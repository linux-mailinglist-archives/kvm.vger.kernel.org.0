Return-Path: <kvm+bounces-22506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB8EB93F6B6
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08A531C2186C
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3E414EC47;
	Mon, 29 Jul 2024 13:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S9Nf6PdI"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E999D1420D0
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722259869; cv=none; b=KhhdZEejrNO1WplQTje+99bo0RC3X0ptGQ43Mn8F590k6QbOdJsZSflLSWTkrazn9G6vioKk6xiw0ulUIKyEXmz4Og6WFYSDy0XRmcjEPGuguIvaUY2hpiTGiYoVQeLrNLrRWFihLSjRjqJWYo5/AshvbocUQRIMbjrMkhNDv5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722259869; c=relaxed/simple;
	bh=CSeWyxtXGfa8Wp85zPo12PzWFDebFaaXH8/l7BQ5Hkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZ0y2Bz8Ukbw8hIdWzVeVPOJpQ0RXDDBlDhp+59cTbAswk3Di96yyLkdJE3E/wOmyQ/hVQ/hrRK0sHGXlYUIJijseYddpksn3neSKwgbPbLivR1LCWbe+t0Rno2UXCHLPAG7hc9wvBHBfBtSg95Yo1tf86IVlAp9Z5WY2NHWS8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S9Nf6PdI; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 29 Jul 2024 15:31:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722259865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qqEgYVCrJjJwtoysFoDZ1ZfMUOa9QD4x5M2Di+FogDY=;
	b=S9Nf6PdIgzpZPLty4xeX+OmpaTraX+tOaePJdlhwKscAIdv1z/2CMMnaCa1n+AdfpLvEDl
	aH0SXSISw3Hj+i0l/a7DMw/iS1k/5IzcVfYIrXif5add720KTg9LqlF6sC0Hn9YWm2hWKy
	py+s0BfXurdw095syYcxMzKIc39DdqE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v5 5/5] riscv: sbi: Add test for timer
 extension
Message-ID: <20240729-a7e67852ef18e54de184d42a@orel>
References: <20240728165022.30075-1-jamestiotio@gmail.com>
 <20240728165022.30075-6-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240728165022.30075-6-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 29, 2024 at 12:50:22AM GMT, James Raphael Tiovalen wrote:
> Add a test for the set_timer function of the time extension. The test
> checks that:
> - The time extension is available
> - The installed timer interrupt handler is called
> - The timer interrupt is received within a reasonable time interval
> - The timer interrupt pending bit is cleared after the set_timer SBI
>   call is made
> - The timer interrupt can be cleared either by requesting a timer
>   interrupt infinitely far into the future or by masking the timer
>   interrupt
> 
> The timer interrupt delay can be set using the TIMER_DELAY environment
> variable in microseconds. The default delay value is 200 milliseconds.
> Since the interrupt can arrive a little later than the specified delay,
> allow some margin of error. This margin of error can be specified via
> the TIMER_MARGIN environment variable in microseconds. The default
> margin of error is 200 milliseconds.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/csr.h   |   8 +++
>  lib/riscv/asm/sbi.h   |   5 ++
>  lib/riscv/asm/timer.h |  10 +++
>  riscv/sbi.c           | 144 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 167 insertions(+)
> 
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index a9b1bd42..24b333e0 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -4,11 +4,15 @@
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
> +#define CSR_STIMECMP		0x14d
> +#define CSR_STIMECMPH		0x15d
>  #define CSR_SATP		0x180
>  #define CSR_TIME		0xc01
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
> index f7504f84..b3514d3f 100644
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
> index 762e9711..044258bb 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -6,7 +6,25 @@
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
> +struct timer_info {
> +	bool timer_works;
> +	bool mask_timer_irq;
> +	bool timer_irq_set;
> +	bool timer_irq_cleared;
> +	unsigned long timer_irq_count;
> +};
> +
> +static struct timer_info timer_info_;

I'd rather call this just 'timer_info' than 'timer_info_'. I usually
prefer to use a different name than the struct for grepping purposes,
but for a static structure of a small file it doesn't really matter.

