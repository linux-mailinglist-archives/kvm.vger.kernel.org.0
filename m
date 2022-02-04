Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D49F4A9E7B
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 18:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355839AbiBDR7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 12:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377256AbiBDR7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 12:59:53 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18443C06173D
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 09:59:53 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id x11so5793311plg.6
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 09:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/2JNsgf3kaNUNazBKVI3tgRqtSJ9a/7dAGZoZ0RBSN0=;
        b=plcocTC9b78RDpVYudl/jaGbyjvz/FUhlTJmVZE5hnEUfZmbP6nvfWKEvGLv876o+z
         9zdtnnRGhIYfRNPQ1QIkSFGxS9YW+JxF1csqOIyh3cd6D9F8rqu83HBATqrE7JZ7Tg/J
         n/6BCD/1zUGlor/THn8gSOVztoXqXCD+60pfthrBRGOQyrkWLnIxkWheR3Oa/XreYvOO
         IhkssPKJ55XE02XyuKucleWQPImLhga5+CZ4qPn80nifLHK7iuUVNeJ7CXPWa4IAWjBK
         eEi4UzY+nr8GyqDvBI7FEA65oJ7mme+sREeuZQ9/t5+IGClPYiB1J35QNwl8Yvmler6b
         HUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/2JNsgf3kaNUNazBKVI3tgRqtSJ9a/7dAGZoZ0RBSN0=;
        b=H+8LP0rsfgjzmAUuRQL0kwNVMRi0BdwLzgyEtXXxXskK3NfcO5iI8PsYuy6uNh99EF
         4K/Q1DV1pEEZ1npD4sipctJ18gz3xUvH5EZoigKz4nqVx9kjRfYaDsWM2dd+GCVA3N1M
         NaGaflyZol2YrptJUWdYCiaEQeSCSuuy4gOXrh5tUCbKNipdfAllYjE/x72CSGRSb9Mf
         X5VoZ02vSZ6+dUWrGoJoKmECzSTF0tYyo4VW0OZZA0+qcG1zaidYdHFPFAbtwBFnEjEm
         GBReCuiQSAK+5IrZeQMl3Dzihg6Nmc6Gnev1cDfFeeXHrqNc4Cuw2i8wPH/8bOREoK1t
         ltlw==
X-Gm-Message-State: AOAM530RBLmHtb2f8YjHfaFWX0LVH4a6mvCoSr+Mx0lMt9op4uqjd6v4
        ZF18Cmj6WLk75ylYiv7wGR3S94yk+f9LYA==
X-Google-Smtp-Source: ABdhPJzt5XYWNvw/S8Xij4phdCifKgtyFrDcyAbXvHWOXY8+f8papHzs8kxE7NW9u15Hi72mzumPAA==
X-Received: by 2002:a17:902:7603:: with SMTP id k3mr4595813pll.160.1643997592328;
        Fri, 04 Feb 2022 09:59:52 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id c2sm2155220pgi.55.2022.02.04.09.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 09:59:51 -0800 (PST)
Date:   Fri, 4 Feb 2022 17:59:47 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 01/23] KVM: MMU: pass uses_nx directly to
 reset_shadow_zero_bits_mask
Message-ID: <Yf1pk1EEBXj0O0/p@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:56:56AM -0500, Paolo Bonzini wrote:
> reset_shadow_zero_bits_mask has a very unintuitive way of deciding
> whether the shadow pages will use the NX bit.  The function is used in
> two cases, shadow paging and shadow NPT; shadow paging has a use for
> EFER.NX and needs to force it enabled, while shadow NPT only needs it
> depending on L1's setting.
> 
> The actual root problem here is that is_efer_nx, despite being part
> of the "base" role, only matches the format of the shadow pages in the
> NPT case.  For now, just remove the ugly variable initialization and move
> the call to reset_shadow_zero_bits_mask out of shadow_mmu_init_context.
> The parameter can then be removed after the root problem in the role
> is fixed.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

(I agree this commit makes no functional change.)

> ---
>  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 296f8723f9ae..9424ae90f1ef 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4410,18 +4410,9 @@ static inline u64 reserved_hpa_bits(void)
>   * follow the features in guest.
>   */
>  static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
> -					struct kvm_mmu *context)
> +					struct kvm_mmu *context,
> +					bool uses_nx)
>  {
> -	/*
> -	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
> -	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
> -	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
> -	 * The iTLB multi-hit workaround can be toggled at any time, so assume
> -	 * NX can be used by any non-nested shadow MMU to avoid having to reset
> -	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
> -	 */
> -	bool uses_nx = is_efer_nx(context) || !tdp_enabled;
> -
>  	/* @amd adds a check on bit of SPTEs, which KVM shouldn't use anyways. */
>  	bool is_amd = true;
>  	/* KVM doesn't use 2-level page tables for the shadow MMU. */
> @@ -4829,8 +4820,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
>  
>  	reset_guest_paging_metadata(vcpu, context);
>  	context->shadow_root_level = new_role.base.level;
> -
> -	reset_shadow_zero_bits_mask(vcpu, context);
>  }
>  
>  static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
> @@ -4841,6 +4830,16 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
>  		kvm_calc_shadow_mmu_root_page_role(vcpu, regs, false);
>  
>  	shadow_mmu_init_context(vcpu, context, regs, new_role);
> +
> +	/*
> +	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
> +	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
> +	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
> +	 * The iTLB multi-hit workaround can be toggled at any time, so assume
> +	 * NX can be used by any non-nested shadow MMU to avoid having to reset
> +	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
> +	 */
> +	reset_shadow_zero_bits_mask(vcpu, context, true);
>  }
>  
>  static union kvm_mmu_role
> @@ -4872,6 +4871,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>  	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
>  
>  	shadow_mmu_init_context(vcpu, context, &regs, new_role);
> +	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));

Out of curiousity, how does KVM mitigate iTLB multi-hit when shadowing
NPT and the guest has not enabled EFER.NX?

>  }
>  EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
>  
> -- 
> 2.31.1
> 
> 
