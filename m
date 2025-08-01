Return-Path: <kvm+bounces-53821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4D7B17ADF
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 03:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF5667AEF55
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 01:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A2778F5D;
	Fri,  1 Aug 2025 01:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="a1fJcoiR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B0923AD;
	Fri,  1 Aug 2025 01:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754012181; cv=none; b=U3dPGYVo14h6/Cm6cRHp9KE61r4Vz1bPvQdHqiXp1c3GllFxq16H7zkoTRWaGZRiQ1x9PfhQ2RaVwgasFUJTA2ih6Jr+10vLIWd9JEmcfr7qdOeQWcphEe6HPCeyetNV4uSU2Jssvo3nvJyi5Axm6lDINFazpA5EcKREj3AWuzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754012181; c=relaxed/simple;
	bh=5SNsFNLVWYOZFqNAoOz9IHjAl8j+Cg/aGn2QpUZyKgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RLiS/3nLFwQ76NLOFjIk6yIC3lAwQwFf1PPxcV3Jms6kKmZoNOClJuDk7PGD2dBf2fs7i4UaSmEcoKCBRpc2swAn4DttHhcFmq1FNeOzmyq0eiMFWQlBTPtIwBnMQCOMU9kVZ7D8TdG+JPfgaGyGU+2YczgP/i4jFzJ7SNwxi08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=a1fJcoiR; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5711ZkZT2441379
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 31 Jul 2025 18:35:47 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5711ZkZT2441379
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754012148;
	bh=EgWSSRCbXkSWBQ/z1xshtc+sAmsdQQ8TiuhWS5SqWjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a1fJcoiRdAaGnQhMvG9bBK1PxYIUehGfoar3etETXoVw8UJRsCeCFzZZIwz0cfSAI
	 9Y5TmH+7PQSJenuuJffwyliLOwPhRNLHdrGTeAtUNCrxvhNj9x4zjPU9HZd67yXRzk
	 alUmQcrhpFhtWtJgnqWW2W+Gq8VNkGLHqUwrnpZuade2NPjfcc47S60YtFn669i5XF
	 I8fwtC57UpJairG5ZDMvdc9xtIORBuiSJDOQZcTmWe9IXMXcS+Slffu5DFViUciJTr
	 sDW9WMfbMMzNiizYfdpPFHJund1KA3lMYHI+dhW6VyriP051L1nHIqJSI1Wxsy/He6
	 n+QR4Rmtiv2dQ==
Message-ID: <b3774d86-5589-4b01-a633-ae28794a4cfd@zytor.com>
Date: Thu, 31 Jul 2025 18:35:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] KVM: x86: Introduce MSR read/write emulation
 helpers
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com
References: <20250730174605.1614792-1-xin@zytor.com>
 <20250730174605.1614792-3-xin@zytor.com> <aItGzjhpfzIbG+Op@intel.com>
 <7af6dcf5-fbcd-4173-a588-38cf6c536282@zytor.com>
 <aIwOmEzLgkP-9ZDE@google.com>
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
In-Reply-To: <aIwOmEzLgkP-9ZDE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>>> +
>>>> 		handled = !handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
>>>> 		break;
>>>> 	case MSR_IA32_TSC_DEADLINE:
>>>> -		data = kvm_read_edx_eax(vcpu);
>>>> +		if (reg == VCPU_EXREG_EDX_EAX)
>>>> +			data = kvm_read_edx_eax(vcpu);
>>>> +		else
>>>> +			data = kvm_register_read(vcpu, reg);
>>>> +
>>>
>>> Hoist this chunk out of the switch clause to avoid duplication.
>>
>> I thought about it, but didn't do so because the original code doesn't read
>> the MSR data from registers when a MSR is not being handled in the
>> fast path, which saves some cycles in most cases.
> 
> Can you hold off on doing anything with this series?  Mostly to save your time.

Sure.

> 
> Long story short, I unexpectedly dove into the fastpath code this week while sorting
> out an issue with the mediated PMU series, and I ended up with a series of patches
> to clean things up for both the mediated PMU series and for this series.
> 
> With luck, I'll get the cleanups, the mediated PMU series, and a v2 of this series
> posted tomorrow (I also have some feedback on VCPU_EXREG_EDX_EAX; we can avoid it
> entirely without much fuss).
> 

Will wait and take a look when you post them.


