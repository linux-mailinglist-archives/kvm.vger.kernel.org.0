Return-Path: <kvm+bounces-39081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E477A434DA
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2D2A3B4189
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 05:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34642566EE;
	Tue, 25 Feb 2025 05:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LavnUCvB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D389C36124;
	Tue, 25 Feb 2025 05:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740463013; cv=none; b=EbtKpM/mzMnxMVHDvew3SE5dQSJbRmPzs7CfNfpngxAlRc+jP5oz4Hu1o1BSXKm/+PwT03mb0+FpeETJB8UEC8E8nc8jCqzW5VvWBxSMqhwVEkQCKhLJv/XC2lww4S5A7EevnaLGBJ3M4kDeGh1c6YKrJnEW9XKLSi7lDOCeA1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740463013; c=relaxed/simple;
	bh=O0AZLPEFBpzWrpkL052RWCLjQ6UGpoQ8F1HUT4GvX3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BS2Ka/0UJErT2LAnpTFzMBG4F5/d7VMR+tb4qt851/mNWVXc97muWlzroRWqfTxcS6hlfltmtog2mFiYU/EOZL9RpBoRJch3QYVQMi4htuNcPkMezH9zu3iiuVl9cPKV3Xo46r7qlZbgST8HUjYpz2cgs/TOgMWoxGXep49COkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LavnUCvB; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740463011; x=1771999011;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O0AZLPEFBpzWrpkL052RWCLjQ6UGpoQ8F1HUT4GvX3k=;
  b=LavnUCvBkSxBMD2ECAv3/MkAggFidI1RVQf5lCzO/goLSV10ZBHcuwzw
   GAo4odL/dIrOhHnGqZRmO1R0rEdkUgklVMbgZzc8v7AFcEVxSn+3+2t5o
   U/N6rwLCbFwnOBge2adCBlCKFi3x7lLAY34rsNGONWOpShwp6vUIbHFnE
   NLfEUDRNuSAO4pTVN+xFJ6NASZxG6NPecVzhDxJUpmQye3VBaPi11QgOq
   PT/dOd7NZSb1ThKnXkfU3LnvVR5enuFoRDwGg+etxNH1aoSre8z9kpphR
   XnURgB7p5T40b7cSp7c9+sDYoNVuB5m+do0naCGF6YZ36gy2VwHksIIsq
   A==;
X-CSE-ConnectionGUID: 0KdYGRkcQ22pRVDtk6BV0A==
X-CSE-MsgGUID: mbzzeHMKTw2+tG4OKuicow==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="45036319"
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="45036319"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 21:56:51 -0800
X-CSE-ConnectionGUID: KJw0J1VNTSuc+ODJm2wyyw==
X-CSE-MsgGUID: Zr07HMDJRJqXKEkpzNv7Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="121386643"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 21:56:45 -0800
Message-ID: <27e31afd-2f8e-4f2e-92e3-92e52b956751@intel.com>
Date: Tue, 25 Feb 2025 13:56:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 02/12] KVM: x86: Allow the use of
 kvm_load_host_xsave_state() with guest_state_protected
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-3-adrian.hunter@intel.com>
 <01e85b96-db63-4de2-9f49-322919e054ec@intel.com>
 <96cc48a7-157b-4c42-a7d4-79181f55eed8@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <96cc48a7-157b-4c42-a7d4-79181f55eed8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/24/2025 7:38 PM, Adrian Hunter wrote:
> On 20/02/25 12:50, Xiaoyao Li wrote:
>> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>>> From: Sean Christopherson <seanjc@google.com>
>>>
>>> Allow the use of kvm_load_host_xsave_state() with
>>> vcpu->arch.guest_state_protected == true. This will allow TDX to reuse
>>> kvm_load_host_xsave_state() instead of creating its own version.
>>>
>>> For consistency, amend kvm_load_guest_xsave_state() also.
>>>
>>> Ensure that guest state that kvm_load_host_xsave_state() depends upon,
>>> such as MSR_IA32_XSS, cannot be changed by user space, if
>>> guest_state_protected.
>>>
>>> [Adrian: wrote commit message]
>>>
>>> Link: https://lore.kernel.org/r/Z2GiQS_RmYeHU09L@google.com
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>>> ---
>>> TD vcpu enter/exit v2:
>>>    - New patch
>>> ---
>>>    arch/x86/kvm/svm/svm.c |  7 +++++--
>>>    arch/x86/kvm/x86.c     | 18 +++++++++++-------
>>>    2 files changed, 16 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 7640a84e554a..b4bcfe15ad5e 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -4253,7 +4253,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>>>            svm_set_dr6(svm, DR6_ACTIVE_LOW);
>>>          clgi();
>>> -    kvm_load_guest_xsave_state(vcpu);
>>> +
>>> +    if (!vcpu->arch.guest_state_protected)
>>> +        kvm_load_guest_xsave_state(vcpu);
>>>          kvm_wait_lapic_expire(vcpu);
>>>    @@ -4282,7 +4284,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>>>        if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>>>            kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
>>>    -    kvm_load_host_xsave_state(vcpu);
>>> +    if (!vcpu->arch.guest_state_protected)
>>> +        kvm_load_host_xsave_state(vcpu);
>>>        stgi();
>>>          /* Any pending NMI will happen here */
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index bbb6b7f40b3a..5cf9f023fd4b 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -1169,11 +1169,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
>>>      void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>>>    {
>>> -    if (vcpu->arch.guest_state_protected)
>>> -        return;
>>> +    WARN_ON_ONCE(vcpu->arch.guest_state_protected);
>>>          if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
>>> -
>>>            if (vcpu->arch.xcr0 != kvm_host.xcr0)
>>>                xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>>>    @@ -1192,13 +1190,11 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>>>      void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>>>    {
>>> -    if (vcpu->arch.guest_state_protected)
>>> -        return;
>>> -
>>>        if (cpu_feature_enabled(X86_FEATURE_PKU) &&
>>>            ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>>>             kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
>>> -        vcpu->arch.pkru = rdpkru();
>>> +        if (!vcpu->arch.guest_state_protected)
>>> +            vcpu->arch.pkru = rdpkru();
>>
>> this needs justification.
> 
> It was proposed by Sean here:
> 
> 	https://lore.kernel.org/all/Z2WZ091z8GmGjSbC@google.com/
> 
> which is part of the email thread referenced by the "Link:" tag above

IMHO, this change needs to be put in patch 07, which is the better place 
to justify it.

>>
>>>            if (vcpu->arch.pkru != vcpu->arch.host_pkru)
>>>                wrpkru(vcpu->arch.host_pkru);
>>>        }
>>
>>
>>> @@ -3916,6 +3912,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>            if (!msr_info->host_initiated &&
>>>                !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>>                return 1;
>>> +
>>> +        if (vcpu->arch.guest_state_protected)
>>> +            return 1;
>>> +
>>
>> this and below change need to be a separate patch. So that we can discuss independently.
>>
>> I see no reason to make MSR_IA32_XSS special than other MSRs. When guest_state_protected, most of the MSRs that aren't emulated by KVM are inaccessible by KVM.
> 
> Yes, TDX will block access to MSR_IA32_XSS anyway because
> tdx_has_emulated_msr() will return false for MSR_IA32_XSS.
> 
> However kvm_load_host_xsave_state() is not TDX-specific code and it
> relies upon vcpu->arch.ia32_xss, so there is reason to block
> access to it when vcpu->arch.guest_state_protected is true.

It is TDX specific logic that TDX requires vcpu->arch.ia32_xss unchanged 
since TDX is going to utilize kvm_load_host_xsave_state() to restore 
host xsave state and relies on vcpu->arch.ia32_xss to be always the 
value of XFAM & XSS_MASK.

So please put this change into the TDX specific patch with the clear 
justfication.

>>
>>>            /*
>>>             * KVM supports exposing PT to the guest, but does not support
>>>             * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>>> @@ -4375,6 +4375,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>            if (!msr_info->host_initiated &&
>>>                !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>>                return 1;
>>> +
>>> +        if (vcpu->arch.guest_state_protected)
>>> +            return 1;
>>> +
>>>            msr_info->data = vcpu->arch.ia32_xss;
>>>            break;
>>>        case MSR_K7_CLK_CTL:
>>
> 


