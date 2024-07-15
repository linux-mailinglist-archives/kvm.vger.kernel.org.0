Return-Path: <kvm+bounces-21659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 501F1931C4C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 22:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDE33B20D3D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 20:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7D413C67E;
	Mon, 15 Jul 2024 20:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gl2GFe16"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9866F099
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 20:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721077042; cv=none; b=FpOdGkAHXZ3q+3PDUqhQxsDBNA2pvtxgN5yzKaW8dnmPh16KgcOCj7FOzhbsffDBfaT63BwdP4F+4Do2vA75uM6PpiXEk6U5U+W56u4BL11v8/PzmHRb+uf4aoMHQ9uNXtuO7fWoOgGlRALiTaCj7ZuKe2r5Y1tLEaGYf10xu+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721077042; c=relaxed/simple;
	bh=VI74We3Dst5Y7Coe8PJtRjjlkufLgtNtZ61mBsqzQmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZax8yViQ250jNfr4zqgnftMcCU180pu17Yzb4jjN+pqMkDZ7mR/oFWLinEfz65QHrn6V88ynoyJyl+9fvf67NarMhZk9FW3BrhjP2CHLELFOMeeh5hCHmKdWNx1XhQsZ8Tw/jUsejSf2z5IoZo+5gWDWmHHrrhFOmKenspSiEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gl2GFe16; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: cade.richard@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721077037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fTbQXpjYzbxEe06A/wxLmLcUG36xTzLy3700iGnMqgg=;
	b=gl2GFe16gKSqTBJeJlPWPfgUVlso/6B31ngiesud/d6FyrKTCdb/Rq3vCr2b4ar8pEWvMx
	Ge6Jfcq3t6mn1ZA15nP5v84Dtqqf+zNH+9T51zEWYzjz8mM+f8ddfo5u1BCwuLYlnvazbv
	O16ogJd8kNrIgvnWr4we9GmXR0uyrbM=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
X-Envelope-To: jamestiotio@gmail.com
Date: Mon, 15 Jul 2024 15:57:12 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [PATCH kvm-unit-tests] riscv: Fix virt_to_phys()
Message-ID: <20240715-259591b706e831a2cf19f618@orel>
References: <20240706-virt-to-phys-v1-1-7a4dc11f542c@berkeley.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240706-virt-to-phys-v1-1-7a4dc11f542c@berkeley.edu>
X-Migadu-Flow: FLOW_OUT

On Sat, Jul 06, 2024 at 04:09:44PM GMT, Cade Richard wrote:
> 

Needs a commit message stating it's currently broken for anything
other than addresses on page boundaries and that this is the fix.

> 
> ---

These dashes shouldn't be here. With them, git will strip the s-o-b on
commit.

Please also add

Fixes: 23100d972705 ("riscv: Enable vmalloc")

> Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
> ---
>  lib/riscv/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
> index bd006881..c4770552 100644
> --- a/lib/riscv/mmu.c
> +++ b/lib/riscv/mmu.c
> @@ -194,7 +194,7 @@ unsigned long virt_to_phys(volatile void *address)
>  	paddr = virt_to_pte_phys(pgtable, (void *)address);
>  	assert(sizeof(long) == 8 || !(paddr >> 32));
>  
> -	return (unsigned long)paddr;
> +	return (unsigned long)paddr | ((unsigned long) address & 0x00000FFF);

Let's add

  #define offset_in_page(p) ((unsigned long)(p) & ~PAGE_MASK)

to lib/asm-generic/page.h and use it here.

>  }
>  
>  void *phys_to_virt(unsigned long address)
>

Thanks,
drew

