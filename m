Return-Path: <kvm+bounces-41563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB6EA6A784
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1B8D7AC954
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38EAF22173D;
	Thu, 20 Mar 2025 13:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s4Kuds6B"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2D32AE8E
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 13:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742478422; cv=none; b=UeR13e3tF9Ao4sAdS2gVs1KsfcdybjDQ9Rv5DtxE9p7wnLaR+gDQ1vcWRx032fa31rcwjXTGmUxBuNDRbl9dlLp54ahqNKc/3OYGKMbzrrdGEZf3fbI17tLwOoOtcq96J14DnLleelVqGTleAtLXCdPQiJKEBEmWqVlZWpXA/8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742478422; c=relaxed/simple;
	bh=yuWM3CwZi+3/xscFYVUnm/00LkhC6Fj9fGr794bCrBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eD+E4Bvlq+ZrOjZWMD7fgrKDKsNInNSwBmLFpREA+d4RBD59XIlnSpqhxtmv+mquAa2X0BRy9X30ItzZq57RjEgvQ8nn6fdHOwzzQR7dUqEao5dUZkH7mYSpwipsTgDZLttKHFwez6R3HMTooa/Smxj6se8e4/PhqyvKQnJ0gGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s4Kuds6B; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Mar 2025 14:46:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742478417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=46D2P77DBtjFb7Wuj1uG9v4TuAsKB5wVdzf8FSrE/zw=;
	b=s4Kuds6BDNv1Zh6U/DsYXx7tBEGVwB64MIVaHNzOhrmjkiRjNtMvqUWlNp145pV//sVr05
	rWpMNTnapkIfewXmKc45pDovhjjT2NSTm4UoNQexAApQn2O2tjP1SmLoBo9ZwYxuiqKTdz
	LBoRZ8CUDczC444/lPx54Mm4rxbRTJU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v11 8/8] riscv: sbi: Add SSE extension
 tests
Message-ID: <20250320-48e2478cb96a804bfb1008e3@orel>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
 <20250317164655.1120015-9-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317164655.1120015-9-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

...
> +cleanup:
> +	switch (state) {
> +	case SBI_SSE_STATE_ENABLED:
> +		ret = sbi_sse_disable(event_id);
> +		if (ret.error) {
> +			sbiret_report_error(&ret, SBI_SUCCESS, "disable event 0x%x", event_id);
> +			break;
> +		}
> +	case SBI_SSE_STATE_REGISTERED:
> +		sbi_sse_unregister(event_id);
> +		if (ret.error)
> +			sbiret_report_error(&ret, SBI_SUCCESS, "unregister event 0x%x", event_id);
> +	default:

I had to add break here to make clang happy (and same for the other two
defaults without statements).

Thanks,
drew

