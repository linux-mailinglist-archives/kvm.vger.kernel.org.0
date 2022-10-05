Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950F65F5A73
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 21:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJETOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 15:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiJETOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 15:14:22 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5D67E310
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 12:14:21 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b15so8346633pje.1
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 12:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jy7nEkMKV3x8qL4/Rhb8J8yjosfoIEGXvUXfVwpTnO0=;
        b=itDiU6dGDXooQZIlW836myceNR5Yaas3n46ZFcHRlcu8acJewjXoFyfh9RV+rk6A+P
         LqXLCLimqEjCF8OKIamHiD9lOultE/FFMbxOAhx0TuY7dGXSN1nFIbW2Czhgb7g8YF5p
         MPwJd58v+rUZNh8eoJj+Fa6mRXwHHP3yh3OpgRTbObwOrCr6E6khG9NohnQ9u4qt+qej
         rjP6h8Y5gk8K51dCWsGC7FJysFWQo8ulcbpSRE72pqK1Brt5bHSapsoOnV70nsm/0V8y
         0jH9AcPlXDqgnoJCyYve/Z+bqYjQkzhJ7bXujgFjb+cL5Mz5q9AGa32rxEwh3gML6brf
         +YjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jy7nEkMKV3x8qL4/Rhb8J8yjosfoIEGXvUXfVwpTnO0=;
        b=ghz7lnvaBsAnjimJOuUO4nvflL8IHDt1agGOCumnKx2zHmqNjsmm1UrA+e7/8rjK/Y
         LG4fcj+izgAjcQHz9zrqgzRoqh754agQLvO+B2kVU3SAFCljwcnPk1MOaioPntf6QxpC
         a5SFKjqXdj1AAdExeKxRsCJV8ba4Jvbo4A6Bx2y9WeStcs0o7iEx1EW4ZoBta2Ek0271
         tFzq4ex7Md8bs5Mt8DijwO0fagz1WYpR532m6BvzG9A/XOBsVD8wZY84UeLbg9dKKMDv
         BfmuUW0y8PYuxiFbUWgLhD7QqhhvwVPKj5E1r/d6Id8wVKrKtar56nAfaz31VULl+4Rl
         CRFw==
X-Gm-Message-State: ACrzQf1y1I0Hhqe2bLXcIk4rmIjWrrfyEd+YzaKnFJ85K3bhhSlbS9lR
        rmNbkUDC1cQkDb/xJ0sXNM9SQQ==
X-Google-Smtp-Source: AMsMyM6bGhFYGCvQSoSZxgTvFIwuvaU0vlHQPL0Tb651XmV9o7kmhiKHKe6+ADq3Wf0jJ08HOGltdg==
X-Received: by 2002:a17:903:124e:b0:178:6946:a2ba with SMTP id u14-20020a170903124e00b001786946a2bamr938365plh.89.1664997260912;
        Wed, 05 Oct 2022 12:14:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902e74b00b0017f73caf588sm3229172plf.218.2022.10.05.12.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 12:14:20 -0700 (PDT)
Date:   Wed, 5 Oct 2022 19:14:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2] x86: Add tests for Guest Processor
 Event Based Sampling (PEBS)
Message-ID: <Yz3XiP6GBp95YEW9@google.com>
References: <20220728112119.58173-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728112119.58173-1-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022, Like Xu wrote:
> +#include "vm.h"
> +#include "types.h"
> +#include "processor.h"
> +#include "vmalloc.h"
> +#include "alloc_page.h"
> +
> +#define PC_VECTOR	32

PC?

> +
> +#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))

This belongs in lib/x86/processor.h, e.g. it'll also be used for the pmu_lbr tests.

> +#define PERF_CAP_PEBS_FORMAT           0xf00
> +#define PMU_CAP_FW_WRITES	(1ULL << 13)
> +#define PMU_CAP_PEBS_BASELINE	(1ULL << 14)
> +
> +#define INTEL_PMC_IDX_FIXED				       32
> +
> +#define GLOBAL_STATUS_BUFFER_OVF_BIT		62
> +#define GLOBAL_STATUS_BUFFER_OVF	BIT_ULL(GLOBAL_STATUS_BUFFER_OVF_BIT)
> +
> +#define EVNTSEL_USR_SHIFT       16
> +#define EVNTSEL_OS_SHIFT        17
> +#define EVNTSEL_EN_SHIF         22
> +
> +#define EVNTSEL_EN      (1 << EVNTSEL_EN_SHIF)
> +#define EVNTSEL_USR     (1 << EVNTSEL_USR_SHIFT)
> +#define EVNTSEL_OS      (1 << EVNTSEL_OS_SHIFT)
> +
> +#define PEBS_DATACFG_MEMINFO	BIT_ULL(0)
> +#define PEBS_DATACFG_GP	BIT_ULL(1)
> +#define PEBS_DATACFG_XMMS	BIT_ULL(2)
> +#define PEBS_DATACFG_LBRS	BIT_ULL(3)
> +
> +#define ICL_EVENTSEL_ADAPTIVE				(1ULL << 34)
> +#define PEBS_DATACFG_LBR_SHIFT	24
> +#define MAX_NUM_LBR_ENTRY	32

