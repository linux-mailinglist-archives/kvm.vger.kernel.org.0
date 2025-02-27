Return-Path: <kvm+bounces-39600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 106BDA48459
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B6EB3B8947
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73B91B0421;
	Thu, 27 Feb 2025 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cSCpcjeG"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9A34EB38
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 16:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740672205; cv=none; b=hMSigRgsUsQtaQ99AtI/T/QBWKKiZHl8fIrZd2P0V5I3bwkZIs1O/ZpnJMso3EPHBHZWE8o0C6D7s+wMb4AOym5KCMvdk/Q7NGnZNNAByp1VGSno+gVB0+TiUD9vAgjp6dOasGWoJUwblUNtRuPiPRRh5mccSm4uh0zQ7EekdHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740672205; c=relaxed/simple;
	bh=DmAfziIoD0YPBcP8wc0sf66nFT3rx9Ef8YwTi6meTW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4dt4Ct6fi+PnlmxWar9K7V/tNqB+B01rnhUinZNww2EXEBk/8y90+di1LuBMQ5IrWUouunx2cC7qG7c4kCESWMmJf/dpvi2HxwLQWnPwYJx/zB1kZmqLKlbf52cnDhZ6FrjH22zmXKc/yjGTFsHVfHy82W+ekWsChMKyynf//U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cSCpcjeG; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 27 Feb 2025 17:03:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740672198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l1+AyCQLv7cOOfW4ZiocHyOBtFJdcnQChne7Uogxj4M=;
	b=cSCpcjeGZ6hyO+N6SagobjMbIs26+2uo+GpGa2OqeSIE/eHFsNnx+WckF7peeN7YWKBxnu
	tJrmJ+8l5UPRP9ZW4T7PrV6/bkKa3MOgRPmIolhDSF4RxVI78SpYgmskoMDkzDLbXAaZjy
	Y14xSAW0arswlb0iBJtSFz8D22xg1r0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v7 5/6] lib: riscv: Add SBI SSE support
Message-ID: <20250227-a28f41972a73e8269d26b461@orel>
References: <20250214114423.1071621-1-cleger@rivosinc.com>
 <20250214114423.1071621-6-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250214114423.1071621-6-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 14, 2025 at 12:44:18PM +0100, Clément Léger wrote:
> Add support for registering and handling SSE events. This will be used
> by sbi test as well as upcoming double trap tests.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile          |   2 +
>  lib/riscv/asm/csr.h     |   1 +
>  lib/riscv/asm/sbi-sse.h |  48 +++++++++++++++++++
>  lib/riscv/sbi-sse-asm.S | 103 ++++++++++++++++++++++++++++++++++++++++
>  lib/riscv/asm-offsets.c |   9 ++++
>  lib/riscv/sbi-sse.c     |  84 ++++++++++++++++++++++++++++++++
>  6 files changed, 247 insertions(+)
>  create mode 100644 lib/riscv/asm/sbi-sse.h
>  create mode 100644 lib/riscv/sbi-sse-asm.S
>  create mode 100644 lib/riscv/sbi-sse.c
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 02d2ac39..ed590ede 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -43,6 +43,8 @@ cflatobjs += lib/riscv/setup.o
>  cflatobjs += lib/riscv/smp.o
>  cflatobjs += lib/riscv/stack.o
>  cflatobjs += lib/riscv/timer.o
> +cflatobjs += lib/riscv/sbi-sse-asm.o
> +cflatobjs += lib/riscv/sbi-sse.o
>  ifeq ($(ARCH),riscv32)
>  cflatobjs += lib/ldiv32.o
>  endif
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index 16f5ddd7..389d9850 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -17,6 +17,7 @@
>  #define CSR_TIME		0xc01
>  
>  #define SR_SIE			_AC(0x00000002, UL)
> +#define SR_SPP			_AC(0x00000100, UL)
>  
>  /* Exception cause high bit - is an interrupt if set */
>  #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
> diff --git a/lib/riscv/asm/sbi-sse.h b/lib/riscv/asm/sbi-sse.h
> new file mode 100644
> index 00000000..ba18ce27
> --- /dev/null
> +++ b/lib/riscv/asm/sbi-sse.h
> @@ -0,0 +1,48 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * SBI SSE library interface
> + *
> + * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
> + */
> +#ifndef _RISCV_SSE_H_
> +#define _RISCV_SSE_H_
> +
> +#include <asm/sbi.h>
> +
> +typedef void (*sbi_sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
> +
> +struct sbi_sse_handler_arg {
> +	unsigned long reg_tmp;
> +	sbi_sse_handler_fn handler;
> +	void *handler_data;
> +	void *stack;
> +};
> +
> +extern void sbi_sse_entry(void);
> +
> +static inline bool sbi_sse_event_is_global(uint32_t event_id)
> +{
> +	return !!(event_id & SBI_SSE_EVENT_GLOBAL_BIT);
> +}
> +
> +struct sbiret sbi_sse_read_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
> +				     unsigned long attr_count, unsigned long phys_lo,
> +				     unsigned long phys_hi);
> +struct sbiret sbi_sse_read_attrs(unsigned long event_id, unsigned long base_attr_id,
> +				 unsigned long attr_count, unsigned long *values);
> +struct sbiret sbi_sse_write_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
> +				      unsigned long attr_count, unsigned long phys_lo,
> +				      unsigned long phys_hi);
> +struct sbiret sbi_sse_write_attrs(unsigned long event_id, unsigned long base_attr_id,
> +				  unsigned long attr_count, unsigned long *values);
> +struct sbiret sbi_sse_register_raw(unsigned long event_id, unsigned long entry_pc,
> +				   unsigned long entry_arg);
> +struct sbiret sbi_sse_register(unsigned long event_id, struct sbi_sse_handler_arg *arg);
> +struct sbiret sbi_sse_unregister(unsigned long event_id);
> +struct sbiret sbi_sse_enable(unsigned long event_id);
> +struct sbiret sbi_sse_hart_mask(void);
> +struct sbiret sbi_sse_hart_unmask(void);
> +struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id);
> +struct sbiret sbi_sse_disable(unsigned long event_id);

