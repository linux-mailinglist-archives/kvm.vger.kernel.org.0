Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3385543075
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbiFHMbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiFHMbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:31:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE04B24C08B
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654691501; x=1686227501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5qWRnjvGyNwaSgv5oXZe2n49XMKJfJ+r4yqF2S9an0k=;
  b=MQGS0L+kItbh7H6+JvKVwWjw1o3fsmQgdTBW/1iKK4AxDo6qNeCrqS0S
   nnLQVULwMEGaMx0zrrSLCWJ9kk5HiVqQLq0HCp4DoeVz/g4ubpplZarrI
   w812TtJxwKJC5C/UvPbRvAwPAPdjEz8l2lhkWW85jWao/Q3V8IDDO5k/3
   +YuwsoAkUdhanORuC4N3gbHOTI5Id49jN7JEWGx/OXN0Khcm0XUPwzk1j
   1qqiwew+XuBuH5oY5UA3acNDClmNtQkJQTnU9YIg9TKObN//NT5W0BhVt
   WnDymyAg+XhWQsVc7BpTXTuePqRPLbF/theSrZIamvhuZR7N5xI7Z+xyd
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302237985"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="302237985"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:31:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="670529709"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jun 2022 05:31:40 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com
Subject: [RFC v2 02/15] linux-headers: Import latest vfio.h and iommufd.h
Date:   Wed,  8 Jun 2022 05:31:26 -0700
Message-Id: <20220608123139.19356-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220608123139.19356-1-yi.l.liu@intel.com>
References: <20220608123139.19356-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Imported from https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 linux-headers/linux/iommufd.h | 223 ++++++++++++++++++++++++++++++++++
 linux-headers/linux/vfio.h    |  84 +++++++++++++
 2 files changed, 307 insertions(+)
 create mode 100644 linux-headers/linux/iommufd.h

