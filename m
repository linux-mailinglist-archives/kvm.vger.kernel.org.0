Return-Path: <kvm+bounces-45091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC7D8AA5F72
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:45:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4278463073
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7E61D63D3;
	Thu,  1 May 2025 13:45:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C6C1A08B8;
	Thu,  1 May 2025 13:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746107101; cv=none; b=F6xlyLMgLKIZVzV2Sgf/6CWjaPpQa01ZYWCfeRvIl4RSKKiqga7ncUtpt138YVEM3jgACgzNDIGtNqrLyWe69783m8knXY1W9Yo4zDjKzsvOkdbvQ8MRkOWNpwQjJ/4F8tHcJgJ2kMfGmlEHfFyFxyPp08sz6B5vHgKIKEXambg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746107101; c=relaxed/simple;
	bh=kKenmRzGfOHmyjzOAoGBmpGNmDMllmOINdon1Jn8QkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kAkRD0Hh2z/J+5mSSRWjhQeTCQ4LqZePggf3wW1OV9aD0S1ha7Ht5AqGb59Sc4wIDxoMe+oZTw0rwJbGjANmalYQ4RQSt5v3HmYweTGPH/YX9FjdQK04e2Pzc5zmZ2PPDdihktYmIJSojgwqVRR6roY+e4PYp1oyVeWnouArrcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8A2E168F;
	Thu,  1 May 2025 06:44:49 -0700 (PDT)
