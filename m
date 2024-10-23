Return-Path: <kvm+bounces-29518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA93E9ACC2B
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90BB41C20C49
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41DB1BC9EB;
	Wed, 23 Oct 2024 14:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PcZodF8s"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7698F1AA787
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 14:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729693401; cv=none; b=siVoYpFz9ZsTU1dafLGNi350MpLX79tPr9PnwfirhauM8nD7PSTG+QCxNB2n7LCnEnout1mOx6Z39YEZwLYmDLf+4Hd49p7/AY6PXFTRj5ExoqDdZa6VtR9+Tbyk+3HlqRxNpWfAoVRvZtxXB1aAEBUhUgORaMMpKcDMOY3QN0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729693401; c=relaxed/simple;
	bh=BUVzywpRpzr14CpLVd/duDK9VHh+MmrSGYph3Sfix4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNehC24+ilk+8YsddvFXEAmC9O+RLbckRcDbVmDYyZVbQvG8JJ/aQsuEf7Jci8hek1iBrkiGCCW1DRpJvUow7AWrd7ZPGFYs4qZOJ4ZhVF8Ed0pBWkTtd2a9Ks5xAEA8aTRR/41h90BLVRlF/As6tC9XUkIE0MJtKp0HCFqjzNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PcZodF8s; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 23 Oct 2024 16:23:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729693395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6D6+2LA53RFDe6sHdCHip511F5V3mLNeWhEGIZIvwok=;
	b=PcZodF8shkw7wU5unEOCjDqxu4TRsordgOyKkt8E5oau+GNbeq9K/gIC4IGSdcHl2Msz6o
	DQace9/VZAXvlqJCgohgqMvKhxQBpVH38Ve0bK/uo3gTBe8p+6Gp94b6rE3loXOskO79Ik
	5n0SpXtjrQ3zbGWXZNqOUGZwxSHHtnE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v5 0/5] riscv: sbi: Add support to test
 HSM extension
Message-ID: <20241023-13ecdc4f251cd2d070c9ee5e@orel>
References: <20240921100824.151761-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240921100824.151761-1-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Sep 21, 2024 at 06:08:18PM +0800, James Raphael Tiovalen wrote:
> This patch series adds support for testing all 4 functions of the HSM
> extension as defined in the RISC-V SBI specification. The first 4
> patches add some helper routines to prepare for the HSM test, while
> the last patch adds the actual test for the HSM extension.

Hi James,

Patch1 is now merged and I've applied patch2 to riscv/sbi[1]. I've also
applied [2] and [3] to riscv/sbi so patches 3 and 4 of this series
should no longer be necessary. Can you please rebase patch5 on
riscv/sbi and repost?

[1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi
[2] https://lore.kernel.org/all/20241023131718.117452-4-andrew.jones@linux.dev/
[3] https://lore.kernel.org/all/20241023132130.118073-6-andrew.jones@linux.dev/

Thanks,
drew

> 
> v5:
> - Addressed all of Andrew's comments.
> - Added 2 new patches to clear on_cpu_info[cpu].func and to set the
>   cpu_started mask, which are used to perform cleanup after running the
>   HSM tests.
> - Added some new tests to validate suspension on RV64 with the high
>   bits set for suspend_type.
> - Picked up the hartid_to_cpu rewrite patch from Andrew's branch.
> - Moved the variables declared in riscv/sbi.c in patch 2 to group it
>   together with the other HSM test variables declared in patch 5.
> 
> v4:
> - Addressed all of Andrew's comments.
> - Included the 2 patches from Andrew's branch that refactored some
>   functions.
> - Added timers to all of the waiting activities in the HSM tests.
> 
> v3:
> - Addressed all of Andrew's comments.
> - Split the report_prefix_pop patch into its own series.
> - Added a new environment variable to specify the maximum number of
>   CPUs supported by the SBI implementation.
> 
> v2:
> - Addressed all of Andrew's comments.
> - Added a new patch to add helper routines to clear multiple prefixes.
> - Reworked the approach to test the HSM extension by using cpumask and
>   on-cpus.
> 
> Andrew Jones (1):
>   riscv: Rewrite hartid_to_cpu in assembly
> 
> James Raphael Tiovalen (4):
>   riscv: sbi: Provide entry point for HSM tests
>   lib/on-cpus: Add helper method to clear the function from on_cpu_info
>   riscv: Add helper method to set cpu started mask
>   riscv: sbi: Add tests for HSM extension
> 
>  riscv/Makefile          |   3 +-
>  lib/riscv/asm/smp.h     |   2 +
>  lib/on-cpus.h           |   1 +
>  lib/on-cpus.c           |  11 +
>  lib/riscv/asm-offsets.c |   5 +
>  lib/riscv/setup.c       |  10 -
>  lib/riscv/smp.c         |   8 +
>  riscv/sbi-tests.h       |  10 +
>  riscv/cstart.S          |  24 ++
>  riscv/sbi-asm.S         |  71 +++++
>  riscv/sbi.c             | 651 ++++++++++++++++++++++++++++++++++++++++
>  11 files changed, 785 insertions(+), 11 deletions(-)
>  create mode 100644 riscv/sbi-tests.h
>  create mode 100644 riscv/sbi-asm.S
> 
> --
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

