Return-Path: <kvm+bounces-53848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D58BAB185C8
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 18:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC1BF581AF1
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 16:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE8C28CF5C;
	Fri,  1 Aug 2025 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="v321MfF2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3929C1F2C45;
	Fri,  1 Aug 2025 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754065705; cv=none; b=us0N9iUL2Secm3/oMjEQQcfrqaFNf/KlNq85z7YDReTwGsgUtjqlrzTzCxcaX5jcl/Hi4C/HcmTIvcEXahQeevMEGEilvM4fhGh0mDMmrag3tnMGORCB8CiKEVnQvYxdTdt2S5fRlDTYf/TgRYm2AzFEMalJBMu/6oN2ijb7gc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754065705; c=relaxed/simple;
	bh=7KN7jxN1xhOuuMgct4p3MSXPg+2R2mCAvX5lQLKS+wI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ToGgHlklueDDWKHK86BE2DjXKEUGs5gUUZhR31erGoeAJRbLQ6V8Ot+xHM4cV8t+A+JEvJznABoZao/7jPjSYDVIi/tHg9P9Y7DRPH3fS9hSaBbZcJG01sXgGI1q/LHQW16R1S2AxI9NHsRu5y3vXByH24uJHiWjl+2+9O+6Lg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=v321MfF2; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 571GRqDD2947859
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 1 Aug 2025 09:27:53 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 571GRqDD2947859
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754065674;
	bh=OLtNWbgnEawrqTKJxWuW7Pqkf2cPjeHWlfO8F9mfG3Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=v321MfF2NHtBPo6fPuxU8Iyzhcc/zIbyXRhZnIKDCVwfrpo6yeTXZtA3gbXBgg8GK
	 Wn2AWemVe3iM3El1/xKU7O9umGCcdETZdJQvh4tASwD6Zw5l6AH/7q+0ySgezDZiRs
	 cYCHcDh7HJhJx5ENZHuiRM9IaGMJOGEOXqk0WTiF/AAh0/EkXDjXVEAVi0YUJA2GGv
	 1/zZKdyyNc+WOdIEyQY6bbyU5PNCxQjHU/JEHWoZS2JZ/22cn4GJ0h90FnRzgG5sLo
	 /0hweQXLFvvWxoxqvCOKh0snH8LJ6xkwuoFnG2neawVX5M3QlpxpTMqiNVpTrymrZZ
	 qo7KJuLhUdObA==
Message-ID: <72a0c74e-529a-4b1e-bf9c-07468caa24d4@zytor.com>
Date: Fri, 1 Aug 2025 09:27:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] KVM: x86: Introduce MSR read/write emulation
 helpers
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        chao.gao@intel.com
References: <20250730174605.1614792-1-xin@zytor.com>
 <20250730174605.1614792-3-xin@zytor.com> <aIzROnILlYuaE2FB@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aIzROnILlYuaE2FB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/2025 7:37 AM, Sean Christopherson wrote:
> On Wed, Jul 30, 2025, Xin Li (Intel) wrote:
>> Add helper functions to centralize guest MSR read and write emulation.
>> This change consolidates the MSR emulation logic and makes it easier
>> to extend support for new MSR-related VM exit reasons introduced with
>> the immediate form of MSR instructions.
>>
>> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/x86.c              | 67 +++++++++++++++++++++++----------
>>   2 files changed, 49 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index f19a76d3ca0e..a854d9a166fe 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -201,6 +201,7 @@ enum kvm_reg {
>>   	VCPU_EXREG_SEGMENTS,
>>   	VCPU_EXREG_EXIT_INFO_1,
>>   	VCPU_EXREG_EXIT_INFO_2,
>> +	VCPU_EXREG_EDX_EAX,
> 
> I really, really don't want to add a "reg" for this.  It's not an actual register,
> and bleeds details of one specific flow throughout KVM.

Sure.

> 
> The only path where KVM _needs_ to differentiate between the "legacy" instructions
> and the immediate variants instruction is in the inner RDMSR helper.
> 
> For the WRMSR helper, KVM can and should simply pass in @data, not pass in a reg
> and then have the helper do an if-else on the reg:

My initial patch passes @data in the WRMSR path, but to make it 
consistent with the handling of RDMSR I changed it to @reg.

Yes, passing @data makes more sense because it hides unneccesary details.

> 
>    int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>    {
>    	return __kvm_emulate_wrmsr(vcpu, kvm_rcx_read(vcpu),
>    				   kvm_read_edx_eax(vcpu));
>    }
>    EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
>    
>    int kvm_emulate_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
>    {
>    	return __kvm_emulate_wrmsr(vcpu, msr, kvm_register_read(vcpu, reg));
>    }
>    EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr_imm);
> 
> And for the RDMSR userspace completion, KVM is already eating an indirect function
> call, so the wrappers can simply pass in the appropriate completion helper.  It
> does mean having to duplicate the vcpu->run->msr.error check, but we'd have to
> duplicate the "r == VCPU_EXREG_EDX_EAX" by sharing a callback, *and* we'd also
> need to be very careful about setting the effective register in the other existing
> flows that utilize complete_fast_rdmsr.
> 
> Then to communicate that the legacy form with implicit destination operands is
> being emulated, pass -1 for the register.  It's not the prettiest, but I do like
> using "reg invalid" to communicate that the destination is implicit.
> 
>    static int __kvm_emulate_rdmsr(struct kvm_vcpu *vcpu, u32 msr, int reg,
>    			       int (*complete_rdmsr)(struct kvm_vcpu *))

