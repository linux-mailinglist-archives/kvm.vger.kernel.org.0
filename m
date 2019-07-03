Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD7D5E4D9
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 15:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfGCNJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 09:09:36 -0400
Received: from foss.arm.com ([217.140.110.172]:47548 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbfGCNJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 09:09:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 165972B;
        Wed,  3 Jul 2019 06:09:35 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B08DA3F718;
        Wed,  3 Jul 2019 06:09:33 -0700 (PDT)
Subject: Re: [PATCH 15/59] KVM: arm64: nv: Refactor vcpu_{read,write}_sys_reg
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
 <20190621093843.220980-16-marc.zyngier@arm.com>
 <a64c85c3-0230-d9d0-aea6-b8a4196e62b2@arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <94b1665e-f365-da5e-f47d-8cddd21643eb@arm.com>
Date:   Wed, 3 Jul 2019 14:09:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a64c85c3-0230-d9d0-aea6-b8a4196e62b2@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/2019 16:07, Julien Thierry wrote:
> 
> 
> On 06/21/2019 10:37 AM, Marc Zyngier wrote:
>> Extract the direct HW accessors for later reuse.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 247 +++++++++++++++++++++-----------------
>>  1 file changed, 139 insertions(+), 108 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 2b8734f75a09..e181359adadf 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -182,99 +182,161 @@ const struct el2_sysreg_map *find_el2_sysreg(const struct el2_sysreg_map *map,
>>  	return entry;
>>  }
>>  
>> +static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
>> +{
>> +	/*
>> +	 * System registers listed in the switch are not saved on every
>> +	 * exit from the guest but are only saved on vcpu_put.
>> +	 *
>> +	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
>> +	 * should never be listed below, because the guest cannot modify its
>> +	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
>> +	 * thread when emulating cross-VCPU communication.
>> +	 */
>> +	switch (reg) {
>> +	case CSSELR_EL1:	*val = read_sysreg_s(SYS_CSSELR_EL1);	break;
>> +	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
>> +	case ACTLR_EL1:		*val = read_sysreg_s(SYS_ACTLR_EL1);	break;
>> +	case CPACR_EL1:		*val = read_sysreg_s(SYS_CPACR_EL12);	break;
>> +	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
>> +	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
>> +	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
>> +	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
>> +	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
>> +	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
>> +	case FAR_EL1:		*val = read_sysreg_s(SYS_FAR_EL12);	break;
>> +	case MAIR_EL1:		*val = read_sysreg_s(SYS_MAIR_EL12);	break;
>> +	case VBAR_EL1:		*val = read_sysreg_s(SYS_VBAR_EL12);	break;
>> +	case CONTEXTIDR_EL1:	*val = read_sysreg_s(SYS_CONTEXTIDR_EL12);break;
>> +	case TPIDR_EL0:		*val = read_sysreg_s(SYS_TPIDR_EL0);	break;
>> +	case TPIDRRO_EL0:	*val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
>> +	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
>> +	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
>> +	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
>> +	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
>> +	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
>> +	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
>> +	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
>> +	default:		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
>> +{
>> +	/*
>> +	 * System registers listed in the switch are not restored on every
>> +	 * entry to the guest but are only restored on vcpu_load.
>> +	 *
>> +	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
>> +	 * should never be listed below, because the the MPIDR should only be
>> +	 * set once, before running the VCPU, and never changed later.
>> +	 */
>> +	switch (reg) {
>> +	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	break;
>> +	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
>> +	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	break;
>> +	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
>> +	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
>> +	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
>> +	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
>> +	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
>> +	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
>> +	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
>> +	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	break;
>> +	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	break;
>> +	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	break;
>> +	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12);break;
>> +	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
>> +	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
>> +	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
>> +	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
>> +	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
>> +	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
>> +	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
>> +	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
>> +	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
>> +	default:		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>  u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>>  {
>> -	u64 val;
>> +	u64 val = 0x8badf00d8badf00d;
>>  
>>  	if (!vcpu->arch.sysregs_loaded_on_cpu)
>> -		goto immediate_read;
>> +		goto memory_read;
>>  
>>  	if (unlikely(sysreg_is_el2(reg))) {
>>  		const struct el2_sysreg_map *el2_reg;
>>  
>>  		if (!is_hyp_ctxt(vcpu))
>> -			goto immediate_read;
>> +			goto memory_read;
>>  
>>  		switch (reg) {
>> +		case ELR_EL2:
>> +			return read_sysreg_el1(SYS_ELR);
> 
> Hmmm, This change feels a bit out of place.
> 
> Also, patch 13 added ELR_EL2 and SP_EL2 to the switch cases for physical
> sysreg accesses. Now ELR_EL2 is moved out of the main switch cases and
> SP_EL2 is completely omitted.
> 
> I'd say either patch 13 needs to be reworked or there is a separate
> patch that should be extracted from this patch to have an intermediate
> state, or the commit message on this patch should be more detailed.

Yeah, I wanted to actually squash most of this patch into #13, and got
sidetracked. Definitely room for improvement. I may even bring in the
rework I mentioned against #13.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
