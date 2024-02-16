Return-Path: <kvm+bounces-8892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2486985847D
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4FFF1F215B3
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 17:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7041132C1E;
	Fri, 16 Feb 2024 17:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="mn2c0zOE"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FD1131722;
	Fri, 16 Feb 2024 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708105660; cv=none; b=m5Wq/55V/IbTaEM1LKrBlkZj5HBbmg2MBrbVy3BiMmKkSyl7EET71oAHXFcM4MSGQJkPlnxiIvIdvidVI2emEFpuHY4/dQmnrMtvckha/wDUJnkRkK2vwNXeaciHBlXcZ+3RU9M0VTFEbUVDaDEeMDIRgYRwGvykw6m+caPQq4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708105660; c=relaxed/simple;
	bh=pCdcgfupWxb9tNcvVGMT8DeXhPoVdcf8md3sQ9WO9UI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=plSAbNqOx2zpu1ArXxfuYTIibGles8pIN9i34pdG3rz1r7Y6Iv+MjKOLoOMWCRl1Zsu6QUa40auOx33utpJFmqRlIE7UNSLiw6zt+kZUIwqcsJAiguKlz27nLGxH4GywEqmChhC92mo4kJ+CSykeAm9cSblBTOB2jrT//JhEx/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=mn2c0zOE; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.187] ([71.202.196.111])
	(authenticated bits=0)
	by mail.zytor.com (8.17.2/8.17.1) with ESMTPSA id 41GHlPqk2189121
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 16 Feb 2024 09:47:26 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 41GHlPqk2189121
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024021201; t=1708105647;
	bh=/4ACweF7wN4lnpLyn+mOJHhkAqPUkZwP7iBkgupiACc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=mn2c0zOEmKWEbzEo4BAejsVpUfaSx+ksVDcAAewt1kFPTKIyQQmTE6IRXpjxw0zYP
	 Lrz2cAlrDVJtg9Bu43kiJSVsxielT6Jp9aLYa6w6JNqayZuyVGIc/+a1fe5Y9YTP2s
	 QYb5PtnqjHsTtq5oBx1u2SFcXBOj8N9ztIjGEaMnRbhZ5G7eXPHGitktcJBSvDMLTs
	 UlJX7CPL0u46b1jgKSUJy7vx/HxnousIJyY4U0j2JtZm/4nfPLweRcy1JyUC1kHN2T
	 7fn/3Baea24JF9IAIuddnLQmDE/je3QdzCcaz33APsRCwDX9JQ0tq8OBDcgAZAYWo7
	 +BqBmmEvp/vlA==
Message-ID: <b7e7f51a-25d7-466a-b892-3746c86c67e6@zytor.com>
Date: Fri, 16 Feb 2024 09:47:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is
 disabled
Content-Language: en-US
From: Xin Li <xin@zytor.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Max Kellermann <max.kellermann@ionos.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com>
 <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
 <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com>
 <1bcbd004-7233-4369-a4ac-7fcb91a97553@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <1bcbd004-7233-4369-a4ac-7fcb91a97553@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/16/2024 9:41 AM, Xin Li wrote:
