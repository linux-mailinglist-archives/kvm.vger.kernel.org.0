Return-Path: <kvm+bounces-36924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4169A22EC8
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 15:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44A9B163BB9
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 14:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05DED1E98E7;
	Thu, 30 Jan 2025 14:14:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9F1199939;
	Thu, 30 Jan 2025 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246498; cv=none; b=flUJTgut6FtJvajk30KycvihBuR6UVE2LwZ10rdapkHOn6ijAaZJnf4wu7N/44FyVJZlzFbHUPX7Ng3CUYmiCfmgeI7EhAYGO4zxNGC+MUblP2HtxcWWUuUnMqdAYyU/FeYq79zkTF8c2MgUVsYHVhqMwsy+x4vTDVKlheg/PBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246498; c=relaxed/simple;
	bh=62uvUPVokekdadvzzYgMQHmplXUKl1Kb/D+EIGlWRtw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSAUF96v200Lw7UFaybEi2AKzvUkV1nJTXr81gOtDRnXSPfg7f4YrJtVIVcoZWQQia4myj7kIUFt3Itnd8Y4ijCh+JGTEh/PTOzx2YjoZyoYik7J++YW92d6Sa98PX5IFTOuLZVjJg/+Pa1+wc6JkLYC1i8+ldcgp5LHobRAoR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 940B1497;
	Thu, 30 Jan 2025 06:15:14 -0800 (PST)
Received: from [10.1.32.52] (e122027.cambridge.arm.com [10.1.32.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BF713F694;
	Thu, 30 Jan 2025 06:14:45 -0800 (PST)
Message-ID: <1356de81-2fa1-4ad5-80bd-d02440603288@arm.com>
Date: Thu, 30 Jan 2025 14:14:43 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/43] arm64: kvm: Allow passing machine type in KVM
 creation
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-11-steven.price@arm.com>
 <a580d287-2fb0-4e9d-adbb-57e4dbf25765@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <a580d287-2fb0-4e9d-adbb-57e4dbf25765@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 29/01/2025 04:07, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
>> Previously machine type was used purely for specifying the physical
>> address size of the guest. Reserve the higher bits to specify an ARM
>> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
>> used to create a realm guest.
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/kvm/arm.c     | 17 +++++++++++++++++
>>   arch/arm64/kvm/mmu.c     |  3 ---
>>   include/uapi/linux/kvm.h | 19 +++++++++++++++----
>>   3 files changed, 32 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index c505ec61180a..73016e1e0067 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -207,6 +207,23 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned
>> long type)
>>       mutex_unlock(&kvm->lock);
>>   #endif
>>   +    if (type & ~(KVM_VM_TYPE_ARM_MASK |
>> KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
>> +        return -EINVAL;
>> +
>> +    switch (type & KVM_VM_TYPE_ARM_MASK) {
>> +    case KVM_VM_TYPE_ARM_NORMAL:
>> +        break;
>> +    case KVM_VM_TYPE_ARM_REALM:
>> +        kvm->arch.is_realm = true;
>> +        if (!kvm_is_realm(kvm)) {
>> +            /* Realm support unavailable */
>> +            return -EINVAL;
>> +        }
>> +        break;
>> +    default:
>> +        return -EINVAL;
>> +    }
>> +
>>       kvm_init_nested(kvm);
>>         ret = kvm_share_hyp(kvm, kvm + 1);
> 
> Corresponding to comments for PATCH[6], the block of the code can be
> modified
> to avoid using kvm_is_realm() here. In this way, kvm_is_realm() can be
> simplifed
> as I commented for PATCH[6].
> 
>     case KVM_VM_TYPE_ARM_REALM:
>         if (static_branch_unlikely(&kvm_rme_is_available))
>             return -EPERM;    /* -EPERM may be more suitable than -
> EINVAL */
> 
>         kvm->arch.is_realm = true;
>         break;

Yes that's more readable. I'd used kvm_is_realm() because I wanted to
keep the check on kvm_rme_is_available to one place, but coming back to
the code there's definitely a "Huh?" moment from setting 'is_realm' and
then testing if it's a realm!

I also agree -EPERM is probably better to signify that the kernel
supports realms but the hardware doesn't.

Thanks,

Steve


