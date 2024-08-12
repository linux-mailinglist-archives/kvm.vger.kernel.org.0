Return-Path: <kvm+bounces-23863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBAA594EF6A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 674E61F2253A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91930183084;
	Mon, 12 Aug 2024 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y+Por+2Q"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DC717D8A9
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472474; cv=none; b=kgMHhOpopjIw+wjmqVCTKAkCH4Idc18nS/UIlAOfzB8e0rPmBUKQYsUo+R2p6HtL189kPLIR3Rk71u6uIgWXJRE6qfksSz8AKx5RUPKd3AepcywFEOhXq/4okWLFNrZFFhb+EoNTjO9Q52DooY+Q7PmsX9tktSD3wZbLyMlw+LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472474; c=relaxed/simple;
	bh=bznRfkavE8gz5GSMpFFXyzdgUcVe1kjpO/qgo6apdm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHny8dceEVy4ekrnMfn1tpYpF+icU8m7TpEaPBOz4uHh4CYQmDzbveWMi7aIc3Ft+NlXfcFcQv+reR2CHGv8zNwAg49qlqazQ/OsqAh9s6moQpJ6aeDfIEmBVXKrAKQm2isyske+971a6a4UoR18G42ZLVWlqT/p15ZwC7ZAz4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y+Por+2Q; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Aug 2024 16:21:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723472471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AgaYljEONxrM+2ayk3RUMmQAOWsjXZDGkdEXbTyanJU=;
	b=Y+Por+2Q2Tm8F0V+bjvBhYMq9t0G+rjyE8IQHIKVO8f2HMeqNbJ/u9kU/h768FYSrSQojY
	ZfaducSjotJmD04G/f9PPXx8mMK/8thKvBoMNhEvsLdkOynnbMAVmYOKSUzY7dN755So5W
	hT68iXCNUeMHGK2Tr9rjGtYcU98Bq2g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH 0/3] riscv: sbi: Add support to test HSM
 extension
Message-ID: <20240812-ad8171c2d4e3bf1355e85326@orel>
References: <20240810175744.166503-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240810175744.166503-1-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 11, 2024 at 01:57:41AM GMT, James Raphael Tiovalen wrote:
> This patch series adds support for testing all 4 functions of the HSM
> extension as defined in the RISC-V SBI specification. The first 2
> patches add some helper routines to prepare for the HSM test, while the
> last patch adds the actual test for the HSM extension.
> 
> James Raphael Tiovalen (3):
>   riscv: sbi: Add IPI extension support
>   riscv: sbi: Add HSM extension functions
>   riscv: sbi: Add tests for HSM extension
> 
>  riscv/Makefile      |   7 +-
>  lib/riscv/asm/sbi.h |  23 ++++
>  lib/riscv/sbi.c     |  15 +++
>  riscv/sbi-asm.S     |  38 ++++++
>  riscv/sbi.c         | 285 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 365 insertions(+), 3 deletions(-)
>  create mode 100644 riscv/sbi-asm.S
> 
> --
> 2.43.0
>

Hi James,

When you send v2, please base on riscv/sbi, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv%2Fsbi

Thanks,
drew

