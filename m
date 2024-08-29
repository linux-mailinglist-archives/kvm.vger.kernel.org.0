Return-Path: <kvm+bounces-25356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2959D9646C1
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DF3B1C22CDE
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 13:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3014C1B29CB;
	Thu, 29 Aug 2024 13:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n/Ov1qBD"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C82F1B1506
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 13:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724938234; cv=none; b=ooyj2PlNkIs+eHhWa+nNVnjhPa889+5s7NvnoQRPpLcuT8o5Vo6V4Kbby4P+wUMvS6W7PE2abK/EyeuWfUHL9yNwwQZ6gdqHk+ZCokn061RB7Qrig8/MglunQRX/ztHKSYK2TeLSgaezi4affV6Rz7wi4dWixEFHr6UJ5k5iLXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724938234; c=relaxed/simple;
	bh=2A7VVmGZ72iLwBaewKZueByRUwKKMINyW+q9ZCTUBBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shGUo//ySGKRt420oLJJUVyYn5uj3VXKsT1c6IJ5WfaZVhLdNc6ThLEsCe8rFXKNY6W1C+N+emslxlhf40iSP6xjOctbLk6o4RerItOaMfLKjGlB1bFPejBAXEHQw77P2DT/zAYEQHAtebIiabcipG2pHDyGvUUKMDw3ZOtqrr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n/Ov1qBD; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 29 Aug 2024 15:30:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724938229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0UshFS1IEja/Ljn01nxIm4tKNE57+W1pPsU2vfZns5I=;
	b=n/Ov1qBDjFJUleGxxidhEeHL5O0kTals4iC2LUbzfUQrto8jI55LS6uN86q2zkDzhXKJ1e
	+W0rep5fupbVJSxBzXkdw26t3hGpjOeiQZPTJBl+OLwZE05aCINl/n0Ru7BzIUzj3vkekP
	/isDPAdODgcONrkANA6LJnV/IqkqZ60=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v2 4/4] riscv: sbi: Add tests for HSM
 extension
Message-ID: <20240829-8860b495f7e50336fd8a2b90@orel>
References: <20240825170824.107467-1-jamestiotio@gmail.com>
 <20240825170824.107467-5-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240825170824.107467-5-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 26, 2024 at 01:08:24AM GMT, James Raphael Tiovalen wrote:
> Add some tests for all of the HSM extension functions. These tests
> ensure that the HSM extension functions follow the behavior as described
> in the SBI specification.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  riscv/Makefile  |   7 +-
>  riscv/sbi-asm.S |  79 ++++++++++
>  riscv/sbi.c     | 382 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 465 insertions(+), 3 deletions(-)
>  create mode 100644 riscv/sbi-asm.S
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 179a373d..548041ad 100644
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
> @@ -99,7 +100,7 @@ cflatobjs += lib/efi.o
>  .PRECIOUS: %.so
>  
>  %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
> -%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o
> +%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) $(sbi-asm.o) %.aux.o

Something left over from the previous version? We don't have $(sbi-asm.o)
anymore.

>  	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
>  		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
>  
> @@ -115,7 +116,7 @@ cflatobjs += lib/efi.o
>  		-O binary $^ $@
>  else
>  %.elf: LDFLAGS += -pie -n -z notext
> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o
> +%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) $(sbi-asm.o) %.aux.o

same

>  	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
>  		$(filter %.o, $^) $(FLATLIBS)
>  	@chmod a-x $@
> @@ -127,7 +128,7 @@ else
>  endif
>  
>  generated-files = $(asm-offsets)
> -$(tests:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
> +$(tests:.$(exe)=.o) $(cstart.o) $(sbi-asm.o) $(cflatobjs): $(generated-files)

same

>  
>  arch_clean: asm_offsets_clean
>  	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} \
> diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
> new file mode 100644
> index 00000000..f31bc096
> --- /dev/null
> +++ b/riscv/sbi-asm.S
> @@ -0,0 +1,79 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Helper assembly code routines for RISC-V SBI extension tests.
> + *
> + * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
> + */
> +#define __ASSEMBLY__
> +#include <config.h>
> +#include <asm/csr.h>
> +#include <asm/page.h>
> +
> +#define SBI_HSM_TEST_DONE       (1 << 0)
> +#define SBI_HSM_TEST_SATP       (1 << 1)
> +#define SBI_HSM_TEST_SIE        (1 << 2)
> +#define SBI_HSM_TEST_HARTID_A1  (1 << 3)
> +
> +.section .text
> +.balign 4
> +.global sbi_hsm_check_hart_start
> +sbi_hsm_check_hart_start:
> +	li	t0, 0

