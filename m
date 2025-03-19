Return-Path: <kvm+bounces-41503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 68127A69691
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 18:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5C8B7A735C
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5F8204F8D;
	Wed, 19 Mar 2025 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MNZ2ReFM"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F2F204879
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742405523; cv=none; b=mBJFpSElqob9/t02GwiHTy40nmL22/aWdYlFZ+abQOlcft/okavxZ0Z93ISeorkpsra/XLvcZvD2C6N0KNC0GFLk+Nf4NL/RLjUWtuBLlYkG/DkjsRAFFYv8omlHqSKp8pMUeQh95brY9G7Pe4oo/zFT8HnpTnSMiQo+Ft8rMxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742405523; c=relaxed/simple;
	bh=JS4AbVhBY7TV/52Wihuhrjwsa+yjjHvOvqxSmsbbynU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MY8kzstS8vI10uS92M9MZBQLNVwPHCFqEMWNj3vC9S4FEAowajNuYXAcYKRS62jN74uSeiKszF3HmBzqUix6RmNM/xAjHYkiPb0/9E8jaF5LOp8bxLpwkAbjVfB4vY4hJohy2Bq79AuPIEANt/YMgSAzoq+ojiLRBaNEWGex8Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MNZ2ReFM; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 19 Mar 2025 18:31:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742405518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z2pqXA/0SlPrspqJJaHSGdI17Q8kctLaPstjxatkNlU=;
	b=MNZ2ReFMY8kfunRXE+pcnZTr3t+U9sdt7uz6cjy52DGzH4JjpAjcc1GkfYzuIQRTnAR8j9
	yeJp8P0rYRZOI6310FTREa34E5hbi9RhSxlkq49R3qoBapQardJ1LDBxk91Z9iVJDIMZU8
	Swe2sefwPL1GKOb8A9tW8xmOdBrwdgQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v11 4/8] lib: riscv: Add functions for
 version checking
Message-ID: <20250319-7ce04ed29661af987303b215@orel>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
 <20250317164655.1120015-5-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317164655.1120015-5-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 05:46:49PM +0100, Clément Léger wrote:
> Version checking was done using some custom hardcoded values, backport a
> few SBI function and defines from Linux to do that cleanly.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  lib/riscv/asm/sbi.h | 15 +++++++++++++++
>  lib/riscv/sbi.c     |  9 +++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 2f4d91ef..ee9d6e50 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -18,6 +18,13 @@
>  #define SBI_ERR_IO			-13
>  #define SBI_ERR_DENIED_LOCKED		-14
>  
> +/* SBI spec version fields */
> +#define SBI_SPEC_VERSION_MAJOR_SHIFT	24
> +#define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
> +#define SBI_SPEC_VERSION_MINOR_MASK	0xffffff
> +#define SBI_SPEC_VERSION_MASK		((SBI_SPEC_VERSION_MAJOR_MASK << SBI_SPEC_VERSION_MAJOR_SHIFT) | \
> +					SBI_SPEC_VERSION_MINOR_MASK)
                                       ^ needs one more space
> +
>  #ifndef __ASSEMBLER__
>  #include <cpumask.h>
>  
> @@ -110,6 +117,13 @@ struct sbiret {
>  	long value;
>  };
>  
> +/* Make SBI version */

Unnecessary comment, it's the same as the function name.

> +static inline unsigned long sbi_mk_version(unsigned long major, unsigned long minor)
> +{
> +	return ((major & SBI_SPEC_VERSION_MAJOR_MASK) << SBI_SPEC_VERSION_MAJOR_SHIFT)
> +		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
> +}
> +
>  struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  			unsigned long arg1, unsigned long arg2,
>  			unsigned long arg3, unsigned long arg4,
> @@ -124,6 +138,7 @@ struct sbiret sbi_send_ipi_cpu(int cpu);
>  struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
>  struct sbiret sbi_send_ipi_broadcast(void);
>  struct sbiret sbi_set_timer(unsigned long stime_value);
> +struct sbiret sbi_get_spec_version(void);
>  long sbi_probe(int ext);
>  
>  #endif /* !__ASSEMBLER__ */
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 02dd338c..9d4eb541 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -107,12 +107,17 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>  }
>  
> +struct sbiret sbi_get_spec_version(void)
> +{
> +	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
> +}
> +
>  long sbi_probe(int ext)
>  {
>  	struct sbiret ret;
>  
> -	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
> -	assert(!ret.error && (ret.value & 0x7ffffffful) >= 2);
> +	ret = sbi_get_spec_version();
> +	assert(!ret.error && (ret.value & SBI_SPEC_VERSION_MASK) >= sbi_mk_version(0, 2));
>  
>  	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
>  	assert(!ret.error);
> -- 
> 2.47.2
>

I fixed those two things up while applying.

Thanks,
drew

