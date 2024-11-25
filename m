Return-Path: <kvm+bounces-32411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3364A9D82B0
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 10:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED6922818D6
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 09:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6464191499;
	Mon, 25 Nov 2024 09:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xJ1tUg5r"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480BF18FC9D
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 09:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732527667; cv=none; b=oN+oKxwEwdZ2U2ZgGKIG1SKx76GT9mw178n/FNP+gs7iBxqKcSdTRA14DccOrGr5Q3L0aP3s7Lj+4otqv1HoCccz0YkiVoX91tXASryidxwZb48tQmIXOVCLB6FmLxH0AEWyVENEHqhE0DMwMCOMU/diQCcutC+N4dXXX4n7EAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732527667; c=relaxed/simple;
	bh=AZI3dmQI9gVUrfaxLPLCTPq6sYdz9vjZWeHL4cKbk6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J391EYicBJ4srPg9drw0wT+42DvaH23jN8QuxyyTOvHqBfkz79ahvnGYsrGhCKJ2VIAc4BZe1E4Y6kLBFX+BpPzlG001tk90NP/7OSpwh2oOy7ic/fLDbgDV3Yx7P+YEvGkkXm2ttqdD1JzCWpkyYxxSuIAWnrfQyv628MWftm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xJ1tUg5r; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 25 Nov 2024 10:40:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732527661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7qvKf2xmUwIBQSSne8ZCdCNiu+azoxH3hUmoQJ5AbJc=;
	b=xJ1tUg5rf7qAK0X0fXUyQChYAvtxiBWr1qPo2CtB8gjDkcow6q6xs019sFx3VxDvhpkcAT
	Ue9U4Zilzvo7Gt1zWoted3QmEAFEmtxX2nmMSLxsGJYEsxfg9YWT8m+pOzWVbaVtQ9Q+Ea
	p41S6mHhxuq64uZ9sPqoqopn0bqfGqM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/3] riscv: sbi: Add SSE extension tests
Message-ID: <20241125-dd673eb2a354159e4a7829bc@orel>
References: <20241122140459.566306-1-cleger@rivosinc.com>
 <20241122140459.566306-4-cleger@rivosinc.com>
 <20241122-5e3fefbf68ba10f193470d6a@orel>
 <362ddf23-283c-43e8-bfff-00ff971e8501@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <362ddf23-283c-43e8-bfff-00ff971e8501@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 25, 2024 at 09:55:47AM +0100, Clément Léger wrote:
> 
> 
> On 22/11/2024 17:34, Andrew Jones wrote:
> > On Fri, Nov 22, 2024 at 03:04:57PM +0100, Clément Léger wrote:
> >> Add SBI SSE extension tests for the following features:
> >> - Test attributes errors (invalid values, RO, etc)
> >> - Registration errors
> >> - Simple events (register, enable, inject)
> >> - Events with different priorities
> >> - Global events dispatch on different harts
> >> - Local events on all harts
> >>
> >> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> >> ---
> >>  riscv/Makefile      |   1 +
> >>  lib/riscv/asm/csr.h |   2 +
> >>  riscv/sbi-tests.h   |   4 +
> >>  riscv/sbi-sse.c     | 981 ++++++++++++++++++++++++++++++++++++++++++++
> >>  riscv/sbi.c         |   1 +
> >>  riscv/unittests.cfg |   4 +
> >>  6 files changed, 993 insertions(+)
> >>  create mode 100644 riscv/sbi-sse.c
> >>
> >> diff --git a/riscv/Makefile b/riscv/Makefile
> >> index e50621ad..768e1c25 100644
> >> --- a/riscv/Makefile
> >> +++ b/riscv/Makefile
> >> @@ -46,6 +46,7 @@ ifeq ($(ARCH),riscv32)
> >>  cflatobjs += lib/ldiv32.o
> >>  endif
> >>  cflatobjs += riscv/sbi-asm.o
> >> +cflatobjs += riscv/sbi-sse.o
> > 
> > We should figure out how to only link these files into
> > riscv/sbi.{flat,efi}
> 
> Hey drew, thansk for the review.
> 
> I'll check if this is possible to do that yeah.
> 
> > 
> >>  
> >>  ########################################
> >>  
> >> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> >> index 16f5ddd7..06831380 100644
> >> --- a/lib/riscv/asm/csr.h
> >> +++ b/lib/riscv/asm/csr.h
> >> @@ -21,6 +21,8 @@
> >>  /* Exception cause high bit - is an interrupt if set */
> >>  #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
> >>  
> >> +#define SSTATUS_SPP		_AC(0x00000100, UL) /* Previously Supervisor */
> >> +
> >>  /* Exception causes */
> >>  #define EXC_INST_MISALIGNED	0
> >>  #define EXC_INST_ACCESS		1
> >> diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
> >> index ce129968..2115acc6 100644
> >> --- a/riscv/sbi-tests.h
> >> +++ b/riscv/sbi-tests.h
> >> @@ -33,4 +33,8 @@
> >>  #define SBI_SUSP_TEST_HARTID	(1 << 2)
> >>  #define SBI_SUSP_TEST_MASK	7
> >>  
> >> +#ifndef __ASSEMBLY__
> >> +void check_sse(void);
> > 
> > We can just put this in riscv/sbi.c
> 
> sbi.c is already almost 1500 lines long, adding SSE would make it a 2500
> lines files. IMHO, it would be nice to keep it separated to keep it
> clean. But if you really have a strong opinion to incorporate that in
> sbi.c, I'll do that.

I meant just this prototype, 'void check_sse(void);'

Thanks,
drew

