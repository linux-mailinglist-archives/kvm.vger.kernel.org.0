Return-Path: <kvm+bounces-56610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C6AB40996
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29D363BCD72
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 15:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83FEA340D92;
	Tue,  2 Sep 2025 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="kPSsOYI5"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C19932BF41;
	Tue,  2 Sep 2025 15:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756828034; cv=none; b=N0tI3tEF86YxtOXiLahyZz1eDxNStJ+iU1FFuQhhcpGUS7jL+p+LxgQft7OseuGGkjGQTnmJKNTBDD5CFrjwfkSPKvSerGQOxGfNvMevK7BcQQt38mM6CWu9vxLEbb+z0/CEAXWMzeva+K8VOMA/1ucrCUel0BUxDzhvd3dJfik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756828034; c=relaxed/simple;
	bh=VwkDNpfoPE+9zVywcTkI+ddZXAbeZOlkUMIA50o62oU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jUMb1V0mQez2kD4Tqge6y9Jwa97FJMYNiAGbIvjVrLIwairpR4hj72wea4tAW5GpTiiTfYJMcajG1qn6M+kJ9SFqAkzl8xzD1iT/VbJfVs5TlgmnIWBTnZ1D1x0hnI/YGSOTpFGbx24/NJxpXeBFu1zxt2guj/Fy9J0c0PwVYYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=kPSsOYI5; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 582Fkh7k788279
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 2 Sep 2025 08:46:43 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 582Fkh7k788279
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756828004;
	bh=iWWmJ59c4YzM6lpvTwAjzKzKePDsD3rz63FRkjFeEJg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kPSsOYI5gZNTI6TFiwA2cgAiVHFJnDxLC/uhEVUlooUHoyd75jvDqWB15Ci1eYiaw
	 XcTOQbec0d24c770OF+mNI2uH2T1pxSCiS23hbDiB33vdpFqq2KiiRojEapn5lCliE
	 AJl/Vr/AFuBTMiD6dCAlB5pTNpGYD5vK2tjLul5AKux0zk4s1YjWJnXp495BNVOqXd
	 ikBAX5bQU3+b7oga3bllYTe3jBfQVX4OLGdgL1wx9I8b+MOYHz+Veh5JF/NGc+6aFb
	 /0pEDFHiOfMoQ7Y0/Umje4ptNj51XreUGsPaInlUnpyGKJ9ySaI2/c3uHixlnZQxBA
	 TK1VP8wvwcdbw==
Message-ID: <c28069c2-4a28-4803-89e1-9056514196a0@zytor.com>
Date: Tue, 2 Sep 2025 08:46:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] KVM: x86: Add support for RDMSR/WRMSRNS w/
 immediate on Intel
To: Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>,
        Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
References: <20250805202224.1475590-1-seanjc@google.com>
 <20250805202224.1475590-5-seanjc@google.com>
 <424e2aaa-04df-4c7e-a7f9-c95f554bd847@intel.com>
 <849dd787-8821-41f1-8eef-26ede3032d90@linux.intel.com>
 <c4bc61da-c42c-453d-b484-f970b99cb616@zytor.com>
 <fbdcca61-e9c4-47fc-b629-7a46ad35cd24@intel.com>
 <aLcEMCMDRCEZnmdH@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aLcEMCMDRCEZnmdH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/2/2025 7:50 AM, Sean Christopherson wrote:
> On Mon, Sep 01, 2025, Xiaoyao Li wrote:
>> On 9/1/2025 3:04 PM, Xin Li wrote:
>>> On 8/31/2025 11:34 PM, Binbin Wu wrote:
>>>>> We need to inject #UD for !guest_cpu_has(X86_FEATURE_MSR_IMM)
>>>>>
>>>>
>>>> Indeed.
>>>
>>> Good catch!
>>>
>>>>
>>>> There is a virtualization hole of this feature for the accesses to the
>>>> MSRs not intercepted. IIUIC, there is no other control in VMX for this
>>>> feature. If the feature is supported in hardware, the guest will succeed
>>>> when it accesses to the MSRs not intercepted even when the feature is not
>>>> exposed to the guest, but the guest will get #UD when access to the MSRs
>>>> intercepted if KVM injects #UD.
>>>
>>> hpa mentioned this when I just started the work.  But I managed to forget
>>> it later... Sigh!
>>>
>>>>
>>>> But I guess this is the guest's fault by not following the CPUID,
>>>> KVM should
>>>> still follow the spec?
>>>
>>> I think we should still inject #UD when a MSR is intercepted by KVM.
> 
> Hmm, no, inconsistent behavior (from the guest's perspective) is likely worse
> than eating with the virtualization hole.  Practically speaking, the only guest
> that's going to be surprised by the hole is a guest that's fuzzing opcodes, and
> a guest that's fuzzing opcodes at CPL0 isn't is going to create an inherently
> unstable environment no matter what.

Hmm, a malicious guest could *smartly* avoid causing such vmexits.  So more
or less that is wasteful and no objection here.

> 
> Though that raises the question of whether or not KVM should emulate WRMSRNS and
> whatever the official name for the "RDMSR with immediate" instruction is (I can't
> find it in the SDM).  I'm leaning "no", because outside of forced emulation, KVM
> should only "need" to emulate the instructions if Unrestricted Guest is disabled,
> the instructions should only be supported on CPUs with unrestricted guest, there's
> no sane reason (other than testing) to run a guest without Unrestricted Guest,
> and using the instructions in Big RM would be quite bizarre.  On the other hand,
> adding emulation support should be quite easy...
> 
> Side topic, does RDMSRLIST have any VMX controls?

Yes, bit 6 of Tertiary Processor-Based VM-Execution Controls, below is C&P
from Intel SDM:

Enable MSR-list instructions control: if this control is 0, any execution 
of RDMSRLIST or WRMSRLIST causes a #UD.

If the control is 1, the instruction commences normally, writing one MSR at
a time. Writes to certain MSRs are treated specially as described above for
WRMSR and WRMSRNS. In addition, attempts to access specific MSRs may cause 
VM exits.

For RDMSRLIST and WRMSRLIST, the exit qualification depends on the setting
of the “use MSR bitmaps” VM-execution control. If the control is 0, the
exit qualification is zero. If the control is 1, the exit qualification
is the index of the MSR whose access caused the VM exit.

