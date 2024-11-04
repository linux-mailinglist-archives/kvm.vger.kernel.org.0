Return-Path: <kvm+bounces-30536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC7A9BB5EE
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:26:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94E5C1F22574
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF04533FE;
	Mon,  4 Nov 2024 13:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RhCrfz6W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7977081D
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726721; cv=none; b=T2GftmjD9NmwNMfB7aaZzCyV2o47Ho6a3Aoa3XO9fcZisHh+koHyYnGzHCdyIA3ilhha+yxVKiBGmH1n7QG/9PiPnIk8mN6cxDKaQjJcNhCQUmWRijuj7eXpivNJn1xvnLhgyFJfG3Bm0KMfBL5QMUlELsoMZLd1nAVErgPE0fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726721; c=relaxed/simple;
	bh=DqvBgYqq7wFOCqtrgRzxPKftAsYmEtm79SIPwuzEPAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GHRRVFk+c29X1TE4h0n+l8NjQMlygOoDSRTRcqUa3uSdaObo9IRJ0oFkI1f+HZzgqhGsf5lsOo5UOOh4Y+Gpq/lf1RdKUuMi0K8s9Uv13KrEC0Txycj776sjLfvi2ohBH5DyEJ8/ZOrkfbmh9G0HZ/YfiqhPQQBc8pagoHZ4qrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RhCrfz6W; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726720; x=1762262720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DqvBgYqq7wFOCqtrgRzxPKftAsYmEtm79SIPwuzEPAE=;
  b=RhCrfz6WEnlNKDgJxdnp1/0tJnE7sRIPJjurVVjkU95Cr0b7CmO/BnxF
   1MNxDk4lN6msm7N30aAQxJPIzV3uJQBvitN3D9PqcMPnPHY8NCRFK/KfQ
   /uisM2ho22AILCdWU9wa/GMIo7z9w2K5IC8/VsxE5GdjcA1lw5ckCv8fd
   a/By3Ull4PKBQeZXRL8Lne71KCkZn/WXxzapvScBp5QVcOkqx9tho5ZeU
   LAF5c8mf3xtI0sahzFgEUviQ8h5cpGh8IHIDPafRJTuAZVSMksCXFnHp0
   cvJUsG7qPsjRzPTWb6Nj+hAAhElJ4Ui2Ex7D8etyQErn1MYG2lhaMpV/6
   Q==;
X-CSE-ConnectionGUID: Yl/0ad4iRDGkQUZJ3ZmJwQ==
X-CSE-MsgGUID: xbMLt+CgRX6Q7ZrwCKU3HQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884051"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884051"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:25:19 -0800
X-CSE-ConnectionGUID: cs7diujJQBae6WISpQVjGg==
X-CSE-MsgGUID: JBaREV8uSxeTAQSCIAh1JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100454"
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
Subject: [PATCH v5 05/12] iommufd: Pass pasid through the device attach/replace path
Date: Mon,  4 Nov 2024 05:25:06 -0800
Message-Id: <20241104132513.15890-6-yi.l.liu@intel.com>
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

Most of the core logic before conducting the actual device attach/
replace operation can be shared with pasid attach/replace. So pass
pasid through the device attach/replace helpers to prepare adding
pasid attach/replace.

So far the @pasid should only be IOMMU_NO_PASID. No functional change.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c          | 55 ++++++++++++++-----------
 drivers/iommu/iommufd/fault.c           | 16 ++++---
 drivers/iommu/iommufd/hw_pagetable.c    |  5 ++-
 drivers/iommu/iommufd/iommufd_private.h | 41 +++++++++++-------
 4 files changed, 71 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 823c81145214..0b3f2094af4a 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -294,11 +294,12 @@ u32 iommufd_device_to_id(struct iommufd_device *idev)
 EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
 
 struct iommufd_attach_handle *
