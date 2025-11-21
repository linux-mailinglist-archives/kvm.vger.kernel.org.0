Return-Path: <kvm+bounces-64170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 86556C7AD2A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 17:25:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5C66835C70B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 16:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D830134D385;
	Fri, 21 Nov 2025 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="iVYxelnp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UvzaBNSi"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5363C33E341;
	Fri, 21 Nov 2025 16:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763742270; cv=none; b=j3FC1PVhEEWpjoMUaLRBgE4cLbjeaLpj4GIyCAAB24enHpRhvosLiQOvUo7VUgrW/zu4JXBhRYgTB2ZPAl6ku1rE4qfIM0p6Zp/g1O/h5L6Z+0ybgOxZvh29c6CjAkTMuLkze1UYph5GNEdA0Sqw1V7911mWr/BhtwMUO2MseNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763742270; c=relaxed/simple;
	bh=+roBNOCU2FTSHuPGdhzpgEM5wzJA/OhVLab+j8XE08E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xl0Zm5YGCV8SEmv2L0YJIDkBVn92iVyo+0gqZxcu2zoIXFn+o56yXM2MriRKuQQ7spC+ivtRqVQwNJ8ZkdB6NGByU7HkY7dZ464VcfSc0peQvJrcKIqqHlvQq+4TuCrHd3TNYWjBdr7sZ7RUWxXGMglIrOVORpred/KLhp9VDv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=iVYxelnp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UvzaBNSi; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id A04FF1D00156;
	Fri, 21 Nov 2025 11:24:25 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 21 Nov 2025 11:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763742265;
	 x=1763828665; bh=y9sPmO9ctPmEofVcJL2ve0sLdAoEmPz/dsTzOswFhgc=; b=
	iVYxelnp6m8nPDJCJD3pghiuY0JnfpXoWiKDtyC1ZfTMF8fUQtXTaMX5yXfbLont
	ST9OiZCOgXI8ULRFc6aFOTV/tf4SKt4W5wcQbP9AJZVnFKNBeKTXaQz1YXBFdesO
	ngWnz2nFnL1qztTi6xyP0b4aSzvPm+uN9ak+bIptT2djVNAQLdqCmwibU9kE5Aby
	VpAiSzJm+BAVU4pwbqnka0BeOqzyT0bMUyCvk7dAaYRepF8yb8plimv6meD7DiWX
	p8wl94vOATtCxVWlASjaMB/2zpgiQXfFwIjaAR+tnZBqkJApVj4qwHk4EVRiCEnp
	1g+zDY1l5gB38/tTHqvG8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763742265; x=
	1763828665; bh=y9sPmO9ctPmEofVcJL2ve0sLdAoEmPz/dsTzOswFhgc=; b=U
	vzaBNSi3AV9eHP0xV5OI+fIMqpbdDdLZSjxGvsQ1T9RKmeLAwjextymi2cVXU8uy
	Be6PO+J6KI0iovHc0UiFA8B7rQiJTAIxOd4DhBWcsamEOEW5kjFnqKsB7FIrhxeQ
	GuiIAMeDF55zh/ogS1yglOFCO/9flUPn1HBDtkEepyUIH7oJ3GvW0fdgq2cG3HNt
	Rreb7R/CH8xTdpLKWo0BA9gScPfpMk/xxjgIGSyYgTlnJbiy/QOWhAmLxQpYZ6V3
	7/Vl+Dl5oQsAGlnSZbuDQqBdTTIF2o/fTw+PlG/91H2n4QIdikT7RS5D+uM/ue4F
	NdHheTOKT/rjN+6DYqXNw==
X-ME-Sender: <xms:N5IgaVaQZaAe5t79XnH1rbSJrYlQplMMYdp0M6-Mr3uWvt823MEJDQ>
    <xme:N5IgaSsBncHkvTAX8k6pT0FvMeuYcjAGM09pjfPKAWMwiWFbRzWYD5L220C8E6Pk7
    g55i_BbOAKRyF9cw6sEpexN2O8LimadQjIefkoeLiQUv98iWdUI>
X-ME-Received: <xmr:N5Igad-WFs5Ve-cFz6F4xXvv1f14eMC6yGbsbN7RyWZyEu__tXqKIFcs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfedtgeefucetufdoteggodetrf
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
X-ME-Proxy: <xmx:N5IgaQ84u-HHIf2TcQNYp-qQlqRMCjkmlLokOX6AO2UGzSJhrElRBA>
    <xmx:OJIgaXPtSD_NpuOHdtKoNjoojGX18VUQEBCkvknI_2nnhJz5NPrx0g>
    <xmx:OJIgacOkV7PC26nL5WPRH0i6onKjj8iCzVuttmRsX2N7uBq0h1DUmQ>
    <xmx:OJIgaVMFYRWTlkUhXAgJS6FxtMLkh8eI-ToaCrmBZCSefA8L7jXnYw>
    <xmx:OZIgaTGK97vls5JNSW_jGH-7CSY683IBHOHRkaC1YrXeI4xtr5m3V3e5>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Nov 2025 11:24:20 -0500 (EST)
Date: Fri, 21 Nov 2025 09:24:17 -0700
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
Subject: Re: [PATCH v9 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251121092417.7a6eaa2f.alex@shazbot.org>
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Nov 2025 11:28:19 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> Changelog:
> v9:
>  * Added Reviewed-by tags.
>  * Fixes to p2pdma documentation.
>  * Renamed dma_buf_map and unmap.
>  * Moved them to separate file.
>  * Used nvgrace_gpu_memregion() function instead of open-coded variant.
>  * Paired get_file_active() with fput().

Applied to vfio next branch with the fixes discussed for v6.19.  I also
pushed a tag, vfio-v6.19-dma-buf-v9+, for this work.  Thanks,

Alex

