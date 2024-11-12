Return-Path: <kvm+bounces-31553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AFFF9C4E7B
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E171287074
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 06:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2A520A5E4;
	Tue, 12 Nov 2024 06:01:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4C91A0AFE;
	Tue, 12 Nov 2024 06:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731391276; cv=none; b=XqsK4fWwmVeM1chKN/RwCNziarp049uqEdkAUN4Kcby2N3S1SuFY4Z3VqWZo68p9rYixMGzzRiai+UwTLgjFNtJut8J3EXOnBquJnPhPJlK3yJE56crNvHtBiNe30YBpRrqlaiQfHL795g1voPhoKrII7RS1u3mZfUL3WBF27Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731391276; c=relaxed/simple;
	bh=0PVIDi3JGo0JcgiypZig4noJVOHBWMpTvGUyYzU70NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgj2O5pSu0EZjHUyEj95qgpqAXSvssBuVvK8nyj63y3Uy44jZQXh20cjjcRkFUeSBK/IZw9S/kZa2AwoM5RpUQETMfo3BrWns4SpeCbcf6FW+YYZZrxaJqGbeoup4Miaeso5H7+VBl2rZq/+NOuBrLY1vg1LvHuIDwVMAAhD7bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A286768D09; Tue, 12 Nov 2024 07:01:08 +0100 (CET)
Date: Tue, 12 Nov 2024 07:01:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
	Thomas.Hellstrom@linux.intel.com, brian.welty@intel.com,
	himal.prasad.ghimiray@intel.com, krishnaiah.bommu@intel.com,
	niranjana.vishwanathapura@intel.com
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
Message-ID: <20241112060108.GA10056@lst.de>
References: <20241104095831.GA28751@lst.de> <20241105195357.GI35848@ziepe.ca> <20241107083256.GA9071@lst.de> <20241107132808.GK35848@ziepe.ca> <20241107135025.GA14996@lst.de> <20241108150226.GM35848@ziepe.ca> <20241108150500.GA10102@lst.de> <20241108152537.GN35848@ziepe.ca> <20241108152956.GA12130@lst.de> <20241108153846.GO35848@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108153846.GO35848@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 08, 2024 at 11:38:46AM -0400, Jason Gunthorpe wrote:
> > > What I'm thinking about is replacing code like the above with something like:
> > > 
> > > 		if (p2p_provider)
> > > 			return DMA_MAPPING_ERROR;
> > > 
> > > And the caller is the one that would have done is_pci_p2pdma_page()
> > > and either passes p2p_provider=NULL or page->pgmap->p2p_provider.
> > 
> > And where do you get that one from?
> 
> Which one?

The p2p_provider thing (whatever that will actually be).


