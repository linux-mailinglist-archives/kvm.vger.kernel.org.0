Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A9A7CF282
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 10:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbjJSI1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 04:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbjJSI1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 04:27:01 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1382C130;
        Thu, 19 Oct 2023 01:26:58 -0700 (PDT)
Received: from [192.168.7.187] ([76.103.185.250])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 39J8Q8Ld647733
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 19 Oct 2023 01:26:09 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 39J8Q8Ld647733
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023101201; t=1697703970;
        bh=qC604qCWixi6qsUg2/vSLQ4O7LWbdngoJ3dxnuhZYvA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TlgSLd9TI0qJpEMVFbiIXJbJqGDxigCpfHI+LdG1Exh6lnuv2ayGdeyUboAEt/JKK
         AJQva+NPHcu1JOWsLAwG6zlQBrjfkuewFb6ZjGAbqbK0OJ1D9zbYRsJvcz1kHvVZha
         E9smW1diVC54KW88eh/am5aDKy8E6VuKit7oM73rshM/qf/9U+Ihm2oFvIYGxKR6Cv
         hc5a/jFFXIsI/byF/ba5C035UZsVVT9FRHnCjfHE30K5QytYHjih3qHY1nQfbVJUmX
         9w5oVQgFdjuoyByhfrAlapJThqEm6TOfjEIip7Q6kg4tw4zzIC9UN7Nr/eLlUbPnyl
         V8Yf/2/eL8Mog==
Message-ID: <20bb3005-bf6c-4fe1-bf0d-6d37e0ce1a77@zytor.com>
Date:   Thu, 19 Oct 2023 01:26:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: VMX: Cleanup VMX basic information defines and
 usages
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, weijiang.yang@intel.com
References: <20230927230811.2997443-1-xin@zytor.com>
 <ZTBJO75Zu1JBsqvw@google.com>
Content-Language: en-US
From:   Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <ZTBJO75Zu1JBsqvw@google.com>
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

On 10/18/2023 2:08 PM, Sean Christopherson wrote:

>> Add IA32_VMX_BASIC MSR bitfield shift macros and use them to define VMX
>> basic information bitfields.
> 
> Why?  Unless something actually uses the shift independently, just define the
> BIT_ULL(...) straightaway.

Well, reading "BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |" is hard.

But Lemme remove those shifts not being used now.

>> Add VMX_BASIC_FEATURES and VMX_BASIC_RESERVED_BITS to form a valid bitmask
>> of IA32_VMX_BASIC MSR. As a result, to add a new VMX basic feature bit,
>> just change the 2 new macros in the header file.
> 
> Not if a new feature bit lands in the middle of one of the reserved ranges, then
> the developer will have to update at least three macros, and add a new one. More
> below.

yes, it is the case for VMX nested exception feature bit.


> 
>> Also replace hardcoded VMX basic numbers with the new VMX basic macros.
>>
>> Tested-by: Shan Kang <shan.kang@intel.com>
>> Signed-off-by: Xin Li <xin3.li@intel.com>
>> ---
>>   arch/x86/include/asm/msr-index.h       | 31 ++++++++++++++++++++------
>>   arch/x86/kvm/vmx/nested.c              | 10 +++------
>>   arch/x86/kvm/vmx/vmx.c                 |  2 +-
>>   tools/arch/x86/include/asm/msr-index.h | 31 ++++++++++++++++++++------
> 
> Please drop the tools/ update, copying kernel headers into tools is a perf tools
> thing that I want no part of.
> 
> https://lore.kernel.org/all/Y8bZ%2FJ98V5i3wG%2Fv@google.com

why can't we simply remove tools/arch/x86/include/asm/msr-index.h?


