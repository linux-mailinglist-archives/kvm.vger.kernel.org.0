Return-Path: <kvm+bounces-50369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56422AE4752
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC49F16DCB5
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C920B26D4F7;
	Mon, 23 Jun 2025 14:45:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7BB26C3B3;
	Mon, 23 Jun 2025 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750689940; cv=none; b=IfKi6B5Xjfr+xoPehtMTTJjlwIeq5W/2UDOZziJ0JA79JMBw8QVyQ8vY4eJ0qCtL9IQ51KQHg0O+vo+rHDkFRFzmidF2yOBHG96JC5VXsqy86scvn9izNGKc4rHvp85ntFmRSVCXKj3ermmW8ImBz0ahBzIYxTjR+84U9TxrEIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750689940; c=relaxed/simple;
	bh=ml2WHOrRaZXlImblmApJ9TNiFC7BKrRWyn3drFSQq3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jaVnB5JOaJ4vTZHXV08SZnUMirlSy0LwCFrw8i+7tUWIRaMHfdOi8kFKq4AzfY9ReHRGwkBo60dNC//yih9eO7Zc+aYbGms/bMM9Pb4tZcPHmdzOZ7f22/jbBJ3N348iV2OYQWzvZdPKCyaEUz6J1y/FHry53PvBNza8HTmPLeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5414D1D14;
	Mon, 23 Jun 2025 07:45:20 -0700 (PDT)
Received: from [10.57.29.183] (unknown [10.57.29.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3E143F66E;
	Mon, 23 Jun 2025 07:45:33 -0700 (PDT)
Message-ID: <1c1f1970-4b6d-4914-b6eb-fd8f53a55356@arm.com>
Date: Mon, 23 Jun 2025 15:45:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/43] arm64: RME: Allow VMM to set RIPAS
To: zhuangyiwei <zhuangyiwei@huawei.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
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
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 zhouguangwei5@huawei.com, wangyuan46@huawei.com
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-16-steven.price@arm.com>
 <5934e102-0e3c-43a8-a887-0c97904e6f6c@huawei.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <5934e102-0e3c-43a8-a887-0c97904e6f6c@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 17/06/2025 13:56, zhuangyiwei wrote:
> Hi Steven
> 
> On 2025/6/11 18:48, Steven Price wrote:
>> Each page within the protected region of the realm guest can be marked
>> as either RAM or EMPTY. Allow the VMM to control this before the guest
>> has started and provide the equivalent functions to change this (with
>> the guest's approval) at runtime.
>>
>> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
>> unmapped from the guest and undelegated allowing the memory to be reused
>> by the host. When transitioning to RIPAS RAM the actual population of
>> the leaf RTTs is done later on stage 2 fault, however it may be
>> necessary to allocate additional RTTs to allow the RMM track the RIPAS
>> for the requested range.
>>
>> When freeing a block mapping it is necessary to temporarily unfold the
>> RTT which requires delegating an extra page to the RMM, this page can
>> then be recovered once the contents of the block mapping have been
>> freed.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
[...]
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 25705da6f153..fe75c41d6ac3 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
[...]
>> @@ -126,6 +206,40 @@ static int realm_rtt_destroy(struct realm *realm,
>> unsigned long addr,
>>       return ret;
>>   }
>>   +static int realm_create_rtt_levels(struct realm *realm,
>> +                   unsigned long ipa,
>> +                   int level,
>> +                   int max_level,
>> +                   struct kvm_mmu_memory_cache *mc)
>> +{
>> +    if (level == max_level)
>> +        return 0;
>> +
>> +    while (level++ < max_level) {
>> +        phys_addr_t rtt = alloc_rtt(mc);
>> +        int ret;
>> +
>> +        if (rtt == PHYS_ADDR_MAX)
>> +            return -ENOMEM;
>> +
>> +        ret = realm_rtt_create(realm, ipa, level, rtt);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT &&
>> +            RMI_RETURN_INDEX(ret) == level - 1) {
>> +            /* The RTT already exists, continue */
> Should rtt be freed and undelegated in this branch?

Indeed it should! There's a missing call to free_rtt(). Thanks for spotting.

>> +            continue;
>> +        }
>> +        if (ret) {
>> +            WARN(1, "Failed to create RTT at level %d: %d\n",
>> +                 level, ret);
>> +            free_rtt(rtt);
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    return 0;
>> +}
>> +

Thanks,
Steve

