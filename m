Return-Path: <kvm+bounces-30331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4571A9B9595
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:37:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99442B21475
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C544C1A2643;
	Fri,  1 Nov 2024 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SqY13ez9"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919C71C2456
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 16:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730479068; cv=none; b=NXL5Ahb3dclWOf9lSvn1RAZduf6zAsWrpsDzduBYcaozK4l7m3RyIQfg/8qh3zTE1Y+heA4ni3WzUzj3qs3rbDZlNVuwDOzhnV6w/DUQ6utqfkFr+LGK4gNKYZ/dXNh1UpH8OtQMfb/MjLIRqOIvshUs6BXgExm5fTU8fq/aG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730479068; c=relaxed/simple;
	bh=ElTPdFqCMKHg+d6jcctlkAdohRi01Zj6D6kR7G9I2R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ruGJEydONR/gXScY9eYi0kVzfbldSfhOY2NQV3UGasRWwDjdFyrEpDJvZg2HCmDESUS3gIO7xY2bZdUify/SWq3OJH2pAX0R/jnzaWZbTQD/ukp9jnhSPMZ+W640ajmxbzQHY5CPRFzDN9ZY7DM/2VgewSdXzvT4W/VUcHvVOtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SqY13ez9; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 1 Nov 2024 17:37:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730479061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hrMOfNqZEvlJ5mJtRnp4TXiIJaAKoWjVk1gW68mBtyM=;
	b=SqY13ez9KZfJKADGMDAm31wuhAUQtYI3rHzYVHhmeWcUitt0ByY61/Qt8up/wIrcnHIzEV
	HVL9eHIvE9IyH3Pc0Tit6oa5p+atmH0d1fYJ/K9niGa96BCfTHGoMgZuTNylOrfSSdwz/L
	eBvc0H+EFSLY/XBZtCEJ2G5j5ql7G4E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v6 1/1] riscv: sbi: Add tests for HSM
 extension
Message-ID: <20241029-a8b71c4eb1146ea01104993d@orel>
References: <20241026161813.17189-1-jamestiotio@gmail.com>
 <20241026161813.17189-2-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026161813.17189-2-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 27, 2024 at 12:18:13AM +0800, James Raphael Tiovalen wrote:
> Add some tests for all of the HSM extension functions. These tests
> ensure that the HSM extension functions follow the behavior as described
> in the SBI specification.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  riscv/sbi.c | 663 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 663 insertions(+)
> 
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 6f2d3e35..b09e2e45 100644
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
> @@ -833,6 +839,662 @@ static void check_susp(void)
>  	report_prefix_pop();
>  }
>  
> +unsigned char sbi_hsm_stop_hart[NR_CPUS];
> +unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
> +unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];

The above three are already present in the file. It's strange the compiler
doesn't warn about the redundant definition.

> +cpumask_t sbi_hsm_started_hart_checks;

This one can be static.

> +static bool sbi_hsm_invalid_hartid_check;
> +static bool sbi_hsm_timer_fired;
> +extern void sbi_hsm_check_hart_start(void);
> +extern void sbi_hsm_check_non_retentive_suspend(void);
> +
> +static void hsm_timer_irq_handler(struct pt_regs *regs)
> +{
> +	sbi_hsm_timer_fired = true;
> +	timer_stop();

nit: timer_stop() should be first (of course it doesn't matter much
here...)

> +}
> +
> +static void hsm_timer_setup(void)
> +{
> +	install_irq_handler(IRQ_S_TIMER, hsm_timer_irq_handler);
> +	local_irq_enable();
> +	timer_irq_enable();
> +}
> +
> +static void hsm_timer_teardown(void)
> +{
> +	timer_irq_disable();
> +	local_irq_disable();
> +	install_irq_handler(IRQ_S_TIMER, NULL);

nit: since the above functions are 'timer' functions by name, then
calling local_irq_enable/disable() is out of their scope.

> +}
> +
> +static void hart_empty_fn(void *data) {}

We have start_cpu() already in this file for a no-op function.

> +
> +static void hart_execute(void *data)

rename to 'hart_check_already_started'

