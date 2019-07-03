Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329245E912
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfGCQbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 12:31:37 -0400
Received: from foss.arm.com ([217.140.110.172]:52222 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbfGCQbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 12:31:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90D22344;
        Wed,  3 Jul 2019 09:31:35 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 196CB3F718;
        Wed,  3 Jul 2019 09:31:33 -0700 (PDT)
Subject: Re: [PATCH 26/59] KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit
 setting
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
 <20190621093843.220980-27-marc.zyngier@arm.com>
 <8ad1b436-9325-2abb-648d-2cd3a3c9b113@arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <0dd7106e-d5a2-a374-107f-85f871d227b5@arm.com>
Date:   Wed, 3 Jul 2019 17:31:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8ad1b436-9325-2abb-648d-2cd3a3c9b113@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/06/2019 06:31, Julien Thierry wrote:
> 
> 
> On 06/21/2019 10:38 AM, Marc Zyngier wrote:
>> From: Jintack Lim <jintack.lim@linaro.org>
>>
>> Forward traps due to HCR_EL2.NV bit to the virtual EL2 if they are not
>> coming from the virtual EL2 and the virtual HCR_EL2.NV bit is set.
>>
>> In addition to EL2 register accesses, setting NV bit will also make EL12
>> register accesses trap to EL2. To emulate this for the virtual EL2,
>> forword traps due to EL12 register accessses to the virtual EL2 if the
>> virtual HCR_EL2.NV bit is set.
>>
>> This is for recursive nested virtualization.
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> [Moved code to emulate-nested.c]
>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_arm.h    |  1 +
>>  arch/arm64/include/asm/kvm_nested.h |  2 ++
>>  arch/arm64/kvm/emulate-nested.c     | 28 ++++++++++++++++++++++++++++
>>  arch/arm64/kvm/handle_exit.c        |  6 ++++++
>>  arch/arm64/kvm/sys_regs.c           | 18 ++++++++++++++++++
>>  5 files changed, 55 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 48e15af2bece..d21486274eeb 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -24,6 +24,7 @@
>>  
>>  /* Hyp Configuration Register (HCR) bits */
>>  #define HCR_FWB		(UL(1) << 46)
>> +#define HCR_NV		(UL(1) << 42)
>>  #define HCR_API		(UL(1) << 41)
>>  #define HCR_APK		(UL(1) << 40)
>>  #define HCR_TEA		(UL(1) << 37)
>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>> index 645e5e11b749..61e71d0d2151 100644
>> --- a/arch/arm64/include/asm/kvm_nested.h
>> +++ b/arch/arm64/include/asm/kvm_nested.h
>> @@ -11,5 +11,7 @@ static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
>>  }
>>  
>>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>> +extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>> +extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>>  
>>  #endif /* __ARM64_KVM_NESTED_H */
>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
>> index f829b8b04dc8..c406fd688b9f 100644
>> --- a/arch/arm64/kvm/emulate-nested.c
>> +++ b/arch/arm64/kvm/emulate-nested.c
>> @@ -24,6 +24,27 @@
>>  
>>  #include "trace.h"
>>  
>> +bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
> 
> Should this one be static?

$ git grep forward_traps
arch/arm64/include/asm/kvm_nested.h:extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
arch/arm64/kvm/emulate-nested.c:bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
arch/arm64/kvm/emulate-nested.c:        return forward_traps(vcpu, HCR_NV);
arch/arm64/kvm/sys_regs.c:      return forward_traps(vcpu, HCR_AT);
arch/arm64/kvm/sys_regs.c:      return forward_traps(vcpu, HCR_TTLB);
arch/arm64/kvm/sys_regs.c:      return forward_traps(vcpu, HCR_NV1);

I guess not.

> 
>> +{
>> +	bool control_bit_set;
>> +
>> +	if (!nested_virt_in_use(vcpu))
>> +		return false;
>> +
>> +	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
>> +	if (!vcpu_mode_el2(vcpu) && control_bit_set) {
>> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>> +		return true;
>> +	}
>> +	return false;
>> +}
>> +
>> +bool forward_nv_traps(struct kvm_vcpu *vcpu)
>> +{
>> +	return forward_traps(vcpu, HCR_NV);
>> +}
>> +
>> +
>>  /* This is borrowed from get_except_vector in inject_fault.c */
>>  static u64 get_el2_except_vector(struct kvm_vcpu *vcpu,
>>  		enum exception_type type)
>> @@ -55,6 +76,13 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>>  	u64 spsr, elr, mode;
>>  	bool direct_eret;
>>  
>> +	/*
>> +	 * Forward this trap to the virtual EL2 if the virtual
>> +	 * HCR_EL2.NV bit is set and this is coming from !EL2.
>> +	 */
>> +	if (forward_nv_traps(vcpu))
>> +		return;
>> +
>>  	/*
>>  	 * Going through the whole put/load motions is a waste of time
>>  	 * if this is a VHE guest hypervisor returning to its own
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index 39602a4c1d61..7e8b1ec1d251 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -72,6 +72,12 @@ static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  {
>>  	int ret;
>>  
>> +	/*
>> +	 * Forward this trapped smc instruction to the virtual EL2.
>> +	 */
>> +	if ((vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_TSC) && forward_nv_traps(vcpu))
> 
> Not sure I understand why this would be only when the guest hyp also has
> NV set.
> 
> If the guest hyp requested to trap smc instructions and that we received
> one while in vel1, shouldn't we always forward it to the guest hyp to
> let it implement the smc response the way it wants?

There is a small difference, but I'm not sure it matters: If EL3 is not
implemented, SMC UNDEFs at EL1 unless NV is set. So we know here that our
guest is running a guest hypervisor. But does it change a thing?

I need to think about it again... :-(

	M.
-- 
Jazz is not dead. It just smells funny...