> On 2/15/2024 10:31 PM, Paolo Bonzini wrote:
>> On 2/16/24 03:10, Xin Li wrote:
>>> On 2/15/2024 11:55 AM, Sean Christopherson wrote:
>>>> +Paolo and Stephen
>>>>
>>>> FYI, there's a build failure in -next due to a collision between 
>>>> kvm/next and
>>>> tip/x86/fred.  The above makes everything happy.
>>>>
>>>> On Thu, Feb 15, 2024, Max Kellermann wrote:
>>>>> When KVM is disabled, the POSTED_INTR_* macros do not exist, and the
>>>>> build fails.
>>>>>
>>>>> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
>>>>> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
>>>>> ---
>>>>>   arch/x86/entry/entry_fred.c | 2 ++
>>>>>   1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
>>>>> index ac120cbdaaf2..660b7f7f9a79 100644
>>>>> --- a/arch/x86/entry/entry_fred.c
>>>>> +++ b/arch/x86/entry/entry_fred.c
>>>>> @@ -114,9 +114,11 @@ static idtentry_t 
>>>>> sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
>>>>>       SYSVEC(IRQ_WORK_VECTOR,            irq_work),
>>>>> +#if IS_ENABLED(CONFIG_KVM)
>>>>>       SYSVEC(POSTED_INTR_VECTOR,        kvm_posted_intr_ipi),
>>>>>       SYSVEC(POSTED_INTR_WAKEUP_VECTOR,    
>>>>> kvm_posted_intr_wakeup_ipi),
>>>>>       SYSVEC(POSTED_INTR_NESTED_VECTOR,    
>>>>> kvm_posted_intr_nested_ipi),
>>>>> +#endif
>>>>>   };
>>>>>   static bool fred_setup_done __initdata;
>>>>> -- 
>>>>> 2.39.2
>>>
>>> We want to minimize #ifdeffery (which is why we didn't add any to
>>> sysvec_table[]), would it be better to simply remove "#if 
>>> IS_ENABLED(CONFIG_KVM)" around the the POSTED_INTR_* macros from the
>>> Linux-next tree?
>>>
>>> BTW, kvm_posted_intr_*() are defined to NULL if !IS_ENABLED(CONFIG_KVM).
>>
>> It is intentional that KVM-related things are compiled out completely
>> if !IS_ENABLED(CONFIG_KVM), 
> 
> In arch/x86/include/asm/irq_vectors.h, most vector definitions are not
> under any #ifdeffery, e.g., THERMAL_APIC_VECTOR not under
> CONFIG_X86_THERMAL_VECTOR and IRQ_WORK_VECTOR not under CONFIG_IRQ_WORK.
> 
> We'd better make all of them consistent, and the question is that should
> we add #ifdefs or not.
> 
>> because then it's also not necessary to have
>>
>> # define fred_sysvec_kvm_posted_intr_ipi                NULL
>> # define fred_sysvec_kvm_posted_intr_wakeup_ipi         NULL
>> # define fred_sysvec_kvm_posted_intr_nested_ipi         NULL
>>
>> in arch/x86/include/asm/idtentry.h. The full conflict resultion is
>>
>> diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
>> index ac120cbdaaf2..660b7f7f9a79 100644
>> --- a/arch/x86/entry/entry_fred.c
>> +++ b/arch/x86/entry/entry_fred.c
>> @@ -114,9 +114,11 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] 
>> __ro_after_init = {
>>
>>       SYSVEC(IRQ_WORK_VECTOR,            irq_work),
>>
>> +#if IS_ENABLED(CONFIG_KVM)
>>       SYSVEC(POSTED_INTR_VECTOR,        kvm_posted_intr_ipi),
>>       SYSVEC(POSTED_INTR_WAKEUP_VECTOR,    kvm_posted_intr_wakeup_ipi),
>>       SYSVEC(POSTED_INTR_NESTED_VECTOR,    kvm_posted_intr_nested_ipi),
>> +#endif
>>   };
>>
>>   static bool fred_setup_done __initdata;
>> diff --git a/arch/x86/include/asm/idtentry.h 
>> b/arch/x86/include/asm/idtentry.h
>> index 749c7411d2f1..758f6a2838a8 100644
>> --- a/arch/x86/include/asm/idtentry.h
>> +++ b/arch/x86/include/asm/idtentry.h
>> @@ -745,10 +745,6 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR, 
>> sysvec_irq_work);
>>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR, 
>> sysvec_kvm_posted_intr_ipi);
>>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR, 
>> sysvec_kvm_posted_intr_wakeup_ipi);
>>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR, 
>> sysvec_kvm_posted_intr_nested_ipi);
>> -#else
>> -# define fred_sysvec_kvm_posted_intr_ipi        NULL
>> -# define fred_sysvec_kvm_posted_intr_wakeup_ipi        NULL
>> -# define fred_sysvec_kvm_posted_intr_nested_ipi        NULL
>>   #endif
>>
>>   #if IS_ENABLED(CONFIG_HYPERV)
>>
>> and it seems to be a net improvement to me.  The #ifs match in
>> the .h and .c files, and there are no unnecessary initializers
>> in the sysvec_table.
>>
> 
> I somehow get an impression that the x86 maintainers don't like #ifs in
> the .c files, but I could be just wrong.
> 

Here is an example, but again my interpretation could just be wrong:

#ifdef CONFIG_X86_FRED
void fred_install_sysvec(unsigned int vector, const idtentry_t function);
#else
static inline void fred_install_sysvec(unsigned int vector, const 
idtentry_t function) { }
#endif

#define sysvec_install(vector, function) {                              \
         if (cpu_feature_enabled(X86_FEATURE_FRED))                      \
                 fred_install_sysvec(vector, function);                  \
         else                                                            \
                 idt_install_sysvec(vector, asm_##function);             \
}




