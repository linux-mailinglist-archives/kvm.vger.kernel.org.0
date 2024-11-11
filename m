Return-Path: <kvm+bounces-31475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 317A39C3FCF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:48:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E517028554F
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E521619CC3F;
	Mon, 11 Nov 2024 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JaeLS/Lw"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1374C1DA53
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731332912; cv=none; b=XRe79jTCwKjP4J4BtainX1wFNmobulFERO3pKCWMYvLGWZjjkNEFhk3wfSjqsbbFxwUV2BEUfWdlVjoKevg+QtSz6s2hZBb/Waz3q9N6u3RF9G/absDVWI2YJ9R2799QNYBn2we/3fjd/FZwDyLA8HgPfg2xvWh/PmrQZKrZnOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731332912; c=relaxed/simple;
	bh=N+OpVSY+ZpLEA+i2JFRbofR5TZQtBbejJaiHBY0tgQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZKqVgofCHZpkmhViR622Wq7Z3J8OL+QW/g1UcT+8A4gTv87djbv62ajWdsZptI0Q270d/Q8fmXhjUFEzV4z+ZoQW+WjKsCpuklJckuQvfieOuKwmjkO+RCI0L7h0u5UwcafQoSpJbl1JtxpsU7z6MIVscE2a6qx6vVgTaqVbl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JaeLS/Lw; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 14:48:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731332907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tfSl/dZpCrpMHwYeZmZHHEfOGR4QZTmdAfp69ttdR2A=;
	b=JaeLS/LwDoWChVt5R9ZJmGEVP1xHuYjS0w7XZAdDSyl9D0AAYIP8qVj4QujYjlUBJR3hDL
	/d66qhP0MzhATz2OCHHA8wHUAR8gMQ0Aeb0c61NGrNojouuVPR5sYoR5FKp+c+n1f/HY39
	6hm64v1jCd7TBze9w8NTM4YwVLy86Yw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v7 2/2] riscv: sbi: Add tests for HSM
 extension
Message-ID: <20241111-f0c1e97108e8eb00208c61c8@orel>
References: <20241110171633.113515-1-jamestiotio@gmail.com>
 <20241110171633.113515-3-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241110171633.113515-3-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 11, 2024 at 01:16:33AM +0800, James Raphael Tiovalen wrote:
