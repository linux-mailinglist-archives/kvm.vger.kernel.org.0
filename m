Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199335AC367
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 10:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiIDITY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 04:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIDITX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 04:19:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53E5491ED
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 01:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662279558; x=1693815558;
  h=message-id:date:mime-version:cc:to:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=UpbzzkpnNGwmUEOL09TiD5tM8A03p04PBzBV6ZKTPx0=;
  b=iQbAMFFLSKqmkm0k+VRLARNHfaEfM6S2U9gpNB2JlSY7409MUV9yYsTE
   jJ+yMISD4+AXqfQF+a0V4f4k+p8mhPtjW3fBopdCycNQNMUO7E2y2Jp9H
   aela1QDmwERA/jaDqhJ7pRFCWfkJEeuhVjtTcj6m5z9Ux4XsYqAMJOeYc
   pvmtMP/pqg3dxZox6wlAGiQ/Z0Wbodh64Y1IngnYCUCVKtVqTnmtyTNMH
   JoH/JaWQYlaXw2DnvAQMWBhf+hWui5YZLBYcweqEVLnVuc4yJwEzVPNVK
   b7nBoeAeJR5m9pMiCfrIpXt/5asq7HTJFKKUI+26Zze/mvXyOPYCvpDCI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="357936985"
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="357936985"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 01:19:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="590551607"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.214.77]) ([10.254.214.77])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 01:19:06 -0700
Message-ID: <fa14cc8b-6038-1f4f-e1ac-1e28f913529a@linux.intel.com>
Date:   Sun, 4 Sep 2022 16:19:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Cc:     baolu.lu@linux.intel.com,
        Alex Williamson <alex.williamson@redhat.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <3-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH RFC v2 03/13] iommufd: File descriptor, context, kconfig
 and makefiles
In-Reply-To: <3-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/9/3 3:59, Jason Gunthorpe wrote:
> This is the basic infrastructure of a new miscdevice to hold the iommufd
> IOCTL API.
> 
> It provides:
>   - A miscdevice to create file descriptors to run the IOCTL interface over
> 
>   - A table based ioctl dispatch and centralized extendable pre-validation
>     step.
> 
>   - An xarray mapping user ID's to kernel objects. The design has multiple
>     inter-related objects held within in a single IOMMUFD fd
> 
>   - A simple usage count to build a graph of object relations and protect
>     against hostile userspace racing ioctls
> 
> The only IOCTL provided in this patch is the generic 'destroy any object
> by handle' operation.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>   MAINTAINERS                                   |  10 +
>   drivers/iommu/Kconfig                         |   1 +
>   drivers/iommu/Makefile                        |   2 +-
>   drivers/iommu/iommufd/Kconfig                 |  13 +
>   drivers/iommu/iommufd/Makefile                |   5 +
>   drivers/iommu/iommufd/iommufd_private.h       | 110 ++++++
>   drivers/iommu/iommufd/main.c                  | 345 ++++++++++++++++++
>   include/linux/iommufd.h                       |  31 ++
>   include/uapi/linux/iommufd.h                  |  55 +++
>   10 files changed, 572 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/iommu/iommufd/Kconfig
>   create mode 100644 drivers/iommu/iommufd/Makefile
>   create mode 100644 drivers/iommu/iommufd/iommufd_private.h
>   create mode 100644 drivers/iommu/iommufd/main.c
>   create mode 100644 include/linux/iommufd.h
>   create mode 100644 include/uapi/linux/iommufd.h
> 
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 3b985b19f39d12..4387e787411ebe 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -105,6 +105,7 @@ Code  Seq#    Include File                                           Comments
>   '8'   all                                                            SNP8023 advanced NIC card
>                                                                        <mailto:mcr@solidum.com>
>   ';'   64-7F  linux/vfio.h
> +';'   80-FF  linux/iommufd.h
>   '='   00-3f  uapi/linux/ptp_clock.h                                  <mailto:richardcochran@gmail.com>
>   '@'   00-0F  linux/radeonfb.h                                        conflict!
>   '@'   00-0F  drivers/video/aty/aty128fb.c                            conflict!
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 589517372408ca..abd041f5e00f4c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10609,6 +10609,16 @@ L:	linux-mips@vger.kernel.org
>   S:	Maintained
>   F:	drivers/net/ethernet/sgi/ioc3-eth.c
>   
> +IOMMU FD
> +M:	Jason Gunthorpe <jgg@nvidia.com>
> +M:	Kevin Tian <kevin.tian@intel.com>
> +L:	iommu@lists.linux-foundation.org

