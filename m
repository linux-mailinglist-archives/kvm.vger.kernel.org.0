Return-Path: <kvm+bounces-26475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1478974C8A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85C1A287703
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE1F42AB7;
	Wed, 11 Sep 2024 08:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RZFxghiL"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B02154434
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726043052; cv=none; b=QbKdQTVAsZ6Y4zp3jZ0qh2glo7OsS/LKycPBv96KJPult+F4wYvpEBkanaBFpcH+2Y69BxypqZ/N5dDyRsbw5IzObqmMDklG8ESenJ+W3eRx2X4/ZxVhB9rWj2kihhky1nsFax/U+S8PXdzU0EQrCUzHic0hAWKHTM0n7NIfO5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726043052; c=relaxed/simple;
	bh=wmPNf1tPTS1FEKpH/lAzR4g+Ek+a2/MNrQx1KRfjAwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXdzSCoFkiKTqW2w5sUP3IyUyrIZs6JL6isc0K8kDKkK/q+1iUbtMwuEY2IjqRCxu3gDuTi3Cas5fAWZJw9Q5MtFSkvJQaWzXeilXS6PWbO/RZenXTUgzIFN9U/T9fO+ThRrecNB/dLshE+b2WW4bu3XBr0Oh4JXYZ2bpZU9J5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RZFxghiL; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Sep 2024 10:24:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726043047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/1TI8bsOlziGCU+hlwwiFofGLl9oRjkXX9zj1uFoMWU=;
	b=RZFxghiLIKxKCgLnibfFH4ohiv33HX3hbHVAGyIE8JlT9bIGx4BVzkUhVwpdBmmzi5vbnx
	FXAdcQ+RcA1B0CKKjMtElVrxXAM+19onH2byFb5ATKCVdXi3TiCVL7kt+yNLzMeWmiseys
	DJ3Cud9yYsRK1+D+SAwjKYJhn87Te1Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	pbonzini@redhat.com, thuth@redhat.com, lvivier@redhat.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, nrb@linux.ibm.com, atishp@rivosinc.com, 
	cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v2 3/4] configure: Support cross compiling
 with clang
Message-ID: <20240911-99a010a84e453f4362566c6b@orel>
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-9-andrew.jones@linux.dev>
 <D430ZV4FP2GE.3B7VE2I37RPXX@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D430ZV4FP2GE.3B7VE2I37RPXX@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 11, 2024 at 10:24:34AM GMT, Nicholas Piggin wrote:
> On Wed Sep 4, 2024 at 8:50 PM AEST, Andrew Jones wrote:
> > When a user specifies the compiler with --cc assume it's already
> > fully named, even if the user also specifies a cross-prefix. This
> > allows clang to be selected for the compiler, which doesn't use
> > prefixes, but also still provide a cross prefix for binutils. If
> > a user needs a prefix on the compiler that they specify with --cc,
> > then they'll just have to specify it with the prefix prepended.
> 
> Makes sense.
> 
> > Also ensure user provided cflags are used when testing the compiler,
> > since the flags may drastically change behavior, such as the --target
> > flag for clang.
> 
> Could be a separate patch but no big deal.
> 
> >
> > With these changes it's possible to cross compile for riscv with
> > clang after configuring with
> >
> >  ./configure --arch=riscv64 --cc=clang --cflags='--target=riscv64' \
> >              --cross-prefix=riscv64-linux-gnu-
> 
> Nice. Perhaps add a recipe to README?

Sure.

> 
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
drew

