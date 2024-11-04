Return-Path: <kvm+bounces-30538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5541F9BB5F1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D01001F22479
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F318213C90A;
	Mon,  4 Nov 2024 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NHUFE0Qj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DA0137772
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726724; cv=none; b=AJr+mAp7U6fQ2MlnoJmnft687vqiR1wsFuv7cx6rtT0oWlzZialuDhPVSsZ+X4FldWBD8cAjWJr3y1svCgSE4mk6OpM1Utj7LncYfTzCysIM6yL83A/VPe3HlDI+TtU6HDGwN9AmBd0cfoGKbRQeEJ1KFoZdOLhzyDm65GOxdfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726724; c=relaxed/simple;
	bh=pa04HYrY5OwOywpRL+JSohAKkUnKL81KhC7Pw9KPtcM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qvIq9t4lInpOTE54fPof8SCxI+hbkxszcqUs5Lfoc2PGoLJecMCqFSU20XrVxxAUysm64/hxwk3gxq6y9JjAq2+aCqJIcAyHgS/aei+FlIDqORTl9EYhVmKiyjzwl63eKCgoDWDjl3AFcTN8zg/m9Q7xCPYpx9NBT38QrKv7TSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NHUFE0Qj; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726722; x=1762262722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pa04HYrY5OwOywpRL+JSohAKkUnKL81KhC7Pw9KPtcM=;
  b=NHUFE0QjQp55BYPVjeb2mZOgU2H+vPS/egBBEyskGt8ObPa3jochVa5y
   ZIpRzKt3wa/jwfksX5Jsbvsv5rjGOVXu3/EN7KV6Q/05RUZMh+pwrx0iu
   nS+w28NsrIRNXPh++V6kTvc7ycubM9VDmzUusm2/S1Cy4C0FVzqInL7yO
   U6YnA77KgBBdUW93TEwtncUchnT443Q4Af5JN7jkIcj1dF/LKIowxGpxU
   3QLpBjXFW4aG0inTDc4/26+PaYVYKaM5ICFTVGHAFXQrq1lpwqpiVlmJV
   TyOXzuw+zEkDwyFT6l2bJqNXBpG8FLRqlfjAimY/VBMyA6ATOPbVrukkU
   g==;
X-CSE-ConnectionGUID: Bhz1xZQlRseSH0iknqbLcg==
X-CSE-MsgGUID: NKRgv+ogQk+cqzeR0mRcxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884057"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884057"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:25:19 -0800
X-CSE-ConnectionGUID: MSC1M6b3SHmb97utAx0e3A==
X-CSE-MsgGUID: BaTiugp6SzKNWFYE+E5MJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100457"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:25:19 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com
Subject: [PATCH v5 06/12] iommufd: Support pasid attach/replace
Date: Mon,  4 Nov 2024 05:25:07 -0800
Message-Id: <20241104132513.15890-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132513.15890-1-yi.l.liu@intel.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This introduces three APIs for device drivers to manage pasid attach/
replace/detach.

    int iommufd_device_pasid_attach(struct iommufd_device *idev,
				    ioasid_t pasid, u32 *pt_id);
    int iommufd_device_pasid_replace(struct iommufd_device *idev,
				     ioasid_t pasid, u32 *pt_id);
    void iommufd_device_pasid_detach(struct iommufd_device *idev,
				     ioasid_t pasid);

