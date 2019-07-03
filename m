Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7ED5E5A8
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 15:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfGCNnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 09:43:00 -0400
Received: from foss.arm.com ([217.140.110.172]:48302 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCNnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 09:43:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6A202B;
        Wed,  3 Jul 2019 06:42:58 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76CD23F718;
        Wed,  3 Jul 2019 06:42:57 -0700 (PDT)
Subject: Re: [PATCH 16/59] KVM: arm64: nv: Save/Restore vEL2 sysregs
To:     Julien Thierry <julien.thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-17-marc.zyngier@arm.com>
 <800f3e9a-5b67-951b-34c2-60367c0697f9@arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <7102a9ab-ede8-bd08-ce9b-12e3f36e40e1@arm.com>
Date:   Wed, 3 Jul 2019 14:42:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <800f3e9a-5b67-951b-34c2-60367c0697f9@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/2019 09:48, Julien Thierry wrote:
> 
> 
> On 06/21/2019 10:38 AM, Marc Zyngier wrote:
>> From: Andre Przywara <andre.przywara@arm.com>
>>
>> Whenever we need to restore the guest's system registers to the CPU, we
>> now need to take care of the EL2 system registers as well. Most of them
>> are accessed via traps only, but some have an immediate effect and also
>> a guest running in VHE mode would expect them to be accessible via their
>> EL1 encoding, which we do not trap.
>>
>> Split the current __sysreg_{save,restore}_el1_state() functions into
>> handling common sysregs, then differentiate between the guest running in
>> vEL2 and vEL1.
>>
>> For vEL2 we write the virtual EL2 registers with an identical format directly
>> into their EL1 counterpart, and translate the few registers that have a
>> different format for the same effect on the execution when running a
>> non-VHE guest guest hypervisor.
>>
>>   [ Commit message reworked and many bug fixes applied by Marc Zyngier
>>     and Christoffer Dall. ]
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/sysreg-sr.c | 160 +++++++++++++++++++++++++++++++--
>>  1 file changed, 153 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
>> index 62866a68e852..2abb9c3ff24f 100644
>> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
>> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> 
> [...]
> 
>> @@ -124,10 +167,91 @@ static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
>>  	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0],	tpidrro_el0);
>>  }
>>  
>> -static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>> +static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
>>  {
>> +	u64 val;
>> +
>> +	write_sysreg(read_cpuid_id(),			vpidr_el2);
>>  	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
>> -	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
>> +	write_sysreg_el1(ctxt->sys_regs[MAIR_EL2],	SYS_MAIR);
>> +	write_sysreg_el1(ctxt->sys_regs[VBAR_EL2],	SYS_VBAR);
>> +	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL2],SYS_CONTEXTIDR);
>> +	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL2],	SYS_AMAIR);
>> +
>> +	if (__vcpu_el2_e2h_is_set(ctxt)) {
>> +		/*
>> +		 * In VHE mode those registers are compatible between
>> +		 * EL1 and EL2.
>> +		 */
>> +		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL2],	SYS_SCTLR);
>> +		write_sysreg_el1(ctxt->sys_regs[CPTR_EL2],	SYS_CPACR);
>> +		write_sysreg_el1(ctxt->sys_regs[TTBR0_EL2],	SYS_TTBR0);
>> +		write_sysreg_el1(ctxt->sys_regs[TTBR1_EL2],	SYS_TTBR1);
>> +		write_sysreg_el1(ctxt->sys_regs[TCR_EL2],	SYS_TCR);
>> +		write_sysreg_el1(ctxt->sys_regs[CNTHCTL_EL2],	SYS_CNTKCTL);
>> +	} else {
>> +		write_sysreg_el1(translate_sctlr(ctxt->sys_regs[SCTLR_EL2]),
>> +				 SYS_SCTLR);
>> +		write_sysreg_el1(translate_cptr(ctxt->sys_regs[CPTR_EL2]),
>> +				 SYS_CPACR);
>> +		write_sysreg_el1(translate_ttbr0(ctxt->sys_regs[TTBR0_EL2]),
>> +				 SYS_TTBR0);
>> +		write_sysreg_el1(translate_tcr(ctxt->sys_regs[TCR_EL2]),
>> +				 SYS_TCR);
>> +		write_sysreg_el1(translate_cnthctl(ctxt->sys_regs[CNTHCTL_EL2]),
>> +				 SYS_CNTKCTL);
>> +	}
>> +
>> +	/*
>> +	 * These registers can be modified behind our back by a fault
>> +	 * taken inside vEL2. Save them, always.
>> +	 */
>> +	write_sysreg_el1(ctxt->sys_regs[ESR_EL2],	SYS_ESR);
>> +	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL2],	SYS_AFSR0);
>> +	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL2],	SYS_AFSR1);
>> +	write_sysreg_el1(ctxt->sys_regs[FAR_EL2],	SYS_FAR);
>> +	write_sysreg(ctxt->sys_regs[SP_EL2],		sp_el1);
>> +	write_sysreg_el1(ctxt->sys_regs[ELR_EL2],	SYS_ELR);
>> +
>> +	val = __fixup_spsr_el2_write(ctxt, ctxt->sys_regs[SPSR_EL2]);
>> +	write_sysreg_el1(val,	SYS_SPSR);
>> +}
>> +
>> +static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
>> +{
>> +	u64 mpidr;
>> +
>> +	if (has_vhe()) {
>> +		struct kvm_vcpu *vcpu;
>> +
>> +		/*
>> +		 * Warning: this hack only works on VHE, because we only
>> +		 * call this with the *guest* context, which is part of
>> +		 * struct kvm_vcpu. On a host context, you'd get pure junk.
>> +		 */
>> +		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
> 
> This seems very fragile, just to find out whether the guest has hyp
> capabilities. It would be at least nice to make sure this is indeed a
> guest context.

Oh come on! It is such a nice hack! ;-) I distinctly remember
Christoffer being >that< close to vomiting when he saw that first.

More seriously, we know what the context is by construction.

> The *clean* way to do it could be to have a pointer to kvm_vcpu in the
> kvm_cpu_context which would be NULL for host contexts.

Funny you mention that. We have the exact opposite (host context
pointing to the running vcpu, and NULL in the guest context). Maybe we
can come up with something that always point to the vcpu, assuming
nothing yet checks for NULL to identify a guest context! ;-)

> Otherwise, I'm under the impression that for a host context,
> ctxt->sys_reg[HCR_EL2] == 0 and that this would also be true for a guest
> without nested virt capability. Could we use something like that here?

Urgh. I think I'd prefer the above suggestion. Or even my hack.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
