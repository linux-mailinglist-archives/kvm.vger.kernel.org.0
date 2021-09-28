Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBA541BAED
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 01:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243214AbhI1XW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 19:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhI1XW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 19:22:27 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4C1C06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 16:20:47 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w14so354332pfu.2
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 16:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UGqfj0Lu1yqe3ICg5RET+tLswWsdfuZHNoCTUNF/Uzs=;
        b=ktTYgxEt+/Ampbz8uSBrRMPIAz/idvs23twHZPW49NiFLYNx0UrJMlpO/qSoV1Bomk
         YUWDBgxRXfTYt7mqIz3yM9k71Qvwk4LZ93E1desyrK5VVDybtiUv7ubdJ28LEP39esq2
         uuU+6ErIQAyonGVV+s3AGb+o+NsKYw4ovGye57m5ERw++PUxSv8C4TsCL3OI25AWuUOE
         7Z8i+9ip2VS5JhpqoDKTXp2iRr8YB30Wu9BIkMy+IJRHdMzGHsVaU5A7AuZZSycPBXwG
         7sYcqsMqaIJ6N2Lj6sNFSQbrsOFxC4yNvRAnFOYjalbNGjadVQZsO68TeLq3cAJuUHZx
         qA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UGqfj0Lu1yqe3ICg5RET+tLswWsdfuZHNoCTUNF/Uzs=;
        b=3H7oHQIsZ9sIurb02K+0ExXafTvBXUzy9GbBAdrdni1FbwL9FZ6V+rQ0wJs9tquivF
         kcYW3fE1Eh6/rVc8N5UsQv7sY1yPP5Lqx+rLKrrdC1lmFmXlfVMTohks2S30e8PhFFk7
         g2Ntman7LM0Nq/PL1LunkwIuWAadjzIOqsm5njMKkqkoEV+Aqbpw71uzR28uWV1ZmAc7
         Au5+aVMJOYRuwmFMO/r7Tmv5EKii76+dOumXTNQJJ8YhA7jSm5iq+D/GHMR3VYnhhcM8
         ZNj0+oO/lGF8J0UfmsfZwR9XCVhRrIlKK+y0PaPOHyLp1ujfl9R5yS55ubuF7u2hFSsA
         YKQQ==
X-Gm-Message-State: AOAM533BA0w0R+WUQ5kz6cCYg5aMCHLsI0qbAedI3Lx9gjnwxWwjtcc4
        YnqbXGoPJgDSfrGLdI3aKWxH9w==
X-Google-Smtp-Source: ABdhPJwTa/py5geL3XY+CzwyaLKtYNqkjvb1RpNaBnglEbbxxOrFPI04Wm0x7FME079K+YbBCuZQ0Q==
X-Received: by 2002:a63:a65:: with SMTP id z37mr7028095pgk.192.1632871246302;
        Tue, 28 Sep 2021 16:20:46 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z17sm190349pfj.185.2021.09.28.16.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 16:20:45 -0700 (PDT)
Date:   Tue, 28 Sep 2021 23:20:41 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Subject: Re: [PATCH v3 31/31] KVM: MMU: make spte an in-out argument in
 make_spte
Message-ID: <YVOjSSahzJ/tf28g@google.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
 <20210924163152.289027-32-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924163152.289027-32-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 12:31:52PM -0400, Paolo Bonzini wrote:
> Pass the old SPTE in the same variable that receives the new SPTE.  This
> reduces the number of arguments from 11 to 10.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 18 ++++++++----------
>  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>  arch/x86/kvm/mmu/spte.c        |  7 ++++---
>  arch/x86/kvm/mmu/spte.h        |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c     |  9 +++++----
>  5 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 91292009780a..b363433bcd2c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2682,8 +2682,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>  	int was_rmapped = 0;
>  	int ret = RET_PF_FIXED;
>  	bool flush = false;
> +	u64 spte = *sptep;
>  	bool wrprot;
> -	u64 spte;
>  
>  	/* Prefetching always gets a writable pfn.  */
>  	bool host_writable = !fault || fault->map_writable;
> @@ -2691,35 +2691,33 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>  	bool write_fault = fault && fault->write;
>  
>  	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
> -		 *sptep, write_fault, gfn);
> +		 spte, write_fault, gfn);
>  
>  	if (unlikely(is_noslot_pfn(pfn))) {
>  		mark_mmio_spte(vcpu, sptep, gfn, pte_access);
>  		return RET_PF_EMULATE;
>  	}
>  
> -	if (is_shadow_present_pte(*sptep)) {
> +	if (is_shadow_present_pte(spte)) {
>  		/*
>  		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
>  		 * the parent of the now unreachable PTE.
>  		 */
> -		if (level > PG_LEVEL_4K && !is_large_pte(*sptep)) {
> +		if (level > PG_LEVEL_4K && !is_large_pte(spte)) {
>  			struct kvm_mmu_page *child;
> -			u64 pte = *sptep;
> -
> -			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
> +			child = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
>  			drop_parent_pte(child, sptep);
>  			flush = true;
> -		} else if (pfn != spte_to_pfn(*sptep)) {
> +		} else if (pfn != spte_to_pfn(spte)) {
>  			pgprintk("hfn old %llx new %llx\n",
> -				 spte_to_pfn(*sptep), pfn);
> +				 spte_to_pfn(spte), pfn);
>  			drop_spte(vcpu->kvm, sptep);
>  			flush = true;
>  		} else
>  			was_rmapped = 1;
>  	}
>  
> -	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, speculative,
> +	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, speculative,
>  			   true, host_writable, &spte);
>  
>  	if (*sptep == spte) {
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index d8889e02c4b7..88551cfd06c6 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1130,7 +1130,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		host_writable = spte & shadow_host_writable_mask;
>  		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  		make_spte(vcpu, sp, slot, pte_access, gfn,
> -			  spte_to_pfn(spte), spte, true, false,
> +			  spte_to_pfn(spte), true, false,
>  			  host_writable, &spte);
>  
>  		flush |= mmu_spte_update(sptep, spte);
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 871f6114b0fa..91525388032e 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -92,10 +92,11 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
>  bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       struct kvm_memory_slot *slot,
>  	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
> -	       u64 old_spte, bool speculative, bool can_unsync,
> -	       bool host_writable, u64 *new_spte)
> +	       bool speculative, bool can_unsync,
> +	       bool host_writable, u64 *sptep)

I'd prefer a different name since `sptep` has specific meaning
throughout the mmu code. (It's the address of the spte in the page
table.)

Case in point, I was going to suggest we can get rid of struct
kvm_mmu_page since it can be derived from the sptep and then realized
how wrong that was :).

Instead of receiving the new spte as a parameter what do you think about
changing make_spte to return the new spte? I think that would make the
code more readable (but won't reduce the number of arguments because
you'd have to add wrprot).

>  {
>  	int level = sp->role.level;
> +	u64 old_spte = *sptep;
>  	u64 spte = SPTE_MMU_PRESENT_MASK;
>  	bool wrprot = false;
>  
> @@ -187,7 +188,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
>  	}
>  
> -	*new_spte = spte;
> +	*sptep = spte;
>  	return wrprot;
>  }
>  
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 7c0b09461349..231531c6015a 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -337,7 +337,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
>  bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       struct kvm_memory_slot *slot,
>  	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
> -	       u64 old_spte, bool speculative, bool can_unsync,
> +	       bool speculative, bool can_unsync,
>  	       bool host_writable, u64 *new_spte);
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
>  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 953f24ded6bc..29b739c7bba4 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -903,13 +903,14 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  	bool wrprot = false;
>  
>  	WARN_ON(sp->role.level != fault->goal_level);
> -	if (unlikely(!fault->slot))
> +	if (unlikely(!fault->slot)) {
>  		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
> -	else
> +	} else {
> +		new_spte = iter->old_spte;
>  		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
> -					 fault->pfn, iter->old_spte, fault->prefault, true,
> +					 fault->pfn, fault->prefault, true,
>  					 fault->map_writable, &new_spte);
> -
> +	}
>  	if (new_spte == iter->old_spte)
>  		ret = RET_PF_SPURIOUS;
>  	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> -- 
> 2.27.0
> 
