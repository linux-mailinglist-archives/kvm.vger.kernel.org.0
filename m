Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF47E4AA2AA
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245059AbiBDV5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244978AbiBDV5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:57:33 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2994FC06173D
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:57:32 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c9so6258653plg.11
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X5mQ7XgNN+wXIOoyBr6bEPCY6JnyKab78tFOCt/mw8M=;
        b=f0s53wUDMeWAABIK90/+s023v71c8CXbsCTguKRbhpeoYsrOVMM82VyLxAKX8ZxmIo
         AqCtBYgDq5jSe5xsU/c9v0Y+gU6II6lJDtPd4t1IdyChIcU29ViSQYdiwzZBzLlGi5JW
         04qKzUAulgERC3XEWgigCpZJ2AT/Nb53TiWwlo8dJIUzyTepS3FmSOXHxd56VHo2JuuZ
         3H7hXy49uYsQnXXwClLjACnQwx3u6YhntVqGTvsuH5b+SDxpLVg/qK+zXScBYwiZX47u
         NYEqMHNsmvs2Yl82NxNU3icz+q3abBPdCe7/o8JYe5tbzLttH0f+HBZGoZaq3+0p++lE
         MeWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X5mQ7XgNN+wXIOoyBr6bEPCY6JnyKab78tFOCt/mw8M=;
        b=TpLZJSlifaDTSPpUIyRFhYsGfJ/4mxpXTdzHW3u4eqgDIZvD+kyWmQ6ea9gLGuJAme
         GcYkSuLJvRcxYsb+oxUgyuZwZYlZ8arhymQAfqpuPTxkO2118bhz0txR2dVG/164dBpN
         pUfLVvOcYcv4imyrZShRxQqYuJfdvUgUXbZDiA1kMRy/OC7I+SC5ratjTYMuQQxISKGi
         ggRWOoFrVB2q2i52hWT+beYja85HPpC1mOJCM4VSyIRs1YVSx5/pceo53Tlb75Vc6k5P
         Zwa/fAOiminHvXGkOs1hte3wK6HvasFAXM5ZiMsC5Z6pBsoqaQ5c+4aM7VZ0BAZYTlyl
         JMeA==
X-Gm-Message-State: AOAM532T83cziNglPgFHnlcMMP1axRfROguMf1ZkYqaBsCNQ69DcXXd6
        6c8A+3qOiSNmhVOPl8NER+2BCw==
X-Google-Smtp-Source: ABdhPJzRWUpM8+rgedAJTRPqUF2/4bzzp5hsVBHxEVWYZwtgYXRoVbAgM5BjDVq5nlLwIs9fyreOyQ==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr1176474pjq.68.1644011851262;
        Fri, 04 Feb 2022 13:57:31 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id l22sm3562372pfc.191.2022.02.04.13.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 13:57:30 -0800 (PST)
Date:   Fri, 4 Feb 2022 21:57:26 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 10/23] KVM: MMU: split cpu_role from mmu_role
Message-ID: <Yf2hRltaM1Ezd6SM@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-11-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-11-pbonzini@redhat.com>
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

