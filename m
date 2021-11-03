Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3229C444A6D
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 22:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhKCVqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 17:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhKCVqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 17:46:10 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85756C06127A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 14:43:33 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id l8so4100764ilv.3
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 14:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EAi4O14LsoudO9jsmZ3QJYP/+NoLL/AWLs480HycinQ=;
        b=fSxWyheVmsuf33PjE4PH3p6+KEdCrGg8zI7nU0HsIoe+ImR3q5K+rCmodvf3bSnFAm
         FJ3RZgU4OxxM0Hr3+02Pu0ZLnQeOXNxKudpBn5V4EgAdJGQUH9YNicLnYSjMQOmh0Y1J
         1xOXcOIwAiTFiN4Z3CzVNH8acuOwNYQDz2pIhr9eaIh4yZ4Qo87t3kMBQjYj6zTyrLG0
         dmFe0OCdaI0BgJWhXryG9ILtGPKTkiKpQ6UYDs37tPVTydV3NbBpxCViyFwOWPi/ifnU
         3g3GVW3HcNyiCPnmR7HvrZ4msASErUyuEiTem1ccebp8f48eBZI2hqsZquWF+q6PSN2S
         V8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EAi4O14LsoudO9jsmZ3QJYP/+NoLL/AWLs480HycinQ=;
        b=ZMP9v/Hjl8czHUXwMuEapxiUTJrFI9YQhCkBcuhD8iuDNZuyYnb/SwaXGb/HFzFBf6
         51jStbSoWYe40asKcdl31xml70jFtnFraGgg+bB+RmJpUaIBIau2q5Bji+QD198ks0fl
         qX79K1EqrzAgHoOsKI/cSYHNLCp4/9FVz+OaBBCf0jsqEN0WitQbv+cTGwZ8hGthjAe4
         S3AfXmR0j7jjI22IE09zXERnUWauG1ySsXdUKmkBAZdQzQctScNoHAaYAQR/hHFj5DPQ
         8kO8XaupsUV9bH4ttcx+YoBfLzx2XAHdfYNr9GyuNxt80mmw6TRv+nr/rlIqa+qBYSDc
         gM8A==
X-Gm-Message-State: AOAM531Q+grpWN4QzPl1LyY36gJI1RPDKxjmWiGT7Ha5WjT9TZ3Z1MJa
        LiryZb5UuYsCYKo9u/g7L0ZJ3A==
X-Google-Smtp-Source: ABdhPJw7HeYm9XrJhcI2fUw5PAPlPlf2ovLgY6XpBZtaBpSDelIBs5dgmeFbRq/gAcTthkYfOGBf4w==
X-Received: by 2002:a05:6e02:216e:: with SMTP id s14mr14929682ilv.247.1635975812468;
        Wed, 03 Nov 2021 14:43:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id o14sm1623834ioo.36.2021.11.03.14.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 14:43:31 -0700 (PDT)
Date:   Wed, 3 Nov 2021 21:43:28 +0000
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
Subject: Re: [RFC PATCH 1/8] KVM: arm64: Factor out firmware register
 handling from psci.c
Message-ID: <YYMCgC6qMEEWhNrk@google.com>
References: <20211102002203.1046069-1-rananta@google.com>
 <20211102002203.1046069-2-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102002203.1046069-2-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Tue, Nov 02, 2021 at 12:21:56AM +0000, Raghavendra Rao Ananta wrote:
> Common hypercall firmware register handing is currently employed
> by psci.c. Since the upcoming patches add more of these registers,
> it's better to move the generic handling to hypercall.c for a
> cleaner presentation.
> 
> While we are at it, collect all the firmware registers under
> fw_reg_ids[] to help implement kvm_arm_get_fw_num_regs() and
> kvm_arm_copy_fw_reg_indices() in a generic way.
> 
> No functional change intended.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/guest.c       |   2 +-
>  arch/arm64/kvm/hypercalls.c  | 151 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/psci.c        | 167 +++--------------------------------
>  include/kvm/arm_hypercalls.h |   7 ++
>  include/kvm/arm_psci.h       |   8 +-
>  5 files changed, 172 insertions(+), 163 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5ce26bedf23c..625f97f7b304 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -18,7 +18,7 @@
>  #include <linux/string.h>
>  #include <linux/vmalloc.h>
>  #include <linux/fs.h>
> -#include <kvm/arm_psci.h>
> +#include <kvm/arm_hypercalls.h>
>  #include <asm/cputype.h>
>  #include <linux/uaccess.h>
>  #include <asm/fpsimd.h>
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 30da78f72b3b..d030939c5929 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -146,3 +146,154 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>  	return 1;
>  }
> +
> +static const u64 fw_reg_ids[] = {
> +	KVM_REG_ARM_PSCI_VERSION,
> +	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> +	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> +};
> +
> +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> +{
> +	return ARRAY_SIZE(fw_reg_ids);
> +}
> +
> +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
> +		if (put_user(fw_reg_ids[i], uindices))
> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}

