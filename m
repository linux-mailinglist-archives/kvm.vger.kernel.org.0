Return-Path: <kvm+bounces-44679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B19F0AA0199
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 770E24812E3
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C4A274645;
	Tue, 29 Apr 2025 05:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O3/B9y4P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3201DE8B2;
	Tue, 29 Apr 2025 05:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902961; cv=none; b=kfokqoovuVNXVpz2wdojvSzuIVuLsezQH54XJX6YEGQ+vAGrGBOvL6sxuLAo4IwHq29beslTn3VFTWvOD8VTcsTEIOZdu5GO+8tyHUUmmAxrczD+mONdqDE/NX6S1Dsj5KvfQxHf8haOxcHsbpCc4AQf5UMpVj0pj69ajhz9DXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902961; c=relaxed/simple;
	bh=yJHygitItCE7AjT4PE9hDK5eTwShgF8pqCV5bUS99tg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YUs1S8cIexrshtbv7ynAmgrXMdL8m0TdE9AL4nXK+zrchQBdChlWBxcG4pktN42JtYfBgfOgvWwnmff3Bd3x0iPqwS4IzyZ1Mt+ND/0H01JcvaocWOrMhwPNT7jOpmjjqcEPD4coLqXrLLtoVupxPoYAwUmDAHnOSi3QAG4RwjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O3/B9y4P; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745902960; x=1777438960;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yJHygitItCE7AjT4PE9hDK5eTwShgF8pqCV5bUS99tg=;
  b=O3/B9y4PSKompQLB0b5RmqlYynOa+ey8T/WjvjEQApg2E8p9tNnzsvuv
   GLK08LTAUYmruhTO0/EBvwgVXvWNbwxnazkIZtP/VDWUdsPI9jjlRkX/C
   3GKfUol2SqoUKZ+75V+3vPWYVTn0I7IjZQmny0KRCdzJvJjIoWZovcFRX
   eNC1RqscY22pE6/Cgj9ddVprRYiuZ53OEepRSXJ0SrUCZd94wz9EnlawQ
   CNdLYxWnRBWvt6VHikTzmmxjg7zZqlCUZ8t3WR93VuxAab/1yzm5X8f6M
   I6u1L2PDwDxAuiLHWQi86ksYUCQ4N0Zl8/qNlPwhucjXaFMvgCEYmNXPq
   w==;
X-CSE-ConnectionGUID: W7Z1V5aiQ/+jIW15i6Nc/w==
X-CSE-MsgGUID: k9fEfIDTQ7We2T56517w2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="35121395"
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="35121395"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 22:02:39 -0700
X-CSE-ConnectionGUID: a5E3m5JXQF+Vct9TFcNxPw==
X-CSE-MsgGUID: WNPv/oL5TCup2x/mZ3mf+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="138896368"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 22:02:30 -0700
Message-ID: <8416e94f-171e-4956-b8fe-246ed12a2314@linux.intel.com>
Date: Tue, 29 Apr 2025 12:58:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/24] iommu/dma: Factor out a iommu_dma_map_swiotlb
 helper
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Niklas Schnelle <schnelle@linux.ibm.com>,
 Chuck Lever <chuck.lever@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Dan Williams
 <dan.j.williams@intel.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>
References: <cover.1745831017.git.leon@kernel.org>
 <f9a6a7874760a2919bea1f255bb3c81c6369ed1c.1745831017.git.leon@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <f9a6a7874760a2919bea1f255bb3c81c6369ed1c.1745831017.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/25 17:22, Leon Romanovsky wrote:
> From: Christoph Hellwig<hch@lst.de>
> 
> Split the iommu logic from iommu_dma_map_page into a separate helper.
> This not only keeps the code neatly separated, but will also allow for
> reuse in another caller.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Tested-by: Jens Axboe<axboe@kernel.dk>
> Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> Signed-off-by: Leon Romanovsky<leonro@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

with a nit below ...

> ---
>   drivers/iommu/dma-iommu.c | 73 ++++++++++++++++++++++-----------------
>   1 file changed, 41 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index d3211a8d755e..d7684024c439 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1138,6 +1138,43 @@ void iommu_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
>   			arch_sync_dma_for_device(sg_phys(sg), sg->length, dir);
>   }
>   
> +static phys_addr_t iommu_dma_map_swiotlb(struct device *dev, phys_addr_t phys,
> +		size_t size, enum dma_data_direction dir, unsigned long attrs)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iova_domain *iovad = &domain->iova_cookie->iovad;
> +
> +	if (!is_swiotlb_active(dev)) {
> +		dev_warn_once(dev, "DMA bounce buffers are inactive, unable to map unaligned transaction.\n");
> +		return (phys_addr_t)DMA_MAPPING_ERROR;
> +	}
> +
> +	trace_swiotlb_bounced(dev, phys, size);
> +
> +	phys = swiotlb_tbl_map_single(dev, phys, size, iova_mask(iovad), dir,
> +			attrs);
> +
> +	/*
> +	 * Untrusted devices should not see padding areas with random leftover
> +	 * kernel data, so zero the pre- and post-padding.
> +	 * swiotlb_tbl_map_single() has initialized the bounce buffer proper to
> +	 * the contents of the original memory buffer.
> +	 */
> +	if (phys != (phys_addr_t)DMA_MAPPING_ERROR && dev_is_untrusted(dev)) {
> +		size_t start, virt = (size_t)phys_to_virt(phys);
> +
> +		/* Pre-padding */
> +		start = iova_align_down(iovad, virt);
> +		memset((void *)start, 0, virt - start);
> +
> +		/* Post-padding */
> +		start = virt + size;
> +		memset((void *)start, 0, iova_align(iovad, start) - start);
> +	}
> +
> +	return phys;
> +}
> +
>   dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
>   	      unsigned long offset, size_t size, enum dma_data_direction dir,
>   	      unsigned long attrs)
> @@ -1151,42 +1188,14 @@ dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
>   	dma_addr_t iova, dma_mask = dma_get_mask(dev);
>   
>   	/*
> -	 * If both the physical buffer start address and size are
> -	 * page aligned, we don't need to use a bounce page.
> +	 * If both the physical buffer start address and size are page aligned,
> +	 * we don't need to use a bounce page.
>   	 */
>   	if (dev_use_swiotlb(dev, size, dir) &&
>   	    iova_offset(iovad, phys | size)) {
> -		if (!is_swiotlb_active(dev)) {

... Is it better to move this check into the helper? Simply no-op if a
bounce page is not needed:

	if (!dev_use_swiotlb(dev, size, dir) ||
	    !iova_offset(iovad, phys | size))
		return phys;

Thanks,
baolu

