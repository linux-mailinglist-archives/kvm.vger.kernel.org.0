Return-Path: <kvm+bounces-62144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 669F8C38C0B
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 02:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D00318C586F
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 01:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A70238149;
	Thu,  6 Nov 2025 01:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GpGTV08x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B8121C9FD;
	Thu,  6 Nov 2025 01:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762394145; cv=none; b=GrAYoRvNo4XyQ8yehaYBrZ9E4fQfAAE/zpY1qicf6sNLzTfHZdm9k6udrajKTo31ApiqRctbS52Gz3HTDc15bwHXZ+5fRCfGspGhJ21j3vzMAY/XKozgeRZQFdwxj0n4shv3iTBygMjD3OqNOPTYMP5rrzclEARR857oNiitPPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762394145; c=relaxed/simple;
	bh=pRLZN8mGjbS1FREllnEA9ISH0/+3SzyEx0UzjRHUbuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eM3fTONfLOFZShKACBDJGHOSnwf7K9UotJ4hgjJ0nL7KtVTKvXFrv7IaTOqa+bPEEypK8Lw3Tjty9zg+wVdDbDuDRlIB6mDJDKOG4V0ApqRA9EsPGRNDOzem13AvnpjKPK8sEjJ9KqmRJga6vJ1H9pbfYFve0LsVL6GxgBz1qdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GpGTV08x; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762394144; x=1793930144;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pRLZN8mGjbS1FREllnEA9ISH0/+3SzyEx0UzjRHUbuc=;
  b=GpGTV08xxlO21wcPYpoBt361Te+/Fgovzv1CTQojZSpVEnxM0jz+tz14
   QSTba4tE5+h2Ug8Gkyu2eKnuKDBQ6gLzcpBk3kvj9BRiwptBc7VcmFdHq
   ymI6h0IKh24Q4NxFvDnvKCXE2jxnlyy2aUo+4wZRExlsO6jikBRP4eosp
   7OpS2rpbTovXEtaDibw3XDJg5JRPLHDrzwYPJLG79gAoTmoDaCg/WT40p
   3e4uxebdgOguOhrqV7a+4yn6laNfOHF1WpB12VPA7Cw0f3gfbK+7dzJou
   Hv5latikOCip53IdJt2YjP8Z/fIejWwWLVmEoQjxOkKWLLpG4CW55Uo1c
   g==;
X-CSE-ConnectionGUID: 57akyfHXRLCvGAZwzw9Hrw==
X-CSE-MsgGUID: hyp4wpMHQFKMucO3lAPRzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="75875550"
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="75875550"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 17:55:43 -0800
X-CSE-ConnectionGUID: JUHR9PThSVGDlsvXS1MlAg==
X-CSE-MsgGUID: B1q0o/X7S1StXv9phEUPoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="186910781"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 17:55:42 -0800
Message-ID: <7b30f2b5-5173-4c3b-85ff-dbfeda3c807a@linux.intel.com>
Date: Thu, 6 Nov 2025 09:55:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] KVM: x86: Load guest/host XCR0 and XSS outside of the
 fastpath run loop
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jon Kohler <jon@nutanix.com>
References: <20251030224246.3456492-1-seanjc@google.com>
 <20251030224246.3456492-4-seanjc@google.com>
 <88404ae2-fa4b-4357-918b-fd949dd2521a@linux.intel.com>
 <aQtiYwBYtsz6Whwz@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aQtiYwBYtsz6Whwz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/5/2025 10:43 PM, Sean Christopherson wrote:
> On Wed, Nov 05, 2025, Binbin Wu wrote:
>>
>> On 10/31/2025 6:42 AM, Sean Christopherson wrote:
>> [...]
>>> -void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>>> +static void kvm_load_guest_xfeatures(struct kvm_vcpu *vcpu)
>>>    {
>>>    	if (vcpu->arch.guest_state_protected)
>>>    		return;
>>>    	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
>>> -
>>>    		if (vcpu->arch.xcr0 != kvm_host.xcr0)
>>>    			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>>> @@ -1217,6 +1216,27 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>>>    		    vcpu->arch.ia32_xss != kvm_host.xss)
>>>    			wrmsrq(MSR_IA32_XSS, vcpu->arch.ia32_xss);
>>>    	}
>>> +}
>>> +
>>> +static void kvm_load_host_xfeatures(struct kvm_vcpu *vcpu)
>>> +{
>>> +	if (vcpu->arch.guest_state_protected)
>>> +		return;
>>> +
>>> +	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
>>> +		if (vcpu->arch.xcr0 != kvm_host.xcr0)
>>> +			xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
>>> +
>>> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
>>> +		    vcpu->arch.ia32_xss != kvm_host.xss)
>>> +			wrmsrq(MSR_IA32_XSS, kvm_host.xss);
>>> +	}
>>> +}
>> kvm_load_guest_xfeatures() and kvm_load_host_xfeatures() are almost the same
>> except for the guest values VS. host values to set.
>> I am wondering if it is worth adding a helper to dedup the code, like:
>>
>> static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, u64 xcr0, u64 xss)
>> {
>>          if (vcpu->arch.guest_state_protected)
>>                  return;
>>
>>          if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
>>                  if (vcpu->arch.xcr0 != kvm_host.xcr0)
>>                          xsetbv(XCR_XFEATURE_ENABLED_MASK, xcr0);
>>
>>                  if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
>>                      vcpu->arch.ia32_xss != kvm_host.xss)
>>                          wrmsrq(MSR_IA32_XSS, xss);
>>          }
>> }
> Nice!  I like it.  Want to send a proper patch (relative to this series)?  Or
> I can turn the above into a patch with a Suggested-by.  Either way works for me.
>
I can send a patch.

