Return-Path: <kvm+bounces-67379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BCC2D036CF
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 15:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E328930735C6
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A81C4DA530;
	Thu,  8 Jan 2026 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="L2FTBc97"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98C34DA537;
	Thu,  8 Jan 2026 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767880754; cv=none; b=juuazNKZHgxwJN3VuVh81o1HPWhZ9zS4YrAsy3jpDjzBWGqnqWm7p9TQvsSiylndbemioVj0eMj4GH2Rq6Nju4Q6FzM14khdEABc35T6HZfemjmvPLDPd3lHTBuPD63x91uJt6Y3AdpQI3KiGykjEfh7XtOnUsjuiTDQSfKORf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767880754; c=relaxed/simple;
	bh=i+S0t+cvTYJQZdDDAO2WBUwfYWcrj53i531N1BKDWtw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=el1jFhUEB8t4vcfZRo3OOdUjh8N6+8PgMiu1Gk4nO2ojb5giqBOIsy1r7SLEkbyfqen2b6uvw2WokGVdV955l8xPxHvQhTeP0UEU8osyaKhlYp/jU10giTUgWtEUaRVANEMbzr4vPDx7Z1b77wkAJeYq49o82csdBoz0tU11fXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=L2FTBc97; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260108135910euoutp01ccbfd9c84e69621c7e3b92a2b5deec4f~Ixi0etxix0597605976euoutp01a;
	Thu,  8 Jan 2026 13:59:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260108135910euoutp01ccbfd9c84e69621c7e3b92a2b5deec4f~Ixi0etxix0597605976euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767880750;
	bh=HBLoWucuNoa4iyIqpGPENUJPEqe5py10aQ1+typoc88=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=L2FTBc97UDye/KFyXU5zA6qnW86ftuorQ2GangcpFFaA4Z/PMV/6yRn1S8sl1dSwS
	 exmaxsLC/S8/bl80Gu6pAC0Zmfc9N4LXZlfPgeh8CT5RoOz9PQbJhYlqMC3Mxd93Ps
	 wJrG8j45kuOs7szKO1kH8Zg6/dW3sly4RuykzNNc=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260108135910eucas1p2c3a9b2f7e2c019e56996f0760278662f~Ixiz4YTfm2123121231eucas1p23;
	Thu,  8 Jan 2026 13:59:10 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260108135905eusmtip2913ea5be854e60c0e9a456912a96a941~Ixiv5DNn82338323383eusmtip2D;
	Thu,  8 Jan 2026 13:59:05 +0000 (GMT)
Message-ID: <b19d87c3-e783-44d1-ae7c-5911ba42d487@samsung.com>
Date: Thu, 8 Jan 2026 14:59:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 04/15] docs: dma-api: document
 DMA_ATTR_CPU_CACHE_CLEAN
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
In-Reply-To: <0720b4be31c1b7a38edca67fd0c97983d2a56936.1767601130.git.mst@redhat.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260108135910eucas1p2c3a9b2f7e2c019e56996f0760278662f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260105082317eucas1p2259400fc064a45dfe6147964fcb6e73e
X-EPHeader: CA
X-CMS-RootMailID: 20260105082317eucas1p2259400fc064a45dfe6147964fcb6e73e
References: <cover.1767601130.git.mst@redhat.com>
	<CGME20260105082317eucas1p2259400fc064a45dfe6147964fcb6e73e@eucas1p2.samsung.com>
	<0720b4be31c1b7a38edca67fd0c97983d2a56936.1767601130.git.mst@redhat.com>

On 05.01.2026 09:23, Michael S. Tsirkin wrote:
> Document DMA_ATTR_CPU_CACHE_CLEAN as implemented in the
> previous patch.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   Documentation/core-api/dma-attributes.rst | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
> index 0bdc2be65e57..1d7bfad73b1c 100644
> --- a/Documentation/core-api/dma-attributes.rst
> +++ b/Documentation/core-api/dma-attributes.rst
> @@ -148,3 +148,12 @@ DMA_ATTR_MMIO is appropriate.
>   For architectures that require cache flushing for DMA coherence
>   DMA_ATTR_MMIO will not perform any cache flushing. The address
>   provided must never be mapped cacheable into the CPU.
> +
> +DMA_ATTR_CPU_CACHE_CLEAN
> +------------------------
> +
> +This attribute indicates the CPU will not dirty any cacheline overlapping this
> +DMA_FROM_DEVICE/DMA_BIDIRECTIONAL buffer while it is mapped. This allows
> +multiple small buffers to safely share a cacheline without risk of data
> +corruption, suppressing DMA debug warnings about overlapping mappings.
> +All mappings sharing a cacheline should have this attribute.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


