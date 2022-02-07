Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C508C4ACD51
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiBHBFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240261AbiBGXCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 18:02:01 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF11C061355
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 15:02:00 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id u130so15628644pfc.2
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 15:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q3Qh2zAQTysN7pJuJqaaISnqHFk+D6iUbrzUWxgk10Q=;
        b=SiOdTPdslAm3NH53Rth94uZETgfcchJEWePG6gBIOL7YJeqZaI744P+xNWGGiEfivp
         rCNC5Rg8KvODWgLyMIgKHC+JCi/wmh2rYhQJOrRI43CPDE+xqzZ3Jiivtub/60IPTTCh
         wOsMDsz/7/R9HQAjSw/BZNXQnTF4fvbms5wTOJAMECt/VYfs9pRsUDRjoxjGXH6sLlrP
         WEIM32hMWqOHk4NAbTomK2ckokf2wOo84gtkDgoz2ePd51b7Gy4FriMFX3BxLWdNlmrT
         IUkuZ9mfPwEj4DTnRHrr4JwM7FwL29GOZjECkZU5tVoFBwjrrElYxnqCbTu2uNjFx+Mr
         /0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q3Qh2zAQTysN7pJuJqaaISnqHFk+D6iUbrzUWxgk10Q=;
        b=dIHJ+BP6q/DwtJ/FqGyErEj0r4KDGwIz3YBdNlZM2nZz7y/6C8FYvG+lYFBa6brXyV
         s49uuqu64Bk5nrXYof9K2xjYikCzgOFjfO34xfdB4MDukFh6VkJPM2EHqZpbNymAUwRX
         XW2LYL0/0reQpcFg/xdDMqLYngumang2tW45CEUCb8h+3SDzyFubm2wZ/IpzW+k8ybah
         Jac0nMeXVED5vI0I1eEBq+XdF8Rc+P/kVthw0w9aYTb9UPlqbwKLpveRdcE8rqLehBVt
         G9Snx44iXCBCbsqOc6Jp3vAuB/xZzbylsYYgvC5jGwsksR6BTcC4LBgczio5cUMmwRF5
         9pxA==
X-Gm-Message-State: AOAM532+Kb1fX504U1V9HXHYBnL2fvVklKgNN8wyIMaMMFHknfq11CYS
        Bxx9JBMZECqbWds1uHuXP0/M2g==
X-Google-Smtp-Source: ABdhPJx+V+nhANqiiBKPst8l9EJo+akzqrRthxaCNDnbUGy4pFEZMHtFbrg3+xlromxKGA0K8rWY+A==
X-Received: by 2002:aa7:938c:: with SMTP id t12mr1545547pfe.51.1644274919785;
        Mon, 07 Feb 2022 15:01:59 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id m68sm274131pga.10.2022.02.07.15.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 15:01:58 -0800 (PST)
Date:   Mon, 7 Feb 2022 23:01:55 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 22/23] KVM: MMU: use cpu_role for root_level
Message-ID: <YgGk48O8Z9PUbHpr@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-23-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-23-pbonzini@redhat.com>
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

On Fri, Feb 04, 2022 at 06:57:17AM -0500, Paolo Bonzini wrote:
> Remove another duplicate field of struct kvm_mmu.  This time it's
> the root level for page table walking; we were already initializing
> it mostly as cpu_role.base.level, but the field still existed;
> remove it.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

nit: How about the following for the shortlog?

KVM: MMU: Replace root_level with cpu_role.base.level

