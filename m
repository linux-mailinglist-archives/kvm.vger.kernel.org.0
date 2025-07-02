Return-Path: <kvm+bounces-51305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4474AF5B82
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E867617362F
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC5F309DBC;
	Wed,  2 Jul 2025 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R7tVbKS0"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277428A731
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751467577; cv=none; b=PUs4qOFxC/92cOe0bV3x7Z4EMh01ghC2fDcY14M29T/63M119q9xvrgLXMA4MG9e6T4ChIQAFqvga//gUxqvWaPGXK3fFlBsixz90qwJxax6s9R3z6LxOVP9+IuFkLtXQV5+7GzYJ4pDcwcP5dLXjl2husrm4QNrhMLMFSBW/xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751467577; c=relaxed/simple;
	bh=4C1J+Ay8wQrDLJ+yQO9wgrVdpaRPJfpxJwGo3ccxVio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7qkTRfdnl49E6/BtL46jXY4JL4xKEu9tq8pU88Li7AtQ39qPq05IhPr//LIpvpVU5oBpC/ONo7te9MtHBcgzTw8uU1kzoU02+VBf5+pzul6bVUSd0zft0qYXFu/yxdWeZ6BysW7ZJDd94rPnSet23g4zUemqKeeUf5YizDJY0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R7tVbKS0; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 2 Jul 2025 16:46:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751467573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hWVk+mWXjNoWAcO7yRaMljb1CdNmQ9EOBU3D+Ap2Yw8=;
	b=R7tVbKS0GuZdnm4Um1TDnU4JRqJ2BW+VpknYouN4TZ9qbKamZnbJ+ORstVhvpmq+D8UBAt
	JfC+mSgjoFVJGQiVFd+izGlmoar7YiPdHtU9QdvpVDm+cah9o1JkRZRK0y3iqpz2P2OQKG
	sAY0xc130ftLxucS9M3rVvQWIgVc9eM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jesse Taube <jesse@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, Atish Patra <atish.patra@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, Himanshu Chauhan <hchauhan@ventanamicro.com>, 
	Charlie Jenkins <charlie@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v2] riscv: Allow SBI_CONSOLE with no uart
 in device tree
Message-ID: <20250702-7efa8f9a74c2014fc94f35c3@orel>
References: <20250613150313.2042132-1-jesse@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613150313.2042132-1-jesse@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 13, 2025 at 08:03:13AM -0700, Jesse Taube wrote:
> When CONFIG_SBI_CONSOLE is enabled and there is no uart defined in the
> device tree kvm-unit-tests fails to start.
> 
> Only abort when uart is not found in device tree if SBI_CONSOLE is false
> 
> Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> ---
>  lib/riscv/io.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
>

Merged. Thanks

