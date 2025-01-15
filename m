Return-Path: <kvm+bounces-35544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0DB3A1247C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 14:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2C7B16723E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 13:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BAD92416AC;
	Wed, 15 Jan 2025 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s1V+jihF"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5452459A8
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 13:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946773; cv=none; b=kJO2BhDxyEYgKViSuQXd80kKbG0IrPQbKtpl9I/bqGS6r6sfEBMOQR713T1he9LvdZN/FS30NIMsXgXxOTqDRzgwLAecR/eZcw+Fonxjr3j3nJBIfa2J2t1JcSIvqgefm+ZMZKJo0nvMdX2N9lcLWWyeQphzQigVbL5vLMsHHPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946773; c=relaxed/simple;
	bh=jgD/utpZPSf32QqzsIgoPtwgMFkksDK/B+X3b5deW8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rUUa3zWoD++9VXG1/MVQGcpxK84moj+C+WrA0WA5ZITqB0hYfE2UVVx57p43fvTP5/XrH0Ial9EAzdrFKujZClE8ewZd2Rm/iBnt0PmpeFGygS3ISoMLVr8M7IdtoponZcEbE3JFxb8yp5CD3yNJA/nnCOPTCtuEIAeM1oeNAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s1V+jihF; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 15 Jan 2025 14:12:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736946763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rkfYIVXkksCwaplxJod6xonK+RNaAP9Y6T95YTo709w=;
	b=s1V+jihFRL7bDpC7MoZjhyG16NNqG3UsSsK3PjEI+77ZR/K3XzPPmB2tG8Aoj+f5Z33nUA
	vd5f50AYl9BvDcdLMToh9PiQm7GCHwJQVHvBBtyxxgTG1g0FIocuDjwzEkqQP5ZdjlW89B
	UmpCrpKbqj3Whb8W0ExfIa1UGIkWSq0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v6 5/5] riscv: sbi: Add SSE extension tests
Message-ID: <20250115-f2d15dd40c85aad2e16a1b3b@orel>
References: <20250110111247.2963146-1-cleger@rivosinc.com>
 <20250110111247.2963146-6-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250110111247.2963146-6-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 10, 2025 at 12:12:44PM +0100, Clément Léger wrote:
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
>  riscv/Makefile          |   3 +-
>  lib/riscv/asm/csr.h     |   2 +
>  riscv/sse.h             |  41 ++
>  riscv/sse-asm.S         | 104 +++++
>  riscv/sbi-asm-offsets.c |   8 +
>  riscv/sbi-sse.c         | 936 ++++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c             |   3 +
>  riscv/sse.c             | 132 ++++++

I'm not reviewing this whole file since I have comments on v4 that I think
mostly apply. However, I noticed the new riscv/sse.[ch] files being added.
Those should have 'sbi' somewhere in their names or, if they just define
wrappers for the SSE functions (not test-specific stuff), then they can go
in lib/riscv/sbi.c. Remaining test-specific stuff should stay in the riscv
dir. Header stuff could go in riscv/sbi-tests.h or a new riscv/sbi-sse.h.
Everything else should be in riscv/sbi-sse.c

And riscv/sse-asm.S should be named riscv/sbi-sse-asm.S

Thanks,
drew

