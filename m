Return-Path: <kvm+bounces-7722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A6F845B62
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16AAC1C29E4D
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B15962166;
	Thu,  1 Feb 2024 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GC1aR+1n"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1786214D
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706801091; cv=none; b=F6VlkdQGWH9YyqlCpFGmC7DMyqzGe/mEPYNlJJ5vF2gmqRDuxLfpDrRL2MP7e1dxb39NGhj4vGefzlzSjvXkD99CYNlKRiulKuPvSGb0Hcg6OM/x6/g/aSCpLStKU4uJXoNn+4PxH0Fs25YWmJlcGg64WZmnxO4XJRN830Mtsyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706801091; c=relaxed/simple;
	bh=XUnkRVzXP0J5ztlCEqt0Jnkrx//imaYicJF9DMcPF5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TqdM/lRAD6e242/IOE/2u6TeKG6v0HS8EVRntWCW4GqZ01LSHkZjW9JiLy6VJPaom9ZAuVvxKN5eWre+JOnrZw9nK8f8g0EPxWFdnWaHmql3JfAKoS6Jmbgg+TBv5LWKUSKSwndHHnZriL/qY2DYTL3x5yHq1Lj440lrazddrb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GC1aR+1n; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 1 Feb 2024 16:24:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706801086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DNm/YSjEI3MHXj9mUdpdM+XLsKI+Mq5SAxRsrNRS2Io=;
	b=GC1aR+1n1SJMv8BfpOpsQDW1BIY8gPn5PsZ+8oWcco2nAdGypgeJtlgtUnyBIO1HR3Y2s5
	jYUp+y/L5hHBUKK0YEtUUINb996KusIrZsss9FNpNK4mdgGHscTE5ioUO7RDHzeDzTzAEY
	ieb1HZlKAPeI+dVu69ORuJCgE770j0U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com, 
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 08/24] riscv: Add riscv32 support
Message-ID: <20240201-89bb062a591a3a65313f4cba@orel>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-34-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126142324.66674-34-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 26, 2024 at 03:23:33PM +0100, Andrew Jones wrote:
...
> diff --git a/lib/ldiv32.c b/lib/ldiv32.c
> index 897a4b9cd39e..9ce2a6a1faf0 100644
> --- a/lib/ldiv32.c
> +++ b/lib/ldiv32.c
> @@ -1,5 +1,21 @@
>  #include <stdint.h>
>  
> +#if __riscv_xlen == 32
> +int __clzdi2(unsigned long);
> +
> +int __clzdi2(unsigned long a)
> +{
> +	int n = 0;
> +
> +	while (a) {
> +		++n;
> +		a >>= 1;
> +	}
> +
> +	return 32 - n;
> +}
> +#endif
> +

On riscv32, when attempting to do printf("%llx\n", x), where x is a 64-bit
type, I found a bug with the above. It turns out that despite [1] stating
that __clzdi2() takes an unsigned long, libgcc code which generates calls
to it expect it to take an unsigned long long. I've fixed this for v3 by
renaming the above function to __clzsi2() and adding

 int __clzdi2(uint64_t num)
 {
     return num >> 32 ? __clzsi2(num >> 32) : __clzsi2(num) + 32;
 }

[1] https://gcc.gnu.org/onlinedocs/gccint/Integer-library-routines.html

Thanks,
drew

