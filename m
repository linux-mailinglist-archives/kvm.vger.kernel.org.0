Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3E04E4130
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 15:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiCVO1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 10:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241020AbiCVO02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 10:26:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E480B104
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 07:24:55 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MDlQ0n018127;
        Tue, 22 Mar 2022 14:19:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=a3fMQ631gIDMAZqQPIcdPgZaKBp5XLM8demZhk/wGVM=;
 b=apItDN+tukHCG5IJzKeOSZMfufU4q9QZ43J4aBD/Ug0mqWJLfrFMEDydkMxMXbBendWA
 A+SMi8VbPBRO8BgF+gm7LT8xTs3cUzMdHJU8tWvV4iXRtOizbf16ie2VL+1/K2/FzsnI
 EvVfOfIhGVwxesRW+vqMiNcD81d5sFB+Y9f8Ph0cTgLjQkl4lgHkXtdkrj0i4NngKiVY
 /EpQuBSpkmN9iTyvHDJZ/ZFqJ4V3b0fWL0DHTbVxiuh1ZyTBg6Ym9Awn5PJ4CPH/FPLH
 gGtfkHCrjhGZmTa/CB/4/rn/cLqRFqO5EI4sEFbscr4rWDlVryQ7r+Q8CCsETqdDbfLz 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyautqrqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 14:19:35 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MEJPNM016051;
        Tue, 22 Mar 2022 14:19:35 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyautqrkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 14:19:34 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MEHfWC021054;
        Tue, 22 Mar 2022 14:18:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3ew6ehwhkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 14:18:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MEIqvp11469094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 14:18:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6CB152052;
        Tue, 22 Mar 2022 14:18:52 +0000 (GMT)
Received: from sig-9-145-28-179.uk.ibm.com (unknown [9.145.28.179])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AAC295204E;
        Tue, 22 Mar 2022 14:18:51 +0000 (GMT)
Message-ID: <5f1e2f85e45d7cc5c7cade7042a681186d3d7bd3.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 03/12] iommufd: File descriptor, context, kconfig
 and makefiles
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Date:   Tue, 22 Mar 2022 15:18:51 +0100
In-Reply-To: <3-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: <3-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7kporxZV40xpg43zgjOvdjKvr58YSj7w
X-Proofpoint-ORIG-GUID: DNF914Ae1RvMI7_AaHjenmtkKgzHN_By
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_06,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=635 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-18 at 14:27 -0300, Jason Gunthorpe wrote:
> This is the basic infrastructure of a new miscdevice to hold the iommufd
> IOCTL API.
> 
> It provides:
>  - A miscdevice to create file descriptors to run the IOCTL interface over
> 
>  - A table based ioctl dispatch and centralized extendable pre-validation
>    step
> 
>  - An xarray mapping user ID's to kernel objects. The design has multiple
>    inter-related objects held within in a single IOMMUFD fd
> 
>  - A simple usage count to build a graph of object relations and protect
>    against hostile userspace racing ioctls

For me at this point it seems hard to grok what this "graph of object
relations" is about. Maybe an example would help? I'm assuming this is
about e.g. the DEVICE -depends-on-> HW_PAGETABLE -depends-on-> IOAS  so
the arrows in the picture of PATCH 02? Or is it the other way around
and the IOAS -depends-on-> HW_PAGETABLE because it's about which
references which? From the rest of the patch I seem to understand that
this mostly establishes the order of destruction. So is HW_PAGETABLE
destroyed before the IOAS because a HW_PAGETABLE must never reference
an invalid/destoryed IOAS or is it the other way arund because the IOAS
has a reference to the HW_PAGETABLES in it? I'd guess the former but
I'm a bit confused still.

