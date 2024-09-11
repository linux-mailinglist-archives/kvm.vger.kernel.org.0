Return-Path: <kvm+bounces-26552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D81975771
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1000B1C2367C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BCB619CC31;
	Wed, 11 Sep 2024 15:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uQIX1L3i"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7FC18C930
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726069568; cv=none; b=F5751WPVJehhjqwj6G9eXIMt5nLkRD1dF18m1rePvHYMTO494r9egxBNyoGVP6fGB7mJ+0Xn9j00Ksqs3wljvJhAwMP+NPaTB54BeDOGEvs2KDE6Vy++KBWl0kxfQzZv9nIWKrO5n72ql7SEYWsFSI2cIuxrkTjOYpsf1RFHQvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726069568; c=relaxed/simple;
	bh=58koDVYY3cfvDInlGTWcdqHvUp36AhhYJQ3irOMwUcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCw1Ng4apfAC3nZTjTlwNG8P9BRoL0DLi/KOvT8uzzACCSMciwF7/JIgiVunEkDZQ8L2wykJ8k3WjnCzA+I1RHtqLhKMPPeqxGoEgJY71VV+tpr1qIq06k4qRHx+A9unEYp8yh60+1ZI/RxSHy/WRoK3yFk3QQQaXX1OuY7ixJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uQIX1L3i; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Sep 2024 17:45:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726069563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zwdrlyJt4ssUxLJdqSrq1xQqheFEj4MHzHNkkesSuTo=;
	b=uQIX1L3iB1pgfNNK5Ej3GABpW+1pf3cT3dJkmCE/ueaj277YatJEjFH07ot1i6mUetK7JJ
	fAeY0KTBQpl+mVPnzkqukRtYpE+Q7EAFkHhUVryOPFbUnrx/DzStkOxW3pJ8AMTiiPuxUM
	vSayh3QVpOq8GbAJFwIsuEI2j1S+soc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v3 1/2] riscv: sbi: Add HSM extension
 functions
Message-ID: <20240911-595775a85e53a6fd92bdf707@orel>
References: <20240910151536.163830-1-jamestiotio@gmail.com>
 <20240910151536.163830-2-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910151536.163830-2-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 10, 2024 at 11:15:35PM GMT, James Raphael Tiovalen wrote:
> Add helper functions to perform hart-related operations to prepare for
> the HSM tests. Also add the HSM state IDs and default suspend type
> constants.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/sbi.h | 17 +++++++++++++++++
>  lib/riscv/sbi.c     | 10 ++++++++++
>  riscv/sbi.c         |  5 +++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index e032444d..1319439b 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -49,6 +49,21 @@ enum sbi_ext_ipi_fid {
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
> @@ -67,6 +82,8 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  
>  void sbi_shutdown(void);
>  struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
> +struct sbiret sbi_hart_stop(void);
> +struct sbiret sbi_hart_get_status(unsigned long hartid);
>  struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base);
>  struct sbiret sbi_send_ipi_cpu(int cpu);
>  struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index ecc63acd..8972e765 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -42,6 +42,16 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
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
> index f88bf700..c9fbd6db 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -73,6 +73,11 @@ static phys_addr_t get_highest_addr(void)
>  	return highest_end - 1;
>  }
>  
> +static struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
> +{
> +	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
> +}
> +

This hunk needs to be moved to the next patch since the build will
otherwise fail due to the function being unused. We want each commit
to build in order to maintain bisectability. You may want to test
your series with something like

 ./configure --arch=riscv64 --cross-prefix=riscv64-linux-gnu-
 git rebase -x 'make' <some-base-commit>

Also we should put sbi_hart_suspend() directly under sbi_dbcn_write_byte()
in order to keep all the sbi_ecall wrappers grouped together.

Thanks,
drew

