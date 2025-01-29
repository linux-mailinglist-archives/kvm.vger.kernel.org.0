Return-Path: <kvm+bounces-36859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 360C8A21EE2
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:17:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D3D818816EA
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F62E1494CC;
	Wed, 29 Jan 2025 14:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OBPU4IEj"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA0ADF49
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738160242; cv=none; b=axz8ECsQfu3q5SkfAMwRXt3rTON0BBV6+08LGAsHoZkTzFrLsqDxl3qzOZvy9J4sFBtdc/QSaaM/cGPmPjyClWlxvd38H1e6gsbjGoaORPdFlRy9jvMcza/ooumBuJpY+AkOJSAWmoQeuHQnAa1nYNQU95J187bIDNpIsZw8A6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738160242; c=relaxed/simple;
	bh=6Nl4yJJGsKMoKMQS7OlSI6B7Qhs+lNPje1Rdrjw+r+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJvjD3RGvetnSf+1uyp4Z5Nyr4Nl1TwVv0I0dQq682iwUuEal5r3JVCoai9yTEuMwsUnwgGuIOPXcZdBFNDluWOpuSwPTNty2+qTu0l3ieT+ObHKdD+7dMiom9YntOXFFm+tLqcQ/LzlNJ5yTvbm5RU2j/jO0ZzrOEVhb3x+Rdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OBPU4IEj; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 29 Jan 2025 15:17:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738160236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3FYe50gT7/INRrDrvYureIAbDleSAcXQFfoib6AD7R4=;
	b=OBPU4IEjGreOYYBuocl/PISwDOmNRejZFaLZ6Rph/amMKVcV9gjMxadWYzh2qQZr69rgzN
	XYCHXy1M/Yt4Tu1h9GkiYouVTOcqw4gkt8WtrItZxhkQLhUQI4pilHAS4eelFDaxMhiYIE
	SNL69s+Fw2Wpn5fSIybK+BzcDxuDu7A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/2] riscv: Add tests for SBI FWFT
 extension
Message-ID: <20250129-ab75148a5b1ce97ae8529532@orel>
References: <20250128141543.1338677-1-cleger@rivosinc.com>
 <20250128141543.1338677-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250128141543.1338677-3-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 28, 2025 at 03:15:42PM +0100, Clément Léger wrote:
