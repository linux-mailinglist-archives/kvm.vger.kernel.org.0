Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5FE4AA043
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 20:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbiBDTl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 14:41:29 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:42738 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiBDTl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 14:41:28 -0500
Received: by mail-pj1-f43.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so7063964pjb.1
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 11:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CFMZsF60mL/AvzBP5r7pT0OECNsIa6CFchGR8JtV4T0=;
        b=HOiF0IuLnq3i8UV+fBUCJFRs4Q4aJV/D1+wwXgLvB57llCkcIRS4p3ObBuIH81IopO
         kWEtR1ssi8mWxG1BHvyNrV6Mwb/PAdOuKKJMnxIv/AExTjjZCD54OjE4mPip7ee2Laaf
         qzXvoQjY42iwKVhMF+5BhMBGbyAmtNCKzUJWdSc9Ag6WlhOi7JV0f5ZSVOs+q0k0QU1G
         DgPB9LQmVxY38GEuBfV7Cn3ncte/NndbXLQIgmsuz3Gawus9gzzUmDFBxXlsahGDVLAc
         0E4WQlu9m8M8ybnA+HdYytVWRfC9ppyZ3HQG+RgG5tzWNeSUsuKO35mO4zCeUNuTl8GE
         gKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CFMZsF60mL/AvzBP5r7pT0OECNsIa6CFchGR8JtV4T0=;
        b=4Q7MZmL4S7QXjiWoTJvpeyCDkpvGXdVvPspfUSeUzDqZt9HEq6qeu73fCm0l4ta2Tq
         HKPT7kyNNjR91INnkCx32FrwFQhj4imMw0FP4/b3M1LEw0Qwdo5gJ79hcZ7rmDKH6ZON
         0P+lqqEt0J2PF5cjom8reScJXzBJV1VBbbm9RLsikMfucsbRiJXVPGGVk1FD1yiLR01Z
         VN+IyMGwkT1Q0WprO/Q1Q+EUCMC0CXXoKbDqPId7gtekKxMHs+K7cghsVBgkEH7J2KWo
         hFyvnUsri/PjShz3vhTrMtuQPslidVoLZn0BleOwvGtFL+AGd71NWh+tvTXB1ATfzHxz
         fThg==
X-Gm-Message-State: AOAM531r1RwK98lBiNDtaLq+q6av6wuNGYAVNFeg61ix4TE/RJ5sZZp0
        x9hJ3nH9pS5u6wFkN/d/ycrM7Q==
X-Google-Smtp-Source: ABdhPJxWkol5aNJtQE2P/r9jH259x9uDSBFAEB4kHn82uLShVjYU7+64EOypAuDoqP1JG7a0BrO+Sg==
X-Received: by 2002:a17:90b:33cd:: with SMTP id lk13mr4873649pjb.91.1644003687575;
        Fri, 04 Feb 2022 11:41:27 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z13sm3537235pfe.20.2022.02.04.11.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 11:41:26 -0800 (PST)
