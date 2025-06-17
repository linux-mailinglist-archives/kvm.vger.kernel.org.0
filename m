Return-Path: <kvm+bounces-49769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAFB3ADDF22
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 00:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76EC917CFFA
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 22:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CDB292B4E;
	Tue, 17 Jun 2025 22:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="oxD2FvHd"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7672F530A;
	Tue, 17 Jun 2025 22:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750200582; cv=none; b=mANhAP/0tDo4dS7xymquDBm+ZtBys4rERltX/UPqrIjQIzgBiAuRpp0aybnMHfaesSGZrlEP2dQwZzdmYEjWG82Di2QdYdQkWQVEn1KbO6MG6dEZ/H5VFV1kA7Pick7XHvLpcm4SIxhe4hW9kEH/BATccHqSnAzds4zhif1CtAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750200582; c=relaxed/simple;
	bh=+418RPPEpMl6R1nIeDIqqt6kT5AmLgaQLrpG11zA7DQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aa9X4jPssHq10m6CQq/kKsRftopf5f9wFDeu9KMQfXfKD4csR55yXbQVAzCetQB2pn7XgUeH/mXAp60n5HH04i6/yeB0q43ASNPH50CLFPlXnTOiMyM8i1SxOyCEH+LRMxQ2/pJ2ri2MreNtU+trs2HIO29k4YUUpWcET6ty5n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=oxD2FvHd; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55HMn0Ih1302619
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 17 Jun 2025 15:49:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55HMn0Ih1302619
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750200542;
	bh=EIJzrZlslsqFwEcgd7KKjC9LQLcizWIApfmEny/9WT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oxD2FvHdmWeI5aPqZ8d2wwrKnhwJdagX4vCZgrdG/Giwz/VgCfSBibb/AJr0DlsGQ
	 aDG0B9mprdY6fzoqiprxpq5QF/Ks/lu4koyKaQgEU4aaI6zQMAPZbQE3tSjuv/ie/o
	 rnLmVet5SCNbrxaynepHxZofaaH8YKfTYhCJah4w+pWcJybNbRWw9WnEOeOIJWV4Ye
	 qImy8PFoYDwKK8cllAiWriybeLU/V5WaZJWrE4RAdYmea4uV8hiwcC5+X/rwfgqu7E
	 91+Jgb0lDEHmMqHyfPXe2Mrqt5JJdN/CmN2aC0OMk4n6mnFvG2KIb1BJSA+hCSWoDr
	 XpMppk6nMekQw==
Message-ID: <3e4c2e32-3c12-47a6-bf84-79690f78e1bf@zytor.com>
Date: Tue, 17 Jun 2025 15:49:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
References: <20250617073234.1020644-1-xin@zytor.com>
 <20250617073234.1020644-2-xin@zytor.com>
 <20250617090329.GO1613376@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250617090329.GO1613376@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/2025 2:03 AM, Peter Zijlstra wrote:
> On Tue, Jun 17, 2025 at 12:32:33AM -0700, Xin Li (Intel) wrote:
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index 8feb8fd2957a..3bd7c9ac7576 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -2243,20 +2243,17 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>>   #endif
>>   #endif
>>   
>> -/*
>> - * Clear all 6 debug registers:
>> - */
>> -static void clear_all_debug_regs(void)
>> +static void initialize_debug_regs(void)
>>   {
>>   	int i;
>>   
>> -	for (i = 0; i < 8; i++) {
>> -		/* Ignore db4, db5 */
>> -		if ((i == 4) || (i == 5))
>> -			continue;
>> +	/* Control register first */
>> +	set_debugreg(0, 7);
>> +	set_debugreg(DR6_RESERVED, 6);
>>   
>> +	/* Ignore db4, db5 */
>> +	for (i = 0; i < 4; i++)
>>   		set_debugreg(0, i);
>> -	}
>>   }
>>   
>>   #ifdef CONFIG_KGDB
> 
> Maybe like so?
> 
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -2206,15 +2206,14 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard)
>   
>   static void initialize_debug_regs(void)
>   {
> -	int i;
> -
> -	/* Control register first */
> +	/* Control register first -- to make sure everything is disabled. */
>   	set_debugreg(0, 7);
>   	set_debugreg(DR6_RESERVED, 6);
> -
> -	/* Ignore db4, db5 */
> -	for (i = 0; i < 4; i++)
> -		set_debugreg(0, i);
> +	/* dr5 and dr4 don't exist */
> +	set_debugreg(0, 3);
> +	set_debugreg(0, 2);
> +	set_debugreg(0, 1);
> +	set_debugreg(0, 0);
>   }
>   
>   #ifdef CONFIG_KGDB

Yeah, I think it makes sense to make the change.

Thanks!
     Xin

