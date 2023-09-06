Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E677794033
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 17:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242491AbjIFPVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 11:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjIFPVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 11:21:14 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 631E41717;
        Wed,  6 Sep 2023 08:21:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 783DC8050;
        Wed,  6 Sep 2023 15:21:08 +0000 (UTC)
Date:   Wed, 6 Sep 2023 18:21:07 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Marc Haber <mh+linux-kernel@zugschlus.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <20230906152107.GD11676@atomide.com>
References: <ZO3sA2GuDbEuQoyj@torres.zugschlus.de>
 <ZO4GeazfcA09SfKw@google.com>
 <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
 <ZO4RzCr/Ugwi70bZ@google.com>
 <ZO4YJlhHYjM7MsK4@torres.zugschlus.de>
 <ZO4nbzkd4tovKpxx@google.com>
 <ZO5OeoKA7TbAnrI1@torres.zugschlus.de>
 <ZPEPFJ8QvubbD3H9@google.com>
 <20230901122431.GU11676@atomide.com>
 <ZPiPkSY6NRzfWV5Z@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPiPkSY6NRzfWV5Z@torres.zugschlus.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Marc Haber <mh+linux-kernel@zugschlus.de> [230906 14:41]:
> If I cannot see the host boot, I cannot debug, and if I cannot type into
> grub, I cannot find out whether removing the serial console from the
> kernel command line fixes the issue. I have removed the network
> interface to simplify things, so I need a working console.

I use something like this for a serial console:

-serial stdio -append "console=ttyS0 other kernel command line options"

Regards,

Tony
