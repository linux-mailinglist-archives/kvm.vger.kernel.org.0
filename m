Return-Path: <kvm+bounces-26719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C61B976B7C
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1AF31F20C2A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572B71B12D8;
	Thu, 12 Sep 2024 14:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m47gb+Ux"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956091AD25A
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726149852; cv=none; b=R4bvynzmkLT6+DZv69m8nkYJKRg1ZzYqi2wioMdakE7TK08W19B6D5jccrhz0z65UzB3UP0wBEjvDo1i3CwyPDX67KB4pGK64LMxmVZXcMI0av4DeOQ/2XvsqqfGwiKBk9hx4wrwF5++BDVQR8DKYL404HuhTnBgIaGTnOlySlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726149852; c=relaxed/simple;
	bh=ahK7dh95eM4fA4RF4BmFt2tbPWEX6puVJG6NupczyBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ThPWoQbxR5/XQco1OThbuFLYOEYsl7U0i9h6PZ+mjiJZET2NHkIFupEPvGvCdiQiucoGbGrxGTGXSzFe5fHSdlalsQD3AyvzAIskLWt2esasMjY44uUmApdHdmIwi6et1CIxZXFR5BAcCnmaMbqpdGL0rkUUX4GckwzL3SEZQeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m47gb+Ux; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 12 Sep 2024 16:04:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726149846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lGIOSaiiUU16fhJX2fsPcZl2Pgg2TqrYcUSTCsWcOEE=;
	b=m47gb+UxasKgUpz74sG1tdI27QK4QwibUvuxoakKxfwY7S1GDuaC4254h/rTv36UkSTX+Z
	D6+5T84E+pT6RdJdzRM8AKbVP1oe1fW037uOEWet6CA+kHnijbK7bQQTxbwSUh/LfHxJ2z
	4Ix9YT/O7uWoCX/foH3o7e9I6eCKz50=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v3 2/2] riscv: sbi: Add tests for HSM
 extension
Message-ID: <20240911-fb01aeaadae60fc12bdb40cc@orel>
References: <20240910151536.163830-1-jamestiotio@gmail.com>
 <20240910151536.163830-3-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910151536.163830-3-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 10, 2024 at 11:15:36PM GMT, James Raphael Tiovalen wrote:
> Add some tests for all of the HSM extension functions. These tests
> ensure that the HSM extension functions follow the behavior as described
> in the SBI specification.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  riscv/Makefile  |   3 +-
>  riscv/sbi.h     |  10 ++
>  riscv/sbi-asm.S |  47 +++++++
>  riscv/sbi.c     | 352 ++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 411 insertions(+), 1 deletion(-)
>  create mode 100644 riscv/sbi.h
>  create mode 100644 riscv/sbi-asm.S
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 2ee7c5bb..4676d262 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -43,6 +43,7 @@ cflatobjs += lib/riscv/timer.o
>  ifeq ($(ARCH),riscv32)
>  cflatobjs += lib/ldiv32.o
>  endif
> +cflatobjs += riscv/sbi-asm.o
>  
>  ########################################
>  
> @@ -80,7 +81,7 @@ CFLAGS += -mcmodel=medany
>  CFLAGS += -std=gnu99
>  CFLAGS += -ffreestanding
>  CFLAGS += -O2
> -CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
> +CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
>  
>  asm-offsets = lib/riscv/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
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
> diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
> new file mode 100644
> index 00000000..1b8b2fd8
> --- /dev/null
> +++ b/riscv/sbi-asm.S
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Helper assembly code routines for RISC-V SBI extension tests.
> + *
> + * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
> + */
> +#define __ASSEMBLY__
> +#include <config.h>
> +#include <asm/csr.h>
> +#include <sbi.h>
> +
> +.section .text
> +.balign 4
> +sbi_hsm_check:
> +	csrr	t1, CSR_SATP
> +	bnez	t1, 1f
> +	li	t0, SBI_HSM_TEST_SATP
> +1:	csrr	t1, CSR_SSTATUS
> +	andi	t1, t1, SR_SIE
> +	bnez	t1, 2f
> +	ori	t0, t0, SBI_HSM_TEST_SIE
> +2:	bne	a0, a1, 3f
> +	ori	t0, t0, SBI_HSM_TEST_HARTID_A1
> +3:	ori	t0, t0, SBI_HSM_TEST_DONE
> +	add	t1, t6, a0	/* t6 is the address of the results array */

Thinking about this some more, we shouldn't be using hartid as an index
into an array since hartids can be sparse. We should convert the hartid
to a cpu index and then use that for the index. We could
call hartid_to_cpu, but we can't call C code from this function. But...,
nothing stops the simple hartid_to_cpu function from being rewritten in
assembly. I've gone ahead and done that along with other changes to this
function and pushed to riscv/sbi for this patch to be rebased on.

