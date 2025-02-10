Return-Path: <kvm+bounces-37692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD13FA2EC13
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 12:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E2203A9674
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 11:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE17B1F8691;
	Mon, 10 Feb 2025 11:58:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874A51F63F9;
	Mon, 10 Feb 2025 11:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739188692; cv=none; b=PXzR+AXAqTrmwu1nYEg/nBDmnVeOtWajT/+bxkRuKDJqv24t8x2anTkoNtk6/FyR4baStEzsC6FGgJmfPmS8BRXbun5/Ni+C2DDRJsEZehd6NOSMCVIe0dCRRzjDVNRyYbDHaTz9S5/El5o8Bbm6kiicmJ0UrG/dPEHHicc7HcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739188692; c=relaxed/simple;
	bh=hL9rrvSME9i1CXiLNY5ZTPrGW/xLRIM2uh3rjlwqY3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X2nc0JEBKgM7g0znsIPNGYqNfUyGSHKxf02fdUbmWj4Cx4O8sRiHsKywIKbR+MLwfvVPgh49ZU1/i7Gj3SKycs5Rot7L1o4GT4oOi+ZDLtnGO/SlG783ny4X9gXFHXJRzRgfJlPHLX/hozz/l1221EVv+i+kh5N+ZWN7c4Xe3Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CFB1113E;
	Mon, 10 Feb 2025 03:58:31 -0800 (PST)
Received: from [10.57.78.92] (unknown [10.57.78.92])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B96843F5A1;
	Mon, 10 Feb 2025 03:58:05 -0800 (PST)
Message-ID: <9c216f6d-c885-41e7-ad66-656a09035e9b@arm.com>
Date: Mon, 10 Feb 2025 11:58:03 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 32/43] arm64: rme: Enable PMU support with a realm
 guest
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-33-steven.price@arm.com>
 <20241212165440.GA1479329@e124191.cambridge.arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20241212165440.GA1479329@e124191.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/12/2024 16:54, Joey Gouly wrote:
> On Thu, Dec 12, 2024 at 03:55:57PM +0000, Steven Price wrote:
>> Use the PMU registers from the RmiRecExit structure to identify when an
>> overflow interrupt is due and inject it into the guest. Also hook up the
>> configuration option for enabling the PMU within the guest.
>>
>> When entering a realm guest with a PMU interrupt pending, it is
>> necessary to disable the physical interrupt. Otherwise when the RMM
>> restores the PMU state the physical interrupt will trigger causing an
>> immediate exit back to the host. The guest is expected to acknowledge
>> the interrupt causing a host exit (to update the GIC state) which gives
>> the opportunity to re-enable the physical interrupt before the next PMU
>> event.
>>
>> Number of PMU counters is configured by the VMM by writing to PMCR.N.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v2:
>>  * Add a macro kvm_pmu_get_irq_level() to avoid compile issues when PMU
>>    support is disabled.
>> ---
>>  arch/arm64/kvm/arm.c      | 11 +++++++++++
>>  arch/arm64/kvm/guest.c    |  7 +++++++
>>  arch/arm64/kvm/pmu-emul.c |  3 +++
>>  arch/arm64/kvm/rme.c      |  8 ++++++++
>>  arch/arm64/kvm/sys_regs.c |  2 +-
>>  include/kvm/arm_pmu.h     |  4 ++++
>>  6 files changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 6f7f96ab781d..ae3596a25272 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/vmalloc.h>
>>  #include <linux/fs.h>
>>  #include <linux/mman.h>
>> +#include <linux/perf/arm_pmu.h>
>>  #include <linux/sched.h>
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_irqfd.h>
>> @@ -1209,6 +1210,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  	run->exit_reason = KVM_EXIT_UNKNOWN;
>>  	run->flags = 0;
>>  	while (ret > 0) {
>> +		bool pmu_stopped = false;
>> +
>>  		/*
>>  		 * Check conditions before entering the guest
>>  		 */
>> @@ -1240,6 +1243,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  
>>  		kvm_pmu_flush_hwstate(vcpu);
>>  
>> +		if (vcpu_is_rec(vcpu) && kvm_pmu_get_irq_level(vcpu)) {
>> +			pmu_stopped = true;
>> +			arm_pmu_set_phys_irq(false);
>> +		}
>> +
>>  		local_irq_disable();
>>  
>>  		kvm_vgic_flush_hwstate(vcpu);
>> @@ -1342,6 +1350,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  
>>  		preempt_enable();
>>  
>> +		if (pmu_stopped)
>> +			arm_pmu_set_phys_irq(true);
>> +
>>  		/*
>>  		 * The ARMv8 architecture doesn't give the hypervisor
>>  		 * a mechanism to prevent a guest from dropping to AArch32 EL0
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index 920e0fd73698..b4e3839f6076 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -804,6 +804,8 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>  	return kvm_arm_sys_reg_get_reg(vcpu, reg);
>>  }
>>  
>> +#define KVM_REG_ARM_PMCR_EL0		ARM64_SYS_REG(3, 3, 9, 12, 0)
> 
> There's already SYS_PMCR_EL0 defined, so it seems this is not needed?

ARM64_SYS_REG() is slightly different from the sys_reg() macro used by
SYS_PMCR_EL0. The ARM64_SYS_REG() macro encodes extra bits about the
register size (KVM_REG_SIZE_U64) and that this is an arm64 system
register (KVM_REG_ARM64 | KVM_REG_ARM64_SYSREG).

There is a KVM_ARM64_SYS_REG() macro used by the selftests which would
allow using the SYS_PMCR_EL0 to avoid repeating the encoding, but I
can't find an equivalent outside the selftests.

To be honest I'm not sure quite what the best option here is. I was
tempted to put them in uapi/asm/kvm.h but other than the timer registers
(which have quirks due to a accident in the past) we don't define any
other register names as uABI - and there's no particular reason to start
for this one.

Thanks,
Steve

>> +
>>  /*
>>   * The RMI ABI only enables setting some GPRs and PC. The selection of GPRs
>>   * that are available depends on the Realm state and the reason for the last
>> @@ -818,6 +820,11 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
>>  		u64 off = core_reg_offset_from_id(reg->id);
>>  
>>  		return kvm_realm_validate_core_reg(off);
>> +	} else {
>> +		switch (reg->id) {
>> +		case KVM_REG_ARM_PMCR_EL0:
>> +			return true;
>> +		}
>>  	}
>>  
>>  	return false;
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index 456102bc0b55..5628b573ca41 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -397,6 +397,9 @@ static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
>>  {
>>  	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>>  
>> +	if (vcpu_is_rec(vcpu))
>> +		return vcpu->arch.rec.run->exit.pmu_ovf_status;
>> +
>>  	reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
>>  
>>  	/*
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 27a479feb907..e562e77c1f94 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -303,6 +303,11 @@ static int realm_create_rd(struct kvm *kvm)
>>  	params->rtt_base = kvm->arch.mmu.pgd_phys;
>>  	params->vmid = realm->vmid;
>>  
>> +	if (kvm->arch.arm_pmu) {
>> +		params->pmu_num_ctrs = kvm->arch.pmcr_n;
>> +		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
>> +	}
>> +
>>  	params_phys = virt_to_phys(params);
>>  
>>  	if (rmi_realm_create(rd_phys, params_phys)) {
>> @@ -1370,6 +1375,9 @@ int kvm_create_rec(struct kvm_vcpu *vcpu)
>>  	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
>>  		return -EINVAL;
>>  
>> +	if (vcpu->kvm->arch.arm_pmu && !kvm_vcpu_has_pmu(vcpu))
>> +		return -EINVAL;
>> +
>>  	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
>>  	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
>>  
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 83c6b4a07ef5..a4713609e230 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1324,7 +1324,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>>  	 * implements. Ignore this error to maintain compatibility
>>  	 * with the existing KVM behavior.
>>  	 */
>> -	if (!kvm_vm_has_ran_once(kvm) &&
>> +	if (!kvm_vm_has_ran_once(kvm) && !kvm_realm_is_created(kvm) &&
>>  	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
>>  		kvm->arch.pmcr_n = new_n;
>>  
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index e61dd7dd2286..30625a6fd143 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -77,6 +77,8 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
>>  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>>  void kvm_vcpu_pmu_resync_el0(void);
>>  
>> +#define kvm_pmu_get_irq_level(vcpu) ((vcpu)->arch.pmu.irq_level)
>> +
>>  #define kvm_vcpu_has_pmu(vcpu)					\
>>  	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
>>  
>> @@ -164,6 +166,8 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>>  	return 0;
>>  }
>>  
>> +#define kvm_pmu_get_irq_level(vcpu) (false)
>> +
>>  #define kvm_vcpu_has_pmu(vcpu)		({ false; })
>>  static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
> 
> Thanks,
> Joey


