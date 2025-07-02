Return-Path: <kvm+bounces-51307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A87AF5B8C
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B85FC1C434ED
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B92309DCD;
	Wed,  2 Jul 2025 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rf4N3HWQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FEB3093DA
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751467702; cv=none; b=KfOEU9pc7AG1eah0D5lTuqQ/FPPtGHRegOxBUDx6nl8zCnYj/RVQNrc6EpjWk5UoJdqjWWsovnD1b7KKo5Lu4H3P01fqA/YNlV1xa4RYrkVrlw+UmblJsHgDKphT/4S+j+bpePpxfoNQrC23j2LSbjgo0cJdTDZJp77mOdXEATo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751467702; c=relaxed/simple;
	bh=qImu94BbfcJ6pgR9vPXPjwBb9KtKKaMseKlRSQwUaDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vsy1QHXD8Ek1bTc2oOq/rv6ydZT15Ko6jutS9nRZE3HgcSvBD8hsJmJKE+eOnHdgoUVAXzab23YkF4wwZQwlfmtfdikEp1VVV4PTW/fCkJIFI/Au6ORqEfnCWdw62kVelz1j6tFyepAQprn+GDnRAnhorXDQMSilYR1VgpSzoxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rf4N3HWQ; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 2 Jul 2025 16:48:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751467698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nbthkilk4rhYuupR8Kp07gxh/gsc1k1JOjY3FMC3GPc=;
	b=rf4N3HWQkxxe5DJLjjnRwD9Zxx4HaeHVSxbcNwfxa6d6na1f8a172ZYP/+p3DTec4MBFh+
	iUopalXvAoLNLQW7JXJkHOeS+SV0fCXldF6b6LRNoTTlSp/4i2jjgd66OrT002ZbdXn/8O
	XUEXxDzB6nFdjie7st6ZvbihlGyKn8A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [kvm-unit-tests v3 0/2] riscv: Add double trap testing
Message-ID: <20250702-f69602380b206713b2711f79@orel>
References: <20250616115900.957266-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250616115900.957266-1-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 16, 2025 at 01:58:58PM +0200, Clément Léger wrote:
> Add a test that triggers double trap and verify that it's behavior
> conforms to the spec. Also use SSE to verify that an SSE event is
> correctly sent upon double trap.
> 
> In order to run this test, one can use the following command using an
> upstream version of OpenSBI:
> 
> $ QEMU=qemu-system-riscv64 \
>   FIRMWARE_OVERRIDE=<opensbi>/fw_dynamic.bin \
>   ./riscv-run riscv/isa-dbltrp.flat
> 
> ---
> 
> v3:
>  - Return an error only if SSE event wasn't unregistered successfully
> 
> v2:
>  - Use WRITE_ONCE/READ_ONCE for shared variables
>  - Remove locking flag for last test
>  - Fix a few typos
>  - Skip crash test if env var DOUBLE_TRAP_TEST_CRASH isn't set
>  - Skip crash test if SSE event unregistering failed
>  - Remove SDT clearing patch
>  - Fix wrong check using ret.value nstead of ret.error
> 
> Clément Léger (2):
>   lib/riscv: export FWFT functions
>   riscv: Add ISA double trap extension testing
> 
>  riscv/Makefile            |   1 +
>  lib/riscv/asm/csr.h       |   1 +
>  lib/riscv/asm/processor.h |  10 ++
>  lib/riscv/asm/sbi.h       |   5 +
>  lib/riscv/sbi.c           |  20 ++++
>  riscv/isa-dbltrp.c        | 210 ++++++++++++++++++++++++++++++++++++++
>  riscv/sbi-fwft.c          |  49 +++------
>  riscv/unittests.cfg       |   4 +
>  8 files changed, 265 insertions(+), 35 deletions(-)
>  create mode 100644 riscv/isa-dbltrp.c
> 
> -- 
> 2.49.0
>

Merged. Thanks

