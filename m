Return-Path: <kvm+bounces-23838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FC894EB81
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 12:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EFF51F21AD1
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 10:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09ED0170A29;
	Mon, 12 Aug 2024 10:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NladPl+p"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93439166F29
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 10:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723460116; cv=none; b=SWSs/nlxOP8uahDOAZ89xyewOzQR7Co4hqhKdecBaj7mVn+AjqYiVg/NPztu9LLa0ddZQqhxYoB/sNf5OPfHO8Egq2YESdcDmV/HgRmit0gUg0mizAwikg7bPf2X4O6yRFvt+xbACkRS/a/ih7gOem7uav447VeyO9ON2P5Zm1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723460116; c=relaxed/simple;
	bh=CMOKPDx1ptG5dR+3PhI5aORMs6UqHT9WHIYv/sAQEZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iF3l5cswacPpxHsYe6uCWs6Mi+KtmStJE1BdZC5tNM7XwQL6nuU2s3py5h/xlkBClwylOzCtkjEJEbrDB4AT87KFHJVOpuPWMuWHsFNlAuPUopzoR1DX3qJDuNqXiz9oxa88lGDOWBhaF76K94whOAShIAeBzOkT9qwrXD6MxQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NladPl+p; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Aug 2024 12:55:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723460111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qQEtspD+2TidJBqqSgQZ1fimD2NfpPEgEj3eIv6FpIE=;
	b=NladPl+pSl/I+42l3tCew2OXYWXKAcYeiNVm+kSw/f+7tXlfvhStPMeCOIj8tekvX1U7RL
	B4UkfZb3EyTuVRRH/GE99YWWawB/C8QxriD/vwd43WzrHDGmIqMG/9L+IcoM1u/sUXpHNO
	bWIhk7+OxQbKbJoTEHME/TuPJoLx3tA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH 1/3] riscv: sbi: Add IPI extension support
Message-ID: <20240812-2ba194fcf113cf3307173f3c@orel>
References: <20240810175744.166503-1-jamestiotio@gmail.com>
 <20240810175744.166503-2-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240810175744.166503-2-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 11, 2024 at 01:57:42AM GMT, James Raphael Tiovalen wrote:
> Add IPI EID and FID constants and a helper function to perform the IPI
> SBI ecall.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/sbi.h | 5 +++++
>  riscv/sbi.c         | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 73ab5438..6b485dd3 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -17,6 +17,7 @@
>  enum sbi_ext_id {
>  	SBI_EXT_BASE = 0x10,
>  	SBI_EXT_TIME = 0x54494d45,
> +	SBI_EXT_IPI = 0x735049,
>  	SBI_EXT_HSM = 0x48534d,
>  	SBI_EXT_SRST = 0x53525354,
>  };
> @@ -42,6 +43,10 @@ enum sbi_ext_time_fid {
>  	SBI_EXT_TIME_SET_TIMER = 0,
>  };
>  
> +enum sbi_ext_ipi_fid {
> +	SBI_EXT_IPI_SEND_IPI = 0,
> +};
> +
>  struct sbiret {
>  	long error;
>  	long value;
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 2438c497..08bd6a95 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -32,6 +32,11 @@ static struct sbiret __time_sbi_ecall(unsigned long stime_value)
>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>  }
>  
> +static struct sbiret __ipi_sbi_ecall(unsigned long hart_mask, unsigned long hart_mask_base)
> +{
> +	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI, hart_mask, hart_mask_base, 0, 0, 0, 0);
> +}

This will likely come in handy for other tests. Let's add it with the name
sbi_send_ipi() to lib/riscv/sbi.c instead.

Thanks,
drew

> +
>  static bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

