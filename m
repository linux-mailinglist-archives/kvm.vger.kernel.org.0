Return-Path: <kvm+bounces-31491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F36E9C4192
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:10:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16F78B22CA4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1F11A0BD7;
	Mon, 11 Nov 2024 15:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VaU4xHF1"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040FA1BC58
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731337821; cv=none; b=m76UJwQimwoLikIlQlXd1V9+RBLo5Ai2eSDRffL+OfH9N9Gc7y7nimS0hQ39nlWyOFdUXUlPo+g+t7hi+ucHEJdr3ldwqSqmpQ2kIxk57mUKxoquotV17oZ9sPAObTbtoJm3m51+vf0B0NUvutwITbg31/DT1cWJWvq47IgK/rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731337821; c=relaxed/simple;
	bh=orVHPJDDb+E2JgZh94H/vyxZEJgogDG82hBh5d1yyrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnQ9opNAarC9QExCH19mqoO8ctptSmBvo1CnFktdRzI2Mrvx7ygrB1ezsfJbo4vvHhRWGaj+gpCX2pnXrNniSEKlJN6R0/Z37VENhdtGmQvk5Pq0VtLTRE3S7J7B3ga+AbFS8ULm5faKSFZ0kxrMNd/4cOaCw8nPheoR3xyUtQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VaU4xHF1; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 16:10:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731337818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XAmbbKmHFOTylrblkqH/lSa+VDPPEWPxIvM8CMqBgc8=;
	b=VaU4xHF1TM2OX15OwNp0WXIuF+30UG+gDnwFW+E/GKgpr+6q5mSL2xc+/gmvNAwxum4/74
	1s70m1St5hEW7BlF9jSeGn/zAbiPo7sgzkX0Y20dyUUSqymX70e7jxTj+6sR7o2NxZKUg9
	EwjPSTTlh4Pxm8M7hWC+pASuPZyiZ1k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v7 0/2] riscv: sbi: Add support to test
 HSM extension
Message-ID: <20241111-dc706a3f0c07d4c49ec77d0c@orel>
References: <20241110171633.113515-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241110171633.113515-1-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 11, 2024 at 01:16:31AM +0800, James Raphael Tiovalen wrote:
> This patch series adds support for testing all 4 functions of the HSM
> extension as defined in the RISC-V SBI specification. The first patch
> in version 7 of this series fixes the entry point of the HSM tests,
> while the second patch adds the actual test for the HSM extension.
> 
> Based-on: https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

I've gone ahead and fixed up the patches per my comments and HSM tests
are now merged!

Thanks,
drew

> 
> v7:
> - Addressed all of Andrew's comments.
> - Fixed the entry point of the HSM tests to follow the SUSP tests.
> 
> v6:
> - Rebased on top of the latest commit of the riscv/sbi branch.
> - Removed unnecessary cleanup code in the HSM tests after improvements
>   to the on-cpus API were made by Andrew.
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
> James Raphael Tiovalen (2):
>   riscv: sbi: Fix entry point of HSM tests
>   riscv: sbi: Add tests for HSM extension
> 
>  riscv/sbi-tests.h |  13 +-
>  riscv/sbi-asm.S   |  33 +--
>  riscv/sbi.c       | 613 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 642 insertions(+), 17 deletions(-)
> 
> --
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

