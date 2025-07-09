Return-Path: <kvm+bounces-51957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2FFCAFEC69
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C72D964257F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F972E7167;
	Wed,  9 Jul 2025 14:43:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2192E6D37;
	Wed,  9 Jul 2025 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072189; cv=none; b=OgSCHaZqY7yDmIPt9GLQUUvCxr39l3iKnu91ha3asI6Oghpgmt/OfYUdTJrrF5dRUcmdSOgkDiYj1C7BsgsLsmRLsFCcYcUeJObQGUCXQ2g98tdmYaYLX4/zF+jNK+FZIOSK9nRtV2h/ASpjByWLuu901265YUTLHABuQd6pxbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072189; c=relaxed/simple;
	bh=bQMNFx6GOIIt/6c+Np8R4/r+qUvNC1doOK/fLJk48Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TZFlGrNbEbO4qhA+RgiUCMs/0eAtL+l4O5mt+osJIiJJzG1UTL18r/D4XIR9L5qjoKwYiKX+BkFd5l4Yh3idJf0pqU33M6E8/MNDfvdzDf68/jhuwDI1vLkU4BRn79nlbYIbstpyn677JSovdDkeKvARrdPkI8LbuZUTywyu7Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DA69153B;
	Wed,  9 Jul 2025 07:42:55 -0700 (PDT)
