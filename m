Return-Path: <kvm+bounces-30876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B22459BE143
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D8A6B23127
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E151D619E;
	Wed,  6 Nov 2024 08:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="luX4rVb5"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C361C7FBAC
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882703; cv=none; b=obCPffwJpBd6fv+nffKTh8uc2zIcy/w/1TWAQWIS/TM3Al17YSqm7uSRdXKh7+MiRc5nQuvVrkF63jBFnzLsBualLoSmGA9g1s4sH2EpyZOlf7sorwdvNzT1S++m4XL+XocCtsuP7i1OVFdrhravFXRFhxi7GIpm9DO72apk6gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882703; c=relaxed/simple;
	bh=Rb6UWEWCLw2H3Wr3mIVy6SIXt1j/+znTejsaGsr1hVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOz4rdlJpKU5R5DzUbGNJbet9oDuBihLDz5g/cYEdBMq344fWFYWrITxWRQt0s6sM/OAAjLPbElz2aNpY3DWY6r7HPu41LLHO+lLf7uBvJO+pHp9vWZ7Mi47smr/e71+TPMS0owUfw3hgmDvS18vna9zGXLqQUWfL01Wb6c1eXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=luX4rVb5; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 09:44:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730882698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UIS7d0Fg/6Lu7S3HUpHZFTodaKadaaTMpB7Te4+Ej4E=;
	b=luX4rVb5OgiCmKSYprS8EwdZIaWWzsjKKt6yR5sWyxGKkd5oVRt9jFzxyChFvpiJiGiFYI
	2Fm/HaJ17fKhhEhr1XikWlRDcNmLemBJM+4QixB8/bG7vpZGNw9nC0GhjlVvNEL5H9hKrt
	DJi6LULdqw9mg+gfH0vL5U7tFgi/vbU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v5 0/5] riscv: sbi: Add support to test
 HSM extension
Message-ID: <20241106-6fa6bde06f75e3911f83c349@orel>
References: <20240921100824.151761-1-jamestiotio@gmail.com>
 <20241023-13ecdc4f251cd2d070c9ee5e@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023-13ecdc4f251cd2d070c9ee5e@orel>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 23, 2024 at 04:23:10PM +0200, Andrew Jones wrote:
> On Sat, Sep 21, 2024 at 06:08:18PM +0800, James Raphael Tiovalen wrote:
> > This patch series adds support for testing all 4 functions of the HSM
> > extension as defined in the RISC-V SBI specification. The first 4
> > patches add some helper routines to prepare for the HSM test, while
> > the last patch adds the actual test for the HSM extension.
> 
> Hi James,
> 
> Patch1 is now merged and I've applied patch2 to riscv/sbi[1]. I've also

I've had some second thoughts on patch2, as pointed out in the review of
v6. I need some bits of that patch, though, for other tests. I'll post a
patch with just those bits, retaining your authorship.

Thanks,
drew

> applied [2] and [3] to riscv/sbi so patches 3 and 4 of this series
> should no longer be necessary. Can you please rebase patch5 on
> riscv/sbi and repost?
> 
> [1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi
> [2] https://lore.kernel.org/all/20241023131718.117452-4-andrew.jones@linux.dev/
> [3] https://lore.kernel.org/all/20241023132130.118073-6-andrew.jones@linux.dev/
> 
> Thanks,
> drew
> 
> > 
> > v5:
> > - Addressed all of Andrew's comments.
> > - Added 2 new patches to clear on_cpu_info[cpu].func and to set the
> >   cpu_started mask, which are used to perform cleanup after running the
> >   HSM tests.
> > - Added some new tests to validate suspension on RV64 with the high
> >   bits set for suspend_type.
> > - Picked up the hartid_to_cpu rewrite patch from Andrew's branch.
> > - Moved the variables declared in riscv/sbi.c in patch 2 to group it
> >   together with the other HSM test variables declared in patch 5.
> > 
> > v4:
> > - Addressed all of Andrew's comments.
> > - Included the 2 patches from Andrew's branch that refactored some
> >   functions.
> > - Added timers to all of the waiting activities in the HSM tests.
> > 
> > v3:
> > - Addressed all of Andrew's comments.
> > - Split the report_prefix_pop patch into its own series.
> > - Added a new environment variable to specify the maximum number of
> >   CPUs supported by the SBI implementation.
> > 
> > v2:
> > - Addressed all of Andrew's comments.
> > - Added a new patch to add helper routines to clear multiple prefixes.
> > - Reworked the approach to test the HSM extension by using cpumask and
> >   on-cpus.
> > 
> > Andrew Jones (1):
> >   riscv: Rewrite hartid_to_cpu in assembly
> > 
> > James Raphael Tiovalen (4):
> >   riscv: sbi: Provide entry point for HSM tests
> >   lib/on-cpus: Add helper method to clear the function from on_cpu_info
> >   riscv: Add helper method to set cpu started mask
> >   riscv: sbi: Add tests for HSM extension
> > 
> >  riscv/Makefile          |   3 +-
> >  lib/riscv/asm/smp.h     |   2 +
> >  lib/on-cpus.h           |   1 +
> >  lib/on-cpus.c           |  11 +
> >  lib/riscv/asm-offsets.c |   5 +
> >  lib/riscv/setup.c       |  10 -
> >  lib/riscv/smp.c         |   8 +
> >  riscv/sbi-tests.h       |  10 +
> >  riscv/cstart.S          |  24 ++
> >  riscv/sbi-asm.S         |  71 +++++
> >  riscv/sbi.c             | 651 ++++++++++++++++++++++++++++++++++++++++
> >  11 files changed, 785 insertions(+), 11 deletions(-)
> >  create mode 100644 riscv/sbi-tests.h
> >  create mode 100644 riscv/sbi-asm.S
> > 
> > --
> > 2.43.0
> > 
> > 
> > -- 
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

