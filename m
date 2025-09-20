Return-Path: <kvm+bounces-58284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17ECCB8BB3F
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 02:47:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC93F1C079B2
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC202110E;
	Sat, 20 Sep 2025 00:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eGACpajA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECDA335C7;
	Sat, 20 Sep 2025 00:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758329271; cv=none; b=fzFCMl+saAhkzNG+6PqGkYgEdvBZI6fHPgglaZMcAf8Y+R6J6S/RFDzF2Nkb8+QjT/oe3P7RfzlzxSrDv2cOnQH5tL5ZQqNDle4eQxWkuVfhoeAyFZszkBDitm6fmrr+lbdqqfyMi6gbUfcgkZN5T1Nx6Vf6G2dZUzpxMXnemtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758329271; c=relaxed/simple;
	bh=Iu/Xn6ahDSxjPOATIzR44ZM5YDkn03Z4GmkkYhbHcL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BwO2kUEMkdMo078zupECNq+woC635SrQTv83ciSJCHPtYizUSrotX4UDe/Tp6J3yzLTJhGXv8TyCA73yLZp3NslgwCsHXUhEwrTQp+Nkoo0HGR2v2tnSPUFXOUgI5hM7PxLatCTp6aLFAM2+08GEfyiwa34gs+sUbLqAuAxDpv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eGACpajA; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758329270; x=1789865270;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Iu/Xn6ahDSxjPOATIzR44ZM5YDkn03Z4GmkkYhbHcL0=;
  b=eGACpajAX5q+WoycApso86klfgf2quMZwaronzIKt0alq97G1hfcvV2I
   UMDLL6/+tCKFjIoXU3gssTcmRyH7ipOCNj7tdWRxV3+1A0F4mabEd4pFB
   KvvyhhfrPHZ//7d02GVDFcK+LO2L/vPkSp+h3bPCHE/US4HNTmVi3ifpk
   Cg5gbiUJIQ+HE1wsL86joD7ofKg8H/O0iYluTs4AAOeOj7ZIfU0H41U0O
   P661D2O/1M8lKh5IShxTmVOSox2qIpyNTj9UErYrpIqhljuItTebhVS0r
   9fxNGh1f1LAaOARkjmgCDpyxv3c3F3W/UBHYdxYpbedwNQNYZiaWAqP3E
   g==;
X-CSE-ConnectionGUID: ZDii/zwSR8mbppH/zM/kWg==
X-CSE-MsgGUID: 1L9hLHPNRkOPqVFmkISFSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="60373139"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="60373139"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 17:47:48 -0700
X-CSE-ConnectionGUID: qHfUbq4fQKuUi+looCbjLA==
X-CSE-MsgGUID: E9llOl1mSnOLOD+oLUoFnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="176402455"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.233.177]) ([10.124.233.177])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 17:47:46 -0700
Message-ID: <e25c84b0-75de-4963-a05a-0d0ac5916168@linux.intel.com>
Date: Sat, 20 Sep 2025 08:47:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: selftests: Handle Intel Atom errata that
 leads to PMU event overcount
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yi Lai <yi1.lai@intel.com>
References: <20250919214648.1585683-1-seanjc@google.com>
 <20250919214648.1585683-6-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250919214648.1585683-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 9/20/2025 5:46 AM, Sean Christopherson wrote:
> From: dongsheng <dongsheng.x.zhang@intel.com>
>
> Add a PMU errata framework and use it to relax precise event counts on
> Atom platforms that overcount "Instruction Retired" and "Branch Instruction
> Retired" events, as the overcount issues on VM-Exit/VM-Entry are impossible
> to prevent from userspace, e.g. the test can't prevent host IRQs.
>
> Setup errata during early initialization and automatically sync the mask
> to VMs so that tests can check for errata without having to manually
> manage host=>guest variables.
>
> For Intel Atom CPUs, the PMU events "Instruction Retired" or
> "Branch Instruction Retired" may be overcounted for some certain
> instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
> and complex SGX/SMX/CSTATE instructions/flows.
>
> The detailed information can be found in the errata (section SRF7):
> https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
>
> For the Atom platforms before Sierra Forest (including Sierra Forest),
> Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
> be overcounted on these certain instructions, but for Clearwater Forest
> only "Instruction Retired" event is overcounted on these instructions.
>
> Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86/pmu.h | 16 +++++++
>  tools/testing/selftests/kvm/lib/x86/pmu.c     | 44 +++++++++++++++++++
>  .../testing/selftests/kvm/lib/x86/processor.c |  4 ++
>  .../selftests/kvm/x86/pmu_counters_test.c     | 12 ++++-
>  .../selftests/kvm/x86/pmu_event_filter_test.c |  4 +-
>  5 files changed, 77 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h b/tools/testing/selftests/kvm/include/x86/pmu.h
> index 2aabda2da002..72575eadb63a 100644
> --- a/tools/testing/selftests/kvm/include/x86/pmu.h
> +++ b/tools/testing/selftests/kvm/include/x86/pmu.h
> @@ -5,8 +5,11 @@
>  #ifndef SELFTEST_KVM_PMU_H
>  #define SELFTEST_KVM_PMU_H
>  
> +#include <stdbool.h>
>  #include <stdint.h>
>  
> +#include <linux/bits.h>
> +
>  #define KVM_PMU_EVENT_FILTER_MAX_EVENTS			300
>  
>  /*
> @@ -104,4 +107,17 @@ enum amd_pmu_zen_events {
>  extern const uint64_t intel_pmu_arch_events[];
>  extern const uint64_t amd_pmu_zen_events[];
>  
> +enum pmu_errata {
> +	INSTRUCTIONS_RETIRED_OVERCOUNT,
> +	BRANCHES_RETIRED_OVERCOUNT,
> +};
> +extern uint64_t pmu_errata_mask;
> +
> +void kvm_init_pmu_errata(void);
> +
> +static inline bool this_pmu_has_errata(enum pmu_errata errata)
> +{
> +	return pmu_errata_mask & BIT_ULL(errata);
> +}
> +
>  #endif /* SELFTEST_KVM_PMU_H */
> diff --git a/tools/testing/selftests/kvm/lib/x86/pmu.c b/tools/testing/selftests/kvm/lib/x86/pmu.c
> index 5ab44bf54773..34cb57d1d671 100644
> --- a/tools/testing/selftests/kvm/lib/x86/pmu.c
> +++ b/tools/testing/selftests/kvm/lib/x86/pmu.c
> @@ -8,6 +8,7 @@
>  #include <linux/kernel.h>
>  
>  #include "kvm_util.h"
> +#include "processor.h"
>  #include "pmu.h"
>  
>  const uint64_t intel_pmu_arch_events[] = {
> @@ -34,3 +35,46 @@ const uint64_t amd_pmu_zen_events[] = {
>  	AMD_ZEN_BRANCHES_MISPREDICTED,
>  };
>  kvm_static_assert(ARRAY_SIZE(amd_pmu_zen_events) == NR_AMD_ZEN_EVENTS);
> +
> +/*
> + * For Intel Atom CPUs, the PMU events "Instruction Retired" or
> + * "Branch Instruction Retired" may be overcounted for some certain
> + * instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
> + * and complex SGX/SMX/CSTATE instructions/flows.
> + *
> + * The detailed information can be found in the errata (section SRF7):
> + * https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
> + *
> + * For the Atom platforms before Sierra Forest (including Sierra Forest),
> + * Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
> + * be overcounted on these certain instructions, but for Clearwater Forest
> + * only "Instruction Retired" event is overcounted on these instructions.
> + */
> +static uint64_t get_pmu_errata(void)
> +{
> +	if (!this_cpu_is_intel())
> +		return 0;
> +
> +	if (this_cpu_family() != 0x6)
> +		return 0;
> +
> +	switch (this_cpu_model()) {
> +	case 0xDD: /* Clearwater Forest */
> +		return BIT_ULL(INSTRUCTIONS_RETIRED_OVERCOUNT);
> +	case 0xAF: /* Sierra Forest */
> +	case 0x4D: /* Avaton, Rangely */
> +	case 0x5F: /* Denverton */
> +	case 0x86: /* Jacobsville */
> +		return BIT_ULL(INSTRUCTIONS_RETIRED_OVERCOUNT) |
> +		       BIT_ULL(BRANCHES_RETIRED_OVERCOUNT);
> +	default:
> +		return 0;
> +	}
> +}
> +
> +uint64_t pmu_errata_mask;
> +
> +void kvm_init_pmu_errata(void)
> +{
> +	pmu_errata_mask = get_pmu_errata();
> +}
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index 3b63c99f7b96..4402d2e1ea69 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -6,6 +6,7 @@
>  #include "linux/bitmap.h"
>  #include "test_util.h"
>  #include "kvm_util.h"
> +#include "pmu.h"
>  #include "processor.h"
>  #include "sev.h"
>  
> @@ -638,6 +639,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
>  	sync_global_to_guest(vm, host_cpu_is_intel);
>  	sync_global_to_guest(vm, host_cpu_is_amd);
>  	sync_global_to_guest(vm, is_forced_emulation_enabled);
> +	sync_global_to_guest(vm, pmu_errata_mask);
>  
>  	if (is_sev_vm(vm)) {
>  		struct kvm_sev_init init = { 0 };
> @@ -1269,6 +1271,8 @@ void kvm_selftest_arch_init(void)
>  	host_cpu_is_intel = this_cpu_is_intel();
>  	host_cpu_is_amd = this_cpu_is_amd();
>  	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
> +
> +	kvm_init_pmu_errata();
>  }
>  
>  bool sys_clocksource_is_based_on_tsc(void)
> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> index 24599d98f898..eb6c12a2cdd4 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> @@ -163,10 +163,18 @@ static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr
>  
>  	switch (idx) {
>  	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
> -		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
> +		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
> +		if (this_pmu_has_errata(INSTRUCTIONS_RETIRED_OVERCOUNT))
> +			GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
> +		else
> +			GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
>  		break;
>  	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
> -		GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
> +		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
> +		if (this_pmu_has_errata(BRANCHES_RETIRED_OVERCOUNT))
> +			GUEST_ASSERT(count >= NUM_BRANCH_INSNS_RETIRED);
> +		else
> +			GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
>  		break;
>  	case INTEL_ARCH_LLC_REFERENCES_INDEX:
>  	case INTEL_ARCH_LLC_MISSES_INDEX:
> diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> index c15513cd74d1..1c5b7611db24 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> @@ -214,8 +214,10 @@ static void remove_event(struct __kvm_pmu_event_filter *f, uint64_t event)
>  do {											\
>  	uint64_t br = pmc_results.branches_retired;					\
>  	uint64_t ir = pmc_results.instructions_retired;					\
> +	bool br_matched = this_pmu_has_errata(BRANCHES_RETIRED_OVERCOUNT) ?		\
> +			  br >= NUM_BRANCHES : br == NUM_BRANCHES;			\
>  											\
> -	if (br && br != NUM_BRANCHES)							\
> +	if (br && !br_matched)								\
>  		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
>  			__func__, br, NUM_BRANCHES);					\
>  	TEST_ASSERT(br, "%s: Branch instructions retired = %lu (expected > 0)",		\

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



