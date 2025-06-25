Return-Path: <kvm+bounces-50739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A91AE8B67
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 19:19:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41A3E3BA72A
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE1029ACED;
	Wed, 25 Jun 2025 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JPAq5RtF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0FB3074AC;
	Wed, 25 Jun 2025 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750871946; cv=none; b=kYPyuceldvmvTSPS162sxCDiQOHeIQ1Cdcg75U8D1jlAyMqIqVbF46iZLORnU7ddVwpg+7xDeya9Y52oBlwnIEZsYvFiQ04e/QaFVX7tTVmQS0yS7x4ymJGbxVm9kvHEaIBrZRZ7tQdiBakmSz1LrUQ2yq7xCinPkXeWlyNYEkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750871946; c=relaxed/simple;
	bh=JDycdRDjOullquM1c2r5tzpdD0MiNHYGnWvVTdBdKAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHA8vH2LXkLH3MskjtGtfWt/zvD+r0sLQqV4HgQEgCaqXl9/o1O+gMNykSlcLG2QtQytYLhMvn8/EE01JBlu7gSkku5dNupSkJeyXuqV0GJqDmBNTC7qJlqyYiKF4anIwqwmvuAyyMR7q3EPrauooqux1bH+G7CB0lSQcN0mPes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JPAq5RtF; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55PHIPTD1863931
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 25 Jun 2025 10:18:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55PHIPTD1863931
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750871906;
	bh=loidXCrBBthki92bM6ro87FQwyhzKevoE90+bNNgOBQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JPAq5RtFxBeXG8Wn9bwzFn9GsxId4+Ccfdh/nbT5OabOtOdb3B/T3rv9orZKwOlh1
	 jipZoiAczn+aoR8lf5jfTWOIYcGwuWwtQVGOpBvjn4takqq68YnCDBvYFdAZ1kDWcK
	 zXyj3JPtAIe1g0KcJO1eSwW78lmipWpKziaSP4u3ZxM+N+I7i+paVRKcfYKh1bWEvM
	 oWpvMX9imQ9OhXE864ziwv9Y3uTNRvBQv/yDWI4iXV4rowrBZa3W/dP1uW6EOPQlGp
	 wMT1T+YYn/PjjVVBzj/Hw+N54deMtVRAjGbls/Q+2+x9++NqVLfvNeRXJJuwON03U8
	 +3r2vYsMB/qIw==
Message-ID: <858a3c30-08ab-4b9b-b74c-a3917a247841@zytor.com>
Date: Wed, 25 Jun 2025 10:18:24 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/19] KVM: VMX: Add support for FRED context
 save/restore
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, andrew.cooper3@citrix.com,
        luto@kernel.org, peterz@infradead.org, chao.gao@intel.com,
        xin3.li@intel.com
References: <20250328171205.2029296-1-xin@zytor.com>
 <20250328171205.2029296-9-xin@zytor.com> <aFrR5Nk1Ge3_ApWy@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aFrR5Nk1Ge3_ApWy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/24/2025 9:27 AM, Sean Christopherson wrote:
>> +
>> +static u64 vmx_read_guest_fred_rsp0(struct vcpu_vmx *vmx)
>> +{
>> +	preempt_disable();
>> +	if (vmx->guest_state_loaded)
>> +		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
>> +	preempt_enable();
>> +	return vmx->msr_guest_fred_rsp0;
>> +}
>> +
>> +static void vmx_write_guest_fred_rsp0(struct vcpu_vmx *vmx, u64 data)
>> +{
>> +	preempt_disable();
>> +	if (vmx->guest_state_loaded)
>> +		wrmsrns(MSR_IA32_FRED_RSP0, data);
>> +	preempt_enable();
>> +	vmx->msr_guest_fred_rsp0 = data;
>> +}
>>   #endif
> 
> Maybe add helpers to deal with the preemption stuff?  Oh, never mind, FRED

This is a good idea.

Do you want to upstream the following patch?

So I can rebase this patch on top of it in the next iteration.

> uses WRMSRNS.  Hmm, actually, can't these all be non-serializing?  KVM is
> progating *guest* values to hardware, so a VM-Enter is guaranteed before the
> CPU value can be consumed.

I see your point.  It seems that only a new MSR write instruction could
achieve this: consistently performing a non-serializing write to a MSR
with the assumption that the target is a guest MSR.  So software needs
to explicitly specify the type, host or guest, of the target MSR to the CPU.

(WRMSRNS writes to an MSR in either a serializing or non-serializing
manner, only based on its index.)

