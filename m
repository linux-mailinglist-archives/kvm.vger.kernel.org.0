Return-Path: <kvm+bounces-57163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 665CAB50AAB
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 04:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20FC3161E44
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 02:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2BB22DFA5;
	Wed, 10 Sep 2025 02:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZcP96CAh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061FF14F9FB;
	Wed, 10 Sep 2025 02:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757469785; cv=none; b=i6O5RpI7GLteQcP/a3CuOzkIxqyfb9Iyrd5R5+TN4LPEzZSnJ4klYyWF4cB6mEr+aUggYbWFuB9hiBsbZ9gOjROBvTrJ8Mh6G1KaVcS+pLMvY/A9qBZWdyzujJ+FZF7DkhQ7cXtF+BKURP6PnVw9IMAp05VESCBFWo7X8kFVROA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757469785; c=relaxed/simple;
	bh=yQC5/Pr9dIleX6ToR5xP6NjHGoOIn0D5FwPIi+ZIUXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UQFDtuFAEkY1QQ5Cf3GVUJD71nyMQhvrWdY4ws/p4jWlza4Umm7jyFdOhRy20cDIxvjHO3CMOSbEKUE4cHlRBht0KU9MTaT3emQ0KctOsS+o3kiMUedsp/MNfbQbW6n/jtwrb+DAPYfvljGCfxieIeGP2oFFtZVJR7xN700Zlvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZcP96CAh; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757469784; x=1789005784;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yQC5/Pr9dIleX6ToR5xP6NjHGoOIn0D5FwPIi+ZIUXE=;
  b=ZcP96CAhoqooSiHU0sL5Wp7g92+jS7BR+93+37ejtxlCsrlGZstIECRU
   BIrMt/OchRwYzdIFbNVwxRVkBydz7JlaRwM92RvZ40DspF0Ar9xidu68L
   pRhPxmNB+mqvd7lpJC/Fn/gCHMkY2FxnzYp1mmo/3PttnHejlJC+sBJH9
   oKZTLkoeYk1srApw/+1hrKiLoCJMRb9jOFtAlmbGthrZpC8MovFP9GPOh
   gK4u7YEWpzepUIduaTv+cuWAgu+fATro+XWysZwT92WOBwocm5HWLyAo9
   aDezS4jj7jJFuSZvuc8i8VTdGiY2Ul5Xl9iSqe1rRCMsdp03U80W97LBa
   A==;
X-CSE-ConnectionGUID: k1fZdoU1S9ClKm/jAWOKuQ==
X-CSE-MsgGUID: iVXjUoyKTZKETPJR+oUfFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63599824"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63599824"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 19:03:04 -0700
X-CSE-ConnectionGUID: IpTMBQPHTuOmy+/ArxaHJw==
X-CSE-MsgGUID: 0RVQFBxYR1+QCKDB/a25tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="196924902"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 19:03:01 -0700
Message-ID: <9fa411a9-08d2-44fa-8ef8-18d3f2c8acad@linux.intel.com>
Date: Wed, 10 Sep 2025 10:02:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] KVM: TDX: Do not retry locally when the retry is
 caused by invalid memslot
To: Sean Christopherson <seanjc@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com,
 reinette.chatre@intel.com, rick.p.edgecombe@intel.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250822070305.26427-1-yan.y.zhao@intel.com>
 <20250822070523.26495-1-yan.y.zhao@intel.com>
 <2257f7a6-e4f5-4b90-bb18-cb0af756323f@linux.intel.com>
 <aMA3LjGP9nezNM7e@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aMA3LjGP9nezNM7e@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/2025 10:18 PM, Sean Christopherson wrote:
> On Tue, Sep 09, 2025, Binbin Wu wrote:
>> On 8/22/2025 3:05 PM, Yan Zhao wrote:
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index 6784aaaced87..de2c4bb36069 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -1992,6 +1992,11 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>>>    	 * blocked by TDs, false positives are inevitable i.e., KVM may re-enter
>>>    	 * the guest even if the IRQ/NMI can't be delivered.
>>>    	 *
>>> +	 * Breaking out of the local retries if a retry is caused by faulting
>>> +	 * in an invalid memslot (indicating the slot is under removal), so that
>>> +	 * the slot removal will not be blocked due to waiting for releasing
>>> +	 * SRCU lock in the VMExit handler.
>>> +	 *
>>>    	 * Note: even without breaking out of local retries, zero-step
>>>    	 * mitigation may still occur due to
>>>    	 * - invoking of TDH.VP.ENTER after KVM_EXIT_MEMORY_FAULT,
>>> @@ -2002,6 +2007,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>>>    	 * handle retries locally in their EPT violation handlers.
>>>    	 */
>>>    	while (1) {
>>> +		struct kvm_memory_slot *slot;
>>> +
>>>    		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
>>>    		if (ret != RET_PF_RETRY || !local_retry)
>>> @@ -2015,6 +2022,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>>>    			break;
>>>    		}
>>> +		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
>>> +		if (slot && slot->flags & KVM_MEMSLOT_INVALID)
>> The slot couldn't be NULL here, right?
> Uh, hmm.  It could be NULL.  If the memslot deletion starts concurrently with the
> S-EPT violation, then the memslot could be transitioned to INVALID (prepared for
> deletion) prior to the vCPU acquiring SRCU after the VM-Exit.  Memslot deletion
> could then assign to kvm->memslots with a NULL memslot.
>
>    vCPU                          DELETE
>    S-EPT Violation
>                                  Set KVM_MEMSLOT_INVALID
>                                  synchronize_srcu_expedited()
>    Acquire SRCU
>    __vmx_handle_ept_violation()
>    RET_PF_RETRY due to INVALID
>                                  Set memslot NULL
>    kvm_vcpu_gfn_to_memslot()
Got it, thanks!

