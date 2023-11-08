Return-Path: <kvm+bounces-1214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E199D7E5ACE
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ECD11C20C1D
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112F730CF5;
	Wed,  8 Nov 2023 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cbu3WNJj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE793034F
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 16:08:21 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B9B1FE7;
	Wed,  8 Nov 2023 08:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699459701; x=1730995701;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VCjzH6mVYN4iFo+LQzgIsGM1zhF1v29DXkIIMQyJhLY=;
  b=cbu3WNJjZpwZoacRDxrtd5QTbpE8euMF/UYaMZzodCkKbREFV1IPDqKw
   LlkIo04XY4hWwfRqRVPzHxPaOKxSjtG/6OPoSzK05SOts5XEnnpBdrAnM
   o5TSlGneXdAbpmdRC/buatzNOZJJT134MKroVQkkxG4hOdK7oVBr7/BdJ
   7zfERvvTjb28D7EbV1AAN6q78zOCsNCaE5ZtRzkF6ZrAFzbbVXQD1pLVZ
   yyjKe1QqH/jT0q2WmQx6jK8Tb3SXDMfY2zROyQsR9qCLS4n8y8c8ow02M
   WIE+SDhTmGzBUnjJCOLQZ6zy64p5W3AXI0CgAsyPVIoI4IL4pEgpdgRx3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="393708437"
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="393708437"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 08:06:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="4423030"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 08:06:34 -0800
Received: from [10.213.166.225] (kliang2-mobl1.ccr.corp.intel.com [10.213.166.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id C7C4F580DB4;
	Wed,  8 Nov 2023 08:06:32 -0800 (PST)
Message-ID: <4281eee7-6423-4ec8-bb18-c6aeee1faf2c@linux.intel.com>
Date: Wed, 8 Nov 2023 11:06:31 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/19] KVM: x86/pmu: Remove KVM's enumeration of
 Intel's architectural encodings
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231108003135.546002-1-seanjc@google.com>
 <20231108003135.546002-4-seanjc@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20231108003135.546002-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2023-11-07 7:31 p.m., Sean Christopherson wrote:
> Drop KVM's enumeration of Intel's architectural event encodings, and
> instead open code the three encodings (of which only two are real) that
> KVM uses to emulate fixed counters.  Now that KVM doesn't incorrectly
> enforce the availability of architectural encodings, there is no reason
> for KVM to ever care about the encodings themselves, at least not in the
> current format of an array indexed by the encoding's position in CPUID.
> 
> Opportunistically add a comment to explain why KVM cares about eventsel
> values for fixed counters.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 72 ++++++++++++------------------------
>  1 file changed, 23 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 7737ee2fc62f..c4f2c6a268e7 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -22,52 +22,6 @@
>  
>  #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>  
> -enum intel_pmu_architectural_events {
> -	/*
> -	 * The order of the architectural events matters as support for each
> -	 * event is enumerated via CPUID using the index of the event.
> -	 */
> -	INTEL_ARCH_CPU_CYCLES,
> -	INTEL_ARCH_INSTRUCTIONS_RETIRED,
> -	INTEL_ARCH_REFERENCE_CYCLES,
> -	INTEL_ARCH_LLC_REFERENCES,
> -	INTEL_ARCH_LLC_MISSES,
> -	INTEL_ARCH_BRANCHES_RETIRED,
> -	INTEL_ARCH_BRANCHES_MISPREDICTED,
> -
> -	NR_REAL_INTEL_ARCH_EVENTS,
> -
> -	/*
> -	 * Pseudo-architectural event used to implement IA32_FIXED_CTR2, a.k.a.
> -	 * TSC reference cycles.  The architectural reference cycles event may
> -	 * or may not actually use the TSC as the reference, e.g. might use the
> -	 * core crystal clock or the bus clock (yeah, "architectural").
> -	 */
> -	PSEUDO_ARCH_REFERENCE_CYCLES = NR_REAL_INTEL_ARCH_EVENTS,
> -	NR_INTEL_ARCH_EVENTS,
> -};
> -
> -static struct {
> -	u8 eventsel;
> -	u8 unit_mask;
> -} const intel_arch_events[] = {
> -	[INTEL_ARCH_CPU_CYCLES]			= { 0x3c, 0x00 },
> -	[INTEL_ARCH_INSTRUCTIONS_RETIRED]	= { 0xc0, 0x00 },
> -	[INTEL_ARCH_REFERENCE_CYCLES]		= { 0x3c, 0x01 },
> -	[INTEL_ARCH_LLC_REFERENCES]		= { 0x2e, 0x4f },
> -	[INTEL_ARCH_LLC_MISSES]			= { 0x2e, 0x41 },
> -	[INTEL_ARCH_BRANCHES_RETIRED]		= { 0xc4, 0x00 },
> -	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= { 0xc5, 0x00 },
> -	[PSEUDO_ARCH_REFERENCE_CYCLES]		= { 0x00, 0x03 },
> -};
> -
> -/* mapping between fixed pmc index and intel_arch_events array */
> -static int fixed_pmc_events[] = {
> -	[0] = INTEL_ARCH_INSTRUCTIONS_RETIRED,
> -	[1] = INTEL_ARCH_CPU_CYCLES,
> -	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
> -};
> -
>  static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>  {
>  	struct kvm_pmc *pmc;
> @@ -442,8 +396,29 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	return 0;
>  }
>  
> +/*
> + * Map fixed counter events to architectural general purpose event encodings.
> + * Perf doesn't provide APIs to allow KVM to directly program a fixed counter,
> + * and so KVM instead programs the architectural event to effectively request
> + * the fixed counter.  Perf isn't guaranteed to use a fixed counter and may
> + * instead program the encoding into a general purpose counter, e.g. if a
> + * different perf_event is already utilizing the requested counter, but the end
> + * result is the same (ignoring the fact that using a general purpose counter
> + * will likely exacerbate counter contention).
> + *
> + * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
> + * as there is no architectural general purpose encoding for reference cycles.

It's not the case for the latest Intel platforms anymore. Please see
ffbe4ab0beda ("perf/x86/intel: Extend the ref-cycles event to GP counters").

Maybe perf should export .event_map to KVM somehow.

Thanks,
Kan
> + */
>  static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
>  {
> +	const struct {
> +		u8 eventsel;
> +		u8 unit_mask;
> +	} fixed_pmc_events[] = {
> +		[0] = { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIONS. */
> +		[1] = { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
> +		[2] = { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLES*/
> +	};
>  	int i;
>  
>  	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
> @@ -451,10 +426,9 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
>  	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>  		int index = array_index_nospec(i, KVM_PMC_MAX_FIXED);
>  		struct kvm_pmc *pmc = &pmu->fixed_counters[index];
> -		u32 event = fixed_pmc_events[index];
>  
> -		pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
> -				 intel_arch_events[event].eventsel;
> +		pmc->eventsel = (fixed_pmc_events[index].unit_mask << 8) |
> +				 fixed_pmc_events[index].eventsel;
>  	}
>  }
>  

