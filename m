Return-Path: <kvm+bounces-35729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E31EA149DB
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 07:55:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AFB816ABF8
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 06:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2D11F78F0;
	Fri, 17 Jan 2025 06:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BAGWZ/7f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DB81F7564;
	Fri, 17 Jan 2025 06:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737096939; cv=none; b=b66Wqp8Dt2c5MzosCHqWaK8fp+PYZLIBuqElf6WHX1qkbhAZdDx3/+s9McFZD5l8Eg6Fig5DK7SCEszxBVaBRo9701vwC+JH3SbugSPJoyZJ6AQgA0EUZ0DotPM52Qy7g54j3YAfrCitCwotDSy9IVvgZ0w+p42KXfQ1iTgYpIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737096939; c=relaxed/simple;
	bh=a0dUK/jQpDvIM8/nBDBU73ylJDOTGNarHp7F4VWxh2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HnCHSUbzysG/bEvSX0dG7b3Vl5dqtljVCE3ATwYU0I0zV+HYjyi2fVDA20fhn7hqk3AXSKpumXjlYq+/AqEtMhUbwTRyswuid3VHgAxDtJmFU+4PhSNZM1fFPcOmuSJWxRWVtUxTLOTIZGyUgJ1w/Wwj2unWQgDHVUKpe4nwoOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BAGWZ/7f; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737096939; x=1768632939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=a0dUK/jQpDvIM8/nBDBU73ylJDOTGNarHp7F4VWxh2Y=;
  b=BAGWZ/7fEaIl3foWPAIo9ZebSnMETgwNPT+d4AS3tZBxpsHVYlSdKtJH
   iZSGwMb6LEYb9BHRSNM+wFt2bjgAB9P3iRSEhX5oIouwDTwsB1ydCWUEd
   7vD+dbVLcQTvXU38njr6T0Imn9ILxs1ub0vIQt5/MjeVMH3w2h7LXBeMy
   sU8Zz/iMikNIv2aTFv2byENAKBF+GauKVt2j71jWBVg1gfYE+faNnwh3q
   jeQR9C5Nw9y27sysl7SMBR0eUS8Q8+L9fIn6WeaCdOmQ1K+In0Nxmn8NV
   jpB/n/IZP6ItDdZRluSx9Xr6wZf2dXBpmavCrvqNz8Oay6C458F5i2agh
   Q==;
X-CSE-ConnectionGUID: 8rUuzQchQpiCvDL8nrI29g==
X-CSE-MsgGUID: IsoL10krTd6lmtOAqkhRdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11317"; a="41284406"
X-IronPort-AV: E=Sophos;i="6.13,211,1732608000"; 
   d="scan'208";a="41284406"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 22:55:38 -0800
X-CSE-ConnectionGUID: RxiCzTo0ROmjq7QbZX/TYg==
X-CSE-MsgGUID: jaCx/4CdQQ2PY/ze4H41mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,211,1732608000"; 
   d="scan'208";a="106312339"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 16 Jan 2025 22:55:32 -0800
Date: Fri, 21 Jun 2024 06:02:17 +0800
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
Message-ID: <ZnSm6ULbJbxOU27J@yilunxu-OptiPlex-7050>
References: <20250115133821.GO5556@nvidia.com>
 <f6c2524f-5ef5-4c2c-a464-a7b195e0bf6c@amd.com>
 <1afd5049-d1d4-4fd6-8259-e7a5454e6a1d@amd.com>
 <20250115141458.GP5556@nvidia.com>
 <c86cfee1-063a-4972-a343-ea0eff2141c9@amd.com>
 <86afb69a-79bd-4719-898e-c6c2e62103f7@amd.com>
 <20250115151056.GS5556@nvidia.com>
 <6f7a14aa-f607-45f9-9e15-759e26079dec@amd.com>
 <20250115170942.GT5556@nvidia.com>
 <5f588dac-d3e2-445d-9389-067b875412dc@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f588dac-d3e2-445d-9389-067b875412dc@amd.com>

On Thu, Jan 16, 2025 at 04:13:13PM +0100, Christian König wrote:
>    Am 15.01.25 um 18:09 schrieb Jason Gunthorpe:
> 
>  On Wed, Jan 15, 2025 at 05:34:23PM +0100, Christian König wrote:
> 
>     Granted, let me try to improve this.
>     Here is a real world example of one of the issues we ran into and why
>     CPU mappings of importers are redirected to the exporter.
>     We have a good bunch of different exporters who track the CPU mappings
>     of their backing store using address_space objects in one way or
>     another and then uses unmap_mapping_range() to invalidate those CPU
>     mappings.
>     But when importers get the PFNs of the backing store they can look
>     behind the curtain and directly insert this PFN into the CPU page
>     tables.
>     We had literally tons of cases like this where drivers developers cause
>     access after free issues because the importer created a CPU mappings on
>     their own without the exporter knowing about it.
>     This is just one example of what we ran into. Additional to that
>     basically the whole synchronization between drivers was overhauled as
>     well because we found that we can't trust importers to always do the
>     right thing.
> 
>  But this, fundamentally, is importers creating attachments and then
>  *ignoring the lifetime rules of DMABUF*. If you created an attachment,
>  got a move and *ignored the move* because you put the PFN in your own
>  VMA, then you are not following the attachment lifetime rules!
> 
>    Move notify is solely for informing the importer that they need to
>    re-fresh their DMA mappings and eventually block for ongoing DMA to end.
> 
>    This semantics doesn't work well for CPU mappings because you need to hold
>    the reservation lock to make sure that the information stay valid and you
>    can't hold a lock while returning from a page fault.

Dealing with CPU mapping and resource invalidation is a little hard, but is
resolvable, by using other types of locks. And I guess for now dma-buf
exporters should always handle this CPU mapping VS. invalidation contention if
they support mmap().

It is resolvable so with some invalidation notify, a decent importers could
also handle the contention well.

IIUC now the only concern is importer device drivers are easier to do
something wrong, so move CPU mapping things to exporter. But most of the
exporters are also device drivers, why they are smarter?

And there are increasing mapping needs, today exporters help handle CPU primary
mapping, tomorrow should they also help on all other mappings? Clearly it is
not feasible. So maybe conditionally give trust to some importers.

Thanks,
Yilun

