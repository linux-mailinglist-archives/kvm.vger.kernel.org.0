Return-Path: <kvm+bounces-48262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C58ACC0D9
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0949B1890DA5
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BF326981E;
	Tue,  3 Jun 2025 07:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lXdXRGwp"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454D7268C50
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 07:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748934643; cv=none; b=cEhpInSknU7veD10kIp61b6GI2ykVLwGfqjmIij6B4PCJT2K2l4AuDgClFZ6SCdxgvwOXsBE5NS7qLJhyd3/EMTWftjfJ/yfLGqcmfDTJgFqDs+EHKJ8UAgfOTsGvxStdBy4IjHcaR0RJIz/GCaFFGForuq7NNLstPWqazN1hgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748934643; c=relaxed/simple;
	bh=i9JjLC6OOGK8RP0zDfp1k96ZgHQFnUUWUJtR2jwjjv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmp3cvzmpULVsuJqKIp4z4wkdvy31Os3DDY5K3VmY0bOVxrfwoABMW1Q4VftW1HZqkffSTV8N8INzRfJO1XVzQYALUnPVIDWq0i9KuPRd1/Dv5OXCsxIinEOkm8SHP/ZKEYAA48oNS+HoIDDTyRzz85HLmsMzqOQIsZxjj/uZKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lXdXRGwp; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Jun 2025 09:10:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748934638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TGPsKIcTmlOWEH5ktRv3z8GmqOkCSSJSkOu9iMxAxoA=;
	b=lXdXRGwphJKffE/ICKc1VNQZPTZWq0OzxQFtu62KSKMzc/0uf1a195MW4XVY2SZjO3trZa
	sqIPeP4lNad/CHt+HU0iS4QMWsI/uJqrbnYpZqJfkm9672s4FnNnORhRwDztoHZFqw59tq
	RZfow1Wx/etN43rcuYFySx5FkZKhCFY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [PATCH 0/3] riscv: Add double trap testing
Message-ID: <20250603-ae5b10c63b6ac83d206343fa@orel>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250523075341.1355755-1-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT


Hi Clement,

You may want to add format.subjectprefix = kvm-unit-tests to your git
config, since it's missing from this series.

On Fri, May 23, 2025 at 09:53:07AM +0200, Clément Léger wrote:
> Add a test that triggers double trap and verify that it's behavior
> conforms to the spec. Also use SSE to verify that an SSE event is
> correctly sent upon double trap.
> 
> In order to run this test, one can use the following command using an
> upstream version of OpenSBI:
> 
> $ qemu-system-riscv64 \
> 	-M virt \
> 	-cpu max \
> 	-nographic -serial mon:stdio \
> 	-bios <opensbi>/fw_dynamic.bin \
> 	-kernel riscv/isa-dbltrp.flat

You can also do

$ QEMU=qemu-system-riscv64 FIRMWARE_OVERRIDE=<opensbi>/fw_dynamic.bin ./riscv-run riscv/isa-dbltrp.flat

Thanks,
drew

> 
> Clément Léger (3):
>   lib/riscv: export FWFT functions
>   lib/riscv: clear SDT when entering exception handling
>   riscv: Add ISA double trap extension testing
> 
>  riscv/Makefile      |   1 +
>  lib/riscv/asm/csr.h |   1 +
>  lib/riscv/asm/sbi.h |   5 ++
>  lib/riscv/sbi.c     |  20 +++++
>  riscv/cstart.S      |   9 ++-
>  riscv/isa-dbltrp.c  | 189 ++++++++++++++++++++++++++++++++++++++++++++
>  riscv/sbi-fwft.c    |  49 ++++--------
>  riscv/unittests.cfg |   5 ++
>  8 files changed, 240 insertions(+), 39 deletions(-)
>  create mode 100644 riscv/isa-dbltrp.c
> 
> -- 
> 2.49.0
> 

