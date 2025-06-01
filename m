Return-Path: <kvm+bounces-48147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41071AC9E5E
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 12:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37C063B5116
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 10:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32CB1B0F17;
	Sun,  1 Jun 2025 10:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qDYV1/ZA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52D17DA66;
	Sun,  1 Jun 2025 10:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748774746; cv=none; b=Ugfpw/hgy5dkHWrtKgc61CZfviDwCPhMmh7Ov+aKPTcohRE/LX1vrI8IOHqng5ppRzNB4sdBe13LLDz/qnUUYvTmYX6iGVnTBPhHWeVjXRhQ56rOuFQpDX/k18fC0+bWBiL9Pd3r2RW3wHDCx6Ft61cC9rGYPY1FqcEY+IQa/A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748774746; c=relaxed/simple;
	bh=knDZgzB0R6dEpWPhQ7xIaO+LHFR6wi+XZqOGDMJ/B0w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FthLmwVD6K/JEGR68OFMve7n9MmIOF410LZ+UTc3wgqDuM2PcnC+o9/+cTTdaQq+eiXEdDM8U++ZTjC+rTdPQRgVeKoUiCXpS2TpOl/nFC67F2Oi59f7fK+fLAShWHfrQIhmFcSR8h5UU36QRH5xq3RFR44eYW+cZsuwc0kDZms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qDYV1/ZA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C73FC4CEE7;
	Sun,  1 Jun 2025 10:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748774745;
	bh=knDZgzB0R6dEpWPhQ7xIaO+LHFR6wi+XZqOGDMJ/B0w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qDYV1/ZAycrdKvqDBdRG18s72KjUVe1utEyYr/NWAvvRLiRpjj/EBvjGqxUkYxBc9
	 5x2s3Z6wQm87Uqy4ekxSFAj6UeNcohh5VOsC8TP2dS5WqYvlV5lrNmU5gLPFBhqCw9
	 1Q/8/QBKQSXyfxk9GsA1FNMKeNCTuuUojMDBd/c7FV1vTtZjb6wCZyl+X8FCk16/v+
	 xP5yeouaAVK5TT5TRkyZ3Gkrdn2CbPJkMjJLE/TWcnD9eXCnUb7tqIxmDlA3e7c4fj
	 Hl7zyUiXQUEGRHrd6c9q5jweG0Ck/87xImFcW4s+4EfdqM57o+nW0XIkgpJpoPfn4T
	 6Maoj+pH2Rttw==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 19/30] vfio/pci: Add TSM TDI bind/unbind IOCTLs for
 TEE-IO support
In-Reply-To: <20250529053513.1592088-20-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-20-yilun.xu@linux.intel.com>
Date: Sun, 01 Jun 2025 16:15:32 +0530
Message-ID: <yq5aplfn210z.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Xu Yilun <yilun.xu@linux.intel.com> writes:

> Add new IOCTLs to do TSM based TDI bind/unbind. These IOCTLs are
> expected to be called by userspace when CoCo VM issues TDI bind/unbind
> command to VMM. Specifically for TDX Connect, these commands are some
> secure Hypervisor call named GHCI (Guest-Hypervisor Communication
> Interface).
>
> The TSM TDI bind/unbind operations are expected to be initiated by a
> running CoCo VM, which already have the legacy assigned device in place.
> The TSM bind operation is to request VMM make all secure configurations
> to support device work as a TDI, and then issue TDISP messages to move
> the TDI to CONFIG_LOCKED or RUN state, waiting for guest's attestation.
>
> Do TSM Unbind before vfio_pci_core_disable(), otherwise will lead
> device to TDISP ERROR state.
>

Any reason these need to be a vfio ioctl instead of iommufd ioctl?
For ex: https://lore.kernel.org/all/20250529133757.462088-3-aneesh.kumar@kernel.org/

