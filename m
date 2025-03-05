Return-Path: <kvm+bounces-40170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BF0A504D8
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 17:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D93361898867
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 16:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E77C197A8B;
	Wed,  5 Mar 2025 16:25:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4648318A6B5;
	Wed,  5 Mar 2025 16:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741191926; cv=none; b=lsC5+5Cs9BSqAVf6/DRYw2hIvIdy44Wl6p3ZXuh++HaGFaeTPBG4JOjYp6pn28DoasHCIbJww0OdSrAloMBPmFjMdJm3aCWLEuYaNmA3Fph2cnMyGQ/gVo+RCg5K3ki8BGHDuHywN2FWqWt5/NO4nQQXxL8etTtEn9USCW+3PS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741191926; c=relaxed/simple;
	bh=K+K6DmUC+Wxvngt/uU7W1IItHbJf0lWSGmSE11WgMBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HKprgePh14EbWjMV2x8CGcz09i90dqUSI+qE2NtBKiQG0oSUDpX2bmOf6uecehUrVaaiupQfbJB9vPkOqJFIXaw6mNxZCiYkhiItsGP1LPcNwXMa6vHzdEX5rMP+AOrQyqqqYZ1fSUwKNVrdkPS/yKC7nVVzax85OtS3TmeBSM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5D60FEC;
	Wed,  5 Mar 2025 08:25:36 -0800 (PST)
Received: from [10.57.67.16] (unknown [10.57.67.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FB763F5A1;
	Wed,  5 Mar 2025 08:25:18 -0800 (PST)
Message-ID: <ea9bb982-cf31-4079-8fea-dc39e91a975b@arm.com>
Date: Wed, 5 Mar 2025 16:25:17 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/45] kvm: arm64: Expose debug HW register numbers for
 Realm
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-10-steven.price@arm.com>
 <cec600f2-2ddc-4c71-9bab-0a0403132b43@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <cec600f2-2ddc-4c71-9bab-0a0403132b43@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 03/03/2025 04:48, Gavin Shan wrote:
> On 2/14/25 2:13 AM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Expose VM specific Debug HW register numbers.

Looking at this now, this patch description is garbage. Probably the
patch has changed over time - so I suspect it's my fault not Suzuki's.
We're not exposing anything new here. This is purely about telling the
VMM that a realm cannot (currently) be debugged. Something like the
below would be more accurate:

"""
kvm: arm64: Don't expose debug capabilities for realm guests

RMM v1.0 provides no mechanism for the host to perform debug operations
on the guest. So don't expose KVM_CAP_SET_GUEST_DEBUG and report 0
breakpoints and 0 watch points.
"""

>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/kvm/arm.c | 24 +++++++++++++++++++++---
>>   1 file changed, 21 insertions(+), 3 deletions(-)
>>
> 
> Documentation/virt/kvm/api.rst needs to be updated accordingly.

I don't think (with the above clarification) there's anything to update
in the API documentation. There's nothing new being added, just
capabilities being hidden where the functionality isn't available.

And eventually we hope to add support for this (in a later RMM spec) - I
don't yet know exactly what form this will take, but I hope to keep the
interfaces as close as possible to what we already have so that existing
tooling can be used.

Thanks,
Steve

>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index b8fa82be251c..df6eb5e9ca96 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -78,6 +78,22 @@ bool is_kvm_arm_initialised(void)
>>       return kvm_arm_initialised;
>>   }
>>   +static u32 kvm_arm_get_num_brps(struct kvm *kvm)
>> +{
>> +    if (!kvm_is_realm(kvm))
>> +        return get_num_brps();
>> +    /* Realm guest is not debuggable. */
>> +    return 0;
>> +}
>> +
>> +static u32 kvm_arm_get_num_wrps(struct kvm *kvm)
>> +{
>> +    if (!kvm_is_realm(kvm))
>> +        return get_num_wrps();
>> +    /* Realm guest is not debuggable. */
>> +    return 0;
>> +}
>> +
> 
> The above two comments "Realm guest is not debuggable." can be dropped
> since
> the code is self-explanatory, and those two functions are unnecessary to be
> kept in that way, for example:
> 
>     case KVM_CAP_GUEST_DEBUG_HW_BPS:
>         return kvm_is_realm(kvm) ? 0 : get_num_brps();
>     case KVM_CAP_GUEST_DEBUG_HW_WRPS:
>         return kvm_is_realm(kvm) ? 0 : get_num_wrps();
> 
> 
>>   int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>>   {
>>       return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>> @@ -323,7 +339,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>       case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>>       case KVM_CAP_ARM_NISV_TO_USER:
>>       case KVM_CAP_ARM_INJECT_EXT_DABT:
>> -    case KVM_CAP_SET_GUEST_DEBUG:
>>       case KVM_CAP_VCPU_ATTRIBUTES:
>>       case KVM_CAP_PTP_KVM:
>>       case KVM_CAP_ARM_SYSTEM_SUSPEND:
>> @@ -331,6 +346,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>       case KVM_CAP_COUNTER_OFFSET:
>>           r = 1;
>>           break;
>> +    case KVM_CAP_SET_GUEST_DEBUG:
>> +        r = !kvm_is_realm(kvm);
>> +        break;
>>       case KVM_CAP_SET_GUEST_DEBUG2:
>>           return KVM_GUESTDBG_VALID_MASK;
>>       case KVM_CAP_ARM_SET_DEVICE_ADDR:
>> @@ -376,10 +394,10 @@ int kvm_vm_ioctl_check_extension(struct kvm
>> *kvm, long ext)
>>           r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
>>           break;
>>       case KVM_CAP_GUEST_DEBUG_HW_BPS:
>> -        r = get_num_brps();
>> +        r = kvm_arm_get_num_brps(kvm);
>>           break;
>>       case KVM_CAP_GUEST_DEBUG_HW_WPS:
>> -        r = get_num_wrps();
>> +        r = kvm_arm_get_num_wrps(kvm);
>>           break;
>>       case KVM_CAP_ARM_PMU_V3:
>>           r = kvm_arm_support_pmu_v3();
> 
> Thanks,
> Gavin
> 