> 
> The only IOCTL provided in this patch is the generic 'destroy any object
> by handle' operation.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  MAINTAINERS                                   |  10 +
>  drivers/iommu/Kconfig                         |   1 +
>  drivers/iommu/Makefile                        |   2 +-
>  drivers/iommu/iommufd/Kconfig                 |  13 +
>  drivers/iommu/iommufd/Makefile                |   5 +
>  drivers/iommu/iommufd/iommufd_private.h       |  95 ++++++
>  drivers/iommu/iommufd/main.c                  | 305 ++++++++++++++++++
>  include/uapi/linux/iommufd.h                  |  55 ++++
>  9 files changed, 486 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/iommu/iommufd/Kconfig
>  create mode 100644 drivers/iommu/iommufd/Makefile
>  create mode 100644 drivers/iommu/iommufd/iommufd_private.h
>  create mode 100644 drivers/iommu/iommufd/main.c
>  create mode 100644 include/uapi/linux/iommufd.h
> 
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index e6fce2cbd99ed4..4a041dfc61fe95 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -105,6 +105,7 @@ Code  Seq#    Include File                                           Comments
>  '8'   all                                                            SNP8023 advanced NIC card
>                                                                       <mailto:mcr@solidum.com>
>  ';'   64-7F  linux/vfio.h
> +';'   80-FF  linux/iommufd.h
>  '='   00-3f  uapi/linux/ptp_clock.h                                  <mailto:richardcochran@gmail.com>
>  '@'   00-0F  linux/radeonfb.h                                        conflict!
>  '@'   00-0F  drivers/video/aty/aty128fb.c                            conflict!
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1ba1e4af2cbc80..23a9c631051ee8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10038,6 +10038,16 @@ L:	linux-mips@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/ethernet/sgi/ioc3-eth.c
>  
> +IOMMU FD
> +M:	Jason Gunthorpe <jgg@nvidia.com>
> +M:	Kevin Tian <kevin.tian@intel.com>
> +L:	iommu@lists.linux-foundation.org
> +S:	Maintained
> +F:	Documentation/userspace-api/iommufd.rst
> +F:	drivers/iommu/iommufd/
> +F:	include/uapi/linux/iommufd.h
> +F:	include/linux/iommufd.h
> +
>  IOMAP FILESYSTEM LIBRARY
>  M:	Christoph Hellwig <hch@infradead.org>
>  M:	Darrick J. Wong <djwong@kernel.org>
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 3eb68fa1b8cc02..754d2a9ff64623 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -177,6 +177,7 @@ config MSM_IOMMU
>  
>  source "drivers/iommu/amd/Kconfig"
>  source "drivers/iommu/intel/Kconfig"
> +source "drivers/iommu/iommufd/Kconfig"
>  
>  config IRQ_REMAP
>  	bool "Support for Interrupt Remapping"
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index bc7f730edbb0be..6b38d12692b213 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> -obj-y += amd/ intel/ arm/
> +obj-y += amd/ intel/ arm/ iommufd/
>  obj-$(CONFIG_IOMMU_API) += iommu.o
>  obj-$(CONFIG_IOMMU_API) += iommu-traces.o
>  obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
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
> index 00000000000000..2d0bba3965be1a
> --- /dev/null
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -0,0 +1,95 @@
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
> +	struct file *filp;
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
> +/*
> + * The objects for an acyclic graph through the users refcount. This enum must
> + * be sorted by type depth first so that destruction completes lower objects and
> + * releases the users refcount before reaching higher objects in the graph.
> + */

A bit like my first comment I think this would benefit from an example
what lower/higher mean in this case. I believe a lower object must only
reference/depend on higher objects, correct?

> +enum iommufd_object_type {
> +	IOMMUFD_OBJ_NONE,
> +	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
> +	IOMMUFD_OBJ_MAX,
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
> +static inline void iommufd_put_object_keep_user(struct iommufd_object *obj)
> +{
> +	up_read(&obj->destroy_rwsem);
> +}
> +void iommufd_object_abort(struct iommufd_ctx *ictx, struct iommufd_object *obj);
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
> index 00000000000000..ae8db2f663004f
> --- /dev/null
> +++ b/drivers/iommu/iommufd/main.c
> @@ -0,0 +1,305 @@
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
> +	obj = kzalloc(size, GFP_KERNEL);
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
> +		      xa_limit_32b, GFP_KERNEL);
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

Not sure about the name here. Finalize kind of sounds like
destruction/going away. That might just be me though. Maybe having a
"..abort.." function, "commit" or "complete" come to mind.

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
> +struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
> +					  enum iommufd_object_type type)
> +{
> +	struct iommufd_object *obj;
> +
> +	xa_lock(&ictx->objects);
> +	obj = xa_load(&ictx->objects, id);
> +	if (!obj || (type != IOMMUFD_OBJ_ANY && obj->type != type) ||
> +	    !iommufd_lock_obj(obj))

Looking at the code it seems iommufd_lock_obj() locks against
destroy_rw_sem and increases the reference count but there is also an
iommufd_put_object_keep_user() which only unlocks the destroy_rw_sem. I
think I personally would benefit from a comment/commit message
explaining the lifecycle.

There is the below comment in iommufd_object_destroy_user() but I think
it would be better placed near the destroy_rwsem decleration and to
also explain the interaction between the destroy_rwsem and the
reference count.

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
> +
> +	iommufd_object_ops[obj->type].destroy(obj);
> +	up_write(&obj->destroy_rwsem);
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
> +	ictx = kzalloc(sizeof(*ictx), GFP_KERNEL);
> +	if (!ictx)
> +		return -ENOMEM;
> +
> +	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1);
> +	ictx->filp = filp;
> +	filp->private_data = ictx;
> +	return 0;
> +}
> +
> +static int iommufd_fops_release(struct inode *inode, struct file *filp)
> +{
> +	struct iommufd_ctx *ictx = filp->private_data;
> +	struct iommufd_object *obj;
> +	unsigned long index = 0;
> +	int cur = 0;
> +
> +	/* Destroy the graph from depth first */
> +	while (cur < IOMMUFD_OBJ_MAX) {
> +		xa_for_each(&ictx->objects, index, obj) {
> +			if (obj->type != cur)
> +				continue;
> +			xa_erase(&ictx->objects, index);
> +			if (WARN_ON(!refcount_dec_and_test(&obj->users)))

I think if this warning ever triggers it would be good to have a
comment here what it means. As I understand it this would mean that the
graph isn't acyclic and the types aren't in the correct order i.e. we
attempted to destroy a higher order object before a lower one?

> +				continue;
> +			iommufd_object_ops[obj->type].destroy(obj);
> +			kfree(obj);
> +		}
> +		cur++;
> +	}
> +	WARN_ON(!xa_empty(&ictx->objects));
> +	kfree(ictx);
> +	return 0;
> +}
> +
> 
---8<---


