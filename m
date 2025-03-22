Return-Path: <kvm+bounces-41747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A0DA6C9D1
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 944767ADD9A
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 10:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84DF1FC0EA;
	Sat, 22 Mar 2025 10:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sluOk92j"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8151F8F04
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 10:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742640446; cv=none; b=V+D73bBw+wOcA3HY6lXDSaUbKJiYfxVNJwJePY3upKav3xw3Czz5aaiwTBS0zkRrBiRUdsuk/KWBHQ2EcezSrkN1CUDdnpOlnJSNHhfsEkHPgM34udtP36flV3pQzJ6Bz4D6B/HRtJ8IDimwUKtO7pWFDK1R9WNFf/6X2dqhCss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742640446; c=relaxed/simple;
	bh=skahNnTbLCnHqpl25kNdePGRE89KJb5V8/7j05Ttjjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKpeuO1u3daPHshzjFpknJkrXIIYQMcWypP9ov64FXwFyBNaDxSi4pPItTQ/J3kjNewL5NpVwul5aeBWFTX0XLE/a2YHLucbMeOUFgdYlqcS6NOQ4v5OgBAAL44vwEW7tZU8K6OBsIOw6JkC8nGTuDPhRQ4ZlYZbAukzfAsqy1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sluOk92j; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 11:47:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742640436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qtWGS+cnaJZc69h7e8Nnmx/GjyNyfzHViayLLb7oOu4=;
	b=sluOk92jOKy8XuRGlckPPQfhvoO+7Xz7ry35lmhUmEeYa4ti413/EUid7YVRonz8YFKIR7
	4kWbKwUg6wSDnE8bgdzMRE5FNpr6TtySLQL3CzxxkZMRLb671GgEYNsHdGF8MKSstzhKX1
	/WoT8zJEv41Jdy/ENYuZj5FUxpDK3Ks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc: cleger@rivosinc.com, atishp@rivosinc.com, akshaybehl231@gmail.com
Subject: Re: [kvm-unit-tests PATCH 0/3] riscv: sbi: Ensure we can pass with
 any opensbi
Message-ID: <20250322-58f9c16024c28e345fd7ed02@orel>
References: <20250321165403.57859-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321165403.57859-5-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 21, 2025 at 05:54:04PM +0100, Andrew Jones wrote:
> At some point CI will update the version of QEMU it uses. If the version
> selected includes an opensbi that doesn't have all the fixes for current
> tests, then CI will start failing for riscv. Guard against that by using
> kfail for known opensbi failures. We only kfail for opensbi and for its
> versions less than 1.7, though, as we expect everything to be fixed then.
> 
> Andrew Jones (3):
>   lib/riscv: Also provide sbiret impl functions
>   riscv: sbi: Add kfail versions of sbiret_report functions
>   riscv: sbi: Use kfail for known opensbi failures
> 
>  lib/riscv/asm/sbi.h |  6 ++++--
>  lib/riscv/sbi.c     | 18 ++++++++++++++----
>  riscv/sbi-fwft.c    | 20 +++++++++++++-------
>  riscv/sbi-sse.c     |  4 ++--
>  riscv/sbi-tests.h   | 20 +++++++++++++++-----
>  riscv/sbi.c         |  6 ++++--
>  6 files changed, 52 insertions(+), 22 deletions(-)
> 
> -- 
> 2.48.1
>

Merged.

Thanks,
drew

