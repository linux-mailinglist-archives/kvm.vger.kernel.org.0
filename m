Return-Path: <kvm+bounces-32435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77BA09D85B1
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BE5F289E3C
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8991A7060;
	Mon, 25 Nov 2024 12:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VCoh3TlD"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2727C1714AC
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 12:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732539358; cv=none; b=c6SNZ+DDXjKN3deNavzhFuBmovRLXnGLXZDQq8H0n8lVtu2oD8Lb/rD2bZSFwBI9ldQq/gxtSbjqmfBUVNDHdWxDHSb29yLQz67rLqMIz0XvTf6bqw7ibZXE5AWQZv83pyIafQPCUv7/sanFzuxH4L3vvs+8W0mP+NsKbJcnleI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732539358; c=relaxed/simple;
	bh=H9uJuzWBKxkujHB+bWBGAA+4Qx38yeHWZZU3Werv6jA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxK7tp6qS4DIN65tPMYTlT/2YjApUFGTHyk0xPyxRdVpf6MDkPZhwqNU06OkIcfSqXDNZGicTgeh+hZeqXfVKHc63UpxtY0ogzrCvS3IWop1em/tCBAJCvbowMIOsnJ2RIiZ63I4lBSw/FHu/NDTqkO4fZ33FJWlRfle2jBLcyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VCoh3TlD; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 25 Nov 2024 13:55:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732539354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2mKzCRMitBFDXr2GLM3ChCasW/6X9tcwnLQEyG4tD3k=;
	b=VCoh3TlD9mQd4efg25BSoCUF1i1e6EWL9OJI5k1DZIrlZmxMd5cC7qn5rRUokFKonLfbKC
	uwl4oxj/HdZHuqMOKQBkrTN3BXJF1CVzzt+VOwtjp3E3pBKm3ZGgTDq9AAS0DsmlppNnD3
	KWNfh/FwkQu3JNoEDhTq0tVFIgS7Os0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/4] riscv: lib: Add SBI SSE extension
 definitions
Message-ID: <20241125-0453a5f28f22c185bbabb1dd@orel>
References: <20241125115452.1255745-1-cleger@rivosinc.com>
 <20241125115452.1255745-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241125115452.1255745-3-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 25, 2024 at 12:54:46PM +0100, Clément Léger wrote:
> Add SBI SSE extension definitions in sbi.h
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  lib/riscv/asm/sbi.h | 83 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 83 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 98a9b097..f2494a50 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -11,6 +11,11 @@
>  #define SBI_ERR_ALREADY_AVAILABLE	-6
>  #define SBI_ERR_ALREADY_STARTED		-7
>  #define SBI_ERR_ALREADY_STOPPED		-8
> +#define SBI_ERR_NO_SHMEM		-9
> +#define SBI_ERR_INVALID_STATE		-10
> +#define SBI_ERR_BAD_RANGE		-11
> +#define SBI_ERR_TIMEOUT			-12
> +#define SBI_ERR_IO			-13
>  
>  #ifndef __ASSEMBLY__
>  #include <cpumask.h>
> @@ -23,6 +28,7 @@ enum sbi_ext_id {
>  	SBI_EXT_SRST = 0x53525354,
>  	SBI_EXT_DBCN = 0x4442434E,
>  	SBI_EXT_SUSP = 0x53555350,
> +	SBI_EXT_SSE = 0x535345,
>  };
>  
>  enum sbi_ext_base_fid {
> @@ -71,6 +77,83 @@ enum sbi_ext_dbcn_fid {
>  	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
>  };
>  
> +enum sbi_ext_ss_fid {
                ^ sse

> +	SBI_EXT_SSE_READ_ATTRS = 0,
> +	SBI_EXT_SSE_WRITE_ATTRS,
> +	SBI_EXT_SSE_REGISTER,
> +	SBI_EXT_SSE_UNREGISTER,
> +	SBI_EXT_SSE_ENABLE,
> +	SBI_EXT_SSE_DISABLE,
> +	SBI_EXT_SSE_COMPLETE,
> +	SBI_EXT_SSE_INJECT,
> +	SBI_EXT_SSE_HART_UNMASK,
> +	SBI_EXT_SSE_HART_MASK,
> +};
> +
> +/* SBI SSE Event Attributes. */
> +enum sbi_sse_attr_id {
> +	SBI_SSE_ATTR_STATUS		= 0x00000000,
> +	SBI_SSE_ATTR_PRIORITY		= 0x00000001,
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
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP	BIT(0)
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPIE	BIT(1)
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV	BIT(2)
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP	BIT(3)
> +
> +enum sbi_sse_state {
> +	SBI_SSE_STATE_UNUSED		= 0,
> +	SBI_SSE_STATE_REGISTERED	= 1,
> +	SBI_SSE_STATE_ENABLED		= 2,
> +	SBI_SSE_STATE_RUNNING		= 3,
> +};
> +
> +/* SBI SSE Event IDs. */
> +#define SBI_SSE_EVENT_LOCAL_RAS			0x00000000
> +#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP		0x00000001
> +#define SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
> +
> +#define SBI_SSE_EVENT_GLOBAL_RAS		0x00008000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x0000c000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x0000ffff
> +
> +#define SBI_SSE_EVENT_LOCAL_PMU			0x00010000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
> +
> +#define SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00024000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00027fff
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0002c000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0002ffff
> +
> +#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
> +#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_3_START	0xffffc000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_3_END		0xffffffff
> +
> +#define SBI_SSE_EVENT_PLATFORM_BIT		(1 << 14)
> +#define SBI_SSE_EVENT_GLOBAL_BIT		(1 << 15)
> +
>  struct sbiret {
>  	long error;
>  	long value;
> -- 
> 2.45.2
>

Otherwise looks good.

Thanks,
drew

