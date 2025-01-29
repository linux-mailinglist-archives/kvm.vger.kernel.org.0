Return-Path: <kvm+bounces-36847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 071BAA21E20
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:47:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2506E3A5EE5
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 13:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF9941C71;
	Wed, 29 Jan 2025 13:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MaQsoh8U"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38D8149C50
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 13:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738158469; cv=none; b=iKF6xjyTcvAmHz19Jx9UTOuVf+2puat5WFOUmMmZ6PL6lrvMGMC1JW3ezMlM9QK1UJ0C+Rc7L7zncDpGLxn8nRnrIN6JqFTMl6h1lhPdit4KxfBTGQFCZACsf+q334hqiy5H24esgv4fLTO3qI4cHvZ1OKipvwXNNmjkmfog2/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738158469; c=relaxed/simple;
	bh=BcKXpE72yFoRMhY9eGA7c4yqmV3n2ELaUUzOaf0Fh2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTIadXv4zOB+04947PMwtiEuf6JFLEZ7/QanKnHGZctfg98QSc/m66gLZYER6l2wtvjUG8BUWOrkZParBVCOQTYj87mQ4brjcmHtbKg2LWk8E4B39Y2X8hM6Q/icc+eXSX78K+y/6ecGZjEqFhbN17ooPXFC1Yi6MvzueT1uAkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MaQsoh8U; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 29 Jan 2025 14:47:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738158462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjhAFNlfSdxxlXBrsa57d35+2hiHQN0ajkkjsYo+Rhs=;
	b=MaQsoh8UvjI2JJgSnf7PQwgsiaNtY9AIet31ggSKhJWEux5nlvrydURGXDCe4KXykMbL6z
	0+0rujxbrn5YQ+brTLOt43PUs6+yBEApYFnsyCl1urZQxVbQb1Ksnlfwcd453gDBWjjSHe
	PS6EKuVlT6saVN7EAkbL9mNqJt5oLq4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/2] riscv: Add tests for SBI FWFT
 extension
Message-ID: <20250129-a3f1f5e241901cbd54a82f3a@orel>
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
> +	}
> +
> +	/* Set to 0 and check after with get */
> +	ret = fwft_misaligned_exc_set(0, 0);
> +	sbiret_report_error(&ret, 0, "Set misaligned deleg feature value 0 no error");
> +	ret = fwft_misaligned_exc_get();
> +	sbiret_report(&ret, 0, 0, "Get misaligned deleg feature expected value 0");
> +
> +	/* Set to 1 and check after with get */
> +	ret = fwft_misaligned_exc_set(1, 0);
> +	sbiret_report_error(&ret, 0, "Set misaligned deleg feature value 1 no error");
> +	ret = fwft_misaligned_exc_get();
> +	sbiret_report(&ret, 0, 1, "Get misaligned deleg feature expected value 1");
> +
> +	install_exception_handler(EXC_LOAD_MISALIGNED, misaligned_handler);
> +
> +	asm volatile (
> +		".option push\n"
> +		/*
> +		 * Disable compression so the lw takes exactly 4 bytes and thus
> +		 * can be skipped reliably from the exception handler.
> +		 */
> +		".option arch,-c\n"
> +		"lw %[val], 1(%[val_addr])\n"
> +		".option pop\n"
> +		: [val] "+r" (ret.value)
> +		: [val_addr] "r" (&ret.value)
> +		: "memory");
> +
> +	/*
> +	 * Even though the SBI delegated the misaligned exception to S-mode, it might not trap on
> +	 * misaligned load/store access, report that during tests.
> +	 */
> +	if (!misaligned_handled)
> +		report_skip("Misaligned load exception does not trap in S-mode");
> +	else
> +		report_pass("Misaligned load exception trap in S-mode");
> +
> +	install_exception_handler(EXC_LOAD_MISALIGNED, NULL);
> +
> +	/* Lock the feature */
> +	ret = fwft_misaligned_exc_set(0, SBI_FWFT_SET_FLAG_LOCK);
> +	sbiret_report_error(&ret, 0, "Set misaligned deleg feature value 0 and lock no error");
> +	ret = fwft_misaligned_exc_set(1, 0);
> +	sbiret_report_error(&ret, SBI_ERR_LOCKED,
> +			    "Set misaligned deleg feature value 0 and lock no error");

The error message is copy+pasted from the last one. I've changed it to

"Set locked misaligned deleg feature to new value returns error"

while merging.

> +	ret = fwft_misaligned_exc_get();
> +	sbiret_report(&ret, 0, 0, "Get misaligned deleg locked value 0 no error");
> +
> +	report_prefix_pop();
> +}
> +
> +void check_fwft(void)
> +{
> +	report_prefix_push("fwft");
> +
> +	if (!sbi_probe(SBI_EXT_FWFT)) {
> +		report_skip("FWFT extension not available");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	fwft_check_base();
> +	fwft_check_misaligned_exc_deleg();
> +
> +	report_prefix_pop();
> +}
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 3eca8c7e..7c7a2d2d 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -32,6 +32,8 @@
>  
>  #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
>  
> +void check_fwft(void);
> +
>  static long __labs(long a)
>  {
>  	return __builtin_labs(a);
> @@ -1437,6 +1439,7 @@ int main(int argc, char **argv)
>  	check_hsm();
>  	check_dbcn();
>  	check_susp();
> +	check_fwft();
>  
>  	return report_summary();
>  }
> -- 
> 2.47.1
>

Thanks,
drew

