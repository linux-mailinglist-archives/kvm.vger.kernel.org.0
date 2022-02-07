Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B044ACD97
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbiBHBFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245423AbiBGXCb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 18:02:31 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD56C0612A4
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 15:02:30 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so480499pja.3
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 15:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pJ/+igUmHgRIjjygLMzdyoK+rvf+jqDZy1oDYk+RIZg=;
        b=E8gpxS6fJle8GCoe8lQxUylKx4rE9z5yYpFntEJ50OrhsXqUw5Yehi5aTy1m0q26AD
         TEwxWZ36okQ4FloOQhMedCeMaJF15ck58zyhBFEa4d2isJeVlLSEx1y4rOd4l8zg+e+H
         Ju0Dvi2L6q1e9s7ha+qlY2jY0nG2P4SS8otyNBDzh4P4czNsbUyezpFJXWMqjwhpdVxk
         y7612yxtdBylaTRTDcse9PTgPY9M+r7M9zL1eAARfnRz5kjQ5aghTrT5zvLbejUHscGF
         7/Cvm3rCCa0rJjTyw785o85bazmJ7mXvEkPZ3QltQj4kMOz6l2bS2x+WbGn1ho9S6zrh
         pk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pJ/+igUmHgRIjjygLMzdyoK+rvf+jqDZy1oDYk+RIZg=;
        b=D1GW1SUmm+y5oDOInbDNswFSTtsVNF3CTMmb6dJ4qIL8NQuavSxv1frF3C3lT+Qb77
         DHrd2RHblHi/iRl5EmwDtrkTRyn5PqQsJRjv/Xej7MjNnhuZobP3/A0eLSJfF8KIBtuv
         jJQ/8QbH49N9o0lpLh4jeLEeGrTOthEu5VtwddBcoP5qKqwWYqoUIwZ2wANvTP4HWWra
         LeyWCwpOAOdwEzDVRwio2x8jH8SYp0lkNnJjKcEiZtTHsXLv5bp6iY/W2Q7J42H1R12A
         9dK2O/yTHFGyLnmpoglaPOc13HqHr1hMUSlvMxZM+mYHlosY9jQ1bwi10hYjDA3xAPYP
         gllQ==
X-Gm-Message-State: AOAM532SuR0iK71Mb4bEPwIP79pYqGxuTiMewYpt9wLpw13owRSGOmXe
        SGbf7IWcqpxW7ROReIAshT67jg==
X-Google-Smtp-Source: ABdhPJzesOXuASeOIlrf6AUPY9/bVDPCRvCIr2LQINyXY8719iOU6+yIEu8TjJMTDHLemah5XzLtvg==
X-Received: by 2002:a17:90b:3c6:: with SMTP id go6mr1291136pjb.230.1644274950087;
        Mon, 07 Feb 2022 15:02:30 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id h27sm9242504pgb.20.2022.02.07.15.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 15:02:29 -0800 (PST)
