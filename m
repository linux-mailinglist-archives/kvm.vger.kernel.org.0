Return-Path: <kvm+bounces-39593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F110FA4831C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0602F165DF6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7836626B94A;
	Thu, 27 Feb 2025 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aXHmHcil"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AE32356AE
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 15:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740670589; cv=none; b=Trbba0o0gtFYNm+/BLwWBGsPIB/lJpHS9oUfyO5DqFfBpfDxJ7fBe6gOHjSI0ceI1vT0TyMr7YNTyhWP7m5u5ZtUAynMVQJ/FICl57OBhw8FteMDcfgpOqiFIGkGsnvG9UGKNwun5Uv+bmBOkXb/9CrbwCTj0W34+MdBCi/yKUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740670589; c=relaxed/simple;
	bh=aIgRRLSLxCQtLw3ka8XL3uGcWMR6P5+JSFsjaPltxGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNnYN3xZsFW35HI2x1NgIN0l5lOhOCoz4E0a0zg/MZOkn3mORsVb0N60MYhKh5o5j9onW8wuXRSli1DV2XBrNI0VzwEaiEpQO4lfpCyxQ8Z5Jmuy+W+Q6a5jfA57gDTB/i6By3jF8WYQ1jgF72Px2FtSebsoiHLOQjt0B/wLbuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aXHmHcil; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 27 Feb 2025 16:36:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740670583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7K+2652/2JPqs5KtXhCAPsJQsXoPDx6afoG7BlPfQS4=;
	b=aXHmHcilHp8+1yrcDjrSBW6wUsJH3hgJ7hMiLqfOoF7R2hdCNd9sZ98XMO0HaEWykHJrNj
	tub0RKTAtgI4CD5kziXZwcCW+lbNtMKTRGPasIXVARhnFaGCUC8mtJoN28mma7uVMmyOOJ
	d0MzHaKsEs3LtgKYiplbzSyu6p/v7hE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, npiggin@gmail.com
Subject: Re: [kvm-unit-tests PATCH v7 2/6] riscv: Set .aux.o files as
 .PRECIOUS
Message-ID: <20250227-99cd90f3ad775b89fd9fc262@orel>
References: <20250214114423.1071621-1-cleger@rivosinc.com>
 <20250214114423.1071621-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250214114423.1071621-3-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 14, 2025 at 12:44:15PM +0100, Clément Léger wrote:
> When compiling, we need to keep .aux.o file or they will be removed
> after the compilation which leads to dependent files to be recompiled.
> Set these files as .PRECIOUS to keep them.

There was a thread[1] about this 7 months ago or so. I've CC'ed Nicholas
to see if there were any more thoughts on how we should proceed.

[1] https://lore.kernel.org/all/20240612044234.212156-1-npiggin@gmail.com/

Thanks,
drew

> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 52718f3f..ae9cf02a 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -90,6 +90,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
>  asm-offsets = lib/riscv/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
>  
> +.PRECIOUS: %.aux.o
>  %.aux.o: $(SRCDIR)/lib/auxinfo.c
>  	$(CC) $(CFLAGS) -c -o $@ $< \
>  		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
> -- 
> 2.47.2
> 

