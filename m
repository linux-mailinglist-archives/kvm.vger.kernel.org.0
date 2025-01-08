Return-Path: <kvm+bounces-34865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 091F1A06DC7
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 06:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0AEF1888C14
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 05:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A872147E9;
	Thu,  9 Jan 2025 05:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iEt6tHOf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4143207A0A;
	Thu,  9 Jan 2025 05:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736402232; cv=none; b=XCvDy2BI4HXdfKXQcj7wbnmhTFkQxe4/tSveZgijv0duYkxpBAPU1WExZKjC0OtZE2PHGMhN9xTNeTWd4T9DrGp6yjrx//T0uzB6tVoFTA5jDfUNSTMeFvu/V5WldreGFUl0wxZIgbz0W+z61IniXzZ+01vYWxwh+NIfckZqiqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736402232; c=relaxed/simple;
	bh=FqI/VlxAMR/gPma1s74j4/VQzGXLaUyWkAAHdpWMFek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEf9+fp1i9gMd55+0jDH9XYYRkzZf9Y0z7x5z422s5CNIbLfdEC8LtJNjzk9DcV9lyGmE+vrNms9Slqeuj/vBJ5g5fBOcuW2fhrDTTn1RdBzn4gSnNdfZDvE9LjcoLYUa1sGS78BBqwqC2YPN3QO09zteHtHDqrXY23ISbRpKI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iEt6tHOf; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736402231; x=1767938231;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FqI/VlxAMR/gPma1s74j4/VQzGXLaUyWkAAHdpWMFek=;
  b=iEt6tHOfdsYE4Ucr4ciQ2t4ehld8EcOVieg2oD+/qDdkQyMdpEuFmfAn
   QMWdx72wXbb4g3EY4xF18ZTH7dUwMMo5qdpNzPcnWsPHVv1NBW6QV26wa
   ZTZGPT9aFO298d3mstt/SHQNMBTqcQr9OE6/ewCl18eGogjxcFGMiRDxx
   Unwo6T4YR0e/WEZAYdvVHPgYQZp5KAygQq0mu4NJTEMArLE5xJpx5PukZ
   bLgly0TfH0FjDlO/COXkmAc+D0Kj2p1rfxNcG4ZhiI2W8hFNTNrLE/x4R
   9G9cVeUAwWz8VhHjujRa+Q7yUnwBvdXvA1EqIumtE6jlno0944gFUdI6m
   Q==;
X-CSE-ConnectionGUID: zdLU/RLATUKaMOHwkjz9tg==
X-CSE-MsgGUID: hLylUr6BRveDaeNOaf//PA==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36807935"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="36807935"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 21:57:10 -0800
X-CSE-ConnectionGUID: SOoiHxivRYyitr+jKiwhJw==
X-CSE-MsgGUID: eOFZZnw/SNquEG3O9injsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="134145387"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 08 Jan 2025 21:57:04 -0800
Date: Thu, 9 Jan 2025 01:56:02 +0800
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
	lukas@wunner.de, yan.y.zhao@intel.com, daniel.vetter@ffwll.ch,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <Z368Mmxjqa4U0jHK@yilunxu-OptiPlex-7050>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
 <20250107142719.179636-2-yilun.xu@linux.intel.com>
 <b1f3c179-31a9-4592-a35b-b96d2e8e8261@amd.com>
 <20250108132358.GP5556@nvidia.com>
 <f3748173-2bbc-43fa-b62e-72e778999764@amd.com>
 <20250108145843.GR5556@nvidia.com>
 <5a858e00-6fea-4a7a-93be-f23b66e00835@amd.com>
 <20250108162227.GT5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108162227.GT5556@nvidia.com>

> > > 5) iommufd and kvm are both using CPU addresses without DMA. No
> > > exporter mapping is possible
> > 
> > We have customers using both KVM and XEN with DMA-buf, so I can clearly
> > confirm that this isn't true.
> 
> Today they are mmaping the dma-buf into a VMA and then using KVM's
> follow_pfn() flow to extract the CPU pfn from the PTE. Any mmapable
> dma-buf must have a CPU PFN.

Yes, the final target for KVM is still the CPU PFN, just with the help
of CPU mapping table.

I also found the xen gntdev-dmabuf is calculating pfn from mapped
sgt.

From Christion's point, I assume only sgl->dma_address should be
used by importers but in fact not. More importers are 'abusing' sg dma
helpers.

That said there are existing needs for importers to know more about the
real buffer resource, for mapping, or even more than mapping,
e.g. dmabuf_imp_grant_foreign_access()

Thanks,
Yilun


