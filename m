Return-Path: <kvm+bounces-35530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D71DA12353
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51CA63AEB23
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 11:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50D22419F8;
	Wed, 15 Jan 2025 11:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jIxEzcRq"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851EA2416A0
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 11:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736942030; cv=none; b=W823yd+mihxCQCq07vbgA9bg3FfLLz1d7yUx3d5TpOHyfzXS5dPI1NZ1rFE5qe2jKo1Ov1ZpYqAooTbMikGuY5dJLb++VFTACgH9EM5lwZaeeziKE7d8Rc9+ObFb6fUYPQmwyPQST3ZF0Jwje5JuUHkAovviFa61RBDWxkKowR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736942030; c=relaxed/simple;
	bh=z+DQDmdXGGm+uA4XJsVXWYm9OtnBct6EXfKv+XkD9Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eSbrxCUIC2n5eLdj1MzVVRTfxlkryQ7QgdgyNGWE1HwW19Q2LNlzx+RE9dR5t4WaESzbR8jmcn+do+OFuxCBuM10l5UMeqFCar7osRWdzSuHkG5RsVe1pXPt9qJAxve4vohFIliNmHb2/7wBnFfnno4HW2DcOmI9EvSawLqijZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jIxEzcRq; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 15 Jan 2025 12:53:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736942026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1sco8ktW39kqonSXUGt7UzTB7sldMgmov4ALg1LT3J8=;
	b=jIxEzcRqQj2BGFcCwQxk1BAbzZUh1p7LSk5gJqBlcJ3ONXm6x4pP3wtBL66rgthNwqpfsr
	FhjtPaouQc3AGVwcdh6wCj9aXAL0j6hpEN0J3KcuDGts5bsGzcitrXZvbI+tUkgFp+g40E
	6zNVinfkYrCBB56fWq16FUQL45EbeEs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v6 2/5] riscv: use asm-offsets to generate
 SBI_EXT_HSM values
Message-ID: <20250115-b08dfc4dd3d73ce95bece07c@orel>
References: <20250110111247.2963146-1-cleger@rivosinc.com>
 <20250110111247.2963146-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250110111247.2963146-3-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 10, 2025 at 12:12:41PM +0100, Clément Léger wrote:
> Replace hardcoded values with generated ones using sbi-asm-offset. This
> allows to directly use ASM_SBI_EXT_HSM and ASM_SBI_EXT_HSM_STOP in
> assembly.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile          |  2 +-
>  riscv/sbi-asm.S         |  6 ++++--
>  riscv/sbi-asm-offsets.c | 12 ++++++++++++
>  riscv/.gitignore        |  1 +
>  4 files changed, 18 insertions(+), 3 deletions(-)
>  create mode 100644 riscv/sbi-asm-offsets.c
>  create mode 100644 riscv/.gitignore
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 28b04156..af5ee495 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -86,7 +86,7 @@ CFLAGS += -ffreestanding
>  CFLAGS += -O2
>  CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
>  
> -asm-offsets = lib/riscv/asm-offsets.h
> +asm-offsets = lib/riscv/asm-offsets.h riscv/sbi-asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
>  
>  %.aux.o: $(SRCDIR)/lib/auxinfo.c
> diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
> index 923c2cec..b9c2696f 100644
> --- a/riscv/sbi-asm.S
> +++ b/riscv/sbi-asm.S
> @@ -7,6 +7,8 @@
>  #define __ASSEMBLY__
>  #include <asm/asm.h>
>  #include <asm/csr.h>
> +#include <asm/asm-offsets.h>
> +#include <generated/sbi-asm-offsets.h>
>  
>  #include "sbi-tests.h"
>  
> @@ -58,8 +60,8 @@ sbi_hsm_check:
>  7:	lb	t0, 0(t1)
>  	pause
>  	beqz	t0, 7b
> -	li	a7, 0x48534d	/* SBI_EXT_HSM */
> -	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
> +	li	a7, ASM_SBI_EXT_HSM
> +	li	a6, ASM_SBI_EXT_HSM_HART_STOP
>  	ecall
>  8:	pause
>  	j	8b
> diff --git a/riscv/sbi-asm-offsets.c b/riscv/sbi-asm-offsets.c
> new file mode 100644
> index 00000000..116fe497
> --- /dev/null
> +++ b/riscv/sbi-asm-offsets.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <kbuild.h>
> +#include <asm/sbi.h>
> +#include "sbi-tests.h"

Don't need to include sbi-tests.h

> +
> +int main(void)
> +{
> +	DEFINE(ASM_SBI_EXT_HSM, SBI_EXT_HSM);
> +	DEFINE(ASM_SBI_EXT_HSM_HART_STOP, SBI_EXT_HSM_HART_STOP);
> +
> +	return 0;
> +}
> diff --git a/riscv/.gitignore b/riscv/.gitignore
> new file mode 100644
> index 00000000..0a8c5a36
> --- /dev/null
> +++ b/riscv/.gitignore
> @@ -0,0 +1 @@
> +/*-asm-offsets.[hs]
> -- 
> 2.47.1
>

Otherwise,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