For the other changes, besides a couple minor things, we now also ensure
that hartid is valid before passing the HARTID_A1 test and before using
its resulting cpu index as an index.

> +	sb	t0, 0(t1)
> +	la	t0, sbi_hsm_stop_hart
> +	add	t1, t0, a0
> +4:	lb	t0, 0(t1)
> +	pause
> +	beqz	t0, 4b
> +	li	a7, 0x48534d	/* SBI_EXT_HSM */
> +	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
> +	ecall
> +	j	halt
> +
> +.balign 4
> +.global sbi_hsm_check_hart_start
> +sbi_hsm_check_hart_start:
> +	la	t6, sbi_hsm_hart_start_checks
> +	j	sbi_hsm_check
> +
> +.balign 4
> +.global sbi_hsm_check_non_retentive_suspend
> +sbi_hsm_check_non_retentive_suspend:
> +	la	t6, sbi_hsm_non_retentive_hart_suspend_checks
> +	j	sbi_hsm_check
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index c9fbd6db..bf275630 100644
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
> @@ -16,10 +18,13 @@
>  #include <asm/delay.h>
>  #include <asm/io.h>
>  #include <asm/mmu.h>
> +#include <asm/page.h>
>  #include <asm/processor.h>
>  #include <asm/sbi.h>
> +#include <asm/setup.h>
>  #include <asm/smp.h>
>  #include <asm/timer.h>
> +#include <sbi.h>
>  
>  #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
>  
> @@ -420,6 +425,352 @@ static void check_dbcn(void)
>  	report_prefix_popn(2);
>  }
>  
> +unsigned char sbi_hsm_stop_hart[NR_CPUS];
> +unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
> +unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];
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
> +static void hsm_timer_wait(int nr_secondary_cpus)
> +{
> +	unsigned long hsm_timer_duration = getenv("SBI_HSM_TIMER_DURATION")
> +					 ? strtol(getenv("SBI_HSM_TIMER_DURATION"), NULL, 0) : 200000;
> +
> +	install_irq_handler(IRQ_S_TIMER, hsm_timer_irq_handler);
> +	local_irq_enable();
> +	timer_irq_enable();
> +	timer_start(hsm_timer_duration);
> +
> +	while (cpumask_weight(&cpu_idle_mask) != nr_secondary_cpus && !hsm_timer_fired)
> +		cpu_relax();
> +
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
> +	while (!ret.error && ret.value == status) {
> +		cpu_relax();
> +		ret = sbi_hart_get_status(hartid);
> +	}
> +
> +	if (ret.error)
> +		report_fail("got %ld while waiting on status %u for hart %ld\n", ret.error, status, hartid);
> +}
> +
> +static void check_hsm(void)
> +{
> +	struct sbiret ret;
> +	unsigned long hartid;
> +	bool ipi_failed = false;
> +	int cpu, nr_secondary_cpus, me = smp_processor_id();
> +	unsigned long max_cpu = getenv("SBI_HSM_MAX_CPU") ? strtol(getenv("SBI_HSM_MAX_CPU"), NULL, 0) : NR_CPUS;

This should be

 int max_cpu = getenv("SBI_HSM_MAX_CPU") ? strtol(getenv("SBI_HSM_MAX_CPU"), NULL, 0) : INT_MAX;
 
 max_cpu = MIN(max_cpu, nr_cpus - 1);

> +	cpumask_t secondary_cpus_mask;
> +
> +	cpumask_copy(&secondary_cpus_mask, &cpu_present_mask);
> +	cpumask_clear_cpu(me, &secondary_cpus_mask);
> +	for_each_cpu(cpu, &secondary_cpus_mask)
> +		if (cpu >= max_cpu)

if (cpu > max_cpu)

(max_cpu should be highest possible cpu index. So it's a valid index.)

> +			cpumask_clear_cpu(cpu, &secondary_cpus_mask);
> +
> +	nr_secondary_cpus = cpumask_weight(&secondary_cpus_mask);

This is also just 'max_cpu' since max_cpu is one less than the number of
usable cpus, so one cpu has already been eliminated from the count, which
accommodates 'me'.

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
> +	if (nr_cpus < 2) {

if (max_cpu + 1 < 2)

> +		report_skip("no other cpus to run the remaining hsm tests on");
> +		report_prefix_pop();
> +		return;
> +	}
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
> +		}
> +	}
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
> +		ret = sbi_hart_get_status(hartid);
> +		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
> +		report(ret.value == SBI_EXT_HSM_STARTED,
> +		       "hart %ld start success (ret.value=%ld)", hartid, ret.value);
> +	}