> Add tests for the FWFT SBI extension. Currently, only the reserved range
> as well as the misaligned exception delegation are used.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile      |   2 +-
>  lib/riscv/asm/sbi.h |  34 ++++++++
>  riscv/sbi-fwft.c    | 190 ++++++++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c         |   3 +
>  4 files changed, 228 insertions(+), 1 deletion(-)
>  create mode 100644 riscv/sbi-fwft.c
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 5b5e157c..52718f3f 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -17,7 +17,7 @@ tests += $(TEST_DIR)/sieve.$(exe)
>  
>  all: $(tests)
>  
> -$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o
> +$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o $(TEST_DIR)/sbi-fwft.o
>  
>  # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
>  $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 98a9b097..397400f2 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -11,6 +11,12 @@
>  #define SBI_ERR_ALREADY_AVAILABLE	-6
>  #define SBI_ERR_ALREADY_STARTED		-7
>  #define SBI_ERR_ALREADY_STOPPED		-8
> +#define SBI_ERR_NO_SHMEM		-9
> +#define SBI_ERR_INVALID_STATE		-10
> +#define SBI_ERR_BAD_RANGE		-11
> +#define SBI_ERR_TIMEOUT			-12
> +#define SBI_ERR_IO			-13
> +#define SBI_ERR_LOCKED			-14
>  
>  #ifndef __ASSEMBLY__
>  #include <cpumask.h>
> @@ -23,6 +29,7 @@ enum sbi_ext_id {
>  	SBI_EXT_SRST = 0x53525354,
>  	SBI_EXT_DBCN = 0x4442434E,
>  	SBI_EXT_SUSP = 0x53555350,
> +	SBI_EXT_FWFT = 0x46574654,
>  };
>  
>  enum sbi_ext_base_fid {
> @@ -71,6 +78,33 @@ enum sbi_ext_dbcn_fid {
>  	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
>  };
>  
> +
> +enum sbi_ext_fwft_fid {
> +	SBI_EXT_FWFT_SET = 0,
> +	SBI_EXT_FWFT_GET,
> +};
> +
> +#define SBI_FWFT_MISALIGNED_EXC_DELEG		0x0
> +#define SBI_FWFT_LANDING_PAD			0x1
> +#define SBI_FWFT_SHADOW_STACK			0x2
> +#define SBI_FWFT_DOUBLE_TRAP			0x3
> +#define SBI_FWFT_PTE_AD_HW_UPDATING		0x4
> +#define SBI_FWFT_POINTER_MASKING_PMLEN		0x5
> +#define SBI_FWFT_LOCAL_RESERVED_START		0x6
> +#define SBI_FWFT_LOCAL_RESERVED_END		0x3fffffff
> +#define SBI_FWFT_LOCAL_PLATFORM_START		0x40000000
> +#define SBI_FWFT_LOCAL_PLATFORM_END		0x7fffffff
> +
> +#define SBI_FWFT_GLOBAL_RESERVED_START		0x80000000
> +#define SBI_FWFT_GLOBAL_RESERVED_END		0xbfffffff
> +#define SBI_FWFT_GLOBAL_PLATFORM_START		0xc0000000
> +#define SBI_FWFT_GLOBAL_PLATFORM_END		0xffffffff
> +
> +#define SBI_FWFT_PLATFORM_FEATURE_BIT		BIT(30)
> +#define SBI_FWFT_GLOBAL_FEATURE_BIT		BIT(31)
> +
> +#define SBI_FWFT_SET_FLAG_LOCK			BIT(0)
> +
>  struct sbiret {
>  	long error;
>  	long value;
> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> new file mode 100644
> index 00000000..c9292cfb
> --- /dev/null
> +++ b/riscv/sbi-fwft.c
> @@ -0,0 +1,190 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * SBI verification
> + *
> + * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
> + */
> +#include <libcflat.h>
> +#include <stdlib.h>
> +
> +#include <asm/csr.h>
> +#include <asm/processor.h>
> +#include <asm/ptrace.h>
> +#include <asm/sbi.h>
> +
> +#include "sbi-tests.h"
> +
> +void check_fwft(void);
> +
> +
> +static struct sbiret fwft_set_raw(unsigned long feature, unsigned long value, unsigned long flags)
> +{
> +	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, feature, value, flags, 0, 0, 0);
> +}
> +
> +static struct sbiret fwft_set(uint32_t feature, unsigned long value, unsigned long flags)
> +{
> +	return fwft_set_raw(feature, value, flags);
> +}
> +
> +static struct sbiret fwft_get_raw(unsigned long feature)
> +{
> +	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET, feature, 0, 0, 0, 0, 0);
> +}
> +
> +static struct sbiret fwft_get(uint32_t feature)
> +{
> +	return fwft_get_raw(feature);
> +}
> +
> +static void fwft_check_reserved(unsigned long id)
> +{
> +	struct sbiret ret;
> +
> +	ret = fwft_get(id);
> +	sbiret_report_error(&ret, SBI_ERR_DENIED, "get reserved feature 0x%lx", id);
> +
> +	ret = fwft_set(id, 1, 0);
> +	sbiret_report_error(&ret, SBI_ERR_DENIED, "set reserved feature 0x%lx", id);
> +}
> +
> +static void fwft_check_base(void)
> +{
> +	struct sbiret ret;
> +
> +	report_prefix_push("base");
> +
> +	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_START);
> +	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_END);
> +	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_START);
> +	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_END);
> +
> +	/* Check id > 32 bits */
> +	if (__riscv_xlen > 32) {
> +		ret = fwft_get_raw(BIT(32));
> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +				    "get feature 0x%lx error", BIT(32));
> +
> +		ret = fwft_set_raw(BIT(32), 0, 0);
> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +				    "set feature 0x%lx error", BIT(32));

At least with the compiler I'm using, the code inside this
"if (__riscv_xlen > 32)" block is still getting compiled for
rv32 and breaking on the BIT(). It doesn't help to use BIT_ULL() here
since fwft_get/set_raw() take longs. I guess we'll have to use #if.

Fixed on merge.

> +	}
> +
> +	report_prefix_pop();
> +}
> +
> +static bool misaligned_handled;
> +
> +static void misaligned_handler(struct pt_regs *regs)
> +{
> +	misaligned_handled = true;
> +	regs->epc += 4;
> +}
> +
> +static struct sbiret fwft_misaligned_exc_set(unsigned long value, unsigned long flags)
> +{
> +	return fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, value, flags);
> +}
> +
> +static struct sbiret fwft_misaligned_exc_get(void)
> +{
> +	return fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
> +}
> +
> +static void fwft_check_misaligned_exc_deleg(void)
> +{
> +	struct sbiret ret;
> +
> +	report_prefix_push("misaligned_exc_deleg");
> +
> +	ret = fwft_misaligned_exc_get();
> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
> +		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
> +		return;
> +	}
> +
> +	if (!sbiret_report_error(&ret, 0, "Get misaligned deleg feature no error"))
> +		return;
> +
> +	ret = fwft_misaligned_exc_set(2, 0);
> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +			    "Set misaligned deleg feature invalid value 2");
> +	ret = fwft_misaligned_exc_set(0xFFFFFFFF, 0);
> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +			    "Set misaligned deleg feature invalid value 0xFFFFFFFF");
> +
> +	if (__riscv_xlen > 32) {
> +		ret = fwft_misaligned_exc_set(BIT(32), 0);
> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +				    "Set misaligned deleg with invalid value > 32bits");
> +
> +		ret = fwft_misaligned_exc_set(0, BIT(32));
> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
> +				    "Set misaligned deleg with invalid flag > 32bits");

Same comment as above and also fixed on merge.

Thanks,
drew

