Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC54F4AA024
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 20:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiBDTdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 14:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbiBDTdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 14:33:01 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4079C061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 11:33:00 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cx3-20020a17090afd8300b001b87b9c0247so33135pjb.0
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 11:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=afvbo3MExCet85K9ykqiKWxvGxx3EQ6ll0RfZSv5ATY=;
        b=Y6hRGcw7JDyrO6Qt4pybwXKtBKWapEiBN1uRlSAOSSnW0NP9uCEsOL9ksjE5nKqI4I
         8UpqtkotVEntfIVWn8pg14q48fr1YT8TIY6fzBO/FgeMOyGT2BDfoN/Hrq8WVko5RCyP
         dIp9rMlod/0SZupUV+c87U9rRQk3t82baZs8PFUi8sJ3OaIuUco/mJIjzJRVAMwxQxja
         gzDvmxQ/UQk0Qj6l+UxkkhV1ymJ0QxYVbpPYpK1erVJVXFmuDlPk19KQfiEP92Q/gOU5
         yQ0erULE33JDzTKzRL23hmgcikafLrtP1mDS1kxSO7Gpi6EINbSBJtxeMlP8H88Py2yL
         5pFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=afvbo3MExCet85K9ykqiKWxvGxx3EQ6ll0RfZSv5ATY=;
        b=LLfnNY+ozeivkK6kf3LTuwIqlSKcMKKfSn06eyDfDKzE+hiG/zPq6OQ4HCxQ7PSCxm
         cew4nHiB/n2cZCtTtJSEj/OtUlaYkuf0Xjrrnkv+YdVA7r5ZVHyPjjdgCVB3q4ZLOo7t
         4rFcuYXavF4Azn3monXW9G0n81T4T020tWe3MKlSPMhY0orXozjmLPmDSvsaeBlMBECH
         0xPF8fgxuXIwt8YNOH64jgGWV4b3G9mnFo4diR+YyhBnO5VI0n4bPYzGLAERVhGja3Mc
         UcafXRMivzEvBAIqL74U3YUCoWH+c+b3K1seT0rldsKlL5x528kBg+645w5a/iLJ9e7c
         6dCQ==
X-Gm-Message-State: AOAM530IuFOOFufLw/9yBwO1fTHeiBB0PJA3wykxih4Uilb+e6bDGWhs
        c290/IGCUASfBz+v9KXS6aQPIw==
X-Google-Smtp-Source: ABdhPJzTRpjZla1zRvutupFWXiCQIhoIaSa4rcgEMrvw/S3QA9UD0XcXxYLbTbNy9VTaSt2FzESm0A==
X-Received: by 2002:a17:902:8a97:: with SMTP id p23mr4849333plo.26.1644003180248;
        Fri, 04 Feb 2022 11:33:00 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id f9sm2227406pgf.94.2022.02.04.11.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 11:32:59 -0800 (PST)
Date:   Fri, 4 Feb 2022 19:32:55 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 07/23] KVM: MMU: remove kvm_mmu_calc_root_page_role
Message-ID: <Yf1/ZyrPufhHKEep@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-8-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:57:02AM -0500, Paolo Bonzini wrote:
> Since the guest PGD is now loaded after the MMU has been set up
> completely, the desired role for a cache hit is simply the current
> mmu_role.  There is no need to compute it again, so __kvm_mmu_new_pgd
> can be folded in kvm_mmu_new_pgd.
> 
> As an aside, the !tdp_enabled case in the function was dead code,
> and that also gets mopped up as a side effect.

Couldn't the !tdp_enabled case be called via kvm_set_cr3() ->
kvm_mmu_new_pgd()?

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 29 ++++-------------------------
>  1 file changed, 4 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b8ab16323629..42475e4c2a48 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -190,8 +190,6 @@ struct kmem_cache *mmu_page_header_cache;
>  static struct percpu_counter kvm_total_used_mmu_pages;
>  
>  static void mmu_spte_set(u64 *sptep, u64 spte);
> -static union kvm_mmu_page_role
> -kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
>  
>  struct kvm_mmu_role_regs {
>  	const unsigned long cr0;
> @@ -4159,9 +4157,9 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  	return false;
>  }
>  
> -static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
> -			      union kvm_mmu_page_role new_role)
> +void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
>  {
> +	union kvm_mmu_page_role new_role = vcpu->arch.mmu->mmu_role.base;

nit: Blank line after variable declarations.

>  	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
>  		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
>  		return;
> @@ -4196,11 +4194,6 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  		__clear_sp_write_flooding_count(
>  				to_shadow_page(vcpu->arch.mmu->root_hpa));
>  }
> -
> -void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
> -{
> -	__kvm_mmu_new_pgd(vcpu, new_pgd, kvm_mmu_calc_root_page_role(vcpu));
> -}
>  EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
>  
>  static unsigned long get_cr3(struct kvm_vcpu *vcpu)
> @@ -4871,7 +4864,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>  
>  	shadow_mmu_init_context(vcpu, context, &regs, new_role);
>  	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
> -	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
> +	kvm_mmu_new_pgd(vcpu, nested_cr3);
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
>  
> @@ -4923,7 +4916,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  		reset_ept_shadow_zero_bits_mask(context, execonly);
>  	}
>  
> -	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
> +	kvm_mmu_new_pgd(vcpu, new_eptp);
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
>  
> @@ -5009,20 +5002,6 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_mmu);
>  
> -static union kvm_mmu_page_role
> -kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
> -	union kvm_mmu_role role;
> -
> -	if (tdp_enabled)
> -		role = kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, true);
> -	else
> -		role = kvm_calc_shadow_mmu_root_page_role(vcpu, &regs, true);
> -
> -	return role.base;
> -}
> -
>  void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	/*
> -- 
> 2.31.1
> 
> 
