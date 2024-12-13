Return-Path: <kvm+bounces-33760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4506E9F152B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 19:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37029188CFA0
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 18:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6691EB9F8;
	Fri, 13 Dec 2024 18:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ceDcUwUH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8391E47D6;
	Fri, 13 Dec 2024 18:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734115471; cv=none; b=l9ZaiXdSdj3UG/2GUaCfdVLGYagZB7d46JfwX/T99/yW1H8owYfmDXhkFP2u68bk890eq72xVnhzVsG3q1u8b7ZsuWhkau9GOADfcJyD0PeLOnAM/Ogwx8Jf+WHlnAQ+0v186qiAkDl5xBS7C+YDU7Xwb+RgIDQv2z2tAi75ryI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734115471; c=relaxed/simple;
	bh=BGUhJ7s4wap9Trc0L03YqNCF5PervmrG+ZI0sPhI0Iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F+X0eYELlhdyFGb7fLZDc5M0aXIAzalKTjQiA/f8NHaYWz+6mZhBHL/2swnZIzWSYqY+53KC8jBVjl353r9x7jE4U/2GSKdCMzGtWwxwd8a3kCSUzh9XbqY9MfFEIGpCy3ODInRo4Yi3fUBTvzbUxUuVuRoxL+ThHE0H8d9ZHNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ceDcUwUH; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4BDIhojZ1669908
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 13 Dec 2024 10:43:51 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4BDIhojZ1669908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1734115432;
	bh=kBqPmg8+aysNeFRPWlQAPUCgrnX3967ZvJpr+SvfrL8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ceDcUwUH7CqZWX44iL17eN8nw5RrcS4vDK62vWEYOx4MA2DGTpGbKXJUh5TlTeB+a
	 aQFSWvCltZZOqLjr4cPPbMpByK3RrMy0phB+cHueogz+2DWCNXidHXmLUFkiMPrDeC
	 mNnA4D2qexyIfyH5SX+2yXuodvc8D4R0DBxs53a43VjZN52WzOd596ng7UDaSB5Hxi
	 ESgZjFH4J9n8hz9A7Pze2/DwlX0Wy52BRKPmCfeF12MXVoWxUtGLIQ0dnvMFf/BPje
	 aNuBH6LBP78BMPK21B+oCL1L3T7KCV9diN9ddD1rFUUZSpPY2tr/KhNpom3uXzMITo
	 Blawug5XjYX7w==
