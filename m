Return-Path: <kvm+bounces-67378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E959ED03412
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 15:15:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 574193011A95
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B874B3AA2;
	Thu,  8 Jan 2026 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N46t9Kk/"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEB140FD9C;
	Thu,  8 Jan 2026 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767880678; cv=none; b=l+Nq+mj3q6wiVjio0C70wCgKlvYAcBRsd1ix1ztV4sq8pjZhlarFjSV1nzMskQYOcgMG1izRqm5prg3Cx9xMOSdsXwhB12hj7/oJEND0sxrqNNoNIQFIv/qJR0o4JsUJWlt+9E87hkx5oD6C902+Ps6g5egRaYdPxsgGbWQ2wdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767880678; c=relaxed/simple;
	bh=oo49FY2ULfaQzovc7U0e+DMcGIZIxCNslx48Vot+DTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=UY6T4wChp9koqnkMWFImtB9doyHIgRiMN15jxPZdd9DV0igKbGT7i1I5rT8mJCNuCnV4A7VlUYE+TgNAbofJ5S3dF1LfDtyk0jSOr/EXfYDY5nz6eFy7YDGZikawsKzsl1+hs3gVoL/IfzDTIb4XDz7tJ4JWHnRYOb8hxHxEr0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=N46t9Kk/; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260108135752euoutp01739b42acd5b37a2cf575cc6620e75601~Ixhr3Z5IZ0573705737euoutp01M;
	Thu,  8 Jan 2026 13:57:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260108135752euoutp01739b42acd5b37a2cf575cc6620e75601~Ixhr3Z5IZ0573705737euoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767880672;
	bh=yH2rPLThWUM1dKN4UcJR1XVOYszcMfuT+BMdjTT6Aeg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=N46t9Kk/hKhFT/cK/fnFzzobH1ZHxDEKrH7vDer+rIyqkzq2N3DjZtamOag7s+48z
	 i2stGQ72tRjS8NBhnxaWsqtYROJQY5AGOSLNwsEn/ggNNLJc1AOnGbHRIXur7qHK0Z
	 QXh9oqt5sxoI2nKXY+ibzdMZ6i2j5jvnKS/9Zbog=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260108135752eucas1p13f59f8e3f41236b8ee98e7a0596869e7~Ixhrlgbp73057130571eucas1p1m;
	Thu,  8 Jan 2026 13:57:52 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260108135749eusmtip2c78af2cbbbecbe57163d255ece269da0~IxholZqkN2020220202eusmtip2V;
	Thu,  8 Jan 2026 13:57:49 +0000 (GMT)
Message-ID: <c43c630e-cd3c-43bf-b390-659c23f7c711@samsung.com>
Date: Thu, 8 Jan 2026 14:57:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 03/15] dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>, Paolo
	Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Robin Murphy <robin.murphy@arm.com>, Stefano
	Garzarella <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
	Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Petr Tesarik
	<ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Bartosz Golaszewski <brgl@kernel.org>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <2d5d091f9d84b68ea96abd545b365dd1d00bbf48.1767601130.git.mst@redhat.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260108135752eucas1p13f59f8e3f41236b8ee98e7a0596869e7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260105082314eucas1p2dd6ff42b1a8f9c60e9c813dffef7f4fb
X-EPHeader: CA
X-CMS-RootMailID: 20260105082314eucas1p2dd6ff42b1a8f9c60e9c813dffef7f4fb
References: <cover.1767601130.git.mst@redhat.com>
	<CGME20260105082314eucas1p2dd6ff42b1a8f9c60e9c813dffef7f4fb@eucas1p2.samsung.com>
	<2d5d091f9d84b68ea96abd545b365dd1d00bbf48.1767601130.git.mst@redhat.com>

On 05.01.2026 09:23, Michael S. Tsirkin wrote:
> When multiple small DMA_FROM_DEVICE or DMA_BIDIRECTIONAL buffers share a
> cacheline, and DMA_API_DEBUG is enabled, we get this warning:
> 	cacheline tracking EEXIST, overlapping mappings aren't supported.
>
> This is because when one of the mappings is removed, while another one
> is active, CPU might write into the buffer.
>
> Add an attribute for the driver to promise not to do this, making the
> overlapping safe, and suppressing the warning.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

It is somehow similar to DMA_ATTR_SKIP_CPU_SYNC in its concept, so I see 
no reason not to accept it.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   include/linux/dma-mapping.h | 7 +++++++
>   kernel/dma/debug.c          | 3 ++-
>   2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 29ad2ce700f0..29973baa0581 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -79,6 +79,13 @@
>    */
>   #define DMA_ATTR_MMIO		(1UL << 10)
>   
> +/*
> + * DMA_ATTR_CPU_CACHE_CLEAN: Indicates the CPU will not dirty any cacheline
> + * overlapping this buffer while it is mapped for DMA. All mappings sharing
> + * a cacheline must have this attribute for this to be considered safe.
> + */
> +#define DMA_ATTR_CPU_CACHE_CLEAN	(1UL << 11)
> +
>   /*
>    * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
>    * be given to a device to use as a DMA source or target.  It is specific to a
> diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> index 138ede653de4..7e66d863d573 100644
> --- a/kernel/dma/debug.c
> +++ b/kernel/dma/debug.c
> @@ -595,7 +595,8 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
>   	if (rc == -ENOMEM) {
>   		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
>   		global_disable = true;
> -	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
> +	} else if (rc == -EEXIST &&
> +		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
>   		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
>   		     is_swiotlb_active(entry->dev))) {
>   		err_printk(entry->dev, entry,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