> Add some tests for all of the HSM extension functions. These tests
> ensure that the HSM extension functions follow the behavior as described
> in the SBI specification.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  riscv/sbi.c | 612 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 612 insertions(+)
> 
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 300e5cc9..021b606c 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -21,6 +21,7 @@
>  #include <asm/delay.h>
>  #include <asm/io.h>
>  #include <asm/mmu.h>
> +#include <asm/page.h>
>  #include <asm/processor.h>
>  #include <asm/sbi.h>
>  #include <asm/setup.h>
> @@ -54,6 +55,11 @@ static struct sbiret sbi_dbcn_write_byte(uint8_t byte)
>  	return sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, byte, 0, 0, 0, 0, 0);
>  }
>  
> +static struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
> +{
> +	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
> +}
> +
>  static struct sbiret sbi_system_suspend(uint32_t sleep_type, unsigned long resume_addr, unsigned long opaque)
>  {
>  	return sbi_ecall(SBI_EXT_SUSP, 0, sleep_type, resume_addr, opaque, 0, 0, 0);
> @@ -834,6 +840,611 @@ static void check_susp(void)
>  	report_prefix_pop();
>  }
>  
> +static const char *hart_state_str[] = {
> +	[SBI_EXT_HSM_STARTED] = "started",
> +	[SBI_EXT_HSM_STOPPED] = "stopped",
> +	[SBI_EXT_HSM_SUSPENDED] = "suspended",
> +};
> +struct hart_state_transition_info {
> +	enum sbi_ext_hsm_sid initial_state;
> +	enum sbi_ext_hsm_sid intermediate_state;
> +	enum sbi_ext_hsm_sid final_state;
> +};
> +static cpumask_t sbi_hsm_started_hart_checks;
> +static bool sbi_hsm_invalid_hartid_check;
> +static bool sbi_hsm_timer_fired;
> +extern void sbi_hsm_check_hart_start(void);
> +extern void sbi_hsm_check_non_retentive_suspend(void);
> +
> +static void hsm_timer_irq_handler(struct pt_regs *regs)
> +{
> +	timer_stop();
> +	sbi_hsm_timer_fired = true;
> +}
> +
> +static void hsm_timer_setup(void)
> +{
> +	install_irq_handler(IRQ_S_TIMER, hsm_timer_irq_handler);
> +	timer_irq_enable();
> +}
> +
> +static void hsm_timer_teardown(void)
> +{
> +	timer_irq_disable();
> +	install_irq_handler(IRQ_S_TIMER, NULL);
> +}
> +
> +static void hart_check_already_started(void *data)
> +{
> +	struct sbiret ret;
> +	unsigned long hartid = current_thread_info()->hartid;
> +	int me = smp_processor_id();
> +
> +	ret = sbi_hart_start(hartid, virt_to_phys(&start_cpu), 0);
> +
> +	if (ret.error == SBI_ERR_ALREADY_AVAILABLE)
> +		cpumask_set_cpu(me, &sbi_hsm_started_hart_checks);
> +}
> +
> +static void hart_start_invalid_hartid(void *data)
> +{
> +	struct sbiret ret;
> +
> +	ret = sbi_hart_start(-1UL, virt_to_phys(&start_cpu), 0);
> +
> +	if (ret.error == SBI_ERR_INVALID_PARAM)
> +		sbi_hsm_invalid_hartid_check = true;
> +}
> +
> +static void hart_stop(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +	struct sbiret ret = sbi_hart_stop();
> +
> +	report_fail("failed to stop hart %ld (error=%ld)", hartid, ret.error);
> +}

We already have stop_cpu() and can just extend it to also output hartid.
And hartids should be output in hex since they can be sparse.

> +
> +static void hart_retentive_suspend(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_RETENTIVE, 0, 0);
> +
> +	if (ret.error)
> +		report_fail("failed to retentive suspend hart %ld (error=%ld)", hartid, ret.error);

Instead of 'hart %ld', let's use 'cpu%d (hartid = %lx)'
Same comment for the other functions below.

> +}
> +
> +static void hart_non_retentive_suspend(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +	unsigned long params[] = {
> +		[SBI_HSM_MAGIC_IDX] = SBI_HSM_MAGIC,
> +		[SBI_HSM_HARTID_IDX] = hartid,
> +	};
> +	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE,
> +					     virt_to_phys(&sbi_hsm_check_non_retentive_suspend),
> +					     virt_to_phys(params));
> +
> +	report_fail("failed to non-retentive suspend hart %ld (error=%ld)", hartid, ret.error);
> +}
> +
> +/* This test function is only being run on RV64 to verify that upper bits of suspend_type are ignored */
> +static void hart_retentive_suspend_with_msb_set(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +	unsigned long suspend_type = SBI_EXT_HSM_HART_SUSPEND_RETENTIVE | (_AC(1, UL) << (__riscv_xlen - 1));
> +	struct sbiret ret = sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, 0, 0, 0, 0, 0);
> +
> +	if (ret.error)
> +		report_fail("failed to retentive suspend hart %ld with MSB set (error=%ld)", hartid, ret.error);
> +}
> +
> +/* This test function is only being run on RV64 to verify that upper bits of suspend_type are ignored */
> +static void hart_non_retentive_suspend_with_msb_set(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +	unsigned long suspend_type = SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE | (_AC(1, UL) << (__riscv_xlen - 1));
> +	unsigned long params[] = {
> +		[SBI_HSM_MAGIC_IDX] = SBI_HSM_MAGIC,
> +		[SBI_HSM_HARTID_IDX] = hartid,
> +	};
> +
> +	struct sbiret ret = sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type,
> +				      virt_to_phys(&sbi_hsm_check_non_retentive_suspend), virt_to_phys(params),
> +				      0, 0, 0);
> +
> +	report_fail("failed to non-retentive suspend hart %ld with MSB set (error=%ld)", hartid, ret.error);
> +}
> +
> +static bool hart_wait_on_status(unsigned long hartid, enum sbi_ext_hsm_sid status, unsigned long duration)
> +{
> +	struct sbiret ret;
> +
> +	sbi_hsm_timer_fired = false;
> +	timer_start(duration);
> +
> +	ret = sbi_hart_get_status(hartid);
> +
> +	while (!ret.error && ret.value == status && !sbi_hsm_timer_fired) {
> +		cpu_relax();
> +		ret = sbi_hart_get_status(hartid);
> +	}
> +
> +	timer_stop();
> +
> +	if (sbi_hsm_timer_fired)
> +		report_info("timer fired while waiting on status %u for hart %ld", status, hartid);
> +	else if (ret.error)
> +		report_fail("got %ld while waiting on status %u for hart %ld\n", ret.error, status, hartid);
> +
> +	return !sbi_hsm_timer_fired && !ret.error;
> +}
> +
> +static int hart_wait_state_transition(cpumask_t mask, unsigned long duration, struct hart_state_transition_info states)

