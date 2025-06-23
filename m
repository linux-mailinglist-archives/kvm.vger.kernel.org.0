Return-Path: <kvm+bounces-50393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C69FAE4B62
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C01D13B8A29
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0966D27816D;
	Mon, 23 Jun 2025 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HwVoKr7J"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDAE26D4D9
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 16:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750697388; cv=none; b=RRVXApydPZ4A8uxt+DLVHETNYjSayhWVzezqxi7GEAvvOPVKU1kqbCc8b+tJ7MTGnshdI1Juiz1Dbc8ibQP3Jzx5W+8luRDXPZHmekQ7x4wiDGBo1Ljtsl7zj4AxeVgk9Be1guH3ZphQqhVPw5pnrctWlj09HRZ8M3sDt3L6blA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750697388; c=relaxed/simple;
	bh=gM+nAk0KVwQWW6q53BbnWWciLaorwoVn5lGi9ljsFNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/kmHJG5ntgZbsyxJ2WIAH6ed2aF3t8YWiyYnPWdoHXH15Ounmn6ZGjr/UwMmkp5M+vgW/HWGa20sGd/2ej2oEk5ms4GCpv3RevktBrLE6DbbrUxc81rnLtY10nQA2+beArVYWq1jDIW+4dPo8Mk1A6spe/Ld293SU5NvNq/ZF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HwVoKr7J; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 23 Jun 2025 18:49:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750697383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HqRjLcZdOZFq89doRZdoZM2ySs8Gc+mIIvErbU8ZPgg=;
	b=HwVoKr7Jw0gxN9sXK+UUnD8GtqhWcljktu/GM0k9LZDh8pSGgZTVCEeYsvt9ViR+4ex630
	kZNlalWYAf9d5VBruVzGq+BocugxQbZ1LMO19GtZn84FTgus+sJYGxmZd9YiVH6Kto4QcY
	XwibfQ2PL+1vXOw3TC/SleCN2SX5xDE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Charlie Jenkins <charlie@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] riscv: sbi: sse: Fix some potential
 crashes
Message-ID: <20250623-67f9a093878a1062f19067a0@orel>
References: <20250623131127.531783-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250623131127.531783-1-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 23, 2025 at 03:11:22PM +0200, Clément Léger wrote:
> While validating another SBI, we encountered a few crashes and errors in
> the SSE tests. Fix SSE stack freeing as well as handler call checking.
> Also add READ_ONCE()/WRITE_ONCE() for some shared variable.
> 
> Clément Léger (3):
>   riscv: sbi: sse: Fix wrong sse stack initialization
>   riscv: sbi: sse: Add missing index for handler call check
>   riscv: sbi: sse: Use READ_ONCE()/WRITE_ONCE() for shared variables
> 
>  riscv/sbi-sse.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> -- 
> 2.50.0
>

Applied to riscv/sbi

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

