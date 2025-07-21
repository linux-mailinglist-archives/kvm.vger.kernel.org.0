Return-Path: <kvm+bounces-52970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD0CB0C419
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05F654E2B9C
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95DE2D3EE1;
	Mon, 21 Jul 2025 12:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thg+FHvg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41F120F098
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 12:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753100853; cv=none; b=rIEEOUxr0c3skTjG7RIlBJJMf0nkaEQbWmJnk2siyQRchGQr0PXV2QxorrPxynYQPx8Ka5ZPm4FsCoeINwRidC0ch3dnF7o0QPbLf77HC4O9jwE6I4phM/+4bWYNLKNEV5reM3bLYoldV2ycnoqZ8RfnST+rC0pvzneMLAA6Nco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753100853; c=relaxed/simple;
	bh=qLapjG2Q1wDEwOcTlNkyAdtqISZebfaOjZ1Uo6ISD+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsBW870tdD5YY5T4Aro6/khuVHHf4s7+FxBDHsmxylEZISCx4WwGngXi6mvQumtCGwJ5zY5BJwpwHEOio2NjOmtBo0s41Cfq/0pHI9kwQBwOBlceMNmoc9AjD3+IVIuXlJLrpPQHfLZ+Vor+efjAgGxy4Q4nqF7Qcb0Ehl/s2p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thg+FHvg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A050C4CEED;
	Mon, 21 Jul 2025 12:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753100853;
	bh=qLapjG2Q1wDEwOcTlNkyAdtqISZebfaOjZ1Uo6ISD+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=thg+FHvgNyKBEvpji3rvaS3VCu9VXHvFyn9cTedAlcdi3gXWeomaZrelSemC/7eZ2
	 +LcEFtGW5+7hQM+7tiYkTL+6dTq8zDu1L9bYKfeTU42vj9byh4XeXQ9RLQQZC+OvTo
	 KdIC1UCpFi8iBJjN4yCt6gtOiihncih4zZTwNhstlCOpsMPkEGupA4R/2R+ucsMdoE
	 Shz4Fw9xDvukxQxv3nMHGJ61wpnoTdsEt227G2O/2vryOazqlVhayyrT31lhakU9eY
	 8Hpsat+Sl+WnzJPZGYRqFj9liFm51OZuijUgQtWnKUrXXOlEmU0N++XOZrVw3I3Kfu
	 diidsu66UBnhA==
Date: Mon, 21 Jul 2025 13:27:29 +0100
From: Will Deacon <will@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
Message-ID: <aH4yMUWTuVtgqD7T@willie-the-truck>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250525074917.150332-9-aneesh.kumar@kernel.org>

On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
> This also allocates a stage1 bypass and stage2 translate table.

Please write your commit messages as per Linux kernel guidelines.

> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  builtin-run.c            |   2 +
>  include/kvm/kvm-config.h |   1 +
>  vfio/core.c              |   4 +-
>  vfio/iommufd.c           | 115 ++++++++++++++++++++++++++++++++++++++-

[...]

>  4 files changed, 119 insertions(+), 3 deletions(-)
> diff --git a/vfio/iommufd.c b/vfio/iommufd.c
> index 742550705746..39870320e4ac 100644
> --- a/vfio/iommufd.c
> +++ b/vfio/iommufd.c
> @@ -108,6 +108,116 @@ err_out:
>  	return ret;
>  }
>  
> +static int iommufd_alloc_s1bypass_hwpt(struct vfio_device *vdev)
> +{
> +	int ret;
> +	unsigned long dev_num;
> +	unsigned long guest_bdf;
> +	struct vfio_device_bind_iommufd bind;
> +	struct vfio_device_attach_iommufd_pt attach_data;
> +	struct iommu_hwpt_alloc alloc_hwpt;
> +	struct iommu_viommu_alloc alloc_viommu;
> +	struct iommu_hwpt_arm_smmuv3 bypass_ste;
> +	struct iommu_vdevice_alloc alloc_vdev;
> +
> +	bind.argsz = sizeof(bind);
> +	bind.flags = 0;
> +	bind.iommufd = iommu_fd;
> +
> +	/* now bind the iommufd */
> +	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to get info");
> +		goto err_out;
> +	}
> +
> +	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
> +	alloc_hwpt.flags = IOMMU_HWPT_ALLOC_NEST_PARENT;
> +	alloc_hwpt.dev_id = bind.out_devid;
> +	alloc_hwpt.pt_id = ioas_id;
> +	alloc_hwpt.data_type = IOMMU_HWPT_DATA_NONE;
> +	alloc_hwpt.data_len = 0;
> +	alloc_hwpt.data_uptr = 0;
> +
> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
> +		ret = -errno;
> +		pr_err("Failed to allocate HWPT");
> +		goto err_out;
> +	}
> +
> +	attach_data.argsz = sizeof(attach_data);
> +	attach_data.flags = 0;
> +	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
> +
> +	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to attach to IOAS ");
> +		goto err_out;
> +	}
> +
> +	alloc_viommu.size = sizeof(alloc_viommu);
> +	alloc_viommu.flags = 0;
> +	alloc_viommu.type = IOMMU_VIOMMU_TYPE_ARM_SMMUV3;
> +	alloc_viommu.dev_id = bind.out_devid;
> +	alloc_viommu.hwpt_id = alloc_hwpt.out_hwpt_id;
> +
> +	if (ioctl(iommu_fd, IOMMU_VIOMMU_ALLOC, &alloc_viommu)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to allocate VIOMMU %d", ret);
> +		goto err_out;
> +	}
> +#define STRTAB_STE_0_V			(1UL << 0)
> +#define STRTAB_STE_0_CFG_S2_TRANS	6
> +#define STRTAB_STE_0_CFG_S1_TRANS	5
> +#define STRTAB_STE_0_CFG_BYPASS		4
> +
> +	/* set up virtual ste as bypass ste */
> +	bypass_ste.ste[0] = STRTAB_STE_0_V | (STRTAB_STE_0_CFG_BYPASS << 1);
> +	bypass_ste.ste[1] = 0x0UL;
> +
> +	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
> +	alloc_hwpt.flags = 0;
> +	alloc_hwpt.dev_id = bind.out_devid;
> +	alloc_hwpt.pt_id = alloc_viommu.out_viommu_id;
> +	alloc_hwpt.data_type = IOMMU_HWPT_DATA_ARM_SMMUV3;
> +	alloc_hwpt.data_len = sizeof(bypass_ste);
> +	alloc_hwpt.data_uptr = (unsigned long)&bypass_ste;
> +
> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
> +		ret = -errno;
> +		pr_err("Failed to allocate S1 bypass HWPT %d", ret);
> +		goto err_out;
> +	}
> +
> +	alloc_vdev.size = sizeof(alloc_vdev),
> +	alloc_vdev.viommu_id = alloc_viommu.out_viommu_id;
> +	alloc_vdev.dev_id = bind.out_devid;
> +
> +	dev_num = vdev->dev_hdr.dev_num;
> +	/* kvmtool only do 0 domain, 0 bus and 0 function devices. */
> +	guest_bdf = (0ULL << 32) | (0 << 16) | dev_num << 11 | (0 << 8);

I don't understand this. Shouldn't the BDF correspond to the virtual
configuration space? That's not allocated until later, but just going
with 0 isn't going to work.

What am I missing?

Will

