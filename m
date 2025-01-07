Return-Path: <kvm+bounces-34696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B2FA0482F
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 18:27:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A55A166EC4
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 17:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C271F4717;
	Tue,  7 Jan 2025 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xj2PAsKy"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7299198A29
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 17:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736270830; cv=none; b=EKMBTrMl5n/kUHxdlcy+/rCjkSSx3jlEBtefJRtJTiW7QembnT9YjfPWIT/pqvW0iVFYU2VDeb/mm+Xl7pN9CMK60J7L5bHTRB2rqYFcZZYxf3nfWiHHlxUc5GeazPSxA71po/ZFh3gluGE3IRqYWC6GtHdITqmUsMGs6ZtpW6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736270830; c=relaxed/simple;
	bh=GgFQyqcgtOf6dOHxkVzE41qVoWKrlvRNuqK5ny9L5WE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5vYONzTHJTAYudb1LHf/F3bQS2kcSl/Hy7nRof+GsxupRhSXbJOiZfq3QIBJ80hUAOUZCEihJt0blBD3QpHkuyKCg0ckZALCJbI23EuHp51kZFtUQe3JYHbtwHrytDUL3q7rati/X8tRBkcxvlDFfnYF5QJirRa1D6KDg+CYQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xj2PAsKy; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 7 Jan 2025 18:27:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736270823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EInka3Xi3NGVenf+F3gnYlNQHdGGFcUbbqf7IwFSB0k=;
	b=xj2PAsKyHO8xaKwwCSczbalSZ7j2iErQyZFdb7VxtKUMUdbqz68ntzGj2D8n/vxECx580/
	rSY/UiOEK8t6pSmX9nWop8VTe4MhOWDS1xSWGB+B17upmpPGFdTLvu8Yq2TNFWXPb3l6ea
	11DU2Nnl2ATR6rYcnWF0CLdQut4BDn8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v4 2/5] riscv: use asm-offsets to generate
 SBI_EXT_HSM values
Message-ID: <20250107-feb21efc4c0815bd3ed7b173@orel>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
 <20241125162200.1630845-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241125162200.1630845-3-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 25, 2024 at 05:21:51PM +0100, Clément Léger wrote:
> Replace hardcoded values with generated ones using asm-offset. This
> allows to directly use ASM_SBI_EXT_HSM and ASM_SBI_EXT_HSM_START in

ASM_SBI_EXT_HSM_HART_STOP

> assembly.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile           |  2 +-
>  riscv/sbi-asm.S          |  6 ++++--
>  riscv/asm-offsets-test.c | 12 ++++++++++++
>  riscv/.gitignore         |  1 +
>  4 files changed, 18 insertions(+), 3 deletions(-)
>  create mode 100644 riscv/asm-offsets-test.c
>  create mode 100644 riscv/.gitignore
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 28b04156..a01ff8a3 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -86,7 +86,7 @@ CFLAGS += -ffreestanding
>  CFLAGS += -O2
>  CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
>  
> -asm-offsets = lib/riscv/asm-offsets.h
> +asm-offsets = lib/riscv/asm-offsets.h riscv/asm-offsets-test.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
>  
>  %.aux.o: $(SRCDIR)/lib/auxinfo.c
> diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
> index 923c2cec..193d9606 100644
> --- a/riscv/sbi-asm.S
> +++ b/riscv/sbi-asm.S
> @@ -7,6 +7,8 @@
>  #define __ASSEMBLY__
>  #include <asm/asm.h>
>  #include <asm/csr.h>
> +#include <asm/asm-offsets.h>
> +#include <generated/asm-offsets-test.h>
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
> diff --git a/riscv/asm-offsets-test.c b/riscv/asm-offsets-test.c
> new file mode 100644
> index 00000000..116fe497
> --- /dev/null
> +++ b/riscv/asm-offsets-test.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <kbuild.h>
> +#include <asm/sbi.h>
> +#include "sbi-tests.h"
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
> index 00000000..91713581
> --- /dev/null
> +++ b/riscv/.gitignore
> @@ -0,0 +1 @@
> +/asm-offsets-test.[hs]
> -- 
> 2.45.2
>

I like this and I should probably rework stuff to replace all the _IDX
macros in riscv/sbi-tests.h. I think we should call it sbi-asm-offsets.c,
though, and then change the Makefile and .gitignore changes to refer to
riscv/*-asm-offsets.h. That would allow us to keep test-specific asm-
offsets separate and avoid the name "asm-offsets-test" or similar which,
to me, conveys it's for testing asm-offsets.

Thanks,
drew

