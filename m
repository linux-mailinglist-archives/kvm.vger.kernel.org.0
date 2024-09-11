Return-Path: <kvm+bounces-26473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF653974C73
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:21:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4083286AF8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B1C17995E;
	Wed, 11 Sep 2024 08:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mOgc2X16"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D35714AD0A
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726042772; cv=none; b=VQ7fbFjHNGpOC51oms03sXxbYmbfk+eOerHj57uq13kCuS0GpJdWZNK0QOkU7fQg6kj9GYxvylGy+ctpvO9kX/l5pTb47BSUBZrVez6hviAchHXJZn51XIwr8CtwaXYTCkC//pedW7j4KqP12DNecB49UAbj/1vkgaOpW3P20DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726042772; c=relaxed/simple;
	bh=LxHdd6oWMKDSmV87qVDd0Ih45iGUGvPc3C0MfoJr+W4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNrnvmdhmStmrGfMBs2spLq8obGnjXTYk/xMsEPIwaa4oe3tEvLqYw0/IZs57taXEEvnZFqbR3DeTem2bbDXDu1M4PsBqZY2kxinTIyVnPSXHGznVMEEdHz+VrIBarRiu6dyaIY2y5lyMQTgmPlrSv0TnX2zR1VLA5sht1TSYLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mOgc2X16; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Sep 2024 10:19:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726042767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xawjdg9z4iOS4w17C67FyLrAjZ6VCLSaCQ0vlpCF4cQ=;
	b=mOgc2X16DMniSSg5raKMj4rMI4P5mn/hmJoO4dhq78qFcth9aXmLURlGx3a9wvb/xx3GZV
	xZ4p1ifKJZnphmltqmAInC3jPjDJ1plx7dRNLiTvGa4ZBWwKQn+ruszwkrQKp5BFNWhLFa
	imaAtwoItwF0hl/nnckK9zeluUh+I/0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	pbonzini@redhat.com, thuth@redhat.com, lvivier@redhat.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, nrb@linux.ibm.com, atishp@rivosinc.com, 
	cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] riscv: Drop mstrict-align
Message-ID: <20240911-b5b62a907e90fabe4c701930@orel>
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-7-andrew.jones@linux.dev>
 <D430NH4TXH15.KR19KPMT2APE@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D430NH4TXH15.KR19KPMT2APE@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 11, 2024 at 10:08:23AM GMT, Nicholas Piggin wrote:
> On Wed Sep 4, 2024 at 8:50 PM AEST, Andrew Jones wrote:
> > The spec says unaligned accesses are supported, so this isn't required
> > and clang doesn't support it. A platform might have slow unaligned
> > accesses, but kvm-unit-tests isn't about speed anyway.
> >
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >  riscv/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/riscv/Makefile b/riscv/Makefile
> > index 179a373dbacf..2ee7c5bb5ad8 100644
> > --- a/riscv/Makefile
> > +++ b/riscv/Makefile
> > @@ -76,7 +76,7 @@ LDFLAGS += -melf32lriscv
> >  endif
> >  CFLAGS += -DCONFIG_RELOC
> >  CFLAGS += -mcmodel=medany
> > -CFLAGS += -mstrict-align
> > +#CFLAGS += -mstrict-align
> 
> Just remove the line?
> 
> Or put a comment there instead to explain.

I'll add a comment.

Thanks,
drew

