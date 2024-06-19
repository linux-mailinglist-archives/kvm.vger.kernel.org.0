Return-Path: <kvm+bounces-19946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCD3F90E605
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 10:39:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BBA9B20EF7
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1A17D3F5;
	Wed, 19 Jun 2024 08:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bpG6Q8OR"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410B679952
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 08:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718786356; cv=none; b=COKNYrz1p2ptbVPjoVizqwArWoUjNsEpxFe8xEicmt+yyCvXb2alWdzMQjPp1cAdGJXvs2O5Hr5q2K5W5BRePlE/XvGv6CGgdW8YnsDUY58uNVLUI1DQ+hNvh0tw7FilXG4wVO5+BOh4G1KcrqCjWUn/Uy/eSCfLpGBV/vMKW0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718786356; c=relaxed/simple;
	bh=LryhlDSILRALTJjaAexiT8ERLeQX0NmxlxBlH+oLbbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOm2l3B12eHLch/XsVStCLYs8SNP/HqpjvgoP9yXWsjcmOWj7uk6r9W245LCwXfpASApMf6tGu7ZpWvdD/Z86rejOaB2vd77l/q7BNsjIazit/J/u1M/4ysIwHpOsYuRHN3F7yrhRNOxG+tjKFpYf0dRHZGhLfV8mNFkm+QGOt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bpG6Q8OR; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jamestiotio@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718786351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MvLXJXivXAvpMZPRU/vFz6SvKkSXQa1mHb+NWXJaJdc=;
	b=bpG6Q8ORpILBlhbdxRY5xFZvikARGnRbxu26//n9++ae4//wrLQ2vnTJMV8EyVI7ShIeX6
	qWN1CWPalVeJPO8KMxoKrkKSh+8djlyPZg6RdADwNvQdWMFKy44JZHMNbjT9Ed5pPGelgn
	uBF1mj09OxkKYRymP3AgeQ4VYXLwX38=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
Date: Wed, 19 Jun 2024 10:39:08 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH 3/4] riscv: Add methods to toggle
 interrupt enable bits
Message-ID: <20240619-3ba7acf7b1504529899f6cc9@orel>
References: <20240618173053.364776-1-jamestiotio@gmail.com>
 <20240618173053.364776-4-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618173053.364776-4-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 19, 2024 at 01:30:52AM GMT, James Raphael Tiovalen wrote:
> Add some helper methods to toggle the interrupt enable bits in the SIE
> register.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  riscv/Makefile            |  1 +
>  lib/riscv/asm/csr.h       |  7 +++++++
>  lib/riscv/asm/interrupt.h | 12 ++++++++++++
>  lib/riscv/interrupt.c     | 39 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 59 insertions(+)
>  create mode 100644 lib/riscv/asm/interrupt.h
>  create mode 100644 lib/riscv/interrupt.c
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 919a3ebb..108d4481 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -30,6 +30,7 @@ cflatobjs += lib/memregions.o
>  cflatobjs += lib/on-cpus.o
>  cflatobjs += lib/vmalloc.o
>  cflatobjs += lib/riscv/bitops.o
> +cflatobjs += lib/riscv/interrupt.o
>  cflatobjs += lib/riscv/io.o
>  cflatobjs += lib/riscv/isa.o
>  cflatobjs += lib/riscv/mmu.o
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index c1777744..da58b0ce 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -4,15 +4,22 @@
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
>  
>  #define SSTATUS_SIE		(_AC(1, UL) << 1)
>  
> +#define SIE_SSIE		(_AC(1, UL) << 1)
> +#define SIE_STIE		(_AC(1, UL) << 5)
> +#define SIE_SEIE		(_AC(1, UL) << 9)
> +#define SIE_LCOFIE		(_AC(1, UL) << 13)
> +
>  /* Exception cause high bit - is an interrupt if set */
>  #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
>  
> diff --git a/lib/riscv/asm/interrupt.h b/lib/riscv/asm/interrupt.h
> new file mode 100644
> index 00000000..b760afbb
> --- /dev/null
> +++ b/lib/riscv/asm/interrupt.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_INTERRUPT_H_
> +#define _ASMRISCV_INTERRUPT_H_
> +
> +#include <stdbool.h>
> +
> +void toggle_software_interrupt(bool enable);
> +void toggle_timer_interrupt(bool enable);
> +void toggle_external_interrupt(bool enable);
> +void toggle_local_cof_interrupt(bool enable);
> +
> +#endif /* _ASMRISCV_INTERRUPT_H_ */
> diff --git a/lib/riscv/interrupt.c b/lib/riscv/interrupt.c
> new file mode 100644
> index 00000000..bc0e16f1
> --- /dev/null
> +++ b/lib/riscv/interrupt.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
> + */
> +#include <libcflat.h>
> +#include <asm/csr.h>
> +#include <asm/interrupt.h>
> +
> +void toggle_software_interrupt(bool enable)
> +{
> +	if (enable)
> +		csr_set(CSR_SIE, SIE_SSIE);
> +	else
> +		csr_clear(CSR_SIE, SIE_SSIE);
> +}
> +
> +void toggle_timer_interrupt(bool enable)
> +{
> +	if (enable)
> +		csr_set(CSR_SIE, SIE_STIE);
> +	else
> +		csr_clear(CSR_SIE, SIE_STIE);
> +}
> +
> +void toggle_external_interrupt(bool enable)
> +{
> +	if (enable)
> +		csr_set(CSR_SIE, SIE_SEIE);
> +	else
> +		csr_clear(CSR_SIE, SIE_SEIE);
> +}
> +
> +void toggle_local_cof_interrupt(bool enable)
> +{
> +	if (enable)
> +		csr_set(CSR_SIE, SIE_LCOFIE);
> +	else
> +		csr_clear(CSR_SIE, SIE_LCOFIE);
> +}
> -- 
> 2.43.0
>

Most of this patch seems premature since the series only needs
toggle_timer_interrupt(). Also, I think lib/riscv/interrupt.c
is premature because something like toggle_timer_interrupt()
can be a static inline in a new lib/riscv/asm/timer.h file.

And please provide two functions rather than a toggle with
a parameter, i.e.

  timer_interrupt_enable() / timer_interrupt_disable()

Thanks,
drew

