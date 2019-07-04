Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D699F5FA9A
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 17:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfGDPFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 11:05:39 -0400
Received: from foss.arm.com ([217.140.110.172]:43580 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727180AbfGDPFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 11:05:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0F9E28;
        Thu,  4 Jul 2019 08:05:38 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B61143F738;
        Thu,  4 Jul 2019 08:05:37 -0700 (PDT)
Subject: Re: [PATCH 13/59] KVM: arm64: nv: Handle virtual EL2 registers in
 vcpu_read/write_sys_reg()
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-14-marc.zyngier@arm.com>
 <d5d263d6-0c1f-ae53-80f4-f650c1d25c70@arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <9209a8e4-ab0d-9c9e-4207-0649b84ba806@arm.com>
Date:   Thu, 4 Jul 2019 16:05:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d5d263d6-0c1f-ae53-80f4-f650c1d25c70@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/06/2019 16:04, Alexandru Elisei wrote:
> On 6/21/19 10:37 AM, Marc Zyngier wrote:
>> From: Andre Przywara <andre.przywara@arm.com>
>>
>> KVM internally uses accessor functions when reading or writing the
>> guest's system registers. This takes care of accessing either the stored
>> copy or using the "live" EL1 system registers when the host uses VHE.
>>
>> With the introduction of virtual EL2 we add a bunch of EL2 system
>> registers, which now must also be taken care of:
>> - If the guest is running in vEL2, and we access an EL1 sysreg, we must
>>   revert to the stored version of that, and not use the CPU's copy.
>> - If the guest is running in vEL1, and we access an EL2 sysreg, we must
>>   also use the stored version, since the CPU carries the EL1 copy.
>> - Some EL2 system registers are supposed to affect the current execution
>>   of the system, so we need to put them into their respective EL1
>>   counterparts. For this we need to define a mapping between the two.
>>   This is done using the newly introduced struct el2_sysreg_map.
>> - Some EL2 system registers have a different format than their EL1
>>   counterpart, so we need to translate them before writing them to the
>>   CPU. This is done using an (optional) translate function in the map.
>> - There are the three special registers SP_EL2, SPSR_EL2 and ELR_EL2,
>>   which need some separate handling.
>>
>> All of these cases are now wrapped into the existing accessor functions,
>> so KVM users wouldn't need to care whether they access EL2 or EL1
>> registers and also which state the guest is in.
>>
>> This handles what was formerly known as the "shadow state" dynamically,
>> without requiring a separate copy for each vCPU EL.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h |   6 +
>>  arch/arm64/include/asm/kvm_host.h    |   5 +
>>  arch/arm64/kvm/sys_regs.c            | 163 +++++++++++++++++++++++++++
>>  3 files changed, 174 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index c43aac5fed69..f37006b6eec4 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -70,6 +70,12 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
>>  int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
>>  int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
>>  
>> +u64 translate_tcr(u64 tcr);
>> +u64 translate_cptr(u64 tcr);
>> +u64 translate_sctlr(u64 tcr);
>> +u64 translate_ttbr0(u64 tcr);
>> +u64 translate_cnthctl(u64 tcr);
>> +
>>  static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>>  {
>>  	return !(vcpu->arch.hcr_el2 & HCR_RW);
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 2d4290d2513a..dae9c42a7219 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -217,6 +217,11 @@ enum vcpu_sysreg {
>>  	NR_SYS_REGS	/* Nothing after this line! */
>>  };
>>  
>> +static inline bool sysreg_is_el2(int reg)
>> +{
>> +	return reg >= FIRST_EL2_SYSREG && reg < NR_SYS_REGS;
>> +}
>> +
>>  /* 32bit mapping */
>>  #define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
>>  #define c0_CSSELR	(CSSELR_EL1 * 2)/* Cache Size Selection Register */
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 693dd063c9c2..d024114da162 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -76,11 +76,142 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>>  	return false;
>>  }
>>  
>> +static u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
>> +{
>> +	return ((tcr_el2 & TCR_EL2_PS_MASK) >> TCR_EL2_PS_SHIFT)
>> +		<< TCR_IPS_SHIFT;
>> +}
>> +
>> +u64 translate_tcr(u64 tcr)
>> +{
>> +	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
>> +	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
>> +	       tcr_el2_ips_to_tcr_el1_ps(tcr) |
>> +	       (tcr & TCR_EL2_TG0_MASK) |
>> +	       (tcr & TCR_EL2_ORGN0_MASK) |
>> +	       (tcr & TCR_EL2_IRGN0_MASK) |
>> +	       (tcr & TCR_EL2_T0SZ_MASK);
>> +}
>> +
>> +u64 translate_cptr(u64 cptr_el2)
>> +{
>> +	u64 cpacr_el1 = 0;
>> +
>> +	if (!(cptr_el2 & CPTR_EL2_TFP))
>> +		cpacr_el1 |= CPACR_EL1_FPEN;
>> +	if (cptr_el2 & CPTR_EL2_TTA)
>> +		cpacr_el1 |= CPACR_EL1_TTA;
>> +	if (!(cptr_el2 & CPTR_EL2_TZ))
>> +		cpacr_el1 |= CPACR_EL1_ZEN;
>> +
>> +	return cpacr_el1;
>> +}
>> +
>> +u64 translate_sctlr(u64 sctlr)
>> +{
>> +	/* Bit 20 is RES1 in SCTLR_EL1, but RES0 in SCTLR_EL2 */
>> +	return sctlr | BIT(20);
>> +}
>> +
>> +u64 translate_ttbr0(u64 ttbr0)
>> +{
>> +	/* Force ASID to 0 (ASID 0 or RES0) */
>> +	return ttbr0 & ~GENMASK_ULL(63, 48);
>> +}
>> +
>> +u64 translate_cnthctl(u64 cnthctl)
>> +{
>> +	return ((cnthctl & 0x3) << 10) | (cnthctl & 0xfc);
>> +}
>> +
>> +#define EL2_SYSREG(el2, el1, translate)	\
>> +	[el2 - FIRST_EL2_SYSREG] = { el2, el1, translate }
>> +#define PURE_EL2_SYSREG(el2) \
>> +	[el2 - FIRST_EL2_SYSREG] = { el2,__INVALID_SYSREG__, NULL }
>> +/*
>> + * Associate vEL2 registers to their EL1 counterparts on the CPU.
>> + * The translate function can be NULL, when the register layout is identical.
>> + */
>> +struct el2_sysreg_map {
>> +	int sysreg;	/* EL2 register index into the array above */
>> +	int mapping;	/* associated EL1 register */
>> +	u64 (*translate)(u64 value);
>> +} nested_sysreg_map[NR_SYS_REGS - FIRST_EL2_SYSREG] = {
>> +	PURE_EL2_SYSREG( VPIDR_EL2 ),
>> +	PURE_EL2_SYSREG( VMPIDR_EL2 ),
>> +	PURE_EL2_SYSREG( ACTLR_EL2 ),
>> +	PURE_EL2_SYSREG( HCR_EL2 ),
>> +	PURE_EL2_SYSREG( MDCR_EL2 ),
>> +	PURE_EL2_SYSREG( HSTR_EL2 ),
>> +	PURE_EL2_SYSREG( HACR_EL2 ),
>> +	PURE_EL2_SYSREG( VTTBR_EL2 ),
>> +	PURE_EL2_SYSREG( VTCR_EL2 ),
>> +	PURE_EL2_SYSREG( RVBAR_EL2 ),
>> +	PURE_EL2_SYSREG( RMR_EL2 ),
>> +	PURE_EL2_SYSREG( TPIDR_EL2 ),
>> +	PURE_EL2_SYSREG( CNTVOFF_EL2 ),
>> +	PURE_EL2_SYSREG( CNTHCTL_EL2 ),
>> +	PURE_EL2_SYSREG( HPFAR_EL2 ),
>> +	EL2_SYSREG(      SCTLR_EL2,  SCTLR_EL1,      translate_sctlr ),
>> +	EL2_SYSREG(      CPTR_EL2,   CPACR_EL1,      translate_cptr  ),
>> +	EL2_SYSREG(      TTBR0_EL2,  TTBR0_EL1,      translate_ttbr0 ),
>> +	EL2_SYSREG(      TTBR1_EL2,  TTBR1_EL1,      NULL            ),
>> +	EL2_SYSREG(      TCR_EL2,    TCR_EL1,        translate_tcr   ),
>> +	EL2_SYSREG(      VBAR_EL2,   VBAR_EL1,       NULL            ),
>> +	EL2_SYSREG(      AFSR0_EL2,  AFSR0_EL1,      NULL            ),
>> +	EL2_SYSREG(      AFSR1_EL2,  AFSR1_EL1,      NULL            ),
>> +	EL2_SYSREG(      ESR_EL2,    ESR_EL1,        NULL            ),
>> +	EL2_SYSREG(      FAR_EL2,    FAR_EL1,        NULL            ),
>> +	EL2_SYSREG(      MAIR_EL2,   MAIR_EL1,       NULL            ),
>> +	EL2_SYSREG(      AMAIR_EL2,  AMAIR_EL1,      NULL            ),
>> +};
>> +
>> +static
>> +const struct el2_sysreg_map *find_el2_sysreg(const struct el2_sysreg_map *map,
>> +					     int reg)
>> +{
>> +	const struct el2_sysreg_map *entry;
>> +
>> +	if (!sysreg_is_el2(reg))
>> +		return NULL;
>> +
>> +	entry = &nested_sysreg_map[reg - FIRST_EL2_SYSREG];
>> +	if (entry->sysreg == __INVALID_SYSREG__)
>> +		return NULL;
>> +
>> +	return entry;
>> +}
>> +
>>  u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>>  {
>> +
>>  	if (!vcpu->arch.sysregs_loaded_on_cpu)
>>  		goto immediate_read;
>>  
>> +	if (unlikely(sysreg_is_el2(reg))) {
>> +		const struct el2_sysreg_map *el2_reg;
>> +
>> +		if (!is_hyp_ctxt(vcpu))
>> +			goto immediate_read;
>> +
>> +		el2_reg = find_el2_sysreg(nested_sysreg_map, reg);
>> +		if (el2_reg) {
>> +			/*
>> +			 * If this register does not have an EL1 counterpart,
>> +			 * then read the stored EL2 version.
>> +			 */
>> +			if (el2_reg->mapping == __INVALID_SYSREG__)
>> +				goto immediate_read;
>> +
>> +			/* Get the current version of the EL1 counterpart. */
>> +			reg = el2_reg->mapping;
>> +		}
>> +	} else {
>> +		/* EL1 register can't be on the CPU if the guest is in vEL2. */
>> +		if (unlikely(is_hyp_ctxt(vcpu)))
>> +			goto immediate_read;
>> +	}
>> +
>>  	/*
>>  	 * System registers listed in the switch are not saved on every
>>  	 * exit from the guest but are only saved on vcpu_put.
>> @@ -114,6 +245,8 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>>  	case DACR32_EL2:	return read_sysreg_s(SYS_DACR32_EL2);
>>  	case IFSR32_EL2:	return read_sysreg_s(SYS_IFSR32_EL2);
>>  	case DBGVCR32_EL2:	return read_sysreg_s(SYS_DBGVCR32_EL2);
>> +	case SP_EL2:		return read_sysreg(sp_el1);
> From ARM DDI 0487D.b, section Behavior when HCR_EL2.NV == 1: "Reads or writes to
> any allocated and implemented System register or Special-purpose register named
> *_EL2, *_EL02, or *_EL12 in the MRS or MSR instruction, other than SP_EL2, are
> trapped to EL2 rather than being UNDEFINED" (page D5-2480). My interpretation of
> the text is that attempted reads of SP_EL2 from virtual EL2 cause an undefined
> instruction exception.

Sure. Nonetheless, the virtual EL2 has a stack pointer, accessible via
SP_EL1 when it is loaded on the CPU. Somehow, this gets dropped later in
the series (which is a bit wrong). I definitely should bring it back.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