diff --git a/linux-headers/linux/iommufd.h b/linux-headers/linux/iommufd.h
new file mode 100644
index 0000000000..6c3cd9e259
--- /dev/null
+++ b/linux-headers/linux/iommufd.h
@@ -0,0 +1,223 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
+ */
+#ifndef _IOMMUFD_H
+#define _IOMMUFD_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define IOMMUFD_TYPE (';')
+
+/**
+ * DOC: General ioctl format
+ *
+ * The ioctl mechanims follows a general format to allow for extensibility. Each
+ * ioctl is passed in a structure pointer as the argument providing the size of
+ * the structure in the first u32. The kernel checks that any structure space
+ * beyond what it understands is 0. This allows userspace to use the backward
+ * compatible portion while consistently using the newer, larger, structures.
+ *
+ * ioctls use a standard meaning for common errnos:
+ *
+ *  - ENOTTY: The IOCTL number itself is not supported at all
+ *  - E2BIG: The IOCTL number is supported, but the provided structure has
+ *    non-zero in a part the kernel does not understand.
+ *  - EOPNOTSUPP: The IOCTL number is supported, and the structure is
+ *    understood, however a known field has a value the kernel does not
+ *    understand or support.
+ *  - EINVAL: Everything about the IOCTL was understood, but a field is not
+ *    correct.
+ *  - ENOENT: An ID or IOVA provided does not exist.
+ *  - ENOMEM: Out of memory.
+ *  - EOVERFLOW: Mathematics oveflowed.
+ *
+ * As well as additional errnos. within specific ioctls.
+ */
+enum {
+	IOMMUFD_CMD_BASE = 0x80,
+	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
+	IOMMUFD_CMD_IOAS_ALLOC,
+	IOMMUFD_CMD_IOAS_IOVA_RANGES,
+	IOMMUFD_CMD_IOAS_MAP,
+	IOMMUFD_CMD_IOAS_COPY,
+	IOMMUFD_CMD_IOAS_UNMAP,
+	IOMMUFD_CMD_VFIO_IOAS,
+};
+
+/**
+ * struct iommu_destroy - ioctl(IOMMU_DESTROY)
+ * @size: sizeof(struct iommu_destroy)
+ * @id: iommufd object ID to destroy. Can by any destroyable object type.
+ *
+ * Destroy any object held within iommufd.
+ */
+struct iommu_destroy {
+	__u32 size;
+	__u32 id;
+};
+#define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)
+
+/**
+ * struct iommu_ioas_alloc - ioctl(IOMMU_IOAS_ALLOC)
+ * @size: sizeof(struct iommu_ioas_alloc)
+ * @flags: Must be 0
+ * @out_ioas_id: Output IOAS ID for the allocated object
+ *
+ * Allocate an IO Address Space (IOAS) which holds an IO Virtual Address (IOVA)
+ * to memory mapping.
+ */
+struct iommu_ioas_alloc {
+	__u32 size;
+	__u32 flags;
+	__u32 out_ioas_id;
+};
+#define IOMMU_IOAS_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_ALLOC)
+
+/**
+ * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
+ * @size: sizeof(struct iommu_ioas_iova_ranges)
+ * @ioas_id: IOAS ID to read ranges from
+ * @out_num_iovas: Output total number of ranges in the IOAS
+ * @__reserved: Must be 0
+ * @out_valid_iovas: Array of valid IOVA ranges. The array length is the smaller
+ *                   of out_num_iovas or the length implied by size.
+ * @out_valid_iovas.start: First IOVA in the allowed range
+ * @out_valid_iovas.last: Inclusive last IOVA in the allowed range
+ *
+ * Query an IOAS for ranges of allowed IOVAs. Operation outside these ranges is
+ * not allowed. out_num_iovas will be set to the total number of iovas
+ * and the out_valid_iovas[] will be filled in as space permits.
+ * size should include the allocated flex array.
+ */
+struct iommu_ioas_iova_ranges {
+	__u32 size;
+	__u32 ioas_id;
+	__u32 out_num_iovas;
+	__u32 __reserved;
+	struct iommu_valid_iovas {
+		__aligned_u64 start;
+		__aligned_u64 last;
+	} out_valid_iovas[];
+};
+#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IOVA_RANGES)
+
+/**
+ * enum iommufd_ioas_map_flags - Flags for map and copy
+ * @IOMMU_IOAS_MAP_FIXED_IOVA: If clear the kernel will compute an appropriate
+ *                             IOVA to place the mapping at
+ * @IOMMU_IOAS_MAP_WRITEABLE: DMA is allowed to write to this mapping
+ * @IOMMU_IOAS_MAP_READABLE: DMA is allowed to read from this mapping
+ */
+enum iommufd_ioas_map_flags {
+	IOMMU_IOAS_MAP_FIXED_IOVA = 1 << 0,
+	IOMMU_IOAS_MAP_WRITEABLE = 1 << 1,
+	IOMMU_IOAS_MAP_READABLE = 1 << 2,
+};
+
+/**
+ * struct iommu_ioas_map - ioctl(IOMMU_IOAS_MAP)
+ * @size: sizeof(struct iommu_ioas_map)
+ * @flags: Combination of enum iommufd_ioas_map_flags
+ * @ioas_id: IOAS ID to change the mapping of
+ * @__reserved: Must be 0
+ * @user_va: Userspace pointer to start mapping from
+ * @length: Number of bytes to map
+ * @iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IOVA is set
+ *        then this must be provided as input.
+ *
+ * Set an IOVA mapping from a user pointer. If FIXED_IOVA is specified then the
+ * mapping will be established at iova, otherwise a suitable location will be
+ * automatically selected and returned in iova.
+ */
+struct iommu_ioas_map {
+	__u32 size;
+	__u32 flags;
+	__u32 ioas_id;
+	__u32 __reserved;
+	__aligned_u64 user_va;
+	__aligned_u64 length;
+	__aligned_u64 iova;
+};
+#define IOMMU_IOAS_MAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_MAP)
+
+/**
+ * struct iommu_ioas_copy - ioctl(IOMMU_IOAS_COPY)
+ * @size: sizeof(struct iommu_ioas_copy)
+ * @flags: Combination of enum iommufd_ioas_map_flags
+ * @dst_ioas_id: IOAS ID to change the mapping of
+ * @src_ioas_id: IOAS ID to copy from
+ * @length: Number of bytes to copy and map
+ * @dst_iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IOVA is
+ *            set then this must be provided as input.
+ * @src_iova: IOVA to start the copy
+ *
+ * Copy an already existing mapping from src_ioas_id and establish it in
+ * dst_ioas_id. The src iova/length must exactly match a range used with
+ * IOMMU_IOAS_MAP.
+ */
+struct iommu_ioas_copy {
+	__u32 size;
+	__u32 flags;
+	__u32 dst_ioas_id;
+	__u32 src_ioas_id;
+	__aligned_u64 length;
+	__aligned_u64 dst_iova;
+	__aligned_u64 src_iova;
+};
+#define IOMMU_IOAS_COPY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_COPY)
+
+/**
+ * struct iommu_ioas_unmap - ioctl(IOMMU_IOAS_UNMAP)
+ * @size: sizeof(struct iommu_ioas_copy)
+ * @ioas_id: IOAS ID to change the mapping of
+ * @iova: IOVA to start the unmapping at
+ * @length: Number of bytes to unmap
+ *
+ * Unmap an IOVA range. The iova/length must exactly match a range
+ * used with IOMMU_IOAS_PAGETABLE_MAP, or be the values 0 & U64_MAX.
+ * In the latter case all IOVAs will be unmaped.
+ */
+struct iommu_ioas_unmap {
+	__u32 size;
+	__u32 ioas_id;
+	__aligned_u64 iova;
+	__aligned_u64 length;
+};
+#define IOMMU_IOAS_UNMAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP)
+
+/**
+ * enum iommufd_vfio_ioas_op
+ * @IOMMU_VFIO_IOAS_GET: Get the current compatibility IOAS
+ * @IOMMU_VFIO_IOAS_SET: Change the current compatibility IOAS
+ * @IOMMU_VFIO_IOAS_CLEAR: Disable VFIO compatibility
+ */
+enum iommufd_vfio_ioas_op {
+	IOMMU_VFIO_IOAS_GET = 0,
+	IOMMU_VFIO_IOAS_SET = 1,
+	IOMMU_VFIO_IOAS_CLEAR = 2,
+};
+
+/**
+ * struct iommu_vfio_ioas - ioctl(IOMMU_VFIO_IOAS)
+ * @size: sizeof(struct iommu_ioas_copy)
+ * @ioas_id: For IOMMU_VFIO_IOAS_SET the input IOAS ID to set
+ *           For IOMMU_VFIO_IOAS_GET will output the IOAS ID
+ * @op: One of enum iommufd_vfio_ioas_op
+ * @__reserved: Must be 0
+ *
+ * The VFIO compatibility support uses a single ioas because VFIO APIs do not
+ * support the ID field. Set or Get the IOAS that VFIO compatibility will use.
+ * When VFIO_GROUP_SET_CONTAINER is used on an iommufd it will get the
+ * compatibility ioas, either by taking what is already set, or auto creating
+ * one. From then on VFIO will continue to use that ioas and is not effected by
+ * this ioctl. SET or CLEAR does not destroy any auto-created IOAS.
+ */
+struct iommu_vfio_ioas {
+	__u32 size;
+	__u32 ioas_id;
+	__u16 op;
+	__u16 __reserved;
+};
+#define IOMMU_VFIO_IOAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VFIO_IOAS)
+#endif
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index e9f7795c39..d1aa1ccd9f 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -190,6 +190,90 @@ struct vfio_group_status {
 
 /* --------------- IOCTLs for DEVICE file descriptors --------------- */
 
+/*
+ * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
+ *				struct vfio_device_bind_iommufd)
+ *
+ * Bind a vfio_device to the specified iommufd
+ *
+ * The user should provide a device cookie when calling this ioctl. The
+ * cookie is carried only in event e.g. I/O fault reported to userspace
+ * via iommufd. The user should use devid returned by this ioctl to mark
+ * the target device in other ioctls (e.g. capability query via iommufd).
+ *
+ * User is not allowed to access the device before the binding operation
+ * is completed.
+ *
+ * Unbind is automatically conducted when device fd is closed.
+ *
+ * Input parameters:
+ *	- iommufd;
+ *	- dev_cookie;
+ *
+ * Output parameters:
+ *	- devid;
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_bind_iommufd {
+	__u32		argsz;
+	__u32		flags;
+	__aligned_u64	dev_cookie;
+	__s32		iommufd;
+	__u32		out_devid;
+};
+
+#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
+
+/*
+ * VFIO_DEVICE_ATTACH_IOAS - _IOW(VFIO_TYPE, VFIO_BASE + 21,
+ *				  struct vfio_device_attach_ioas)
+ *
+ * Attach a vfio device to the specified IOAS.
+ *
+ * Multiple vfio devices can be attached to the same IOAS Page Table. One
+ * device can be attached to only one ioas at this point.
+ *
+ * @argsz:	user filled size of this data.
+ * @flags:	reserved for future extension.
+ * @iommufd:	iommufd where the ioas comes from.
+ * @ioas_id:	Input the target I/O address space page table.
+ * @hwpt_id:	Output the hw page table id
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_attach_ioas {
+	__u32	argsz;
+	__u32	flags;
+	__s32	iommufd;
+	__u32	ioas_id;
+	__u32	out_hwpt_id;
+};
+
+#define VFIO_DEVICE_ATTACH_IOAS	_IO(VFIO_TYPE, VFIO_BASE + 20)
+
+/*
+ * VFIO_DEVICE_DETACH_IOAS - _IOW(VFIO_TYPE, VFIO_BASE + 21,
+ *				  struct vfio_device_detach_ioas)
+ *
+ * Detach a vfio device from the specified IOAS.
+ *
+ * @argsz:	user filled size of this data.
+ * @flags:	reserved for future extension.
+ * @iommufd:	iommufd where the ioas comes from.
+ * @ioas_id:	Input the target I/O address space page table.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_detach_ioas {
+	__u32	argsz;
+	__u32	flags;
+	__s32	iommufd;
+	__u32	ioas_id;
+};
+
+#define VFIO_DEVICE_DETACH_IOAS	_IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /**
  * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
  *						struct vfio_device_info)
-- 
2.27.0

