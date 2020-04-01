Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E8519ACEA
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 15:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbgDANbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 09:31:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48466 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732645AbgDANbV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 09:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585747880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=khy6escS/gMZ60xgHqFZm3yT0ljG8MitkL6uMsVyZrM=;
        b=BiaU3bOkcU5eOw1GnitfqwOSTuI5h8nyoWMpIpDkgM40BOosImt4KEo90PNXjWQmtcp7u1
        uPifWq6EKc/AdHsPziwMzLzyeAZM6TtFSnoXntezzl6Zizc93fuCniP6hV1dY3veGDRK+y
        BteoY2p/5hJnnpC0jiUWsYaA8UWx+vM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-8HNLeJx6OlOIfFbO4nsd0g-1; Wed, 01 Apr 2020 09:31:16 -0400
X-MC-Unique: 8HNLeJx6OlOIfFbO4nsd0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C20B3DB30;
        Wed,  1 Apr 2020 13:31:13 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 85DE619C70;
        Wed,  1 Apr 2020 13:31:06 +0000 (UTC)
Subject: Re: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
Cc:     "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-5-eric.auger@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21DBDF@SHSMSX104.ccr.corp.intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <893039be-265a-8c70-8e48-74122d9857de@redhat.com>
Date:   Wed, 1 Apr 2020 15:31:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A21DBDF@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/1/20 3:18 PM, Liu, Yi L wrote:
> Hi Eric,
> 
> Just curious about your plan on this patch, I just heard my colleague would like
> to reference the functions from this patch in his dsa driver work.

Well I intend to respin until somebody tells me it is completely vain or
dead follows. Joking aside, feel free to embed it in any series it would
be beneficial to, just please cc me in case code diverges.

Thanks