Received: from [10.57.86.38] (unknown [10.57.86.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D7B83F694;
	Wed,  9 Jul 2025 07:43:03 -0700 (PDT)
Message-ID: <b2f3ddac-956e-4779-9202-fc393266aa6c@arm.com>
Date: Wed, 9 Jul 2025 15:42:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/43] arm64: RME: Allow VMM to set RIPAS
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-16-steven.price@arm.com>
 <60bb33b4-133e-4ebd-950c-e9e2ba8fc38b@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <60bb33b4-133e-4ebd-950c-e9e2ba8fc38b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 02/07/2025 01:37, Gavin Shan wrote:
> On 6/11/25 8:48 PM, Steven Price wrote:
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
>> Changes from v8:
>>   * Propagate the 'may_block' flag to allow conditional calls to
>>     cond_resched_rwlock_write().
>>   * Introduce alloc_rtt() to wrap alloc_delegated_granule() and
>>     kvm_account_pgtable_pages() and use when allocating RTTs.
>>   * Code reorganisation to allow init_ipa_state and set_ipa_state to
>>     share a common ripas_change() function,
>>   * Other minor changes following review.
>> Changes from v7:
>>   * Replace use of "only_shared" with the upstream "attr_filter" field
>>     of struct kvm_gfn_range.
>>   * Clean up the logic in alloc_delegated_granule() for when to call
>>     kvm_account_pgtable_pages().
>>   * Rename realm_destroy_protected_granule() to
>>     realm_destroy_private_granule() to match the naming elsewhere. Also
>>     fix the return codes in the function to be descriptive.
>>   * Several other minor changes to names/return codes.
>> Changes from v6:
>>   * Split the code dealing with the guest triggering a RIPAS change into
>>     a separate patch, so this patch is purely for the VMM setting up the
>>     RIPAS before the guest first runs.
>>   * Drop the useless flags argument from alloc_delegated_granule().
>>   * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>>   * Deal with the RMM granule size potentially being smaller than the
>>     host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>>     still allocates an entire host page for every RMM granule (so wasting
>>     memory when PAGE_SIZE>4k).
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
>>   arch/arm64/include/asm/kvm_rme.h |   6 +
>>   arch/arm64/kvm/mmu.c             |   8 +-
>>   arch/arm64/kvm/rme.c             | 447 +++++++++++++++++++++++++++++++
>>   3 files changed, 458 insertions(+), 3 deletions(-)
>>
> 
> With below nitpicks addressed. The changes looks good to me.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks, most the nitpicks I agree - thanks for raising. Just one below I
wanted to comment on...

[...]
>> +
>> +enum ripas_action {
>> +    RIPAS_INIT,
>> +    RIPAS_SET,
>> +};
>> +
>> +static int ripas_change(struct kvm *kvm,
>> +            struct kvm_vcpu *vcpu,
>> +            unsigned long ipa,
>> +            unsigned long end,
>> +            enum ripas_action action,
>> +            unsigned long *top_ipa)
>> +{
> 
> The 'enum ripas_action' is used in limited scope, I would replace it
> with a 'bool'
> parameter to ripas_change(), something like below. If we plan to support
> more actions
> in future, then the 'enum ripas_action' makes sense to me.

The v1.1 spec[1] adds RMI_RTT_SET_S2AP (set stage 2 access permission).
So that adds a third option to the enum. I agree the enum is a little
clunky but it allows extension and at least spells out the action which
is occurring.

The part I'm not especially happy with is the 'vcpu' argument which is
not applicable to RIPAS_INIT but otherwise required (and in those cases
could replace 'kvm'). But I couldn't come up with a better solution for
that.

[1] Available from:
https://developer.arm.com/documentation/den0137/latest (following the
small "here" link near the end).

Thanks,
Steve

> static int ripas_change(struct kvm *kvm,
>             struct kvm_vcpu *vcpu,
>             unsigned long ipa,
>             unsigned long end,
>             bool set_ripas,
>             unsigned long *top_ipa)
> 
>> +    struct realm *realm = &kvm->arch.realm;
>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +    phys_addr_t rec_phys;
>> +    struct kvm_mmu_memory_cache *memcache = NULL;
>> +    int ret = 0;
>> +
>> +    if (vcpu) {
>> +        rec_phys = virt_to_phys(vcpu->arch.rec.rec_page);
>> +        memcache = &vcpu->arch.mmu_page_cache;
>> +
>> +        WARN_ON(action != RIPAS_SET);
>> +    } else {
>> +        WARN_ON(action != RIPAS_INIT);
>> +    }
>> +
>> +    while (ipa < end) {
>> +        unsigned long next;
>> +
>> +        switch (action) {
>> +        case RIPAS_INIT:
>> +            ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
>> +            break;
>> +        case RIPAS_SET:
>> +            ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end,
>> +                        &next);
>> +            break;
>> +        }
>> +
> 
> if 'enum ripas_action' is replaced by 'bool set_ripas' as above, this needs
> twist either.
> 
>> +        switch (RMI_RETURN_STATUS(ret)) {
>> +        case RMI_SUCCESS:
>> +            ipa = next;
>> +            break;
>> +        case RMI_ERROR_RTT:
>> +            int err_level = RMI_RETURN_INDEX(ret);
>> +            int level = find_map_level(realm, ipa, end);
>> +
>> +            if (err_level >= level)
>> +                return -EINVAL;
>> +
>> +            ret = realm_create_rtt_levels(realm, ipa, err_level,
>> +                              level, memcache);
>> +            if (ret)
>> +                return ret;
>> +            /* Retry with the RTT levels in place */
>> +            break;
>> +        default:
>> +            WARN_ON(1);
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    if (top_ipa)
>> +        *top_ipa = ipa;
>> +
>> +    return 0;
>> +}
>> +
>> +static int realm_init_ipa_state(struct kvm *kvm,
>> +                unsigned long ipa,
>> +                unsigned long end)
>> +{
>> +    return ripas_change(kvm, NULL, ipa, end, RIPAS_INIT, NULL);
>> +}
>> +
>> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
>> +                    struct arm_rme_init_ripas *args)
>> +{
>> +    gpa_t addr, end;
>> +
>> +    addr = args->base;
>> +    end = addr + args->size;
>> +
>> +    if (end < addr)
>> +        return -EINVAL;
>> +
>> +    if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>> +        return -EPERM;
>> +
>> +    return realm_init_ipa_state(kvm, addr, end);
>> +}
>> +
>>   /* Protects access to rme_vmid_bitmap */
>>   static DEFINE_SPINLOCK(rme_vmid_lock);
>>   static unsigned long *rme_vmid_bitmap;
>> @@ -441,6 +876,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct
>> kvm_enable_cap *cap)
>>       case KVM_CAP_ARM_RME_CREATE_REALM:
>>           r = kvm_create_realm(kvm);
>>           break;
>> +    case KVM_CAP_ARM_RME_INIT_RIPAS_REALM: {
>> +        struct arm_rme_init_ripas args;
>> +        void __user *argp = u64_to_user_ptr(cap->args[1]);
>> +
>> +        if (copy_from_user(&args, argp, sizeof(args))) {
>> +            r = -EFAULT;
>> +            break;
>> +        }
>> +
>> +        r = kvm_init_ipa_range_realm(kvm, &args);
>> +        break;
>> +    }
>>       default:
>>           r = -EINVAL;
>>           break;
> 
> Thanks,
> Gavin
> 


