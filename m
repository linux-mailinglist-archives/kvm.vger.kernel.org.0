Return-Path: <kvm+bounces-20962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2094927ADA
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 18:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 145D91F21C67
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 16:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9824F1B1519;
	Thu,  4 Jul 2024 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I/wiw3Sb"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2B21A2C1E
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720109195; cv=none; b=CZ7Jno/om9HrxCX2K1V4WwVcKSy5sQzwptyFACIahvz8ZPTmQ0B5OZP9atwty1xkD9M4lt3mIgguIIRQ1PHcth/S2U7TeiNX0fK1rmZSITN5vfBCYxk4xNKCD1gQeHE+DG2n4GxXGJxZ6lapRk9bCCoWqWsuGPNUeYLRD1BMYCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720109195; c=relaxed/simple;
	bh=zhoNSP3L6Jj6Spmik+a3CNA7HLo+yipd2xFnvY4lZxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UsFbvUf2Z3YoL3zY90leNLLP0gVUfcTBdOa8qSfXudTe45P3UtWxT5BiHeaFZGbVkXf5psfXTclkUvDZQ/rw0TCcJWmbNoSii3Jfw62WDtyY9bptmhEnqxMNO+H+kqaRRgiRNfY7zwG9NwyURzOClqbLT+CsNPsz7no7axI2YPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I/wiw3Sb; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jamestiotio@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720109189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VOvXPkLGojE5nteyG5Ze6FNsDQR83M3KU1Pel8qHixM=;
	b=I/wiw3SbpV7S6/h6j2GiSJx2cBYKuf4z1R+Tb1Q4JdJDygIlJzJfU/5s/bIAZ/OlnKsjmg
	ejE63E59FPS/tMkrdX6Ro8ogK0iOCI2I8UuHu9nwzElATOPdoXyQdOUYrWNSw2U0ILkBbE
	ZCk6vIXqqGKks5v31hLIE2fGAfTllbY=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
Date: Thu, 4 Jul 2024 11:06:25 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH 4/4] riscv: sbi: Add test for timer
 extension
Message-ID: <20240704-8c9503a4a5e1504cf66051ba@orel>
References: <20240618173053.364776-1-jamestiotio@gmail.com>
 <20240618173053.364776-5-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618173053.364776-5-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 19, 2024 at 01:30:53AM GMT, James Raphael Tiovalen wrote:
> Add a test for the set_timer function of the time extension. The test
> checks that:
> - The time extension is available
> - The time counter monotonically increases
> - The installed timer interrupt handler is called
> - The timer interrupt is received within a reasonable time frame
> 
> The timer interrupt delay can be set using the TIMER_DELAY environment
> variable. If the variable is not set, the default delay value is
> 1000000. The time interval used to validate the timer interrupt is
> between the specified delay and double the delay. Because of this, the
> test might fail if the delay is too short. Hence, we set the default
> delay value as the minimum value.
> 
> This test has been verified on RV32 and RV64 with OpenSBI using QEMU.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/csr.h |  6 ++++
>  lib/riscv/asm/sbi.h |  5 +++
>  riscv/sbi.c         | 87 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+)
> 
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index da58b0ce..c4435650 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -12,6 +12,7 @@
>  #define CSR_STVAL		0x143
>  #define CSR_SIP			0x144
>  #define CSR_SATP		0x180
> +#define CSR_TIME		0xc01
>  
>  #define SSTATUS_SIE		(_AC(1, UL) << 1)
>  
> @@ -108,5 +109,10 @@
>  				: "memory");			\
>  })
>  
> +#define wfi()							\
> +({								\
> +	__asm__ __volatile__("wfi" ::: "memory");		\
> +})

This belongs in lib/riscv/asm/barrier.h (but actually we don't need it at
all, see below.)

> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMRISCV_CSR_H_ */
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index d82a384d..eb4c77ef 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -18,6 +18,7 @@ enum sbi_ext_id {
>  	SBI_EXT_BASE = 0x10,
>  	SBI_EXT_HSM = 0x48534d,
>  	SBI_EXT_SRST = 0x53525354,
> +	SBI_EXT_TIME = 0x54494D45,

Let's list these in chapter order, so TIME comes after BASE.

>  };
>  
>  enum sbi_ext_base_fid {
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
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 762e9711..6ad1dff6 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -6,8 +6,13 @@
>   */
>  #include <libcflat.h>
>  #include <stdlib.h>
> +#include <asm/csr.h>
> +#include <asm/interrupt.h>
> +#include <asm/processor.h>
>  #include <asm/sbi.h>
>  
> +static bool timer_work;

timer_works

> +
>  static void help(void)
>  {
>  	puts("Test SBI\n");
> @@ -19,6 +24,18 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
>  	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
>  }
>  
> +static struct sbiret __time_sbi_ecall(int fid, unsigned long arg0)

Since this is the time extension specific wrapper function then we should
use time extension specific parameter names, i.e. s/arg0/stime_value/ and
we don't need to take fid as a parameter since there's only a single
function ID which can just be put directly in the sbi_ecall() call.

> +{
> +	return sbi_ecall(SBI_EXT_TIME, fid, arg0, 0, 0, 0, 0, 0);
> +}
> +
> +static void timer_interrupt_handler(struct pt_regs *regs)
> +{
> +	timer_work = true;
> +	toggle_timer_interrupt(false);
> +	local_irq_disable();

Just masking the timer interrupt should be enough. We don't want to over
disable interrupts because we want to ensure the minimally specified
disabling is sufficient in order to properly test the SBI impl. Also,
we probably don't want to mask the timer interrupt here since we need
to also provide a test case which only sets the next timer interrupt to
be "infinitely far into the future" as specified by SBI as an alternative
for "clearing" the timer interrupt.

> +}
> +
>  static bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {
> @@ -112,6 +129,75 @@ static void check_base(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_time(void)
> +{
> +	struct sbiret ret;
> +	unsigned long begin, end, duration;
> +	const unsigned long default_delay = 1000000;
> +	unsigned long delay = getenv("TIMER_DELAY")
> +				? MAX(strtol(getenv("TIMER_DELAY"), NULL, 0), default_delay)

Is there a reason we can't have a shorter delay than 1000000? Using MAX()
will silently force 1000000 even when the user provided an environment
variable with something smaller.

> +				: default_delay;
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
> +
> +	if (!ret.value) {
> +		report_skip("time extension not available");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	begin = csr_read(CSR_TIME);
> +	end = csr_read(CSR_TIME);

It doesn't hurt to have this sanity check, but I'd probably make it
an assert since things are really nuts if the timer isn't working.

 begin = csr_read(CSR_TIME);
 // Add delay here based on the timer frequency to ensure at
 // least one tick of the timer occurs
 assert(begin < csr_read(CSR_TIME));

> +	if (begin >= end) {
> +		report_fail("time counter has decreased");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	report_prefix_push("set_timer");
> +
> +	install_irq_handler(IRQ_SUPERVISOR_TIMER, timer_interrupt_handler);
> +	local_irq_enable();
> +
> +	begin = csr_read(CSR_TIME);
> +	ret = __time_sbi_ecall(SBI_EXT_TIME_SET_TIMER, csr_read(CSR_TIME) + delay);
> +
> +	if (ret.error) {
> +		report_fail("setting timer failed");
> +		install_irq_handler(IRQ_SUPERVISOR_TIMER, NULL);
> +		report_prefix_pop();
> +		report_prefix_pop();
> +		return;

We don't necessarily need to abort the rest of the tests. Sometimes yes,
if we know that when this test fails nothing else can work, but if there
are other tests, such as negative tests, that we could still try, then
we should.

> +	}
> +
> +	toggle_timer_interrupt(true);
> +
> +	while ((!timer_work) && (csr_read(CSR_TIME) <= (begin + delay)))

nit: Unnecessary () on both sides of the &&

> +		wfi();


wfi() means we expect some interrupt, sometime, but if the timer setting
isn't working then we may never get any interrupt. We should use
cpu_relax(). Unit tests can't make any assumptions, but that's OK, since
they don't need to be efficient. (Anything about the environment we would
like to assume should be checked with asserts or at least be documented.)

> +
> +	end = csr_read(CSR_TIME);

duration will be slightly more accurate if we write the while loop like

 while ((end = csr_read(CSR_TIME)) < begin + delay)
     cpu_relax();

> +	report(timer_work, "timer interrupt received");
> +
> +	install_irq_handler(IRQ_SUPERVISOR_TIMER, NULL);
> +	__time_sbi_ecall(SBI_EXT_TIME_SET_TIMER,  -1);
> +
> +	duration = end - begin;
> +	if (timer_work)
> +		report((duration >= delay) && (duration <= (delay + delay)), "timer delay honored");

The <= delay + delay check implies that the delay has been selected for
two purposes, how long to wait for the interrupt and how much time we
allow the interrupt to be late. We should have two separate variables
for those two purposes, both configurable.

> +
> +	report_prefix_pop();
> +

nit: drop this extra blank line.

> +	report_prefix_pop();

(After seeing all these repeated _pop() lines I'm actually thinking we
need another report API call, something like report_prefix_popn(int n)
which pops n number times.)

> +}
> +
>  int main(int argc, char **argv)
>  {
>  
> @@ -122,6 +208,7 @@ int main(int argc, char **argv)
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

The spec says "This function must clear the pending timer interrupt bit as
well." so I think we should have something in the test that checks that
too.

Thanks,
drew

