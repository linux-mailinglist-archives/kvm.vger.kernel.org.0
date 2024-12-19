Return-Path: <kvm+bounces-34154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBE29F7C82
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 14:37:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1EFD16D839
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 13:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D421863E;
	Thu, 19 Dec 2024 13:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M01joDh1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3141A21A945
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734615341; cv=none; b=CDkmpQEJnCTS2rcg+AetVN2/RwrL7eDfzwNN5oydJGRZ5wBAlflUrCoF5jcaLJdzhXH9BvkCD41LItM3YK7kY/VUaoVKEDawybK83OVH1VQ+2eHDnQgDL2PyJZGTlqYSloZwzCS1NSpZu8h5414eqBXLYrHFcq5E3m8b3QEWsTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734615341; c=relaxed/simple;
	bh=3anyELIJe46K0CHAtqHnFLaf0CmL6Zww7IVGm+tRQoo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rhMi9CXMko1f65WnMsi+0CbahP68Uvck2BdWsqqEVHA1PqHhAprbBjoApPEegombMZ3cYgIov6LcIt6H2nGhN/uOA61acGICqKMIBb4iyNkZd2GSl01kUYDKvbArU4hOMZNvYPLwuwejvK0pnlAaaYENPEPxbBtGnKvoDGtmjnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M01joDh1; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734615340; x=1766151340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3anyELIJe46K0CHAtqHnFLaf0CmL6Zww7IVGm+tRQoo=;
  b=M01joDh1gqOi953map11ql/9HHpnE25Kq6snm6beTxDQI9FIQvCX+zar
   537LI7ZaV+kHfxeCQAj8hwz6KKRgx6A3JuNaa1YgFEeorTvtgkS6z1m2l
   bgLIbYzMD+6nMnf7zinkr4lHLM4iIlPKvhM9MKRSI/C/1Ck5vaKfxjLn1
   3ZZSJjeDVhFuCJ74kZXd8tpeUQjEBTEtHJz8WLVvhA/G8eHJCToqBQXWj
   2kVJp6cD/YHJQQpnshySAClNgwE5UzrNzYgl+untgEIv1Hl9CK5SiqICj
   LYs0fN9loxuYQjCRN9x7W3oSu3bEbD23Ah6vV2A2gsFamjJb+Io/yxyms
   w==;
X-CSE-ConnectionGUID: dfTiF2ZLRU+VBUg/z4hsbA==
X-CSE-MsgGUID: qkFhAo5FRWaShai3b/ET8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="60504310"
X-IronPort-AV: E=Sophos;i="6.12,247,1728975600"; 
   d="scan'208";a="60504310"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 05:35:38 -0800
X-CSE-ConnectionGUID: TCLGpHgLRCWH4e+kaD9LUQ==
X-CSE-MsgGUID: lusWw+W+T22fXZxvwwcMcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103197885"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 19 Dec 2024 05:35:37 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	kevin.tian@intel.com
Cc: jgg@nvidia.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	yi.l.liu@intel.com,
	chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com,
	willy@infradead.org,
	zhangfei.gao@linaro.org,
	vasant.hegde@amd.com
