Return-Path: <kvm+bounces-32441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C209D8723
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:54:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6095E285113
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158511ADFFB;
	Mon, 25 Nov 2024 13:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mZwPhnyB"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000FF19258B
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732542838; cv=none; b=qgS1NEjMGaK03Se0yoHjPWzbk/3vqAH4nnIMz0SKe8FnUqBafIxGkmNm6FPlm20y5mLAItkHMXKMsvdhfsRA02xBx4Bx8wny4p5ZDkkc1Y0gyEoFRkKqwbMFcMJxwIaBGzrWDkPDrcv/G3ZajbTOxP6JepUweaY/dSmv2EKoVXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732542838; c=relaxed/simple;
	bh=uYkbiZjeQSSL5Pg+lQu6Ku0WlfNsiun/wS3f4qpwSi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVipKek6U/jJylgbt2Bbpyxb/ddQbdzu/3gUT+yPuHF4C18gzw7HQeTYxwi9LeHetsUv1Wvheh/za3WnbbJgKH8sY+kmdciZsGR38H5TRfMAtvEnN6+YLL54VtkDJvLbdMIXODJFjieO1XMAnPgnttavtp616v3gtCXrmMWtKLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mZwPhnyB; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 25 Nov 2024 14:53:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732542833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uYkbiZjeQSSL5Pg+lQu6Ku0WlfNsiun/wS3f4qpwSi4=;
	b=mZwPhnyBp63MzELQQLssEpRPa9A9XTG3p2vevTA8IDHXUT8EGpCjD+N+F2MCs0JrlCjGuU
	msj2fcYx59vPTclMpT6LJfZZsRt6lzQ05VxbIUQ4KbQVz8rR0jZGQJF0Q9675GYY+Eu5Zw
	rI/UjruWvd4L6IQQW+K3okHMOjXQe8I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/4] riscv: sbi: Add SSE extension tests
Message-ID: <20241125-01fae59d27bb81fff71e794e@orel>
References: <20241125115452.1255745-1-cleger@rivosinc.com>
 <20241125115452.1255745-5-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241125115452.1255745-5-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 25, 2024 at 12:54:48PM +0100, Clément Léger wrote:
> Add SBI SSE extension tests for the following features:
> - Test attributes errors (invalid values, RO, etc)
> - Registration errors
> - Simple events (register, enable, inject)
> - Events with different priorities
> - Global events dispatch on different harts
> - Local events on all harts

And now also double trap and mask/unmask.

Thanks,
drew

