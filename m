Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0574A19767E
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 10:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbgC3IcU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Mar 2020 04:32:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:23594 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729576AbgC3IcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 04:32:20 -0400
IronPort-SDR: jKgqs4iQwV3pQrNaU7VH50Y3AK+EsAYurzsnJctu1RNhZbcyOf3MmP4LMumz4DLfS0HOaYnj9m
 Szxt/bUgfjKw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 01:32:19 -0700
IronPort-SDR: MqwbZqs8TzW49d6NnKTnhcyirETjIfbB9o6aanw9YEF0Z/q0s3zTUy28t/8iE7cJTqTwsEbOel
 G3bms/bGod4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,323,1580803200"; 
   d="scan'208";a="248633408"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2020 01:32:18 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 01:32:18 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 01:32:18 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.101]) with mapi id 14.03.0439.000;
 Mon, 30 Mar 2020 16:32:14 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHWAEUbvuzF5+3jpEaYhihTFzMRG6hgq7/w
Date:   Mon, 30 Mar 2020 08:32:14 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF378@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Sunday, March 22, 2020 8:32 PM
> 
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> For a long time, devices have only one DMA address space from platform
> IOMMU's point of view. This is true for both bare metal and directed-
> access in virtualization environment. Reason is the source ID of DMA in
> PCIe are BDF (bus/dev/fnc ID), which results in only device granularity

are->is

> DMA isolation. However, this is changing with the latest advancement in
> I/O technology area. More and more platform vendors are utilizing the PCIe
> PASID TLP prefix in DMA requests, thus to give devices with multiple DMA
> address spaces as identified by their individual PASIDs. For example,
> Shared Virtual Addressing (SVA, a.k.a Shared Virtual Memory) is able to
> let device access multiple process virtual address space by binding the

"address space" -> "address spaces"

"binding the" -> "binding each"

> virtual address space with a PASID. Wherein the PASID is allocated in
> software and programmed to device per device specific manner. Devices
> which support PASID capability are called PASID-capable devices. If such
> devices are passed through to VMs, guest software are also able to bind
> guest process virtual address space on such devices. Therefore, the guest
> software could reuse the bare metal software programming model, which
> means guest software will also allocate PASID and program it to device
> directly. This is a dangerous situation since it has potential PASID
> conflicts and unauthorized address space access. It would be safer to
> let host intercept in the guest software's PASID allocation. Thus PASID
> are managed system-wide.
> 
> This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims to
> passdown
> PASID allocation/free request from the virtual IOMMU. Additionally, such

"Additionally, because such"

> requests are intended to be invoked by QEMU or other applications which

simplify to "intended to be invoked from userspace"

> are running in userspace, it is necessary to have a mechanism to prevent
> single application from abusing available PASIDs in system. With such
> consideration, this patch tracks the VFIO PASID allocation per-VM. There
> was a discussion to make quota to be per assigned devices. e.g. if a VM
> has many assigned devices, then it should have more quota. However, it
> is not sure how many PASIDs an assigned devices will use. e.g. it is

devices -> device

