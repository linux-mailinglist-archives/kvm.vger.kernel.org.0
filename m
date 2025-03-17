Return-Path: <kvm+bounces-41225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CFE3A64FB0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:49:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE8AF170A50
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FE51E51D;
	Mon, 17 Mar 2025 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cAEfVtV8"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAF64A1C
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 12:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742215787; cv=none; b=cCCONH31ZIYq82lBZQo2xuCv/mxC0Qu/vubNLjvUhmO3KRCp0kai/yip1KDu9A5Ie0gOYOP1O5ruYRKvxzBTS0GUNUt1nO7ALGZRjeT9Nn69Ov3Rm7JgnRt71MOm240CqOJfAEoECFq1wLqD49o7gr2edh4Hx3aQfQPJDO5IuG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742215787; c=relaxed/simple;
	bh=0ekGd2L+h7xKqNHfygF7b/WUlxOPEzhmYltsBfE1+EA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCqxIczNlGFau+RQtMC+QNOEK2Sc94LNrVV7+SrinU8XtTt2PtTj4wINQnp7SSIAuKB2N+XjHzvTHz8QS9AZAai8CTZ9vcBtEj5VEYnq0AwxQaMAMsoKHuBhsJaY+nENKDEqiEps0gt0DBT3EthoI1NuNv+5tVZpBaoEAZ0qUpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cAEfVtV8; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 17 Mar 2025 13:49:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742215782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oPYpkeHTBRW7ZIq4gqnfgs5Y1FHdNlRjkzXr+4ZZFI8=;
	b=cAEfVtV8vV5kgOVgDdlZFV+46S4JzGAYcRVYNIIYNfs1qMvjdD7MyKWRIP0qZFJ/41Okk+
	BVa3Y2cUdPxFw2ibqwW7sTg02o5f/GsxZ8gNlxarw2yYoa+XMN6UlARGgd64UX5d4lAbvf
	GONppRou4Vh8g7a9qv+dky4jpFY7lGc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v10 8/8] riscv: sbi: Add SSE extension
 tests
Message-ID: <20250317-a427b5b91080ab28e40a56b7@orel>
References: <20250317101956.526834-1-cleger@rivosinc.com>
 <20250317101956.526834-9-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317101956.526834-9-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 11:19:54AM +0100, Clément Léger wrote:
> Add SBI SSE extension tests for the following features:
> - Test attributes errors (invalid values, RO, etc)
> - Registration errors
> - Simple events (register, enable, inject)
> - Events with different priorities
> - Global events dispatch on different harts
> - Local events on all harts
> - Hart mask/unmask events
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile    |    1 +
>  riscv/sbi-tests.h |    1 +
>  riscv/sbi-sse.c   | 1280 +++++++++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c       |    2 +
>  4 files changed, 1284 insertions(+)
>  create mode 100644 riscv/sbi-sse.c
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

