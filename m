Return-Path: <kvm+bounces-62586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF304C494A9
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 21:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FC193B437B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 20:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA5C2F5467;
	Mon, 10 Nov 2025 20:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="htuAqLZ4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="W1pcFNtX"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680472F291B;
	Mon, 10 Nov 2025 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762807347; cv=none; b=lysskvUAiExUfC+tFAC+Floa4Q7j5i/KPtcr0Dfzpwq0dwWBrxnbAnZCHu4dLgno5GgadBb+S5w7iocrL2JNCx1Q5SkCwtIO/awU7mlxvycMj3C7jah+vyiBSfi0hYrHxjRSH1rb3IJeQyLXjTAdtaEOqJ+K0peFSKe9R6VHMv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762807347; c=relaxed/simple;
	bh=EVZlZ6pxpX8LL3e1/kedrfN4wUWfo9Ezw2G03AI99jE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fi0vyutT7WBs6aU0w+xNF3bahL2GS9TQ3qVwvzd2PSq71W7oayLszx1k1HgKPXpPLPvRo9WU1hiQEDDcg+33vQcz42o5kWdybDi3e7ZY7lNu7UDRTdZiNqzBPvg0ZhGtItMPxtiabLM+E5JALVF9vta0nbVA+L2pFbVBgmDtt/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=htuAqLZ4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=W1pcFNtX; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id C4D701D000F8;
	Mon, 10 Nov 2025 15:42:23 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 10 Nov 2025 15:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762807343;
	 x=1762893743; bh=gqeX2If3HYh30yCslpotpD1eSH8ukdg4bxJbH47uciI=; b=
	htuAqLZ4SouJYoITuzsRhJjEXMvYg51jdhYpfuNbonoAiCijob/69evbidTgy+sh
	iRd/focxifhKHG29GSovKjpd+ZahK1KX4u/ZS5xwu1cwXqVC/UCcfTwYH5JPDv12
	hGHLp/nV+WavmCJRl9wTrZikJq0k+REA/xuHpzuBgd81DF7sIwQG9Nn6LXDccuBp
	Kcbv2MQHhh0bNcI9y7090F/H/ONHQBQn0M3YoNGcqHaUJhgJYpUOx9LyevwJdnFy
	Ict245DxpPf6jiaMEQZaHVfubTy/2FN5JOeKQcWBk3z0YAlBC9LITZ62vdXk1Y/c
	Rd49/UzrTC9Hg0y+GBi9Hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762807343; x=
	1762893743; bh=gqeX2If3HYh30yCslpotpD1eSH8ukdg4bxJbH47uciI=; b=W
	1pcFNtXWP9fMq2c7Go8PGx8HwIWpuPF2lBF5s8fzNuWqlubpSf71I4RGXc/+pwcE
	wq+IM4acQDpUfJS8lOK336Hg+6Yhp/JfxC5SEFBEOLYskuuF1zMvdgewgnWx52X/
	fNOBJyzaAv96LswEo/scIGTSRxWJi2ZUU5XAvFuOshhDJGBo38Xa+K5zj1omajl4
	9Nzw2IiBoN/XHZmZW4L1O2XuQ5m2ygcV/Ej73MJG4tl8Yp+XoKJ+BgkgvopLu2GH
	obrv7xcViS0KT+tbc+wUE4u16+09BsabKp6VUrTPLyomAqmaiXC7s3Fr/VvCaEMh
	I3yt1TVyxJAxtgG24ZoJw==
X-ME-Sender: <xms:Lk4SadPf7Z_61ugy1UZG-S0z50mLGWjkeWFW-KUtptz0WE1qSwYswA>
    <xme:Lk4SaWQnTbNosFeU6S8-IkOOxvD-vMp6PSlA7UVcS1gFInm63zNeLDUnY47L26hp1
    UJx5XZp5pVS_p1iGPb8C2-PW03MLsP60V0ld5GGp6ghlpo8mHKR>
X-ME-Received: <xmr:Lk4SaSQT-qKgrv4djpFBdctnnMfQHHqqcvgPYrMcvkpGGEF5Ve9ebvTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleelfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeefhedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhoghgrnhhg
    seguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrug
    hkpdhrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthht
    ohepjhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgt
    ohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
X-ME-Proxy: <xmx:Lk4SaXAf2U3xTIUQxs8i0IsnHoTy1Jl7o0BH0TlVy7zhF4WWB901JA>
    <xmx:Lk4SacCXUZGgOPwzyeCst1KYlCMu_DTngssMm-yanfi8GAiSreZfOA>
    <xmx:Lk4SaYxVBS9qwrWpCA566IQDcrCbii10ahjD77GRLJBh3SrN6LWZAw>
    <xmx:Lk4SaejgdRKg7EjLQE1Gk-cfpzoWXZw-pFjsodEgU8MMWqFzLPeaiQ>
    <xmx:L04SaZr36QwMGCQIKH-kIOIQH3332nOSuBo78ltSYdTNpyhWUvhiqLCC>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Nov 2025 15:42:19 -0500 (EST)
Date: Mon, 10 Nov 2025 13:42:18 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
 Nicolin Chen <nicolinc@nvidia.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v7 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251110134218.5e399b0f.alex@shazbot.org>
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  6 Nov 2025 16:16:45 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> Changelog:
> v7:
>  * Dropped restore_revoke flag and added vfio_pci_dma_buf_move
>    to reverse loop.
>  * Fixed spelling errors in documentation patch.
>  * Rebased on top of v6.18-rc3.
>  * Added include to stddef.h to vfio.h, to keep uapi header file independent.

I think we're winding down on review comments.  It'd be great to get
p2pdma and dma-buf acks on this series.  Otherwise it's been posted
enough that we'll assume no objections.  Thanks,

Alex

