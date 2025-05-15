Return-Path: <kvm+bounces-46724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A3D0AB9027
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 21:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 422551BC7F94
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 19:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54061297A48;
	Thu, 15 May 2025 19:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPcdyKPg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7297D296FB9
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 19:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747338681; cv=none; b=HRE9GCqbhvPKS9AmjICmdByUYLorQcPEfkP+Nx53HvM5McpvWkycuBkVW2uG+VLyfYQas5hGKZ+ZG9h3ELw7a+IKJJgU+0+IEQGdFSXwOp1L/tmBcadt1IF2iGbqWZ9EwUzgdtWMrRfWq8EPnFiZCazM+82fvSSIE1wvPYt+1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747338681; c=relaxed/simple;
	bh=SM7Fsp7OBkR12UwEkjhPIInqFpNqTlTloiXdSI0R6HY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UH7RHTuY82sUPMmO0o9VBEHDgqDcoo5PfmQlkDOMgtAJyYj1iyycEZBnZ+jx5R4Nwc2tNjK5OFWeEl4q6JntVj5SxN0Vp9CB2gdg2QH0poLrKWFw3lgKvlg7bTpmn2WsD7MFWus8L1Y5JMWSKhJsev5mNhzj141+/5YBwV7XTFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPcdyKPg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1717CC4CEF0;
	Thu, 15 May 2025 19:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747338680;
	bh=SM7Fsp7OBkR12UwEkjhPIInqFpNqTlTloiXdSI0R6HY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OPcdyKPg+FQX0zX7nyDXXkM4xDAm5Jxc6VSU2Xrnoso7xzt2ZyWKK+lS9g/Oji8II
	 FlQ7bWdtkgel4576D5ZfRO5nwKz5s40d/yLg0W3BchmsbHcapD5EJTQ9qjnnoTZZVd
	 dc0bnrEosroqwu4ktWBkkHaTdj8kgVNDviJ9CgIqIqoA+fY1LpFDESW/YTzBBXFaJ/
	 Xs9mvXa6uViJm5DBDQY5hZ9yYN0yo/8Lg15Oy/f0fpeiSFms/YxScMhXpMJUifraCP
	 q4ti9tgXXdCoDpLEKKlpy0Kf7qiwl3emnrdvnavLAAUfxmf06ayjJ8+PlXxYASSgR0
	 g4wOdZO6CPjRw==
Date: Thu, 15 May 2025 22:51:16 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, kvm@vger.kernel.org,
	Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] Please pull mlx5 VFIO PCI DMA conversion
Message-ID: <20250515195116.GP22843@unreal>
References: <20250513104811.265533-1-leon@kernel.org>
 <20250515114715.0f718ce0.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515114715.0f718ce0.alex.williamson@redhat.com>

On Thu, May 15, 2025 at 11:47:15AM -0600, Alex Williamson wrote:
> On Tue, 13 May 2025 13:48:10 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > Hi Alex,
> > 
> > Please accept this pull request, which presents subset of new DMA-API
> > patchset [1] specific for VFIO subsystem.
> > 
> > It is based on Marek's dma-mapping-for-6.16-two-step-api branch, so merging
> > now will allow us to reduce possible rebase errors in mlx5 vfio code and give
> > enough time to start to work on second driver conversion. Such conversion will
> > allow us to generalize the API for VFIO kernel drivers, in similiar way that
> > was done for RDMA, HMM and block layers.
> 
> Hi Leon,
> 
> Pull requests are not my typical workflow.  Are these mlx5-vfio-pci
> changes intended to enter mainline through the vfio tree or your rdma
> tree?

VFIO changes will come through your tree. DMA patches are the same as in
Marek's DMA tree and in our RDMA tree.

I prepared PR to save from your hassle of merging dma/dma-mapping-for-6.16-two-step-api
topic from Marek and collecting VFIO patches from ML.

> Why do the commits not include a review/ack from Yishai?

They have Jason's review tags and as far as I know Yishai, he trusts
Jason's judgement.

> 
> Typically I'd expect a patch series for the mlx5-vfio-pci changes that
> I would apply, with Yishai's approval, to a shared branch containing the
> commits Marek has already accepted.  I'm not sure why we're preempting
> that process here.  Thanks,

This is exactly what is in this PR: reviewed VFIO patches which were
posted to the ML on top of Marek's shared branch.

If you prefer, I can repost the VFIO patches.

Thanks

> 
> Alex
> 
> > [1] [PATCH v10 00/24] Provide a new two step DMA mapping API
> > https://lore.kernel.org/all/cover.1745831017.git.leon@kernel.org/
> > 
> > ----------------------------------------------------------------
> > The following changes since commit 3ee7d9496342246f4353716f6bbf64c945ff6e2d:
> > 
> >   docs: core-api: document the IOVA-based API (2025-05-06 08:36:54 +0200)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/vfio-dma-two-step
> > 
> > for you to fetch changes up to 855c89a25e1756b7699b863afd4d6afcbd0de0d6:
> > 
> >   vfio/mlx5: Enable the DMA link API (2025-05-13 03:58:27 -0400)
> > 
> > ----------------------------------------------------------------
> > Convert mlx5 VFIO PCI driver to new two step DMA API
> > 
> > This PR is based on newly accepted DMA API, which allows us
> > to avoid building scatter-gather lists just to batch mapping
> > and unmapping of pages.
> > 
> > VFIO PCI live migration code is building a very large "page list"
> > for the device. Instead of allocating a scatter list entry per
> > allocated page it can just allocate an array of 'struct page *',
> > saving a large amount of memory.
> > 
> > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> > 
> > ----------------------------------------------------------------
> > Leon Romanovsky (3):
> >       vfio/mlx5: Explicitly use number of pages instead of allocated length
> >       vfio/mlx5: Rewrite create mkey flow to allow better code reuse
> >       vfio/mlx5: Enable the DMA link API
> > 
> >  drivers/vfio/pci/mlx5/cmd.c  | 375 +++++++++++++++++++++----------------------
> >  drivers/vfio/pci/mlx5/cmd.h  |  35 ++--
> >  drivers/vfio/pci/mlx5/main.c |  87 +++++-----
> >  3 files changed, 239 insertions(+), 258 deletions(-)
> > 
> 

