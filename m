Return-Path: <kvm+bounces-53953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12359B1ABED
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 03:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CA0918A21AF
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 01:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 200411922FA;
	Tue,  5 Aug 2025 01:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UxdbScLe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397C0341AA;
	Tue,  5 Aug 2025 01:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754356267; cv=none; b=DwZwSv1k17U+r4HckCr0qGydw5ojMi//gRLYfTrs2KNZ25m88DKaOnmA69GfgsqLJG8geOC/765azpRSwnGMiM2NLDbWhW1wCOygj6jBUEeyz1u1HlOu9fNr6hyhL6BszH5rV/7oFFlmVpphpEaEACmtk9cOCKmYpXrU8OHgHz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754356267; c=relaxed/simple;
	bh=Q8eclBKC+Y5eKp2t/3rQb4iW+MQqhitRPf4lX/akBSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XVc0Rzno/S71HIKkSWcSafKZEH+8gbagJIjYIwMOEMEv/bp44RSn9/iH45gVGoYnntVusPn8dgH16YPb2XlNltmvaiIgyErFcyRNozPAEvr1R5LdjY+6jUVxvVCpFjNogvw2lI3KHHLrzuW9Q/EWgubafVr3SAAw7bboY0NdvGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UxdbScLe; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754356266; x=1785892266;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q8eclBKC+Y5eKp2t/3rQb4iW+MQqhitRPf4lX/akBSE=;
  b=UxdbScLe4X4QXZsLrRVc0C7hDvgZeSHrvLZdy3Pu4+eM/E50Eukk92nT
   oWMG0cxd3j/8hmc5NzZVgMk+AXro6q/mkFBYvq2xpsgXUNA3BPKusWTMJ
   HxbIdVXR+Dt7NB8hdAnhouEhOp+FPL55tt5b5zR5H3xj/8NcJj/jpy4FZ
   ZlUHafgvhC9Jr5VR8qPYD0uX80+5eMFEcza2PTZwvhlxSw+8R+ObQeRtM
   lR4GTwe3wn+i3RBBJRqoKj2a4btEOUkuqrEBNNsl1frrdpGZvbXuchACT
   jRuGB44XxbwPlhrJgvZd+2TkaRyM289LtZqY3adGt+oIcZhWy8b009ASc
   w==;
X-CSE-ConnectionGUID: qOPZQxMTSEihSFbH3hZjZA==
X-CSE-MsgGUID: zV1XW3H+S8qndMA8cgaZZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11512"; a="59250418"
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="59250418"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 18:11:04 -0700
X-CSE-ConnectionGUID: SpfHO0eYS9+bQZzYDC++Ug==
X-CSE-MsgGUID: cu90An5dQB2cmFV2Oadwaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="164305510"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 18:11:00 -0700
Message-ID: <f3db96ed-a06a-4eff-ae56-3c04566408bb@linux.intel.com>
Date: Tue, 5 Aug 2025 09:10:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/11] KVM: x86: Add emulation support for Extented LVT
 registers
To: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, mizhang@google.com,
 thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
References: <20250627162550.14197-1-manali.shukla@amd.com>
 <20250627162550.14197-5-manali.shukla@amd.com>
 <3b37d820-12cd-4f33-b059-66e12693b779@linux.intel.com>
 <afafc865-b42f-4a9d-82d7-a72de16bb47b@amd.com>
 <71d741d1-9250-4a64-b695-16f8bdc338e7@linux.intel.com>
 <e0af8ca8-c7ad-4ef9-a8eb-554593e07139@amd.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <e0af8ca8-c7ad-4ef9-a8eb-554593e07139@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/1/2025 5:33 PM, Manali Shukla wrote:
