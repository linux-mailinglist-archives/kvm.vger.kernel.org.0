Return-Path: <kvm+bounces-30947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 246CA9BE83F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 13:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFE141F2200B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B721DF998;
	Wed,  6 Nov 2024 12:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NRP7kIx2"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEB11DF740
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 12:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895762; cv=none; b=Pcarb+Xjr4sXY+FBkgXaIk3llBh+qzWSkdtm1Q2ITbSxILSs6fOBrHto7YZ1IVb6JSLluPSYCGnF4x23EQcCx7vGTLFT0qBWep0j5CizZrytXR+CoyJiGPS4F55sz8CA1sNhmOLVg/7TKmCfUx8rOXzQ2dTrJdk/cSz93GpXEQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895762; c=relaxed/simple;
	bh=LyySVVRvkQAroiXXmCxdnkRwGb8pMPzSex8f3OQ7zFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbc7bRP58u4qmcRzBE6H1pl+dZS0YSDK7kzp5Ki8Gz/yO+H6LKpd5Zrb+b4KLlW7WXqeiwGbangsrfcw7v2IwV9Jyh2tSNnwDwZAHAvwKaNRZMMK3FxWEqpa2Eq4Hmhoc4RRY6m7++8P/pg4f5Dn74NocfkIDJwNGX4iLxgpL2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NRP7kIx2; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 13:22:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730895756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9LJ/byH+TE2QOe/LTi1hwN2NlyjwVEV1qLmtrG07yaI=;
	b=NRP7kIx2s4ASrAZMW8AALEFWYQYvXioTe+OHOzAtAIlGN9N4Xv0xpJgfnJ01BR3LzE92Or
	Vx6kXaCbtjIWSLnFdZpIkSOSN7TFqDFqaR3UtQdyNfEpAChJx+4dVgnF/RKqAYvwrz2YBb
	RdDoQLDAvQwroEoiXSM+jFmkRIAVGVI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: cade.richard@gmail.com, atishp@rivosinc.com, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] riscv: sbi: Add two in hart_mask
 IPI test
Message-ID: <20241106-7a94a002553733a6983389a0@orel>
References: <20241106113814.42992-5-andrew.jones@linux.dev>
 <20241106113814.42992-8-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106113814.42992-8-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 12:38:18PM +0100, Andrew Jones wrote:
> We should ensure that when hart_mask has more than one hartid
> that both harts get IPIs with a single call of the IPI function.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  riscv/sbi.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index cdf8d13cc9cf..8ccdf42f902a 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -364,10 +364,11 @@ static void check_ipi(void)
>  	int nr_cpus_present = cpumask_weight(&cpu_present_mask);
>  	int me = smp_processor_id();
>  	unsigned long max_hartid = 0;
> +	unsigned long hartid1, hartid2;
>  	cpumask_t ipi_receivers;
>  	static prng_state ps;
>  	struct sbiret ret;
> -	int cpu;
> +	int cpu, cpu2;
>  
>  	ps = prng_init(0xDEADBEEF);
>  
> @@ -398,6 +399,42 @@ static void check_ipi(void)
>  	ipi_hart_check(&ipi_receivers);
>  	report_prefix_pop();
>  
> +	report_prefix_push("two in hart_mask");
> +
> +	if (nr_cpus_present < 3) {
> +		report_skip("3 cpus required");
> +		goto end_two;
> +	}
> +
> +	cpu = rand_online_cpu(&ps);
> +	hartid1 = cpus[cpu].hartid;
> +	hartid2 = 0;
> +	for_each_present_cpu(cpu2) {
> +		if (cpu2 == cpu || cpu2 == me)
> +			continue;
> +		hartid2 = cpus[cpu2].hartid;
> +		if (__builtin_labs(hartid2 - hartid1) < BITS_PER_LONG)

clang is complaining about these __builtin_labs calls not taking signed
input. I'll add this wrapper

 static long __labs(long a)
 {
    return __builtin_labs(a);
 }

> +			break;
> +	}
> +	if (cpu2 == nr_cpus) {
> +		report_skip("hartids are too sparse");
> +		goto end_two;
> +	}
> +
> +	cpumask_clear(&ipi_done);
> +	cpumask_clear(&ipi_receivers);
> +	cpumask_set_cpu(cpu, &ipi_receivers);
> +	cpumask_set_cpu(cpu2, &ipi_receivers);
> +	on_cpu_async(cpu, ipi_hart_wait, (void *)d);
> +	on_cpu_async(cpu2, ipi_hart_wait, (void *)d);
> +	ret = sbi_send_ipi((1UL << __builtin_labs(hartid2 - hartid1)) | 1UL, hartid1 < hartid2 ? hartid1 : hartid2);
> +	report(ret.error == SBI_SUCCESS, "ipi returned success");
> +	while (!cpumask_equal(&ipi_done, &ipi_receivers))
> +		cpu_relax();
> +	ipi_hart_check(&ipi_receivers);
> +end_two:
> +	report_prefix_pop();
> +
>  	report_prefix_push("broadcast");
>  	cpumask_clear(&ipi_done);
>  	cpumask_copy(&ipi_receivers, &cpu_present_mask);
> -- 
> 2.47.0
> 

