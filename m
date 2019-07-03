Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE8F5E402
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 14:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGCMcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 08:32:31 -0400
Received: from foss.arm.com ([217.140.110.172]:46354 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 08:32:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD4322B;
        Wed,  3 Jul 2019 05:32:29 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3DBD3F703;
        Wed,  3 Jul 2019 05:32:28 -0700 (PDT)
Subject: Re: [PATCH 01/59] KVM: arm64: Migrate _elx sysreg accessors to
 msr_s/mrs_s
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-2-marc.zyngier@arm.com>
 <1b5c4ba2-dc19-e5ab-d752-7abfdc61daf8@arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <1f37d4d2-9d67-bbb8-0df8-8e239208d746@arm.com>
Date:   Wed, 3 Jul 2019 13:32:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1b5c4ba2-dc19-e5ab-d752-7abfdc61daf8@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/2019 13:59, Alexandru Elisei wrote:
> On 6/21/19 10:37 AM, Marc Zyngier wrote:
>> From: Dave Martin <Dave.Martin@arm.com>
>>
>> Currently, the {read,write}_sysreg_el*() accessors for accessing
>> particular ELs' sysregs in the presence of VHE rely on some local
>> hacks and define their system register encodings in a way that is
>> inconsistent with the core definitions in <asm/sysreg.h>.
>>
>> As a result, it is necessary to add duplicate definitions for any
>> system register that already needs a definition in sysreg.h for
>> other reasons.
>>
>> This is a bit of a maintenance headache, and the reasons for the
>> _el*() accessors working the way they do is a bit historical.
>>
>> This patch gets rid of the shadow sysreg definitions in
>> <asm/kvm_hyp.h>, converts the _el*() accessors to use the core
>> __msr_s/__mrs_s interface, and converts all call sites to use the
>> standard sysreg #define names (i.e., upper case, with SYS_ prefix).
>>
>> This patch will conflict heavily anyway, so the opportunity taken
>> to clean up some bad whitespace in the context of the changes is
>> taken.
>>
>> The change exposes a few system registers that have no sysreg.h
>> definition, due to msr_s/mrs_s being used in place of msr/mrs:
>> additions are made in order to fill in the gaps.
>>
>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Link: https://www.spinics.net/lists/kvm-arm/msg31717.html
>> [Rebased to v4.21-rc1]
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> [Rebased to v5.2-rc5, changelog updates]
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_hyp.h           | 13 ++--
>>  arch/arm64/include/asm/kvm_emulate.h     | 16 ++---
>>  arch/arm64/include/asm/kvm_hyp.h         | 50 ++-------------
>>  arch/arm64/include/asm/sysreg.h          | 35 ++++++++++-
>>  arch/arm64/kvm/hyp/switch.c              | 14 ++---
>>  arch/arm64/kvm/hyp/sysreg-sr.c           | 78 ++++++++++++------------
>>  arch/arm64/kvm/hyp/tlb.c                 | 12 ++--
>>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
>>  arch/arm64/kvm/regmap.c                  |  4 +-
>>  arch/arm64/kvm/sys_regs.c                | 56 ++++++++---------
>>  virt/kvm/arm/arch_timer.c                | 24 ++++----
>>  11 files changed, 148 insertions(+), 156 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
>> index 87bcd18df8d5..059224fb14db 100644
>> --- a/arch/arm/include/asm/kvm_hyp.h
>> +++ b/arch/arm/include/asm/kvm_hyp.h
>> @@ -93,13 +93,14 @@
>>  #define VFP_FPEXC	__ACCESS_VFP(FPEXC)
>>  
>>  /* AArch64 compatibility macros, only for the timer so far */
>> -#define read_sysreg_el0(r)		read_sysreg(r##_el0)
>> -#define write_sysreg_el0(v, r)		write_sysreg(v, r##_el0)
>> +#define read_sysreg_el0(r)		read_sysreg(r##_EL0)
>> +#define write_sysreg_el0(v, r)		write_sysreg(v, r##_EL0)
>> +
>> +#define SYS_CNTP_CTL_EL0		CNTP_CTL
>> +#define SYS_CNTP_CVAL_EL0		CNTP_CVAL
>> +#define SYS_CNTV_CTL_EL0		CNTV_CTL
>> +#define SYS_CNTV_CVAL_EL0		CNTV_CVAL
>>  
>> -#define cntp_ctl_el0			CNTP_CTL
>> -#define cntp_cval_el0			CNTP_CVAL
>> -#define cntv_ctl_el0			CNTV_CTL
>> -#define cntv_cval_el0			CNTV_CVAL
>>  #define cntvoff_el2			CNTVOFF
>>  #define cnthctl_el2			CNTHCTL
>>  
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 613427fafff9..39ffe41855bc 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -137,7 +137,7 @@ static inline unsigned long *__vcpu_elr_el1(const struct kvm_vcpu *vcpu)
>>  static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
>>  {
>>  	if (vcpu->arch.sysregs_loaded_on_cpu)
>> -		return read_sysreg_el1(elr);
>> +		return read_sysreg_el1(SYS_ELR);
>>  	else
>>  		return *__vcpu_elr_el1(vcpu);
>>  }
>> @@ -145,7 +145,7 @@ static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
>>  static inline void vcpu_write_elr_el1(const struct kvm_vcpu *vcpu, unsigned long v)
>>  {
>>  	if (vcpu->arch.sysregs_loaded_on_cpu)
>> -		write_sysreg_el1(v, elr);
>> +		write_sysreg_el1(v, SYS_ELR);
>>  	else
>>  		*__vcpu_elr_el1(vcpu) = v;
>>  }
>> @@ -197,7 +197,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
>>  		return vcpu_read_spsr32(vcpu);
>>  
>>  	if (vcpu->arch.sysregs_loaded_on_cpu)
>> -		return read_sysreg_el1(spsr);
>> +		return read_sysreg_el1(SYS_SPSR);
>>  	else
>>  		return vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
>>  }
>> @@ -210,7 +210,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
>>  	}
>>  
>>  	if (vcpu->arch.sysregs_loaded_on_cpu)
>> -		write_sysreg_el1(v, spsr);
>> +		write_sysreg_el1(v, SYS_SPSR);
>>  	else
>>  		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
>>  }
>> @@ -462,13 +462,13 @@ static inline void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_instr)
>>   */
>>  static inline void __hyp_text __kvm_skip_instr(struct kvm_vcpu *vcpu)
>>  {
>> -	*vcpu_pc(vcpu) = read_sysreg_el2(elr);
>> -	vcpu->arch.ctxt.gp_regs.regs.pstate = read_sysreg_el2(spsr);
>> +	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
>> +	vcpu->arch.ctxt.gp_regs.regs.pstate = read_sysreg_el2(SYS_SPSR);
>>  
>>  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
>>  
>> -	write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pstate, spsr);
>> -	write_sysreg_el2(*vcpu_pc(vcpu), elr);
>> +	write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pstate, SYS_SPSR);
>> +	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
>>  }
>>  
>>  #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
>> index 09fe8bd15f6e..ce99c2daff04 100644
>> --- a/arch/arm64/include/asm/kvm_hyp.h
>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>> @@ -29,7 +29,7 @@
>>  #define read_sysreg_elx(r,nvh,vh)					\
>>  	({								\
>>  		u64 reg;						\
>> -		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##nvh),\
>> +		asm volatile(ALTERNATIVE(__mrs_s("%0", r##nvh),	\
>>  					 __mrs_s("%0", r##vh),		\
>>  					 ARM64_HAS_VIRT_HOST_EXTN)	\
>>  			     : "=r" (reg));				\
>> @@ -39,7 +39,7 @@
>>  #define write_sysreg_elx(v,r,nvh,vh)					\
>>  	do {								\
>>  		u64 __val = (u64)(v);					\
>> -		asm volatile(ALTERNATIVE("msr " __stringify(r##nvh) ", %x0",\
>> +		asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"),	\
>>  					 __msr_s(r##vh, "%x0"),		\
>>  					 ARM64_HAS_VIRT_HOST_EXTN)	\
>>  					 : : "rZ" (__val));		\
>> @@ -48,55 +48,15 @@
>>  /*
>>   * Unified accessors for registers that have a different encoding
>>   * between VHE and non-VHE. They must be specified without their "ELx"
>> - * encoding.
>> + * encoding, but with the SYS_ prefix, as defined in asm/sysreg.h.
>>   */
>> -#define read_sysreg_el2(r)						\
>> -	({								\
>> -		u64 reg;						\
>> -		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##_EL2),\
>> -					 "mrs %0, " __stringify(r##_EL1),\
>> -					 ARM64_HAS_VIRT_HOST_EXTN)	\
>> -			     : "=r" (reg));				\
>> -		reg;							\
>> -	})
>> -
>> -#define write_sysreg_el2(v,r)						\
>> -	do {								\
>> -		u64 __val = (u64)(v);					\
>> -		asm volatile(ALTERNATIVE("msr " __stringify(r##_EL2) ", %x0",\
>> -					 "msr " __stringify(r##_EL1) ", %x0",\
>> -					 ARM64_HAS_VIRT_HOST_EXTN)	\
>> -					 : : "rZ" (__val));		\
>> -	} while (0)
>>  
>>  #define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
>>  #define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
>>  #define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
>>  #define write_sysreg_el1(v,r)	write_sysreg_elx(v, r, _EL1, _EL12)
>> -
>> -/* The VHE specific system registers and their encoding */
>> -#define sctlr_EL12              sys_reg(3, 5, 1, 0, 0)
>> -#define cpacr_EL12              sys_reg(3, 5, 1, 0, 2)
>> -#define ttbr0_EL12              sys_reg(3, 5, 2, 0, 0)
>> -#define ttbr1_EL12              sys_reg(3, 5, 2, 0, 1)
>> -#define tcr_EL12                sys_reg(3, 5, 2, 0, 2)
>> -#define afsr0_EL12              sys_reg(3, 5, 5, 1, 0)
>> -#define afsr1_EL12              sys_reg(3, 5, 5, 1, 1)
>> -#define esr_EL12                sys_reg(3, 5, 5, 2, 0)
>> -#define far_EL12                sys_reg(3, 5, 6, 0, 0)
>> -#define mair_EL12               sys_reg(3, 5, 10, 2, 0)
>> -#define amair_EL12              sys_reg(3, 5, 10, 3, 0)
>> -#define vbar_EL12               sys_reg(3, 5, 12, 0, 0)
>> -#define contextidr_EL12         sys_reg(3, 5, 13, 0, 1)
>> -#define cntkctl_EL12            sys_reg(3, 5, 14, 1, 0)
>> -#define cntp_tval_EL02          sys_reg(3, 5, 14, 2, 0)
>> -#define cntp_ctl_EL02           sys_reg(3, 5, 14, 2, 1)
>> -#define cntp_cval_EL02          sys_reg(3, 5, 14, 2, 2)
>> -#define cntv_tval_EL02          sys_reg(3, 5, 14, 3, 0)
>> -#define cntv_ctl_EL02           sys_reg(3, 5, 14, 3, 1)
>> -#define cntv_cval_EL02          sys_reg(3, 5, 14, 3, 2)
>> -#define spsr_EL12               sys_reg(3, 5, 4, 0, 0)
>> -#define elr_EL12                sys_reg(3, 5, 4, 0, 1)
>> +#define read_sysreg_el2(r)	read_sysreg_elx(r, _EL2, _EL1)
>> +#define write_sysreg_el2(v,r)	write_sysreg_elx(v, r, _EL2, _EL1)
>>  
>>  /**
>>   * hyp_alternate_select - Generates patchable code sequences that are
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 902d75b60914..434cf53d527b 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -202,6 +202,9 @@
>>  #define SYS_APGAKEYLO_EL1		sys_reg(3, 0, 2, 3, 0)
>>  #define SYS_APGAKEYHI_EL1		sys_reg(3, 0, 2, 3, 1)
>>  
>> +#define SYS_SPSR_EL1			sys_reg(3, 0, 4, 0, 0)
>> +#define SYS_ELR_EL1			sys_reg(3, 0, 4, 0, 1)
>> +
>>  #define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
>>  
>>  #define SYS_AFSR0_EL1			sys_reg(3, 0, 5, 1, 0)
>> @@ -393,6 +396,9 @@
>>  #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
>>  #define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
>>  
>> +#define SYS_CNTV_CTL_EL0		sys_reg(3, 3, 14, 3, 1)
>> +#define SYS_CNTV_CVAL_EL0		sys_reg(3, 3, 14, 3, 2)
>> +
>>  #define SYS_AARCH32_CNTP_TVAL		sys_reg(0, 0, 14, 2, 0)
>>  #define SYS_AARCH32_CNTP_CTL		sys_reg(0, 0, 14, 2, 1)
>>  #define SYS_AARCH32_CNTP_CVAL		sys_reg(0, 2, 0, 14, 0)
>> @@ -403,14 +409,17 @@
>>  #define __TYPER_CRm(n)			(0xc | (((n) >> 3) & 0x3))
>>  #define SYS_PMEVTYPERn_EL0(n)		sys_reg(3, 3, 14, __TYPER_CRm(n), __PMEV_op2(n))
>>  
>> -#define SYS_PMCCFILTR_EL0		sys_reg (3, 3, 14, 15, 7)
>> +#define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
>>  
>>  #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
>> -
>>  #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
>> +#define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
>> +#define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
>>  #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
>> +#define SYS_ESR_EL2			sys_reg(3, 4, 5, 2, 0)
>>  #define SYS_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
>>  #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
>> +#define SYS_FAR_EL2			sys_reg(3, 4, 6, 0, 0)
>>  
>>  #define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1,  1)
>>  #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
>> @@ -455,7 +464,29 @@
>>  #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
>>  
>>  /* VHE encodings for architectural EL0/1 system registers */
>> +#define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
>> +#define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
>>  #define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
>> +#define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
>> +#define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
>> +#define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
>> +#define SYS_SPSR_EL12			sys_reg(3, 5, 4, 0, 0)
>> +#define SYS_ELR_EL12			sys_reg(3, 5, 4, 0, 1)
>> +#define SYS_AFSR0_EL12			sys_reg(3, 5, 5, 1, 0)
>> +#define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
>> +#define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
>> +#define SYS_FAR_EL12			sys_reg(3, 5, 6, 0, 0)
>> +#define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
>> +#define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
>> +#define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
>> +#define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
>> +#define SYS_CNTKCTL_EL12		sys_reg(3, 5, 14, 1, 0)
>> +#define SYS_CNTP_TVAL_EL02		sys_reg(3, 5, 14, 2, 0)
>> +#define SYS_CNTP_CTL_EL02		sys_reg(3, 5, 14, 2, 1)
>> +#define SYS_CNTP_CVAL_EL02		sys_reg(3, 5, 14, 2, 2)
>> +#define SYS_CNTV_TVAL_EL02		sys_reg(3, 5, 14, 3, 0)
>> +#define SYS_CNTV_CTL_EL02		sys_reg(3, 5, 14, 3, 1)
>> +#define SYS_CNTV_CVAL_EL02		sys_reg(3, 5, 14, 3, 2)
>>  
>>  /* Common SCTLR_ELx flags. */
>>  #define SCTLR_ELx_DSSBS	(_BITUL(44))
>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index 8799e0c267d4..7b55c11b30fb 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -295,7 +295,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
>>  	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
>>  		return true;
>>  
>> -	far = read_sysreg_el2(far);
>> +	far = read_sysreg_el2(SYS_FAR);
>>  
>>  	/*
>>  	 * The HPFAR can be invalid if the stage 2 fault did not
>> @@ -412,7 +412,7 @@ static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>>  static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>>  {
>>  	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
>> -		vcpu->arch.fault.esr_el2 = read_sysreg_el2(esr);
>> +		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
>>  
>>  	/*
>>  	 * We're using the raw exception code in order to only process
>> @@ -708,8 +708,8 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
>>  	asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
>>  
>>  	__hyp_do_panic(str_va,
>> -		       spsr,  elr,
>> -		       read_sysreg(esr_el2),   read_sysreg_el2(far),
>> +		       spsr, elr,
>> +		       read_sysreg(esr_el2), read_sysreg_el2(SYS_FAR),
> Seems to me we are pretty sure here we don't have VHE, so why not make both
> reads either read_sysreg or read_sysreg_el2 for consistency? Am I missing something?

You're not missing much, only that it isn't what this change is about.
If we want to make these things consistent, I'd rather have a separate
patch that changes just that.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