> On 7/17/2025 7:32 AM, Mi, Dapeng wrote:
>> On 7/16/2025 6:10 PM, Manali Shukla wrote:
>>> Hi Dapeng Mi,
>>>
>>> Thanks for reviewing my patches.
>>>
>>> On 7/15/2025 8:28 AM, Mi, Dapeng wrote:
>>>> On 6/28/2025 12:25 AM, Manali Shukla wrote:
>>>>> From: Santosh Shukla <santosh.shukla@amd.com>
>>>>>
>>>>> The local interrupts are extended to include more LVT registers in
>>>>> order to allow additional interrupt sources, like Instruction Based
>>>>> Sampling (IBS) and many more.
>>>>>
>>>>> Currently there are four additional LVT registers defined and they are
>>>>> located at APIC offsets 400h-530h.
>>>>>
>>>>> AMD IBS driver is designed to use EXTLVT (Extended interrupt local
>>>>> vector table) by default for driver initialization.
>>>>>
>>>>> Extended LVT registers are required to be emulated to initialize the
>>>>> guest IBS driver successfully.
>>>>>
>>>>> Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
>>>>> https://bugzilla.kernel.org/attachment.cgi?id=306250 for more details
>>>>> on Extended LVT.
>>>>>
>>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>>> Co-developed-by: Manali Shukla <manali.shukla@amd.com>
>>>>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>>>>> ---
>>>>>  arch/x86/include/asm/apicdef.h | 17 +++++++++
>>>>>  arch/x86/kvm/cpuid.c           |  6 +++
>>>>>  arch/x86/kvm/lapic.c           | 69 +++++++++++++++++++++++++++++++++-
>>>>>  arch/x86/kvm/lapic.h           |  1 +
>>>>>  arch/x86/kvm/svm/avic.c        |  4 ++
>>>>>  arch/x86/kvm/svm/svm.c         |  4 ++
>>>>>  6 files changed, 99 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
>>>>> index 094106b6a538..4c0f580578aa 100644
>>>>> --- a/arch/x86/include/asm/apicdef.h
>>>>> +++ b/arch/x86/include/asm/apicdef.h
>>>>> @@ -146,6 +146,23 @@
>>>>>  #define		APIC_EILVT_MSG_EXT	0x7
>>>>>  #define		APIC_EILVT_MASKED	(1 << 16)
>>>>>  
>>>>> +/*
>>>>> + * Initialize extended APIC registers to the default value when guest
>>>>> + * is started and EXTAPIC feature is enabled on the guest.
>>>>> + *
>>>>> + * APIC_EFEAT is a read only Extended APIC feature register, whose
>>>>> + * default value is 0x00040007. However, bits 0, 1, and 2 represent
>>>>> + * features that are not currently emulated by KVM. Therefore, these
>>>>> + * bits must be cleared during initialization. As a result, the
>>>>> + * default value used for APIC_EFEAT in KVM is 0x00040000.
>>>>> + *
>>>>> + * APIC_ECTRL is a read-write Extended APIC control register, whose
>>>>> + * default value is 0x0.
>>>>> + */
>>>>> +
>>>>> +#define		APIC_EFEAT_DEFAULT	0x00040000
>>>>> +#define		APIC_ECTRL_DEFAULT	0x0
>>>>> +
>>>>>  #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
>>>>>  #define APIC_BASE_MSR		0x800
>>>>>  #define APIC_X2APIC_ID_MSR	0x802
>>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>>> index eb7be340138b..7270d22fbf31 100644
>>>>> --- a/arch/x86/kvm/cpuid.c
>>>>> +++ b/arch/x86/kvm/cpuid.c
>>>>> @@ -458,6 +458,12 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>>>  	/* Invoke the vendor callback only after the above state is updated. */
>>>>>  	kvm_x86_call(vcpu_after_set_cpuid)(vcpu);
>>>>>  
>>>>> +	/*
>>>>> +	 * Initialize extended LVT registers at guest startup to support delivery
>>>>> +	 * of interrupts via the extended APIC space (offsets 0x400–0x530).
>>>>> +	 */
>>>>> +	kvm_apic_init_eilvt_regs(vcpu);
>>>>> +
>>>>>  	/*
>>>>>  	 * Except for the MMU, which needs to do its thing any vendor specific
>>>>>  	 * adjustments to the reserved GPA bits.
>>>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>>>> index 00ca2b0faa45..cffe44eb3f2b 100644
>>>>> --- a/arch/x86/kvm/lapic.c
>>>>> +++ b/arch/x86/kvm/lapic.c
>>>>> @@ -1624,9 +1624,13 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
>>>>>  }
>>>>>  
>>>>>  #define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
>>>>> +#define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) >> 4) - 0x40))
>>>> It seems there is no difference on the MASK definition between
>>>> APIC_REG_MASK() and APIC_REG_EXT_MASK(). Why not directly use the original
>>>> APIC_REG_MASK()?
>>>>
>>> The Extended LVT registers range from 0x400 to 0x530. When using
>>> APIC_REG_MASK(reg) with reg = 0x400 (as an example), the operation
>>> results in a right shift of 64(0x40) bits, causing an overflow. This was
>>> the actual reason of creating a new macro for extended APIC register space.
>> I see. Just ignored that the bit could extend 64 bits.
>>
>>
>>>> BTW, If we indeed need to define this new macro, could we define the macro
>>>> like blow?
>>>>
>>>> #define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) - 0x400) >> 4))
>>>>
>>>> It's more easily to understand. 
>>>>
>>> I can define the macro in this way.
>>>
>>>>>  #define APIC_REGS_MASK(first, count) \
>>>>>  	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
>>>>>  
>>>>> +#define APIC_LAST_REG_OFFSET		0x3f0
>>>>> +#define APIC_EXT_LAST_REG_OFFSET	0x530
>>>>> +
>>>>>  u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
>>>>>  {
>>>>>  	/* Leave bits '0' for reserved and write-only registers. */
>>>>> @@ -1668,6 +1672,8 @@ EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
>>>>>  static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>>>>>  			      void *data)
>>>>>  {
>>>>> +	u64 valid_reg_ext_mask = 0;
>>>>> +	unsigned int last_reg = APIC_LAST_REG_OFFSET;
>>>>>  	unsigned char alignment = offset & 0xf;
>>>>>  	u32 result;
>>>>>  
>>>>> @@ -1677,13 +1683,44 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>>>>>  	 */
>>>>>  	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
>>>>>  
>>>>> +	/*
>>>>> +	 * The local interrupts are extended to include LVT registers to allow
>>>>> +	 * additional interrupt sources when the EXTAPIC feature bit is enabled.
>>>>> +	 * The Extended Interrupt LVT registers are located at APIC offsets 400-530h.
>>>>> +	 */
>>>>> +	if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
>>>>> +		valid_reg_ext_mask =
>>>>> +			APIC_REG_EXT_MASK(APIC_EFEAT) |
>>>>> +			APIC_REG_EXT_MASK(APIC_ECTRL) |
>>>>> +			APIC_REG_EXT_MASK(APIC_EILVTn(0)) |
>>>>> +			APIC_REG_EXT_MASK(APIC_EILVTn(1)) |
>>>>> +			APIC_REG_EXT_MASK(APIC_EILVTn(2)) |
>>>>> +			APIC_REG_EXT_MASK(APIC_EILVTn(3));
>>>>> +		last_reg = APIC_EXT_LAST_REG_OFFSET;
>>>>> +	}
>>>> Why not move this code piece into kvm_lapic_readable_reg_mask() and
>>>> directly use APIC_REG_MASK() for these extended regs? Then we don't need to
>>>> modify the below code. 
>> I still think we should get a unified APIC reg mask even for the extended
>> APIC with kvm_lapic_readable_reg_mask() helper. We can extend current
>> kvm_lapic_readable_reg_mask() and let it return a 128 bits bitmap, maybe
>> like this,
>>
>> void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 *mask)
>>
>> This makes code more easily maintain. 
>>
>>
> Sorry for the delay.
>
> The reason why I am wary of this approach is because
> kvm_lapic_readable_reg_mask() is currently being used in
> vmx_update_msr_bitmap_x2apic(), where we directly use its return value:
>
>     if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
>         msr_bitmap[read_idx] =
> ~kvm_lapic_readable_reg_mask(vcpu->arch.apic);
>     else
>         msr_bitmap[read_idx] = ~0ull;
>     msr_bitmap[write_idx] = ~0ull;
>
> Where msr_bitmap is a u64 array.
>
> Changing kvm_lapic_readable_reg_mask() to return a 128-bit mask would
> require changes in vmx_update_msr_bitmap_x2apic() too.

Yes, I know. IMO, it's worth to do it. 


>
> - Manali
>