Date:   Fri, 4 Feb 2022 19:41:23 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 09/23] KVM: MMU: remove "bool base_only" arguments
Message-ID: <Yf2BY7d8TsmNrceY@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-10-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-10-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:57:04AM -0500, Paolo Bonzini wrote:
> The argument is always false now that kvm_mmu_calc_root_page_role has
> been removed.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 63 +++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 42475e4c2a48..dd69cfc8c4f6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4658,46 +4658,30 @@ static void paging32_init_context(struct kvm_mmu *context)
>  	context->direct_map = false;
>  }
>  
> -static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
> -							 const struct kvm_mmu_role_regs *regs)
> -{
> -	union kvm_mmu_extended_role ext = {0};
> -
> -	if (____is_cr0_pg(regs)) {
> -		ext.cr0_pg = 1;
> -		ext.cr4_pae = ____is_cr4_pae(regs);
> -		ext.cr4_smep = ____is_cr4_smep(regs);
> -		ext.cr4_smap = ____is_cr4_smap(regs);
> -		ext.cr4_pse = ____is_cr4_pse(regs);
> -
> -		/* PKEY and LA57 are active iff long mode is active. */
> -		ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
> -		ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
> -		ext.efer_lma = ____is_efer_lma(regs);
> -	}
> -
> -	return ext;
> -}
> -
>  static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
> -						   const struct kvm_mmu_role_regs *regs,
> -						   bool base_only)
> +						   const struct kvm_mmu_role_regs *regs)
>  {
>  	union kvm_mmu_role role = {0};
>  
>  	role.base.access = ACC_ALL;
>  	if (____is_cr0_pg(regs)) {
> +		role.ext.cr0_pg = 1;
>  		role.base.efer_nx = ____is_efer_nx(regs);
>  		role.base.cr0_wp = ____is_cr0_wp(regs);
> +
> +		role.ext.cr4_pae = ____is_cr4_pae(regs);
> +		role.ext.cr4_smep = ____is_cr4_smep(regs);
> +		role.ext.cr4_smap = ____is_cr4_smap(regs);
> +		role.ext.cr4_pse = ____is_cr4_pse(regs);
> +
> +		/* PKEY and LA57 are active iff long mode is active. */
> +		role.ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
> +		role.ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
> +		role.ext.efer_lma = ____is_efer_lma(regs);
>  	}
>  	role.base.smm = is_smm(vcpu);
>  	role.base.guest_mode = is_guest_mode(vcpu);
>  
> -	if (base_only)
> -		return role;
> -
> -	role.ext = kvm_calc_mmu_role_ext(vcpu, regs);
> -
>  	return role;
>  }
>  
> @@ -4716,10 +4700,9 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>  
>  static union kvm_mmu_role
>  kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
> -				const struct kvm_mmu_role_regs *regs,
> -				bool base_only)
> +				const struct kvm_mmu_role_regs *regs)
>  {
> -	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
> +	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs);
>  
>  	role.base.ad_disabled = (shadow_accessed_mask == 0);
>  	role.base.level = kvm_mmu_get_tdp_level(vcpu);
> @@ -4734,7 +4717,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
>  	union kvm_mmu_role new_role =
> -		kvm_calc_tdp_mmu_root_page_role(vcpu, regs, false);
> +		kvm_calc_tdp_mmu_root_page_role(vcpu, regs);
>  
>  	if (new_role.as_u64 == context->mmu_role.as_u64)
>  		return;
> @@ -4763,10 +4746,9 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
>  
>  static union kvm_mmu_role
>  kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
> -				      const struct kvm_mmu_role_regs *regs,
> -				      bool base_only)
> +				      const struct kvm_mmu_role_regs *regs)
>  {
> -	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
> +	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs);
>  
>  	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
>  	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
> @@ -4777,11 +4759,10 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
>  
>  static union kvm_mmu_role
>  kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
> -				   const struct kvm_mmu_role_regs *regs,
> -				   bool base_only)
> +				   const struct kvm_mmu_role_regs *regs)
>  {
>  	union kvm_mmu_role role =
> -		kvm_calc_shadow_root_page_role_common(vcpu, regs, base_only);
> +		kvm_calc_shadow_root_page_role_common(vcpu, regs);
>  
>  	role.base.direct = !____is_cr0_pg(regs);
>  
> @@ -4821,7 +4802,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
>  	union kvm_mmu_role new_role =
> -		kvm_calc_shadow_mmu_root_page_role(vcpu, regs, false);
> +		kvm_calc_shadow_mmu_root_page_role(vcpu, regs);
>  
>  	shadow_mmu_init_context(vcpu, context, regs, new_role);
>  
> @@ -4841,7 +4822,7 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
>  				   const struct kvm_mmu_role_regs *regs)
>  {
>  	union kvm_mmu_role role =
> -		kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
> +		kvm_calc_shadow_root_page_role_common(vcpu, regs);
>  
>  	role.base.direct = false;
>  	role.base.level = kvm_mmu_get_tdp_level(vcpu);
> @@ -4937,7 +4918,7 @@ kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *
>  {
>  	union kvm_mmu_role role;
>  
> -	role = kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
> +	role = kvm_calc_shadow_root_page_role_common(vcpu, regs);
>  
>  	/*
>  	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
> -- 
> 2.31.1
> 
> 
