Return-Path: <kvm+bounces-41070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73751A613BA
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37E02462219
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F3B200BAA;
	Fri, 14 Mar 2025 14:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lOu1BjIu"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850131FBC94
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 14:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741962877; cv=none; b=TdGUZOurPnrG8FFTwdQL5pMI0tYx/qRK5USLysLrDwSTMR37cgNAxTE1oX0B9i/6g6WFakFR+2fXKTxvXaFmUj9YrOXHGqIAn3rgquql+hlgc1Ot2oiN55WU9mbS8b4FcOO2h+E6c/kC77ZGLkArfXO5QUm3v8kLZXBNZ/yx1Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741962877; c=relaxed/simple;
	bh=VRVWWgHvtEqTQgiElIeMpGkci79o3Ta9hrVLQQP7uS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mullttronwmg4SYDDZAOQ2aVE7WN5PMsAchIe1NqV3UROa2N3UWUz0LP80esYyEuwYTmwuTJMgs+0mykLfe3rzPc5mFZGNV/AHYD9IHE423AqmRLbOnFILsNQ3CwZq7M6pzj+IIyF4NxJAjebUhbcEE0L2O0I/W+NJfvMQdulVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lOu1BjIu; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Mar 2025 15:34:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741962873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQtXn7EfOwi88ok7c8Xwpnh/hZw+xkgnM8G54+S4Ae8=;
	b=lOu1BjIu03QWispt+Xs/80b17zsC4eW/Zjf78alvB71TRKZk4VIL1JkSt+KxLoChEIhr0Y
	z/bftBI0MrVBShwhdGTsGTj2T5sHFTEgv0XV7xtXFfjEmzG6dxr6CyjseU9otn+1EW+KYL
	4XdAz7AsgP2qgEqBQC1dF8uqtdbGvmw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v9 0/6] riscv: add SBI SSE extension tests
Message-ID: <20250314-2452599f59b82e53e99100e7@orel>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
 <20250314-eb8cf0b719942c912e254ab2@orel>
 <eaf88dbb-39bb-4755-830a-7c801099c790@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eaf88dbb-39bb-4755-830a-7c801099c790@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 14, 2025 at 03:23:39PM +0100, Clément Léger wrote:
> 
> 
> On 14/03/2025 15:19, Andrew Jones wrote:
> > On Fri, Mar 14, 2025 at 12:10:23PM +0100, Clément Léger wrote:
> >> This series adds tests for SBI SSE extension as well as needed
> >> infrastructure for SSE support. It also adds test specific asm-offsets
> >> generation to use custom OFFSET and DEFINE from the test directory.
> > 
> > Is there an opensbi branch I should be using to test this? There are
> > currently 54 failures reported with opensbi's master branch, and, with
> > opensbi v1.5.1, which is the version provided by qemu's master branch,
> > I get a crash which leads to a recursive stack walk. The crash occurs
> > in what I'm guessing is sbi_sse_inject() by the last successful output.
> 
> Yeah that's due to a6/a7 being inverted at injection time.
> 
> > 
> > I can't merge this without it skipping/kfailing with qemu's opensbi,
> > otherwise it'll fail CI. We could change CI to be more tolerant, but I'd
> > rather use kfail instead, and of course not crash.
> 
> Yes, the branch dev/cleger/sse on github can be used:
> 
> https://github.com/rivosinc/opensbi/tree/dev/cleger/sse
> 
> I'm waiting for the specification error changes to be merged before
> sending this one.

While ugly, I'm not opposed to doing an SBI implementation ID and
version check at the entry of the SSE tests and then just SKIP
when we detect opensbi and not a late enough version of it. If we
go that route, then please create a separate patch that adds a
couple functions in lib/riscv/sbi allowing all sbi unit tests to
easily check for specific SBI implementations and versions. (We'll
probably want to steal the kernel's sbi_mk_version and add an enum
or defines for the SBI implementation IDs.)

Thanks,
drew

