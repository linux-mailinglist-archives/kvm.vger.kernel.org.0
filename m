Return-Path: <kvm+bounces-25743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6016C969F99
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0ABBA1F247F5
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 13:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06AEA2A1D3;
	Tue,  3 Sep 2024 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="scwwnekS"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC021CA6A1
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371910; cv=none; b=Gb3jM/FsfpoP1pvmEbAoPsS2R7Or/NGMr3PB1DD0GyqXVjg+FkDzt0bV2OfGCCjM1xOjT4VPMuMOjX7yoe6rF2GTY6jgvuXqvBp/NozA7o7tvkQHrwi9f0r/LZHz4kxccrA/R9VVo5aMqBUbBzaa10fDA0PxtOjz6PF/WdGcn4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371910; c=relaxed/simple;
	bh=mlc31i6gK7zTxcbcpZ/jTcusEq5jxc+b1PR1B4fv0lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8w5vzPYYQVQcCa85fJLtf7beWYYokA8GPaVQM4oc+5x39KjeZBUfkPzKgEsvqWOoM8Ol4frR0ipB0vr7+PSc7hDy1ewteqoeHbpds/2nWYrPCybBVCTntV49eY3sgukGZUgXGVvfOSTn8plsVy7vygIxLVZa61IXEamdDnpQ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=scwwnekS; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Sep 2024 15:58:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725371906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C7kJPJlH/FwJ0rpbcSmUgY+vGaLaGAX9iLPEEOV5Hnc=;
	b=scwwnekSr4/786Xl/yIHfnIqysgcMEJ21PJ3MwWpgGTkZc9a0nFp1GP0EfqQYDzt29xMrp
	L8EZAX9v52YJzvw2Tgtu5SToXwAHvo6FZiMe0nGnf/1wOHrSoBUFcBm5CamO2GKrx7eG2i
	YlaQeygLt2yzvsFbqzmL7lXOVGmZo/E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 0/2] riscv: sbi: Rename sbi ecall wrappers
Message-ID: <20240903-335afb7445c803c23e1f1297@orel>
References: <20240830155337.335534-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830155337.335534-4-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 30, 2024 at 05:53:38PM GMT, Andrew Jones wrote:
> Just some renaming to improve readability and also add another DBCN
> test to ensure we only write a single byte with write-byte. Use the
> "raw" ecall for that because sbi_dbcn_write_byte now takes a uint8_t.
> 
> Andrew Jones (2):
>   sbi: Rename __*_sbi_ecall to sbi_*
>   sbi: dbcn: Add write-byte test with more than byte given
> 
>  riscv/sbi.c | 48 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 30 insertions(+), 18 deletions(-)
> 
> -- 
> 2.45.2
>

Adding the missing 'riscv' prefixes to the patches and queued
https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

