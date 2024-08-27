Return-Path: <kvm+bounces-25160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 379399611A5
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6984280361
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64E71C6F76;
	Tue, 27 Aug 2024 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ISfIDD4n"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ACF1BC9E3
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 15:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772110; cv=none; b=musZwhJRIwq8MEN16I5Ed2K5sNWFMweLSeb/ZJVBp8YDOmTasNtER61pYlCussF2KR1ZmIubN4iBjnm8v7TgmTNcSH2z6RTRzl5Wb9hrPr+F/F0kb6XiOpbYXdeHMX8IMbkbIdVslbAdX4yPsAURS+w5G6mSjzTTGHBCjs6WVkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772110; c=relaxed/simple;
	bh=bYaMM3eszBwrHtqpahAeuFJKrHvd9IBUxHPY4/5ZaTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjDt4GpIwc81+/n7KtD5+Rb62uW1ijr84xLaLegtmbAGcXPtZm2lN7a5tSzbffrvnoUkYt3HvyNC2yI7QgomngmasiDieH9oMGWiP+IV7oFs2t7BrlpIQUwt/tOpK8kTaVZ58fS108rMPqOgn/VKMWjYKnNHQkOAmcDozCZf2ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ISfIDD4n; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 27 Aug 2024 17:21:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724772105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LU6jFApvic+i5R9qZ5vGVMMp2K4vJOyoUg/JSjWQmHU=;
	b=ISfIDD4nZpigIHWp94WBgP3PnFsIO8aRBfNiGl2D7rOELr3SzwRiMJ6uDg7di4KZCyzjJg
	YPHEQduHhlHksKpyY8CSDOydd8ub6kvoXe2t5xTIXL/iPsCDoYWT1KQpJRs0biayys/tFF
	APLL5rVOfV7HBXEOeCqQDBJ771wPL34=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH] Changed cpumask_next to wrap instead of
 terminating after nr_cpus.
Message-ID: <20240827-a3f2014b839d6c39c110e15b@orel>
References: <20240826054038.11584-1-cade.richard@berkeley.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826054038.11584-1-cade.richard@berkeley.edu>
X-Migadu-Flow: FLOW_OUT


Patch summaries shouldn't have periods and they should be concise.

On Sun, Aug 25, 2024 at 10:40:38PM GMT, Cade Richard wrote:
> Changed cpumask_next() to wrap instead of terminating after nr_cpus.
> 
> Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
> ---
>  lib/cpumask.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/cpumask.h b/lib/cpumask.h
> index be191923..5105c3bd 100644
> --- a/lib/cpumask.h
> +++ b/lib/cpumask.h
> @@ -109,8 +109,10 @@ static inline void cpumask_copy(cpumask_t *dst, const cpumask_t *src)
>  
>  static inline int cpumask_next(int cpu, const cpumask_t *mask)
>  {
> -	while (++cpu < nr_cpus && !cpumask_test_cpu(cpu, mask))
> -		;
> +	do {
> +		if (++cpu > nr_cpus)

Should be ++cpu == nr_cpus, but...

> +			cpu = 0;
> +	} while (!cpumask_test_cpu(cpu, mask));

...this will break everything. See for_each_cpu().

Nack

drew

>  	return cpu;
>  }
>  
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

