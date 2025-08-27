Return-Path: <kvm+bounces-55974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD922B38E9C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:43:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A63593654C3
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 22:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04C03112A1;
	Wed, 27 Aug 2025 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="MREP9Mkt"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733B32BEC4A;
	Wed, 27 Aug 2025 22:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756334613; cv=none; b=hrXxvq/C9fbxFznw8A71fdAga1lVrCs9ZLcaXQ6p3hwgCehlFP1M9mtrs7WDzkjliQh+T1rHYjmpC+hk56CVsWH6TRTLCwbVwS84XNemD8JoybnzD7p/Tr439iblrr4bkRb+/zHrgGTfxkrcQz/3TIkYYuzdzG84MzuJUaF8piU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756334613; c=relaxed/simple;
	bh=M5wBJ5H/Lnxt0nRISLvUE9r5Wrj+wr3mKLmfL7JYRsw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iYqEIYYI8PYfuShaO5VzZB8ZNcnuffdHJG/iK1l0t/LbcvQgkyxVlOKRnyJbr2jO7nWzcX96Xlp58I0We6TvJmmk9JVFXdTnJFaRgiKxLgzl6TUAmM9F+tCH2ygE6bZlK0jc7ybYFmRLtlP6eScbHN6Gm03H9T0DpKn8X6iiX3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=MREP9Mkt; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57RMh0x81916010
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 27 Aug 2025 15:43:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57RMh0x81916010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756334582;
	bh=GlD3nUD4hvTwMTAZekHH9XvHUFOJHjy73HK/6D0khgk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=MREP9MktjbZSfaJ2jbw6MizbnXzyx0wEHKk7LXZuQKT6t4asZDmO/RizqmXZtqDBa
	 QvMoAI1/em3pzOzRchmEu9OF3+eQHRz3v/mtUr3yjYQ4919wzBC1/lJLLKAVBq1wGe
	 DO+b56aJeH54/G7a/AaSp7lpR/uj3JJg/nxxxRC1AU75AkjVhpeQd+CKi2q03sjFK1
	 HZiBUmFQTVIosZTP2y1+ZlH4oPyRRTrlPCno+HmYMpTLiJT1ugtxWdWhqKxN53H1Eh
	 w2aNTL9CQksujqdIXXXoFgF2vrthxelUBu+leY9CZ5CjY0F9uDa3nJ7U676N5ZXudR
	 +wbMZf2Rujlnw==
Message-ID: <77076b24-c503-40e8-9459-ede808074f0f@zytor.com>
Date: Wed, 27 Aug 2025 15:43:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/20] KVM: VMX: Set FRED MSR intercepts
From: Xin Li <xin@zytor.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org
References: <20250821223630.984383-1-xin@zytor.com>
 <20250821223630.984383-7-xin@zytor.com>
 <2dd8c323-7654-4a28-86f1-d743b70d10b1@zytor.com>
 <aK340-6yIE_qujUm@google.com>
 <c45a7c91-e393-4f71-8b22-aef6486aaa9e@zytor.com>
 <aK4yXT9y5YHeEWkb@google.com>
 <5b1c5f80-bbe1-4294-8ede-5e097e8feda1@zytor.com>
Content-Language: en-US
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
In-Reply-To: <5b1c5f80-bbe1-4294-8ede-5e097e8feda1@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/27/2025 3:24 PM, Xin Li wrote:
> On 8/26/2025 3:17 PM, Sean Christopherson wrote:
>>> +        if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>>> +            wrmsrns(MSR_IA32_FRED_SSP0, vmx->msr_guest_fred_ssp0);
>> FWIW, if we can't get an SDM change, don't bother with RDMSR/WRMSRNS, just
>> configure KVM to intercept accesses.  Then in kvm_set_msr_common(), pivot on
>> X86_FEATURE_SHSTK, e.g.
> 
> 
> Intercepting is a solid approach: it ensures the guest value is fully
> virtual and does not affect the hardware FRED SSP0 MSR.  Of course the code
> is also simplified.
> 
> 
>>
>>     case MSR_IA32_U_CET:
>>     case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>>         if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>>             WARN_ON_ONCE(msr != MSR_IA32_FRED_SSP0);
>>             vcpu->arch.fred_rsp0_fallback = data;

Putting fred_rsp0_fallback in struct kvm_vcpu_arch reminds me one thing:

We know AMD will do FRED and follow the FRED spec for bare metal, but
regarding virtualization of FRED, I have no idea how it will be done on
AMD, so I keep the KVM FRED code in VMX files, e.g., msr_guest_fred_rsp0 is
defined in struct vcpu_vmx, and saved/restored in vmx.c.

It is a future task to make common KVM FRED code for Intel and AMD.

