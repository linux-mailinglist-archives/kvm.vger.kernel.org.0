Return-Path: <kvm+bounces-26101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5002971307
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 11:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2A581C209B3
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 09:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B55D1B2ED9;
	Mon,  9 Sep 2024 09:12:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09BDC1B1500;
	Mon,  9 Sep 2024 09:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725873153; cv=none; b=WcXzJBbqOqJTCinr64DoGWDcxjgsEkOkFq106sBs7PNrcqjnJr/iYoBMnap5j7YERe0GLudrvI6kOludUucKH8csn0vLoF5EmuL6I05HotTDYDSRI3ha1d0+WXRn+uQwCPHZV9RNDoO7bhtBasr1J50u1Wey+laL9768mokHbF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725873153; c=relaxed/simple;
	bh=mZifNs88hExMfQNezko5ETnWOiKsW5xtuzhY2WfF+v0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XSNzr3Hq2r4bskMM+vA+tL8baBGI0XRmGeL2I8Qtmh6IDtWjIEzPGTeFKeH/pF0Cvht4AN46ZPCXvCcLaI8yVBXEG4c4AwSJKuj7n/jySh/QO40P7KIFIUqxZ7Rc2nlCUkJADP435wtG/WfyJQUJ9PDAD94kcmgC2AtbY4Yx02s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D2A1FEC;
	Mon,  9 Sep 2024 02:12:57 -0700 (PDT)
Received: from [10.57.74.73] (unknown [10.57.74.73])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E1733F66E;
	Mon,  9 Sep 2024 02:12:25 -0700 (PDT)
Message-ID: <7b9a7d5b-ffd7-4add-88b4-fb5f1242c2ce@arm.com>
Date: Mon, 9 Sep 2024 10:12:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/19] arm64: rsi: Add RSI definitions
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-4-steven.price@arm.com>
 <c44e9d4f-9ad2-4ff7-9b18-ede351950149@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <c44e9d4f-9ad2-4ff7-9b18-ede351950149@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 09/09/2024 06:10, Gavin Shan wrote:
> On 8/19/24 11:19 PM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by a realm guest through SMC (Realm Services Interface) calls.
>>
>> The SMC definitions are based on DEN0137[1] version 1.0-rel0-rc1.
>>
>> [1]
>> https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v4:
>>   * Update to match the latest RMM spec version 1.0-rel0-rc1.
>>   * Make use of the ARM_SMCCC_CALL_VAL macro.
>>   * Cast using (_UL macro) various values to unsigned long.
>> Changes since v3:
>>   * Drop invoke_rsi_fn_smc_with_res() function and call arm_smccc_smc()
>>     directly instead.
>>   * Rename header guard in rsi_smc.h to be consistent.
>> Changes since v2:
>>   * Rename rsi_get_version() to rsi_request_version()
>>   * Fix size/alignment of struct realm_config
>> ---
>>   arch/arm64/include/asm/rsi_cmds.h | 136 +++++++++++++++++++++
>>   arch/arm64/include/asm/rsi_smc.h  | 189 ++++++++++++++++++++++++++++++
>>   2 files changed, 325 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/rsi_cmds.h
>>   create mode 100644 arch/arm64/include/asm/rsi_smc.h
>>
> 
> With the following minor comments addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redht.com>

Thanks for the review!

>> diff --git a/arch/arm64/include/asm/rsi_cmds.h
>> b/arch/arm64/include/asm/rsi_cmds.h
>> new file mode 100644
>> index 000000000000..968b03f4e703
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rsi_cmds.h
>> @@ -0,0 +1,136 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_RSI_CMDS_H
>> +#define __ASM_RSI_CMDS_H
>> +
>> +#include <linux/arm-smccc.h>
>> +
>> +#include <asm/rsi_smc.h>
>> +
>> +#define RSI_GRANULE_SHIFT        12
>> +#define RSI_GRANULE_SIZE        (_AC(1, UL) << RSI_GRANULE_SHIFT)
>> +
>> +enum ripas {
>> +    RSI_RIPAS_EMPTY = 0,
>> +    RSI_RIPAS_RAM = 1,
>> +    RSI_RIPAS_DESTROYED = 2,
>> +    RSI_RIPAS_IO = 3,
>> +};
>> +
> 
> The 'RSI_RIPAS_IO' corresponds to 'RIPAS_DEV' defined in
> tf-rmm/lib/s2tt/include/ripas.h.
> Shall we rename it to RSI_RIPAS_DEV so that the name is matched with
> that defined in
> tf-rmm?

