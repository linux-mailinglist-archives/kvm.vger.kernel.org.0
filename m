Return-Path: <kvm+bounces-48176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9B7ACB60F
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 17:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A04CF1947750
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 14:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFFCC239570;
	Mon,  2 Jun 2025 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gAxGSIiR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394D2231C87;
	Mon,  2 Jun 2025 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875839; cv=none; b=QugAXskoUdlVX0Zok5GPAbic1uABWipBpraotpqsXFUcheSrB8heSRMm9bBemhbfcaxQNj1czC/lpfgPWZplQVtxBM4TAidkGFPG3tj1+t3AyF8O57LJ3YxHYzAPr9Jtoa1Sfi56ufhGJyZbRWPsK/vaRR9V0JSNF/EjjE7c7OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875839; c=relaxed/simple;
	bh=gvltXEjxatA7cwXbM1ySU6qvzw0guFizH5e5rJ906Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKCfVUdZiMe18+TtAoepz4+Ug90Zc+TeLuL4VOT5f3BuNGTh5tqa+g9dULfPxvBbszwje2XpGCI/KRwje75CHNm2q7ONU53ts1TuD9A+rvzxYiVaIhGISjQwAtTf2LFOOdDsnaU1YuSu/2yUHCnpULiT9IIeg8GCVHHkFmwCOhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gAxGSIiR; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748875837; x=1780411837;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gvltXEjxatA7cwXbM1ySU6qvzw0guFizH5e5rJ906Jg=;
  b=gAxGSIiRmPNfF74z2v8p2uVMdrDvB4Jsrq8ai5zQsR3qVdx0+/uPq/Mt
   GBDj5QJNgPR2vrvyfmggDnZrV9zJODB3shZWed6D32t/XVl55+bhylPaZ
   wZAp1xnOOe8qMqLneoPW9lZKWGCQ2/25KeRXi5lUMrvSUGe4/vCuTkJtR
   xQGaXzZAvA8LjKP+0mEu1VF1gviAgLn6FwJGrTD/w2tViWVAjMYLq0O/b
   zqOiH82efqUBRaFhBUCWqbU/8sZE07+rrXcMSpAPvT2B17Yi3Y45FNLt5
   BW2ok61D1J1aIyKeh0xaXPF2N8lL/l3wRGnzU1MKiOZdget/V+kKInIRP
   A==;
X-CSE-ConnectionGUID: bONEmGf5SUC+7oJCVuxPAw==
X-CSE-MsgGUID: u2QuODLRRcCkredeVqk/lw==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="68435605"
X-IronPort-AV: E=Sophos;i="6.16,203,1744095600"; 
   d="scan'208";a="68435605"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 07:50:36 -0700
X-CSE-ConnectionGUID: bSyumsRCQFaHieW5WnNEIw==
X-CSE-MsgGUID: ORB/JHGpRB2A/q6o48Pqug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,203,1744095600"; 
   d="scan'208";a="144592177"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa009.jf.intel.com with ESMTP; 02 Jun 2025 07:50:30 -0700
Date: Mon, 2 Jun 2025 22:43:59 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com, yilun.xu@intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 19/30] vfio/pci: Add TSM TDI bind/unbind IOCTLs for
 TEE-IO support
Message-ID: <aD24r44v0g1NgeZs@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-20-yilun.xu@linux.intel.com>
 <yq5aplfn210z.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aplfn210z.fsf@kernel.org>

On Sun, Jun 01, 2025 at 04:15:32PM +0530, Aneesh Kumar K.V wrote:
> Xu Yilun <yilun.xu@linux.intel.com> writes:
> 
> > Add new IOCTLs to do TSM based TDI bind/unbind. These IOCTLs are
> > expected to be called by userspace when CoCo VM issues TDI bind/unbind
> > command to VMM. Specifically for TDX Connect, these commands are some
> > secure Hypervisor call named GHCI (Guest-Hypervisor Communication
> > Interface).
> >
> > The TSM TDI bind/unbind operations are expected to be initiated by a
> > running CoCo VM, which already have the legacy assigned device in place.
> > The TSM bind operation is to request VMM make all secure configurations
> > to support device work as a TDI, and then issue TDISP messages to move
> > the TDI to CONFIG_LOCKED or RUN state, waiting for guest's attestation.
> >
> > Do TSM Unbind before vfio_pci_core_disable(), otherwise will lead
> > device to TDISP ERROR state.
> >
> 
> Any reason these need to be a vfio ioctl instead of iommufd ioctl?
> For ex: https://lore.kernel.org/all/20250529133757.462088-3-aneesh.kumar@kernel.org/

