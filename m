Return-Path: <kvm+bounces-36921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED2A3A22CBD
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 12:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00D6E3A52FE
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 11:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523061E284B;
	Thu, 30 Jan 2025 11:57:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB38E1E1A31;
	Thu, 30 Jan 2025 11:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738238232; cv=none; b=Lz2s7lq8mVbFdx88iKrkXPwmII+9PoXfPb0eeqB3yTqm9BYwgB8Kz3ksTflIq35kF1OBRUJrjiMZYncmAaYf++YPSbAjJ71PUtcukdQBLEPLOLQvdxc6dhb1QQrOi9fmNw57jCLjs0ufLH+NRMxZGGXRIJvb29Q99Lqwtg29jSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738238232; c=relaxed/simple;
	bh=/jzUuYwmgxP+lfg92pEzyANCRw7aOu7723g/XvYgnsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K60M5FgFrHlkl3mD/TJZAbA4RMR07TUl6gH6a3iQHd8t4z4sTp11UO3S9R3okO1Q/xDnTNcXzQJXBJSFPNs4UxyOnr/LX/Ys3z3/Xa+4i+aqEyvG6SWIwhKTq/X0zBdu2hl6HHnH+q+FEZHabGx0oTeZPWq+OLFXklNUZ2Rn4q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9179B497;
	Thu, 30 Jan 2025 03:57:35 -0800 (PST)