I see this is a faithful copy of the code I suggested in the last review,
but this is a pointless load of zero to t0, it's not used and then gets
overwritten a few lines down.

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
> +	la	t1, sbi_hsm_hart_start_checks
> +	add	t1, t1, a0
> +	sb	t0, 0(t1)
> +4:	la	t0, sbi_hsm_stop_hart
> +	add	t0, t0, a0
> +	lb	t0, 0(t0)

And no need to repeat the address construction, just use another register

 	la      t0, sbi_hsm_stop_hart
 	add     t1, t0, a0
 4:	lb	t0, 0(t1) 

> +	pause
> +	beqz	t0, 4b
> +	li	a7, 0x48534d	/* SBI_EXT_HSM */
> +	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
> +	ecall
> +	j	halt
> +
> +.balign 4
> +.global sbi_hsm_check_non_retentive_suspend
> +sbi_hsm_check_non_retentive_suspend:
> +	li	t0, 0
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
> +	la	t1, sbi_hsm_non_retentive_hart_suspend_checks
> +	add	t1, t1, a0
> +	sb	t0, 0(t1)
> +4:	la	t0, sbi_hsm_stop_hart
> +	add	t0, t0, a0
> +	lb	t0, 0(t0)
> +	pause
> +	beqz	t0, 4b
> +	li	a7, 0x48534d	/* SBI_EXT_HSM */
> +	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
> +	ecall
> +	j	halt

This is identical, except the address to load for the results, to the
function above. Just make a static helper function that puts that
address in a register, e.g. t6, and then call it from both

/* t6 is the address of the results array */
sbi_hsm_check:
	...

.global sbi_hsm_check_hart_start
sbi_hsm_check_non_retentive_suspend:
	la	t6, sbi_hsm_non_retentive_hart_suspend_checks
	j	sbi_hsm_check

.global sbi_hsm_check_non_retentive_suspend
sbi_hsm_check_non_retentive_suspend:
	la	t6, sbi_hsm_non_retentive_hart_suspend_checks
	j	sbi_hsm_check

> +
> +.section .data
> +.balign PAGE_SIZE
> +.global sbi_hsm_hart_start_checks
> +sbi_hsm_hart_start_checks:			.space CONFIG_NR_CPUS
> +.global sbi_hsm_non_retentive_hart_suspend_checks
> +sbi_hsm_non_retentive_hart_suspend_checks:	.space CONFIG_NR_CPUS
> +.global sbi_hsm_stop_hart
> +sbi_hsm_stop_hart:				.space CONFIG_NR_CPUS

I don't think it should be necessary to create these arrays in assembly.
We should be able to make global arrays in C in riscv/sbi.c and still
access them from the assembly as you've done.

CONFIG_NR_CPUS will support all possible cpuids, but hartids have their
own range and the code above is indexing these arrays by hartid. Since
we should be able to define the arrays in C, then we could also either

 1) assert that max_hartid + 1 <= NR_CPUS
 2) dynamically allocate the arrays using max_hartid + 1 for the size
    and then assign global variables the physical addresses of those
    allocated regions to use in the assembly

(1) is probably good enough

> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 6469304b..25fc2e81 100644
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
> @@ -17,8 +19,10 @@
>  #include <asm/io.h>
>  #include <asm/isa.h>
>  #include <asm/mmu.h>
> +#include <asm/page.h>
>  #include <asm/processor.h>
>  #include <asm/sbi.h>
> +#include <asm/setup.h>
>  #include <asm/smp.h>
>  #include <asm/timer.h>
>  
> @@ -425,6 +429,383 @@ static void check_dbcn(void)
>  	report_prefix_pop();
>  }
>  
> +#define SBI_HSM_TEST_DONE       (1 << 0)
> +#define SBI_HSM_TEST_SATP       (1 << 1)
> +#define SBI_HSM_TEST_SIE        (1 << 2)
> +#define SBI_HSM_TEST_HARTID_A1  (1 << 3)

We should create a header for these devices, riscv/sbi.h, and share them
with the asm file rather than duplicate them.

> +
> +static cpumask_t cpus_alive_after_start;
> +static cpumask_t cpus_alive_after_retentive_suspend;
> +extern void sbi_hsm_check_hart_start(void);
> +extern void sbi_hsm_check_non_retentive_suspend(void);
> +extern unsigned char sbi_hsm_stop_hart[NR_CPUS];
> +extern unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
> +extern unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];

need blank line here

> +static void on_secondary_cpus_async(void (*func)(void *data), void *data)
> +{
> +	int cpu, me = smp_processor_id();
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +		on_cpu_async(cpu, func, data);
> +	}
> +}

Seems on-cpus is missing an API for "all, but ...". How about, as a
separate patch, adding

 void on_cpus_async(cpumask_t *mask, void (*func)(void *data), void *data)

to lib/on-cpus.c

Then here you'd copy the present mask to your own mask and clear 'me' from
it for an 'all present, but me' mask.

> +
> +static bool cpumask_test_secondary_cpus(cpumask_t *mask)
> +{
> +	int cpu, me = smp_processor_id();
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +
> +		if (!cpumask_test_cpu(cpu, mask))
> +			return false;
> +	}
> +
> +	return true;
> +}

This is just

  cpumask_weight(mask) == nr_cpus - 1

or

 !cpumask_test_cpu(me, mask) && cpumask_weight(mask) == nr_cpus - 1

if there's concern for 'me' being set in the mask erroneously.

> +
> +static void hart_execute(void *data)
> +{
> +	int me = smp_processor_id();
> +
> +	cpumask_set_cpu(me, &cpus_alive_after_start);
> +}
> +
> +static void hart_retentive_suspend(void *data)
> +{
> +	int me = smp_processor_id();
> +	unsigned long hartid = current_thread_info()->hartid;
> +	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_RETENTIVE, __pa(NULL), __pa(NULL));

__pa(NULL) is just 0 and I don't think __pa(NULL) tells the reader
anything useful.

> +
> +	if (ret.error)
> +		report_fail("failed to retentive suspend hart %ld", hartid);

Should output ret.error too

> +	else
> +		cpumask_set_cpu(me, &cpus_alive_after_retentive_suspend);

This mask is redundant with the cpu_idle_mask.

> +}
> +
> +static void hart_non_retentive_suspend(void *data)
> +{
> +	unsigned long hartid = current_thread_info()->hartid;
> +

Put a comment here explaining why opaque must be hartid, i.e. for the
a0==a1 test which ensures a0 is hartid and a1 is opaque per the spec.

> +	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE,
> +					     virt_to_phys(&sbi_hsm_check_non_retentive_suspend), hartid);
> +
> +	if (ret.error)

Drop the 'if'. Any return from a non-retentive suspend is a failure.

> +		report_fail("failed to non-retentive suspend hart %ld", hartid);

Should output ret.error too