This mailing list has already been replaced with iommu@lists.linux.dev.

> +S:	Maintained
> +F:	Documentation/userspace-api/iommufd.rst
> +F:	drivers/iommu/iommufd/
> +F:	include/uapi/linux/iommufd.h
> +F:	include/linux/iommufd.h
> +
>   IOMAP FILESYSTEM LIBRARY
>   M:	Christoph Hellwig <hch@infradead.org>
>   M:	Darrick J. Wong <djwong@kernel.org>
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 5c5cb5bee8b626..9ff3d2830f9559 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -177,6 +177,7 @@ config MSM_IOMMU
>   
>   source "drivers/iommu/amd/Kconfig"
>   source "drivers/iommu/intel/Kconfig"
> +source "drivers/iommu/iommufd/Kconfig"
>   
>   config IRQ_REMAP
>   	bool "Support for Interrupt Remapping"
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 44475a9b3eeaf9..6d2bc288324704 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -1,5 +1,5 @@
>   # SPDX-License-Identifier: GPL-2.0
> -obj-y += amd/ intel/ arm/
> +obj-y += amd/ intel/ arm/ iommufd/
>   obj-$(CONFIG_IOMMU_API) += iommu.o
>   obj-$(CONFIG_IOMMU_API) += iommu-traces.o
>   obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> new file mode 100644
> index 00000000000000..fddd453bb0e764
> --- /dev/null
> +++ b/drivers/iommu/iommufd/Kconfig
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config IOMMUFD
> +	tristate "IOMMU Userspace API"
> +	select INTERVAL_TREE
> +	select IOMMU_API
> +	default n
> +	help
> +	  Provides /dev/iommu the user API to control the IOMMU subsystem as
> +	  it relates to managing IO page tables that point at user space memory.
> +
> +	  This would commonly be used in combination with VFIO.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
> new file mode 100644
> index 00000000000000..a07a8cffe937c6
> --- /dev/null
> +++ b/drivers/iommu/iommufd/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +iommufd-y := \
> +	main.o
> +
> +obj-$(CONFIG_IOMMUFD) += iommufd.o
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> new file mode 100644
> index 00000000000000..a65208d6442be7
> --- /dev/null
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -0,0 +1,110 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
> + */
> +#ifndef __IOMMUFD_PRIVATE_H
> +#define __IOMMUFD_PRIVATE_H
> +
> +#include <linux/rwsem.h>
> +#include <linux/xarray.h>
> +#include <linux/refcount.h>
> +#include <linux/uaccess.h>
> +
> +struct iommufd_ctx {
> +	struct file *file;
> +	struct xarray objects;
> +};
> +
> +struct iommufd_ctx *iommufd_fget(int fd);
> +
> +struct iommufd_ucmd {
> +	struct iommufd_ctx *ictx;
> +	void __user *ubuffer;
> +	u32 user_size;
> +	void *cmd;
> +};
> +
> +/* Copy the response in ucmd->cmd back to userspace. */
> +static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
> +				       size_t cmd_len)
> +{
> +	if (copy_to_user(ucmd->ubuffer, ucmd->cmd,
> +			 min_t(size_t, ucmd->user_size, cmd_len)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +enum iommufd_object_type {
> +	IOMMUFD_OBJ_NONE,
> +	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
> +};
> +
> +/* Base struct for all objects with a userspace ID handle. */
> +struct iommufd_object {
> +	struct rw_semaphore destroy_rwsem;
> +	refcount_t users;
> +	enum iommufd_object_type type;
> +	unsigned int id;
> +};
> +
> +static inline bool iommufd_lock_obj(struct iommufd_object *obj)
> +{
> +	if (!down_read_trylock(&obj->destroy_rwsem))
> +		return false;
> +	if (!refcount_inc_not_zero(&obj->users)) {
> +		up_read(&obj->destroy_rwsem);
> +		return false;
> +	}
> +	return true;
> +}
> +
> +struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
> +					  enum iommufd_object_type type);
> +static inline void iommufd_put_object(struct iommufd_object *obj)
> +{
> +	refcount_dec(&obj->users);
> +	up_read(&obj->destroy_rwsem);
> +}
> +
> +/**
> + * iommufd_put_object_keep_user() - Release part of the refcount on obj
> + * @obj - Object to release
> + *
> + * Objects have two protections to ensure that userspace has a consistent
> + * experience with destruction. Normally objects are locked so that destroy will
> + * block while there are concurrent users, and wait for the object to be
> + * unlocked.
> + *
> + * However, destroy can also be blocked by holding users reference counts on the
> + * objects, in that case destroy will immediately return EBUSY and will not wait
> + * for reference counts to go to zero.
> + *
> + * This function releases the destroy lock and destroy will return EBUSY.

This reads odd. Does it release or acquire a destroy lock.

> + *
> + * It should be used in places where the users will be held beyond a single
> + * system call.
> + */
> +static inline void iommufd_put_object_keep_user(struct iommufd_object *obj)
> +{
> +	up_read(&obj->destroy_rwsem);
> +}
> +void iommufd_object_abort(struct iommufd_ctx *ictx, struct iommufd_object *obj);
> +void iommufd_object_abort_and_destroy(struct iommufd_ctx *ictx,
> +				      struct iommufd_object *obj);
> +void iommufd_object_finalize(struct iommufd_ctx *ictx,
> +			     struct iommufd_object *obj);
> +bool iommufd_object_destroy_user(struct iommufd_ctx *ictx,
> +				 struct iommufd_object *obj);
> +struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
> +					     size_t size,
> +					     enum iommufd_object_type type);
> +
> +#define iommufd_object_alloc(ictx, ptr, type)                                  \
> +	container_of(_iommufd_object_alloc(                                    \
> +			     ictx,                                             \
> +			     sizeof(*(ptr)) + BUILD_BUG_ON_ZERO(               \
> +						      offsetof(typeof(*(ptr)), \
> +							       obj) != 0),     \
> +			     type),                                            \
> +		     typeof(*(ptr)), obj)
> +
> +#endif
> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> new file mode 100644
> index 00000000000000..a5b1e2302ba59d
> --- /dev/null
> +++ b/drivers/iommu/iommufd/main.c
> @@ -0,0 +1,345 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (C) 2021 Intel Corporation
> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
> + *
> + * iommfd provides control over the IOMMU HW objects created by IOMMU kernel
       ^^^^^^ iommufd

> + * drivers. IOMMU HW objects revolve around IO page tables that map incoming DMA
> + * addresses (IOVA) to CPU addresses.
> + *
> + * The API is divided into a general portion that is intended to work with any
> + * kernel IOMMU driver, and a device specific portion that  is intended to be
> + * used with a userspace HW driver paired with the specific kernel driver. This
> + * mechanism allows all the unique functionalities in individual IOMMUs to be
> + * exposed to userspace control.
> + */
> +#define pr_fmt(fmt) "iommufd: " fmt
> +
> +#include <linux/file.h>
> +#include <linux/fs.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/miscdevice.h>
> +#include <linux/mutex.h>
> +#include <linux/bug.h>
> +#include <uapi/linux/iommufd.h>
> +#include <linux/iommufd.h>
> +
> +#include "iommufd_private.h"
> +
> +struct iommufd_object_ops {
> +	void (*destroy)(struct iommufd_object *obj);
> +};
> +static struct iommufd_object_ops iommufd_object_ops[];
> +
> +struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
> +					     size_t size,
> +					     enum iommufd_object_type type)
> +{
> +	struct iommufd_object *obj;
> +	int rc;
> +
> +	obj = kzalloc(size, GFP_KERNEL_ACCOUNT);
> +	if (!obj)
> +		return ERR_PTR(-ENOMEM);
> +	obj->type = type;
> +	init_rwsem(&obj->destroy_rwsem);
> +	refcount_set(&obj->users, 1);
> +
> +	/*
> +	 * Reserve an ID in the xarray but do not publish the pointer yet since
> +	 * the caller hasn't initialized it yet. Once the pointer is published
> +	 * in the xarray and visible to other threads we can't reliably destroy
> +	 * it anymore, so the caller must complete all errorable operations
> +	 * before calling iommufd_object_finalize().
> +	 */
> +	rc = xa_alloc(&ictx->objects, &obj->id, XA_ZERO_ENTRY,
> +		      xa_limit_32b, GFP_KERNEL_ACCOUNT);
> +	if (rc)
> +		goto out_free;
> +	return obj;
> +out_free:
> +	kfree(obj);
> +	return ERR_PTR(rc);
> +}
> +
> +/*
> + * Allow concurrent access to the object. This should only be done once the
> + * system call that created the object is guaranteed to succeed.
> + */
> +void iommufd_object_finalize(struct iommufd_ctx *ictx,
> +			     struct iommufd_object *obj)
> +{
> +	void *old;
> +
> +	old = xa_store(&ictx->objects, obj->id, obj, GFP_KERNEL);
> +	/* obj->id was returned from xa_alloc() so the xa_store() cannot fail */
> +	WARN_ON(old);
> +}
> +
> +/* Undo _iommufd_object_alloc() if iommufd_object_finalize() was not called */
> +void iommufd_object_abort(struct iommufd_ctx *ictx, struct iommufd_object *obj)
> +{
> +	void *old;
> +
> +	old = xa_erase(&ictx->objects, obj->id);
> +	WARN_ON(old);
> +	kfree(obj);
> +}
> +
> +/*
> + * Abort an object that has been fully initialized and needs destroy, but has
> + * not been finalized.
> + */
> +void iommufd_object_abort_and_destroy(struct iommufd_ctx *ictx,
> +				      struct iommufd_object *obj)
> +{
> +	iommufd_object_ops[obj->type].destroy(obj);
> +	iommufd_object_abort(ictx, obj);
> +}
> +
> +struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
> +					  enum iommufd_object_type type)
> +{
> +	struct iommufd_object *obj;
> +
> +	xa_lock(&ictx->objects);
> +	obj = xa_load(&ictx->objects, id);
> +	if (!obj || (type != IOMMUFD_OBJ_ANY && obj->type != type) ||
> +	    !iommufd_lock_obj(obj))
> +		obj = ERR_PTR(-ENOENT);
> +	xa_unlock(&ictx->objects);
> +	return obj;
> +}
> +
> +/*
> + * The caller holds a users refcount and wants to destroy the object. Returns
> + * true if the object was destroyed. In all cases the caller no longer has a
> + * reference on obj.
> + */
> +bool iommufd_object_destroy_user(struct iommufd_ctx *ictx,
> +				 struct iommufd_object *obj)
> +{
> +	/*
> +	 * The purpose of the destroy_rwsem is to ensure deterministic
> +	 * destruction of objects used by external drivers and destroyed by this
> +	 * function. Any temporary increment of the refcount must hold the read
> +	 * side of this, such as during ioctl execution.
> +	 */
> +	down_write(&obj->destroy_rwsem);
> +	xa_lock(&ictx->objects);
> +	refcount_dec(&obj->users);
> +	if (!refcount_dec_if_one(&obj->users)) {
> +		xa_unlock(&ictx->objects);
> +		up_write(&obj->destroy_rwsem);
> +		return false;
> +	}
> +	__xa_erase(&ictx->objects, obj->id);
> +	xa_unlock(&ictx->objects);
> +	up_write(&obj->destroy_rwsem);
> +
> +	iommufd_object_ops[obj->type].destroy(obj);
> +	kfree(obj);
> +	return true;
> +}
> +
> +static int iommufd_destroy(struct iommufd_ucmd *ucmd)
> +{
> +	struct iommu_destroy *cmd = ucmd->cmd;
> +	struct iommufd_object *obj;
> +
> +	obj = iommufd_get_object(ucmd->ictx, cmd->id, IOMMUFD_OBJ_ANY);
> +	if (IS_ERR(obj))
> +		return PTR_ERR(obj);
> +	iommufd_put_object_keep_user(obj);
> +	if (!iommufd_object_destroy_user(ucmd->ictx, obj))
> +		return -EBUSY;
> +	return 0;
> +}
> +
> +static int iommufd_fops_open(struct inode *inode, struct file *filp)
> +{
> +	struct iommufd_ctx *ictx;
> +
> +	ictx = kzalloc(sizeof(*ictx), GFP_KERNEL_ACCOUNT);
> +	if (!ictx)
> +		return -ENOMEM;
> +
> +	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
> +	ictx->file = filp;
> +	filp->private_data = ictx;
> +	return 0;
> +}
> +
> +static int iommufd_fops_release(struct inode *inode, struct file *filp)
> +{
> +	struct iommufd_ctx *ictx = filp->private_data;
> +	struct iommufd_object *obj;
> +
> +	/* Destroy the graph from depth first */
> +	while (!xa_empty(&ictx->objects)) {
> +		unsigned int destroyed = 0;
> +		unsigned long index;
> +
> +		xa_for_each (&ictx->objects, index, obj) {
> +			/*
> +			 * Since we are in release elevated users must come from
> +			 * other objects holding the users. We will eventually
> +			 * destroy the object that holds this one and the next
> +			 * pass will progress it.
> +			 */
> +			if (!refcount_dec_if_one(&obj->users))
> +				continue;
> +			destroyed++;
> +			xa_erase(&ictx->objects, index);
> +			iommufd_object_ops[obj->type].destroy(obj);
> +			kfree(obj);
> +		}
> +		/* Bug related to users refcount */
> +		if (WARN_ON(!destroyed))
> +			break;
> +	}
> +	kfree(ictx);
> +	return 0;
> +}
> +
> +union ucmd_buffer {
> +	struct iommu_destroy destroy;
> +};
> +
> +struct iommufd_ioctl_op {
> +	unsigned int size;
> +	unsigned int min_size;
> +	unsigned int ioctl_num;
> +	int (*execute)(struct iommufd_ucmd *ucmd);
> +};
> +
> +#define IOCTL_OP(_ioctl, _fn, _struct, _last)                                  \
> +	[_IOC_NR(_ioctl) - IOMMUFD_CMD_BASE] = {                               \
> +		.size = sizeof(_struct) +                                      \
> +			BUILD_BUG_ON_ZERO(sizeof(union ucmd_buffer) <          \
> +					  sizeof(_struct)),                    \
> +		.min_size = offsetofend(_struct, _last),                       \
> +		.ioctl_num = _ioctl,                                           \
> +		.execute = _fn,                                                \
> +	}
> +static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
> +	IOCTL_OP(IOMMU_DESTROY, iommufd_destroy, struct iommu_destroy, id),
> +};
> +
> +static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
> +			       unsigned long arg)
> +{
> +	struct iommufd_ucmd ucmd = {};
> +	struct iommufd_ioctl_op *op;
> +	union ucmd_buffer buf;
> +	unsigned int nr;
> +	int ret;
> +
> +	ucmd.ictx = filp->private_data;
> +	ucmd.ubuffer = (void __user *)arg;
> +	ret = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
> +	if (ret)
> +		return ret;
> +
> +	nr = _IOC_NR(cmd);
> +	if (nr < IOMMUFD_CMD_BASE ||
> +	    (nr - IOMMUFD_CMD_BASE) >= ARRAY_SIZE(iommufd_ioctl_ops))
> +		return -ENOIOCTLCMD;
> +	op = &iommufd_ioctl_ops[nr - IOMMUFD_CMD_BASE];
> +	if (op->ioctl_num != cmd)
> +		return -ENOIOCTLCMD;
> +	if (ucmd.user_size < op->min_size)
> +		return -EOPNOTSUPP;
> +
> +	ucmd.cmd = &buf;
> +	ret = copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
> +				    ucmd.user_size);
> +	if (ret)
> +		return ret;
> +	ret = op->execute(&ucmd);
> +	return ret;
> +}
> +
> +static const struct file_operations iommufd_fops = {
> +	.owner = THIS_MODULE,
> +	.open = iommufd_fops_open,
> +	.release = iommufd_fops_release,
> +	.unlocked_ioctl = iommufd_fops_ioctl,
> +};
> +
> +/**
> + * iommufd_ctx_get - Get a context reference
> + * @ictx - Context to get
> + *
> + * The caller must already hold a valid reference to ictx.
> + */
> +void iommufd_ctx_get(struct iommufd_ctx *ictx)
> +{
> +	get_file(ictx->file);
> +}
> +EXPORT_SYMBOL_GPL(iommufd_ctx_get);
> +
> +/**
> + * iommufd_ctx_from_file - Acquires a reference to the iommufd context
> + * @file: File to obtain the reference from
> + *
> + * Returns a pointer to the iommufd_ctx, otherwise ERR_PTR. The struct file
> + * remains owned by the caller and the caller must still do fput. On success
> + * the caller is responsible to call iommufd_ctx_put().
> + */
> +struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
> +{
> +	struct iommufd_ctx *ictx;
> +
> +	if (file->f_op != &iommufd_fops)
> +		return ERR_PTR(-EBADFD);
> +	ictx = file->private_data;
> +	iommufd_ctx_get(ictx);
> +	return ictx;
> +}
> +EXPORT_SYMBOL_GPL(iommufd_ctx_from_file);
> +
> +/**
> + * iommufd_ctx_put - Put back a reference
> + * @ictx - Context to put back
> + */
> +void iommufd_ctx_put(struct iommufd_ctx *ictx)
> +{
> +	fput(ictx->file);
> +}
> +EXPORT_SYMBOL_GPL(iommufd_ctx_put);
> +
> +static struct iommufd_object_ops iommufd_object_ops[] = {
> +};
> +
> +static struct miscdevice iommu_misc_dev = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "iommu",
> +	.fops = &iommufd_fops,
> +	.nodename = "iommu",
> +	.mode = 0660,
> +};
> +
> +static int __init iommufd_init(void)
> +{
> +	int ret;
> +
> +	ret = misc_register(&iommu_misc_dev);
> +	if (ret) {
> +		pr_err("Failed to register misc device\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit iommufd_exit(void)
> +{
> +	misc_deregister(&iommu_misc_dev);
> +}
> +
> +module_init(iommufd_init);
> +module_exit(iommufd_exit);
> +
> +MODULE_DESCRIPTION("I/O Address Space Management for passthrough devices");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> new file mode 100644
> index 00000000000000..c8bbed542e923c
> --- /dev/null
> +++ b/include/linux/iommufd.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2021 Intel Corporation
> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
> + */
> +#ifndef __LINUX_IOMMUFD_H
> +#define __LINUX_IOMMUFD_H
> +
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +
> +struct iommufd_ctx;
> +struct file;
> +
> +void iommufd_ctx_get(struct iommufd_ctx *ictx);
> +
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
> +void iommufd_ctx_put(struct iommufd_ctx *ictx);
> +#else /* !CONFIG_IOMMUFD */
> +static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
> +{
> +       return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline void iommufd_ctx_put(struct iommufd_ctx *ictx)
> +{
> +}
> +#endif /* CONFIG_IOMMUFD */
> +#endif
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> new file mode 100644
> index 00000000000000..2f7f76ec6db4cb
> --- /dev/null
> +++ b/include/uapi/linux/iommufd.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
> + */
> +#ifndef _UAPI_IOMMUFD_H
> +#define _UAPI_IOMMUFD_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +#define IOMMUFD_TYPE (';')
> +
> +/**
> + * DOC: General ioctl format
> + *
> + * The ioctl mechanims follows a general format to allow for extensibility. Each
> + * ioctl is passed in a structure pointer as the argument providing the size of
> + * the structure in the first u32. The kernel checks that any structure space
> + * beyond what it understands is 0. This allows userspace to use the backward
> + * compatible portion while consistently using the newer, larger, structures.
> + *
> + * ioctls use a standard meaning for common errnos:
> + *
> + *  - ENOTTY: The IOCTL number itself is not supported at all
> + *  - E2BIG: The IOCTL number is supported, but the provided structure has
> + *    non-zero in a part the kernel does not understand.
> + *  - EOPNOTSUPP: The IOCTL number is supported, and the structure is
> + *    understood, however a known field has a value the kernel does not
> + *    understand or support.
> + *  - EINVAL: Everything about the IOCTL was understood, but a field is not
> + *    correct.
> + *  - ENOENT: An ID or IOVA provided does not exist.
> + *  - ENOMEM: Out of memory.
> + *  - EOVERFLOW: Mathematics oveflowed.
> + *
> + * As well as additional errnos. within specific ioctls.
> + */
> +enum {
> +	IOMMUFD_CMD_BASE = 0x80,
> +	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
> +};
> +
> +/**
> + * struct iommu_destroy - ioctl(IOMMU_DESTROY)
> + * @size: sizeof(struct iommu_destroy)
> + * @id: iommufd object ID to destroy. Can by any destroyable object type.

                                              ^^be ?

> + *
> + * Destroy any object held within iommufd.
> + */
> +struct iommu_destroy {
> +	__u32 size;
> +	__u32 id;
> +};
> +#define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)
> +
> +#endif

Best regards,
baolu
