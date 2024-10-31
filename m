Return-Path: <kvm+bounces-30140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EAF9B7215
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 02:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C609B2867AA
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B7882499;
	Thu, 31 Oct 2024 01:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S6EPMqUn"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE0417557;
	Thu, 31 Oct 2024 01:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730338928; cv=none; b=sR90fS5myBszyjLVx3+BIOcXWvS7uNffyqBW53g6IBsGyZxlnj0R9LVFD2GJxwcleNXfBZGVhiOBPQ8uiBTkjzQvILInnhuSveQqAbriuh5XqXjbVYRK1LPGLGxm0e5ly8Gw8FWG2GZZhiWGsLz6on+NRa6EVdnKruPUOWWTlnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730338928; c=relaxed/simple;
	bh=uiuGDGOOsQVFk2/pTqh06oxqVDJv0u7YalXmTsxrZn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jyvuSrXG6x1IKL/jltrB/QhxWzrmbvfw6gUd4fnzF4VGhanJ8OrmBqcxd9aF8KiV1WAY4I3Y45ypRtsml78qzYzV1u8CO+Qr4MNej8SyRUoUm95aS9D44YH8hQO9qpQF6g4uHoMlXBXPmlCoZOCUCflJjXYK0NnvuZTeSXkvsJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S6EPMqUn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=fq4kJNH2CAE848TPhhysdxKjBpD694h5FnzeuEmb1qg=; b=S6EPMqUnjSMOY2vNcllwd8p6Ox
	BPtRyDbTyKdeu8zN7/wLUeNEzO4yOt1VTpHholffpA3y2fXCRmfGBwbaq+MhS7i6uXvZPqK8EWMf1
	vdnR+ykKcs42+hETXuNdH86QIsFdTsFb5DdA2bI/GBKPhibpWGo8LZ3PBdnL6MNt66IGi5rIDxwfh
	Nm4PIrdldIDwzVjNZc3a6VarZ5m10jD/+0k0wQ6vaP/5ECeWPGuh0sdOuXzd7qA+HFGDz97uZOAV8
	aVCodx/6OFerCofoyBUjDKwTi3nqK7mNz0BN5W9cwhuz4xTFN0XerCsGsF3834u0w+0svVHPsvvbO
	Jz1tZyPw==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t6KBm-0000000E8Yj-17R7;
	Thu, 31 Oct 2024 01:41:31 +0000
Message-ID: <19cf7d58-4a28-4ce8-9524-8c99fdc79062@infradead.org>
Date: Wed, 30 Oct 2024 18:41:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
References: <cover.1730298502.git.leon@kernel.org>
 <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(nits)

On 10/30/24 8:12 AM, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add an explanation of the newly added IOVA-based mapping API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/core-api/dma-api.rst | 70 ++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
> index 8e3cce3d0a23..6095696a65a7 100644
> --- a/Documentation/core-api/dma-api.rst
> +++ b/Documentation/core-api/dma-api.rst
> @@ -530,6 +530,76 @@ routines, e.g.:::
>  		....
>  	}
>  
> +Part Ie - IOVA-based DMA mappings
> +---------------------------------
> +
> +These APIs allow a very efficient mapping when using an IOMMU.  They are an
> +optional path that requires extra code and are only recommended for drivers
> +where DMA mapping performance, or the space usage for storing the DMA addresses
> +matter.  All the consideration from the previous section apply here as well.

                    considerations

> +
> +::
> +
> +    bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
> +		phys_addr_t phys, size_t size);
> +
> +Is used to try to allocate IOVA space for mapping operation.  If it returns
> +false this API can't be used for the given device and the normal streaming
> +DMA mapping API should be used.  The ``struct dma_iova_state`` is allocated
> +by the driver and must be kept around until unmap time.
> +
> +::
> +
> +    static inline bool dma_use_iova(struct dma_iova_state *state)
> +
> +Can be used by the driver to check if the IOVA-based API is used after a
> +call to dma_iova_try_alloc.  This can be useful in the unmap path.
> +
> +::
> +
> +    int dma_iova_link(struct device *dev, struct dma_iova_state *state,
> +		phys_addr_t phys, size_t offset, size_t size,
> +		enum dma_data_direction dir, unsigned long attrs);
> +
> +Is used to link ranges to the IOVA previously allocated.  The start of all
> +but the first call to dma_iova_link for a given state must be aligned
> +to the DMA merge boundary returned by ``dma_get_merge_boundary())``, and
> +the size of all but the last range must be aligned to the DMA merge boundary
> +as well.
> +
> +::
> +
> +    int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
> +		size_t offset, size_t size);
> +
> +Must be called to sync the IOMMU page tables for IOVA-range mapped by one or
> +more calls to ``dma_iova_link()``.
> +
> +For drivers that use a one-shot mapping, all ranges can be unmapped and the
> +IOVA freed by calling:
> +
> +::
> +
> +   void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
> +		enum dma_data_direction dir, unsigned long attrs);
> +
> +Alternatively drivers can dynamically manage the IOVA space by unmapping
> +and mapping individual regions.  In that case
> +
> +::
> +
> +    void dma_iova_unlink(struct device *dev, struct dma_iova_state *state,
> +		size_t offset, size_t size, enum dma_data_direction dir,
> +		unsigned long attrs);
> +
> +is used to unmap a range previous mapped, and

                            previously

> +
> +::
> +
> +   void dma_iova_free(struct device *dev, struct dma_iova_state *state);
> +
> +is used to free the IOVA space.  All regions must have been unmapped using
> +``dma_iova_unlink()`` before calling ``dma_iova_free()``.
>  
>  Part II - Non-coherent DMA allocations
>  --------------------------------------

-- 
~Randy


