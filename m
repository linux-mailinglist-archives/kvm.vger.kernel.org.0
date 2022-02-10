Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909CD4B1487
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 18:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbiBJRsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 12:48:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245319AbiBJRsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 12:48:20 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71D1210EA
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:48:21 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CEE9D6E;
        Thu, 10 Feb 2022 09:48:21 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB0473F70D;
        Thu, 10 Feb 2022 09:48:19 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:48:35 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgVP8zy6N4fL66Wk@monolith.localdoman>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgVPPCTJG7UFRkhQ@monolith.localdoman>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Feb 10, 2022 at 05:45:47PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > configuring the tests. If the rename is not acceptable, I can think of a
> > > few other options:
> > 
> > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > seems like it would be sufficient.

I missed this bit in my earlier reply, I like --efi better. I would also like to
hear the opinion of the people who added EFI support before reworking the patch.

> > 
> > > 1. Rename --target to --vmm. That was actually the original name for the
> > > option, but I changed it because I thought --target was more generic and
> > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > to run as an EFI payload. I realize now that separating the VMM from
> > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > a test runner, so I think the impact on users should be minimal.
> > 
> > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > compiler, usurping that for something similar but slightly different is odd.
> 
> Wouldn't that mean that --target-efi is equally confusing? Do you have
> suggestions for other names?

Thanks,
Alex
