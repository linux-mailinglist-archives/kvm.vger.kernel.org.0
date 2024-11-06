Return-Path: <kvm+bounces-30862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05EE39BE021
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE3A71F24870
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6961F1D5148;
	Wed,  6 Nov 2024 08:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ELvIzerC"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123591CCB57
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730880944; cv=none; b=jQ/wIcIVEMmepjEy8CJ1q/fESla8MuoKQsax278zGi89kMVkMl/LIezPbh2Xd44IABdiYBU4Lbcl2KMetYPhHEj+qAfGLXNKvQUQ6GMvS//I7CDgkH/M3cI72DQCNVa3qLWCucwwUKsrBopBSqw+Z57Kq1LmYjNwwzuwzSuHWyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730880944; c=relaxed/simple;
	bh=8fw7y0ufn8alOZsJQrnBs1sftljzanf/bcsDxnTbGwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3cCOyuNF6fp3U3/vhZNG5gYd0z9OC9bkQ5gVsK0bepm3BJXVwLjFvt+M+IDLhugTwV3knP5pr5EtDJGUWxbuI+SN/K3bPWBYeO/OtQf0WG92g9DNy6dt/n8fCAWXMgQu7UbtrYt3HD7axrco3XKsKwuivlseVoDPjvkvtz2W+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ELvIzerC; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 09:15:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730880939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hsMaYv3m940tgneEsZ4pQ4oYPa/rPcIiKpYEeNTsRWM=;
	b=ELvIzerC2NVng7M43243GE/8DSEqmW2a+EAbWgbzN2PQ0HfGxLoY2/IcrqQ7Ra3ps1PH1B
	vAO6IG/COlXOp9cBqPh/vK61M0FhZAobVaN4Xmnpmpm+La+p56buTAFZb4W86aeOQ7fhoW
	Suk8jgQTCmqxDYlqKcrQlWi/NemGTE8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com, jamestiotio@gmail.com, alexandru.elisei@arm.com, 
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/3] lib/on-cpus: Add barrier after
 func call
Message-ID: <20241106-9611aa66dfd52197b3b00e96@orel>
References: <20241031123948.320652-5-andrew.jones@linux.dev>
 <20241031123948.320652-7-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031123948.320652-7-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 31, 2024 at 01:39:51PM +0100, Andrew Jones wrote:
> It's reasonable for users of on_cpu() and on_cpumask() to assume
> they can read data that 'func' has written when the call completes.
> Ensure the caller doesn't observe a completion (target cpus are again
> idle) without also being able to observe any writes which were made
> by func(). Do so by adding barriers to implement the following
> 
>  target-cpu                                   calling-cpu
>  ----------                                   -----------
>  func() /* store something */                 /* wait for target to be idle */
>  smp_wmb();                                   smp_rmb();
>  set_cpu_idle(smp_processor_id(), true);      /* load what func() stored */
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

I added a

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>

to this patch.

> ---
>  lib/on-cpus.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/on-cpus.c b/lib/on-cpus.c
> index f6072117fa1b..356f284be61b 100644
> --- a/lib/on-cpus.c
> +++ b/lib/on-cpus.c
> @@ -79,6 +79,7 @@ void do_idle(void)
>  			smp_wait_for_event();
>  		smp_rmb();
>  		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
> +		smp_wmb(); /* pairs with the smp_rmb() in on_cpu() and on_cpumask() */
>  	}
>  }
>  
> @@ -145,12 +146,14 @@ void on_cpumask(const cpumask_t *mask, void (*func)(void *data), void *data)
>  		smp_wait_for_event();
>  	for_each_cpu(cpu, mask)
>  		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
> +	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
>  }
>  
>  void on_cpu(int cpu, void (*func)(void *data), void *data)
>  {
>  	on_cpu_async(cpu, func, data);
>  	cpu_wait(cpu);
> +	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
>  }
>  
>  void on_cpus(void (*func)(void *data), void *data)
> -- 
> 2.47.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

