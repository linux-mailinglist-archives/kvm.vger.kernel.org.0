Return-Path: <kvm+bounces-62583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F3F6C492EA
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 21:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0CAA14E24DF
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 20:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AADB033F8D7;
	Mon, 10 Nov 2025 20:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="VTtNveK1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ehVjo0kN"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0010F1A7AE3;
	Mon, 10 Nov 2025 20:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762805138; cv=none; b=LjonZkeCBWPLLo8D4wHdKuu+98HeKUt+uo5LbKiEaLgJmUuMCp55TWrQizuuNjRpJhrLlk1ScrmUg/Ss2Qa0i/0DBIjnUHSJ+mLZclrxGerm8Iw2ZiY5H3eiF1N7QyuBJ36Ipt3kZYB13tN7maXnr0T2p2QojWwud0WnrW1DCoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762805138; c=relaxed/simple;
	bh=ZIYO3CpaK6TCINhe6w8XA+pYaZFiVJ/7Kigz3C4Xd9g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbOXwzIzWNN4tYWKT3QCT1tnKuMxliDJsFJk4RQWYovXG1sry+CUN1LsXTKUjNQ/M3sJWicdFTorUpQFRPViHjsBSecfrmkpi4ziyQkPuwpQiwS6mzwnhANutgvVKWXeXaFETLFKY9Z+Kqw2i6sw0n2ObobgH0UCXCV2XNxdQrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=VTtNveK1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ehVjo0kN; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 6D7811D00147;
	Mon, 10 Nov 2025 15:05:33 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 10 Nov 2025 15:05:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762805133;
	 x=1762891533; bh=LRTbnDgOZdkcWyYb0TrSsTJyowo8VQnXM0W6ONAWUts=; b=
	VTtNveK1sP3RdPO0iA1mluhOTIezB/pxiWEOpTMtRrXpqSxqoom2HwDYk67QuWkW
	sPYOFU9wblpXDKzCcGaz76SsbUIjzORvB2iixAZGqW2fpsMJzqP5XDSLJZuUeose
	gUs7geKqCEZxyILKTVR1G6bjEdT1IDPI9lORfC7uU7VXjawAWvGl2cthKxtM67hg
	2LGDVSp2fb5+OY7d95VBUt3xXcg4zmyZNGQJvu4WmoOyjyktai2rEvD59ntUSPrz
	noD0hx+3MnVDFBYoEm291EVo6ioNy0I4iVxIt4URSUSibY5VQFYlMAenBohjrrqE
	5M+jBIsmcKEZFKzLT7cG6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762805133; x=
	1762891533; bh=LRTbnDgOZdkcWyYb0TrSsTJyowo8VQnXM0W6ONAWUts=; b=e
	hVjo0kNkpXpEnjyGLa3/HioTTAA5OcK4yDT+dT+kSj8VoCNpXQicmGnR1r8kl3i4
	n/q1SGSEgGz8mmhYlrkKrESCZwS6ZmjcXz2B3B9WVYhcun1l7NR44AgVENlnLqvu
	a1zJZ2CuMWjHrlkgrKrx6rKTVBu03wGm/PEyRLxXjeJPUmeJkA1RNRcTv4vkR077
	UeYkeuPv7KXX5jjN3Q3Admhq/wVV39C97HYyXRwatVk2JzsEizOnKtCy3nYrgUV0
	f16CdLzVqw7okI7dfupJaRHAfGhXWIUe34rM5F+7RmgptMF8UZmdovDBQ67FlOmL
	bbZtZ4jSrTcVOKqnpDH4g==
X-ME-Sender: <xms:i0USacfcdiFukOkHlGoqV_M4dCc620hY4NSllrMdUQNN1jhyNXA0dA>
    <xme:i0USaebmv-CqTmGTtMURt40eSNK-Wx58zPcA6lUAMFk6_sJ7kTrwfXO5-hJI7QP35
    WOjketLVpgzAmupEQaOyA0CSU46lUmN1quCAYwRJCTFcTgJGFD4>
X-ME-Received: <xmr:i0USaQJZE78F87doANetcSybuW5K51r7sW1QPQxDU2rb0XeXgAf-OVXV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleelvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeeffedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhoghgrnhhg
    seguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrug
    hkpdhrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthht
    ohepjhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgt
    ohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
X-ME-Proxy: <xmx:i0USadiojN3-M4EVjjaRRugj8V8QuJnr5MsQlLluVx8g5hN9fuNwjw>
    <xmx:i0USacvol4BakuBUda4qcSsYifPCPIwHmQFFbRa4tQipabSTTp737w>
    <xmx:i0USaREDw4I87L0odND3wJ85uUDm4QaLw4uwBFQIJ-AXU7QEY82_xw>
    <xmx:i0USaS_gEbCoj0gRiNt7PSMpEk5gV19bFOSSEZSZfZgUVR07IZj5bA>
    <xmx:jUUSaRJMGClENgI7ttLAOXLiOuPL8ZATIaHOyPe6Y_F7QjCcID7VjG5j>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Nov 2025 15:05:29 -0500 (EST)
Date: Mon, 10 Nov 2025 13:05:25 -0700
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
 linux-hardening@vger.kernel.org,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v7 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251110130525.6712552b.alex@shazbot.org>
In-Reply-To: <20251106-dmabuf-vfio-v7-10-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
	<20251106-dmabuf-vfio-v7-10-2503bf390699@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  6 Nov 2025 16:16:55 +0200
Leon Romanovsky <leon@kernel.org> wrote:
> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> new file mode 100644
> index 000000000000..cbf502b14e3c
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
...
> +
> +int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
> +				  struct vfio_device_feature_dma_buf __user *arg,
> +				  size_t argsz)
> +{
> +	struct vfio_device_feature_dma_buf get_dma_buf = {};
> +	struct vfio_region_dma_range *dma_ranges;
> +	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> +	struct vfio_pci_dma_buf *priv;
> +	size_t length;
> +	int ret;
> +
> +	if (!vdev->pci_ops->get_dmabuf_phys)


vdev->pci_ops can be NULL.

Thanks,
Alex

