Return-Path: <kvm+bounces-33563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5819EE153
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:33:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 822BE282CAC
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078DE20DD6A;
	Thu, 12 Dec 2024 08:33:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35FF153BF6;
	Thu, 12 Dec 2024 08:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733992402; cv=none; b=RFHgyqljImpmVbDsdC5Aw51V4z7ud7VtqqPEXQHeHHtW+jpPSgIQOHp7bOYbnBtDYaq/yEXf5Zu40jeell3RHbDBQ6H8GRHB5d+DaZvVC5iAsb5B8RZdYZ2fPWdQa0tvEta2L49hEb3+uha7LmxLv/aXgGlFwqIP80YQXk/K+Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733992402; c=relaxed/simple;
	bh=ot48Ik4V4v5EQENxhTEcEi66UwS0ekYW2KvZvqQWfBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVeJiktYN+MkZG2G6TlNw3U/MNHUbG0AoObaU5cMemLGMvk6idHBM4Zet+tskyzZoufpW/KNqd4NcxSc1p8Ivt/RF8rcULpeY62cLS20OtFru7TW5MysSY8lrNbeU5ONgk7vTFWUffbDJy1m8pbd3LxIXyqaIhtKcoPHGMLd/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9FDD768D0E; Thu, 12 Dec 2024 09:33:12 +0100 (CET)
Date: Thu, 12 Dec 2024 09:33:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Leon Romanovsky <leonro@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v4 04/18] iommu: add kernel-doc for iommu_unmap and
 iommu_unmap_fast
Message-ID: <20241212083312.GA9376@lst.de>
References: <cover.1733398913.git.leon@kernel.org> <da4827fda833e69dbe487ef404a9333c51d8ed2e.1733398913.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da4827fda833e69dbe487ef404a9333c51d8ed2e.1733398913.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 05, 2024 at 03:21:03PM +0200, Leon Romanovsky wrote:
> +/**
> + * iommu_unmap_fast() - Remove mappings from a range of IOVA without IOTLB sync
> + * @domain: Domain to manipulate
> + * @iova: IO virtual address to start
> + * @size: Length of the range starting from @iova
> + * @iotlb_gather: range information for a pending IOTLB flush
> + *
> + * iommu_unmap_fast() will remove a translation created by iommu_map(). It cannot

Please avoid the overly long line here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

