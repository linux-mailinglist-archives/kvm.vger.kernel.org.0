Return-Path: <kvm+bounces-50386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 522B9AE4B03
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 070C14416E7
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BAD8266EE7;
	Mon, 23 Jun 2025 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HpZ3RjBM"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946751ADFFB
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 16:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750696175; cv=none; b=JCrYtzMrUnhO9nSVFxhf7nc8My2vQ3Szi0ER/b/LhT5m02UcOqaLYZ7umyp6oV8xG2dScyKOflbJF8iRwAceJ2eMh84cz4dkizxWyJa/fDJSj903Em/H/pdI38iT95bvzheyjK0xV3GixbLhAiCNB2fLwQep3jwOEd7SPmhcnk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750696175; c=relaxed/simple;
	bh=xd4mZWiHCQ3XWVdO9nJmnv5nmSLtgHNiisGJZYWc2Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alYW/hf1OgeG1O/8JGHEb2mdoMhi0TN1A8KjJi8auGGEIdmaisdydPpdpEOSNBpcRgMa77N4jZqDb+mcRIUNbX/Jt2q/RPtGL5Ba3oXphDOb6kcISOMvWLyuI6ZRcJ/n4jhsOnwLUvNsZh6cl56tfoUacKrfOWIoLc7Rt2H/vEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HpZ3RjBM; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 23 Jun 2025 18:29:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750696167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7nD68AZ9bBeskPuhwyqlzdxDvnk/wliv4c8riomEwQ=;
	b=HpZ3RjBMraQ0SuWRyrgkcI+mCAMDhgXGKXjmhouq/7gl1D4AIklCH9AP4VKZVzMR0Hib+Q
	wUVyE/SYDZFNMtHJVWpJfOfp52XmsAEzx/l5JGwxRSLaMTUDt2EaSmhW8oxloBkINLvVhX
	N2Cq/jgDDOC+UeM29Bh92+ctmwX1JPI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [kvm-unit-tests v3 2/2] riscv: Add ISA double trap extension
 testing
Message-ID: <20250623-0f0c86d875c2701f3a17d87b@orel>
References: <20250616115900.957266-1-cleger@rivosinc.com>
 <20250616115900.957266-3-cleger@rivosinc.com>
 <73e94306-91e4-4fd3-bc43-79872efc1b52@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73e94306-91e4-4fd3-bc43-79872efc1b52@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 19, 2025 at 09:59:47AM +0200, Clément Léger wrote:
> 
> 
> On 16/06/2025 13:59, Clément Léger wrote:
> > This test allows to test the double trap implementation of hardware as
> > well as the SBI FWFT and SSE support for double trap. The tests will try
> > to trigger double trap using various sequences and will test to receive
> > the SSE double trap event if supported.
> > 
> > It is provided as a separate test from the SBI one for two reasons:
> > - It isn't specifically testing SBI "per se".
> > - It ends up by trying to crash into in M-mode.
> > 
> > Currently, the test uses a page fault to raise a trap programatically.
> > Some concern was raised by a github user on the original branch [1]
> > saying that the spec doesn't mandate any trap to be delegatable and that
> > we would need a way to detect which ones are delegatable. I think we can
> > safely assume that PAGE FAULT is delegatable and if a hardware that does
> > not have support comes up then it will probably be the vendor
> > responsibility to provide a way to do so.
> > 
> > Link: https://github.com/clementleger/kvm-unit-tests/issues/1 [1]
> > Signed-off-by: Clément Léger <cleger@rivosinc.com>
> > ---
> >  riscv/Makefile            |   1 +
> >  lib/riscv/asm/csr.h       |   1 +
> >  lib/riscv/asm/processor.h |  10 ++
> >  riscv/isa-dbltrp.c        | 210 ++++++++++++++++++++++++++++++++++++++
> >  riscv/unittests.cfg       |   4 +
> >  5 files changed, 226 insertions(+)
> >  create mode 100644 riscv/isa-dbltrp.c
> > 
> > diff --git a/riscv/Makefile b/riscv/Makefile
> > index 11e68eae..d71c9d2e 100644
> > --- a/riscv/Makefile
> > +++ b/riscv/Makefile
> > @@ -14,6 +14,7 @@ tests =
> >  tests += $(TEST_DIR)/sbi.$(exe)
> >  tests += $(TEST_DIR)/selftest.$(exe)
> >  tests += $(TEST_DIR)/sieve.$(exe)
> > +tests += $(TEST_DIR)/isa-dbltrp.$(exe)
> >  
> >  all: $(tests)
> >  
> > diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> > index 3e4b5fca..6a8e0578 100644
> > --- a/lib/riscv/asm/csr.h
> > +++ b/lib/riscv/asm/csr.h
> > @@ -18,6 +18,7 @@
> >  
> >  #define SR_SIE			_AC(0x00000002, UL)
> >  #define SR_SPP			_AC(0x00000100, UL)
> > +#define SR_SDT			_AC(0x01000000, UL) /* Supervisor Double Trap */
> >  
> >  /* Exception cause high bit - is an interrupt if set */
> >  #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
> > diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
> > index 631ce226..a3dab064 100644
> > --- a/lib/riscv/asm/processor.h
> > +++ b/lib/riscv/asm/processor.h
> > @@ -50,6 +50,16 @@ static inline void ipi_ack(void)
> >  	csr_clear(CSR_SIP, IE_SSIE);
> >  }
> >  
> > +static inline void local_dlbtrp_enable(void)
> > +{
> > +	csr_set(CSR_SSTATUS, SR_SDT);
> > +}
> > +
> > +static inline void local_dlbtrp_disable(void)
> > +{
> > +	csr_clear(CSR_SSTATUS, SR_SDT);
> > +}
> > +
> >  void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *));
> >  void install_irq_handler(unsigned long cause, void (*handler)(struct pt_regs *));
> >  void do_handle_exception(struct pt_regs *regs);
> > diff --git a/riscv/isa-dbltrp.c b/riscv/isa-dbltrp.c
> > new file mode 100644
> > index 00000000..dcfa66da
> > --- /dev/null
> > +++ b/riscv/isa-dbltrp.c
> > @@ -0,0 +1,210 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * SBI verification
> > + *
> > + * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
> > + */
> > +#include <alloc.h>
> > +#include <alloc_page.h>
> > +#include <libcflat.h>
> > +#include <stdlib.h>
> > +
> > +#include <asm/csr.h>
> > +#include <asm/page.h>
> > +#include <asm/processor.h>
> > +#include <asm/ptrace.h>
> > +#include <asm/sbi.h>
> > +
> > +#include <sbi-tests.h>
> > +
> > +static bool double_trap;
> > +static bool clear_sdt;
> > +
> > +#define INSN_LEN(insn)			((((insn) & 0x3) < 0x3) ? 2 : 4)
> 
> This macro should be removed since it was merged in another file.

Actually it should be removed since it's unused. If it was used, then we'd
need to rename the callsites since we call it RV_INSN_LEN.

I've removed it while applying to riscv/sbi.

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

