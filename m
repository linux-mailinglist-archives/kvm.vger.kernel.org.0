Return-Path: <kvm+bounces-32368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C555D9D61B7
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 17:06:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1964BB22EC4
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 16:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C450C1DDA32;
	Fri, 22 Nov 2024 16:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="loK7lUdF"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D5E2E3EE
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732291585; cv=none; b=p89kVyaicLFSeDSaRHZbKrOKTWn4U9VsTLGtz/LGeLFdBpwURKyUOYTZemMg9yjLjEHoo5BTePuuDxzJgNqy+KMxKhri/sVpwQ3ajAnTHzjnAX/YiuAXAnt2KYP6GcK8LJpsOMltSWKlThIWH84+hcgZBS08rzxLxvAbGfstgVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732291585; c=relaxed/simple;
	bh=8t/6cSMjaOuStiJQoCpD2HnmWHqeECzGJPwKbisehZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1lB5JY6Idlhcw74PIhFU2oQSold9K19c4U6LyzwRT0HA3tGO3sNDclFUCwvIM6HKGT/krnSOlT89L0VRfVeYnlTD4ayb1qCp0FU1TfLubuXLWgEPKGbgjrYGuLnZ26KvSnBsDwSQuySGKj4GWp9gyckY6F/W+O3a3nSUAbbo+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=loK7lUdF; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 22 Nov 2024 17:05:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732291579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNorr4eDP8eaKbqCRxA1eHmjQQT+uQ9qL/NNapgP1CY=;
	b=loK7lUdFlgAPZCy3braYFts1Pq8fvGeFmyBtxdJRHgH423yHqznUh2a3r2DTD5bWom1BuG
	VNxMiOkGCWGnslGPglGheNLMfQOSZmEdJuHo4+dLR/g7juZHziHjveT9k1b97mhTWYaBVb
	TFxR2enJAfntyxKifFbVJEdFFWoQlDI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/3] riscv: lib: Add SBI SSE extension
 definitions
Message-ID: <20241122-1e45023d7cf30ca9885f7872@orel>
References: <20241122140459.566306-1-cleger@rivosinc.com>
 <20241122140459.566306-2-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241122140459.566306-2-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 22, 2024 at 03:04:55PM +0100, Clément Léger wrote:
> Add SBI SSE extension definitions in sbi.h
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  lib/riscv/asm/sbi.h | 76 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 98a9b097..96100bc2 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -11,6 +11,9 @@
>  #define SBI_ERR_ALREADY_AVAILABLE	-6
>  #define SBI_ERR_ALREADY_STARTED		-7
>  #define SBI_ERR_ALREADY_STOPPED		-8
> +#define SBI_ERR_NO_SHMEM		-9
> +#define SBI_ERR_INVALID_STATE		-10
> +#define SBI_ERR_BAD_RANGE		-11

Might as well add SBI_ERR_TIMEOUT and SBI_ERR_IO now too.

