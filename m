Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D250C6D3249
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 17:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjDAPTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 11:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjDAPS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 11:18:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C6926254;
        Sat,  1 Apr 2023 08:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680362332; x=1711898332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B99jEbLR0tNkpukHQr/yNPobSRf3EINVeCE8niNa5rI=;
  b=E1E6HZzLtlqm/VrwdhPNtF8bH/AVgU0Sahf0CAo3q5glvlBIfX+FU1VV
   8MIHFZQ6VH4rg5xUV/NUeX/VQIi5RlsFwoTRZVWvBEdbyTq2VghfobOPd
   YeHzPfQgnyv67eXb8xfqM6dZhh4ny8oGdOUHSyW+m361Ur0jv4MmF0PzX
   c2SYRXoeh9aP9GewAy22Jfd0Xbm3nUJBKqgRZ9H3eWRm6m4xBpjyXIT2D
   OaTSPEmwo0HWqI9KlV0BqtQj7Myjq4DVNQsYltY/6hymuPhUOBSyPqBIk
   bdojCnKQSx2rbC3AI9xVImRSTql3qvlvyCjuNjU0byj8fNRxiL9sGcxuD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="404411409"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404411409"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 08:18:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="678937239"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="678937239"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2023 08:18:49 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: [PATCH v9 24/25] vfio: Compile group optionally
Date:   Sat,  1 Apr 2023 08:18:32 -0700
Message-Id: <20230401151833.124749-25-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401151833.124749-1-yi.l.liu@intel.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

group code is not needed for vfio device cdev, so with vfio device cdev
introduced, the group infrastructures can be compiled out if only cdev
is needed.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/Kconfig |   4 +-
 drivers/vfio/Kconfig          |  14 +++++
 drivers/vfio/Makefile         |   2 +-
 drivers/vfio/vfio.h           | 111 ++++++++++++++++++++++++++++++++--
 include/linux/vfio.h          |  13 +++-
 5 files changed, 133 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index ada693ea51a7..99d4b075df49 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -14,8 +14,8 @@ config IOMMUFD
 if IOMMUFD
 config IOMMUFD_VFIO_CONTAINER
 	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
-	depends on VFIO && !VFIO_CONTAINER
-	default VFIO && !VFIO_CONTAINER
+	depends on VFIO_GROUP && !VFIO_CONTAINER
+	default VFIO_GROUP && !VFIO_CONTAINER
 	help
 	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
 	  IOMMUFD providing compatibility emulation to give the same ioctls.
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index e2105b4dac2d..62c58830a8d5 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -4,6 +4,8 @@ menuconfig VFIO
 	select IOMMU_API
 	depends on IOMMUFD || !IOMMUFD
 	select INTERVAL_TREE
+	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
+	select VFIO_DEVICE_CDEV if !VFIO_GROUP
 	select VFIO_CONTAINER if IOMMUFD=n
 	help
 	  VFIO provides a framework for secure userspace device drivers.
@@ -15,6 +17,7 @@ if VFIO
 config VFIO_DEVICE_CDEV
 	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
 	depends on IOMMUFD
+	default !VFIO_GROUP
 	help
 	  The VFIO device cdev is another way for userspace to get device
 	  access. Userspace gets device fd by opening device cdev under
@@ -23,9 +26,20 @@ config VFIO_DEVICE_CDEV
 
 	  If you don't know what to do here, say N.
 
+config VFIO_GROUP
+	bool "Support for the VFIO group /dev/vfio/$group_id"
+	default y
+	help
+	   VFIO group support provides the traditional model for accessing
+	   devices through VFIO and is used by the majority of userspace
+	   applications and drivers making use of VFIO.
+
+	   If you don't know what to do here, say Y.
+
 config VFIO_CONTAINER
 	bool "Support for the VFIO container /dev/vfio/vfio"
 	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
+	depends on VFIO_GROUP
 	default y
 	help
 	  The VFIO container is the classic interface to VFIO for establishing
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 245394aeb94b..57c3515af606 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -2,9 +2,9 @@
 obj-$(CONFIG_VFIO) += vfio.o
 
 vfio-y += vfio_main.o \
-	  group.o \
 	  iova_bitmap.o
 vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
+vfio-$(CONFIG_VFIO_GROUP) += group.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
 vfio-$(CONFIG_VFIO_CONTAINER) += container.o
 vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index c199e410db18..9c7a238ec8dd 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -36,6 +36,12 @@ vfio_allocate_device_file(struct vfio_device *device);
 
 extern const struct file_operations vfio_device_fops;
 