pasid operations have different implications when comparing to device
operations:

 - No connection to iommufd_group since pasid is a device capability
   and can be enabled only in singleton group;

 - no reserved region per pasid otherwise SVA architecture is already
   broken (CPU address space doesn't count device reserved regions);

 - accordingly no sw_msi trick;

 - immediated_attach is not supported, expecting that arm-smmu driver
   will already remove that requirement before supporting this pasid
   operation. This avoids unnecessary change in iommufd_hw_pagetable_alloc()
   to carry the pasid from device.c.

With above differences, this puts all pasid related logics into a new
pasid.c file.

Cache coherency enforcement is still applied to pasid operations since
it is about memory accesses post page table walking (no matter the walk
is per RID or per PASID).

Since the attach is per PASID, this introduces a pasid_hwpts xarray to
track the per-pasid attach data.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/device.c          |  31 ++---
 drivers/iommu/iommufd/fault.c           |   6 +-
 drivers/iommu/iommufd/iommufd_private.h |  21 +++-
 drivers/iommu/iommufd/pasid.c           | 157 ++++++++++++++++++++++++
 include/linux/iommufd.h                 |   7 ++
 6 files changed, 205 insertions(+), 18 deletions(-)
 create mode 100644 drivers/iommu/iommufd/pasid.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index cf4605962bea..d791664ed05b 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -7,6 +7,7 @@ iommufd-y := \
 	ioas.o \
 	main.o \
 	pages.o \
+	pasid.o \
 	vfio_compat.o
 
 iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o
diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 0b3f2094af4a..4e7a473d0dd0 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -136,6 +136,7 @@ void iommufd_device_destroy(struct iommufd_object *obj)
 	struct iommufd_device *idev =
 		container_of(obj, struct iommufd_device, obj);
 
+	WARN_ON(!xa_empty(&idev->pasid_hwpts));
 	iommu_device_release_dma_owner(idev->dev);
 	iommufd_put_group(idev->igroup);
 	if (!iommufd_selftest_is_mock_dev(idev->dev))
@@ -217,6 +218,8 @@ struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 	idev->igroup = igroup;
 	mutex_init(&idev->iopf_lock);
 
+	xa_init(&idev->pasid_hwpts);
+
 	/*
 	 * If the caller fails after this success it must call
 	 * iommufd_unbind_device() which is safe since we hold this refcount.
@@ -298,7 +301,6 @@ iommufd_device_get_attach_handle(struct iommufd_device *idev, ioasid_t pasid)
 {
 	struct iommu_attach_handle *handle;
 
-	WARN_ON(pasid != IOMMU_NO_PASID);
 	handle = iommu_attach_handle_get(idev->igroup->group, pasid, 0);
 	if (IS_ERR(handle))
 		return NULL;
@@ -318,9 +320,12 @@ int iommufd_dev_attach_handle(struct iommufd_hw_pagetable *hwpt,
 		return -ENOMEM;
 
 	handle->idev = idev;
-	WARN_ON(pasid != IOMMU_NO_PASID);
-	ret = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
-					&handle->handle);
+	if (pasid == IOMMU_NO_PASID)
+		ret = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
+						&handle->handle);
+	else
+		ret = iommu_attach_device_pasid(hwpt->domain, idev->dev, pasid,
+						&handle->handle);
 	if (ret)
 		kfree(handle);
 
@@ -340,9 +345,12 @@ int iommufd_dev_replace_handle(struct iommufd_device *idev,
 		return -ENOMEM;
 
 	handle->idev = idev;
-	WARN_ON(pasid != IOMMU_NO_PASID);
-	ret = iommu_replace_group_handle(idev->igroup->group,
-					 hwpt->domain, &handle->handle);
+	if (pasid == IOMMU_NO_PASID)
+		ret = iommu_replace_group_handle(idev->igroup->group,
+						 hwpt->domain, &handle->handle);
+	else
+		ret = iommu_replace_device_pasid(hwpt->domain, idev->dev,
+						 pasid, &handle->handle);
 	if (ret)
 		kfree(handle);
 
@@ -589,10 +597,6 @@ iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 	return ERR_PTR(rc);
 }
 
-typedef struct iommufd_hw_pagetable *(*attach_fn)(
-			struct iommufd_device *idev, ioasid_t pasid,
-			struct iommufd_hw_pagetable *hwpt);
-
 /*
  * When automatically managing the domains we search for a compatible domain in
  * the iopt and if one is found use it, otherwise create a new domain.
@@ -676,9 +680,8 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev, ioasid_t pasid,
 	return destroy_hwpt;
 }
 
-static int iommufd_device_change_pt(struct iommufd_device *idev,
-				    ioasid_t pasid,
-				    u32 *pt_id, attach_fn do_attach)
+int iommufd_device_change_pt(struct iommufd_device *idev, ioasid_t pasid,
+			     u32 *pt_id, attach_fn do_attach)
 {
 	struct iommufd_hw_pagetable *destroy_hwpt;
 	struct iommufd_object *pt_obj;
diff --git a/drivers/iommu/iommufd/fault.c b/drivers/iommu/iommufd/fault.c
index 3b60349e2913..2d7590ede715 100644
--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -111,8 +111,10 @@ void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
 	struct iommufd_attach_handle *handle;
 
 	handle = iommufd_device_get_attach_handle(idev, pasid);
-	WARN_ON(pasid != IOMMU_NO_PASID);
-	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
+	if (pasid == IOMMU_NO_PASID)
+		iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
+	else
+		iommu_detach_device_pasid(hwpt->domain, idev->dev, pasid);
 	iommufd_auto_response_faults(hwpt, handle);
 	iommufd_fault_iopf_disable(idev);
 	kfree(handle);
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 8e7265885f36..11773cef5acc 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -418,6 +418,7 @@ struct iommufd_device {
 	struct list_head group_item;
 	/* always the physical device */
 	struct device *dev;
+	struct xarray pasid_hwpts;
 	bool enforce_cache_coherency;
 	/* protect iopf_enabled counter */
 	struct mutex iopf_lock;
@@ -435,6 +436,20 @@ iommufd_get_device(struct iommufd_ucmd *ucmd, u32 id)
 void iommufd_device_destroy(struct iommufd_object *obj);
 int iommufd_get_hw_info(struct iommufd_ucmd *ucmd);
 
+typedef struct iommufd_hw_pagetable *(*attach_fn)(
+			struct iommufd_device *idev, ioasid_t pasid,
+			struct iommufd_hw_pagetable *hwpt);
+
+int iommufd_device_change_pt(struct iommufd_device *idev, ioasid_t pasid,
+			     u32 *pt_id, attach_fn do_attach);
+
+struct iommufd_hw_pagetable *
+iommufd_device_pasid_do_attach(struct iommufd_device *idev, ioasid_t pasid,
+			       struct iommufd_hw_pagetable *hwpt);
+struct iommufd_hw_pagetable *
+iommufd_device_pasid_do_replace(struct iommufd_device *idev, ioasid_t pasid,
+				struct iommufd_hw_pagetable *hwpt);
+
 struct iommufd_access {
 	struct iommufd_object obj;
 	struct iommufd_ctx *ictx;
@@ -534,8 +549,10 @@ static inline void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
 	}
 
 	handle = iommufd_device_get_attach_handle(idev, pasid);
-	WARN_ON(pasid != IOMMU_NO_PASID);
-	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
+	if (pasid == IOMMU_NO_PASID)
+		iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
+	else
+		iommu_detach_device_pasid(hwpt->domain, idev->dev, pasid);
 	kfree(handle);
 }
 
