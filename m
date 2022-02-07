Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D37F4ACD02
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbiBHBFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245410AbiBGXAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 18:00:47 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E639BC0612A4
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 15:00:46 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id g8so5741818pfq.9
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 15:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4ssq4yNo39SDas6BkL3oT8hb7H7gYR4kWKE8uNUgLE4=;
        b=aIYxgg61HPWoxIUwjIKs0S5jNPjG1J4R47Q4ppiPWrfD/NoOpJuf8R2tVizBaJllJ6
         nwpr9CnMW0ZQ7PgmNDMpy3BKO1xECJibComaSEhc2QnZ9iyDGC7X4JEQ1U/nMGS7qxUk
         qmgQWwprlFAgX6SzqI6s3OA/JglXYNKEuIqUnUbQUNValgoAPzbvstUJOn5oWr+PcGmt
         XydZFJJWRaqWlyNp2uko+KsAyJPjAt9jByjAHrUL28hVgUamOYw40gZBJhus5lA0/HJb
         wFGopc/rowmDxmJXQS039g1PFABK5QquUfEXiTuYabrMFruGQTcPQOYxuDVGBkblWxbU
         bL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ssq4yNo39SDas6BkL3oT8hb7H7gYR4kWKE8uNUgLE4=;
        b=aU1oQ5h1FiUMQAaHydVb789iopULAP0Iy57Yn2W5N3wp9hFAl4wQhfF6CDkDS2AVHr
         nXKQQ4Gl9qZiv+1RLj9Xnv4kgx4m8dGUPE8XaFEtMIbX8Y+mvLUWdkefBf007j933sWQ
         uq0ooHtIt0RkPGbkQHER/7S5kTFvk9SooHVnV2w7zLrcFSq0JSzM86v7/k+37MCP09MP
         FwzPW3Fct1H2OlDIwusqcRLOCOzT9eoh89/KaOL+QxnlaaL4LCjmr7jQKj+PfSzAIgND
         BygsbZExXlfN26jZukobg64viBChDE+O4A56HM57kOwMAyt2cKwaYBvd4SKMY23j/dgh
         z+4A==
X-Gm-Message-State: AOAM530th36HSgfircvNyM9/k1gahVHe2CLYdaNsEC7yOjPbtX6zdp/o
        jEW5YQwvmgZ9qqNptN2ipb385Q==
X-Google-Smtp-Source: ABdhPJxDt2Bx0sSctwiwvIZpSWaYgpGzNcVgYODKJKciJnR8lRL/MJMXOlJI4y2JlDQZWj1uTHFnKw==
X-Received: by 2002:a63:2543:: with SMTP id l64mr871382pgl.302.1644274845958;
        Mon, 07 Feb 2022 15:00:45 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id u2sm13678446pfk.15.2022.02.07.15.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 15:00:45 -0800 (PST)
Date:   Mon, 7 Feb 2022 23:00:41 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 21/23] KVM: MMU: store shadow_root_level into mmu_role
Message-ID: <YgGkmWg7MfEIkjxf@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-22-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-22-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:57:16AM -0500, Paolo Bonzini wrote:
> mmu_role.level is always the same value as shadow_level:
> 
> - kvm_mmu_get_tdp_level(vcpu) when going through init_kvm_tdp_mmu
> 
> - the level argument when going through kvm_init_shadow_ept_mmu
> 
> - it's assigned directly from new_role.base.level when going
>   through shadow_mmu_init_context
> 
> Remove the duplication and get the level directly from the role.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

nit: How about the following for the shortlog?

KVM: MMU: Replace shadow_root_level with mmu_role.level

