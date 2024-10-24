Return-Path: <kvm+bounces-29605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DEF9ADF56
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C8BD1C21EFB
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 08:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38151B21A0;
	Thu, 24 Oct 2024 08:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ub1S7pKX"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50D01B0F3F
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 08:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729759219; cv=none; b=oFcVZNFF3wJ/xCOq3/NIM3joDEob0lrG4lkPrjCKdIiswVBbRzA7hXzincgpZjHln7b7h3UZ48JcZ0ZrsBC8yEaNEcdAv0+Wwm+Gd90r2JSduGCucERVK2beNaiL5O8izy4oC3u9k8KIqCye3l90OdxdyHczmFHhbLP6pnTugak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729759219; c=relaxed/simple;
	bh=0K+RX95ryHG5fD91kMqo8aa7PSon0llOzyqHXNAUSyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/KERKJc/m+xqDDhYVooxQNvFORxSXMKN7x4tr8wEfsAXkzDdzrUXil8lia1sme8GMB3h7+hQDq/A/rdm3Ai9xjkzhLtCXcV5NTnP9Lv7VvJm5BvWarTF+kHmLDk8Oc23wOMX2VaZm03Dj6jqMJQoVr2FBUPV90fATPqjp5F8NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ub1S7pKX; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 24 Oct 2024 10:40:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729759214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ITSlBcmdKUBoR2+a1SNIWkpnRKbgwmB5a0/kaSKYmq8=;
	b=ub1S7pKXI97oebLi2oaD1dJYspFyor7IlAvysM648Lbyc/mwRaS51w04urtDipyN9PKZiF
	6ePGROwZ9+V69oJgo/pO1KwazBhNRp5wbeZzztEjk5Sy/a2urhwyA+sHtzl9uoaBXFFXAQ
	yEwT/kma/4BEgHMPDJ07VFtm2JmRymI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Subhasish Ghosh <subhasish.ghosh@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Fix arm64 clang errors on fpu tests
Message-ID: <20241024-ab42773f235945c68dd99d68@orel>
References: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 23, 2024 at 03:26:34PM +0000, Raghavendra Rao Ananta wrote:
> When compiled with clang for arm64, some build errors were observed
> along the fpu code. Moreover, data aborts were seen while running
> the arm/fpu test due to misconfigured input/output args in the inline
> assembly.
> 
> The series tries to address these issues.
> 
> v2:
>  - Fix build errors for newer clang versions that push 'q' registers out
>    of scope under '-mgeneral-regs-only'. (Andrew)
> 
> v1:
> https://lore.kernel.org/all/20241022004710.1888067-1-rananta@google.com/
> 
> - Raghavendra
> 
> Raghavendra Rao Ananta (4):
>   arm: Fix clang error in sve_vl()
>   arm: fpu: Convert 'q' registers to 'v' to satisfy clang
>   arm: fpu: Add '.arch_extension fp' to fpu macros
>   arm: fpu: Fix the input/output args for inline asm in fpu.c
> 
>  arm/fpu.c                 | 52 ++++++++++++++++++++-------------------
>  lib/arm64/asm/processor.h |  2 +-
>  2 files changed, 28 insertions(+), 26 deletions(-)
> 
> 
> base-commit: f246b16099478a916eab37b9bd1eb07c743a67d5
> -- 
> 2.47.0.105.g07ac214952-goog
>

I've merged this along with the cross clang series and the 5/4 patch I
tacked onto this series which adds aarch64 clang testing to gitlab CI.

Thanks,
drew

