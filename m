Return-Path: <kvm+bounces-32369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 063F09D6219
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 17:22:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 646EF161619
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 16:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592201DF976;
	Fri, 22 Nov 2024 16:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o3PC6nd/"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB1C1DED76
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 16:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292425; cv=none; b=FRgmOjcKRtxhg2NbgYOgA9r/vfai8vdzfMo2Dk3LI7r8h/ShUo96NYEiiuh0oWib9/OR+ZPxMmw7CVZbjgpx2EQupEe0Jrq0EsSEohOeahqXo9xqazsa7vRomZjqBRHMGYdSC7TpvB7gphtY+kMn0NwTi5hVNm40cqS+czLhpQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292425; c=relaxed/simple;
	bh=tZJxMgrbJCOACCTHUhJ8qtcE7SUU81eHofJm85kOh1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXDlQoQe+2UbJ9O+Yh/Jk3DaETkU7gAh1AcBpiVxKoSHGtZvLkBNkGdqSH+ISqU55Gx76uWv+ny0Jc5Ss236lclrtJyy+w6rfGXfR7wm4/KcqBxutwKsLJWph1INZui/5hDTdv1+IXcv2HMoIVCwLLimjv6JXjogErVkkAAAa8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o3PC6nd/; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 22 Nov 2024 17:20:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732292419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVqejpoB+npTVQN5KyHZxRLpCHhvW+3cyH8GXQo8Zx4=;
	b=o3PC6nd/xsxECWscM6vUECYOzPsk9ehDVvBg0CWLZX8ii5UvI0Dy5SqioGTA/IE3Rb/9gK
	me92DbSOcGW41TXHPMlxm4ZfnFAA2aBSnxWIlY4v2RLDi+r0EyDCFArG9Fxb3SVcir95ph
	W0wH1HYEMZKHcCY6FFZMmyoedb8myN0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/3] riscv: lib: Add SSE assembly entry
 handling
Message-ID: <20241122-a7e54373559727e1e296b8c4@orel>
References: <20241122140459.566306-1-cleger@rivosinc.com>
 <20241122140459.566306-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241122140459.566306-3-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 22, 2024 at 03:04:56PM +0100, Clément Léger wrote:
> Add a SSE entry assembly code to handle SSE events. Events should be
> registered with a struct sse_handler_arg containing a correct stack and
> handler function.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile          |   1 +
>  lib/riscv/asm/sse.h     |  16 +++++++
>  lib/riscv/sse-entry.S   | 100 ++++++++++++++++++++++++++++++++++++++++

Let's just add the entry function to riscv/sbi-asm.S and the
sse_handler_arg struct definition to riscv/sbi-tests.h

>  lib/riscv/asm-offsets.c |   9 ++++
>  4 files changed, 126 insertions(+)
>  create mode 100644 lib/riscv/asm/sse.h
>  create mode 100644 lib/riscv/sse-entry.S
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 28b04156..e50621ad 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -39,6 +39,7 @@ cflatobjs += lib/riscv/sbi.o
>  cflatobjs += lib/riscv/setjmp.o
>  cflatobjs += lib/riscv/setup.o
>  cflatobjs += lib/riscv/smp.o
> +cflatobjs += lib/riscv/sse-entry.o
>  cflatobjs += lib/riscv/stack.o
>  cflatobjs += lib/riscv/timer.o
>  ifeq ($(ARCH),riscv32)
> diff --git a/lib/riscv/asm/sse.h b/lib/riscv/asm/sse.h
> new file mode 100644
> index 00000000..557f6680
> --- /dev/null
> +++ b/lib/riscv/asm/sse.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_SSE_H_
> +#define _ASMRISCV_SSE_H_
> +
> +typedef void (*sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
> +
> +struct sse_handler_arg {
> +	unsigned long reg_tmp;
> +	sse_handler_fn handler;
> +	void *handler_data;
> +	void *stack;
> +};
> +
> +extern void sse_entry(void);
> +
> +#endif /* _ASMRISCV_SSE_H_ */
> diff --git a/lib/riscv/sse-entry.S b/lib/riscv/sse-entry.S
> new file mode 100644
> index 00000000..bedc47e9
> --- /dev/null
> +++ b/lib/riscv/sse-entry.S
> @@ -0,0 +1,100 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * SBI SSE entry code
> + *
> + * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
> + */
> +#include <asm/asm.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/csr.h>
> +
> +.global sse_entry
> +sse_entry:
> +	/* Save stack temporarily */
> +	REG_S sp, SSE_REG_TMP(a6)
> +	/* Set entry stack */
> +	REG_L sp, SSE_HANDLER_STACK(a6)
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
> +	REG_L a0, SSE_REG_TMP(a6)
> +	REG_S a0, PT_SP(sp)
> +
> +	REG_L t0, SSE_HANDLER(a6)
> +	REG_L a0, SSE_HANDLER_DATA(a6)
> +	move a1, sp
> +	move a2, a7

nit: prefer 'mv'

> +	jalr t0
> +
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
> diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
> index 6c511c14..b3465eeb 100644
> --- a/lib/riscv/asm-offsets.c
> +++ b/lib/riscv/asm-offsets.c
> @@ -3,7 +3,9 @@
>  #include <elf.h>
>  #include <asm/processor.h>
>  #include <asm/ptrace.h>
> +#include <asm/sbi.h>
>  #include <asm/smp.h>
> +#include <asm/sse.h>
>  
>  int main(void)
>  {
> @@ -63,5 +65,12 @@ int main(void)
>  	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
>  	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
>  
> +	OFFSET(SSE_REG_TMP, sse_handler_arg, reg_tmp);
> +	OFFSET(SSE_HANDLER, sse_handler_arg, handler);
> +	OFFSET(SSE_HANDLER_DATA, sse_handler_arg, handler_data);
> +	OFFSET(SSE_HANDLER_STACK, sse_handler_arg, stack);
> +	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
> +	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);

sbi_hsm_check just uses the numbers and adds comments. We could instead
move the extension IDs from an enum to defines outside the
#ifndef __ASSEMBLY__ and function IDs can also be defines accessible
by assembly.

> +
>  	return 0;
>  }
> -- 
> 2.45.2
>

Thanks,
drew