> 
>>   4 files changed, 52 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 1d111350197f..4607448ff805 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -1084,13 +1084,30 @@
>>   #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
>>   
>>   /* VMX_BASIC bits and bitmasks */
>> -#define VMX_BASIC_VMCS_SIZE_SHIFT	32
>> -#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
>> -#define VMX_BASIC_64		0x0001000000000000LLU
>> -#define VMX_BASIC_MEM_TYPE_SHIFT	50
>> -#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
>> -#define VMX_BASIC_MEM_TYPE_WB	6LLU
>> -#define VMX_BASIC_INOUT		0x0040000000000000LLU
>> +#define VMX_BASIC_VMCS_SIZE_SHIFT		32
>> +#define VMX_BASIC_ALWAYS_0			BIT_ULL(31)
>> +#define VMX_BASIC_RESERVED_RANGE_1		GENMASK_ULL(47, 45)
>> +#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT	48
>> +#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT)
>> +#define VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT	49
>> +#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT)
>> +#define VMX_BASIC_MEM_TYPE_SHIFT		50
>> +#define VMX_BASIC_MEM_TYPE_WB			6LLU
>> +#define VMX_BASIC_INOUT_SHIFT			54
>> +#define VMX_BASIC_INOUT				BIT_ULL(VMX_BASIC_INOUT_SHIFT)
>> +#define VMX_BASIC_TRUE_CTLS_SHIFT		55
>> +#define VMX_BASIC_TRUE_CTLS			BIT_ULL(VMX_BASIC_TRUE_CTLS_SHIFT)
>> +#define VMX_BASIC_RESERVED_RANGE_2		GENMASK_ULL(63, 56)
>> +
>> +#define VMX_BASIC_FEATURES			\
> 
> Maybe VMX_BASIC_FEATURES_MASK to make it more obvious it's a mask of multiple
> bits?

This is better!


> 
>> +	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
>> +	 VMX_BASIC_INOUT |			\
>> +	 VMX_BASIC_TRUE_CTLS)
>> +
>> +#define VMX_BASIC_RESERVED_BITS			\
>> +	(VMX_BASIC_ALWAYS_0 |			\
>> +	 VMX_BASIC_RESERVED_RANGE_1 |		\
>> +	 VMX_BASIC_RESERVED_RANGE_2)
> 
> I don't see any value in defining VMX_BASIC_RESERVED_RANGE_1 and
> VMX_BASIC_RESERVED_RANGE_2 separately.   Or VMX_BASIC_ALWAYS_0 for the matter.
> And I don't think these macros need to go in msr-index.h, e.g. just define them
> above vmx_restore_vmx_basic() as that's likely going to be the only user, ever.

hmm, I'm overusing macros, better do:
#define VMX_BASIC_RESERVED_BITS			\
	(BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56))

Probably should also move VMX MSR field defs from msr-index.h to
a vmx header file.

> 
> And what's really missing is a static_assert() or BUILD_BUG_ON() to ensure that
> VMX_BASIC_FEATURES doesn't overlap with VMX_BASIC_RESERVED_BITS.

good idea, human beings are not good at such jobs by staring at it.

> 
>>   /* Resctrl MSRs: */
>>   /* - Intel: */
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index c5ec0ef51ff7..5280ba944c87 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1203,21 +1203,17 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
>>   
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
>> +	if (!is_bitwise_subset(vmx_basic, data,
>> +			       VMX_BASIC_FEATURES | VMX_BASIC_RESERVED_BITS))
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
>> index 72e3943f3693..f597243d6a72 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2701,7 +2701,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   
>>   #ifdef CONFIG_X86_64
>>   	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
>> -	if (vmx_msr_high & (1u<<16))
>> +	if (vmx_msr_high & (1u << (VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT - 32)))
> 
> In all honestly, I find the existing code easier to read.  I'm definitely not
> saying the existing code is good, but IMO this is at best a wash.
> 
> I would much rather we do something like this and move away from the hi/lo crud
> entirely:

I ever saw a TDX patch does most of this cleanup.

> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 86ce9efe6c66..f103980c3d02 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2693,28 +2693,28 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>                  _vmexit_control &= ~x_ctrl;
>          }
>   
> -       rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
> +       rdmsrl(MSR_IA32_VMX_BASIC, vmx_msr);
>   
>          /* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
> -       if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
> +       if ((VMX_BASIC_VMCS_SIZE(vmx_msr) > PAGE_SIZE)
>                  return -EIO;
>   
>   #ifdef CONFIG_X86_64
>          /* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
> -       if (vmx_msr_high & (1u<<16))
> +       if (vmx_msr & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
>                  return -EIO;
>   #endif
>   
>          /* Require Write-Back (WB) memory type for VMCS accesses. */
> -       if (((vmx_msr_high >> 18) & 15) != 6)
> +       if (VMX_BASIC_VMCS_MEMTYPE(vmx_msr) != VMX_BASIC_MEM_TYPE_WB)
>                  return -EIO;
>   
>          rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
>   
> -       vmcs_conf->size = vmx_msr_high & 0x1fff;
> -       vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
> +       vmcs_conf->size = VMX_BASIC_VMCS_SIZE(vmx_msr);
> +       vmcs_conf->basic_cap = ????(vmx_msr);
>   
> -       vmcs_conf->revision_id = vmx_msr_low;
> +       vmcs_conf->revision_id = (u32)vmx_msr;
>   
>          vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
>          vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
> 

-- 
Thanks!
     Xin

