Return-Path: <kvm+bounces-26965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0CCE979E63
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 457311F21859
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 09:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBFD14A62E;
	Mon, 16 Sep 2024 09:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rkO51MjW"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EC71494B5
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 09:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726478633; cv=none; b=Jks9IGdTWUhv9IJK6F2fmyg06Cp4hdj/az3ZA5QhKmuvG342a/+mx1cV5xmLPukbaMneucfMQjDaPtS6NtriI6Ru5/rqCsFOW7+M1rq4wG0L2qQcSCybWVcRvJ5GT8ERhc5enX4c8iFhkIzfRzx9/NqzU7+YctEcr/PCSjEf9Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726478633; c=relaxed/simple;
	bh=2eq6AMxcKcXoRhb1843F5tUUlwy6Fl0+2Sa7R/3xrcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3oI/Gq8jCm55myce9SX5IN/ntA8An/FQiO0Mh8L2AlZzW11ck8zCtIi4S/OlobA3IuEn7SLECyYW+WKcn4sc9ZYlfMDNObD29QxT51xEOsfAvzImL20sFU7u1zQGQAmhYbXMDtEsXlByRPH0lR78IgdCi0P9IeeK/FdoPHGhyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rkO51MjW; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 16 Sep 2024 11:23:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726478626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zxjhlaKh7u+qHyhHAlgOUZ0oJgi8GFN2hycFr/QDw8A=;
	b=rkO51MjW7s8TaIq1KrDpyE1mb8cGzevytYP0OlZvia+0y3sXFickGyOsvi7Fx94e/WWXGu
	5Vu4INO1jWap1nqPe5npuljmRwZhVFYTmM93Iblqpl5Gba0K1X74sdq3hvEYO/6eIAKX+0
	JL5jBzQDyid7/NNT+Ue8Mp8eHn5CIhI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v4 3/3] riscv: sbi: Add tests for HSM
 extension
Message-ID: <20240916-e0d132aff741e7887f831949@orel>
References: <20240915183459.52476-1-jamestiotio@gmail.com>
 <20240915183459.52476-4-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240915183459.52476-4-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 16, 2024 at 02:34:59AM GMT, James Raphael Tiovalen wrote:
> Add some tests for all of the HSM extension functions. These tests
> ensure that the HSM extension functions follow the behavior as described
> in the SBI specification.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  riscv/sbi.h |  10 +
>  riscv/sbi.c | 561 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 571 insertions(+)
>  create mode 100644 riscv/sbi.h
> 
> diff --git a/riscv/sbi.h b/riscv/sbi.h
> new file mode 100644
> index 00000000..e8625cb1
> --- /dev/null
> +++ b/riscv/sbi.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _RISCV_SBI_H_
> +#define _RISCV_SBI_H_
> +
> +#define SBI_HSM_TEST_DONE	(1 << 0)
> +#define SBI_HSM_TEST_SATP	(1 << 1)
> +#define SBI_HSM_TEST_SIE	(1 << 2)
> +#define SBI_HSM_TEST_HARTID_A1	(1 << 3)
> +
> +#endif /* _RISCV_SBI_H_ */

The last patch creates riscv/sbi-tests.h for this, so we don't want this
file.

> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index d4dfd48e..fab0091b 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -6,6 +6,8 @@
>   */
>  #include <libcflat.h>
>  #include <alloc_page.h>
> +#include <cpumask.h>
> +#include <on-cpus.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <limits.h>
> @@ -16,11 +18,13 @@
>  #include <asm/delay.h>
>  #include <asm/io.h>
>  #include <asm/mmu.h>
> +#include <asm/page.h>
>  #include <asm/processor.h>
>  #include <asm/sbi.h>
>  #include <asm/setup.h>
>  #include <asm/smp.h>
>  #include <asm/timer.h>
> +#include <sbi.h>

This should be

 #include "sbi-tests.h"

and have a blank line between the last <> include and it. See how it's
included in sbi-asm.S.

