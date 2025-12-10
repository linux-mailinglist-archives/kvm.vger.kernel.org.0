Return-Path: <kvm+bounces-65637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A0310CB1946
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 02:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5A4813015E12
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C4122128B;
	Wed, 10 Dec 2025 01:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oevo+BJi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379EB2153D8;
	Wed, 10 Dec 2025 01:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765328945; cv=none; b=nlmKYQeKxXc5oKDRpGXic0LiOm11tqSpgw3qWFR16qAo+GHASQffiGKmTMxrgLTqCEU0WyFcnVxpe4Tkr3/7dF4kuH7gbtD+JTHq1tAEuo2fjekZTq+6iwODjJzg8CNTtpSHQn0WiSDpVwhfT3zXEYVoHpVfKHT2FwXOADe5jxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765328945; c=relaxed/simple;
	bh=7Sw6PITpzapkD99/tAnwNI3D6Ucw9JU8bsiOsehlJts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pAN3drOj1/1rDrXTLRWa5X9nCpl1dic7/COmEmaIMHIbPDNlNK321uL6D9deIj3wSDAxiy3xMSoEVtufd1Pa2RHAX602T8e4W+U/91ee3jxiQt9cjQOu/JOvLWibIldkCQlwmQyQ2f1QfI1mJRQggrokq7mCcQHpHtj4AGembHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oevo+BJi; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765328943; x=1796864943;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7Sw6PITpzapkD99/tAnwNI3D6Ucw9JU8bsiOsehlJts=;
  b=Oevo+BJiqpvQMUoRJM5hp4O2KdQgYEHYW90HTJ+FUTCqhV+OFrksovyi
   lPTXxNJgOJI8ahA7H8sq2EnTl7dq6IuBjnY4iEXBRkYUMisgqdsEmqKpK
   A/uSce8HsUC9I5sDv+3emnId7YMOdXr9HkQ3yrLtbw6cDIZvwpcaF+bJn
   NkPzpWldT8011xQs7IfyMeD2Dp3SVnAJE1O5WlJttV90Dz5bv+AplzQz/
   b6t++/7z5miGAz8yZvb2yTJocfB0A1wvfDpRyt/rf6yc2EMxJpFjxqgEB
   +Pul5NNqydPqjGxWUZ0+t88pY4tvm9L+kcSdZ8w2d/aRRFDeSLbAj8OEP
   g==;
X-CSE-ConnectionGUID: 1znDVrjwS5i1agx3fvuqgA==
X-CSE-MsgGUID: 48WqWwhnQk6DjmUYq9mwbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67190219"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67190219"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 17:09:02 -0800
X-CSE-ConnectionGUID: 21iGYDOORw+11NIMlPnpaw==
X-CSE-MsgGUID: WFDJ3r6bSDGlQ9mRnDj7FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="200862410"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 17:08:54 -0800
Message-ID: <fad66209-6dc1-4067-87df-9aa1105e3017@linux.intel.com>
Date: Wed, 10 Dec 2025 09:08:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 37/44] KVM: VMX: Dedup code for removing MSR from
 VMCS's auto-load list
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>,
 Sandipan Das <sandipan.das@amd.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-38-seanjc@google.com>
 <2440b9bf-a2a1-4f66-94b2-71f47d62f3db@linux.intel.com>
 <aTheSQb9fhXmZKw6@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aTheSQb9fhXmZKw6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 12/10/2025 1:37 AM, Sean Christopherson wrote:
> On Mon, Dec 08, 2025, Dapeng Mi wrote:
>> On 12/6/2025 8:17 AM, Sean Christopherson wrote:
>>> Add a helper to remove an MSR from an auto-{load,store} list to dedup the
>>> msr_autoload code, and in anticipation of adding similar functionality for
>>> msr_autostore.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>  arch/x86/kvm/vmx/vmx.c | 31 ++++++++++++++++---------------
>>>  1 file changed, 16 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 52bcb817cc15..a51f66d1b201 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -1040,9 +1040,22 @@ static int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr)
>>>  	return -ENOENT;
>>>  }
>>>  
>>> +static void vmx_remove_auto_msr(struct vmx_msrs *m, u32 msr,
>>> +				unsigned long vmcs_count_field)
>>> +{
>>> +	int i;
>>> +
>>> +	i = vmx_find_loadstore_msr_slot(m, msr);
>>> +	if (i < 0)
>>> +		return;
>>> +
>>> +	--m->nr;
>>> +	m->val[i] = m->val[m->nr];
>> Sometimes the order of MSR writing does matter, e.g., PERF_GLOBAL_CTRL MSR
>> should be written at last after all PMU MSR writing.
> Hmm, no.  _If_ KVM were writing event selectors using the auto-load lists, then
> KVM would need to bookend the event selector MSRs with PERF_GLOBAL_CTRL=0 and
> PERF_GLOBAL_CTRL=<new context (guest vs. host)>.  E.g. so that guest PMC counts
> aren't polluted with host events, and vice versa.
>
> As things stand today, the only other MSRs are PEBS and the DS area configuration
> stuff, and kinda to my earlier point, KVM pre-zeroes MSR_IA32_PEBS_ENABLE as part
> of add_atomic_switch_msr() to ensure a quiescent period before VM-Enter.
>
> Heh, and writing PERF_GLOBAL_CTRL last for that sequence might actually be
> problematic.  E.g. load host PEBS with guest PERF_GLOBAL_CTRL active.
>
> Anyways, I agree that this might be brittle, but this is all pre-existing behavior
> so I don't want to tackle that here unless it's absolutely necessary.

Yeah, this won't cause any real issue for current code. 


>
> Or wait, by "writing" do you mean "writing MSRs to memory", as opposed to "writing
> values to MSRs"?  Regardless, I think my answer is the same: this isn't a problem
> today, so I'd prefer to not shuffle the ordering unless it's absolutely necessary.

Actually both. As SDM suggests, current any manipulation for PMU MSRs, the
below order should be followed.

- disable all PMU counters by writing PERF_GLOBAL_CTRL to 0.

- manipulate PMU MSRs.

- Enable the needed PMU counters by writing PERF_GLOBAL_CTRL.

So there is a implicit order on the MSR writing in fact. 

For KVM, if MSR auto-load list feature is used to automatically restore the
host/guest MSRs, KVM needs to follow the above order to fill the MSR
auto-load list and then expect these MSRs are written by VMX in the
designed order.

But since it won't cause any real issue now, it's fine for me to handle it
until there is a real necessity.


>
>> So directly moving the last MSR entry into cleared one could break the MSR
>> writing sequence and may cause issue in theory.
>>
>> I know this won't really cause issue since currently vPMU won't use the MSR
>> auto-load feature to save any PMU MSR, but it's still unsafe for future uses. 
>>
>> I'm not sure if it's worthy to do the strict MSR entry shift right now.
>>
>> Perhaps we could add a message to warn users at least.
> Hmm, yeah, but I'm not entirely sure where/how best to document this.  Because
> it's not just that vmx_remove_auto_msr() arbitrarily maniuplates the order, e.g.
> multiple calls to vmx_add_auto_msr() aren't guaranteed to provide ordering because
> one or more MSRs may already be in the list.  And the "special" MSRs that can be
> switched via dedicated VMCS fields further muddy the waters.
>
> So I'm tempted to not add a comment to the helpers, or even the struct fields,
> because unfortunately it's largely a "Here be dragons!" type warning. :-/

I see. Thanks.



