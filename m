Return-Path: <kvm+bounces-44571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABDF7A9F208
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7D2816D472
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 13:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0944026B941;
	Mon, 28 Apr 2025 13:20:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188BD25E81D;
	Mon, 28 Apr 2025 13:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745846414; cv=none; b=oyqlom4hQl/yLClTpLhF/tZzXv1UoybezamheQOFwlCXUpeZ7ROBzZFQ+ry+i2tIq1V35HsVYQglk8EygestM6qFlq+RS2/LHjSicipPI/sGonUGmQJs8kjn0SbFhIDFml97C3u/Jm9T2nyK2YaVjwBdWY0NPHHZ/RBig5b7D8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745846414; c=relaxed/simple;
	bh=j5yKBIk0ChsBmEbxwXBtdSmj61Lr30e37k9LA8CJ3MA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVZgzqss5BFSrOXfupaVOBZEjUu7cNZt4UQf62uYCh3GS394BoMID9F4dPDIvYX8n8ZcF/FOnQ2B+Ou9PYAL01ZgI+b1u6PUPY0t6Jwhr233aP940SUdsC1vti47sNkKv2nf4cjJXA+mAoDPCwK/voLANh8MN+bCs3iak35vfGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3A2B668C4E; Mon, 28 Apr 2025 15:20:06 +0200 (CEST)
Date: Mon, 28 Apr 2025 15:20:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 07/24] dma-mapping: Implement link/unlink ranges API
Message-ID: <20250428132006.GA30966@lst.de>
References: <cover.1745394536.git.leon@kernel.org> <2d6ca43ef8d26177d7674b9e3bdf0fe62b55a7ed.1745394536.git.leon@kernel.org> <aA1iRtCsPkuprI-X@bombadil.infradead.org> <20250427081312.GE5848@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427081312.GE5848@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Apr 27, 2025 at 11:13:12AM +0300, Leon Romanovsky wrote:
> > So arch_sync_dma_for_device() is a no-op on some architectures, notably x86.
> > So since you're doing this work and given the above pattern is common on
> > the non iova case, we could save ourselves 2 branches checks on x86 on
> > __dma_iova_link() and also generalize savings for the non-iova case as
> > well. For the non-iova case we have two use cases, one with the attrs on
> > initial mapping, and one without on subsequent sync ops. For the iova
> > case the attr is always consistently used.
> 
> I want to believe that compiler will discards these "if (!coherent &&
> !(attrs & DMA_ATTR_SKIP_CPU_SYNC)))" branch if case is empty.

Yes, it is the poster child for dead code elimination using the
IS_ENABLED() helper.

> checks are scattered over all dma-iommu.c file with different
> combinations. While we can do new static functions for small number of
> use cases, it will be half-solution.

Don't bother.


