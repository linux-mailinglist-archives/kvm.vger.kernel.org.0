Return-Path: <kvm+bounces-35057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2060A0946F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 15:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DE0F3A428A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92EB21324D;
	Fri, 10 Jan 2025 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bpRRtW2V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CD5213248;
	Fri, 10 Jan 2025 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736520649; cv=none; b=aFD2W3kPs5gl4eFWzx2lu0qHi1f0dZJeUgjYmEQVSidHSEZ+RZYrm5C5uJlww99oOmfgdK1ITnjGgJs9+08cs0ztSLzhjhbnGpDBsHd05F/ARaS5qoReH9B74PiJ+mw/ptyIoRwre3gIe095lfPhb9ISRsGtNUX+zy/wJ3c8OZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736520649; c=relaxed/simple;
	bh=Nr/8cWy/ytkiwzuzf0dij57Q7S3zOYs/c6vUQnl9qDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CqTwmbAvsQg4AWf3jrerCTtLsczl3IaRBmplL3pOYnvqY73BNQhER4mgKNoBR9GO1YjUVadUX8Tgn8V5CYGtPKkfmeJ2MgP8WCRwMlL0U0FTibM1AuJKfK3izNJmTcLyZn4fJdobXo/FjBvGSLy0/SMEhpnpaZrftmg1JVFxGpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bpRRtW2V; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736520648; x=1768056648;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Nr/8cWy/ytkiwzuzf0dij57Q7S3zOYs/c6vUQnl9qDA=;
  b=bpRRtW2Vi6ctJuNqM8azCQU6KqVX/eVBZkY6qs/Xk1ItEEyTQ+Jr43d4
   Bx63TzuHo0cQzZR9DSBJbXl+BD0Sy8RILtpqQZ+tAiGJY6R6SKzWRezmt
   ebBdSPA1fl455ttxkx3QjdPJzuNA0yvSj41JJi7qOMI6r7/XtVGy5v8ce
   mtFOzm7OmJqwMQBqjrsnTCduna9ktLHPMO+OOL2Au709VuX7zgcFiWiIS
   rC04FWp5lhfLBAP5dL5ptu7oR3zr0odl/gc83PxfPFF4zEE6JfXAq8pE3
   M0bZxhgoZ444fK/l1YO4bTKiJ9VLp2y/rud5Rvw3FSTScAN5LMzRiKSBO
   A==;
