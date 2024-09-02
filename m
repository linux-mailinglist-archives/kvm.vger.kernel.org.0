Return-Path: <kvm+bounces-25669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7CE96846A
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 12:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACC02B20E1F
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 10:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F1F513D503;
	Mon,  2 Sep 2024 10:17:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD0C13AD37;
	Mon,  2 Sep 2024 10:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725272244; cv=none; b=D6cbO76aU9O6nfWdNpxgaIQvsNqezuNcTBbBCh2oXFsaj6GTLBwLWmbLzn9FXh7SKd++gtVUZ9pDJlHxkAOIarA22HuCZOI1LpvvV9ATzR2T4gLUjiIlNUYpjUWE0XZSQfbmT2XJd2/pk2WZOf1YQUXOb9tKlAPSbmrDzPJqOE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725272244; c=relaxed/simple;
	bh=WUfaW6gunklyLKsITQ/73SFW4fLHi5OKuof3I1yiLPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7lchI3OR5YBJIDcrPyGKPjRuHH113I+KXzRd/wvzzFuo4y4nKRO6mCJ9bc5vJy/5jil6/u/Ih3SCibWdPCNL+jE0d84ItTYGO0tKFYmXjTb11KRKcOrH29DZoNp3DcjTpZRjhw3cI6SryGFhpCm3YuMTXi8LUAbZMQ831I9GwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71BE5FEC;
	Mon,  2 Sep 2024 03:17:46 -0700 (PDT)
Received: from [10.57.74.147] (unknown [10.57.74.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F6A63F66E;
	Mon,  2 Sep 2024 03:17:15 -0700 (PDT)
Message-ID: <fe5626ef-3930-4ad1-b41e-3734ac16b562@arm.com>
Date: Mon, 2 Sep 2024 11:17:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 43/43] KVM: arm64: Allow activating realms
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
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
 Alper Gun <alpergun@google.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-44-steven.price@arm.com> <yq5afrqieiyg.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5afrqieiyg.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/09/2024 06:13, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> Add the ioctl to activate a realm and set the static branch to enable
>> access to the realm functionality if the RMM is detected.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/kvm/rme.c | 19 ++++++++++++++++++-
>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 9f415411d3b5..1eeef9e15d1c 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -1194,6 +1194,20 @@ static int kvm_init_ipa_range_realm(struct kvm *kvm,
>>  	return realm_init_ipa_state(realm, addr, end);
>>  }
>>  
>> +static int kvm_activate_realm(struct kvm *kvm)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +
>> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>> +		return -EINVAL;
>> +
>> +	if (rmi_realm_activate(virt_to_phys(realm->rd)))
>> +		return -ENXIO;
>> +
>> +	WRITE_ONCE(realm->state, REALM_STATE_ACTIVE);
>> +	return 0;
>> +}
>> +
>>  /* Protects access to rme_vmid_bitmap */
>>  static DEFINE_SPINLOCK(rme_vmid_lock);
>>  static unsigned long *rme_vmid_bitmap;
>> @@ -1343,6 +1357,9 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>  		r = kvm_populate_realm(kvm, &args);
>>  		break;
>>  	}
>> +	case KVM_CAP_ARM_RME_ACTIVATE_REALM:
>> +		r = kvm_activate_realm(kvm);
>> +		break;
>>  	default:
>>  		r = -EINVAL;
>>  		break;
>> @@ -1599,5 +1616,5 @@ void kvm_init_rme(void)
>>  	if (rme_vmid_init())
>>  		return;
>>  
>> -	/* Future patch will enable static branch kvm_rme_is_available */
>> +	static_branch_enable(&kvm_rme_is_available);
>>
> 
> like rsi_present, we might want to use this outside kvm, ex: for TIO.

I'm struggling to think why rme_is_available would be needed outside KVM
- what is "TIO"?

> Can we move this outside module init so that we can have a helper
> like is_rme_supported()

It's obviously possible, but I'm not sure where in the code it would go
- if there is an actual use case outside of KVM then presumably it would
need to move completely outside of the KVM code.

Can you elaborate on why you think it might be useful?

Steve


