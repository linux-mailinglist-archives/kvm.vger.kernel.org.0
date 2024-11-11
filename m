Return-Path: <kvm+bounces-31490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0831B9C4182
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92FC2B23071
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DA419D89B;
	Mon, 11 Nov 2024 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D8dDwiQp"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10F522318
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731337695; cv=none; b=gh8nqzdFO9OIQRs4JdM8ypEpIresw70is5PgZVKJCR3MhDo8ONG5hs8zHWL3j+LBXDEI12tm4OzawIEwo9JET/dMoOcN51ZjmIZmXIinJYE9nVjhJgoCQQC1cwVs3iBjnycZpPCNixXly5LmCN9wl3iTEkdqqz3lll028GNBHqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731337695; c=relaxed/simple;
	bh=9nJ0wCijZrA1sBt2t2yPt2ExJzOdSKRcd9+XmMnVJAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+6QGlht8cjoFDs91OPHISAqe/utFY9suxzFksWNQ1kcSD5YnMt86NtxnXzLQmUoiKAHj94H5VkneXFn/j/qeDfQuA632ZQ2lGHqT+4QRMHteAF1IrGyTe684jVRgbkCpnSHAgq2tKwKo6xF9d9CJbN5Dm05XyyciH+WxzdHPto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D8dDwiQp; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 16:08:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731337690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NRv1tPwGT4Odsj1fGe1YUeNzJe4z/w0h6MR21sCNMXk=;
	b=D8dDwiQpCwLHcjPqNhTnd+wonsfLyZIiPmVK+7GrignRAxRN+5ldPffkuk7ewFQCYDQfXf
	3Oi1RJsUvpqHt2GSyEtC6J9ZiOkYsQkBpPHzRG/KhNn5CwTpnO9jmzBcC5ytEaMtlRA6v/
	1rEjc2gdJwEMAwfAi4nQJ/OGP6ZYmMQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 0/3] riscv: sbi: Add SUSP tests
Message-ID: <20241111-10022f0cc16c81ac6a39ee6b@orel>
References: <20241024124101.73405-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024124101.73405-5-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 24, 2024 at 02:41:02PM +0200, Andrew Jones wrote:
> Add tests for the SBI SUSP extension.
> 
> Based-on: https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi
> 
> Andrew Jones (3):
>   riscv: Implement setjmp/longjmp
>   riscv: sbi: Clean up env checking
>   riscv: sbi: Add SUSP tests
> 
>  lib/riscv/asm/asm.h |   3 +
>  lib/riscv/asm/sbi.h |   1 +
>  lib/riscv/setjmp.S  |  50 +++++++
>  lib/setjmp.h        |   4 +
>  riscv/Makefile      |   1 +
>  riscv/sbi-asm.S     |  55 ++++++++
>  riscv/sbi-tests.h   |  19 +++
>  riscv/sbi.c         | 308 ++++++++++++++++++++++++++++++++++++++++----
>  8 files changed, 417 insertions(+), 24 deletions(-)
>  create mode 100644 lib/riscv/setjmp.S
> 
> -- 
> 2.47.0
>

Merged through riscv/sbi.

Thanks,
drew

