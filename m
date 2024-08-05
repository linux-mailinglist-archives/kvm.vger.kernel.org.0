Return-Path: <kvm+bounces-23227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A982A947CCB
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:27:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA9E11C21D5F
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 14:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9727F13A884;
	Mon,  5 Aug 2024 14:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wm8YjdsU"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298263EA64
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 14:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722868024; cv=none; b=h+CKYQXZ3F3BhClIdA1XC1vs7MaE9iZ8M2Txqbks+WF1FVPY16xT5XzK6bgiICn+Wt/uhw8l8+yhxTEn6tU4Vg/ufJe/m7v4uvMKUhq7DkeaUfp6sbmWqDlGVOR/Fiu54gyQ8Q3r0FOYFcsdxukiWrivhwVT8eSZ5OSeX6cQGd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722868024; c=relaxed/simple;
	bh=F+ZmQ/VqMymoQm28PJj2JRZECejmP5G3PlthE9JS14Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTKhRnhHt9CnVW0i2p6a8Wev95wBE40cX0MnhZqW7dcy0KpPTo7CwIKbfXp6y7uQ3a2bWcGmg+wBVIANL7730czya3SSuVQOJ0s6QM1BSQ+n3VFmQCGTo3I1BBW00t/EhLikIGwSPxS/afqkEbvMFvEEt1jaFZLOOfuAsBqWBlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wm8YjdsU; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 5 Aug 2024 16:26:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722868018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yjx4EHLzVjCv54dbG7vmeeuAamNfgD0DI460Fr/FHR8=;
	b=Wm8YjdsUw52kqyq7ok67Xg9+QfzGzMvsqbrSgKHcD75ZY30t+O6yIvnJKNN9oqP8WnIMEQ
	7fKrr0dJsAWMDuWsK1QJJb6jhboLVLJ4Z1xrFrpbtCWe9HmcCyJBqDsFoBY/uHhJUg6Ovt
	fRPqZKuw4g025NGNi+fTxTCWDLn3ZL8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [PATCH kvm-unit-tests] riscv: Fix virt_to_phys()
Message-ID: <20240805-1d135dd842be42acbe313193@orel>
References: <20240706-virt-to-phys-v1-1-7a4dc11f542c@berkeley.edu>
 <20240715-259591b706e831a2cf19f618@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240715-259591b706e831a2cf19f618@orel>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 15, 2024 at 03:57:12PM GMT, Andrew Jones wrote:
> On Sat, Jul 06, 2024 at 04:09:44PM GMT, Cade Richard wrote:
> > 
> 
> Needs a commit message stating it's currently broken for anything
> other than addresses on page boundaries and that this is the fix.
> 
> > 
> > ---
> 
> These dashes shouldn't be here. With them, git will strip the s-o-b on
> commit.
> 
> Please also add
> 
> Fixes: 23100d972705 ("riscv: Enable vmalloc")
> 
> > Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
> > ---
> >  lib/riscv/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
> > index bd006881..c4770552 100644
> > --- a/lib/riscv/mmu.c
> > +++ b/lib/riscv/mmu.c
> > @@ -194,7 +194,7 @@ unsigned long virt_to_phys(volatile void *address)
> >  	paddr = virt_to_pte_phys(pgtable, (void *)address);
> >  	assert(sizeof(long) == 8 || !(paddr >> 32));
> >  
> > -	return (unsigned long)paddr;
> > +	return (unsigned long)paddr | ((unsigned long) address & 0x00000FFF);
> 
> Let's add
> 
>   #define offset_in_page(p) ((unsigned long)(p) & ~PAGE_MASK)
> 
> to lib/asm-generic/page.h and use it here.
> 
> >  }
> >  
> >  void *phys_to_virt(unsigned long address)
> >
> 
> Thanks,
> drew
>

Since this is a fix that I'd like to get in sooner than later, I've made
my suggested changes myself and merged it.

Thanks,
drew

