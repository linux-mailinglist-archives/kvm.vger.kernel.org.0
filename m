Return-Path: <kvm+bounces-55024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 153F4B2CB7E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26CA87AFBE3
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C1C30DEDB;
	Tue, 19 Aug 2025 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="gcjA76+M"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0812550CA;
	Tue, 19 Aug 2025 17:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755626054; cv=none; b=gbSb7nV44QpF++nuEns1740lTddW34oPh8zQmgeWODRRTiCjDngxn0Y//NncKaPtzJg1WwcdRcqZELdvhCxFSpsK/E1GUyuVp9sXwFO3U1r3pTUcr7VDuQz7CGlLXGNF3tTEZ8UxAivKC6avVT5fpmOsSrvNfUjopGnOpBkQk6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755626054; c=relaxed/simple;
	bh=4J1bjXbT5ammo3TwOOtd1UIg3jLW9cn6POgEJUnjFXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sN3aNA3X/G4HrS+s6LOLYvnKPVGb/CocGLc8jTPqGkO7hW2gqdkoxtjq93//V8YPLKAV9S8PX8IskyrBxKPjN6grsbjp/wbq7JcEXmcdM6WYSaZBpeRNKRw6/UIVpAdgKw9kampPSGuGpR8YCQDfU+xTd4PRwBFJNpEdTti0PJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=gcjA76+M; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57JHrS5M2742817
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 19 Aug 2025 10:53:31 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57JHrS5M2742817
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755626017;
	bh=aB04BRRbyT2lWMhMsx+xff17/ihdjQGqjAFAwjLk104=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gcjA76+M+R9oatXRnLMbvZFA80vUOj4zPOI3zMe4SJnkju1ez8+dqmz/x1iS0t5RR
	 /GEnZM3rrJ3uAii4CNI/BGeI2KQFOlr6QzaZ6V+P897dY9yeL0lmLyx3fGGIPF0If8
	 SZWa6WQDS1MHKzWr7OP1J6a03rbNBwWQ9oIOMBLBj/mw4wo5Zd8JLRn9Zsa87gbmXc
	 cZ756Pq/StiXBnphJQWAXJtjnSBd5wZWGNIyIoz4xpOKD1h+o4ztdrz25SjusagiS1
	 kURzc03y/itjN4u2opykUPKUgkUcT6AFnEe8JCBHtDTpn60asUpK7eBmnn8GsX6U47
	 CDHYeOuHLKKMQ==
Message-ID: <915d0ca8-05c5-42c1-90fe-b214904b23bc@zytor.com>
Date: Tue, 19 Aug 2025 10:53:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 15/24] KVM: VMX: Emulate read and write to CET MSRs
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Mathias Krause <minipli@grsecurity.net>,
        John Allen <john.allen@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-16-chao.gao@intel.com> <aKShs0btGwLtYlVc@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aKShs0btGwLtYlVc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/2025 9:09 AM, Sean Christopherson wrote:
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
>> +			return KVM_MSR_RET_UNSUPPORTED;
>> +		if (is_noncanonical_msr_address(data, vcpu))
> This emulation is wrong (in no small part because the architecture sucks).  From
> the SDM:
> 
>    If the processor does not support Intel 64 architecture, these fields have only
>    32 bits; bits 63:32 of the MSRs are reserved.
> 
>    On processors that support Intel 64 architecture this value cannot represent a
>    non-canonical address.
> 
>    In protected mode, only 31:0 are loaded.
> 
> That means KVM needs to drop bits 63:32 if the vCPU doesn't have LM or if the vCPU
> isn't in 64-bit mode.  The last one is especially frustrating, because software
> can still get a 64-bit value into the MSRs while running in protected, e.g. by
> switching to 64-bit mode, doing WRMSRs, then switching back to 32-bit mode.
> 
> But, there's probably no point in actually trying to correctly emulate/virtualize
> the Protected Mode behavior, because the MSRs can be written via XRSTOR, and to
> close that hole KVM would need to trap-and-emulate XRSTOR.  No thanks.
> 
> Unless someone has a better idea, I'm inclined to take an erratum for this, i.e.
> just sweep it under the rug.

Since WRMSR (WRMSRNS) and XRSTORS are the two instructions that write to
MSRs in CPL0, Why KVM doesn't use the XSS-exiting bitmap?



