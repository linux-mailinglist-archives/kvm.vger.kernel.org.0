Return-Path: <kvm+bounces-48317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D2514ACCB38
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 18:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C6167A9AF4
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 16:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0405923F291;
	Tue,  3 Jun 2025 16:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KQkJyGm5"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D9523C511
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748967969; cv=none; b=tFoIvUKBC7NeOVIltCYa/HPJdR0jnV6alsqQRk73cBH3s4Y5yru1suSAqSj9eVCUHG29l21bH7pCb5yq71gTe13M8lDYqjZYfBbow+Hxh5v5ulNwW/yJMq0XbPLcTDgqf2RTZT22SVUFTz4WbUzBi4Ue1sJ/JtmKdJy6JxA6u/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748967969; c=relaxed/simple;
	bh=5ePL13X3PJUXQDmGxbNOF5UT5AFbMUpu/pW+78GbfhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GESBLuruDZgt3Fdalj84MAuNQwh706PabMPiMpJezq6FgcDbIsCkJN4SkzD/5l1ixUcLnze1M3MVNAJcz32gcI6kxFsLV22IRyo8uRuhfrF/rMlypjgXdAh8T4Y4cJE2ql8h2WJ7dxB69dguoTi3/UayEfIsLlP02J1LNO8BRMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KQkJyGm5; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Jun 2025 18:25:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748967961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZBAniNnGiElPg6mOkY82dWGbV7a3yKmZ4sg11NxT1WY=;
	b=KQkJyGm5Qrl8fLvpuyX0P7CKRdbSAL5suxcTKEGgfMEP+4LARluTvrfY9ONB0Vra7zFIMa
	D7ciX/ORgsTeBvIBqcC3P9Er77LwBh5mddYDtVrv3Q7Su3Ic9/xXYh5UtYriIiTLcIS6Mv
	fFYckZ5amTjUrfqvX7EQlpvlriP4VkE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [kvm-unit-tests v2 2/2] riscv: Add ISA double trap extension
 testing
Message-ID: <20250603-1e175dd9e60c1bf2a52dbfc9@orel>
References: <20250603154652.1712459-1-cleger@rivosinc.com>
 <20250603154652.1712459-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250603154652.1712459-3-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 03, 2025 at 05:46:50PM +0200, Clément Léger wrote:
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
> safely assume that PAGE FAULT is delegatable and if a hardware that does
> not have support comes up then it will probably be the vendor
> responsibility to provide a way to do so.
> 
> Link: https://github.com/clementleger/kvm-unit-tests/issues/1 [1]
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile            |   1 +
>  lib/riscv/asm/csr.h       |   1 +
>  lib/riscv/asm/processor.h |  10 ++
>  riscv/isa-dbltrp.c        | 211 ++++++++++++++++++++++++++++++++++++++
>  riscv/unittests.cfg       |   4 +
>  5 files changed, 227 insertions(+)
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
> diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
> index 40104272..87a41312 100644
> --- a/lib/riscv/asm/processor.h
> +++ b/lib/riscv/asm/processor.h
> @@ -48,6 +48,16 @@ static inline void ipi_ack(void)
>  	csr_clear(CSR_SIP, IE_SSIE);
>  }
>  
> +static inline void local_dlbtrp_enable(void)
> +{
> +	csr_set(CSR_SSTATUS, SR_SDT);
> +}
> +
> +static inline void local_dlbtrp_disable(void)
> +{
> +	csr_clear(CSR_SSTATUS, SR_SDT);
> +}
> +
>  void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *));
>  void install_irq_handler(unsigned long cause, void (*handler)(struct pt_regs *));
>  void do_handle_exception(struct pt_regs *regs);
> diff --git a/riscv/isa-dbltrp.c b/riscv/isa-dbltrp.c
> new file mode 100644
> index 00000000..a4545096
> --- /dev/null
> +++ b/riscv/isa-dbltrp.c
> @@ -0,0 +1,211 @@
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
> +static bool clear_sdt;
> +
> +#define INSN_LEN(insn)			((((insn) & 0x3) < 0x3) ? 2 : 4)
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
> +	: : "r" (value), "r" (ptr) : "memory");					\
> +} while (0)
> +
> +static void pagefault_trap_handler(struct pt_regs *regs)
> +{
> +	if (READ_ONCE(clear_sdt))
> +		local_dlbtrp_disable();
> +
> +	if (READ_ONCE(double_trap)) {
> +		WRITE_ONCE(double_trap, false);
> +		GEN_TRAP();
> +	}
> +
> +	/* Skip trapping instruction */
> +	regs->epc += 4;
> +
> +	local_dlbtrp_enable();
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
> +	WRITE_ONCE(sse_dbltrp_called, true);
> +
> +	/* Skip trapping instruction */
> +	regs->epc += 4;
> +}
> +
> +static int sse_double_trap(void)
> +{
> +	struct sbiret ret;
> +	int err = 0;
> +
> +	struct sbi_sse_handler_arg handler_arg = {
> +		.handler = sse_dbltrp_handler,
> +		.stack = alloc_page() + PAGE_SIZE,
> +	};
> +
> +	report_prefix_push("sse");
> +
> +	ret = sbi_sse_hart_unmask();
> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart unmask ok")) {
> +		report_skip("Failed to unmask SSE events, skipping test");
> +		goto out_free_page;
> +	}
> +
> +	ret = sbi_sse_register(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, &handler_arg);
> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> +		report_skip("SSE double trap event is not supported");
> +		goto out_mask_sse;
> +	}
> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap register");
> +
> +	ret = sbi_sse_enable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap enable")) {
> +		err = ret.error;

