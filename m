Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77BB35E3B3
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 14:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfGCMVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 08:21:00 -0400
Received: from foss.arm.com ([217.140.110.172]:46074 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 08:20:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A05A92B;
        Wed,  3 Jul 2019 05:20:58 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 646A03F703;
        Wed,  3 Jul 2019 05:20:57 -0700 (PDT)
Subject: Re: [PATCH 07/59] KVM: arm64: nv: Add EL2 system registers to vcpu
 context
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-8-marc.zyngier@arm.com>
 <20190624125416.GQ2790@e103592.cambridge.arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <bf624c54-41f6-85d0-e8c1-7943e065ec98@arm.com>
Date:   Wed, 3 Jul 2019 13:20:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190624125416.GQ2790@e103592.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/2019 13:54, Dave Martin wrote:
> On Fri, Jun 21, 2019 at 10:37:51AM +0100, Marc Zyngier wrote:
>> From: Jintack Lim <jintack.lim@linaro.org>
>>
>> ARM v8.3 introduces a new bit in the HCR_EL2, which is the NV bit. When
>> this bit is set, accessing EL2 registers in EL1 traps to EL2. In
>> addition, executing the following instructions in EL1 will trap to EL2:
>> tlbi, at, eret, and msr/mrs instructions to access SP_EL1. Most of the
>> instructions that trap to EL2 with the NV bit were undef at EL1 prior to
>> ARM v8.3. The only instruction that was not undef is eret.
>>
>> This patch sets up a handler for EL2 registers and SP_EL1 register
>> accesses at EL1. The host hypervisor keeps those register values in
>> memory, and will emulate their behavior.
>>
>> This patch doesn't set the NV bit yet. It will be set in a later patch
>> once nested virtualization support is completed.
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_host.h | 37 +++++++++++++++-
>>  arch/arm64/include/asm/sysreg.h   | 50 ++++++++++++++++++++-
>>  arch/arm64/kvm/sys_regs.c         | 74 ++++++++++++++++++++++++++++---
>>  3 files changed, 154 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 4bcd9c1291d5..2d4290d2513a 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -173,12 +173,47 @@ enum vcpu_sysreg {
>>  	APGAKEYLO_EL1,
>>  	APGAKEYHI_EL1,
>>  
>> -	/* 32bit specific registers. Keep them at the end of the range */
>> +	/* 32bit specific registers. */
> 
> Out of interest, why did we originally want these to be at the end?
> Because they're not at the end any more...

I seem to remember the original assembly switch code used that property.
This is a long gone requirement, thankfully.

> 
>>  	DACR32_EL2,	/* Domain Access Control Register */
>>  	IFSR32_EL2,	/* Instruction Fault Status Register */
>>  	FPEXC32_EL2,	/* Floating-Point Exception Control Register */
>>  	DBGVCR32_EL2,	/* Debug Vector Catch Register */
>>  
>> +	/* EL2 registers sorted ascending by Op0, Op1, CRn, CRm, Op2 */
>> +	FIRST_EL2_SYSREG,
>> +	VPIDR_EL2 = FIRST_EL2_SYSREG,
>> +			/* Virtualization Processor ID Register */
>> +	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
>> +	SCTLR_EL2,	/* System Control Register (EL2) */
>> +	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
>> +	HCR_EL2,	/* Hypervisor Configuration Register */
>> +	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
>> +	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
>> +	HSTR_EL2,	/* Hypervisor System Trap Register */
>> +	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
>> +	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
>> +	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
>> +	TCR_EL2,	/* Translation Control Register (EL2) */
>> +	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
>> +	VTCR_EL2,	/* Virtualization Translation Control Register */
>> +	SPSR_EL2,	/* EL2 saved program status register */
>> +	ELR_EL2,	/* EL2 exception link register */
>> +	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
>> +	AFSR1_EL2,	/* Auxiliary Fault Status Register 1 (EL2) */
>> +	ESR_EL2,	/* Exception Syndrome Register (EL2) */
>> +	FAR_EL2,	/* Hypervisor IPA Fault Address Register */
>> +	HPFAR_EL2,	/* Hypervisor IPA Fault Address Register */
>> +	MAIR_EL2,	/* Memory Attribute Indirection Register (EL2) */
>> +	AMAIR_EL2,	/* Auxiliary Memory Attribute Indirection Register (EL2) */
>> +	VBAR_EL2,	/* Vector Base Address Register (EL2) */
>> +	RVBAR_EL2,	/* Reset Vector Base Address Register */
>> +	RMR_EL2,	/* Reset Management Register */
>> +	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
>> +	TPIDR_EL2,	/* EL2 Software Thread ID Register */
>> +	CNTVOFF_EL2,	/* Counter-timer Virtual Offset register */
>> +	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
>> +	SP_EL2,		/* EL2 Stack Pointer */
>> +
> 
> I wonder whether we could make these conditionally present somehow.  Not
> worth worrying about for now to save 200-odd bytes per vcpu though.

With 8.4-NV, these 200 bytes turn into a whole 8kB (4kB page, plus
almost 4kB of padding that I need to reduce one way or another). So I'm
not too worried about this for now.

I really want the NV code to always be present though, in order to avoid
configuration related regressions. I'm not sure how to make this better.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