> possible that a VM with multiples assigned devices but requests less
> PASIDs. Therefore per-VM quota would be better.
> 
> This patch uses struct mm pointer as a per-VM token. We also considered
> using task structure pointer and vfio_iommu structure pointer. However,
> task structure is per-thread, which means it cannot achieve per-VM PASID
> alloc tracking purpose. While for vfio_iommu structure, it is visible
> only within vfio. Therefore, structure mm pointer is selected. This patch
> adds a structure vfio_mm. A vfio_mm is created when the first vfio
> container is opened by a VM. On the reverse order, vfio_mm is free when
> the last vfio container is released. Each VM is assigned with a PASID
> quota, so that it is not able to request PASID beyond its quota. This
> patch adds a default quota of 1000. This quota could be tuned by
> administrator. Making PASID quota tunable will be added in another patch
> in this series.
> 
> Previous discussions:
> https://patchwork.kernel.org/patch/11209429/
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/vfio/vfio.c             | 130
> ++++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c | 104
> ++++++++++++++++++++++++++++++++
>  include/linux/vfio.h            |  20 +++++++
>  include/uapi/linux/vfio.h       |  41 +++++++++++++
>  4 files changed, 295 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index c848262..d13b483 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -32,6 +32,7 @@
>  #include <linux/vfio.h>
>  #include <linux/wait.h>
>  #include <linux/sched/signal.h>
> +#include <linux/sched/mm.h>
> 
>  #define DRIVER_VERSION	"0.3"
>  #define DRIVER_AUTHOR	"Alex Williamson
> <alex.williamson@redhat.com>"
> @@ -46,6 +47,8 @@ static struct vfio {
>  	struct mutex			group_lock;
>  	struct cdev			group_cdev;
>  	dev_t				group_devt;
> +	struct list_head		vfio_mm_list;
> +	struct mutex			vfio_mm_lock;
>  	wait_queue_head_t		release_q;
>  } vfio;
> 
> @@ -2129,6 +2132,131 @@ int vfio_unregister_notifier(struct device *dev,
> enum vfio_notify_type type,
>  EXPORT_SYMBOL(vfio_unregister_notifier);
> 
>  /**
> + * VFIO_MM objects - create, release, get, put, search

why capitalizing vfio_mm?

> + * Caller of the function should have held vfio.vfio_mm_lock.
> + */
> +static struct vfio_mm *vfio_create_mm(struct mm_struct *mm)
> +{
> +	struct vfio_mm *vmm;
> +	struct vfio_mm_token *token;
> +	int ret = 0;
> +
> +	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
> +	if (!vmm)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Per mm IOASID set used for quota control and group operations
> */
> +	ret = ioasid_alloc_set((struct ioasid_set *) mm,
> +			       VFIO_DEFAULT_PASID_QUOTA, &vmm-
> >ioasid_sid);
> +	if (ret) {
> +		kfree(vmm);
> +		return ERR_PTR(ret);
> +	}
> +
> +	kref_init(&vmm->kref);
> +	token = &vmm->token;
> +	token->val = mm;
> +	vmm->pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
> +	mutex_init(&vmm->pasid_lock);
> +
> +	list_add(&vmm->vfio_next, &vfio.vfio_mm_list);
> +
> +	return vmm;
> +}
> +
> +static void vfio_mm_unlock_and_free(struct vfio_mm *vmm)
> +{
> +	/* destroy the ioasid set */
> +	ioasid_free_set(vmm->ioasid_sid, true);

do we need hold pasid lock here, since it attempts to destroy a
set which might be referenced by vfio_mm_pasid_free? or is
there guarantee that such race won't happen?

> +	mutex_unlock(&vfio.vfio_mm_lock);
> +	kfree(vmm);
> +}
> +
> +/* called with vfio.vfio_mm_lock held */
> +static void vfio_mm_release(struct kref *kref)
> +{
> +	struct vfio_mm *vmm = container_of(kref, struct vfio_mm, kref);
> +
> +	list_del(&vmm->vfio_next);
> +	vfio_mm_unlock_and_free(vmm);
> +}
> +
> +void vfio_mm_put(struct vfio_mm *vmm)
> +{
> +	kref_put_mutex(&vmm->kref, vfio_mm_release,
> &vfio.vfio_mm_lock);
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_put);
> +
> +/* Assume vfio_mm_lock or vfio_mm reference is held */
> +static void vfio_mm_get(struct vfio_mm *vmm)
> +{
> +	kref_get(&vmm->kref);
> +}
> +
> +struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
> +{
> +	struct mm_struct *mm = get_task_mm(task);
> +	struct vfio_mm *vmm;
> +	unsigned long long val = (unsigned long long) mm;
> +
> +	mutex_lock(&vfio.vfio_mm_lock);
> +	list_for_each_entry(vmm, &vfio.vfio_mm_list, vfio_next) {
> +		if (vmm->token.val == val) {
> +			vfio_mm_get(vmm);
> +			goto out;
> +		}
> +	}
> +
> +	vmm = vfio_create_mm(mm);
> +	if (IS_ERR(vmm))
> +		vmm = NULL;
> +out:
> +	mutex_unlock(&vfio.vfio_mm_lock);
> +	mmput(mm);

I assume this has been discussed before, but from readability p.o.v
it might be good to add a comment for this function to explain
how the recording of mm in vfio_mm can be correctly removed
when the mm is being destroyed, since we don't hold a reference
of mm here.

> +	return vmm;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> +
> +int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max)
> +{
> +	ioasid_t pasid;
> +	int ret = -ENOSPC;
> +
> +	mutex_lock(&vmm->pasid_lock);
> +
> +	pasid = ioasid_alloc(vmm->ioasid_sid, min, max, NULL);
> +	if (pasid == INVALID_IOASID) {
> +		ret = -ENOSPC;
> +		goto out_unlock;
> +	}
> +
> +	ret = pasid;
> +out_unlock:
> +	mutex_unlock(&vmm->pasid_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_pasid_alloc);
> +
> +int vfio_mm_pasid_free(struct vfio_mm *vmm, ioasid_t pasid)
> +{
> +	void *pdata;
> +	int ret = 0;
> +
> +	mutex_lock(&vmm->pasid_lock);
> +	pdata = ioasid_find(vmm->ioasid_sid, pasid, NULL);
> +	if (IS_ERR(pdata)) {
> +		ret = PTR_ERR(pdata);
> +		goto out_unlock;
> +	}
> +	ioasid_free(pasid);
> +
> +out_unlock:
> +	mutex_unlock(&vmm->pasid_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_pasid_free);
> +
> +/**
>   * Module/class support
>   */
>  static char *vfio_devnode(struct device *dev, umode_t *mode)
> @@ -2151,8 +2279,10 @@ static int __init vfio_init(void)
>  	idr_init(&vfio.group_idr);
>  	mutex_init(&vfio.group_lock);
>  	mutex_init(&vfio.iommu_drivers_lock);
> +	mutex_init(&vfio.vfio_mm_lock);
>  	INIT_LIST_HEAD(&vfio.group_list);
>  	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
> +	INIT_LIST_HEAD(&vfio.vfio_mm_list);
>  	init_waitqueue_head(&vfio.release_q);
> 
>  	ret = misc_register(&vfio_dev);
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index a177bf2..331ceee 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -70,6 +70,7 @@ struct vfio_iommu {
>  	unsigned int		dma_avail;
>  	bool			v2;
>  	bool			nesting;
> +	struct vfio_mm		*vmm;
>  };
> 
>  struct vfio_domain {
> @@ -2018,6 +2019,7 @@ static void vfio_iommu_type1_detach_group(void
> *iommu_data,
>  static void *vfio_iommu_type1_open(unsigned long arg)
>  {
>  	struct vfio_iommu *iommu;
> +	struct vfio_mm *vmm = NULL;
> 
>  	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
>  	if (!iommu)
> @@ -2043,6 +2045,10 @@ static void *vfio_iommu_type1_open(unsigned
> long arg)
>  	iommu->dma_avail = dma_entry_limit;
>  	mutex_init(&iommu->lock);
>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
> +	vmm = vfio_mm_get_from_task(current);
> +	if (!vmm)
> +		pr_err("Failed to get vfio_mm track\n");

I assume error should be returned when pr_err is used...

> +	iommu->vmm = vmm;
> 
>  	return iommu;
>  }
> @@ -2084,6 +2090,8 @@ static void vfio_iommu_type1_release(void
> *iommu_data)
>  	}
> 
>  	vfio_iommu_iova_free(&iommu->iova_list);
> +	if (iommu->vmm)
> +		vfio_mm_put(iommu->vmm);
> 
>  	kfree(iommu);
>  }
> @@ -2172,6 +2180,55 @@ static int vfio_iommu_iova_build_caps(struct
> vfio_iommu *iommu,
>  	return ret;
>  }
> 
> +static bool vfio_iommu_type1_pasid_req_valid(u32 flags)

I don't think you need prefix "vfio_iommu_type1" for every new
function here, especially for leaf internal function as this one.

> +{
> +	return !((flags & ~VFIO_PASID_REQUEST_MASK) ||
> +		 (flags & VFIO_IOMMU_PASID_ALLOC &&
> +		  flags & VFIO_IOMMU_PASID_FREE));
> +}
> +
> +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> +					 int min,
> +					 int max)
> +{
> +	struct vfio_mm *vmm = iommu->vmm;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret = -EFAULT;

why -EFAULT?

> +		goto out_unlock;
> +	}
> +	if (vmm)
> +		ret = vfio_mm_pasid_alloc(vmm, min, max);
> +	else
> +		ret = -EINVAL;
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> +				       unsigned int pasid)
> +{
> +	struct vfio_mm *vmm = iommu->vmm;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret = -EFAULT;

ditto

> +		goto out_unlock;
> +	}
> +
> +	if (vmm)
> +		ret = vfio_mm_pasid_free(vmm, pasid);
> +	else
> +		ret = -EINVAL;
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2276,6 +2333,53 @@ static long vfio_iommu_type1_ioctl(void
> *iommu_data,
> 
>  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>  			-EFAULT : 0;
> +
> +	} else if (cmd == VFIO_IOMMU_PASID_REQUEST) {
> +		struct vfio_iommu_type1_pasid_request req;
> +		unsigned long offset;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_pasid_request,
> +				    flags);
> +
> +		if (copy_from_user(&req, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (req.argsz < minsz ||
> +		    !vfio_iommu_type1_pasid_req_valid(req.flags))
> +			return -EINVAL;
> +
> +		if (copy_from_user((void *)&req + minsz,
> +				   (void __user *)arg + minsz,
> +				   sizeof(req) - minsz))
> +			return -EFAULT;

why copying in two steps instead of copying them together?

> +
> +		switch (req.flags & VFIO_PASID_REQUEST_MASK) {
> +		case VFIO_IOMMU_PASID_ALLOC:
> +		{
> +			int ret = 0, result;
> +
> +			result = vfio_iommu_type1_pasid_alloc(iommu,
> +							req.alloc_pasid.min,
> +							req.alloc_pasid.max);
> +			if (result > 0) {
> +				offset = offsetof(
> +					struct
> vfio_iommu_type1_pasid_request,
> +					alloc_pasid.result);
> +				ret = copy_to_user(
> +					      (void __user *) (arg + offset),
> +					      &result, sizeof(result));
> +			} else {
> +				pr_debug("%s: PASID alloc failed\n",
> __func__);
> +				ret = -EFAULT;

no, this branch is not for copy_to_user error. it is about pasid alloc
failure. you should handle both.

> +			}
> +			return ret;
> +		}
> +		case VFIO_IOMMU_PASID_FREE:
> +			return vfio_iommu_type1_pasid_free(iommu,
> +							   req.free_pasid);
> +		default:
> +			return -EINVAL;
> +		}
>  	}
> 
>  	return -ENOTTY;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e42a711..75f9f7f1 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -89,6 +89,26 @@ extern int vfio_register_iommu_driver(const struct
> vfio_iommu_driver_ops *ops);
>  extern void vfio_unregister_iommu_driver(
>  				const struct vfio_iommu_driver_ops *ops);
> 
> +#define VFIO_DEFAULT_PASID_QUOTA	1000
> +struct vfio_mm_token {
> +	unsigned long long val;
> +};
> +
> +struct vfio_mm {
> +	struct kref			kref;
> +	struct vfio_mm_token		token;
> +	int				ioasid_sid;
> +	/* protect @pasid_quota field and pasid allocation/free */
> +	struct mutex			pasid_lock;
> +	int				pasid_quota;
> +	struct list_head		vfio_next;
> +};
> +
> +extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
> +extern void vfio_mm_put(struct vfio_mm *vmm);
> +extern int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max);
> +extern int vfio_mm_pasid_free(struct vfio_mm *vmm, ioasid_t pasid);
> +
>  /*
>   * External user API
>   */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a1..298ac80 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -794,6 +794,47 @@ struct vfio_iommu_type1_dma_unmap {
>  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
> 
> +/*
> + * PASID (Process Address Space ID) is a PCIe concept which
> + * has been extended to support DMA isolation in fine-grain.
> + * With device assigned to user space (e.g. VMs), PASID alloc
> + * and free need to be system wide. This structure defines
> + * the info for pasid alloc/free between user space and kernel
> + * space.
> + *
> + * @flag=VFIO_IOMMU_PASID_ALLOC, refer to the @alloc_pasid
> + * @flag=VFIO_IOMMU_PASID_FREE, refer to @free_pasid
> + */
> +struct vfio_iommu_type1_pasid_request {
> +	__u32	argsz;
> +#define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
> +#define VFIO_IOMMU_PASID_FREE	(1 << 1)
> +	__u32	flags;
> +	union {
> +		struct {
> +			__u32 min;
> +			__u32 max;
> +			__u32 result;

result->pasid?

> +		} alloc_pasid;
> +		__u32 free_pasid;

what about putting a common pasid field after flags?

> +	};
> +};
> +
> +#define VFIO_PASID_REQUEST_MASK	(VFIO_IOMMU_PASID_ALLOC | \
> +					 VFIO_IOMMU_PASID_FREE)
> +
> +/**
> + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
> + *				struct vfio_iommu_type1_pasid_request)
> + *
> + * Availability of this feature depends on PASID support in the device,
> + * its bus, the underlying IOMMU and the CPU architecture. In VFIO, it
> + * is available after VFIO_SET_IOMMU.
> + *
> + * returns: 0 on success, -errno on failure.
> + */
> +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE +
> 22)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
> 
>  /*
> --
> 2.7.4

