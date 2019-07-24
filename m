Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EE572F11
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 14:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbfGXMjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 08:39:19 -0400
Received: from foss.arm.com ([217.140.110.172]:40352 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfGXMjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 08:39:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3FA53337;
        Wed, 24 Jul 2019 05:39:17 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C34F3F71A;
        Wed, 24 Jul 2019 05:39:16 -0700 (PDT)
Subject: Re: [PATCH 43/59] KVM: arm64: nv: Trap and emulate AT instructions
 from virtual EL2
To:     Tomasz Nowicki <tn@semihalf.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-44-marc.zyngier@arm.com>
 <0411c636-adbd-98d0-5191-2b073daaf68e@semihalf.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <327dfc0e-e7c9-0d18-2615-1db5b05121f4@arm.com>
Date:   Wed, 24 Jul 2019 13:39:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0411c636-adbd-98d0-5191-2b073daaf68e@semihalf.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/07/2019 11:25, Tomasz Nowicki wrote:
> On 21.06.2019 11:38, Marc Zyngier wrote:
>> From: Jintack Lim <jintack.lim@linaro.org>
>>
>> When supporting nested virtualization a guest hypervisor executing AT
>> instructions must be trapped and emulated by the host hypervisor,
>> because untrapped AT instructions operating on S1E1 will use the wrong
>> translation regieme (the one used to emulate virtual EL2 in EL1 instead
>> of virtual EL1) and AT instructions operating on S12 will not work from
>> EL1.
>>
>> This patch does several things.
>>
>> 1. List and define all AT system instructions to emulate and document
>> the emulation design.
>>
>> 2. Implement AT instruction handling logic in EL2. This will be used to
>> emulate AT instructions executed in the virtual EL2.
>>
>> AT instruction emulation works by loading the proper processor
>> context, which depends on the trapped instruction and the virtual
>> HCR_EL2, to the EL1 virtual memory control registers and executing AT
>> instructions. Note that ctxt->hw_sys_regs is expected to have the
>> proper processor context before calling the handling
>> function(__kvm_at_insn) implemented in this patch.
>>
>> 4. Emulate AT S1E[01] instructions by issuing the same instructions in
>> EL2. We set the physical EL1 registers, NV and NV1 bits as described in
>> the AT instruction emulation overview.
>>
>> 5. Emulate AT A12E[01] instructions in two steps: First, do the stage-1
>> translation by reusing the existing AT emulation functions.  Second, do
>> the stage-2 translation by walking the guest hypervisor's stage-2 page
>> table in software. Record the translation result to PAR_EL1.
>>
>> 6. Emulate AT S1E2 instructions by issuing the corresponding S1E1
>> instructions in EL2. We set the physical EL1 registers and the HCR_EL2
>> register as described in the AT instruction emulation overview.
>>
>> 7. Forward system instruction traps to the virtual EL2 if the corresponding
>> virtual AT bit is set in the virtual HCR_EL2.
>>
>>    [ Much logic above has been reworked by Marc Zyngier ]
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_arm.h |   2 +
>>   arch/arm64/include/asm/kvm_asm.h |   2 +
>>   arch/arm64/include/asm/sysreg.h  |  17 +++
>>   arch/arm64/kvm/hyp/Makefile      |   1 +
>>   arch/arm64/kvm/hyp/at.c          | 217 +++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/hyp/switch.c      |  13 +-
>>   arch/arm64/kvm/sys_regs.c        | 202 +++++++++++++++++++++++++++-
>>   7 files changed, 450 insertions(+), 4 deletions(-)
>>   create mode 100644 arch/arm64/kvm/hyp/at.c
>>
> 
> [...]
> 
>> +
>> +void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>> +{
>> +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
>> +	struct mmu_config config;
>> +	struct kvm_s2_mmu *mmu;
>> +
>> +	/*
>> +	 * We can only get here when trapping from vEL2, so we're
>> +	 * translating a guest guest VA.
>> +	 *
>> +	 * FIXME: Obtaining the S2 MMU for a a guest guest is horribly
>> +	 * racy, and we may not find it.
>> +	 */
>> +	spin_lock(&vcpu->kvm->mmu_lock);
>> +
>> +	mmu = lookup_s2_mmu(vcpu->kvm,
>> +			    vcpu_read_sys_reg(vcpu, VTTBR_EL2),
>> +			    vcpu_read_sys_reg(vcpu, HCR_EL2));
>> +
>> +	if (WARN_ON(!mmu))
>> +		goto out;
>> +
>> +	/* We've trapped, so everything is live on the CPU. */
>> +	__mmu_config_save(&config);
>> +
>> +	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
>> +	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
>> +	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
>> +	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
>> +	write_sysreg(kvm_get_vttbr(mmu),		vttbr_el2);
>> +	/* FIXME: write S2 MMU VTCR_EL2 */
>> +	write_sysreg(config.hcr & ~HCR_TGE,		hcr_el2);
> 
> All below AT S1E* operations may initiate stage-1 PTW. And stage-1 table 
> walk addresses are themselves subject to stage-2 translation.
> 
> So should we enable stage-2 translation here by setting HCR_VM bit?

Hopefully that's already the case, otherwise nothing works. Have you
verified that it is actually clear at this stage?

It's a bit of a moot point as we need a full S1 PTW in SW anyway (so
most of that code will eventually be removed), but at least this should
be fixed if it needs to.

Thanks,

	M. (who really needs to get on top of these review comments)
-- 
Jazz is not dead. It just smells funny...
