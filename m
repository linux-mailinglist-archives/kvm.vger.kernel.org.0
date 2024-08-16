Return-Path: <kvm+bounces-24402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4634C954E49
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 17:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F18B8284FC4
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 15:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292541BE241;
	Fri, 16 Aug 2024 15:56:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9981B86FB;
	Fri, 16 Aug 2024 15:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723823791; cv=none; b=Bgn5WXDoQc/aXxeOMHgwctR8m7+zkToCUPq3qZKeS0s8Q8D+dt9rfST8GEOnNJHX9P8qkOiv7W2B0J4T79h3PltydQsvokLE5tSdX0HjWLJxIpznkdjAsZ66jMhSFacpcOc9QnTayC4hI/mbE6MV4GbAL/SXBZHC/L4MI20Hv0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723823791; c=relaxed/simple;
	bh=LJSlKhDs2xULF9oOdsbFHOVL0MfKa7F/Jn4NmxHc14Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=HlaIB+hJBWOJbeVrdjPNHZyW4xG214pgLJ190J7zAdLRvRU3tUmDn+rCvD75vLRBQ4kBUTTBlv5cnQQLrWqTApCcRMwzRJgt1nACBA/sAXIs1jwYwpv+OVWOE/Z8Jqt3v/ouME9a0eYNHXKRK6uAdGZYayWUTA/vz0KMj3rYf7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02A8A13D5;
	Fri, 16 Aug 2024 08:56:54 -0700 (PDT)
Received: from [10.1.34.14] (e122027.cambridge.arm.com [10.1.34.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF0D33F58B;
	Fri, 16 Aug 2024 08:56:24 -0700 (PDT)
Message-ID: <38fa2fd0-c03c-4dcb-814c-c7a397affc62@arm.com>
Date: Fri, 16 Aug 2024 16:56:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v4 01/15] arm64: rsi: Add RSI definitions
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-2-steven.price@arm.com>
 <a119ad47-11b7-42e5-a1e2-2706660c93d9@redhat.com>
Content-Language: en-GB
In-Reply-To: <a119ad47-11b7-42e5-a1e2-2706660c93d9@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

Sorry for the slow reply, I realised I'd never replied to this email.

On 23/07/2024 07:22, Gavin Shan wrote:
> On 7/1/24 7:54 PM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by a realm guest through SMC (Realm Services Interface) calls.
>>
>> The SMC definitions are based on DEN0137[1] version A-eac5.
>>
>> [1] https://developer.arm.com/documentation/den0137/latest
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v3:
>>   * Drop invoke_rsi_fn_smc_with_res() function and call arm_smccc_smc()
>>     directly instead.
>>   * Rename header guard in rsi_smc.h to be consistent.
>> Changes since v2:
>>   * Rename rsi_get_version() to rsi_request_version()
>>   * Fix size/alignment of struct realm_config
>> ---
>>   arch/arm64/include/asm/rsi_cmds.h |  38 ++++++++
>>   arch/arm64/include/asm/rsi_smc.h  | 142 ++++++++++++++++++++++++++++++
>>   2 files changed, 180 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/rsi_cmds.h
>>   create mode 100644 arch/arm64/include/asm/rsi_smc.h
>>
> 
> Some nits and questions like below.
> 
>> diff --git a/arch/arm64/include/asm/rsi_cmds.h
>> b/arch/arm64/include/asm/rsi_cmds.h
>> new file mode 100644
>> index 000000000000..89e907f3af0c
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rsi_cmds.h
>> @@ -0,0 +1,38 @@
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
>> +#endif
> 
> #endif /* __ASM_RSI_CMDS_H */
> 
>> diff --git a/arch/arm64/include/asm/rsi_smc.h
>> b/arch/arm64/include/asm/rsi_smc.h
>> new file mode 100644
>> index 000000000000..b3b3aff88f71
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rsi_smc.h
>> @@ -0,0 +1,142 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_RSI_SMC_H_
>> +#define __ASM_RSI_SMC_H_
>> +
>> +/*
>> + * This file describes the Realm Services Interface (RSI) Application
>> Binary
>> + * Interface (ABI) for SMC calls made from within the Realm to the
>> RMM and
>> + * serviced by the RMM.
>> + */
>> +
>> +#define SMC_RSI_CALL_BASE        0xC4000000
>> +
>> +/*
>> + * The major version number of the RSI implementation.  Increase this
>> whenever
>> + * the binary format or semantics of the SMC calls change.
>> + */
>> +#define RSI_ABI_VERSION_MAJOR        1
>> +
>> +/*
>> + * The minor version number of the RSI implementation.  Increase this
>> when
>> + * a bug is fixed, or a feature is added without breaking binary
>> compatibility.
>> + */
>> +#define RSI_ABI_VERSION_MINOR        0
>> +
>> +#define RSI_ABI_VERSION            ((RSI_ABI_VERSION_MAJOR << 16) | \
>> +                     RSI_ABI_VERSION_MINOR)
>> +
>> +#define RSI_ABI_VERSION_GET_MAJOR(_version) ((_version) >> 16)
>> +#define RSI_ABI_VERSION_GET_MINOR(_version) ((_version) & 0xFFFF)
>> +
>> +#define RSI_SUCCESS            0
>> +#define RSI_ERROR_INPUT            1
>> +#define RSI_ERROR_STATE            2
>> +#define RSI_INCOMPLETE            3
>> +
> 
> I think these return values are copied from
> tf-rmm/lib/smc/include/smc-rsi.h, but
> UL() prefix has been missed. It's still probably worthy to have it to
> indicate the
> width of the return values. Besides, it seems that RSI_ERROR_COUNT is
> also missed
> here.

