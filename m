Return-Path: <kvm+bounces-34980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F748A08643
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 05:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EA033A79C4
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 04:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A302063E4;
	Fri, 10 Jan 2025 04:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="irI1pxD8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4A4B672;
	Fri, 10 Jan 2025 04:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736484098; cv=none; b=nXo7U1+1Cmlh+hp3+TAUxDnRDh/4SX0Z3uE7XxLa053EiPr1/jVkjqB/6G0QJ6iE8Fhv+hGHqo2mXcG+0zhfA2Jj/PGYopw19cnjVFnQj7PdUsGZ/7pcJrnMbPAg9Bkzca3vRDzPTh0KCKgbBZmSnunWQ35W2eJWRX2c6ZG+qTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736484098; c=relaxed/simple;
	bh=DGxK73eBcrHkAal0dgjD2vhuA/aOg+rpM5xwCq1ezTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ih0YoRv3J2v/Xvh+o9WeMS0kcGyPY4A+NyG55Kao7kp1BlTiWQPNQb/vwlJ3ne0VeCwLWgmAy/8ONyK3Ins5FzC1SPw3T7wCu08v4WtBrnTkNcOSLFTs/wIUflDkVtIrqMFzrNFAkEYb8APnReaaWpwKOceZatfFFfP/BNkNZHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=irI1pxD8; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736484096; x=1768020096;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DGxK73eBcrHkAal0dgjD2vhuA/aOg+rpM5xwCq1ezTA=;
  b=irI1pxD8WKQCdkwR9S19/plGe3fK5yS1XYrTjQ5r5HWzWWQKDX6odNXQ
   0W/NH8y7LEHm10PEfuDlxSlGiSThVTTcafEyNoyGtu2kwLhGOFsQpHH8c
   LQmCXkVakx0ByikMKGnsjPuI5sLWWhIhm49n7SvPAVoet5+ILAxtxrSrd
   rYedWoMGJGFHz0GB2/QPRas/0vArvdAWsck1HRP2S05RSIHAhAJ+gnjUZ
   A8YprDkz4NkwiSdR8TAnQhsX0H5gpS5n8kuNbcrJTGnPo66hnCqXSPAyq
   CZ6Ug3osuLL+X1hXRZyI96LQueLgiiOFYpiHynZ+XyisHYnhfrHIoWqkz
   Q==;
X-CSE-ConnectionGUID: 6HW7XyBkSmmt/3xBfaDKkg==
X-CSE-MsgGUID: a8gPrrd2RMGT4PA2QLLKGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="36877897"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="36877897"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 20:41:36 -0800
X-CSE-ConnectionGUID: K//gjLLKTECj0XWVemmntw==
X-CSE-MsgGUID: n72tzvFxTvOIbtm23glOzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="108539760"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 09 Jan 2025 20:41:30 -0800
Date: Fri, 10 Jan 2025 00:40:28 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
Message-ID: <Z3/7/PQCLi1GE5Ry@yilunxu-OptiPlex-7050>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
 <20250107142719.179636-9-yilun.xu@linux.intel.com>
 <20250108133026.GQ5556@nvidia.com>
 <Z36ulpCoJAllp4fP@yilunxu-OptiPlex-7050>
 <20250109144051.GX5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109144051.GX5556@nvidia.com>

On Thu, Jan 09, 2025 at 10:40:51AM -0400, Jason Gunthorpe wrote:
> On Thu, Jan 09, 2025 at 12:57:58AM +0800, Xu Yilun wrote:
> > On Wed, Jan 08, 2025 at 09:30:26AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Jan 07, 2025 at 10:27:15PM +0800, Xu Yilun wrote:
> > > > Add a flag for ioctl(VFIO_DEVICE_BIND_IOMMUFD) to mark a device as
> > > > for private assignment. For these private assigned devices, disallow
> > > > host accessing their MMIO resources.
> > > 
> > > Why? Shouldn't the VMM simply not call mmap? Why does the kernel have
> > > to enforce this?
> > 
> > MM.. maybe I should not say 'host', instead 'userspace'.
> > 
> > I think the kernel part VMM (KVM) has the responsibility to enforce the
> > correct behavior of the userspace part VMM (QEMU). QEMU has no way to
> > touch private memory/MMIO intentionally or accidently. IIUC that's one
> > of the initiative guest_memfd is introduced for private memory. Private
> > MMIO follows.
> 
> Okay, but then why is it a flag like that? I'm expecting a much

This flag is a prerequisite for setting up TDI, or part of the
requirement to make a "TDI capable" assigned device. It prevents the
userspace mapping at the first place, even as a shared device.

We want the device firstly appear as a shared device in CoCo-VM, then
do TDI setup (via a tsm verb "bind"). This late bind approach avoids
changing the CoCo VM startup routine. In contrast, early bind would
easily be broken, especially if bios is not aware of the TDI rule.

So then we face with the shared <-> private device conversion in CoCo VM,
and in turn shared <-> private MMIO conversion. MMIO region has only one
physical backend so it is a bit like in-place conversion which is
complicated. I wanna simply the MMIO conversion routine based on the fact
that VMM never needs to access assigned MMIO for feature emulation, so
always disallow userspace MMIO mapping during the whole lifecycle. That's
why the flag is introduced.

Patch 6 has similar discription.

> broader system here to make the VFIO device into a confidential device
> (like setup the TDI) where we'd have to enforce the private things,

I plan to introduce a new VFIO ioctl to setup the TDI.

> communicate with some secure world to assign it, and so on.

Yes, the new VFIO ioctl will communicate with PCI TSM.

> 
> I want to see a fuller solution to the CC problem in VFIO before we

MM.. I have something but need more preparation. Whether send out or
make a public repo, I'll discuss with internal.

> can be sure what is the correct UAPI. In other words, make the
> VFIO device into a CC device should also prevent mmaping it and so on.

My idea is prevent mmaping first, then allow VFIO device into CC dev (TDI).

> 
> So, I would take this out and defer VFIO enforcment to a series which
> does fuller CC enablement of VFIO.
> 
> The precursor work should just be avoiding requiring a VMA when
> installing VFIO MMIO into the KVM and IOMMU stage 2 mappings. Ie by
> using a FD to get the CPU pfns into iommufd and kvm as you are
> showing.
> 
> This works just fine for non-CC devices anyhow and is the necessary

Yes. It carries out the idea of "KVM maps MMIO resources without firstly
mapping into the host" even for normal VM. That's why I think it could
be an independent patchset.

Thanks,
Yilun

> building block for making a TDI interface in VFIO.
> 
> Jason

