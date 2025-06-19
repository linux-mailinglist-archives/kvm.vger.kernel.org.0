Return-Path: <kvm+bounces-49998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A87EAE0FB3
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 00:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63782189C1B8
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 22:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A76928C5A1;
	Thu, 19 Jun 2025 22:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="nOeYNJmM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06D030E83B;
	Thu, 19 Jun 2025 22:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750373199; cv=none; b=FvwLDB50BM0r5vYUVQtCI5eS0pjk7MnvcmY7y218nKDNBQGzbJoDoflo57kGp6CUuShKMy9pZcfbe2TYkmXdzKm9Qp/Dq+zVivV/jAj/5lRXq/xJBQqa0A2qCEvrRv8PaMPnLaOBKAr/1znus9D7fTR5bT0EE4jr7ww1NRkW4P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750373199; c=relaxed/simple;
	bh=DnAJf2SEsI4warxPu/9d4W9YSrx57BgXcltfx7/axvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDCEE3/JnNr17s+B+j0+ZlyuFCJxDvBrqooahO3+b9qdgxN3GtwqKyz3NL3ea5LlZ60OQSEpB40k8QFN+tGAjk7Z95CQjN7lipHBU/gWyRCcRF3llU1gFYuZMzjvfJ73WBf92oIvklJdbiogYOIo7KbHeYR+jMme5nb6cMLrvTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=nOeYNJmM; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55JMjM0v2225623
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 19 Jun 2025 15:45:22 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55JMjM0v2225623
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750373125;
	bh=6OyJJNePWaFs0bpkh+aX3fWSzJHKYLwaEq7c9zTilGQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nOeYNJmMAVmOFdGTEFk4zY2iLDZQYlsAA5EPTTWX++rmrHYB5nEZe4btbYs0r3NPB
	 7kI1/tqe9TrjzZIATZKWcGAUL5LxWWRDySGhN+GYBtzL0c4+lmEYNBnmby1dhliLM/
	 5ADHKd/2B6EqDZGCnBY+uj5u8ISIMrx1efEZQg6IaHty0c6t4NqEzibA7e3O2iPAl0
	 H8HRbMa3VQ034Y4me4XPZexo9Fpm6fd5o2/WysZZ41goa9LOElJX4ZMGgF/mS8R+p6
	 yxr4evD1KFCLIZEuTgygC1b9L1g7CNSgVi25gCuwTQWp+MfBFrc8f+NiWG20tJyO1Y
	 Ral4tKT3snW5A==
Message-ID: <36374100-0587-47f1-9319-6333f6dfe4db@zytor.com>
Date: Thu, 19 Jun 2025 15:45:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
To: Sohil Mehta <sohil.mehta@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jacob Pan <jacob.pan@linux.microsoft.com>,
        Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-3-sohil.mehta@intel.com>
 <7525af7f-a817-47d5-91f7-d7702380c85f@zytor.com>
 <3281866f-2593-464d-a77e-5893b5e7014f@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <3281866f-2593-464d-a77e-5893b5e7014f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/19/2025 3:15 PM, Sohil Mehta wrote:
> On 6/18/2025 10:02 PM, Xin Li wrote:
>>> diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
>>> index 29c5c32c16c3..1c9c6e036233 100644
>>> --- a/arch/x86/entry/entry_64_fred.S
>>> +++ b/arch/x86/entry/entry_64_fred.S
>>> @@ -93,7 +93,7 @@ SYM_FUNC_START(asm_fred_entry_from_kvm)
>>>    	 * +--------+-----------------+
>>>    	 */
>>>    	push $0				/* Reserved, must be 0 */
>>> -	push $0				/* Event data, 0 for IRQ/NMI */
>>> +	push %rsi			/* Event data for NMI */
>>
>> Maybe a bit more accurate?
>>
> 
> Actually, I am wondering if it might be better to make it less precise
> than it is right now. How about
> 
> /* Event data passed in by the caller */
> 
> The problem with having precise comments for a generic implementation is
> that the caller might get updated, but we would forget to update this
> comment since nothing in this function needs to change.

No strong preference, I'm okay if you take this approach.

> 
>> /* Event data, NMI-source bitmap only so far */
>>
>>>    	push %rdi			/* fred_ss handed in by the caller */
>>>    	push %rbp
>>>    	pushf
> 
> ...
> 
>>>    /* Must be called from noinstr code, thus __always_inline */
>>> -static __always_inline void fred_nmi_from_kvm(void)
>>> +static __always_inline void fred_nmi_from_kvm(unsigned long edata)
>>>    {
>>>    	struct fred_ss ss = {
>>>    		.ss	= __KERNEL_DS,
>>> @@ -83,7 +83,7 @@ static __always_inline void fred_nmi_from_kvm(void)
>>>    		.lm	= 1,
>>>    	};
>>>    
>>> -	asm_fred_entry_from_kvm(ss);
>>> +	asm_fred_entry_from_kvm(ss, edata);
>>>    }
>>>    
>>>    static inline void fred_irq_from_kvm(unsigned int vector)
>>> @@ -95,7 +95,8 @@ static inline void fred_irq_from_kvm(unsigned int vector)
>>>    		.lm	= 1,
>>>    	};
>>>    
>>> -	asm_fred_entry_from_kvm(ss);
>>> +	/* Event data is always zero for IRQ */
>>
>> /* Event data not used for IRQ thus 0 */
> 
> Event data "not used" might imply that the architecture provides
> something, but the kernel is choosing to not use it. There is no event
> data for IRQ, right?
> 
> I want to say that the event data for IRQ has to be zero until the
> architecture changes — Similar to the /* Reserved, must be 0 */ comment
> in asm_fred_entry_from_kvm().
> 

FRED spec says:

For any other event, the event data are not currently defined and will 
be zero until they are.

So "Event data not defined for IRQ thus 0."

