Return-Path: <kvm+bounces-46808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB54AB9DF6
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59F97173524
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 13:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFB3155389;
	Fri, 16 May 2025 13:50:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2AF10E9;
	Fri, 16 May 2025 13:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747403424; cv=none; b=mWj78ttmCDSe/0gw4eJ6fSTNRQzuds/knL8tVHhD2UB70cLdNMLFoGwqNo7bFdopfg6gjNIq8o7HML8R3LxGCqJuIqS4tvoD455KrC7FAaQiz8aJHWwVLjJBqFMTiOFFrHhZfrdB7HDLkC28jI9qSc06Z6+WqMojqn4oFG6Mu10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747403424; c=relaxed/simple;
	bh=nf3OQE9ZhNsiJA068uF5vECxBvjjy1drOxz1l/4Kwgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=exdPULYFtmnHtaKSx62wfFNWdsPvXw6s2kG9p9ystRTQEGkwtHVSsRXguVvaaesJQFBO6fbyjN6XxycMR7x5gjQve/whv4MO+rjZ6e3LLqUGyWxnCwTyrXyXXweaFXoYtAeLUgaM+NV9u8C69OKtZqUxSdpuK0mybNyp4s0nf04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB252169C;
	Fri, 16 May 2025 06:50:09 -0700 (PDT)
Received: from [10.1.27.17] (e122027.cambridge.arm.com [10.1.27.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 73A8F3F673;
	Fri, 16 May 2025 06:50:17 -0700 (PDT)
Message-ID: <31bf9eac-a234-44dd-a4a3-0939092da66a@arm.com>
Date: Fri, 16 May 2025 14:50:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 17/43] arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-18-steven.price@arm.com>
 <b5770d9b-4f17-4be8-95a7-1549322debb2@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <b5770d9b-4f17-4be8-95a7-1549322debb2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 30/04/2025 13:11, Gavin Shan wrote:
> On 4/16/25 11:41 PM, Steven Price wrote:
>> The guest can request that a region of it's protected address space is
>> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
>> RSI_IPA_STATE_SET. This causes a guest exit with the
>> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
>> protected region to unprotected (or back), exiting to the VMM to make
>> the necessary changes to the guest_memfd and memslot mappings. On the
>> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
>> calls.
>>
>> The VMM may wish to reject the RIPAS change requested by the guest. For
>> now it can only do with by no longer scheduling the VCPU as we don't
>> currently have a usecase for returning that rejection to the guest, but
>> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
>> open for adding a new ioctl in the future for this purpose.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v7:
>>   * Rework the loop in realm_set_ipa_state() to make it clear when the
>>     'next' output value of rmi_rtt_set_ripas() is used.
>> New patch for v7: The code was previously split awkwardly between two
>> other patches.
>> ---
>>   arch/arm64/kvm/rme.c | 88 ++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 88 insertions(+)
>>
> 
> One nitpick below, either way:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index bee9dfe12e03..fe0d5b8703d2 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -624,6 +624,65 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>> unsigned long start,
>>           realm_unmap_private_range(kvm, start, end);
>>   }
>>   +static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>> +                   unsigned long start,
>> +                   unsigned long end,
>> +                   unsigned long ripas,
>> +                   unsigned long *top_ipa)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm *realm = &kvm->arch.realm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +    phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
>> +    struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>> +    unsigned long ipa = start;
>> +    int ret = 0;
>> +
>> +    while (ipa < end) {
>> +        unsigned long next;
>> +
>> +        ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS) {
>> +            ipa = next;
>> +        } else if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> 
> --->
> 
>> +            int walk_level = RMI_RETURN_INDEX(ret);
>> +            int level = find_map_level(realm, ipa, end);
>> +
>> +            /*
>> +             * If the RMM walk ended early then more tables are
>> +             * needed to reach the required depth to set the RIPAS.
>> +             */
>> +            if (walk_level < level) {
>> +                ret = realm_create_rtt_levels(realm, ipa,
>> +                                  walk_level,
>> +                                  level,
>> +                                  memcache);
>> +                /* Retry with RTTs created */
>> +                if (!ret)
>> +                    continue;
>> +            } else {
>> +                ret = -EINVAL;
>> +            }
>> +
> 
> <--- This block of code have been existing in multiple functions. I guess
> it would be worthy to introduce a helper for it if you agree.
> Alternatively,
> it's definitely something to do in the future, after this series is
> merged :)

I believe it's just two functions: realm_set_ipa_state() and
realm_init_ipa_state(). Those two functions are going basically the same
thing just at different stages (realm_init before the guest has started,
and realm_set when it's running).

I've had a go and combing the two functions, it's a little clunky
because of the differences, but I think it's an improvement over the
repeated code.

Thanks,
Steve

>> +            break;
>> +        } else {
>> +            WARN(1, "Unexpected error in %s: %#x\n", __func__,
>> +                 ret);
>> +            ret = -ENXIO;
>> +            break;
>> +        }
>> +    }
>> +
>> +    *top_ipa = ipa;
>> +
>> +    if (ripas == RMI_EMPTY && ipa != start)
>> +        realm_unmap_private_range(kvm, start, ipa);
>> +
>> +    return ret;
>> +}
>> +
>>   static int realm_init_ipa_state(struct realm *realm,
>>                   unsigned long ipa,
>>                   unsigned long end)
>> @@ -863,6 +922,32 @@ void kvm_destroy_realm(struct kvm *kvm)
>>       kvm_free_stage2_pgd(&kvm->arch.mmu);
>>   }
>>   +static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long base = rec->run->exit.ripas_base;
>> +    unsigned long top = rec->run->exit.ripas_top;
>> +    unsigned long ripas = rec->run->exit.ripas_value;
>> +    unsigned long top_ipa;
>> +    int ret;
>> +
>> +    do {
>> +        kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
>> +                       kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
>> +        write_lock(&kvm->mmu_lock);
>> +        ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
>> +        write_unlock(&kvm->mmu_lock);
>> +
>> +        if (WARN_RATELIMIT(ret && ret != -ENOMEM,
>> +                   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx,
>> ripas: %#lx\n",
>> +                   base, top, ripas))
>> +            break;
>> +
>> +        base = top_ipa;
>> +    } while (top_ipa < top);
>> +}
>> +
>>   int kvm_rec_enter(struct kvm_vcpu *vcpu)
>>   {
>>       struct realm_rec *rec = &vcpu->arch.rec;
>> @@ -873,6 +958,9 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu)
>>           for (int i = 0; i < REC_RUN_GPRS; i++)
>>               rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>>           break;
>> +    case RMI_EXIT_RIPAS_CHANGE:
>> +        kvm_complete_ripas_change(vcpu);
>> +        break;
>>       }
>>         if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
> 
> Thanks,
> Gavin
> 


