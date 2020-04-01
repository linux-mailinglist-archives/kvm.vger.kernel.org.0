Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8600819AC95
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 15:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbgDANSv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 1 Apr 2020 09:18:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:6360 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732505AbgDANSv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 09:18:51 -0400
IronPort-SDR: Ko4c0J3WvkfccBfFP5FKY2xFA1NN05AkwGNSdQ4d0U63cUOMinLYDkJ0gPwCu5MtjYHt36pmob
 0EmGO0WHgYmw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 06:18:50 -0700
IronPort-SDR: NlmaAM1IFqE30CHZgLjmu1rUYlz4gOe+/atm98Ukg60AhhDyIgOppXrCahC+2ea3cVIDYRhc8d
 noDGCui3FiAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,331,1580803200"; 
   d="scan'208";a="395975429"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga004.jf.intel.com with ESMTP; 01 Apr 2020 06:18:50 -0700
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 06:18:49 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 06:18:49 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.89]) with mapi id 14.03.0439.000;
 Wed, 1 Apr 2020 21:18:46 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Eric Auger <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
Thread-Topic: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
Thread-Index: AQHV/tNxynbYpV5vT0iLn8klxfIfp6hkUe3A
Date:   Wed, 1 Apr 2020 13:18:46 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21DBDF@SHSMSX104.ccr.corp.intel.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-5-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-5-eric.auger@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

Just curious about your plan on this patch, I just heard my colleague would like
to reference the functions from this patch in his dsa driver work.

Regards,
Yi Liu