Date:   Mon, 7 Feb 2022 23:02:25 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 23/23] KVM: MMU: replace direct_map with mmu_role.direct
Message-ID: <YgGlAbyLQGRUOlSG@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-24-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-24-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:57:18AM -0500, Paolo Bonzini wrote:
> direct_map is always equal to the role's direct field:
> 
> - for shadow paging, direct_map is true if CR0.PG=0 and mmu_role.direct is
> copied from cpu_role.base.direct
> 
> - for TDP, it is always true and mmu_role.direct is also always true
> 
> - for shadow EPT, it is always false and mmu_role.direct is also always
> false
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/mmu/mmu.c          | 30 ++++++++++++++----------------
>  arch/x86/kvm/x86.c              | 12 ++++++------
>  4 files changed, 21 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c86a2beee92a..647b3f6d02d0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -432,7 +432,6 @@ struct kvm_mmu {
>  	gpa_t root_pgd;
>  	union kvm_mmu_role cpu_role;
>  	union kvm_mmu_page_role mmu_role;
> -	bool direct_map;
>  	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
>  
>  	/*
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5a6541d6a424..ce55fad99671 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2045,7 +2045,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  					     int direct,
>  					     unsigned int access)
>  {
> -	bool direct_mmu = vcpu->arch.mmu->direct_map;
> +	bool direct_mmu = vcpu->arch.mmu->mmu_role.direct;
>  	union kvm_mmu_page_role role;
>  	struct hlist_head *sp_list;
>  	unsigned quadrant;
> @@ -2147,7 +2147,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
>  
>  	if (iterator->level >= PT64_ROOT_4LEVEL &&
>  	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
> -	    !vcpu->arch.mmu->direct_map)
> +	    !vcpu->arch.mmu->mmu_role.direct)
>  		iterator->level = PT32E_ROOT_LEVEL;
>  
>  	if (iterator->level == PT32E_ROOT_LEVEL) {
> @@ -2523,7 +2523,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
>  	gpa_t gpa;
>  	int r;
>  
> -	if (vcpu->arch.mmu->direct_map)
> +	if (vcpu->arch.mmu->mmu_role.direct)
>  		return 0;
>  
>  	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
> @@ -3255,7 +3255,8 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  
>  	if (free_active_root) {
>  		if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
> -		    (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> +		    (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
> +		     mmu->mmu_role.direct)) {
>  			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
>  		} else if (mmu->pae_root) {
>  			for (i = 0; i < 4; ++i) {
> @@ -3558,7 +3559,8 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>  	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
>  	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
>  	 */
> -	if (mmu->direct_map || mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
> +	if (mmu->mmu_role.direct ||
> +	    mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
>  	    mmu->mmu_role.level < PT64_ROOT_4LEVEL)
>  		return 0;
>  
> @@ -3647,7 +3649,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  	int i;
>  	struct kvm_mmu_page *sp;
>  
> -	if (vcpu->arch.mmu->direct_map)
> +	if (vcpu->arch.mmu->mmu_role.direct)
>  		return;
>  
>  	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
> @@ -3872,7 +3874,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>  	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>  	arch.gfn = gfn;
> -	arch.direct_map = vcpu->arch.mmu->direct_map;
> +	arch.direct_map = vcpu->arch.mmu->mmu_role.direct;
>  	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
>  
>  	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
> @@ -4090,7 +4092,6 @@ static void nonpaging_init_context(struct kvm_mmu *context)
>  	context->gva_to_gpa = nonpaging_gva_to_gpa;
>  	context->sync_page = nonpaging_sync_page;
>  	context->invlpg = NULL;
> -	context->direct_map = true;
>  }
>  
>  static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
> @@ -4641,7 +4642,6 @@ static void paging64_init_context(struct kvm_mmu *context)
>  	context->gva_to_gpa = paging64_gva_to_gpa;
>  	context->sync_page = paging64_sync_page;
>  	context->invlpg = paging64_invlpg;
> -	context->direct_map = false;
>  }
>  
>  static void paging32_init_context(struct kvm_mmu *context)
> @@ -4650,7 +4650,6 @@ static void paging32_init_context(struct kvm_mmu *context)
>  	context->gva_to_gpa = paging32_gva_to_gpa;
>  	context->sync_page = paging32_sync_page;
>  	context->invlpg = paging32_invlpg;
> -	context->direct_map = false;
>  }
>  
>  static union kvm_mmu_role
> @@ -4735,7 +4734,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role cpu_role)
>  	context->page_fault = kvm_tdp_page_fault;
>  	context->sync_page = nonpaging_sync_page;
>  	context->invlpg = NULL;
> -	context->direct_map = true;
>  	context->get_guest_pgd = get_cr3;
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
> @@ -4852,7 +4850,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  		context->gva_to_gpa = ept_gva_to_gpa;
>  		context->sync_page = ept_sync_page;
>  		context->invlpg = ept_invlpg;
> -		context->direct_map = false;
> +
>  		update_permission_bitmask(context, true);
>  		context->pkru_mask = 0;
>  		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
> @@ -4967,13 +4965,13 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  {
>  	int r;
>  
> -	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
> +	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->mmu_role.direct);
>  	if (r)
>  		goto out;
>  	r = mmu_alloc_special_roots(vcpu);
>  	if (r)
>  		goto out;
> -	if (vcpu->arch.mmu->direct_map)
> +	if (vcpu->arch.mmu->mmu_role.direct)
>  		r = mmu_alloc_direct_roots(vcpu);
>  	else
>  		r = mmu_alloc_shadow_roots(vcpu);
> @@ -5176,7 +5174,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  		       void *insn, int insn_len)
>  {
>  	int r, emulation_type = EMULTYPE_PF;
> -	bool direct = vcpu->arch.mmu->direct_map;
> +	bool direct = vcpu->arch.mmu->mmu_role.direct;
>  
>  	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
>  		return RET_PF_RETRY;
> @@ -5207,7 +5205,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  	 * paging in both guests. If true, we simply unprotect the page
>  	 * and resume the guest.
>  	 */
> -	if (vcpu->arch.mmu->direct_map &&
> +	if (vcpu->arch.mmu->mmu_role.direct &&
>  	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
>  		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
>  		return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 657aa646871e..b910fa34e57e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7978,7 +7978,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
>  		return false;
>  
> -	if (!vcpu->arch.mmu->direct_map) {
> +	if (!vcpu->arch.mmu->mmu_role.direct) {
>  		/*
>  		 * Write permission should be allowed since only
>  		 * write access need to be emulated.
> @@ -8011,7 +8011,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	kvm_release_pfn_clean(pfn);
>  
>  	/* The instructions are well-emulated on direct mmu. */
> -	if (vcpu->arch.mmu->direct_map) {
> +	if (vcpu->arch.mmu->mmu_role.direct) {
>  		unsigned int indirect_shadow_pages;
>  
>  		write_lock(&vcpu->kvm->mmu_lock);
> @@ -8079,7 +8079,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>  	vcpu->arch.last_retry_eip = ctxt->eip;
>  	vcpu->arch.last_retry_addr = cr2_or_gpa;
>  
> -	if (!vcpu->arch.mmu->direct_map)
> +	if (!vcpu->arch.mmu->mmu_role.direct)
>  		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
>  
>  	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> @@ -8359,7 +8359,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		ctxt->exception.address = cr2_or_gpa;
>  
>  		/* With shadow page tables, cr2 contains a GVA or nGPA. */
> -		if (vcpu->arch.mmu->direct_map) {
> +		if (vcpu->arch.mmu->mmu_role.direct) {
>  			ctxt->gpa_available = true;
>  			ctxt->gpa_val = cr2_or_gpa;
>  		}
> @@ -12196,7 +12196,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
>  	int r;
>  
> -	if ((vcpu->arch.mmu->direct_map != work->arch.direct_map) ||
> +	if ((vcpu->arch.mmu->mmu_role.direct != work->arch.direct_map) ||
>  	      work->wakeup_all)
>  		return;
>  
> @@ -12204,7 +12204,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	if (unlikely(r))
>  		return;
>  
> -	if (!vcpu->arch.mmu->direct_map &&
> +	if (!vcpu->arch.mmu->mmu_role.direct &&
>  	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
>  		return;
>  
> -- 
> 2.31.1
> 