X-CSE-ConnectionGUID: vcjPv2FETeuOI4iTitXEEA==
X-CSE-MsgGUID: tNvOTbRSRdi+YD3dtjKP0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11311"; a="24421523"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="24421523"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 06:50:47 -0800
X-CSE-ConnectionGUID: 9n43q5iXSCyhI9kmCTNqcg==
X-CSE-MsgGUID: ozaw/qF7TUOCS8gViZDNEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="108852253"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.163])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 06:50:41 -0800
Message-ID: <3a7d93aa-781b-445e-a67a-25b0ffea0dff@intel.com>
Date: Fri, 10 Jan 2025 16:50:33 +0200
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
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z4Aff2QTJeOyrEUY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/01/25 21:11, Sean Christopherson wrote:
> On Fri, Jan 03, 2025, Adrian Hunter wrote:
>> On 20/12/24 18:22, Sean Christopherson wrote:
>> +/* Set a maximal guest CR0 value */
>> +static u64 tdx_guest_cr0(struct kvm_vcpu *vcpu, u64 cr4)
>> +{
>> +	u64 cr0;
>> +
>> +	rdmsrl(MSR_IA32_VMX_CR0_FIXED1, cr0);
>> +
>> +	if (cr4 & X86_CR4_CET)
>> +		cr0 |= X86_CR0_WP;
>> +
>> +	cr0 |= X86_CR0_PE | X86_CR0_NE;
>> +	cr0 &= ~(X86_CR0_NW | X86_CR0_CD);
>> +
>> +	return cr0;
>> +}
>> +
>> +/*
>> + * Set a maximal guest CR4 value. Clear bits forbidden by XFAM or
>> + * TD Attributes.
>> + */
>> +static u64 tdx_guest_cr4(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>> +	u64 cr4;
>> +
>> +	rdmsrl(MSR_IA32_VMX_CR4_FIXED1, cr4);
> 
> This won't be accurate long-term.  E.g. run KVM on hardware with CR4 bits that
> neither KVM nor TDX know about, and vcpu->arch.cr4 will end up with bits set that
> KVM think are illegal, which will cause it's own problems.

Currently validation of CR4 is only done when user space changes it,
which should not be allowed for TDX.  For that it looks like TDX
would need:

	kvm->arch.has_protected_state = true;

Not sure why it doesn't already?

> 
> For CR0 and CR4, we should be able to start with KVM's set of allowed bits, not
> the CPU's.  That will mean there will likely be missing bits, in vcpu->arch.cr{0,4},
> but if KVM doesn't know about a bit, the fact that it's missing should be a complete
> non-issue.

What about adding:

	cr4 &= ~cr4_reserved_bits;

and

	cr0 &= ~CR0_RESERVED_BITS
> 
> That also avoids weirdness for things like user-mode interrupts, LASS, PKS, etc.,
> where KVM is open coding the bits.  The downside is that we'll need to remember
> to update TDX when enabling those features to account for kvm_tdx->attributes,
> but that's not unreasonable.
> 
>> +
>> +	if (!(kvm_tdx->xfam & XFEATURE_PKRU))
>> +		cr4 &= ~X86_CR4_PKE;
>> +
>> +	if (!(kvm_tdx->xfam & XFEATURE_CET_USER) || !(kvm_tdx->xfam & BIT_ULL(12)))
>> +		cr4 &= ~X86_CR4_CET;
>> +
>> +	/* User Interrupts */
>> +	if (!(kvm_tdx->xfam & BIT_ULL(14)))
>> +		cr4 &= ~BIT_ULL(25);
>> +
>> +	if (!(kvm_tdx->attributes & TDX_TD_ATTR_LASS))
>> +		cr4 &= ~BIT_ULL(27);
>> +
>> +	if (!(kvm_tdx->attributes & TDX_TD_ATTR_PKS))
>> +		cr4 &= ~BIT_ULL(24);
>> +
>> +	if (!(kvm_tdx->attributes & TDX_TD_ATTR_KL))
>> +		cr4 &= ~BIT_ULL(19);
>> +
>> +	cr4 &= ~X86_CR4_SMXE;
>> +
>> +	return cr4;
>> +}
>> +
>>  int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>> @@ -732,8 +783,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>>  	vcpu->arch.cr0_guest_owned_bits = -1ul;
>>  	vcpu->arch.cr4_guest_owned_bits = -1ul;
>>  
>> -	vcpu->arch.cr4 = <maximal value>;
>> -	vcpu->arch.cr0 = <maximal value, give or take>;
>> +	vcpu->arch.cr4 = tdx_guest_cr4(vcpu);
>> +	vcpu->arch.cr0 = tdx_guest_cr0(vcpu, vcpu->arch.cr4);
>>  
>>  	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
>>  	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
>> @@ -767,6 +818,12 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>>  	return 0;
>>  }
>>  
>> +void tdx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>> +{
>> +	if (cpu_feature_enabled(X86_FEATURE_XSAVES))
> 
> This should use kvm_cpu_caps_has(), because strictly speaking it's KVM support
> that matters.  In practice, I don't think it matters for XSAVES, but it can
> matter for other features (though probably not for TDX guests).
> 
>> +		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
>> +}
>> +
>>  void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>  {
>>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> @@ -933,6 +990,24 @@ static void tdx_user_return_msr_update_cache(void)
>>  						 tdx_uret_msrs[i].defval);
>>  }
>>  
>> +static void tdx_reinforce_guest_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>> +
>> +	if (WARN_ON_ONCE(vcpu->arch.xcr0 != (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK)))
>> +		vcpu->arch.xcr0 = kvm_tdx->xfam & TDX_XFAM_XCR0_MASK;
>> +	if (WARN_ON_ONCE(vcpu->arch.ia32_xss != (kvm_tdx->xfam & TDX_XFAM_XSS_MASK)))
>> +		vcpu->arch.ia32_xss = kvm_tdx->xfam & TDX_XFAM_XSS_MASK;
>> +	if (WARN_ON_ONCE(vcpu->arch.pkru))
>> +		vcpu->arch.pkru = 0;
>> +	if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_XSAVE) &&
>> +			 !kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)))
>> +		vcpu->arch.cr4 |= X86_CR4_OSXSAVE;
>> +	if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_XSAVES) &&
>> +			 !guest_can_use(vcpu, X86_FEATURE_XSAVES)))
>> +		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
>> +}
>> +
>>  static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> @@ -1028,9 +1103,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>  		update_debugctlmsr(tdx->host_debugctlmsr);
>>  
>>  	tdx_user_return_msr_update_cache();
>> +
>> +	tdx_reinforce_guest_state(vcpu);
> 
> Hmm, I don't think fixing up guest state is a good idea.  It probably works?
> But continuing on when we know there's a KVM bug *and* a chance for host data
> corruption seems unnecessarily risky.
> 
> My vote would to KVM_BUG_ON() before entering the guest.  I think I'd also be ok
> omitting the checks, it's not like the potential for KVM bugs that clobber KVM's
> view of state are unique to TDX (though I do agree that the behavior of the TDX
> module in this case does make them more likely).

