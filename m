Return-Path: <kvm+bounces-29969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0EFC9B511D
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 18:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64CE51F221A7
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 17:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA0091D356C;
	Tue, 29 Oct 2024 17:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="prWlFthl"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FAE2107;
	Tue, 29 Oct 2024 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730223651; cv=none; b=tX3/AWfhI9f2ElciqjNOpZX+wRLSMVfaDuaQhMFfKmfJYB8wvYcXXl7Tv5PuN1xGPYIrnJN480J6XxhJ55U5AjtAgLXqbMeobLeuiipgdYPS33jikJpmZLkAJtlda0BCy+NjBIUBSRMwKyGeajUhinyCh7NjfQT1OCXb8HkYrYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730223651; c=relaxed/simple;
	bh=nOaHu/IehEL6OQiLLzh5zQdYlqOfd77xgDIYOg4DnAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uiVu1IeFlnaGi2enyIU/OKZbZzrYravHgANnWMP7wUqRA0g54cZ0jdnTi1zmPSEtKlTMU3gj95mjMHqJWLhqWy2M1OT2GFg0FOWu7pwPzgzvBa4wIgI/kBOVaj+3KyURikYp6iOnY+e8bQM70MDdDOELd311ndls6DFrRro7LS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=prWlFthl; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.205] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49THe3A6451693
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 29 Oct 2024 10:40:03 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49THe3A6451693
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024101701; t=1730223604;
	bh=l0/F6+jn/7mFUkBUVW0dl3LGmpVjN1lVeIa3tibqzhE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=prWlFthlScSlGElGCx1KOSTF9/+bR6IBrIn8zROURZ5GpR4+/Zk6ti2sYv2aB51+q
	 HHVlYD85bN5u0dbpR9sNp/BA3UPvMJvN3/SHrVSZo8GM6HgdU7V92S5C04ByVEFS4a
	 BX76o/UpzVfQPaLSFvo5M2l8NnsMtRt7ZhtLnPX2TbZrGJdoqqL+JSp9S1ZVk5r3P2
	 /L1x8K52qb0lsshahMxfSv1dgjPVZx0/gSSVzd+rDgG/S68izOfhu+FZ+b34obl1mV
	 dEOG8vkad6Q0JdH7jyNB3jFeZhw745r8bwrYm1G7qOHUjtJZuzqryj6CA4I1lyoEoQ
	 OFq5kEREnpMcw==
Message-ID: <538c630c-0de3-4807-9e9f-6af02dd18d0e@zytor.com>
Date: Tue, 29 Oct 2024 10:40:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/27] KVM: nVMX: Add FRED VMCS fields
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-26-xin@zytor.com> <Zxn6Vc/2vvJ3VHCb@intel.com>
 <f9bb0740-21ec-482d-92fb-7fed3fef7d36@zytor.com> <Zx9Ua0dTQXwC9lzS@intel.com>
 <Zx_XmJnMCZjb7VBS@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <Zx_XmJnMCZjb7VBS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/2024 11:27 AM, Sean Christopherson wrote:
> On Mon, Oct 28, 2024, Chao Gao wrote:
>> On Fri, Oct 25, 2024 at 12:25:45AM -0700, Xin Li wrote:
>>>>> static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
>>>>> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>>>>> index 2c296b6abb8c..5272f617fcef 100644
>>>>> --- a/arch/x86/kvm/vmx/nested.h
>>>>> +++ b/arch/x86/kvm/vmx/nested.h
>>>>> @@ -251,6 +251,14 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
>>>>> 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
>>>>> }
>>>>>
>>>>> +static inline bool nested_cpu_has_fred(struct vmcs12 *vmcs12)
>>>>> +{
>>>>> +	return vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED &&
>>>>> +	       vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS &&
>>>>> +	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_SAVE_IA32_FRED &&
>>>>> +	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED;
>>>>
>>>> Is it a requirement in the SDM that the VMM should enable all FRED controls or
>>>> none? If not, the VMM is allowed to enable only one or two of them. This means
>>>> KVM would need to emulate FRED controls for the L1 VMM as three separate
>>>> features.
>>>
>>> The SDM doesn't say that.  But FRED states are used during and
>>> immediately after VM entry and exit, I don't see a good reason for a VMM
>>> to enable only one or two of the 3 save/load configs.
> 
> Not KVM's concern.
> 
>>> Say if VM_ENTRY_LOAD_IA32_FRED is not set, it means a VMM needs to
>>> switch to guest FRED states before it does a VM entry, which is
>>> absolutely a big mess.
> 
> Again, not KVM's concern.
> 
>> If the VMM doesn't enable FRED, it's fine to load guest FRED states before VM
>> entry, right?
> 
> Yep.  Or if L1 is simply broken and elects to manually load FRED state before
> VM-Enter instead of using VM_ENTRY_LOAD_IA32_FRED, then any badness that happens
> is 100% L1's problem to deal with.  KVM's responsiblity is to emulate the
> architectural behavior, what L1 may or may not do is irrelevant.

Damn, obviously I COMPLETELY missed this point.

Let me think how should KVM as L0 handle it.

> 
>> The key is to emulate hardware behavior accurately without making assumptions
>> about guests.
> 
> +1000
> 
>> If some combinations of controls cannot be emulated properly, KVM
>> should report internal errors at some point.

Yeah, only if CANNOT.  Otherwise a broken VMM will behave differently on
real hardware and KVM, even if it crashes in a way which it never knows
about, right?

