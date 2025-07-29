Return-Path: <kvm+bounces-53608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B90B14981
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 09:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5D3A3A7623
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 07:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63B426D4EF;
	Tue, 29 Jul 2025 07:52:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E6626B751;
	Tue, 29 Jul 2025 07:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753775561; cv=none; b=BNZA9PBY7w8B52NHGFw0AlJhD0XD+C9oJBi8Q14LtUosUJ2pZdu4LCw5t5284LXEVdzOU1vrjBbf3IN1UdrxBuhsF2OCZTIg7gIAnDrvZ1N9tfZj+h+yQFOu7vI36w85XUSXUnjJ6h3z6nGCJpPbQgyjnNelQDn0MHDBB53+0/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753775561; c=relaxed/simple;
	bh=dwPGGRPZlcgcpxdt3wtbJj8qCueXtKv9Ub/aK1H1gCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcNg6buHEKqqSK+0u83GpEpqi3IXh2JGVh78UPD7hWS6Q9WRShbbcXS37xz+xtlg0TCPBtrrY84OrXZBrDMunwJHiiXeQf/uGonHubusbdaFVQZ0ba238+q9TsNlDMdS1iKlqNUxxL15TfLb6AX5FzLe6v81w9xX+d2vWwwfcBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A57DF68BFE; Tue, 29 Jul 2025 09:52:30 +0200 (CEST)
Date: Tue, 29 Jul 2025 09:52:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250729075230.GB23823@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com> <20250724080313.GA31887@lst.de> <20250724081321.GT402218@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724081321.GT402218@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 24, 2025 at 11:13:21AM +0300, Leon Romanovsky wrote:
> On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> > On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Export the pci_p2pdma_map_type() function to allow external modules
> > > and subsystems to determine the appropriate mapping type for P2PDMA
> > > transfers between a provider and target device.
> > 
> > External modules have no business doing this.
> 
> VFIO PCI code is built as module. There is no way to access PCI p2p code
> without exporting functions in it.

We never ever export anything for "external" modules, and you really
should know that.


