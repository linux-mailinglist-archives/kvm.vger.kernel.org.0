Return-Path: <kvm+bounces-30948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35EF29BE865
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 13:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C311FB244B8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55411E5005;
	Wed,  6 Nov 2024 12:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DG2HgHLb"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FD41E22E4
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 12:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895813; cv=none; b=VlAziG3IIb+YBJcc0a0VXnwt694Z+rEGEgSuO73TVOZ2S4MV/+d2NTQgM6mb4dNyV0ShDOPz6cdYjoev3zZ+vhyG5XbSmsRF+JnXell+NQBYSK2rVlTY0zIzWZ7Pc8LCKHgFTz9CVKbEhNU1R+npDpcDU90I+3PXOQ5VobfFSlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895813; c=relaxed/simple;
	bh=wcT3c+jNGTe6rmf+KIO1hlh93vr4UdI5cOeokw+RtYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+ho/hWRXk4LUUvKgxYFOLgI0QUOUAdnTBwFPtURlq7t0grpU7MWqlhiVU18CRXO4M+TVGq/wPjTBD2WvkLfBLp6oBp3GC1WJh/i1GBnaTN+zTQTHq0iMaB+ndufefdddUjWGT+LeKeEGYfVEXgHDLZFNAdIeyMiDoyuMRfXjT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DG2HgHLb; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 13:23:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730895807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8kOdqy9VzxDkzXyDu6uQoam/yGtaIEnjGZzotQ9YlyA=;
	b=DG2HgHLb4eA7pT2+otAtNYuwHTpU3pEoGJRF3E6hInJNCNqXNevGnpQxZB6OQMar+rre2Q
	Q1/tA3V7HQ9UheOZuPDMbW2VH56F1DUu/nus+21Uib9kFzU+QC4OWt3CfRVRdKAHjd4W9H
	bfx7Aeb8WMM7MlsfRVusVT0BPJWB1pI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 2/3] riscv: sbi: Clean up env checking
Message-ID: <20241106-91c3a0bb34b7a6611fa7fd27@orel>
References: <20241024124101.73405-5-andrew.jones@linux.dev>
 <20241024124101.73405-7-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024124101.73405-7-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 24, 2024 at 02:41:04PM +0200, Andrew Jones wrote:
> Add a couple helpers to cleanup checking of test configuration
> environment variables.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  riscv/sbi.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index d46befa1c6c1..1e7314ec8d98 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -74,6 +74,20 @@ static phys_addr_t get_highest_addr(void)
>  	return highest_end - 1;
>  }
>  
> +static bool env_enabled(const char *env)
> +{
> +	char *s = getenv(env);
> +
> +	return s && (*s == '1' || *s == 'y' || *s == 'Y');
> +}
> +
> +static bool env_disabled(const char *env)
> +{
> +	char *s = getenv(env);
> +
> +	return !(s && (*s == '0' || *s == 'n' || *s == 'N'));
> +}

I've dropped env_disabled() since what I really want is !env_enabled()

> +
>  static bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {
> @@ -348,7 +362,6 @@ static void check_dbcn(void)
>  	bool highmem_supported = true;
>  	phys_addr_t paddr;
>  	struct sbiret ret;
> -	const char *tmp;
>  	char *buf;
>  
>  	report_prefix_push("dbcn");
> @@ -371,13 +384,11 @@ static void check_dbcn(void)
>  	dbcn_write_test(&buf[PAGE_SIZE - num_bytes / 2], num_bytes, false);
>  	report_prefix_pop();
>  
> -	tmp = getenv("SBI_HIGHMEM_NOT_SUPPORTED");
> -	if (tmp && atol(tmp) != 0)
> +	if (env_enabled("SBI_HIGHMEM_NOT_SUPPORTED"))
>  		highmem_supported = false;
>  
>  	report_prefix_push("high boundary");
> -	tmp = getenv("SBI_DBCN_SKIP_HIGH_BOUNDARY");
> -	if (!tmp || atol(tmp) == 0)
> +	if (env_disabled("SBI_DBCN_SKIP_HIGH_BOUNDARY"))
>  		dbcn_high_write_test(DBCN_WRITE_TEST_STRING, num_bytes,
>  				     HIGH_ADDR_BOUNDARY - PAGE_SIZE, PAGE_SIZE - num_bytes / 2,
>  				     highmem_supported);
> @@ -386,12 +397,8 @@ static void check_dbcn(void)
>  	report_prefix_pop();
>  
>  	report_prefix_push("high page");
> -	tmp = getenv("SBI_DBCN_SKIP_HIGH_PAGE");
> -	if (!tmp || atol(tmp) == 0) {
> -		paddr = HIGH_ADDR_BOUNDARY;
> -		tmp = getenv("HIGH_PAGE");
> -		if (tmp)
> -			paddr = strtoull(tmp, NULL, 0);
> +	if (env_disabled("SBI_DBCN_SKIP_HIGH_PAGE")) {
> +		paddr = getenv("HIGH_PAGE") ? strtoull(getenv("HIGH_PAGE"), NULL, 0) : HIGH_ADDR_BOUNDARY;
>  		dbcn_high_write_test(DBCN_WRITE_TEST_STRING, num_bytes, paddr, 0, highmem_supported);
>  	} else {
>  		report_skip("user disabled");
> @@ -400,8 +407,7 @@ static void check_dbcn(void)
>  
>  	/* Bytes are read from memory and written to the console */
>  	report_prefix_push("invalid parameter");
> -	tmp = getenv("INVALID_ADDR_AUTO");
> -	if (tmp && atol(tmp) == 1) {
> +	if (env_enabled("INVALID_ADDR_AUTO")) {
>  		paddr = get_highest_addr() + 1;
>  		do_invalid_addr = true;
>  	} else if (env_or_skip("INVALID_ADDR")) {
> -- 
> 2.47.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

