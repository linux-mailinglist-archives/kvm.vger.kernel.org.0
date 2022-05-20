Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FD452EDA0
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349754AbiETN5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236833AbiETN5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:57:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10335E142;
        Fri, 20 May 2022 06:57:01 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KDiIHQ014456;
        Fri, 20 May 2022 13:56:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WB7PGOAIGqwn7FUsGf9m55ihhyjYL53r+g9LfYU1XiE=;
 b=pcx8bS+gHba3Ob98vmOsZCgAgw7Gt9WOMooC1U+5OzZx70OnCLDmKGRzqp5bNWXLzDoC
 PlcTon0SGToN4uR9tQYo2uAHkhFlNrtolt9atKx7P5zW0tq30GMX9gTMLg+h6jp/8ITr
 EbSf3XmRgvUD2Bnz3yBBmsn55Tk35X6WDT5MYvmsfm+IAR2TBps7SyhkUeb0XM7qnpoY
 TO19nPSNbaQ3kxSAVSTRq1fbF0BesSTmmdQa+PqRT6CVDc3SlzqVdl93wyLmFoNbk7vK
 GEvcy3eBFFQsPWfSAb0hrODZAZhxzkboYYuc0PVLotOIE4e9ruW9X/7nil0ujD/YtrAQ Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6c4sr9ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 13:56:49 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24KDjcXj020813;
        Fri, 20 May 2022 13:56:48 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6c4sr9an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 13:56:48 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24KDqVsJ022845;
        Fri, 20 May 2022 13:56:47 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 3g3r2fkn48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 13:56:47 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24KDukVr5571156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 13:56:46 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A269CB206A;
        Fri, 20 May 2022 13:56:46 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C381FB2065;
        Fri, 20 May 2022 13:56:45 +0000 (GMT)
Received: from [9.160.37.241] (unknown [9.160.37.241])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 20 May 2022 13:56:45 +0000 (GMT)
Message-ID: <8b6db781-9d4e-4d64-04fa-94e45dbf8b22@linux.ibm.com>
Date:   Fri, 20 May 2022 09:56:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, jgg@nvidia.com,
        alex.williamson@redhat.com
Cc:     cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
 <20220519183311.582380-2-mjrosato@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220519183311.582380-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XQOMaXwfHzdiZWgYc9s7JYi0JZnUa4mD
