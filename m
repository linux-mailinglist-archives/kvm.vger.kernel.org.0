Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B7F6B131B
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 21:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjCHUdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 15:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCHUdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 15:33:41 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C4462305;
        Wed,  8 Mar 2023 12:33:34 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id i9so22919749lfc.6;
        Wed, 08 Mar 2023 12:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678307613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+y5CsNJhs5mJzVRXxGuJt3NYWoHOarEf+TwmHdAF4U=;
        b=ZMmcjUF/dHGD019gl9Tjw0yMIrdP1AaAMhT9h8stAiQ7wo6G0rZSRkn7lGkJNJp+XL
         kEhnmIL0g2yW/07TxPSTGGqLv1Y5VklTcx2P61sF0//K3yYgsa/do+g6htRmp+HMbaTJ
         c8nyBgdAiRvHVgI63SwOvDQm9Z649LCQ114FL5pq2ZP+xpBNm6KjQCemP1N0Z9BJ+PL2
         P0waAs29z2tKxTXusdHuBLMdC/26ZnAmHsECRDrY2oVfI0ge2TE9RYZ5xXY3ojxmRROc
         6lRjHsYUeN/tWGpgg14vtQrZQZNMcXheozRmcxyyZWH36Izx1HfmYZBGFfcXYmBqvIdl
         s0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678307613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N+y5CsNJhs5mJzVRXxGuJt3NYWoHOarEf+TwmHdAF4U=;
        b=LWiaQ4NeLZHncb1dND9WBdyNjiB6JzO6ivXmm/dtNhWs8bT/zAJ81KuVW/Sw7hTviX
         gcSZEs5tssbpyVqFVeCEzQD451nx3xoWPmTa3gJtFyfw3Y04a2yQ89MLy2L8uGrpYbu3
         TxP3qfxpfqQuAe0JpiVVpSXLbN+5ARxQKt5VqW5uZpRQolGV7HPryy9ZL+qg/hbD4Ycv
         hQX2vBSqd6ITtymDJLvUpdIh7dKQPQI+uEN/eJEMZD8HAt2temTeEdvRCaZnrHYs8Ty2
         Nsmf5H9xgigVd8o0ytsv3K8lmgAmIIhh0Ltp0oVAOAGJbFdFBvhc0j2wWe1ik6G3y2Gs
         8eoA==
X-Gm-Message-State: AO0yUKXl3CzCTy+3QZnFBhfrf5pDWWSNZEisULsEZ2NfAsCd/XbkLsJf
        EArSJ0pEqZCBjoY8KVAAEEqJ+VhJklsCAA==
X-Google-Smtp-Source: AK7set+L/mHDfMcGLiv0LCFStH0X6EwgefksdjZrJ/f7/T6gky7cQatc3vSQh7FAXi8TGvn1OGWk/Q==
X-Received: by 2002:ac2:55b0:0:b0:4dd:a025:d87 with SMTP id y16-20020ac255b0000000b004dda0250d87mr4665891lfg.0.1678307612462;
        Wed, 08 Mar 2023 12:33:32 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id r25-20020ac252b9000000b004b5979f9ba8sm2418239lfm.210.2023.03.08.12.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 12:33:32 -0800 (PST)
Date:   Wed, 8 Mar 2023 22:33:31 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com, jmattson@google.com, mizhang@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
Message-ID: <20230308223331.00000234@gmail.com>
In-Reply-To: <20230306224127.1689967-4-vipinsh@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
        <20230306224127.1689967-4-vipinsh@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  6 Mar 2023 14:41:12 -0800
Vipin Sharma <vipinsh@google.com> wrote:

> Create a global counter for total number of pages available
> in MMU page caches across all VMs. Add mmu_shadow_page_cache
> pages to this counter.
> 
> This accounting will be used in future commits to shrink MMU caches via
> KVM MMU shrinker.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 ++
>  arch/x86/kvm/mmu/mmu.c          | 90 ++++++++++++++++++++++++++++-----
>  arch/x86/kvm/mmu/mmu_internal.h |  2 +
>  arch/x86/kvm/mmu/paging_tmpl.h  | 25 +++++----
>  arch/x86/kvm/mmu/tdp_mmu.c      |  3 +-
>  5 files changed, 100 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ebbe692acf3f..4322c7020d5d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -791,6 +791,11 @@ struct kvm_vcpu_arch {
>  	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
>  
> +	/*
> +	 * Protect allocation and release of pages from mmu_shadow_page_cache.
> +	 */
> +	struct mutex mmu_shadow_page_cache_lock;
> +
>  	/*
>  	 * QEMU userspace and the guest each have their own FPU state.
>  	 * In vcpu_run, we switch between the user and guest FPU contexts.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3a452989f5cd..13f41b7ac280 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -167,6 +167,11 @@ struct kvm_shadow_walk_iterator {
>  static struct kmem_cache *pte_list_desc_cache;
>  struct kmem_cache *mmu_page_header_cache;
>  
> +/*
> + * Global count of unused pages in MMU page caches across all VMs.
> + */
> +static struct percpu_counter kvm_total_unused_cached_pages;
> +
>  static void mmu_spte_set(u64 *sptep, u64 spte);
>  
>  struct kvm_mmu_role_regs {
> @@ -667,6 +672,34 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +/**
> + * Caller should hold mutex lock corresponding to cache, if available.
> + */
> +static int mmu_topup_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
> +				     int min)
> +{
> +	int orig_nobjs, r;
> +
> +	orig_nobjs = cache->nobjs;
> +	r = kvm_mmu_topup_memory_cache(cache, min);
> +	if (orig_nobjs != cache->nobjs)
> +		percpu_counter_add(&kvm_total_unused_cached_pages,
> +				   (cache->nobjs - orig_nobjs));
> +
> +	return r;
> +}
> +

Maybe kvm_mmu_topup_shadow_page_cache() would be better?

As a user of kvm_mmu_topup_memory_cache(), mmu_topup_memory_cache() is not
supposed to directly touch the kvm_mmu_memory_cache meta data.

The name "mmu_topup_sp_memory_cache()" seems similar with "mmu_topup_memory_cache()".
Renaming it would make its level self-documenting.

> +/**
> + * Caller should hold mutex lock corresponding to kvm_mmu_memory_cache, if
> + * available.
> + */
> +static void mmu_free_sp_memory_cache(struct kvm_mmu_memory_cache *cache)
> +{
> +	if (cache->nobjs)
> +		percpu_counter_sub(&kvm_total_unused_cached_pages, cache->nobjs);
> +	kvm_mmu_free_memory_cache(cache);
> +}
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>  	int r;
> @@ -676,10 +709,11 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>  	if (r)
>  		return r;
> -	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -				       PT64_ROOT_MAX_LEVEL);
> +
> +	r = mmu_topup_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache, PT64_ROOT_MAX_LEVEL);
>  	if (r)
>  		return r;
> +
>  	if (maybe_indirect) {
>  		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadowed_info_cache,
>  					       PT64_ROOT_MAX_LEVEL);
> @@ -693,7 +727,9 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> -	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +	mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
> +	mmu_free_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +	mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
> @@ -2148,6 +2184,7 @@ struct shadow_page_caches {
>  	struct kvm_mmu_memory_cache *page_header_cache;
>  	struct kvm_mmu_memory_cache *shadow_page_cache;
>  	struct kvm_mmu_memory_cache *shadowed_info_cache;
> +	bool count_shadow_page_allocation;
>  };
>  
>  static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
> @@ -2159,7 +2196,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
>  	struct kvm_mmu_page *sp;
>  
>  	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
> -	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
> +	sp->spt = mmu_sp_memory_cache_alloc(caches->shadow_page_cache,
> +					    caches->count_shadow_page_allocation);
>  	if (!role.direct)
>  		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
>  
> @@ -2216,6 +2254,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
>  		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
>  		.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache,
>  		.shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
> +		.count_shadow_page_allocation = true,
>  	};
>  
>  	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
> @@ -4314,29 +4353,32 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (r != RET_PF_INVALID)
>  		return r;
>  
> +	mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  	r = mmu_topup_memory_caches(vcpu, false);
>  	if (r)
> -		return r;
> +		goto out_page_cache_unlock;
>  
>  	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
>  	if (r != RET_PF_CONTINUE)
> -		return r;
> +		goto out_page_cache_unlock;
>  
>  	r = RET_PF_RETRY;
>  	write_lock(&vcpu->kvm->mmu_lock);
>  
>  	if (is_page_fault_stale(vcpu, fault))
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  
>  	r = direct_map(vcpu, fault);
>  
> -out_unlock:
> +out_mmu_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  	kvm_release_pfn_clean(fault->pfn);
> +out_page_cache_unlock:
> +	mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  	return r;
>  }
>  
> @@ -4396,25 +4438,28 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  	if (r != RET_PF_INVALID)
>  		return r;
>  
> +	mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);

Can you elaborate more why this lock is required? When will this lock contend?

1) Previously mmu_topup_memory_caches() works fine without a lock.
2) IMHO I was suspecting if this lock seems affects the parallelization
of the TDP MMU fault handling. 

TDP MMU fault handling is intend to be optimized for parallelization fault
handling by taking a read lock and operating the page table via atomic
operations. Multiple fault handling can enter the TDP MMU fault path
because of read_lock(&vcpu->kvm->mmu_lock) below.

W/ this lock, it seems the part of benefit of parallelization is gone
because the lock can contend earlier above. Will this cause performance
regression?

If the lock will not contend above, then I am not sure if we need it.