Yes it should be renamed. This was posted based on the v1.0-rel0-rc1
spec and follows the naming there. But shortly after that spec was
released the decision to rename to RIPAS_DEV was made (as it's really
specifying that it's a device not that I/O is happening at an address).
I kept the naming to match the spec, but the next release of the spec
should have the RIPAS_DEV so I'll update to match that.

> ---> tf-rmm/lib/s2tt/include/ripas.h
> 
> /*
>  * The RmmRipas enumeration represents realm IPA state.
>  *
>  * Map RmmRipas to RmiRipas to simplify code/decode operations.
>  */
> enum ripas {
>         RIPAS_EMPTY = RMI_EMPTY,        /* Unused IPA for Realm */
>         RIPAS_RAM = RMI_RAM,            /* IPA used for Code/Data by
> Realm */
>         RIPAS_DESTROYED = RMI_DESTROYED,/* IPA is inaccessible to the
> Realm */
>         RIPAS_DEV                       /* Address where memory of an
> assigned
>                                            Realm device is mapped */
> };
> 
>> +static inline unsigned long rsi_request_version(unsigned long req,
>> +                        unsigned long *out_lower,
>> +                        unsigned long *out_higher)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_smc(SMC_RSI_ABI_VERSION, req, 0, 0, 0, 0, 0, 0, &res);
>> +
>> +    if (out_lower)
>> +        *out_lower = res.a1;
>> +    if (out_higher)
>> +        *out_higher = res.a2;
>> +
>> +    return res.a0;
>> +}
>> +
>> +static inline unsigned long rsi_get_realm_config(struct realm_config
>> *cfg)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_smc(SMC_RSI_REALM_CONFIG, virt_to_phys(cfg),
>> +              0, 0, 0, 0, 0, 0, &res);
>> +    return res.a0;
>> +}
>> +
>> +static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
>> +                             phys_addr_t end,
>> +                             enum ripas state,
>> +                             unsigned long flags,
>> +                             phys_addr_t *top)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_smc(SMC_RSI_IPA_STATE_SET, start, end, state,
>> +              flags, 0, 0, 0, &res);
>> +
>> +    if (top)
>> +        *top = res.a1;
>> +
>> +    return res.a0;
>> +}
>> +
>> +/**
>> + * rsi_attestation_token_init - Initialise the operation to retrieve an
>> + * attestation token.
>> + *
>> + * @challenge:    The challenge data to be used in the attestation token
>> + *        generation.
>> + * @size:    Size of the challenge data in bytes.
>> + *
>> + * Initialises the attestation token generation and returns an upper
>> bound
>> + * on the attestation token size that can be used to allocate an
>> adequate
>> + * buffer. The caller is expected to subsequently call
>> + * rsi_attestation_token_continue() to retrieve the attestation token
>> data on
>> + * the same CPU.
>> + *
>> + * Returns:
>> + *  On success, returns the upper limit of the attestation report size.
>> + *  Otherwise, -EINVAL
>> + */
>> +static inline unsigned long
>> +rsi_attestation_token_init(const u8 *challenge, unsigned long size)
>> +{
>> +    struct arm_smccc_1_2_regs regs = { 0 };
>> +
>> +    /* The challenge must be at least 32bytes and at most 64bytes */
>> +    if (!challenge || size < 32 || size > 64)
>> +        return -EINVAL;
>> +
>> +    regs.a0 = SMC_RSI_ATTESTATION_TOKEN_INIT;
>> +    memcpy(&regs.a1, challenge, size);
>> +    arm_smccc_1_2_smc(&regs, &regs);
>> +
>> +    if (regs.a0 == RSI_SUCCESS)
>> +        return regs.a1;
>> +
>> +    return -EINVAL;
>> +}
>> +
> 
> The type of the return value would be 'long' instead of 'unsigned long'
> since
> '-EINVAL' can be returned.

Good spot! The call site is casting back to long, so it "should work",
but clearly this is the wrong type.

