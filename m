Return-Path: <kvm+bounces-19941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D67290E583
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 10:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF9772830E2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2004F7E56B;
	Wed, 19 Jun 2024 08:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BJy67NmN"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797757B3EB
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 08:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718785866; cv=none; b=ZV63kl4pSDpXfDO1CAREDjph4NtZaLq85Mfr0LWfbyaA5PfQaMRNun9e8/M2Ub7ZZwNvomPy0wjKIet55jzVMsYSUk5/YeFTiXtRQ6T+xtfAV+PcMyQttWVxR2ebP+VoW9F01w7urb6KhTnQdoj+VMJYCJT4LeS1pYPJov46u8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718785866; c=relaxed/simple;
	bh=Jg/LhxDWgBow8xex4QEPFx4XAujKc07RBYSibT0BSmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljIQeYTjT7dycobb/AwEhzaYHU3t+VphmRW0wEiXwcKWwaEr/pfTDDVbRCPsWji+SSP+6GLL77jnw42OHogw47Ejq/P9aPbkDn8S/izx/RazNd32iGJ4d2UZ95FQgoUZxFvXcZQKNxwZ18G/q15H1ecj9/RJUNGlFWpZjRU2Gzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BJy67NmN; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jamestiotio@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718785859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0R2bWWd5V85nriXvhkkwm8qakajLHVJtklfbxwq77k=;
	b=BJy67NmNfMvH+JJ53Scb+1veXXykLh0eq6GIzOyrcYnMhCE0S9kLnyO9yOqx/zOAge/K/Z
	C2btTiufbgpMetCJYOBUldHEAxacYsenxyMDYPXo/gucFkVE5t/wdxD8lDxIcy34mcTkDw
	FIu4LGEurL1aFwy4vc+DNwkR3yQDAJU=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
Date: Wed, 19 Jun 2024 10:30:56 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH 2/4] riscv: Update exception cause list
Message-ID: <20240619-5747f9b7cf121c71889128a7@orel>
References: <20240618173053.364776-1-jamestiotio@gmail.com>
 <20240618173053.364776-3-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618173053.364776-3-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 19, 2024 at 01:30:51AM GMT, James Raphael Tiovalen wrote:
> Update the list of exception and interrupt causes to follow the latest
> RISC-V privileged ISA specification (version 20240411).
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/csr.h       | 15 +++++++++------
>  lib/riscv/asm/processor.h |  2 +-
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index d5879d2a..c1777744 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -26,15 +26,18 @@
>  #define EXC_STORE_MISALIGNED	6
>  #define EXC_STORE_ACCESS	7
>  #define EXC_SYSCALL		8
> -#define EXC_HYPERVISOR_SYSCALL	9
> -#define EXC_SUPERVISOR_SYSCALL	10
> +#define EXC_SUPERVISOR_SYSCALL	9
>  #define EXC_INST_PAGE_FAULT	12
>  #define EXC_LOAD_PAGE_FAULT	13
>  #define EXC_STORE_PAGE_FAULT	15
> -#define EXC_INST_GUEST_PAGE_FAULT	20
> -#define EXC_LOAD_GUEST_PAGE_FAULT	21
> -#define EXC_VIRTUAL_INST_FAULT		22
> -#define EXC_STORE_GUEST_PAGE_FAULT	23
> +#define EXC_SOFTWARE_CHECK	18
> +#define EXC_HARDWARE_ERROR	19

The above changes don't update the exception cause list to the latest
spec, they drop the defines supporting the hypervisor extension's
augmentations (see Section 18.6.1 of the 20240411 priv spec).

> +
> +/* Interrupt causes */
> +#define IRQ_SUPERVISOR_SOFTWARE	1
> +#define IRQ_SUPERVISOR_TIMER	5
> +#define IRQ_SUPERVISOR_EXTERNAL	9
> +#define IRQ_COUNTER_OVERFLOW	13

These are fine, but we could also add the defines for the hypervisor
extension's augmentations. I also usually just copy+paste the defines
from Linux since I prefer name consistency.

>  
>  #ifndef __ASSEMBLY__
>  
> diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
> index 767b1caa..5942ed2e 100644
> --- a/lib/riscv/asm/processor.h
> +++ b/lib/riscv/asm/processor.h
> @@ -4,7 +4,7 @@
>  #include <asm/csr.h>
>  #include <asm/ptrace.h>
>  
> -#define EXCEPTION_CAUSE_MAX	16
> +#define EXCEPTION_CAUSE_MAX	64

If we want to test the H extension, then we'll want 20-23, but everything
else is custom or reserved, so we don't need to allocate handler pointer
space all the way up to 64 as they'll never be used.

Thanks,
drew

>  #define INTERRUPT_CAUSE_MAX	16
>  
>  typedef void (*exception_fn)(struct pt_regs *);
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

