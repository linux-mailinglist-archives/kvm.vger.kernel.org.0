Return-Path: <kvm+bounces-35279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C9130A0B43A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 11:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 175A77A4B7C
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A9621ADA7;
	Mon, 13 Jan 2025 10:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O0zPJRTN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B9B186A;
	Mon, 13 Jan 2025 10:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736763115; cv=none; b=KO/RZWL8Mz3ZQt2xRzJGGALS/JCkbimGdjaYNiCOc0eAbufNVHTKGURXdbnmGwq+8XVcSA8Zn7Ax9nM0KhPopIb7hvMUdDFeZE16NmfpNcduhUGoidvpXGaiQ1qr1oFsWvErnMZYxgL14zQdNmNACFgPyOMhc/uaLEGlTQEHRmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736763115; c=relaxed/simple;
	bh=1V0smjfm6liFtFPXdzXRpp1hcMphdhXOdaciBJTxc3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SFE3664fUuenGl2NQHzDBNlYqBqANq5/1pRBMx8uMumtfXDKB5oNBA1peS2Qh7B1CysWWsCLnNcwoSoeK6ZzuElxB2Nc36Be6r3WmkFNqZ86y4KlYAV/zC479vg41L7Jf3+L5y/bGzftOHbe9cGoGaGwlbIbTWz0I0lWsBujoak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O0zPJRTN; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736763113; x=1768299113;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1V0smjfm6liFtFPXdzXRpp1hcMphdhXOdaciBJTxc3k=;
  b=O0zPJRTNxraCEZrGaAHXbs+64PRrD6dgH35gVUTROm5w3OlOQSkXoNvA
   xo0dRmNrSSCihGPo/SXgplyImFJABvVMnJWQ0NIg7Amyy5yg+6nP+N2w2
   rOiDqRvH2bche1j9iJ6oKaxwyvtP+WpIDZe2yiWVrXd40+CEnYPKwlO8t
   3kFBxc3iS/meX3Ln64DQMAsutd5o7NUSbszUPyR9PONZZnoIvc2T3DVG3
   wvxvIewtz327/WpgHaC/TN+Z5vsvCZQAjCa3MA66c92W0ebnPdbK9m0Yi
   Ob2zACnMqD1lr3wmai8uGQB5kQxD1Ap3dvIVGjMMDnFQyQ80LJK+50ria
   g==;
X-CSE-ConnectionGUID: CQhZjaxITJaFlsw+qpKgGg==
X-CSE-MsgGUID: Y4maSOBNQLyn5LbjxVDLKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="47680431"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="47680431"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 02:11:52 -0800
X-CSE-ConnectionGUID: e1W5JBnaQKeKiTmx3Y+QPg==
X-CSE-MsgGUID: iL1mS6fgQq2TTbSbHA6WqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104509323"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa006.jf.intel.com with ESMTP; 13 Jan 2025 02:11:47 -0800
Date: Mon, 13 Jan 2025 06:10:40 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leonro@nvidia.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, pbonzini@redhat.com, seanjc@google.com,
	alex.williamson@redhat.com, vivek.kasireddy@intel.com,
	dan.j.williams@intel.com, aik@amd.com, yilun.xu@intel.com,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	lukas@wunner.de, yan.y.zhao@intel.com, leon@kernel.org,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <Z4Q94E6JvWrhvCyq@yilunxu-OptiPlex-7050>
References: <f3748173-2bbc-43fa-b62e-72e778999764@amd.com>
 <20250108145843.GR5556@nvidia.com>
 <5a858e00-6fea-4a7a-93be-f23b66e00835@amd.com>
 <20250108162227.GT5556@nvidia.com>
 <Z37HpvHAfB0g9OQ-@phenom.ffwll.local>
 <Z37QaIDUgiygLh74@yilunxu-OptiPlex-7050>
 <58e97916-e6fd-41ef-84b4-bbf53ed0e8e4@amd.com>
 <Z38FCOPE7WPprYhx@yilunxu-OptiPlex-7050>
 <Z4F2X7Fu-5lprLrk@phenom.ffwll.local>
 <20250110203838.GL5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110203838.GL5556@nvidia.com>

