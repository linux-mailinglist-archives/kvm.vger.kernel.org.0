Return-Path: <kvm+bounces-31404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 198629C387D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 07:39:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3E6B281099
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 06:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F9E15747D;
	Mon, 11 Nov 2024 06:39:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D092914F108;
	Mon, 11 Nov 2024 06:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731307140; cv=none; b=Kz/W2jw8mKuWMPNG+kQoHW/Q64jdmbFpjEG5dR8ccAjUdnBwIwD9WlntLfeKSxu1J905HimEUaTiGKHOXQpwKPTxdJlMSoNVY58S/k8r9Fe5FmCs2beKJwq/z1Edhkqb3AmRRF/ZtDOsGf8KDtndgG8h7AiMTQVu5wf552671mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731307140; c=relaxed/simple;
	bh=dqOX1/gW8gtAFrPKO9zWd7C8NC3AB/b5YM72EztB0Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EraCDuZ43cQSjFfQF6W8IlxvIItvIujyOuLSWsSttAjX5a7vqWs8vThiz7jeNpG88wAmfrZcM8VLdgtnS0LiDFKe0wT68CeWY4KKP4zwGS5mzCNViyepfC7SoW/yd+CC4BvxBLOlK1OImgQGWMCuhGqR2Sg3F8C56TU8RRlXZlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93F2A68C7B; Mon, 11 Nov 2024 07:38:47 +0100 (CET)
Date: Mon, 11 Nov 2024 07:38:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
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
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
Message-ID: <20241111063847.GB23992@lst.de>
References: <cover.1730298502.git.leon@kernel.org> <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org> <87ttchwmde.fsf@trenco.lwn.net> <20241108200355.GC189042@unreal> <87h68hwkk8.fsf@trenco.lwn.net> <20241108202736.GD189042@unreal> <20241110104130.GA19265@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241110104130.GA19265@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Nov 10, 2024 at 12:41:30PM +0200, Leon Romanovsky wrote:
> I tried this today and the output (HTML) in the new section looks
> so different from the rest of dma-api.rst that I lean to leave
> the current doc implementation as is.

Yeah.  The whole DMA API documentation shows it's age and could use
a major revamp, but for now I'd prefer to stick to the way it is done.

If we have any volunteers for bringing it up to standards I'd be glad
to help with input and review.


