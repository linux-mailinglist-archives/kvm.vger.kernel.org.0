Return-Path: <kvm+bounces-36936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24317A23256
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 17:56:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57A1C3A5045
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 16:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C201EEA3C;
	Thu, 30 Jan 2025 16:56:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC841EE035;
	Thu, 30 Jan 2025 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738256191; cv=none; b=BUMoCWunthEIr1dodOMdoJAZyeVEimDspvIoIbt9CbWVKuFTCdlQI9Mqe/hoS1Z68XIKhzl99z7KKlQdWHXeumvw97G1xsTzwvX6KrX97DU40b2dC+rYkmmCRj0i1ObH4JrgwW1mGWqVzM0Dszigvno7Ceb6DX8N/K0b2/2vjmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738256191; c=relaxed/simple;
	bh=eLyjG0G1KbV38YOTYlWw6vyTB9t+tEh09C2FyplIcgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AQfK+yHJaR5gXHUsAzRyXwAxAZgQ0DTdJbpGt9WIbuARDeHBETRlu1qQEdgY27PJF7tYrGAoNpsLAgj8atxUmStnrDRNfYwsn248IfpmNjZfZBaI2m4bCjmdhcNUya4P1gAkJXlZ7dRfVkw77Ws6LW0GyxVs+SoHhVNs1iFMFiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E7DB497;
	Thu, 30 Jan 2025 08:56:55 -0800 (PST)
Received: from [10.1.32.52] (e122027.cambridge.arm.com [10.1.32.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20D4F3F63F;
	Thu, 30 Jan 2025 08:56:24 -0800 (PST)
Message-ID: <699f918e-5db4-467c-9dcf-c1474aaef265@arm.com>
Date: Thu, 30 Jan 2025 16:56:22 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/43] arm64: RME: Allow VMM to set RIPAS
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
 <20241212155610.76522-17-steven.price@arm.com>
 <4c1c507d-25ae-488f-88d3-fd6ffe337d0d@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <4c1c507d-25ae-488f-88d3-fd6ffe337d0d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 29/01/2025 23:25, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
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
>> Changes from v5:
>>   * Adapt to rebasing.
>>   * Introduce find_map_level()
>>   * Rename some functions to be clearer.
>>   * Drop the "spare page" functionality.
>> Changes from v2:
>>   * {alloc,free}_delegated_page() moved from previous patch to this one.
>>   * alloc_delegated_page() now takes a gfp_t flags parameter.
>>   * Fix the reference counting of guestmem pages to avoid leaking memory.
>>   * Several misc code improvements and extra comments.
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |  17 ++
>>   arch/arm64/kvm/mmu.c             |   8 +-
>>   arch/arm64/kvm/rme.c             | 411 +++++++++++++++++++++++++++++++
>>   3 files changed, 433 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>> asm/kvm_rme.h
>> index be64b749fcac..4e7758f0e4b5 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -92,6 +92,15 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
>> ia_bits);
>>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>   +void kvm_realm_unmap_range(struct kvm *kvm,
>> +               unsigned long ipa,
>> +               u64 size,
>> +               bool unmap_private);
>> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>> +            unsigned long addr, unsigned long end,
>> +            unsigned long ripas,
>> +            unsigned long *top_ipa);
>> +
> 
> The declaration of realm_set_ipa_state() is unnecessary since its scope has
> been limited to rme.c

Ack, the function can be static too.

>>   #define RMM_RTT_BLOCK_LEVEL    2
>>   #define RMM_RTT_MAX_LEVEL    3
>>   @@ -110,4 +119,12 @@ static inline unsigned long
>> rme_rtt_level_mapsize(int level)
>>       return (1UL << RMM_RTT_LEVEL_SHIFT(level));
>>   }
>>   +static inline bool realm_is_addr_protected(struct realm *realm,
>> +                       unsigned long addr)
>> +{
>> +    unsigned int ia_bits = realm->ia_bits;
>> +
>> +    return !(addr & ~(BIT(ia_bits - 1) - 1));
>> +}
>> +
>>   #endif
> 
> The check on the specified address to determine its range seems a bit
> complicated
> to me, it can be simplified like below. Besides, it may be a good idea
> to rename
> it to have the prefix "kvm_realm_".
> 
> static inline bool kvm_realm_is_{private | protected}_address(struct
> realm *realm,
>                           unsigned long addr)
> {
>     return !(addr & BIT(realm->ia_bits - 1));
> }

Ack

> A question related to the terms used in this series to describe a
> granule's state:
> "protected" or "private", "unprotected" or "shared". Those terms are all
> used in
> the function names of this series. I guess it would be nice to unify so
> that
> "private" and "shared" to be used, which is consistent to the terms used by
> guest-memfd. For example, kvm_realm_is_protected_address() can be
> renamed to
> kvm_realm_is_private_address().

Happy with the rename here. More generally it's a little awkward because
the RMM spec does refer to protected/unprotected (e.g.
RMI_RTT_MAP_UNPROTECTED). So there's always a choice between aligning
with the RMM spec or aligning with guest-memfd.

Thanks,

Steve