It would appear that this patch is separating out the hypercall services
to each handle their own FW regs. At the same time, this is
consolidating the register enumeration into a single place.

It would be nice to keep the scoping consistent with your accessors
below, or simply just handle all regs in hypercalls.c. Abstracting
per-service might result in a lot of boilerplate, though.

> +#define KVM_REG_FEATURE_LEVEL_WIDTH	4
> +#define KVM_REG_FEATURE_LEVEL_MASK	(BIT(KVM_REG_FEATURE_LEVEL_WIDTH) - 1)
> +
> +/*
> + * Convert the workaround level into an easy-to-compare number, where higher
> + * values mean better protection.
> + */
> +static int get_kernel_wa_level(u64 regid)
> +{
> +	switch (regid) {
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> +		switch (arm64_get_spectre_v2_state()) {
> +		case SPECTRE_VULNERABLE:
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> +		case SPECTRE_MITIGATED:
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
> +		case SPECTRE_UNAFFECTED:
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
> +		}
> +		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> +		switch (arm64_get_spectre_v4_state()) {
> +		case SPECTRE_MITIGATED:
> +			/*
> +			 * As for the hypercall discovery, we pretend we
> +			 * don't have any FW mitigation if SSBS is there at
> +			 * all times.
> +			 */
> +			if (cpus_have_final_cap(ARM64_SSBS))
> +				return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> +			fallthrough;
> +		case SPECTRE_UNAFFECTED:
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
> +		case SPECTRE_VULNERABLE:
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	void __user *uaddr = (void __user *)(long)reg->addr;
> +	u64 val;
> +
> +	switch (reg->id) {
> +	case KVM_REG_ARM_PSCI_VERSION:
> +		val = kvm_psci_version(vcpu, vcpu->kvm);

Should this become kvm_arm_get_fw_reg() to consistently genericize the
PSCI FW register accessors?

> +		break;
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> +		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> +		break;
> +	default:
> +		return -ENOENT;
> +	}
> +
> +	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	void __user *uaddr = (void __user *)(long)reg->addr;
> +	u64 val;
> +	int wa_level;
> +
> +	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
> +
> +	switch (reg->id) {
> +	case KVM_REG_ARM_PSCI_VERSION:
> +		return kvm_arm_set_psci_fw_reg(vcpu, val);
> +
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> +		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
> +			return -EINVAL;
> +
> +		if (get_kernel_wa_level(reg->id) < val)
> +			return -EINVAL;
> +
> +		return 0;
> +
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> +		if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
> +			    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
> +			return -EINVAL;
> +
> +		/* The enabled bit must not be set unless the level is AVAIL. */
> +		if ((val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED) &&
> +		    (val & KVM_REG_FEATURE_LEVEL_MASK) != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL)
> +			return -EINVAL;
> +
> +		/*
> +		 * Map all the possible incoming states to the only two we
> +		 * really want to deal with.
> +		 */
> +		switch (val & KVM_REG_FEATURE_LEVEL_MASK) {
> +		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL:
> +		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN:
> +			wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> +			break;
> +		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
> +		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
> +			wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +		/*
> +		 * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
> +		 * other way around.
> +		 */
> +		if (get_kernel_wa_level(reg->id) < wa_level)
> +			return -EINVAL;
> +
> +		return 0;
> +	default:
> +		return -ENOENT;
> +	}
> +
> +	return -EINVAL;
> +}
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 74c47d420253..b9bcbc919b19 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -404,168 +404,25 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
>  	};
>  }
>  
> -int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> +int kvm_arm_set_psci_fw_reg(struct kvm_vcpu *vcpu, u64 val)
>  {
> -	return 3;		/* PSCI version and two workaround registers */
> -}
> -
> -int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> -{
> -	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices++))
> -		return -EFAULT;
> -
> -	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1, uindices++))
> -		return -EFAULT;
> -
> -	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> +	bool wants_02;
>  
> -#define KVM_REG_FEATURE_LEVEL_WIDTH	4
> -#define KVM_REG_FEATURE_LEVEL_MASK	(BIT(KVM_REG_FEATURE_LEVEL_WIDTH) - 1)
> -
> -/*
> - * Convert the workaround level into an easy-to-compare number, where higher
> - * values mean better protection.
> - */
> -static int get_kernel_wa_level(u64 regid)
> -{
> -	switch (regid) {
> -	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> -		switch (arm64_get_spectre_v2_state()) {
> -		case SPECTRE_VULNERABLE:
> -			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> -		case SPECTRE_MITIGATED:
> -			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
> -		case SPECTRE_UNAFFECTED:
> -			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
> -		}
> -		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> -	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> -		switch (arm64_get_spectre_v4_state()) {
> -		case SPECTRE_MITIGATED:
> -			/*
> -			 * As for the hypercall discovery, we pretend we
> -			 * don't have any FW mitigation if SSBS is there at
> -			 * all times.
> -			 */
> -			if (cpus_have_final_cap(ARM64_SSBS))
> -				return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> -			fallthrough;
> -		case SPECTRE_UNAFFECTED:
> -			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
> -		case SPECTRE_VULNERABLE:
> -			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> -		}
> -	}
> +	wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
>  
> -	return -EINVAL;
> -}
> -
> -int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> -{
> -	void __user *uaddr = (void __user *)(long)reg->addr;
> -	u64 val;
> -
> -	switch (reg->id) {
> -	case KVM_REG_ARM_PSCI_VERSION:
> -		val = kvm_psci_version(vcpu, vcpu->kvm);
> -		break;
> -	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> -	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> -		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> -		break;
> -	default:
> -		return -ENOENT;
> -	}
> -
> -	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
> -int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> -{
> -	void __user *uaddr = (void __user *)(long)reg->addr;
> -	u64 val;
> -	int wa_level;
> -
> -	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
> -		return -EFAULT;
> -
> -	switch (reg->id) {
> -	case KVM_REG_ARM_PSCI_VERSION:
> -	{
> -		bool wants_02;
> -
> -		wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
> -
> -		switch (val) {
> -		case KVM_ARM_PSCI_0_1:
> -			if (wants_02)
> -				return -EINVAL;
> -			vcpu->kvm->arch.psci_version = val;
> -			return 0;
> -		case KVM_ARM_PSCI_0_2:
> -		case KVM_ARM_PSCI_1_0:
> -			if (!wants_02)
> -				return -EINVAL;
> -			vcpu->kvm->arch.psci_version = val;
> -			return 0;
> -		}
> -		break;
> -	}
> -
> -	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> -		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
> -			return -EINVAL;
> -
> -		if (get_kernel_wa_level(reg->id) < val)
> +	switch (val) {
> +	case KVM_ARM_PSCI_0_1:
> +		if (wants_02)
>  			return -EINVAL;
> -
> +		vcpu->kvm->arch.psci_version = val;
>  		return 0;
> -
> -	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> -		if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
> -			    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
> -			return -EINVAL;
> -
> -		/* The enabled bit must not be set unless the level is AVAIL. */
> -		if ((val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED) &&
> -		    (val & KVM_REG_FEATURE_LEVEL_MASK) != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL)
> -			return -EINVAL;
> -
> -		/*
> -		 * Map all the possible incoming states to the only two we
> -		 * really want to deal with.
> -		 */
> -		switch (val & KVM_REG_FEATURE_LEVEL_MASK) {
> -		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL:
> -		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN:
> -			wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> -			break;
> -		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
> -		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
> -			wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
> -			break;
> -		default:
> -			return -EINVAL;
> -		}
> -
> -		/*
> -		 * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
> -		 * other way around.
> -		 */
> -		if (get_kernel_wa_level(reg->id) < wa_level)
> +	case KVM_ARM_PSCI_0_2:
> +	case KVM_ARM_PSCI_1_0:
> +		if (!wants_02)
>  			return -EINVAL;
> -
> +		vcpu->kvm->arch.psci_version = val;
>  		return 0;
>  	default:
> -		return -ENOENT;
> +		return -EINVAL;
>  	}
> -
> -	return -EINVAL;
>  }
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 0e2509d27910..5d38628a8d04 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -40,4 +40,11 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
>  	vcpu_set_reg(vcpu, 3, a3);
>  }
>  
> +struct kvm_one_reg;
> +
> +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> +int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> +int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> +
>  #endif
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 5b58bd2fe088..eddbd7d805e9 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -41,12 +41,6 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
>  
>  
>  int kvm_psci_call(struct kvm_vcpu *vcpu);
> -
> -struct kvm_one_reg;
> -
> -int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> -int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> -int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> -int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> +int kvm_arm_set_psci_fw_reg(struct kvm_vcpu *vcpu, u64 val);
>  
>  #endif /* __KVM_ARM_PSCI_H__ */
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
