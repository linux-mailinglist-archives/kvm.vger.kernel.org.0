Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2666C67ADAF
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 10:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbjAYJYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 04:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjAYJYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 04:24:45 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126F045F4C;
        Wed, 25 Jan 2023 01:24:44 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id n7so16360294wrx.5;
        Wed, 25 Jan 2023 01:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z0Arz+pfAQe2myKejng9WE2IrSZFUhfsk2WraOwJVT8=;
        b=Bi3qWzqeMh80NryBIAF5Dhr6ASV1XIfGkldULP1u8WVVtFfkMD7sLb7qlR4JvlPLXk
         O8CK3lYtRC1ghQgbr/EEHPEM300ot/WvDkj1+sjnCeQz/DRtPs7SIZgmyYklsUr4XiP4
         erTeIYuE9z9XwqHzyaqcVE+5My6NZK5m+VgI+WUeSll5XsKOHSpn5uJG8nz/hkWiLzMO
         Ill5FvXYPQqD0U8RbWmuHvxsiU+2M5YHj1cSI6M4OlHFvpm/9vegT7D7pN/2bh9L76b6
         AptexREEtZs5VOCUdADhVMQFeT4QArwBR/qlZaJI913iz2V1YQBSGT3ZWIohFHuQMz5j
         Jfmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z0Arz+pfAQe2myKejng9WE2IrSZFUhfsk2WraOwJVT8=;
        b=QKz77NsKej8VNj9ab8VHtA/tKPcICv3aSJ+nWJ3OFUfL4x+B9zwJyv3ryH8riyg8Aj
         k7aeo9p3W6HXaJhS3NhgcImr/qbg3isb1957VoHFCcM2Yzq1TuW+7Sr+ChnyExQXNmQK
         l4rskRwM5rWB0wToYC4M6vECiI65bpw0t5kFV2RplWgs7qSEgFhRTpyqy0eAfQwG2xZl
         ckis9P5iaTvoNkppXmek6mkDKu021xt/ci6ZpwlEuWStvZ9H2zmP5dlGL4f5T/cQIPvN
         OwLKvaDDIpkizVCVAOsvGMoy5cUPZSljTNDvu9O4eB4vKTcHuTuhvfluorozy7Svtdql
         tK9w==
X-Gm-Message-State: AFqh2kpqx5+yAi7/l2kOf3Iqm9I3A1Xepji5fYOcsxA3GGry9O9/L5oO
        Wk3wqO4auYwtx53eOx1jDe0=
X-Google-Smtp-Source: AMrXdXvCVpzdYmkvwD+InHMlUvlzHqd2a6n6HQAKP5NRmt2gyTAvFEqJRs1wOF0A6rEje9NtNEytnA==
X-Received: by 2002:a05:6000:1e0d:b0:236:c60b:c766 with SMTP id bj13-20020a0560001e0d00b00236c60bc766mr4918321wrb.6.1674638682404;
        Wed, 25 Jan 2023 01:24:42 -0800 (PST)
Received: from localhost (95-172-185-203.cpe.netmadeira.com. [95.172.185.203])
        by smtp.gmail.com with ESMTPSA id p15-20020a5d4e0f000000b002bdc39849d1sm3886630wrt.44.2023.01.25.01.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 01:24:42 -0800 (PST)
Date:   Wed, 25 Jan 2023 11:24:34 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v11 030/113] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Message-ID: <20230125112434.0000512a@gmail.com>
In-Reply-To: <dee30f0562d8be0102547d8eb9fc77736eae679d.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <dee30f0562d8be0102547d8eb9fc77736eae679d.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 08:31:38 -0800
isaku.yamahata@intel.com wrote:

This refactor patch is quite hacky.

Why not change the purpose of vcpu->arch.mmu_shadow_page.gfp_zero and let the
callers respect that the initial value of spte can be configurable? It will be
generic and not TDX-specific, then kvm_init_shadow_page() is not required,
mmu_topup_shadow_page_cache() can be left un-touched as the refactor can cover
other architectures.

1) Let it store the expected nonpresent value and rename it to nonpresent_spte.

2) Let mmu_spte_clear_track_bits(), mmu_spte_clear_no_track() and all
the other places where assume 0 as initial value, respect nonpreset_spte.

3) Let kvm_mmu_topup_memory_cache() to respect nonpresent_spte: a. using GFP_ZERO
if the nonpresent_spte is zero. b. memset the page if nonpresent_spte is *not*
zero.

