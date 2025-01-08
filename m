Return-Path: <kvm+bounces-34907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 577E4A07434
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 12:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D73B3165F6A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 11:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9A82165E8;
	Thu,  9 Jan 2025 11:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yu8QvwhI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E9A204C3C;
	Thu,  9 Jan 2025 11:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736420878; cv=none; b=Pb1kYg2E1aybsr1AxjJKXVZZvacoMiOBvWG+tc+L67BxD2O0DOqOhCPSxZ7dm/iMXHUMyQrMW9d03iNjog/MJ43cgJWzS+NovXcEdm95Z+EqJ/LTB61LU8sOzB5EzZB8+3ICX0i+Vkzsg2p7pXSQlKxoVLafKMfPBrndQUxRk7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736420878; c=relaxed/simple;
	bh=+rokNR1TBRe3TqEAQHJ6WAVWiY++bf7dkHnY6VnhOIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RF+iIrWXS7HHBc7Ax2C05DYifstAsCKNKcXvSC1zoBg3lZSJNOnrFyDPI60nU/QodTpt0XXKT5VrJ5Gp65Q87BRRimdFz8EKTeeqLrxBuWJdNUgux2ZN6J+nP8po3LUAXq0gp76GaEvHCuMsuU6oGWZq70yCJXThxzi1sssB4Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yu8QvwhI; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736420876; x=1767956876;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+rokNR1TBRe3TqEAQHJ6WAVWiY++bf7dkHnY6VnhOIw=;
  b=Yu8QvwhIklD6R96Mo7/pLl+Thr9iUG/xh7+neZft4Dg3puHijwxlPlNN
   Bed5JeIu0qiiZv8VCsTogUZDgpVots6HFfjl79N5sMt3AJ3z4SPX5xliG
   Q7nLLoTfA5+N+lh2LnWKZpd64i099vsXdA8lI33iP8uT7h31TLzo85r2H
   XJ9klZSxB5u5EkMHi8xQhCCYxuZw88wOZkgmqxxtgRv10mgRJk2+ZcG4S
   b6I4Q2puj+jVLXKExq6S4lQwEkcx2fkjz5nAaZNHq8KanC27TaMSiYsbW
   bHbPgA+S693JnVqTB/GSXy8Bh9Ls4HMv33tG4FetKmmggp5hP3TKR9Qg1
   w==;
X-CSE-ConnectionGUID: QPRw3ZLcQZyEvJpsoJb1+Q==
X-CSE-MsgGUID: WpvkjXsrTgyXi2cmGU5e0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="48090745"
X-IronPort-AV: E=Sophos;i="6.12,301,1728975600"; 
   d="scan'208";a="48090745"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 03:07:56 -0800
X-CSE-ConnectionGUID: JZV1fD2DSIei0Kb+5rkS+Q==
X-CSE-MsgGUID: U75bsEzcRwOUOMGJwatAdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108432058"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa003.jf.intel.com with ESMTP; 09 Jan 2025 03:07:51 -0800
Date: Thu, 9 Jan 2025 07:06:48 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <Z38FCOPE7WPprYhx@yilunxu-OptiPlex-7050>
References: <20250107142719.179636-2-yilun.xu@linux.intel.com>
 <b1f3c179-31a9-4592-a35b-b96d2e8e8261@amd.com>
 <20250108132358.GP5556@nvidia.com>
 <f3748173-2bbc-43fa-b62e-72e778999764@amd.com>
 <20250108145843.GR5556@nvidia.com>
 <5a858e00-6fea-4a7a-93be-f23b66e00835@amd.com>
 <20250108162227.GT5556@nvidia.com>
 <Z37HpvHAfB0g9OQ-@phenom.ffwll.local>
 <Z37QaIDUgiygLh74@yilunxu-OptiPlex-7050>
 <58e97916-e6fd-41ef-84b4-bbf53ed0e8e4@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58e97916-e6fd-41ef-84b4-bbf53ed0e8e4@amd.com>

>  So I guess my first question is, which locking rules do you want here for
>  pfn importers?
> 
>  follow_pfn() is unwanted for private MMIO, so dma_resv_lock.
> 
>    As Sima explained you either have follow_pfn() and mmu_notifier or you
>    have DMA addresses and dma_resv lock / dma_fence.
> 
>    Just giving out PFNs without some lifetime associated with them is one of
>    the major problems we faced before and really not something you can do.

I'm trying to make exporter give out PFN with lifetime control via
move_notify() in this series. May not be conceptually correct but seems
possible.

> 
> 
>  If mmu notifiers is fine, then I think the current approach of follow_pfn
>  should be ok. But if you instead dma_resv_lock rules (or the cpu mmap
>  somehow is an issue itself), then I think the clean design is create a new
> 
>  cpu mmap() is an issue, this series is aimed to eliminate userspace
>  mapping for private MMIO resources.
> 
>    Why?

OK, I can start from here.

It is about the Secure guest, or CoCo VM. The memory and MMIOs assigned
to this kind of guest is unaccessable to host itself, by leveraging HW
encryption & access control technology (e.g. Intel TDX, AMD SEV-SNP ...).
This is to protect the tenant data being stolen by CSP itself.

The impact is when host accesses the encrypted region, bad things
happen to system, e.g. memory corruption, MCE. Kernel is trying to
mitigate most of the impact by alloc and assign user unmappable memory
resources (private memory) to guest, which prevents userspace
accidents. guest_memfd is the private memory provider that only allows
for KVM to position the page/pfn by fd + offset and create secondary
page table (EPT, NPT...), no host mapping, no VMA, no mmu_notifier. But
the lifecycle of the private memory is still controlled by guest_memfd.
When fallocate(fd, PUNCH_HOLE), the memory resource is revoked and KVM
is notified to unmap corresponding EPT.

The further thought is guest_memfd is also suitable for normal guest.
It makes no sense VMM must build host mapping table before guest access.

Now I'm trying to seek a similar way for private MMIO. A MMIO resource
provider that is exported as an fd. It controls the lifecycle of the
MMIO resource and notify KVM when revoked. dma-buf seems to be a good
provider which have done most of the work, only need to extend the
memory resource seeking by fd + offset.

> 
>  separate access mechanism just for that. It would be the 5th or so (kernel
>  vmap, userspace mmap, dma_buf_attach and driver private stuff like
>  virtio_dma_buf.c where you access your buffer with a uuid), so really not
>  a big deal.
> 
>  OK, will think more about that.
> 
>    Please note that we have follow_pfn() + mmu_notifier working for KVM/XEN

Folow_pfn & mmu_notifier won't work here, cause no VMA, no host mapping
table.

Thanks,
Yilun
>    with MMIO mappings and P2P. And that required exactly zero DMA-buf changes
>    :)
> 
>    I don't fully understand your use case, but I think it's quite likely that
>    we already have that working.
> 
>    Regards,
>    Christian.