I'm not sure we need to return an error for this case. We won't be leaving
an SSE event handler registered.

> +		goto out_unregister;
> +	}
> +
> +	/*
> +	 * Generate a double crash so that an SSE event should be generated. The SPEC (ISA nor SBI)
> +	 * does not explicitly tell that if supported it should generate an SSE event but that's
> +	 * a reasonable assumption to do so if both FWFT and SSE are supported.
> +	 */
> +	WRITE_ONCE(clear_sdt, false);
> +	WRITE_ONCE(double_trap, true);
> +	GEN_TRAP();
> +
> +	report(READ_ONCE(sse_dbltrp_called), "SSE double trap event generated");
> +
> +	ret = sbi_sse_disable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap disable");
> +
> +out_unregister:
> +	ret = sbi_sse_unregister(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap unregister");

Needs to be

 if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap unregister"))
    err = ret.error;

> +
> +out_mask_sse:
> +	sbi_sse_hart_mask();
> +
> +out_free_page:
> +	free_page(handler_arg.stack - PAGE_SIZE);
> +	report_prefix_pop();
> +
> +	return err;
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
> +	install_exception_handler(EXC_STORE_PAGE_FAULT, pagefault_trap_handler);
> +
> +	WRITE_ONCE(clear_sdt, true);
> +	WRITE_ONCE(double_trap, true);
> +	GEN_TRAP();
> +	report_pass("Double trap disabled, trap first time ok");
> +
> +	/* Enable double trap */
> +	ret = sbi_fwft_set(SBI_FWFT_DOUBLE_TRAP, 1, 0);
> +	sbiret_report_error(&ret, SBI_SUCCESS, "Set double trap enable feature value == 1");
> +	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
> +	if (!sbiret_report(&ret, SBI_SUCCESS, 1, "Get double trap enable feature value == 1"))
> +		return;
> +
> +	/* First time, clear the double trap flag (SDT) so that it doesn't generate a double trap */
> +	WRITE_ONCE(clear_sdt, true);
> +	WRITE_ONCE(double_trap, true);
> +
> +	GEN_TRAP();
> +	report_pass("Trapped twice allowed ok");
> +
> +	if (sbi_probe(SBI_EXT_SSE)) {
> +		if (sse_double_trap()) {
> +			report_skip("Could not correctly unregister SSE event, skipping last test");
> +			return;
> +		}
> +	} else {
> +		report_skip("SSE double trap event will not be tested, extension is not available");

Missing return

> +	}

How about rearranging as

 if (!sbi_probe(SBI_EXT_SSE)) {
    report_skip("SSE double trap event will not be tested, extension is not available");
    return;
 }
 if (sse_double_trap()) {
    report_skip("Could not correctly unregister SSE event, skipping last test");
    return;
 }

> +
> +	if (!env_or_skip("DOUBLE_TRAP_TEST_CRASH"))
> +		return;
> +
> +	/*
> +	 * Third time, keep the double trap flag (SDT) and generate another trap, this should
> +	 * generate a double trap. Since there is no SSE handler registered, it should crash to
> +	 * M-mode.
> +	 */
> +	WRITE_ONCE(clear_sdt, false);
> +	WRITE_ONCE(double_trap, true);
> +	report_info("Should generate a double trap and crash!");
> +	GEN_TRAP();
> +	report_fail("Should have crashed!");
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
> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> +		report_skip("SBI_FWFT_DOUBLE_TRAP is not supported!");
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
> index 2eb760ec..286e1cc7 100644
> --- a/riscv/unittests.cfg
> +++ b/riscv/unittests.cfg
> @@ -18,3 +18,7 @@ groups = selftest
>  file = sbi.flat
>  smp = $MAX_SMP
>  groups = sbi
> +
> +[dbltrp]
> +file = isa-dbltrp.flat
> +groups = isa sbi
> -- 
> 2.49.0
>

Thanks,
drew

