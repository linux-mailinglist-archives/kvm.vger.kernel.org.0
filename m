Return-Path: <kvm+bounces-57720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AFE4B596E7
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E4973AECFF
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 13:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF71A21FF36;
	Tue, 16 Sep 2025 13:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lhKgI2f2"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F31A21D5B0
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 13:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758027890; cv=none; b=FyNmO68PxNM+5lr2BRiro/HzbvII+SwOwzZjM8UynCJyyO0nDlwOf7MJXRpA8CoCPV0nOvU+bG0SkSHK/ruT4Y73zKBM4oVzdIeu7oo4D7wAh9b9P13olAznMHWHHebcd8HS4vVqKxHkNldFpgrUv8dfdzy26IaaUxnddYcWFMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758027890; c=relaxed/simple;
	bh=IclkClmNYuPrsM1evye5YOrVaiJ2idHg+P+9S29U8RI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7A20EsuBLiail0r/2ljU/A70Wy4Qn3tZVrYsKkD4F4ZP/sB8EIaswMzIJksUxDh1bqXs1Bsxp2JYDdAB8Vr7mjhMgyY4bBhLXljiuGgvYhczYSOad0iW4aBrcP9LBhLUNkNtUsn5c+GOVyO2g7P0+QGfft2uOdHPJSuNTE+giY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lhKgI2f2; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 16 Sep 2025 08:04:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758027877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/0wMpeo7+HuzXTCk6SZr1DvI6hGSc5rxKcjPuH42CqM=;
	b=lhKgI2f240r2xWTG3lgdUooyhxt1bwBwWYgm4Fxbk7YPbv6zhZHCH6gQmd02oXsz09cTUq
	LhznMFzGj/UXS7PhFwWihE+wErC9pBVMS5IEt0TuOavm0DMFF+e/BUoQd9Yr1ZfOUxvHJA
	lVt306BPn5RiE8X6gGm/Ni6Bu/UZD84=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
Message-ID: <20250916-47e5c9b9db5514de4d27a37c@orel>
References: <20250915215432.362444-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 15, 2025 at 11:54:28PM +0200, Mathias Krause wrote:
> This is v2 of [1], trying to enhance backtraces involving leaf
> functions.
> 
> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
> fails hard for leaf functions lacking a proper stack frame setup, making
> it dereference invalid pointers. ARM64 just skips frames, much like x86
> does.

Hi Mathias,

Thank you for the arm/arm64 fixes!

For the arm/arm64 patches

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Tested-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

> 
> v2 fixes this by introducing the concept of "late CFLAGS" that get
> evaluated in the top-level Makefile once all other optional flags have
> been added to $(CFLAGS), which is needed for x86's version at least.
> 
> Please apply!
> 
> Thanks,
> Mathias
> 
> [1] https://lore.kernel.org/kvm/20250724181759.1974692-1-minipli@grsecurity.net/
> 
> Mathias Krause (4):
>   Makefile: Provide a concept of late CFLAGS
>   x86: Better backtraces for leaf functions
>   arm64: Better backtraces for leaf functions
>   arm: Fix backtraces involving leaf functions
> 
>  Makefile            |  4 ++++
>  arm/Makefile.arm    |  8 ++++++++
>  arm/Makefile.arm64  |  6 ++++++
>  x86/Makefile.common | 11 +++++++++++
>  lib/arm/stack.c     | 18 ++++++++++++++++--
>  5 files changed, 45 insertions(+), 2 deletions(-)
> 
> -- 
> 2.47.3
> 

