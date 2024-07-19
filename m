Return-Path: <kvm+bounces-21954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2403B937B11
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46FD11C21CD6
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C30145FE1;
	Fri, 19 Jul 2024 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZNCEgmJt"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0BB2F30
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721406714; cv=none; b=mGzPbZpxdYQuQBVjKGjFMi+/EGPzqB9VilIdVZYYQ+3gJ9oyGhquWzr6/OdxlurA0ywgH+MiRIOTRXOxlgi+Y/W3fDdfAQqCwdXli/lPrubzWRO6sY0nInYXmCxg5+jM7F6xZg4wTLuuG7je0a4SXx52IYFiDIb5d846uv6zqCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721406714; c=relaxed/simple;
	bh=bHMZVAIJXUtaXZ+25zRYaSwKIgB80QDUGwaZfd8lpqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QieccVCYesZWvF2fyYw36WuY57NkC4y4xYZkH6UsGxokAqhJlPyDhnqlxFxkFgzzUfDs90Oe5mB8bJmPgmH6jZNuFlkcYFFr5RWVGOAGoXS3qWfKoCV2zBqInVJgqPLHNFg80aCG7a36lKvxow32J+eVphh0EUUqawG9hfRRkoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZNCEgmJt; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jamestiotio@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721406709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxDBTviArTpV5r8VkQvuDFRHuBXZEohQF5CKTD2GYJY=;
	b=ZNCEgmJtjN4UsqdlRUrEJKTokwfmkjJewhdYMG03bn93QRxdbWESGiXAc9dms96vfZnaOr
	itxXhSGf/PRr2oh86EvRDIjmgw9sm7wWx6BezO3VMGCAb5t5evxTKCRmf+2nhQdFMBGq7f
	Igw+218vAaO0qSqXrkPmegD3vXNcxC8=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
Date: Fri, 19 Jul 2024 11:31:41 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v3 5/5] riscv: sbi: Add test for timer
 extension
Message-ID: <20240719-fe2a61d5b67ed6ba35e25eca@orel>
References: <20240719023947.112609-1-jamestiotio@gmail.com>
 <20240719023947.112609-6-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240719023947.112609-6-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 19, 2024 at 10:39:47AM GMT, James Raphael Tiovalen wrote:
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

Do we need a whole second? I'd reduce the default delay for the interrupt
in order to ensure speedy test execution. I think this can be 200 ms as
well.

> interrupt can arrive a little later than the specified delay, allow some
> margin of error. This margin of error can be specified via the
> TIMER_MARGIN environment variable in microseconds. The default margin of
> error is 200 milliseconds.
> 
> This test has been verified on RV32 and RV64 with OpenSBI using QEMU.

Sentences like these belong in the cover letter or under the --- below
your signoff as they don't belong in the commit (particularly because
it doesn't include opensbi and qemu versions so it's not that useful
of information and because all patches should be tested on rv32 and
rv64, both with and without EFI, before they're merged :-)

> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/csr.h   |   8 +++
>  lib/riscv/asm/sbi.h   |   5 ++
>  lib/riscv/asm/timer.h |  10 ++++
>  riscv/sbi.c           | 136 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 159 insertions(+)
> 
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index a9b1bd42..052c0412 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -4,13 +4,17 @@
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
>  #define CSR_TIME		0xc01
> +#define CSR_STIMECMP		0x14d
> +#define CSR_STIMECMPH		0x15d

Please put these CSRs in numeric order, below CSR_SIP.

