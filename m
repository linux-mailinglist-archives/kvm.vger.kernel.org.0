Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E904A9F59
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 19:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377578AbiBDSmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 13:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356104AbiBDSmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 13:42:04 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA26C061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 10:42:04 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z5so5877814plg.8
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 10:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CT7Hm/Nr7YHrouVT14eiWQtHBeJqitv4EnDHr/IDEIg=;
        b=bekO2WJgXZCz4CENwlr9fHGuyddrnUUerNs1iE/u6JCb7n66SUK4eImfV+bJXJESx/
         E4sPqs1B3XCf2SX7rgHw2AApHouWd0i8ArytUxa5tbke5Ap5mdGyCuh+9SjQCISPvNQZ
         fMWKiJP4skz2JPJkyu7feLw7eFcAIxGLUn4LNhXcPdxOgW4nuFhEGBmU9ArBHVHrnt0l
         LPYXScBTCWwrZa3RD40whmBg6Ebf1CB1XAfThd6YlZvBVuSqGPf8gpuLrxWHiPLRGm8B
         5udeIv7QauaUVmzT/bl6D0IlLtG58KKh4aG1kSf4utuAu0/VVe/0Mr/DZzvpyjBYDul8
         3kVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CT7Hm/Nr7YHrouVT14eiWQtHBeJqitv4EnDHr/IDEIg=;
        b=bPLGPfbSlxIHEHrRc2yMytmPAcUYMoc7mH1X7KjDTI/HjP+vX5HpcloG26FfvOQm4L
         5lw7P6ycHgM2zvCB0omB2rlpFSsIuAasP/RoY5Bwpnw1YQgHCopdJOCxu/qiQD5Wm/ny
         /R8ykxf1uvs/sORfwnQZiB2wHO9quJy4Cg31vbs8aIZYt3nQANzKodugo1o/jWTtDrY+
         XOrk9cJUcX/1D7yOxJIVdhVFr3b5Iz8Sq0OU7A8uUqgYDJypIHTYO6qTCpMMlg6fuAGx
         PYplNmuqWJF8jSsEVOJMykDfsHWLJTyZFnwUBHiZ8amAAYonX1+DC7dFselLBXs/X2WX
         mbIg==
X-Gm-Message-State: AOAM532SRj9xgoX4icEgizjswNj32+TMrQDj89ldLjQUQyke2c4Lk0Lc
        zagWA2RB0QiHIfw7EYkAyWsWYQ==
X-Google-Smtp-Source: ABdhPJx3vpa7SWndvO37itrF3x3A7Pb4+SHxKZY4hkiVcj7zQLLeuxASQAj0EeglJ479OoahmmmjBA==
X-Received: by 2002:a17:90b:350c:: with SMTP id ls12mr352741pjb.44.1644000123888;
        Fri, 04 Feb 2022 10:42:03 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id ip5sm14483980pjb.13.2022.02.04.10.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:42:02 -0800 (PST)
Date:   Fri, 4 Feb 2022 18:41:59 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 04/23] KVM: MMU: constify uses of struct kvm_mmu_role_regs
Message-ID: <Yf1zd4urw8Jro5mi@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-5-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:56:59AM -0500, Paolo Bonzini wrote:
> struct kvm_mmu_role_regs is computed just once and then accessed.  Use
> const to enforce this.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0039b2f21286..3add9d8b0630 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -208,7 +208,7 @@ struct kvm_mmu_role_regs {
>   * the single source of truth for the MMU's state.
>   */
>  #define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
> -static inline bool __maybe_unused ____is_##reg##_##name(struct kvm_mmu_role_regs *regs)\
> +static inline bool __maybe_unused ____is_##reg##_##name(const struct kvm_mmu_role_regs *regs)\
>  {									\
>  	return !!(regs->reg & flag);					\
>  }
> @@ -255,7 +255,7 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
>  	return regs;
>  }
>  
> -static int role_regs_to_root_level(struct kvm_mmu_role_regs *regs)
> +static int role_regs_to_root_level(const struct kvm_mmu_role_regs *regs)
>  {
>  	if (!____is_cr0_pg(regs))
>  		return 0;
> @@ -4666,7 +4666,7 @@ static void paging32_init_context(struct kvm_mmu *context)
>  }
>  
>  static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
> -							 struct kvm_mmu_role_regs *regs)
> +							 const struct kvm_mmu_role_regs *regs)
>  {
>  	union kvm_mmu_extended_role ext = {0};
>  
> @@ -4687,7 +4687,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
>  }
>  
>  static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
> -						   struct kvm_mmu_role_regs *regs,
> +						   const struct kvm_mmu_role_regs *regs,
>  						   bool base_only)
>  {
>  	union kvm_mmu_role role = {0};
> @@ -4723,7 +4723,8 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>  
>  static union kvm_mmu_role
>  kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
> -				struct kvm_mmu_role_regs *regs, bool base_only)
> +				const struct kvm_mmu_role_regs *regs,
> +				bool base_only)
>  {
>  	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
>  
> @@ -4769,7 +4770,8 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  
>  static union kvm_mmu_role
>  kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
> -				      struct kvm_mmu_role_regs *regs, bool base_only)
> +				      const struct kvm_mmu_role_regs *regs,
> +				      bool base_only)
>  {
>  	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
>  
> @@ -4782,7 +4784,8 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
>  
>  static union kvm_mmu_role
>  kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
> -				   struct kvm_mmu_role_regs *regs, bool base_only)
> +				   const struct kvm_mmu_role_regs *regs,
> +				   bool base_only)
>  {
>  	union kvm_mmu_role role =
>  		kvm_calc_shadow_root_page_role_common(vcpu, regs, base_only);
> @@ -4940,7 +4943,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
>  }
>  
>  static union kvm_mmu_role
> -kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, struct kvm_mmu_role_regs *regs)
> +kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
>  {
>  	union kvm_mmu_role role;
>  
> -- 
> 2.31.1
> 
> 