>> +/**
>> + * rsi_attestation_token_continue - Continue the operation to
>> retrieve an
>> + * attestation token.
>> + *
>> + * @granule: {I}PA of the Granule to which the token will be written.
>> + * @offset:  Offset within Granule to start of buffer in bytes.
>> + * @size:    The size of the buffer.
>> + * @len:     The number of bytes written to the buffer.
>> + *
>> + * Retrieves up to a RSI_GRANULE_SIZE worth of token data per call.
>> The caller
>> + * is expected to call rsi_attestation_token_init() before calling this
>> + * function to retrieve the attestation token.
>> + *
>> + * Return:
>> + * * %RSI_SUCCESS     - Attestation token retrieved successfully.
>> + * * %RSI_INCOMPLETE  - Token generation is not complete.
>> + * * %RSI_ERROR_INPUT - A parameter was not valid.
>> + * * %RSI_ERROR_STATE - Attestation not in progress.
>> + */
>> +static inline int rsi_attestation_token_continue(phys_addr_t granule,
>> +                         unsigned long offset,
>> +                         unsigned long size,
>> +                         unsigned long *len)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_1_1_invoke(SMC_RSI_ATTESTATION_TOKEN_CONTINUE,
>> +                 granule, offset, size, 0, &res);
>> +
>> +    if (len)
>> +        *len = res.a1;
>> +    return res.a0;
>> +}
>> +
>> +#endif /* __ASM_RSI_CMDS_H */
>> diff --git a/arch/arm64/include/asm/rsi_smc.h
>> b/arch/arm64/include/asm/rsi_smc.h
>> new file mode 100644
>> index 000000000000..b76b03a8fea8
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rsi_smc.h
>> @@ -0,0 +1,189 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_RSI_SMC_H_
>> +#define __ASM_RSI_SMC_H_
>> +
>> +#include <linux/arm-smccc.h>
>> +
>> +/*
>> + * This file describes the Realm Services Interface (RSI) Application
>> Binary
>> + * Interface (ABI) for SMC calls made from within the Realm to the
>> RMM and
>> + * serviced by the RMM.
>> + */
>> +
>> +/*
>> + * The major version number of the RSI implementation.  This is
>> increased when
>> + * the binary format or semantics of the SMC calls change.
>> + */
>> +#define RSI_ABI_VERSION_MAJOR        UL(1)
>> +
>> +/*
>> + * The minor version number of the RSI implementation.  This is
>> increased when
>> + * a bug is fixed, or a feature is added without breaking binary
>> compatibility.
>> + */
>> +#define RSI_ABI_VERSION_MINOR        UL(0)
>> +
>> +#define RSI_ABI_VERSION            ((RSI_ABI_VERSION_MAJOR << 16) | \
>> +                     RSI_ABI_VERSION_MINOR)
>> +
>> +#define RSI_ABI_VERSION_GET_MAJOR(_version) ((_version) >> 16)
>> +#define RSI_ABI_VERSION_GET_MINOR(_version) ((_version) & 0xFFFF)
>> +
>> +#define RSI_SUCCESS        UL(0)
>> +#define RSI_ERROR_INPUT        UL(1)
>> +#define RSI_ERROR_STATE        UL(2)
>> +#define RSI_INCOMPLETE        UL(3)
>> +#define RSI_ERROR_UNKNOWN    UL(4)
>> +
>> +#define SMC_RSI_FID(n)       
>> ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,      \
>> +                           ARM_SMCCC_SMC_64,         \
>> +                           ARM_SMCCC_OWNER_STANDARD, \
>> +                           n)
>> +
>> +/*
>> + * Returns RSI version.
>> + *
>> + * arg1 == Requested interface revision
>> + * ret0 == Status /error
>> + * ret1 == Lower implemented interface revision
>> + * ret2 == Higher implemented interface revision
>> + */
>> +#define SMC_RSI_ABI_VERSION    SMC_RSI_FID(0x190)
>> +
>> +/*
>> + * Read feature register.
>> + *
>> + * arg1 == Feature register index
>> + * ret0 == Status /error
>               ^^^^^^^^^^^^^
>               Status / error

Ack

>> + * ret1 == Feature register value
>> + */
>> +#define SMC_RSI_FEATURES            SMC_RSI_FID(0x191)
>> +
>> +/*
>> + * Read measurement for the current Realm.
>> + *
>> + * arg1 == Index, which measurements slot to read
>> + * ret0 == Status / error
>> + * ret1 == Measurement value, bytes:  0 -  7
>> + * ret2 == Measurement value, bytes:  7 - 15
>                                          ^^^^^^
>                                          8 - 15
> 
>> + * ret3 == Measurement value, bytes: 16 - 23
>> + * ret4 == Measurement value, bytes: 24 - 31
>> + * ret5 == Measurement value, bytes: 32 - 39
>> + * ret6 == Measurement value, bytes: 40 - 47
>> + * ret7 == Measurement value, bytes: 48 - 55
>> + * ret8 == Measurement value, bytes: 56 - 63
>> + */
>> +#define SMC_RSI_MEASUREMENT_READ        SMC_RSI_FID(0x192)
>> +
>> +/*
>> + * Extend Realm Extensible Measurement (REM) value.
>> + *
>> + * arg1  == Index, which measurements slot to extend
>> + * arg2  == Size of realm measurement in bytes, max 64 bytes
>> + * arg3  == Measurement value, bytes:  0 -  7
>> + * arg4  == Measurement value, bytes:  7 - 15
>                                           ^^^^^^
>                                           8 - 15
> 
>> + * arg5  == Measurement value, bytes: 16 - 23
>> + * arg6  == Measurement value, bytes: 24 - 31
>> + * arg7  == Measurement value, bytes: 32 - 39
>> + * arg8  == Measurement value, bytes: 40 - 47
>> + * arg9  == Measurement value, bytes: 48 - 55
>> + * arg10 == Measurement value, bytes: 56 - 63
>> + * ret0  == Status / error
>> + */
>> +#define SMC_RSI_MEASUREMENT_EXTEND        SMC_RSI_FID(0x193)
>> +
>> +/*
>> + * Initialize the operation to retrieve an attestation token.
>> + *
>> + * arg1 == Challenge value, bytes:  0 -  7
>> + * arg2 == Challenge value, bytes:  7 - 15
>                                        ^^^^^^
>                                        8 - 15

One mistake and too much copy/pasting :(

>> + * arg3 == Challenge value, bytes: 16 - 23
>> + * arg4 == Challenge value, bytes: 24 - 31
>> + * arg5 == Challenge value, bytes: 32 - 39
>> + * arg6 == Challenge value, bytes: 40 - 47
>> + * arg7 == Challenge value, bytes: 48 - 55
>> + * arg8 == Challenge value, bytes: 56 - 63
>> + * ret0 == Status / error
>> + * ret1 == Upper bound of token size in bytes
>> + */
>> +#define SMC_RSI_ATTESTATION_TOKEN_INIT        SMC_RSI_FID(0x194)
>> +
>> +/*
>> + * Continue the operation to retrieve an attestation token.
>> + *
>> + * arg1 == The IPA of token buffer
>> + * arg2 == Offset within the granule of the token buffer
>> + * arg3 == Size of the granule buffer
>> + * ret0 == Status / error
>> + * ret1 == Length of token bytes copied to the granule buffer
>> + */
>> +#define SMC_RSI_ATTESTATION_TOKEN_CONTINUE    SMC_RSI_FID(0x195)
>> +
>> +#ifndef __ASSEMBLY__
>> +
>> +struct realm_config {
>> +    union {
>> +        struct {
>> +            unsigned long ipa_bits; /* Width of IPA in bits */
>> +            unsigned long hash_algo; /* Hash algorithm */
>> +        };
>> +        u8 pad[0x200];
>> +    };
>> +    union {
>> +        u8 rpv[64]; /* Realm Personalization Value */
>> +        u8 pad2[0xe00];
>> +    };
>> +    /*
>> +     * The RMM requires the configuration structure to be aligned to
>> a 4k
>> +     * boundary, ensure this happens by aligning this structure.
>> +     */
>> +} __aligned(0x1000);
>> +
>> +#endif /* __ASSEMBLY__ */
>> +
>> +/*
>> + * Read configuration for the current Realm.
>> + *
>> + * arg1 == struct realm_config addr
>> + * ret0 == Status / error
>> + */
>> +#define SMC_RSI_REALM_CONFIG            SMC_RSI_FID(0x196)
>> +
>> +/*
>> + * Request RIPAS of a target IPA range to be changed to a specified
>> value.
>> + *
>> + * arg1 == Base IPA address of target region
>> + * arg2 == Top of the region
>> + * arg3 == RIPAS value
>> + * arg4 == flags
>> + * ret0 == Status / error
>> + * ret1 == Top of modified IPA range
>> + */
>> +#define SMC_RSI_IPA_STATE_SET            SMC_RSI_FID(0x197)
>> +
>> +#define RSI_NO_CHANGE_DESTROYED            UL(0)
>> +#define RSI_CHANGE_DESTROYED            UL(1)
>> +
> 
> According to the linked specification, the description for the third
> return value
> has been missed here.
> 
> ret2 == Whether the host accepted or rejected the request

Worse than just a documentation error - I'd completely forgotten to
check this extra return value in rsi_set_addr_range_state(). Thanks for
spotting this!

Steve

>> +/*
>> + * Get RIPAS of a target IPA range.
>> + *
>> + * arg1 == Base IPA of target region
>> + * arg2 == End of target IPA region
>> + * ret0 == Status / error
>> + * ret1 == Top of IPA region which has the reported RIPAS value
>> + * ret2 == RIPAS value
>> + */
>> +#define SMC_RSI_IPA_STATE_GET            SMC_RSI_FID(0x198)
>> +
>> +/*
>> + * Make a Host call.
>> + *
>> + * arg1 == IPA of host call structure
>> + * ret0 == Status / error
>> + */
>> +#define SMC_RSI_HOST_CALL            SMC_RSI_FID(0x199)
>> +
>> +#endif /* __ASM_RSI_SMC_H_ */
> 
> Thanks,
> Gavin
> 