Subject: [PATCH v6 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
Date: Thu, 19 Dec 2024 05:35:32 -0800
Message-Id: <20241219133534.16422-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241219133534.16422-1-yi.l.liu@intel.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
a given pasid of a vfio device to/from an IOAS/HWPT.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 60 +++++++++++++++++++++++++++++++++-----
 include/uapi/linux/vfio.h  | 29 +++++++++++-------
 2 files changed, 71 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index bb1817bd4ff3..6d436bee8207 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -162,9 +162,9 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
 int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 			    struct vfio_device_attach_iommufd_pt __user *arg)
 {
-	struct vfio_device *device = df->device;
 	struct vfio_device_attach_iommufd_pt attach;
-	unsigned long minsz;
+	struct vfio_device *device = df->device;
+	unsigned long minsz, xend = 0;
 	int ret;
 
 	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
@@ -172,11 +172,34 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 	if (copy_from_user(&attach, arg, minsz))
 		return -EFAULT;
 
-	if (attach.argsz < minsz || attach.flags)
+	if (attach.argsz < minsz)
 		return -EINVAL;
 
+	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
+		return -EINVAL;
+
+	if (attach.flags & VFIO_DEVICE_ATTACH_PASID) {
+		if (!device->ops->pasid_attach_ioas)
+			return -EOPNOTSUPP;
+		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
+	}
+
+	if (xend) {
+		if (attach.argsz < xend)
+			return -EINVAL;
+
+		if (copy_from_user((void *)&attach + minsz,
+				   (void __user *)arg + minsz, xend - minsz))
+			return -EFAULT;
+	}
+
 	mutex_lock(&device->dev_set->lock);
-	ret = device->ops->attach_ioas(device, &attach.pt_id);
+	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
+		ret = device->ops->pasid_attach_ioas(device,
+						     attach.pasid,
+						     &attach.pt_id);
+	else
+		ret = device->ops->attach_ioas(device, &attach.pt_id);
 	if (ret)
 		goto out_unlock;
 
@@ -198,20 +221,41 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
 			    struct vfio_device_detach_iommufd_pt __user *arg)
 {
-	struct vfio_device *device = df->device;
 	struct vfio_device_detach_iommufd_pt detach;
-	unsigned long minsz;
+	struct vfio_device *device = df->device;
+	unsigned long minsz, xend = 0;
 
 	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
 
 	if (copy_from_user(&detach, arg, minsz))
 		return -EFAULT;
 
-	if (detach.argsz < minsz || detach.flags)
+	if (detach.argsz < minsz)
 		return -EINVAL;
 
+	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
+		return -EINVAL;
+
+	if (detach.flags & VFIO_DEVICE_DETACH_PASID) {
+		if (!device->ops->pasid_detach_ioas)
+			return -EOPNOTSUPP;
+		xend = offsetofend(struct vfio_device_detach_iommufd_pt, pasid);
+	}
+
+	if (xend) {
+		if (detach.argsz < xend)
+			return -EINVAL;
+
+		if (copy_from_user((void *)&detach + minsz,
+				   (void __user *)arg + minsz, xend - minsz))
+			return -EFAULT;
+	}
+
 	mutex_lock(&device->dev_set->lock);
-	device->ops->detach_ioas(device);
+	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
+		device->ops->pasid_detach_ioas(device, detach.pasid);
+	else
+		device->ops->detach_ioas(device);
 	mutex_unlock(&device->dev_set->lock);
 
 	return 0;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index c8dbf8219c4f..6899da70b929 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -931,29 +931,34 @@ struct vfio_device_bind_iommufd {
  * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 19,
  *					struct vfio_device_attach_iommufd_pt)
  * @argsz:	User filled size of this data.
- * @flags:	Must be 0.
+ * @flags:	Flags for attach.
  * @pt_id:	Input the target id which can represent an ioas or a hwpt
  *		allocated via iommufd subsystem.
  *		Output the input ioas id or the attached hwpt id which could
  *		be the specified hwpt itself or a hwpt automatically created
  *		for the specified ioas by kernel during the attachment.
+ * @pasid:	The pasid to be attached, only meaningful when
+ *		VFIO_DEVICE_ATTACH_PASID is set in @flags
  *
  * Associate the device with an address space within the bound iommufd.
  * Undo by VFIO_DEVICE_DETACH_IOMMUFD_PT or device fd close.  This is only
  * allowed on cdev fds.
  *
- * If a vfio device is currently attached to a valid hw_pagetable, without doing
- * a VFIO_DEVICE_DETACH_IOMMUFD_PT, a second VFIO_DEVICE_ATTACH_IOMMUFD_PT ioctl
- * passing in another hw_pagetable (hwpt) id is allowed. This action, also known
- * as a hw_pagetable replacement, will replace the device's currently attached
- * hw_pagetable with a new hw_pagetable corresponding to the given pt_id.
+ * If a vfio device or a pasid of this device is currently attached to a valid
+ * hw_pagetable (hwpt), without doing a VFIO_DEVICE_DETACH_IOMMUFD_PT, a second
+ * VFIO_DEVICE_ATTACH_IOMMUFD_PT ioctl passing in another hwpt id is allowed.
+ * This action, also known as a hw_pagetable replacement, will replace the
+ * currently attached hwpt of the device or the pasid of this device with a new
+ * hwpt corresponding to the given pt_id.
  *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_attach_iommufd_pt {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_DEVICE_ATTACH_PASID	(1 << 0)
 	__u32	pt_id;
+	__u32	pasid;
 };
 
 #define VFIO_DEVICE_ATTACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 19)
@@ -962,17 +967,21 @@ struct vfio_device_attach_iommufd_pt {
  * VFIO_DEVICE_DETACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 20,
  *					struct vfio_device_detach_iommufd_pt)
  * @argsz:	User filled size of this data.
- * @flags:	Must be 0.
+ * @flags:	Flags for detach.
+ * @pasid:	The pasid to be detached, only meaningful when
+ *		VFIO_DEVICE_DETACH_PASID is set in @flags
  *
- * Remove the association of the device and its current associated address
- * space.  After it, the device should be in a blocking DMA state.  This is only
- * allowed on cdev fds.
+ * Remove the association of the device or a pasid of the device and its current
+ * associated address space.  After it, the device or the pasid should be in a
+ * blocking DMA state.  This is only allowed on cdev fds.
  *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_detach_iommufd_pt {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_DEVICE_DETACH_PASID	(1 << 0)
+	__u32	pasid;
 };
 
 #define VFIO_DEVICE_DETACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 20)
-- 
2.34.1


