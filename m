Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D8D5E5B6
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 15:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfGCNri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 09:47:38 -0400
Received: from foss.arm.com ([217.140.110.172]:48412 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCNri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 09:47:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C075A2B;
        Wed,  3 Jul 2019 06:47:36 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EFE253F718;
        Wed,  3 Jul 2019 06:47:35 -0700 (PDT)
Subject: Re: [PATCH 35/59] KVM: arm/arm64: nv: Support multiple nested stage 2
 mmu structures
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-36-marc.zyngier@arm.com>
 <6a59df67-1b5e-6737-449c-d779537adf3e@arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <0e0de9a8-b165-572e-af8f-6828e7aee49f@arm.com>
Date:   Wed, 3 Jul 2019 14:47:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6a59df67-1b5e-6737-449c-d779537adf3e@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/2019 13:19, Alexandru Elisei wrote:
> On 6/21/19 10:38 AM, Marc Zyngier wrote:
>> From: Christoffer Dall <christoffer.dall@arm.com>
>>
>> Add stage 2 mmu data structures for virtual EL2 and for nested guests.
>> We don't yet populate shadow stage 2 page tables, but we now have a
>> framework for getting to a shadow stage 2 pgd.
>>
>> We allocate twice the number of vcpus as stage 2 mmu structures because
>> that's sufficient for each vcpu running two VMs without having to flush
>> the stage 2 page tables.
>>
>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_host.h     |   4 +
>>  arch/arm/include/asm/kvm_mmu.h      |   3 +
>>  arch/arm64/include/asm/kvm_host.h   |  28 +++++
>>  arch/arm64/include/asm/kvm_mmu.h    |   8 ++
>>  arch/arm64/include/asm/kvm_nested.h |   7 ++
>>  arch/arm64/kvm/nested.c             | 172 ++++++++++++++++++++++++++++
>>  virt/kvm/arm/arm.c                  |  16 ++-
>>  virt/kvm/arm/mmu.c                  |  31 ++---
>>  8 files changed, 254 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index e3217c4ad25b..b821eb2383ad 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -424,4 +424,8 @@ static inline bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>>  	return true;
>>  }
>>  
>> +static inline void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu) {}
>> +static inline int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu) { return 0; }
>> +
>>  #endif /* __ARM_KVM_HOST_H__ */
>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>> index be23e3f8e08c..e6984b6da2ce 100644
>> --- a/arch/arm/include/asm/kvm_mmu.h
>> +++ b/arch/arm/include/asm/kvm_mmu.h
>> @@ -420,6 +420,9 @@ static inline int hyp_map_aux_data(void)
>>  
>>  static inline void kvm_set_ipa_limit(void) {}
>>  
>> +static inline void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu) {}
>> +static inline void kvm_init_nested(struct kvm *kvm) {}
>> +
>>  static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
>>  {
>>  	struct kvm_vmid *vmid = &mmu->vmid;
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 3dee5e17a4ee..cc238de170d2 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -88,11 +88,39 @@ struct kvm_s2_mmu {
>>  	phys_addr_t	pgd_phys;
>>  
>>  	struct kvm *kvm;
>> +
>> +	/*
>> +	 * For a shadow stage-2 MMU, the virtual vttbr programmed by the guest
>> +	 * hypervisor.  Unused for kvm_arch->mmu. Set to 1 when the structure
>> +	 * contains no valid information.
>> +	 */
>> +	u64	vttbr;
>> +
>> +	/* true when this represents a nested context where virtual HCR_EL2.VM == 1 */
>> +	bool	nested_stage2_enabled;
>> +
>> +	/*
>> +	 *  0: Nobody is currently using this, check vttbr for validity
>> +	 * >0: Somebody is actively using this.
>> +	 */
>> +	atomic_t refcnt;
>>  };
>>  
>> +static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
>> +{
>> +	return !(mmu->vttbr & 1);
>> +}
>> +
>>  struct kvm_arch {
>>  	struct kvm_s2_mmu mmu;
>>  
>> +	/*
>> +	 * Stage 2 paging stage for VMs with nested virtual using a virtual
>> +	 * VMID.
>> +	 */
>> +	struct kvm_s2_mmu *nested_mmus;
>> +	size_t nested_mmus_size;
>> +
>>  	/* VTCR_EL2 value for this VM */
>>  	u64    vtcr;
>>  
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 1eb6e0ca61c2..32bcaa1845dc 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -100,6 +100,7 @@ alternative_cb_end
>>  #include <asm/mmu_context.h>
>>  #include <asm/pgtable.h>
>>  #include <asm/kvm_emulate.h>
>> +#include <asm/kvm_nested.h>
>>  
>>  void kvm_update_va_mask(struct alt_instr *alt,
>>  			__le32 *origptr, __le32 *updptr, int nr_inst);
>> @@ -164,6 +165,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>>  			     void **haddr);
>>  void free_hyp_pgds(void);
>>  
>> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
>>  void stage2_unmap_vm(struct kvm *kvm);
>>  int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
>>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>> @@ -635,5 +637,11 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
>>  	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
>>  }
>>  
>> +static inline u64 get_vmid(u64 vttbr)
>> +{
>> +	return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
>> +		VTTBR_VMID_SHIFT;
>> +}
>> +
>>  #endif /* __ASSEMBLY__ */
>>  #endif /* __ARM64_KVM_MMU_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>> index 61e71d0d2151..d4021d0892bd 100644
>> --- a/arch/arm64/include/asm/kvm_nested.h
>> +++ b/arch/arm64/include/asm/kvm_nested.h
>> @@ -10,6 +10,13 @@ static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
>>  		test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features);
>>  }
>>  
>> +extern void kvm_init_nested(struct kvm *kvm);
>> +extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>> +extern void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu);
>> +extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr);
>> +extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
>> +extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
>> +
>>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>>  extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>>  extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>> index 3872e3cf1691..4b38dc5c0be3 100644
>> --- a/arch/arm64/kvm/nested.c
>> +++ b/arch/arm64/kvm/nested.c
>> @@ -18,7 +18,161 @@
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>>  
>> +#include <asm/kvm_arm.h>
>>  #include <asm/kvm_emulate.h>
>> +#include <asm/kvm_mmu.h>
>> +#include <asm/kvm_nested.h>
>> +
>> +void kvm_init_nested(struct kvm *kvm)
>> +{
>> +	kvm_init_s2_mmu(&kvm->arch.mmu);
>> +
>> +	kvm->arch.nested_mmus = NULL;
>> +	kvm->arch.nested_mmus_size = 0;
>> +}
>> +
>> +int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct kvm_s2_mmu *tmp;
>> +	int num_mmus;
>> +	int ret = -ENOMEM;
>> +
>> +	if (!test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features))
>> +		return 0;
>> +
>> +	if (!cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
>> +		return -EINVAL;
> 
> Here we fail if KVM_ARM_VCPU_NESTED_VIRT features was requested from the virtual
> vcpu, but the nested capability isn't present. This function is called as a
> result of the KVM_ARM_VCPU_INIT, and when this function fails, the
> KVM_ARM_VCPU_INIT ioctl will also fail. This means that we cannot have a vcpu
> with the nested virt feature on a system which doesn't support nested
> virtualization.
> 
> However, commit 04/59 "KVM: arm64: nv: Introduce nested virtualization VCPU
> feature" added the function nested_virt_in_use (in
> arch/arm64/include/asm/kvm_nested.h) which checks for **both** conditions before
> returning true. I believe the capability check is not required in
> nested_virt_in_use.

The capability check is a static branch, meaning that if there is no
actual evaluation, just a branch. If you remove this branch, you end-up
checking the feature bit even on systems that do not have NV, and that'd
be a measurable performance drag.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
