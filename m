Return-Path: <kvm+bounces-23862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65B8C94EF5A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 970ED1C20F73
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9D417E46E;
	Mon, 12 Aug 2024 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cwhJ5lrt"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C785A16B38D
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472296; cv=none; b=R2KqAD86UBBb0Tbuew2tzj/DUF1LsYcFomddJtDeKCdCrX2HFuEPNJR3Sdm+T4fsXv+lRBHaI/jAjMZ6a/54lzMMRJPce+xgWtOM1rx8iGY7YfS0WJL35Gz/GtI7P8+okVtSaw2oK+U9s1g0HLzbgixRGaK98roFil0tJglM4Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472296; c=relaxed/simple;
	bh=+XqXRdRDS7fH/Qr4dLMgiIgHdP7tqvnCJ5SS8TKCTLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNmHBr6Cx9TAPQYuNo4iJtLFIozTGNSHRy4rTpkX6haT8n3GDIEj17MWiJNeJWiRsazit3RTcop4DV3SNaNOsMomdo0r5nPWPEe3E5MrzrDG0wuU/Lr1M72wc9kCbhDDIUo2yt72Y/5YbTKZ5rewGPrrjS40jHGGUqRajYpPN1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cwhJ5lrt; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Aug 2024 16:18:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723472292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nXVtc9Ey9rgRBdNJC/nm2cLjyxf+MaJ3vC2dOyKPuAI=;
	b=cwhJ5lrtZVEXe/CiYwTQzTdGBrn2Qf0n12LPvKe3clELTtH3T55PoQ8e2p8AQ2L9qc3X5B
	ELKQ1X1geg+FCiNaENJ4dIzI9+7MseFEqrlTRZOuyujo3YB9gqgQPkFV9hueOSvJgUsvcE
	p03SrbZ3bI+Urrs7d/0Ew85tYqSodHM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 0/4] riscv: sbi: More DBCN tests
Message-ID: <20240812-067579d76c30484592009ced@orel>
References: <20240812141354.119889-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812141354.119889-6-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 12, 2024 at 04:13:55PM GMT, Andrew Jones wrote:
> The current DBCN tests found a several bugs and with high address
> support for rv32 we were able to find even more. Add the new tests
> which checks high use page boundary crossing. The first three patches
> a various improvements to the SBI tests.
> 
> Based on riscv/queue, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv%2Fqueue
> 
> Andrew Jones (4):
>   riscv: sbi: dbcn: Output return values
>   riscv: sbi: Use strtoul to avoid overflow
>   riscv: sbi: Prefix several environment variables with SBI
>   riscv: sbi: dbcn: Add high address tests
> 
>  riscv/sbi.c | 163 +++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 131 insertions(+), 32 deletions(-)
> 
> -- 
> 2.45.2
>

Queued on riscv/sbi, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv%2Fsbi