Otherwise,

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/mmu/mmu.c          | 22 +++++++++-------------
>  arch/x86/kvm/mmu/mmu_audit.c    |  6 +++---
>  arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
>  4 files changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 867fc82f1de5..c86a2beee92a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -432,7 +432,6 @@ struct kvm_mmu {
>  	gpa_t root_pgd;
>  	union kvm_mmu_role cpu_role;
>  	union kvm_mmu_page_role mmu_role;
> -	u8 root_level;
>  	bool direct_map;
>  	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4d1fa87718f8..5a6541d6a424 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2146,7 +2146,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
>  	iterator->level = vcpu->arch.mmu->mmu_role.level;
>  
>  	if (iterator->level >= PT64_ROOT_4LEVEL &&
> -	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
> +	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
>  	    !vcpu->arch.mmu->direct_map)
>  		iterator->level = PT32E_ROOT_LEVEL;
>  
> @@ -3255,7 +3255,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  
>  	if (free_active_root) {
>  		if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
> -		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> +		    (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
>  			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
>  		} else if (mmu->pae_root) {
>  			for (i = 0; i < 4; ++i) {
> @@ -3453,7 +3453,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	 * On SVM, reading PDPTRs might access guest memory, which might fault
>  	 * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
>  	 */
> -	if (mmu->root_level == PT32E_ROOT_LEVEL) {
> +	if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
>  		for (i = 0; i < 4; ++i) {
>  			pdptrs[i] = mmu->get_pdptr(vcpu, i);
>  			if (!(pdptrs[i] & PT_PRESENT_MASK))
> @@ -3477,7 +3477,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	 * Do we shadow a long mode page table? If so we need to
>  	 * write-protect the guests page table root.
>  	 */
> -	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
> +	if (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
>  		root = mmu_alloc_root(vcpu, root_gfn, 0,
>  				      mmu->mmu_role.level, false);
>  		mmu->root_hpa = root;
> @@ -3516,7 +3516,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	for (i = 0; i < 4; ++i) {
>  		WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
>  
> -		if (mmu->root_level == PT32E_ROOT_LEVEL) {
> +		if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
>  			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
>  				mmu->pae_root[i] = INVALID_PAE_ROOT;
>  				continue;
> @@ -3558,7 +3558,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>  	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
>  	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
>  	 */
> -	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
> +	if (mmu->direct_map || mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
>  	    mmu->mmu_role.level < PT64_ROOT_4LEVEL)
>  		return 0;
>  
> @@ -3655,7 +3655,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  
>  	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
>  
> -	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
> +	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
>  		hpa_t root = vcpu->arch.mmu->root_hpa;
>  		sp = to_shadow_page(root);
>  
> @@ -4146,7 +4146,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  	 * later if necessary.
>  	 */
>  	if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
> -	    mmu->root_level >= PT64_ROOT_4LEVEL)
> +	    mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL)
>  		return cached_root_available(vcpu, new_pgd, new_role);
>  
>  	return false;
> @@ -4335,7 +4335,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>  {
>  	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
>  				vcpu->arch.reserved_gpa_bits,
> -				context->root_level, is_efer_nx(context),
> +				context->cpu_role.base.level, is_efer_nx(context),
>  				guest_can_use_gbpages(vcpu),
>  				is_cr4_pse(context),
>  				guest_cpuid_is_amd_or_hygon(vcpu));
> @@ -4739,7 +4739,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role cpu_role)
>  	context->get_guest_pgd = get_cr3;
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
> -	context->root_level = cpu_role.base.level;
>  
>  	if (!is_cr0_pg(context))
>  		context->gva_to_gpa = nonpaging_gva_to_gpa;
> @@ -4769,7 +4768,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
>  		paging64_init_context(context);
>  	else
>  		paging32_init_context(context);
> -	context->root_level = cpu_role.base.level;
>  
>  	reset_guest_paging_metadata(vcpu, context);
>  }
> @@ -4854,7 +4852,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  		context->gva_to_gpa = ept_gva_to_gpa;
>  		context->sync_page = ept_sync_page;
>  		context->invlpg = ept_invlpg;
> -		context->root_level = level;
>  		context->direct_map = false;
>  		update_permission_bitmask(context, true);
>  		context->pkru_mask = 0;
> @@ -4889,7 +4886,6 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role new_ro
>  	g_context->get_guest_pgd     = get_cr3;
>  	g_context->get_pdptr         = kvm_pdptr_read;
>  	g_context->inject_page_fault = kvm_inject_page_fault;
> -	g_context->root_level        = new_role.base.level;
>  
>  	/*
>  	 * L2 page tables are never shadowed, so there is no need to sync
> diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
> index f31fdb874f1f..eb9c59fcb957 100644
> --- a/arch/x86/kvm/mmu/mmu_audit.c
> +++ b/arch/x86/kvm/mmu/mmu_audit.c
> @@ -59,11 +59,11 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
>  	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
>  		return;
>  
> -	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
> +	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
>  		hpa_t root = vcpu->arch.mmu->root_hpa;
>  
>  		sp = to_shadow_page(root);
> -		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->root_level);
> +		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->cpu_role.base.level);
>  		return;
>  	}
>  
> @@ -119,7 +119,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
>  	hpa =  pfn << PAGE_SHIFT;
>  	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
>  		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
> -			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
> +			     "ent %llxn", vcpu->arch.mmu->cpu_role.base.level, pfn,
>  			     hpa, *sptep);
>  }
>  
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 847c4339e4d9..dd0b6f83171f 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -361,7 +361,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  
>  	trace_kvm_mmu_pagetable_walk(addr, access);
>  retry_walk:
> -	walker->level = mmu->root_level;
> +	walker->level = mmu->cpu_role.base.level;
>  	pte           = mmu->get_guest_pgd(vcpu);
>  	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
>  
> @@ -656,7 +656,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	WARN_ON_ONCE(gw->gfn != base_gfn);
>  	direct_access = gw->pte_access;
>  
> -	top_level = vcpu->arch.mmu->root_level;
> +	top_level = vcpu->arch.mmu->cpu_role.base.level;
>  	if (top_level == PT32E_ROOT_LEVEL)
>  		top_level = PT32_ROOT_LEVEL;
>  	/*
> -- 
> 2.31.1
> 
> 
