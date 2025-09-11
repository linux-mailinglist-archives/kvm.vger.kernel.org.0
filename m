Return-Path: <kvm+bounces-57281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBD0B5295D
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 08:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B2476815CC
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 06:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08EF262808;
	Thu, 11 Sep 2025 06:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="krP0Mf43"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD23023E355;
	Thu, 11 Sep 2025 06:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757573886; cv=none; b=n5DanHOMV3OEOZ4I2o8R53E8FVVPsjzXfhQBEUiSaWyQvlccU47UJWAGTT9j6mWG2POg5pmGjG6/RuAsSMixNr6fzcjxgrthp1pC0EKgD1cb3uzTA+IJXtVszsnnzRfvdKJVsn1P32CaruZTj2ptTia0zTP5ppBtNyvYptGrZG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757573886; c=relaxed/simple;
	bh=ezYmetIuXixRHkPs5XqtQKqJxfsVsN9SqTJaOciWsro=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=B6kTphm3meICbP2KCIIiyIugyc3f9Vu43TiCA6Nqo4eopg9YbW0gRImJVcjvUYtP8TkLnNN6yeFbQc0h5t3Noyu1wJez780LWMfcSuakCYeo5E5Fwdtjecy4rlCr/aBA0vNMEMH1jnk/bXiGiaS98PqhEerlo4u/PzI1EtqRD3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=krP0Mf43; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 58B6v1Uk3451381
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 10 Sep 2025 23:57:02 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 58B6v1Uk3451381
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757573824;
	bh=lEaOcSoBLUph9n1Zjxl5jBw1XZCkL3NrlYg8XzrZUFI=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=krP0Mf43urhSNBqtVCqSlpqqaRB2ULapg86LJzirl5u3i0JRoOfXPMhSFPl282rO1
	 c/MJna3YFTY0ZmLxcdmWQzk6C2Pr7da79A+gzJ3UJRWDYkR2pEVk2w8GOd73jln0cd
	 A0hDmRLzu4QkkruOX1INFT5JNscCIXrFaHPkY66iBQRnzLCnZDqEJRpUYc5scmCxjQ
	 bBfx8Url652IvOBbAQgx9Xp/0aeGEP9YrzTwwZp9MLtlrvsmsJD2WgM6+o9PJyH1Br
	 +0t+boYOd09GKuESb3jybj2ov95D/dkrX7KPvZfgsK2lH98NFq2fBMXvw0eVgeOUZm
	 2sHZodNui2Glw==
Message-ID: <a8fa891e-0f35-449b-970c-24e5ca01e2f6@zytor.com>
Date: Wed, 10 Sep 2025 23:57:01 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Xin Li <xin@zytor.com>
Subject: Re: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
To: Chao Gao <chao.gao@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        rafael@kernel.org, pavel@kernel.org, brgerst@gmail.com,
        david.kaplan@amd.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        kprateek.nayak@amd.com, arjan@linux.intel.com,
        rick.p.edgecombe@intel.com, dan.j.williams@intel.com
References: <20250909182828.1542362-1-xin@zytor.com>
 <20250909182828.1542362-2-xin@zytor.com> <aMEn4czyuqrQ1+oF@intel.com>
Content-Language: en-US
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aMEn4czyuqrQ1+oF@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/10/2025 12:25 AM, Chao Gao wrote:
>> void vmx_vm_destroy(struct kvm *kvm)
>> @@ -8499,10 +8396,6 @@ __init int vmx_hardware_setup(void)
>>
>> 	vmx_set_cpu_caps();
>>
>> -	r = alloc_kvm_area();
>> -	if (r && nested)
>> -		nested_vmx_hardware_unsetup();
>> -
> 
> There is a "return r" at the end of this function. with the removal
> of "r = alloc_kvm_area()", @r may be uninitialized.

Good catch!

There’s no need for r to have function-wide scope anymore; just return 0 at
the end of vmx_hardware_setup() after changing the definition of r as the
following

	if (nested) {
		int r = 0;
		...
	}


BTW, it's a good habit to always initialize local variables, which helps to
avoid this kind of mistakes I made here.


>> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
>> index 916441f5e85c..0eec314b79c2 100644
>> --- a/arch/x86/power/cpu.c
>> +++ b/arch/x86/power/cpu.c
>> @@ -206,11 +206,11 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
>> 	/* cr4 was introduced in the Pentium CPU */
>> #ifdef CONFIG_X86_32
>> 	if (ctxt->cr4)
>> -		__write_cr4(ctxt->cr4);
>> +		__write_cr4(ctxt->cr4 & ~X86_CR4_VMXE);
> 
> any reason to mask off X86_CR4_VMXE here?

In this patch set, X86_CR4_VMXE is an indicator of whether VMX is on.  I
used a per-CPU variable to track that, but later it seems better to track
X86_CR4_VMXE.

> 
> I assume before suspend, VMXOFF is executed and CR4.VMXE is cleared. then
> ctxt->cr4 here won't have CR4.VMXE set.

What you said is for APs per my understanding.

cpu_{enable,disable}_virtualization() in arch/x86/power/cpu.c are only used
to execute VMXON/VMXOFF on BSP.

TBH, there are lot of power management details I don't understand, e.g., AP
states don't seem saved.  But the changes here are required to make S4
work :)


