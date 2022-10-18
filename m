Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7FE6027C7
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 11:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiJRJBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 05:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiJRJB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 05:01:27 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A214A98FA
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 02:01:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h12so13436563pjk.0
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 02:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5ZWdXexZHyYB2NyFo9kSQHrpgh2CO9hnccgz7KETG20=;
        b=MqvZsw8TV4TN3TNXj9ys8Q1Pb/rLhSBxqiRxStcXdeCfTbcfea9+jxohHChhL3OEjH
         HXK7p5iuEqhdwYTvJFGa7Jt8+FM7Ik6ubZS5w81uZnj9k5jG9u5x1Qm8xgO6p0+oT9Bl
         VRXnSNAHXiU0UmTFeJxIzmd+DQQvYmAJOwph7cPjoLH501Rv7Bqqje9r3LzzBkusTWzZ
         LfeRhErU2hMRTji5R81ixXgIrhX6xTztEv3ujr2RU7MtvEvqKfn5t4q82aKjMEIoR/g7
         FJO+J4F3rXvRO7KaPblL13e0+v18t7o4MMlPAwBcgKN3Ko8RpJyLbdNqC+EU5DHFiLZR
         YlPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ZWdXexZHyYB2NyFo9kSQHrpgh2CO9hnccgz7KETG20=;
        b=gyfkf67SSfdAWF8NnY4u6LDwbAq7uNPQx7OSgZVChSF0BZ0voI4d93F2/oPp8L18ux
         98Qs7igkr8sEKhdG6UsH520wnNHzKfHJrfTyyhcXJKN11mEKM6TPj0Ev/fA2iA4MfTNF
         DzpOoHnhT7bHSJx+3DEUIe3OyL9nWKnCwXvV67nbLo0QUPd/N1J0N9Y9JsTM4ALocxxi
         rp+/9wRdj6P8KqseMW1kYq5eh2gvk+8QlC6l7i6DLs3NQVSQyEcBQQjEbxiLO8U+0Vq/
         slQC59ZZkLjdr24euk2kgo1zi9wRZaquiQuYYuGozDkvL/A8nJ4pewIkw0uO2x/ry+nW
         wvHA==
X-Gm-Message-State: ACrzQf04pEMtEfmc2zjK76FCXlxS3KwHmYNy2pviKxmH5z//yttmbl8J
        /4hMHwg0XClmwU+mndpHwk4cskf0qstUOzcx
X-Google-Smtp-Source: AMsMyM6aAcWovWuCVSubUhTsKTW8nN/SSQJl0u8vfWS0cJuq1vIeawtFoKhOQSMQrzAt91HWs6I4Ew==
X-Received: by 2002:a17:902:c40d:b0:17f:7ef6:57cd with SMTP id k13-20020a170902c40d00b0017f7ef657cdmr1948421plk.151.1666083672387;
        Tue, 18 Oct 2022 02:01:12 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090a784e00b001ef81574355sm10898078pjl.12.2022.10.18.02.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 02:01:11 -0700 (PDT)
Message-ID: <fe9d582b-aae0-d219-863a-dbdca988e1d6@gmail.com>
Date:   Tue, 18 Oct 2022 17:01:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [kvm-unit-tests PATCH v2] x86: Add tests for Guest Processor
 Event Based Sampling (PEBS)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20220728112119.58173-1-likexu@tencent.com>
 <Yz3XiP6GBp95YEW9@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Yz3XiP6GBp95YEW9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most of the comments will be addressed in the next version.

On 6/10/2022 3:14 am, Sean Christopherson wrote:
> On Thu, Jul 28, 2022, Like Xu wrote:
>> +#include "vm.h"
>> +#include "types.h"
>> +#include "processor.h"
>> +#include "vmalloc.h"
>> +#include "alloc_page.h"
>> +
>> +#define PC_VECTOR	32
> 
> PC?

Part of legacy code, may be "performance counter vector" ?
It will be reused in the new lib/pmu.h.

> 
>> +
>> +#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
> 
> This belongs in lib/x86/processor.h, e.g. it'll also be used for the pmu_lbr tests.

Applied.

