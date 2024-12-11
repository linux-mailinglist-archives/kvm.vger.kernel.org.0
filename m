Return-Path: <kvm+bounces-33492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8419ED3DE
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 18:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18B372835B2
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 17:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46C81FF1B9;
	Wed, 11 Dec 2024 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="Nq4tv77V"
X-Original-To: kvm@vger.kernel.org
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF741D6DA4;
	Wed, 11 Dec 2024 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733938995; cv=none; b=ZB0f26VITb2JUdxnv1LoCPJVFybcFzh8fITT1MlHu04ECasNpwCayM6JgFkkS8uM+9A7+r7RPtgkhACcuf6Yhmu8KwlcJ6Sjvcghp+Pn799G6mjHjOppeNL4vpkdlxi4LS0eKMKYwdWp2wI8IxihbNLngfWan7etMUBl9Lel2f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733938995; c=relaxed/simple;
	bh=49SKRixadurapl3Gf/n3BAdrM2d4z6xw6c6GK+sdzfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bd7V1aOe+2NaxMGlSaXdDzqiMnZSZzXvMmtBOj9w6OcjE2wjU/v7YpLZWOFNnMLYzxhAakMAABiOoIuoa9DmbI0EZEtl8zPJpp3ZOQRe/DfBkr6/4c+YeehTBZBFKfgYLLg7OPowEyQQXQw+EEUsYCZTfPaxnph0tBQ/pdTjFhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=Nq4tv77V; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4Y7jcP3NMYz9tF2;
	Wed, 11 Dec 2024 18:43:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1733938981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMs1sLGLbCKoPzxD2qKl1ngo8hgDqG1n8l4Vt1q2uJM=;
	b=Nq4tv77VX8S/nEzIV7jQ9qZ/gF1BEiP6Vzuqzywx2L+xZlmou1UQH6X4Rk5o/rKyb2oKbY
	xN89lb7raDshjyJWzteYfpYoV6+FbPLFLg3JYinuSa6m/NOAWs4hRycedyHUyF/XhUqnj6
	MSHClgxlxuq6Uwit7f0AI0JzFbHD5AjBgzYEcVvgauI7pw2iJCOWf9nBCYD27qo1+rFfiq
	3mNvCCY9/+iKJr3HCLq0Z4G8z4nAB78XXay/fqesJU6R5g8ewVv81gDypLAJdVzQeD9c4Q
	E5WaMjzdlW9JZOO5uyxMfONWguwydir4hC3YfieOXHg4eXop51PNpb5seRUKUw==
Message-ID: <e1c96619-4402-4577-b2b8-a694bd5569c7@mailbox.org>
Date: Wed, 11 Dec 2024 18:42:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [REGRESSION] from 74a0e79df68a8042fb84fd7207e57b70722cf825: VFIO
 PCI passthrough no longer works
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 regressions@lists.linux.dev
References: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
 <Z1hiiz40nUqN2e5M@google.com>
 <93a3edef-dde6-4ef6-ae40-39990040a497@mailbox.org>
 <9e827d41-a054-5c04-6ecb-b23f2a4b5913@amd.com> <Z1jEDFpanEIVz1sY@google.com>
 <c64099db-33b3-9438-536e-7882bae614e0@amd.com>
Content-Language: en-GB
From: Simon Pilkington <simonp.git@mailbox.org>
In-Reply-To: <c64099db-33b3-9438-536e-7882bae614e0@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: xdc69urognmmw5b6skbn8y398iernif8
X-MBO-RS-ID: 73b08729dd3458e0d66