(I renamed it to sbi-tests.h and use "" since I want it to be clear that
it isn't part of the library. Headers included like <sbi.h> would normally
be in lib.)

>  
>  #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
>  
> @@ -47,6 +51,11 @@ static struct sbiret sbi_dbcn_write_byte(uint8_t byte)
>  	return sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, byte, 0, 0, 0, 0, 0);
>  }
>  
> +static struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
> +{
> +	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
> +}
> +
>  static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo)
>  {
>  	*lo = (unsigned long)paddr;
> @@ -434,6 +443,557 @@ static void check_dbcn(void)
>  	report_prefix_popn(2);
>  }
>  
> +unsigned char sbi_hsm_stop_hart[NR_CPUS];
> +unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
> +unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];

These were added in the first patch of this series. So they must be
getting added again somehow?

> +cpumask_t sbi_hsm_started_hart_checks;
> +cpumask_t sbi_hsm_invalid_hartid_checks;
> +static bool hsm_timer_fired;
> +extern void sbi_hsm_check_hart_start(void);
> +extern void sbi_hsm_check_non_retentive_suspend(void);
> +
> +static void hsm_timer_irq_handler(struct pt_regs *regs)
> +{
> +	hsm_timer_fired = true;
> +	timer_stop();
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
> +}
> +
> +static void hart_empty_fn(void *data) {}
> +
> +static void hart_execute(void *data)
> +{
> +	struct sbiret ret;
> +	unsigned long hartid = current_thread_info()->hartid;
> +	int me = smp_processor_id();
> +
> +	ret = sbi_hart_start(hartid, virt_to_phys(&hart_empty_fn), 0);
> +
> +	if (ret.error == SBI_ERR_ALREADY_AVAILABLE)
> +		cpumask_set_cpu(me, &sbi_hsm_started_hart_checks);
> +
> +	ret = sbi_hart_start(ULONG_MAX, virt_to_phys(&hart_empty_fn), 0);
> +
> +	if (ret.error == SBI_ERR_INVALID_PARAM)
> +		cpumask_set_cpu(me, &sbi_hsm_invalid_hartid_checks);

This is a good tests, but I'm not sure why we give the 'me' hart credit
for it since we weren't using the 'me' hart's hartid in the test. The
invalid hartid test should just be an independent test.

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
> +static void hart_wait_on_status(unsigned long hartid, enum sbi_ext_hsm_sid status)
> +{
> +	struct sbiret ret = sbi_hart_get_status(hartid);
> +
> +	while (!ret.error && ret.value == status && !hsm_timer_fired) {
> +		cpu_relax();
> +		ret = sbi_hart_get_status(hartid);
> +	}
> +
> +	if (hsm_timer_fired)
> +		report_info("timer fired while waiting on status %u for hart %ld", status, hartid);
> +	else if (ret.error)
> +		report_fail("got %ld while waiting on status %u for hart %ld\n", ret.error, status, hartid);
> +}
> +
> +static void check_hsm(void)
> +{
> +	struct sbiret ret;
> +	unsigned long hartid;
> +	cpumask_t secondary_cpus_mask, hsm_start, hsm_stop, hsm_suspend, hsm_resume, hsm_check;
> +	int cpu, me = smp_processor_id();
> +	int max_cpu = getenv("SBI_HSM_MAX_CPU") ? strtol(getenv("SBI_HSM_MAX_CPU"), NULL, 0) : INT_MAX;

I think it'll be better if this is named SBI_MAX_CPUS and is the maximum
_number_ of cpus that the SBI implementation supports.

And max_cpus should default to nr_cpus, so we should have

 int max_cpus = getenv("SBI_MAX_CPUS") ? strtol(getenv("SBI_MAX_CPUS"), NULL, 0) : nr_cpus;


> +	unsigned long hsm_timer_duration = getenv("SBI_HSM_TIMER_DURATION")
> +					 ? strtol(getenv("SBI_HSM_TIMER_DURATION"), NULL, 0) : 200000;
> +
> +	max_cpu = MIN(max_cpu, nr_cpus - 1);

And here we would have

	max_cpus = MIN(max_cpus, nr_cpus);

and if we still need 'max_cpu' (the highest cpu id), like we do below,
then we'll get it with 'max_cpus - 1'.

> +
> +	cpumask_copy(&secondary_cpus_mask, &cpu_present_mask);
> +	cpumask_clear_cpu(me, &secondary_cpus_mask);
> +	for_each_cpu(cpu, &secondary_cpus_mask)
> +		if (cpu > max_cpu)

 if (cpu > max_cpus - 1)

> +			cpumask_clear_cpu(cpu, &secondary_cpus_mask);
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
> +	if (max_cpu + 1 < 2) {

 if (max_cpus < 2)

> +		report_skip("no other cpus to run the remaining hsm tests on");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	/* This is necessary since we do not choose which cpu the boot hart will run on */
> +	if (me > max_cpu)
> +		max_cpu++;

Hmm, I see an issue here. If a DT has its CPU nodes in an order where
nodes earlier in the list include hartids which are not activated by the
SBI implementation due to the SBI implementation's limits on the number
of harts it can activate (because the SBI implementation chose to activate
harts in a particular hartid order rather than by DT cpu node order), then
simply clamping nr_cpus down to SBI max_cpus will not work. We need to
instead run the cpu_present_mask through a filter to remove all the cpus
corresponding to hartids which the SBI implementation has not activated.
This is something we should do in setup(), so I just wrote a patch for it
now [1]. With that patch the 

  for_each_cpu(cpu, &secondary_cpus_mask)
     if (cpu > max_cpu)
          cpumask_clear_cpu(cpu, &secondary_cpus_mask);

loop above should be removed. The

    cpumask_copy(&secondary_cpus_mask, &cpu_present_mask);
    cpumask_clear_cpu(me, &secondary_cpus_mask);

is sufficient for getting a valid mask of cpus that SBI manages. And of
course no need for this

 if (me > max_cpu)
     max_cpu++;

which was insufficient anyway since 'me' doesn't necessarily have to be
just one more than the expected max cpuid.

[1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commit/5fc2c49c6ee37ab725dc0f7a0f6858c17705604f

> +
> +	report_prefix_push("hart_start");
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		/* Set opaque as hartid so that we can check a0 == a1, ensuring that a0 is hartid and a1 is opaque */
> +		ret = sbi_hart_start(hartid, virt_to_phys(&sbi_hsm_check_hart_start), hartid);
> +		if (ret.error) {
> +			report_fail("failed to start test hart %ld (error=%ld)", hartid, ret.error);
> +			report_prefix_popn(2);
> +			return;

Do we need to give up on all tests if one hart fails to start?

> +		}

We should move the sbi_hart_start call into the loop below so we can time
each start/wait individually.

> +	}
> +
> +	cpumask_clear(&hsm_start);
> +	hsm_timer_setup();
> +	timer_start(hsm_timer_duration);

Duration should be small, so we don't want to put a timer_start outside
the loop. It should instead be...

> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;

...here and...

> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);

...here should be a timer_stop().

> +		if (hsm_timer_fired)
> +			break;

Other timer_start here

> +		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);

and stop here. Actually we can put timer_start/stop in
hart_wait_on_status().

> +		if (hsm_timer_fired)
> +			break;
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STARTED)
> +			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_start);
> +	}
> +
> +	if (hsm_timer_fired) {
> +		hsm_timer_teardown();
> +		report_fail("hsm timer fired before all secondary harts started");
> +		report_prefix_popn(2);
> +		return;

Do we need to give up on all test if some harts fail?

> +	}
> +
> +	report(cpumask_weight(&hsm_start) == max_cpu, "all secondary harts started");
> +
> +	cpumask_clear(&hsm_check);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +

timer_start

> +		while (!(READ_ONCE(sbi_hsm_hart_start_checks[cpu]) & SBI_HSM_TEST_DONE) && !hsm_timer_fired)
> +			cpu_relax();

timer_stop

> +
> +		if (hsm_timer_fired)
> +			break;
> +
> +		if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_SATP))
> +			report_info("satp is not zero for test hart %ld", hartid);
> +		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_SIE))
> +			report_info("sstatus.SIE is not zero for test hart %ld", hartid);
> +		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
> +			report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_check);

The body of this loop can also be merged with the loop above. There should
be only one loop that does, start, wait, check for each hart allowing us
to time the wait for each hart individually. One the hart the fails to
start within duration will fail its start test and we try each to see if
others fail or not.

After the loop completes we can output all the

 report(cpumask_weight(...

checks.

> +	}
> +
> +	if (hsm_timer_fired) {
> +		hsm_timer_teardown();
> +		report_fail("hsm timer fired before all secondary harts are done with checks");
> +		report_prefix_popn(2);
> +		return;

Do we need to give up on all test if some harts fail?

> +	}
> +
> +	timer_stop();
> +
> +	report(cpumask_weight(&hsm_check) == max_cpu,
> +	       "all secondary harts have expected register values after hart start");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_stop");
> +
> +	memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
> +
> +	cpumask_clear(&hsm_stop);
> +	hsm_timer_fired = false;
> +	timer_start(hsm_timer_duration);

move timer_start/top into hart_wait_on_status.

> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +		if (hsm_timer_fired)
> +			break;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
> +		if (hsm_timer_fired)
> +			break;
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STOPPED)
> +			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_stop);
> +	}
> +
> +	if (hsm_timer_fired) {
> +		hsm_timer_teardown();
> +		report_fail("hsm timer fired before all secondary harts stopped");
> +		report_prefix_popn(2);
> +		return;

Do we need to give up on all test if some harts fail?

> +	}
> +
> +	timer_stop();
> +
> +	report(cpumask_weight(&hsm_stop) == max_cpu, "all secondary harts stopped");
> +
> +	/* Reset the stop flags so that we can reuse them after suspension tests */
> +	memset(sbi_hsm_stop_hart, 0, sizeof(sbi_hsm_stop_hart));
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_start");
> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_execute, NULL);
> +
> +	cpumask_clear(&hsm_start);
> +	hsm_timer_fired = false;
> +	timer_start(hsm_timer_duration);

