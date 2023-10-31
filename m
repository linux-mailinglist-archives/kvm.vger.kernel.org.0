Return-Path: <kvm+bounces-213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C977DD4AE
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2F13B21003
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8EA208C1;
	Tue, 31 Oct 2023 17:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="dKl5mYy7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63613AEC
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:29:36 +0000 (UTC)
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AFF8F;
	Tue, 31 Oct 2023 10:29:35 -0700 (PDT)
Received: from [192.168.7.187] ([76.103.185.250])
	(authenticated bits=0)
	by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 39VHSp11715311
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 31 Oct 2023 10:28:52 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 39VHSp11715311
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2023101201; t=1698773332;
	bh=B6aEIhwEV+uOGmAG0jTxRqmBo5hE68Bxjr/IuvGLN18=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dKl5mYy7JMqrVTtuWB9Odr5sSc04kgg8QaFB0r3R7TZU5cvVv2dnHBjDu26g1qksP
	 +hGd0RaDgarsHv8Bgen8+za8rm+ZIbpUDyx0EC1VT17O+p2AW7dumM2D0aJlcHvAyk
	 aPlaDCf0fkC8x1+ukpWvTzFno510+fg5JdPPddJM3Vs6LhAkIn/RJxznn3bqL3rldr
	 A+huVix52+SFJSFEf8JgLfJ2jLSBnzoCyfME9D2LyknwW+s2/7rP6tNQRD8zoM/qBN
	 oaEM7xs0n/WYNycaL9ySnQtGJhSmeWnXYgrjdAKGTa7LwULTgvmjXNy8Kl1lTsY71j
	 WxhBNMJSK7I5w==
Message-ID: <47316871-db95-4f72-9f3a-71743d97d336@zytor.com>
Date: Tue, 31 Oct 2023 10:28:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
To: "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "x86@kernel.org"
 <x86@kernel.org>,
        "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20231030233940.438233-1-xin@zytor.com>
 <2158ef3c5ce2de96c970b49802b7e1dba8b704d6.camel@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <2158ef3c5ce2de96c970b49802b7e1dba8b704d6.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/2023 2:03 AM, Huang, Kai wrote:
> On Mon, 2023-10-30 at 16:39 -0700, Xin Li (Intel) wrote:
>> From: Xin Li <xin3.li@intel.com>
>>
>> Define VMX basic information fields with BIT_ULL()/GENMASK_ULL(), and
>> replace hardcoded VMX basic numbers with these field macros.
>>
>> Per Sean's ask, save the full/raw value of MSR_IA32_VMX_BASIC in the
>> global vmcs_config as type u64 to get rid of the hi/lo crud, and then
>> use VMX_BASIC helpers to extract info as needed.
>>
> 
> [...]
> 
> Btw, it's better to have a cover letter even for this small series and give a
> lore link for old versions so that people can easily find old discussions.

Well, this patch set has few (I would say no) logic and functionality
changes, and the change history should be it.

> 
>>   
>> +/* x86 memory types, explicitly used in VMX only */
>> +#define MEM_TYPE_WB				0x6ULL
>> +#define MEM_TYPE_UC				0x0ULL
> 
> The renaming of memory type macros deserves some justification in the changelog
> IMHO, because it doesn't belong to what the patch title claims to do.

I thought about it, however the changes are more of how these 2 memory
type macros are used, which is still cleanup.

> 
> You can even split this part out, but will leave to Sean/Paolo.

My point too :)

> 
>> +
>> +/* VMX_BASIC bits and bitmasks */
>> +#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(48)
>> +#define VMX_BASIC_INOUT				BIT_ULL(54)
>> +
>>   #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
>>   #define VMX_MISC_SAVE_EFER_LMA			0x00000020
>>   #define VMX_MISC_ACTIVITY_HLT			0x00000040
>> @@ -143,6 +151,16 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
>>   	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
>>   }
>>   
>> +static inline u32 vmx_basic_vmcs_basic_cap(u64 vmx_basic)
>> +{
>> +	return (vmx_basic & GENMASK_ULL(63, 45)) >> 32;
>> +}
> 
> Is this still needed?

no.

> 
>> +
>> +static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
>> +{
>> +	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
>> +}
> 
> You already have VMX_BASIC_MEM_TYPE_SHIFT defined below, so it looks a little
> bit odd to still use hard-coded values here.
> 
> But per Sean I agree it's quite noisy to have all these _SHIFT defined just in
> order to get rid of these hard-coded values.
> 
> How about, ...
> 
>> +#define VMX_BASIC_VMCS_SIZE_SHIFT		32
>> +#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
>> +#define VMX_BASIC_MEM_TYPE_SHIFT		50
>> +#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
>> +
>>
> 
> ... since, if I am reading correctly, the two _SHIFT above are only used ...
> 
> [...]
> 
>> @@ -6964,7 +6975,7 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
>>   		VMCS12_REVISION |
>>   		VMX_BASIC_TRUE_CTLS |
>>   		((u64)VMCS12_SIZE << VMX_BASIC_VMCS_SIZE_SHIFT) |
>> -		(VMX_BASIC_MEM_TYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
>> +		(MEM_TYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
>>   
> 
> ... here, we can remove the two _SHIFT but define below instead:
> 
>    #define VMX_BASIC_VMCS12_SIZE	((u64)VMCS12_SIZE << 32)
>    #define VMX_BASIC_MEM_TYPE_WB	(MEM_TYPE_WB << 50)

I personally don't like such names, unless we can name them in a better
way.

> 
> And use above two macros in nested_vmx_setup_basic()?
> 
Thanks!
     Xin


