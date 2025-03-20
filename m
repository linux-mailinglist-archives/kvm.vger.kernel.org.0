Return-Path: <kvm+bounces-41558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB623A6A776
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 514B81B616C4
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00088204F85;
	Thu, 20 Mar 2025 13:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f/mFItOA"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B41322E
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 13:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477793; cv=none; b=TTrWBW0wYASVKBZoQSw4bYPWd2jDkDfaINcuV+QVUUR2WVB6d/a2lWMu+4gGNsqWAwfGs+3y1soZNSCq9C47ORQcs6vKmtV4Ev6Mf32Tr82CcDcf8Z4pFPJu8JRmccKqTAYiO95tcVyBWFFlRIlvfomlJxr4QJK94opN2GiJT54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477793; c=relaxed/simple;
	bh=r6CMR7lNItIYMUfNuupmKDN6y6+Nhy0lWknkKKLseZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D07xDFqcpmzJ0wfE9bGxUmXYwdlnjRh1zS62VmzLQthW3OnynatrzZB3V8RsDSRthkk4SFWro/W0olq5VqUEKYVid/whgOKVo9vRN1EDxI5Lx+GT74HVaymcdHQedHVr4j8mBB5EWdq5SWBNWr6D4z/51cCPmxvt+08aF7Dlxr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f/mFItOA; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Mar 2025 14:36:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742477789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aEuneCpX2PcaS+tZZlfKCHOTfh8n4va050LvywoLtyg=;
	b=f/mFItOAunYnk5+Nw7Jy39RL+QuZJCsxRL0zzpIN4jIagh3XHT/eS8/SBHMOyogSqEKNTa
	EjEGon+wABUQ9tbMnhfc03YG9Gzf9HEpdqLRWePrjKMiBSoFiz7L2oxTEdtnhCGiHLxtUV
	f59ESLWZpVZQgwJk/n8hyBHtmldDL6M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v11 3/8] riscv: Use asm-offsets to
 generate SBI_EXT_HSM values
Message-ID: <20250320-3db2b32593ec175998ef03b8@orel>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
 <20250317164655.1120015-4-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317164655.1120015-4-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 05:46:48PM +0100, Clément Léger wrote:
> Replace hardcoded values with generated ones using sbi-asm-offset. This
> allows to directly use ASM_SBI_EXT_HSM and ASM_SBI_EXT_HSM_STOP in
> assembly.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  riscv/Makefile          |  2 +-
>  riscv/sbi-asm.S         |  6 ++++--
>  riscv/sbi-asm-offsets.c | 11 +++++++++++
>  riscv/.gitignore        |  1 +
>  4 files changed, 17 insertions(+), 3 deletions(-)
>  create mode 100644 riscv/sbi-asm-offsets.c
>  create mode 100644 riscv/.gitignore
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index ae9cf02a..02d2ac39 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -87,7 +87,7 @@ CFLAGS += -ffreestanding
>  CFLAGS += -O2
>  CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
>  
> -asm-offsets = lib/riscv/asm-offsets.h
> +asm-offsets = lib/riscv/asm-offsets.h riscv/sbi-asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
>  
>  .PRECIOUS: %.aux.o
> diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
> index f4185496..51f46efd 100644
> --- a/riscv/sbi-asm.S
> +++ b/riscv/sbi-asm.S
> @@ -6,6 +6,8 @@
>   */
>  #include <asm/asm.h>
>  #include <asm/csr.h>
> +#include <asm/asm-offsets.h>
> +#include <generated/sbi-asm-offsets.h>

Doing this causes sbi-asm.o to depend on generated files, so I had to add
the change below to the Makefile in order for 'make -j' to work.

Thanks,
drew


diff --git a/riscv/Makefile b/riscv/Makefile
index 02d2ac392f11..e4dba6772377 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -19,6 +19,8 @@ all: $(tests)

 $(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o $(TEST_DIR)/sbi-fwft.o

+all_deps += $($(TEST_DIR)/sbi-deps)
+
 # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
 $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1

@@ -134,7 +136,7 @@ else
 endif

 generated-files = $(asm-offsets)
-$(tests:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
+$(tests:.$(exe)=.o) $(cstart.o) $(cflatobjs) $(all_deps): $(generated-files)

 arch_clean: asm_offsets_clean
        $(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} \

>  
>  #include "sbi-tests.h"
>  
> @@ -57,8 +59,8 @@ sbi_hsm_check:
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
> index 00000000..bd37b6a2
> --- /dev/null
> +++ b/riscv/sbi-asm-offsets.c
> @@ -0,0 +1,11 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <kbuild.h>
> +#include <asm/sbi.h>
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
> 2.47.2
> 

