Return-Path: <kvm+bounces-50368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ACB4AE4740
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0450B189D255
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A553526B77F;
	Mon, 23 Jun 2025 14:45:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0299926B2DB;
	Mon, 23 Jun 2025 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750689936; cv=none; b=aZ+OtT8F25yIMeJHKOfFvb/oYTMvSqZHfGvFDNAlPeAoWl0m6WYxs8uqw0mHw12Q2BwdhfrXJL5NMbodYIgkQ3c7G+I5ikgfbK85YGXDNDKpCwOspef1xSfhEGP5ij2eD7YtzkM2Kq2qKWsaxmDCvBHzBwzHl1MOtWAGYuhefkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750689936; c=relaxed/simple;
	bh=/sfQBvTH/yGMQ94U8EPTO0Y5HoLE1uO6aQH+B4AtwsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iLytbK8kE/G3IjBmS9eEhrXyNnWVg6uWTVOGDy0+fjlA4UEwFuBz/h08ouXgopNt2umKram8k5A+2FOW3iSeyTK4Ly5MItlgYBVgRWLzo9WZrlDJiu04b1ReAX2/CpF1NDfVMFxGEvi1K2VEKkWVOSuKa1AlXPYDVuYxSnGEeEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F9E01756;
	Mon, 23 Jun 2025 07:45:15 -0700 (PDT)
Received: from [10.57.29.183] (unknown [10.57.29.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77E763F66E;
	Mon, 23 Jun 2025 07:45:29 -0700 (PDT)
Message-ID: <8bff076f-0c82-49e3-8e63-15dfedde233e@arm.com>
Date: Mon, 23 Jun 2025 15:45:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/43] arm64: RME: RTT tear down
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-11-steven.price@arm.com>
 <b39ce0e3-5d44-4334-b739-2af07a24a668@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <b39ce0e3-5d44-4334-b739-2af07a24a668@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 16/06/2025 11:41, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 11/06/2025 11:48, Steven Price wrote:
>> The RMM owns the stage 2 page tables for a realm, and KVM must request
>> that the RMM creates/destroys entries as necessary. The physical pages
>> to store the page tables are delegated to the realm as required, and can
>> be undelegated when no longer used.
>>
>> Creating new RTTs is the easy part, tearing down is a little more
>> tricky. The result of realm_rtt_destroy() can be used to effectively
>> walk the tree and destroy the entries (undelegating pages that were
>> given to the realm).
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> A couple of minor nits below. Should have spotted earlier, apologies.
> ...
> 
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 73261b39f556..0f89295fa59c 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -17,6 +17,22 @@ static unsigned long rmm_feat_reg0;
>>   #define RMM_PAGE_SHIFT        12
>>   #define RMM_PAGE_SIZE        BIT(RMM_PAGE_SHIFT)
>>   +#define RMM_RTT_BLOCK_LEVEL    2
>> +#define RMM_RTT_MAX_LEVEL    3
>> +
>> +/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
>> +#define RMM_RTT_LEVEL_SHIFT(l)    \
>> +    ((RMM_PAGE_SHIFT - 3) * (4 - (l)) + 3)
>> +#define RMM_L2_BLOCK_SIZE    BIT(RMM_RTT_LEVEL_SHIFT(2))
>> +
>> +static inline unsigned long rme_rtt_level_mapsize(int level)
>> +{
>> +    if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
>> +        return RMM_PAGE_SIZE;
>> +
>> +    return (1UL << RMM_RTT_LEVEL_SHIFT(level));
>> +}
>> +
>>   static bool rme_has_feature(unsigned long feature)
>>   {
>>       return !!u64_get_bits(rmm_feat_reg0, feature);
>> @@ -82,6 +98,126 @@ static int free_delegated_granule(phys_addr_t phys)
>>       return 0;
>>   }
>>   +static void free_rtt(phys_addr_t phys)
>> +{
>> +    if (free_delegated_granule(phys))
>> +        return;
>> +
>> +    kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>> +}
>> +
>> +static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>> +                 int level, phys_addr_t *rtt_granule,
>> +                 unsigned long *next_addr)
>> +{
>> +    unsigned long out_rtt;
>> +    int ret;
>> +
>> +    ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
>> +                  &out_rtt, next_addr);
>> +
>> +    *rtt_granule = out_rtt;
>> +
>> +    return ret;
> 
> ultra minor nit: this could simply be :
> 
>     return rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
> rtt_granule, next_addr);
> 

Sadly it can't because of the types. We want to return a phys_addr_t for
the granule to undelegate. But the rmi_xxx calls use 'unsigned long' for
consistency. So this is actually a type conversion.

I did toy around with pushing the types up or down but it makes the code
more ugly. Explicitly casting 'works' but is fragile because it bakes in
that phys_addr_t is the same type as unsigned long.

> ...
> 
>> +
>> +static int realm_tear_down_rtt_range(struct realm *realm,
>> +                     unsigned long start, unsigned long end)
>> +{
> 
> minor nit: Is it worth adding a comment here, why we start from
> start_level + 1 and downwards ? Something like:
> 
>     /*
>      * Root level RTTs can only be destroyed after the RD is
>      * destroyed. So tear down everything below the root level.
>      */

Ack

> Similarly, we may be able to clarify a comment in kvm_free_stage2_pgd()

Ack, I'll use the wording you suggested in your later email.

Thanks,
Steve


