Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD697D9F35
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346109AbjJ0SAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjJ0SAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:00:07 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8689F3;
        Fri, 27 Oct 2023 11:00:04 -0700 (PDT)
Received: from [192.168.7.187] ([76.103.185.250])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 39RHx76Q727634
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 27 Oct 2023 10:59:08 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 39RHx76Q727634
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023101201; t=1698429549;
        bh=GukAnHkZFI3/rBa416j/S5VKfqqJcD7kg8PrMwTvmfg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Lr7+bZ4KBh+It+K8G/kFD8XX/ZwlJkuAbtJ7MtGnkv6RtjaBrPQ8O9tQEdxY4Eh6M
         yCy2FOzd4lvfc/bbO5ym+NQFQvcJFlraIQfCLXKDKcABq5gdX2mkbVUlo5MzQGoHpz
         bt+6nnvXNx0UZPyU6m/ub6c39dvjTwLPlfAGDWD8iXNVC5JYvx8ZZLxT0wksyFs43/
         8vxrdeRkeEeoL8HMkHruXUWDfgZCpm6bYpkc4bPiRr0TaS+JHEY2vW5TxkF6WsJtkx
         g3UmJX9toIb7Xdh/6/1UAUMPRmZ+aGXt7b3jR9jRw4NJOkoszwQAl1wJHb9r7+QeYB
         x9iwfkeYWSLsQ==
Message-ID: <1e01fb97-2e3c-4fd7-8ed4-1770d6c2b0d4@zytor.com>
Date:   Fri, 27 Oct 2023 10:59:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20231026172530.208867-1-xin@zytor.com>
 <4aff0cdcd6ae3b5998ac963df1eee31166caef1c.camel@intel.com>
From:   Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <4aff0cdcd6ae3b5998ac963df1eee31166caef1c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/2023 2:29 AM, Huang, Kai wrote:
> 
>>   
>> +/* VMX_BASIC bits and bitmasks */
>> +#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(48)
>> +#define VMX_BASIC_MEM_TYPE_WB			6LLU
> 
> Strictly speaking, VMX_BASIC_MEM_TYPE_MB isn't any bit definition or bitmasks of
> VMX_BASIC MSR.  So perhaps better to put it somewhere under separately.

Actually you reminded me that the memory type WB is architectural on
x86, but I can't find it defined in a common x86 header.

We also have:
#define VMX_EPTP_MT_WB                               0x6ull
which is simply redundant if we have a common definition MEMTYPE_WB.


>   
>> +#define VMX_BASIC_INOUT				BIT_ULL(54)
>> +
>> +/* VMX_MISC bits and bitmasks */
> 
> Your next patch is to "Cleanup VMX misc information defines and usages", so I
> guess it's better to move any VMX_MISC related change to that patch.

ah, you're right.

> 
>>   #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
>>   #define VMX_MISC_SAVE_EFER_LMA			0x00000020
>>   #define VMX_MISC_ACTIVITY_HLT			0x00000040
>> @@ -143,6 +149,16 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
>>   	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
>>   }
>>   
>> +static inline u32 vmx_basic_vmcs_basic_cap(u64 vmx_basic)
>> +{
>> +	return (vmx_basic & GENMASK_ULL(63, 45)) >> 32;
>> +}
>> +
>> +static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
>> +{
>> +	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
>> +}
>> +
>>   static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
>>   {
>>   	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 4ba46e1b29d2..274d480d9071 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1201,23 +1201,34 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
>>   	return (superset | subset) == superset;
>>   }
>>   
>> +#define VMX_BASIC_VMCS_SIZE_SHIFT		32
>> +#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
>> +#define VMX_BASIC_MEM_TYPE_SHIFT		50
>> +#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
> 
> If I am reading correctly, the two "*_SHIFT" above are not used?  The above
> vmx_basic_vmcs_mem_type() and vmx_basic_vmcs_basic_cap() use hard-coded values
> directly.

The 2 shift macros are needed in arch/x86/kvm/vmx/nested.c.

> 
> And How about moving all these bit/mask definitions to <asm/vmx.h> above?
> 
> It's better they stay together for better readability.

Sean kind of prefers to keep the macros close to code that uses it,
unless they are used somewhere else.

