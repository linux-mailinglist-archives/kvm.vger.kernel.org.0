Return-Path: <kvm+bounces-23853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B83E894EEF3
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75F01283948
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E73049647;
	Mon, 12 Aug 2024 13:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="teIZL9RY"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C0516E89B
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 13:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470852; cv=none; b=AmH9LMt84R9Ib5l9pXFcNAlbNFLOKzhM1zRajlupW58o1ZRg88cW3vQwM8Y+26W10f5Em6lrfQWV0QULy1lZRRTlKXj489UckqeCJ5CRKfLLgE8JpTxo9fjMnOKbPCe9wejx+9pRwnJ1hduATFI6xgGty2/bSp84oprT8V01Y8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470852; c=relaxed/simple;
	bh=95m+tqYcnE0XlSJuLNhY+/gac1K9gx6tKJESX32oEIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sOUQrf6Gkn01Y+StWvFLsuCT6C9lRoU3IHh+RvhdOaA1HH5TiFnQWdkYPXSHfwwLeYQS+avM0sSFWGDotRu1siTD+Ysz6+z3kG6WFvCUDyX9jASD8xEUZPCrTTPBsZgnJrT4dmYDEM4t9+flczjgm4Ws+qHl+eBGyuYcSuaZMhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=teIZL9RY; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Aug 2024 15:53:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723470848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+HlaHYBFzlVH6FzjV5qgulRj5J5LLSvjH+FLRM4vdBE=;
	b=teIZL9RYjPZFpzjLsH+ymKTAGaC0wWO39ees3//eNJm07HDbSIeh/mDRmcL1499MzSZdHS
	pERALs0oC4qKcz5BI1RD5S9wVrRsovS2HRfvV+L+HoOTKc4WTOSGE9ZuswKMcigGH35DeA
	0MUrK+KSFc63ZNa1W9ZtocYrbxweaks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com, thuth@redhat.com, atishp@rivosinc.com, 
	cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v2 0/4] riscv: Extend CI
Message-ID: <20240812-e97009553ee2983da3448575@orel>
References: <20240808154223.79686-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808154223.79686-6-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 08, 2024 at 05:42:24PM GMT, Andrew Jones wrote:
> So far we were only building and testing 64-bit, non-efi in the CI for
> riscv. I had mistakenly thought Fedora's riscv compiler could only build
> 64-bit, but it's multilib so we just need to add some CFLAGS to get it
> to work. To preserve building with a 32-bit-only riscv compiler we need
> to introduce limits.h to our tiny libc. And, while adding 32-bit builds
> to CI we also add EFI builds so now we test 32-bit, 64-bit, and 64-bit
> EFI. And, since Fedora has been udpated, bringing in a later QEMU, we
> can now do the testing with the 'max' cpu type.
> 
> v2:
>  - *Actually* test out-of-tree builds in the rv32 CI (I was missing
>    a few important lines, like 'cd build'...
>  - Add another patch to fix out-of-tree builds for riscv
>  - Added some indentation in the new limits.h
> 
> Andrew Jones (4):
>   lib: Add limits.h
>   riscv: Build with explicit ABI
>   riscv: Fix out-of-tree builds
>   riscv: Extend gitlab CI
> 
>  .gitlab-ci.yml | 36 +++++++++++++++++++++++++++++++-----
>  configure      |  8 ++++++--
>  lib/limits.h   | 43 +++++++++++++++++++++++++++++++++++++++++++
>  riscv/Makefile | 12 +++++++-----
>  4 files changed, 87 insertions(+), 12 deletions(-)
>  create mode 100644 lib/limits.h
> 
> -- 
> 2.45.2
>

Queued on riscv/queue, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv%2Fqueue

drew