Yeah, it is a clean way to pass a userspace completion callback.

>    {
>    	u64 data;
>    	int r;
>    
>    	r = kvm_get_msr_with_filter(vcpu, msr, &data);
>    	if (!r) {
>    		trace_kvm_msr_read(msr, data);
>    
>    		if (reg < 0) {
>    			kvm_rax_write(vcpu, data & -1u);
>    			kvm_rdx_write(vcpu, (data >> 32) & -1u);
>    		} else {
>    			kvm_register_write(vcpu, reg, data);
>    		}
>    	} else {
>    		/* MSR read failed? See if we should ask user space */
>    		if (kvm_msr_user_space(vcpu, msr, KVM_EXIT_X86_RDMSR, 0,
>    				       complete_rdmsr, r))
>    			return 0;
>    		trace_kvm_msr_read_ex(msr);
>    	}
>    
>    	return kvm_x86_call(complete_emulated_msr)(vcpu, r);
>    }
>    
>    int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
>    {
>    	return __kvm_emulate_rdmsr(vcpu, kvm_rcx_read(vcpu), -1,
>    				   complete_fast_rdmsr);
>    }
>    EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
>    
>    int kvm_emulate_rdmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
>    {
>    	vcpu->arch.cui_rdmsr_imm_reg = reg;
>    
>    	return __kvm_emulate_rdmsr(vcpu, msr, reg, complete_fast_rdmsr_imm);
>    }
>    EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr_imm);
> 
>>   };
>>   
>>   enum {
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index a1c49bc681c4..5086c3b30345 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2024,54 +2024,71 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
>>   	return 1;
>>   }
>>   
>> -int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
>> +static int kvm_emulate_get_msr(struct kvm_vcpu *vcpu, u32 msr, int reg)
> 
> Please keep "rdmsr" and "wrmsr" when dealing emulation of those instructions to
> help differentiate from the many other MSR get/set paths.  (ignore the actual
> emulator hooks; that code is crusty, but not worth the churn to clean up).

Once the rules are laid out, it's easy to act :)

> 
>> @@ -2163,9 +2180,8 @@ static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
>>   	return 0;
>>   }
>>   
>> -fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
>> +static fastpath_t handle_set_msr_irqoff(struct kvm_vcpu *vcpu, u32 msr, int reg)
> 
> I think it makes sense to (a) add the x86.c code and the vmx.c code in the same
> patch, and then (b) add fastpath support in a separate patch to make the initial
> (combined x86.c + vmx.c) patch easier to review.  Adding the x86.c plumbing/logic
> before the VMX support makes the x86.c change difficult to review, as there are
> no users of the new paths, and the VMX changes are quite tiny.  Ignoring the arch
> boilerplate, the VMX changes barely add anything relative to the x86.c changes.

Will do.

> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ae2c8c10e5d2..757e4bb89f36 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6003,6 +6003,23 @@ static int handle_notify(struct kvm_vcpu *vcpu)
>          return 1;
>   }
>   
> +static int vmx_get_msr_imm_reg(struct kvm_vcpu *vcpu)
> +{
> +       return vmx_get_instr_info_reg(vmcs_read32(VMX_INSTRUCTION_INFO))
> +}
> +
> +static int handle_rdmsr_imm(struct kvm_vcpu *vcpu)
> +{
> +       return kvm_emulate_rdmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
> +                                    vmx_get_msr_imm_reg(vcpu));
> +}
> +
> +static int handle_wrmsr_imm(struct kvm_vcpu *vcpu)
> +{
> +       return kvm_emulate_wrmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
> +                                    vmx_get_msr_imm_reg(vcpu));
> +}
> +
>   /*
>    * The exit handlers return 1 if the exit was handled fully and guest execution
>    * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
> @@ -6061,6 +6078,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>          [EXIT_REASON_ENCLS]                   = handle_encls,
>          [EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
>          [EXIT_REASON_NOTIFY]                  = handle_notify,
> +       [EXIT_REASON_MSR_READ_IMM]            = handle_rdmsr_imm,
> +       [EXIT_REASON_MSR_WRITE_IMM]           = handle_wrmsr_imm,
>   };
>   
>   static const int kvm_vmx_max_exit_handlers =
> @@ -6495,6 +6514,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   #ifdef CONFIG_MITIGATION_RETPOLINE
>          if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
>                  return kvm_emulate_wrmsr(vcpu);
> +       else if (exit_reason.basic == EXIT_REASON_MSR_WRITE_IMM)
> +               return handle_wrmsr_imm(vcpu);
>          else if (exit_reason.basic == EXIT_REASON_PREEMPTION_TIMER)
>                  return handle_preemption_timer(vcpu);
>          else if (exit_reason.basic == EXIT_REASON_INTERRUPT_WINDOW)
> 

Thanks!
     Xin

