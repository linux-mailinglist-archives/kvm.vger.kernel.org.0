Return-Path: <kvm+bounces-55971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E483FB38E3E
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E8662058A0
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 22:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0930E311954;
	Wed, 27 Aug 2025 22:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="mEoOQB3z"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCC427935C;
	Wed, 27 Aug 2025 22:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333201; cv=none; b=tP3ylBzC1Z6LAQ39pJl+bf0cWhfDRM5IdXjPQ28Lj+ippdjkt0o5v3LzBgBeNCMtuTf9pUprtvslQRaqp9LuZpupt23GX42SQEGSiMynLCeLxgDoynItKWASVTIDVlN/Xp+05EAt/mjLUFfoaHXM/I8GyDSLLofd1x5/oLehS0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333201; c=relaxed/simple;
	bh=r/pGZK7kffhvJQpxrfEZVXYRwUpDhgaWXvg34gCGFB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HuFfCoR1v1nCvdhcOSwj92KmWjsVJdw7/BpVHAxo36feGW/dSLy5yWjhZGu8LPenOtHmZ4cdhLpHjXiWjj4milWDsOysgHF5yFZUxml/A2tukzLLcQhQ3DbKnTG1Nh/AuuV+NYpPdAgL4fYH4xZ6gjj+4HkuZE4tnqm07ciz3yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=mEoOQB3z; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57RMIq9C1905948
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 27 Aug 2025 15:18:52 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57RMIq9C1905948
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756333135;
	bh=2cYP731y2qYaZDQ8pdiBsKtWhtEf1GRHZ29xPrOv/bQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mEoOQB3z2Cjz5W5eDNyuS4wLtk1nqxV63zfySIBg/3Z7FOM3f8nG5b/+dU/GwFS4s
	 zyWKFPv9eZ8g9zrxAuZLj3NH0+JaLwwTsOpMS4+jYzFkILsPqcnkP8121zWpeUIWxt
	 tgh5a8JXOAV7vJd7PpUdf2twy806pL621/RYnQj0Q/IKqyJacDtr7LPRNd6bSCyzfh
	 C0htM9pIjIVuMRNeffl4IO9FjTVMt4jStmvuMya1PznQHhf7kp0rgoOZLnDNvfX51V
	 6Re9UIchwfxmiLxY/XpiXFiMzDpFAcufTnwoKvigmrphZ6FvyRcmSk1F099QJ0Bh7K
	 5zmxh6HcA1YaA==
Message-ID: <2cdc163a-12fc-49e1-ab87-bba6df0ae345@zytor.com>
Date: Wed, 27 Aug 2025 15:18:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/20] x86/cea: Export an API to get per CPU exception
 stacks for KVM to use
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, chao.gao@intel.com, hch@infradead.org
References: <20250821223630.984383-1-xin@zytor.com>
 <20250821223630.984383-5-xin@zytor.com>
 <720bc7ac-7e81-4ad9-8cc5-29ac540be283@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <720bc7ac-7e81-4ad9-8cc5-29ac540be283@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> Suggested-by: Christoph Hellwig <hch@infradead.org>
>> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> 
> Nit: I wouldn't use Suggested-by unless the person basically asked for
> the *entire* patch. Christoph and I were asking for specific bits of
> this, but neither of us asked for this patch as a whole.

I did it because the patch is almost rewritten to export accessors instead
of raw data, IOW, the way of doing it is completely changed.

But I will remove Suggested-by.

> 
>> diff --git a/arch/x86/coco/sev/sev-nmi.c b/arch/x86/coco/sev/sev-nmi.c
>> index d8dfaddfb367..73e34ad7a1a9 100644
>> --- a/arch/x86/coco/sev/sev-nmi.c
>> +++ b/arch/x86/coco/sev/sev-nmi.c
>> @@ -30,7 +30,7 @@ static __always_inline bool on_vc_stack(struct pt_regs *regs)
>>   	if (ip_within_syscall_gap(regs))
>>   		return false;
>>   
>> -	return ((sp >= __this_cpu_ist_bottom_va(VC)) && (sp < __this_cpu_ist_top_va(VC)));
>> +	return ((sp >= __this_cpu_ist_bottom_va(ESTACK_VC)) && (sp < __this_cpu_ist_top_va(ESTACK_VC)));
>>   }
> 
> This rename is one of those things that had me scratching my head for a
> minute. It wasn't obvious at _all_ why the VC=>ESTACK_VC "rename" is
> necessary.
> 
> This needs to have been mentioned in the changelog.
> 
> Better yet would have been to do this in a separate patch because a big
> chunk of this patch is just rename noise.

Sure, will do.

>> diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
>> index 462fc34f1317..8e17f0ca74e6 100644
>> --- a/arch/x86/include/asm/cpu_entry_area.h
>> +++ b/arch/x86/include/asm/cpu_entry_area.h
>> @@ -46,7 +46,7 @@ struct cea_exception_stacks {
>>    * The exception stack ordering in [cea_]exception_stacks
>>    */
>>   enum exception_stack_ordering {
>> -	ESTACK_DF,
>> +	ESTACK_DF = 0,
>>   	ESTACK_NMI,
>>   	ESTACK_DB,
>>   	ESTACK_MCE,
> 
> Is this really required? I thought the first enum was always 0? Is this
> just trying to ensure that ESTACKS_MEMBERS() defines a matching number
> of N_EXCEPTION_STACKS stacks?
> 
> If that's the case, shouldn't this be represented with a BUILD_BUG_ON()?

Will do BUILD_BUG_ON().

> 
>> @@ -58,18 +58,15 @@ enum exception_stack_ordering {
>>   #define CEA_ESTACK_SIZE(st)					\
>>   	sizeof(((struct cea_exception_stacks *)0)->st## _stack)
>>   
>> -#define CEA_ESTACK_BOT(ceastp, st)				\
>> -	((unsigned long)&(ceastp)->st## _stack)
>> -
>> -#define CEA_ESTACK_TOP(ceastp, st)				\
>> -	(CEA_ESTACK_BOT(ceastp, st) + CEA_ESTACK_SIZE(st))
>> -
>>   #define CEA_ESTACK_OFFS(st)					\
>>   	offsetof(struct cea_exception_stacks, st## _stack)
>>   
>>   #define CEA_ESTACK_PAGES					\
>>   	(sizeof(struct cea_exception_stacks) / PAGE_SIZE)
>>   
>> +extern unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack);
>> +extern unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack);
>> +
>>   #endif
>>   
>>   #ifdef CONFIG_X86_32
>> @@ -144,10 +141,4 @@ static __always_inline struct entry_stack *cpu_entry_stack(int cpu)
>>   	return &get_cpu_entry_area(cpu)->entry_stack_page.stack;
>>   }
>>   
>> -#define __this_cpu_ist_top_va(name)					\
>> -	CEA_ESTACK_TOP(__this_cpu_read(cea_exception_stacks), name)
>> -
>> -#define __this_cpu_ist_bottom_va(name)					\
>> -	CEA_ESTACK_BOT(__this_cpu_read(cea_exception_stacks), name)
>> -
>>   #endif
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index 34a054181c4d..cb14919f92da 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -2307,12 +2307,12 @@ static inline void setup_getcpu(int cpu)
>>   static inline void tss_setup_ist(struct tss_struct *tss)
>>   {
>>   	/* Set up the per-CPU TSS IST stacks */
>> -	tss->x86_tss.ist[IST_INDEX_DF] = __this_cpu_ist_top_va(DF);
>> -	tss->x86_tss.ist[IST_INDEX_NMI] = __this_cpu_ist_top_va(NMI);
>> -	tss->x86_tss.ist[IST_INDEX_DB] = __this_cpu_ist_top_va(DB);
>> -	tss->x86_tss.ist[IST_INDEX_MCE] = __this_cpu_ist_top_va(MCE);
>> +	tss->x86_tss.ist[IST_INDEX_DF] = __this_cpu_ist_top_va(ESTACK_DF);
>> +	tss->x86_tss.ist[IST_INDEX_NMI] = __this_cpu_ist_top_va(ESTACK_NMI);
>> +	tss->x86_tss.ist[IST_INDEX_DB] = __this_cpu_ist_top_va(ESTACK_DB);
>> +	tss->x86_tss.ist[IST_INDEX_MCE] = __this_cpu_ist_top_va(ESTACK_MCE);
> 
> If you respin this, please vertically align these.

NP.

> 
>> +/*
>> + * FRED introduced new fields in the host-state area of the VMCS for
>> + * stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
>> + * corresponding to per CPU stacks for #DB, NMI and #DF.  KVM must
>> + * populate these each time a vCPU is loaded onto a CPU.
>> + *
>> + * Called from entry code, so must be noinstr.
>> + */
>> +noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
>> +{
>> +	unsigned long base = (unsigned long)&(__this_cpu_read(cea_exception_stacks)->DF_stack);
>> +	return base + EXCEPTION_STKSZ + stack * (EXCEPTION_STKSZ + PAGE_SIZE);
>> +}
>> +EXPORT_SYMBOL(__this_cpu_ist_top_va);
>> +
>> +noinstr unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack)
>> +{
>> +	unsigned long base = (unsigned long)&(__this_cpu_read(cea_exception_stacks)->DF_stack);
>> +	return base + stack * (EXCEPTION_STKSZ + PAGE_SIZE);
>> +}
> 
> These are basically treating 'struct exception_stacks' like an array.
> There's no type safety or anything here. It's just an open-coded array
> access.
> 
> Also, starting with ->DF_stack is a bit goofy looking. It's not obvious
> (or enforced) that it is stack #0 or at the beginning of the structure.
> 
> Shouldn't we be _trying_ to make this look like:
> 
> 	struct cea_exception_stacks *s;
> 	s = __this_cpu_read(cea_exception_stacks);
> 
> 	return &s[stack_nr].stack;
> 
> ?
> 
> Where 'cea_exception_stacks' is an actual array:
> 
> 	struct cea_exception_stacks[N_EXCEPTION_STACKS];
> 
> which might need to be embedded in a larger structure to get the
> 'IST_top_guard' without wasting allocating space for an extra full stack.
> 

Good suggestion!

Thanks!
     Xin