move timer_start/top into hart_wait_on_status

> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
> +		if (hsm_timer_fired)
> +			break;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
> +		if (hsm_timer_fired)
> +			break;
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_STARTED)
> +			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_start);
> +	}
> +
> +	if (hsm_timer_fired) {
> +		hsm_timer_teardown();
> +		report_fail("hsm timer fired before all secondary harts started");
> +		report_prefix_popn(2);
> +		return;

Do we need to give up on all test if some harts fail?

> +	}
> +
> +	report(cpumask_weight(&hsm_start) == max_cpu, "all secondary harts started");
> +

timer_start

> +	while (cpumask_weight(&cpu_idle_mask) != max_cpu && !hsm_timer_fired)
> +		cpu_relax();

timer_stop

> +
> +	if (hsm_timer_fired) {
> +		hsm_timer_teardown();
> +		report_fail("hsm timer fired before all secondary harts started");
> +		report_prefix_popn(2);
> +		return;
> +	}
> +
> +	timer_stop();
> +
> +	report(cpumask_weight(&cpu_idle_mask) == max_cpu,
> +	       "all secondary harts successfully executed code after start");
> +	report(cpumask_weight(&cpu_online_mask) == max_cpu + 1, "all secondary harts online");
> +	report(cpumask_weight(&sbi_hsm_started_hart_checks) == max_cpu,
> +	       "all secondary harts are already started");
> +	report(cpumask_weight(&sbi_hsm_invalid_hartid_checks) == max_cpu,
> +	       "all secondary harts refuse to start with invalid hartid");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_suspend");
> +
> +	if (!sbi_probe(SBI_EXT_IPI)) {
> +		hsm_timer_teardown();
> +		report_skip("skipping suspension tests since ipi extension is unavailable");
> +		report_prefix_popn(2);
> +		return;
> +	}
> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_retentive_suspend, NULL);
> +
> +	cpumask_clear(&hsm_suspend);
> +	hsm_timer_fired = false;
> +	timer_start(hsm_timer_duration);