Message-ID: <832e87d1-8349-47f8-b1dc-33768b534b10@zytor.com>
Date: Fri, 13 Dec 2024 10:43:49 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/27] KVM: x86: Mark CR4.FRED as not reserved when
 guest can use FRED
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-18-xin@zytor.com> <Zxn0tfA+k4ppu2WL@intel.com>
 <3ec986fa-2bf0-4c78-b532-343ad19436b2@zytor.com>
 <Z1sz_oMq8yX--H7U@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 xsDNBGUPz1cBDACS/9yOJGojBFPxFt0OfTWuMl0uSgpwk37uRrFPTTLw4BaxhlFL0bjs6q+0
 2OfG34R+a0ZCuj5c9vggUMoOLdDyA7yPVAJU0OX6lqpg6z/kyQg3t4jvajG6aCgwSDx5Kzg5
 Rj3AXl8k2wb0jdqRB4RvaOPFiHNGgXCs5Pkux/qr0laeFIpzMKMootGa4kfURgPhRzUaM1vy
 bsMsL8vpJtGUmitrSqe5dVNBH00whLtPFM7IbzKURPUOkRRiusFAsw0a1ztCgoFczq6VfAVu
 raTye0L/VXwZd+aGi401V2tLsAHxxckRi9p3mc0jExPc60joK+aZPy6amwSCy5kAJ/AboYtY
 VmKIGKx1yx8POy6m+1lZ8C0q9b8eJ8kWPAR78PgT37FQWKYS1uAroG2wLdK7FiIEpPhCD+zH
 wlslo2ETbdKjrLIPNehQCOWrT32k8vFNEMLP5G/mmjfNj5sEf3IOKgMTMVl9AFjsINLHcxEQ
 6T8nGbX/n3msP6A36FDfdSEAEQEAAc0WWGluIExpIDx4aW5Aenl0b3IuY29tPsLBDQQTAQgA
 NxYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89XBQkFo5qAAhsDBAsJCAcFFQgJCgsFFgID
 AQAACgkQa70OVx2uN1HUpgv/cM2fsFCQodLArMTX5nt9yqAWgA5t1srri6EgS8W3F+3Kitge
 tYTBKu6j5BXuXaX3vyfCm+zajDJN77JHuYnpcKKr13VcZi1Swv6Jx1u0II8DOmoDYLb1Q2ZW
 v83W55fOWJ2g72x/UjVJBQ0sVjAngazU3ckc0TeNQlkcpSVGa/qBIHLfZraWtdrNAQT4A1fa
 sWGuJrChBFhtKbYXbUCu9AoYmmbQnsx2EWoJy3h7OjtfFapJbPZql+no5AJ3Mk9eE5oWyLH+
 QWqtOeJM7kKvn/dBudokFSNhDUw06e7EoVPSJyUIMbYtUO7g2+Atu44G/EPP0yV0J4lRO6EA
 wYRXff7+I1jIWEHpj5EFVYO6SmBg7zF2illHEW31JAPtdDLDHYcZDfS41caEKOQIPsdzQkaQ
 oW2hchcjcMPAfyhhRzUpVHLPxLCetP8vrVhTvnaZUo0xaVYb3+wjP+D5j/3+hwblu2agPsaE
 vgVbZ8Fx3TUxUPCAdr/p73DGg57oHjgezsDNBGUPz1gBDAD4Mg7hMFRQqlzotcNSxatlAQNL
 MadLfUTFz8wUUa21LPLrHBkUwm8RujehJrzcVbPYwPXIO0uyL/F///CogMNx7Iwo6by43KOy
 g89wVFhyy237EY76j1lVfLzcMYmjBoTH95fJC/lVb5Whxil6KjSN/R/y3jfG1dPXfwAuZ/4N
 cMoOslWkfZKJeEut5aZTRepKKF54T5r49H9F7OFLyxrC/uI9UDttWqMxcWyCkHh0v1Di8176
 jjYRNTrGEfYfGxSp+3jYL3PoNceIMkqM9haXjjGl0W1B4BidK1LVYBNov0rTEzyr0a1riUrp
 Qk+6z/LHxCM9lFFXnqH7KWeToTOPQebD2B/Ah5CZlft41i8L6LOF/LCuDBuYlu/fI2nuCc8d
 m4wwtkou1Y/kIwbEsE/6RQwRXUZhzO6llfoN96Fczr/RwvPIK5SVMixqWq4QGFAyK0m/1ap4
 bhIRrdCLVQcgU4glo17vqfEaRcTW5SgX+pGs4KIPPBE5J/ABD6pBnUUAEQEAAcLA/AQYAQgA
 JhYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89ZBQkFo5qAAhsMAAoJEGu9DlcdrjdR4C0L
 /RcjolEjoZW8VsyxWtXazQPnaRvzZ4vhmGOsCPr2BPtMlSwDzTlri8BBG1/3t/DNK4JLuwEj
 OAIE3fkkm+UG4Kjud6aNeraDI52DRVCSx6xff3bjmJsJJMb12mWglN6LjdF6K+PE+OTJUh2F
 dOhslN5C2kgl0dvUuevwMgQF3IljLmi/6APKYJHjkJpu1E6luZec/lRbetHuNFtbh3xgFIJx
 2RpgVDP4xB3f8r0I+y6ua+p7fgOjDLyoFjubRGed0Be45JJQEn7A3CSb6Xu7NYobnxfkwAGZ
 Q81a2XtvNS7Aj6NWVoOQB5KbM4yosO5+Me1V1SkX2jlnn26JPEvbV3KRFcwV5RnDxm4OQTSk
 PYbAkjBbm+tuJ/Sm+5Yp5T/BnKz21FoCS8uvTiziHj2H7Cuekn6F8EYhegONm+RVg3vikOpn
 gao85i4HwQTK9/D1wgJIQkdwWXVMZ6q/OALaBp82vQ2U9sjTyFXgDjglgh00VRAHP7u1Rcu4
 l75w1xInsg==
In-Reply-To: <Z1sz_oMq8yX--H7U@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/2024 11:05 AM, Sean Christopherson wrote:
> On Thu, Dec 12, 2024, Xin Li wrote:
>> On 10/24/2024 12:18 AM, Chao Gao wrote:
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index 03f42b218554..bfdd10773136 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -8009,6 +8009,10 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>> 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
>>>> 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_FRED);
>>>>
>>>> +	/* Don't allow CR4.FRED=1 before all of FRED KVM support is in place. */
>>>> +	if (!guest_can_use(vcpu, X86_FEATURE_FRED))
>>>> +		vcpu->arch.cr4_guest_rsvd_bits |= X86_CR4_FRED;
>>>
>>> is this necessary? __kvm_is_valid_cr4() ensures that guests cannot set any bit
>>> which isn't supported by the hardware.
>>>
>>> To account for hardware/KVM caps, I think the following changes will work. This
>>> will fix all other bits besides X86_CR4_FRED.
>>
>> This seems a generic infra improvement, maybe it's better for you to
>> send it as an individual patch to Sean and the KVM mailing list?
> 
> Already ahead of y'all :-)  (I think, I didn't look closely at this).
> 
> https://lore.kernel.org/all/20241128013424.4096668-6-seanjc@google.com

Ha, that is nice.  Thank you!