>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> ---
>  drivers/vfio/iommufd.c           | 22 ++++++++++
>  drivers/vfio/pci/vfio_pci_core.c | 74 ++++++++++++++++++++++++++++++++
>  include/linux/vfio.h             |  7 +++
>  include/linux/vfio_pci_core.h    |  1 +
>  include/uapi/linux/vfio.h        | 42 ++++++++++++++++++
>  5 files changed, 146 insertions(+)
>
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 3441d24538a8..33fd20ffaeee 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -297,3 +297,25 @@ void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev)
>  	vdev->iommufd_attached = false;
>  }
>  EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_detach_ioas);
> +
> +int vfio_iommufd_tsm_bind(struct vfio_device *vdev, u32 vdevice_id)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_device))
> +		return -EINVAL;
> +
> +	return iommufd_device_tsm_bind(vdev->iommufd_device, vdevice_id);
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_tsm_bind);
> +
> +void vfio_iommufd_tsm_unbind(struct vfio_device *vdev)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_device))
> +		return;
> +
> +	iommufd_device_tsm_unbind(vdev->iommufd_device);
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_tsm_unbind);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 116964057b0b..92544e54c9c3 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -692,6 +692,13 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  #if IS_ENABLED(CONFIG_EEH)
>  	eeh_dev_release(vdev->pdev);
>  #endif
> +
> +	if (vdev->is_tsm_bound) {
> +		vfio_iommufd_tsm_unbind(&vdev->vdev);
> +		pci_release_regions(vdev->pdev);
> +		vdev->is_tsm_bound = false;
> +	}
> +
>  	vfio_pci_core_disable(vdev);
>  
>  	vfio_pci_dma_buf_cleanup(vdev);
> @@ -1447,6 +1454,69 @@ static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
>  				  ioeventfd.fd);
>  }
>  
> +static int vfio_pci_ioctl_tsm_bind(struct vfio_pci_core_device *vdev,
> +				   void __user *arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_pci_tsm_bind, vdevice_id);
> +	struct vfio_pci_tsm_bind tsm_bind;
> +	struct pci_dev *pdev = vdev->pdev;
> +	int ret;
> +
> +	if (copy_from_user(&tsm_bind, arg, minsz))
> +		return -EFAULT;
> +
> +	if (tsm_bind.argsz < minsz || tsm_bind.flags)
> +		return -EINVAL;
> +
> +	mutex_lock(&vdev->vdev.dev_set->lock);
> +
> +	/* To ensure no host side MMIO access is possible */
> +	ret = pci_request_regions_exclusive(pdev, "vfio-pci-tsm");
> +	if (ret)
> +		goto out_unlock;
>

This should be part of pci_tsm_bind() ? 

> +
> +	ret = vfio_iommufd_tsm_bind(&vdev->vdev, tsm_bind.vdevice_id);
> +	if (ret)
> +		goto out_release_region;
> +
> +	vdev->is_tsm_bound = true;
> +	mutex_unlock(&vdev->vdev.dev_set->lock);
> +
> +	return 0;
> +
> +out_release_region:
> +	pci_release_regions(pdev);
> +out_unlock:
> +	mutex_unlock(&vdev->vdev.dev_set->lock);
> +	return ret;
> +}
> +
> +static int vfio_pci_ioctl_tsm_unbind(struct vfio_pci_core_device *vdev,
> +				     void __user *arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_pci_tsm_unbind, flags);
> +	struct vfio_pci_tsm_unbind tsm_unbind;
> +	struct pci_dev *pdev = vdev->pdev;
> +
> +	if (copy_from_user(&tsm_unbind, arg, minsz))
> +		return -EFAULT;
> +
> +	if (tsm_unbind.argsz < minsz || tsm_unbind.flags)
> +		return -EINVAL;
> +
> +	mutex_lock(&vdev->vdev.dev_set->lock);
> +
> +	if (!vdev->is_tsm_bound)
> +		return 0;
> +
> +	vfio_iommufd_tsm_unbind(&vdev->vdev);
> +	pci_release_regions(pdev);
> +	vdev->is_tsm_bound = false;
> +	mutex_unlock(&vdev->vdev.dev_set->lock);
> +
> +	return 0;
> +}
> +


-aneesh

