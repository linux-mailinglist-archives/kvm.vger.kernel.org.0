Return-Path: <kvm+bounces-1279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55DD57E5F53
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:41:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07C782814A3
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B8E36B0F;
	Wed,  8 Nov 2023 20:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AGx9yYWs"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533B132C65
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:41:28 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12891FEE;
	Wed,  8 Nov 2023 12:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699476087; x=1731012087;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5vTuv7i33xV6Xb2Jmaxi1kuydek/b7NH6zn+kDGHWj0=;
  b=AGx9yYWsBaB+ygcs03zOhFW5tcIWY2eqPr870dOGJv25amo1oogTAWIO
   ov9yih9uDBUmNXETEAwP7zGRVQPt4JI0GUdyKtb9/fOnzAFY8iX9lunu2
   m6UBE8TX4HfEzYhkERvSsZC3ev3LzNvNp2f/Lc3P4w0igk/Mh8huKqBkr
   b4VNoHZ01AGgakeeiX12ntxcQuYkZbpuik94ephUOnOItjUD9gsRZAmDZ
   nTzlzRtzxIXQGlDFHbugUH1Baepi5eFbCqPDyTNb+LJFAwIAWkdd08N9t
   e/+8VcyB3903BxvOgQnrgDlO9WCNaL+ZJIu2PiXSL/2bITlQkPV2GfAj4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="380245074"
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="380245074"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:41:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="4311555"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:41:27 -0800
Received: from [10.213.166.225] (kliang2-mobl1.ccr.corp.intel.com [10.213.166.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 4E8BA580D4E;
	Wed,  8 Nov 2023 12:41:26 -0800 (PST)
Message-ID: <54d1437e-dcbb-49c6-a83c-bc87da03f196@linux.intel.com>
Date: Wed, 8 Nov 2023 15:41:25 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/19] KVM: x86/pmu: Allow programming events that
 match unsupported arch events
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231108003135.546002-1-seanjc@google.com>
 <20231108003135.546002-3-seanjc@google.com>
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20231108003135.546002-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2023-11-07 7:31 p.m., Sean Christopherson wrote:
> Remove KVM's bogus restriction that the guest can't program an event whose
> encoding matches an unsupported architectural event.  The enumeration of
> an architectural event only says that if a CPU supports an architectural
> event, then the event can be programmed using the architectural encoding.
> The enumeration does NOT say anything about the encoding when the CPU
> doesn't report support the architectural event.
> 
> Preventing the guest from counting events whose encoding happens to match
> an architectural event breaks existing functionality whenever Intel adds
> an architectural encoding that was *ever* used for a CPU that doesn't
> enumerate support for the architectural event, even if the encoding is for
> the exact same event!
> 
> E.g. the architectural encoding for Top-Down Slots is 0x01a4.  Broadwell
> CPUs, which do not support the Top-Down Slots architectural event, 0x10a4
> is a valid, model-specific event.  Denying guest usage of 0x01a4 if/when
> KVM adds support for Top-Down slots would break any Broadwell-based guest.
> 
> Reported-by: Kan Liang <kan.liang@linux.intel.com>
> Closes: https://lore.kernel.org/all/2004baa6-b494-462c-a11f-8104ea152c6a@linux.intel.com
> Fixes: a21864486f7e ("KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event")
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---


Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

Thanks,
Kan

>  arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
>  arch/x86/kvm/pmu.c                     |  1 -
>  arch/x86/kvm/pmu.h                     |  1 -
>  arch/x86/kvm/svm/pmu.c                 |  6 ----
>  arch/x86/kvm/vmx/pmu_intel.c           | 38 --------------------------
>  5 files changed, 47 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index 6c98f4bb4228..884af8ef7657 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -12,7 +12,6 @@ BUILD_BUG_ON(1)
>   * a NULL definition, for example if "static_call_cond()" will be used
>   * at the call sites.
>   */
> -KVM_X86_PMU_OP(hw_event_available)
>  KVM_X86_PMU_OP(pmc_idx_to_pmc)
>  KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
>  KVM_X86_PMU_OP(msr_idx_to_pmc)
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 9ae07db6f0f6..99ed72966528 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -374,7 +374,6 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>  static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
>  {
>  	return pmc_is_globally_enabled(pmc) && pmc_speculative_in_use(pmc) &&
> -	       static_call(kvm_x86_pmu_hw_event_available)(pmc) &&
>  	       check_pmu_event_filter(pmc);
>  }
>  
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 1d64113de488..10fe5bf02705 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -19,7 +19,6 @@
>  #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
>  
>  struct kvm_pmu_ops {
> -	bool (*hw_event_available)(struct kvm_pmc *pmc);
>  	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
>  	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
>  		unsigned int idx, u64 *mask);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 373ff6a6687b..5596fe816ea8 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -73,11 +73,6 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>  	return amd_pmc_idx_to_pmc(pmu, idx);
>  }
>  
> -static bool amd_hw_event_available(struct kvm_pmc *pmc)
> -{
> -	return true;
> -}
> -
>  static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -249,7 +244,6 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
>  }
>  
>  struct kvm_pmu_ops amd_pmu_ops __initdata = {
> -	.hw_event_available = amd_hw_event_available,
>  	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
>  	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
>  	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index c6e227edcf8e..7737ee2fc62f 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -101,43 +101,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
>  	}
>  }
>  
> -static bool intel_hw_event_available(struct kvm_pmc *pmc)
> -{
> -	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> -	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
> -	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
> -	int i;
> -
> -	/*
> -	 * Fixed counters are always available if KVM reaches this point.  If a
> -	 * fixed counter is unsupported in hardware or guest CPUID, KVM doesn't
> -	 * allow the counter's corresponding MSR to be written.  KVM does use
> -	 * architectural events to program fixed counters, as the interface to
> -	 * perf doesn't allow requesting a specific fixed counter, e.g. perf
> -	 * may (sadly) back a guest fixed PMC with a general purposed counter.
> -	 * But if _hardware_ doesn't support the associated event, KVM simply
> -	 * doesn't enumerate support for the fixed counter.
> -	 */
> -	if (pmc_is_fixed(pmc))
> -		return true;
> -
> -	BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) != NR_INTEL_ARCH_EVENTS);
> -
> -	/*
> -	 * Disallow events reported as unavailable in guest CPUID.  Note, this
> -	 * doesn't apply to pseudo-architectural events (see above).
> -	 */
> -	for (i = 0; i < NR_REAL_INTEL_ARCH_EVENTS; i++) {
> -		if (intel_arch_events[i].eventsel != event_select ||
> -		    intel_arch_events[i].unit_mask != unit_mask)
> -			continue;
> -
> -		return pmu->available_event_types & BIT(i);
> -	}
> -
> -	return true;
> -}
> -
>  static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -802,7 +765,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
>  }
>  
>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
> -	.hw_event_available = intel_hw_event_available,
>  	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
>  	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
>  	.msr_idx_to_pmc = intel_msr_idx_to_pmc,

