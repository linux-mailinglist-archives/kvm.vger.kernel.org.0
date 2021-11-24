Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2827645CEBF
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 22:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243500AbhKXVKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 16:10:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234102AbhKXVKn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 16:10:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637788052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/RoszFU0XTK0aV/vu4I1mgmUsImsHFL9k+YboQn9sa0=;
        b=PzXcop0GK44pI4shn1pzqAFs2YzbOBmPhy4gDPrdvbbBHL64ZRNroXeRmarIXezCMgIKHN
        dVRm0oSC837PhZrqgc8wxi4uLMv6gAD/O+/3RmjBVFi/9CpU5igv6g3lHk/iebonrJ/R/K
        axLEvaV8Igi0EUKDzygNBUZLJqUrwbo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-MH_l0fnEOvuVz70p-gb-Sw-1; Wed, 24 Nov 2021 16:07:31 -0500
X-MC-Unique: MH_l0fnEOvuVz70p-gb-Sw-1
Received: by mail-wr1-f70.google.com with SMTP id d18-20020adfe852000000b001985d36817cso778212wrn.13
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 13:07:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/RoszFU0XTK0aV/vu4I1mgmUsImsHFL9k+YboQn9sa0=;
        b=7FvlzcICfvtoS6hi2PgBn9IHxdZPbzTW4BbnTwO2sAIZKR9ayOvgoJgimuZ1ddLTxR
         ku5AL0k2AG8IOo3h1JIya51Rg8PopUUbzBYhox6h1Agu+5mYu7vNQhXp81hW++IYf+9s
         tKGJLEyo4yImWhdvpEYMI+tuBMBgK2kK8/yAcxAkIfCvLadlVNHXORxFJYx2fsno3UxQ
         WuZOztIe6EBwe2hJOhsZErmwj6fmYtAqtqU31Ejd2JdfLVl+ba9v/8/mrbWo/XOPeUES
         uS8A32YHKaSg0F+wbZG7x8UqPFgVqZ+KFX1zVUxPrRbOMQbqQR9m4p60AhoG5YoKPfFD
         IK1A==
X-Gm-Message-State: AOAM531YOVVG3B8Af+ZwjLm5dUUSD0CbYkTHGW5glBvaxvJ7YtduIjJt
        8Rmx402/T6MfWSUK0ujz5NXbemM4dvBFLmxYhnAYgbC3evhBP5rwB6/7VK0CaDZDnY9Fx/lFuVP
        kf4kHLtCgQ1Hq
X-Received: by 2002:adf:ea51:: with SMTP id j17mr24095161wrn.421.1637788050080;
        Wed, 24 Nov 2021 13:07:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvtmp1vYY4JvJvhU7UCQah9E5DPqS6e1GV5BHuqB9k2zEOpJ9nLjJLltsjLvp7xxvv78snYw==