>  	r = mmu_topup_memory_caches(vcpu, false);
>  	if (r)
> -		return r;
> +		goto out_page_cache_unlock;
>  
>  	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
>  	if (r != RET_PF_CONTINUE)
> -		return r;
> +		goto out_page_cache_unlock;
>  
>  	r = RET_PF_RETRY;
>  	read_lock(&vcpu->kvm->mmu_lock);
>  
>  	if (is_page_fault_stale(vcpu, fault))
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  
>  	r = kvm_tdp_mmu_map(vcpu, fault);
>  
> -out_unlock:
> +out_mmu_unlock:
>  	read_unlock(&vcpu->kvm->mmu_lock);
>  	kvm_release_pfn_clean(fault->pfn);
> +out_page_cache_unlock:
> +	mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  	return r;
>  }
>  #endif
> @@ -5394,6 +5439,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  {
>  	int r;
>  
> +	mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
>  	if (r)
>  		goto out;
> @@ -5420,6 +5466,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  	 */
>  	static_call(kvm_x86_flush_tlb_current)(vcpu);
>  out:
> +	mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  	return r;
>  }
>  
> @@ -5924,6 +5971,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>  
>  	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	mutex_init(&vcpu->arch.mmu_shadow_page_cache_lock);
>  
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> @@ -6769,12 +6817,17 @@ int kvm_mmu_vendor_module_init(void)
>  	if (!mmu_page_header_cache)
>  		goto out;
>  
> +	if (percpu_counter_init(&kvm_total_unused_cached_pages, 0, GFP_KERNEL))
> +		goto out;
> +
>  	ret = register_shrinker(&mmu_shrinker, "x86-mmu");
>  	if (ret)
> -		goto out;
> +		goto out_shrinker;
>  
>  	return 0;
>  
> +out_shrinker:
> +	percpu_counter_destroy(&kvm_total_unused_cached_pages);
>  out:
>  	mmu_destroy_caches();
>  	return ret;
> @@ -6792,6 +6845,7 @@ void kvm_mmu_vendor_module_exit(void)
>  {
>  	mmu_destroy_caches();
>  	unregister_shrinker(&mmu_shrinker);
> +	percpu_counter_destroy(&kvm_total_unused_cached_pages);
>  }
>  
>  /*
> @@ -6994,3 +7048,11 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>  	if (kvm->arch.nx_huge_page_recovery_thread)
>  		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
>  }
> +
> +void *mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *shadow_page_cache,
> +				bool count_allocation)
> +{
> +	if (count_allocation && shadow_page_cache->nobjs)
> +		percpu_counter_dec(&kvm_total_unused_cached_pages);
> +	return kvm_mmu_memory_cache_alloc(shadow_page_cache);
> +}
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index cc58631e2336..798cfbf0a36b 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -338,5 +338,7 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  
>  void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void *mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *cache,
> +				bool count_allocation);
>  
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 57f0b75c80f9..1dea9be6849d 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -821,9 +821,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  		return RET_PF_EMULATE;
>  	}
>  
> +	mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  	r = mmu_topup_memory_caches(vcpu, true);
>  	if (r)
> -		return r;
> +		goto out_page_cache_unlock;
>  
>  	vcpu->arch.write_fault_to_shadow_pgtable = false;
>  
> @@ -837,7 +838,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  
>  	r = kvm_faultin_pfn(vcpu, fault, walker.pte_access);
>  	if (r != RET_PF_CONTINUE)
> -		return r;
> +		goto out_page_cache_unlock;
>  
>  	/*
>  	 * Do not change pte_access if the pfn is a mmio page, otherwise
> @@ -862,16 +863,18 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	write_lock(&vcpu->kvm->mmu_lock);
>  
>  	if (is_page_fault_stale(vcpu, fault))
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  	r = FNAME(fetch)(vcpu, fault, &walker);
>  
> -out_unlock:
> +out_mmu_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  	kvm_release_pfn_clean(fault->pfn);
> +out_page_cache_unlock:
> +	mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  	return r;
>  }
>  
> @@ -897,17 +900,18 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>  
>  	vcpu_clear_mmio_info(vcpu, gva);
>  
> +	if (!VALID_PAGE(root_hpa)) {
> +		WARN_ON(1);
> +		return;
> +	}
> +
> +	mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  	/*
>  	 * No need to check return value here, rmap_can_add() can
>  	 * help us to skip pte prefetch later.
>  	 */
>  	mmu_topup_memory_caches(vcpu, true);
>  
> -	if (!VALID_PAGE(root_hpa)) {
> -		WARN_ON(1);
> -		return;
> -	}
> -
>  	write_lock(&vcpu->kvm->mmu_lock);
>  	for_each_shadow_entry_using_root(vcpu, root_hpa, gva, iterator) {
>  		level = iterator.level;
> @@ -943,6 +947,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>  			break;
>  	}
>  	write_unlock(&vcpu->kvm->mmu_lock);
> +	mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
>  }
>  
>  /* Note, @addr is a GPA when gva_to_gpa() translates an L2 GPA to an L1 GPA. */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7c25dbf32ecc..fa6eb1e9101e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -265,7 +265,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
>  	struct kvm_mmu_page *sp;
>  
>  	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	sp->spt = mmu_sp_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache,
> +					    true);
>  
>  	return sp;
>  }