>  
>  static void help(void)
>  {
> @@ -19,6 +37,36 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
>  	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
>  }
>  
> +static struct sbiret __time_sbi_ecall(unsigned long stime_value)
> +{
> +	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
> +}
> +
> +static bool timer_irq_pending(void)
> +{
> +	return csr_read(CSR_SIP) & IP_TIP;
> +}
> +
> +static void timer_irq_handler(struct pt_regs *regs)
> +{
> +	if (timer_info_.timer_irq_count < ULONG_MAX)
> +		++timer_info_.timer_irq_count;
> +
> +	timer_info_.timer_works = true;
> +	if (timer_irq_pending())
> +		timer_info_.timer_irq_set = true;
> +
> +	if (timer_info_.mask_timer_irq) {
> +		timer_irq_disable();
> +		__time_sbi_ecall(0);
> +	} else {
> +		__time_sbi_ecall(ULONG_MAX);
> +	}
> +
> +	if (!timer_irq_pending())
> +		timer_info_.timer_irq_cleared = true;
> +}
> +
>  static bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {
> @@ -112,6 +160,101 @@ static void check_base(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_time(void)
> +{
> +	struct sbiret ret;
> +	unsigned long begin, end, duration;
> +	unsigned long d = getenv("TIMER_DELAY") ? strtol(getenv("TIMER_DELAY"), NULL, 0)
> +						: 200000;
> +	unsigned long margin = getenv("TIMER_MARGIN") ? strtol(getenv("TIMER_MARGIN"), NULL, 0)
> +						      : 200000;
> +
> +	d = usec_to_cycles(d);
> +	margin = usec_to_cycles(margin);
> +
> +	report_prefix_push("time");
> +
> +	if (!sbi_probe(SBI_EXT_TIME)) {
> +		report_skip("time extension not available");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	report_prefix_push("set_timer");
> +
> +	install_irq_handler(IRQ_S_TIMER, timer_irq_handler);
> +	local_irq_enable();
> +	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
> +		csr_write(CSR_STIMECMP, ULONG_MAX);
> +#if __riscv_xlen == 32
> +		csr_write(CSR_STIMECMPH, ULONG_MAX);
> +#endif
> +	}
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
> +	while ((end = timer_get_cycles()) <= (begin + d + margin) && !timer_info_.timer_works)
> +		cpu_relax();
> +
> +	report(timer_info_.timer_works, "timer interrupt received");
> +	report(timer_info_.timer_irq_set, "pending timer interrupt bit set in irq handler");
> +	report(timer_info_.timer_irq_set && timer_info_.timer_irq_cleared,
> +	       "pending timer interrupt bit cleared by setting timer to -1");
> +
> +	if (timer_info_.timer_works) {
> +		duration = end - begin;
> +		report(duration >= d && duration <= (d + margin), "timer delay honored");
> +	}
> +
> +	if (timer_info_.timer_irq_count > 1)
> +		report_fail("timer interrupt received multiple times");
> +
> +	if (csr_read(CSR_SIE) & IE_TIE) {
> +		timer_info_ = (struct timer_info){ .mask_timer_irq = true };
> +		begin = timer_get_cycles();
> +		ret = __time_sbi_ecall(begin + d);
> +
> +		report(!ret.error, "set timer for mask irq test");
> +		if (ret.error)
> +			report_info("set timer for mask irq test failed with %ld\n", ret.error);
> +
> +		while ((end = timer_get_cycles()) <= (begin + d + margin)
> +		       && !timer_info_.timer_works)
> +			cpu_relax();
> +
> +		report(timer_info_.timer_works, "timer interrupt received for mask irq test");
> +		report(timer_info_.timer_irq_set,
> +		       "pending timer interrupt bit set in irq handler for mask irq test");
> +		report(timer_info_.timer_irq_set && timer_info_.timer_irq_cleared,
> +		       "pending timer interrupt bit cleared by masking timer irq");
> +
> +		if (timer_info_.timer_works) {
> +			duration = end - begin;
> +			report(duration >= d && duration <= (d + margin),
> +			"timer delay honored for mask irq test");
> +		}
> +
> +		if (timer_info_.timer_irq_count > 1)
> +			report_fail("timer interrupt received multiple times for mask irq test");

nit: we could share all the code in the body of this if-statement with the
code above if we just create a function which takes a const char * which
would be NULL for the first invocation and "for mask irq test" for the
second.

> +	} else {
> +		report_skip("timer irq enable bit is not writable, skipping mask irq test");
> +	}
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
> @@ -122,6 +265,7 @@ int main(int argc, char **argv)
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

