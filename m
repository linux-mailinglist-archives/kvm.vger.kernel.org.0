Return-Path: <kvm+bounces-44493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B30A9E0A2
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D9605A7DB5
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 07:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959F12472BE;
	Sun, 27 Apr 2025 07:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SuhJkBrk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985FC366;
	Sun, 27 Apr 2025 07:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745740485; cv=none; b=KOPvv9Vyt6NTY6Rvz0e8z2ZnlAQ2abDmzAQOxC/UwWXFwd6B4faBVn5Y6xKxbZ4Mpz/nONtWkMgzb3+vYfiZBItl5Y9iz0Vd4soMGnX8WyYysVJyMM400sjB5l0DsuISVP4RGWsFCVpKsJGrHrdqKkErRTXot03k3Ctf8kytEHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745740485; c=relaxed/simple;
	bh=Del72uuLK4HjhoyvAuoYd0zF0NkA3zOArQZGDqNBzxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNGlPSFgjFdsyUjw8vN+lJLXJJp4JmxbmerczsDZs+EN3exFx1Rv9/hBYUzsAh5XjZ+m91DokNXTh61eATkOSXorRLR83MFDxm5I+5totLJ2JGSF1zygMoPbyeBloLLqpmQLz4mXHZBbti0eFYgeSebqhMuG9YoijWbH16OBtz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SuhJkBrk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0855AC4CEE3;
	Sun, 27 Apr 2025 07:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745740484;
	bh=Del72uuLK4HjhoyvAuoYd0zF0NkA3zOArQZGDqNBzxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SuhJkBrkNS4zwAXk7vhnnjTRZkEidT0ML4s+9rRbQ/rk7cTAt0pbTsqWAepTmBVWl
	 5AfnI/cgdAGSNmV4OtvHzHVqZhuz50Cf5oQnXgSPE590Z0og8OdcRKn9XbJDelW+UI
	 KcY7yLSDQOGGLvnH6aXAbHKg2fTfrqJ2/1hToU+wGxgFKB8y5jpuflRKtTuHFow3c/
	 AcSBIxFBVboHWrcPdTuGaTQ6qglA8niAauD8MT1BQRbl3OVnUBIUFmBpPnUOOsHCBM
	 DToX3YsnhAxRwlCrJ7Z4xLOVkIGDKPmgikA0N4H6UuIg1CNUJMIx8fR6GdZ4hW2y/U
	 KWMW5Qk/iOztg==
Date: Sun, 27 Apr 2025 10:54:39 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
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
Subject: Re: [PATCH v9 03/24] iommu: generalize the batched sync after map
 interface
Message-ID: <20250427075439.GD5848@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <2ce6a74ddf5e13a7fdb731984aa781a15f17749d.1745394536.git.leon@kernel.org>
 <aAwuMuR3tpWtyCTa@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAwuMuR3tpWtyCTa@bombadil.infradead.org>

On Fri, Apr 25, 2025 at 05:52:02PM -0700, Luis Chamberlain wrote:
> On Wed, Apr 23, 2025 at 11:12:54AM +0300, Leon Romanovsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > For the upcoming IOVA-based DMA API we want to use the interface batch the
> > sync after mapping multiple entries from dma-iommu without having a
> > scatterlist.
> 
> This reads odd, how about:
> 
> For the upcoming IOVA-based DMA API, we want to batch the sync operation
> after mapping multiple entries from dma-iommu without requiring a
> scatterlist.
> 
> Other than that:
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

I used Jason's proposal
https://lore.kernel.org/all/20250423171537.GJ1213339@ziepe.ca

Thanks

> 
>   Luis