nit: I'd put disable up by enable to keep pairs together.

> +
> +#endif /* !_RISCV_SSE_H_ */
> diff --git a/lib/riscv/sbi-sse-asm.S b/lib/riscv/sbi-sse-asm.S
> new file mode 100644
> index 00000000..5f60b839
> --- /dev/null
> +++ b/lib/riscv/sbi-sse-asm.S
> @@ -0,0 +1,103 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * RISC-V SSE events entry point.
> + *
> + * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
> + */
> +#define __ASSEMBLY__
> +#include <asm/asm.h>
> +#include <asm/csr.h>
> +#include <asm/asm-offsets.h>

nit: asm-offsets above csr if we want to practice alphabetical ordering.

> +#include <generated/sbi-asm-offsets.h>
> +
> +.section .text
> +.global sbi_sse_entry
> +sbi_sse_entry:
> +	/* Save stack temporarily */
> +	REG_S sp, SBI_SSE_REG_TMP(a7)
> +	/* Set entry stack */
> +	REG_L sp, SBI_SSE_HANDLER_STACK(a7)
> +
> +	addi sp, sp, -(PT_SIZE)
> +	REG_S ra, PT_RA(sp)
> +	REG_S s0, PT_S0(sp)
> +	REG_S s1, PT_S1(sp)
> +	REG_S s2, PT_S2(sp)
> +	REG_S s3, PT_S3(sp)
> +	REG_S s4, PT_S4(sp)
> +	REG_S s5, PT_S5(sp)
> +	REG_S s6, PT_S6(sp)
> +	REG_S s7, PT_S7(sp)
> +	REG_S s8, PT_S8(sp)
> +	REG_S s9, PT_S9(sp)
> +	REG_S s10, PT_S10(sp)
> +	REG_S s11, PT_S11(sp)
> +	REG_S tp, PT_TP(sp)
> +	REG_S t0, PT_T0(sp)
> +	REG_S t1, PT_T1(sp)
> +	REG_S t2, PT_T2(sp)
> +	REG_S t3, PT_T3(sp)
> +	REG_S t4, PT_T4(sp)
> +	REG_S t5, PT_T5(sp)
> +	REG_S t6, PT_T6(sp)
> +	REG_S gp, PT_GP(sp)
> +	REG_S a0, PT_A0(sp)
> +	REG_S a1, PT_A1(sp)
> +	REG_S a2, PT_A2(sp)
> +	REG_S a3, PT_A3(sp)
> +	REG_S a4, PT_A4(sp)
> +	REG_S a5, PT_A5(sp)
> +	csrr a1, CSR_SEPC
> +	REG_S a1, PT_EPC(sp)
> +	csrr a2, CSR_SSTATUS
> +	REG_S a2, PT_STATUS(sp)
> +
> +	REG_L a0, SBI_SSE_REG_TMP(a7)
> +	REG_S a0, PT_SP(sp)
> +
> +	REG_L t0, SBI_SSE_HANDLER(a7)
> +	REG_L a0, SBI_SSE_HANDLER_DATA(a7)
> +	mv a1, sp
> +	mv a2, a6
> +	jalr t0
> +
> +	REG_L a1, PT_EPC(sp)
> +	REG_L a2, PT_STATUS(sp)
> +	csrw CSR_SEPC, a1
> +	csrw CSR_SSTATUS, a2
> +
> +	REG_L ra, PT_RA(sp)
> +	REG_L s0, PT_S0(sp)
> +	REG_L s1, PT_S1(sp)
> +	REG_L s2, PT_S2(sp)
> +	REG_L s3, PT_S3(sp)
> +	REG_L s4, PT_S4(sp)
> +	REG_L s5, PT_S5(sp)
> +	REG_L s6, PT_S6(sp)
> +	REG_L s7, PT_S7(sp)
> +	REG_L s8, PT_S8(sp)
> +	REG_L s9, PT_S9(sp)
> +	REG_L s10, PT_S10(sp)
> +	REG_L s11, PT_S11(sp)
> +	REG_L tp, PT_TP(sp)
> +	REG_L t0, PT_T0(sp)
> +	REG_L t1, PT_T1(sp)
> +	REG_L t2, PT_T2(sp)
> +	REG_L t3, PT_T3(sp)
> +	REG_L t4, PT_T4(sp)
> +	REG_L t5, PT_T5(sp)
> +	REG_L t6, PT_T6(sp)
> +	REG_L gp, PT_GP(sp)
> +	REG_L a0, PT_A0(sp)
> +	REG_L a1, PT_A1(sp)
> +	REG_L a2, PT_A2(sp)
> +	REG_L a3, PT_A3(sp)
> +	REG_L a4, PT_A4(sp)
> +	REG_L a5, PT_A5(sp)
> +
> +	REG_L sp, PT_SP(sp)
> +
> +	li a7, ASM_SBI_EXT_SSE
> +	li a6, ASM_SBI_EXT_SSE_COMPLETE
> +	ecall

