Return-Path: <kvm+bounces-32434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4DF9D870A
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:49:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8556AB2F37F
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F0F1A0721;
	Mon, 25 Nov 2024 12:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vx0Z21Kl"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6699B194A43
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 12:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732539133; cv=none; b=VaMgqMxjwqPWUl+lCksyUnb473LU0js7jv6na+d+QbPEXNZlFYmEpRYS8EmmFgxQp2ijZPXo5K7IcSHbjzF9XX3KcQ2KAn6BLsJSHsnzT7ynKmoL/hVInS3qdW3mqL8ucETZke1aDN4F/1USHALixnyqNDDc+fLWOR1/J/OuPX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732539133; c=relaxed/simple;
	bh=qIIVA5PGNLrqDZ9ZqauXcyZiMlklUTczhmGBrKkpCp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzgBeB7A6hvEhPPn5wPPIHEfEizl5WMS4fWwCIBgXAK/VKTsieqJhQk6GqSIbsGB3HX0/nQWLRVTrxgjw750HBcLDHd0hjvPRjRqwgEXLD/w3kL6iCv97URB9GQAY1CJOswfm43ZWlNxYar04Nv72pijBYgymLb19ZMDZnahPcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vx0Z21Kl; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 25 Nov 2024 13:52:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732539127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7zF1+KLd7ZwfMP07MIAdOXgylmQ2DJCWWxSFBRZrVhA=;
	b=Vx0Z21KlOj0k1cOPSeBCkHe2BIZbP/t97u3lTjiLJzplduujaMCEZDyu6L76zLwNaGgnId
	Ctu3WoKNBsMu+GT6DVMG32BEdwMukJ4uFqm2UirrUQayk7DAP9c00y2A6kpaZPQF+Kta2j
	/4U/ma9hxbohpwPDIJunc00rXJprs2o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/4] riscv: Add "-deps" handling for
 tests
Message-ID: <20241125-cdb4055c9d58e66f04fc5db5@orel>
References: <20241125115452.1255745-1-cleger@rivosinc.com>
 <20241125115452.1255745-2-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241125115452.1255745-2-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 25, 2024 at 12:54:45PM +0100, Clément Léger wrote:
> Some tests uses additional files that needs to be linked in the final
> binary. This is the case for asm-sbi.S which is only used by the sbi
> test. Add a "-deps" per test variable that allows to designate
> additional .o files.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