Given all the PMU stuff coming in, I think we need e.g. lib/x86/pmu.h to hold all
of the hardware-defined stuff, e.g. #defines and structs that are dictated by
hardware.

> +static inline u8 pebs_format(void)
> +{
> +	return (perf_cap & PERF_CAP_PEBS_FORMAT ) >> 8;
> +}
> +
> +static inline bool pebs_has_baseline(void)
> +{
> +	return perf_cap & PMU_CAP_PEBS_BASELINE;
> +}

These types of accessors can also go in pmu.h.  The easy thing is to just re-read
PERF_CAPABILITIES every time, the overhead of the VM-Exit to emulate the RDMSR
isn't meaningless in the grand scheme of the test.

> +static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
> +{
> +	static struct debug_store *ds;
> +	u64 baseline_extra_ctrl, fixed_ctr_ctrl = 0;
> +	unsigned int idx;
> +
> +	if (pebs_has_baseline())

This function can snapshot pebs_has_baseline() to avoid RDMSR on every touch.

> +		wrmsr(MSR_PEBS_DATA_CFG, pebs_data_cfg);
> +
> +	ds = (struct debug_store *)ds_bufer;
> +	ds->pebs_index = ds->pebs_buffer_base = (unsigned long)pebs_buffer;
> +	ds->pebs_absolute_maximum = (unsigned long)pebs_buffer + PAGE_SIZE;
> +	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
> +		get_adaptive_pebs_record_size(pebs_data_cfg);
> +
> +	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++) {
> +		if (!(BIT_ULL(INTEL_PMC_IDX_FIXED + idx) & bitmask))
> +			continue;
> +		baseline_extra_ctrl = pebs_has_baseline() ?
> +			(1ULL << (INTEL_PMC_IDX_FIXED + idx * 4)) : 0;

Init baseline_extra_ctrl to zero outside of the loop, then this can avoid the
ternary operator:

		if (has_baseline)
			baseline_extra_ctrl = BIT(INTEL_PMC_IDX_FIXED + idx * 4);

> +		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + idx, ctr_start_val);

Helpers (or macros?) to read/write counter MSRs would improve readability.

> +		fixed_ctr_ctrl |= (0xbULL << (idx * 4) | baseline_extra_ctrl);
> +	}
> +	if (fixed_ctr_ctrl)
> +		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, fixed_ctr_ctrl);
> +
> +	for (idx = 0; idx < max_nr_gp_events; idx++) {
> +		if (!(BIT_ULL(idx) & bitmask))
> +			continue;
> +		baseline_extra_ctrl = pebs_has_baseline() ?
> +			ICL_EVENTSEL_ADAPTIVE : 0;

Same thing as above, rely on the "has_baseline" not changing to avoid the ternary
operator.

> +		wrmsr(MSR_P6_EVNTSEL0 + idx,

Add a helper/macro instead of manually indexing?

> +		      EVNTSEL_EN | EVNTSEL_OS | EVNTSEL_USR |
> +		      intel_arch_events[idx] | baseline_extra_ctrl);
> +		wrmsr(gp_counter_base + idx, ctr_start_val);

Continuing the theme of code reuse, please add a lib/pmu.c and move common code
and variables there, e.g. tests shouldn't need to manually compute gp_counter_base.
A common "PMU init" routine would allow the library to provide helpers for accessing
GP counters too.

> +	}
> +
> +	wrmsr(MSR_IA32_DS_AREA,  (unsigned long)ds_bufer);
> +	wrmsr(MSR_IA32_PEBS_ENABLE, bitmask);
> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, bitmask);
> +}
> +
> +static void pmu_env_cleanup(void)

This is probably a good candidate for library code.  And maybe reset_pmu() or so
to provide a hint that this is often called _before_ running tests?

