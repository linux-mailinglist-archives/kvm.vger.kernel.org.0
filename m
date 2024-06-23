Return-Path: <kvm+bounces-35936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C3A4A16634
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 05:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97D71169B38
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 04:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724A9155316;
	Mon, 20 Jan 2025 04:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AB+NAedf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AA013CFA6;
	Mon, 20 Jan 2025 04:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737348803; cv=none; b=Eif6hyjvOwGUdb/AcU98DfVOUp9qJtdEzn/rGcL7nzDERtky2EfC1fRMq5hRn3wQEpxgOjKi3kdNIPrkDQXFJqpmKurRHZojDw9fhRksaZ0kDC5jtWHjlqZK+33JrAnXv27+6h2EefPzOw4eSr6qScX0NE1cbSJ9xTvr+gBfT4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737348803; c=relaxed/simple;
	bh=Y0xUv/KrGZMTDVn3d6aDjHsZO9ljCANXeLbTh4Y3AmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qd5SstJaigaqcZUGvG/BEIPv0PcaL6SioiMTSThN0oD4QD353KCkjklmmO1wXoCeuZmAqVGtuRfnDZQ25Pa2hIzJMNflmHxheEWeXTIjD6rJlll1htYLSmsIxJC5Wkc2lbK3nh1VO53FVQVgMyNuDZh3gtjFZtJvBi5JHjOOtPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AB+NAedf; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737348802; x=1768884802;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y0xUv/KrGZMTDVn3d6aDjHsZO9ljCANXeLbTh4Y3AmU=;
  b=AB+NAedfBwPyBmUQNbagOES/N0hlOJhjzEwYecWIgsJ6ruahVvWNlqpw
   OJPxXxv2nUa39UHZWmVft9Ur31jDH1eNVTUlnZPUyF2ZuccmI30i8OGzd
   Mg52CQE1lxSo3/D5oLsljkLtaxm4eZI1bZ7QrRamYATbyFvlMQGNF/+Vu
   GDSsO7srDBMuXhHkFH1ntgbIGNiOjUwcyYGfTEzCOWWlwFod+QDTT8EyK
   cv/wvxRamriVEjb+P4cQtxPlIYXrR2Vf+IZ3H9GOlGRXkxZQ4u2QfAUxQ
   oLwzIP2GhcXF+yLmVI5N0H9OSrBWhJ1uNcAFssYQQ2d8TWVW+ieZWBxBP
   w==;
X-CSE-ConnectionGUID: +i7wqT37T5yWulO+10vYDg==
X-CSE-MsgGUID: 7C6SEItjRqe4t52PZQLgdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11320"; a="36926152"
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="36926152"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2025 20:53:21 -0800
X-CSE-ConnectionGUID: pzuQM0SDQPu1WYfF97IPTg==
X-CSE-MsgGUID: 3MYTX9d4QRCtd/oYUVB0Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="137273330"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 19 Jan 2025 20:53:16 -0800
Date: Mon, 24 Jun 2024 03:59:53 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
Message-ID: <Znh+uTMe/wX2RIJm@yilunxu-OptiPlex-7050>
References: <Z3/7/PQCLi1GE5Ry@yilunxu-OptiPlex-7050>
 <20250110133116.GF5556@nvidia.com>
 <Z4Hp9jvJbhW0cqWY@yilunxu-OptiPlex-7050>
 <20250113164935.GP5556@nvidia.com>
 <ZnDGqww5SLbVD6ET@yilunxu-OptiPlex-7050>
 <20250114133553.GB5556@nvidia.com>
 <17cd9b77-4620-4883-9a6a-8d1cab822c88@amd.com>
 <20250115130102.GM5556@nvidia.com>
 <f1ac048f-64b1-4343-ab86-ad98c24a44f5@linux.intel.com>
 <20250117132523.GA5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117132523.GA5556@nvidia.com>