diff --git a/drivers/iommu/iommufd/pasid.c b/drivers/iommu/iommufd/pasid.c
new file mode 100644
index 000000000000..5e8598f1846b
--- /dev/null
+++ b/drivers/iommu/iommufd/pasid.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2024, Intel Corporation
+ */
+#include <linux/iommufd.h>
+#include <linux/iommu.h>
+#include "../iommu-priv.h"
+
+#include "iommufd_private.h"
+
+struct iommufd_hw_pagetable *
+iommufd_device_pasid_do_attach(struct iommufd_device *idev, ioasid_t pasid,
+			       struct iommufd_hw_pagetable *hwpt)
+{
+	void *curr;
+	int rc;
+
+	refcount_inc(&hwpt->obj.users);
+	curr = xa_cmpxchg(&idev->pasid_hwpts, pasid, NULL, hwpt, GFP_KERNEL);
+	if (curr) {
+		if (curr == hwpt)
+			rc = 0;
+		else
+			rc = xa_err(curr) ? : -EBUSY;
+		goto err_put_hwpt;
+	}
+
+	rc = iommufd_hwpt_attach_device(hwpt, idev, pasid);
+	if (rc) {
+		xa_erase(&idev->pasid_hwpts, pasid);
+		goto err_put_hwpt;
+	}
+
+	return NULL;
+
+err_put_hwpt:
+	refcount_dec(&hwpt->obj.users);
+	return rc ? ERR_PTR(rc) : NULL;
+}
+
+struct iommufd_hw_pagetable *
+iommufd_device_pasid_do_replace(struct iommufd_device *idev, ioasid_t pasid,
+				struct iommufd_hw_pagetable *hwpt)
+{
+	void *curr;
+	int rc;
+
+	refcount_inc(&hwpt->obj.users);
+	curr = xa_store(&idev->pasid_hwpts, pasid, hwpt, GFP_KERNEL);
+	rc = xa_err(curr);
+	if (rc)
+		goto out_put_hwpt;
+
+	if (!curr) {
+		xa_erase(&idev->pasid_hwpts, pasid);
+		rc = -EINVAL;
+		goto out_put_hwpt;
+	}
+
+	if (curr == hwpt)
+		goto out_put_hwpt;
+
+	/*
+	 * After replacement, the reference on the old hwpt is retained
+	 * in this thread as caller would free it.
+	 */
+	rc = iommufd_hwpt_replace_device(idev, pasid, hwpt, curr);
+	if (rc) {
+		WARN_ON(xa_err(xa_store(&idev->pasid_hwpts, pasid,
+					curr, GFP_KERNEL)));
+		goto out_put_hwpt;
+	}
+
+	/* Caller must destroy old_hwpt */
+	return curr;
+
+out_put_hwpt:
+	refcount_dec(&hwpt->obj.users);
+	return rc ? ERR_PTR(rc) : NULL;
+}
+
+/**
+ * iommufd_device_pasid_attach - Connect a {device, pasid} to an iommu_domain
+ * @idev: device to attach
+ * @pasid: pasid to attach
+ * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
+ *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
+ *
+ * This connects a pasid of the device to an iommu_domain. Once this
+ * completes the device could do DMA with the pasid.
+ *
+ * This function is undone by calling iommufd_device_detach_pasid().
+ *
+ * iommufd does not handle race between iommufd_device_pasid_attach(),
+ * iommufd_device_pasid_replace() and iommufd_device_pasid_detach().
+ * So caller of them should guarantee no concurrent call on the same
+ * device and pasid.
+ */
+int iommufd_device_pasid_attach(struct iommufd_device *idev,
+				ioasid_t pasid, u32 *pt_id)
+{
+	return iommufd_device_change_pt(idev, pasid, pt_id,
+					&iommufd_device_pasid_do_attach);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_pasid_attach, IOMMUFD);
+
+/**
+ * iommufd_device_pasid_replace - Change the {device, pasid}'s iommu_domain
+ * @idev: device to change
+ * @pasid: pasid to change
+ * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
+ *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
+ *
+ * This is the same as
+ *   iommufd_device_pasid_detach();
+ *   iommufd_device_pasid_attach();
+ *
+ * If it fails then no change is made to the attachment. The iommu driver may
+ * implement this so there is no disruption in translation. This can only be
+ * called if iommufd_device_pasid_attach() has already succeeded.
+ *
+ * iommufd does not handle race between iommufd_device_pasid_replace(),
+ * iommufd_device_pasid_attach() and iommufd_device_pasid_detach().
+ * So caller of them should guarantee no concurrent call on the same
+ * device and pasid.
+ */
+int iommufd_device_pasid_replace(struct iommufd_device *idev,
+				 ioasid_t pasid, u32 *pt_id)
+{
+	return iommufd_device_change_pt(idev, pasid, pt_id,
+					&iommufd_device_pasid_do_replace);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_pasid_replace, IOMMUFD);
+
+/**
+ * iommufd_device_pasid_detach - Disconnect a {device, pasid} to an iommu_domain
+ * @idev: device to detach
+ * @pasid: pasid to detach
+ *
+ * Undo iommufd_device_pasid_attach(). This disconnects the idev/pasid from
+ * the previously attached pt_id.
+ *
+ * iommufd does not handle race between iommufd_device_pasid_detach(),
+ * iommufd_device_pasid_attach() and iommufd_device_pasid_replace().
+ * So caller of them should guarantee no concurrent call on the same
+ * device and pasid.
+ */
+void iommufd_device_pasid_detach(struct iommufd_device *idev, ioasid_t pasid)
+{
+	struct iommufd_hw_pagetable *hwpt;
+
+	hwpt = xa_erase(&idev->pasid_hwpts, pasid);
+	if (WARN_ON(!hwpt))
+		return;
+	iommufd_hwpt_detach_device(hwpt, idev, pasid);
+	iommufd_hw_pagetable_put(idev->ictx, hwpt);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_pasid_detach, IOMMUFD);
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 30f832a60ccb..f18472cbf688 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -8,6 +8,7 @@
 
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/iommu.h>
 #include <linux/types.h>
 
 struct device;
@@ -26,6 +27,12 @@ int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
 int iommufd_device_replace(struct iommufd_device *idev, u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev);
 
+int iommufd_device_pasid_attach(struct iommufd_device *idev,
+				ioasid_t pasid, u32 *pt_id);
+int iommufd_device_pasid_replace(struct iommufd_device *idev,
+				 ioasid_t pasid, u32 *pt_id);
+void iommufd_device_pasid_detach(struct iommufd_device *idev, ioasid_t pasid);
+
 struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
 u32 iommufd_device_to_id(struct iommufd_device *idev);
 
-- 
2.34.1


