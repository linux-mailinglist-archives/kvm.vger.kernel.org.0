Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C02442D5A0
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhJNJG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 05:06:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230094AbhJNJGV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 05:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634202256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ArdfMWNbuG02n1OQKPEk6jS02d/uCbdT+PSDgFpbJqI=;
        b=PnKbrHFCe5oJP0MoegCR/l+Agbzcv7SlMVLHjkkQIiNrhuLWzMOoCvYQhaJ3/3WLnJ0K4c
        X0L+SgZIJfdF9++/XnVEte3mOqT+MXS085CW0vMXs2Is5xv90jnqQLkHgt/3CD/gRxvHOf
        E5TpjDrbBD7ImRkoJ0eguknk21O+nQU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-Rla0I2qgN-iiNCKhj6zL6A-1; Thu, 14 Oct 2021 05:04:15 -0400
X-MC-Unique: Rla0I2qgN-iiNCKhj6zL6A-1
Received: by mail-ed1-f72.google.com with SMTP id l22-20020aa7c316000000b003dbbced0731so4632607edq.6
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 02:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ArdfMWNbuG02n1OQKPEk6jS02d/uCbdT+PSDgFpbJqI=;
        b=Zo2k+9ttnRtke9kyRcGyBcYH+/Emwdyfq9yPMFTGbakaDK0wmtIfEv7WLVixd/fBBQ
         2KHW1/2HvPR3IZr/cUWGyOXkw/L2STcidf1hCplcIyUUM39gjooHFe2LeZF7XMR2InSq
         P43G/wImQi+LPFuRwYhpBcGaCwINLSJXNAsMMTdncJA+DpmI7hujEBMg7p8lRTmrVWvf
         UzloDwbXcyCecPFQzquGM2HLJD51FLQtwzMhDUBB9rqaz8GluKaHrSydkireRmNyodDH
         7WcI6QQnCG2zqdEH7AEkRainge1Ycf7ULYBWY1D+SFc6z/u72OvQamZ93V73DDU4ocrR
         4v3g==
X-Gm-Message-State: AOAM533rb/eRZl79BpuWWseokWp/K24438KZK6IDKlsZn2XSxbvCHRKT
        iu1T1/iMxSj3JF6MG0MnAhOekK4PShFa2uljL79x08JG1oT6T0Ez65CHQu/2zvvxrAA36U88Jf+
        C3oCWYnEa9+5a
X-Received: by 2002:a17:906:480a:: with SMTP id w10mr2449897ejq.262.1634202254384;
        Thu, 14 Oct 2021 02:04:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx51QMjFB9Vzo1OSOWMnnTw0zDmc+1WIxFwXo1jS+FtYBu1RisLoBxSR9VmCwx+bPBhBVyTMQ==
X-Received: by 2002:a17:906:480a:: with SMTP id w10mr2449861ejq.262.1634202254160;
        Thu, 14 Oct 2021 02:04:14 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id ke12sm1431541ejc.32.2021.10.14.02.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 02:04:13 -0700 (PDT)
Date:   Thu, 14 Oct 2021 11:04:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        oupton@google.com, qperret@google.com, kernel-team@android.com,
        tabba@google.com
Subject: Re: [PATCH v9 13/22] KVM: arm64: pkvm: Use a single function to
 expose all id-regs
Message-ID: <20211014090411.dk2whm76hwsems6j@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013120346.2926621-3-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 01:03:37PM +0100, Marc Zyngier wrote:
> Rather than exposing a whole set of helper functions to retrieve
> individual ID registers, use the existing decoding tree and expose
> a single helper instead.
> 
> This allow a number of functions to be made static, and we now
> have a single entry point to maintain.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/sys_regs.h | 14 +-------
>  arch/arm64/kvm/hyp/nvhe/pkvm.c             | 10 +++---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c         | 37 ++++++++++++----------
>  3 files changed, 26 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h b/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
> index 3288128738aa..8adc13227b1a 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
> @@ -9,19 +9,7 @@
>  
>  #include <asm/kvm_host.h>
>  
> -u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64isar0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64mmfr1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu);

This is nice.