Why pass a copy of the cpumask instead of passing it by reference?
Same question for the states struct.

> +{
> +	struct sbiret ret;
> +	unsigned long hartid;
> +	int cpu, count = 0;
> +
> +	for_each_cpu(cpu, &mask) {
> +		hartid = cpus[cpu].hartid;
> +		if (!hart_wait_on_status(hartid, states.initial_state, duration))
> +			continue;
> +		if (!hart_wait_on_status(hartid, states.intermediate_state, duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != states.final_state)
> +			report_info("hart %ld status is not '%s' (ret.value=%ld)", hartid,
> +				    hart_state_str[states.final_state], ret.value);
> +		else
> +			count++;
> +	}
> +
> +	return count;
> +}
> +
> +static void hart_wait_until_idle(int max_cpus, unsigned long duration)
> +{
> +	sbi_hsm_timer_fired = false;
> +	timer_start(duration);
> +
> +	while (cpumask_weight(&cpu_idle_mask) != max_cpus - 1 && !sbi_hsm_timer_fired)

The prefix 'max_' doesn't make much sense in this context, it's just a
parameter which isn't relative to anything else in this scope. That also
means that subtracting one from it seems like an odd thing to do. And,
looking ahead, I see we're not just waiting for the idle mask to have
that many arbitrary idle cpus, we're using this to check if all the cpus
in a particular mask are idle. That means we should be passing that mask
into this function and using cpumask_subset() for the check.

> +		cpu_relax();
> +
> +	timer_stop();
> +
> +	if (sbi_hsm_timer_fired)
> +		report_info("hsm timer fired before all secondary harts go to idle");

'all secondary' in this info line also means this function is specific to
a particular set of cpus. We should at least rename the function, then
we could either use cpumask_subset() as I point out above or still use
number of cpus, but rename 'max_cpus' to 'nr_secondaries' and not subtract
one. I think I prefer keeping it more generic by passing in a mask though,
as it would also be consistent with hart_wait_state_transition().

> +}
> +
> +static void check_hsm(void)
> +{
> +	struct sbiret ret;
> +	unsigned long hartid;
> +	cpumask_t secondary_cpus_mask;
> +	int hsm_start, hsm_stop, hsm_suspend, hsm_resume, hsm_check;

Isn't a single 'count' variable shared for all these tests sufficient?

> +	struct hart_state_transition_info transition_states;
> +	bool ipi_unavailable = false;
> +	bool suspend_with_msb = false, resume_with_msb = false, check_with_msb = false, stop_with_msb = false;

Isn't a single 'pass' boolean sufficient for all these tests? Actually, I
don't think we even need any boolean. See below.

> +	int cpu, me = smp_processor_id();
> +	int max_cpus = getenv("SBI_MAX_CPUS") ? strtol(getenv("SBI_MAX_CPUS"), NULL, 0) : nr_cpus;
> +	unsigned long hsm_timer_duration = getenv("SBI_HSM_TIMER_DURATION")
> +					 ? strtol(getenv("SBI_HSM_TIMER_DURATION"), NULL, 0) : 200000;
> +
> +	max_cpus = MIN(MIN(max_cpus, nr_cpus), cpumask_weight(&cpu_present_mask));
> +
> +	report_prefix_push("hsm");
> +
> +	if (!sbi_probe(SBI_EXT_HSM)) {
> +		report_skip("hsm extension not available");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	report_prefix_push("hart_get_status");
> +
> +	hartid = current_thread_info()->hartid;
> +	ret = sbi_hart_get_status(hartid);
> +
> +	if (ret.error) {
> +		report_fail("failed to get status of current hart (error=%ld)", ret.error);
> +		report_prefix_popn(2);
> +		return;
> +	} else if (ret.value != SBI_EXT_HSM_STARTED) {
> +		report_fail("current hart is not started (ret.value=%ld)", ret.value);
> +		report_prefix_popn(2);
> +		return;
> +	}
> +
> +	report_pass("status of current hart is started");
> +
> +	report_prefix_pop();
> +
> +	if (max_cpus < 2) {
> +		report_skip("no other cpus to run the remaining hsm tests on");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	report_prefix_push("hart_stop");
> +
> +	cpumask_copy(&secondary_cpus_mask, &cpu_present_mask);
> +	cpumask_clear_cpu(me, &secondary_cpus_mask);
> +	hsm_timer_setup();
> +	local_irq_enable();
> +
> +	/* Assume that previous tests have not cleaned up and stopped the secondary harts */
> +	on_cpumask_async(&secondary_cpus_mask, hart_stop, NULL);
> +
> +	transition_states = (struct hart_state_transition_info) {
> +		.initial_state = SBI_EXT_HSM_STARTED,
> +		.intermediate_state = SBI_EXT_HSM_STOP_PENDING,
> +		.final_state = SBI_EXT_HSM_STOPPED,
> +	};
> +	hsm_stop = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
> +
> +	report(hsm_stop == max_cpus - 1, "all secondary harts stopped");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_start");
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		sbi_hsm_hart_start_params[cpu * SBI_HSM_NUM_OF_PARAMS + SBI_HSM_MAGIC_IDX] = SBI_HSM_MAGIC;
> +		sbi_hsm_hart_start_params[cpu * SBI_HSM_NUM_OF_PARAMS + SBI_HSM_HARTID_IDX] = hartid;
> +
> +		ret = sbi_hart_start(hartid, virt_to_phys(&sbi_hsm_check_hart_start),
> +				     virt_to_phys(&sbi_hsm_hart_start_params[cpu * SBI_HSM_NUM_OF_PARAMS]));
> +		if (ret.error) {
> +			report_fail("failed to start test hart %ld (error=%ld)", hartid, ret.error);
> +			continue;
> +		}
> +	}
> +
> +	transition_states = (struct hart_state_transition_info) {
> +		.initial_state = SBI_EXT_HSM_STOPPED,
> +		.intermediate_state = SBI_EXT_HSM_START_PENDING,
> +		.final_state = SBI_EXT_HSM_STARTED,
> +	};
> +
> +	hsm_start = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
> +	hsm_check = 0;
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		sbi_hsm_timer_fired = false;
> +		timer_start(hsm_timer_duration);
> +
> +		while (!(READ_ONCE(sbi_hsm_hart_start_checks[cpu]) & SBI_HSM_TEST_DONE) && !sbi_hsm_timer_fired)
> +			cpu_relax();
> +
> +		timer_stop();
> +
> +		if (sbi_hsm_timer_fired) {
> +			report_info("hsm timer fired before hart %ld is done with start checks", hartid);
> +			continue;
> +		}
> +
> +		if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_SATP))
> +			report_info("satp is not zero for test hart %ld", hartid);
> +		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_SIE))
> +			report_info("sstatus.SIE is not zero for test hart %ld", hartid);
> +		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_MAGIC_A1))
> +			report_info("a1 does not start with magic for test hart %ld", hartid);
> +		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
> +			report_info("a0 is not hartid for test hart %ld", hartid);
> +		else
> +			hsm_check++;
> +	}
> +
> +	report(hsm_start == max_cpus - 1, "all secondary harts started");
> +	report(hsm_check == max_cpus - 1,
> +	       "all secondary harts have expected register values after hart start");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_stop");
> +
> +	memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
> +
> +	transition_states = (struct hart_state_transition_info) {
> +		.initial_state = SBI_EXT_HSM_STARTED,
> +		.intermediate_state = SBI_EXT_HSM_STOP_PENDING,
> +		.final_state = SBI_EXT_HSM_STOPPED,
> +	};
> +	hsm_stop = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
> +
> +	report(hsm_stop == max_cpus - 1, "all secondary harts stopped");
> +
> +	/* Reset the stop flags so that we can reuse them after suspension tests */
> +	memset(sbi_hsm_stop_hart, 0, sizeof(sbi_hsm_stop_hart));
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_start");
> +
> +	/* Select just one secondary cpu to run the invalid hartid test */
> +	on_cpu(cpumask_next(-1, &secondary_cpus_mask), hart_start_invalid_hartid, NULL);
> +
> +	report(sbi_hsm_invalid_hartid_check, "secondary hart refuse to start with invalid hartid");
> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_check_already_started, NULL);
> +
> +	transition_states = (struct hart_state_transition_info) {
> +		.initial_state = SBI_EXT_HSM_STOPPED,
> +		.intermediate_state = SBI_EXT_HSM_START_PENDING,
> +		.final_state = SBI_EXT_HSM_STARTED,
> +	};
> +
> +	hsm_start = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
> +
> +	report(hsm_start == max_cpus - 1, "all secondary harts started");
> +
> +	hart_wait_until_idle(max_cpus, hsm_timer_duration);
> +
> +	report(cpumask_weight(&cpu_idle_mask) == max_cpus - 1,
> +	       "all secondary harts successfully executed code after start");
> +	report(cpumask_weight(&cpu_online_mask) == max_cpus, "all secondary harts online");

