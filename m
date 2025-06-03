Return-Path: <kvm+bounces-48280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9346FACC2AE
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 11:09:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BA36171F23
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B460280CE7;
	Tue,  3 Jun 2025 09:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KCT0BjQj"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F132C324E
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 09:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748941780; cv=none; b=QYpmZ6fg8eJYevTaW2oTrI/aGW9GIGrouvD4Q8RXSYEzK9l3ELibqLG3iDZrRKA8AGEk2pileR5cbKjnlz2ix1TPL0I1Z1I/fI6QHdBY8JgvRGmB2uJqaSTa/weNH96sUeZ+MxDrTvgIpW4kT/TYE0SJcyZPftRNBEVn80d75kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748941780; c=relaxed/simple;
	bh=vTL0Fhdjb+NX+uKBJaQ9PxfeKvTQrjcPx2VRXz36ZDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guWZtpQMIUPzkNUesPCwep+D85QXI9je3nGWs2cK9yVzHFQyzy6Nw6bqoOHBfk6YzIELsrx4nXBR1YKfXWP0S+1m54KNvME+Ro55Negcr7fEJJMgOwtjvn7IELjquwPq+QRbY8d3fbaZH79NGwINwEq1rIMTta5NgWma4uUx4uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KCT0BjQj; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Jun 2025 11:09:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748941775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HosKKhKaeAxS0BiblgoplCxniIg8FN66wGDmGUgRL0s=;
	b=KCT0BjQjtCVrutQNA760Pedbb11ZG6XjGVOCuAczocX6KAEUJyT273u3DiHowXFp8hnIKx
	gbNDhJKE6Gca+oVUrcCAVzTw+oAcMOLyeji4xJyCzlpyUIeIOyTCt8EmzFrxJk2lHegR+9
	tFXXrr2FbM+wWYF6oM35ZXzxphbenYo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [PATCH 3/3] riscv: Add ISA double trap extension testing
Message-ID: <20250603-46e84d5167307b38c90a06b5@orel>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
 <20250523075341.1355755-4-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250523075341.1355755-4-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 23, 2025 at 09:53:10AM +0200, Clément Léger wrote:
> This test allows to test the double trap implementation of hardware as
> well as the SBI FWFT and SSE support for double trap. The tests will try
> to trigger double trap using various sequences and will test to receive
> the SSE double trap event if supported.
> 
> It is provided as a separate test from the SBI one for two reasons:
> - It isn't specifically testing SBI "per se".
> - It ends up by trying to crash into in M-mode.
> 
> Currently, the test uses a page fault to raise a trap programatically.
> Some concern was raised by a github user on the original branch [1]
> saying that the spec doesn't mandate any trap to be delegatable and that
> we would need a way to detect which ones are delegatable. I think we can
> safely assume that PAGE FAULT is delagatable and if a hardware that does
> not have support comes up then it will probably be the vendor
> responsibility to provide a way to do so.
> 
> Link: https://github.com/clementleger/kvm-unit-tests/issues/1 [1]
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile      |   1 +
>  lib/riscv/asm/csr.h |   1 +
>  riscv/isa-dbltrp.c  | 189 ++++++++++++++++++++++++++++++++++++++++++++
>  riscv/unittests.cfg |   5 ++
>  4 files changed, 196 insertions(+)
>  create mode 100644 riscv/isa-dbltrp.c
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 11e68eae..d71c9d2e 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -14,6 +14,7 @@ tests =
>  tests += $(TEST_DIR)/sbi.$(exe)
>  tests += $(TEST_DIR)/selftest.$(exe)
>  tests += $(TEST_DIR)/sieve.$(exe)
> +tests += $(TEST_DIR)/isa-dbltrp.$(exe)
>  
>  all: $(tests)
>  
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index 3e4b5fca..6a8e0578 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -18,6 +18,7 @@
>  
>  #define SR_SIE			_AC(0x00000002, UL)
>  #define SR_SPP			_AC(0x00000100, UL)
> +#define SR_SDT			_AC(0x01000000, UL) /* Supervisor Double Trap */
>  
>  /* Exception cause high bit - is an interrupt if set */
>  #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
> diff --git a/riscv/isa-dbltrp.c b/riscv/isa-dbltrp.c
> new file mode 100644
> index 00000000..174aee2a
> --- /dev/null
> +++ b/riscv/isa-dbltrp.c
> @@ -0,0 +1,189 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * SBI verification
> + *
> + * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
> + */
> +#include <alloc.h>
> +#include <alloc_page.h>
> +#include <libcflat.h>
> +#include <stdlib.h>
> +
> +#include <asm/csr.h>
> +#include <asm/page.h>
> +#include <asm/processor.h>
> +#include <asm/ptrace.h>
> +#include <asm/sbi.h>
> +
> +#include <sbi-tests.h>
> +
> +static bool double_trap;
> +static bool set_sdt = true;
> +
> +#define GEN_TRAP()								\
> +do {										\
> +	void *ptr = NULL;							\
> +	unsigned long value = 0;						\
> +	asm volatile(								\
> +	"	.option push\n"							\
> +	"	.option arch,-c\n"						\
> +	"	sw %0, 0(%1)\n"							\
> +	"	.option pop\n"							\
> +	: : "r"(value), "r"(ptr) : "memory");					\

nit: need some spaces

 "r" (value), "r" (ptr)

> +} while (0)
> +
> +static void syscall_trap_handler(struct pt_regs *regs)

