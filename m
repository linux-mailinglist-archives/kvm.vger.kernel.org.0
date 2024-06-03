Return-Path: <kvm+bounces-18608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD3D8D7DEF
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAC1A2833BD
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 08:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A1C7604D;
	Mon,  3 Jun 2024 08:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TXkS7ufn"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA853D551
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 08:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717405002; cv=none; b=lPTzbZotmkDsO6UdvKHeEu82ygG8BUABAVew2MPX3RyusQzLgCL8VtsVnIPi8uV1L80amqdlgodYLF9yBMiILLbN7ANnsRyQxuc0touCD8kC4PhKheAicnV59I3ON2K25LUGOFgrWZDsh6H906s4hIBHft1/Apc9jOgDbmc3Z2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717405002; c=relaxed/simple;
	bh=wgYrSpaRhR135jXnRkYUw7bA1MGH+2Bt1nszyMvtk2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7d2OjY9MxKepN9TMi30DJBOZk1M3b1TqoUe9s2zZkJt97fdJlOAi7VCy9s9LOimEx4L+/jP5EqDUwbjSz/syK+FDgvpUfCeWqweflDGTdq5HNyz3kiVEv/dY5kKTp6Dv/sZWpbeCKxVP898lsPEKtWf++4SVSkVCRLcxo4nPCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TXkS7ufn; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: thuth@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717404997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JdLVrqZlOzGIOAo+mAo39ZzvPknpYmsUoLiAZ9P3k04=;
	b=TXkS7ufnb4RSVMZzj0M//08wJbUjiwhtRntF4GGjdKcIwe05jkPR+U3w6Bc5aWcdPETcoz
	0k/opK0VSnxp+69WYY5bVWYDpb7i608Ts55pQDL22F6HcrtnS3og9ZJT5HbiVu8xqt3an+
	608YRqFM4nrI9Q3yjtNahybLKiGmy3o=
X-Envelope-To: npiggin@gmail.com
X-Envelope-To: kvm@vger.kernel.org
Date: Mon, 3 Jun 2024 10:56:30 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/4] build: Make build output pretty
Message-ID: <20240603-20454ab2bca28b2a4b119db6@orel>
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-4-npiggin@gmail.com>
 <448757a4-46c8-4761-bc51-32ee39f39b97@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <448757a4-46c8-4761-bc51-32ee39f39b97@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 03, 2024 at 10:26:50AM GMT, Thomas Huth wrote:
> On 02/06/2024 14.25, Nicholas Piggin wrote:
> > Unless make V=1 is specified, silence make recipe echoing and print
> > an abbreviated line for major build steps.
> > 
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   Makefile                | 14 ++++++++++++++
> >   arm/Makefile.common     |  7 +++++++
> >   powerpc/Makefile.common | 11 +++++++----
> >   riscv/Makefile          |  5 +++++
> >   s390x/Makefile          | 18 +++++++++++++++++-
> >   scripts/mkstandalone.sh |  2 +-
> >   x86/Makefile.common     |  5 +++++
> >   7 files changed, 56 insertions(+), 6 deletions(-)
> 
> The short lines look superfluous in verbose mode, e.g.:
> 
>  [OBJCOPY] s390x/memory-verify.bin
> objcopy -O binary  s390x/memory-verify.elf s390x/memory-verify.bin
> 
> Could we somehow suppress the echo lines in verbose mode, please?
> 
> For example in the SLOF project, it's done like this:
> 
> https://gitlab.com/slof/slof/-/blob/master/make.rules?ref_type=heads#L48
> 
> By putting the logic into $CC and friends, you also don't have to add
> "@echo" statements all over the place.

And I presume make will treat the printing and compiling as one unit, so
parallel builds still get the summary above the error messages when
compilation fails. The way this patch is now a parallel build may show
the summary for the last successful build and then error messages for
a build that hasn't output its summary yet, which can be confusing.

So I agree that something more like SLOF's approach would be better.

Thanks,
drew

