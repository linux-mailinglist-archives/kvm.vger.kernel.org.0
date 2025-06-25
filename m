Return-Path: <kvm+bounces-50740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB81AE8B9D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 19:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B41181885F09
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C172D23B8;
	Wed, 25 Jun 2025 17:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="S6U3o4De"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628CF1459FA;
	Wed, 25 Jun 2025 17:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750873128; cv=none; b=h/c7iWjigzCmA9/ximfuwckLLx9ABg30DNFlhS7f0PI56Bnbu+Wo9WwWfFYduJcFNQgWpiY7rAYUYQTe2ZlHOUItkDC8BCrIBwaOaDmhoObkvtr/NgstEG6LZB+JStPbf4bB4MwJPEjI0NDP8sHzYep2Txlgsbzi0wmsNCTdAgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750873128; c=relaxed/simple;
	bh=w3u6IO0pbfeGjgbOpb/8vxunTnTNqJNmxIiEocEKWkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nREWHd4kfCoP4FrptQ+igtEH407mr2HrHJHsADYzxUF8spwV6qfGpYHeObSTB3Vy8uuf2xZ7uGIWONSMcBb563kK9EE6OkBQIJJ+PyYvGMD+RHsQkQ7K2XxSuRWupmejh4m4kqNWakOPedNGvTChWLH8UVYXT1kPi6NywMAq3bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=S6U3o4De; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55PHcE701870028
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 25 Jun 2025 10:38:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55PHcE701870028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750873096;
	bh=t2dKVmN1aRJoALT/qUHCBcvFg5zdwPI3fklJD/xTsYg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S6U3o4De/qG8KchwQqrJ2F0MVQB7XD2VZ3tne4NYrKKCiOTvReBUnO5AriyiM6sPp
	 6lbtoO0SUfmkTD4u8SF2zUySfir1s7L/07zFLU59/xeYUFGMRg2OGmg8lXYVMWNIOL
	 JDBcA+NlKIv9vi+9joKH4ilcv1v3Ue5NRS0XzI1h+bAg0Ifr21hrcYUK3/6nQhW5wD
	 mf035TNGWwQKJ3e66c5VSzf8eb4e7pSDN8dymcbHuZ1HWcoQCk62dHRdi8yt6n/Ya5
	 o7zY3ZrLeW/9D9FoBkaPzkiGAuPOB4zOUzDXI57YQBeXU0yzstIsW/jhWIN838my37
	 Uh8GcPXrNk0bA==
Message-ID: <4459df49-7c02-4fa8-ae69-279d2b64fb2d@zytor.com>
Date: Wed, 25 Jun 2025 10:38:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/19] KVM: VMX: Dump FRED context in dump_vmcs()
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, andrew.cooper3@citrix.com,
        luto@kernel.org, peterz@infradead.org, chao.gao@intel.com,
        xin3.li@intel.com
References: <20250328171205.2029296-1-xin@zytor.com>
 <20250328171205.2029296-15-xin@zytor.com> <aFrTAT-xTLmlwO5V@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aFrTAT-xTLmlwO5V@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/2025 9:32 AM, Sean Christopherson wrote:
>> @@ -6519,6 +6521,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>>   	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
>>   	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
>>   	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
>> +	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_FRED)
>> +		pr_err("FRED guest: config=0x%016llx, stack_levels=0x%016llx\n"
>> +		       "RSP0=0x%016llx, RSP1=0x%016llx\n"
>> +		       "RSP2=0x%016llx, RSP3=0x%016llx\n",
>> +		       vmcs_read64(GUEST_IA32_FRED_CONFIG),
>> +		       vmcs_read64(GUEST_IA32_FRED_STKLVLS),
>> +		       __rdmsr(MSR_IA32_FRED_RSP0),
> 
> There is no guarantee the vCPU's FRED_RSP is loaded in hardware at this point.
> I think you need to use vmx_read_guest_fred_rsp0().

Good catch.

> 
>> +		       vmcs_read64(GUEST_IA32_FRED_RSP1),
>> +		       vmcs_read64(GUEST_IA32_FRED_RSP2),
>> +		       vmcs_read64(GUEST_IA32_FRED_RSP3));
>>   	efer_slot = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest, MSR_EFER);
>>   	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER)
>>   		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
>> @@ -6566,6 +6578,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>>   	       vmcs_readl(HOST_TR_BASE));
>>   	pr_err("GDTBase=%016lx IDTBase=%016lx\n",
>>   	       vmcs_readl(HOST_GDTR_BASE), vmcs_readl(HOST_IDTR_BASE));
>> +	if (vmexit_ctl & SECONDARY_VM_EXIT_LOAD_IA32_FRED)
>> +		pr_err("FRED host: config=0x%016llx, stack_levels=0x%016llx\n"
>> +		       "RSP0=0x%016lx, RSP1=0x%016llx\n"
>> +		       "RSP2=0x%016llx, RSP3=0x%016llx\n",
>> +		       vmcs_read64(HOST_IA32_FRED_CONFIG),
>> +		       vmcs_read64(HOST_IA32_FRED_STKLVLS),
>> +		       (unsigned long)task_stack_page(current) + THREAD_SIZE,
> 
> Maybe add a helper in arch/x86/include/asm/fred.h to generate the desired RSP0?
> Not sure it's worth doing that just for this code.

It's not just one usage.  I checked with:

     git grep -w task_stack_page | grep THREAD_SIZE | wc -l

And get 25.

However it is used in other architectures, so I'll work it in parallel.
I.e., likely I won't change it in the next iteration.

Thanks!
     Xin



