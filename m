Return-Path: <kvm+bounces-25262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC7D962AB7
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64A04282A5C
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B01719DF8D;
	Wed, 28 Aug 2024 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QVw0mvVo"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D6618A6C3
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724856516; cv=none; b=LdqyRe4DMDxq5zEAxjq6Jqq+lEtmDuQcKE60i4mQJKE4lD/V6nZJdLXIykO/XYfWNDQQY7NJZG0G0I8zKX978ogY26JI5oiqO/ala940Vfu/evaihQHllwAvaVz2HnWrSzY2/+qj/MutU3PuKbX9HT0zcUyLBdDkxK/D8MoW1Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724856516; c=relaxed/simple;
	bh=1+L1j1EPBKybH2e3LBk09KEoyFW/khIpA7yAgx4T0hM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pwzJO7EaORMXE/hobkYqtJuO/MfyQ8vsJ2Tbk6UjsSMtvdSy1vbMBpoC3AVx0jCahsT7FVYrrX56FSJhyzWI4wEq6GZT4zH7vSTO7Jg4WA+lZDrG7h5m6opy1vNQr5RkgUbePuQuEmcPqxP+MQIVA6WS+NlcfJSnlP2Xl2ASTBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QVw0mvVo; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Aug 2024 16:48:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724856510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ExC/CKGNIByC1RV0BVFyMZPPHDjKqVm8b5yckfgn4Ec=;
	b=QVw0mvVob9cg7ZKY7omff7enK6nTMU+mzZhEkCdAywUDCLQOdzo6FORszAQ2S2NtU+PKbx
	ya5l8tZH4MGMD9CJ5S5yFUzQEy9fxdaB2F6uTWAdaH8Lmu/z5r4AnkL3Sbz41gfKwjQo8O
	2Gl8sUqgcEaKPsC1+p0fYP7tcCaybuo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v2] riscv: sbi: add IPI extension tests.
