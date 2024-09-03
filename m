Return-Path: <kvm+bounces-25738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B7C969F1F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90F521C23D14
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 13:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286975684;
	Tue,  3 Sep 2024 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GcgKKjPz"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F891CA69D
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 13:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725370596; cv=none; b=oMXx6FbpXxhNz1f0ZbVb+egSeVsdRgfbNTVAkpxkUU/o9Tm3q1TdZJ8G8pxem1EZ79OAIu8KotFMe/kMPV6K8eWbKRrqEy3MqJH/SP6gLPGAqpAsNGjQStp0tWhlgvLVcT8e8X/L1A7ogflvaJ4XwobAeZWDznrDHL3NwXZTOT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725370596; c=relaxed/simple;
	bh=dLYSC5zV07QGj2bzjtdTw4GrhlRC2U9m9Im+nhIeFeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZneHLSb8gQUF6Ejd6FkJkz9N11NdOaKgVHFf7FSIlZDGO1ucPoWPhl7y37dJ6kIpNrKbTD1RbD++n+A+HLHsk/2ei6t7apaadV8ZQUXqhQH0ZcCAg621DXIP4beTrpfh2nKZrGzmjZqlHampqlGI3mpAtdqmEUGFUOLd+sr+l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GcgKKjPz; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Sep 2024 15:36:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725370591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bBbomYBOuYd8qiT2Kxo3dDIkplR5VW+QHX+MUe0IKak=;
	b=GcgKKjPzllS3qGXN2LudwuSeIXTPv/9SV8RFTPNHOu7eDeqoVXaYIcA5mjF/gHmbaQ/s3K
	ODaVVyXOOMUCaFAMv1OnABw6jAJubNRYAmVoM7LLhHpU7xgrs9sLIQgvP/pxHfl3e15sal
	f+8LOMKIZYNCa843ieMWO5TqonV0gtI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 1/3] riscv: Introduce local_timer_init
Message-ID: <20240903-2958c0abcdc35b2e8f14be7a@orel>
References: <20240828162200.1384696-5-andrew.jones@linux.dev>
 <20240828162200.1384696-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828162200.1384696-6-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 28, 2024 at 06:22:02PM GMT, Andrew Jones wrote:
> When Sstc is available make sure that even if we enable timer
> interrupts nothing will happen. This is necessary for cases where
> the unit tests actually intend to use the SBI TIME extension and
> aren't thinking about Sstc at all, like the SBI TIME test in
> riscv/sbi where we can now remove the initialization.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/riscv/asm/timer.h |  1 +
>  lib/riscv/setup.c     |  2 ++
>  lib/riscv/smp.c       |  2 ++
>  lib/riscv/timer.c     | 13 +++++++++++++
>  riscv/sbi.c           |  5 -----
>  5 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
> index b3514d3f6a78..fd12251a3a6b 100644
> --- a/lib/riscv/asm/timer.h
> +++ b/lib/riscv/asm/timer.h
> @@ -5,6 +5,7 @@
>  #include <asm/csr.h>
>  
>  extern void timer_get_frequency(void);
> +extern void local_timer_init(void);
>  

I've renamed the new function to local_hart_init and put it in processor.c
instead of timer.c. This is because going forward there will be other
non-timer-related CSRs that need to be set at init time and we can just
lump them all together.

Thanks,
drew