We can make the test less verbose by changing this to

     cpumask_t hsm_start;

     cpumask_clear(&hsm_start);

     for_each_cpu(cpu, &secondary_cpus_mask) {
             hartid = cpus[cpu].hartid;
             hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
             hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
             ret = sbi_hart_get_status(hartid);
	     if (ret.error)
             	report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
	     else if (ret.value != SBI_EXT_HSM_STARTED)
                report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
	     else
	        cpumask_set_cpu(cpu, &hsm_start);
     }

     if (cpumask_weight(&hsm_start) == max_cpu)
     	report_pass("All harts started");

> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +
> +		while (!(READ_ONCE(sbi_hsm_hart_start_checks[hartid]) & SBI_HSM_TEST_DONE))
> +			cpu_relax();

We need a timeout for this loop.

Also, after the rebase on the new hsm start entry assembly code this index
and the indices for the array below should all be 'cpu', not 'hartid'.

> +
> +		report(READ_ONCE(sbi_hsm_hart_start_checks[hartid]) & SBI_HSM_TEST_SATP,
> +		       "satp is zero for test hart %ld", hartid);
> +		report(READ_ONCE(sbi_hsm_hart_start_checks[hartid]) & SBI_HSM_TEST_SIE,
> +		       "sstatus.SIE is zero for test hart %ld", hartid);
> +		report(READ_ONCE(sbi_hsm_hart_start_checks[hartid]) & SBI_HSM_TEST_HARTID_A1,
> +		       "a0 and a1 are hartid for test hart %ld", hartid);

The READ_ONCE's aren't needed here. They're need in the loop to keep the
compiler from doing the load outside the loop, but here the compiler will
have to emit the loads. 

> +	}
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_stop");
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		WRITE_ONCE(sbi_hsm_stop_hart[hartid], true);

s/hartid/cpu/

The WRITE_ONCE self-documents that something depends on this being written
when we say it should be written, but it doesn't really do anything.

> +	}
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
> +		ret = sbi_hart_get_status(hartid);
> +		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
> +		report(ret.value == SBI_EXT_HSM_STOPPED,
> +		       "hart %ld stop success (ret.value=%ld)", hartid, ret.value);
> +	}

We should rework this loop like the one above to avoid being too verbose.
Just imagine how the test log would look on a system with 512 harts...

> +
> +	/* Reset the stop flags so that we can reuse them after suspension tests */
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		WRITE_ONCE(sbi_hsm_stop_hart[hartid], false);
> +	}

 memset(sbi_hsm_stop_hart, 0, sizeof(sbi_hsm_stop_hart));

> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_start");
> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_execute, NULL);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
> +		ret = sbi_hart_get_status(hartid);
> +		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
> +		report(ret.value == SBI_EXT_HSM_STARTED,
> +		       "hart %ld start success (ret.value=%ld)", hartid, ret.value);
> +	}

Rework to be less verbose.

> +
> +	hsm_timer_wait(nr_secondary_cpus);
> +
> +	if (hsm_timer_fired) {
> +		report_fail("hsm timer fired before all secondary harts started");
> +		report_prefix_popn(2);
> +		return;
> +	}
> +

The timer will never fire because we don't start the timer until after
we've waited on the harts to get to HSM_STARTED. The use of timers should
be like this

  /* enable timer irq and set handler */

  ...

  timer_fired = false;
  timer_start(duration);
  /* do timed activity while !timer_fired */
  timer_stop();

  if (timer_fired)
     /* activity failed */

  timer_fired = false;
  timer_start(another_duration);
  /* do another timed activity while !timer_fired */
  timer_stop();

  if (timer_fired)
     /* activity failed */

  ...

  /* disable timer irq and reset handler */

> +	report(cpumask_weight(&cpu_idle_mask) == nr_secondary_cpus,
> +	       "all secondary harts successfully executed code after start");
> +	report(cpumask_weight(&cpu_online_mask) == nr_secondary_cpus + 1, "all secondary harts online");
> +	report(cpumask_weight(&sbi_hsm_started_hart_checks) == nr_secondary_cpus,
> +	       "all secondary harts are already started");
> +	report(cpumask_weight(&sbi_hsm_invalid_hartid_checks) == nr_secondary_cpus,
> +	       "all secondary harts refuse to start with invalid hartid");

Yeah, this is the type of thing I expect in order to keep verbosity low.

> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_suspend");
> +
> +	if (!sbi_probe(SBI_EXT_IPI)) {
> +		report_skip("skipping suspension tests since ipi extension is unavailable");
> +		report_prefix_popn(2);
> +		return;
> +	}
> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_retentive_suspend, NULL);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
> +		ret = sbi_hart_get_status(hartid);
> +		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
> +		report(ret.value == SBI_EXT_HSM_SUSPENDED,
> +		       "hart %ld retentive suspend success (ret.value=%ld)", hartid, ret.value);
> +	}