On 11/12/2024 15:37, Tom Lendacky wrote:
> On 12/10/24 16:43, Sean Christopherson wrote:
>> On Tue, Dec 10, 2024, Tom Lendacky wrote:
>>> On 12/10/24 14:33, Simon Pilkington wrote:
>>>> On 10/12/2024 16:47, Sean Christopherson wrote:
>>>>> Can you run with the below to see what bits the guest is trying to set (or clear)?
>>>>> We could get the same info via tracepoints, but this will likely be faster/easier.
>>>>>
>>>>> ---
>>>>>  arch/x86/kvm/svm/svm.c | 12 +++++++++---
>>>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>> index dd15cc635655..5144d0283c9d 100644
>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>> @@ -3195,11 +3195,14 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>>>>  	case MSR_AMD64_DE_CFG: {
>>>>>  		u64 supported_de_cfg;
>>>>>  
>>>>> -		if (svm_get_feature_msr(ecx, &supported_de_cfg))
>>>>> +		if (WARN_ON_ONCE(svm_get_feature_msr(ecx, &supported_de_cfg)))
>>>>>  			return 1;
>>>>>  
>>>>> -		if (data & ~supported_de_cfg)
>>>>> +		if (data & ~supported_de_cfg) {
>>>>> +			pr_warn("DE_CFG supported = %llx, WRMSR = %llx\n",
>>>>> +				supported_de_cfg, data);
>>>>>  			return 1;
>>>>> +		}
>>>>>  
>>>>>  		/*
>>>>>  		 * Don't let the guest change the host-programmed value.  The
>>>>> @@ -3207,8 +3210,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>>>>  		 * are completely unknown to KVM, and the one bit known to KVM
>>>>>  		 * is simply a reflection of hardware capabilities.
>>>>>  		 */
>>>>> -		if (!msr->host_initiated && data != svm->msr_decfg)
>>>>> +		if (!msr->host_initiated && data != svm->msr_decfg) {
>>>>> +			pr_warn("DE_CFG current = %llx, WRMSR = %llx\n",
>>>>> +				svm->msr_decfg, data);
>>>>>  			return 1;
>>>>> +		}
>>>>>  
>>>>>  		svm->msr_decfg = data;
>>>>>  		break;
>>>>>
>>>>> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
>>>>
>>>> Relevant dmesg output with some context below. VM locked up as expected.
>>>>
>>>> [   85.834971] vfio-pci 0000:0c:00.0: resetting
>>>> [   85.937573] vfio-pci 0000:0c:00.0: reset done
>>>> [   86.494210] vfio-pci 0000:0c:00.0: resetting
>>>> [   86.494264] vfio-pci 0000:0c:00.1: resetting
>>>> [   86.761442] vfio-pci 0000:0c:00.0: reset done
>>>> [   86.761480] vfio-pci 0000:0c:00.1: reset done
>>>> [   86.762392] vfio-pci 0000:0c:00.0: resetting
>>>> [   86.865462] vfio-pci 0000:0c:00.0: reset done
>>>> [   86.977360] virbr0: port 1(vnet1) entered learning state
>>>> [   88.993052] virbr0: port 1(vnet1) entered forwarding state
>>>> [   88.993057] virbr0: topology change detected, propagating
>>>> [  103.459114] kvm_amd: DE_CFG current = 0, WRMSR = 2
>>>> [  161.442032] virbr0: port 1(vnet1) entered disabled state // VM shut down
>>>
>>> That is the MSR_AMD64_DE_CFG_LFENCE_SERIALIZE bit. Yeah, that actually
>>> does change the behavior of LFENCE and isn't just a reflection of the
>>> hardware.
>>>
>>> Linux does set that bit on boot, too (if LFENCE always serializing isn't
>>> advertised 8000_0021_EAX[2]), so I'm kind of surprised it didn't pop up
>>> there.
>>
>> Linux may be running afoul of this, but it would only become visible if someone
>> checked dmesg.  Even the "unsafe" MSR accesses in Linux gracefully handle faults
>> these days, the only symptom would be a WARN.
>>
>>> I imagine that the above CPUID bit isn't set, so an attempt is made to
>>> set the MSR bit.
>>
>> Yep.  And LFENCE_RDTSC _is_ supported, otherwise the supported_de_cfg check would
>> have failed.  Which means it's a-ok for the guest to set the bit, i.e. KVM won't
>> let the guest incorrectly think it's running on CPU for which LFENCE is serializing.
>>
>> Unless you (Tom) disagree, I vote to simply drop the offending code, i.e. make
>> all supported bits fully writable from the guest.  KVM is firmly in the wrong here,
>> and I can't think of any reason to disallow the guest from clearing LFENCE_SERIALIZE.
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 6a350cee2f6c..5a82ead3bf0f 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3201,15 +3201,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>                 if (data & ~supported_de_cfg)
>>                         return 1;
>>  
>> -               /*
>> -                * Don't let the guest change the host-programmed value.  The
>> -                * MSR is very model specific, i.e. contains multiple bits that
>> -                * are completely unknown to KVM, and the one bit known to KVM
>> -                * is simply a reflection of hardware capabilities.
>> -                */
>> -               if (!msr->host_initiated && data != svm->msr_decfg)
>> -                       return 1;
>> -
> 
> That works for me.
> 
> Thanks,
> Tom
> 
>>                 svm->msr_decfg = data;
>>                 break;
>>         }
>>

Thanks for the prompt response on this Sean & Tom.

Regards,
Simon

