Return-Path: <kvm+bounces-35441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1BB9A111A5
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 21:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CC167A182B
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 20:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DD520A5D5;
	Tue, 14 Jan 2025 20:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FfAtcbw5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BDA14A60C;
	Tue, 14 Jan 2025 20:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736885072; cv=none; b=UR9hRVRuEenpMa/ROfJIyO5fbx55Fkt2H7f+WAhUFHCSIKlLM23iGNEv57nCf/VOuaVNvym6GtsGHwLXOoN8NAOtwRe5iL1F6A5xyYAgVVZsfirA4elG4d2mK99HGs/N3k40fq+2vGcqMXZwXPv2EYNP82p9oWLQ4wpzp2nQJo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736885072; c=relaxed/simple;
	bh=qBgyUnC8kuMZBM6nCm7kGljKQgXw/ZnnBRz1djoNINk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nm9AJL2AavRGL/slk4gNMp05x3oWR2+2YCdRmMYtQVWlFbMHIXI1p3zTxkEP3TlP0wAf9zIOsuEview2gJQ/1/SSE6ntjorRlZyQjVH+PnyvAfhZ83r96CfGsW8+CtUogmC6Rvrk+JqvIjiPj7fKI+tXthwExl2nLRdfqoKGj7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FfAtcbw5; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736885071; x=1768421071;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qBgyUnC8kuMZBM6nCm7kGljKQgXw/ZnnBRz1djoNINk=;
  b=FfAtcbw5CJhwNGihfe+GuMKap7YcQHry9PqmHJhNJF4Z8+brfnlROE47
   TEB00XhSB03xe7gXzyYiMAEFCgMntrkG1ryt7GTKwSPYxPZ9AgI2bytre
   EMDTG5Arzvv+ZnRM0lyt4ak8PTsyI+sYli4wie7re1w9U0PRedFbmyM3t
   GUDP4qPBUF/b7TOROhS2+KGi5Rpud4spO/90xHgdFTsevMqBxX9NWF+WR
   5rUl2uk/wVt05PSo4zbFbe+bKqk53EzS8uw2H/cP2pD8UAnabTfuFh09+
   wT8Ck7bYvdtvzil7HALfb2EsRHv9D3wqqnEHkZyQfjhidU73ByZgPmc1G
   w==;
X-CSE-ConnectionGUID: E393fuk1RxqQHpJPPlOxDA==
X-CSE-MsgGUID: 1IepVzecTByOU3ctfjMdGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37429391"
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="37429391"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 12:04:30 -0800
X-CSE-ConnectionGUID: DhvYo1iXTuu/1KbEFTaqsQ==
X-CSE-MsgGUID: jOx2nyyTQUmzle6AsyWe+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="108965674"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 12:04:24 -0800
Message-ID: <51475a06-7775-4bbb-b53c-615796df8417@intel.com>
Date: Tue, 14 Jan 2025 22:04:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
 <Z2GiQS_RmYeHU09L@google.com>
 <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com>
 <Z2WZ091z8GmGjSbC@google.com>
 <96f7204b-6eb4-4fac-b5bb-1cd5c1fc6def@intel.com>
 <Z4Aff2QTJeOyrEUY@google.com>
 <3a7d93aa-781b-445e-a67a-25b0ffea0dff@intel.com>
 <Z4FZKOzXIdhLOlU8@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z4FZKOzXIdhLOlU8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/01/25 19:30, Sean Christopherson wrote:
