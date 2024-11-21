Return-Path: <kvm+bounces-32234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B4FD9D4604
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 04:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 211AB282D4D
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 03:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8156D7083A;
	Thu, 21 Nov 2024 03:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RenuXPdJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DDC33F9;
	Thu, 21 Nov 2024 03:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732158131; cv=none; b=iVzjFfMVquR15ytZ2e7CcssDlRyBwyMQZ4SBHquukq1zIpUjB2q2iLPYe9Y5Bn/EANNcHGn8blgCN8oqvXjDXImLM7DWlUMEoBk0VbQ/C7PhQEGN3b7bkxqwLXqAibfRVs5VwhNra2f6peVbN+5OHfdGBY/Aeu52Urh06kYSnkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732158131; c=relaxed/simple;
	bh=94NhdbQwCb3ltf60bMqydvxwaDbCG4+Dd89YO3dFSK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EPBWAPWYFLykjYWbXkyK+q/mBwL4YHw1pXF8HC4hnMcuwHHMultQX+mBSAYaRoMCMPOPjJyvLsu1qQF1Lcm9Eydg26SJSLmBYqnImV6hQBh17qtEt8YRNSedMIXIp9MF1Dh/7ffWtsghkG5v1e0AD7z/p0kRqol7AURFFdA2O1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RenuXPdJ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732158130; x=1763694130;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=94NhdbQwCb3ltf60bMqydvxwaDbCG4+Dd89YO3dFSK0=;
  b=RenuXPdJ5jCQQxQ9BL/m5Bsc7HUyUv9LjgNCUdSuulZhY3NE6/JeBy/E
   7+epDYu5vtEEs8Cbbv7ghpCRkXsYdSIc246Hw89gJLss4BASNUdiAQVYZ
   yA2oUn2qtz7fXuQT8f4ykOggfR7/K27e7Mm3LOkMsvhFMghODc1Ax9hfn
   UOZZ4Q1KN+5BabOsHx25zYFlxvjxTOBQY0k7h5KY46idGYi+cvqJK8nAf
   kE0q4E8g1UaGXMRxr6Lz7WBJSzzXledssKpern+rIX0LnOtYZM+mN9FXr
   WCS3hdbYhM2evtujoS07yjI1MqwrtgAtWOcsMtavOgMb2iyR9c5UzOTb0
   g==;
X-CSE-ConnectionGUID: iioZjW38RP+gsOpG5vdQkQ==
X-CSE-MsgGUID: KwOivDx8RTyUQcqlIgIfCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="54747110"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="54747110"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:02:10 -0800
X-CSE-ConnectionGUID: rzlEauBISMy7GfH7GYWT5w==
X-CSE-MsgGUID: qTz815x7S6SeQvNPQ3M/UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="89916302"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:02:04 -0800
Message-ID: <2a0841ef-fdaa-4397-b021-e18ad056c432@linux.intel.com>
Date: Thu, 21 Nov 2024 11:02:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 46/58] KVM: x86/pmu: Disconnect counter reprogram
 logic from passthrough PMU
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-47-mizhang@google.com> <Zz5JW-LGL4tvB2r8@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz5JW-LGL4tvB2r8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 4:40 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Disconnect counter reprogram logic because passthrough PMU never use host
>> PMU nor does it use perf API to do anything. Instead, when passthrough PMU
>> is enabled, touching anywhere around counter reprogram part should be an
>> error.
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  arch/x86/kvm/pmu.c | 3 +++
>>  arch/x86/kvm/pmu.h | 8 ++++++++
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 3604cf467b34..fcd188cc389a 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -478,6 +478,9 @@ static int reprogram_counter(struct kvm_pmc *pmc)
>>  	bool emulate_overflow;
>>  	u8 fixed_ctr_ctrl;
>>  
>> +	if (WARN_ONCE(pmu->passthrough, "Passthrough PMU never reprogram counter\n"))
> Eh, a WARN_ON_ONCE() is enough.
>
> That said, this isn't entirely correct.  The mediated PMU needs to "reprogram"
> event selectors if the event filter is changed. KVM currently handles this by
> setting  all __reprogram_pmi bits and blasting KVM_REQ_PMU.
>
> LOL, and there's even a reprogram_fixed_counters_in_passthrough_pmu(), so the
> above message is a lie.
>
> There is also far too much duplicate code in things like reprogram_fixed_counters()
> versus reprogram_fixed_counters_in_passthrough_pmu().
>
> Reprogramming on each write is also technically suboptimal, as _very_ theoretically
> KVM could emulate multiple WRMSRs without re-entering the guest.
>
> So, I think the mediated PMU should use the reprogramming infrastructure, and
> handle the bulk of the different behavior in reprogram_counter(), not in a half
> dozen different paths.

Sure. would handle the reprogram counter behavior of meidated vPMU
reprogram_counter(), and you comments reminds me current mediated vPMU code
missed to handle the case of event filter changing. Would add them in next
version.


>
>> +		return 0;
>> +
>>  	emulate_overflow = pmc_pause_counter(pmc);
>>  
>>  	if (!pmc_event_is_allowed(pmc))
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 7e006cb61296..10553bc1ae1d 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -256,6 +256,10 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>>  
>>  static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
>>  {
>> +	/* Passthrough PMU never reprogram counters via KVM_REQ_PMU. */
>> +	if (pmc_to_pmu(pmc)->passthrough)
>> +		return;
>> +
>>  	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
>>  	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>>  }
>> @@ -264,6 +268,10 @@ static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
>>  {
>>  	int bit;
>>  
>> +	/* Passthrough PMU never reprogram counters via KVM_REQ_PMU. */
>> +	if (pmu->passthrough)
>> +		return;
> Make up your mind :-)  Either handle the mediated PMU here, or handle it in the
> callers.  Don't do both.
>
> I vote to handle it here, i.e. drop the check in kvm_pmu_set_msr() when handling
> MSR_CORE_PERF_GLOBAL_CTRL, and then add a comment that reprogramming GP counters
> doesn't need to happen on control updates because KVM enforces the event filters
> when emulating writes to event selectors (and because the guest can write
> PERF_GLOBAL_CTRL directly).

:) Yeah, we found this and removed them internally. Sure. would follow your
suggestion.


>
>> +
>>  	if (!diff)
>>  		return;
>>  
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>

