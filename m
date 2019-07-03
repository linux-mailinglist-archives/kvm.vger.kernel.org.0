Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44CB5E63A
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 16:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfGCOPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 10:15:41 -0400
Received: from foss.arm.com ([217.140.110.172]:49096 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbfGCOPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 10:15:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE5462B;
        Wed,  3 Jul 2019 07:15:36 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 656F83F718;
        Wed,  3 Jul 2019 07:15:35 -0700 (PDT)
Subject: Re: [PATCH 21/59] KVM: arm64: nv: Set a handler for the system
 instruction traps
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
 <20190621093843.220980-22-marc.zyngier@arm.com>
 <880f9a31-10bb-0fbd-987a-03dabf536f2f@arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <736ac3bf-20f4-56de-979b-6a77853f1517@arm.com>
Date:   Wed, 3 Jul 2019 15:15:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <880f9a31-10bb-0fbd-987a-03dabf536f2f@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/2019 13:55, Julien Thierry wrote:
> 
> 
> On 06/21/2019 10:38 AM, Marc Zyngier wrote:
>> From: Jintack Lim <jintack.lim@linaro.org>
>>
>> When HCR.NV bit is set, execution of the EL2 translation regime address
>> aranslation instructions and TLB maintenance instructions are trapped to
>> EL2. In addition, execution of the EL1 translation regime address
>> aranslation instructions and TLB maintenance instructions that are only
> 
> What's "translation regime address aranslation" ? I would guess
> "aranslation" should be removed, but since the same pattern appears
> twice in the commit doubt took over me :) .

It's a whole new concept. Still working on it though! ;-)

> 
>> accessible from EL2 and above are trapped to EL2. In these cases,
>> ESR_EL2.EC will be set to 0x18.
>>
>> Change the existing handler to handle those system instructions as well
>> as MRS/MSR instructions.  Emulation of each system instructions will be
>> done in separate patches.
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_coproc.h |  2 +-
>>  arch/arm64/kvm/handle_exit.c        |  2 +-
>>  arch/arm64/kvm/sys_regs.c           | 53 +++++++++++++++++++++++++----
>>  arch/arm64/kvm/trace.h              |  2 +-
>>  4 files changed, 50 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
>> index 0b52377a6c11..1b3d21bd8adb 100644
>> --- a/arch/arm64/include/asm/kvm_coproc.h
>> +++ b/arch/arm64/include/asm/kvm_coproc.h
>> @@ -43,7 +43,7 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> -int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> +int kvm_handle_sys(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  
>>  #define kvm_coproc_table_init kvm_sys_reg_table_init
>>  void kvm_sys_reg_table_init(void);
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index 2517711f034f..e662f23b63a1 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -236,7 +236,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>>  	[ESR_ELx_EC_SMC32]	= handle_smc,
>>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
>>  	[ESR_ELx_EC_SMC64]	= handle_smc,
>> -	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
>> +	[ESR_ELx_EC_SYS64]	= kvm_handle_sys,
>>  	[ESR_ELx_EC_SVE]	= handle_sve,
>>  	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
>>  	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 1d1312425cf2..e711dde4511c 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2597,6 +2597,40 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
>>  	return 1;
>>  }
>>  
>> +static int emulate_tlbi(struct kvm_vcpu *vcpu,
>> +			     struct sys_reg_params *params)
>> +{
>> +	/* TODO: support tlbi instruction emulation*/
>> +	kvm_inject_undefined(vcpu);
>> +	return 1;
>> +}
>> +
>> +static int emulate_at(struct kvm_vcpu *vcpu,
>> +			     struct sys_reg_params *params)
>> +{
>> +	/* TODO: support address translation instruction emulation */
>> +	kvm_inject_undefined(vcpu);
>> +	return 1;
>> +}
>> +
>> +static int emulate_sys_instr(struct kvm_vcpu *vcpu,
>> +			     struct sys_reg_params *params)
>> +{
>> +	int ret = 0;
>> +
>> +	/* TLB maintenance instructions*/
>> +	if (params->CRn == 0b1000)
>> +		ret = emulate_tlbi(vcpu, params);
>> +	/* Address Translation instructions */
>> +	else if (params->CRn == 0b0111 && params->CRm == 0b1000)
>> +		ret = emulate_at(vcpu, params);
>> +
> 
> So, in theory the NV bit shouldn't trap other Op0 == 1 instructions.
> Would it be worth adding a WARN() or BUG() in an "else" branch here,
> just in case?

Probably not a BUG(), but a WARN_ONCE() would be good.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