The above two tests aren't really testing the SBI implementation as much as
they are the kvm-unit-tests framework. Let's just drop them.

> +	report(cpumask_weight(&sbi_hsm_started_hart_checks) == max_cpus - 1,
> +	       "all secondary harts are already started");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_suspend");
> +
> +	if (!sbi_probe(SBI_EXT_IPI)) {
> +		report_skip("skipping suspension tests since ipi extension is unavailable");
> +		report_prefix_pop();
> +		ipi_unavailable = true;
> +		goto sbi_hsm_hart_stop_tests;
> +	}
> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_retentive_suspend, NULL);
> +
> +	transition_states = (struct hart_state_transition_info) {
> +		.initial_state = SBI_EXT_HSM_STARTED,
> +		.intermediate_state = SBI_EXT_HSM_SUSPEND_PENDING,
> +		.final_state = SBI_EXT_HSM_SUSPENDED,
> +	};
> +
> +	hsm_suspend = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
> +
> +	report(hsm_suspend == max_cpus - 1, "all secondary harts retentive suspended");
> +
> +	/* Ignore the return value since we check the status of each hart anyway */
> +	sbi_send_ipi_cpumask(&secondary_cpus_mask);
> +
> +	transition_states = (struct hart_state_transition_info) {
> +		.initial_state = SBI_EXT_HSM_SUSPENDED,
> +		.intermediate_state = SBI_EXT_HSM_RESUME_PENDING,
> +		.final_state = SBI_EXT_HSM_STARTED,
> +	};
> +
> +	hsm_resume = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
> +
> +	report(hsm_resume == max_cpus - 1, "all secondary harts retentive resumed");
> +
> +	hart_wait_until_idle(max_cpus, hsm_timer_duration);
> +
> +	report(cpumask_weight(&cpu_idle_mask) == max_cpus - 1,
> +	       "all secondary harts successfully executed code after retentive suspend");
> +	report(cpumask_weight(&cpu_online_mask) == max_cpus,
> +	       "all secondary harts online");

