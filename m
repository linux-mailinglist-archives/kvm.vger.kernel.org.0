Return-Path: <kvm+bounces-35292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E54E8A0B919
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 15:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09F1E167137
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 14:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881BE23ED62;
	Mon, 13 Jan 2025 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PiM9USzv"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB5A23ED51
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777479; cv=none; b=SgYfGcZlkvPeCKj8X5OAatB6mJimSn3g9nJlyND2cQtQfjyz3Ft8YpM6RRddHx7cu3zRN7Nn1KhyCC8LPHe5n+aJhqpcDh5d141CMCc+N0ylb4OjvokebirvrpghHRWPeX3dPSrPT4CfencP/0SzUDBvmGzb0X5bHlgShjfBtaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777479; c=relaxed/simple;
	bh=jX1DjcMk1gi2U9IfPHSep5MVKoAIz8PNPqMbVbaEeN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtvihB51Ufe7a1N5+s3qPrgfw82V7Et9Gbo1T6nT7ClOsfBCIR+WG+hzn5xCG9+logD41J9s1h2XPOgNyDMYPfAia5g/1xFBAFBzBGzi2LRGVLSluIKgh+jcPEiYOqE+lSw8mQ2v+XiW13hm12lDhUawRsSGmUfpLqGXlxtye7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PiM9USzv; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 13 Jan 2025 15:11:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736777472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xTLLPDUXcmmZr7F3eNzvr+Ad2FEwFLBnrfQo7nonAUE=;
	b=PiM9USzvh9mC68PAZviyKKe4gSZqQ5ldBPsENPfcBUHYDhLGVS37YKMJdiS5Db59FFvUP0
	QtCDdr/Ago0zG/tvOfEQa20hfDzQ/VzcKd3eVvU7nb9ZS1dYyR1NLj3ZjBGDf3TyBeFC0P
	dTMmHRKGzMdVThC0lD2E3WZA+wJLW0s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v6 0/5] riscv: add SBI SSE extension tests
Message-ID: <20250113-a733eb4cb209b57475bf5df2@orel>
References: <20250110111247.2963146-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250110111247.2963146-1-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

Hi Clement,

I have comments on patch 5 of the v4 series drafted. I'll finish reviewing
that patch and send them. Hopefully they'll still mostly apply to v6 as
well.

Thanks,
drew

On Fri, Jan 10, 2025 at 12:12:39PM +0100, Clément Léger wrote:
> This series adds an individual test for SBI SSE extension as well as
> needed infrastructure for SSE support. It also adds test specific
> asm-offsets generation to use custom OFFSET and DEFINE from the test
> directory.
> 
> ---
> 
> V6:
>  - Add missing $(generated-file) dependencies for "-deps" objects
>  - Split SSE entry from sbi-asm.S to sse-asm.S and all SSE core functions
>    since it will be useful for other tests as well (dbltrp).
> 
> V5:
>  - Update event ranges based on latest spec
>  - Rename asm-offset-test.c to sbi-asm-offset.c
> 
> V4:
>  - Fix typo sbi_ext_ss_fid -> sbi_ext_sse_fid
>  - Add proper asm-offset generation for tests
>  - Move SSE specific file from lib/riscv to riscv/
> 
> V3:
>  - Add -deps variable for test specific dependencies
>  - Fix formatting errors/typo in sbi.h
>  - Add missing double trap event
>  - Alphabetize sbi-sse.c includes
>  - Fix a6 content after unmasking event
>  - Add SSE HART_MASK/UNMASK test
>  - Use mv instead of move
>  - move sbi_check_sse() definition in sbi.c
>  - Remove sbi_sse test from unitests.cfg
> 
> V2:
>  - Rebased on origin/master and integrate it into sbi.c tests
> 
> Clément Léger (5):
>   kbuild: allow multiple asm-offsets file to be generated
>   riscv: use asm-offsets to generate SBI_EXT_HSM values
>   riscv: Add "-deps" handling for tests
>   riscv: lib: Add SBI SSE extension definitions
>   riscv: sbi: Add SSE extension tests
> 
>  scripts/asm-offsets.mak |  22 +-
>  riscv/Makefile          |  12 +-
>  lib/riscv/asm/csr.h     |   2 +
>  lib/riscv/asm/sbi.h     |  89 ++++
>  riscv/sse.h             |  41 ++
>  riscv/sbi-asm.S         |   6 +-
>  riscv/sse-asm.S         | 104 +++++
>  riscv/sbi-asm-offsets.c |  20 +
>  riscv/sbi-sse.c         | 936 ++++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c             |   3 +
>  riscv/sse.c             | 132 ++++++
>  riscv/.gitignore        |   1 +
>  12 files changed, 1355 insertions(+), 13 deletions(-)
>  create mode 100644 riscv/sse.h
>  create mode 100644 riscv/sse-asm.S
>  create mode 100644 riscv/sbi-asm-offsets.c
>  create mode 100644 riscv/sbi-sse.c
>  create mode 100644 riscv/sse.c
>  create mode 100644 riscv/.gitignore
> 
> -- 
> 2.47.1
> 