On Fri, Jan 17, 2025 at 09:25:23AM -0400, Jason Gunthorpe wrote:
> On Fri, Jan 17, 2025 at 09:57:40AM +0800, Baolu Lu wrote:
> > On 1/15/25 21:01, Jason Gunthorpe wrote:
> > > On Wed, Jan 15, 2025 at 11:57:05PM +1100, Alexey Kardashevskiy wrote:
> > > > On 15/1/25 00:35, Jason Gunthorpe wrote:
> > > > > On Tue, Jun 18, 2024 at 07:28:43AM +0800, Xu Yilun wrote:
> > > > > 
> > > > > > > is needed so the secure world can prepare anything it needs prior to
> > > > > > > starting the VM.
> > > > > > OK. From Dan's patchset there are some touch point for vendor tsm
> > > > > > drivers to do secure world preparation. e.g. pci_tsm_ops::probe().
> > > > > > 
> > > > > > Maybe we could move to Dan's thread for discussion.
> > > > > > 
> > > > > > https://lore.kernel.org/linux-
> > > > > > coco/173343739517.1074769.13134786548545925484.stgit@dwillia2-
> > > > > > xfh.jf.intel.com/
> > > > > I think Dan's series is different, any uapi from that series should
> > > > > not be used in the VMM case. We need proper vfio APIs for the VMM to
> > > > > use. I would expect VFIO to be calling some of that infrastructure.
> > > > Something like this experiment?
> > > > 
> > > > https://github.com/aik/linux/commit/
> > > > ce052512fb8784e19745d4cb222e23cabc57792e
> > > Yeah, maybe, though I don't know which of vfio/iommufd/kvm should be
> > > hosting those APIs, the above does seem to be a reasonable direction.
> > > 
> > > When the various fds are closed I would expect the kernel to unbind
> > > and restore the device back.
> > 
> > I am curious about the value of tsm binding against an iomnufd_vdevice
> > instead of the physical iommufd_device.
> 
> Interesting question
>  
> > It is likely that the kvm pointer should be passed to iommufd during the
> > creation of a viommu object. 
> 
> Yes, I fully expect this
> 
> > If my recollection is correct, the arm
> > smmu-v3 needs it to obtain the vmid to setup the userspace event queue:
> 
> Right now it will use a VMID unrelated to KVM. BTM support on ARM will
> require syncing the VMID with KVM.
> 
> AMD and Intel may require the KVM for some reason as well.
> 
> For CC I'm expecting the KVM fd to be the handle for the cVM, so any
> RPCs that want to call into the secure world need the KVM FD to get
> the cVM's identifier. Ie a "bind to cVM" RPC will need the PCI
> information and the cVM's handle.

I also expect this.

> 
> From that perspective it does make sense that any cVM related APIs,
> like "bind to cVM" would be against the VDEVICE where we have a link
> to the VIOMMU which has the KVM. On the iommufd side the VIOMMU is
> part of the object hierarchy, but does not necessarily have to force a
> vIOMMU to appear in the cVM.
> 
> But it also seems to me that VFIO should be able to support putting
> the device into the RUN state

Firstly I think VFIO should support putting device into *LOCKED* state.
From LOCKED to RUN, there are many evidence fetching and attestation
things that only guest cares. I don't think VFIO needs to opt-in.

But that doesn't impact this concern. I actually think VFIO should
provide 'bind' uAPI to support these device side configuration things
rather than iommufd uAPI. IIUC iommufd should only do the setup on
IOMMU side.

The switching of TDISP state to LOCKED involves device side
differences that should be awared by the device owner, VFIO driver.

E.g. as we previously mentioned, to check if all MMIOs are never mapped.

Another E.g. invalidate MMIOs when device is to be LOCKED, some Pseudo
Code:

@@ -1494,7 +1494,15 @@ static int vfio_pci_ioctl_tsm_bind(struct vfio_pci_core_device *vdev,
        if (!kvm)
                return -ENOENT;

+       down_write(&vdev->memory_lock);
+       vfio_pci_dma_buf_move(vdev, true);
+
        ret = pci_tsm_dev_bind(pdev, kvm, &bind.intf_id);
+
+       if (__vfio_pci_memory_enabled(vdev))
+               vfio_pci_dma_buf_move(vdev, false);
+       up_write(&vdev->memory_lock);


BTW, we may still need viommu/vdevice APIs during 'bind', if some IOMMU
side configurations are required by secure world. TDX does have some.

> without involving KVM or cVMs.

It may not be feasible for all vendors. I believe AMD would have one
firmware call that requires cVM handle *AND* move device into LOCKED
state. It really depends on firmware implementation.

So I'm expecting a coarse TSM verb pci_tsm_dev_bind() for vendors to do
any host side preparation and put device into LOCKED state.

> 
> > Intel TDX connect implementation also needs a reference to the kvm
> > pointer to obtain the secure EPT information. This is crucial because
> > the CPU's page table must be shared with the iommu. 
> 
> I thought kvm folks were NAKing this sharing entirely? Or is the

I believe this is still Based on the general EPT sharing idea, is it?

There are several major reasons for the objection. In general, KVM now
has many "page non-present" tricks in EPT, which are not applicable to
IOPT. If shared, KVM has to take IOPT concerns into account, which is
quite a burden for KVM maintaining.

> secure EPT in the secure world and not directly managed by Linux?

Yes, the secure EPT is in the secure world and managed by TDX firmware.
Now a SW Mirror Secure EPT is introduced in KVM and managed by KVM
directly, and KVM will finally use firmware calls to propagate Mirror
Secure EPT changes to secure EPT.

Secure EPT are controlled by TDX module, basically KVM cannot play any
of the tricks. And TDX firmware should ensure any SEPT setting would be
applicable for Secure IOPT. I hope this could remove most of the
concerns.

I remember we've talked about SEPT sharing architechture for TDX TIO
before, but didn't get information back from KVM folks. Not sure how
things will go. Maybe will find out when we have some patches posted.

Thanks,
Yilun

> 
> AFAIK AMD is going to mirror the iommu page table like today.
> 
> ARM, I suspect, will not have an "EPT" under Linux control, so
> whatever happens will be hidden in their secure world.
> 
> Jason