Otherwise,

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 36 +++++++++++++++------------------
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>  arch/x86/kvm/svm/svm.c          |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  2 +-
>  6 files changed, 20 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b0085c54786c..867fc82f1de5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -433,7 +433,6 @@ struct kvm_mmu {
>  	union kvm_mmu_role cpu_role;
>  	union kvm_mmu_page_role mmu_role;
>  	u8 root_level;
> -	u8 shadow_root_level;
>  	bool direct_map;
>  	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
>  
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 51faa2c76ca5..43b99308cb0e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -112,7 +112,7 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa,
> -					  vcpu->arch.mmu->shadow_root_level);
> +					  vcpu->arch.mmu->mmu_role.level);
>  }
>  
>  struct kvm_page_fault {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f9d876ce429..4d1fa87718f8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2143,7 +2143,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
>  {
>  	iterator->addr = addr;
>  	iterator->shadow_addr = root;
> -	iterator->level = vcpu->arch.mmu->shadow_root_level;
> +	iterator->level = vcpu->arch.mmu->mmu_role.level;
>  
>  	if (iterator->level >= PT64_ROOT_4LEVEL &&
>  	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
> @@ -3254,7 +3254,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  					   &invalid_list);
>  
>  	if (free_active_root) {
> -		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> +		if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
>  		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
>  			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
>  		} else if (mmu->pae_root) {
> @@ -3329,7 +3329,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
>  static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> -	u8 shadow_root_level = mmu->shadow_root_level;
> +	u8 shadow_root_level = mmu->mmu_role.level;
>  	hpa_t root;
>  	unsigned i;
>  	int r;
> @@ -3479,7 +3479,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	 */
>  	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
>  		root = mmu_alloc_root(vcpu, root_gfn, 0,
> -				      mmu->shadow_root_level, false);
> +				      mmu->mmu_role.level, false);
>  		mmu->root_hpa = root;
>  		goto set_root_pgd;
>  	}
> @@ -3495,7 +3495,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	 * the shadow page table may be a PAE or a long mode page table.
>  	 */
>  	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
> -	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
> +	if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL) {
>  		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
>  
>  		if (WARN_ON_ONCE(!mmu->pml4_root)) {
> @@ -3504,7 +3504,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  		}
>  		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
>  
> -		if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
> +		if (mmu->mmu_role.level == PT64_ROOT_5LEVEL) {
>  			if (WARN_ON_ONCE(!mmu->pml5_root)) {
>  				r = -EIO;
>  				goto out_unlock;
> @@ -3529,9 +3529,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  		mmu->pae_root[i] = root | pm_mask;
>  	}
>  
> -	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL)
> +	if (mmu->mmu_role.level == PT64_ROOT_5LEVEL)
>  		mmu->root_hpa = __pa(mmu->pml5_root);
> -	else if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
> +	else if (mmu->mmu_role.level == PT64_ROOT_4LEVEL)
>  		mmu->root_hpa = __pa(mmu->pml4_root);
>  	else
>  		mmu->root_hpa = __pa(mmu->pae_root);
> @@ -3547,7 +3547,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> -	bool need_pml5 = mmu->shadow_root_level > PT64_ROOT_4LEVEL;
> +	bool need_pml5 = mmu->mmu_role.level > PT64_ROOT_4LEVEL;
>  	u64 *pml5_root = NULL;
>  	u64 *pml4_root = NULL;
>  	u64 *pae_root;
> @@ -3559,7 +3559,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>  	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
>  	 */
>  	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
> -	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)
> +	    mmu->mmu_role.level < PT64_ROOT_4LEVEL)
>  		return 0;
>  
>  	/*
> @@ -4145,7 +4145,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
>  	 * later if necessary.
>  	 */
> -	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> +	if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
>  	    mmu->root_level >= PT64_ROOT_4LEVEL)
>  		return cached_root_available(vcpu, new_pgd, new_role);
>  
> @@ -4408,17 +4408,17 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
>  	struct rsvd_bits_validate *shadow_zero_check;
>  	int i;
>  
> -	WARN_ON_ONCE(context->shadow_root_level < PT32E_ROOT_LEVEL);
> +	WARN_ON_ONCE(context->mmu_role.level < PT32E_ROOT_LEVEL);
>  
>  	shadow_zero_check = &context->shadow_zero_check;
>  	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
> -				context->shadow_root_level, uses_nx,
> +				context->mmu_role.level, uses_nx,
>  				guest_can_use_gbpages(vcpu), is_pse, is_amd);
>  
>  	if (!shadow_me_mask)
>  		return;
>  
> -	for (i = context->shadow_root_level; --i >= 0;) {
> +	for (i = context->mmu_role.level; --i >= 0;) {
>  		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
>  		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
>  	}
> @@ -4445,7 +4445,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
>  
>  	if (boot_cpu_is_amd())
>  		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
> -					context->shadow_root_level, false,
> +					context->mmu_role.level, false,
>  					boot_cpu_has(X86_FEATURE_GBPAGES),
>  					false, true);
>  	else
> @@ -4456,7 +4456,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
>  	if (!shadow_me_mask)
>  		return;
>  
> -	for (i = context->shadow_root_level; --i >= 0;) {
> +	for (i = context->mmu_role.level; --i >= 0;) {
>  		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
>  		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
>  	}
> @@ -4735,7 +4735,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role cpu_role)
>  	context->page_fault = kvm_tdp_page_fault;
>  	context->sync_page = nonpaging_sync_page;
>  	context->invlpg = NULL;
> -	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
>  	context->direct_map = true;
>  	context->get_guest_pgd = get_cr3;
>  	context->get_pdptr = kvm_pdptr_read;
> @@ -4773,7 +4772,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
>  	context->root_level = cpu_role.base.level;
>  
>  	reset_guest_paging_metadata(vcpu, context);
> -	context->shadow_root_level = mmu_role.level;
>  }
>  
>  static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
> @@ -4852,8 +4850,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  		context->cpu_role.as_u64 = new_role.as_u64;
>  		context->mmu_role.word = new_role.base.word;
>  
> -		context->shadow_root_level = level;
> -
>  		context->page_fault = ept_page_fault;
>  		context->gva_to_gpa = ept_gva_to_gpa;
>  		context->sync_page = ept_sync_page;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index dd4c78833016..9fb6d983bae9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1697,7 +1697,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>  	gfn_t gfn = addr >> PAGE_SHIFT;
>  	int leaf = -1;
>  
> -	*root_level = vcpu->arch.mmu->shadow_root_level;
> +	*root_level = vcpu->arch.mmu->mmu_role.level;
>  
>  	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
>  		leaf = iter.level;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7b5345a66117..5a1d552b535b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3815,7 +3815,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  		hv_track_root_tdp(vcpu, root_hpa);
>  
>  		cr3 = vcpu->arch.cr3;
> -	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
> +	} else if (vcpu->arch.mmu->mmu_role.level >= PT64_ROOT_4LEVEL) {
>  		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
>  	} else {
>  		/* PCID in the guest should be impossible with a 32-bit MMU. */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8ac5a6fa7720..5e2c865a04ff 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2965,7 +2965,7 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
>  
>  	if (enable_ept)
>  		ept_sync_context(construct_eptp(vcpu, root_hpa,
> -						mmu->shadow_root_level));
> +						mmu->mmu_role.level));
>  	else
>  		vpid_sync_context(vmx_get_current_vpid(vcpu));
>  }
> -- 
> 2.31.1
> 
> 
