Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F38444BE5
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhKDASg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbhKDASf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:18:35 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62147C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:15:58 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id n128so4954108iod.9
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Z+rx+jAjeNutkyFq4mEbDWMd5XalChM/Z873XpOBjg=;
        b=e1U4nMJaaNYM+fMmCokf1HZYE7dPfwz0SEDmiiGLADqYQTNOtVRA6VmXWC6MYLHHpI
         s0mgVVKOHqHP790zOllFN13eO0a1hvfWwl4o1P3+TRF+47qliBM/jDzEMFubx7Lt2mAB
         8/9sZAfCTYDKG2a1+XJXM9ICImE66K5nvXa910E0X7gI/bkOTp8LiVdqchA60KAtQnJV
         UtYTMYuU8uWsl+dWsajblV1i5d7ydIA/hY5k7acM1tRQ63fM3vuXFlBfUpjpsU0yOgML
         TW3CeQDPqHrHkOLLkwPApjmTXLCfhJI47xRAbSxuTEN9FHxKP3oShogm9HBFkKkEMv+y
         EWvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Z+rx+jAjeNutkyFq4mEbDWMd5XalChM/Z873XpOBjg=;
        b=RBcqEaRDZLJk+szsF0Pcnz3Nia/2GdP3c9F3H/qrSxdAbLpAqu2i0485v0ZjVjdTTY
         Y5lcrXFzA0763JxCh0lYl7bjQOjdrWLr+EKHiusm5VG2FkknXvcXtpql7KIuP/cUHmmq
         28NdlwdOTHIInikByEWbDRPlpXTmYMXjrSyOxvQ9CHDzWDfdUNJredATbEwrSam7r69H
         LeliDRd6gb7CtwWqXtP1bFhzeCiYCOtW/y1wc3dFUEGOqb6VOls5ohnrwF3SIrKc99YG
         u8Uqw0dPpWT5zLcz3/8SINqIMcCYrULMbxAbzv6cnvTg5hAX1p9Xt2W5bp38Z0cb6hFb
         KWoA==
X-Gm-Message-State: AOAM532cYEBjU6ENglzwt0K/0ytsr2YBDm/yBlmkA94FiKHHWejhOGZV
        Lu8LiqGi/lyP58Fpde65XwE8HQ==
X-Google-Smtp-Source: ABdhPJxHZXKUkiEhA45OQneC0k408DKCekOPldF8JFBv1SNiYgmomSQIm08ihVOPymgHSJWDM26q0g==
X-Received: by 2002:a05:6638:dd5:: with SMTP id m21mr1295157jaj.51.1635984957353;
        Wed, 03 Nov 2021 17:15:57 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id l14sm2026884iow.31.2021.11.03.17.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 17:15:56 -0700 (PDT)
Date:   Thu, 4 Nov 2021 00:15:53 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 3/8] KVM: arm64: Add standard secure service calls
 firmware register
Message-ID: <YYMmOTy6butWHYo+@google.com>
References: <20211102002203.1046069-1-rananta@google.com>
 <20211102002203.1046069-4-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102002203.1046069-4-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 12:21:58AM +0000, Raghavendra Rao Ananta wrote:
> Introduce a firmware register that encapsulates standard secure
> service calls (owner value 4) as a bitmap. Depending on how the
> user-space configures the register, the features will be enabled
> or disabled for the guest. Currently, this includes support only
> for ARM True Random Number Generator (TRNG) service, with bit-0
> of the register representing mandatory features of v1.0.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  Documentation/virt/kvm/arm/hypercalls.rst | 17 +++++
>  arch/arm64/include/asm/kvm_host.h         |  2 +
>  arch/arm64/include/uapi/asm/kvm.h         |  6 ++
>  arch/arm64/kvm/arm.c                      |  8 +++
>  arch/arm64/kvm/hypercalls.c               | 75 ++++++++++++++++++++++-
>  arch/arm64/kvm/trng.c                     |  9 +--
>  include/kvm/arm_hypercalls.h              |  5 ++
>  7 files changed, 113 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> index 85dfd682d811..1601919f256d 100644
> --- a/Documentation/virt/kvm/arm/hypercalls.rst
> +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> @@ -20,6 +20,14 @@ pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
>  interface. These registers can be saved/restored by userspace, and set
>  to a convenient value if required.
>  
> +The firmware register KVM_REG_ARM_STD exposes the hypercall services