> +{
> +	struct sbiret ret;
> +	unsigned long hartid = current_thread_info()->hartid;
> +	int me = smp_processor_id();
> +
> +	ret = sbi_hart_start(hartid, virt_to_phys(&hart_empty_fn), 0);
> +
> +	if (ret.error == SBI_ERR_ALREADY_AVAILABLE)
> +		cpumask_set_cpu(me, &sbi_hsm_started_hart_checks);
> +}
> +
> +static void hart_start_invalid_hartid(void *data)
> +{
> +	struct sbiret ret;
> +
> +	ret = sbi_hart_start(ULONG_MAX, virt_to_phys(&hart_empty_fn), 0);

nit: I think I prefer '-1UL' over ULONG_MAX since -1 is what is used in
the spec to refer to invalid hartids (which I interpret from the "Hart
list parameter" using -1 for hart_mask_base to indicate broadcast).

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
> +
> +static void hart_retentive_suspend(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_RETENTIVE, 0, 0);
> +
> +	if (ret.error)
> +		report_fail("failed to retentive suspend hart %ld (error=%ld)", hartid, ret.error);
> +}
> +
> +static void hart_non_retentive_suspend(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +
> +	/* Set opaque as hartid so that we can check a0 == a1, ensuring that a0 is hartid and a1 is opaque */
> +	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE,
> +					     virt_to_phys(&sbi_hsm_check_non_retentive_suspend), hartid);
> +
> +	report_fail("failed to non-retentive suspend hart %ld (error=%ld)", hartid, ret.error);
> +}
> +
> +static void hart_retentive_suspend_with_msb_set(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +	unsigned long suspend_type = SBI_EXT_HSM_HART_SUSPEND_RETENTIVE | (_AC(1, UL) << (__riscv_xlen - 1));
> +	struct sbiret ret = sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, 0, 0, 0, 0, 0);
> +
> +	if (ret.error)
> +		report_fail("failed to retentive suspend hart %ld with MSB set (error=%ld)", hartid, ret.error);

This test, which I assume is to ensure the SBI implementation ignores
upper bits set in suspend_type, will only work on rv64. On rv32, it
will try to do a non-retentive suspend. I see below that it's only
being run on rv64. We should put a comment here making that clear.

> +}
> +
> +static void hart_non_retentive_suspend_with_msb_set(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +	unsigned long suspend_type = SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE | (_AC(1, UL) << (__riscv_xlen - 1));
> +
> +	/* Set opaque as hartid so that we can check a0 == a1, ensuring that a0 is hartid and a1 is opaque */
> +	struct sbiret ret = sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type,
> +				      virt_to_phys(&sbi_hsm_check_non_retentive_suspend), hartid, 0, 0, 0);
> +
> +	report_fail("failed to non-retentive suspend hart %ld with MSB set (error=%ld)", hartid, ret.error);

Same comment as for hart_retentive_suspend_with_msb_set()

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
> +	return sbi_hsm_timer_fired || ret.error;

For boolean returning functions I prefer 'true' to mean success and
'false' to me failure, so I would reverse this logic.

> +}
> +
> +static void check_hsm(void)
> +{
> +	struct sbiret ret;
> +	unsigned long hartid;
> +	cpumask_t secondary_cpus_mask, hsm_start, hsm_stop, hsm_suspend, hsm_resume, hsm_check;
> +	bool ipi_unavailable = false;
> +	bool suspend_with_msb = false, resume_with_msb = false, check_with_msb = false, stop_with_msb = false;
> +	int cpu, me = smp_processor_id();
> +	int max_cpus = getenv("SBI_MAX_CPUS") ? strtol(getenv("SBI_MAX_CPUS"), NULL, 0) : nr_cpus;
> +	unsigned long hsm_timer_duration = getenv("SBI_HSM_TIMER_DURATION")
> +					 ? strtol(getenv("SBI_HSM_TIMER_DURATION"), NULL, 0) : 200000;
> +
> +	max_cpus = MIN(max_cpus, nr_cpus);

We should further clamp this to cpumask_weight(&cpu_present_mask);

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
> +	for_each_present_cpu(cpu) {
> +		if (sbi_hart_get_status(cpus[cpu].hartid).error == SBI_ERR_INVALID_PARAM)
> +			set_cpu_present(cpu, false);
> +	}

We do this now in setup since commit b9e849027e0d ("riscv: Filter unmanaged
harts from present mask") which is merged into riscv/sbi.

> +
> +	report(cpumask_weight(&cpu_present_mask) == nr_cpus, "all present harts have valid hartids");

The above test should be dropped. It wouldn't be testing SBI it would be
testing the DT.

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
> +
> +	/* Assume that previous tests have not cleaned up and stopped the secondary harts */
> +	on_cpumask_async(&secondary_cpus_mask, hart_stop, NULL);
> +
> +	cpumask_clear(&hsm_stop);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
> +			continue;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STOPPED)
> +			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_stop);
> +	}
> +
> +	report(cpumask_weight(&hsm_stop) == max_cpus - 1, "all secondary harts stopped");