The source of all these defines is the RMM spec[1], tf-rmm obviously
also has similar defines but I haven't been copying from there because
this code is intended to work with any RMM that complies with the spec.

In particular RSI_ERROR_COUNT isn't defined by the spec and we
(currently at least) have no use for it in Linux.

I'm not sure how much benefit the UL() prefix brings, but I've no
objection so I'll add it.

[1] https://developer.arm.com/documentation/den0137/latest

>> +#define SMC_RSI_FID(_x)            (SMC_RSI_CALL_BASE + (_x))
>> +
>> +#define SMC_RSI_ABI_VERSION            SMC_RSI_FID(0x190)
>> +
>> +/*
>> + * arg1 == Challenge value, bytes:  0 -  7
>> + * arg2 == Challenge value, bytes:  7 - 15
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
> 
> In tf-rmm/lib/smc/include/smc-rsi.h, it is SMC_RSI_ATTEST_TOKEN_INIT
> instead
> of SMC_RSI_ATTESTATION_TOKEN_INIT. The short description for all SMC

Here tf-rmm is deviating from the spec, the specification gives the long
form, so I'd prefer to stick to the spec unless we have a good reason
for deviating.

> calls have
> been dropped and I think they're worthy to be kept. At least, it helps
> readers
> to understand what the SMC call does. For this particular SMC call, the
> short
> description is something like below:
> 
> /*
>  * Initialize the operation to retrieve an attestation token.
>  * :
>  */

Fair point, I'll include the one-line descriptions from the spec
(although in most cases that level of detail is obvious from the name).

>> +/*
>> + * arg1 == The IPA of token buffer
>> + * arg2 == Offset within the granule of the token buffer
>> + * arg3 == Size of the granule buffer
>> + * ret0 == Status / error
>> + * ret1 == Length of token bytes copied to the granule buffer
>> + */
>> +#define SMC_RSI_ATTESTATION_TOKEN_CONTINUE    SMC_RSI_FID(0x195)
>> +
> 
> SMC_RSI_ATTEST_TOKEN_CONTINUE as defined in tf-rmm.

As above, the abbreviation isn't used in the spec.

