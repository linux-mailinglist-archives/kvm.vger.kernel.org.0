Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499B578FD1A
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 14:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344287AbjIAMYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 08:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243081AbjIAMYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 08:24:36 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45D52D7;
        Fri,  1 Sep 2023 05:24:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 5DBA1809C;
        Fri,  1 Sep 2023 12:24:32 +0000 (UTC)
Date:   Fri, 1 Sep 2023 15:24:31 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Haber <mh+linux-kernel@zugschlus.de>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <20230901122431.GU11676@atomide.com>
References: <ZO2RlYCDl8kmNHnN@torres.zugschlus.de>
 <ZO2piz5n1MiKR-3-@debian.me>
 <ZO3sA2GuDbEuQoyj@torres.zugschlus.de>
 <ZO4GeazfcA09SfKw@google.com>
 <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
 <ZO4RzCr/Ugwi70bZ@google.com>
 <ZO4YJlhHYjM7MsK4@torres.zugschlus.de>
 <ZO4nbzkd4tovKpxx@google.com>
 <ZO5OeoKA7TbAnrI1@torres.zugschlus.de>
 <ZPEPFJ8QvubbD3H9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZPEPFJ8QvubbD3H9@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Sean Christopherson <seanjc@google.com> [230831 22:07]:
> On Tue, Aug 29, 2023, Marc Haber wrote:
> > Hi,
> > 
> > On Tue, Aug 29, 2023 at 10:14:23AM -0700, Sean Christopherson wrote:
> > > On Tue, Aug 29, 2023, Marc Haber wrote:
> > > > Both come from virt-manager, so if the XML helps more, I'll happy to
> > > > post that as well.
> > > 
> > > Those command lines are quite different, e.g. the Intel one has two
> > > serial ports versus one for the AMD VM.
> > 
> > Indeed? I virt-manager, I don't see a second serial port. In either case,
> > only the one showing up in the VM as ttyS0 is being used. But thanks for
> > making me look, I discovered that the machine on the Intel host still
> > used emulated SCSI instead of VirtIO für the main disk. I changed that.
> > 
> > >Unless Tony jumps in with an
> > > idea, I would try massaging either the good or bad VM's QEMU
> > > invocation, e.g. see if you can get the AMD VM to "pass" by pulling in
> > > stuff from the Intel VM, or get the Intel VM to fail by making its
> > > command line look more like the AMD VM.
> > 
> > In Virt-Manager, both machines don't look THAT different tbh. I verified
> > the XML and the differences are not big at all.
> > 
> > Do you want me to try different vCPU types? Currently the VM is set to
> > "Opteron_G3", would you recommend a different vCPU for the host having a
> > "AMD GX-412TC SOC" host CPU?
> 
> I would be surprised if using a different vCPU type fixed anything, but it's not
> impossible that it could help.  In general, unless someone from the serial driver
> side spots an issue, fixing whatever the bug is will likely require a reproducer,
> which in turn likely means narrowing down what exactly is unique about your AMD
> setup.  In other words, if you have cycles to spare, anything you can do to help
> isolate the problem would be appreciated.

Yes two somewhat minimal qemu command lines for working and failing test
case sure would help to debug this.

Regards,

Tony