Message-ID: <20240828-9e5ff57ab81af9d53bcc4839@orel>
References: <20240826065106.20281-1-cade.richard@berkeley.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826065106.20281-1-cade.richard@berkeley.edu>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 25, 2024 at 11:51:06PM GMT, Cade Richard wrote:
> Add tests for the RISC-V OpenSBI inter-processor interrupt extension.
> 
> Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
> ---
>  lib/riscv/asm/sbi.h |   5 ++
>  riscv/sbi.c         | 141 ++++++++++++++++++++++++++++++++++++++++++++
>  riscv/unittests.cfg |   1 +
>  3 files changed, 147 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 47e91025..dd0ce9a1 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -17,6 +17,7 @@
>  enum sbi_ext_id {
>  	SBI_EXT_BASE = 0x10,
>  	SBI_EXT_TIME = 0x54494d45,
> +	SBI_EXT_IPI = 0x735049,
>  	SBI_EXT_HSM = 0x48534d,
>  	SBI_EXT_SRST = 0x53525354,
>  	SBI_EXT_DBCN = 0x4442434E,
> @@ -32,6 +33,10 @@ enum sbi_ext_base_fid {
>  	SBI_EXT_BASE_GET_MIMPID,
>  };
>  
> +enum sbi_ext_ipi_fid {
> +	SBI_EXT_IPI_SEND = 0,
> +};
> +
>  enum sbi_ext_hsm_fid {
>  	SBI_EXT_HSM_HART_START = 0,
>  	SBI_EXT_HSM_HART_STOP,
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 36ddfd48..d0c33a72 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -6,11 +6,15 @@
>   */
>  #include <libcflat.h>
>  #include <alloc_page.h>
> +#include <cpumask.h>
> +#include <cpumask.h>

redundant cpumask.h include

>  #include <stdlib.h>
>  #include <string.h>
>  #include <limits.h>
>  #include <vmalloc.h>
>  #include <memregions.h>
> +#include <on-cpus.h>
> +#include <rand.h>
>  #include <asm/barrier.h>
>  #include <asm/csr.h>
>  #include <asm/delay.h>
> @@ -19,10 +23,16 @@
>  #include <asm/mmu.h>
>  #include <asm/processor.h>
>  #include <asm/sbi.h>
> +#include <asm/setup.h>
>  #include <asm/smp.h>
>  #include <asm/timer.h>
>  
>  #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
> +static prng_state ps;

Why is ps global? It isn't accessed from interrupt context or need to
otherwise be global.

> +static bool ipi_received[__riscv_xlen];
> +static bool ipi_timeout[__riscv_xlen];
> +static bool ipi_received[__riscv_xlen];
> +static bool ipi_timeout[__riscv_xlen];

Doesn't this warn when compiling? The arrays are duplicated.

>  
>  static void help(void)
>  {
> @@ -45,6 +55,11 @@ static struct sbiret __dbcn_sbi_ecall(int fid, unsigned long arg0, unsigned long
>  	return sbi_ecall(SBI_EXT_DBCN, fid, arg0, arg1, arg2, 0, 0, 0);
>  }
>  
> +static struct sbiret __ipi_sbi_ecall(unsigned long hart_mask, unsigned long hart_mask_base)
> +{
> +	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND, hart_mask, hart_mask_base, 0, 0, 0, 0);
> +}

Should rebase on latest
https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi and use
sbi_send_ipi()

> +
>  static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo)
>  {
>  	*lo = (unsigned long)paddr;
> @@ -420,6 +435,131 @@ static void check_dbcn(void)
>  	report_prefix_pop();
>  }
>  
> +static int rand_online_cpu(prng_state* ps)
> +{
> +	int me = smp_processor_id();
> +	int num_iters = prng32(ps) % NR_CPUS;
> +	int rand_cpu = cpumask_next(me, &cpu_online_mask);
> +
> +	/*
> +	 *	TODO: Not sure if cpumask_next should wrap or not. Get this checked.

It should not. If we need a wrapping cpumask_next then you can do
something like

cpumask_next_wrap(...)
{
   cpu = cpumask_next(cpu, ...)
   if (cpu == nr_cpus)
      cpu = cpumask_next(-1, ...)

but do we really need that? If we want a random online cpu as the function
name states, then isn't the following sufficient?

 cpu = prng32(ps) % nr_cpus;
 cpu = cpumask_next(cpu - 1, &cpu_online_mask);

> +	 */
> +	for (int i = 0; i < num_iters; i++) {
> +		rand_cpu = cpumask_next(rand_cpu, &cpu_online_mask);
> +	}
> +
> +	return rand_cpu;
> +}
> +
> +static void ipi_timeout_handler(struct pt_regs *regs)
> +{
> +	int me = smp_processor_id();
> +	ipi_timeout[me] = true;
> +}
> +
> +static void ipi_irq_handler(struct pt_regs *regs)
> +{
> +	int me = smp_processor_id();
> +	ipi_received[me] = true;
> +}
> +
> +static void ipi_hart_init(void *irq_func)
> +{
> +	int me = smp_processor_id();
> +	install_irq_handler(IRQ_S_IPI, (void *)ipi_irq_handler);

What is this patch based on? We don't have IRQ_S_IPI. So this can't
compile. Anyway, there's no such thing. For SBI IPI you want IRQ_S_SOFT,
which we do have.

> +	install_irq_handler(IRQ_S_TIMER, (void *)ipi_timeout_handler);


Drop the (void *) casts. They aren't needed.

> +	local_irq_enable();
> +	timer_irq_enable();

We also need to enable IRQ_S_SOFT. We don't have functions for that
yet, but since IPIs are generally useful, like timers are, then I think
we should have them. The enable/disable pair can go in
lib/riscv/asm/processor.h and be named softirq_enable/softirq_disable.

> +
> +	while (!ipi_received[me] && !ipi_timeout[me])

Need !READ_ONCE(ipi_received[me]) && !READ_ONCE(ipi_timeout[me])
otherwise the ipi_* arrays need to at least be declared as volatile.
This is to avoid the compiler thinking it's fine to just check them
once since nothing in the loop body modifies them.

> +		cpu_relax();
> +	timer_irq_disable();
> +	local_irq_disable();
> +
> +	if (ipi_timeout[me])
> +		report_fail("ipi timed out on hart %d", me);
> +	if (ipi_received[me])
> +		report_pass("ipi received on hart %d", me);

This function is called blah_blah_init() so it shouldn't be doing
anything other than initialization, but it looks like it's doing a
test. It could just be renamed to something with 'check' in the
name instead if we want to do the init and the check in the same place.

> +}
> +
> +static void check_ipi(void)
> +{
> +	int cpu = smp_processor_id();
> +	unsigned long me = (unsigned long)cpu;

me = (unsigned long)smp_processor_id() ?

> +	struct sbiret ret;
> +	ps = prng_init(0xDEADBEEF);
> +
> +	report_prefix_push("ipi");
> +
> +	if (!sbi_probe(SBI_EXT_IPI)) {
> +		report_skip("ipi extension not available");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	if (cpumask_weight(&cpu_online_mask) <= 1) {

nit: The weight can't be less than 1 without a bug in the framework. So
just == 1 makes more sense to me, but I'd actually probably write it < 2.

> +		report_skip("smp not enabled");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
> +		csr_write(CSR_STIMECMP, ULONG_MAX);
> +		if (__riscv_xlen == 32)
> +			csr_write(CSR_STIMECMPH, ULONG_MAX);
> +	}

Let's move this above block into setup code so we don't have to
repeat it everywhere that the SBI time extension is used. We
should actually extend our timer support in lib/riscv/timer.c
as well to allow a timer to be set with sstc when available or
fallback to SBI TIME when that's available or error out when
no way to set a timer is available. I'll do that myself now and
push to the riscv/sbi branch for you to base on.

(Unlike the cpumask_to_list function I promised, but then didn't do, but
also looks like you don't need anymore, I'll actually do this one!)

> +
> +	report_prefix_push("send to one random hart");

This is too wordy to be a prefix. We should make it more concise or
just drop it.

> +	int rand_hartid = rand_online_cpu(&ps);

This is a cpuid, not a hartid.

> +	cpumask_t rand_mask;
> +	cpumask_set_cpu(rand_hartid, &rand_mask);

If this mask should have hartids in it instead of cpuids, then the
return of rand_online_cpu() needs to be converted to a hartid with
cpus[rand_cpu].hartid first.

> +	on_cpu(rand_hartid, (void *)ipi_hart_init, NULL);
> +	unsigned long ipi_rand_mask = 1 << rand_hartid;

Why aren't we using a cpumask for ipi_rand_mask?

> +
> +	memset(ipi_received, 0, sizeof(ipi_received));
> +	memset(ipi_timeout, 0, sizeof(ipi_timeout));
> +	ret = __ipi_sbi_ecall((unsigned long)cpumask_bits(&rand_mask), 0);

This should be

       sbi_send_ipi(cpumask_bits(&rand_mask)[0], 0)

because cpumask_bits returns a pointer to an array and we want the same
element of that array as we pass for the base hartid. If we wanted to go
higher than the number of bits in a ulong, e.g. 70 on rv64, then we'd do

       sbi_send_ipi(cpumask_bits(&rand_mask)[70 % BITS_PER_LONG], 70 & ~(BITS_PER_LONG - 1))

> +	report(ret.error == SBI_SUCCESS, "send to one randomly chosen hart");
> +	report_prefix_pop();
> +
> +	report_prefix_push("broadcast");
> +	report_prefix_push("with hart_mask");

The "with hart_mask" text can go in the report(...), i.e. we don't need
another prefix, just 'broadcast' is enough.

> +	on_cpus((void *)ipi_hart_init, NULL);
> +	unsigned long ipi_broadcast_mask;

Why not a real cpumask? How will we use these tests on platforms with > 64
cpus?

> +	memcpy(&ipi_broadcast_mask, &cpu_online_mask, sizeof(ipi_broadcast_mask));

Why not cpumask_copy?

> +	
> +	memset(ipi_received, 0, sizeof(ipi_received));
> +	memset(ipi_timeout, 0, sizeof(ipi_timeout));
> +	ret = __ipi_sbi_ecall(ipi_broadcast_mask, me);
> +	report(ret.error == SBI_SUCCESS, "ipi sent");
> +	report_prefix_pop();
> +
> +	report_prefix_push("by setting hart_mask_base to -1");

Same as above. This text can go in the report() rather than be a prefix.

> +	on_cpus((void *)ipi_hart_init, NULL);
> +
> +	memset(ipi_received, 0, sizeof(ipi_received));
> +	memset(ipi_timeout, 0, sizeof(ipi_timeout));
> +	ret = __ipi_sbi_ecall(0, -1);
> +	report(ret.error == SBI_SUCCESS, "ipi sent");
> +	report_prefix_pop();
> +	report_prefix_pop();
> +
> +	report_prefix_push("invalid parameters");
> +	unsigned long invalid_hart_mask_base = NR_CPUS;
> +	ret = __ipi_sbi_ecall(ipi_rand_mask, invalid_hart_mask_base);
> +	report(ret.error == SBI_ERR_INVALID_PARAM, "hart_mask_base");
> +
> +	cpumask_t invalid_mask;
> +	cpumask_set_cpu(NR_CPUS, &invalid_mask);

The above could overrun the cpumask array since the array size if
calculated from NR_CPUS. To do a test like this we need to determine
a hartid that exceeds the highest hartid and then try to send an IPI
to it using a valid base parameter.

> +	unsigned long invalid_mask_bits = (unsigned long)cpumask_bits(&invalid_mask);
> +	ret = __ipi_sbi_ecall(invalid_mask_bits, me);
> +	report(ret.error == SBI_ERR_INVALID_PARAM, "hart_mask");
> +	report_prefix_pop();

We're still missing the mask = 0, base != -1 test that I pointed out last
time.

> +
> +	report_prefix_pop();
> +	report_prefix_pop();

I lost count, but three pops seems like one pop too many.

> +}
> +
>  int main(int argc, char **argv)
>  {
>  	if (argc > 1 && !strcmp(argv[1], "-h")) {
> @@ -431,6 +571,7 @@ int main(int argc, char **argv)
>  	check_base();
>  	check_time();
>  	check_dbcn();
> +	check_ipi();
>  
>  	return report_summary();
>  }
> diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
> index cbd36bf6..2eb760ec 100644
> --- a/riscv/unittests.cfg
> +++ b/riscv/unittests.cfg
> @@ -16,4 +16,5 @@ groups = selftest
>  # Set $FIRMWARE_OVERRIDE to /path/to/firmware to select the SBI implementation.
>  [sbi]
>  file = sbi.flat
> +smp = $MAX_SMP
>  groups = sbi
> -- 
> 2.43.0
> 
>

Please make sure the code compiles and runs on at least rv64 before
posting the next version.

Thanks,
drew