Received: from [10.1.32.52] (e122027.cambridge.arm.com [10.1.32.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33F8C3F63F;
	Thu, 30 Jan 2025 03:57:05 -0800 (PST)
Message-ID: <84da77b5-9150-49bc-a3b3-60dfa13935e5@arm.com>
Date: Thu, 30 Jan 2025 11:57:03 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/43] arm64: RME: ioctls to create and configure
 realms
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
 <20241212155610.76522-9-steven.price@arm.com>
 <691a2f0a-0f04-4bf6-a11a-ea7ee753cf88@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <691a2f0a-0f04-4bf6-a11a-ea7ee753cf88@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 29/01/2025 00:43, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
>> Add the KVM_CAP_ARM_RME_CREATE_RD ioctl to create a realm. This involves
>> delegating pages to the RMM to hold the Realm Descriptor (RD) and for
>> the base level of the Realm Translation Tables (RTT). A VMID also need
>> to be picked, since the RMM has a separate VMID address space a
>> dedicated allocator is added for this purpose.
>>
>> KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
>> before it is created. Configuration options can be classified as:
>>
>>   1. Parameters specific to the Realm stage2 (e.g. IPA Size, vmid, stage2
>>      entry level, entry level RTTs, number of RTTs in start level, LPA2)
>>      Most of these are not measured by RMM and comes from KVM book
>>      keeping.
>>
>>   2. Parameters controlling "Arm Architecture features for the VM". (e.g.
>>      SVE VL, PMU counters, number of HW BRPs/WPs), configured by the VMM
>>      using the "user ID register write" mechanism. These will be
>>      supported in the later patches.
>>
>>   3. Parameters are not part of the core Arm architecture but defined
>>      by the RMM spec (e.g. Hash algorithm for measurement,
>>      Personalisation value). These are programmed via
>>      KVM_CAP_ARM_RME_CONFIG_REALM.
>>
>> For the IPA size there is the possibility that the RMM supports a
>> different size to the IPA size supported by KVM for normal guests. At
>> the moment the 'normal limit' is exposed by KVM_CAP_ARM_VM_IPA_SIZE and
>> the IPA size is configured by the bottom bits of vm_type in
>> KVM_CREATE_VM. This means that it isn't easy for the VMM to discover
>> what IPA sizes are supported for Realm guests. Since the IPA is part of
>> the measurement of the realm guest the current expectation is that the
>> VMM will be required to pick the IPA size demanded by attestation and
>> therefore simply failing if this isn't available is fine. An option
>> would be to expose a new capability ioctl to obtain the RMM's maximum
>> IPA size if this is needed in the future.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v5:
>>   * Introduce free_delegated_granule() to replace many
>>     undelegate/free_page() instances and centralise the comment on
>>     leaking when the undelegate fails.
>>   * Several other minor improvements suggested by reviews - thanks for
>>     the feedback!
>> Changes since v2:
>>   * Improved commit description.
>>   * Improved return failures for rmi_check_version().
>>   * Clear contents of PGD after it has been undelegated in case the RMM
>>     left stale data.
>>   * Minor changes to reflect changes in previous patches.
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h |   5 +
>>   arch/arm64/include/asm/kvm_rme.h     |  19 ++
>>   arch/arm64/kvm/arm.c                 |  18 ++
>>   arch/arm64/kvm/mmu.c                 |  22 +-
>>   arch/arm64/kvm/rme.c                 | 296 +++++++++++++++++++++++++++
>>   5 files changed, 358 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/
>> include/asm/kvm_emulate.h
>> index 4d417e39763e..27f54a7778aa 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -715,6 +715,11 @@ static inline enum realm_state
>> kvm_realm_state(struct kvm *kvm)
>>       return READ_ONCE(kvm->arch.realm.state);
>>   }
>>   +static inline bool kvm_realm_is_created(struct kvm *kvm)
>> +{
>> +    return kvm_is_realm(kvm) && kvm_realm_state(kvm) !=
>> REALM_STATE_NONE;
>> +}
>> +
>>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>>   {
>>       return false;
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>> asm/kvm_rme.h
>> index 69af5c3a1e44..209cd99f03dd 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -6,6 +6,8 @@
>>   #ifndef __ASM_KVM_RME_H
>>   #define __ASM_KVM_RME_H
>>   +#include <uapi/linux/kvm.h>
>> +
>>   /**
>>    * enum realm_state - State of a Realm
>>    */
>> @@ -46,11 +48,28 @@ enum realm_state {
>>    * struct realm - Additional per VM data for a Realm
>>    *
>>    * @state: The lifetime state machine for the realm
>> + * @rd: Kernel mapping of the Realm Descriptor (RD)
>> + * @params: Parameters for the RMI_REALM_CREATE command
>> + * @num_aux: The number of auxiliary pages required by the RMM
>> + * @vmid: VMID to be used by the RMM for the realm
>> + * @ia_bits: Number of valid Input Address bits in the IPA
>>    */
>>   struct realm {
>>       enum realm_state state;
>> +
>> +    void *rd;
>> +    struct realm_params *params;
>> +
>> +    unsigned long num_aux;
>> +    unsigned int vmid;
>> +    unsigned int ia_bits;
>>   };
>>     void kvm_init_rme(void);
>> +u32 kvm_realm_ipa_limit(void);
>> +
>> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>> +int kvm_init_realm_vm(struct kvm *kvm);
>> +void kvm_destroy_realm(struct kvm *kvm);
>>     #endif
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 93087eca9c51..2bbf30d66424 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -153,6 +153,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>           }
>>           mutex_unlock(&kvm->slots_lock);
>>           break;
>> +    case KVM_CAP_ARM_RME:
>> +        if (!kvm_is_realm(kvm))
>> +            return -EINVAL;
>> +        mutex_lock(&kvm->lock);
>> +        r = kvm_realm_enable_cap(kvm, cap);
>> +        mutex_unlock(&kvm->lock);
>> +        break;
>>       default:
>>           break;
>>       }
> 
> The check of !kvm_is_realm() seems unnecessary because the same check
> will be
> done in kvm_realm_enable_cap().

Indeed, I'll drop this check.

