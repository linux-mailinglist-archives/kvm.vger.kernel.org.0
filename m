Return-Path: <kvm+bounces-26960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E1D979BF1
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 09:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 689481F22D86
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 07:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07EEF12E1CA;
	Mon, 16 Sep 2024 07:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BB+JCo/z"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04D420B22
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 07:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726471164; cv=none; b=hmJr2/Mt29a9ja7TdUJ6ndF66LBwxWshGUHPJCYV2nCJ5GqkWvl2r77TutN6Yqb7FcXhArIpsL821X6lyt+1Ro3n3Hw7Y6kNUydIyWiJGYcUFfgn4V1SqARRNmdmQlj3ZqXbmC8o0AOY+uF3z2Nr6AC9iKfbly9WM0SWnU0os0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726471164; c=relaxed/simple;
	bh=AiuT2GVbgf/JaQpd2uk1kpOWwLsSoVCbq2mNltMd4c0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=geDK3PJcFeuXRcg80e4S6PIxXakgdWaOJpzuGWtENkAuuRMWmvUCbfmrqXSyUEwYNGmr8tIMmA2fo6ash/T3EZVJhjhuGYkbcoUFcXHfZI+SJJmarO/TJm9guNmyQS+uvL7j01+7vkkrOZa7jMin6AV5rPhPBY7ZkOi7YCQc6Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BB+JCo/z; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 16 Sep 2024 09:19:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726471158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XFMQE0C78fViBPaDapacxW93vJ112LrqDdN07T5XTgI=;
	b=BB+JCo/za9ULHNsmkLoqaDC2eGXLCxlcGn0UClkVOAtx2cipN/Wf8RvLqqq6kgIiuU7iL4
	6RbmNAqs9ZS/WltbfZvEQQ3AnM9JvxMT5AQwzv/7Zo+GeoPFBOFjCHblu3so2GaZE66SSR
	JOBXxc9gwxKpw3hKNsxX2xPqjCf1F+c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v4 1/3] riscv: Rewrite hartid_to_cpu in
 assembly
Message-ID: <20240916-68681cd03420e20e1628481b@orel>
References: <20240915183459.52476-1-jamestiotio@gmail.com>
 <20240915183459.52476-2-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240915183459.52476-2-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 16, 2024 at 02:34:57AM GMT, James Raphael Tiovalen wrote:
> From: Andrew Jones <andrew.jones@linux.dev>
> 
> Some SBI HSM tests run without a stack being setup so they can't
> run C code. Those tests still need to know the corresponding cpuid
> for the hartid on which they are running. Give those tests
> hartid_to_cpu() by reimplementing it in assembly.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

This should also include your sign-off since you're posting it and it's
for your series. Passing unmodified patches on that you're comfortable
passing on corresponds to (c) of [1]

[1] https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#developer-s-certificate-of-origin-1-1

> ---
>  lib/riscv/asm-offsets.c |  5 +++++
>  lib/riscv/setup.c       | 10 ----------
>  riscv/cstart.S          | 23 +++++++++++++++++++++++
>  3 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
> index a2a32438..6c511c14 100644
> --- a/lib/riscv/asm-offsets.c
> +++ b/lib/riscv/asm-offsets.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  #include <kbuild.h>
>  #include <elf.h>
> +#include <asm/processor.h>
>  #include <asm/ptrace.h>
>  #include <asm/smp.h>
>  
> @@ -58,5 +59,9 @@ int main(void)
>  	OFFSET(SECONDARY_FUNC, secondary_data, func);
>  	DEFINE(SECONDARY_DATA_SIZE, sizeof(struct secondary_data));
>  
> +	OFFSET(THREAD_INFO_CPU, thread_info, cpu);
> +	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
> +	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
> +
>  	return 0;
>  }
> diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
> index 495db041..f347ad63 100644
> --- a/lib/riscv/setup.c
> +++ b/lib/riscv/setup.c
> @@ -43,16 +43,6 @@ uint64_t timebase_frequency;
>  
>  static struct mem_region riscv_mem_regions[NR_MEM_REGIONS + 1];
>  
> -int hartid_to_cpu(unsigned long hartid)
> -{
> -	int cpu;
> -
> -	for_each_present_cpu(cpu)
> -		if (cpus[cpu].hartid == hartid)
> -			return cpu;
> -	return -1;
> -}
> -
>  static void cpu_set_fdt(int fdtnode __unused, u64 regval, void *info __unused)
>  {
>  	int cpu = nr_cpus++;
> diff --git a/riscv/cstart.S b/riscv/cstart.S
> index 8f269997..6784d5e1 100644
> --- a/riscv/cstart.S
> +++ b/riscv/cstart.S
> @@ -109,6 +109,29 @@ halt:
>  1:	wfi
>  	j	1b
>  
> +/*
> + * hartid_to_cpu
> + *   a0 is a hartid on entry
> + * returns the corresponding cpuid in a0

I should have capitalized the 'r' in 'returns' and also written
"or -1 if no thread-info struct with 'hartid' is found."

> + */
> +.balign 4
> +.global hartid_to_cpu
> +hartid_to_cpu:
> +	la	t0, cpus
> +	la	t1, nr_cpus
> +	lw	t1, 0(t1)
> +	li	t2, 0
> +1:	bne	t2, t1, 2f
> +	li	a0, -1
> +	ret
> +2:	REG_L	t3, THREAD_INFO_HARTID(t0)
> +	bne	a0, t3, 3f
> +	lw	a0, THREAD_INFO_CPU(t0)
> +	ret
> +3:	addi	t0, t0, THREAD_INFO_SIZE
> +	addi	t2, t2, 1
> +	j	1b
> +
>  .balign 4
>  .global secondary_entry
>  secondary_entry:
> -- 
> 2.43.0
>

I'll fixup the comment and add your sign-off when applying.

Thanks,
drew

