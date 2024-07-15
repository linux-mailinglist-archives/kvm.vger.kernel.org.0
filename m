Return-Path: <kvm+bounces-21668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA172931DB2
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 01:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E48A282638
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 23:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A3B143891;
	Mon, 15 Jul 2024 23:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cH4gt+Iv"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02164142659
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 23:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721086699; cv=none; b=kFPjCPl1ycVvZVlS3Bu25LC1jPkp9O6KihCe7tfCqs2TRs0SlfvVksj9YCk57+9yAhGLP6D1wAnzmwWOfWUeWoO/OAETvMb5xwCAtgRbgiRX9n94wvR7rEStwb6/d6ci2cqdjy6Cpqal6Zc16VJp3lLFwEX4Y/FoTw+H2f9Bczk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721086699; c=relaxed/simple;
	bh=+eex/zGQLjYuMUgjUSVjAIqp/eRbpv4WdxVHnV2yAbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdzZhfUWZ5tZnRtXbsJ9GHYEx0o9mKVGy6ewTC9+9bqTkJMRm4FnYyE45X5K0J0J5niy1yK7AdJCGo1GUG+VSNrc/fbJc6dl7c5/a1PJMpvG/gh69RgoMXqb0FXn1Z8e/X1vTw0nDgUxQ0e50yOdZaq61Jnaeel3wJ/EML+8xQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cH4gt+Iv; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jamestiotio@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721086691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eov8vlNlg1rAbqilfhccWJIE+ZzdWCEsL2wKk+GU7i8=;
	b=cH4gt+Iv9dU0lZr8ycI009/Rsm9zaJTwMBmDPJPYatYYEGBwqC6Tn6CkgJK77ZzwKzIYpD
	hf/6EeAbqnRizZbMNZ0P226bNtO3gCW94xPSqrDlaSOTjZn0OIb2a4S9ZppvJKsJ2Z8BK0
	Jonbvr/IhVnZkkLrFnltUVHpWandap8=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
Date: Mon, 15 Jul 2024 18:38:02 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v2 3/3] riscv: sbi: Add test for timer
 extension
Message-ID: <20240715-180ca4fcd886945070ec3a22@orel>
References: <20240707101053.74386-1-jamestiotio@gmail.com>
 <20240707101053.74386-4-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240707101053.74386-4-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jul 07, 2024 at 06:10:52PM GMT, James Raphael Tiovalen wrote:
> Add a test for the set_timer function of the time extension. The test
> checks that:
> - The time extension is available
> - The time counter monotonically increases
> - The installed timer interrupt handler is called
> - The timer interrupt is received within a reasonable time interval
> - The timer interrupt pending bit is cleared after the set_timer SBI
>   call is made
> - The timer interrupt can be cleared either by requesting a timer
>   interrupt infinitely far into the future or by masking the timer
>   interrupt
> 
> The timer interrupt delay can be set using the TIMER_DELAY environment
> variable in microseconds. The default delay value is 1 second. Since the
> interrupt can arrive a little later than the specified delay, allow some
> margin of error. This margin of error can be specified via the
> TIMER_MARGIN environment variable in microseconds. The default margin of
> error is 1 second.

1 second is too much since we want these tests to run really fast when
possible. Let's use 200 ms.

