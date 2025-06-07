Return-Path: <kvm+bounces-48695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93ED7AD0ABE
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 02:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5A291896165
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 00:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CEC13A26D;
	Sat,  7 Jun 2025 00:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="b+RXMVJh"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B34F1367;
	Sat,  7 Jun 2025 00:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749257937; cv=none; b=CD4UBGHakonRcmDHadCErmL+DGTFGJ3fwaVcHXM4i9O5tzBsJDBZEe25L/mB/2LUNsers/+tlAlYe5yxc1F7l//z7MFrdXuWcq6G7/EqsvJTP6sQ6K5+UQB7EHpTgitPcBH9OWc8nnklA4DCfP5xPlIxJ7AbAN3n0MmfZNYPWso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749257937; c=relaxed/simple;
	bh=gbMdOOaPfp/Km6obIuvPLgSKGFsNBi+m+HlAcVIMPyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E6d2Ro82RHZdzPyhJ1T/8tD7hI7gOZ3Dr3dZ7DmBPXOJBtqKRJgNZ0s17NWcAsBRD5OPQOnOlNptMGWg1EJLqyE0cwo6xYYDGeawrOCDxKNQNaH9lG/s1T+iL57oLDlN5Z46d8VvRXBNWJZ/bJ11ix6t+0BpaIm3ZRCNUSIXojM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=b+RXMVJh; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [IPV6:2601:646:8081:9482:7437:c350:20af:75f1] ([IPv6:2601:646:8081:9482:7437:c350:20af:75f1])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5570w7L71126981
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 6 Jun 2025 17:58:08 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5570w7L71126981
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749257890;
	bh=4v2v2mCM9JnVjwUKDEQ0CdYtzrh9MjRpJTRKPi/K33c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b+RXMVJh71w0hethEOc1Ld39rrQGD819p8LxfGzk5kACs8T9Z9sy8Q85Jpg5YXC8U
	 veR7tfFvxWqo2sRLC38rLOR439bK5tApqkfL6VQOi8MpyZS/JgZlODUJugg3/4afKy
	 2WqbMMiqwHzkLctOOqxa34OVK1Ochk5B9z3+nQj12uweK6cfcyoiR+o8VFMOaEYzzh
	 G9L5PxjCWh8ScjuAKW/DXhGZONncyUupbN2V/SlCxvPsJUWcUemTxflIWpY+mfseNK
	 oCwV5nlxVCAavBmJcHGQ3dHKG5ZWtn6D9Q1d1n8sKJ0YEunoayeW373sOuWGw0eiTR
	 6Bl33vc5AmuqA==
Message-ID: <4a66adfa-fc10-4668-9986-55f6cf231988@zytor.com>
Date: Fri, 6 Jun 2025 17:58:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: X86: Raise #GP when clearing CR0_PG in 64 bit mode
To: Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
References: <20211207095230.53437-1-jiangshanlai@gmail.com>
 <51bb6e75-4f0a-e544-d2e4-ff23c5aa2f49@redhat.com>
Content-Language: en-US
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <51bb6e75-4f0a-e544-d2e4-ff23c5aa2f49@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2021-12-09 09:55, Paolo Bonzini wrote:
> On 12/7/21 10:52, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> In the SDM:
>> If the logical processor is in 64-bit mode or if CR4.PCIDE = 1, an
>> attempt to clear CR0.PG causes a general-protection exception (#GP).
>> Software should transition to compatibility mode and clear CR4.PCIDE
>> before attempting to disable paging.
>>
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/x86.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 00f5b2b82909..78c40ac3b197 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -906,7 +906,8 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned 
>> long cr0)
>>           !load_pdptrs(vcpu, kvm_read_cr3(vcpu)))
>>           return 1;
>> -    if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
>> +    if (!(cr0 & X86_CR0_PG) &&
>> +        (is_64_bit_mode(vcpu) || kvm_read_cr4_bits(vcpu, 
>> X86_CR4_PCIDE)))
>>           return 1;
>>       static_call(kvm_x86_set_cr0)(vcpu, cr0);
>>
> 
> Queued, thanks.
> 

Have you actually checked to see what real CPUs do in this case?

	-hpa


