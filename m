Return-Path: <kvm+bounces-48151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A7DEACA920
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 07:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBCE5189CC07
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 05:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C4119342F;
	Mon,  2 Jun 2025 05:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5Sd2nst"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B82B65C;
	Mon,  2 Jun 2025 05:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748843417; cv=none; b=l5SH4oYBVewRRragluhLnAcKVsrsp6jNv9Swfzs/Ogm4zZnOGNgTcozP1/YBjaYbRHC61aKhag6LHGs7CBbouGtsip9uiZFlmMaydriKhILBfQLWfdiU6CqPdIVXl4QcD1cyLgn94+JL9TTne8fH/gGuFF4exM/N5w+69bgpKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748843417; c=relaxed/simple;
	bh=dhCKdaNGVDVa0JTWjU+OMRG/7HWBCYhvLNRz1AVVfXE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Nd6QOPe/BUlSpZF5WgJpDN8AhhP+G2tN9KLLDsR9OqjJ18gB++9svNGu2XQxqbE3zbkqx3RzkeJTOlK7pvomaabv2xZgKlNwe2NVjsqYPYAuSiZthY4YLlmxPCw0igyHD1zFU8dv/uiOPi8hsUiaSf8nO2OTjgrFRpuXSoF2Fug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5Sd2nst; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44666C4CEEB;
	Mon,  2 Jun 2025 05:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748843416;
	bh=dhCKdaNGVDVa0JTWjU+OMRG/7HWBCYhvLNRz1AVVfXE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=G5Sd2nstABBUN5D1nIItdFgV+88+1UPejyKervnRfy9iyIoVp/dv1N7AW4iwLkkRq
	 9Eaaml3nHfPK1UNp1BNYzXmIcjmoirTwXw8t9nerrBwlWIWg9YJCgVbWITI15QZdMD
	 bwGsYls8TnqnHrr04C2Suw2oQm16OycxnhpeYbkvRO+ByiC8T618kZzC59zz4MXo9H
	 3TEefc7NGVkny+vE1KqLfupzE09RfLCTPXhTnpdNVEbeikKzA5ycSQZnGmumbAG1z3
	 lzzGIWiZdry/9Lom+86S8+B7hlr5uZ4IRzUOl8kSR1VdzaSVTOxAbWTZuye6KCHguS
	 AgRkt5LjU0ATw==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 Q)
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
Subject: Re: [RFC PATCH 20/30] vfio/pci: Do TSM Unbind before zapping bars
In-Reply-To: <20250529053513.1592088-21-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-21-yilun.xu@linux.intel.com>
Date: Mon, 02 Jun 2025 10:50:11 +0530
Message-ID: <yq5a34cilnxw.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Xu Yilun <yilun.xu@linux.intel.com> writes:

