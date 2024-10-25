Return-Path: <kvm+bounces-29691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AAC9AFAEF
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 09:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2814B280DBB
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 07:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B91C1B6D05;
	Fri, 25 Oct 2024 07:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="dtjjIfU0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A0F166F1B;
	Fri, 25 Oct 2024 07:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729841210; cv=none; b=oCP2FIpa5+zPtLwGGFQBZtH/dvptpmtsRrdt2eBGT1bkpENOecdBm0pKw+J7JUzGmk0DWZ42M6OOvYo5Lvg3XCDyFCsQDfrH/A7laIrigfj5200kwWRPY0M3vw9pCnmqhRE2TG1k0uBAvdmqxiNoGBcK0lR6iAGYYFVT3DiW9cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729841210; c=relaxed/simple;
	bh=mfuwS2CBw28SWOw71UxCe0uVYFNhYMJ9pb0TPJRGl78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=av+hrmLbeEDev2QnJLRle7smQnITCs5V/H1hXZHjWyHIja/G8WpWCUE9sIHjpFc3vD8BrDGC+N2kXFFGwAxbAYykgOWUDRMBTTMRPM48FgcXJS8KUXmjRoiP4BevOapwd37Ll1r/pSgabhJJGCoSOMbpTQvtksPEr+2NKt586l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=dtjjIfU0; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.205] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49P7Pk5b2106563
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 25 Oct 2024 00:25:47 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49P7Pk5b2106563
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024101701; t=1729841150;
	bh=NMQEGMNoS1kjt2ZrIrRF8/paM/PCBwmYLnmq+XRI1GI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dtjjIfU0jwte8iB+16b3u9aCi45gWHmC3k277R/avs9h9Zg0QkQ/8xjtzAe0saMP7
	 vKo69yEK9wm+Xq73m4AskoAss7DFNTl3muUjEqkuFiNe82oh/3q9gilYjsAciLIOQQ
	 R0J3o4azFBaOmXLyPLOBVT6KoSol+20KO9IlcJop41L+zvBEUM3DDOuf3vEnyhRj9+
	 OPxUwwHSauda8lVW1jO7cZHtY8j32IMjvM6KkV7J1PJ58kObBoi7qeBJQ3yuD7uaAX
	 CvciviQ4ztHKtRrarLRAryyYomrrfZMrthuHWPI/VR1QNIYKwg+ylAY/oz63BJcvOW
	 DCi9QTs2SFD9g==
Message-ID: <f9bb0740-21ec-482d-92fb-7fed3fef7d36@zytor.com>
Date: Fri, 25 Oct 2024 00:25:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/27] KVM: nVMX: Add FRED VMCS fields
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-26-xin@zytor.com> <Zxn6Vc/2vvJ3VHCb@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <Zxn6Vc/2vvJ3VHCb@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2024 12:42 AM, Chao Gao wrote:
>> @@ -7197,6 +7250,9 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
>> 	msrs->basic |= VMX_BASIC_TRUE_CTLS;
>> 	if (cpu_has_vmx_basic_inout())
>> 		msrs->basic |= VMX_BASIC_INOUT;
>> +
>> +	if (cpu_has_vmx_fred())
>> +		msrs->basic |= VMX_BASIC_NESTED_EXCEPTION;
> 
> why not advertising VMX_BASIC_NESTED_EXCEPTION if the CPU supports it? just like
> VMX_BASIC_INOUT right above.

Because VMX nested-exception support only works with FRED.

We could pass host MSR_IA32_VMX_BASIC.VMX_BASIC_NESTED_EXCEPTION to
nested, but it's meaningless w/o VMX FRED.

> 
> 
>> }
>>
>> static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
>> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>> index 2c296b6abb8c..5272f617fcef 100644
>> --- a/arch/x86/kvm/vmx/nested.h
>> +++ b/arch/x86/kvm/vmx/nested.h
>> @@ -251,6 +251,14 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
>> 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
>> }
>>
>> +static inline bool nested_cpu_has_fred(struct vmcs12 *vmcs12)
>> +{
>> +	return vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED &&
>> +	       vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS &&
>> +	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_SAVE_IA32_FRED &&
>> +	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED;
> 
> Is it a requirement in the SDM that the VMM should enable all FRED controls or
> none? If not, the VMM is allowed to enable only one or two of them. This means
> KVM would need to emulate FRED controls for the L1 VMM as three separate
> features.

The SDM doesn't say that.  But FRED states are used during and
immediately after VM entry and exit, I don't see a good reason for a VMM
to enable only one or two of the 3 save/load configs.

Say if VM_ENTRY_LOAD_IA32_FRED is not set, it means a VMM needs to
switch to guest FRED states before it does a VM entry, which is
absolutely a big mess.

TBH I'm not sure this is the question you have in mind.

