Return-Path: <kvm+bounces-51559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9BC2AF8BE7
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:36:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 164AD564490
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBA729DB61;
	Fri,  4 Jul 2025 08:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O/KeGp18"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD1829B78C
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 08:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751617597; cv=none; b=gXeLe5RUwdZScMl1GI7LMPk3r4DWSqsuUVbInqxdqMlJagCpmvN8Dmd3pPngohJqhWK4Ki5PxbFhT2wo+pIWe+cMSyuQNmkzS9/k4jh7kmAjk4Fs6KX3P83FJ2YTLJidokbdPrcZ1naRMxVf8ga4pWFWyMVUp3jblGHgQT+s7WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751617597; c=relaxed/simple;
	bh=/9FK+7EehWZ8tfWC27v015RMwFUn1bNC926w4K4cOUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5e+JRCbEvUu0uXNOodDgg6vNQmQ4QXoNGXMoT3Das+sOiPwytu75j+q381PYmrfGVurjDwtGiuFu1x1IpXMx9GkwSwxstVktaqhZajxURg7F4J0xnhIgzd8Cfr3O8dd+RCABifKXHoW+Gyg7woTziDGl5Z4jswZaOKsMTuoBRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O/KeGp18; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 4 Jul 2025 10:26:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751617582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BLuiC3GK+gBvNhBFSKYbY6othCmyRdGRrBJ98b0dw2g=;
	b=O/KeGp18sv8U3Wmy1pNjriUFJ4BC0DT1Oy4toWt8ZaSSRugTLk8eYxb9ib8a/0X8+ORC96
	vOL53MvzvpprNrxEisYnpILjJGsEU/qmzD9pDV3cNqXY1ZH1KhdXDRov0PfT66tAAUBHkK
	3hcFcu0FMwtFvH/zG8Gv+D4EvmZS9fM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jesse Taube <jesse@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Charlie Jenkins <charlie@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH] riscv: Use norvc over arch, -c
Message-ID: <20250704-d34a50590233beaf67e66044@orel>
References: <20250704015837.1700249-1-jesse@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250704015837.1700249-1-jesse@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 03, 2025 at 06:58:37PM -0700, Jesse Taube wrote:
> The Linux kernel main tree uses "norvc" over
> "arch, -c" change to match this.
> 
> GCC 15 started to add _zca_zcd to the assembler flags causing a bug
> which made "arch, -c" generate a compressed instruction.
> 
> Link: https://sourceware.org/bugzilla/show_bug.cgi?id=33128
> Cc: Clément Léger <cleger@rivosinc.com>
> Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> ---
>  riscv/isa-dbltrp.c | 2 +-
>  riscv/sbi-dbtr.c   | 2 +-
>  riscv/sbi-fwft.c   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/riscv/isa-dbltrp.c b/riscv/isa-dbltrp.c
> index b7e21589..af12860c 100644
> --- a/riscv/isa-dbltrp.c
> +++ b/riscv/isa-dbltrp.c
> @@ -26,7 +26,7 @@ do {										\
>  	unsigned long value = 0;						\
>  	asm volatile(								\
>  	"	.option push\n"							\
> -	"	.option arch,-c\n"						\
> +	"	.option norvc\n"						\
>  	"	sw %0, 0(%1)\n"							\
>  	"	.option pop\n"							\
>  	: : "r" (value), "r" (ptr) : "memory");					\
> diff --git a/riscv/sbi-dbtr.c b/riscv/sbi-dbtr.c
> index c4ccd81d..129f79b8 100644
> --- a/riscv/sbi-dbtr.c
> +++ b/riscv/sbi-dbtr.c
> @@ -134,7 +134,7 @@ static __attribute__((naked)) void exec_call(void)
>  {
>  	/* skip over nop when triggered instead of ret. */
>  	asm volatile (".option push\n"
> -		      ".option arch, -c\n"
> +		      ".option norvc\n"
>  		      "nop\n"
>  		      "ret\n"
>  		      ".option pop\n");
> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> index 8920bcb5..fda7eb52 100644
> --- a/riscv/sbi-fwft.c
> +++ b/riscv/sbi-fwft.c
> @@ -174,7 +174,7 @@ static void fwft_check_misaligned_exc_deleg(void)
>  		 * Disable compression so the lw takes exactly 4 bytes and thus
>  		 * can be skipped reliably from the exception handler.
>  		 */
> -		".option arch,-c\n"
> +		".option norvc\n"
>  		"lw %[val], 1(%[val_addr])\n"
>  		".option pop\n"
>  		: [val] "+r" (ret.value)
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

Merged. Thanks