> When device is TSM Bound, some of its MMIO regions are controlled by
> secure firmware. E.g. TDX Connect would require these MMIO regions
> mappeed in S-EPT and never unmapped until device Unbound. Zapping bars
> irrespective of TSM Bound state may cause unexpected secure firmware
> errors. It is always safe to do TSM Unbind first, transiting the device
> to shared, then do whatever needed as before.
>
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |  4 +++
>  drivers/vfio/pci/vfio_pci_core.c   | 41 +++++++++++++++++++-----------
>  drivers/vfio/pci/vfio_pci_priv.h   |  3 +++
>  3 files changed, 33 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 7ac062bd5044..4ffe661c9e59 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -590,6 +590,7 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
>  		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
>  
>  		if (!new_mem) {
> +			vfio_pci_tsm_unbind(vdev);
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
>  			vfio_pci_dma_buf_move(vdev, true);
>

Don't we need to re-bind the vdev with tsm_bind for the continued use of TDI?

>  		} else {
> @@ -712,6 +713,7 @@ static void vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
>  					  pci_power_t state)
>  {
>  	if (state >= PCI_D3hot) {
> +		vfio_pci_tsm_unbind(vdev);
>  		vfio_pci_zap_and_down_write_memory_lock(vdev);
>  		vfio_pci_dma_buf_move(vdev, true);
>  	} else {
> @@ -907,6 +909,7 @@ static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
>  						 &cap);
>  
>  		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
> +			vfio_pci_tsm_unbind(vdev);
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
>  			vfio_pci_dma_buf_move(vdev, true);
>  			pci_try_reset_function(vdev->pdev);
> @@ -992,6 +995,7 @@ static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
>  						&cap);
>  
>  		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
> +			vfio_pci_tsm_unbind(vdev);
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
>  			vfio_pci_dma_buf_move(vdev, true);
>  			pci_try_reset_function(vdev->pdev);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 92544e54c9c3..a8437fcecca1 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -286,6 +286,7 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
>  	 * The vdev power related flags are protected with 'memory_lock'
>  	 * semaphore.
>  	 */
> +	vfio_pci_tsm_unbind(vdev);
>  	vfio_pci_zap_and_down_write_memory_lock(vdev);
>  	vfio_pci_dma_buf_move(vdev, true);
>  
> @@ -693,11 +694,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  	eeh_dev_release(vdev->pdev);
>  #endif
>  
> -	if (vdev->is_tsm_bound) {
> -		vfio_iommufd_tsm_unbind(&vdev->vdev);
> -		pci_release_regions(vdev->pdev);
> -		vdev->is_tsm_bound = false;
> -	}
> +	__vfio_pci_tsm_unbind(vdev);
>  
>  	vfio_pci_core_disable(vdev);
>  
> @@ -1222,6 +1219,7 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
>  	if (!vdev->reset_works)
>  		return -EINVAL;
>  
> +	vfio_pci_tsm_unbind(vdev);
>  	vfio_pci_zap_and_down_write_memory_lock(vdev);
>  
>  	/*
> @@ -1491,12 +1489,32 @@ static int vfio_pci_ioctl_tsm_bind(struct vfio_pci_core_device *vdev,
>  	return ret;
>  }
>  
> +void __vfio_pci_tsm_unbind(struct vfio_pci_core_device *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +
> +	lockdep_assert_held(&vdev->vdev.dev_set->lock);
> +
> +	if (!vdev->is_tsm_bound)
> +		return;
> +
> +	vfio_iommufd_tsm_unbind(&vdev->vdev);
> +	pci_release_regions(pdev);
> +	vdev->is_tsm_bound = false;
>

Do we really need to check vdev->is_tsm_bound? The tsm_ops lock already
ensures that concurrent TSM operations can't happen, and repeated calls
to bind()/unbind() seem to be handled safely by pci_tsm_bind and pci_tsm_unbind.

> +}
> +
> +void vfio_pci_tsm_unbind(struct vfio_pci_core_device *vdev)
> +{
> +	mutex_lock(&vdev->vdev.dev_set->lock);
> +	__vfio_pci_tsm_unbind(vdev);
> +	mutex_unlock(&vdev->vdev.dev_set->lock);
> +}
>

If is_tsm_bound is no longer needed, and pci_release_regions /
request_region_exclusive are now handled within pci_tsm_unbind / bind,
do we still need mutex_lock() to guard this path?

> +
>  static int vfio_pci_ioctl_tsm_unbind(struct vfio_pci_core_device *vdev,
>  				     void __user *arg)
>  {
>  	unsigned long minsz = offsetofend(struct vfio_pci_tsm_unbind, flags);
>  	struct vfio_pci_tsm_unbind tsm_unbind;
> -	struct pci_dev *pdev = vdev->pdev;
>  
>  	if (copy_from_user(&tsm_unbind, arg, minsz))
>  		return -EFAULT;
> @@ -1504,15 +1522,7 @@ static int vfio_pci_ioctl_tsm_unbind(struct vfio_pci_core_device *vdev,
>  	if (tsm_unbind.argsz < minsz || tsm_unbind.flags)
>  		return -EINVAL;
>  
> -	mutex_lock(&vdev->vdev.dev_set->lock);
> -
> -	if (!vdev->is_tsm_bound)
> -		return 0;
> -
> -	vfio_iommufd_tsm_unbind(&vdev->vdev);
> -	pci_release_regions(pdev);
> -	vdev->is_tsm_bound = false;
> -	mutex_unlock(&vdev->vdev.dev_set->lock);
> +	vfio_pci_tsm_unbind(vdev);
>  
>  	return 0;
>  }
> @@ -2526,6 +2536,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  			break;
>  		}
>  
> +		__vfio_pci_tsm_unbind(vdev);
>  		/*
>  		 * Take the memory write lock for each device and zap BAR
>  		 * mappings to prevent the user accessing the device while in
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index 6f3e8eafdc35..e5bf27f46a73 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -130,4 +130,7 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
>  }
>  #endif
>  
> +void __vfio_pci_tsm_unbind(struct vfio_pci_core_device *vdev);
> +void vfio_pci_tsm_unbind(struct vfio_pci_core_device *vdev);
> +
>  #endif
> -- 
> 2.25.1

