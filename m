Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429385FA30
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 16:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfGDOjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 10:39:10 -0400
Received: from foss.arm.com ([217.140.110.172]:42882 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfGDOjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 10:39:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A173528;
        Thu,  4 Jul 2019 07:39:09 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A738F3F738;
        Thu,  4 Jul 2019 07:39:08 -0700 (PDT)
Subject: Re: [PATCH 13/59] KVM: arm64: nv: Handle virtual EL2 registers in
 vcpu_read/write_sys_reg()
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-14-marc.zyngier@arm.com>
 <6a866fda-a332-9881-b466-2a855deea6a5@arm.com>
 <13886346-cbbc-a17c-b83d-e189a30e0696@arm.com>
 <c3138f83-ccfb-5d01-3cac-be47f1eb916c@arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <a22b4745-7fa1-554b-c897-9359fffa3a1f@arm.com>
Date:   Thu, 4 Jul 2019 15:39:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c3138f83-ccfb-5d01-3cac-be47f1eb916c@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/2019 17:32, Alexandru Elisei wrote:

[...]

>>>> +}
>>>> +
>>>> +#define EL2_SYSREG(el2, el1, translate)	\
>>>> +	[el2 - FIRST_EL2_SYSREG] = { el2, el1, translate }
>>>> +#define PURE_EL2_SYSREG(el2) \
>>>> +	[el2 - FIRST_EL2_SYSREG] = { el2,__INVALID_SYSREG__, NULL }
>>>> +/*
>>>> + * Associate vEL2 registers to their EL1 counterparts on the CPU.
>>>> + * The translate function can be NULL, when the register layout is identical.
>>>> + */
>>>> +struct el2_sysreg_map {
>>>> +	int sysreg;	/* EL2 register index into the array above */
>>>> +	int mapping;	/* associated EL1 register */
>>>> +	u64 (*translate)(u64 value);
>>>> +} nested_sysreg_map[NR_SYS_REGS - FIRST_EL2_SYSREG] = {
>>>> +	PURE_EL2_SYSREG( VPIDR_EL2 ),
>>>> +	PURE_EL2_SYSREG( VMPIDR_EL2 ),
>>>> +	PURE_EL2_SYSREG( ACTLR_EL2 ),
>>>> +	PURE_EL2_SYSREG( HCR_EL2 ),
>>>> +	PURE_EL2_SYSREG( MDCR_EL2 ),
>>>> +	PURE_EL2_SYSREG( HSTR_EL2 ),
>>>> +	PURE_EL2_SYSREG( HACR_EL2 ),
>>>> +	PURE_EL2_SYSREG( VTTBR_EL2 ),
>>>> +	PURE_EL2_SYSREG( VTCR_EL2 ),
>>>> +	PURE_EL2_SYSREG( RVBAR_EL2 ),
>>>> +	PURE_EL2_SYSREG( RMR_EL2 ),
>>>> +	PURE_EL2_SYSREG( TPIDR_EL2 ),
>>>> +	PURE_EL2_SYSREG( CNTVOFF_EL2 ),
>>>> +	PURE_EL2_SYSREG( CNTHCTL_EL2 ),
>>>> +	PURE_EL2_SYSREG( HPFAR_EL2 ),
>>>> +	EL2_SYSREG(      SCTLR_EL2,  SCTLR_EL1,      translate_sctlr ),
>>>> +	EL2_SYSREG(      CPTR_EL2,   CPACR_EL1,      translate_cptr  ),
>>>> +	EL2_SYSREG(      TTBR0_EL2,  TTBR0_EL1,      translate_ttbr0 ),
>>>> +	EL2_SYSREG(      TTBR1_EL2,  TTBR1_EL1,      NULL            ),
>>>> +	EL2_SYSREG(      TCR_EL2,    TCR_EL1,        translate_tcr   ),
>>>> +	EL2_SYSREG(      VBAR_EL2,   VBAR_EL1,       NULL            ),
>>>> +	EL2_SYSREG(      AFSR0_EL2,  AFSR0_EL1,      NULL            ),
>>>> +	EL2_SYSREG(      AFSR1_EL2,  AFSR1_EL1,      NULL            ),
>>>> +	EL2_SYSREG(      ESR_EL2,    ESR_EL1,        NULL            ),
>>>> +	EL2_SYSREG(      FAR_EL2,    FAR_EL1,        NULL            ),
>>>> +	EL2_SYSREG(      MAIR_EL2,   MAIR_EL1,       NULL            ),
>>>> +	EL2_SYSREG(      AMAIR_EL2,  AMAIR_EL1,      NULL            ),
>>>> +};
>>> Figuring out which registers are in this map and which aren't and are supposed
>>> to be treated differently is really cumbersome because they are split into two
>>> types of el2 registers and their order is different from the order in enum
>>> vcpu_sysreg (in kvm_host.h). Perhaps adding a comment about what registers will
>>> be treated differently would make the code a bit easier to follow?
>> I'm not sure what this buys us. We have 3 categories of EL2 sysregs:
>> - Purely emulated
>> - Directly mapped onto an EL1 sysreg
>> - Translated from EL2 to EL1
>>
>> I think the wrappers represent that pretty well, although we could split
>> EL2_SYSREG into DIRECT_EL2_SYSREG and TRANSLATE_EL2_SYSREG. As for the
>> order, does it really matter? We also have the trap table order, which
>> is also different from the enum. Do you propose we reorder everything?
> 
> The wrappers and the naming are fine.
> 
> I was trying to figure out which EL2 registers are in the nested_sysreg_map and
> which aren't (that's what I meant by "two types of registers") by looking at the
> vcpu_sysreg enum. Because the order in the map is different than the order in
> the enum, I was having a difficult time figuring out which registers are not in
> the nested_sysreg_map to make sure we haven't somehow forgot to emulate a register.
> 
> So no, I wasn't asking to reorder everything. I was asking if it would be
> appropriate to write a comment stating the intention to treat registers X, Y and
> Z separately from the registers in nested_sysreg_map.

Ah, fair enough. Yes, that's a very reasonable suggestion.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