Received: from [10.1.33.27] (e122027.cambridge.arm.com [10.1.33.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE1B63F5A1;
	Thu,  1 May 2025 06:44:53 -0700 (PDT)
Message-ID: <9004ac7b-2df5-42c3-b3af-729ef5107822@arm.com>
Date: Thu, 1 May 2025 14:44:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/43] arm64: RME: Define the user ABI
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
 <20250416134208.383984-7-steven.price@arm.com>
 <dac9f2c6-d46e-4232-abbd-8aa097f012a5@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <dac9f2c6-d46e-4232-abbd-8aa097f012a5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 30/04/2025 05:25, Gavin Shan wrote:
> On 4/16/25 11:41 PM, Steven Price wrote:
>> There is one (multiplexed) CAP which can be used to create, populate and
>> then activate the realm.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v7:
>>   * Add documentation of new ioctls
>>   * Bump the magic numbers to avoid conflicts
>> Changes since v6:
>>   * Rename some of the symbols to make their usage clearer and avoid
>>     repetition.
>> Changes from v5:
>>   * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>>     KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
>> ---
>>   Documentation/virt/kvm/api.rst    | 70 +++++++++++++++++++++++++++++++
>>   arch/arm64/include/uapi/asm/kvm.h | 49 ++++++++++++++++++++++
>>   include/uapi/linux/kvm.h          | 10 +++++
>>   3 files changed, 129 insertions(+)
>>
> 
> With below comment addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/
>> api.rst
>> index 1f8625b7646a..99ba6c82cf37 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -3527,6 +3527,11 @@ Possible features:
>>             - the KVM_REG_ARM64_SVE_VLS pseudo-register is immutable,
>> and can
>>               no longer be written using KVM_SET_ONE_REG.
>>   +    - KVM_ARM_VCPU_REC: Allocate a REC (Realm Execution Context)
>> for this
>> +      VCPU. This must be specified on all VCPUs created in a Realm VM.
>> +      Depends on KVM_CAP_ARM_RME.
>> +      Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_REC).
>> +
>>   4.83 KVM_ARM_PREFERRED_TARGET
>>   -----------------------------
>>   @@ -5098,6 +5103,7 @@ Recognised values for feature:
>>       =====      ===========================================
>>     arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
>> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
>>     =====      ===========================================
>>     Finalizes the configuration of the specified vcpu feature.
>> @@ -6452,6 +6458,30 @@ the capability to be present.
>>     `flags` must currently be zero.
>>   +4.144 KVM_ARM_VCPU_RMM_PSCI_COMPLETE
>> +------------------------------------
>> +
>> +:Capability: KVM_CAP_ARM_RME
>> +:Architectures: arm64
>> +:Type: vcpu ioctl
>> +:Parameters: struct kvm_arm_rmm_psci_complete (in)
>> +:Returns: 0 if successful, < 0 on error
>> +
>> +::
>> +
>> +  struct kvm_arm_rmm_psci_complete {
>> +    __u64 target_mpidr;
>> +    __u32 psci_status;
>> +    __u32 padding[3];
>> +  };
>> +
>> +Where PSCI functions are handled by user space, the RMM needs to be
>> informed of
>> +the target of the operation using `target_mpidr`, along with the status
>> +(`psci_status`). The RMM v1.0 specification defines two functions
>> that require
>> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
>> +
>> +If the kernel is handling PSCI then this is done automatically and
>> the VMM
>> +doesn't need to call this ioctl.
>>     .. _kvm_run:
>>   @@ -8280,6 +8310,46 @@ aforementioned registers before the first
>> KVM_RUN. These registers are VM
>>   scoped, meaning that the same set of values are presented on all
>> vCPUs in a
>>   given VM.
>>   +7.38 KVM_CAP_ARM_RME
>> +--------------------
>> +
>> +:Architectures: arm64
>> +:Target: VM
>> +:Parameters: args[0] provides an action, args[1] points to a
>> structure in
>> +         memory for some actions.
>> +:Returns: 0 on success, negative value on error
>> +
>> +Used to configure and set up the memory for a Realm. The available
>> actions are:
>> +
>> +=================================
>> =============================================
>> + KVM_CAP_ARM_RME_CONFIG_REALM     Takes struct arm_rme_config as
>> args[1] and
>> +                                  configures realm parameters prior
>> to it being
>> +                                  created.
>> +
>> +                                  Options are ARM_RME_CONFIG_RPV to
>> set the
>> +                                  "Realm Personalization Value" and
>> +                                  ARM_RME_CONFIG_HASH_ALGO to set the
>> hash
>> +                                  algorithm.
>> +
>> + KVM_CAP_ARM_RME_CREATE_REALM     Request the RMM create the realm.
>> The realm's
>> +                                  configuration parameters must be
>> set first.
>> +
>> + KVM_CAP_ARM_RME_INIT_RIPAS_REALM Takes struct arm_rme_init_ripas as
>> args[1]
>> +                                  and sets the RIPAS (Realm IPA
>> State) to
>> +                                  RIPAS_RAM of a specified area of
>> the realm's
>> +                                  IPA.
>> +
>> + KVM_CAP_ARM_RME_POPULATE_REALM   Takes struct arm_rme_init_ripas as
>> args[1]
>> +                                  and populates a region of protected
>> address
>> +                                  space by copying the data from the
>> shared
>> +                                  alias.
>> +
>> + KVM_CAP_ARM_RME_ACTIVATE_REALM   Request the RMM activate the realm. No
>> +                                  further changes can be made to the
>> realm's
>> +                                  configuration, and VCPUs are not
>> permitted to
>> +                                  enter the realm until it has been
>> activated.
>                                                              
> ^^^^^^^^^^^^^^^^^^
> s/has been activated/is deactivated

I think I worded it badly before (as Susuki has already pointed out) and
you haven't understood what I intended.

VCPUs can be added to a Realm guest up until the ACTIVATE_REALM call.
There is no "deactivate" - you would need to destroy the guest and start
again.

What I intended was to say that a VCPU must not be executed (KVM_RUN)
until the ACTIVE_REALM call.

> I don't see where the guard is applied to prevent vCPU is added after realm
> has been activated. I may missed that. Otherwise, it's something to be
> improved
> n the subsequent patch where a vCPU is created and added to the realm.

This is handled in kvm_create_rec() where there's a check that
kvm_realm_state() != REALM_STATE_NEW. This prevents finalization of a
VCPU unless the realm is still in "new" state.

Admittedly this doesn't technically stop the user creating a VCPU. I
could add a check in kvm_arch_vcpu_create(), however this wouldn't stop
a VMM creating a VCPU and not finalising it before activating the realm.
So we'd end up with the same situation. I'm not sure whether it's worth
trying to stop the VMM or if I should just reword to say that the VMM
shouldn't do this.

I don't believe anything bad will happen to the host in these situations
- you will just end up with a useless VCPU which cannot be run.

Thanks,
Steve

