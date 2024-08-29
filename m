Return-Path: <kvm+bounces-25382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5612964AE2
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 18:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81D402881D5
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF4F19885D;
	Thu, 29 Aug 2024 16:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CfrrftqK"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E9F1B3749
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724947241; cv=none; b=eImqv2X3n5JQcmLE15es1ZsJ2EccCosvrgbkdMGkcFrz2OSOBXWPjgaWS2vOVuWLYN6C/BpqD8JXxWmnfnVfbPLTvVCV2C+I0EbmzeBY06cMlXID4OM9IC9LQwfqm1U2wuRzV4uv5/uRDEh6oRzvb4HdAxAKkKzl+I2wGS64D7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724947241; c=relaxed/simple;
	bh=9JHYMVIc9Cu/nFbvq+Ogf+hfJg1zsWcCgKicvIbWUMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7avyP9kIEh+QCMI+vtLwQTV1TwEaDR4KZcTspAJO1fK4kw3aVoigbdjUtstIkxH5HBt5KwTya1Okojd43UiRen0O47pw+rl1TpPcqo8HXvtyaDYW7HbNzb6tKWU4KYTD/IgjXM1OoUB2OStgulV0CTNWc7Kaco8eSOWvBBL1uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CfrrftqK; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 29 Aug 2024 18:00:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724947237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0rWikQVnNVqsvYzWEE1hdncdjr+jNRxpDhNDln7lIt0=;
	b=CfrrftqK8Hn6vivryFU8QlAtHUHPlvidDJ0GwDGZYLjxSBGUMlkvKr/hkaoR80FHvfNSMo
	apcA+Mqmu4fYZbVuyMqSE/0I/nxQVlwgDtNOz0pg02tqULfIgCP+utk+8rp9SmwbZRO4Qp
	eSMm50/MTnuTb6Q5k8Y/OXefFC69efg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v2 4/4] riscv: sbi: Add tests for HSM
 extension
Message-ID: <20240829-0f48e6c15a505fbb9fa1bae2@orel>
References: <20240825170824.107467-1-jamestiotio@gmail.com>
 <20240825170824.107467-5-jamestiotio@gmail.com>
 <20240829-8860b495f7e50336fd8a2b90@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829-8860b495f7e50336fd8a2b90@orel>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 29, 2024 at 03:30:26PM GMT, Andrew Jones wrote:
> On Mon, Aug 26, 2024 at 01:08:24AM GMT, James Raphael Tiovalen wrote:
...
> > +.section .data
> > +.balign PAGE_SIZE
> > +.global sbi_hsm_hart_start_checks
> > +sbi_hsm_hart_start_checks:			.space CONFIG_NR_CPUS
> > +.global sbi_hsm_non_retentive_hart_suspend_checks
> > +sbi_hsm_non_retentive_hart_suspend_checks:	.space CONFIG_NR_CPUS
> > +.global sbi_hsm_stop_hart
> > +sbi_hsm_stop_hart:				.space CONFIG_NR_CPUS
> 
> I don't think it should be necessary to create these arrays in assembly.
> We should be able to make global arrays in C in riscv/sbi.c and still
> access them from the assembly as you've done.
> 
> CONFIG_NR_CPUS will support all possible cpuids, but hartids have their
> own range and the code above is indexing these arrays by hartid. Since
> we should be able to define the arrays in C, then we could also either
> 
>  1) assert that max_hartid + 1 <= NR_CPUS
>  2) dynamically allocate the arrays using max_hartid + 1 for the size
>     and then assign global variables the physical addresses of those
>     allocated regions to use in the assembly
> 
> (1) is probably good enough

Actually we have to do (1) unless we want to open a big can of worms
because we're currently shoehorning hartids into cpumasks, but cpumasks
are based on NR_CPUS for size. To do it right, we should have hartmasks,
but they may be very large and/or sparse.

> 
> Seems on-cpus is missing an API for "all, but ...". How about, as a
> separate patch, adding
> 
>  void on_cpus_async(cpumask_t *mask, void (*func)(void *data), void *data)
> 
> to lib/on-cpus.c
> 
> Then here you'd copy the present mask to your own mask and clear 'me' from
> it for an 'all present, but me' mask.

I'll write a patch for on_cpus_async() now.

> but, instead, let's provide the following (untested) function in lib/riscv/sbi.c
> 
>    struct sbiret sbi_send_ipi_cpumask(cpumask_t *mask)
>    {
>         struct sbiret ret;
> 
> 	for (int i = 0; i < CPUMASK_NR_LONGS; ++i) {
> 	    if (cpumask_bits(mask)[i]) {
> 	       ret = sbi_send_ipi(cpumask_bits(mask)[i], i * BITS_PER_LONG);
> 	       if (ret.error)
> 	          break;
> 	    }
> 	}
> 
> 	return ret;
>    }
>

I'll write a patch adding this now too.

Thanks,
drew

