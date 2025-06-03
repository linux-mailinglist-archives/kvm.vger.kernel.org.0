Return-Path: <kvm+bounces-48252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8EEACBF7A
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB194188A770
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 05:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B2A202984;
	Tue,  3 Jun 2025 05:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WAP6lHRJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752E81F7060;
	Tue,  3 Jun 2025 05:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748927485; cv=none; b=GusWUzXwSF8sJdS7MM7gc1dQt4+z9weXHuFc4wQdFDtb0dBAeCP6nh00LUXCSR8JBypQr72FT0K4FtTX39zuugrB+Egs1NpPurNvN2Eh5z+E4G6IOXz0vbl9FKzKK3gQjx0+Hk+gQAYzy2kTb/jGg7W8wS68Il+UPIyd6/2hZKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748927485; c=relaxed/simple;
	bh=A4LDdea+SqFvSsp7QIZfn63yvE0Iup0Y5Vmq4FjSSs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSYc9MW3FP2VaZlIkzueRtWLCn7u9Z9d1QjI8r6ZnGKd2vTfFH1LzvbfXFZxg4gUfpdMIhvRAKgJH5wa6jk2/QEI8bDKQACzRRAk204ewf7taWstsrF8nnEbeEZ/qcInMCxVTG+QUa/vXqOBeCRnLepkTLhpIDvpiwQCnYbCBtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WAP6lHRJ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748927484; x=1780463484;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A4LDdea+SqFvSsp7QIZfn63yvE0Iup0Y5Vmq4FjSSs8=;
  b=WAP6lHRJULfGwaBDordXZjf8BQRcOsFCpCjS30/1/tg88ILkEolyAecG
   bWiH2FUOXr/QexAX+IQNsFUQBYnBCIXHbCSI245y5bPdDxTiPVVWbwDAN
   DK+TGCG8jgOPpPuM5zHjfcuN4UANoJML80aBI2A6n67GUdFsoVQ3dskgV
   VTeM11hlCdOI1AKRbO086hufp7JJ3ZRSfPqD4UNJqefDQ7Bgd1GVciGeh
   7qQSK6KOzbEziCgD97ank7yWwu9Eha9LKnjapxzsRdFy/UcbYbiKcuOEb
   Gle4ApLMQIenXhXIheqRWr+LZgDITGV3Vwkd3rYd6YmqdV6bfy6XLzAM/
   A==;
X-CSE-ConnectionGUID: bn3wGxucQx6Ju6oRqw7VvA==
X-CSE-MsgGUID: NkivxYQTTmS3dVmg5AgLtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="62007039"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="62007039"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 22:07:47 -0700
X-CSE-ConnectionGUID: vMpLU8zvR5e2O0JVHMgjXg==
X-CSE-MsgGUID: glbqWyGzSAW042M4b3+m5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="175700501"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 02 Jun 2025 22:07:41 -0700
Date: Tue, 3 Jun 2025 13:01:09 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	dan.j.williams@intel.com, aik@amd.com, linux-coco@lists.linux.dev,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, linux-kernel@vger.kernel.org, lukas@wunner.de,
	yan.y.zhao@intel.com, daniel.vetter@ffwll.ch, leon@kernel.org,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com, linux-pci@vger.kernel.org, zhiw@nvidia.com,
	simona.vetter@ffwll.ch, shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 10/30] vfio/pci: Export vfio dma-buf specific info
 for importers
Message-ID: <aD6BlXfuCGCOw4PM@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-11-yilun.xu@linux.intel.com>
 <20250602133009.GC233377@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602133009.GC233377@nvidia.com>

On Mon, Jun 02, 2025 at 10:30:09AM -0300, Jason Gunthorpe wrote:
> On Thu, May 29, 2025 at 01:34:53PM +0800, Xu Yilun wrote:
> > Export vfio dma-buf specific info by attaching vfio_dma_buf_data in
> > struct dma_buf::priv. Provide a helper vfio_dma_buf_get_data() for
> > importers to fetch these data. Exporters identify VFIO dma-buf by
> > successfully getting these data.
> > 
> > VFIO dma-buf supports disabling host access to these exported MMIO
> > regions when the device is converted to private. Exporters like KVM
> > need to identify this type of dma-buf to decide if it is good to use.
> > KVM only allows host unaccessible MMIO regions been mapped in private
> > roots.
> > 
> > Export struct kvm * handler attached to the vfio device. This
> > allows KVM to do another sanity check. MMIO should only be assigned to
> > a CoCo VM if its owner device is already assigned to the same VM.
> 
> This doesn't seem right, it should be encapsulated into the standard
> DMABUF API in some way.

OK.

> 
> Jason