>> @@ -215,6 +222,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned
>> long type)
>>         bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>>   +    /* Initialise the realm bits after the generic bits are enabled */
>> +    if (kvm_is_realm(kvm)) {
>> +        ret = kvm_init_realm_vm(kvm);
>> +        if (ret)
>> +            goto err_free_cpumask;
>> +    }
>> +
>>       return 0;
>>     err_free_cpumask:
>> @@ -274,6 +288,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>       kvm_unshare_hyp(kvm, kvm + 1);
>>         kvm_arm_teardown_hypercalls(kvm);
>> +    kvm_destroy_realm(kvm);
>>   }
>>     static bool kvm_has_full_ptr_auth(void)
>> @@ -421,6 +436,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>       case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
>>           r = BIT(0);
>>           break;
>> +    case KVM_CAP_ARM_RME:
>> +        r = static_key_enabled(&kvm_rme_is_available);
>> +        break;
>>       default:
>>           r = 0;
>>       }
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c9d46ad57e52..f09d580c12ad 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -863,12 +863,16 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>>       .icache_inval_pou    = invalidate_icache_guest_page,
>>   };
>>   -static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long
>> type)
>> +static int kvm_init_ipa_range(struct kvm *kvm,
>> +                  struct kvm_s2_mmu *mmu, unsigned long type)
>>   {
>>       u32 kvm_ipa_limit = get_kvm_ipa_limit();
>>       u64 mmfr0, mmfr1;
>>       u32 phys_shift;
>>   +    if (kvm_is_realm(kvm))
>> +        kvm_ipa_limit = kvm_realm_ipa_limit();
>> +
>>       if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>>           return -EINVAL;
>>   @@ -933,7 +937,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct
>> kvm_s2_mmu *mmu, unsigned long t
>>           return -EINVAL;
>>       }
>>   -    err = kvm_init_ipa_range(mmu, type);
>> +    err = kvm_init_ipa_range(kvm, mmu, type);
>>       if (err)
>>           return err;
>>   @@ -1056,6 +1060,20 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>       struct kvm_pgtable *pgt = NULL;
>>         write_lock(&kvm->mmu_lock);
>> +    if (kvm_is_realm(kvm) &&
>> +        (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>> +         kvm_realm_state(kvm) != REALM_STATE_NONE)) {
>> +        /* Tearing down RTTs will be added in a later patch */
>> +        write_unlock(&kvm->mmu_lock);
>> +
>> +        /*
>> +         * The physical PGD pages are delegated to the RMM, so cannot
>> +         * be freed at this point. This function will be called again
>> +         * from kvm_destroy_realm() after the physical pages have been
>> +         * returned at which point the memory can be freed.
>> +         */
>> +        return;
>> +    }
>>       pgt = mmu->pgt;
>>       if (pgt) {
>>           mmu->pgd_phys = 0;
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index b88269b80c11..5530ec2653b7 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -5,9 +5,20 @@
>>     #include <linux/kvm_host.h>
>>   +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_mmu.h>
>>   #include <asm/rmi_cmds.h>
>>   #include <asm/virt.h>
>>   +#include <asm/kvm_pgtable.h>
>> +
>> +static unsigned long rmm_feat_reg0;
>> +
>> +static bool rme_supports(unsigned long feature)
>> +{
>> +    return !!u64_get_bits(rmm_feat_reg0, feature);
>> +}
>> +
> 
> I don't have strong sense, but the name would be rme_has_feature() since
> the
> source is the RMM feature register-0.

Sure.

>>   static int rmi_check_version(void)
>>   {
>>       struct arm_smccc_res res;
>> @@ -36,6 +47,285 @@ static int rmi_check_version(void)
>>       return 0;
>>   }
>>   +u32 kvm_realm_ipa_limit(void)
>> +{
>> +    return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>> +}
>> +
>> +static int get_start_level(struct realm *realm)
>> +{
>> +    return 4 - stage2_pgtable_levels(realm->ia_bits);
>> +}
>> +
>> +static void free_delegated_granule(phys_addr_t phys)
>> +{
>> +    if (WARN_ON(rmi_granule_undelegate(phys))) {
>> +        /* Undelegate failed: leak the page */
>> +        return;
>> +    }
>> +
>> +    free_page((unsigned long)phys_to_virt(phys));
>> +}
>> +
>> +static int realm_create_rd(struct kvm *kvm)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    struct realm_params *params = realm->params;
>> +    void *rd = NULL;
>> +    phys_addr_t rd_phys, params_phys;
>> +    size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
>> +    int i, r;
>> +
>> +    if (WARN_ON(realm->rd) || WARN_ON(!realm->params))
>> +        return -EEXIST;
>> +
>> +    rd = (void *)__get_free_page(GFP_KERNEL);
>> +    if (!rd)
>> +        return -ENOMEM;
>> +
>> +    rd_phys = virt_to_phys(rd);
>> +    if (rmi_granule_delegate(rd_phys)) {
>> +        r = -ENXIO;
>> +        goto free_rd;
>> +    }
>> +
>> +    for (i = 0; i < pgd_size; i += PAGE_SIZE) {
>> +        phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
>> +
>> +        if (rmi_granule_delegate(pgd_phys)) {
>> +            r = -ENXIO;
>> +            goto out_undelegate_tables;
>> +        }
>> +    }
>> +
> 
> The step of 'i' is PAGE_SIZE, inconsistent with what has been done in
> the tag
> 'out_undelegate_tables' where the step is expected to be 1.

Ouch, good spot!

Thanks!

Steve

>> +    realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
>> +
>> +    params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
>> +    params->rtt_level_start = get_start_level(realm);
>> +    params->rtt_num_start = pgd_size / PAGE_SIZE;
>> +    params->rtt_base = kvm->arch.mmu.pgd_phys;
>> +    params->vmid = realm->vmid;
>> +
>> +    params_phys = virt_to_phys(params);
>> +
>> +    if (rmi_realm_create(rd_phys, params_phys)) {
>> +        r = -ENXIO;
>> +        goto out_undelegate_tables;
>> +    }
>> +
>> +    if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
>> +        WARN_ON(rmi_realm_destroy(rd_phys));
>> +        goto out_undelegate_tables;
>> +    }
>> +
>> +    realm->rd = rd;
>> +
>> +    return 0;
>> +
>> +out_undelegate_tables:
>> +    while (--i >= 0) {
>> +        phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
>> +
>> +        if (WARN_ON(rmi_granule_undelegate(pgd_phys))) {
>> +            /* Leak the pages if they cannot be returned */
>> +            kvm->arch.mmu.pgt = NULL;
>> +            break;
>> +        }
>> +    }
>> +    if (WARN_ON(rmi_granule_undelegate(rd_phys))) {
>> +        /* Leak the page if it isn't returned */
>> +        return r;
>> +    }
>> +free_rd:
>> +    free_page((unsigned long)rd);
>> +    return r;
>> +}
>> +
>> +/* Protects access to rme_vmid_bitmap */
>> +static DEFINE_SPINLOCK(rme_vmid_lock);
>> +static unsigned long *rme_vmid_bitmap;
>> +
>> +static int rme_vmid_init(void)
>> +{
>> +    unsigned int vmid_count = 1 << kvm_get_vmid_bits();
>> +
>> +    rme_vmid_bitmap = bitmap_zalloc(vmid_count, GFP_KERNEL);
>> +    if (!rme_vmid_bitmap) {
>> +        kvm_err("%s: Couldn't allocate rme vmid bitmap\n", __func__);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int rme_vmid_reserve(void)
>> +{
>> +    int ret;
>> +    unsigned int vmid_count = 1 << kvm_get_vmid_bits();
>> +
>> +    spin_lock(&rme_vmid_lock);
>> +    ret = bitmap_find_free_region(rme_vmid_bitmap, vmid_count, 0);
>> +    spin_unlock(&rme_vmid_lock);
>> +
>> +    return ret;
>> +}
>> +
>> +static void rme_vmid_release(unsigned int vmid)
>> +{
>> +    spin_lock(&rme_vmid_lock);
>> +    bitmap_release_region(rme_vmid_bitmap, vmid, 0);
>> +    spin_unlock(&rme_vmid_lock);
>> +}
>> +
>> +static int kvm_create_realm(struct kvm *kvm)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    int ret;
>> +
>> +    if (!kvm_is_realm(kvm))
>> +        return -EINVAL;
> 
> The duplicated check has been done in kvm_realm_enable_cap(). So it can be
> dropped safely.
> 
>> +    if (kvm_realm_is_created(kvm))
>> +        return -EEXIST;
>> +
>> +    ret = rme_vmid_reserve();
>> +    if (ret < 0)
>> +        return ret;
>> +    realm->vmid = ret;
>> +
>> +    ret = realm_create_rd(kvm);
>> +    if (ret) {
>> +        rme_vmid_release(realm->vmid);
>> +        return ret;
>> +    }
>> +
>> +    WRITE_ONCE(realm->state, REALM_STATE_NEW);
>> +
>> +    /* The realm is up, free the parameters.  */
>> +    free_page((unsigned long)realm->params);
>> +    realm->params = NULL;
>> +
>> +    return 0;
>> +}
>> +
>> +static int config_realm_hash_algo(struct realm *realm,
>> +                  struct kvm_cap_arm_rme_config_item *cfg)
>> +{
>> +    switch (cfg->hash_algo) {
>> +    case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256:
>> +        if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_256))
>> +            return -EINVAL;
>> +        break;
>> +    case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512:
>> +        if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_512))
>> +            return -EINVAL;
>> +        break;
>> +    default:
>> +        return -EINVAL;
>> +    }
>> +    realm->params->hash_algo = cfg->hash_algo;
>> +    return 0;
>> +}
>> +
>> +static int kvm_rme_config_realm(struct kvm *kvm, struct
>> kvm_enable_cap *cap)
>> +{
>> +    struct kvm_cap_arm_rme_config_item cfg;
>> +    struct realm *realm = &kvm->arch.realm;
>> +    int r = 0;
>> +
>> +    if (kvm_realm_is_created(kvm))
>> +        return -EBUSY;
>> +
>> +    if (copy_from_user(&cfg, (void __user *)cap->args[1], sizeof(cfg)))
>> +        return -EFAULT;
>> +
>> +    switch (cfg.cfg) {
>> +    case KVM_CAP_ARM_RME_CFG_RPV:
>> +        memcpy(&realm->params->rpv, &cfg.rpv, sizeof(cfg.rpv));
>> +        break;
>> +    case KVM_CAP_ARM_RME_CFG_HASH_ALGO:
>> +        r = config_realm_hash_algo(realm, &cfg);
>> +        break;
>> +    default:
>> +        r = -EINVAL;
>> +    }
>> +
>> +    return r;
>> +}
>> +
>> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>> +{
>> +    int r = 0;
>> +
>> +    if (!kvm_is_realm(kvm))
>> +        return -EINVAL;
>> +
>> +    switch (cap->args[0]) {
>> +    case KVM_CAP_ARM_RME_CONFIG_REALM:
>> +        r = kvm_rme_config_realm(kvm, cap);
>> +        break;
>> +    case KVM_CAP_ARM_RME_CREATE_RD:
>> +        r = kvm_create_realm(kvm);
>> +        break;
>> +    default:
>> +        r = -EINVAL;
>> +        break;
>> +    }
>> +
>> +    return r;
>> +}
>> +
>> +void kvm_destroy_realm(struct kvm *kvm)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
>> +    int i;
>> +
>> +    if (realm->params) {
>> +        free_page((unsigned long)realm->params);
>> +        realm->params = NULL;
>> +    }
>> +
>> +    if (!kvm_realm_is_created(kvm))
>> +        return;
>> +
>> +    WRITE_ONCE(realm->state, REALM_STATE_DYING);
>> +
>> +    if (realm->rd) {
>> +        phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +
>> +        if (WARN_ON(rmi_realm_destroy(rd_phys)))
>> +            return;
>> +        free_delegated_granule(rd_phys);
>> +        realm->rd = NULL;
>> +    }
>> +
>> +    rme_vmid_release(realm->vmid);
>> +
>> +    for (i = 0; i < pgd_size; i += PAGE_SIZE) {
>> +        phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
>> +
>> +        if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
>> +            return;
>> +    }
>> +
>> +    WRITE_ONCE(realm->state, REALM_STATE_DEAD);
>> +
>> +    /* Now that the Realm is destroyed, free the entry level RTTs */
>> +    kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +}
>> +
>> +int kvm_init_realm_vm(struct kvm *kvm)
>> +{
>> +    struct realm_params *params;
>> +
>> +    params = (struct realm_params *)get_zeroed_page(GFP_KERNEL);
>> +    if (!params)
>> +        return -ENOMEM;
>> +
>> +    kvm->arch.realm.params = params;
>> +    return 0;
>> +}
>> +
>>   void kvm_init_rme(void)
>>   {
>>       if (PAGE_SIZE != SZ_4K)
>> @@ -46,5 +336,11 @@ void kvm_init_rme(void)
>>           /* Continue without realm support */
>>           return;
>>   +    if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
>> +        return;
>> +
>> +    if (rme_vmid_init())
>> +        return;
>> +
>>       /* Future patch will enable static branch kvm_rme_is_available */
>>   }
> 
> Thanks,
> Gavin
> 