> 
> #ifdef CONFIG_X86_64
> static u64 vmx_read_guest_host_msr(struct vcpu_vmx *vmx, u32 msr, u64 *cache)
> {
> 	preempt_disable();
> 	if (vmx->guest_state_loaded)
> 		*cache = read_msr(msr);
> 	preempt_enable();
> 	return *cache;
> }
> 
> static u64 vmx_write_guest_host_msr(struct vcpu_vmx *vmx, u32 msr, u64 data,
> 				    u64 *cache)
> {
> 	preempt_disable();
> 	if (vmx->guest_state_loaded)
> 		wrmsrns(MSR_KERNEL_GS_BASE, data);
> 	preempt_enable();
> 	*cache = data;
> }
> 
> static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
> {
> 	return vmx_read_guest_host_msr(vmx, MSR_KERNEL_GS_BASE,
> 				       &vmx->msr_guest_kernel_gs_base);
> }
> 
> static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
> {
> 	vmx_write_guest_host_msr(vmx, MSR_KERNEL_GS_BASE, data,
> 				 &vmx->msr_guest_kernel_gs_base);
> }
> 
> static u64 vmx_read_guest_fred_rsp0(struct vcpu_vmx *vmx)
> {
> 	return vmx_read_guest_host_msr(vmx, MSR_IA32_FRED_RSP0,
> 				       &vmx->msr_guest_fred_rsp0);
> }
> 
> static void vmx_write_guest_fred_rsp0(struct vcpu_vmx *vmx, u64 data)
> {
> 	return vmx_write_guest_host_msr(vmx, MSR_IA32_FRED_RSP0, data,
> 				        &vmx->msr_guest_fred_rsp0);
> }
> #endif
> 
>> +#ifdef CONFIG_X86_64
>> +static u32 fred_msr_vmcs_fields[] = {
> 
> This should be const.

Will add.

> 
>> +	GUEST_IA32_FRED_RSP1,
>> +	GUEST_IA32_FRED_RSP2,
>> +	GUEST_IA32_FRED_RSP3,
>> +	GUEST_IA32_FRED_STKLVLS,
>> +	GUEST_IA32_FRED_SSP1,
>> +	GUEST_IA32_FRED_SSP2,
>> +	GUEST_IA32_FRED_SSP3,
>> +	GUEST_IA32_FRED_CONFIG,
>> +};
> 
> I think it also makes sense to add a static_assert() here, more so to help
> readers follow along than anything else.
> 
> static_assert(MSR_IA32_FRED_CONFIG - MSR_IA32_FRED_RSP1 ==
> 	      ARRAY_SIZE(fred_msr_vmcs_fields) - 1);

Good idea!

I tried to make fred_msr_to_vmcs() fail at build time, but couldn’t get
it to work.

> 
>> +
>> +static u32 fred_msr_to_vmcs(u32 msr)
>> +{
>> +	return fred_msr_vmcs_fields[msr - MSR_IA32_FRED_RSP1];
>> +}
>> +#endif
>> +
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> @@ -1849,6 +1852,23 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>>   
>>   		data = (u32)data;
>>   		break;
>> +	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
>> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
>> +			return 1;
> 
> Yeesh, this is a bit of a no-win situation.  Having to re-check the MSR index is
> no fun, but the amount of overlap between MSRs is significant, i.e. I see why you
> bundled everything together.  Ugh, and MSR_IA32_FRED_STKLVLS is buried smack dab
> in the middle of everything.
> 
>> +
>> +		/* Bit 11, bits 5:4, and bit 2 of the IA32_FRED_CONFIG must be zero */
> 
> Eh, the comment isn't helping much.  If we want to add more documentation, add
> #defines.  But I think we can documented the reserved behavior while also tidying
> up the code a bit.
> 
> After much fiddling, how about this?
> 
> 	case MSR_IA32_FRED_STKLVLS:
> 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
> 			return 1;
> 		break;			
> 
> 	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
> 	case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_CONFIG: {
> 		u64 reserved_bits;
> 
> 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
> 			return 1;
> 
> 		if (is_noncanonical_msr_address(data, vcpu))
> 			return 1;
> 
> 		switch (index) {
> 		case MSR_IA32_FRED_CONFIG:
> 			reserved_bits = BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2);
> 			break;
> 		case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
> 			reserved_bits = GENMASK_ULL(5, 0);
> 			break;
> 		case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_SSP3:
> 			reserved_bits = GENMASK_ULL(2, 0);
> 			break;
> 		default:
> 			WARN_ON_ONCE(1);
> 			return 1;
> 		}
> 		if (data & reserved_bits)
> 			return 1;
> 		break;
> 	}
> 

Easier to read, I will use it :)

Thanks!
     Xin

