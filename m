Return-Path: <kvm+bounces-41504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D448CA696AB
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 18:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A209F7A6360
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307181F5844;
	Wed, 19 Mar 2025 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cXZc7K/3"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC71D6DAD
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742405778; cv=none; b=ILjs0kyxKAWuN5DLTc8lxcy3A3VfINXL8uUUUv6lkeDL9di62zCgb5CjReHEcZwZxk6dHPl49Mj8oeTjx10mnYq+JSfsPEg1diqzPwOGBlH9VIxAlfg/WRXd8j0767papWT5+3eVEpIDMhUb7jsXpbjH/NhCDngf2GlNdrk5G5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742405778; c=relaxed/simple;
	bh=+Sb07lLXEfsD+WvHXblNw56cpR3oNDoxbEWMnQBwUUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYPdKptguomBizEobdI881pSnt5bTdc8RrB//2lAiu6uN3QubjVQ9g7rKueMIF6MDjujAeIZSRzPYMBgt4LKeTL9uKxvIC6X4U4+qsgf5mRd5zK1ArSYBXKwoh0LJJHthXMmhP3KKhFgWbS2IH0SQ/YB/CedQNXWk/s7v6nyT8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cXZc7K/3; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 19 Mar 2025 18:36:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742405773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ErWkhu1m3mOlbwmYksVgSmppKgKfD3xu4om11C7ZndA=;
	b=cXZc7K/3uRl2umO2QqWHI8wOEvg5I2uPhREU3yeRvj/OpimxjI1J+kpUvywK20JtmF3EqK
	Esemtcfm8jz8fhpxQ9B33uGdXvQEWYK3HTeoKmV8dN6gGTu8w/1peZKOUti+XhyjiwI4xA
	mOEO7gjaHylWW5QOWIwGbONz0IACwLE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v11 5/8] lib: riscv: Add functions to get
 implementer ID and version
Message-ID: <20250319-093901c8531b82e99d02ea8e@orel>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
 <20250317164655.1120015-6-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317164655.1120015-6-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 05:46:50PM +0100, Clément Léger wrote:
> These functions will be used by SSE tests to check for a specific OpenSBI
> version.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  lib/riscv/asm/sbi.h | 20 ++++++++++++++++++++
>  lib/riscv/sbi.c     | 20 ++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index ee9d6e50..90111628 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -18,6 +18,19 @@
>  #define SBI_ERR_IO			-13
>  #define SBI_ERR_DENIED_LOCKED		-14
>  
> +#define SBI_IMPL_BBL		0
> +#define SBI_IMPL_OPENSBI	1
> +#define SBI_IMPL_XVISOR		2
> +#define SBI_IMPL_KVM		3
> +#define SBI_IMPL_RUSTSBI	4
> +#define SBI_IMPL_DIOSIX		5
> +#define SBI_IMPL_COFFER		6
> +#define SBI_IMPL_XEN		7
> +#define SBI_IMPL_POLARFIRE_HSS	8
> +#define SBI_IMPL_COREBOOT	9
> +#define SBI_IMPL_OREBOOT	10
> +#define SBI_IMPL_BHYVE		11
> +
>  /* SBI spec version fields */
>  #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
>  #define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
> @@ -124,6 +137,11 @@ static inline unsigned long sbi_mk_version(unsigned long major, unsigned long mi
>  		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
>  }
>  
> +static inline unsigned long sbi_impl_opensbi_mk_version(unsigned long major, unsigned long minor)
> +{
> +	return (((major & 0xffff) << 16) | (minor & 0xffff));
> +}
> +
>  struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  			unsigned long arg1, unsigned long arg2,
>  			unsigned long arg3, unsigned long arg4,
> @@ -139,6 +157,8 @@ struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
>  struct sbiret sbi_send_ipi_broadcast(void);
>  struct sbiret sbi_set_timer(unsigned long stime_value);
>  struct sbiret sbi_get_spec_version(void);
> +unsigned long sbi_get_imp_version(void);
> +unsigned long sbi_get_imp_id(void);
>  long sbi_probe(int ext);
>  
>  #endif /* !__ASSEMBLER__ */
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 9d4eb541..ab032e3e 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -107,6 +107,26 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>  }
>  
> +unsigned long sbi_get_imp_version(void)
> +{
> +	struct sbiret ret;
> +
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0, 0, 0, 0, 0, 0);
> +	assert(!ret.error);
> +
> +	return ret.value;
> +}
> +
> +unsigned long sbi_get_imp_id(void)
> +{
> +	struct sbiret ret;
> +
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0, 0, 0, 0, 0, 0);
> +	assert(!ret.error);
> +
> +	return ret.value;
> +}
> +
>  struct sbiret sbi_get_spec_version(void)
>  {
>  	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
> -- 
> 2.47.2
>

LGTM

Thanks,
drew