> 
>> +#define PERF_CAP_PEBS_FORMAT           0xf00
>> +#define PMU_CAP_FW_WRITES	(1ULL << 13)
>> +#define PMU_CAP_PEBS_BASELINE	(1ULL << 14)
>> +
>> +#define INTEL_PMC_IDX_FIXED				       32
>> +
>> +#define GLOBAL_STATUS_BUFFER_OVF_BIT		62
>> +#define GLOBAL_STATUS_BUFFER_OVF	BIT_ULL(GLOBAL_STATUS_BUFFER_OVF_BIT)
>> +
>> +#define EVNTSEL_USR_SHIFT       16
>> +#define EVNTSEL_OS_SHIFT        17
>> +#define EVNTSEL_EN_SHIF         22
>> +
>> +#define EVNTSEL_EN      (1 << EVNTSEL_EN_SHIF)
>> +#define EVNTSEL_USR     (1 << EVNTSEL_USR_SHIFT)
>> +#define EVNTSEL_OS      (1 << EVNTSEL_OS_SHIFT)
>> +
>> +#define PEBS_DATACFG_MEMINFO	BIT_ULL(0)
>> +#define PEBS_DATACFG_GP	BIT_ULL(1)
>> +#define PEBS_DATACFG_XMMS	BIT_ULL(2)
>> +#define PEBS_DATACFG_LBRS	BIT_ULL(3)
>> +
>> +#define ICL_EVENTSEL_ADAPTIVE				(1ULL << 34)
>> +#define PEBS_DATACFG_LBR_SHIFT	24
>> +#define MAX_NUM_LBR_ENTRY	32
> 
> Given all the PMU stuff coming in, I think we need e.g. lib/x86/pmu.h to hold all
> of the hardware-defined stuff, e.g. #defines and structs that are dictated by
> hardware.

Applied.

> 
>> +static inline u8 pebs_format(void)
>> +{
>> +	return (perf_cap & PERF_CAP_PEBS_FORMAT ) >> 8;
>> +}
>> +
>> +static inline bool pebs_has_baseline(void)
>> +{
>> +	return perf_cap & PMU_CAP_PEBS_BASELINE;
>> +}
> 
> These types of accessors can also go in pmu.h.  The easy thing is to just re-read
> PERF_CAPABILITIES every time, the overhead of the VM-Exit to emulate the RDMSR
> isn't meaningless in the grand scheme of the test.

More helpers will be added into lib/pmu.h.

> 
>> +static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
>> +{
>> +	static struct debug_store *ds;
>> +	u64 baseline_extra_ctrl, fixed_ctr_ctrl = 0;
>> +	unsigned int idx;
>> +
>> +	if (pebs_has_baseline())
> 
> This function can snapshot pebs_has_baseline() to avoid RDMSR on every touch.

Applied.

> 
>> +		wrmsr(MSR_PEBS_DATA_CFG, pebs_data_cfg);
>> +
>> +	ds = (struct debug_store *)ds_bufer;
>> +	ds->pebs_index = ds->pebs_buffer_base = (unsigned long)pebs_buffer;
>> +	ds->pebs_absolute_maximum = (unsigned long)pebs_buffer + PAGE_SIZE;
>> +	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
>> +		get_adaptive_pebs_record_size(pebs_data_cfg);
>> +
>> +	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++) {
>> +		if (!(BIT_ULL(INTEL_PMC_IDX_FIXED + idx) & bitmask))
>> +			continue;
>> +		baseline_extra_ctrl = pebs_has_baseline() ?
>> +			(1ULL << (INTEL_PMC_IDX_FIXED + idx * 4)) : 0;
> 
> Init baseline_extra_ctrl to zero outside of the loop, then this can avoid the
> ternary operator:

Fine to me, and why the C ternary operator is not welcome.

> 
> 		if (has_baseline)
> 			baseline_extra_ctrl = BIT(INTEL_PMC_IDX_FIXED + idx * 4);
> 
>> +		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + idx, ctr_start_val);
> 
> Helpers (or macros?) to read/write counter MSRs would improve readability.

Emm, write_fixed_counter_value(idx, value);

