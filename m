Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB3A78D980
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbjH3SdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243389AbjH3Kwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 06:52:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83032198
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 03:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693392768; x=1724928768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LKYQcQHOMOvKh9iQVujrZ29uLyWWbA45EUA3lP33byU=;
  b=j7DEZI5YUAdu/iLPt3TbCsri5K/K+UVCRrJNWq/V6iRRFiuKxIJRF5Wa
   ncF6azmzwoWXo45Als2M6TmWbAOgV6nzPjdNQy6UiWLpARVV85pZnU+XT
   cnlY1xliQ3I+btB4mXTkcCnSFfEbmVTodN82MrqItkuaqVeP2WtxhG8/G
   6jvbAZnr5SXL8ZkoP/u8Xtn6nkLhCzHkmAse1LuUPwYZApXq4Q3taTIKU
   Y2s2rSgGeNpRMqGVqTIkOinFWzvUIgeEmpz5bw0bHPPBJ2Dg0OIrGvzqr
   15h3EfJmlduPOEUzYDUYVSNxpOqMyfifth4SgfD0oCkwZSCTY+/0P27gq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="373016382"
X-IronPort-AV: E=Sophos;i="6.02,213,1688454000"; 
   d="scan'208,223";a="373016382"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 03:52:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="715865988"
X-IronPort-AV: E=Sophos;i="6.02,213,1688454000"; 
   d="scan'208,223";a="715865988"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.147])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 03:52:33 -0700
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     qemu-devel@nongnu.org
Cc:     alex.williamson@redhat.com, clg@redhat.com, jgg@nvidia.com,
        nicolinc@nvidia.com, joao.m.martins@oracle.com,
        eric.auger@redhat.com, peterx@redhat.com, jasowang@redhat.com,
        kevin.tian@intel.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        chao.p.peng@intel.com, Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH v1 02/22] Update linux-header to support iommufd cdev and hwpt alloc
Date:   Wed, 30 Aug 2023 18:37:34 +0800
Message-Id: <20230830103754.36461-3-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230830103754.36461-1-zhenzhong.duan@intel.com>
References: <20230830103754.36461-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git
branch: for_next
commit id: eb501c2d96cfce6b42528e8321ea085ec605e790

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
Note this is a placeholder patch.

 include/standard-headers/linux/fuse.h |   3 +
 linux-headers/linux/iommufd.h         | 444 ++++++++++++++++++++++++++
 linux-headers/linux/kvm.h             |  13 +-
 linux-headers/linux/vfio.h            | 148 ++++++++-
 4 files changed, 604 insertions(+), 4 deletions(-)
 create mode 100644 linux-headers/linux/iommufd.h

diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index 35c131a107..2c8b8de9c2 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -206,6 +206,7 @@
  *  - add extension header
  *  - add FUSE_EXT_GROUPS
  *  - add FUSE_CREATE_SUPP_GROUP
+ *  - add FUSE_HAS_EXPIRE_ONLY
  */
 
 #ifndef _LINUX_FUSE_H