On Fri, Feb 04, 2022 at 06:57:05AM -0500, Paolo Bonzini wrote:
> Snapshot the state of the processor registers that govern page walk into
> a new field of struct kvm_mmu.  This is a more natural representation
> than having it *mostly* in mmu_role but not exclusively; the delta
> right now is represented in other fields, such as root_level.  For
> example, already in this patch we can replace role_regs_to_root_level
> with the "level" field of the CPU role.
> 
> The nested MMU now has only the CPU role; and in fact the new function
> kvm_calc_cpu_role is analogous to the previous kvm_calc_nested_mmu_role,
> except that it has role.base.direct equal to CR0.PG.  It is not clear
> what the code meant by "setting role.base.direct to true to detect bogus
> usage of the nested MMU".
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   1 +
>  arch/x86/kvm/mmu/mmu.c          | 100 ++++++++++++++++++++------------
>  arch/x86/kvm/mmu/paging_tmpl.h  |   2 +-
>  3 files changed, 64 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4ec7d1e3aa36..427ee486309c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -432,6 +432,7 @@ struct kvm_mmu {
>  	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
>  	hpa_t root_hpa;
>  	gpa_t root_pgd;
> +	union kvm_mmu_role cpu_role;
>  	union kvm_mmu_role mmu_role;
>  	u8 root_level;
>  	u8 shadow_root_level;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dd69cfc8c4f6..f98444e1d834 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -230,7 +230,7 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
>  #define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
>  static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
>  {								\
> -	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
> +	return !!(mmu->cpu_role. base_or_ext . reg##_##name);	\
>  }
>  BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
>  BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
> @@ -4658,6 +4658,38 @@ static void paging32_init_context(struct kvm_mmu *context)
>  	context->direct_map = false;
>  }
>  
> +static union kvm_mmu_role
> +kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> +{
> +	union kvm_mmu_role role = {0};
> +
> +	role.base.access = ACC_ALL;
> +	role.base.smm = is_smm(vcpu);
> +	role.base.guest_mode = is_guest_mode(vcpu);
> +	role.base.direct = !____is_cr0_pg(regs);
> +	if (!role.base.direct) {
> +		role.base.efer_nx = ____is_efer_nx(regs);
> +		role.base.cr0_wp = ____is_cr0_wp(regs);
> +		role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
> +		role.base.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
> +		role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
> +		role.base.level = role_regs_to_root_level(regs);
> +
> +		role.ext.cr0_pg = 1;
> +		role.ext.cr4_pae = ____is_cr4_pae(regs);
> +		role.ext.cr4_smep = ____is_cr4_smep(regs);
> +		role.ext.cr4_smap = ____is_cr4_smap(regs);
> +		role.ext.cr4_pse = ____is_cr4_pse(regs);
> +
> +		/* PKEY and LA57 are active iff long mode is active. */
> +		role.ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
> +		role.ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
> +		role.ext.efer_lma = ____is_efer_lma(regs);
> +	}
> +
> +	return role;
> +}
> +
>  static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
>  						   const struct kvm_mmu_role_regs *regs)
>  {
> @@ -4716,13 +4748,16 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
>  			     const struct kvm_mmu_role_regs *regs)
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
> -	union kvm_mmu_role new_role =
> +	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
> +	union kvm_mmu_role mmu_role =
>  		kvm_calc_tdp_mmu_root_page_role(vcpu, regs);
>  
> -	if (new_role.as_u64 == context->mmu_role.as_u64)
> +	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
> +	    mmu_role.as_u64 == context->mmu_role.as_u64)
>  		return;
>  
> -	context->mmu_role.as_u64 = new_role.as_u64;
> +	context->cpu_role.as_u64 = cpu_role.as_u64;
> +	context->mmu_role.as_u64 = mmu_role.as_u64;
>  	context->page_fault = kvm_tdp_page_fault;
>  	context->sync_page = nonpaging_sync_page;
>  	context->invlpg = NULL;
> @@ -4777,13 +4812,15 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  }
>  
>  static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
> -				    const struct kvm_mmu_role_regs *regs,
> -				    union kvm_mmu_role new_role)
> +				    union kvm_mmu_role cpu_role,
> +				    union kvm_mmu_role mmu_role)
>  {
> -	if (new_role.as_u64 == context->mmu_role.as_u64)
> +	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
> +	    mmu_role.as_u64 == context->mmu_role.as_u64)
>  		return;
>  
> -	context->mmu_role.as_u64 = new_role.as_u64;
> +	context->cpu_role.as_u64 = cpu_role.as_u64;
> +	context->mmu_role.as_u64 = mmu_role.as_u64;
>  
>  	if (!is_cr0_pg(context))
>  		nonpaging_init_context(context);
> @@ -4791,20 +4828,21 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
>  		paging64_init_context(context);
>  	else
>  		paging32_init_context(context);
> -	context->root_level = role_regs_to_root_level(regs);
> +	context->root_level = cpu_role.base.level;
>  
>  	reset_guest_paging_metadata(vcpu, context);
> -	context->shadow_root_level = new_role.base.level;
> +	context->shadow_root_level = mmu_role.base.level;
>  }
>  
>  static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
>  				const struct kvm_mmu_role_regs *regs)
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
> -	union kvm_mmu_role new_role =
> +	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
> +	union kvm_mmu_role mmu_role =
>  		kvm_calc_shadow_mmu_root_page_role(vcpu, regs);
>  
> -	shadow_mmu_init_context(vcpu, context, regs, new_role);
> +	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
>  
>  	/*
>  	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
> @@ -4839,11 +4877,10 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>  		.cr4 = cr4 & ~X86_CR4_PKE,
>  		.efer = efer,
>  	};
> -	union kvm_mmu_role new_role;
> -
> -	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
> +	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
> +	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);;
>  
> -	shadow_mmu_init_context(vcpu, context, &regs, new_role);
> +	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
>  	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
>  	kvm_mmu_new_pgd(vcpu, nested_cr3);
>  }
> @@ -4862,7 +4899,6 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
>  	role.base.guest_mode = true;
>  	role.base.access = ACC_ALL;
>  
> -	/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
>  	role.ext.word = 0;
>  	role.ext.execonly = execonly;
>  
> @@ -4879,7 +4915,9 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
>  						   execonly, level);
>  
> -	if (new_role.as_u64 != context->mmu_role.as_u64) {
> +	if (new_role.as_u64 != context->cpu_role.as_u64) {
> +		/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
> +		context->cpu_role.as_u64 = new_role.as_u64;
>  		context->mmu_role.as_u64 = new_role.as_u64;
>  
>  		context->shadow_root_level = level;
> @@ -4913,32 +4951,15 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
>  	context->inject_page_fault = kvm_inject_page_fault;
>  }
>  
> -static union kvm_mmu_role
> -kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> -{
> -	union kvm_mmu_role role;
> -
> -	role = kvm_calc_shadow_root_page_role_common(vcpu, regs);
> -
> -	/*
> -	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
> -	 * shadow pages of their own and so "direct" has no meaning.   Set it
> -	 * to "true" to try to detect bogus usage of the nested MMU.
> -	 */
> -	role.base.direct = true;
> -	role.base.level = role_regs_to_root_level(regs);
> -	return role;
> -}
> -
>  static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
>  {
> -	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, regs);
> +	union kvm_mmu_role new_role = kvm_calc_cpu_role(vcpu, regs);
>  	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
>  
> -	if (new_role.as_u64 == g_context->mmu_role.as_u64)
> +	if (new_role.as_u64 == g_context->cpu_role.as_u64)
>  		return;
>  
> -	g_context->mmu_role.as_u64 = new_role.as_u64;
> +	g_context->cpu_role.as_u64 = new_role.as_u64;
>  	g_context->get_guest_pgd     = get_cr3;
>  	g_context->get_pdptr         = kvm_pdptr_read;
>  	g_context->inject_page_fault = kvm_inject_page_fault;
> @@ -4997,6 +5018,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * problem is swept under the rug; KVM's CPUID API is horrific and
>  	 * it's all but impossible to solve it without introducing a new API.
>  	 */
> +	vcpu->arch.root_mmu.cpu_role.base.level = 0;
> +	vcpu->arch.guest_mmu.cpu_role.base.level = 0;
> +	vcpu->arch.nested_mmu.cpu_role.base.level = 0;