nit: try to cram BITMAP in the name. IMO, this will help disambiguate
with version-based FW regs, like KVM_REG_ARM_PSCI_VERSION.

> +in the form of a feature bitmap. Upon VM creation, by default, KVM exposes
> +all the features to the guest, which can be learnt using GET_ONE_REG
> +interface. Conversely, the features can be enabled or disabled via the
> +SET_ONE_REG interface. These registers allow the user-space modification
> +only until the VM has started running, after which they turn to read-only
> +registers. SET_ONE_REG in this scenario will return -EBUSY.
> +
>  The following register is defined:
>  
>  * KVM_REG_ARM_PSCI_VERSION:
> @@ -74,4 +82,13 @@ The following register is defined:
>      KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
>        The workaround is always active on this vCPU or it is not needed.
>  
> +* KVM_REG_ARM_STD:
> +    Controls the bitmap of the ARM Standard Secure Service Calls.
> +
> +    The following bits are accepted:
> +
> +      KVM_REG_ARM_STD_TRNG_V1_0:

state the bit position as well

> +        The bit represents the services offered under v1.0 of ARM True Random Number Generator
> +        (TRNG) specification (ARM DEN 0098).
> +
>  .. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0b2502494a17..176d6be7b4da 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -105,6 +105,8 @@ struct kvm_arch_memory_slot {
>  struct hvc_reg_desc {
>  	bool write_disabled;
>  	bool write_attempted;
> +
> +	u64 kvm_std_bmap;
>  };
>  
>  struct kvm_arch {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..6387dea5396d 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -281,6 +281,12 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
>  
> +#define KVM_REG_ARM_STD			KVM_REG_ARM_FW_REG(3)
> +enum kvm_reg_arm_std_bmap {
> +	KVM_REG_ARM_STD_TRNG_V1_0,
> +	KVM_REG_ARM_STD_BMAP_MAX,
> +};
> +

I would recommend just defining the bit values explicitly rather than
using an enumeration:

  #define KVM_REG_ARM_STD_TRNG_V1_0	(1ULL << 0)

You do lose the convenience of having KVM_REG_ARM_STD_BMAP_MAX.

>  /* SVE registers */
>  #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f9a25e439e99..1cf58aa49222 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -130,6 +130,13 @@ static void set_default_spectre(struct kvm *kvm)
>  		kvm->arch.pfr0_csv3 = 1;
>  }
>  
> +static void set_default_hypercalls(struct kvm *kvm)
> +{
> +	struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
> +
> +	hvc_desc->kvm_std_bmap = ARM_SMCCC_STD_FEATURES;
> +}
> +
>  /**
>   * kvm_arch_init_vm - initializes a VM data structure
>   * @kvm:	pointer to the KVM struct
> @@ -156,6 +163,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
>  
>  	set_default_spectre(kvm);
> +	set_default_hypercalls(kvm);
>  
>  	return ret;
>  out_free_stage2_pgd:
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 7e873206a05b..0b3006353bf6 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -60,8 +60,64 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>  
>  static u64 *kvm_fw_reg_to_bmap(struct kvm *kvm, u64 fw_reg)
>  {
> -	/* No firmware registers supporting hvc bitmaps exits yet */
> -	return NULL;
> +	struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
> +
> +	switch (fw_reg) {
> +	case KVM_REG_ARM_STD:
> +		return &hvc_desc->kvm_std_bmap;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +struct kvm_hvc_func_map {
> +	u32 func_id;
> +	u64 bmap_bit;
> +};
> +
> +#define HVC_FUNC_MAP_DESC(func, bit)	\
> +	{					\
> +		.func_id = func,		\
> +		.bmap_bit = bit,		\
> +	}
> +
> +static const struct kvm_hvc_func_map hvc_std_map[] = {
> +	HVC_FUNC_MAP_DESC(ARM_SMCCC_TRNG_GET_UUID, KVM_REG_ARM_STD_TRNG_V1_0),
> +	HVC_FUNC_MAP_DESC(ARM_SMCCC_TRNG_RND32, KVM_REG_ARM_STD_TRNG_V1_0),
> +	HVC_FUNC_MAP_DESC(ARM_SMCCC_TRNG_RND64, KVM_REG_ARM_STD_TRNG_V1_0),
> +};
> +
> +bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u8 hvc_owner = ARM_SMCCC_OWNER_NUM(func_id);
> +	const struct kvm_hvc_func_map *hvc_func_map = NULL;
> +
> +	u64 fw_reg, *hc_bmap;
> +	unsigned int map_sz, i;
> +
> +	switch (hvc_owner) {
> +	case ARM_SMCCC_OWNER_STANDARD:
> +		fw_reg = KVM_REG_ARM_STD;
> +		hvc_func_map = hvc_std_map;
> +		map_sz = ARRAY_SIZE(hvc_std_map);
> +		break;
> +	default:
> +		/* Allow all the owners that aren't mapped */
> +		return true;
> +	}
> +
> +	hc_bmap = kvm_fw_reg_to_bmap(kvm, fw_reg);
> +	if (!hc_bmap)
> +		return true;
> +
> +	for (i = 0; i < map_sz; i++) {
> +		if (func_id == hvc_func_map[i].func_id)
> +			return *hc_bmap & BIT(hvc_func_map[i].bmap_bit);
> +	}

Hrm...

Could you instead define a helper function for each service and use a
switch statement to ensure each function tests the correct bit? This
would avoid the need to loop over a map.

> +
> +	/* Allow all the functions of an owner that aren't mapped */
> +	return true;
>  }
>  
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> @@ -71,6 +127,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	u32 feature;
>  	gpa_t gpa;
>  
> +	if (!kvm_hvc_call_supported(vcpu, func_id))
> +		goto out;
> +
>  	switch (func_id) {
>  	case ARM_SMCCC_VERSION_FUNC_ID:
>  		val[0] = ARM_SMCCC_VERSION_1_1;
> @@ -149,6 +208,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  		return kvm_psci_call(vcpu);
>  	}
>  
> +out:
>  	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>  	return 1;
>  }
> @@ -157,6 +217,7 @@ static const u64 fw_reg_ids[] = {
>  	KVM_REG_ARM_PSCI_VERSION,
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> +	KVM_REG_ARM_STD,

This (and all other FW regs you add) need to be added to the
get-reg-list selftest. Marc/Andrew have reminded me enough times to do
this myself, so I'll share suggestion :-P

>  };
>  
>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> @@ -219,6 +280,7 @@ static int get_kernel_wa_level(u64 regid)
>  
>  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
> +	struct hvc_reg_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
>  	void __user *uaddr = (void __user *)(long)reg->addr;
>  	u64 val;
>  
> @@ -230,6 +292,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
>  		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
>  		break;
> +	case KVM_REG_ARM_STD:
> +		val = hvc_desc->kvm_std_bmap;
> +		break;
>  	default:
>  		return -ENOENT;
>  	}
> @@ -352,6 +417,12 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  		if (get_kernel_wa_level(reg->id) < wa_level)
>  			return -EINVAL;
>  
> +		return 0;
> +	case KVM_REG_ARM_STD:
> +		if (val & ~ARM_SMCCC_STD_FEATURES)
> +			return -EINVAL;
> +
> +		hvc_desc->kvm_std_bmap = val;
>  		return 0;
>  	default:
>  		return -ENOENT;
> diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
> index 99bdd7103c9c..6dff765f5b9b 100644
> --- a/arch/arm64/kvm/trng.c
> +++ b/arch/arm64/kvm/trng.c
> @@ -60,14 +60,9 @@ int kvm_trng_call(struct kvm_vcpu *vcpu)
>  		val = ARM_SMCCC_TRNG_VERSION_1_0;
>  		break;
>  	case ARM_SMCCC_TRNG_FEATURES:
> -		switch (smccc_get_arg1(vcpu)) {
> -		case ARM_SMCCC_TRNG_VERSION:
> -		case ARM_SMCCC_TRNG_FEATURES:
> -		case ARM_SMCCC_TRNG_GET_UUID:
> -		case ARM_SMCCC_TRNG_RND32:
> -		case ARM_SMCCC_TRNG_RND64:
> +		if (kvm_hvc_call_supported(vcpu, smccc_get_arg1(vcpu)))
>  			val = TRNG_SUCCESS;
> -		}
> +
>  		break;
>  	case ARM_SMCCC_TRNG_GET_UUID:
>  		smccc_set_retval(vcpu, le32_to_cpu(u[0]), le32_to_cpu(u[1]),
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 5d38628a8d04..5f01bb139312 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -6,6 +6,9 @@
>  
>  #include <asm/kvm_emulate.h>
>  
> +#define ARM_SMCCC_STD_FEATURES \
> +	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_MAX - 1, 0)
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>  
>  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> @@ -47,4 +50,6 @@ int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
>  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>  
> +bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id);
> +
>  #endif
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
