Return-Path: <kvm+bounces-1278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD7F47E5F4C
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDF241C20C0C
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E307930F94;
	Wed,  8 Nov 2023 20:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JnUZNMcl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDA8610D
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:38:21 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353071FEE;
	Wed,  8 Nov 2023 12:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699475901; x=1731011901;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=guyzV1x+BNcL76TrK8k+P+aM2LkkhhwuAL+/FvBB+CQ=;
  b=JnUZNMclk3+8h1M5NGrg7UdkGAoDWMfumTpB5OpQLA/DCIBTOaaN2p/3
   UwVTA4XrA3O4hrEYe346CRI3bmG8j+oQfdhiDmep69dVvy/j9rTAKgwor
   8v0FIzGmnRMaosT1wGvEamMxG4uMrOdCIMO5+YErE/6PK6veNSGO2ylCf
   8DHOIt2jm95UCFh8bjkOVmGL5EP6EzvGC5aCyq+uafgirdLkpNvll79Gu
   +Xih3L0UE2NDO9zSX1UoFUKWEDTvO3j9i5/tP6uJXpU3/PVwc1/nDc90q
   sVaZb+uOif52jkh2Nm2xXcePvT8O4Q5Qxe7gnWri8i863kImnUTznjtOn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="380244722"
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="380244722"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:38:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="4310972"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:38:22 -0800
Received: from [10.213.166.225] (kliang2-mobl1.ccr.corp.intel.com [10.213.166.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id AA148580D4E;
	Wed,  8 Nov 2023 12:38:19 -0800 (PST)
Message-ID: <7539656d-53d1-4724-b978-f86325d26573@linux.intel.com>
Date: Wed, 8 Nov 2023 15:38:18 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/19] KVM: x86/pmu: Remove KVM's enumeration of
 Intel's architectural encodings
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>,
 Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
References: <20231108003135.546002-1-seanjc@google.com>
 <20231108003135.546002-4-seanjc@google.com>
 <4281eee7-6423-4ec8-bb18-c6aeee1faf2c@linux.intel.com>
 <ZUvi6P7iKMtsS8wm@google.com>
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZUvi6P7iKMtsS8wm@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2023-11-08 2:35 p.m., Sean Christopherson wrote:
> On Wed, Nov 08, 2023, Kan Liang wrote:
>> On 2023-11-07 7:31 p.m., Sean Christopherson wrote:
>>> @@ -442,8 +396,29 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>  	return 0;
>>>  }
>>>  
>>> +/*
>>> + * Map fixed counter events to architectural general purpose event encodings.
>>> + * Perf doesn't provide APIs to allow KVM to directly program a fixed counter,
>>> + * and so KVM instead programs the architectural event to effectively request
>>> + * the fixed counter.  Perf isn't guaranteed to use a fixed counter and may
>>> + * instead program the encoding into a general purpose counter, e.g. if a
>>> + * different perf_event is already utilizing the requested counter, but the end
>>> + * result is the same (ignoring the fact that using a general purpose counter
>>> + * will likely exacerbate counter contention).
>>> + *
>>> + * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
>>> + * as there is no architectural general purpose encoding for reference cycles.
>>
>> It's not the case for the latest Intel platforms anymore. Please see
>> ffbe4ab0beda ("perf/x86/intel: Extend the ref-cycles event to GP counters").
> 
> Ugh, yeah.  But that and should actually be easier to do on top.
> 
>> Maybe perf should export .event_map to KVM somehow.
> 
> Oh for ***** sake, perf already does export this for KVM.  Untested, but the below
> should do the trick.  If I need to spin another version of this series then I'll
> fold it in, otherwise I'll post it as something on top.
> 
> There's also an optimization to be had for kvm_pmu_trigger_event(), which incurs
> an indirect branch not only every invocation, but on every iteration.  I'll post
> this one separately.
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 5fc5a62af428..a02e13c2e5e6 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -405,25 +405,32 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   * different perf_event is already utilizing the requested counter, but the end
>   * result is the same (ignoring the fact that using a general purpose counter
>   * will likely exacerbate counter contention).
> - *
> - * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
> - * as there is no architectural general purpose encoding for reference cycles.
>   */
>  static u64 intel_get_fixed_pmc_eventsel(int index)
>  {
> -       const struct {
> -               u8 eventsel;
> -               u8 unit_mask;
> -       } fixed_pmc_events[] = {
> -               [0] = { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIONS. */
> -               [1] = { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
> -               [2] = { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLES*/
> +       enum perf_hw_id perf_id;
> +       u64 eventsel;
> +
> +       BUILD_BUG_ON(KVM_PMC_MAX_FIXED != 3);
> +
> +       switch (index) {
> +       case 0:
> +               perf_id = PERF_COUNT_HW_INSTRUCTIONS;
> +               break;
> +       case 1:
> +               perf_id = PERF_COUNT_HW_CPU_CYCLES;
> +               break;
> +       case 2:
> +               perf_id = PERF_COUNT_HW_REF_CPU_CYCLES;
> +               break;
> +       default:
> +               WARN_ON_ONCE(1);
> +               return 0;
>         };
>  
> -       BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
> -
> -       return (fixed_pmc_events[index].unit_mask << 8) |
> -               fixed_pmc_events[index].eventsel;
> +       eventsel = perf_get_hw_event_config(perf_id);

Yes, the perf_get_hw_event_config() can tell the updated event encoding.

Thanks,
Kan

> +       WARN_ON_ONCE(!eventsel && index < kvm_pmu_cap.num_counters_fixed);
> +       return eventsel;
>  }
>  
>  static void intel_pmu_refresh(struct kvm_vcpu *vcpu)

