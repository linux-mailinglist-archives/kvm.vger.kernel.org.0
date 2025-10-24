Return-Path: <kvm+bounces-61011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E9BB2C0588B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 12:13:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 14E55507CC6
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 10:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879B930EF8B;
	Fri, 24 Oct 2025 10:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eNGIJm7A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1729930E0E0;
	Fri, 24 Oct 2025 10:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761300764; cv=none; b=i2Lsk9vn/7DJTDfdNPAQT/pZsRXbkc96WJk7qsVjHMZt0Di8jSDLSYjFmbLg5365oC0xJQYjT/sXOhOm9T9ZCg6v73TlSCKIvbYTThYMcl0c7Wvc96onL+4J9h4bAU85EDPHIfUqkpjiWgXRZbWDGUHMoSVWpJkFbK302TYZ2z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761300764; c=relaxed/simple;
	bh=xlFYDG2bQlVTloS05eCO9qDMzMthfcITU9mwgsQzjDk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=u7lGLfNdduDGi/gSmQUmuM8vf1JX9HEjp1XKkl5UCnm9uyhIdHJt/dcDA5TglonY+x1Tj/INY6l3T+STOvUDcOHlKV7iaak/qhwNDa2EQbZWh90FSfUbyso1v2mL/68jdLrpPwBV3Vav/fEckzoubHr3T4WWxtfmV16x+uryQrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eNGIJm7A; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761300762; x=1792836762;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=xlFYDG2bQlVTloS05eCO9qDMzMthfcITU9mwgsQzjDk=;
  b=eNGIJm7AN7UlVokllgHjFBz5m43Sw5zshgu0bzexnF2+eb9ZPouuSB3P
   gQHR+xKYE2s2Gy5b2Q99Ie0rydQPkBqlmwdhpankG0U+9tlfT1HKx6k0e
   0L6adnMa1FDRbTjmSg+RttFe45XdmRjH3GUUVF5oaUHSuLZlWYAvoycH0
   i1xk93TCuRWDZPNeBQaO/u46zya7AmOWQE0OZ0SHu3eTQbBaCszUxDuB+
   2v6uJR5pPWcDgG0VS3wu+E1+XEHaiG0tjEfmM1n2vFlUxBeI664154MbC
   aA/09nvNP+rMrubt265fzlxV+q+eOgv3habUFACQGw1FdfNUcbDVNu2vR
   Q==;
X-CSE-ConnectionGUID: H+x17JegQDao8VujjAQpIg==
X-CSE-MsgGUID: 5w17pZfdSXOG8HhPLW7HXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67347159"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="67347159"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 03:12:41 -0700
X-CSE-ConnectionGUID: A7yLYNKyQ0Ws/5qhPckICQ==
X-CSE-MsgGUID: aVukQjuxQOaWBvcBdIAMQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="184109635"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.246.230])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 03:12:31 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, David Airlie <airlied@gmail.com>, Alex
 Williamson <alex.williamson@redhat.com>, Ankit Agrawal
 <ankita@nvidia.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Brett Creeley <brett.creeley@amd.com>, dri-devel@lists.freedesktop.org,
 Eric Auger <eric.auger@redhat.com>, Eric Farman <farman@linux.ibm.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 intel-gfx@lists.freedesktop.org, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
 linux-s390@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>, Matthew
 Rosato <mjrosato@linux.ibm.com>, Nikhil Agarwal <nikhil.agarwal@amd.com>,
 Nipun Gupta <nipun.gupta@amd.com>, Peter Oberparleiter
 <oberpar@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Pranjal
 Shrivastava <praan@google.com>, qat-linux@intel.com, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Simona Vetter <simona@ffwll.ch>, Shameer
 Kolothum <skolothumtho@nvidia.com>, Mostafa Saleh <smostafa@google.com>,
 Sven Schnelle <svens@linux.ibm.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, virtualization@lists.linux.dev, Vineeth Vijayan
 <vneethv@linux.ibm.com>, Yishai Hadas <yishaih@nvidia.com>, Zhenyu Wang
 <zhenyuw.linux@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH 13/22] vfio/gvt: Provide a get_region_info op