-iommufd_device_get_attach_handle(struct iommufd_device *idev)
+iommufd_device_get_attach_handle(struct iommufd_device *idev, ioasid_t pasid)
 {
 	struct iommu_attach_handle *handle;
 
-	handle = iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
+	WARN_ON(pasid != IOMMU_NO_PASID);
+	handle = iommu_attach_handle_get(idev->igroup->group, pasid, 0);
 	if (IS_ERR(handle))
 		return NULL;
 
@@ -306,7 +307,8 @@ iommufd_device_get_attach_handle(struct iommufd_device *idev)
 }
 
 int iommufd_dev_attach_handle(struct iommufd_hw_pagetable *hwpt,
-			      struct iommufd_device *idev)
+			      struct iommufd_device *idev,
+			      ioasid_t pasid)
 {
 	struct iommufd_attach_handle *handle;
 	int ret;
@@ -316,6 +318,7 @@ int iommufd_dev_attach_handle(struct iommufd_hw_pagetable *hwpt,
 		return -ENOMEM;
 
 	handle->idev = idev;
+	WARN_ON(pasid != IOMMU_NO_PASID);
 	ret = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
 					&handle->handle);
 	if (ret)
@@ -325,6 +328,7 @@ int iommufd_dev_attach_handle(struct iommufd_hw_pagetable *hwpt,
 }
 
 int iommufd_dev_replace_handle(struct iommufd_device *idev,
+			       ioasid_t pasid,
 			       struct iommufd_hw_pagetable *hwpt,
 			       struct iommufd_hw_pagetable *old)
 {
@@ -336,6 +340,7 @@ int iommufd_dev_replace_handle(struct iommufd_device *idev,
 		return -ENOMEM;
 
 	handle->idev = idev;
+	WARN_ON(pasid != IOMMU_NO_PASID);
 	ret = iommu_replace_group_handle(idev->igroup->group,
 					 hwpt->domain, &handle->handle);
 	if (ret)
@@ -404,7 +409,8 @@ iommufd_device_attach_reserved_iova(struct iommufd_device *idev,
 }
 
 int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
-				struct iommufd_device *idev)
+				struct iommufd_device *idev,
+				ioasid_t pasid)
 {
 	struct iommufd_hwpt_paging *hwpt_paging = find_hwpt_paging(hwpt);
 	int rc;
@@ -430,7 +436,7 @@ int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
 	 * attachment.
 	 */
 	if (list_empty(&idev->igroup->device_list)) {
-		rc = iommufd_hwpt_attach_device(hwpt, idev);
+		rc = iommufd_hwpt_attach_device(hwpt, idev, pasid);
 		if (rc)
 			goto err_unresv;
 		idev->igroup->hwpt = hwpt;
@@ -448,7 +454,7 @@ int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
 }
 
 struct iommufd_hw_pagetable *
-iommufd_hw_pagetable_detach(struct iommufd_device *idev)
+iommufd_hw_pagetable_detach(struct iommufd_device *idev, ioasid_t pasid)
 {
 	struct iommufd_hw_pagetable *hwpt = idev->igroup->hwpt;
 	struct iommufd_hwpt_paging *hwpt_paging = find_hwpt_paging(hwpt);
@@ -456,7 +462,7 @@ iommufd_hw_pagetable_detach(struct iommufd_device *idev)
 	mutex_lock(&idev->igroup->lock);
 	list_del(&idev->group_item);
 	if (list_empty(&idev->igroup->device_list)) {
-		iommufd_hwpt_detach_device(hwpt, idev);
+		iommufd_hwpt_detach_device(hwpt, idev, pasid);
 		idev->igroup->hwpt = NULL;
 	}
 	if (hwpt_paging)
@@ -468,12 +474,12 @@ iommufd_hw_pagetable_detach(struct iommufd_device *idev)
 }
 
 static struct iommufd_hw_pagetable *
-iommufd_device_do_attach(struct iommufd_device *idev,
+iommufd_device_do_attach(struct iommufd_device *idev, ioasid_t pasid,
 			 struct iommufd_hw_pagetable *hwpt)
 {
 	int rc;
 
-	rc = iommufd_hw_pagetable_attach(hwpt, idev);
+	rc = iommufd_hw_pagetable_attach(hwpt, idev, pasid);
 	if (rc)
 		return ERR_PTR(rc);
 	return NULL;
@@ -522,7 +528,7 @@ iommufd_group_do_replace_reserved_iova(struct iommufd_group *igroup,
 }
 
 static struct iommufd_hw_pagetable *
-iommufd_device_do_replace(struct iommufd_device *idev,
+iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 			  struct iommufd_hw_pagetable *hwpt)
 {
 	struct iommufd_hwpt_paging *hwpt_paging = find_hwpt_paging(hwpt);
@@ -551,7 +557,7 @@ iommufd_device_do_replace(struct iommufd_device *idev,
 			goto err_unlock;
 	}
 
-	rc = iommufd_hwpt_replace_device(idev, hwpt, old_hwpt);
+	rc = iommufd_hwpt_replace_device(idev, pasid, hwpt, old_hwpt);
 	if (rc)
 		goto err_unresv;
 
@@ -584,7 +590,8 @@ iommufd_device_do_replace(struct iommufd_device *idev,
 }
 
 typedef struct iommufd_hw_pagetable *(*attach_fn)(
-	struct iommufd_device *idev, struct iommufd_hw_pagetable *hwpt);
+			struct iommufd_device *idev, ioasid_t pasid,
+			struct iommufd_hw_pagetable *hwpt);
 
 /*
  * When automatically managing the domains we search for a compatible domain in
@@ -592,7 +599,7 @@ typedef struct iommufd_hw_pagetable *(*attach_fn)(
  * Automatic domain selection will never pick a manually created domain.
  */
 static struct iommufd_hw_pagetable *
-iommufd_device_auto_get_domain(struct iommufd_device *idev,
+iommufd_device_auto_get_domain(struct iommufd_device *idev, ioasid_t pasid,
 			       struct iommufd_ioas *ioas, u32 *pt_id,
 			       attach_fn do_attach)
 {
@@ -621,7 +628,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 		hwpt = &hwpt_paging->common;
 		if (!iommufd_lock_obj(&hwpt->obj))
 			continue;
-		destroy_hwpt = (*do_attach)(idev, hwpt);
+		destroy_hwpt = (*do_attach)(idev, pasid, hwpt);
 		if (IS_ERR(destroy_hwpt)) {
 			iommufd_put_object(idev->ictx, &hwpt->obj);
 			/*
@@ -648,7 +655,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 	hwpt = &hwpt_paging->common;
 
 	if (!immediate_attach) {
-		destroy_hwpt = (*do_attach)(idev, hwpt);
+		destroy_hwpt = (*do_attach)(idev, pasid, hwpt);
 		if (IS_ERR(destroy_hwpt))
 			goto out_abort;
 	} else {
@@ -669,8 +676,9 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 	return destroy_hwpt;
 }
 
-static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
-				    attach_fn do_attach)
+static int iommufd_device_change_pt(struct iommufd_device *idev,
+				    ioasid_t pasid,
+				    u32 *pt_id, attach_fn do_attach)
 {
 	struct iommufd_hw_pagetable *destroy_hwpt;
 	struct iommufd_object *pt_obj;
@@ -685,7 +693,7 @@ static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 		struct iommufd_hw_pagetable *hwpt =
 			container_of(pt_obj, struct iommufd_hw_pagetable, obj);
 
-		destroy_hwpt = (*do_attach)(idev, hwpt);
+		destroy_hwpt = (*do_attach)(idev, pasid, hwpt);
 		if (IS_ERR(destroy_hwpt))
 			goto out_put_pt_obj;
 		break;
@@ -694,8 +702,8 @@ static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 		struct iommufd_ioas *ioas =
 			container_of(pt_obj, struct iommufd_ioas, obj);
 
-		destroy_hwpt = iommufd_device_auto_get_domain(idev, ioas, pt_id,
-							      do_attach);
+		destroy_hwpt = iommufd_device_auto_get_domain(idev, pasid, ioas,
+							      pt_id, do_attach);
 		if (IS_ERR(destroy_hwpt))
 			goto out_put_pt_obj;
 		break;
@@ -732,7 +740,8 @@ int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id)
 {
 	int rc;
 
-	rc = iommufd_device_change_pt(idev, pt_id, &iommufd_device_do_attach);
+	rc = iommufd_device_change_pt(idev, IOMMU_NO_PASID, pt_id,
+				      &iommufd_device_do_attach);
 	if (rc)
 		return rc;
 
@@ -762,7 +771,7 @@ EXPORT_SYMBOL_NS_GPL(iommufd_device_attach, IOMMUFD);
  */
 int iommufd_device_replace(struct iommufd_device *idev, u32 *pt_id)
 {
-	return iommufd_device_change_pt(idev, pt_id,
+	return iommufd_device_change_pt(idev, IOMMU_NO_PASID, pt_id,
 					&iommufd_device_do_replace);
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_replace, IOMMUFD);
@@ -778,7 +787,7 @@ void iommufd_device_detach(struct iommufd_device *idev)
 {
 	struct iommufd_hw_pagetable *hwpt;
 
-	hwpt = iommufd_hw_pagetable_detach(idev);
+	hwpt = iommufd_hw_pagetable_detach(idev, IOMMU_NO_PASID);
 	iommufd_hw_pagetable_put(idev->ictx, hwpt);
 	refcount_dec(&idev->obj.users);
 }
diff --git a/drivers/iommu/iommufd/fault.c b/drivers/iommu/iommufd/fault.c
index 55418a067869..3b60349e2913 100644
--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -56,7 +56,8 @@ static void iommufd_fault_iopf_disable(struct iommufd_device *idev)
 }
 
 int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
-				    struct iommufd_device *idev)
+				    struct iommufd_device *idev,
+				    ioasid_t pasid)
 {
 	int ret;
 
@@ -67,7 +68,7 @@ int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
 	if (ret)
 		return ret;
 
-	ret = iommufd_dev_attach_handle(hwpt, idev);
+	ret = iommufd_dev_attach_handle(hwpt, idev, pasid);
 	if (ret)
 		iommufd_fault_iopf_disable(idev);
 
@@ -104,11 +105,13 @@ static void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
 }
 
 void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
-				     struct iommufd_device *idev)
+				     struct iommufd_device *idev,
+				     ioasid_t pasid)
 {
 	struct iommufd_attach_handle *handle;
 
-	handle = iommufd_device_get_attach_handle(idev);
+	handle = iommufd_device_get_attach_handle(idev, pasid);
+	WARN_ON(pasid != IOMMU_NO_PASID);
 	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
 	iommufd_auto_response_faults(hwpt, handle);
 	iommufd_fault_iopf_disable(idev);
@@ -116,6 +119,7 @@ void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
 }
 
 int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
+				     ioasid_t pasid,
 				     struct iommufd_hw_pagetable *hwpt,
 				     struct iommufd_hw_pagetable *old)
 {
@@ -130,9 +134,9 @@ int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
 			return ret;
 	}
 
-	curr = iommufd_device_get_attach_handle(idev);
+	curr = iommufd_device_get_attach_handle(idev, pasid);
 
-	ret = iommufd_dev_replace_handle(idev, hwpt, old);
+	ret = iommufd_dev_replace_handle(idev, pasid, hwpt, old);
 	if (ret) {
 		if (iopf_on)
 			iommufd_fault_iopf_disable(idev);
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index d06bf6e6c19f..48639427749b 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -180,7 +180,8 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 	 * sequence. Once those drivers are fixed this should be removed.
 	 */
 	if (immediate_attach) {
-		rc = iommufd_hw_pagetable_attach(hwpt, idev);
+		/* Sinc this is just a trick, so passing IOMMU_NO_PASID is enough */
+		rc = iommufd_hw_pagetable_attach(hwpt, idev, IOMMU_NO_PASID);
 		if (rc)
 			goto out_abort;
 	}
@@ -193,7 +194,7 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 
 out_detach:
 	if (immediate_attach)
-		iommufd_hw_pagetable_detach(idev);
+		iommufd_hw_pagetable_detach(idev, IOMMU_NO_PASID);
 out_abort:
 	iommufd_object_abort_and_destroy(ictx, &hwpt->obj);
 	return ERR_PTR(rc);
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 19870b08056e..8e7265885f36 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -369,9 +369,10 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			  bool immediate_attach,
 			  const struct iommu_user_data *user_data);
 int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
-				struct iommufd_device *idev);
+				struct iommufd_device *idev,
+				ioasid_t pasid);
 struct iommufd_hw_pagetable *