>  
>  #define SR_SIE			_AC(0x00000002, UL)
>  
> @@ -47,6 +51,10 @@
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
> index 5e1a674a..73ab5438 100644
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
> diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
> index 2e319391..cd20262f 100644
> --- a/lib/riscv/asm/timer.h
> +++ b/lib/riscv/asm/timer.h
> @@ -11,4 +11,14 @@ static inline uint64_t timer_get_cycles(void)
>  	return csr_read(CSR_TIME);
>  }
>  
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
>  #endif /* _ASMRISCV_TIMER_H_ */
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 762e9711..9798b989 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -6,7 +6,21 @@
>   */
>  #include <libcflat.h>
>  #include <stdlib.h>
> +#include <limits.h>
> +#include <asm/barrier.h>
> +#include <asm/csr.h>
> +#include <asm/delay.h>
> +#include <asm/isa.h>
> +#include <asm/processor.h>
>  #include <asm/sbi.h>
> +#include <asm/smp.h>
> +#include <asm/timer.h>
> +
> +static bool timer_works;
> +static bool mask_timer_irq;
> +static bool timer_irq_set;
> +static bool timer_irq_cleared;
> +static unsigned long timer_irq_count;
>  
>  static void help(void)
>  {
> @@ -19,6 +33,33 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
>  	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
>  }
>  
> +static struct sbiret __time_sbi_ecall(unsigned long stime_value)
> +{
> +	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
> +}
> +
> +static inline bool timer_irq_pending(void)
> +{
> +	return csr_read(CSR_SIP) & IP_TIP;
> +}
> +
> +static void timer_irq_handler(struct pt_regs *regs)
> +{
> +	timer_irq_count = (timer_irq_count == ULONG_MAX) ? ULONG_MAX : timer_irq_count + 1;

Unnecessary () and it might read better as

  if (timer_irq_count < ULONG_MAX)
      ++timer_irq_count;

> +
> +	timer_works = true;
> +	if (timer_irq_pending())
> +		timer_irq_set = true;
> +
> +	if (mask_timer_irq)
> +		timer_irq_disable();

If we use {} on one arm of an if-else then we should use them on both,
even if one arm is only a single statement.

> +	else {
> +		__time_sbi_ecall(ULONG_MAX);
> +		if (!timer_irq_pending())
> +			timer_irq_cleared = true;
> +	}
> +}
> +
>  static bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {
> @@ -112,6 +153,100 @@ static void check_base(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_time(void)
> +{
> +	struct sbiret ret;
> +	unsigned long begin, end, duration;
> +	unsigned long d = getenv("TIMER_DELAY") ? strtol(getenv("TIMER_DELAY"), NULL, 0)
> +						: 1000000;
> +	unsigned long margin = getenv("TIMER_MARGIN") ? strtol(getenv("TIMER_MARGIN"), NULL, 0)
> +						      : 200000;
> +
> +	d = usec_to_cycles(d);
> +	margin = usec_to_cycles(margin);

You can also add udelay() to delay.c to provide a convenience
to users, i.e. we could use udelay(d) below without first
converting d from usec to cycles. See lib/arm/delay.c for some
inspiration.

> +
> +	report_prefix_push("time");
> +
> +	if (!sbi_probe(SBI_EXT_TIME)) {
> +		report_skip("time extension not available");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	begin = timer_get_cycles();
> +	delay(d);
> +	end = timer_get_cycles();
> +	assert(begin + d <= end);

I don't think we need this begin/end capture and assert because it's only
testing our delay function. We should test our delay function before we
merge it to lib/riscv and then unit tests should be able to trust it
since it's in the lib.

> +
> +	report_prefix_push("set_timer");
> +
> +	install_irq_handler(IRQ_S_TIMER, timer_irq_handler);
> +	local_irq_enable();
> +	if (cpu_has_extension(smp_processor_id(), ISA_SSTC))
> +#if __riscv_xlen == 64
> +		csr_write(CSR_STIMECMP, ULONG_MAX);
> +#else
> +		csr_write(CSR_STIMECMPH, ULONG_MAX);
> +#endif

This should be

	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
		csr_write(CSR_STIMECMP, ULONG_MAX);
 #if __riscv_xlen == 32
		csr_write(CSR_STIMECMPH, ULONG_MAX);
 #endif
        }

since rv32 needs to write both registers.

> +	timer_irq_enable();
> +
> +	begin = timer_get_cycles();
> +	ret = __time_sbi_ecall(begin + d);
> +
> +	report(!ret.error, "set timer");
> +	if (ret.error)
> +		report_info("set timer failed with %ld\n", ret.error);
> +
> +	report(!timer_irq_pending(), "pending timer interrupt bit cleared");
> +
> +	while ((end = timer_get_cycles()) <= (begin + d + margin) && !timer_works)
> +		cpu_relax();
> +
> +	report(timer_works, "timer interrupt received");
> +	report(timer_irq_set, "pending timer interrupt bit set in irq handler");
> +	report(timer_irq_cleared, "pending timer interrupt bit cleared by setting timer to -1");
> +
> +	if (timer_works) {
> +		duration = end - begin;
> +		report(duration >= d && duration <= (d + margin), "timer delay honored");
> +	}
> +
> +	if (timer_irq_count > 1)
> +		report_fail("timer interrupt received multiple times");
> +
> +	timer_works = false;
> +	timer_irq_set = false;
> +	timer_irq_count = 0;
> +	mask_timer_irq = true;
> +	begin = timer_get_cycles();
> +	ret = __time_sbi_ecall(begin + d);
> +
> +	report(!ret.error, "set timer for mask irq test");
> +	if (ret.error)
> +		report_info("set timer for mask irq test failed with %ld\n", ret.error);
> +
> +	while ((end = timer_get_cycles()) <= (begin + d + margin) && !timer_works)
> +		cpu_relax();
> +
> +	report(timer_works, "timer interrupt received for mask irq test");
> +	report(timer_irq_set, "pending timer interrupt bit set in irq handler for mask irq test");
> +
> +	if (timer_works) {
> +		duration = end - begin;
> +		report(duration >= d && duration <= (d + margin),
> +		       "timer delay honored for mask irq test");
> +	}
> +
> +	if (timer_irq_count > 1)
> +		report_fail("timer interrupt received multiple times for mask irq test");
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
> @@ -122,6 +257,7 @@ int main(int argc, char **argv)
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

Looks great! Only a couple tweaks remaining and it'll be ready for merge.

Thanks,
drew