> 
>> +		fixed_ctr_ctrl |= (0xbULL << (idx * 4) | baseline_extra_ctrl);
>> +	}
>> +	if (fixed_ctr_ctrl)
>> +		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, fixed_ctr_ctrl);
>> +
>> +	for (idx = 0; idx < max_nr_gp_events; idx++) {
>> +		if (!(BIT_ULL(idx) & bitmask))
>> +			continue;
>> +		baseline_extra_ctrl = pebs_has_baseline() ?
>> +			ICL_EVENTSEL_ADAPTIVE : 0;
> 
> Same thing as above, rely on the "has_baseline" not changing to avoid the ternary
> operator.
> 
>> +		wrmsr(MSR_P6_EVNTSEL0 + idx,
> 
> Add a helper/macro instead of manually indexing?

Emm, write_gp_event_select(...)

> 
>> +		      EVNTSEL_EN | EVNTSEL_OS | EVNTSEL_USR |
>> +		      intel_arch_events[idx] | baseline_extra_ctrl);
>> +		wrmsr(gp_counter_base + idx, ctr_start_val);
> 
> Continuing the theme of code reuse, please add a lib/pmu.c and move common code
> and variables there, e.g. tests shouldn't need to manually compute gp_counter_base.
> A common "PMU init" routine would allow the library to provide helpers for accessing
> GP counters too.

Applied, and some gloabl varibles are added to lib/pmu.c

> 
>> +	}
>> +
>> +	wrmsr(MSR_IA32_DS_AREA,  (unsigned long)ds_bufer);
>> +	wrmsr(MSR_IA32_PEBS_ENABLE, bitmask);
>> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, bitmask);
>> +}
>> +
>> +static void pmu_env_cleanup(void)
> 
> This is probably a good candidate for library code.  And maybe reset_pmu() or so
> to provide a hint that this is often called _before_ running tests?

It will be renamed to reset_pebs() in the pebs specific src file.

> 
>> +{
>> +	unsigned int idx;
>> +
>> +	memset(ds_bufer, 0x0, PAGE_SIZE);
>> +	memset(pebs_buffer, 0x0, PAGE_SIZE);
>> +	wrmsr(MSR_IA32_PEBS_ENABLE, 0);
>> +	wrmsr(MSR_IA32_DS_AREA,  0);
>> +	if (pebs_has_baseline())
>> +		wrmsr(MSR_PEBS_DATA_CFG, 0);
>> +
>> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>> +
>> +	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>> +	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++) {
> 
> Curly braces aren't necessary.  And rather than call a function every time,
> add a global struct in the library to track the PMU capabilities.

The this_cpu_perf_capabilities() may help.
And, reset_all_{gp, fixed}_counters() are added into lib/pmu.h

> 
>> +		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + idx, 0);
>> +	}
>> +
>> +	for (idx = 0; idx < pmu_nr_gp_counters(); idx++) {
>> +		wrmsr(MSR_P6_EVNTSEL0 + idx, 0);
>> +		wrmsr(MSR_IA32_PERFCTR0 + idx, 0);
>> +	}
>> +
>> +	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
>> +}
>> +
>> +static inline void pebs_disable_1(void)
>> +{
>> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>> +}
>> +
>> +static inline void pebs_disable_2(void)
>> +{
>> +	wrmsr(MSR_IA32_PEBS_ENABLE, 0);
>> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>> +}
>> +
>> +static void pebs_disable(unsigned int idx)
>> +{
>> +	if (idx % 2) {
> 
> Curly braces unnecessary.  That said, the helpers do not help.  It's much easier
> to do:
> 
> 	/* comment goes here */
> 	if (idx % 2)
> 		wrmsr(MSR_IA32_PEBS_ENABLE, 0);
> 
> 	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);

Applied.

> 
> Please add a comment, it's not at all obvious to me (non-PMU person) what this
> code is doing.
> 
>> +		pebs_disable_1();
>> +	} else {
>> +		pebs_disable_2();
>> +	}
>> +}

If we only clear the PEBS_ENABLE bit, the counter will continue to increment.
In this very tiny time window, if the counter overflows no pebs record will be 
generated,
but a normal counter irq. Test this fully with two ways.

