Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAC86FFE70
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 03:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239750AbjELBeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 21:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239616AbjELBeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 21:34:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5518E30DD;
        Thu, 11 May 2023 18:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683855242; x=1715391242;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sxb0xXUrKWgZ49MNjGY9j9Ka3JM2Z0cQ2DHEp7tFPxY=;
  b=i++uYNXRxUHZ6bZ80rZmYk5K4z5RXcb8opNF025QlkewBqy50JwNN9De
   y4lYd4OXMG5R5LtMhgwM6WRJXW2gQ16GXMKil0RyveRQktXgpJ9xmx5d+
   mWfrBqR+0Lcl+StHOmhNgUEXhL0Gtqc8ZyEYrY/57BY5Yc5KB8Y0WPBsX
   zJVH0S7VJRSb7vbcOphnBdWoho2ZuAn2BNh6w8WPfUZds0y8dXxJty2Zc
   QKrw8BG1HyVg24Lfylkuhv+lLNqebLr12j00z5iSHZIf8xZr3xeN/4eHS
   FFvM/E48hvpvAz04jpFY3PwC3GYov03Ld0EblUiVo/YAPGkXHtquvrVPf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="353800259"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="353800259"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 18:34:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="702980062"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="702980062"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.30.205]) ([10.255.30.205])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 18:33:59 -0700
Message-ID: <abbb7938-0615-8578-0072-a96d21df3b4d@linux.intel.com>
Date:   Fri, 12 May 2023 09:33:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v8 2/6] KVM: x86: Virtualize CR4.LAM_SUP
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-3-binbin.wu@linux.intel.com>
 <67a20fe2a41fbe99de1470254b14f282f72571c7.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <67a20fe2a41fbe99de1470254b14f282f72571c7.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/11/2023 8:50 PM, Huang, Kai wrote:
> On Wed, 2023-05-10 at 14:06 +0800, Binbin Wu wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> Add support to allow guests to set the new CR4 control bit for guests to enable
>> the new Intel CPU feature Linear Address Masking (LAM) on supervisor pointers.
>>
>> LAM modifies the checking that is applied to 64-bit linear addresses, allowing
>> software to use of the untranslated address bits for metadata and masks the
>> metadata bits before using them as linear addresses to access memory. LAM uses
>> CR4.LAM_SUP (bit 28) to configure LAM for supervisor pointers. LAM also changes
>> VMENTER to allow the bit to be set in VMCS's HOST_CR4 and GUEST_CR4 for
>> virtualization.
>>
>> Move CR4.LAM_SUP out of CR4_RESERVED_BITS and its reservation depends on vcpu
>> supporting LAM feature or not. Leave the bit intercepted to avoid vmread every
>> time when KVM fetches its value, with the expectation that guest won't toggle
>> the bit frequently.
>>
>> Set CR4.LAM_SUP bit in the emulated IA32_VMX_CR4_FIXED1 MSR for guests to allow
>> guests to enable LAM for supervisor pointers in nested VMX operation.
>>
>> Hardware is not required to do TLB flush when CR4.LAM_SUP toggled, KVM doesn't
>> need to emulate TLB flush based on it.
>> There's no other features/vmx_exec_controls connection, no other code needed in
>> {kvm,vmx}_set_cr4().
>>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Reviewed-by: Chao Gao <chao.gao@intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 3 ++-
>>   arch/x86/kvm/vmx/vmx.c          | 3 +++
>>   arch/x86/kvm/x86.h              | 2 ++
>>   3 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index fb9d1f2d6136..c6f03d151c31 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -125,7 +125,8 @@
>>   			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>>   			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>>   			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
>> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
>> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
>> +			  | X86_CR4_LAM_SUP))
>>   
>>   #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>>   
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 44fb619803b8..362b2dce7661 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7603,6 +7603,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>>   	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
>>   	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
>>   
>> +	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
>> +	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
>> +
>>   #undef cr4_fixed1_update
>>   }
>>   
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index c544602d07a3..fe67b641cce4 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -529,6 +529,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>>   		__reserved_bits |= X86_CR4_VMXE;        \
>>   	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>>   		__reserved_bits |= X86_CR4_PCIDE;       \
>> +	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
>> +		__reserved_bits |= X86_CR4_LAM_SUP;     \
>>   	__reserved_bits;                                \
>>   })
>>   
> LAM only applies to 64-bit linear address, which means LAM can only be enabled
> when CPU is in 64-bit mode with either 4-level or 5-level paging enabled.
>
> What's the hardware behaviour if we set CR4.LAM_SUP when CPU isn't in 64-bit
> mode?  And how does VMENTRY check GUEST_CR4.LAM_SUP and 64-bit mode?
>
> Looks they are not clear in the spec you pasted in the cover letter:
>
> https://cdrdv2.intel.com/v1/dl/getContent/671368
>
> Or I am missing something?
Yes, it is not clearly described in LAM spec.
Had some internal discussions and also did some tests in host,
if the processor supports LAM, CR4.LAM_SUP is allowed to be set even 
when cpu isn't in 64bit mode.

There was a statement in commit message of the last version, but I 
missed it in this version. I'll add it back.
"CR4.LAM_SUP is allowed to be set even not in 64-bit mode, but it will not
take effect since LAM only applies to 64-bit linear address."

Also, I will try to ask Intel guys if it's possible to update the document.