> 
>> +
>> +#define VMX_BASIC_FEATURES_MASK			\
>> +	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
>> +	 VMX_BASIC_INOUT |			\
>> +	 VMX_BASIC_TRUE_CTLS)
>> +
>> +#define VMX_BASIC_RESERVED_BITS			\
>> +	(GENMASK_ULL(63, 56) | GENMASK_ULL(47, 45) | BIT_ULL(31))
>> +
> 
> Also move these to <asm/vmx.h>?
> 
>>   static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
>>   {
>> -	const u64 feature_and_reserved =
>> -		/* feature (except bit 48; see below) */
>> -		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
>> -		/* reserved */
>> -		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
>>   	u64 vmx_basic = vmcs_config.nested.basic;
>>   
>> -	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
>> +	static_assert(!(VMX_BASIC_FEATURES_MASK & VMX_BASIC_RESERVED_BITS));
>> +
>> +	if (!is_bitwise_subset(vmx_basic, data,
>> +			       VMX_BASIC_FEATURES_MASK | VMX_BASIC_RESERVED_BITS))
>>   		return -EINVAL;
>>   
>>   	/*
>>   	 * KVM does not emulate a version of VMX that constrains physical
>>   	 * addresses of VMX structures (e.g. VMCS) to 32-bits.
>>   	 */
>> -	if (data & BIT_ULL(48))
>> +	if (data & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
>>   		return -EINVAL;
>>   
>>   	if (vmx_basic_vmcs_revision_id(vmx_basic) !=
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 4c3a70f26b42..b68d54f6e9f8 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2568,14 +2568,13 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
>>   static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   			     struct vmx_capability *vmx_cap)
>>   {
>> -	u32 vmx_msr_low, vmx_msr_high;
>>   	u32 _pin_based_exec_control = 0;
>>   	u32 _cpu_based_exec_control = 0;
>>   	u32 _cpu_based_2nd_exec_control = 0;
>>   	u64 _cpu_based_3rd_exec_control = 0;
>>   	u32 _vmexit_control = 0;
>>   	u32 _vmentry_control = 0;
>> -	u64 misc_msr;
>> +	u64 vmx_basic;
>>   	int i;
>>   
>>   	/*
>> @@ -2693,28 +2692,26 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   		_vmexit_control &= ~x_ctrl;
>>   	}
>>   
>> -	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
>> +	rdmsrl(MSR_IA32_VMX_BASIC, vmx_basic);
>>   
>>   	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
>> -	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
>> +	if ((vmx_basic_vmcs_size(vmx_basic) > PAGE_SIZE))
>>   		return -EIO;
>>   
>>   #ifdef CONFIG_X86_64
>>   	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
>> -	if (vmx_msr_high & (1u<<16))
>> +	if (vmx_basic & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
>>   		return -EIO;
>>   #endif
>>   
>>   	/* Require Write-Back (WB) memory type for VMCS accesses. */
>> -	if (((vmx_msr_high >> 18) & 15) != 6)
>> +	if (vmx_basic_vmcs_mem_type(vmx_basic) != VMX_BASIC_MEM_TYPE_WB)
>>   		return -EIO;
>>   
>> -	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
>> -
>> -	vmcs_conf->size = vmx_msr_high & 0x1fff;
>> -	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
>> +	vmcs_conf->size = vmx_basic_vmcs_size(vmx_basic);
>> +	vmcs_conf->basic_cap = vmx_basic_vmcs_basic_cap(vmx_basic);
>>   
>> -	vmcs_conf->revision_id = vmx_msr_low;
>> +	vmcs_conf->revision_id = vmx_basic_vmcs_revision_id(vmx_basic);
> 
> I actually tried to do similar thing before, and Sean gave me below advice:
> 
> 	Rather than do all of these weird dances, what about saving the
> full/raw
> 	MSR in the config, and then using the helpers to extract info as
> needed?
> 
> https://lkml.kernel.org/kvm/20230330092149.101047-1-kai.huang@intel.com/T/#m4879a3c7e66ede7bfa568a25aea4f6e3778e6e34
> 
> I agreed, but I has been too lazy to do this, sorry :-)
> 
> So maybe we should still go with this approach?

Yes, this looks more consistent.

> 
>>   
>>   	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
>>   	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
>> @@ -2722,7 +2719,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
>>   	vmcs_conf->vmexit_ctrl         = _vmexit_control;
>>   	vmcs_conf->vmentry_ctrl        = _vmentry_control;
>> -	vmcs_conf->misc	= misc_msr;
>> +
>> +	rdmsrl(MSR_IA32_VMX_MISC, vmcs_conf->misc);
> 
> Better to move VMX_MISC code to next patch I suppose.

I view it a bit different, but maybe your suggestion is better.

> 

Thanks!
     Xin

