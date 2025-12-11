Return-Path: <kvm+bounces-65784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F8DFCB66BC
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 17:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E8E030102B7
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 16:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B685531353E;
	Thu, 11 Dec 2025 16:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sfx7CJ8R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BDE29BDB3;
	Thu, 11 Dec 2025 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765469177; cv=none; b=ggzeV+tA3Vx4UMxMFdLlQM/PJ2v7oxhn5yLmHl9XnKVA5vUOhp29iJzPnViIfpGfUriJSCqaP0rniokod/PmAzDd6dhgZ1lt3WifNoOvsuvTgPZTLFFtEjs1ujhQ4jQW3tQkGCyP/7qc2j8e0aGqBTlWDm+XHbJsMS72UHW2Kis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765469177; c=relaxed/simple;
	bh=CFQLU0VJkAgP0hpz642KnBRdfJD0rE2rWXLTg+VxLj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s8dK+/gjBXwdF8aZkk5zYP3kO2FSFhAHkgrXK0SohWfNEH4p1clMWhQxGcEA3t3aLYR0gqjbX7LGPtNeTbpbjFg0IJiJmgluy99AuSnEzcJytDMtSzwraOSqyRY7sH5dz5+QbUvxAgri6TihzVsQqE3pY2H3/7TZCH3YCfGmCE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sfx7CJ8R; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765469176; x=1797005176;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CFQLU0VJkAgP0hpz642KnBRdfJD0rE2rWXLTg+VxLj0=;
  b=Sfx7CJ8RP0k6bItZ9SqHczsN/kQjhkUdLVyZFIJW23RSzeHmYLluEor9
   7mL0q6DhqHhNDI3bCQf5BMFOBJWdMQL/sBC/sAZYeY5GTfUYEhLpaEy0O
   /Zvc15Z/TGktbxX2zblydy3YYbh5PTbyzfJ3xOrIe7803CzLDQuqLwdB1
   JDTgXdcJkpo8CIWJVHDv50fKNJGSMjEk3g2FPNRuNkVVOcHRXTm7YNOJu
   sFmAMGBnnqLSY+nQl74n7Y7xK282HnKydx57QW/o6E19Ww8OKAVVQcLO4
   osevq7feKE4yoHjuTDaqP0mf+TBKxyjvRs3N2s/LB+8UJK84qeeXb0myK
   Q==;
X-CSE-ConnectionGUID: 42MAKFzeS5qRzZgcIq3L/A==
X-CSE-MsgGUID: P7yfBNs7T9+e9XTDU7WUJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="71076418"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="71076418"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 08:06:15 -0800
X-CSE-ConnectionGUID: 92acwOcRQcu1wjKKV73g1Q==
X-CSE-MsgGUID: 2OYO21ACQueLPQTXRdhzfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="227479162"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.218]) ([10.125.109.218])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 08:06:14 -0800
Message-ID: <9f2d5327-6d23-4d4a-aede-f6161a59f086@intel.com>
Date: Thu, 11 Dec 2025 09:06:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 07/15] vfio/cxl: expose CXL region to the userspace via a
 new VFIO device region
To: mhonap@nvidia.com, aniketa@nvidia.com, ankita@nvidia.com,
 alwilliamson@nvidia.com, vsethi@nvidia.com, jgg@nvidia.com,
 mochs@nvidia.com, skolothumtho@nvidia.com, alejandro.lucero-palau@amd.com,
 dave@stgolabs.net, jonathan.cameron@huawei.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, dan.j.williams@intel.com,
 jgg@ziepe.ca, yishaih@nvidia.com, kevin.tian@intel.com
Cc: cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
 zhiw@nvidia.com, kjaju@nvidia.com, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, kvm@vger.kernel.org
References: <20251209165019.2643142-1-mhonap@nvidia.com>
 <20251209165019.2643142-8-mhonap@nvidia.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20251209165019.2643142-8-mhonap@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/25 9:50 AM, mhonap@nvidia.com wrote:
> From: Manish Honap <mhonap@nvidia.com>
> 
> To directly access the device memory, a CXL region is required. Creating
> a CXL region requires to configure HDM decoders on the path to map the
> access of HPA level by level and evetually hit the DPA in the CXL
> topology.
> 
> For the userspace, e.g. QEMU, to access the CXL region, the region is
> required to be exposed via VFIO interfaces.
> 
> Introduce a new VFIO device region and region ops to expose the created
> CXL region when initialize the device in the vfio-cxl-core. Introduce a
> new sub region type for the userspace to identify a CXL region.
> 
> Co-developed-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Manish Honap <mhonap@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_cxl_core.c | 122 +++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_core.c |   3 +-
>  include/linux/vfio_pci_core.h    |   5 ++
>  include/uapi/linux/vfio.h        |   4 +
>  4 files changed, 133 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
> index cf53720c0cb7..35d95de47fa8 100644
> --- a/drivers/vfio/pci/vfio_cxl_core.c
> +++ b/drivers/vfio/pci/vfio_cxl_core.c
> @@ -231,6 +231,128 @@ void vfio_cxl_core_destroy_cxl_region(struct vfio_cxl_core_device *cxl)
>  }
>  EXPORT_SYMBOL_GPL(vfio_cxl_core_destroy_cxl_region);
>  
> +static int vfio_cxl_region_mmap(struct vfio_pci_core_device *pci,
> +				struct vfio_pci_region *region,
> +				struct vm_area_struct *vma)
> +{
> +	struct vfio_cxl_region *cxl_region = region->data;
> +	u64 req_len, pgoff, req_start, end;
> +	int ret;
> +
> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_MMAP))
> +		return -EINVAL;
> +
> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_READ) &&
> +	    (vma->vm_flags & VM_READ))
> +		return -EPERM;
> +
> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE) &&
> +	    (vma->vm_flags & VM_WRITE))
> +		return -EPERM;
> +
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +
> +	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
> +	    check_add_overflow(PHYS_PFN(cxl_region->addr), pgoff, &req_start) ||
> +	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
> +		return -EOVERFLOW;
> +
> +	if (end > cxl_region->size)
> +		return -EINVAL;
> +
> +	if (cxl_region->noncached)
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
> +
> +	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
> +		     VM_DONTEXPAND | VM_DONTDUMP);
> +
> +	ret = remap_pfn_range(vma, vma->vm_start, req_start,
> +			      req_len, vma->vm_page_prot);
> +	if (ret)
> +		return ret;
> +
> +	vma->vm_pgoff = req_start;
> +
> +	return 0;
> +}
> +
> +static ssize_t vfio_cxl_region_rw(struct vfio_pci_core_device *core_dev,
> +				  char __user *buf, size_t count, loff_t *ppos,
> +				  bool iswrite)
> +{
> +	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
> +	struct vfio_cxl_region *cxl_region = core_dev->region[i].data;
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +
> +	if (!count)
> +		return 0;
> +
> +	return vfio_pci_core_do_io_rw(core_dev, false,
> +				      cxl_region->vaddr,
> +				      (char __user *)buf, pos, count,
> +				      0, 0, iswrite);
> +}
> +
> +static void vfio_cxl_region_release(struct vfio_pci_core_device *vdev,
> +				    struct vfio_pci_region *region)
> +{
> +}
> +
> +static const struct vfio_pci_regops vfio_cxl_regops = {
> +	.rw             = vfio_cxl_region_rw,
> +	.mmap           = vfio_cxl_region_mmap,
> +	.release        = vfio_cxl_region_release,
> +};
> +
> +int vfio_cxl_core_register_cxl_region(struct vfio_cxl_core_device *cxl)
> +{
> +	struct vfio_pci_core_device *pci = &cxl->pci_core;
> +	struct vfio_cxl *cxl_core = cxl->cxl_core;
> +	u32 flags;
> +	int ret;
> +
> +	if (WARN_ON(!cxl_core->region.region || cxl_core->region.vaddr))
> +		return -EEXIST;
> +
> +	cxl_core->region.vaddr = ioremap(cxl_core->region.addr, cxl_core->region.size);
> +	if (!cxl_core->region.addr)

I think you are wanting to check cxl_core->region.vaddr here right?

Also, what is the ioremap'd region for?

DJ

> +		return -EFAULT;
> +
> +	flags = VFIO_REGION_INFO_FLAG_READ |
> +		VFIO_REGION_INFO_FLAG_WRITE |
> +		VFIO_REGION_INFO_FLAG_MMAP;
> +
> +	ret = vfio_pci_core_register_dev_region(pci,
> +						PCI_VENDOR_ID_CXL |
> +						VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
> +						VFIO_REGION_SUBTYPE_CXL,
> +						&vfio_cxl_regops,
> +						cxl_core->region.size, flags,
> +						&cxl_core->region);
> +	if (ret) {
> +		iounmap(cxl_core->region.vaddr);
> +		cxl_core->region.vaddr = NULL;
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_cxl_core_register_cxl_region);
> +
> +void vfio_cxl_core_unregister_cxl_region(struct vfio_cxl_core_device *cxl)
> +{
> +	struct vfio_cxl *cxl_core = cxl->cxl_core;
> +
> +	if (WARN_ON(!cxl_core->region.region || !cxl_core->region.vaddr))
> +		return;
> +
> +	iounmap(cxl_core->region.vaddr);
> +	cxl_core->region.vaddr = NULL;
> +}
> +EXPORT_SYMBOL_GPL(vfio_cxl_core_unregister_cxl_region);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR(DRIVER_AUTHOR);
>  MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 7dcf5439dedc..c0695b5db66d 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1698,12 +1698,13 @@ static vm_fault_t vfio_pci_mmap_page_fault(struct vm_fault *vmf)
>  	return vfio_pci_mmap_huge_fault(vmf, 0);
>  }
>  
> -static const struct vm_operations_struct vfio_pci_mmap_ops = {
> +const struct vm_operations_struct vfio_pci_mmap_ops = {
>  	.fault = vfio_pci_mmap_page_fault,
>  #ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
>  	.huge_fault = vfio_pci_mmap_huge_fault,
>  #endif
>  };
> +EXPORT_SYMBOL_GPL(vfio_pci_mmap_ops);
>  
>  int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
>  {
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index a343b91d2580..3474835f5d65 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -102,6 +102,7 @@ struct vfio_cxl_region {
>  	struct cxl_region *region;
>  	u64 size;
>  	u64 addr;
> +	void *vaddr;
>  	bool noncached;
>  };
>  
> @@ -203,6 +204,8 @@ vfio_pci_core_to_cxl(struct vfio_pci_core_device *pci)
>  	return container_of(pci, struct vfio_cxl_core_device, pci_core);
>  }
>  
> +extern const struct vm_operations_struct vfio_pci_mmap_ops;
> +
>  int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
>  			 struct vfio_cxl_dev_info *info);
>  void vfio_cxl_core_finish_enable(struct vfio_cxl_core_device *cxl);
> @@ -210,5 +213,7 @@ void vfio_cxl_core_disable(struct vfio_cxl_core_device *cxl);
>  void vfio_cxl_core_close_device(struct vfio_device *vdev);
>  int vfio_cxl_core_create_cxl_region(struct vfio_cxl_core_device *cxl, u64 size);
>  void vfio_cxl_core_destroy_cxl_region(struct vfio_cxl_core_device *cxl);
> +int vfio_cxl_core_register_cxl_region(struct vfio_cxl_core_device *cxl);
> +void vfio_cxl_core_unregister_cxl_region(struct vfio_cxl_core_device *cxl);
>  
>  #endif /* VFIO_PCI_CORE_H */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 75100bf009ba..95be987d2ed5 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -372,6 +372,10 @@ struct vfio_region_info_cap_type {
>  /* sub-types for VFIO_REGION_TYPE_GFX */
>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>  
> +/* 1e98 vendor PCI sub-types */
> +/* sub-type for VFIO CXL region */
> +#define VFIO_REGION_SUBTYPE_CXL                 (1)
> +
>  /**
>   * struct vfio_region_gfx_edid - EDID region layout.
>   *