Will cpu_role.base.level already be 0 if CR0.PG=0 && !tdp_enabled? i.e.
setting cpu_role.base.level to 0 might not have the desired effect.

It might not matter in practice since the shadow_mmu_init_context() and
kvm_calc_mmu_role_common() check both the mmu_role and cpu_role, but does
make this reset code confusing.

>  	vcpu->arch.root_mmu.mmu_role.base.level = 0;
>  	vcpu->arch.guest_mmu.mmu_role.base.level = 0;
>  	vcpu->arch.nested_mmu.mmu_role.base.level = 0;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 6bb9a377bf89..b9f472f27077 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -323,7 +323,7 @@ static inline bool FNAME(is_last_gpte)(struct kvm_mmu *mmu,
>  	 * is not reserved and does not indicate a large page at this level,
>  	 * so clear PT_PAGE_SIZE_MASK in gpte if that is the case.
>  	 */
> -	gpte &= level - (PT32_ROOT_LEVEL + mmu->mmu_role.ext.cr4_pse);
> +	gpte &= level - (PT32_ROOT_LEVEL + mmu->cpu_role.ext.cr4_pse);
>  #endif
>  	/*
>  	 * PG_LEVEL_4K always terminates.  The RHS has bit 7 set
> -- 
> 2.31.1
> 
> 
