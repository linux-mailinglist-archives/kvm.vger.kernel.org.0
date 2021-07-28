Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BD83D9561
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 20:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhG1Shq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 14:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhG1Shp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 14:37:45 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A8DC0613C1
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 11:37:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i10so3784814pla.3
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 11:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wW0lGlO2h9W3l+Di2eQ8wNpleBt3TTs9VoxXJP2bqhY=;
        b=SaEiXGhzkxEn1MWQT/R4Zq7ytFXEcYz3MXd3lp5qrtdccjSpDoTzlGuaXUTNa9yRv9
         KzOSBYJOcpuNK3lhtcFCosgceBCDchPrcadfpybLXOpPcUgZFwy4jCpeClnxOUHeHOLW
         nRLb/WkZIVIaOL/cOsRlVUvO1fd0XPwA8F1CT6elPr3fz8QBGoRGH0vr2czbFP5kBzYT
         G9Q5LtiOyXkngqKaHhuUVBXpy4T4wSM6a4y4s8bbX1rraoFnYNaFQIPKpp5lM9ye/frP
         +H50hWucuHricEkKA2OcuXgwidDmQCSUK6vQW2FK5Ww+WoLOPuABTobg0+WIYBm+HgH4
         v6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wW0lGlO2h9W3l+Di2eQ8wNpleBt3TTs9VoxXJP2bqhY=;
        b=F9/+XFPRkZYwBATvTwmnh5x/g0vaYDHD7OjYYi7mQiadGDNtoTS/qTdhJ/5Cx2ZN5l
         WJPAKyde4yKUlchGPbMvrUmVLNBaa2XFckfGzAWGHbYGwbuBmRy5yO0uBL6TMWO8RL/F
         TypCIqRLhkmLhjGHgAnXJcBAepv3TAGjxDmhup+S7Tea2Aan+5r/HWsHxDVHJvjoCzBj
         rSzthIEFj6odeee9DPboRyGILGh2rO+cLWgINkxjcaPuhBQKTlCIzgusLmi7CyXv9L7I
         WQHgz7ADLppgaD5xZWBZSaEzSpRXLWi5535aZ8RBxaEQwhVfyPEXIuITn+saGGuvab89
         nEqg==
X-Gm-Message-State: AOAM531UWltboyVPU7xfTSYf5wB016K3ZWetF9EoQgCwrSVTqZSyiIFU
        gUja/kd0FQrhypwNyQ/mt7cTrA==
X-Google-Smtp-Source: ABdhPJyy3dDQk885MGzn7M+KECtE4gK+0BQ0MwF53res5Ld9E6AQOdOK7Or/i8NmeZV+/HMHp6Ayqg==
X-Received: by 2002:a17:90a:ccc:: with SMTP id 12mr1081627pjt.57.1627497462769;
        Wed, 28 Jul 2021 11:37:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s18sm422579pjn.54.2021.07.28.11.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 11:37:42 -0700 (PDT)
Date:   Wed, 28 Jul 2021 18:37:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: A question of TDP unloading.
Message-ID: <YQGj8gj7fpWDdLg5@google.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021, Yu Zhang wrote:
> Thanks a lot for your reply, Sean.
> 
> On Tue, Jul 27, 2021 at 06:07:35PM +0000, Sean Christopherson wrote:
> > On Wed, Jul 28, 2021, Yu Zhang wrote:
> > > Hi all,
> > > 
> > >   I'd like to ask a question about kvm_reset_context(): is there any
> > >   reason that we must alway unload TDP root in kvm_mmu_reset_context()?
> > 
> > The short answer is that mmu_role is changing, thus a new root shadow page is
> > needed.
> 
> I saw the mmu_role is recalculated, but I have not figured out how this
> change would affect TDP. May I ask a favor to give an example? Thanks!
> 
> I realized that if we only recalculate the mmu role, but do not unload
> the TDP root(e.g., when guest efer.nx flips), base role of the SPs will
> be inconsistent with the mmu context. But I do not understand why this
> shall affect TDP. 

The SPTEs themselves are not affected if the base mmu_role doesn't change; note,
this holds true for shadow paging, too.  What changes is all of the kvm_mmu
knowledge about how to walk the guest PTEs, e.g. if a guest toggles CR4.SMAP,
then KVM needs to recalculate the #PF permissions for guest accesses so that
emulating instructions at CPL=0 does the right thing.

As for EFER.NX and CR0.WP, they are in the base page role because they need to
be there for shadow paging, e.g. if the guest toggles EFER.NX, then the reserved
bit and executable permissions change, and reusing shadow paging for the old
EFER.NX could result in missed reserved #PF and/or incorrect executable #PF
behavior.

For simplicitly, it's far, far eaiser to reuse the same page role struct for
TDP paging (both legacy and TDP MMUs) and shadow paging.

However, I think we can safely ignore NX, WP, SMEP, and SMAP in direct shadow
pages, which would allow reusing a TDP root across changes.  This is only a baby
step (assuming it even works), as further changes to set_cr0/cr4/efer would be
needed to fully realize the optimizations, e.g. to avoid complete teardown if
the root_count hits zero.

I'll put this on my todo list, I've been looking for an excuse to update the
cr0/cr4/efer flows anyways :-).  If it works, the changes should be relatively
minor, if it works...

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8cdfd8d45c4..700664fe163e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2077,8 +2077,20 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
        role = vcpu->arch.mmu->mmu_role.base;
        role.level = level;
        role.direct = direct;
-       if (role.direct)
+       if (role.direct) {
                role.gpte_is_8_bytes = true;
+
+               /*
+                * Guest PTE permissions do not impact SPTE permissions for
+                * direct MMUs.  Either there are no guest PTEs (CR0.PG=0) or
+                * guest PTE permissions are enforced by the CPU (TDP enabled).
+                */
+               WARN_ON_ONCE(access != ACC_ALL);
+               role.efer_nx = 0;
+               role.cr0_wp = 0;
+               role.smep_andnot_wp = 0;
+               role.smap_andnot_wp = 0;
+       }
        role.access = access;
        if (!direct_mmu && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
                quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