Rework to avoid two lines per secondary hart.

> +
> +	sbi_send_ipi_cpumask(&secondary_cpus_mask);
> +
> +	if (!ipi_failed) {
> +		for_each_cpu(cpu, &secondary_cpus_mask) {
> +			hartid = cpus[cpu].hartid;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
> +			ret = sbi_hart_get_status(hartid);
> +			report(ret.error == SBI_SUCCESS,
> +			       "hart %ld get status success (error=%ld)", hartid, ret.error);
> +			report(ret.value == SBI_EXT_HSM_STARTED,
> +			       "hart %ld retentive resume success (ret.value=%ld)", hartid, ret.value);
> +		}

Rework to avoid two lines per secondary hart.

> +
> +		hsm_timer_wait(nr_secondary_cpus);
> +
> +		if (hsm_timer_fired) {
> +			report_fail("hsm timer fired before all secondary harts retentive resumed");
> +			report_prefix_popn(2);
> +			return;
> +		}

Same problem with the above timed wait. It'll never fail since we already
did the waiting before we set the timer.

> +
> +		report(cpumask_weight(&cpu_idle_mask) == nr_secondary_cpus,
> +		       "all secondary harts successfully executed code after retentive suspend");
> +		report(cpumask_weight(&cpu_online_mask) == nr_secondary_cpus + 1,
> +		       "all secondary harts online");
> +	}
> +
> +	/* Reset the ipi_failed flag so that we can reuse it for non-retentive suspension tests */
> +	ipi_failed = false;
> +
> +	on_cpumask_async(&secondary_cpus_mask, hart_non_retentive_suspend, NULL);
> +
> +	for_each_cpu(cpu, &secondary_cpus_mask) {
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
> +		ret = sbi_hart_get_status(hartid);
> +		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
> +		report(ret.value == SBI_EXT_HSM_SUSPENDED,
> +		       "hart %ld non-retentive suspend success (ret.value=%ld)", hartid, ret.value);
> +	}

Rework to avoid two lines per secondary hart.

> +
> +	sbi_send_ipi_cpumask(&secondary_cpus_mask);
> +
> +	if (!ipi_failed) {
> +		for_each_cpu(cpu, &secondary_cpus_mask) {
> +			hartid = cpus[cpu].hartid;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
> +			ret = sbi_hart_get_status(hartid);
> +			report(ret.error == SBI_SUCCESS,
> +			       "hart %ld get status success (error=%ld)", hartid, ret.error);
> +			report(ret.value == SBI_EXT_HSM_STARTED,
> +			       "hart %ld non-retentive resume success (ret.value=%ld)", hartid, ret.value);
> +		}

Rework to avoid two lines per secondary hart.

> +
> +		for_each_cpu(cpu, &secondary_cpus_mask) {
> +			hartid = cpus[cpu].hartid;
> +
> +			while (!((READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid])) & SBI_HSM_TEST_DONE))
> +				cpu_relax();

s/hartid/cpu/

> +
> +			report(READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid]) & SBI_HSM_TEST_SATP,
> +			       "satp is zero for test hart %ld", hartid);
> +			report(READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid]) & SBI_HSM_TEST_SIE,
> +			       "sstatus.SIE is zero for test hart %ld", hartid);
> +			report(READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid]) & SBI_HSM_TEST_HARTID_A1,
> +			       "a0 and a1 are hartid for test hart %ld", hartid);

s/hartid/cpu/ and no need for READ_ONCE

> +		}
> +
> +		report_prefix_pop();
> +
> +		report_prefix_push("hart_stop");
> +
> +		for_each_cpu(cpu, &secondary_cpus_mask) {
> +			hartid = cpus[cpu].hartid;
> +			WRITE_ONCE(sbi_hsm_stop_hart[hartid], true);
> +		}

s/hartid/cpu/ and no need for WRITE_ONCE (but can leave WRITE_ONCE for the
self-documentation)

> +
> +		for_each_cpu(cpu, &secondary_cpus_mask) {
> +			hartid = cpus[cpu].hartid;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
> +			ret = sbi_hart_get_status(hartid);
> +			report(ret.error == SBI_SUCCESS,
> +			       "hart %ld get status success (error=%ld)", hartid, ret.error);
> +			report(ret.value == SBI_EXT_HSM_STOPPED,
> +			       "hart %ld stop after retention success (ret.value=%ld)", hartid, ret.value);
> +		}

Rework to avoid two lines per secondary hart.

> +	}
> +
> +	report_prefix_popn(2);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	if (argc > 1 && !strcmp(argv[1], "-h")) {
> @@ -430,6 +781,7 @@ int main(int argc, char **argv)
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

Thanks,
drew