It looks like we just need a counter and not a cpumask for this test since
we only care about the weight of the mask.

> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_start");
> +
> +	cpumask_clear(&hsm_start);
> +	cpumask_clear(&hsm_check);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		/* Set opaque as hartid so that we can check a0 == a1, ensuring that a0 is hartid and a1 is opaque */

The only problem with this trick is that the SBI implementation could have
a bug that sets a0 to opaque and a1 to hartid and we won't catch it. It
would be better to embed hartid in some structure or array (and not at
offset 0) and then set opaque to the pointer of that structure. That's how
the SUSP test does it. Also SUSP puts a magic number at offset zero so
opaque can be tested by that alone. To change it we'll need to also write
a fixup patch for "riscv: sbi: Provide entry point for HSM tests".

> +		ret = sbi_hart_start(hartid, virt_to_phys(&sbi_hsm_check_hart_start), hartid);
> +		if (ret.error) {
> +			report_fail("failed to start test hart %ld (error=%ld)", hartid, ret.error);
> +			continue;
> +		}
> +

From here...

> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED, hsm_timer_duration))
> +			continue;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING, hsm_timer_duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error) {
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +			continue;
> +		} else if (ret.value != SBI_EXT_HSM_STARTED) {
> +			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +			continue;
> +		} else {
> +			cpumask_set_cpu(cpu, &hsm_start);

...to here can be factored into a function that returns the count and
shared with the hsm_stop test since hsm_start doesn't need to be a cpumask
either. The function just needs to take the three states as parameters.

> +		}
> +
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
> +		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
> +			report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_check);
> +	}
> +
> +	report(cpumask_weight(&hsm_start) == max_cpus - 1, "all secondary harts started");
> +	report(cpumask_weight(&hsm_check) == max_cpus - 1,
> +	       "all secondary harts have expected register values after hart start");

hsm_check can also just be a counter.

> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_stop");
> +
> +	memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
> +
> +	cpumask_clear(&hsm_stop);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
> +			continue;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STOPPED)
> +			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_stop);
> +	}
> +
> +	report(cpumask_weight(&hsm_stop) == max_cpus - 1, "all secondary harts stopped");
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
> +	on_cpumask_async(&secondary_cpus_mask, hart_execute, NULL);
> +
> +	cpumask_clear(&hsm_start);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED, hsm_timer_duration))
> +			continue;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING, hsm_timer_duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STARTED)
> +			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_start);
> +	}
> +
> +	report(cpumask_weight(&hsm_start) == max_cpus - 1, "all secondary harts started");
> +

Can factor from here...

> +	sbi_hsm_timer_fired = false;
> +	timer_start(hsm_timer_duration);
> +
> +	while (cpumask_weight(&cpu_idle_mask) != max_cpus - 1 && !sbi_hsm_timer_fired)
> +		cpu_relax();
> +
> +	timer_stop();
> +
> +	if (sbi_hsm_timer_fired)
> +		report_info("hsm timer fired before all secondary harts started");

...to here into a helper function.

> +
> +	report(cpumask_weight(&cpu_idle_mask) == max_cpus - 1,
> +	       "all secondary harts successfully executed code after start");
> +	report(cpumask_weight(&cpu_online_mask) == max_cpus, "all secondary harts online");
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
> +	cpumask_clear(&hsm_suspend);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
> +			continue;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
> +			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_suspend);
> +	}
> +
> +	report(cpumask_weight(&hsm_suspend) == max_cpus - 1, "all secondary harts retentive suspended");

hsm_suspend can be a counter.