A general reason is, the device driver - VFIO should be aware of the
bound state, and some operations break the bound state. VFIO should also
know some operations on bound may crash kernel because of platform TSM
firmware's enforcement. E.g. zapping MMIO, because private MMIO mapping
in secure page tables cannot be unmapped before TDI STOP [1].

Specifically, for TDX Connect, the firmware enforces MMIO unmapping in
S-EPT would fail if TDI is bound. For AMD there seems also some
requirement about this but I need Alexey's confirmation.

[1] https://lore.kernel.org/all/aDnXxk46kwrOcl0i@yilunxu-OptiPlex-7050/

> 
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> > ---
> >  drivers/vfio/iommufd.c           | 22 ++++++++++
> >  drivers/vfio/pci/vfio_pci_core.c | 74 ++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h             |  7 +++
> >  include/linux/vfio_pci_core.h    |  1 +
> >  include/uapi/linux/vfio.h        | 42 ++++++++++++++++++
> >  5 files changed, 146 insertions(+)
> >
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index 3441d24538a8..33fd20ffaeee 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -297,3 +297,25 @@ void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev)
> >  	vdev->iommufd_attached = false;
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_detach_ioas);
> > +
> > +int vfio_iommufd_tsm_bind(struct vfio_device *vdev, u32 vdevice_id)
> > +{
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	if (WARN_ON(!vdev->iommufd_device))
> > +		return -EINVAL;
> > +
> > +	return iommufd_device_tsm_bind(vdev->iommufd_device, vdevice_id);
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_iommufd_tsm_bind);
> > +
> > +void vfio_iommufd_tsm_unbind(struct vfio_device *vdev)
> > +{
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	if (WARN_ON(!vdev->iommufd_device))
> > +		return;
> > +
> > +	iommufd_device_tsm_unbind(vdev->iommufd_device);
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_iommufd_tsm_unbind);
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 116964057b0b..92544e54c9c3 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -692,6 +692,13 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
> >  #if IS_ENABLED(CONFIG_EEH)
> >  	eeh_dev_release(vdev->pdev);
> >  #endif
> > +
> > +	if (vdev->is_tsm_bound) {
> > +		vfio_iommufd_tsm_unbind(&vdev->vdev);
> > +		pci_release_regions(vdev->pdev);
> > +		vdev->is_tsm_bound = false;
> > +	}
> > +
> >  	vfio_pci_core_disable(vdev);
> >  
> >  	vfio_pci_dma_buf_cleanup(vdev);
> > @@ -1447,6 +1454,69 @@ static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
> >  				  ioeventfd.fd);
> >  }
> >  
> > +static int vfio_pci_ioctl_tsm_bind(struct vfio_pci_core_device *vdev,
> > +				   void __user *arg)
> > +{
> > +	unsigned long minsz = offsetofend(struct vfio_pci_tsm_bind, vdevice_id);
> > +	struct vfio_pci_tsm_bind tsm_bind;
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	int ret;
> > +
> > +	if (copy_from_user(&tsm_bind, arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (tsm_bind.argsz < minsz || tsm_bind.flags)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&vdev->vdev.dev_set->lock);
> > +
> > +	/* To ensure no host side MMIO access is possible */
> > +	ret = pci_request_regions_exclusive(pdev, "vfio-pci-tsm");
> > +	if (ret)
> > +		goto out_unlock;
> >
> 
> This should be part of pci_tsm_bind() ? 

I'm not quite sure. My feelig is this method is specific for VFIO
driver. Many other drivers just request regions on probe(), they can
never bind successfully if pci tsm hide this implementation internally.

Thanks,
Yilun

