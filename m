Return-Path: <kvm+bounces-33649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2864C9EFB76
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D988188CEBC
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 18:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FE6188CB1;
	Thu, 12 Dec 2024 18:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="tq6orQL+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896FC2F2F;
	Thu, 12 Dec 2024 18:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734029326; cv=none; b=jf4KQhmslcUoF+urzseL/Y68rI+OAjb6IlfPDE+0U9a9D2GTMZQkpDgGigFC1Lsr68TDpXE23jNDxlW9kx7a10qpDdYrLzOSX6DYIAxE9Yx6oM1Wwg1JdZPLhnbYuA+B79FZoX/B8OyTpPh5FK5nk98YJS1bMREersdw7kKMyx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734029326; c=relaxed/simple;
	bh=vFL9c+2PwzotBNq6ljdxHGHn07GU7AczLYkX2CkFbvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QV2m9QmkvvN3F9xWdw7O0A6L9SX8jqPiPjE9dvIkiSuDl0Oh7Feb/aU8O6gYb0XEVl4TAM9JqpFy89iFKbXAmagVTinuej86g27uaA/6WpP0OatvkKLHkw2RrRoo7HPEHrZE3Wf8o9f+sUyqdi8kDG4lUNOjBUqkPt2Rz/GDQaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=tq6orQL+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4BCIm2MV1241973
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 12 Dec 2024 10:48:02 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4BCIm2MV1241973
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1734029285;
	bh=LS5ebAaxhRt1oilTRh8UWqUtciFI640KhdT1USGVRBA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tq6orQL+5MP6ahCa64iKAgWb6ZPHNMgYBOwXTD0WmjfrfJvdhlNU6yVWg1Idcr0ge
	 MqB2ILmOWMIT/7FcBD3L/GME7qvWeDoFrMbpZYHjF4dl4/BehH7zKZNnkOf8q812y5
	 V9MNDsTSSJm0Ux5zISOWsNiPbETg2lRDRyVqPwUJ4BZldS3m8ZQhip9KvQBJv600F8
	 S5/UGHDE4Ho/qxJbHC0fIE6ykYED71KlbBvu4kyoxn/hfFLDq2JpNX1+1KvpimdZAG
	 cXltHPy7+To/N64SUaJGpny1uEZsXPST7kK0rOYimeMb++aTUMDeFj7DAtnCSeitzk
	 cwYl4sFY18Tlg==
Message-ID: <3ec986fa-2bf0-4c78-b532-343ad19436b2@zytor.com>
Date: Thu, 12 Dec 2024 10:48:01 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/27] KVM: x86: Mark CR4.FRED as not reserved when
 guest can use FRED
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-18-xin@zytor.com> <Zxn0tfA+k4ppu2WL@intel.com>
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
In-Reply-To: <Zxn0tfA+k4ppu2WL@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2024 12:18 AM, Chao Gao wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 03f42b218554..bfdd10773136 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -8009,6 +8009,10 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>> 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
>> 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_FRED);
>>
>> +	/* Don't allow CR4.FRED=1 before all of FRED KVM support is in place. */
>> +	if (!guest_can_use(vcpu, X86_FEATURE_FRED))
>> +		vcpu->arch.cr4_guest_rsvd_bits |= X86_CR4_FRED;
> 
> is this necessary? __kvm_is_valid_cr4() ensures that guests cannot set any bit
> which isn't supported by the hardware.
> 
> To account for hardware/KVM caps, I think the following changes will work. This
> will fix all other bits besides X86_CR4_FRED.

This seems a generic infra improvement, maybe it's better for you to
send it as an individual patch to Sean and the KVM mailing list?

> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4a93ac1b9be9..2bec3ba8e47d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1873,6 +1873,7 @@ struct kvm_arch_async_pf {
>   extern u32 __read_mostly kvm_nr_uret_msrs;
>   extern bool __read_mostly allow_smaller_maxphyaddr;
>   extern bool __read_mostly enable_apicv;
> +extern u64 __read_mostly cr4_reserved_bits;
>   extern struct kvm_x86_ops kvm_x86_ops;
>   
>   #define kvm_x86_call(func) static_call(kvm_x86_##func)
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2617be544480..57d82fbcfd3f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -393,8 +393,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>   
>   	kvm_pmu_refresh(vcpu);
> -	vcpu->arch.cr4_guest_rsvd_bits =
> -	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
> +	vcpu->arch.cr4_guest_rsvd_bits = cr4_reserved_bits |
> +					 __cr4_reserved_bits(guest_cpuid_has, vcpu);
>   
>   	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
>   						    vcpu->arch.cpuid_nent));
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 34b52b49f5e6..08b42bbd2342 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -119,7 +119,7 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
>   static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
>   #endif
>   
> -static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
> +u64 __read_mostly cr4_reserved_bits;
>   
>   #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
>   
> @@ -1110,13 +1110,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
>   
>   bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   {
> -	if (cr4 & cr4_reserved_bits)
> -		return false;
> -
> -	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
> -		return false;
> -
> -	return true;
> +	return !(cr4 & vcpu->arch.cr4_guest_rsvd_bits);
>   }
>   EXPORT_SYMBOL_GPL(__kvm_is_valid_cr4);
>   
> 
>> +
>> 	vmx_setup_uret_msrs(vmx);
>>
>> 	if (cpu_has_secondary_exec_ctrls())
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 992e73ee2ec5..0ed91512b757 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -561,6 +561,8 @@ enum kvm_msr_access {
>> 		__reserved_bits |= X86_CR4_PCIDE;       \
>> 	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
>> 		__reserved_bits |= X86_CR4_LAM_SUP;     \
>> +	if (!__cpu_has(__c, X86_FEATURE_FRED))          \
>> +		__reserved_bits |= X86_CR4_FRED;        \
>> 	__reserved_bits;                                \
>> })
>>
>> -- 
>> 2.46.2
>>
>>