-iommufd_hw_pagetable_detach(struct iommufd_device *idev);
+iommufd_hw_pagetable_detach(struct iommufd_device *idev, ioasid_t pasid);
 void iommufd_hwpt_paging_destroy(struct iommufd_object *obj);
 void iommufd_hwpt_paging_abort(struct iommufd_object *obj);
 void iommufd_hwpt_nested_destroy(struct iommufd_object *obj);
@@ -479,10 +480,12 @@ struct iommufd_attach_handle {
 #define to_iommufd_handle(hdl)	container_of(hdl, struct iommufd_attach_handle, handle)
 
 struct iommufd_attach_handle *
-iommufd_device_get_attach_handle(struct iommufd_device *idev);
+iommufd_device_get_attach_handle(struct iommufd_device *idev, ioasid_t pasid);
 int iommufd_dev_attach_handle(struct iommufd_hw_pagetable *hwpt,
-			      struct iommufd_device *idev);
+			      struct iommufd_device *idev,
+			      ioasid_t pasid);
 int iommufd_dev_replace_handle(struct iommufd_device *idev,
+			       ioasid_t pasid,
 			       struct iommufd_hw_pagetable *hwpt,
 			       struct iommufd_hw_pagetable *old);
 
@@ -499,38 +502,45 @@ void iommufd_fault_destroy(struct iommufd_object *obj);
 int iommufd_fault_iopf_handler(struct iopf_group *group);
 
 int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
