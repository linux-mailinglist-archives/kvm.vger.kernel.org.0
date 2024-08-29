Return-Path: <kvm+bounces-25341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE3E9642C9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 13:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D7681C211F9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 11:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9863C19066C;
	Thu, 29 Aug 2024 11:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZlyIGBRC"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184E9189F36
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724930028; cv=none; b=EY4ZRUvCuJPJawxgTpPiUs0JvScmXHZQjYwNwYF2fQEeCxAx+xuXkuSQLVvGP+xMTds33HKTRmXf2CULzNZ2Gyu4SnSdOesol+7r1pvCEMOhJUSQgreUrjvilxN56yJwAOAff0smAWZiSurBFDDfWz219HMO3Jz45qHX/kwnWdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724930028; c=relaxed/simple;
	bh=DBj+GlsWx5EIi5nGfMBny3eBZz4pG1IHTstTNOdb0Uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFr3o47XadXFVinnihR5lZI1EO8ilWEIHsYkSHbpVZYxrKHN2V9foB8Ds2gcpaF1HHNkY42PvxiljUSKhb+ppkE+4TqdMGE+D5aaE3SnoSBGYMM9yKwOjOEd+A6Vp3VnCwLvFUORv2mUoVPg3CcP2UfVSri/ZEedED9zt1dZKSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZlyIGBRC; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 29 Aug 2024 13:13:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724930023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aKMxGIm2QMWbV0NRFrcfeNbTcE8KBhgmPXTiXUN2CYs=;
	b=ZlyIGBRC2I6HhXd4cNNNG2YhW5CXjHTjsTwfZpvCwNsiXoKW9976PhIxrnrgllJq3XLEyL
	EfoB/iK+cS1hEF/iXkAO+VFbdTE12Rm4YoBw7qKYijv9pC94aLAYU2btMLU8F1dIwzH4P/
	AfiCI54lv5SRoT2ZKNQ8oB6if+v7LVA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v2 3/4] riscv: sbi: Add HSM extension
 functions
Message-ID: <20240829-781224bb5723077bdeaae8c1@orel>
References: <20240825170824.107467-1-jamestiotio@gmail.com>
 <20240825170824.107467-4-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240825170824.107467-4-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 26, 2024 at 01:08:23AM GMT, James Raphael Tiovalen wrote:
> Add helper functions to perform hart-related operations to prepare for
> the HSM tests. Also add the HSM state IDs and default suspend type
> constants.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/sbi.h | 17 +++++++++++++++++
>  lib/riscv/sbi.c     | 10 ++++++++++
>  riscv/sbi.c         |  5 +++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index a864e268..4e48ceaa 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -48,6 +48,21 @@ enum sbi_ext_ipi_fid {
>  	SBI_EXT_IPI_SEND_IPI = 0,
>  };
>  
> +enum sbi_ext_hsm_sid {
> +	SBI_EXT_HSM_STARTED = 0,
> +	SBI_EXT_HSM_STOPPED,
> +	SBI_EXT_HSM_START_PENDING,
> +	SBI_EXT_HSM_STOP_PENDING,
> +	SBI_EXT_HSM_SUSPENDED,
> +	SBI_EXT_HSM_SUSPEND_PENDING,
> +	SBI_EXT_HSM_RESUME_PENDING,
> +};
> +
> +enum sbi_ext_hsm_hart_suspend_type {
> +	SBI_EXT_HSM_HART_SUSPEND_RETENTIVE = 0,
> +	SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE = 0x80000000,
> +};
> +
>  enum sbi_ext_dbcn_fid {
>  	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
>  	SBI_EXT_DBCN_CONSOLE_READ,
> @@ -66,6 +81,8 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  
>  void sbi_shutdown(void);
>  struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
> +struct sbiret sbi_hart_stop(void);
> +struct sbiret sbi_hart_get_status(unsigned long hartid);
>  struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base);
>  long sbi_probe(int ext);
>  
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 19d58ab7..256196b7 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -39,6 +39,16 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
>  	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_START, hartid, entry, sp, 0, 0, 0);
>  }
>  
> +struct sbiret sbi_hart_stop(void)
> +{
> +	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_STOP, 0, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_hart_get_status(unsigned long hartid)
> +{
> +	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_STATUS, hartid, 0, 0, 0, 0, 0);
> +}
> +
>  struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base)
>  {
>  	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI, hart_mask, hart_mask_base, 0, 0, 0, 0);
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 36ddfd48..6469304b 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -72,6 +72,11 @@ static phys_addr_t get_highest_addr(void)
>  	return highest_end - 1;
>  }
>  
> +static struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
> +{
> +	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
> +}
> +

Yeah, I think I prefer this naming to the __<ext>_sbi_ecall type of naming
we currently have in this file, particularly because if we decide to
promote an SBI call from the SBI tests to the riscv lib then we don't need
to go rename everything in the test too. I have another minor riscv/sbi.c
cleanup in mind too so I'll write a riscv/sbi cleanup series at some
point.

>  static bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