Same comment as above. We can drop these.

> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_non_retentive_suspend, NULL);
> +
> +	transition_states = (struct hart_state_transition_info) {
> +		.initial_state = SBI_EXT_HSM_STARTED,
> +		.intermediate_state = SBI_EXT_HSM_SUSPEND_PENDING,
> +		.final_state = SBI_EXT_HSM_SUSPENDED,
> +	};
> +
> +	hsm_suspend = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
> +
> +	report(hsm_suspend == max_cpus - 1, "all secondary harts non-retentive suspended");
> +
> +	/* Ignore the return value since we check the status of each hart anyway */
> +	sbi_send_ipi_cpumask(&secondary_cpus_mask);
> +
> +	transition_states = (struct hart_state_transition_info) {
> +		.initial_state = SBI_EXT_HSM_SUSPENDED,
> +		.intermediate_state = SBI_EXT_HSM_RESUME_PENDING,
> +		.final_state = SBI_EXT_HSM_STARTED,
> +	};
> +
> +	hsm_resume = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
> +	hsm_check = 0;
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		sbi_hsm_timer_fired = false;
> +		timer_start(hsm_timer_duration);
> +
> +		while (!((READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[cpu])) & SBI_HSM_TEST_DONE)
> +			&& !sbi_hsm_timer_fired)
> +			cpu_relax();
> +
> +		timer_stop();
> +
> +		if (sbi_hsm_timer_fired) {
> +			report_info("hsm timer fired before hart %ld is done with non-retentive resume checks",
> +				    hartid);
> +			continue;
> +		}
> +
> +		if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SATP))
> +			report_info("satp is not zero for test hart %ld", hartid);
> +		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SIE))
> +			report_info("sstatus.SIE is not zero for test hart %ld", hartid);
> +		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_MAGIC_A1))
> +			report_info("a1 does not start with magic for test hart %ld", hartid);
> +		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
> +			report_info("a0 is not hartid for test hart %ld", hartid);
> +		else
> +			hsm_check++;
> +	}
> +
> +	report(hsm_resume == max_cpus - 1, "all secondary harts non-retentive resumed");
> +	report(hsm_check == max_cpus - 1,
> +	       "all secondary harts have expected register values after non-retentive resume");
> +
> +	report_prefix_pop();
> +
> +sbi_hsm_hart_stop_tests:
> +	report_prefix_push("hart_stop");
> +
> +	if (ipi_unavailable)
> +		on_cpumask_async(&secondary_cpus_mask, hart_stop, NULL);
> +	else
> +		memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
> +
> +	transition_states = (struct hart_state_transition_info) {
> +		.initial_state = SBI_EXT_HSM_STARTED,
> +		.intermediate_state = SBI_EXT_HSM_STOP_PENDING,
> +		.final_state = SBI_EXT_HSM_STOPPED,
> +	};
> +	hsm_stop = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
> +
> +	report(hsm_stop == max_cpus - 1, "all secondary harts stopped");
> +
> +	report_prefix_pop();
> +
> +	if (__riscv_xlen == 32 || ipi_unavailable) {
> +		local_irq_disable();
> +		hsm_timer_teardown();
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	report_prefix_push("hart_suspend");
> +
> +	/* Select just one secondary cpu to run suspension tests with MSB of suspend type being set */
> +	cpu = cpumask_next(-1, &secondary_cpus_mask);
> +	hartid = cpus[cpu].hartid;
> +
> +	/* Boot up the secondary cpu and let it proceed to the idle loop */
> +	on_cpu(cpu, start_cpu, NULL);
> +
> +	on_cpu_async(cpu, hart_retentive_suspend_with_msb_set, NULL);
> +
> +	if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
> +	    hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration)) {
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
> +			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			suspend_with_msb = true;
> +	}