> -
> +u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
>  bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
>  int kvm_check_pvm_sysreg_table(void);
>  void inject_undef64(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 633547cc1033..62377fa8a4cb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -15,7 +15,7 @@
>   */
>  static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64pfr0(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
>  	u64 hcr_set = HCR_RW;
>  	u64 hcr_clear = 0;
>  	u64 cptr_set = 0;
> @@ -62,7 +62,7 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
>   */
>  static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64pfr1(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
>  	u64 hcr_set = 0;
>  	u64 hcr_clear = 0;
>  
> @@ -81,7 +81,7 @@ static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
>   */
>  static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64dfr0(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
>  	u64 mdcr_set = 0;
>  	u64 mdcr_clear = 0;
>  	u64 cptr_set = 0;
> @@ -125,7 +125,7 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
>   */
>  static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64mmfr0(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR0_EL1);
>  	u64 mdcr_set = 0;
>  
>  	/* Trap Debug Communications Channel registers */
> @@ -140,7 +140,7 @@ static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
>   */
>  static void pvm_init_traps_aa64mmfr1(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64mmfr1(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
>  	u64 hcr_set = 0;
>  
>  	/* Trap LOR */
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 6bde2dc5205c..f125d6a52880 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -82,7 +82,7 @@ static u64 get_restricted_features_unsigned(u64 sys_reg_val,
>   * based on allowed features, system features, and KVM support.
>   */
>  
> -u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
>  {
>  	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
>  	u64 set_mask = 0;
> @@ -103,7 +103,7 @@ u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
>  	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
>  }
>  
> -u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu)
>  {
>  	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
>  	u64 allow_mask = PVM_ID_AA64PFR1_ALLOW;
> @@ -114,7 +114,7 @@ u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu)
>  	return id_aa64pfr1_el1_sys_val & allow_mask;
>  }
>  
> -u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for Scalable Vectors, therefore, hyp has no sanitized
> @@ -124,7 +124,7 @@ u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for debug, including breakpoints, and watchpoints,
> @@ -134,7 +134,7 @@ u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for debug, therefore, hyp has no sanitized copy of the
> @@ -144,7 +144,7 @@ u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for implementation defined features, therefore, hyp has no
> @@ -154,7 +154,7 @@ u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for implementation defined features, therefore, hyp has no
> @@ -164,12 +164,12 @@ u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64isar0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64isar0(const struct kvm_vcpu *vcpu)
>  {
>  	return id_aa64isar0_el1_sys_val & PVM_ID_AA64ISAR0_ALLOW;
>  }
>  
> -u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu)
>  {
>  	u64 allow_mask = PVM_ID_AA64ISAR1_ALLOW;
>  
> @@ -182,7 +182,7 @@ u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu)
>  	return id_aa64isar1_el1_sys_val & allow_mask;
>  }
>  
> -u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
>  {
>  	u64 set_mask;
>  
> @@ -192,22 +192,19 @@ u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
>  	return (id_aa64mmfr0_el1_sys_val & PVM_ID_AA64MMFR0_ALLOW) | set_mask;
>  }
>  
> -u64 get_pvm_id_aa64mmfr1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64mmfr1(const struct kvm_vcpu *vcpu)
>  {
>  	return id_aa64mmfr1_el1_sys_val & PVM_ID_AA64MMFR1_ALLOW;
>  }
>  
> -u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu)
>  {
>  	return id_aa64mmfr2_el1_sys_val & PVM_ID_AA64MMFR2_ALLOW;
>  }
>  
> -/* Read a sanitized cpufeature ID register by its sys_reg_desc. */
> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> -		       struct sys_reg_desc const *r)
> +/* Read a sanitized cpufeature ID register by its encoding */
> +u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
> -	u32 id = reg_to_encoding(r);
> -
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
>  		return get_pvm_id_aa64pfr0(vcpu);
> @@ -245,6 +242,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> +		       struct sys_reg_desc const *r)
> +{
> +	return pvm_read_id_reg(vcpu, reg_to_encoding(r));
> +}
> +
>  /*
>   * Accessor for AArch32 feature id registers.
>   *
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

