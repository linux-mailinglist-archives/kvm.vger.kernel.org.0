Return-Path: <kvm+bounces-42768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98579A7C66F
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 735023B8329
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B571D7E47;
	Fri,  4 Apr 2025 22:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QRFDrlVX"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601D4AD58
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 22:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743806777; cv=none; b=MAYKBrDoPmbdRn+5vM+QjruNygML+aaGKw4h76aUTkFeF7EDWt7aNZlOuSGTJ/FueOwo6AQfS7EFOX2pTsQn83WY6K20zXhQDb/Jwk46nihRSj1R4LNkJ7NYkpSNdnKYvIri0wJlDFr1DMEM7ppu6GgyOSICr7EE076iTLfASLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743806777; c=relaxed/simple;
	bh=Q9/i3wbmROUc1yAY0nI7uO6WaZml7TPX/9qDKuqEQtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayHqQrTYx5rqj/zhqkFGpC5bPuF0OCXUA8aj0MluqfNAtOfc3Rh7P//RdehWKR+RyUOUD9HfhqD31gbD/hDdicGUowUxv7suMQR9hFn0W2qV8bSoR8nFS1c9olQzSqwvOntyeBYV5q3DYrcSelypboOE/EGBad5XWy2Wif8UmzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QRFDrlVX; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 4 Apr 2025 15:46:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743806772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=icbPkrkUd1De4/wRlfQxCHPa3ucnmbOW4BGuGjTGkgM=;
	b=QRFDrlVXyeKYm2auWsnzd21S31ggUiVTESz37sca/elBzIWiLNknM2FIh5SUSNnCRe54b0
	sjQO6yUYmITskjDTi/PpqBwTl26+n2loNJ8I11WPulIigWcmGzePbbUy9Cyk3amqBVg/6I
	BLVUr6+FIXMOnJxuxpCWz5b68q7rF50=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/2] KVM: selftests: arm64: Introduce and use
 hardware-definition macros
Message-ID: <Z_BhKUAgkLCdeWDB@linux.dev>
References: <20250404220659.1312465-1-rananta@google.com>
 <20250404220659.1312465-2-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404220659.1312465-2-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Raghu,

On Fri, Apr 04, 2025 at 10:06:58PM +0000, Raghavendra Rao Ananta wrote:
> The kvm selftest library for arm64 currently configures the hardware
> fields, such as shift and mask in the page-table entries and registers,
> directly with numbers. While it add comments at places, it's better to
> rewrite them with appropriate macros to improve the readability and
> reduce the risk of errors. Hence, introduce macros to define the
> hardware fields and use them in the arm64 processor library.
> 
> Most of the definitions are primary copied from the Linux's header,
> arch/arm64/include/asm/pgtable-hwdef.h.

Thank you for doing this. Having magic numbers all around the shop was a
complete mess. Just a single comment:

> No functional change intended.
> 
> Suggested-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/arch/arm64/include/asm/sysreg.h         | 38 +++++++++++++
>  .../selftests/kvm/arm64/page_fault_test.c     |  2 +-
>  .../selftests/kvm/include/arm64/processor.h   | 28 +++++++--
>  .../selftests/kvm/lib/arm64/processor.c       | 57 ++++++++++---------
>  4 files changed, 92 insertions(+), 33 deletions(-)
> 
> diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
> index 150416682e2c..6fcde168f3a6 100644
> --- a/tools/arch/arm64/include/asm/sysreg.h
> +++ b/tools/arch/arm64/include/asm/sysreg.h
> @@ -884,6 +884,44 @@
>  	 SCTLR_EL1_LSMAOE | SCTLR_EL1_nTLSMD | SCTLR_EL1_EIS   | \
>  	 SCTLR_EL1_TSCXT  | SCTLR_EL1_EOS)
>  
> +/* TCR_EL1 specific flags */
> +#define TCR_T0SZ_OFFSET	0
> +#define TCR_T0SZ(x)		((UL(64) - (x)) << TCR_T0SZ_OFFSET)
> +
> +#define TCR_IRGN0_SHIFT	8
> +#define TCR_IRGN0_MASK		(UL(3) << TCR_IRGN0_SHIFT)
> +#define TCR_IRGN0_NC		(UL(0) << TCR_IRGN0_SHIFT)
> +#define TCR_IRGN0_WBWA		(UL(1) << TCR_IRGN0_SHIFT)
> +#define TCR_IRGN0_WT		(UL(2) << TCR_IRGN0_SHIFT)
> +#define TCR_IRGN0_WBnWA	(UL(3) << TCR_IRGN0_SHIFT)
> +
> +#define TCR_ORGN0_SHIFT	10
> +#define TCR_ORGN0_MASK		(UL(3) << TCR_ORGN0_SHIFT)
> +#define TCR_ORGN0_NC		(UL(0) << TCR_ORGN0_SHIFT)
> +#define TCR_ORGN0_WBWA		(UL(1) << TCR_ORGN0_SHIFT)
> +#define TCR_ORGN0_WT		(UL(2) << TCR_ORGN0_SHIFT)
> +#define TCR_ORGN0_WBnWA	(UL(3) << TCR_ORGN0_SHIFT)
> +
> +#define TCR_SH0_SHIFT		12
> +#define TCR_SH0_MASK		(UL(3) << TCR_SH0_SHIFT)
> +#define TCR_SH0_INNER		(UL(3) << TCR_SH0_SHIFT)
> +
> +#define TCR_TG0_SHIFT		14
> +#define TCR_TG0_MASK		(UL(3) << TCR_TG0_SHIFT)
> +#define TCR_TG0_4K		(UL(0) << TCR_TG0_SHIFT)
> +#define TCR_TG0_64K		(UL(1) << TCR_TG0_SHIFT)
> +#define TCR_TG0_16K		(UL(2) << TCR_TG0_SHIFT)
> +
> +#define TCR_IPS_SHIFT		32
> +#define TCR_IPS_MASK		(UL(7) << TCR_IPS_SHIFT)
> +#define TCR_IPS_52_BITS	(UL(6) << TCR_IPS_SHIFT)
> +#define TCR_IPS_48_BITS	(UL(5) << TCR_IPS_SHIFT)
> +#define TCR_IPS_40_BITS	(UL(2) << TCR_IPS_SHIFT)
> +#define TCR_IPS_36_BITS	(UL(1) << TCR_IPS_SHIFT)
> +
> +#define TCR_HA			(UL(1) << 39)
> +#define TCR_DS			(UL(1) << 59)
> +

sysreg.h isn't the right home for these definitions since it is meant to
be a copy of the corresponding kernel header.

Since KVM selftests are likely the only thing in tools to care about
setting up page tables, adding this to processor.h seems like a better
place.

Thanks,
Oliver