X-Proofpoint-GUID: cZUs5C22mGeaE8UZyMeTa0Lr5Q1Lx03B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_04,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200096
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/19/22 2:33 PM, Matthew Rosato wrote:
> Rather than relying on a notifier for associating the KVM with
> the group, let's assume that the association has already been
> made prior to device_open.  The first time a device is opened
> associate the group KVM with the device.
>
> This fixes a user-triggerable oops in GVT.
>
> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   drivers/gpu/drm/i915/gvt/gtt.c        |  4 +-
>   drivers/gpu/drm/i915/gvt/gvt.h        |  3 -
>   drivers/gpu/drm/i915/gvt/kvmgt.c      | 82 ++++++--------------------
>   drivers/s390/crypto/vfio_ap_ops.c     | 35 ++---------
>   drivers/s390/crypto/vfio_ap_private.h |  3 -
>   drivers/vfio/vfio.c                   | 83 ++++++++++-----------------
>   include/linux/vfio.h                  |  6 +-
>   7 files changed, 57 insertions(+), 159 deletions(-)
>
>
>   
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e8914024f5b1..a7d2a95796d3 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1284,25 +1284,6 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>   	}
>   }
>   
> -static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> -				       unsigned long action, void *data)
> -{
> -	int notify_rc = NOTIFY_OK;
> -	struct ap_matrix_mdev *matrix_mdev;
> -
> -	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
> -		return NOTIFY_OK;
> -
> -	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> -
> -	if (!data)
> -		vfio_ap_mdev_unset_kvm(matrix_mdev);
> -	else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
> -		notify_rc = NOTIFY_DONE;
> -
> -	return notify_rc;
> -}
> -
>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>   {
>   	struct device *dev;
> @@ -1402,11 +1383,10 @@ static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
>   	unsigned long events;
>   	int ret;
>   
> -	matrix_mdev->group_notifier.notifier_call = vfio_ap_mdev_group_notifier;
> -	events = VFIO_GROUP_NOTIFY_SET_KVM;
> +	if (!vdev->kvm)
> +		return -EINVAL;
>   
> -	ret = vfio_register_notifier(vdev, VFIO_GROUP_NOTIFY, &events,
> -				     &matrix_mdev->group_notifier);
> +	ret = vfio_ap_mdev_set_kvm(matrix_mdev, vdev->kvm);
>   	if (ret)
>   		return ret;

I'm sorry I didn't see this with my last review, but maybe move the call
to vfio_ap_mdev_set_kvm(matrix_mdev, vdev->kvm) after the successful
registration of the IOMMU notifier? This way you won't be plugging AP queues
into the guest only to remove them if the registration fails.

>   
> @@ -1415,12 +1395,11 @@ static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
>   	ret = vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY, &events,
>   				     &matrix_mdev->iommu_notifier);
>   	if (ret)
> -		goto out_unregister_group;
> +		goto err_kvm;
>   	return 0;
>   
> -out_unregister_group:
> -	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
> -				 &matrix_mdev->group_notifier);
> +err_kvm:
> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>   	return ret;
>   }
>   
> @@ -1431,8 +1410,6 @@ static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
>   
>   	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY,
>   				 &matrix_mdev->iommu_notifier);
> -	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
> -				 &matrix_mdev->group_notifier);
>   	vfio_ap_mdev_unset_kvm(matrix_mdev);
>   }
>   
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 648fcaf8104a..a26efd804d0d 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -81,8 +81,6 @@ struct ap_matrix {
>    * @node:	allows the ap_matrix_mdev struct to be added to a list
>    * @matrix:	the adapters, usage domains and control domains assigned to the
>    *		mediated matrix device.
> - * @group_notifier: notifier block used for specifying callback function for
> - *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
>    * @iommu_notifier: notifier block used for specifying callback function for
>    *		    handling the VFIO_IOMMU_NOTIFY_DMA_UNMAP even
>    * @kvm:	the struct holding guest's state
> @@ -94,7 +92,6 @@ struct ap_matrix_mdev {
>   	struct vfio_device vdev;
>   	struct list_head node;
>   	struct ap_matrix matrix;
> -	struct notifier_block group_notifier;
>   	struct notifier_block iommu_notifier;
>   	struct kvm *kvm;
>   	crypto_hook pqap_hook;
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index cfcff7764403..831fc722e3f8 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1083,10 +1083,21 @@ static struct file *vfio_device_open(struct vfio_device *device)
>   
>   	mutex_lock(&device->dev_set->lock);
>   	device->open_count++;
> -	if (device->open_count == 1 && device->ops->open_device) {
> -		ret = device->ops->open_device(device);
> -		if (ret)
> -			goto err_undo_count;
> +	if (device->open_count == 1) {
> +		/*
> +		 * Here we pass the KVM pointer with the group under the read
> +		 * lock.  If the device driver will use it, it must obtain a
> +		 * reference and release it during close_device.
> +		 */
> +		down_read(&device->group->group_rwsem);
> +		device->kvm = device->group->kvm;
> +
> +		if (device->ops->open_device) {
> +			ret = device->ops->open_device(device);
> +			if (ret)
> +				goto err_undo_count;
> +		}
> +		up_read(&device->group->group_rwsem);
>   	}
>   	mutex_unlock(&device->dev_set->lock);
>   
> @@ -1119,10 +1130,14 @@ static struct file *vfio_device_open(struct vfio_device *device)
>   
>   err_close_device:
>   	mutex_lock(&device->dev_set->lock);
> +	down_read(&device->group->group_rwsem);
>   	if (device->open_count == 1 && device->ops->close_device)
>   		device->ops->close_device(device);
>   err_undo_count:
>   	device->open_count--;
> +	if (device->open_count == 0 && device->kvm)
> +		device->kvm = NULL;
> +	up_read(&device->group->group_rwsem);
>   	mutex_unlock(&device->dev_set->lock);
>   	module_put(device->dev->driver->owner);
>   err_unassign_container:
> @@ -1315,9 +1330,13 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>   
>   	mutex_lock(&device->dev_set->lock);
>   	vfio_assert_device_open(device);
> +	down_read(&device->group->group_rwsem);
>   	if (device->open_count == 1 && device->ops->close_device)
>   		device->ops->close_device(device);
> +	up_read(&device->group->group_rwsem);
>   	device->open_count--;
> +	if (device->open_count == 0)
> +		device->kvm = NULL;
>   	mutex_unlock(&device->dev_set->lock);
>   
>   	module_put(device->dev->driver->owner);
> @@ -1726,8 +1745,8 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>    * @file: VFIO group file
>    * @kvm: KVM to link
>    *
> - * The kvm pointer will be forwarded to all the vfio_device's attached to the
> - * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
> + * When a VFIO device is first opened the KVM will be available in
> + * device->kvm if one was associated with the group.
>    */
>   void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>   {
> @@ -1738,8 +1757,6 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>   
>   	down_write(&group->group_rwsem);
>   	group->kvm = kvm;
> -	blocking_notifier_call_chain(&group->notifier,
> -				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
>   	up_write(&group->group_rwsem);
>   }
>   EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
> @@ -2006,7 +2023,8 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
>   	struct vfio_iommu_driver *driver;
>   	int ret;
>   
> -	down_read(&group->group_rwsem);
> +	lockdep_assert_held_read(&group->group_rwsem);
> +
>   	container = group->container;
>   	driver = container->iommu_driver;
>   	if (likely(driver && driver->ops->register_notifier))
> @@ -2014,7 +2032,6 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
>   						     events, nb);
>   	else
>   		ret = -ENOTTY;
> -	up_read(&group->group_rwsem);
>   
>   	return ret;
>   }
> @@ -2026,7 +2043,8 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
>   	struct vfio_iommu_driver *driver;
>   	int ret;
>   
> -	down_read(&group->group_rwsem);
> +	lockdep_assert_held_read(&group->group_rwsem);
> +
>   	container = group->container;
>   	driver = container->iommu_driver;
>   	if (likely(driver && driver->ops->unregister_notifier))
> @@ -2034,47 +2052,10 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
>   						       nb);
>   	else
>   		ret = -ENOTTY;
> -	up_read(&group->group_rwsem);
>   
>   	return ret;
>   }
>   
> -static int vfio_register_group_notifier(struct vfio_group *group,
> -					unsigned long *events,
> -					struct notifier_block *nb)
> -{
> -	int ret;
> -	bool set_kvm = false;
> -
> -	if (*events & VFIO_GROUP_NOTIFY_SET_KVM)
> -		set_kvm = true;
> -
> -	/* clear known events */
> -	*events &= ~VFIO_GROUP_NOTIFY_SET_KVM;
> -
> -	/* refuse to continue if still events remaining */
> -	if (*events)
> -		return -EINVAL;
> -
> -	ret = blocking_notifier_chain_register(&group->notifier, nb);
> -	if (ret)
> -		return ret;
> -
> -	/*
> -	 * The attaching of kvm and vfio_group might already happen, so
> -	 * here we replay once upon registration.
> -	 */
> -	if (set_kvm) {
> -		down_read(&group->group_rwsem);
> -		if (group->kvm)
> -			blocking_notifier_call_chain(&group->notifier,
> -						     VFIO_GROUP_NOTIFY_SET_KVM,
> -						     group->kvm);
> -		up_read(&group->group_rwsem);
> -	}
> -	return 0;
> -}
> -
>   int vfio_register_notifier(struct vfio_device *device,
>   			   enum vfio_notify_type type, unsigned long *events,
>   			   struct notifier_block *nb)
> @@ -2090,9 +2071,6 @@ int vfio_register_notifier(struct vfio_device *device,
>   	case VFIO_IOMMU_NOTIFY:
>   		ret = vfio_register_iommu_notifier(group, events, nb);
>   		break;
> -	case VFIO_GROUP_NOTIFY:
> -		ret = vfio_register_group_notifier(group, events, nb);
> -		break;
>   	default:
>   		ret = -EINVAL;
>   	}
> @@ -2114,9 +2092,6 @@ int vfio_unregister_notifier(struct vfio_device *device,
>   	case VFIO_IOMMU_NOTIFY:
>   		ret = vfio_unregister_iommu_notifier(group, nb);
>   		break;
> -	case VFIO_GROUP_NOTIFY:
> -		ret = blocking_notifier_chain_unregister(&group->notifier, nb);
> -		break;
>   	default:
>   		ret = -EINVAL;
>   	}
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 45b287826ce6..aa888cc51757 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -36,6 +36,8 @@ struct vfio_device {
>   	struct vfio_device_set *dev_set;
>   	struct list_head dev_set_list;
>   	unsigned int migration_flags;
> +	/* Driver must reference the kvm during open_device or never touch it */
> +	struct kvm *kvm;
>   
>   	/* Members below here are private, not for driver use */
>   	refcount_t refcount;
> @@ -155,15 +157,11 @@ extern int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova,
>   /* each type has independent events */
>   enum vfio_notify_type {
>   	VFIO_IOMMU_NOTIFY = 0,
> -	VFIO_GROUP_NOTIFY = 1,
>   };
>   
>   /* events for VFIO_IOMMU_NOTIFY */
>   #define VFIO_IOMMU_NOTIFY_DMA_UNMAP	BIT(0)
>   
> -/* events for VFIO_GROUP_NOTIFY */
> -#define VFIO_GROUP_NOTIFY_SET_KVM	BIT(0)
> -
>   extern int vfio_register_notifier(struct vfio_device *device,
>   				  enum vfio_notify_type type,
>   				  unsigned long *required_events,

