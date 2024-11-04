Return-Path: <kvm+bounces-30534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C59719BB5EC
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E91C01C21320
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7896383CD3;
	Mon,  4 Nov 2024 13:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CDzLaPWT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D673A42056
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726720; cv=none; b=IbbGhKMw2Wh02+gunC4UwMI+EpaIbVzoFxIaNjAxZzB2sUnJWRG86aQFQT1fUgxd3ltHXXoeKOho6YBzWgP+h6JJt5xnPXvjxQlAYrsFmxbdQ1oFux3y1lRvtfZBTzdL0alvVXr8t92UiwhwhFBr96qEmaKbSSMe/s7//tWwxzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726720; c=relaxed/simple;
	bh=p2Bdqq25CYOWEqSmNai3CPRCLJjeSOObJdpfJMNpgU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c+ZgOYSG+r4MSoc8+jgmDIwVw7kOq/2dnxnkfsc8DshaBptvXBnbMGJ664wwJh/QurlQ8MjzZ+OuTQgbkYc5nHf0ekAy8SF4a+eHcnRe/q17NKdzKtWJcOclKLuJPNP/Bj2DPV/HeO+qYENzFuC3BY/TyF/dzseDRyxA46E9F/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CDzLaPWT; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726718; x=1762262718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p2Bdqq25CYOWEqSmNai3CPRCLJjeSOObJdpfJMNpgU4=;
  b=CDzLaPWTpfuWsrfSBUMyMwlLmrjNBm2FsoLlhS87ISrzSYyYec5ECLSn
   0SRPeA5l90CKsT8fHcD9mXM3CEonDMeDMBOQU3AHTpWjPnacfhN338QmW
   pMqZzQ+pD3PVPnfYbRPkQ+JzoTPxAUfSRLrSeUIYeo31OCB9lvfotCBkT
   pPGB7a8W1K7IMRjobfYZQaCDHEsRK0KtId8/LDjpVNg2KvlTxQmL1wQtx
   NHFvpoLcTzQgmfovk01X1f4jUn59MIT1h5uRBweg736cHXyZE4hw2iJFk
   G2cJd+NPRdnF25yuR8Wc43AKTy09nlwiY1yMfXApocoWHySGzNPRSw9sP
   Q==;
X-CSE-ConnectionGUID: A2gxq26NQqq7nzJ+pF77/g==
X-CSE-MsgGUID: N65uXYh3TQiHaoKKDmzJ8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884039"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884039"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:25:18 -0800
X-CSE-ConnectionGUID: i+Ha3sMtTb2dSZ0F/HPJ4w==
X-CSE-MsgGUID: Q95UnDI1Sqmtcmg3GhInqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100447"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:25:18 -0800
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
Subject: [PATCH v5 03/12] iommufd: Move the iommufd_handle helpers to device.c
Date: Mon,  4 Nov 2024 05:25:04 -0800
Message-Id: <20241104132513.15890-4-yi.l.liu@intel.com>
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

The iommu_attach_handle is now only passed when attaching iopf-capable
domain, while it is not convenient for the iommu core to track the
attached domain of pasids. To address it, the iommu_attach_handle will
be passed to iommu core for non-fault-able domain as well. Hence the
iommufd_handle related helpers are no longer fault specific, it makes
more sense to move it out of fault.c.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c          | 51 ++++++++++++++++++++++
 drivers/iommu/iommufd/fault.c           | 56 +------------------------
 drivers/iommu/iommufd/iommufd_private.h |  8 ++++
 3 files changed, 61 insertions(+), 54 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 5fd3dd420290..823c81145214 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -293,6 +293,57 @@ u32 iommufd_device_to_id(struct iommufd_device *idev)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
 