On Fri, Jan 10, 2025 at 04:38:38PM -0400, Jason Gunthorpe wrote:
> On Fri, Jan 10, 2025 at 08:34:55PM +0100, Simona Vetter wrote:
> 
> > So if I'm getting this right, what you need from a functional pov is a
> > dma_buf_tdx_mmap? Because due to tdx restrictions, the normal dma_buf_mmap

I'm not sure if the word 'mmap' is proper here.

It is kind of like the mapping from (FD+offset) to backend memory,
which is directly provided by memory provider, rather than via VMA
and cpu page table.  Basically VMA & cpu page table are for host to
access the memory, but VMM/host doesn't access most of the guest
memory, so why must build them.

> > is not going to work I guess?
> 
> Don't want something TDX specific!
> 
> There is a general desire, and CC is one, but there are other
> motivations like performance, to stop using VMAs and mmaps as a way to
> exchanage memory between two entities. Instead we want to use FDs.

Exactly.

> 
> We now have memfd and guestmemfd that are usable with
> memfd_pin_folios() - this covers pinnable CPU memory.
> 
> And for a long time we had DMABUF which is for all the other wild
> stuff, and it supports movable memory too.
> 
> So, the normal DMABUF semantics with reservation locking and move
> notifiers seem workable to me here. They are broadly similar enough to
> the mmu notifier locking that they can serve the same job of updating
> page tables.

Yes. With this new sharing model, the lifecycle of the shared memory/pfn/Page
is directly controlled by dma-buf exporter, not by CPU mapping. So I also
think reservation lock & move_notify works well for lifecycle control,
no conflict (nothing to do) with follow_pfn() & mmu_notifier.

> 
> > Also another thing that's a bit tricky is that kvm kinda has a 3rd dma-buf
> > memory model:
> > - permanently pinned dma-buf, they never move
> > - dynamic dma-buf, they move through ->move_notify and importers can remap
> > - revocable dma-buf, which thus far only exist for pci mmio resources
> 
> I would like to see the importers be able to discover which one is
> going to be used, because we have RDMA cases where we can support 1
> and 3 but not 2.
> 
> revocable doesn't require page faulting as it is a terminal condition.
> 
> > Since we're leaning even more on that 3rd model I'm wondering whether we
> > should make it something official. Because the existing dynamic importers
> > do very much assume that re-acquiring the memory after move_notify will
> > work. But for the revocable use-case the entire point is that it will
> > never work.
> 
> > I feel like that's a concept we need to make explicit, so that dynamic
> > importers can reject such memory if necessary.
> 
> It strikes me as strange that HW can do page faulting, so it can
> support #2, but it can't handle a non-present fault?
> 
> > So yeah there's a bunch of tricky lifetime questions that need to be
> > sorted out with proper design I think, and the current "let's just use pfn
> > directly" proposal hides them all under the rug. 
> 
> I don't think these two things are connected. The lifetime model that
> KVM needs to work with the EPT, and that VFIO needs for it's MMIO,
> definately should be reviewed and evaluated.
> 
> But it is completely orthogonal to allowing iommufd and kvm to access
> the CPU PFN to use in their mapping flows, instead of the
> dma_addr_t.
> 
> What I want to get to is a replacement for scatter list in DMABUF that
> is an array of arrays, roughly like:
> 
>   struct memory_chunks {
>       struct memory_p2p_provider *provider;
>       struct bio_vec addrs[];
>   };
>   int (*dmabuf_get_memory)(struct memory_chunks **chunks, size_t *num_chunks);

Maybe we need to specify which object the API is operating on,
struct dma_buf, or struct dma_buf_attachment, or a new attachment.

I think:

  int (*dmabuf_get_memory)(struct dma_buf_attachment *attach, struct memory_chunks **chunks, size_t *num_chunks);

works, but maybe a new attachment is conceptually more clear to
importers and harder to abuse?

Thanks,
Yilun

> 
> This can represent all forms of memory: P2P, private, CPU, etc and
> would be efficient with the new DMA API.
> 
> This is similar to the structure BIO has, and it composes nicely with
> a future pin_user_pages() and memfd_pin_folios().
> 
> Jason