> 
> This test has been verified on RV32 and RV64 with OpenSBI using QEMU.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/csr.h   |   7 +++
>  lib/riscv/asm/sbi.h   |   5 ++
>  lib/riscv/asm/setup.h |   1 +
>  lib/riscv/asm/timer.h |  30 ++++++++++++
>  lib/riscv/processor.c |   6 +++
>  lib/riscv/setup.c     |  24 ++++++++++
>  riscv/sbi.c           | 108 ++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 181 insertions(+)
>  create mode 100644 lib/riscv/asm/timer.h
> 
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index b3c48e8e..dc05bfc9 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -4,12 +4,15 @@
>  #include <linux/const.h>
>  
>  #define CSR_SSTATUS		0x100
> +#define CSR_SIE			0x104
>  #define CSR_STVEC		0x105
>  #define CSR_SSCRATCH		0x140
>  #define CSR_SEPC		0x141
>  #define CSR_SCAUSE		0x142
>  #define CSR_STVAL		0x143
> +#define CSR_SIP			0x144
>  #define CSR_SATP		0x180
> +#define CSR_TIME		0xc01
>  
>  #define SR_SIE			_AC(0x00000002, UL)
>  
> @@ -50,6 +53,10 @@
>  #define IRQ_S_GEXT		12
>  #define IRQ_PMU_OVF		13
>  
> +#define IE_TIE			(_AC(0x1, UL) << IRQ_S_TIMER)
> +
> +#define IP_TIP			IE_TIE
> +
>  #ifndef __ASSEMBLY__
>  
>  #define csr_swap(csr, val)					\
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index d82a384d..84ce1bff 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -16,6 +16,7 @@
>  
>  enum sbi_ext_id {
>  	SBI_EXT_BASE = 0x10,
> +	SBI_EXT_TIME = 0x54494d45,
>  	SBI_EXT_HSM = 0x48534d,
>  	SBI_EXT_SRST = 0x53525354,
>  };
> @@ -37,6 +38,10 @@ enum sbi_ext_hsm_fid {
>  	SBI_EXT_HSM_HART_SUSPEND,
>  };
>  
> +enum sbi_ext_time_fid {
> +	SBI_EXT_TIME_SET_TIMER = 0,
> +};
> +
>  struct sbiret {
>  	long error;
>  	long value;
> diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
> index 7f81a705..5be252df 100644
> --- a/lib/riscv/asm/setup.h
> +++ b/lib/riscv/asm/setup.h
> @@ -7,6 +7,7 @@
>  #define NR_CPUS 16
>  extern struct thread_info cpus[NR_CPUS];
>  extern int nr_cpus;
> +extern uint64_t tb_hz;

Let's spell out timebase and maybe even just call it exactly
the same name as the DT node, i.e. 'timebase_frequency'

>  int hartid_to_cpu(unsigned long hartid);
>  
>  void io_init(void);
> diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
> new file mode 100644
> index 00000000..3eeb8344
> --- /dev/null
> +++ b/lib/riscv/asm/timer.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_TIMER_H_
> +#define _ASMRISCV_TIMER_H_
> +
> +#include <asm/csr.h>
> +#include <asm/processor.h>
> +
> +extern uint64_t usec_to_cycles(uint64_t usec);
> +
> +static inline void timer_irq_enable(void)
> +{
> +	csr_set(CSR_SIE, IE_TIE);
> +}
> +
> +static inline void timer_irq_disable(void)
> +{
> +	csr_clear(CSR_SIE, IE_TIE);
> +}
> +
> +static inline uint64_t timer_get_cycles(void)
> +{
> +	return csr_read(CSR_TIME);
> +}
> +
> +static inline bool timer_irq_pending(void)
> +{
> +	return csr_read(CSR_SIP) & IP_TIP;

I don't think we need to add this function to asm/timer.h.
I don't expect we'll be checking SIP for TIP much other
than in its test, so this function or the open coded
check can be put directly in the test code.

> +}
> +
> +#endif /* _ASMRISCV_TIMER_H_ */
> diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
> index 0dffadc7..082b9d80 100644
> --- a/lib/riscv/processor.c
> +++ b/lib/riscv/processor.c
> @@ -7,6 +7,7 @@
>  #include <asm/isa.h>
>  #include <asm/processor.h>
>  #include <asm/setup.h>
> +#include <asm/timer.h>
>  
>  extern unsigned long ImageBase;
>  
> @@ -82,3 +83,8 @@ void thread_info_init(void)
>  	isa_init(&cpus[cpu]);
>  	csr_write(CSR_SSCRATCH, &cpus[cpu]);
>  }
> +
> +uint64_t usec_to_cycles(uint64_t usec)
> +{
> +	return (tb_hz * usec) / 1000000;

This function should be a static inline. It also seems like
it belongs in something like a 'delay' component, rather than
the 'processor' component. We should probably add the frequency
getting and usec_to_cycles() support adding in a separate patch,
possibly also introducing delay.{c,h} at the same time (see
Arm's delay.{c,h})

> +}
> diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
> index 50ffb0d0..b659c14e 100644
> --- a/lib/riscv/setup.c
> +++ b/lib/riscv/setup.c
> @@ -20,6 +20,7 @@
>  #include <asm/page.h>
>  #include <asm/processor.h>
>  #include <asm/setup.h>
> +#include <asm/timer.h>
>  
>  #define VA_BASE			((phys_addr_t)3 * SZ_1G)
>  #if __riscv_xlen == 64
> @@ -38,6 +39,7 @@ u32 initrd_size;
>  
>  struct thread_info cpus[NR_CPUS];
>  int nr_cpus;
> +uint64_t tb_hz;
>  
>  static struct mem_region riscv_mem_regions[NR_MEM_REGIONS + 1];
>  
> @@ -67,6 +69,26 @@ static void cpu_init_acpi(void)
>  	assert_msg(false, "ACPI not available");
>  }
>  
> +static int cpu_init_timer(const void *fdt)