> +}
> +
> +static void hart_wait_on_status(unsigned long hartid, enum sbi_ext_hsm_sid status)
> +{
> +	struct sbiret ret = sbi_hart_get_status(hartid);
> +
> +	while (!ret.error && ret.value == status)
> +		ret = sbi_hart_get_status(hartid);

Let's throw a cpu_relax() in the loop too.

> +
> +	if (ret.error)
> +		report_fail("got %ld while waiting on status %u for hart %lx\n", ret.error, status, hartid);
> +}
> +
> +static void check_hsm(void)
> +{
> +	struct sbiret ret;
> +	unsigned long hartid;
> +	unsigned char per_hart_start_checks, per_hart_non_retentive_suspend_checks;
> +	unsigned long hart_mask[NR_CPUS / BITS_PER_LONG] = {0};

Use a real cpumask. When passing a single ulong to an SBI call you can
simply use cpumask_bits(mask)[]

> +	bool ipi_failed = false;
> +	int cpu, me = smp_processor_id();
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
> +	if (ret.error == SBI_ERR_INVALID_PARAM) {

Any error is a failure, so this should be if (ret.error) and we should
output the error in the fail message.

> +		report_fail("current hartid is invalid");
> +		report_prefix_popn(2);
> +		return;
> +	} else if (ret.value != SBI_EXT_HSM_STARTED) {
> +		report_fail("current hart is not started");

need to output ret.value

> +		report_prefix_popn(2);
> +		return;
> +	}
> +
> +	report_pass("status of current hart is started");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_start");
> +
> +	ret = sbi_hart_start(hartid, virt_to_phys(&hart_execute), __pa(NULL));
> +	report(ret.error == SBI_ERR_ALREADY_AVAILABLE, "boot hart is already started");

If we don't get the expected error of 'already started', then the test
could hang here. A test like this is best to do on a secondary, passing
the results back to the primary through a global.

> +
> +	ret = sbi_hart_start(ULONG_MAX, virt_to_phys(&hart_execute), __pa(NULL));
> +	report(ret.error == SBI_ERR_INVALID_PARAM, "invalid hartid check");
> +
> +	if (nr_cpus < 2) {
> +		report_skip("no other cpus to run the remaining hsm tests on");
> +		report_prefix_popn(2);
> +		return;
> +	}
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +
> +		hartid = cpus[cpu].hartid;

Need the same why opaque must be hartid comment here as above.

> +		ret = sbi_hart_start(hartid, virt_to_phys(&sbi_hsm_check_hart_start), hartid);
> +

remove this blank line

> +		if (ret.error) {
> +			report_fail("failed to start test hart %ld", hartid);

output ret.error

> +			report_prefix_popn(2);
> +			return;
> +		}
> +	}
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +
> +		hartid = cpus[cpu].hartid;
> +
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
> +		ret = sbi_hart_get_status(hartid);
> +		report(!ret.error && ret.value == SBI_EXT_HSM_STARTED,
> +		       "test hart with hartid %ld successfully started", hartid);

We should split the reporting to check ret.error and ret.value separately.

> +	}
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +
> +		hartid = cpus[cpu].hartid;
> +
> +		while (!((per_hart_start_checks = READ_ONCE(sbi_hsm_hart_start_checks[hartid]))
> +			 & SBI_HSM_TEST_DONE))

This while condition would be a bit less ugly if we dropped
per_hart_start_checks and then just used hartid to index the array in the
three checks below.

> +			cpu_relax();
> +
> +		report(per_hart_start_checks & SBI_HSM_TEST_SATP,
> +		       "satp is zero for test hart %ld", hartid);
> +		report(per_hart_start_checks & SBI_HSM_TEST_SIE,
> +		       "sstatus.SIE is zero for test hart %ld", hartid);
> +		report(per_hart_start_checks & SBI_HSM_TEST_HARTID_A1,
> +		       "a0 and a1 are hartid for test hart %ld", hartid);
> +	}
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_stop");
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +
> +		hartid = cpus[cpu].hartid;
> +		WRITE_ONCE(sbi_hsm_stop_hart[hartid], true);

instead of the loop we could do

 barrier();
 memset(...);
 barrier();

if we don't mind setting the 'me' hart too.

> +	}
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
> +		ret = sbi_hart_get_status(hartid);
> +		report(!ret.error && (ret.value == SBI_EXT_HSM_STOPPED),

unnecessary (), anyway we should split the check for ret.error and
ret.value and output ret.error/value.  See the DBCN test for how
we do it. For example, the write_byte test has

        report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
        report(ret.value == 0, "expected ret.value (%ld)", ret.value);

> +		       "test hart %ld successfully stopped", hartid);
> +	}
> +
> +	/* Reset the stop flags so that we can reuse them after suspension tests */
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +
> +		hartid = cpus[cpu].hartid;
> +		WRITE_ONCE(sbi_hsm_stop_hart[hartid], false);

