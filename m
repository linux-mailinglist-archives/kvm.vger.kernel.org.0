Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E83C4B9FE8
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 13:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240318AbiBQMOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 07:14:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239609AbiBQMOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 07:14:45 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2A40D21F7
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 04:14:30 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACD50113E;
        Thu, 17 Feb 2022 04:14:30 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD1BD3F66F;
        Thu, 17 Feb 2022 04:14:28 -0800 (PST)
Date:   Thu, 17 Feb 2022 12:14:47 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Huth <thuth@redhat.com>, Zixuan Wang <zxwang42@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <Yg48KawN1+u+sL53@monolith.localdoman>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
 <YgVpJDIfUVzVvFdx@google.com>
 <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
 <f326daff-8384-4666-fc5e-6b7b509f6fe8@redhat.com>
 <YgaMqwbWts3vQ6fD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgaMqwbWts3vQ6fD@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Feb 11, 2022 at 04:19:55PM +0000, Sean Christopherson wrote:
> On Fri, Feb 11, 2022, Thomas Huth wrote:
> > On 10/02/2022 20.48, Zixuan Wang wrote:
> > > On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > 
> > > > On Thu, Feb 10, 2022, Zixuan Wang wrote:
> > > > > On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> > > > > <alexandru.elisei@arm.com> wrote:
> > > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > > > > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > > > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > > > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > > > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > > > > > few other options:
> > > > > > > 
> > > > > > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > > > > > seems like it would be sufficient.
> > > > > > > 
> > > > > > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > > > > > option, but I changed it because I thought --target was more generic and
> > > > > > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > > > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > > > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > > > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > > > > > a test runner, so I think the impact on users should be minimal.
> > > > > > > 
> > > > > > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > > > > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > > > > > compiler, usurping that for something similar but slightly different is odd.
> > > > > > 
> > > > > > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > > > > > suggestions for other names?
> > > > > 
> > > > > How about --config-efi for configure, and CONFIG_EFI for source code?
> > > > > I thought about this name when I was developing the initial patch, and
> > > > > Varad also proposed similar names in his initial patch series [1]:
> > > > > --efi and CONFIG_EFI.
> > > > 
> > > > I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
> > > > configure option and is familiar for kernel developers.  But for the actually
> > > > option, why require more typing?  I really don't see any benefit of --config-efi
> > > > over --efi.
> > > 
> > > I agree, --efi looks better than --target-efi or --config-efi.
> > 
> > <bikeshedding>
> > Or maybe --enable-efi ... since configure scripts normally take
> > "--enable-..." or "--disable-..." parameters for stuff like this?
> > </bikeshedding>
> 
> I don't hate it :-)  It'll also future-proof things if we ever make UEFI the
> default for x86.

Thank you all for the feedback.

I'll respin the series and rename --target-efi to --enable-efi.

Thanks,
Alex