> On Fri, Jan 10, 2025, Adrian Hunter wrote:
>> On 9/01/25 21:11, Sean Christopherson wrote:
>>> On Fri, Jan 03, 2025, Adrian Hunter wrote:
>>>> +static u64 tdx_guest_cr4(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>>>> +	u64 cr4;
>>>> +
>>>> +	rdmsrl(MSR_IA32_VMX_CR4_FIXED1, cr4);
>>>
>>> This won't be accurate long-term.  E.g. run KVM on hardware with CR4 bits that
>>> neither KVM nor TDX know about, and vcpu->arch.cr4 will end up with bits set that
>>> KVM think are illegal, which will cause it's own problems.
>>
>> Currently validation of CR4 is only done when user space changes it,
>> which should not be allowed for TDX.  For that it looks like TDX
>> would need:
>>
>> 	kvm->arch.has_protected_state = true;
>>
>> Not sure why it doesn't already?
> 
> Sorry, I didn't follow any of that.
> 
>>> For CR0 and CR4, we should be able to start with KVM's set of allowed bits, not
>>> the CPU's.  That will mean there will likely be missing bits, in vcpu->arch.cr{0,4},
>>> but if KVM doesn't know about a bit, the fact that it's missing should be a complete
>>> non-issue.
>>
>> What about adding:
>>
>> 	cr4 &= ~cr4_reserved_bits;
>>
>> and
>>
>> 	cr0 &= ~CR0_RESERVED_BITS
> 
> I was thinking a much more explicit:
> 
> 	vcpu->arch.cr4 = ~vcpu->arch.cr4_guest_rsvd_bits;
> 
> which if it's done in tdx_vcpu_init(), in conjunction with freezing the vCPU
> model (see below), should be solid.
> 
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index d2ea7db896ba..f2b1980f830d 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -1240,6 +1240,11 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>>>>  	u64 old_xcr0 = vcpu->arch.xcr0;
>>>>  	u64 valid_bits;
>>>>  
>>>> +	if (vcpu->arch.guest_state_protected) {
>>>
>>> This should be a WARN_ON_ONCE() + return 1, no?
>>
>> With kvm->arch.has_protected_state = true, KVM_SET_XCRS
>> would fail, which would probably be fine except for KVM selftests:
>>
>> Currently the KVM selftests expect to be able to set XCR0:
>>
>>     td_vcpu_add()
>> 	vm_vcpu_add()
>> 	    vm_arch_vcpu_add()
>> 		vcpu_init_xcrs()
>> 		    vcpu_xcrs_set()
>> 			vcpu_ioctl(KVM_SET_XCRS)
>> 			    __TEST_ASSERT_VM_VCPU_IOCTL(!ret)
>>
>> Seems like vm->arch.has_protected_state is needed for KVM selftests?
> 
> I doubt it's truly needed, my guess (without looking at the code) is that selftests
> are fudging around the fact that KVM doesn't stuff arch.xcr0.

Here is when it was added:

commit 8b14c4d85d031f7700fa4e042aebf99d933971f0
Author: Sean Christopherson <seanjc@google.com>
Date:   Thu Oct 3 16:43:31 2024 -0700

    KVM: selftests: Configure XCR0 to max supported value by default
    
    To play nice with compilers generating AVX instructions, set CR4.OSXSAVE
    and configure XCR0 by default when creating selftests vCPUs.  Some distros
    have switched gcc to '-march=x86-64-v3' by default, and while it's hard to
    find a CPU which doesn't support AVX today, many KVM selftests fail with

Is below OK to avoid it?

diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
index 972bb1c4ab4c..42925152ed25 100644
--- a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
@@ -12,20 +12,21 @@ extern bool is_forced_emulation_enabled;
 
 struct kvm_vm_arch {
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
 	vm_vaddr_t idt;
 
 	uint64_t c_bit;
 	uint64_t s_bit;
 	int sev_fd;
 	bool is_pt_protected;
+	bool has_protected_sregs;
 };
 
 static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
 {
 	return arch->c_bit || arch->s_bit;
 }
 
 #define vm_arch_has_protected_memory(vm) \
 	__vm_arch_has_protected_memory(&(vm)->arch)
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 0ed0768b1c88..89b70fe037d1 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -704,22 +704,25 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	 *
 	 * If this code is ever used to launch a vCPU with 32-bit entry point it
 	 * may need to subtract 4 bytes instead of 8 bytes.
 	 */
 	TEST_ASSERT(IS_ALIGNED(stack_vaddr, PAGE_SIZE),
 		    "__vm_vaddr_alloc() did not provide a page-aligned address");
 	stack_vaddr -= 8;
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
-	vcpu_init_sregs(vm, vcpu);
-	vcpu_init_xcrs(vm, vcpu);
+
+	if (!vm->arch.has_protected_sregs) {
+		vcpu_init_sregs(vm, vcpu);
+		vcpu_init_xcrs(vm, vcpu);
+	}
 
 	vcpu->initial_stack_addr = stack_vaddr;
 
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
 	regs.rflags = regs.rflags | 0x2;
 	regs.rsp = stack_vaddr;
 	vcpu_regs_set(vcpu, &regs);
 
 	/* Setup the MP state */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
index 16db4e97673e..da4bcfefdd70 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
@@ -477,25 +477,22 @@ static void load_td_boot_parameters(struct td_boot_parameters *params,
  * entering the TD first time.
  *
  * Input Args:
  *   vm - Virtual Machine
  *   vcpuid - The id of the VCPU to add to the VM.
  */
 struct kvm_vcpu *td_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id, void *guest_code)
 {
 	struct kvm_vcpu *vcpu;
 
-	/*
-	 * TD setup will not use the value of rip set in vm_vcpu_add anyway, so
-	 * NULL can be used for guest_code.
-	 */
-	vcpu = vm_vcpu_add(vm, vcpu_id, NULL);
+	vm->arch.has_protected_sregs = true;
+	vcpu = vm_arch_vcpu_add(vm, vcpu_id);
 
 	tdx_td_vcpu_init(vcpu);
 
 	load_td_boot_parameters(addr_gpa2hva(vm, TD_BOOT_PARAMETERS_GPA),
 				vcpu, guest_code);
 
 	return vcpu;
 }
 
 /**


