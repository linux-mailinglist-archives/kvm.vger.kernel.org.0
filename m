Return-Path: <kvm+bounces-51308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9696DAF5B97
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C822C4E76DD
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B37309DDD;
	Wed,  2 Jul 2025 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MbW21TvA"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9299528468C
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751467788; cv=none; b=l+YPTME0Nk5Rnpo1WYx5xq716ehKT4dDc6G/6tBKko0n8wHMbMVEuir+g0yAGpxxdKXuaompJS4PZfpwzcy3v7Llppose2//3wL62B/KtBmXzHU6mL51GgbQ8ARirtsoT6kz4hN7YwSGD20jMaSJGNDLU4WeYJBvi/HZMtcF+iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751467788; c=relaxed/simple;
	bh=cSMM1u/jGQKLurHL+HuiVlEvzFYNrHymQXLuVXi0j10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meW1Dh6HZ3P2mysm08/oc1511v3sc95yH7QzIAG9LOdfj2DzRGBtk/f/Sy/s5/SjnjDRF1fcxnjJX2WYCY/86w1/xHMAbGD77hw2IzGvc2mFnQ2ExZ+DLLKAcIlrjt9epS4U+7bQxc6ufe1SaPpCDyDOWSvGd+foeP9lzB5kAEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MbW21TvA; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 2 Jul 2025 16:49:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751467774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EXYF79yZaQma0ZGqr/10BsIiL9geDUWdZiWfA4/46sw=;
	b=MbW21TvA2RNaSkB2ILsAY0vgi/O13KpDuWgLfkDUAA5EAs9JCr5kiQJ1cpCmTz/eor/j9v
	ypqr3LPjiXI5uPi1ymlv07kd/gtOA9Z0yVhlbLYO/e1lh3vhNsmxYk0+zESWo/cK1iTddG
	/w+QIZCiYa+ITFo63LT2uKgoHx2qCI0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jesse Taube <jesse@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, Himanshu Chauhan <hchauhan@ventanamicro.com>, 
	Charlie Jenkins <charlie@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/2] riscv: Add RV_INSN_LEN to
 processor.h
Message-ID: <20250702-6b20245edf302791a48f98e1@orel>
References: <20250605161806.1206850-1-jesse@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605161806.1206850-1-jesse@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 05, 2025 at 09:18:05AM -0700, Jesse Taube wrote:
> When handeling traps and faults it is offten necessary to know the size
> of the instruction at epc. Add RV_INSN_LEN to calculate the
> instruction size.
> 
> Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> ---
>  lib/riscv/asm/processor.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
> index 40104272..631ce226 100644
> --- a/lib/riscv/asm/processor.h
> +++ b/lib/riscv/asm/processor.h
> @@ -7,6 +7,8 @@
>  #define EXCEPTION_CAUSE_MAX	24
>  #define INTERRUPT_CAUSE_MAX	16
>  
> +#define RV_INSN_LEN(insn)		((((insn) & 0x3) < 0x3) ? 2 : 4)
> +
>  typedef void (*exception_fn)(struct pt_regs *);
>  
>  struct thread_info {
> -- 
> 2.43.0

Merged. Thanks