This looks like hart_wait_state_transition() so we could just use that
with a mask that only has 'cpu' set in it. Then, the count returned
from that call could be checked below...

> +
> +	report(suspend_with_msb, "secondary hart retentive suspended with MSB set");

report(count, ...)

Same comment for the similar ones below.

> +
> +	/* Ignore the return value since we manually validate the status of the hart anyway */
> +	sbi_send_ipi_cpu(cpu);
> +
> +	if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration) &&
> +	    hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration)) {
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STARTED)
> +			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			resume_with_msb = true;
> +	}
> +
> +	report(resume_with_msb, "secondary hart retentive resumed with MSB set");
> +
> +	/* Reset these flags so that we can reuse them for the non-retentive suspension test */
> +	suspend_with_msb = false;
> +	resume_with_msb = false;
> +	sbi_hsm_stop_hart[cpu] = 0;
> +	sbi_hsm_non_retentive_hart_suspend_checks[cpu] = 0;
> +
> +	on_cpu_async(cpu, hart_non_retentive_suspend_with_msb_set, NULL);
> +
> +	if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
> +	    hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration)) {
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
> +			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			suspend_with_msb = true;
> +	}
> +
> +	report(suspend_with_msb, "secondary hart non-retentive suspended with MSB set");
> +
> +	/* Ignore the return value since we manually validate the status of the hart anyway */
> +	sbi_send_ipi_cpu(cpu);
> +
> +	if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration) &&
> +	    hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration)) {
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STARTED)
> +			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			resume_with_msb = true;
> +
> +		sbi_hsm_timer_fired = false;
> +		timer_start(hsm_timer_duration);
> +
> +		while (!((READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[cpu])) & SBI_HSM_TEST_DONE)
> +			&& !sbi_hsm_timer_fired)
> +			cpu_relax();
> +
> +		timer_stop();
> +
> +		if (sbi_hsm_timer_fired) {
> +			report_info("hsm timer fired before hart %ld is done with non-retentive resume checks",
> +				    hartid);
> +		} else {
> +			if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SATP))
> +				report_info("satp is not zero for test hart %ld", hartid);
> +			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SIE))
> +				report_info("sstatus.SIE is not zero for test hart %ld", hartid);
> +			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_MAGIC_A1))
> +				report_info("a1 does not start with magic for test hart %ld", hartid);
> +			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
> +				report_info("a0 is not hartid for test hart %ld", hartid);
> +			else
> +				check_with_msb = true;
> +		}
> +	}
> +
> +	report(resume_with_msb, "secondary hart non-retentive resumed with MSB set");
> +	report(check_with_msb,
> +	       "secondary hart has expected register values after non-retentive resume with MSB set");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_stop");
> +
> +	sbi_hsm_stop_hart[cpu] = 1;
> +
> +	if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
> +	    hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration)) {
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STOPPED)
> +			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			stop_with_msb = true;
> +	}
> +
> +	report(stop_with_msb, "secondary hart stopped after suspension tests with MSB set");
> +
> +	local_irq_disable();
> +	hsm_timer_teardown();
> +	report_prefix_popn(2);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	if (argc > 1 && !strcmp(argv[1], "-h")) {
> @@ -845,6 +1456,7 @@ int main(int argc, char **argv)
>  	check_base();
>  	check_time();
>  	check_ipi();
> +	check_hsm();
>  	check_dbcn();
>  	check_susp();
>  
> -- 
> 2.43.0
>

Thanks,
drew

