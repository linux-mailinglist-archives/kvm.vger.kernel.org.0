Return-Path: <kvm+bounces-41067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B10A61386
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:19:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F1531731B1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7E6200B8B;
	Fri, 14 Mar 2025 14:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G+QwETGZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D909200BA8
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 14:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741961964; cv=none; b=YHRB9zLA/HRdutsgmZMPHQt8C69Y3uCGjKGN6bDqxYCA0b+r+BQIhX/NZ6O7SKLHvuzBlT5x7PNo6JJUmw2muhWrNR7GaKnR+z/mQdBvvofS5+QFwcpvuKDRrk+WLgLSUL1xGZODxqNYVbRwadb/4cl62aMNC1x0fitCqFlo/us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741961964; c=relaxed/simple;
	bh=rfm2SHJGPzpJqmbjHZGEFvTtcDzNAo8vTHZ0TBp3tm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boQO0iJTBgaNB9VKjK/nm5Ab7HvxABbyoTvAaokXK4x7lbJqvcL9kmumBVbh0MQZepR8oe8WQBZ0wzhToMr762mgyzOtRcPR9IzWQOi6DGTfFf/fpImNsaNGKHgxf3Y/oz1g9TQ/tPu44a2rrLVtE9qLOB3ic1CKD8LtWdvSzdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G+QwETGZ; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Mar 2025 15:19:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741961960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rfm2SHJGPzpJqmbjHZGEFvTtcDzNAo8vTHZ0TBp3tm8=;
	b=G+QwETGZPF4lpBTabTVHn1zefczMYLL6dFG3+c/eMhXR7n0U3UBekW0yg0x32f4eGA1wHt
	WgjMjzrkcmE29qWfRBYBeqmyPDCct3uTmOChsyyikhgwLuWF/ugadzKU5He9E1tVfiz4A6
	wRh2EBQsY2YPY4tMDxxTuBIivrX3pD8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v9 0/6] riscv: add SBI SSE extension tests
Message-ID: <20250314-eb8cf0b719942c912e254ab2@orel>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250314111030.3728671-1-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 14, 2025 at 12:10:23PM +0100, Clément Léger wrote:
> This series adds tests for SBI SSE extension as well as needed
> infrastructure for SSE support. It also adds test specific asm-offsets
> generation to use custom OFFSET and DEFINE from the test directory.

Is there an opensbi branch I should be using to test this? There are
currently 54 failures reported with opensbi's master branch, and, with
opensbi v1.5.1, which is the version provided by qemu's master branch,
I get a crash which leads to a recursive stack walk. The crash occurs
in what I'm guessing is sbi_sse_inject() by the last successful output.

I can't merge this without it skipping/kfailing with qemu's opensbi,
otherwise it'll fail CI. We could change CI to be more tolerant, but I'd
rather use kfail instead, and of course not crash.

Thanks,
drew