>> +=================================
>> =============================================
>> +
>>   8. Other capabilities.
>>   ======================
>>   diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/
>> uapi/asm/kvm.h
>> index af9d9acaf997..b57712880605 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -106,6 +106,7 @@ struct kvm_regs {
>>   #define KVM_ARM_VCPU_PTRAUTH_GENERIC    6 /* VCPU uses generic
>> authentication */
>>   #define KVM_ARM_VCPU_HAS_EL2        7 /* Support nested
>> virtualization */
>>   #define KVM_ARM_VCPU_HAS_EL2_E2H0    8 /* Limit NV support to E2H
>> RES0 */
>> +#define KVM_ARM_VCPU_REC        9 /* VCPU REC state as part of Realm */
>>     struct kvm_vcpu_init {
>>       __u32 target;
>> @@ -429,6 +430,54 @@ enum {
>>   #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES    3
>>   #define   KVM_DEV_ARM_ITS_CTRL_RESET        4
>>   +/* KVM_CAP_ARM_RME on VM fd */
>> +#define KVM_CAP_ARM_RME_CONFIG_REALM        0
>> +#define KVM_CAP_ARM_RME_CREATE_REALM        1
>> +#define KVM_CAP_ARM_RME_INIT_RIPAS_REALM    2
>> +#define KVM_CAP_ARM_RME_POPULATE_REALM        3
>> +#define KVM_CAP_ARM_RME_ACTIVATE_REALM        4
>> +
>> +/* List of configuration items accepted for
>> KVM_CAP_ARM_RME_CONFIG_REALM */
>> +#define ARM_RME_CONFIG_RPV            0
>> +#define ARM_RME_CONFIG_HASH_ALGO        1
>> +
>> +#define ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA256        0
>> +#define ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA512        1
>> +
>> +#define ARM_RME_CONFIG_RPV_SIZE 64
>> +
>> +struct arm_rme_config {
>> +    __u32 cfg;
>> +    union {
>> +        /* cfg == ARM_RME_CONFIG_RPV */
>> +        struct {
>> +            __u8    rpv[ARM_RME_CONFIG_RPV_SIZE];
>> +        };
>> +
>> +        /* cfg == ARM_RME_CONFIG_HASH_ALGO */
>> +        struct {
>> +            __u32    hash_algo;
>> +        };
>> +
>> +        /* Fix the size of the union */
>> +        __u8    reserved[256];
>> +    };
>> +};
>> +
>> +#define KVM_ARM_RME_POPULATE_FLAGS_MEASURE    (1 << 0)
>> +struct arm_rme_populate_realm {
>> +    __u64 base;
>> +    __u64 size;
>> +    __u32 flags;
>> +    __u32 reserved[3];
>> +};
>> +
>> +struct arm_rme_init_ripas {
>> +    __u64 base;
>> +    __u64 size;
>> +    __u64 reserved[2];
>> +};
>> +
>>   /* Device Control API on vcpu fd */
>>   #define KVM_ARM_VCPU_PMU_V3_CTRL    0
>>   #define   KVM_ARM_VCPU_PMU_V3_IRQ    0
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index b6ae8ad8934b..0b8479985581 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -930,6 +930,7 @@ struct kvm_enable_cap {
>>   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>>   #define KVM_CAP_X86_GUEST_MODE 238
>>   #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
>> +#define KVM_CAP_ARM_RME 240
>>     struct kvm_irq_routing_irqchip {
>>       __u32 irqchip;
>> @@ -1582,4 +1583,13 @@ struct kvm_pre_fault_memory {
>>       __u64 padding[5];
>>   };
>>   +/* Available with KVM_CAP_ARM_RME, only for VMs with
>> KVM_VM_TYPE_ARM_REALM  */
>> +struct kvm_arm_rmm_psci_complete {
>> +    __u64 target_mpidr;
>> +    __u32 psci_status;
>> +    __u32 padding[3];
>> +};
>> +
>> +#define KVM_ARM_VCPU_RMM_PSCI_COMPLETE    _IOW(KVMIO, 0xd6, struct
>> kvm_arm_rmm_psci_complete)
>> +
>>   #endif /* __LINUX_KVM_H */
> 
> Thanks,
> Gavin
> 


