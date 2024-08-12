Return-Path: <kvm+bounces-23839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73F3E94EB8C
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 12:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25C821F21E10
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 10:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798CD170A30;
	Mon, 12 Aug 2024 10:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tyDtffvU"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41E216F0E6
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 10:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723460315; cv=none; b=khsHJwepuoLj0sG5v6GZWw5EAleUa91corHiC73ITxvdOGrUDRApDYccn1RMcqC5xe36B0fL52QKdWhG6Sv9qjiB7OfiCC1X3Gk/hF6F65rH9xumSSIp2SjVS5fTv/IC+wpU2IgkOSFs4cYdD1JMfJZinC5Kikv1g582SRTIWmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723460315; c=relaxed/simple;
	bh=UM0akxUYcQl1elspfvzQIx4oT29DeGGY32O3C4AAPUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7LlkyZ8VcodcMh0g4i6wcyMN683UdIweN/gt61Y0it2Av2Pch1lt5vBWwUv4flPicbxOrmsfbRVEh0g04DZvs0AX23dHwXhAVDgR3u3QsK38izHpfGGdgX85MGi9xy9kJwh6dXWEI7Q1f3kuyPgUTrjuVde5Pi3SNQUmOiDv+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tyDtffvU; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Aug 2024 12:58:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723460310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3O20DJNgU/F2jf7Ggg2t218ULXrMsc+XSZD1tw9Vis=;
	b=tyDtffvUC8N0L2DSRwfW3BgTgKDrsWVbUCgjupq2lm26UoklADSI32mYQwRVi4sAC622Ei
	jfi5OcGFWhJeJFMhkqf3rLobWZOVl1oqZEMF7COPYqvNG+UeS7BlQaRcoYXVWQTg8JPnUO
	zd9p3kUEXBwWAETDKO0tBwL+IXdBrNA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH 2/3] riscv: sbi: Add HSM extension
 functions
Message-ID: <20240812-849b12c320b1064dc95c485c@orel>
References: <20240810175744.166503-1-jamestiotio@gmail.com>
 <20240810175744.166503-3-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240810175744.166503-3-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 11, 2024 at 01:57:43AM GMT, James Raphael Tiovalen wrote:
> Add helper functions to perform hart-related operations to prepare for
> the HSM tests. Also add the HSM state IDs and default suspend type
> constants.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/sbi.h | 18 ++++++++++++++++++
>  lib/riscv/sbi.c     | 15 +++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 6b485dd3..5cebc4d9 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -47,6 +47,21 @@ enum sbi_ext_ipi_fid {
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
>  struct sbiret {
>  	long error;
>  	long value;
> @@ -59,6 +74,9 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  
>  void sbi_shutdown(void);
>  struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
> +struct sbiret sbi_hart_stop(void);
> +struct sbiret sbi_hart_get_status(unsigned long hartid);
> +struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque);
>  long sbi_probe(int ext);
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 3d4236e5..a5c18450 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -39,6 +39,21 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
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
> +struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
> +{
> +	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
> +}

Let's put sbi_hart_suspend in riscv/sbi.c for now. I can't think of why
that would useful outside of the HSM tests. stop and get-status are good
to have in the library though.

Thanks,
drew

> +
>  long sbi_probe(int ext)
>  {
>  	struct sbiret ret;
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

