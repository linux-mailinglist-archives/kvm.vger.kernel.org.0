Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E206297CB
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 14:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391383AbfEXMIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 08:08:00 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:41548 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391244AbfEXMIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 08:08:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A98E1374;
        Fri, 24 May 2019 05:07:59 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AEA23F703;
        Fri, 24 May 2019 05:07:55 -0700 (PDT)
Subject: Re: [PATCH v2 12/15] KVM: arm64: add a new vcpu device control group
 for SPEv1
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Julien Thierry <julien.thierry@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
 <20190523103502.25925-13-sudeep.holla@arm.com>
 <a2d64bf0-2424-83c5-d3c8-17affd59dd20@arm.com>
 <20190524112145.GC13121@e107155-lin>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
Organization: ARM Ltd
Message-ID: <18bb9089-263b-5b67-80b4-66547ac09e24@arm.com>
Date:   Fri, 24 May 2019 13:07:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524112145.GC13121@e107155-lin>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/2019 12:21, Sudeep Holla wrote:
> On Fri, May 24, 2019 at 11:37:51AM +0100, Marc Zyngier wrote:
>> Hi Sudeep,
>>
>> On 23/05/2019 11:34, Sudeep Holla wrote:
>>> To configure the virtual SPEv1 overflow interrupt number, we use the
>>> vcpu kvm_device ioctl, encapsulating the KVM_ARM_VCPU_SPE_V1_IRQ
>>> attribute within the KVM_ARM_VCPU_SPE_V1_CTRL group.
>>>
>>> After configuring the SPEv1, call the vcpu ioctl with attribute
>>> KVM_ARM_VCPU_SPE_V1_INIT to initialize the SPEv1.
>>>
>>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>>> ---
>>>  Documentation/virtual/kvm/devices/vcpu.txt |  28 ++++
>>>  arch/arm64/include/asm/kvm_host.h          |   2 +-
>>>  arch/arm64/include/uapi/asm/kvm.h          |   4 +
>>>  arch/arm64/kvm/Makefile                    |   1 +
>>>  arch/arm64/kvm/guest.c                     |   9 ++
>>>  arch/arm64/kvm/reset.c                     |   3 +
>>>  include/kvm/arm_spe.h                      |  35 +++++
>>>  include/uapi/linux/kvm.h                   |   1 +
>>>  virt/kvm/arm/arm.c                         |   1 +
>>>  virt/kvm/arm/spe.c                         | 163 +++++++++++++++++++++
>>>  10 files changed, 246 insertions(+), 1 deletion(-)
>>>  create mode 100644 virt/kvm/arm/spe.c
>>>
>>> diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
>>> index 2b5dab16c4f2..d1ece488aeee 100644
>>> --- a/Documentation/virtual/kvm/devices/vcpu.txt
>>> +++ b/Documentation/virtual/kvm/devices/vcpu.txt
>>> @@ -60,3 +60,31 @@ time to use the number provided for a given timer, overwriting any previously
>>>  configured values on other VCPUs.  Userspace should configure the interrupt
>>>  numbers on at least one VCPU after creating all VCPUs and before running any
>>>  VCPUs.
>>> +
>>> +3. GROUP: KVM_ARM_VCPU_SPE_V1_CTRL
>>> +Architectures: ARM64
>>> +
>>> +1.1. ATTRIBUTE: KVM_ARM_VCPU_SPE_V1_IRQ
>>> +Parameters: in kvm_device_attr.addr the address for SPE buffer overflow interrupt
>>> +	    is a pointer to an int
>>> +Returns: -EBUSY: The SPE overflow interrupt is already set
>>> +         -ENXIO: The overflow interrupt not set when attempting to get it
>>> +         -ENODEV: SPEv1 not supported
>>> +         -EINVAL: Invalid SPE overflow interrupt number supplied or
>>> +                  trying to set the IRQ number without using an in-kernel
>>> +                  irqchip.
>>> +
>>> +A value describing the SPEv1 (Statistical Profiling Extension v1) overflow
>>> +interrupt number for this vcpu. This interrupt should be PPI and the interrupt
>>> +type and number must be same for each vcpu.
>>> +
>>> +1.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_V1_INIT
>>> +Parameters: no additional parameter in kvm_device_attr.addr
>>> +Returns: -ENODEV: SPEv1 not supported or GIC not initialized
>>> +         -ENXIO: SPEv1 not properly configured or in-kernel irqchip not
>>> +                 configured as required prior to calling this attribute
>>> +         -EBUSY: SPEv1 already initialized
>>> +
>>> +Request the initialization of the SPEv1.  If using the SPEv1 with an in-kernel
>>> +virtual GIC implementation, this must be done after initializing the in-kernel
>>> +irqchip.
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 6921fdfd477b..fc4ead0774b3 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -50,7 +50,7 @@
>>>  
>>>  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>>>  
>>> -#define KVM_VCPU_MAX_FEATURES 7
>>> +#define KVM_VCPU_MAX_FEATURES 8
>>>  
>>>  #define KVM_REQ_SLEEP \
>>>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>>> index 7b7ac0f6cec9..4c9e168de896 100644
>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>> @@ -106,6 +106,7 @@ struct kvm_regs {
>>>  #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
>>>  #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
>>>  #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>>> +#define KVM_ARM_VCPU_SPE_V1		7 /* Support guest SPEv1 */
>>>  
>>>  struct kvm_vcpu_init {
>>>  	__u32 target;
>>> @@ -306,6 +307,9 @@ struct kvm_vcpu_events {
>>>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>>>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>>>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
>>> +#define KVM_ARM_VCPU_SPE_V1_CTRL	2
>>> +#define   KVM_ARM_VCPU_SPE_V1_IRQ	0
>>> +#define   KVM_ARM_VCPU_SPE_V1_INIT	1
>>>  
>>>  /* KVM_IRQ_LINE irq field index values */
>>>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
>>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>>> index 3ac1a64d2fb9..1ba6154dd8e1 100644
>>> --- a/arch/arm64/kvm/Makefile
>>> +++ b/arch/arm64/kvm/Makefile
>>> @@ -35,3 +35,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-debug.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>>>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>>> +kvm-$(CONFIG_KVM_ARM_SPE) += $(KVM)/arm/spe.o
>>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>>> index 3ae2f82fca46..02c28a7eb332 100644
>>> --- a/arch/arm64/kvm/guest.c
>>> +++ b/arch/arm64/kvm/guest.c
>>> @@ -848,6 +848,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>>>  	case KVM_ARM_VCPU_TIMER_CTRL:
>>>  		ret = kvm_arm_timer_set_attr(vcpu, attr);
>>>  		break;
>>> +	case KVM_ARM_VCPU_SPE_V1_CTRL:
>>> +		ret = kvm_arm_spe_v1_set_attr(vcpu, attr);
>>> +		break;
>>>  	default:
>>>  		ret = -ENXIO;
>>>  		break;
>>> @@ -868,6 +871,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>>>  	case KVM_ARM_VCPU_TIMER_CTRL:
>>>  		ret = kvm_arm_timer_get_attr(vcpu, attr);
>>>  		break;
>>> +	case KVM_ARM_VCPU_SPE_V1_CTRL:
>>> +		ret = kvm_arm_spe_v1_get_attr(vcpu, attr);
>>> +		break;
>>>  	default:
>>>  		ret = -ENXIO;
>>>  		break;
>>> @@ -888,6 +894,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>>  	case KVM_ARM_VCPU_TIMER_CTRL:
>>>  		ret = kvm_arm_timer_has_attr(vcpu, attr);
>>>  		break;
>>> +	case KVM_ARM_VCPU_SPE_V1_CTRL:
>>> +		ret = kvm_arm_spe_v1_has_attr(vcpu, attr);
>>> +		break;
>>>  	default:
>>>  		ret = -ENXIO;
>>>  		break;
>>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>>> index 1140b4485575..33ce5248613e 100644
>>> --- a/arch/arm64/kvm/reset.c
>>> +++ b/arch/arm64/kvm/reset.c
>>> @@ -91,6 +91,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>  	case KVM_CAP_ARM_INJECT_SERROR_ESR:
>>>  		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
>>>  		break;
>>> +	case KVM_CAP_ARM_SPE_V1:
>>> +		r = kvm_arm_support_spe_v1();
>>> +		break;
>>>  	case KVM_CAP_SET_GUEST_DEBUG:
>>>  	case KVM_CAP_VCPU_ATTRIBUTES:
>>>  		r = 1;
>>> diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
>>> index fdcb0df1e0fd..8c2e8f10a965 100644
>>> --- a/include/kvm/arm_spe.h
>>> +++ b/include/kvm/arm_spe.h
>>> @@ -19,6 +19,9 @@ struct kvm_spe {
>>>  #ifdef CONFIG_KVM_ARM_SPE
>>>  
>>>  #define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
>>> +#define kvm_arm_spe_irq_initialized(v)		\
>>> +	((v)->arch.spe.irq >= VGIC_NR_SGIS &&	\
>>> +	(v)->arch.spe.irq <= VGIC_MAX_PRIVATE)
>>>  
>>>  static inline bool kvm_arm_support_spe_v1(void)
>>>  {
>>> @@ -27,10 +30,42 @@ static inline bool kvm_arm_support_spe_v1(void)
>>>  	return !!cpuid_feature_extract_unsigned_field(dfr0,
>>>  						      ID_AA64DFR0_PMSVER_SHIFT);
>>>  }
>>> +
>>> +int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu,
>>> +			    struct kvm_device_attr *attr);
>>> +int kvm_arm_spe_v1_get_attr(struct kvm_vcpu *vcpu,
>>> +			    struct kvm_device_attr *attr);
>>> +int kvm_arm_spe_v1_has_attr(struct kvm_vcpu *vcpu,
>>> +			    struct kvm_device_attr *attr);
>>> +int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu);
>>>  #else
>>>  
>>>  #define kvm_arm_spe_v1_ready(v)		(false)
>>>  #define kvm_arm_support_spe_v1()	(false)
>>> +#define kvm_arm_spe_irq_initialized(v)	(false)
>>> +
>>> +static inline int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu,
>>> +					  struct kvm_device_attr *attr)
>>> +{
>>> +	return -ENXIO;
>>> +}
>>> +
>>> +static inline int kvm_arm_spe_v1_get_attr(struct kvm_vcpu *vcpu,
>>> +					  struct kvm_device_attr *attr)
>>> +{
>>> +	return -ENXIO;
>>> +}
>>> +
>>> +static inline int kvm_arm_spe_v1_has_attr(struct kvm_vcpu *vcpu,
>>> +					  struct kvm_device_attr *attr)
>>> +{
>>> +	return -ENXIO;
>>> +}
>>> +
>>> +static inline int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu)
>>> +{
>>> +	return 0;
>>> +}
>>>  #endif /* CONFIG_KVM_ARM_SPE */
>>>  
>>>  #endif /* __ASM_ARM_KVM_SPE_H */
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 2fe12b40d503..698bcc2f96e3 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
>>>  #define KVM_CAP_ARM_SVE 170
>>>  #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
>>>  #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
>>> +#define KVM_CAP_ARM_SPE_V1 173
>>>  
>>>  #ifdef KVM_CAP_IRQ_ROUTING
>>>  
>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>> index 90cedebaeb94..c5b711ef1cf8 100644
>>> --- a/virt/kvm/arm/arm.c
>>> +++ b/virt/kvm/arm/arm.c
>>> @@ -34,6 +34,7 @@
>>>  #include <trace/events/kvm.h>
>>>  #include <kvm/arm_pmu.h>
>>>  #include <kvm/arm_psci.h>
>>> +#include <kvm/arm_spe.h>
>>>  
>>>  #define CREATE_TRACE_POINTS
>>>  #include "trace.h"
>>> diff --git a/virt/kvm/arm/spe.c b/virt/kvm/arm/spe.c
>>> new file mode 100644
>>> index 000000000000..87f02ed92426
>>> --- /dev/null
>>> +++ b/virt/kvm/arm/spe.c
>>> @@ -0,0 +1,163 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (C) 2018 ARM Ltd.
>>> + */
>>> +
>>> +#include <linux/cpu.h>
>>> +#include <linux/kvm.h>
>>> +#include <linux/kvm_host.h>
>>> +#include <linux/uaccess.h>
>>> +#include <asm/kvm_emulate.h>
>>> +#include <kvm/arm_spe.h>
>>> +#include <kvm/arm_vgic.h>
>>> +
>>> +int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu)
>>> +{
>>> +	if (!vcpu->arch.spe.created)
>>> +		return 0;
>>> +
>>> +	/*
>>> +	 * A valid interrupt configuration for the SPE is either to have a
>>> +	 * properly configured interrupt number and using an in-kernel irqchip.
>>> +	 */
>>> +	if (irqchip_in_kernel(vcpu->kvm)) {
>>> +		int irq = vcpu->arch.spe.irq;
>>> +
>>> +		if (!kvm_arm_spe_irq_initialized(vcpu))
>>> +			return -EINVAL;
>>> +
>>> +		if (!irq_is_ppi(irq))
>>> +			return -EINVAL;
>>> +	}
>>> +
>>> +	vcpu->arch.spe.ready = true;
>>
>> I don't think we should entertain the idea of using SPE without an
>> in-kernel irqchip, nor on systems that do not have a GIC.
>>
> 
> I agree, but sorry I didn't realise that this infrastructure is just
> to deal with those scenario. I assume these in place for sanity check
> the details we get from DT/ACPI. My assumption is completely wrong I
> suppose.

Not completely wrong. But I have no plan on supporting a hypothetical
SPE-capable CrapberryPi, as this would lead to an incredible level of
complexity, see below.

> 
>> But there is a more fundamental issue here: I do not see how the SPE
>> interrupt get injected in the guest. I've gone through the series twice,
>> and I can't see how we go from a physical interrupt triggered by the HW
>> on the host to a virtual interrupt injected in the guest.
>>
> 
> I haven't been able to trigger error/overflow interrupt from the guest
> so far on the models. I initial started taking PMU KVM implementation
> as reference and soon realised it is quite different. IIUC, we don't
> need to inject the interrupt and KVM takes care to set the corresponding
> virtual INTID to the pending state on vCPU.

Ah, you wish. Unfortunately, our wonderful interrupt architecture is
completely unable of doing so. Yes, this is pretty sad. Instead, you
need to resort to SW injection, and use the HW deactivation that we use
for timers.

From glancing at the code, you probably need to:

- Establish a mapping between the host physical PPI and the guest's
- On exit, evaluate the SPE state, and pend a virtual interrupt if
needed, clear the physical active state
- On entry, if there is a virtual SPE interrupt pending, mark the
corresponding physical interrupt as active
- Hope that this doesn't break the host's use of SPE

This is starting to look like a hybrid of the PMU and timer code. Horrible.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