Eric
> 
> Regards,
> Yi Liu
> 
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: Saturday, March 21, 2020 12:19 AM
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; iommu@lists.linux-
>> foundation.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
>> kvmarm@lists.cs.columbia.edu; joro@8bytes.org; alex.williamson@redhat.com;
>> jacob.jun.pan@linux.intel.com; Liu, Yi L <yi.l.liu@intel.com>; jean-
>> philippe.brucker@arm.com; will.deacon@arm.com; robin.murphy@arm.com
>> Cc: marc.zyngier@arm.com; peter.maydell@linaro.org; zhangfei.gao@gmail.com
>> Subject: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region type
>>
>> Add a new specific DMA_FAULT region aiming to exposed nested mode
>> translation faults.
>>
>> The region has a ring buffer that contains the actual fault
>> records plus a header allowing to handle it (tail/head indices,
>> max capacity, entry size). At the moment the region is dimensionned
>> for 512 fault records.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v8 -> v9:
>> - Use a single region instead of a prod/cons region
>>
>> v4 -> v5
>> - check cons is not null in vfio_pci_check_cons_fault
>>
>> v3 -> v4:
>> - use 2 separate regions, respectively in read and write modes
>> - add the version capability
>> ---
>>  drivers/vfio/pci/vfio_pci.c         | 68 +++++++++++++++++++++++++++++
>>  drivers/vfio/pci/vfio_pci_private.h | 10 +++++
>>  drivers/vfio/pci/vfio_pci_rdwr.c    | 45 +++++++++++++++++++
>>  include/uapi/linux/vfio.h           | 35 +++++++++++++++
>>  4 files changed, 158 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index 379a02c36e37..586b89debed5 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -260,6 +260,69 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
>> pci_power_t state)
>>  	return ret;
>>  }
>>
>> +static void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
>> +				       struct vfio_pci_region *region)
>> +{
>> +}
>> +
>> +static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
>> +					     struct vfio_pci_region *region,
>> +					     struct vfio_info_cap *caps)
>> +{
>> +	struct vfio_region_info_cap_fault cap = {
>> +		.header.id = VFIO_REGION_INFO_CAP_DMA_FAULT,
>> +		.header.version = 1,
>> +		.version = 1,
>> +	};
>> +	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
>> +}
>> +
>> +static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
>> +	.rw		= vfio_pci_dma_fault_rw,
>> +	.release	= vfio_pci_dma_fault_release,
>> +	.add_capability = vfio_pci_dma_fault_add_capability,
>> +};
>> +
>> +#define DMA_FAULT_RING_LENGTH 512
>> +
>> +static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
>> +{
>> +	struct vfio_region_dma_fault *header;
>> +	size_t size;
>> +	int ret;
>> +
>> +	mutex_init(&vdev->fault_queue_lock);
>> +
>> +	/*
>> +	 * We provision 1 page for the header and space for
>> +	 * DMA_FAULT_RING_LENGTH fault records in the ring buffer.
>> +	 */
>> +	size = ALIGN(sizeof(struct iommu_fault) *
>> +		     DMA_FAULT_RING_LENGTH, PAGE_SIZE) + PAGE_SIZE;
>> +
>> +	vdev->fault_pages = kzalloc(size, GFP_KERNEL);
>> +	if (!vdev->fault_pages)
>> +		return -ENOMEM;
>> +
>> +	ret = vfio_pci_register_dev_region(vdev,
>> +		VFIO_REGION_TYPE_NESTED,
>> +		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT,
>> +		&vfio_pci_dma_fault_regops, size,
>> +		VFIO_REGION_INFO_FLAG_READ |
>> VFIO_REGION_INFO_FLAG_WRITE,
>> +		vdev->fault_pages);
>> +	if (ret)
>> +		goto out;
>> +
>> +	header = (struct vfio_region_dma_fault *)vdev->fault_pages;
>> +	header->entry_size = sizeof(struct iommu_fault);
>> +	header->nb_entries = DMA_FAULT_RING_LENGTH;
>> +	header->offset = sizeof(struct vfio_region_dma_fault);
>> +	return 0;
>> +out:
>> +	kfree(vdev->fault_pages);
>> +	return ret;
>> +}
>> +
>>  static int vfio_pci_enable(struct vfio_pci_device *vdev)
>>  {
>>  	struct pci_dev *pdev = vdev->pdev;
>> @@ -358,6 +421,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>>  		}
>>  	}
>>
>> +	ret = vfio_pci_init_dma_fault_region(vdev);
>> +	if (ret)
>> +		goto disable_exit;
>> +
>>  	vfio_pci_probe_mmaps(vdev);
>>
>>  	return 0;
>> @@ -1383,6 +1450,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
>>
>>  	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
>>  	kfree(vdev->region);
>> +	kfree(vdev->fault_pages);
>>  	mutex_destroy(&vdev->ioeventfds_lock);
>>
>>  	if (!disable_idle_d3)
>> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
>> index 8a2c7607d513..a392f50e3a99 100644
>> --- a/drivers/vfio/pci/vfio_pci_private.h
>> +++ b/drivers/vfio/pci/vfio_pci_private.h
>> @@ -119,6 +119,8 @@ struct vfio_pci_device {
>>  	int			ioeventfds_nr;
>>  	struct eventfd_ctx	*err_trigger;
>>  	struct eventfd_ctx	*req_trigger;
>> +	u8			*fault_pages;
>> +	struct mutex		fault_queue_lock;
>>  	struct list_head	dummy_resources_list;
>>  	struct mutex		ioeventfds_lock;
>>  	struct list_head	ioeventfds_list;
>> @@ -150,6 +152,14 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device
>> *vdev, char __user *buf,
>>  extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
>>  			       uint64_t data, int count, int fd);
>>
>> +struct vfio_pci_fault_abi {
>> +	u32 entry_size;
>> +};
>> +
>> +extern size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev,
>> +				    char __user *buf, size_t count,
>> +				    loff_t *ppos, bool iswrite);
>> +
>>  extern int vfio_pci_init_perm_bits(void);
>>  extern void vfio_pci_uninit_perm_bits(void);
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
>> index a87992892a9f..4004ab8cad0e 100644
>> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
>> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
>> @@ -274,6 +274,51 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char
>> __user *buf,
>>  	return done;
>>  }
>>
>> +size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev, char __user *buf,
>> +			     size_t count, loff_t *ppos, bool iswrite)
>> +{
>> +	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) -
>> VFIO_PCI_NUM_REGIONS;
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	void *base = vdev->region[i].data;
>> +	int ret = -EFAULT;
>> +
>> +	if (pos >= vdev->region[i].size)
>> +		return -EINVAL;
>> +
>> +	count = min(count, (size_t)(vdev->region[i].size - pos));
>> +
>> +	mutex_lock(&vdev->fault_queue_lock);
>> +
>> +	if (iswrite) {
>> +		struct vfio_region_dma_fault *header =
>> +			(struct vfio_region_dma_fault *)base;
>> +		u32 new_tail;
>> +
>> +		if (pos != 0 || count != 4) {
>> +			ret = -EINVAL;
>> +			goto unlock;
>> +		}
>> +
>> +		if (copy_from_user((void *)&new_tail, buf, count))
>> +			goto unlock;
>> +
>> +		if (new_tail > header->nb_entries) {
>> +			ret = -EINVAL;
>> +			goto unlock;
>> +		}
>> +		header->tail = new_tail;
>> +	} else {
>> +		if (copy_to_user(buf, base + pos, count))
>> +			goto unlock;
>> +	}
>> +	*ppos += count;
>> +	ret = count;
>> +unlock:
>> +	mutex_unlock(&vdev->fault_queue_lock);
>> +	return ret;
>> +}
>> +
>> +
>>  static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
>>  {
>>  	struct vfio_pci_ioeventfd *ioeventfd = opaque;
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 9f2429eb1958..40d770f80e3d 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -330,6 +330,9 @@ struct vfio_region_info_cap_type {
>>  /* sub-types for VFIO_REGION_TYPE_GFX */
>>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>>
>> +#define VFIO_REGION_TYPE_NESTED			(2)
>> +#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
>> +
>>  /**
>>   * struct vfio_region_gfx_edid - EDID region layout.
>>   *
>> @@ -708,6 +711,38 @@ struct vfio_device_ioeventfd {
>>
>>  #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
>>
>> +
>> +/*
>> + * Capability exposed by the DMA fault region
>> + * @version: ABI version
>> + */
>> +#define VFIO_REGION_INFO_CAP_DMA_FAULT	6
>> +
>> +struct vfio_region_info_cap_fault {
>> +	struct vfio_info_cap_header header;
>> +	__u32 version;
>> +};
>> +
>> +/*
>> + * DMA Fault Region Layout
>> + * @tail: index relative to the start of the ring buffer at which the
>> + *        consumer finds the next item in the buffer
>> + * @entry_size: fault ring buffer entry size in bytes
>> + * @nb_entries: max capacity of the fault ring buffer
>> + * @offset: ring buffer offset relative to the start of the region
>> + * @head: index relative to the start of the ring buffer at which the
>> + *        producer (kernel) inserts items into the buffers
>> + */
>> +struct vfio_region_dma_fault {
>> +	/* Write-Only */
>> +	__u32   tail;
>> +	/* Read-Only */
>> +	__u32   entry_size;
>> +	__u32	nb_entries;
>> +	__u32	offset;
>> +	__u32   head;
>> +};
>> +
>>  /* -------- API for Type1 VFIO IOMMU -------- */
>>
>>  /**
>> --
>> 2.20.1
> 