instead of the loop we could do

 barrier();
 memset(...);
 barrier();

since we definitely we don't mind setting the 'me' hart too as it's
getting set to zero.

> +	}
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_start");
> +
> +	on_secondary_cpus_async(hart_execute, NULL);
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +
> +		hartid = cpus[cpu].hartid;
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
> +		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
> +		ret = sbi_hart_get_status(hartid);
> +		report(!ret.error && (ret.value == SBI_EXT_HSM_STARTED),
> +		       "new hart with hartid %ld successfully started", hartid);

split error/value tests

> +	}
> +
> +	while (!cpumask_test_secondary_cpus(&cpu_idle_mask))

while (cpumask_weight(&cpu_idle_mask) != nr_cpus - 1)

> +		cpu_relax();

We could get stuck in this loop forever if the cpus don't come up, so you
may want to set a timeout with timer_start(), then either handler the
failure due to the timeout handler firing or stop the timer, so

 timer_start(long_enough_duration);
 while (cpumask_weight(&cpu_idle_mask) != nr_cpus - 1)
    cpu_relax();
 timer_stop();
 if (timer_fired)
    report_fail(...)

> +
> +	report(cpumask_full(&cpu_online_mask), "all cpus online");
> +	report(cpumask_test_secondary_cpus(&cpus_alive_after_start),
> +	       "all secondary harts successfully executed code after start");

This test is covered by the idle mask check above. hart_execute() could
just be an empty function

> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("hart_suspend");
> +
> +	if (sbi_probe(SBI_EXT_IPI)) {
> +		on_secondary_cpus_async(hart_retentive_suspend, NULL);
> +
> +		for_each_present_cpu(cpu) {
> +			if (cpu == me)
> +				continue;
> +
> +			hartid = cpus[cpu].hartid;
> +			hart_mask[hartid / BITS_PER_LONG] |= 1UL << hartid;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
> +			ret = sbi_hart_get_status(hartid);
> +			report(!ret.error && (ret.value == SBI_EXT_HSM_SUSPENDED),

split report

> +			       "hart %ld successfully retentive suspended", hartid);
> +		}
> +
> +		for (int i = 0; i < NR_CPUS / BITS_PER_LONG; ++i) {
> +			if (hart_mask[i]) {

using a real mask for hart_mask would allow using

  for_each_cpu(i, &hart_mask)

> +				ret = sbi_send_ipi(hart_mask[i], i * BITS_PER_LONG);

but, instead, let's provide the following (untested) function in lib/riscv/sbi.c

   struct sbiret sbi_send_ipi_cpumask(cpumask_t *mask)
   {
        struct sbiret ret;

	for (int i = 0; i < CPUMASK_NR_LONGS; ++i) {
	    if (cpumask_bits(mask)[i]) {
	       ret = sbi_send_ipi(cpumask_bits(mask)[i], i * BITS_PER_LONG);
	       if (ret.error)
	          break;
	    }
	}

	return ret;
   }

then you can drop your loop and just call the new API.

> +				if (ret.error) {
> +					ipi_failed = true;
> +					report_fail("got %ld when sending ipi to retentive suspended harts",
> +						    ret.error);
> +					break;
> +				}
> +			}
> +		}
> +
> +		if (!ipi_failed) {
> +			for_each_present_cpu(cpu) {
> +				if (cpu == me)
> +					continue;
> +
> +				hartid = cpus[cpu].hartid;
> +				hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
> +				hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
> +				ret = sbi_hart_get_status(hartid);
> +				report(!ret.error && (ret.value == SBI_EXT_HSM_STARTED),

split report

> +				       "hart %ld successfully retentive resumed", hartid);
> +			}
> +
> +			while (!cpumask_test_secondary_cpus(&cpu_idle_mask))
> +				cpu_relax();

Timed wait and use cpumask_weight

> +
> +			report(cpumask_full(&cpu_online_mask), "all cpus online");
> +			report(cpumask_test_secondary_cpus(&cpus_alive_after_retentive_suspend),
> +			       "all secondary harts successfully executed code after retentive suspend");

Already checked with the wait on idle.

> +		}
> +
> +		/* Reset the ipi_failed flag so that we can reuse it for non-retentive suspension tests */
> +		ipi_failed = false;
> +
> +		on_secondary_cpus_async(hart_non_retentive_suspend, NULL);
> +
> +		for_each_present_cpu(cpu) {
> +			if (cpu == me)
> +				continue;
> +
> +			hartid = cpus[cpu].hartid;
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
> +			ret = sbi_hart_get_status(hartid);
> +			report(!ret.error && (ret.value == SBI_EXT_HSM_SUSPENDED),

split errors

> +			       "hart %ld successfully non-retentive suspended", hartid);
> +		}
> +
> +		for (int i = 0; i < NR_CPUS / BITS_PER_LONG; ++i) {
> +			if (hart_mask[i]) {

use real mask

> +				ret = sbi_send_ipi(hart_mask[i], i * BITS_PER_LONG);
> +				if (ret.error) {
> +					ipi_failed = true;
> +					report_fail("got %ld when sending ipi to non-retentive suspended harts",
> +						    ret.error);
> +					break;
> +				}
> +			}
> +		}
> +
> +		if (!ipi_failed) {
> +			for_each_present_cpu(cpu) {
> +				if (cpu == me)
> +					continue;
> +
> +				hartid = cpus[cpu].hartid;
> +				hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
> +				hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
> +				ret = sbi_hart_get_status(hartid);
> +				report(!ret.error && (ret.value == SBI_EXT_HSM_STARTED),

split errors

> +				       "hart %ld successfully non-retentive resumed", hartid);
> +			}
> +
> +			for_each_present_cpu(cpu) {
> +				if (cpu == me)
> +					continue;
> +
> +				hartid = cpus[cpu].hartid;
> +
> +				while (!((per_hart_non_retentive_suspend_checks =
> +					 READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid]))
> +					 & SBI_HSM_TEST_DONE))

Could drop the local variable and index the array below.

> +					cpu_relax();
> +
> +				report(per_hart_non_retentive_suspend_checks & SBI_HSM_TEST_SATP,
> +				       "satp is zero for test hart %ld", hartid);
> +				report(per_hart_non_retentive_suspend_checks & SBI_HSM_TEST_SIE,
> +				       "sstatus.SIE is zero for test hart %ld", hartid);
> +				report(per_hart_non_retentive_suspend_checks & SBI_HSM_TEST_HARTID_A1,
> +				       "a0 and a1 are hartid for test hart %ld", hartid);
> +			}
> +
> +			report_prefix_pop();
> +
> +			report_prefix_push("hart_stop");
> +
> +			for_each_present_cpu(cpu) {
> +				if (cpu == me)
> +					continue;
> +
> +				hartid = cpus[cpu].hartid;
> +				WRITE_ONCE(sbi_hsm_stop_hart[hartid], true);

barrier, memset, barrier?

> +			}
> +
> +			for_each_present_cpu(cpu) {
> +				if (cpu == me)
> +					continue;
> +
> +				hartid = cpus[cpu].hartid;
> +				hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
> +				hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
> +				ret = sbi_hart_get_status(hartid);
> +				report(!ret.error && (ret.value == SBI_EXT_HSM_STOPPED),

split errors

> +				       "test hart %ld successfully stopped", hartid);
> +			}
> +		}

We can avoid having to add a level of indention to all the code that
depends on SBI_EXT_IPI by either putting it all in a function and then
calling that when IPI is available or by doing

  if (!sbi_probe(SBI_EXT_IPI)) {
     report_skip("skipping suspension tests since ipi extension is unavailable");
     return;
  }

since all these tests are currently the last in this function.

> +	} else {
> +		report_skip("skipping suspension tests since ipi extension is unavailable");
> +	}
> +
> +	report_prefix_popn(2);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	if (argc > 1 && !strcmp(argv[1], "-h")) {
> @@ -435,6 +816,7 @@ int main(int argc, char **argv)
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