nit: Format asm with a tab after the operator like save/restore_context do.

> +
> diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
> index 6c511c14..77e5d26d 100644
> --- a/lib/riscv/asm-offsets.c
> +++ b/lib/riscv/asm-offsets.c
> @@ -4,6 +4,7 @@
>  #include <asm/processor.h>
>  #include <asm/ptrace.h>
>  #include <asm/smp.h>
> +#include <asm/sbi-sse.h>

nit: alphabetize

>  
>  int main(void)
>  {
> @@ -63,5 +64,13 @@ int main(void)
>  	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
>  	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
>  
> +	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
> +	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
> +
> +	OFFSET(SBI_SSE_REG_TMP, sbi_sse_handler_arg, reg_tmp);
> +	OFFSET(SBI_SSE_HANDLER, sbi_sse_handler_arg, handler);
> +	OFFSET(SBI_SSE_HANDLER_DATA, sbi_sse_handler_arg, handler_data);
> +	OFFSET(SBI_SSE_HANDLER_STACK, sbi_sse_handler_arg, stack);
> +
>  	return 0;
>  }
> diff --git a/lib/riscv/sbi-sse.c b/lib/riscv/sbi-sse.c
> new file mode 100644
> index 00000000..bc4dd10e
> --- /dev/null
> +++ b/lib/riscv/sbi-sse.c

I think we could just put these wrappers in lib/riscv/sbi.c, but OK.

> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * SBI SSE library
> + *
> + * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
> + */
> +#include <asm/sbi.h>
> +#include <asm/sbi-sse.h>
> +#include <asm/io.h>

nit: alphabetize

> +
> +struct sbiret sbi_sse_read_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
> +				     unsigned long attr_count, unsigned long phys_lo,
> +				     unsigned long phys_hi)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_READ_ATTRS, event_id, base_attr_id, attr_count,
> +			 phys_lo, phys_hi, 0);
> +}
> +
> +struct sbiret sbi_sse_read_attrs(unsigned long event_id, unsigned long base_attr_id,
> +				 unsigned long attr_count, unsigned long *values)
> +{
> +	phys_addr_t p = virt_to_phys(values);
> +
> +	return sbi_sse_read_attrs_raw(event_id, base_attr_id, attr_count, lower_32_bits(p),
> +				      upper_32_bits(p));
> +}
> +
> +struct sbiret sbi_sse_write_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
> +				      unsigned long attr_count, unsigned long phys_lo,
> +				      unsigned long phys_hi)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_WRITE_ATTRS, event_id, base_attr_id, attr_count,
> +			 phys_lo, phys_hi, 0);
> +}
> +
> +struct sbiret sbi_sse_write_attrs(unsigned long event_id, unsigned long base_attr_id,
> +				  unsigned long attr_count, unsigned long *values)
> +{
> +	phys_addr_t p = virt_to_phys(values);
> +
> +	return sbi_sse_write_attrs_raw(event_id, base_attr_id, attr_count, lower_32_bits(p),
> +				       upper_32_bits(p));
> +}
> +
> +struct sbiret sbi_sse_register_raw(unsigned long event_id, unsigned long entry_pc,
> +				   unsigned long entry_arg)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, entry_pc, entry_arg, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_register(unsigned long event_id, struct sbi_sse_handler_arg *arg)
> +{

 phys_addr_t entry = virt_to_phys(sbi_sse_entry);
 phys_addr_t arg = virt_to_phys(arg);

 assert(__riscv_xlen > 32 || upper_32_bits(entry) == 0);
 assert(__riscv_xlen > 32 || upper_32_bits(arg) == 0);

 return sbi_sse_register_raw(event_id, entry, arg);

> +	return sbi_sse_register_raw(event_id, virt_to_phys(sbi_sse_entry), virt_to_phys(arg));
> +}
> +
> +struct sbiret sbi_sse_unregister(unsigned long event_id)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_UNREGISTER, event_id, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_enable(unsigned long event_id)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_ENABLE, event_id, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_disable(unsigned long event_id)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_DISABLE, event_id, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_hart_mask(void)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_MASK, 0, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_hart_unmask(void)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_UNMASK, 0, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_id, 0, 0, 0, 0);
> +}
> -- 
> 2.47.2
>

Besides the nits and the sanity checking for rv32,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

