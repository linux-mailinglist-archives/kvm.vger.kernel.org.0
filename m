Return-Path: <kvm+bounces-40834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C3BA5E1D5
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:30:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 066913BB6DB
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 16:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE101C5D7A;
	Wed, 12 Mar 2025 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="YpwTf8bt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA7F1C3314
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741797014; cv=none; b=EqoTS4qQUj9O6yFwwNWmiYimh2q+Kz6E3j3+I9ubbAM0udnNbQvHpkZaNQ1wBD0sIHu/kIzQgNYMc+O1ExzYvgxFvN1btyzsz/ZSorsKPDcLym72NXpiH3VAc4jWvB7B9O32mO0zLKeQhfMdVVnuRnB/WnU9S/CYHEV7HfU7jf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741797014; c=relaxed/simple;
	bh=CUxcqV7bNDrk+44O0tTdleH8+jqvPueD//YayelaczE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AihL6X/tzJF+ZeIJAM7fFFfMeiUuIEBVKOPx0J4La3RuumnYhDyejmg4QCNmEEwc6HjA4DE/Zm0R2H0auOC/up7Nqxm5IuWW0pzQOfysujj8I2kXzUZHqQjuYxd52juR02MVnsfd/PRsQMRqIYjbWr5JWK1+D3W4jZCeHw76rGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=YpwTf8bt; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38f403edb4eso20953f8f.3
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 09:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741797011; x=1742401811; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hHCzMkM4V0FCA5GSaas6IUmfm95bagI0oFQC8KFA3X8=;
        b=YpwTf8btH0XPaHfGPLWB+98snipQGu9Ow+7i2s6QHJ1ab8HO81M+MaX455ZlBwddUx
         DJVSyTtI6SWL1GofDm9jnZepLp4T5znEpSXGYRd5x6lkCFKNYibAexoSvLOpPnl6mqp2
         aphfDq9EUS/b/Vf8gpVWgABa0U2ek2d9QoouNQLse18U9u4kNFWXGNNqTErrLpkSsaa0
         Qm2xRsa3j0jF/ohBSFCSCCNDs6ObdUNJdDWuooXGy+GPE0r9rDeSsQGiel3Jr6A52648
         ajaelkubfd3YNXtvnVzZyyRzb+mYfl3Z2AdsB5/UhG2VB4kFvkiSBlC0VYN3HD2pbDue
         VbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741797011; x=1742401811;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hHCzMkM4V0FCA5GSaas6IUmfm95bagI0oFQC8KFA3X8=;
        b=fxArOQ4BfVH1hc3QxuxIfWmhIOTxoQSnm3QDn+krlFNmtt6Afj/bmygV65BaXpfPiU
         oZcEIuV0cxEKS6h7yB2G0DYGnzaD4fna/FkLv8UPx4+ACbsUhqHxwcjZPGQmrmTWI0F3
         PhWLZcVBRO+iicuvmV3c5YJXlaTdf8y2QV2geC5vQs0YLpJFJ0+jUsAUgG/JXQkb4GRA
         jxDLt2aDDPUyX8bNH4Qhhk67ZB7olmP9ppQUT8Q75wtiKRWMnUuYmD3A2SC7DmXaaI0W
         LhuwkbESW7Dff4SM5rK59L9Cr+P3QZeDNrRABbvtKvFKpCb5PyaSuB0lRRzjCR23J4+R
         tVnw==
X-Gm-Message-State: AOJu0YxHJdEyjGg6jW/vM9fdFH7ZAKWphVvqAhKzXEOLb0feFp9CUFmU
	P826nMl2KOfNS8HHNeTiiWqQQzPDFk/Vw/00AZ8y/D8R1pP734qOMXr/EH8sZn0=
X-Gm-Gg: ASbGncuUi0Quf+I5tp9o4h2JvcQE1+PUubJvrgxW1z3dJSQw/vX9Yf5HEVmLJkRhAgd
	GqTl05dWC5mgMFmaaZ+/66DT07X95vDFNQhXLAS4b5fQlLtFPA/Zk+9mDL/mEg9meKqKbrs+vje
	FBuGQN9zxCbufVJzXgL2u2HqN3wxxspPUCsfcckesIfPTpuN39X7Zqr6l08yC9Bugleeg9GjQwz
	IAGbBP+hKTv4f1LCqMEd68IzRstsvvvhVLLSDaGO7Wq5lxI4Od7wcDNT0PtgeGxbEOlHLB9lLy3
	W55mfi0RJPGN9NxYhXgc1+bRoskJf6o8
X-Google-Smtp-Source: AGHT+IFzWLdauN8zxlIPaoiRwIyIsZo3yE31HiFbBGGM34rXQs6Ax0qxux5QNa2xvRElBttvBczaJg==
X-Received: by 2002:a5d:648f:0:b0:390:fe13:e0ba with SMTP id ffacd0b85a97d-39132d70bc4mr16934734f8f.27.1741797010642;
        Wed, 12 Mar 2025 09:30:10 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfba9sm21891752f8f.39.2025.03.12.09.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 09:30:10 -0700 (PDT)
Date: Wed, 12 Mar 2025 17:30:09 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v8 2/6] riscv: Set .aux.o files as
 .PRECIOUS
Message-ID: <20250312-c9b8ee98ed38271ed7422550@orel>
References: <20250307161549.1873770-1-cleger@rivosinc.com>
 <20250307161549.1873770-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250307161549.1873770-3-cleger@rivosinc.com>

On Fri, Mar 07, 2025 at 05:15:44PM +0100, Clément Léger wrote:
> When compiling, we need to keep .aux.o file or they will be removed
> after the compilation which leads to dependent files to be recompiled.
> Set these files as .PRECIOUS to keep them.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  riscv/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 52718f3f..ae9cf02a 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -90,6 +90,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
>  asm-offsets = lib/riscv/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
>  
> +.PRECIOUS: %.aux.o
>  %.aux.o: $(SRCDIR)/lib/auxinfo.c
>  	$(CC) $(CFLAGS) -c -o $@ $< \
>  		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
> -- 
> 2.47.2
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

