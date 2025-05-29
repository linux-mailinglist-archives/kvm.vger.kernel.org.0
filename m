Return-Path: <kvm+bounces-47943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9531AC7811
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D5D61C07862
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D46125F799;
	Thu, 29 May 2025 05:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L911y31W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E72257426;
	Thu, 29 May 2025 05:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497377; cv=none; b=OUb/EhyU9/yxZc4TcLPrBk0y05gsLE/v3oVAkjjllMsewS5AZ8Ld7bbGV8XRekRJRJJFOp2zYzAYZG3JKXh+/UkOW8zQ9tNKYyerQDaeQI8a2EclEi0BkgZOjLEh6k1UzzX3tgj9R5EdLGFsyFkuht9H8GLhU8cqMCwDZT4NAI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497377; c=relaxed/simple;
	bh=4RGJKaGi7tjWuePHS0WN6tFoyf+foru2SDZB2A2BTOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b1+5aAgkOSwYgQqfA+1ySGRHSLsucBxFyZDKNZnz6ZkaGoIxc2zk44WzQZTmYRyKNEjgmtZg2YauYmZP/6/2IOwJRHZJ26xHul8pbjGd3Z+N1YFaNSy6u+t+kdeSQXQRn3Q6u9EA1wIl3IoudZsYtoKevYEO/2mB8ZLGyH93Cjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L911y31W; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497376; x=1780033376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4RGJKaGi7tjWuePHS0WN6tFoyf+foru2SDZB2A2BTOY=;
  b=L911y31WDPsVwAwyKJ/uJPWk0tl2Kw4bAGel2tKbXiEJpsvywMlo+rOa
   APPhoaptUspXHfpkdpqTTpH1mIlqC5SWhhDYGOUbuznnUBI9mQ4MN6BET
   DiOS5Mbxz2iQfAz66o8VVmevjDNWxSSujv/z/qaQ2Kqo3YIOhTzpEdwi7
   fpRFRzmZhitsUNuOY+3ZHL+Gkok0OMHIRbuNzA9SoFqENRZ3N/maOOpee
   UvsvRwSCHD7xBvoqzDnF4iK4rA9xBWn0ALITCLfUTioZCYBPRsMg+Wm7u
   m9lGIlF83XXBJO+BF+VrBR/jyUV8soHD/FhClZa4QXzp7Hvv5XI+7+Kwo
   Q==;
X-CSE-ConnectionGUID: hbGwRK2eSVusK8t81Bbt0Q==
X-CSE-MsgGUID: RRjfkZxLTPm60QtryuNj5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963088"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963088"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:42:55 -0700
X-CSE-ConnectionGUID: 1RCu3eSpRVmQoTlgXr2zEA==
X-CSE-MsgGUID: lAU2JY3FTmCrM6asmbLT5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443375"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:42:48 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 12/30] iommufd/device: Associate a kvm pointer to iommufd_device
Date: Thu, 29 May 2025 13:34:55 +0800
Message-Id: <20250529053513.1592088-13-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Add a struct kvm * to iommufd_device_bind() fn and associate it
with idev if bind is successful.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

---
This patch and next Shameer's patch are part of the series:

  https://lore.kernel.org/all/20250319173202.78988-3-shameerali.kolothum.thodi@huawei.com/
---
 drivers/iommu/iommufd/device.c          | 5 ++++-
 drivers/iommu/iommufd/iommufd_private.h | 2 ++
 drivers/vfio/iommufd.c                  | 2 +-
 include/linux/iommufd.h                 | 4 +++-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 2111bad72c72..37ef6bec2009 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -152,6 +152,7 @@ void iommufd_device_destroy(struct iommufd_object *obj)
  * iommufd_device_bind - Bind a physical device to an iommu fd
  * @ictx: iommufd file descriptor
  * @dev: Pointer to a physical device struct
+ * @kvm: Pointer to struct kvm if device belongs to a KVM VM
  * @id: Output ID number to return to userspace for this device
  *
  * A successful bind establishes an ownership over the device and returns
@@ -165,7 +166,8 @@ void iommufd_device_destroy(struct iommufd_object *obj)
  * The caller must undo this with iommufd_device_unbind()
  */
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
-					   struct device *dev, u32 *id)
+					   struct device *dev, struct kvm *kvm,
+					   u32 *id)
 {
 	struct iommufd_device *idev;
 	struct iommufd_group *igroup;
@@ -215,6 +217,7 @@ struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 	if (!iommufd_selftest_is_mock_dev(dev))
 		iommufd_ctx_get(ictx);
 	idev->dev = dev;
+	idev->kvm = kvm;
 	idev->enforce_cache_coherency =
 		device_iommu_capable(dev, IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
 	/* The calling driver is a user until iommufd_device_unbind() */
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 80e8c76d25f2..297e4e2a12d1 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -424,6 +424,8 @@ struct iommufd_device {
 	struct list_head group_item;
 	/* always the physical device */
 	struct device *dev;
+	/* ..and kvm if available */
+	struct kvm *kvm;
 	bool enforce_cache_coherency;
 	/* protect iopf_enabled counter */
 	struct mutex iopf_lock;
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index c8c3a2d53f86..3441d24538a8 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -115,7 +115,7 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 {
 	struct iommufd_device *idev;
 
-	idev = iommufd_device_bind(ictx, vdev->dev, out_device_id);
+	idev = iommufd_device_bind(ictx, vdev->dev, vdev->kvm, out_device_id);
 	if (IS_ERR(idev))
 		return PTR_ERR(idev);
 	vdev->iommufd_device = idev;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 34b6e6ca4bfa..2b2d6095309c 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -24,6 +24,7 @@ struct iommufd_ctx;
 struct iommufd_device;
 struct iommufd_viommu_ops;
 struct page;
+struct kvm;
 
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
@@ -52,7 +53,8 @@ struct iommufd_object {
 };
 
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
-					   struct device *dev, u32 *id);
+					   struct device *dev, struct kvm *kvm,
+					   u32 *id);
 void iommufd_device_unbind(struct iommufd_device *idev);
 
 int iommufd_device_attach(struct iommufd_device *idev, ioasid_t pasid,
-- 
2.25.1


