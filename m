Return-Path: <kvm+bounces-46928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A05EABA7E8
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 04:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 433D39E77D0
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 02:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BE11624D5;
	Sat, 17 May 2025 02:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gGVP+gTz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD778155393;
	Sat, 17 May 2025 02:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747449530; cv=none; b=IDBGhvkIRux9xx2G8KtaTZumBKzuIjS3ygqPx1dRK6Ti2+gCuczS+bZYWpy1oBFuCRx7Ucgn58ItxbhZw2CdvfdVj2kw3XGwscdExgexGIcloI1YzkjwFU50Ex0guBEel/gr6wpYIHS7eMyUknCEsAGcstlyEJL7IavolHh5Po4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747449530; c=relaxed/simple;
	bh=ml22strUZn+xOk9qBkBac3qcQdnFAG09ONFp/e6vtto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RCIAbEuG/Ph2ZA7nUU6jELZaNc3qnFhggerl1rwKQpUyGNbhSTw2PQ5FlS12vvJUsmuJbOVcZ0oWUEuzVmHo7cF3wjEWRHyXHxBVw97RCJQB+d2HwrNS2HwzudCoHny0QdrFyYfXWmvT/RVbgorp8qG+t/P+4ctRyiF3J2iigU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gGVP+gTz; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747449529; x=1778985529;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ml22strUZn+xOk9qBkBac3qcQdnFAG09ONFp/e6vtto=;
  b=gGVP+gTzcU6IjYMMCMW4PiTHZ/vxS8fFsZn7yPe1ftOll1L3Cm4VgC2p
   u9xlbKOh3Lh9giire/eMcYHbMHu8DlsFDNEaGmj4o4LvCYbOjyiEkCroq
   L34Fzi7gqatwXIyBujQUdwSPnWze2yj10jot3l5UPWi8vOnMqDBUEHdp4
   1K3zGCux9jXZzDrLYDfNofTiHkfmLsBAhlU24yndH3MqzKMfhTub/XU6T
   +Ljbq2xoTQgeqeZxCuUBJ+0LO17M9K49e1rZ6tfvIE/KjJS+kPEd9UtFQ
   mIYYgLFAMnbdLbbOiXsEgIENNx/7UUAohGa4v9pzzgrOtnY8NUgL/y0AT
   g==;
X-CSE-ConnectionGUID: 87Yg3peaQAqdVwOXI7pC0g==
X-CSE-MsgGUID: L+Maswm2SuicBGbQwxEVMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="74828438"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="74828438"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 19:38:48 -0700
X-CSE-ConnectionGUID: WsTNlC65TIOa6GM8/8KyQA==
X-CSE-MsgGUID: 3knh1WNVQgOcOdqzelccDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="169788702"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 16 May 2025 19:38:42 -0700
Date: Sat, 17 May 2025 10:33:00 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Zhi Wang <zhiw@nvidia.com>, Alexey Kardashevskiy <aik@amd.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 00/12] Private MMIO support for private assigned dev
Message-ID: <aCf1XNQamIJLi+OL@yilunxu-OptiPlex-7050>
References: <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <20250513130315.0158a626.zhiw@nvidia.com>
 <aCRmoDupzK9zTqFL@yilunxu-OptiPlex-7050>
 <20250514230502.6b64da7f.zhiw@nvidia.com>
 <aCYsNSFQJZzHVOFI@yilunxu-OptiPlex-7050>
 <20250515192127.GA580805@nvidia.com>
 <aCbZATrK7EPyH4qt@yilunxu-OptiPlex-7050>
 <20250516124953.GD613512@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516124953.GD613512@nvidia.com>

On Fri, May 16, 2025 at 09:49:53AM -0300, Jason Gunthorpe wrote:
> On Fri, May 16, 2025 at 02:19:45PM +0800, Xu Yilun wrote:
> > > I don't know why you'd disable a viommu while the VM is running,
> > > doesn't make sense.
> > 
> > Here it means remove the CC setup for viommu, shared setup is still
> > kept.
> 
> That might makes sense for the vPCI function, but not the vIOMMU. A
> secure VIOMMU needs to be running at all times while the guest is
> running. Perhaps it has no devices it can be used with, but it's
> functionality has to be there because a driver in the VM will be
> connected to it.
> 
> At most "bind" should only tell the already existing secure vIOMMU
> that it is allowed to translate for a specific vPCI function.

So I think something like:

struct iommufd_vdevice_ops {
	int (*setup_trusted_dma)(struct iommufd_vdevice *vdev); //for Bind
	void (*remove_trusted_dma)(struct iommufd_vdevice *vdev); //for Unbind
};

Thanks,
Yilun

> 
> Jason
> 

