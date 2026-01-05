Return-Path: <kvm+bounces-67072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6000ACF53CB
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 19:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 207053082EA9
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 18:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F10340A79;
	Mon,  5 Jan 2026 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TddU8smh"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D39254AFF;
	Mon,  5 Jan 2026 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767637663; cv=none; b=t7KYYD3u/87rRnt+mpJwSUkq7nSalcWXzHj0kRWAdOY6qURfhWTrn6536pzYVJKeDlWS63x7bzHC241r+zynCchJBnfWvCI+Ckwv2Nn/6uypTfw4QFAdGf+bsI7MUIjazDMaCKYSlLfDbxW8ak3wXC1OsEuU8bXsQQ9IytvueUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767637663; c=relaxed/simple;
	bh=aGY/jlM6jY/RHCqnrtrgzV8zleTgHdpL34u5gI/QqUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ruZi3k8rBQ5XDOK8qMhcICk8X7r/21hdg4ObpN4ByhX3iiPtFGgVhfHiwyGJm7oun1NrEzJJ07w30EmMO1q5uDN1wVfze1iQ77U8Hi611bRNqpYUCb84dmxrT+gtsS1vH52VCm39VpeMLm+LpJBc0MfFy50dWKnc89ohxGk02Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TddU8smh; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260105182739euoutp022c0ff5a531ea4a0ade8d8afe18af64cd~H6RXqDdGD0910109101euoutp020;
	Mon,  5 Jan 2026 18:27:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260105182739euoutp022c0ff5a531ea4a0ade8d8afe18af64cd~H6RXqDdGD0910109101euoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767637659;
	bh=k3VI0xxK+JeEJMM9Qf4YGsqhbmobVgQABwML3v0f724=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=TddU8smhT91bAmPPPVq7FIf3NQCkbbVU9aNLByOb2P/DDi2aBekl1kXF5mdRP1cIn
	 04/MBVqWhu3U3NvHPwpdzcABtd2Zl4zBlANwfVyE2Hj+e3qvxbF4zfWyc6ausnM1jx
	 6vZEn1ciuXJrSioooL28+l0dHbJkRmxKf6Iwolts=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260105182737eucas1p2d0cda04e784d1c0731b62be8b7f6b6c1~H6RWkV_tt1261112611eucas1p2O;
	Mon,  5 Jan 2026 18:27:37 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260105182731eusmtip2518af9f606f96a7775289d347a5aed87~H6RQX-7If0188901889eusmtip2W;
	Mon,  5 Jan 2026 18:27:31 +0000 (GMT)
Message-ID: <8dbf60ac-0821-4ebf-8191-acf348525c26@samsung.com>
Date: Mon, 5 Jan 2026 19:27:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 01/15] dma-mapping: add
 __dma_from_device_group_begin()/end()
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
In-Reply-To: <19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260105182737eucas1p2d0cda04e784d1c0731b62be8b7f6b6c1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260105082306eucas1p28cec7ef0955fa7ef06248075e148af37
X-EPHeader: CA
X-CMS-RootMailID: 20260105082306eucas1p28cec7ef0955fa7ef06248075e148af37
References: <cover.1767601130.git.mst@redhat.com>
	<CGME20260105082306eucas1p28cec7ef0955fa7ef06248075e148af37@eucas1p2.samsung.com>
	<19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>

On 05.01.2026 09:22, Michael S. Tsirkin wrote:
> When a structure contains a buffer that DMA writes to alongside fields
> that the CPU writes to, cache line sharing between the DMA buffer and
> CPU-written fields can cause data corruption on non-cache-coherent
> platforms.
>
> Add __dma_from_device_group_begin()/end() annotations to ensure proper
> alignment to prevent this:
>
> struct my_device {
> 	spinlock_t lock1;
> 	__dma_from_device_group_begin();
> 	char dma_buffer1[16];
> 	char dma_buffer2[16];
> 	__dma_from_device_group_end();
> 	spinlock_t lock2;
> };
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   include/linux/dma-mapping.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)

Right, this was one of the long standing issues, how to make DMA to the 
buffers embedded into some structures safe and this solution looks 
really nice.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>


> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index aa36a0d1d9df..29ad2ce700f0 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -7,6 +7,7 @@
>   #include <linux/dma-direction.h>
>   #include <linux/scatterlist.h>
>   #include <linux/bug.h>
> +#include <linux/cache.h>
>   
>   /**
>    * List of possible attributes associated with a DMA mapping. The semantics
> @@ -703,6 +704,18 @@ static inline int dma_get_cache_alignment(void)
>   }
>   #endif
>   
> +#ifdef ARCH_HAS_DMA_MINALIGN
> +#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
> +#else
> +#define ____dma_from_device_aligned
> +#endif
> +/* Mark start of DMA buffer */
> +#define __dma_from_device_group_begin(GROUP)			\
> +	__cacheline_group_begin(GROUP) ____dma_from_device_aligned
> +/* Mark end of DMA buffer */
> +#define __dma_from_device_group_end(GROUP)			\
> +	__cacheline_group_end(GROUP) ____dma_from_device_aligned
> +
>   static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
>   		dma_addr_t *dma_handle, gfp_t gfp)
>   {

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