@@ -365,6 +366,7 @@ struct fuse_file_lock {
  * FUSE_HAS_INODE_DAX:  use per inode DAX
  * FUSE_CREATE_SUPP_GROUP: add supplementary group info to create, mkdir,
  *			symlink and mknod (single group that matches parent)
+ * FUSE_HAS_EXPIRE_ONLY: kernel supports expiry-only entry invalidation
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -402,6 +404,7 @@ struct fuse_file_lock {
 #define FUSE_SECURITY_CTX	(1ULL << 32)
 #define FUSE_HAS_INODE_DAX	(1ULL << 33)
 #define FUSE_CREATE_SUPP_GROUP	(1ULL << 34)
+#define FUSE_HAS_EXPIRE_ONLY	(1ULL << 35)
 
 /**
  * CUSE INIT request/reply flags
diff --git a/linux-headers/linux/iommufd.h b/linux-headers/linux/iommufd.h
new file mode 100644
index 0000000000..218bf7ac98
--- /dev/null
+++ b/linux-headers/linux/iommufd.h
@@ -0,0 +1,444 @@
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
+ * The ioctl interface follows a general format to allow for extensibility. Each
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
+ *  - EOVERFLOW: Mathematics overflowed.
+ *
+ * As well as additional errnos, within specific ioctls.
+ */
+enum {
+	IOMMUFD_CMD_BASE = 0x80,
+	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
+	IOMMUFD_CMD_IOAS_ALLOC,
+	IOMMUFD_CMD_IOAS_ALLOW_IOVAS,
+	IOMMUFD_CMD_IOAS_COPY,
+	IOMMUFD_CMD_IOAS_IOVA_RANGES,
+	IOMMUFD_CMD_IOAS_MAP,
+	IOMMUFD_CMD_IOAS_UNMAP,
+	IOMMUFD_CMD_OPTION,
+	IOMMUFD_CMD_VFIO_IOAS,
+	IOMMUFD_CMD_HWPT_ALLOC,
+	IOMMUFD_CMD_GET_HW_INFO,
+};
+
+/**
+ * struct iommu_destroy - ioctl(IOMMU_DESTROY)
+ * @size: sizeof(struct iommu_destroy)
+ * @id: iommufd object ID to destroy. Can be any destroyable object type.
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
+ * struct iommu_iova_range - ioctl(IOMMU_IOVA_RANGE)
+ * @start: First IOVA
+ * @last: Inclusive last IOVA
+ *
+ * An interval in IOVA space.
+ */
+struct iommu_iova_range {
+	__aligned_u64 start;
+	__aligned_u64 last;
+};
+
+/**
+ * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
+ * @size: sizeof(struct iommu_ioas_iova_ranges)
+ * @ioas_id: IOAS ID to read ranges from
+ * @num_iovas: Input/Output total number of ranges in the IOAS
+ * @__reserved: Must be 0
+ * @allowed_iovas: Pointer to the output array of struct iommu_iova_range
+ * @out_iova_alignment: Minimum alignment required for mapping IOVA
+ *
+ * Query an IOAS for ranges of allowed IOVAs. Mapping IOVA outside these ranges
+ * is not allowed. num_iovas will be set to the total number of iovas and
+ * the allowed_iovas[] will be filled in as space permits.
+ *
+ * The allowed ranges are dependent on the HW path the DMA operation takes, and
+ * can change during the lifetime of the IOAS. A fresh empty IOAS will have a
+ * full range, and each attached device will narrow the ranges based on that
+ * device's HW restrictions. Detaching a device can widen the ranges. Userspace
+ * should query ranges after every attach/detach to know what IOVAs are valid
+ * for mapping.
+ *
+ * On input num_iovas is the length of the allowed_iovas array. On output it is
+ * the total number of iovas filled in. The ioctl will return -EMSGSIZE and set
+ * num_iovas to the required value if num_iovas is too small. In this case the
+ * caller should allocate a larger output array and re-issue the ioctl.
+ *
+ * out_iova_alignment returns the minimum IOVA alignment that can be given
+ * to IOMMU_IOAS_MAP/COPY. IOVA's must satisfy::
+ *
+ *   starting_iova % out_iova_alignment == 0
+ *   (starting_iova + length) % out_iova_alignment == 0
+ *
+ * out_iova_alignment can be 1 indicating any IOVA is allowed. It cannot
+ * be higher than the system PAGE_SIZE.
+ */
+struct iommu_ioas_iova_ranges {
+	__u32 size;
+	__u32 ioas_id;
+	__u32 num_iovas;
+	__u32 __reserved;
+	__aligned_u64 allowed_iovas;
+	__aligned_u64 out_iova_alignment;
+};
+#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IOVA_RANGES)
+
+/**
+ * struct iommu_ioas_allow_iovas - ioctl(IOMMU_IOAS_ALLOW_IOVAS)
+ * @size: sizeof(struct iommu_ioas_allow_iovas)
+ * @ioas_id: IOAS ID to allow IOVAs from
+ * @num_iovas: Input/Output total number of ranges in the IOAS
+ * @__reserved: Must be 0
+ * @allowed_iovas: Pointer to array of struct iommu_iova_range
+ *
+ * Ensure a range of IOVAs are always available for allocation. If this call
+ * succeeds then IOMMU_IOAS_IOVA_RANGES will never return a list of IOVA ranges
+ * that are narrower than the ranges provided here. This call will fail if
+ * IOMMU_IOAS_IOVA_RANGES is currently narrower than the given ranges.
+ *
+ * When an IOAS is first created the IOVA_RANGES will be maximally sized, and as
+ * devices are attached the IOVA will narrow based on the device restrictions.
+ * When an allowed range is specified any narrowing will be refused, ie device
+ * attachment can fail if the device requires limiting within the allowed range.
+ *
+ * Automatic IOVA allocation is also impacted by this call. MAP will only
+ * allocate within the allowed IOVAs if they are present.
+ *
+ * This call replaces the entire allowed list with the given list.
+ */
+struct iommu_ioas_allow_iovas {
+	__u32 size;
+	__u32 ioas_id;
+	__u32 num_iovas;
+	__u32 __reserved;
+	__aligned_u64 allowed_iovas;
+};
+#define IOMMU_IOAS_ALLOW_IOVAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_ALLOW_IOVAS)
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
+ * mapping will be established at iova, otherwise a suitable location based on
+ * the reserved and allowed lists will be automatically selected and returned in
+ * iova.
+ *
+ * If IOMMU_IOAS_MAP_FIXED_IOVA is specified then the iova range must currently
+ * be unused, existing IOVA cannot be replaced.
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
+ *
+ * This may be used to efficiently clone a subset of an IOAS to another, or as a
+ * kind of 'cache' to speed up mapping. Copy has an efficiency advantage over
+ * establishing equivalent new mappings, as internal resources are shared, and
+ * the kernel will pin the user memory only once.
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
+ * @size: sizeof(struct iommu_ioas_unmap)
+ * @ioas_id: IOAS ID to change the mapping of
+ * @iova: IOVA to start the unmapping at
+ * @length: Number of bytes to unmap, and return back the bytes unmapped
+ *
+ * Unmap an IOVA range. The iova/length must be a superset of a previously
+ * mapped range used with IOMMU_IOAS_MAP or IOMMU_IOAS_COPY. Splitting or
+ * truncating ranges is not allowed. The values 0 to U64_MAX will unmap
+ * everything.
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
+ * enum iommufd_option - ioctl(IOMMU_OPTION_RLIMIT_MODE) and
+ *                       ioctl(IOMMU_OPTION_HUGE_PAGES)
+ * @IOMMU_OPTION_RLIMIT_MODE:
+ *    Change how RLIMIT_MEMLOCK accounting works. The caller must have privilege
+ *    to invoke this. Value 0 (default) is user based accouting, 1 uses process
+ *    based accounting. Global option, object_id must be 0
+ * @IOMMU_OPTION_HUGE_PAGES:
+ *    Value 1 (default) allows contiguous pages to be combined when generating
+ *    iommu mappings. Value 0 disables combining, everything is mapped to
+ *    PAGE_SIZE. This can be useful for benchmarking.  This is a per-IOAS
+ *    option, the object_id must be the IOAS ID.
+ */
+enum iommufd_option {
+	IOMMU_OPTION_RLIMIT_MODE = 0,
+	IOMMU_OPTION_HUGE_PAGES = 1,
+};
+
+/**
+ * enum iommufd_option_ops - ioctl(IOMMU_OPTION_OP_SET) and
+ *                           ioctl(IOMMU_OPTION_OP_GET)
+ * @IOMMU_OPTION_OP_SET: Set the option's value
+ * @IOMMU_OPTION_OP_GET: Get the option's value
+ */
+enum iommufd_option_ops {
+	IOMMU_OPTION_OP_SET = 0,
+	IOMMU_OPTION_OP_GET = 1,
+};
+
+/**
+ * struct iommu_option - iommu option multiplexer
+ * @size: sizeof(struct iommu_option)
+ * @option_id: One of enum iommufd_option
+ * @op: One of enum iommufd_option_ops
+ * @__reserved: Must be 0
+ * @object_id: ID of the object if required
+ * @val64: Option value to set or value returned on get
+ *
+ * Change a simple option value. This multiplexor allows controlling options
+ * on objects. IOMMU_OPTION_OP_SET will load an option and IOMMU_OPTION_OP_GET
+ * will return the current value.
+ */
+struct iommu_option {
+	__u32 size;
+	__u32 option_id;
+	__u16 op;
+	__u16 __reserved;
+	__u32 object_id;
+	__aligned_u64 val64;
+};
+#define IOMMU_OPTION _IO(IOMMUFD_TYPE, IOMMUFD_CMD_OPTION)
+
+/**
+ * enum iommufd_vfio_ioas_op - IOMMU_VFIO_IOAS_* ioctls
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
+ * @size: sizeof(struct iommu_vfio_ioas)
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
+
+/**
+ * struct iommu_hwpt_alloc - ioctl(IOMMU_HWPT_ALLOC)
+ * @size: sizeof(struct iommu_hwpt_alloc)
+ * @flags: Must be 0
+ * @dev_id: The device to allocate this HWPT for
+ * @pt_id: The IOAS to connect this HWPT to
+ * @out_hwpt_id: The ID of the new HWPT
+ * @__reserved: Must be 0
+ *
+ * Explicitly allocate a hardware page table object. This is the same object
+ * type that is returned by iommufd_device_attach() and represents the
+ * underlying iommu driver's iommu_domain kernel object.
+ *
+ * A HWPT will be created with the IOVA mappings from the given IOAS.
+ */
+struct iommu_hwpt_alloc {
+	__u32 size;
+	__u32 flags;
+	__u32 dev_id;
+	__u32 pt_id;
+	__u32 out_hwpt_id;
+	__u32 __reserved;
+};
+#define IOMMU_HWPT_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_ALLOC)
+
+/**
+ * struct iommu_hw_info_vtd - Intel VT-d hardware information
+ *
+ * @flags: Must be 0
+ * @__reserved: Must be 0
+ *
+ * @cap_reg: Value of Intel VT-d capability register defined in VT-d spec
+ *           section 11.4.2 Capability Register.
+ * @ecap_reg: Value of Intel VT-d capability register defined in VT-d spec
+ *            section 11.4.3 Extended Capability Register.
+ *
+ * User needs to understand the Intel VT-d specification to decode the
+ * register value.
+ */
+struct iommu_hw_info_vtd {
+	__u32 flags;
+	__u32 __reserved;
+	__aligned_u64 cap_reg;
+	__aligned_u64 ecap_reg;
+};
+
+/**
+ * enum iommu_hw_info_type - IOMMU Hardware Info Types
+ * @IOMMU_HW_INFO_TYPE_NONE: Used by the drivers that do not report hardware
+ *                           info
+ * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
+ */
+enum iommu_hw_info_type {
+	IOMMU_HW_INFO_TYPE_NONE,
+	IOMMU_HW_INFO_TYPE_INTEL_VTD,
+};
+
+/**
+ * struct iommu_hw_info - ioctl(IOMMU_GET_HW_INFO)
+ * @size: sizeof(struct iommu_hw_info)
+ * @flags: Must be 0
+ * @dev_id: The device bound to the iommufd
+ * @data_len: Input the length of a user buffer in bytes. Output the length of
+ *            data that kernel supports
+ * @data_uptr: User pointer to a user-space buffer used by the kernel to fill
+ *             the iommu type specific hardware information data
+ * @out_data_type: Output the iommu hardware info type as defined in the enum
+ *                 iommu_hw_info_type.
+ * @__reserved: Must be 0
+ *
+ * Query an iommu type specific hardware information data from an iommu behind
+ * a given device that has been bound to iommufd. This hardware info data will
+ * be used to sync capabilities between the virtual iommu and the physical
+ * iommu, e.g. a nested translation setup needs to check the hardware info, so
+ * a guest stage-1 page table can be compatible with the physical iommu.
+ *
+ * To capture an iommu type specific hardware information data, @data_uptr and
+ * its length @data_len must be provided. Trailing bytes will be zeroed if the
+ * user buffer is larger than the data that kernel has. Otherwise, kernel only
+ * fills the buffer using the given length in @data_len. If the ioctl succeeds,
+ * @data_len will be updated to the length that kernel actually supports,
+ * @out_data_type will be filled to decode the data filled in the buffer
+ * pointed by @data_uptr. Input @data_len == zero is allowed.
+ */
+struct iommu_hw_info {
+	__u32 size;
+	__u32 flags;
+	__u32 dev_id;
+	__u32 data_len;
+	__aligned_u64 data_uptr;
+	__u32 out_data_type;
+	__u32 __reserved;
+};
+#define IOMMU_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_GET_HW_INFO)
+#endif
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 1f3f3333a4..0d74ee999a 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1414,9 +1414,16 @@ struct kvm_device_attr {
 	__u64	addr;		/* userspace address of attr data */
 };
 
-#define  KVM_DEV_VFIO_GROUP			1
-#define   KVM_DEV_VFIO_GROUP_ADD			1
-#define   KVM_DEV_VFIO_GROUP_DEL			2
+#define  KVM_DEV_VFIO_FILE			1
+
+#define   KVM_DEV_VFIO_FILE_ADD			1
+#define   KVM_DEV_VFIO_FILE_DEL			2
+
+/* KVM_DEV_VFIO_GROUP aliases are for compile time uapi compatibility */
+#define  KVM_DEV_VFIO_GROUP	KVM_DEV_VFIO_FILE
+
+#define   KVM_DEV_VFIO_GROUP_ADD	KVM_DEV_VFIO_FILE_ADD
+#define   KVM_DEV_VFIO_GROUP_DEL	KVM_DEV_VFIO_FILE_DEL
 #define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE		3
 
 enum kvm_device_type {
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 16db89071e..7326ace436 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -677,11 +677,60 @@ enum {
  * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
  *					      struct vfio_pci_hot_reset_info)
  *
+ * This command is used to query the affected devices in the hot reset for
+ * a given device.
+ *
+ * This command always reports the segment, bus, and devfn information for
+ * each affected device, and selectively reports the group_id or devid per
+ * the way how the calling device is opened.
+ *
+ *	- If the calling device is opened via the traditional group/container
+ *	  API, group_id is reported.  User should check if it has owned all
+ *	  the affected devices and provides a set of group fds to prove the
+ *	  ownership in VFIO_DEVICE_PCI_HOT_RESET ioctl.
+ *
+ *	- If the calling device is opened as a cdev, devid is reported.
+ *	  Flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set to indicate this
+ *	  data type.  All the affected devices should be represented in
+ *	  the dev_set, ex. bound to a vfio driver, and also be owned by
+ *	  this interface which is determined by the following conditions:
+ *	  1) Has a valid devid within the iommufd_ctx of the calling device.
+ *	     Ownership cannot be determined across separate iommufd_ctx and
+ *	     the cdev calling conventions do not support a proof-of-ownership
+ *	     model as provided in the legacy group interface.  In this case
+ *	     valid devid with value greater than zero is provided in the return
+ *	     structure.
+ *	  2) Does not have a valid devid within the iommufd_ctx of the calling
+ *	     device, but belongs to the same IOMMU group as the calling device
+ *	     or another opened device that has a valid devid within the
+ *	     iommufd_ctx of the calling device.  This provides implicit ownership
+ *	     for devices within the same DMA isolation context.  In this case
+ *	     the devid value of VFIO_PCI_DEVID_OWNED is provided in the return
+ *	     structure.
+ *
+ *	  A devid value of VFIO_PCI_DEVID_NOT_OWNED is provided in the return
+ *	  structure for affected devices where device is NOT represented in the
+ *	  dev_set or ownership is not available.  Such devices prevent the use
+ *	  of VFIO_DEVICE_PCI_HOT_RESET ioctl outside of the proof-of-ownership
+ *	  calling conventions (ie. via legacy group accessed devices).  Flag
+ *	  VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED would be set when all the
+ *	  affected devices are represented in the dev_set and also owned by
+ *	  the user.  This flag is available only when
+ *	  flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
+ *	  When set, user could invoke VFIO_DEVICE_PCI_HOT_RESET with a zero
+ *	  length fd array on the calling device as the ownership is validated
+ *	  by iommufd_ctx.
+ *
  * Return: 0 on success, -errno on failure:
  *	-enospc = insufficient buffer, -enodev = unsupported for device.
  */
 struct vfio_pci_dependent_device {
-	__u32	group_id;
+	union {
+		__u32   group_id;
+		__u32	devid;
+#define VFIO_PCI_DEVID_OWNED		0
+#define VFIO_PCI_DEVID_NOT_OWNED	-1
+	};
 	__u16	segment;
 	__u8	bus;
 	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
@@ -690,6 +739,8 @@ struct vfio_pci_dependent_device {
 struct vfio_pci_hot_reset_info {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID		(1 << 0)
+#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED	(1 << 1)
 	__u32	count;
 	struct vfio_pci_dependent_device	devices[];
 };
@@ -700,6 +751,24 @@ struct vfio_pci_hot_reset_info {
  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
  *				    struct vfio_pci_hot_reset)
  *
+ * A PCI hot reset results in either a bus or slot reset which may affect
+ * other devices sharing the bus/slot.  The calling user must have
+ * ownership of the full set of affected devices as determined by the
+ * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl.
+ *
+ * When called on a device file descriptor acquired through the vfio
+ * group interface, the user is required to provide proof of ownership
+ * of those affected devices via the group_fds array in struct
+ * vfio_pci_hot_reset.
+ *
+ * When called on a direct cdev opened vfio device, the flags field of
+ * struct vfio_pci_hot_reset_info reports the ownership status of the
+ * affected devices and this ioctl must be called with an empty group_fds
+ * array.  See above INFO ioctl definition for ownership requirements.
+ *
+ * Mixed usage of legacy groups and cdevs across the set of affected
+ * devices is not supported.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_pci_hot_reset {
@@ -828,6 +897,83 @@ struct vfio_device_feature {
 
 #define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
 
+/*
+ * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
+ *				   struct vfio_device_bind_iommufd)
+ * @argsz:	 User filled size of this data.
+ * @flags:	 Must be 0.
+ * @iommufd:	 iommufd to bind.
+ * @out_devid:	 The device id generated by this bind. devid is a handle for
+ *		 this device/iommufd bond and can be used in IOMMUFD commands.
+ *
+ * Bind a vfio_device to the specified iommufd.
+ *
+ * User is restricted from accessing the device before the binding operation
+ * is completed.  Only allowed on cdev fds.
+ *
+ * Unbind is automatically conducted when device fd is closed.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_bind_iommufd {
+	__u32		argsz;
+	__u32		flags;
+	__s32		iommufd;
+	__u32		out_devid;
+};
+
+#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)
+
+/*
+ * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 19,
+ *					struct vfio_device_attach_iommufd_pt)
+ * @argsz:	User filled size of this data.
+ * @flags:	Must be 0.
+ * @pt_id:	Input the target id which can represent an ioas or a hwpt
+ *		allocated via iommufd subsystem.
+ *		Output the input ioas id or the attached hwpt id which could
+ *		be the specified hwpt itself or a hwpt automatically created
+ *		for the specified ioas by kernel during the attachment.
+ *
+ * Associate the device with an address space within the bound iommufd.
+ * Undo by VFIO_DEVICE_DETACH_IOMMUFD_PT or device fd close.  This is only
+ * allowed on cdev fds.
+ *
+ * If a vfio device is currently attached to a valid hw_pagetable, without doing
+ * a VFIO_DEVICE_DETACH_IOMMUFD_PT, a second VFIO_DEVICE_ATTACH_IOMMUFD_PT ioctl
+ * passing in another hw_pagetable (hwpt) id is allowed. This action, also known
+ * as a hw_pagetable replacement, will replace the device's currently attached
+ * hw_pagetable with a new hw_pagetable corresponding to the given pt_id.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_attach_iommufd_pt {
+	__u32	argsz;
+	__u32	flags;
+	__u32	pt_id;
+};
+
+#define VFIO_DEVICE_ATTACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 19)
+
+/*
+ * VFIO_DEVICE_DETACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 20,
+ *					struct vfio_device_detach_iommufd_pt)
+ * @argsz:	User filled size of this data.
+ * @flags:	Must be 0.
+ *
+ * Remove the association of the device and its current associated address
+ * space.  After it, the device should be in a blocking DMA state.  This is only
+ * allowed on cdev fds.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_detach_iommufd_pt {
+	__u32	argsz;
+	__u32	flags;
+};
+
+#define VFIO_DEVICE_DETACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 20)
+
 /*
  * Provide support for setting a PCI VF Token, which is used as a shared
  * secret between PF and VF drivers.  This feature may only be set on a
-- 
2.34.1

