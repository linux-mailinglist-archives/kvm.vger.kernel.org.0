Return-Path: <kvm+bounces-25748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C365596A0EE
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F9521F234D4
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 14:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294CE13E025;
	Tue,  3 Sep 2024 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JUj0nQuh"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0571F937
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725374600; cv=none; b=pHOGRDq1hSLK7FYDWLOGsLNpdcdzzwB1/EbQVIv3Lw2cAFW2+T1nO6hgjVzUzPC3tOmGBUurJyUv/TbcaJD6KQu4XAWfg9juyXqyl5MKr59qTXjgcOchDhFMcxsK1ljs03seO345jY2OcaHT5ulGFioF0KLB2Sh9l8y2d6ltz3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725374600; c=relaxed/simple;
	bh=DlOtRS5f8QiAzlHOI7VKfM2I22tVQijMn0pvqimrFEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tT3IfxxYnpoGfo9ckdVgYhptEHM6wUh9pkBg54/1uFEjJ9IWVsn9OdBRV90jKSRbE/MhG5IhqVcD0ggQYAy+wWqVBJVtYE6hR+z5ARpvkmOVe2ZqMZ05OMzrm57HD0izLCq9DDtU6AJbMGyrljyjjt/GlagzmkvApPjTgIc1VUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JUj0nQuh; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Sep 2024 16:43:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725374596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z+Ovm4b8TI2LMcwdXGcHalIl9anarI/kKfCVj3C1F30=;
	b=JUj0nQuhgqVctRYyMBxF7Sd9z/uVabwZLIcMA+oofx7lySIUOXbnVRCznBxbBBwx2VepIf
	1Or4MEvsfeyND4f2H1v5xKRQb8203WMlvx3y9mwzLNnQ1lP5zySzhzGepH/zsgf1MWZQGl
	F9QCWrFQOqM52/A9N8xTE5AyY1G3GO0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH] riscv: Make NR_CPUS configurable
Message-ID: <20240903-cb3f09205bf9cc9906e32024@orel>
References: <20240820170150.377580-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820170150.377580-2-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 20, 2024 at 07:01:51PM GMT, Andrew Jones wrote:
> Unit tests would like to go nuts with the number of harts in order
> to help shake out issues with hart number assumptions. Rather than
> set a huge number that will only be used when a platform supports
> a huge number or when QEMU is told to exceed the recommended
> number of vcpus, make the number configurable. However, we do bump
> the default from 16 to 2*xlen since we would like to always force
> kvm-unit-tests to use cpumasks with more than one word in order to
> ensure that code stays maintained.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  configure             | 8 ++++++++
>  lib/riscv/asm/setup.h | 3 ++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/configure b/configure
> index 27ae9cc89657..6a8d6239a3cb 100755
> --- a/configure
> +++ b/configure
> @@ -77,6 +77,8 @@ usage() {
>  	                           Specify the page size (translation granule). PAGE_SIZE can be
>  	                           4k [default], 16k, 64k for arm64.
>  	                           4k [default], 64k for ppc64.
> +	    --max-cpus=MAX_CPUS
> +	                           Specify the maximum number of CPUs supported. (riscv64 only)
>  	    --earlycon=EARLYCON
>  	                           Specify the UART name, type and address (optional, arm and
>  	                           arm64 only). The specified address will overwrite the UART
> @@ -168,6 +170,9 @@ while [[ "$1" = -* ]]; do
>  	--page-size)
>  	    page_size="$arg"
>  	    ;;
> +	--max-cpus)
> +	    max_cpus="$arg"
> +	    ;;
>  	--earlycon)
>  	    earlycon="$arg"
>  	    ;;
> @@ -496,8 +501,11 @@ cat <<EOF >> lib/config.h
>  
>  EOF
>  elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
> +	[ -z $max_cpus ] && max_cpus='(__riscv_xlen * 2)'
> +
>  cat <<EOF >> lib/config.h
>  
> +#define CONFIG_NR_CPUS $max_cpus
>  #define CONFIG_UART_EARLY_BASE 0x10000000
>  
>  EOF
> diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
> index a13159bfe395..43b63c56d96f 100644
> --- a/lib/riscv/asm/setup.h
> +++ b/lib/riscv/asm/setup.h
> @@ -2,9 +2,10 @@
>  #ifndef _ASMRISCV_SETUP_H_
>  #define _ASMRISCV_SETUP_H_
>  #include <libcflat.h>
> +#include <config.h>
>  #include <asm/processor.h>
>  
> -#define NR_CPUS 16
> +#define NR_CPUS CONFIG_NR_CPUS
>  extern struct thread_info cpus[NR_CPUS];
>  extern int nr_cpus;
>  extern uint64_t timebase_frequency;
> -- 
> 2.45.2
>

I started having second thoughts about this approach since we'll have to
keep adding configure command line options for every CONFIG option. I
posted an alternative approach now [1] and CC'ed everyone since other
architectures should chime in on the approach too.

[1] https://lore.kernel.org/all/20240903143946.834864-4-andrew.jones@linux.dev/

Thanks,
drew