If the guest state that is vital to host state restoration, goes wrong
then the machine can die without much explanation, so KVM_BUG_ON() before
entering the guest seems prudent.

> 
>>  	kvm_load_host_xsave_state(vcpu);
>>  
>> -	vcpu->arch.regs_avail = TDX_REGS_UNSUPPORTED_SET;
>> +	vcpu->arch.regs_avail = ~0;
>>  
>>  	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
>>  		return EXIT_FASTPATH_NONE;
>> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
>> index 861c0f649b69..2e0e300a1f5e 100644
>> --- a/arch/x86/kvm/vmx/tdx_arch.h
>> +++ b/arch/x86/kvm/vmx/tdx_arch.h
>> @@ -110,6 +110,7 @@ struct tdx_cpuid_value {
>>  } __packed;
>>  
>>  #define TDX_TD_ATTR_DEBUG		BIT_ULL(0)
>> +#define TDX_TD_ATTR_LASS		BIT_ULL(27)
>>  #define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(28)
>>  #define TDX_TD_ATTR_PKS			BIT_ULL(30)
>>  #define TDX_TD_ATTR_KL			BIT_ULL(31)
>> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
>> index 7fb1bbf12b39..7f03a6a24abc 100644
>> --- a/arch/x86/kvm/vmx/x86_ops.h
>> +++ b/arch/x86/kvm/vmx/x86_ops.h
>> @@ -126,6 +126,7 @@ void tdx_vm_free(struct kvm *kvm);
>>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>>  
>>  int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>> +void tdx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
>>  void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>>  void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>>  int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
>> @@ -170,6 +171,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
>>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>>  
>>  static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>> +static inline void tdx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu) {}
>>  static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>>  static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
>>  static inline int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index d2ea7db896ba..f2b1980f830d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1240,6 +1240,11 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>>  	u64 old_xcr0 = vcpu->arch.xcr0;
>>  	u64 valid_bits;
>>  
>> +	if (vcpu->arch.guest_state_protected) {
> 
> This should be a WARN_ON_ONCE() + return 1, no?

With kvm->arch.has_protected_state = true, KVM_SET_XCRS
would fail, which would probably be fine except for KVM selftests:

Currently the KVM selftests expect to be able to set XCR0:

    td_vcpu_add()
	vm_vcpu_add()
	    vm_arch_vcpu_add()
		vcpu_init_xcrs()
		    vcpu_xcrs_set()
			vcpu_ioctl(KVM_SET_XCRS)
			    __TEST_ASSERT_VM_VCPU_IOCTL(!ret)

Seems like vm->arch.has_protected_state is needed for
KVM selftests?

> 
>> +		kvm_update_cpuid_runtime(vcpu);

And kvm_update_cpuid_runtime() never gets called otherwise.
Not sure where would be a good place to call it.

>> +		return 0;
>> +	}
>> +
>>  	/* Only support XCR_XFEATURE_ENABLED_MASK(xcr0) now  */
>>  	if (index != XCR_XFEATURE_ENABLED_MASK)
>>  		return 1;
>> @@ -12388,7 +12393,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>  	 * into hardware, to be zeroed at vCPU creation.  Use CRs as a sentinel
>>  	 * to detect improper or missing initialization.
>>  	 */
>> -	WARN_ON_ONCE(!init_event &&
>> +	WARN_ON_ONCE(!init_event && !vcpu->arch.guest_state_protected &&
>>  		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
> 
> Maybe stuff state in tdx_vcpu_init() to avoid this waiver?  KVM is already
> deferring APIC base and RCX initialization to that point, waiting to stuff all
> TDX-specific vCPU state seems natural.


