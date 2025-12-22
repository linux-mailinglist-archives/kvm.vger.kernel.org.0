Return-Path: <kvm+bounces-66475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6DFCD64FE
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 15:03:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B447C3094965
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 14:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67E32773CC;
	Mon, 22 Dec 2025 14:00:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302DE25524C;
	Mon, 22 Dec 2025 14:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766412020; cv=none; b=rIHjrlJ6Fdpod+JuETErwpignTDn3iNfRH0nyzVvPSl02BGXUapHLBBF0+sI2OCVSEWNA21gSOfjlkRV9nZow9hJXhmvR3Q0g6E0cnqHxyhqC6by+HNp3fGInglcSleeNjVn5LBjTv3ag8FFuelSJlZcxFi13GVKfCaXcJh6fnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766412020; c=relaxed/simple;
	bh=hl/ccgQkuUt/1nf6hcYW7H5Zz0p+SwakMiIPlKibrI8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=byfLDkGAF7386S0yQXixA0x1hQ0cvPUmfZ8emOiJ3zeCTPziHsdcCK3JeBmIKObGqnRYyx7PAWq+Bc8M1DQOrSZU/dR9U0hMPKYVOrUUiGfl0UbIv40kU8vmedFeldVBdNlblrO7bjwkJKG5MD/WR32U4+UF/Ph1uKbjODSIE9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dZfs5655kzHnGjM;
	Mon, 22 Dec 2025 21:59:37 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id F1E754056A;
	Mon, 22 Dec 2025 22:00:12 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 22 Dec
 2025 14:00:11 +0000
Date: Mon, 22 Dec 2025 14:00:09 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: <mhonap@nvidia.com>
CC: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<kevin.tian@intel.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: Re: [RFC v2 07/15] vfio/cxl: expose CXL region to the userspace via
 a new VFIO device region
Message-ID: <20251222140009.0000298a@huawei.com>
In-Reply-To: <20251209165019.2643142-8-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
	<20251209165019.2643142-8-mhonap@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Tue, 9 Dec 2025 22:20:11 +0530
mhonap@nvidia.com wrote:

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
A few really minor things inline.

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

GENMASK() might be slightly easier to read and makes it really obvious
this is a simple masking operation.

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

buf is already a char __user * so not sure why you'd need a cast here.

> +				      0, 0, iswrite);
> +}