move timer_start/top into hart_wait_on_status

> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +		if (hsm_timer_fired)
> +			break;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
> +		if (hsm_timer_fired)
> +			break;
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
> +			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_suspend);
> +	}
> +
> +	if (hsm_timer_fired) {
> +		hsm_timer_teardown();
> +		report_fail("hsm timer fired before all secondary harts retentive suspended");
> +		report_prefix_popn(2);
> +		return;

Do we need to give up on all test if some harts fail?

> +	}
> +
> +	timer_stop();
> +
> +	report(cpumask_weight(&hsm_suspend) == max_cpu, "all secondary harts retentive suspended");
> +
> +	ret = sbi_send_ipi_cpumask(&secondary_cpus_mask);
> +
> +	if (!ret.error) {
> +		cpumask_clear(&hsm_resume);
> +		hsm_timer_fired = false;
> +		timer_start(hsm_timer_duration);

move timer_start/top into hart_wait_on_status

> +
> +		for_each_cpu(cpu, &secondary_cpus_mask) {
> +			hartid = cpus[cpu].hartid;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
> +			if (hsm_timer_fired)
> +				break;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
> +			if (hsm_timer_fired)
> +				break;
> +			ret = sbi_hart_get_status(hartid);
> +			if (ret.error)
> +				report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +			else if (ret.value != SBI_EXT_HSM_STARTED)
> +				report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +			else
> +				cpumask_set_cpu(cpu, &hsm_resume);
> +		}
> +
> +		if (hsm_timer_fired) {
> +			hsm_timer_teardown();
> +			report_fail("hsm timer fired before all secondary harts retentive resumed");
> +			report_prefix_popn(2);
> +			return;

Do we need to give up on all test if some harts fail?

> +		}
> +
> +		report(cpumask_weight(&hsm_resume) == max_cpu, "all secondary harts retentive resumed");
> +

timer_start

> +		while (cpumask_weight(&cpu_idle_mask) != max_cpu && !hsm_timer_fired)
> +			cpu_relax();

timer_stop

> +
> +		if (hsm_timer_fired) {
> +			hsm_timer_teardown();
> +			report_fail("hsm timer fired before all secondary harts retentive resumed");
> +			report_prefix_popn(2);
> +			return;

Do we need to give up on all test if some harts fail?

> +		}
> +
> +		timer_stop();
> +
> +		report(cpumask_weight(&cpu_idle_mask) == max_cpu,
> +		       "all secondary harts successfully executed code after retentive suspend");
> +		report(cpumask_weight(&cpu_online_mask) == max_cpu + 1,
> +		       "all secondary harts online");
> +	}
> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_non_retentive_suspend, NULL);
> +
> +	cpumask_clear(&hsm_suspend);
> +	hsm_timer_fired = false;

move timer_start/top into hart_wait_on_status

