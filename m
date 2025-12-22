Return-Path: <kvm+bounces-66512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F52CD6D48
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:32:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1E6FC30024AF
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE6733B6D8;
	Mon, 22 Dec 2025 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cl0cRF7B"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCE133AD87
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766424345; cv=none; b=nmsEuImDYwl2+KGJITTU4Pfz2A6GGxL8Yy1UrYPYGPeHwVI3Gw+jA9Nbf8uUejcrepUKkRopix39abm7g9gtFKIj9gr5EHS6m3XIRfh9ZEqJeu1TpSCGwiSihVhd34o0tf7adPzoSTwVCsto34iiIhU3rcftE2/Tj2EC91OZrFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766424345; c=relaxed/simple;
	bh=1EaRCLtIo5S1nAy2LLljSS1lyzWqYY6SwxtCM/xFawE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BnBpgltUulQ6QKIk0g7X4M1HzLZsRuM+vgVN72li6BPCMRlsNBEqiJogFqg7eaYVWGB89AIqRDGTcQQxhbUDKQrxd56Tfr0vq5ddeFNn682tKhjt0MS87KyuGzoEj40+5bJJHyigKCCLT4kME0BLrgvJnJZq7NpQIB2g8aSSssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cl0cRF7B; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 22 Dec 2025 11:25:22 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766424339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=byvshAmRUwrZC8GVC2vo9mDR5a//m/DN9v63+WgdYgI=;
	b=Cl0cRF7BIMaB5XtNbuYctsoztFcS9MzXisFXRp6G9r/BLHQYgENEamwlRs/rfTKh5CJvQi
	ZtdC2ohWeCh1lDeXcJD7BMrkdb5bbewXuMRS4denOS1bpv3WwktrRQKiXl4ERb1KrR2+43
	mlv5qBjJuJgQFyZjZB7YhM1C728IO5U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com
Subject: Re: [kvm-unit-tests PATCH 0/4] riscv: sbi: Add support to test PMU
 extension
Message-ID: <20251222-4edd14c1464744ef9e24245d@orel>
References: <20251213150848.149729-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251213150848.149729-1-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Dec 13, 2025 at 11:08:44PM +0800, James Raphael Tiovalen wrote:
> This patch series adds support for testing most of the SBI PMU
> extension functions. The functions related to shared memory
> (FID #7 and #8) are not tested yet.
> 
> The first 3 patches add the required support for SBI PMU and some
> helper functions, while the last patch adds the actual tests.
> 
> James Raphael Tiovalen (4):
>   lib: riscv: Add SBI PMU CSRs and enums
>   lib: riscv: Add SBI PMU support
>   lib: riscv: Add SBI PMU helper functions
>   riscv: sbi: Add tests for PMU extension
> 
>  riscv/Makefile      |   2 +
>  lib/riscv/asm/csr.h |  31 +++
>  lib/riscv/asm/pmu.h | 167 ++++++++++++++++
>  lib/riscv/asm/sbi.h | 104 ++++++++++
>  lib/riscv/pmu.c     | 169 ++++++++++++++++
>  lib/riscv/sbi.c     |  73 +++++++
>  riscv/sbi-tests.h   |   1 +
>  riscv/sbi-pmu.c     | 461 ++++++++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c         |   2 +
>  9 files changed, 1010 insertions(+)
>  create mode 100644 lib/riscv/asm/pmu.h
>  create mode 100644 lib/riscv/pmu.c
>  create mode 100644 riscv/sbi-pmu.c
> 
> --
> 2.43.0
>

Hi James,

Thanks for posting this. I'll look at it as soon as possible, but I'm
juggling some other stuff right now and also plan to be on vacation for
a week starting tomorrow.

Thanks,
drew