We're not initializing per-cpu timers so the name of this function isn't
correct. It should be something like 'timer_get_frequency' and maybe it
should live in lib/riscv/timer.c rather than setup.c

> +{
> +	const struct fdt_property *prop;
> +	u32 *data;
> +	int cpus;
> +
> +	cpus = fdt_path_offset(fdt, "/cpus");
> +	if (cpus < 0)
> +		return cpus;

We intend to assert on all non-zero return values so we could just
make this function void and assert directly here. That would actually
make it easier to debug since we'd see which assert fired, i.e. what
exactly failed.

> +
> +	prop = fdt_get_property(fdt, cpus, "timebase-frequency", NULL);
> +	if (prop == NULL)
> +		return -1;
> +
> +	data = (u32 *)prop->data;
> +	tb_hz = fdt32_to_cpu(*data);
> +
> +	return 0;
> +}
> +
>  static void cpu_init(void)
>  {
>  	int ret;
> @@ -75,6 +97,8 @@ static void cpu_init(void)
>  	if (dt_available()) {
>  		ret = dt_for_each_cpu_node(cpu_set_fdt, NULL);
>  		assert(ret == 0);
> +		ret = cpu_init_timer(dt_fdt());
> +		assert(ret == 0);

I think we should call timer_get_frequency() directly from setup()
and setup_efi() (please also test with EFI) and have a

 assert_msg(!dt_available(), "ACPI not yet supported");

at the top of timer_get_frequency().

>  	} else {
>  		cpu_init_acpi();
>  	}
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 762e9711..a1a9ce84 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -6,7 +6,14 @@
>   */
>  #include <libcflat.h>
>  #include <stdlib.h>
> +#include <asm/barrier.h>
> +#include <asm/csr.h>
> +#include <asm/processor.h>
>  #include <asm/sbi.h>
> +#include <asm/timer.h>
> +
> +static bool timer_works;
> +static bool mask_timer_irq;
>  
>  static void help(void)
>  {
> @@ -19,6 +26,27 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
>  	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
>  }
>  
> +static struct sbiret __time_sbi_ecall(unsigned long stime_value)
> +{
> +	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
> +}
> +
> +static void timer_irq_handler(struct pt_regs *regs)
> +{
> +	if (timer_works)
> +		report_abort("timer interrupt received multiple times");

We should generally avoid doing too much in an interrupt handler as
it can add delays to our expected interrupt arrivals, etc. This is
why we have variables like 'timer_works'. We only set the variable
in the handler and then, back in normal context, we look at the
variable to decide what we should do.

> +
> +	timer_works = true;
> +	report(timer_irq_pending(), "pending timer interrupt bit set");
> +
> +	if (mask_timer_irq)
> +		timer_irq_disable();
> +	else {
> +		__time_sbi_ecall(-1);
> +		report(!timer_irq_pending(), "pending timer interrupt bit cleared");
> +	}
> +}
> +
>  static bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {
> @@ -112,6 +140,85 @@ static void check_base(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_time(void)
> +{
> +	struct sbiret ret;
> +	unsigned long begin, end, duration;
> +	unsigned long delay = getenv("TIMER_DELAY")
> +							? strtol(getenv("TIMER_DELAY"), NULL, 0)
> +							: 1000000;
> +	unsigned long margin = getenv("TIMER_MARGIN")
> +							? strtol(getenv("TIMER_MARGIN"), NULL, 0)
> +							: 1000000;

Put the '?' part of the ternary on the same line as the '='.

foo = bar ? x
          : y;

> +
> +	delay = usec_to_cycles(delay);
> +	margin = usec_to_cycles(margin);
> +
> +	report_prefix_push("time");
> +
> +	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_TIME);
> +
> +	if (ret.error) {
> +		report_fail("probing for time extension failed");
> +		report_prefix_pop();
> +		return;
> +	}

See my suggestion in Cade's patch about adding sbi_probe() which asserts
on ret.error.

> +
> +	if (!ret.value) {
> +		report_skip("time extension not available");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	begin = timer_get_cycles();
> +	while ((end = timer_get_cycles()) <= begin)
> +		cpu_relax();
> +	assert(begin < end);

This will always be true since we loop until it's true.
We should just do

 begin = timer_get_cycles();
 delay(d);
 end = timer_get_cycles();
 assert(begin + usec_to_cycles(d) <= end);

(which means we need the 'delay' component)

> +
> +	report_prefix_push("set_timer");
> +
> +	install_irq_handler(IRQ_S_TIMER, timer_irq_handler);
> +	local_irq_enable();
> +	timer_irq_enable();

Before enabling the timer irq we should make sure stimecmp is -1
when we have the Sstc extension.

> +
> +	begin = timer_get_cycles();
> +	ret = __time_sbi_ecall(begin + delay);
> +
> +	if (ret.error)
> +		report_fail("setting timer failed");

This should be something like

  report(!ret.error, "set timer");
  if (ret.error)
     report_info("set timer failed with %ld\n", ret.error);

Hmm, the spec doesn't actually say what to expect for ret.error and
ret.value. We can still test for !ret.error though, I guess... We
should probably also clarify the spec, please open a PR.

> +
> +	report(!timer_irq_pending(), "pending timer interrupt bit cleared");
> +
> +	while ((end = timer_get_cycles()) <= (begin + delay + margin) && !timer_works)
> +		cpu_relax();
> +
> +	report(timer_works, "timer interrupt received");
> +
> +	if (timer_works) {
> +		duration = end - begin;
> +		report(duration >= delay && duration <= (delay + margin), "timer delay honored");
> +	}
> +
> +	timer_works = false;
> +	mask_timer_irq = true;
> +	begin = timer_get_cycles();
> +	ret = __time_sbi_ecall(begin + delay);
> +
> +	if (ret.error)
> +		report_fail("setting timer failed");

same comment as above

> +
> +	while ((end = timer_get_cycles()) <= (begin + delay + margin) && !timer_works)
> +		cpu_relax();
> +
> +	report(timer_works, "timer interrupt received");

This should have a different text than above. Something like

 "timer interrupt received for mask irq test"

We should probably repeat the check that the interrupt arrived within the
appropriate margin too (and also ensure it's text is different from the
test above)

> +
> +	local_irq_disable();
> +	install_irq_handler(IRQ_S_TIMER, NULL);
> +
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
>  int main(int argc, char **argv)
>  {
>  
> @@ -122,6 +229,7 @@ int main(int argc, char **argv)
>  
>  	report_prefix_push("sbi");
>  	check_base();
> +	check_time();
>  
>  	return report_summary();
>  }
> -- 
> 2.43.0
> 

Thanks,
drew