> From: Eric Auger <eric.auger@redhat.com>
> Sent: Saturday, March 21, 2020 12:19 AM
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; iommu@lists.linux-
> foundation.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> kvmarm@lists.cs.columbia.edu; joro@8bytes.org; alex.williamson@redhat.com;
> jacob.jun.pan@linux.intel.com; Liu, Yi L <yi.l.liu@intel.com>; jean-
> philippe.brucker@arm.com; will.deacon@arm.com; robin.murphy@arm.com
> Cc: marc.zyngier@arm.com; peter.maydell@linaro.org; zhangfei.gao@gmail.com
> Subject: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region type
> 
> Add a new specific DMA_FAULT region aiming to exposed nested mode
> translation faults.
> 
> The region has a ring buffer that contains the actual fault
> records plus a header allowing to handle it (tail/head indices,
> max capacity, entry size). At the moment the region is dimensionned
> for 512 fault records.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v8 -> v9:
> - Use a single region instead of a prod/cons region
> 
> v4 -> v5
> - check cons is not null in vfio_pci_check_cons_fault
> 
> v3 -> v4:
> - use 2 separate regions, respectively in read and write modes
> - add the version capability
> ---
>  drivers/vfio/pci/vfio_pci.c         | 68 +++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h | 10 +++++
>  drivers/vfio/pci/vfio_pci_rdwr.c    | 45 +++++++++++++++++++
>  include/uapi/linux/vfio.h           | 35 +++++++++++++++
>  4 files changed, 158 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 379a02c36e37..586b89debed5 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -260,6 +260,69 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
> pci_power_t state)
>  	return ret;
>  }
> 
> +static void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
> +				       struct vfio_pci_region *region)
> +{
> +}
> +
> +static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
> +					     struct vfio_pci_region *region,
> +					     struct vfio_info_cap *caps)
> +{
> +	struct vfio_region_info_cap_fault cap = {
> +		.header.id = VFIO_REGION_INFO_CAP_DMA_FAULT,
> +		.header.version = 1,
> +		.version = 1,
> +	};
> +	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
> +}
> +
> +static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
> +	.rw		= vfio_pci_dma_fault_rw,
> +	.release	= vfio_pci_dma_fault_release,
> +	.add_capability = vfio_pci_dma_fault_add_capability,
> +};
> +
> +#define DMA_FAULT_RING_LENGTH 512
> +
> +static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
> +{
> +	struct vfio_region_dma_fault *header;
> +	size_t size;
> +	int ret;
> +
> +	mutex_init(&vdev->fault_queue_lock);
> +
> +	/*
> +	 * We provision 1 page for the header and space for
> +	 * DMA_FAULT_RING_LENGTH fault records in the ring buffer.
> +	 */
> +	size = ALIGN(sizeof(struct iommu_fault) *
> +		     DMA_FAULT_RING_LENGTH, PAGE_SIZE) + PAGE_SIZE;
> +
> +	vdev->fault_pages = kzalloc(size, GFP_KERNEL);
> +	if (!vdev->fault_pages)
> +		return -ENOMEM;
> +
> +	ret = vfio_pci_register_dev_region(vdev,
> +		VFIO_REGION_TYPE_NESTED,
> +		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT,
> +		&vfio_pci_dma_fault_regops, size,
> +		VFIO_REGION_INFO_FLAG_READ |
> VFIO_REGION_INFO_FLAG_WRITE,
> +		vdev->fault_pages);
> +	if (ret)
> +		goto out;
> +
> +	header = (struct vfio_region_dma_fault *)vdev->fault_pages;
> +	header->entry_size = sizeof(struct iommu_fault);
> +	header->nb_entries = DMA_FAULT_RING_LENGTH;
> +	header->offset = sizeof(struct vfio_region_dma_fault);
> +	return 0;
> +out:
> +	kfree(vdev->fault_pages);
> +	return ret;
> +}
> +
>  static int vfio_pci_enable(struct vfio_pci_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> @@ -358,6 +421,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>  		}
>  	}
> 
> +	ret = vfio_pci_init_dma_fault_region(vdev);
> +	if (ret)
> +		goto disable_exit;
> +
>  	vfio_pci_probe_mmaps(vdev);
> 
>  	return 0;
> @@ -1383,6 +1450,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
> 
>  	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
>  	kfree(vdev->region);
> +	kfree(vdev->fault_pages);
>  	mutex_destroy(&vdev->ioeventfds_lock);
> 
>  	if (!disable_idle_d3)
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 8a2c7607d513..a392f50e3a99 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -119,6 +119,8 @@ struct vfio_pci_device {
>  	int			ioeventfds_nr;
>  	struct eventfd_ctx	*err_trigger;
>  	struct eventfd_ctx	*req_trigger;
> +	u8			*fault_pages;
> +	struct mutex		fault_queue_lock;
>  	struct list_head	dummy_resources_list;
>  	struct mutex		ioeventfds_lock;
>  	struct list_head	ioeventfds_list;
> @@ -150,6 +152,14 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device
> *vdev, char __user *buf,
>  extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
>  			       uint64_t data, int count, int fd);
> 
> +struct vfio_pci_fault_abi {
> +	u32 entry_size;
> +};
> +
> +extern size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev,
> +				    char __user *buf, size_t count,
> +				    loff_t *ppos, bool iswrite);
> +
>  extern int vfio_pci_init_perm_bits(void);
>  extern void vfio_pci_uninit_perm_bits(void);
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index a87992892a9f..4004ab8cad0e 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -274,6 +274,51 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char
> __user *buf,
>  	return done;
>  }
> 
> +size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev, char __user *buf,
> +			     size_t count, loff_t *ppos, bool iswrite)
> +{
> +	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) -
> VFIO_PCI_NUM_REGIONS;
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	void *base = vdev->region[i].data;
> +	int ret = -EFAULT;
> +
> +	if (pos >= vdev->region[i].size)
> +		return -EINVAL;
> +
> +	count = min(count, (size_t)(vdev->region[i].size - pos));
> +
> +	mutex_lock(&vdev->fault_queue_lock);
> +
> +	if (iswrite) {
> +		struct vfio_region_dma_fault *header =
> +			(struct vfio_region_dma_fault *)base;
> +		u32 new_tail;
> +
> +		if (pos != 0 || count != 4) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +
> +		if (copy_from_user((void *)&new_tail, buf, count))
> +			goto unlock;
> +
> +		if (new_tail > header->nb_entries) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +		header->tail = new_tail;
> +	} else {
> +		if (copy_to_user(buf, base + pos, count))
> +			goto unlock;
> +	}
> +	*ppos += count;
> +	ret = count;
> +unlock:
> +	mutex_unlock(&vdev->fault_queue_lock);
> +	return ret;
> +}
> +
> +
>  static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
>  {
>  	struct vfio_pci_ioeventfd *ioeventfd = opaque;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9f2429eb1958..40d770f80e3d 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -330,6 +330,9 @@ struct vfio_region_info_cap_type {
>  /* sub-types for VFIO_REGION_TYPE_GFX */
>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
> 
> +#define VFIO_REGION_TYPE_NESTED			(2)
> +#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
> +
>  /**
>   * struct vfio_region_gfx_edid - EDID region layout.
>   *
> @@ -708,6 +711,38 @@ struct vfio_device_ioeventfd {
> 
>  #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
> 
> +
> +/*
> + * Capability exposed by the DMA fault region
> + * @version: ABI version
> + */
> +#define VFIO_REGION_INFO_CAP_DMA_FAULT	6
> +
> +struct vfio_region_info_cap_fault {
> +	struct vfio_info_cap_header header;
> +	__u32 version;
> +};
> +
> +/*
> + * DMA Fault Region Layout
> + * @tail: index relative to the start of the ring buffer at which the
> + *        consumer finds the next item in the buffer
> + * @entry_size: fault ring buffer entry size in bytes
> + * @nb_entries: max capacity of the fault ring buffer
> + * @offset: ring buffer offset relative to the start of the region
> + * @head: index relative to the start of the ring buffer at which the
> + *        producer (kernel) inserts items into the buffers
> + */
> +struct vfio_region_dma_fault {
> +	/* Write-Only */
> +	__u32   tail;
> +	/* Read-Only */
> +	__u32   entry_size;
> +	__u32	nb_entries;
> +	__u32	offset;
> +	__u32   head;
> +};
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
> 
>  /**
> --
> 2.20.1

