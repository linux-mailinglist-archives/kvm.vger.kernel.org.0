Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31EF321E93
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhBVR4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:56:12 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11329 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhBVR4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 12:56:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6033f0120001>; Mon, 22 Feb 2021 09:55:30 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 17:55:28 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 17:55:27 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 22 Feb 2021 17:55:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmEawTFPNwOOikfjgd5A4eX2D+a82IsVFjojxVVUgpEjie8sAghFrADSexxrlTPNNQmbTZJ0iOMFJvFQ5c03NHUcMD4TCJxdJXLZUAQM5nuwGA60cTH5F0CYZiPuBS//3U6rwOc2bxAia7kxZxefOtgXRL5tPso5IiC3XRWCG9+SkcyTQ0zJXwmj2owzayq5Y7o2+2lp2Yg3dFkT8288yPkaaC1hadPpfk/VoRnvEQAY4Zb8PLkoDB4bLh0LTfUTWfZ/zmyoc8Ifd6WgOqjDMKA/FqCuhGWkahI6tz8DOxOmQCNJeZ+GH2Or0eK9X7mSb3HouTYD8WuMuDPX8s5nOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxW56EmplwlaPPUdRNeEHUkMVOPoRIxsUQLO8MzsIyA=;
 b=MtU2NNWtZsYQxQQMM54k0vxn1uzPlsFxAjUaMxJcywrTVlcqyZJP2bvcDeD7VFWcO6WzknslOvtVb3+IzUeDyh4Xu6EqYHFSX4dXqOI1ZJl4IxPyhYgvk2CjYNqnxqqlmK4CtH6HK6/K+c/IJ1isZMkpLi9IKJyagGf/p4IU2nwEVdyBE0fO8AuPar9awIjV6sS7pxqL0/FVq2Ib8KZRgYz1IBQ7zgtxVsutxcRdzQvFbJQYR4i1bnqwnZhaYOQieI4mHXCmS15oxAP0vgCw1kxXDh8Wpbr5ejhinbr6uJNabTcJIlPXNnkmAkzdOtlka154IgUxEOVCZZdXPGsW8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3594.namprd12.prod.outlook.com (2603:10b6:5:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Mon, 22 Feb
 2021 17:55:25 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.045; Mon, 22 Feb 2021
 17:55:25 +0000
Date:   Mon, 22 Feb 2021 13:55:23 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 10/10] vfio/type1: Register device notifier
Message-ID: <20210222175523.GQ4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401275279.16443.6350471385325897377.stgit@gimli.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161401275279.16443.6350471385325897377.stgit@gimli.home>
X-ClientProxiedBy: BL1PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:208:256::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0016.namprd13.prod.outlook.com (2603:10b6:208:256::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.9 via Frontend Transport; Mon, 22 Feb 2021 17:55:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEFQa-00ETB7-0X; Mon, 22 Feb 2021 13:55:24 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614016530; bh=qxW56EmplwlaPPUdRNeEHUkMVOPoRIxsUQLO8MzsIyA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=CGXQcccrbOS9ZhylsHR9avGGZgxNX9jt5LSUhdCc8PWm/WisU7m6lK8bZhSPIGznv
         lTTLktjV4DYB8J/vShn09G6ZP+T4pNGBUODpvpKlR+ekJywxQafAxsRKgvmvhXRUuk
         tYMgHzESq812241l0vtWi/fgfEVSpLzA1mYiXZHUdIXfsjr8IAc70kjGar5AVdB8Sz
         C7HzRF/7qfeCMcs1ST71PsXkeV+bnpaDunSJ5HtH5u3gFGuPdkIRKUdt40I9jHvIjC
         2SkIEvCA9ToBFBgO8loNroliIeDKqFJA3REAFTZ07oJp8M0U/hnxNN3dB3P5dlCoBy
         xeCP3b/6bbr+w==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 09:52:32AM -0700, Alex Williamson wrote:
> Introduce a new default strict MMIO mapping mode where the vma for
> a VM_PFNMAP mapping must be backed by a vfio device.  This allows
> holding a reference to the device and registering a notifier for the
> device, which additionally keeps the device in an IOMMU context for
> the extent of the DMA mapping.  On notification of device release,
> automatically drop the DMA mappings for it.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>  drivers/vfio/vfio_iommu_type1.c |  124 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 123 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index b34ee4b96a4a..2a16257bd5b6 100644
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -61,6 +61,11 @@ module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
>  MODULE_PARM_DESC(dma_entry_limit,
>  		 "Maximum number of user DMA mappings per container (65535).");
>  
> +static bool strict_mmio_maps = true;
> +module_param_named(strict_mmio_maps, strict_mmio_maps, bool, 0644);
> +MODULE_PARM_DESC(strict_mmio_maps,
> +		 "Restrict to safe DMA mappings of device memory (true).");

I think this should be a kconfig, historically we've required kconfig
to opt-in to unsafe things that could violate kernel security. Someone
building a secure boot trusted kernel system should not have an
options for userspace to just turn off protections.

> +/* Req separate object for async removal from notifier vs dropping vfio_dma */
> +struct pfnmap_obj {
> +	struct notifier_block	nb;
> +	struct work_struct	work;
> +	struct vfio_iommu	*iommu;
> +	struct vfio_device	*device;
> +};

So this is basically the dmabuf, I think it would be simple enough to
go in here and change it down the road if someone had interest.

> +static void unregister_device_bg(struct work_struct *work)
> +{
> +	struct pfnmap_obj *pfnmap = container_of(work, struct pfnmap_obj, work);
> +
> +	vfio_device_unregister_notifier(pfnmap->device, &pfnmap->nb);
> +	vfio_device_put(pfnmap->device);

The device_put keeps the device from becoming unregistered, but what
happens during the hot reset case? Is this what the cover letter
was talking about? CPU access is revoked but P2P is still possible?

> +static int vfio_device_nb_cb(struct notifier_block *nb,
> +			     unsigned long action, void *unused)
> +{
> +	struct pfnmap_obj *pfnmap = container_of(nb, struct pfnmap_obj, nb);
> +
> +	switch (action) {
> +	case VFIO_DEVICE_RELEASE:
> +	{
> +		struct vfio_dma *dma, *dma_last = NULL;
> +		int retries = 0;
> +again:
> +		mutex_lock(&pfnmap->iommu->lock);
> +		dma = pfnmap_find_dma(pfnmap);

Feels a bit strange that the vfio_dma isn't linked to the pfnmap_obj
instead of searching the entire list?

> @@ -549,8 +625,48 @@ static int vaddr_get_pfn(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  		if (ret == -EAGAIN)
>  			goto retry;

I'd prefer this was written a bit differently, I would like it very
much if this doesn't mis-use follow_pte() by returning pfn outside
the lock.

vaddr_get_bar_pfn(..)
{
        vma = find_vma_intersection(mm, vaddr, vaddr + 1);
	if (!vma)
           return -ENOENT;
        if ((vma->vm_flags & VM_DENYWRITE) && (prot & PROT_WRITE)) // Check me
           return -EFAULT;
        device = vfio_device_get_from_vma(vma);
	if (!device)
           return -ENOENT;

	/*
         * Now do the same as vfio_pci_mmap_fault() - the vm_pgoff must
	 * be the physical pfn when using this mechanism. Delete follow_pte entirely()
         */
        pfn = (vaddr - vma->vm_start)/PAGE_SIZE + vma->vm_pgoff
	
        /* de-dup device and record that we are using device's pages in the
	   pfnmap */
        ...
}

This would be significantly better if it could do whole ranges instead
of page at a time.

Jason
