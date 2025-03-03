Return-Path: <kvm+bounces-39889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E40A4C42D
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 16:06:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09DB03A84AC
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7436A213248;
	Mon,  3 Mar 2025 15:05:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76DAA156F5E;
	Mon,  3 Mar 2025 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741014336; cv=none; b=jPpMJgwnTHbMnmg/xyLaq/HtfPqy6Fu2CpEh7R7A1tWJN41FsC9S7F6K7/l5UndB7KDRQr4jvbQLZrw2KE2na6yhvLC9ZjynzFSb3Fy4R3GvB3ZVwIAybDWAfMjXhQYxZMReMvNYb3vnT9mk1SPMArm8Z0lxK5VJB+mW/b4MUg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741014336; c=relaxed/simple;
	bh=1sFtJ7G8T2gULGkEX+wJ+5Cx5/yoOS5AhTqUPY1T+Bo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q+xtorC5cS2MDgfIbcLASFqyN2u3J4vISn/4wjtHQH2BdPOebZmV2m2cYF/ZGd3DnGW5Jft9r0dnDJ32rVUhUa7i9GWEoKLnmy5ioCzqh4wbAt3OL9fiZtLq4Lob3zLdTN9ScZfc4pcPxztfpYHASSw1W8dmtcFWIcOSgPKrD1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE735106F;
	Mon,  3 Mar 2025 07:05:47 -0800 (PST)
Received: from [10.1.39.33] (e122027.cambridge.arm.com [10.1.39.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE1793F5A1;
	Mon,  3 Mar 2025 07:05:29 -0800 (PST)
Message-ID: <59f84354-e890-48c8-ba06-87dda471f364@arm.com>
Date: Mon, 3 Mar 2025 15:05:25 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/45] arm64: RME: Add wrappers for RMI calls
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-6-steven.price@arm.com>
 <8f08b96b-8219-4d51-8f46-bc367bbf2031@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8f08b96b-8219-4d51-8f46-bc367bbf2031@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03/03/2025 03:42, Gavin Shan wrote:
> On 2/14/25 2:13 AM, Steven Price wrote:
>> The wrappers make the call sites easier to read and deal with the
>> boiler plate of handling the error codes from the RMM.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes from v5:
>>   * Further improve comments
>> Changes from v4:
>>   * Improve comments
>> Changes from v2:
>>   * Make output arguments optional.
>>   * Mask RIPAS value rmi_rtt_read_entry()
>>   * Drop unused rmi_rtt_get_phys()
>> ---
>>   arch/arm64/include/asm/rmi_cmds.h | 508 ++++++++++++++++++++++++++++++
>>   1 file changed, 508 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>>
> 
> With the following nitpicks addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks, there were a couple of other pages and params_ptr references
that I've updated to granules and just 'params' too now. With hindsight
conflating pages and granules in the earlier versions of this series was
a big mistake ;)

Steve

>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/
>> asm/rmi_cmds.h
>> new file mode 100644
>> index 000000000000..043b7ff278ee
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rmi_cmds.h
>> @@ -0,0 +1,508 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_RMI_CMDS_H
>> +#define __ASM_RMI_CMDS_H
>> +
> 
> [...]
> 
>> +
>> +/**
>> + * rmi_rec_aux_count() - Get number of auxiliary granules required
>> + * @rd: PA of the RD
>> + * @aux_count: Number of pages written to this pointer
>                   ^^^^^^^^^^^^^^^
>                   Number of granules
>> + *
>> + * A REC may require extra auxiliary pages to be delegated for the
>> RMM to
>                                         ^^^^^
>                                         granules
> 
>> + * store metadata (not visible to the normal world) in. This function
>> provides
>> + * the number of pages that are required.
>                     ^^^^^
>                     granules
>> + *
>> + * Return: RMI return code
>> + */
>> +static inline int rmi_rec_aux_count(unsigned long rd, unsigned long
>> *aux_count)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
>> +
>> +    if (aux_count)
>> +        *aux_count = res.a1;
>> +    return res.a0;
>> +}
>> +
>> +/**
>> + * rmi_rec_create() - Create a REC
>> + * @rd: PA of the RD
>> + * @rec: PA of the target REC
>> + * @params_ptr: PA of REC parameters
>> + *
>> + * Create a REC using the parameters specified in the struct
>> rec_params pointed
>> + * to by @params_ptr.
>> + *
>> + * Return: RMI return code
>> + */
>> +static inline int rmi_rec_create(unsigned long rd, unsigned long rec,
>> +                 unsigned long params_ptr)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rd, rec, params_ptr, &res);
>> +
>> +    return res.a0;
>> +}
>> +
> 
> 'params_ptr' may be renamed to 'params'.
> 
> 
> [...]
>> +#endif /* __ASM_RMI_CMDS_H */
> 
> Thanks,
> Gavin
> 


