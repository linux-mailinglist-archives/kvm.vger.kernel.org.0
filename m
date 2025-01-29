Return-Path: <kvm+bounces-36860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59E13A21EE7
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF6ED161F26
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4F014AD0D;
	Wed, 29 Jan 2025 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rFqNfleo"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CD31531E9
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 14:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738160313; cv=none; b=qwxM1S5A7qi6915HSGaVskwMmUHvSmHI3zJCh36Ly3qnDRFeBLppCdN9biIDfjfqs2aIk7GoA/NllnOAqVYtZ2scUPhB3Sgl06GGQysurhOhQ0uPcmdKIN5CEtrks93lbrvIYt7oUyJrm1eyRSf6Y0Q0uI4kvxC2KGsMYfjE8n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738160313; c=relaxed/simple;
	bh=icTeBGDx73Xb/rrmYSbeWzBVtesvVRErrPmw0pZsNfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WkCHlL7DB+Jd4iR4q/LcvkzgV7r/Tlb/wJoGDIgbBQ+Ymidt60s1b+ivhXt94mv6rTWv6KJotiFEGap8rnubd8AGcG/mzTqdHG9B/CShWlnPWk7yI4rJWjrvCzUqmk4x2C0NDaRPiaGoY3kTer8WxT0A7ocDYykzefBJOFUuXX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rFqNfleo; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 29 Jan 2025 15:18:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738160307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++BNsZx6jximv5tpFJZo63qAT9e5Cd/B0w65SFE0nYw=;
	b=rFqNfleoEUxa3QZR/Og0RHExNr5sKMOiaZYiC6LNrIs7uI3q0SxlcrFl0iKTV6pW+mENVJ
	iQTk+uJWy+E4khujZ+F3vXbNojBJPqaAonpueyo6NaCvU8sLfkz1vFC9WErLVDulrBtYoW
	TAcDEQR2Yx7Wb1Po0Cl4h5hmDPDZTjA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/2] Add support for SBI FWFT extension
 testing
Message-ID: <20250129-4e54cccfa2abab6dba9a608b@orel>
References: <20250128141543.1338677-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250128141543.1338677-1-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 28, 2025 at 03:15:40PM +0100, Clément Léger wrote:
> This series adds a minimal set of tests for the FWFT extension. Reserved
> range as well as misaligned exception delegation. A commit coming from
> the SSE tests series is also included in this series to add -deps
> makefile notation.
> 
> ---
> 
> V3:
>  - Rebase on top of andrew/riscv/sbi
>  - Use sbiret_report_error()
>  - Add helpers for MISALIGNED_EXC_DELEG fwft set/get
>  - Add a comment on misaligned trap handling
> 
> V2:
>  - Added fwft_{get/set}_raw() to test invalid > 32 bits ids
>  - Added test for invalid flags/value > 32 bits
>  - Added test for lock feature
>  - Use and enum for FWFT functions
>  - Replace hardcoded 1 << with BIT()
>  - Fix fwft_get/set return value
>  - Split set/get tests for reserved ranges
>  - Added push/pop to arch -c option
>  - Remove leftover of manual probing code
> 
> Clément Léger (2):
>   riscv: Add "-deps" handling for tests
>   riscv: Add tests for SBI FWFT extension
> 
>  riscv/Makefile      |   8 +-
>  lib/riscv/asm/sbi.h |  34 ++++++++
>  riscv/sbi-fwft.c    | 190 ++++++++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c         |   3 +
>  4 files changed, 232 insertions(+), 3 deletions(-)
>  create mode 100644 riscv/sbi-fwft.c
> 
> -- 
> 2.47.1
>

Applied to riscv/sbi

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