This is a page fault handler, not a syscall.

> +{
> +	if (set_sdt)
> +		csr_set(CSR_SSTATUS, SR_SDT);
> +
> +	if (double_trap) {
> +		double_trap = false;
> +		GEN_TRAP();
> +	}
> +
> +	/* Skip trapping instruction */
> +	regs->epc += 4;
> +}
> +
> +static bool sse_dbltrp_called;
> +
> +static void sse_dbltrp_handler(void *data, struct pt_regs *regs, unsigned int hartid)
> +{
> +	struct sbiret ret;
> +	unsigned long flags;
> +	unsigned long expected_flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP |
> +				       SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT;
> +
> +	ret = sbi_sse_read_attrs(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, SBI_SSE_ATTR_INTERRUPTED_FLAGS, 1,
> +				 &flags);
> +	sbiret_report_error(&ret, SBI_SUCCESS, "Get double trap event flags");
> +	report(flags == expected_flags, "SSE flags == 0x%lx", expected_flags);
> +
> +	sse_dbltrp_called = true;
> +
> +	/* Skip trapping instruction */
> +	regs->epc += 4;
> +}
> +
> +static void sse_double_trap(void)
> +{
> +	struct sbiret ret;
> +
> +	struct sbi_sse_handler_arg handler_arg = {
> +		.handler = sse_dbltrp_handler,
> +		.stack = alloc_page() + PAGE_SIZE,
> +	};
> +
> +	report_prefix_push("sse");
> +
> +	ret = sbi_sse_hart_unmask();
> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart unmask ok"))
> +		goto out;

The unmasking failed, but the out label takes us to a mask.

> +
> +	ret = sbi_sse_register(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, &handler_arg);
> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> +		report_skip("SSE double trap event is not supported");
> +		goto out;
> +	}
> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap register");
> +
> +	ret = sbi_sse_enable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap enable"))
> +		goto out_unregister;
> +
> +	/*
> +	 * Generate a double crash so that an SSE event should be generated. The SPEC (ISA nor SBI)
> +	 * does not explicitly tell that if supported it should generate an SSE event but that's
> +	 * a reasonable assumption to do so if both FWFT and SSE are supported.

This is something to raise in a tech-prs call, because it sounds like we
need another paragraph for FWFT which states when DOUBLE_TRAP is enabled
and SSE is supported that SSE local double trap events will be raised. Or,
we need another FWFT feature that allows S-mode to request that behavior
be enabled/disabled when SSE is supported (and M-mode can decide yes/no
to that request).

> +	 */
> +	set_sdt = true;
> +	double_trap = true;

WRITE_ONCE(set_sdt, true);
WRITE_ONCE(double_trap, true);

> +	GEN_TRAP();
> +
> +	report(sse_dbltrp_called, "SSE double trap event generated");

READ_ONCE(sse_dbltrp_called)

