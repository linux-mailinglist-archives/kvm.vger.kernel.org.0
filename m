Return-Path: <kvm+bounces-21664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 548C1931D3B
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FD182829EA
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 22:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA5213D63D;
	Mon, 15 Jul 2024 22:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bI99KrdT"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256351CA80
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 22:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083381; cv=none; b=YUKiu8AjLevUciN5TxgfsdQs6BqhN9wL2oyD7GEWoxtHlnpOX64Wy2sLOplapa0ZLJV4x7f2rdrMpMc/6ic9aqU1VPWK+MxmHzTX/AZF1zSH+Y+RGZb8nobwv4R+vTj9qna6pRr2Zmx0KEhFd+wnL3g0huOk8cAVCOklWqGKmeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083381; c=relaxed/simple;
	bh=AIgrZeW3RnJpO9CCs+YWKGhE4RsOt/oVfWE8wUgF4Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QzRcBJnd2BU4ygIPR0pyFibE/TZ+9u5ymB1OUmXtikTTosgp0fPZiKzZC5AQMMLBUK8aDYkIuv14nsZN1ZPuT7JL9gPE95KLqZ7XrhDT6BVOHEzGzzfClP2M3cRPHzGjpjt7yTzK8k0lX9/Gq9JgbivUTzAuujygrtC//w4fS54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bI99KrdT; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jamestiotio@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721083377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9ndCosX50XYYUHm4duAQZYGFiLMKKk8BtfgMWx0b8w=;
	b=bI99KrdTeJKwPNPzl2YP2TnEnDrnSns+lBFfFEsOs49PxUbwNuy1/k7nQ9Y9isdw9FG3I/
	iMXJjEto0A5Tj/9Z2kEpZ3D54drjXDr9NhpBRFFUA3xmjoPl9BMq1MlKUP6sqO5eUKs4WS
	Yb8KsnILmFT1QGY1OX+jR99vqJ7LPLY=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
Date: Mon, 15 Jul 2024 17:42:53 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v2 2/3] riscv: Update exception cause list
Message-ID: <20240715-f5383fa7245da0e0a5a03c2a@orel>
References: <20240707101053.74386-1-jamestiotio@gmail.com>
 <20240707101053.74386-3-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240707101053.74386-3-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jul 07, 2024 at 06:10:51PM GMT, James Raphael Tiovalen wrote:
> Update the list of exception and interrupt causes to follow the latest
> RISC-V privileged ISA specification (version 20240411 section 18.6.1).
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/csr.h       | 14 ++++++++++++++
>  lib/riscv/asm/processor.h |  2 +-
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index d6909d93..b3c48e8e 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -28,6 +28,7 @@
>  #define EXC_SYSCALL		8
>  #define EXC_HYPERVISOR_SYSCALL	9
>  #define EXC_SUPERVISOR_SYSCALL	10
> +#define EXC_MACHINE_SYSCALL	11
>  #define EXC_INST_PAGE_FAULT	12
>  #define EXC_LOAD_PAGE_FAULT	13
>  #define EXC_STORE_PAGE_FAULT	15
> @@ -36,6 +37,19 @@
>  #define EXC_VIRTUAL_INST_FAULT		22
>  #define EXC_STORE_GUEST_PAGE_FAULT	23
>  
> +/* Interrupt causes */
> +#define IRQ_S_SOFT		1
> +#define IRQ_VS_SOFT		2
> +#define IRQ_M_SOFT		3
> +#define IRQ_S_TIMER		5
> +#define IRQ_VS_TIMER		6
> +#define IRQ_M_TIMER		7
> +#define IRQ_S_EXT		9
> +#define IRQ_VS_EXT		10
> +#define IRQ_M_EXT		11
> +#define IRQ_S_GEXT		12
> +#define IRQ_PMU_OVF		13
> +

While it doesn't hurt to define them, we don't need the M-mode stuff,
since we don't intend to run in M-mode.

>  #ifndef __ASSEMBLY__
>  
>  #define csr_swap(csr, val)					\
> diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
> index 6451adb5..4c9ad968 100644
> --- a/lib/riscv/asm/processor.h
> +++ b/lib/riscv/asm/processor.h
> @@ -4,7 +4,7 @@
>  #include <asm/csr.h>
>  #include <asm/ptrace.h>
>  
> -#define EXCEPTION_CAUSE_MAX	16
> +#define EXCEPTION_CAUSE_MAX	24
>  #define INTERRUPT_CAUSE_MAX	16
>  
>  typedef void (*exception_fn)(struct pt_regs *);
> -- 
> 2.43.0
>

Otherwise,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

