Return-Path: <kvm+bounces-38314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B95B0A37224
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 06:47:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D810A1892221
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 05:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7421547F3;
	Sun, 16 Feb 2025 05:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y2msebLz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B7D13DDAE
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 05:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739684805; cv=none; b=q5SuyBZMe416sn1W5NaGXB/+tY1wDk9FAdfkn3wFI5d5fs+erDue2o3qO2f7iQ3uUus1p4hZBXoOFdGVR4dIgKM+OFixX+Xhs6diIlWZd25g4nN/pI4lySJaoN29J4QhmmuOJfR+5Zmp8+RJ99xJwZkZX2BbhccNHAaxznSqYy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739684805; c=relaxed/simple;
	bh=9j1wFnERO/FmX/HyIif1kOvae7k7J77O297T3e3kkto=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mQkMZzxQX1JsxInYZNTsBtXFieD1CzjsE/8v2Ys5g91CRMLuNT9SBF3IpTGoQqufKvTUZ4b9z3osOXArBizvbvr9TEIrnD6saSbJS7N30RKyIz2Yn7V07XNJ+dqk1p1/Uxne25dlpWYhEyvuQLdBsukEgXjlD4EWpaQ/JSy4k0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y2msebLz; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739684804; x=1771220804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9j1wFnERO/FmX/HyIif1kOvae7k7J77O297T3e3kkto=;
  b=Y2msebLzRZtYXceHklU5MijDw9J0dc6QpV4xqbGyvFvo6oTGuRizbamn
   l8JoeYoI95zZ+YBIDwhUFOD6WJIAM3dvhFO2UMRD9rWlpz8N6eDBzTYXE
   vbJ62NotBDw3L5rEBF4QPu4c8vk3D9hMlN5znDk56M364cluo0NsKafHc
   3ZJg8iPuPfnrgGhdg8tqh5Jk0Ge5mm/udr+AEt0YgHBfCFGWeNTx/EX+h
   oGBFwEYju2Wy/8Vsb2qn1YRv2vP8jDNrY4amRYmbnOBto7Zfr3Bra4rv4
   odsU5HMIv+n2tZL1Y7x+EDzH/3Y9teSY29SoxaO6wMUlWv7nmtDcbArgT
   A==;
X-CSE-ConnectionGUID: zSKmFeXZQ7qhK2OxszQePg==
X-CSE-MsgGUID: JRK+Oi6iRYmz1SD9NXHusA==
X-IronPort-AV: E=McAfee;i="6700,10204,11346"; a="51373260"
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="51373260"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 21:46:42 -0800
X-CSE-ConnectionGUID: qaT2/04RQGaM0K5Rrbqheg==
X-CSE-MsgGUID: iuhVW6JlQFCPiCIYojpsfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="114330746"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 15 Feb 2025 21:46:40 -0800
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
Subject: [PATCH v7 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
Date: Sat, 15 Feb 2025 21:46:36 -0800
Message-Id: <20250216054638.24603-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250216054638.24603-1-yi.l.liu@intel.com>
References: <20250216054638.24603-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
a given pasid of a vfio device to/from an IOAS/HWPT.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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