In-Reply-To: <13-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <13-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Date: Fri, 24 Oct 2025 13:12:28 +0300
Message-ID: <c30b38456cc11ced5b74d9d38900cf8544a1978e@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, 23 Oct 2025, Jason Gunthorpe <jgg@nvidia.com> wrote:
> Move it out of intel_vgpu_ioctl() and re-indent it.

Not a huge deal, but this will conflict with 69b4d367fff6
("drm/i915/gvt: Simplify case switch in intel_vgpu_ioctl") in
drm-intel-next.

BR,
Jani.


>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 301 +++++++++++++++----------------
>  1 file changed, 150 insertions(+), 151 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 69830a5c49d3fd..6b47e33078eb52 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1140,6 +1140,155 @@ static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
>  	return func(vgpu, index, start, count, flags, data);
>  }
>  
> +static int intel_vgpu_get_region_info(struct vfio_device *vfio_dev,
> +				      struct vfio_region_info __user *arg)
> +{
> +	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +	struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
> +	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
> +	struct vfio_region_info info;
> +	unsigned long minsz;
> +	int nr_areas = 1;
> +	int cap_type_id;
> +	unsigned int i;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_region_info, offset);
> +
> +	if (copy_from_user(&info, arg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	switch (info.index) {
> +	case VFIO_PCI_CONFIG_REGION_INDEX:
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		info.size = vgpu->gvt->device_info.cfg_space_size;
> +		info.flags = VFIO_REGION_INFO_FLAG_READ |
> +			     VFIO_REGION_INFO_FLAG_WRITE;
> +		break;
> +	case VFIO_PCI_BAR0_REGION_INDEX:
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		info.size = vgpu->cfg_space.bar[info.index].size;
> +		if (!info.size) {
> +			info.flags = 0;
> +			break;
> +		}
> +
> +		info.flags = VFIO_REGION_INFO_FLAG_READ |
> +			     VFIO_REGION_INFO_FLAG_WRITE;
> +		break;
> +	case VFIO_PCI_BAR1_REGION_INDEX:
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		info.size = 0;
> +		info.flags = 0;
> +		break;
> +	case VFIO_PCI_BAR2_REGION_INDEX:
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		info.flags = VFIO_REGION_INFO_FLAG_CAPS |
> +			     VFIO_REGION_INFO_FLAG_MMAP |
> +			     VFIO_REGION_INFO_FLAG_READ |
> +			     VFIO_REGION_INFO_FLAG_WRITE;
> +		info.size = gvt_aperture_sz(vgpu->gvt);
> +
> +		sparse = kzalloc(struct_size(sparse, areas, nr_areas),
> +				 GFP_KERNEL);
> +		if (!sparse)
> +			return -ENOMEM;
> +
> +		sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> +		sparse->header.version = 1;
> +		sparse->nr_areas = nr_areas;
> +		cap_type_id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> +		sparse->areas[0].offset =
> +			PAGE_ALIGN(vgpu_aperture_offset(vgpu));
> +		sparse->areas[0].size = vgpu_aperture_sz(vgpu);
> +		break;
> +
> +	case VFIO_PCI_BAR3_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		info.size = 0;
> +		info.flags = 0;
> +
> +		gvt_dbg_core("get region info bar:%d\n", info.index);
> +		break;
> +
> +	case VFIO_PCI_ROM_REGION_INDEX:
> +	case VFIO_PCI_VGA_REGION_INDEX:
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		info.size = 0;
> +		info.flags = 0;
> +
> +		gvt_dbg_core("get region info index:%d\n", info.index);
> +		break;
> +	default: {
> +		struct vfio_region_info_cap_type cap_type = {
> +			.header.id = VFIO_REGION_INFO_CAP_TYPE,
> +			.header.version = 1
> +		};
> +
> +		if (info.index >= VFIO_PCI_NUM_REGIONS + vgpu->num_regions)
> +			return -EINVAL;
> +		info.index = array_index_nospec(
> +			info.index, VFIO_PCI_NUM_REGIONS + vgpu->num_regions);
> +
> +		i = info.index - VFIO_PCI_NUM_REGIONS;
> +
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		info.size = vgpu->region[i].size;
> +		info.flags = vgpu->region[i].flags;
> +
> +		cap_type.type = vgpu->region[i].type;
> +		cap_type.subtype = vgpu->region[i].subtype;
> +
> +		ret = vfio_info_add_capability(&caps, &cap_type.header,
> +					       sizeof(cap_type));
> +		if (ret)
> +			return ret;
> +	}
> +	}
> +
> +	if ((info.flags & VFIO_REGION_INFO_FLAG_CAPS) && sparse) {
> +		switch (cap_type_id) {
> +		case VFIO_REGION_INFO_CAP_SPARSE_MMAP:
> +			ret = vfio_info_add_capability(
> +				&caps, &sparse->header,
> +				struct_size(sparse, areas, sparse->nr_areas));
> +			if (ret) {
> +				kfree(sparse);
> +				return ret;
> +			}
> +			break;
> +		default:
> +			kfree(sparse);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (caps.size) {
> +		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +		if (info.argsz < sizeof(info) + caps.size) {
> +			info.argsz = sizeof(info) + caps.size;
> +			info.cap_offset = 0;
> +		} else {
> +			vfio_info_cap_shift(&caps, sizeof(info));
> +			if (copy_to_user((void __user *)arg + sizeof(info),
> +					 caps.buf, caps.size)) {
> +				kfree(caps.buf);
> +				kfree(sparse);
> +				return -EFAULT;
> +			}
> +			info.cap_offset = sizeof(info);
> +		}
> +
> +		kfree(caps.buf);
> +	}
> +
> +	kfree(sparse);
> +	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
> +}
> +
>  static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
>  			     unsigned long arg)
>  {
> @@ -1168,157 +1317,6 @@ static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>  			-EFAULT : 0;
>  
> -	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> -		struct vfio_region_info info;
> -		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> -		unsigned int i;
> -		int ret;
> -		struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
> -		int nr_areas = 1;
> -		int cap_type_id;
> -
> -		minsz = offsetofend(struct vfio_region_info, offset);
> -
> -		if (copy_from_user(&info, (void __user *)arg, minsz))
> -			return -EFAULT;
> -
> -		if (info.argsz < minsz)
> -			return -EINVAL;
> -
> -		switch (info.index) {
> -		case VFIO_PCI_CONFIG_REGION_INDEX:
> -			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> -			info.size = vgpu->gvt->device_info.cfg_space_size;
> -			info.flags = VFIO_REGION_INFO_FLAG_READ |
> -				     VFIO_REGION_INFO_FLAG_WRITE;
> -			break;
> -		case VFIO_PCI_BAR0_REGION_INDEX:
> -			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> -			info.size = vgpu->cfg_space.bar[info.index].size;
> -			if (!info.size) {
> -				info.flags = 0;
> -				break;
> -			}
> -
> -			info.flags = VFIO_REGION_INFO_FLAG_READ |
> -				     VFIO_REGION_INFO_FLAG_WRITE;
> -			break;
> -		case VFIO_PCI_BAR1_REGION_INDEX:
> -			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> -			info.size = 0;
> -			info.flags = 0;
> -			break;
> -		case VFIO_PCI_BAR2_REGION_INDEX:
> -			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> -			info.flags = VFIO_REGION_INFO_FLAG_CAPS |
> -					VFIO_REGION_INFO_FLAG_MMAP |
> -					VFIO_REGION_INFO_FLAG_READ |
> -					VFIO_REGION_INFO_FLAG_WRITE;
> -			info.size = gvt_aperture_sz(vgpu->gvt);
> -
> -			sparse = kzalloc(struct_size(sparse, areas, nr_areas),
> -					 GFP_KERNEL);
> -			if (!sparse)
> -				return -ENOMEM;
> -
> -			sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> -			sparse->header.version = 1;
> -			sparse->nr_areas = nr_areas;
> -			cap_type_id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> -			sparse->areas[0].offset =
> -					PAGE_ALIGN(vgpu_aperture_offset(vgpu));
> -			sparse->areas[0].size = vgpu_aperture_sz(vgpu);
> -			break;
> -
> -		case VFIO_PCI_BAR3_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
> -			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> -			info.size = 0;
> -			info.flags = 0;
> -
> -			gvt_dbg_core("get region info bar:%d\n", info.index);
> -			break;
> -
> -		case VFIO_PCI_ROM_REGION_INDEX:
> -		case VFIO_PCI_VGA_REGION_INDEX:
> -			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> -			info.size = 0;
> -			info.flags = 0;
> -
> -			gvt_dbg_core("get region info index:%d\n", info.index);
> -			break;
> -		default:
> -			{
> -				struct vfio_region_info_cap_type cap_type = {
> -					.header.id = VFIO_REGION_INFO_CAP_TYPE,
> -					.header.version = 1 };
> -
> -				if (info.index >= VFIO_PCI_NUM_REGIONS +
> -						vgpu->num_regions)
> -					return -EINVAL;
> -				info.index =
> -					array_index_nospec(info.index,
> -							VFIO_PCI_NUM_REGIONS +
> -							vgpu->num_regions);
> -
> -				i = info.index - VFIO_PCI_NUM_REGIONS;
> -
> -				info.offset =
> -					VFIO_PCI_INDEX_TO_OFFSET(info.index);
> -				info.size = vgpu->region[i].size;
> -				info.flags = vgpu->region[i].flags;
> -
> -				cap_type.type = vgpu->region[i].type;
> -				cap_type.subtype = vgpu->region[i].subtype;
> -
> -				ret = vfio_info_add_capability(&caps,
> -							&cap_type.header,
> -							sizeof(cap_type));
> -				if (ret)
> -					return ret;
> -			}
> -		}
> -
> -		if ((info.flags & VFIO_REGION_INFO_FLAG_CAPS) && sparse) {
> -			switch (cap_type_id) {
> -			case VFIO_REGION_INFO_CAP_SPARSE_MMAP:
> -				ret = vfio_info_add_capability(&caps,
> -					&sparse->header,
> -					struct_size(sparse, areas,
> -						    sparse->nr_areas));
> -				if (ret) {
> -					kfree(sparse);
> -					return ret;
> -				}
> -				break;
> -			default:
> -				kfree(sparse);
> -				return -EINVAL;
> -			}
> -		}
> -
> -		if (caps.size) {
> -			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> -			if (info.argsz < sizeof(info) + caps.size) {
> -				info.argsz = sizeof(info) + caps.size;
> -				info.cap_offset = 0;
> -			} else {
> -				vfio_info_cap_shift(&caps, sizeof(info));
> -				if (copy_to_user((void __user *)arg +
> -						  sizeof(info), caps.buf,
> -						  caps.size)) {
> -					kfree(caps.buf);
> -					kfree(sparse);
> -					return -EFAULT;
> -				}
> -				info.cap_offset = sizeof(info);
> -			}
> -
> -			kfree(caps.buf);
> -		}
> -
> -		kfree(sparse);
> -		return copy_to_user((void __user *)arg, &info, minsz) ?
> -			-EFAULT : 0;
>  	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>  		struct vfio_irq_info info;
>  
> @@ -1475,6 +1473,7 @@ static const struct vfio_device_ops intel_vgpu_dev_ops = {
>  	.write		= intel_vgpu_write,
>  	.mmap		= intel_vgpu_mmap,
>  	.ioctl		= intel_vgpu_ioctl,
> +	.get_region_info = intel_vgpu_get_region_info,
>  	.dma_unmap	= intel_vgpu_dma_unmap,
>  	.bind_iommufd	= vfio_iommufd_emulated_bind,
>  	.unbind_iommufd = vfio_iommufd_emulated_unbind,

-- 
Jani Nikula, Intel