>> +
>> +static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
>> +{
>> +	struct pebs_basic *pebs_rec = (struct pebs_basic *)pebs_buffer;
>> +	struct debug_store *ds = (struct debug_store *)ds_bufer;
>> +	unsigned int pebs_record_size = get_adaptive_pebs_record_size(pebs_data_cfg);
>> +	unsigned int count = 0;
>> +	bool expected, pebs_idx_match, pebs_size_match, data_cfg_match;
>> +	void *vernier;
>> +
>> +	expected = (ds->pebs_index == ds->pebs_buffer_base) && !pebs_rec->format_size;
>> +	if (!(rdmsr(MSR_CORE_PERF_GLOBAL_STATUS) & GLOBAL_STATUS_BUFFER_OVF)) {
>> +		report(expected, "No OVF irq, none PEBS records.");
>> +		return;
>> +	}
>> +
>> +	if (expected) {
>> +		report(!expected, "A OVF irq, but none PEBS records.");
>> +		return;
>> +	}
>> +
>> +	expected = ds->pebs_index >= ds->pebs_interrupt_threshold;
>> +	vernier = (void *)pebs_buffer;
> 
> Heh, I have zero clue what vernier means here.  Dictionary says:
> 
>    a small movable graduated scale for obtaining fractional parts of
>    subdivisions on a fixed main scale of a barometer, sextant, or other measuring
>    instrument.
> 
> but that doesn't help me understand what this is doing.

Rename it to "cur_record".

> 
>> +	do {
>> +		pebs_rec = (struct pebs_basic *)vernier;
>> +		pebs_record_size = pebs_rec->format_size >> 48;
> 
> Add a #define instead of open coding a magic number.

/* bits [63:48] provides the size of the current record in bytes */
#define	RECORD_SIZE_OFFSET	48

> 
>> +		pebs_idx_match =
>> +			pebs_rec->applicable_counters & bitmask;
>> +		pebs_size_match =
>> +			pebs_record_size == get_adaptive_pebs_record_size(pebs_data_cfg);
>> +		data_cfg_match =
>> +			(pebs_rec->format_size & 0xffffffffffff) == pebs_data_cfg;
> 
> Please use GENMASK_ULL.

GENMASK_ULL(47, 0)

> 
>> +		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
>> +		report(expected,
>> +		       "PEBS record (written seq %d) is verified (inclduing size, counters and cfg).", count);
>> +		vernier = vernier + pebs_record_size;
>> +		count++;
>> +	} while (expected && (void *)vernier < (void *)ds->pebs_index);
>> +
>> +	if (!expected) {
>> +		if (!pebs_idx_match)
>> +			printf("FAIL: The applicable_counters (0x%lx) doesn't match with pmc_bitmask (0x%lx).\n",
>> +			       pebs_rec->applicable_counters, bitmask);
>> +		if (!pebs_size_match)
>> +			printf("FAIL: The pebs_record_size (%d) doesn't match with MSR_PEBS_DATA_CFG (%d).\n",
>> +			       pebs_record_size, get_adaptive_pebs_record_size(pebs_data_cfg));
>> +		if (!data_cfg_match)
>> +			printf("FAIL: The pebs_data_cfg (0x%lx) doesn't match with MSR_PEBS_DATA_CFG (0x%lx).\n",
>> +			       pebs_rec->format_size & 0xffffffffffff, pebs_data_cfg);
>> +	}
>> +}
>> +
>> +static void check_one_counter(enum pmc_type type,
>> +			      unsigned int idx, u64 pebs_data_cfg)
>> +{
>> +	report_prefix_pushf("%s counter %d (0x%lx)",
>> +			    type == FIXED ? "Extended Fixed" : "GP", idx, ctr_start_val);
>> +	pmu_env_cleanup();
>> +	pebs_enable(BIT_ULL(type == FIXED ? INTEL_PMC_IDX_FIXED + idx : idx), pebs_data_cfg);
> 
> Please avoid burying ternary operators like this, it makes the code hard to follow
> because it's difficult to visually identify what goes with what.  You can also
> avoid copy+paste...
> 
> 	int pebs_bit = BIT_ULL(type == FIXED ? INTEL_PMC_IDX_FIXED + idx : idx);
> 
> 	...
> 
> 	pebs_enable(pebs_bit, pebs_data_cfg);
> 
> 	...
> 
> 	check_pebs_records(pebs_bits, pebs_data_cfg);

Applied.

> 
>> +	workload();
>> +	pebs_disable(idx);
>> +	check_pebs_records(BIT_ULL(type == FIXED ? INTEL_PMC_IDX_FIXED + idx : idx), pebs_data_cfg);
>> +	report_prefix_pop();
>> +}
>> +
>> +static void check_multiple_counters(u64 bitmask, u64 pebs_data_cfg)
>> +{
>> +	pmu_env_cleanup();
>> +	pebs_enable(bitmask, pebs_data_cfg);
>> +	workload2();
> 
> 
>> +	pebs_disable(0);
> 
> Too much magic.  Looks like the intent is to trigger writes to both MSRs, but why?

In this case, more than one PEBS records will be generated (from more than one 
counters).

> 
>> +	check_pebs_records(bitmask, pebs_data_cfg);
>> +}
>> +
>> +static void check_pebs_counters(u64 pebs_data_cfg)
>> +{
>> +	unsigned int idx;
>> +	u64 bitmask = 0;
>> +
>> +	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++)
>> +		check_one_counter(FIXED, idx, pebs_data_cfg);
>> +
>> +	for (idx = 0; idx < max_nr_gp_events; idx++)
>> +		check_one_counter(GP, idx, pebs_data_cfg);
>> +
>> +	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++)
>> +		bitmask |= BIT_ULL(INTEL_PMC_IDX_FIXED + idx);
>> +	for (idx = 0; idx < max_nr_gp_events; idx += 2)
>> +		bitmask |= BIT_ULL(idx);
>> +	report_prefix_pushf("Multiple (0x%lx)", bitmask);
>> +	check_multiple_counters(bitmask, pebs_data_cfg);
>> +	report_prefix_pop();
>> +}
>> +
>> +int main(int ac, char **av)
>> +{
>> +	unsigned int i, j;
>> +
>> +	setup_vm();
>> +
>> +	max_nr_gp_events = MIN(pmu_nr_gp_counters(), ARRAY_SIZE(intel_arch_events));
>> +
>> +	printf("PMU version: %d\n", pmu_version());
>> +	if (this_cpu_has(X86_FEATURE_PDCM))
>> +		perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
>> +
>> +	if (perf_cap & PMU_CAP_FW_WRITES)
>> +		gp_counter_base = MSR_IA32_PMC0;
>> +
>> +	if (!is_intel()) {
>> +		report_skip("PEBS is only supported on Intel CPUs (ICX or later)");
> 
> State exactly what check failed so that the user doesn't need to look at the code
> to understand exactly what failed.  E.g. the "ICX or later" can be interpreted as
> "the check failed because it's not ICX+", but that's not what the code does.

Applied.

> 
> 		report_skip("PEBS requires Intel ICX or later, non-Intel detected");
> 
>> +		return report_summary();
>> +	} else if (pmu_version() < 2) {
>> +		report_skip("Architectural PMU version is not high enough");
> 
> Again, unnecessarily vague.  Don't make the user read the code, provide all the info
> in the error message.
> 
> 		report_skip("PEBS required PMU version 2, reported version is %d",
> 			    pmu_version());

Applied.

> 		
>> +		return report_summary();
>> +	} else if (!pebs_format()) {
>> +		report_skip("PEBS not enumerated in PERF_CAPABILITIES");
>> +		return report_summary();
>> +	} else if (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL) {
>> +		report_skip("PEBS unavailable according to MISC_ENABLE");
>> +		return report_summary();
>> +	}
>> +
>> +	printf("PEBS format: %d\n", pebs_format());
>> +	printf("PEBS GP counters: %d\n", pmu_nr_gp_counters());
>> +	printf("PEBS Fixed counters: %d\n", pmu_nr_fixed_counters());
>> +	printf("PEBS baseline (Adaptive PEBS): %d\n", pebs_has_baseline());
>> +
>> +	printf("Known reasons for none PEBS records:\n");
>> +	printf("1. The selected event does not support PEBS;\n");
>> +	printf("2. From a core pmu perspective, the vCPU and pCPU models are not same;\n");
>> +	printf("3. Guest counter has not yet overflowed or been cross-mapped by the host;\n");
> 
> Printing this every time the test is run is confusing.  If the goal is to help
> users debug failures, then a comment will probably suffice.

Applied.

> 
>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>> index 01d775e..d55db99 100644
>> --- a/x86/unittests.cfg
>> +++ b/x86/unittests.cfg
>> @@ -198,6 +198,13 @@ check = /sys/module/kvm/parameters/ignore_msrs=N
>>   check = /proc/sys/kernel/nmi_watchdog=0
>>   accel = kvm
>>   
>> +[pmu_pebs]
>> +arch = x86_64
>> +file = pmu_pebs.flat
>> +extra_params = -cpu host,migratable=no
>> +check = /proc/sys/kernel/nmi_watchdog=0
>> +accel = kvm
> 
> In a separate commit, add a group for this and all other PMU tests
> 
>    groups = pmu
> 
> so that it's easy to run all PMU tests, e.g. when making PMU KVM changes.