X-Received: by 2002:adf:ea51:: with SMTP id j17mr24095099wrn.421.1637788049731;
        Wed, 24 Nov 2021 13:07:29 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h17sm5823882wmb.44.2021.11.24.13.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 13:07:29 -0800 (PST)
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-4-reijiw@google.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <57519386-0a30-40a6-b46f-d20595df0b86@redhat.com>
Date:   Wed, 24 Nov 2021 22:07:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-4-reijiw@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> This patch lays the groundwork to make ID registers writable.
> 
> Introduce struct id_reg_info for an ID register to manage the
> register specific control of its value for the guest, and provide set
> of functions commonly used for ID registers to make them writable.
> 
> The id_reg_info is used to do register specific initialization,
> validation of the ID register and etc.  Not all ID registers must
> have the id_reg_info. ID registers that don't have the id_reg_info
> are handled in a common way that is applied to all ID registers.
> 
> At present, changing an ID register from userspace is allowed only
> if the ID register has the id_reg_info, but that will be changed
> by the following patches.
> 
> No ID register has the structure yet and the following patches
> will add the id_reg_info for some ID registers.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h |   1 +
>  arch/arm64/kvm/sys_regs.c       | 226 ++++++++++++++++++++++++++++++--
>  2 files changed, 218 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 16b3f1a1d468..597609f26331 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1197,6 +1197,7 @@
>  #define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
>  
>  #define ARM64_FEATURE_FIELD_BITS	4
> +#define ARM64_FEATURE_FIELD_MASK	((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
>  
>  /* Create a mask for the feature bits of the specified feature. */
>  #define ARM64_FEATURE_MASK(x)	(GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5608d3410660..1552cd5581b7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -265,6 +265,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>  		return read_zero(vcpu, p);
>  }
>  
> +/*
> + * A value for FCT_LOWER_SAFE must be zero and changing that will affect
> + * ftr_check_types of id_reg_info.
> + */
> +enum feature_check_type {
> +	FCT_LOWER_SAFE = 0,
> +	FCT_HIGHER_SAFE,
> +	FCT_HIGHER_OR_ZERO_SAFE,
> +	FCT_EXACT,
> +	FCT_EXACT_OR_ZERO_SAFE,
> +	FCT_IGNORE,	/* Don't check (any value is fine) */
> +};
> +
> +static int arm64_check_feature_one(enum feature_check_type type, int val,
> +				   int limit)
> +{
> +	bool is_safe = false;
> +
> +	if (val == limit)
> +		return 0;
> +
> +	switch (type) {
> +	case FCT_LOWER_SAFE:
> +		is_safe = (val <= limit);
> +		break;
> +	case FCT_HIGHER_OR_ZERO_SAFE:
> +		if (val == 0) {
> +			is_safe = true;
> +			break;
> +		}
> +		fallthrough;
> +	case FCT_HIGHER_SAFE:
> +		is_safe = (val >= limit);
> +		break;
> +	case FCT_EXACT:
> +		break;
> +	case FCT_EXACT_OR_ZERO_SAFE:
> +		is_safe = (val == 0);
> +		break;
> +	case FCT_IGNORE:
> +		is_safe = true;
> +		break;
> +	default:
> +		WARN_ONCE(1, "Unexpected feature_check_type (%d)\n", type);
> +		break;
> +	}
> +
> +	return is_safe ? 0 : -1;
> +}
> +
> +#define	FCT_TYPE_MASK		0x7
> +#define	FCT_TYPE_SHIFT		1
> +#define	FCT_SIGN_MASK		0x1
> +#define	FCT_SIGN_SHIFT		0
> +#define	FCT_TYPE(val)	((val >> FCT_TYPE_SHIFT) & FCT_TYPE_MASK)
> +#define	FCT_SIGN(val)	((val >> FCT_SIGN_SHIFT) & FCT_SIGN_MASK)
> +
> +#define	MAKE_FCT(shift, type, sign)				\
> +	((u64)((((type) & FCT_TYPE_MASK) << FCT_TYPE_SHIFT) |	\
> +	       (((sign) & FCT_SIGN_MASK) << FCT_SIGN_SHIFT)) << (shift))
> +
> +/* For signed field */
> +#define	S_FCT(shift, type)	MAKE_FCT(shift, type, 1)
> +/* For unigned field */
> +#define	U_FCT(shift, type)	MAKE_FCT(shift, type, 0)
> +
> +/*
> + * @val and @lim are both a value of the ID register. The function checks
> + * if all features indicated in @val can be supported for guests on the host,
> + * which supports features indicated in @lim. @check_types indicates how
> + * features in the ID register needs to be checked.
> + * See comments for id_reg_info's ftr_check_types field for more detail.
> + */
> +static int arm64_check_features(u64 check_types, u64 val, u64 lim)
> +{
> +	int i;
> +
> +	for (i = 0; i < 64; i += ARM64_FEATURE_FIELD_BITS) {
> +		u8 ftr_check = (check_types >> i) & ARM64_FEATURE_FIELD_MASK;
> +		bool is_sign = FCT_SIGN(ftr_check);
> +		enum feature_check_type fctype = FCT_TYPE(ftr_check);
> +		int fval, flim, ret;
> +
> +		fval = cpuid_feature_extract_field(val, i, is_sign);
> +		flim = cpuid_feature_extract_field(lim, i, is_sign);
> +
> +		ret = arm64_check_feature_one(fctype, fval, flim);
> +		if (ret)
> +			return -E2BIG;
nit: -EINVAL may be better because depending on the check type this may
not mean too big.

Eric
> +	}
> +	return 0;
> +}
> +
> +struct id_reg_info {
> +	u32	sys_reg;	/* Register ID */
> +
> +	/*
> +	 * Limit value of the register for a vcpu. The value is the sanitized
> +	 * system value with bits cleared for unsupported features for the
> +	 * guest.
> +	 */
> +	u64	vcpu_limit_val;
> +
> +	/*
> +	 * The ftr_check_types is comprised of a set of 4 bits fields.
> +	 * Each 4 bits field is for a feature indicated by the same bits
> +	 * field of the ID register and indicates how the feature support
> +	 * for guests needs to be checked.
> +	 * The bit 0 indicates that the corresponding ID register field
> +	 * is signed(1) or unsigned(0).
> +	 * The bits [3:1] hold feature_check_type for the field.
> +	 * If all zero, all features in the ID register are treated as unsigned
> +	 * fields and checked based on Principles of the ID scheme for fields
> +	 * in ID registers (FCT_LOWER_SAFE of feature_check_type).
> +	 */
> +	u64	ftr_check_types;
> +
> +	/* Initialization function of the id_reg_info */
> +	void (*init)(struct id_reg_info *id_reg);
> +
> +	/* Register specific validation function */
> +	int (*validate)(struct kvm_vcpu *vcpu, const struct id_reg_info *id_reg,
> +			u64 val);
> +
> +	/* Return the reset value of the register for the vCPU */
> +	u64 (*get_reset_val)(struct kvm_vcpu *vcpu,
> +			     const struct id_reg_info *id_reg);
> +};
> +
> +static void id_reg_info_init(struct id_reg_info *id_reg)
> +{
> +	id_reg->vcpu_limit_val = read_sanitised_ftr_reg(id_reg->sys_reg);
> +	if (id_reg->init)
> +		id_reg->init(id_reg);
> +}
> +
> +/*
> + * An ID register that needs special handling to control the value for the
> + * guest must have its own id_reg_info in id_reg_info_table.
> + * (i.e. the reset value is different from the host's sanitized value,
> + * the value is affected by opt-in features, some fields needs specific
> + * validation, etc.)
> + */
> +#define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
> +static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
> +
> +static int validate_id_reg(struct kvm_vcpu *vcpu,
> +			   const struct sys_reg_desc *rd, u64 val)
> +{
> +	u32 id = reg_to_encoding(rd);
> +	const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
> +	u64 limit, check_types;
> +	int err;
> +
> +	if (id_reg) {
> +		check_types = id_reg->ftr_check_types;
> +		limit = id_reg->vcpu_limit_val;
> +	} else {
> +		/* All fields are treated as unsigned and FCT_LOWER_SAFE */
> +		check_types = 0;
> +		limit = read_sanitised_ftr_reg(id);
> +	}
> +
> +	/* Check if the value indicates any feature that is not in the limit. */
> +	err = arm64_check_features(check_types, val, limit);
> +	if (err)
> +		return err;
> +
> +	if (id_reg && id_reg->validate)
> +		/* Run the ID register specific validity check. */
> +		err = id_reg->validate(vcpu, id_reg, val);
> +
> +	return err;
> +}
> +
>  /*
>   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
>   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> @@ -1183,11 +1358,19 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>  static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
>  {
>  	u32 id = reg_to_encoding(rd);
> +	struct id_reg_info *id_reg;
> +	u64 val;
>  
>  	if (vcpu_has_reset_once(vcpu))
>  		return;
>  
> -	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
> +	id_reg = GET_ID_REG_INFO(id);
> +	if (id_reg && id_reg->get_reset_val)
> +		val = id_reg->get_reset_val(vcpu, id_reg);
> +	else
> +		val = read_sanitised_ftr_reg(id);
> +
> +	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = val;
>  }
>  
>  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> @@ -1232,11 +1415,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -/*
> - * cpufeature ID register user accessors
> - *
> - * We don't allow the effective value to be changed.
> - */
> +/* cpufeature ID register user accessors */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
> @@ -1247,11 +1426,12 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  	return reg_to_user(uaddr, &val, id);
>  }
>  
> -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> +static int __set_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
>  	const u64 id = sys_reg_to_index(rd);
> +	u32 encoding = reg_to_encoding(rd);
>  	int err;
>  	u64 val;
>  
> @@ -1259,10 +1439,22 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
>  	if (err)
>  		return err;
>  
> -	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(vcpu, rd, raz))
> +	/* Don't allow to change the reg unless the reg has id_reg_info */
> +	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
>  		return -EINVAL;
>  
> +	if (raz)
> +		return 0;
> +
> +	/* Don't allow to change the reg after the first KVM_RUN. */
> +	if (vcpu->arch.has_run_once)> +		return -EINVAL;
> +
> +	err = validate_id_reg(vcpu, rd, val);
> +	if (err)
> +		return err;
> +
> +	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(encoding)) = val;
>  	return 0;
>  }
>  
> @@ -2826,6 +3018,20 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	return write_demux_regids(uindices);
>  }
>  
> +static void id_reg_info_init_all(void)
> +{
> +	int i;
> +	struct id_reg_info *id_reg;
> +
> +	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
> +		id_reg = (struct id_reg_info *)id_reg_info_table[i];
> +		if (!id_reg)
> +			continue;
> +
> +		id_reg_info_init(id_reg);
> +	}
> +}
> +
>  void kvm_sys_reg_table_init(void)
>  {
>  	unsigned int i;
> @@ -2860,4 +3066,6 @@ void kvm_sys_reg_table_init(void)
>  			break;
>  	/* Clear all higher bits. */
>  	cache_levels &= (1 << (i*3))-1;
> +
> +	id_reg_info_init_all();
>  }
> 