+#ifdef CONFIG_VFIO_NOIOMMU
+extern bool vfio_noiommu __read_mostly;
+#else
+enum { vfio_noiommu = false };
+#endif
+
 enum vfio_group_type {
 	/*
 	 * Physical device with IOMMU backing.
@@ -60,6 +66,7 @@ enum vfio_group_type {
 	VFIO_NO_IOMMU,
 };
 
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
 struct vfio_group {
 	struct device 			dev;
 	struct cdev			cdev;
@@ -113,6 +120,104 @@ static inline void vfio_device_set_noiommu(struct vfio_device *device)
 	device->noiommu = IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
 			  device->group->type == VFIO_NO_IOMMU;
 }
+#else
+struct vfio_group;
+
+static inline int vfio_device_block_group(struct vfio_device *device)
+{
+	return 0;
+}
+
+static inline void vfio_device_unblock_group(struct vfio_device *device)
+{
+}
+
+static inline int vfio_device_set_group(struct vfio_device *device,
+					enum vfio_group_type type)
+{
+	return 0;
+}
+
+static inline void vfio_device_remove_group(struct vfio_device *device)
+{
+}
+
+static inline void vfio_device_group_register(struct vfio_device *device)
+{
+}
+
+static inline void vfio_device_group_unregister(struct vfio_device *device)
+{
+}
+
+static inline bool vfio_device_group_uses_container(struct vfio_device_file *df)
+{
+	return false;
+}
+
+static inline int vfio_device_group_use_iommu(struct vfio_device *device)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_device_group_unuse_iommu(struct vfio_device *device)
+{
+}
+
+static inline void vfio_device_group_close(struct vfio_device_file *df)
+{
+}
+
+static inline struct vfio_group *vfio_group_from_file(struct file *file)
+{
+	return NULL;
+}
+
+static inline bool vfio_group_has_dev(struct vfio_group *group,
+				      struct vfio_device *device)
+{
+	return false;
+}
+
+static inline bool vfio_group_enforced_coherent(struct vfio_group *group)
+{
+	return true;
+}
+
+static inline void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
+{
+}
+
+static inline bool vfio_device_has_container(struct vfio_device *device)
+{
+	return false;
+}
+
+static inline int __init vfio_group_init(void)
+{
+	return 0;
+}
+
+static inline void vfio_group_cleanup(void)
+{
+}
+
+static inline void vfio_device_set_noiommu(struct vfio_device *device)
+{
+	struct iommu_group *iommu_group;
+
+	device->noiommu = false;
+
+	if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
+		return;
+
+	iommu_group = iommu_group_get(device->dev);
+	if (iommu_group)
+		iommu_group_put(iommu_group);
+	else
+		device->noiommu = true;
+}
+#endif /* CONFIG_VFIO_GROUP */
 
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 /**
@@ -356,12 +461,6 @@ static inline void vfio_virqfd_exit(void)
 }
 #endif
 
-#ifdef CONFIG_VFIO_NOIOMMU
-extern bool vfio_noiommu __read_mostly;
-#else
-enum { vfio_noiommu = false };
-#endif
-
 #ifdef CONFIG_HAVE_KVM
 void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm);
 void vfio_device_put_kvm(struct vfio_device *device);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index db717a8f4440..46b313f8bfaf 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -43,7 +43,11 @@ struct vfio_device {
 	 */
 	const struct vfio_migration_ops *mig_ops;
 	const struct vfio_log_ops *log_ops;
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
 	struct vfio_group *group;
+	struct list_head group_next;
+	struct list_head iommu_entry;
+#endif
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
 	unsigned int migration_flags;
@@ -59,8 +63,6 @@ struct vfio_device {
 	refcount_t refcount;	/* user count on registered device*/
 	unsigned int open_count;
 	struct completion comp;
-	struct list_head group_next;
-	struct list_head iommu_entry;
 	struct iommufd_access *iommufd_access;
 	void (*put_kvm)(struct kvm *kvm);
 #if IS_ENABLED(CONFIG_IOMMUFD)
@@ -284,7 +286,14 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 /*
  * External user API
  */
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
 struct iommu_group *vfio_file_iommu_group(struct file *file);
+#else
+static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
+{
+	return NULL;
+}
+#endif
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
-- 
2.34.1

