Return-Path: <kvm+bounces-32121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F75D9D3318
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 06:20:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAD1E284350
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 05:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612B3156C71;
	Wed, 20 Nov 2024 05:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gA9q/N/B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF92E3FE;
	Wed, 20 Nov 2024 05:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732080000; cv=none; b=TYuwHXpsdyg68iQxHgfo8pscpO4rUGGAjeP1fYXwio1UI0H8NkN6O81X8X+whu3dgzKC2k0I6U7QjzdfVph44ybN8kz5a46zhcDe5nNEYS395UdEOgC6MmfQ4sI8fb5Yv7pQbI1GI/adc4yf8Y6r/RDdPIA1lDkW1zfwJGOwK5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732080000; c=relaxed/simple;
	bh=kHE5nqDH54rjOiMZFwRETDYCWKtnt4xOaXoWAO3K3Lc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZGmzyu0ny8QxENzazqiwVjkf4JnWGURJXSH7CG/0zJSzCnwVQnP5UfltoHphF2eRwBbXWWjI1FXToRE7isGrQDNi7HfAho/nAteYPQyxzowWx4o8HF78dRzDQizCcvAfYJKlNu+dafcPgO137Z58b7EDVWR/VEvMYPfmuUWYhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gA9q/N/B; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732080000; x=1763616000;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kHE5nqDH54rjOiMZFwRETDYCWKtnt4xOaXoWAO3K3Lc=;
  b=gA9q/N/B3e593m2ItZRTd9rbz4M5a5NSWXSIJQGl7q9aqw+SQvFetPBD
   PqH8lz7+7kOpBWf3CGbT3RlXF/xJB3tSnJVGIbBpOiK8hD/qKTBrPIATK
   Rh2zDgGOf/ZdtNoANLjE4VHL6gVKFekX9jyolrzQVWmpCZGfgFBRjoJYN
   AGiD5AdN7Wqeda3eZGa8zfNLmct/SZp8eQlFIGzrKshAKYqm7uwxaCo8i
   iRRrn1mhTwmjDyE9mO0V5sOI7LVlINMzzbWzi8AH7xrXSSSTYXgDYCGWL
   +Mb6nQAVOo8uHIs501AKn28109QwrIXt027wWE+lWrQT7/CXo33ziWERN
   A==;
X-CSE-ConnectionGUID: G8YpKnYQRuyIY3X/rfkdug==
X-CSE-MsgGUID: IFLFE1p9TRWeW70QIMbebw==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="54620107"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="54620107"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 21:19:59 -0800
X-CSE-ConnectionGUID: 5sXEIbUTS4mKQAqmID8f1g==
X-CSE-MsgGUID: XbRSkJgnR7CkpmGWGiKVIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="94869413"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 21:19:54 -0800
Message-ID: <b08075d5-1190-44f7-bccc-04f3273c13f3@linux.intel.com>
Date: Wed, 20 Nov 2024 13:19:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 20/58] KVM: x86/pmu: Always set global enable bits
 in passthrough mode
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
 <20240801045907.4010984-21-mizhang@google.com> <Zzyw1UyapXDNpc-c@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zzyw1UyapXDNpc-c@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/19/2024 11:37 PM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> From: Sandipan Das <sandipan.das@amd.com>
>>
>> Currently, the global control bits for a vcpu are restored to the reset
>> state only if the guest PMU version is less than 2. This works for
>> emulated PMU as the MSRs are intercepted and backing events are created
>> for and managed by the host PMU [1].
>>
>> If such a guest in run with passthrough PMU, the counters no longer work
>> because the global enable bits are cleared. Hence, set the global enable
>> bits to their reset state if passthrough PMU is used.
>>
>> A passthrough-capable host may not necessarily support PMU version 2 and
>> it can choose to restore or save the global control state from struct
>> kvm_pmu in the PMU context save and restore helpers depending on the
>> availability of the global control register.
>>
>> [1] 7b46b733bdb4 ("KVM: x86/pmu: Set enable bits for GP counters in PERF_GLOBAL_CTRL at "RESET"");
>>
>> Reported-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>> [removed the fixes tag]
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/kvm/pmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 5768ea2935e9..e656f72fdace 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -787,7 +787,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>>  	 * in the global controls).  Emulate that behavior when refreshing the
>>  	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
>>  	 */
>> -	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)
>> +	if ((pmu->passthrough || kvm_pmu_has_perf_global_ctrl(pmu)) && pmu->nr_arch_gp_counters)
>>  		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
> This is wrong and confusing.  From the guest's perspective, and therefore from
> host userspace's perspective, PERF_GLOBAL_CTRL does not exist.  Therefore, the
> value that is tracked for the guest must be '0'.
>
> I see that intel_passthrough_pmu_msrs() and amd_passthrough_pmu_msrs() intercept
> accesses to PERF_GLOBAL_CTRL if "pmu->version > 1" (which, by the by, needs to be
> kvm_pmu_has_perf_global_ctrl()), so there's no weirdness with the guest being able
> to access MSRs that shouldn't exist.
>
> But KVM shouldn't stuff pmu->global_ctrl, and doing so is a symptom of another
> flaw.  Unless I'm missing something, KVM stuffs pmu->global_ctrl so that the
> correct value is loaded on VM-Enter, but loading and saving PERF_GLOBAL_CTRL on
> entry/exit is unnecessary and confusing, as is loading the associated MSRs when
> restoring (loading) the guest context.
>
> For PERF_GLOBAL_CTRL on Intel, KVM needs to ensure all GP counters are enabled in
> VMCS.GUEST_IA32_PERF_GLOBAL_CTRL, but that's a "set once and forget" operation,
> not something that needs to be done on every entry and exit.  Of course, loading
> and saving PERF_GLOBAL_CTRL on every entry/exit is unnecessary for other reasons,
> but that's largely orthogonal.
>
> On AMD, amd_restore_pmu_context()[*] needs to enable a maximal value for
> PERF_GLOBAL_CTRL, but I don't think there's any need to load the other MSRs,
> and the maximal value should come from the above logic, not pmu->global_ctrl.

Sean, just double confirm, you are suggesting to do one-shot initialization
for guest PERF_GLOBAL_CTRL (VMCS.GUEST_IA32_PERF_GLOBAL_CTRL for Intel)
after vCPU resets, right?



>
> [*] Side topic, in case I forget later, that API should be "load", not "restore".
>     There is no assumption or guarantee that KVM is exactly restoring anything,
>     e.g. if PERF_GLOBAL_CTRL doesn't exist in the guest PMU and on the first load.

Sure.



