Return-Path: <kvm+bounces-41560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B047A6A771
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:44:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5ADE3A52CB
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95D0221F3A;
	Thu, 20 Mar 2025 13:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aMNW8sD9"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838981388
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742478025; cv=none; b=OaeQLruHLmw39BLrDmJ+8t/f/m1V5/EMSzzEMH/5kcCAR5pl/YMaGXU2nVOGQMZ63Ud0LIvb3UH/tboSKadrP+u52zwXYcyAq6dLncWxLqZjd0qF49zMBTOI03SPlbNYbCuIx1HR0v78qXkLXgzNbusBCz2uLFVzK8nGbSA9bDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742478025; c=relaxed/simple;
	bh=xKoF/w7zBI701vidANCeg4XZQ/AUh9ubFlHu9W92850=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPnHMQ2mV27MxYXWJ3jItmW3H0TmPrUqKD/e8q8HzYn/NXYVwYlugTnJ+XOrkXxWUWq9hb4KZVKbnnmCNCN77CSLxkOvY+ea6hiMPS6tdUb3hwuTtEpPA06jRD2T/p+E2VCZAW669Yl3ZopOXkZ85wUJpz9O3iI1O2nfRzepQ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aMNW8sD9; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Mar 2025 14:40:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742478020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1neApBu3SJG242Qb7WO9zeFzwoqW5Iefa8BG31bcyE=;
	b=aMNW8sD9Z12Y/vxvQU8WSSwsVlPyfbRb+sOx4+oMYqfcspx6LjfRk6m16f3SARKWznu0Hj
	nVDy/3ZyVKNg7YBQjGmWSaeL4gKEdlgpU/uDHnVTUkaJ6OjXmQWSzR7zz6ucZjVaXo2jIw
	QGHH3lDmdsQdNwrpsLJJVpFdpop9GJw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v11 8/8] riscv: sbi: Add SSE extension
 tests
Message-ID: <20250320-ab264d08531d4ff10b874485@orel>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
 <20250317164655.1120015-9-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317164655.1120015-9-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 05:46:53PM +0100, Clément Léger wrote:
...
> +	/* Test all flags allowed for SBI_SSE_ATTR_INTERRUPTED_FLAGS */
> +	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
> +	ret = sbi_sse_read_attrs(event_id, attr, 1, &prev_value);
> +	sbiret_report_error(&ret, SBI_SUCCESS, "Save interrupted flags");
> +
> +	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
> +		flags = interrupted_flags[i];
> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
> +		sbiret_report_error(&ret, SBI_SUCCESS,
> +				    "Set interrupted flags bit 0x%lx value", flags);
> +		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted flags after set");
> +		report(value == flags, "interrupted flags modified value: 0x%lx", value);
> +	}
> +
> +	/* Write invalid bit in flag register */
> +	flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT << 1;
> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
> +			    flags);
> +
> +	flags = BIT(SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT + 1);

This broke compiling for rv32, but just changing it to BIT_ULL wouldn't be
right either since SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT is a BIT().
I think the test just above this one is what this test was aiming to do,
making it redundant. Instead of removing it, I changed it as below to get
more coverage, at least on rv64.

Thanks,
drew

diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
index fb4ee7dd44b2..f9e389728616 100644
--- a/riscv/sbi-sse.c
+++ b/riscv/sbi-sse.c
@@ -495,10 +495,12 @@ static void sse_simple_handler(void *data, struct pt_regs *regs, unsigned int ha
        sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
                            flags);

-       flags = BIT(SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT + 1);
+#if __riscv_xlen > 32
+       flags = BIT(32);
        ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
        sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
                            flags);
+#endif

        ret = sbi_sse_write_attrs(event_id, attr, 1, &prev_value);
        sbiret_report_error(&ret, SBI_SUCCESS, "Restore interrupted flags");