Now the initial value is configurable, configure the nonpresent_spte in the TDX
initialization path before the first topup in the next patch.

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> The TDX support will need the "suppress #VE" bit (bit 63) set as the
> initial value for SPTE.  To reduce code change size, introduce a new macro
> SHADOW_NONPRESENT_VALUE for the initial value for the shadow page table
> entry (SPTE) and replace hard-coded value 0 for it.  Initialize shadow page
> tables with their value.
> 
> The plan is to unconditionally set the "suppress #VE" bit for both AMD and
> Intel as: 1) AMD hardware uses the bit 63 as NX for present SPTE and
> ignored for non-present SPTE; 2) for conventional VMX guests, KVM never
> enables the "EPT-violation #VE" in VMCS control and "suppress #VE" bit is
> ignored by hardware.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 50 ++++++++++++++++++++++++++++++----
>  arch/x86/kvm/mmu/paging_tmpl.h |  3 +-
>  arch/x86/kvm/mmu/spte.h        |  2 ++
>  arch/x86/kvm/mmu/tdp_mmu.c     | 15 +++++-----
>  4 files changed, 56 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 15d0e8f11d53..59befdfeec23 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -540,9 +540,9 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>  
>  	if (!is_shadow_present_pte(old_spte) ||
>  	    !spte_has_volatile_bits(old_spte))
> -		__update_clear_spte_fast(sptep, 0ull);
> +		__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
>  	else
> -		old_spte = __update_clear_spte_slow(sptep, 0ull);
> +		old_spte = __update_clear_spte_slow(sptep, SHADOW_NONPRESENT_VALUE);
>  
>  	if (!is_shadow_present_pte(old_spte))
>  		return old_spte;
> @@ -576,7 +576,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>   */
>  static void mmu_spte_clear_no_track(u64 *sptep)
>  {
> -	__update_clear_spte_fast(sptep, 0ull);
> +	__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
>  }
>  
>  static u64 mmu_spte_get_lockless(u64 *sptep)
> @@ -644,6 +644,39 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +#ifdef CONFIG_X86_64
> +static inline void kvm_init_shadow_page(void *page)
> +{
> +	memset64(page, SHADOW_NONPRESENT_VALUE, 4096 / 8);
> +}
> +
> +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
> +	int start, end, i, r;
> +
> +	start = kvm_mmu_memory_cache_nr_free_objects(mc);
> +	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
> +
> +	/*
> +	 * Note, topup may have allocated objects even if it failed to allocate
> +	 * the minimum number of objects required to make forward progress _at
> +	 * this time_.  Initialize newly allocated objects even on failure, as
> +	 * userspace can free memory and rerun the vCPU in response to -ENOMEM.
> +	 */
> +	end = kvm_mmu_memory_cache_nr_free_objects(mc);
> +	for (i = start; i < end; i++)
> +		kvm_init_shadow_page(mc->objects[i]);
> +	return r;
> +}
> +#else
> +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> +					  PT64_ROOT_MAX_LEVEL);
> +}
> +#endif /* CONFIG_X86_64 */
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>  	int r;
> @@ -653,8 +686,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>  	if (r)
>  		return r;
> -	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -				       PT64_ROOT_MAX_LEVEL);
> +	r = mmu_topup_shadow_page_cache(vcpu);
>  	if (r)
>  		return r;
>  	if (maybe_indirect) {
> @@ -5920,7 +5952,13 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>  	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>  
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	/*
> +	 * When X86_64, initial SEPT entries are initialized with
> +	 * SHADOW_NONPRESENT_VALUE.  Otherwise zeroed.  See
> +	 * mmu_topup_shadow_page_cache().
> +	 */
> +	if (!IS_ENABLED(CONFIG_X86_64))
> +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>  
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 0f6455072055..42d7106c7350 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1036,7 +1036,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		gpa_t pte_gpa;
>  		gfn_t gfn;
>  
> -		if (!sp->spt[i])
> +		/* spt[i] has initial value of shadow page table allocation */
> +		if (sp->spt[i] == SHADOW_NONPRESENT_VALUE)
>  			continue;
>  
>  		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 0d8deefee66c..f190eaf6b2b5 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -148,6 +148,8 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
>  
>  #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
>  
> +#define SHADOW_NONPRESENT_VALUE	0ULL
> +
>  extern u64 __read_mostly shadow_host_writable_mask;
>  extern u64 __read_mostly shadow_mmu_writable_mask;
>  extern u64 __read_mostly shadow_nx_mask;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 12e430a4ebc3..9cf5844dd34a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -701,7 +701,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 * here since the SPTE is going from non-present to non-present.  Use
>  	 * the raw write helper to avoid an unnecessary check on volatile bits.
>  	 */
> -	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
> +	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
>  
>  	return 0;
>  }
> @@ -878,8 +878,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  			continue;
>  
>  		if (!shared)
> -			tdp_mmu_set_spte(kvm, &iter, 0);
> -		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
> +			tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> +		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
>  			goto retry;
>  	}
>  }
> @@ -935,8 +935,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
>  		return false;
>  
> -	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> -			   sp->gfn, sp->role.level + 1, true, true);
> +	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> +			   SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1,
> +			   true, true);
>  
>  	return true;
>  }
> @@ -970,7 +971,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>  
> -		tdp_mmu_set_spte(kvm, &iter, 0);
> +		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
>  		flush = true;
>  	}
>  
> @@ -1339,7 +1340,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>  	 * invariant that the PFN of a present * leaf SPTE can never change.
>  	 * See __handle_changed_spte().
>  	 */
> -	tdp_mmu_set_spte(kvm, iter, 0);
> +	tdp_mmu_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
>  
>  	if (!pte_write(range->pte)) {
>  		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,

