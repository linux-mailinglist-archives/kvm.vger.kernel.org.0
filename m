Return-Path: <kvm+bounces-33109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B47E9E4E0D
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 08:17:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82D612845F0
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 07:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9F51AC44C;
	Thu,  5 Dec 2024 07:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ymCPqgO8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105B92391AB;
	Thu,  5 Dec 2024 07:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733383060; cv=none; b=KsjS41Zlm8DNMMbgoQhPWKO4UqKxnR5TTw9qfSkvleqf1JQLrSV378cr/5V3gmaQs8dpYcd8bbgVYob0mbKPxiFNBIFIK2xw1uY5i2rna9rPB3iUFqAYIntaRQZElI9Pn45ZuEKKPmN0HHSMj4ep35MhEvf+KTWoKtqsenKH02k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733383060; c=relaxed/simple;
	bh=Z3/tFN7h17xUO2ncrQc4H3nnV14DtFEmAsCjm4/o2ac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T0q/PdwbiLSAgbdbBzJAk1lhv/ophWPdT+DpnSixhrEP4w9MCeFNZylPd9AD0QjXxoiI5pOJjeMgEZea5HkIlxKARvJ433IxWK2gRcPrIaHkUSdwsBu5KnMeeD2luhr4xIZpLsdODtLTwG2IzM3rij09UF77aMXZs3MZpmRn7X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ymCPqgO8; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.205] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4B57Gv3Y1462253
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 4 Dec 2024 23:16:58 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4B57Gv3Y1462253
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1733383020;
	bh=YkeScXjRFcOS65pjCguRHyt/CbJRADw5S8VOqyQ9fR4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ymCPqgO8DxJvyrBe3JsgG8uQLVyos1tT6RnqBy1ozbbWA0AhM5JdxrxUEyqqoaK0A
	 fn61DEoWqyGXKYdGmY2srhA5sJ+JUcyKwhznecugKSSIJQAPZSpP4Jg59yE1gBwAmu
	 HAPeBTVxwA0XdlqCE2X6tyFbcWGmEJaQN2ep3IhcIBJm5o8iPlY66sRDzXPMqxzv6U
	 Y/G3aZw4FsNXqnLwnHrc33fF8SCZgSh50NScLWteiWg5qfr610m8VXh2QHn2bqEeve
	 D1JduC/2c5wKrwL9sk2DTKjAKGfVX7XVqn/Sjb+jvAd6eM+l51kC7O/o0cVNRklJDk
	 aSd4FjBLuHhTQ==
Message-ID: <857ad555-4175-4816-81d7-f98ad091a1db@zytor.com>
Date: Wed, 4 Dec 2024 23:16:57 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/27] KVM: VMX: Virtualize FRED nested exception
 tracking
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-17-xin@zytor.com> <ZxnoE6ltLawgPHdZ@intel.com>
 <5ded5ea5-6a31-47ef-ae12-f32615ada248@zytor.com> <Zx8wS/wAI99yLmPh@intel.com>
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
In-Reply-To: <Zx8wS/wAI99yLmPh@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/2024 11:33 PM, Chao Gao wrote:
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index d81144bd648f..03f42b218554 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -1910,8 +1910,11 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
>>>> 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
>>>> 			     vmx->vcpu.arch.event_exit_inst_len);
>>>> 		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
>>>> -	} else
>>>> +	} else {
>>>> 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
>>>> +		if (ex->nested)
>>>> +			intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;
>>>
>>> how about moving the is_fred_enable() check from kvm_multiple_exception() to here? i.e.,
>>>
>>> 		if (ex->nested && is_fred_enabled(vcpu))
>>> 			intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;
>>>
>>> It is slightly clearer because FRED details don't bleed into kvm_multiple_exception().
>>
>> But FRED is all about events, including exception/interrupt/trap/...
>>
>> logically VMX nested exception only works when FRED is enabled, see how it is
>> set at 2 places in kvm_multiple_exception().
> 
> "VMX nested exception only works ..." is what I referred to as "FRED details"
> 
> I believe there are several reasons to decouple the "nested exception" concept
> from FRED:
> 
> 1. Readers new to FRED can understand kvm_multiple_exception() without needing
>     to know FRED details. Readers just need to know nested exceptions are
>     exceptions encountered during delivering another event (exception/NMI/interrupts).
> 
> 2. Developing KVM's generic "nested exception" concept can support other vendors.
>     "nested" becomes a property of an exception. only how nested exceptions are
>     reported to guests is specific to vendors (i.e., VMX/SVM).
> 
> 3. This series handles ex->event_data in a similar approach: set it regardless
>     of FRED enablement and let VMX/SVM code decide to consume or ignore it.

This is a nice way to look at the nature of nested exception, and I have
made the change for the next iteration.

Thanks!
     Xin