> +
> +	/* Ignore the return value since we check the status of each hart anyway */
> +	sbi_send_ipi_cpumask(&secondary_cpus_mask);
> +
> +	cpumask_clear(&hsm_resume);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration))
> +			continue;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STARTED)
> +			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_resume);
> +	}
> +
> +	report(cpumask_weight(&hsm_resume) == max_cpus - 1, "all secondary harts retentive resumed");

hsm_resume can be a counter.

> +
> +	sbi_hsm_timer_fired = false;
> +	timer_start(hsm_timer_duration);
> +
> +	while (cpumask_weight(&cpu_idle_mask) != max_cpus - 1 && !sbi_hsm_timer_fired)
> +		cpu_relax();
> +
> +	timer_stop();
> +
> +	if (sbi_hsm_timer_fired)
> +		report_info("hsm timer fired before all secondary harts retentive resumed");
> +
> +	report(cpumask_weight(&cpu_idle_mask) == max_cpus - 1,
> +	       "all secondary harts successfully executed code after retentive suspend");
> +	report(cpumask_weight(&cpu_online_mask) == max_cpus,
> +	       "all secondary harts online");
> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_non_retentive_suspend, NULL);
> +
> +	cpumask_clear(&hsm_suspend);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
> +			continue;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
> +			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_suspend);
> +	}
> +
> +	report(cpumask_weight(&hsm_suspend) == max_cpus - 1, "all secondary harts non-retentive suspended");
> +
> +	/* Ignore the return value since we check the status of each hart anyway */
> +	sbi_send_ipi_cpumask(&secondary_cpus_mask);
> +
> +	cpumask_clear(&hsm_resume);
> +	cpumask_clear(&hsm_check);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration))
> +			continue;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error) {
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +			continue;
> +		} else if (ret.value != SBI_EXT_HSM_STARTED) {
> +			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +			continue;
> +		} else {
> +			cpumask_set_cpu(cpu, &hsm_resume);
> +		}
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
> +			continue;
> +		}
> +
> +		if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SATP))
> +			report_info("satp is not zero for test hart %ld", hartid);
> +		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SIE))
> +			report_info("sstatus.SIE is not zero for test hart %ld", hartid);
> +		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
> +			report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_check);
> +	}
> +
> +	report(cpumask_weight(&hsm_resume) == max_cpus - 1, "all secondary harts non-retentive resumed");
> +	report(cpumask_weight(&hsm_check) == max_cpus - 1,
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
> +	cpumask_clear(&hsm_stop);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
> +			continue;
> +		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration))
> +			continue;
> +
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STOPPED)
> +			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_stop);
> +	}
> +
> +	report(cpumask_weight(&hsm_stop) == max_cpus - 1, "all secondary harts stopped");
> +
> +	if (__riscv_xlen == 32 || ipi_unavailable) {
> +		hsm_timer_teardown();
> +		report_prefix_popn(2);
> +		return;
> +	}
> +
> +	report_prefix_pop();

This pop should go above the if 32-bit check and the pop inside that if's
body should be changed to a single pop.

> +
> +	report_prefix_push("hart_suspend");
> +
> +	/* Select just one secondary cpu to run suspension tests with MSB of suspend type being set */
> +	cpu = cpumask_next(-1, &secondary_cpus_mask);
> +	hartid = cpus[cpu].hartid;
> +
> +	/* Boot up the secondary cpu and let it proceed to the idle loop */
> +	on_cpu(cpu, hart_empty_fn, NULL);
> +
> +	on_cpu_async(cpu, hart_retentive_suspend_with_msb_set, NULL);
> +
> +	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
> +	    !hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration)) {
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
> +			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			suspend_with_msb = true;
> +	}
> +
> +	report(suspend_with_msb, "secondary hart retentive suspended with MSB set");
> +
> +	/* Ignore the return value since we manually validate the status of the hart anyway */
> +	sbi_send_ipi_cpu(cpu);
> +
> +	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration) &&
> +	    !hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration)) {
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
> +	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
> +	    !hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration)) {
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
> +	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration) &&
> +	    !hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration)) {
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
> +			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
> +				report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
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
> +	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
> +	    !hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration)) {
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
> +	hsm_timer_teardown();
> +	report_prefix_popn(2);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	if (argc > 1 && !strcmp(argv[1], "-h")) {
> @@ -844,6 +1506,7 @@ int main(int argc, char **argv)
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

