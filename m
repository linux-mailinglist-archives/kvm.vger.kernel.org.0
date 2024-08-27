Return-Path: <kvm+bounces-25185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DCBF9614AD
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 18:54:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8452FB23D75
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 16:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FA81CEAC9;
	Tue, 27 Aug 2024 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A7F6ETYL"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBAD1CE6F7
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 16:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724777623; cv=none; b=OA4zLHRB2joW43sabptL5jsifEY4f1Yl9wh8A8b+HSGMqbOVUgFXQ76XohqyHfR9j/aykmyyRi5RFoNgLskoEluKM8zxQCXIIPIHPEswRPBa2ifJ1jdU9WXS0Et7Eu3EOQh/kMRfVRx8mQIeXwBZ6MwMa5zy6+HB+GudWDxEvfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724777623; c=relaxed/simple;
	bh=Ur3im3g0CtKUghKbUdIk+oQfKxGMFaRvsQ5zkF9aMfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MH54W2hJAgZwmRbtgbnssYgIimCwDZgAy2MtSj1TGVpIhajs98kNiYUZKaRz697ySM99DzPEnV6mAcdaFFgiqN5Hvk0OKriuyh2k/6PMApxk3pf2Jhzwvsbihns3Qs/sgKVvGpDDR+vmShuomD5mVjHjAiqdngR6dWbOADSVA9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A7F6ETYL; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 27 Aug 2024 18:53:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724777618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E/7vLlobYUKupCqbRx6f8nXrjFOpHy/3fF88p1dv2Gw=;
	b=A7F6ETYLmF9peVmZpLzkI6hDmNf9gNswcek/VYjDAVzi8nhVYFpioMp2Zlgmv4rLtwIDl0
	4KTpL/Sq5n6EDZdCQCxSZ9g+nRQjZXwVLLnt+v+PCOXKwMG6ah/DH85J6C/o5MOwFJPHTx
	1cP60k6vjCm8kS7sch99KWQh5wM9L2k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v2 2/4] riscv: sbi: Add IPI extension
 support
Message-ID: <20240827-4fcdc699204019ca47d3e5cd@orel>
References: <20240825170824.107467-1-jamestiotio@gmail.com>
 <20240825170824.107467-3-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240825170824.107467-3-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 26, 2024 at 01:08:22AM GMT, James Raphael Tiovalen wrote:
> Add IPI EID and FID constants and a helper function to perform the IPI
> SBI ecall.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/sbi.h | 6 ++++++
>  lib/riscv/sbi.c     | 5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 47e91025..a864e268 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -17,6 +17,7 @@
>  enum sbi_ext_id {
>  	SBI_EXT_BASE = 0x10,
>  	SBI_EXT_TIME = 0x54494d45,
> +	SBI_EXT_IPI = 0x735049,
>  	SBI_EXT_HSM = 0x48534d,
>  	SBI_EXT_SRST = 0x53525354,
>  	SBI_EXT_DBCN = 0x4442434E,
> @@ -43,6 +44,10 @@ enum sbi_ext_time_fid {
>  	SBI_EXT_TIME_SET_TIMER = 0,
>  };
>  
> +enum sbi_ext_ipi_fid {
> +	SBI_EXT_IPI_SEND_IPI = 0,
> +};
> +
>  enum sbi_ext_dbcn_fid {
>  	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
>  	SBI_EXT_DBCN_CONSOLE_READ,
> @@ -61,6 +66,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  
>  void sbi_shutdown(void);
>  struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
> +struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base);
>  long sbi_probe(int ext);
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 3d4236e5..19d58ab7 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -39,6 +39,11 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
>  	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_START, hartid, entry, sp, 0, 0, 0);
>  }
>  
> +struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base)
> +{
> +	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI, hart_mask, hart_mask_base, 0, 0, 0, 0);
> +}
> +
>  long sbi_probe(int ext)
>  {
>  	struct sbiret ret;
> -- 
> 2.43.0
> 
>

Queued to riscv/sbi, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