>> +/*
>> + * arg1  == Index, which measurements slot to extend
>> + * arg2  == Size of realm measurement in bytes, max 64 bytes
>> + * arg3  == Measurement value, bytes:  0 -  7
>> + * arg4  == Measurement value, bytes:  7 - 15
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
>> + * arg1 == Index, which measurements slot to read
>> + * ret0 == Status / error
>> + * ret1 == Measurement value, bytes:  0 -  7
>> + * ret2 == Measurement value, bytes:  7 - 15
>> + * ret3 == Measurement value, bytes: 16 - 23
>> + * ret4 == Measurement value, bytes: 24 - 31
>> + * ret5 == Measurement value, bytes: 32 - 39
>> + * ret6 == Measurement value, bytes: 40 - 47
>> + * ret7 == Measurement value, bytes: 48 - 55
>> + * ret8 == Measurement value, bytes: 56 - 63
>> + */
>> +#define SMC_RSI_MEASUREMENT_READ        SMC_RSI_FID(0x192)
>> +
> 
> The order of these SMC call definitions are sorted based on their
> corresponding
> function IDs. For example, SMC_RSI_MEASUREMENT_READ would be appearing
> prior to
> SMC_RSI_MEASUREMENT_EXTEND.

Good spot - the spec annoyingly sorts alphabetically so I do struggle to
keep everything in the right order. Will fix.

>> +#ifndef __ASSEMBLY__
>> +
>> +struct realm_config {
>> +    union {
>> +        struct {
>> +            unsigned long ipa_bits; /* Width of IPA in bits */
>> +            unsigned long hash_algo; /* Hash algorithm */
>> +        };
>> +        u8 pad[0x1000];
>> +    };
>> +} __aligned(0x1000);
>> +
> 
> This describes the argument to SMC call RSI_REALM_CONFIG and its address
> needs to
> be aligned to 0x1000. Otherwise, RSI_ERROR_INPUT is returned. This maybe
> worthy
> a comment to explain it why we need 0x1000 alignment here.

Will add.

> It seems the only 4KB page size (GRANULE_SIZE) is supported by tf-rmm at
> present.
> The fixed alignment (0x1000) becomes broken if tf-rmm is extended to
> support
> 64KB in future. Maybe tf-rmm was designed to work with the minimal page
> size (4KB).

Again this is a specification requirement. The size of a granule is
always 4k - even if the host, guest or RMM choose to use a different
page size - the specification requires that the alignment is 4k. If a
larger page size is used in the RMM then it must jump through whatever
hoops are required to support the config address being only 4k aligned.

In practice there is a distinction between page size (which could vary
between the different components in the system) and granule size which
is the size which the physical memory can be switched between the
different PA spaces. The RMM specification defines the granule size as
4k (and doesn't provide any configurability of this), see section A2.2.
The system is expected to have a "GPT MMU" which controls which physical
address spaces each granule is visible in. There's quite a good
document[2] on the Arm website explaining this in more detail.

[2]
https://developer.arm.com/documentation/den0126/0100/Granule-Protection-Checks

Thanks,
Steve

>> +#endif /* __ASSEMBLY__ */
>> +
>> +/*
>> + * arg1 == struct realm_config addr
>> + * ret0 == Status / error
>> + */
>> +#define SMC_RSI_REALM_CONFIG            SMC_RSI_FID(0x196)
>> +
>> +/*
>> + * arg1 == Base IPA address of target region
>> + * arg2 == Top of the region
>> + * arg3 == RIPAS value
>> + * arg4 == flags
>> + * ret0 == Status / error
>> + * ret1 == Top of modified IPA range
>> + */
>> +#define SMC_RSI_IPA_STATE_SET            SMC_RSI_FID(0x197)
>> +
>> +#define RSI_NO_CHANGE_DESTROYED            0
>> +#define RSI_CHANGE_DESTROYED            1
>> +
>> +/*
>> + * arg1 == IPA of target page
>> + * ret0 == Status / error
>> + * ret1 == RIPAS value
>> + */
>> +#define SMC_RSI_IPA_STATE_GET            SMC_RSI_FID(0x198)
>> +
>> +/*
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