-				    struct iommufd_device *idev);
+				    struct iommufd_device *idev,
+				    ioasid_t pasid);
 void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
-				     struct iommufd_device *idev);
+				     struct iommufd_device *idev,
+				     ioasid_t pasid);
 int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
+				     ioasid_t pasid,
 				     struct iommufd_hw_pagetable *hwpt,
 				     struct iommufd_hw_pagetable *old);
 
 static inline int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
-					     struct iommufd_device *idev)
+					     struct iommufd_device *idev,
+					     ioasid_t pasid)
 {
 	if (hwpt->fault)
-		return iommufd_fault_domain_attach_dev(hwpt, idev);
+		return iommufd_fault_domain_attach_dev(hwpt, idev, pasid);
 
-	return iommufd_dev_attach_handle(hwpt, idev);
+	return iommufd_dev_attach_handle(hwpt, idev, pasid);
 }
 
 static inline void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
-					      struct iommufd_device *idev)
+					      struct iommufd_device *idev,
+					      ioasid_t pasid)
 {
 	struct iommufd_attach_handle *handle;
 
 	if (hwpt->fault) {
-		iommufd_fault_domain_detach_dev(hwpt, idev);
+		iommufd_fault_domain_detach_dev(hwpt, idev, pasid);
 		return;
 	}
 
-	handle = iommufd_device_get_attach_handle(idev);
+	handle = iommufd_device_get_attach_handle(idev, pasid);
+	WARN_ON(pasid != IOMMU_NO_PASID);
 	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
 	kfree(handle);
 }
 
 static inline int iommufd_hwpt_replace_device(struct iommufd_device *idev,
+					      ioasid_t pasid,
 					      struct iommufd_hw_pagetable *hwpt,
 					      struct iommufd_hw_pagetable *old)
 {
@@ -538,11 +548,12 @@ static inline int iommufd_hwpt_replace_device(struct iommufd_device *idev,
 	int ret;
 
 	if (old->fault || hwpt->fault)
-		return iommufd_fault_domain_replace_dev(idev, hwpt, old);
+		return iommufd_fault_domain_replace_dev(idev, pasid,
+							hwpt, old);
 
-	curr = iommufd_device_get_attach_handle(idev);
+	curr = iommufd_device_get_attach_handle(idev, pasid);
 
-	ret = iommufd_dev_replace_handle(idev, hwpt, old);
+	ret = iommufd_dev_replace_handle(idev, pasid, hwpt, old);
 	if (ret)
 		return ret;
 
-- 
2.34.1