> +	timer_start(hsm_timer_duration);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +		if (hsm_timer_fired)
> +			break;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
> +		if (hsm_timer_fired)
> +			break;
> +		ret = sbi_hart_get_status(hartid);
> +		if (ret.error)
> +			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
> +			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
> +		else
> +			cpumask_set_cpu(cpu, &hsm_suspend);
> +	}
> +
> +	if (hsm_timer_fired) {
> +		hsm_timer_teardown();
> +		report_fail("hsm timer fired before all secondary harts non-retentive suspended");
> +		report_prefix_popn(2);
> +		return;

Do we need to give up on all test if some harts fail?

> +	}
> +
> +	timer_stop();
> +
> +	report(cpumask_weight(&hsm_suspend) == max_cpu, "all secondary harts non-retentive suspended");
> +
> +	ret = sbi_send_ipi_cpumask(&secondary_cpus_mask);
> +
> +	if (!ret.error) {
> +		cpumask_clear(&hsm_resume);
> +		hsm_timer_fired = false;
> +		timer_start(hsm_timer_duration);

move timer_start/top into hart_wait_on_status

> +
> +		for_each_cpu(cpu, &secondary_cpus_mask) {
> +			hartid = cpus[cpu].hartid;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
> +			if (hsm_timer_fired)
> +				break;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
> +			if (hsm_timer_fired)
> +				break;
> +			ret = sbi_hart_get_status(hartid);
> +			if (ret.error)
> +				report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +			else if (ret.value != SBI_EXT_HSM_STARTED)
> +				report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
> +			else
> +				cpumask_set_cpu(cpu, &hsm_resume);
> +		}
> +
> +		if (hsm_timer_fired) {
> +			hsm_timer_teardown();
> +			report_fail("hsm timer fired before all secondary harts non-retentive resumed");
> +			report_prefix_popn(2);
> +			return;

Do we need to give up on all test if some harts fail?

> +		}
> +
> +		report(cpumask_weight(&hsm_resume) == max_cpu, "all secondary harts non-retentive resumed");
> +
> +		cpumask_clear(&hsm_check);
> +
> +		for_each_cpu(cpu, &secondary_cpus_mask) {
> +			hartid = cpus[cpu].hartid;
> +

timer_start

> +			while (!((READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[cpu])) & SBI_HSM_TEST_DONE)
> +			       && !hsm_timer_fired)
> +				cpu_relax();

timer_stop

> +
> +			if (hsm_timer_fired)
> +				break;
> +
> +			if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SATP))
> +				report_info("satp is not zero for test hart %ld", hartid);
> +			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SIE))
> +				report_info("sstatus.SIE is not zero for test hart %ld", hartid);
> +			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
> +				report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
> +			else
> +				cpumask_set_cpu(cpu, &hsm_check);
> +		}
> +
> +		if (hsm_timer_fired) {
> +			hsm_timer_teardown();
> +			report_fail("hsm timer fired before all secondary harts are done with checks");
> +			report_prefix_popn(2);
> +			return;

Do we need to give up on all test if some harts fail?

> +		}
> +
> +		timer_stop();
> +
> +		report(cpumask_weight(&hsm_check) == max_cpu,
> +		       "all secondary harts have expected register values after non-retentive resume");
> +
> +		report_prefix_pop();
> +
> +		report_prefix_push("hart_stop");
> +
> +		memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
> +
> +		cpumask_clear(&hsm_stop);
> +		hsm_timer_fired = false;
> +		timer_start(hsm_timer_duration);

move timer_start/top into hart_wait_on_status

> +
> +		for_each_cpu(cpu, &secondary_cpus_mask) {
> +			hartid = cpus[cpu].hartid;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +			if (hsm_timer_fired)
> +				break;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
> +			if (hsm_timer_fired)
> +				break;
> +			ret = sbi_hart_get_status(hartid);
> +			if (ret.error)
> +				report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
> +			else if (ret.value != SBI_EXT_HSM_STOPPED)
> +				report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
> +			else
> +				cpumask_set_cpu(cpu, &hsm_stop);
> +		}
> +
> +		if (hsm_timer_fired) {
> +			hsm_timer_teardown();
> +			report_fail("hsm timer fired before all secondary harts stopped after resumption");
> +			report_prefix_popn(2);
> +			return;

Do we need to give up on all test if some harts fail?

> +		}
> +
> +		timer_stop();
> +
> +		report(cpumask_weight(&hsm_stop) == max_cpu, "all secondary harts stopped after resumption");
> +	}
> +
> +	hsm_timer_teardown();
> +	report_prefix_popn(2);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	if (argc > 1 && !strcmp(argv[1], "-h")) {
> @@ -444,6 +1004,7 @@ int main(int argc, char **argv)
>  	report_prefix_push("sbi");
>  	check_base();
>  	check_time();
> +	check_hsm();
>  	check_dbcn();
>  
>  	return report_summary();
> -- 
> 2.43.0
> 
>

Thanks,
drew