> +
> +	ret = sbi_sse_disable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap disable");
> +out_unregister:
> +	ret = sbi_sse_unregister(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap unregister");
> +
> +out:
> +	sbi_sse_hart_mask();
> +	free_page(handler_arg.stack - PAGE_SIZE);
> +
> +	report_prefix_pop();
> +}
> +
> +static void check_double_trap(void)
> +{
> +	struct sbiret ret;
> +
> +	/* Disable double trap */
> +	ret = sbi_fwft_set(SBI_FWFT_DOUBLE_TRAP, 0, 0);
> +	sbiret_report_error(&ret, SBI_SUCCESS, "Set double trap enable feature value == 0");
> +	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
> +	sbiret_report(&ret, SBI_SUCCESS, 0, "Get double trap enable feature value == 0");
> +
> +	install_exception_handler(EXC_STORE_PAGE_FAULT, syscall_trap_handler);
> +
> +	double_trap = true;

WRITE_ONCE(double_trap, true);

> +	GEN_TRAP();
> +	report_pass("Double trap disabled, trap first time ok");
> +
> +	/* Enable double trap */
> +	ret = sbi_fwft_set(SBI_FWFT_DOUBLE_TRAP, 1, 1);

Why lock it?

> +	sbiret_report_error(&ret, SBI_SUCCESS, "Set double trap enable feature value == 1");
> +	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
> +	if (!sbiret_report(&ret, SBI_SUCCESS, 1, "Get double trap enable feature value == 1"))
> +		return;
> +
> +	/* First time, clear the double trap flag (SDT) so that it doesn't generate a double trap */
> +	set_sdt = false;
> +	double_trap = true;

WRITE_ONCE(set_sdt, true);
WRITE_ONCE(double_trap, true);

> +	GEN_TRAP();
> +	report_pass("Trapped twice allowed ok");
> +
> +	if (sbi_probe(SBI_EXT_SSE))
> +		sse_double_trap();
> +	else
> +		report_skip("SSE double trap event will not be tested, extension is not available");
> +
> +	/*
> +	 * Second time, keep the double trap flag (SDT) and generate another trap, this should

Third time if we did the SSE test.

> +	 * generate a double trap. Since there is no SSE handler registered, it should crash to
> +	 * M-mode.

No SSE handler that we know of... sse_double_trap() should return
some error if it fails to unregister and then we should skip this
test in that case.

> +	 */
> +	set_sdt = true;
> +	double_trap = true;

WRITE_ONCE(set_sdt, true);
WRITE_ONCE(double_trap, true);

> +	report_info("Should generate a double trap and crash !");
> +	GEN_TRAP();
> +	report_fail("Should have crashed !");

nit: Put the '!' next to the last word.

I think this M-mode crash test should be optional. We can make it optional
on an environment variable since we already use environment variables for
other optional tests. We even have env_or_skip() in riscv/sbi-tests.h for
that purpose.

> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct sbiret ret;
> +
> +	report_prefix_push("dbltrp");
> +
> +	if (!sbi_probe(SBI_EXT_FWFT)) {
> +		report_skip("FWFT extension is not available, can not enable double traps");
> +		goto out;
> +	}
> +
> +	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
> +	if (ret.value == SBI_ERR_NOT_SUPPORTED) {
> +		report_skip("SBI_FWFT_DOUBLE_TRAP is not supported !");

nit: Put the '!' next to the last word.

> +		goto out;
> +	}
> +
> +	if (sbiret_report_error(&ret, SBI_SUCCESS, "SBI_FWFT_DOUBLE_TRAP get value"))
> +		check_double_trap();
> +
> +out:
> +	report_prefix_pop();
> +
> +	return report_summary();
> +}
> diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
> index 2eb760ec..757e6027 100644
> --- a/riscv/unittests.cfg
> +++ b/riscv/unittests.cfg
> @@ -18,3 +18,8 @@ groups = selftest
>  file = sbi.flat
>  smp = $MAX_SMP
>  groups = sbi
> +
> +[dbltrp]
> +file = isa-dbltrp.flat
> +smp = $MAX_SMP

The test doesn't appear to require multiple harts.

> +groups = isa

groups = isa sbi

> -- 
> 2.49.0
>

Thanks,
drew