> +{
> +	unsigned int idx;
> +
> +	memset(ds_bufer, 0x0, PAGE_SIZE);
> +	memset(pebs_buffer, 0x0, PAGE_SIZE);
> +	wrmsr(MSR_IA32_PEBS_ENABLE, 0);
> +	wrmsr(MSR_IA32_DS_AREA,  0);
> +	if (pebs_has_baseline())
> +		wrmsr(MSR_PEBS_DATA_CFG, 0);
> +
> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +
> +	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> +	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++) {

Curly braces aren't necessary.  And rather than call a function every time,
add a global struct in the library to track the PMU capabilities.

> +		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + idx, 0);
> +	}
> +
> +	for (idx = 0; idx < pmu_nr_gp_counters(); idx++) {
> +		wrmsr(MSR_P6_EVNTSEL0 + idx, 0);
> +		wrmsr(MSR_IA32_PERFCTR0 + idx, 0);
> +	}
> +
> +	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
> +}
> +
> +static inline void pebs_disable_1(void)
> +{
> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +}
> +
> +static inline void pebs_disable_2(void)
> +{
> +	wrmsr(MSR_IA32_PEBS_ENABLE, 0);
> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +}
> +
> +static void pebs_disable(unsigned int idx)
> +{
> +	if (idx % 2) {

Curly braces unnecessary.  That said, the helpers do not help.  It's much easier
to do:

	/* comment goes here */
	if (idx % 2)
		wrmsr(MSR_IA32_PEBS_ENABLE, 0);

	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);

Please add a comment, it's not at all obvious to me (non-PMU person) what this
code is doing.

> +		pebs_disable_1();
> +	} else {
> +		pebs_disable_2();
> +	}
> +}
> +
> +static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
> +{
> +	struct pebs_basic *pebs_rec = (struct pebs_basic *)pebs_buffer;
> +	struct debug_store *ds = (struct debug_store *)ds_bufer;
> +	unsigned int pebs_record_size = get_adaptive_pebs_record_size(pebs_data_cfg);
> +	unsigned int count = 0;
> +	bool expected, pebs_idx_match, pebs_size_match, data_cfg_match;
> +	void *vernier;
> +
> +	expected = (ds->pebs_index == ds->pebs_buffer_base) && !pebs_rec->format_size;
> +	if (!(rdmsr(MSR_CORE_PERF_GLOBAL_STATUS) & GLOBAL_STATUS_BUFFER_OVF)) {
> +		report(expected, "No OVF irq, none PEBS records.");
> +		return;
> +	}
> +
> +	if (expected) {
> +		report(!expected, "A OVF irq, but none PEBS records.");
> +		return;
> +	}
> +
> +	expected = ds->pebs_index >= ds->pebs_interrupt_threshold;
> +	vernier = (void *)pebs_buffer;

Heh, I have zero clue what vernier means here.  Dictionary says:

  a small movable graduated scale for obtaining fractional parts of
  subdivisions on a fixed main scale of a barometer, sextant, or other measuring
  instrument.

but that doesn't help me understand what this is doing.

> +	do {
> +		pebs_rec = (struct pebs_basic *)vernier;
> +		pebs_record_size = pebs_rec->format_size >> 48;

Add a #define instead of open coding a magic number.

> +		pebs_idx_match =
> +			pebs_rec->applicable_counters & bitmask;
> +		pebs_size_match =
> +			pebs_record_size == get_adaptive_pebs_record_size(pebs_data_cfg);
> +		data_cfg_match =
> +			(pebs_rec->format_size & 0xffffffffffff) == pebs_data_cfg;

Please use GENMASK_ULL.

> +		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
> +		report(expected,
> +		       "PEBS record (written seq %d) is verified (inclduing size, counters and cfg).", count);
> +		vernier = vernier + pebs_record_size;
> +		count++;
> +	} while (expected && (void *)vernier < (void *)ds->pebs_index);
> +
> +	if (!expected) {
> +		if (!pebs_idx_match)
> +			printf("FAIL: The applicable_counters (0x%lx) doesn't match with pmc_bitmask (0x%lx).\n",
> +			       pebs_rec->applicable_counters, bitmask);
> +		if (!pebs_size_match)
> +			printf("FAIL: The pebs_record_size (%d) doesn't match with MSR_PEBS_DATA_CFG (%d).\n",
> +			       pebs_record_size, get_adaptive_pebs_record_size(pebs_data_cfg));
> +		if (!data_cfg_match)
> +			printf("FAIL: The pebs_data_cfg (0x%lx) doesn't match with MSR_PEBS_DATA_CFG (0x%lx).\n",
> +			       pebs_rec->format_size & 0xffffffffffff, pebs_data_cfg);
> +	}
> +}
> +
> +static void check_one_counter(enum pmc_type type,
> +			      unsigned int idx, u64 pebs_data_cfg)
> +{
> +	report_prefix_pushf("%s counter %d (0x%lx)",
> +			    type == FIXED ? "Extended Fixed" : "GP", idx, ctr_start_val);
> +	pmu_env_cleanup();
> +	pebs_enable(BIT_ULL(type == FIXED ? INTEL_PMC_IDX_FIXED + idx : idx), pebs_data_cfg);

Please avoid burying ternary operators like this, it makes the code hard to follow
because it's difficult to visually identify what goes with what.  You can also
avoid copy+paste...

	int pebs_bit = BIT_ULL(type == FIXED ? INTEL_PMC_IDX_FIXED + idx : idx);

	...

	pebs_enable(pebs_bit, pebs_data_cfg);

	...

	check_pebs_records(pebs_bits, pebs_data_cfg);

> +	workload();
> +	pebs_disable(idx);
> +	check_pebs_records(BIT_ULL(type == FIXED ? INTEL_PMC_IDX_FIXED + idx : idx), pebs_data_cfg);
> +	report_prefix_pop();
> +}
> +
> +static void check_multiple_counters(u64 bitmask, u64 pebs_data_cfg)
> +{
> +	pmu_env_cleanup();
> +	pebs_enable(bitmask, pebs_data_cfg);
> +	workload2();


> +	pebs_disable(0);

Too much magic.  Looks like the intent is to trigger writes to both MSRs, but why?

> +	check_pebs_records(bitmask, pebs_data_cfg);
> +}
> +
> +static void check_pebs_counters(u64 pebs_data_cfg)
> +{
> +	unsigned int idx;
> +	u64 bitmask = 0;
> +
> +	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++)
> +		check_one_counter(FIXED, idx, pebs_data_cfg);
> +
> +	for (idx = 0; idx < max_nr_gp_events; idx++)
> +		check_one_counter(GP, idx, pebs_data_cfg);
> +
> +	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++)
> +		bitmask |= BIT_ULL(INTEL_PMC_IDX_FIXED + idx);
> +	for (idx = 0; idx < max_nr_gp_events; idx += 2)
> +		bitmask |= BIT_ULL(idx);
> +	report_prefix_pushf("Multiple (0x%lx)", bitmask);
> +	check_multiple_counters(bitmask, pebs_data_cfg);
> +	report_prefix_pop();
> +}
> +
> +int main(int ac, char **av)
> +{
> +	unsigned int i, j;
> +
> +	setup_vm();
> +
> +	max_nr_gp_events = MIN(pmu_nr_gp_counters(), ARRAY_SIZE(intel_arch_events));
> +
> +	printf("PMU version: %d\n", pmu_version());
> +	if (this_cpu_has(X86_FEATURE_PDCM))
> +		perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> +
> +	if (perf_cap & PMU_CAP_FW_WRITES)
> +		gp_counter_base = MSR_IA32_PMC0;
> +
> +	if (!is_intel()) {
> +		report_skip("PEBS is only supported on Intel CPUs (ICX or later)");

State exactly what check failed so that the user doesn't need to look at the code
to understand exactly what failed.  E.g. the "ICX or later" can be interpreted as
"the check failed because it's not ICX+", but that's not what the code does.

		report_skip("PEBS requires Intel ICX or later, non-Intel detected");

> +		return report_summary();
> +	} else if (pmu_version() < 2) {
> +		report_skip("Architectural PMU version is not high enough");

Again, unnecessarily vague.  Don't make the user read the code, provide all the info
in the error message.

		report_skip("PEBS required PMU version 2, reported version is %d",
			    pmu_version());
		
> +		return report_summary();
> +	} else if (!pebs_format()) {
> +		report_skip("PEBS not enumerated in PERF_CAPABILITIES");
> +		return report_summary();
> +	} else if (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL) {
> +		report_skip("PEBS unavailable according to MISC_ENABLE");
> +		return report_summary();
> +	}
> +
> +	printf("PEBS format: %d\n", pebs_format());
> +	printf("PEBS GP counters: %d\n", pmu_nr_gp_counters());
> +	printf("PEBS Fixed counters: %d\n", pmu_nr_fixed_counters());
> +	printf("PEBS baseline (Adaptive PEBS): %d\n", pebs_has_baseline());
> +
> +	printf("Known reasons for none PEBS records:\n");
> +	printf("1. The selected event does not support PEBS;\n");
> +	printf("2. From a core pmu perspective, the vCPU and pCPU models are not same;\n");
> +	printf("3. Guest counter has not yet overflowed or been cross-mapped by the host;\n");

Printing this every time the test is run is confusing.  If the goal is to help
users debug failures, then a comment will probably suffice.  

> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 01d775e..d55db99 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -198,6 +198,13 @@ check = /sys/module/kvm/parameters/ignore_msrs=N
>  check = /proc/sys/kernel/nmi_watchdog=0
>  accel = kvm
>  
> +[pmu_pebs]
> +arch = x86_64
> +file = pmu_pebs.flat
> +extra_params = -cpu host,migratable=no
> +check = /proc/sys/kernel/nmi_watchdog=0
> +accel = kvm

In a separate commit, add a group for this and all other PMU tests

  groups = pmu

so that it's easy to run all PMU tests, e.g. when making PMU KVM changes.
