Return-Path: <kvm+bounces-28634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F114D99A610
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 16:14:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68387285C76
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 14:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295AE219CB9;
	Fri, 11 Oct 2024 14:14:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CEAC2194A6;
	Fri, 11 Oct 2024 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728656071; cv=none; b=ZrFJ5tiBZ9qL8PrBYEtwYS8qjdZwbI/7r4IPz9580oZMk8nlVOT/jOIDb2R1WK2QHRyv7uVlVxXv6Wubkc2VmDJ29RZBJg49a1EhOAMkyszmbWR7VtuRQFRXboHziN1CbTvduTNtJcExutaALtmzuVnmYGyov+EY0bCFiD+LKII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728656071; c=relaxed/simple;
	bh=EpiWcUKOAJX5vxoU+2IwEgs3Lyy8D2KXOdZl2yeOQWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NK8/6l6+0HttauA96Em2n/QNLGakYhJFhbPumFR5Ls4iwHU0nAXJGpkwem5S38MeaNj54yAQBbNhPMIqz7eZS+VqaeMx6QcZUDTGdUFf/42XtYtdQAbSS19L0hILhnOCZdF6UnjW6olzR89pJj1NBaF50S0P7g4dsLYTLk39FcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01F7E497;
	Fri, 11 Oct 2024 07:14:58 -0700 (PDT)
Received: from [10.1.31.21] (e122027.cambridge.arm.com [10.1.31.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 608673F5A1;
	Fri, 11 Oct 2024 07:14:25 -0700 (PDT)
Message-ID: <77030ef8-e180-46bb-872c-e41c8b25bbc2@arm.com>
Date: Fri, 11 Oct 2024 15:14:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/11] arm64: rsi: Add RSI definitions
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Gavin Shan <gshan@redht.com>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-2-steven.price@arm.com>
 <2ed92455-b97f-40ba-b5d6-695e885be62f@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <2ed92455-b97f-40ba-b5d6-695e885be62f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 08/10/2024 00:08, Gavin Shan wrote:
> On 10/5/24 12:42 AM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by a realm guest through SMC (Realm Services Interface) calls.
>>
>> The SMC definitions are based on DEN0137[1] version 1.0-rel0.
>>
>> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redht.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
> 
> [...]
> 
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
>> +    if (res.a2 != RSI_ACCEPT)
>> +        return -EPERM;
>> +
>> +    return res.a0;
>> +}
>> +
> 
> Similar to rsi_attestation_token_init(), the return value type needs to
> be 'long'
> since '-EPERM' can be returned from the function.

Good spot.

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
>> +static inline long
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
> 
> The return value type of this function needs to be 'unsigned long' even
> it's
> converted to 'int' in arm_cca_attestation_continue(). In this way, the
> wrapper
> functions has consistent return value type, which is 'unsigned long' or
> 'long'.

Ack, seems reasonable.

Thanks,
Steve


