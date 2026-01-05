Return-Path: <kvm+bounces-67073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B3629CF53D4
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 19:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DCDCC300BFAB
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 18:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B488340DB1;
	Mon,  5 Jan 2026 18:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LdlQdo1J"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630EC1F94A;
	Mon,  5 Jan 2026 18:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767637741; cv=none; b=i2cz0YultQ9gnzMYFz86NlyrX11Ybn4num+ZUYwrbUz7T34S7nzUxn76q5YjEIHqdI20u5/914SAdDl3qucidGsVDDrlQ/6fSBrlY9b523aGXz/l12M9MWk3GFvH27I7mgv9o9tN5Yxd/6pqM2irtaNAt4rb1A67L4FTdlIS1SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767637741; c=relaxed/simple;
	bh=wkAGmiMchBtc9OScQOQ+Muej3QggBVoP0YqNKFLI0KM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=UG5A5UOeHXBgqjtmWK9z0+QLW+6piABj8V6/8ezdge4p0Q5V7G7mUOufw8xQKkVnubzWaTpd1jM3zC2qpbTz/fOvMhE1C81iOY3aHWA+Dx24AzR6vD6eBO8pACD6hk4+qWFl1IDFJKYfu2wV1207E31cYr4S6Rqq8bIe1wALQuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LdlQdo1J; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260105182857euoutp026f24319d0d6511f3b1dbeb43bf327fba~H6Sg15q060910809108euoutp02v;
	Mon,  5 Jan 2026 18:28:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260105182857euoutp026f24319d0d6511f3b1dbeb43bf327fba~H6Sg15q060910809108euoutp02v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767637737;
	bh=F01Bjiv9Jbar7XQTaAD7ePnWrXaKEdBZUMCzSmOxZ3Q=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=LdlQdo1JQFmuW+nVqR6pwR1qxAMBlcHCB53DqTjz4qoL8zVNAVcLAY7DEdvFDUPEX
	 xa+oSFRiA5tW+HJopKkBa4sbH+fRMdumqVRL0lkSIiiIDowbEKKdngy5qaMdQoXYiq
	 YpSPdz3zIWjH8xm+/pth0F/AvhREHn05EsTPmbcU=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260105182856eucas1p158734c1d57a10887c100d14aab210ced~H6Sf77ObP2452124521eucas1p1_;
	Mon,  5 Jan 2026 18:28:56 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260105182850eusmtip28ed1049745959a614ed8486dd208282c~H6SaLDVa40433904339eusmtip2D;
	Mon,  5 Jan 2026 18:28:50 +0000 (GMT)
Message-ID: <278f23d7-4c95-49df-b9c9-6ad19e6a08ca@samsung.com>
Date: Mon, 5 Jan 2026 19:28:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 02/15] docs: dma-api: document
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
In-Reply-To: <01ea88055ded4d70cac70ba557680fd5fa7d9ff5.1767601130.git.mst@redhat.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260105182856eucas1p158734c1d57a10887c100d14aab210ced
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260105082311eucas1p2f6744dcf6d7bb74e39e353e57dc99c86
X-EPHeader: CA
X-CMS-RootMailID: 20260105082311eucas1p2f6744dcf6d7bb74e39e353e57dc99c86
References: <cover.1767601130.git.mst@redhat.com>
	<CGME20260105082311eucas1p2f6744dcf6d7bb74e39e353e57dc99c86@eucas1p2.samsung.com>
	<01ea88055ded4d70cac70ba557680fd5fa7d9ff5.1767601130.git.mst@redhat.com>

On 05.01.2026 09:22, Michael S. Tsirkin wrote:
> Document the __dma_from_device_group_begin()/end() annotations.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   Documentation/core-api/dma-api-howto.rst | 52 ++++++++++++++++++++++++
>   1 file changed, 52 insertions(+)

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> diff --git a/Documentation/core-api/dma-api-howto.rst b/Documentation/core-api/dma-api-howto.rst
> index 96fce2a9aa90..e97743ab0f26 100644
> --- a/Documentation/core-api/dma-api-howto.rst
> +++ b/Documentation/core-api/dma-api-howto.rst
> @@ -146,6 +146,58 @@ What about block I/O and networking buffers?  The block I/O and
>   networking subsystems make sure that the buffers they use are valid
>   for you to DMA from/to.
>   
> +__dma_from_device_group_begin/end annotations
> +=============================================
> +
> +As explained previously, when a structure contains a DMA_FROM_DEVICE /
> +DMA_BIDIRECTIONAL buffer (device writes to memory) alongside fields that the
> +CPU writes to, cache line sharing between the DMA buffer and CPU-written fields
> +can cause data corruption on CPUs with DMA-incoherent caches.
> +
> +The ``__dma_from_device_group_begin(GROUP)/__dma_from_device_group_end(GROUP)``
> +macros ensure proper alignment to prevent this::
> +
> +	struct my_device {
> +		spinlock_t lock1;
> +		__dma_from_device_group_begin();
> +		char dma_buffer1[16];
> +		char dma_buffer2[16];
> +		__dma_from_device_group_end();
> +		spinlock_t lock2;
> +	};
> +
> +To isolate a DMA buffer from adjacent fields, use
> +``__dma_from_device_group_begin(GROUP)`` before the first DMA buffer
> +field and ``__dma_from_device_group_end(GROUP)`` after the last DMA
> +buffer field (with the same GROUP name). This protects both the head
> +and tail of the buffer from cache line sharing.
> +
> +The GROUP parameter is an optional identifier that names the DMA buffer group
> +(in case you have several in the same structure)::
> +
> +	struct my_device {
> +		spinlock_t lock1;
> +		__dma_from_device_group_begin(buffer1);
> +		char dma_buffer1[16];
> +		__dma_from_device_group_end(buffer1);
> +		spinlock_t lock2;
> +		__dma_from_device_group_begin(buffer2);
> +		char dma_buffer2[16];
> +		__dma_from_device_group_end(buffer2);
> +	};
> +
> +On cache-coherent platforms these macros expand to zero-length array markers.
> +On non-coherent platforms, they also ensure the minimal DMA alignment, which
> +can be as large as 128 bytes.
> +
> +.. note::
> +
> +        It is allowed (though somewhat fragile) to include extra fields, not
> +        intended for DMA from the device, within the group (in order to pack the
> +        structure tightly) - but only as long as the CPU does not write these
> +        fields while any fields in the group are mapped for DMA_FROM_DEVICE or
> +        DMA_BIDIRECTIONAL.
> +
>   DMA addressing capabilities
>   ===========================
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