+struct iommufd_attach_handle *
+iommufd_device_get_attach_handle(struct iommufd_device *idev)
+{
+	struct iommu_attach_handle *handle;
+
+	handle = iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
+	if (IS_ERR(handle))
+		return NULL;
+
+	return to_iommufd_handle(handle);
+}
+
+int iommufd_dev_attach_handle(struct iommufd_hw_pagetable *hwpt,
+			      struct iommufd_device *idev)
+{
+	struct iommufd_attach_handle *handle;
+	int ret;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->idev = idev;
+	ret = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
+					&handle->handle);
+	if (ret)
+		kfree(handle);
+
+	return ret;
+}
+
+int iommufd_dev_replace_handle(struct iommufd_device *idev,
+			       struct iommufd_hw_pagetable *hwpt,
+			       struct iommufd_hw_pagetable *old)
+{
+	struct iommufd_attach_handle *handle;
+	int ret;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->idev = idev;
+	ret = iommu_replace_group_handle(idev->igroup->group,
+					 hwpt->domain, &handle->handle);
+	if (ret)
+		kfree(handle);
+
+	return ret;
+}
+
 static int iommufd_group_setup_msi(struct iommufd_group *igroup,
 				   struct iommufd_hwpt_paging *hwpt_paging)
 {
diff --git a/drivers/iommu/iommufd/fault.c b/drivers/iommu/iommufd/fault.c
index 230d37c17102..add94b044dc6 100644
--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -55,25 +55,6 @@ static void iommufd_fault_iopf_disable(struct iommufd_device *idev)
 	mutex_unlock(&idev->iopf_lock);
 }
 
-static int __fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
-				     struct iommufd_device *idev)
-{
-	struct iommufd_attach_handle *handle;
-	int ret;
-
-	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (!handle)
-		return -ENOMEM;
-
-	handle->idev = idev;
-	ret = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
-					&handle->handle);
-	if (ret)
-		kfree(handle);
-
-	return ret;
-}
-
 int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
 				    struct iommufd_device *idev)
 {
@@ -86,7 +67,7 @@ int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
 	if (ret)
 		return ret;
 
-	ret = __fault_domain_attach_dev(hwpt, idev);
+	ret = iommufd_dev_attach_handle(hwpt, idev);
 	if (ret)
 		iommufd_fault_iopf_disable(idev);
 
@@ -122,18 +103,6 @@ static void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
 	mutex_unlock(&fault->mutex);
 }
 
-static struct iommufd_attach_handle *
-iommufd_device_get_attach_handle(struct iommufd_device *idev)
-{
-	struct iommu_attach_handle *handle;
-
-	handle = iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
-	if (IS_ERR(handle))
-		return NULL;
-
-	return to_iommufd_handle(handle);
-}
-
 void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
 				     struct iommufd_device *idev)
 {
@@ -146,27 +115,6 @@ void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
 	kfree(handle);
 }
 
-static int
-__fault_domain_replace_dev(struct iommufd_device *idev,
-			   struct iommufd_hw_pagetable *hwpt,
-			   struct iommufd_hw_pagetable *old)
-{
-	struct iommufd_attach_handle *handle;
-	int ret;
-
-	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (!handle)
-		return -ENOMEM;
-
-	handle->idev = idev;
-	ret = iommu_replace_group_handle(idev->igroup->group,
-					 hwpt->domain, &handle->handle);
-	if (ret)
-		kfree(handle);
-
-	return ret;
-}
-
 int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
 				     struct iommufd_hw_pagetable *hwpt,
 				     struct iommufd_hw_pagetable *old)
@@ -185,7 +133,7 @@ int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
 	curr = iommufd_device_get_attach_handle(idev);
 
 	if (hwpt->fault)
-		ret = __fault_domain_replace_dev(idev, hwpt, old);
+		ret = iommufd_dev_replace_handle(idev, hwpt, old);
 	else
 		ret = iommu_replace_group_handle(idev->igroup->group,
 						 hwpt->domain, NULL);
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index f1d865e6fab6..66eb95063068 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -478,6 +478,14 @@ struct iommufd_attach_handle {
 /* Convert an iommu attach handle to iommufd handle. */
 #define to_iommufd_handle(hdl)	container_of(hdl, struct iommufd_attach_handle, handle)
 
+struct iommufd_attach_handle *
+iommufd_device_get_attach_handle(struct iommufd_device *idev);
+int iommufd_dev_attach_handle(struct iommufd_hw_pagetable *hwpt,
+			      struct iommufd_device *idev);
+int iommufd_dev_replace_handle(struct iommufd_device *idev,
+			       struct iommufd_hw_pagetable *hwpt,
+			       struct iommufd_hw_pagetable *old);
+
 static inline struct iommufd_fault *
 iommufd_get_fault(struct iommufd_ucmd *ucmd, u32 id)
 {
-- 
2.34.1