>  
>  #ifndef __ASSEMBLY__
>  #include <cpumask.h>
> @@ -23,6 +26,7 @@ enum sbi_ext_id {
>  	SBI_EXT_SRST = 0x53525354,
>  	SBI_EXT_DBCN = 0x4442434E,
>  	SBI_EXT_SUSP = 0x53555350,
> +	SBI_EXT_SSE = 0x535345,
>  };
>  
>  enum sbi_ext_base_fid {
> @@ -71,6 +75,78 @@ enum sbi_ext_dbcn_fid {
>  	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
>  };
>  
> +/* SBI Function IDs for SSE extension */
> +#define SBI_EXT_SSE_READ_ATTR		0x00000000
> +#define SBI_EXT_SSE_WRITE_ATTR		0x00000001

These are named with an 'S' on the end in the spec, e.g.
sbi_sse_read_attrs. Let's add the S here to to be consistent.

> +#define SBI_EXT_SSE_REGISTER		0x00000002
> +#define SBI_EXT_SSE_UNREGISTER		0x00000003
> +#define SBI_EXT_SSE_ENABLE		0x00000004
> +#define SBI_EXT_SSE_DISABLE		0x00000005
> +#define SBI_EXT_SSE_COMPLETE		0x00000006
> +#define SBI_EXT_SSE_INJECT		0x00000007

What about sbi_sse_hart_unmask and sbi_sse_hart_mask?

The function IDs can be enums like the other extensions define them,
unless they need to be used in assembly. But, if they need to be used
in assembly then they should be outside the '#ifndef __ASSEMBLY__'

> +
> +/* SBI SSE Event Attributes. */
> +enum sbi_sse_attr_id {
> +	SBI_SSE_ATTR_STATUS		= 0x00000000,
> +	SBI_SSE_ATTR_PRIO		= 0x00000001,

SBI_SSE_ATTR_PRIORITY

> +	SBI_SSE_ATTR_CONFIG		= 0x00000002,
> +	SBI_SSE_ATTR_PREFERRED_HART	= 0x00000003,
> +	SBI_SSE_ATTR_ENTRY_PC		= 0x00000004,
> +	SBI_SSE_ATTR_ENTRY_ARG		= 0x00000005,
> +	SBI_SSE_ATTR_INTERRUPTED_SEPC	= 0x00000006,
> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS	= 0x00000007,
> +	SBI_SSE_ATTR_INTERRUPTED_A6	= 0x00000008,
> +	SBI_SSE_ATTR_INTERRUPTED_A7	= 0x00000009,
> +};
> +
> +#define SBI_SSE_ATTR_STATUS_STATE_OFFSET	0
> +#define SBI_SSE_ATTR_STATUS_STATE_MASK		0x3
> +#define SBI_SSE_ATTR_STATUS_PENDING_OFFSET	2
> +#define SBI_SSE_ATTR_STATUS_INJECT_OFFSET	3
> +
> +#define SBI_SSE_ATTR_CONFIG_ONESHOT	(1 << 0)
> +
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_STATUS_SPP	BIT(0)
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_STATUS_SPIE	BIT(1)

s/STATUS/SSTATUS/

> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV	BIT(2)
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP	BIT(3)
> +
> +enum sbi_sse_state {
> +	SBI_SSE_STATE_UNUSED     = 0,
> +	SBI_SSE_STATE_REGISTERED = 1,
> +	SBI_SSE_STATE_ENABLED    = 2,
> +	SBI_SSE_STATE_RUNNING    = 3,

Searching for tabs I see an unexpected lack of them above between
the enums and the ='s and also...

> +};
> +
> +/* SBI SSE Event IDs. */
> +#define SBI_SSE_EVENT_LOCAL_RAS			0x00000000

Missing LOCAL_DOUBLE_TRAP

> +#define	SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
> +#define SBI_SSE_EVENT_GLOBAL_RAS		0x00008000
> +#define	SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x00004000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x00007fff

copy+paste error, global platform specific events are 0xc000 - 0xffff

> +
> +#define SBI_SSE_EVENT_LOCAL_PMU			0x00010000
> +#define	SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
> +#define	SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
> +
> +#define	SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00024000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00027fff
> +#define	SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0002c000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0002ffff
> +
> +#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
> +#define	SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
> +#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
> +#define	SBI_SSE_EVENT_GLOBAL_PLAT_3_START	0xffffc000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_3_END		0xffffffff

...unexpected tabs between the #define and the symbol name in
several of the above definitions.

> +
> +#define SBI_SSE_EVENT_GLOBAL_BIT		(1 << 15)
> +#define SBI_SSE_EVENT_PLATFORM_BIT		(1 << 14)

Let's put these in numeric order like the spec has them, i.e.

  #define SBI_SSE_EVENT_PLATFORM_BIT		(1 << 14)
  #define SBI_SSE_EVENT_GLOBAL_BIT		(1 << 15)

> +
>  struct sbiret {
>  	long error;
>  	long value;
> -- 
> 2.45.2
>

Thanks,
drew

