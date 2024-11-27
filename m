Return-Path: <kvm+bounces-32552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 711599DA27E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 07:47:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2E31B24FC9
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 06:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D1C14A099;
	Wed, 27 Nov 2024 06:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LoaidWcd"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F35146580;
	Wed, 27 Nov 2024 06:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732690029; cv=none; b=OHgSyLC7Jmniyi4gqj/3aglKEyH3RCWxy4hqBZ9tkfzb9MNGVsvy/BLMgXrMCo+HwoRB0h2g/ygRj+tjXbwThDn/mQfFHhtEbgLkaKA7AcCdrqglcyF59vDyPOEfiOXcI9UsOrTC2U/YtKHqWdQx7q2RAcctskE5VrEIge9Zpoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732690029; c=relaxed/simple;
	bh=IKN3uGXQpsb214rkA0SH3AIlbeF9blKRdxLBQUVz8R8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bkfUua9aAS7t4+eFL+kD3fSXZlRVj9cPSpjgiVatI6ySODPxkTCsczPPjTeyj9wiJbj0qp1sB+pnb5JkYMSVKrsTgZhS69yFfLT+1hZSwDYIw9ANeKjx7qJtygPIzybFWc87pot+mWToNPMJtfS4jlpDegCOItNrb5462m0ox+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LoaidWcd; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.205] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4AR6kAjs1813996
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 26 Nov 2024 22:46:10 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4AR6kAjs1813996
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1732689974;
	bh=j2sJlehdvfhAuOOkuPIvmkfbbTtOCG9LBc+HSbZ/uJ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LoaidWcdBtqK3iJHkHTC8z3f2py+0XlIgbynqtKiN16Fhv2NzF7TqEp1KnuNmlIMM
	 ZB2oE/qmCg5TIFrmQKdPcehoA9aZAL8gb+zSyPgGGRxoowde070HfpSp2XzPb52XYN
	 ut51pEAVqxNcE0G4QIzpl1v8a0pY7MTJV13g3Gt1tqKEwZM5fz7J+SYrKQgWkQiOmk
	 khYn2ZO0Ihc+p6imEAgTPCWF7owZjGRGHKtaJdaEQEmPfJyo68xbp7cfBKhDmnTWTi
	 J5EKKJVaQE0tr1D0+DV8WQjGLrWtHEml0qu7T1HQL2+fXMz5BuwdP4AZtkiXUbAdaP
	 URB48huTi3dGA==
Message-ID: <f2fa87d7-ade8-42e2-8b2b-dba6f050d8c2@zytor.com>
Date: Tue, 26 Nov 2024 22:46:09 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/27] KVM: VMX: Do not use
 MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-10-xin@zytor.com>
 <20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local>
 <e7f6e7c2-272a-4527-ba50-08167564e787@zytor.com>
 <20241126200624.GDZ0YqQF96hKZ99x_b@fat_crate.local>
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
In-Reply-To: <20241126200624.GDZ0YqQF96hKZ99x_b@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/2024 12:06 PM, Borislav Petkov wrote:
> On Tue, Nov 26, 2024 at 11:22:45AM -0800, Xin Li wrote:
>> It's still far from full in a bitmap on x86-64, but just that the
>> existing use of MAX_POSSIBLE_PASSTHROUGH_MSRS tastes bad.
> 
> Far from full?
> 
> It is full:
> 
> static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
>          MSR_IA32_SPEC_CTRL,
>          MSR_IA32_PRED_CMD,
>          MSR_IA32_FLUSH_CMD,
>          MSR_IA32_TSC,
> #ifdef CONFIG_X86_64
>          MSR_FS_BASE,
>          MSR_GS_BASE,
>          MSR_KERNEL_GS_BASE,
>          MSR_IA32_XFD,
>          MSR_IA32_XFD_ERR,
> #endif
>          MSR_IA32_SYSENTER_CS,
>          MSR_IA32_SYSENTER_ESP,
>          MSR_IA32_SYSENTER_EIP,
>          MSR_CORE_C1_RES,
>          MSR_CORE_C3_RESIDENCY,
>          MSR_CORE_C6_RESIDENCY,
>          MSR_CORE_C7_RESIDENCY,
> };
> 
> I count 16 here.
> 
> If you need to add more, you need to increment MAX_POSSIBLE_PASSTHROUGH_MSRS.

Yes, the most obvious approach is to simply increase
MAX_POSSIBLE_PASSTHROUGH_MSRS by the number of MSRs to be added into the 
array.

However I hate to count it myself, especially we have ARRAY_SIZE.

> 
>> A better one?
> 
> Not really.
> 
> You're not explaining why MAX_POSSIBLE_PASSTHROUGH_MSRS becomes 64.
> 
>> Per the definition, a bitmap on x86-64 is an array of 'unsigned long',
>> and is at least 64-bit long.
>>
>> #define DECLARE_BITMAP(name,bits) \
>> 	unsigned long name[BITS_TO_LONGS(bits)]
>>
>> It's not accurate and error-prone to use a hard-coded possible size of
>> a bitmap, Use ARRAY_SIZE with an overflow build check instead.
> 
> It becomes 64 because a bitmap has 64 bits?

Yes, maybe better to name the macro as MAX_ALLOWED_PASSTHROUGH_MSRS?

> 
> Not because you need to add more MSRs to it and thus raise the limit?

Right.  It triggered me to look at the code further, though, I think the
existing code could be written in a better way no matter whether I need
to add more MSRs.  And whoever wants to add more won't need to increase
MAX_POSSIBLE_PASSTHROUGH_MSRS (ofc unless overflow 64).

Thanks!
     Xin

