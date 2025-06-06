Return-Path: <kvm+bounces-48640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 386B2ACFE86
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 10:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 016D61761C7
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 08:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5DD2857D7;
	Fri,  6 Jun 2025 08:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ib1Pd6/q"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B2C219317
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 08:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749199733; cv=none; b=ifSNnRT3hQ5mKhbRqJ2v0IIRSx2VsfMYVzL8lG0D4lUnes9N/Iu1BhbJmK9GaS2dREiRY2Tr3blrLN53m1AUo60M234/7B4s7aR5nR557tUtM4ryyI+iJyCb0/zrhD+BQeaqaeHlpZOmdKxzNYIzENWStWafEe/8vlh/QsPAYGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749199733; c=relaxed/simple;
	bh=rhpFpuyN7zh3nq9+tih0BO5vmVh66kWrJLMHFpty9uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfqyXYoW+ZhJMifQ1RcqK7CbztWcsphT9yaSKzJflj7YTJ0o+/Sbp93iLD1NoexgpVLlCcqklY9unqvtg6YAs/Oz6aLIMW78FYzRjK/3TwPHGscNpbTMVTrSJVkRGTaqI20G0r8O5KWRM+0Ip8w0FdyHhz1+5QNYYtEax8hoUko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ib1Pd6/q; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 6 Jun 2025 10:48:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749199717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Y0ncs7BntoLmuGjS33PPF7FAyz1oiPPPcRfIV0w5m8=;
	b=Ib1Pd6/qGTY380nEHOlMndskLTkkdMiTv3zcj2QyRFSWXWjgCG6sHcIw0NJVA4j1I5PePi
	VSL16V3jHFtLhDE2zVtrPwdn7kBC+13ztukljn65fDsNFgojEFZzSWyvFG2sRFDs4McZfu
	LlT81dtXkToPhuGk5Syujhj6KM5SDgI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jesse Taube <jesse@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, Himanshu Chauhan <hchauhan@ventanamicro.com>, 
	Charlie Jenkins <charlie@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/2] riscv: sbi: Add SBI Debug Triggers
 Extension tests
Message-ID: <20250606-1b7c5285a3c731597f970c1d@orel>
References: <20250605161806.1206850-1-jesse@rivosinc.com>
 <20250605161806.1206850-2-jesse@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605161806.1206850-2-jesse@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 05, 2025 at 09:18:06AM -0700, Jesse Taube wrote:
> Add tests for the DBTR SBI extension.
> 
> Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> ---
> V1 -> V2:
>  - Call report_prefix_pop before returning
>  - Disable compressed instructions in exec_call, update related comment
>  - Remove extra "| 1" in dbtr_test_load
>  - Remove extra newlines
>  - Remove extra tabs in check_exec
>  - Remove typedefs from enums
>  - Return when dbtr_install_trigger fails
>  - s/avalible/available/g
>  - s/unistall/uninstall/g
> V2 -> V3:
>  - Change SBI_DBTR_SHMEM_INVALID_ADDR to -1UL
>  - Move all dbtr functions to sbi-dbtr.c
>  - Move INSN_LEN to processor.h
>  - Update include list
>  - Use C-style comments
> ---
>  lib/riscv/asm/sbi.h |   1 +
>  riscv/Makefile      |   1 +
>  riscv/sbi-dbtr.c    | 811 ++++++++++++++++++++++++++++++++++++++++++++
>  riscv/sbi-tests.h   |   1 +
>  riscv/sbi.c         |   1 +
>  5 files changed, 815 insertions(+)
>  create mode 100644 riscv/sbi-dbtr.c
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index a5738a5c..78fd6e2a 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -51,6 +51,7 @@ enum sbi_ext_id {
>  	SBI_EXT_SUSP = 0x53555350,
>  	SBI_EXT_FWFT = 0x46574654,
>  	SBI_EXT_SSE = 0x535345,
> +	SBI_EXT_DBTR = 0x44425452,
>  };
>  
>  enum sbi_ext_base_fid {
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 11e68eae..55c7ac93 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -20,6 +20,7 @@ all: $(tests)
>  $(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-asm.o
>  $(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-fwft.o
>  $(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-sse.o
> +$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-dbtr.o
>  
>  all_deps += $($(TEST_DIR)/sbi-deps)
>  
> diff --git a/riscv/sbi-dbtr.c b/riscv/sbi-dbtr.c
> new file mode 100644
> index 00000000..a4bfa41e
> --- /dev/null
> +++ b/riscv/sbi-dbtr.c
> @@ -0,0 +1,811 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * SBI DBTR testsuite
> + *
> + * Copyright (C) 2025, Rivos Inc., Jesse Taube <jesse@rivosinc.com>
> + */
> +
> +#include <asm/io.h>
> +#include <bitops.h>
> +#include <asm/processor.h>
> +
> +#include "sbi-tests.h"

Still missing at least libcflat.h (report_*). I'm not a big fan of
libcflat.h (a collection of random stuff...), but until somebody
gets around to dividing it up correctly, then pretty much every
unit test file will need it.

> +
> +#define SBI_DBTR_SHMEM_INVALID_ADDR	(-1UL)

I was going to complain that my suggestion to use get_invalid_addr() was
ignored, but now I see that SBI_DBTR_SHMEM_INVALID_ADDR isn't used at all?

Thanks,
drew

