Return-Path: <kvm+bounces-47948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7DE3AC7833
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98A3A1686FF
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33276266F0D;
	Thu, 29 May 2025 05:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KuvkG8Eu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B700B265CAC;
	Thu, 29 May 2025 05:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497409; cv=none; b=juDBgLYXcs6syWupac0dr6haibZejjxBY9p+5UVXaBq9/NwULY2H9/Z2sNmxMpngZcbPRU9QnujHxhzAZAL7jnChdzzw6mTFXs4hzloOElD3W+NeoUzhaIUD057artMq3n2TREoTwGiJ6Y95ASRtlSnMvcNEC2vdjmDzTHUeZIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497409; c=relaxed/simple;
	bh=vP92koKVunofrqlnPlqCNDul5Llw0DB0fsaPd9kiOSU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oAZs+tM7Qnp5nUVl70gHZWuewvxyOpZuID4BYkwO72EINN3I27w5W9UeZcfPdb9jzKtDTZO4rNWHjZlMyvY1W96zUzpkV16tb5ewqluKUpS+PscEqsSPDU6di/IKxmK73yFZIPGib2b2OoOPmijT92eRHNdfI4akwInwAXsBO74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KuvkG8Eu; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497408; x=1780033408;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vP92koKVunofrqlnPlqCNDul5Llw0DB0fsaPd9kiOSU=;
  b=KuvkG8Euhf2itkJHNfV0ur3MFHtrSmOyapDJipIAAmYskcuyw8KEUrnI
   N//evaynJNTiY48lfc9oW79haov9S0QXm74IAhlOwn40RtcpylhAZTaGq
   7eaL5tnu50ts4pByRREajT9lF7QcwXxDQW8fE5HHjUULSFyP/HiWlpMen
   KsGbK+nycRInVgbVjwUSMsXFYf768BcPcJsh3vRHfI8KskRKa0nqjSOTD
   30xATh9SHW4VGabK2Fuitdh9/K2P2RY2EWYqyUEX6jrqFaKbBWbc4WJhi
   Lu/QcQLtZsVB8G+z4quQQZnhFp6rGkxZc2i/Cr4bxxf5Yycc4K/97WXI5
   w==;
X-CSE-ConnectionGUID: GUvb0evXR1OnFqT+HoN8ZQ==
X-CSE-MsgGUID: ZRkpEC89RfaQZY2sMz6SKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963223"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963223"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:43:28 -0700
X-CSE-ConnectionGUID: dg5mUtXITPSP2NYLPwER9w==
X-CSE-MsgGUID: f+/Gs+kRTsKqO/91QWb0IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443443"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:43:21 -0700
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
Subject: [RFC PATCH 17/30] iommufd/device: Add TSM Bind/Unbind for TIO support
Date: Thu, 29 May 2025 13:35:00 +0800
Message-Id: <20250529053513.1592088-18-yilun.xu@linux.intel.com>
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

Add new kAPIs against iommufd_device to support TSM Bind/Unbind
commands issued by CoCo-VM. The TSM bind means VMM does all
preparations for private device assignement, lock down the device by
transiting it to TDISP CONFIG_LOCKED or RUN state (when in RUN state,
TSM could still block any accessing to/from device), so that the device
is ready for attestation by CoCo-VM.

The interfaces are added against IOMMUFD because IOMMUFD builds several
abstract objects applicable for private device assignment, e.g. viommu
for secure iommu & kvm, vdevice for vBDF. IOMMUFD links them up to
finish all configurations required by secure firmware. That also means
TSM Bind interface should be called after viommu & vdevice allocation.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Originally-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/iommu/iommufd/device.c          | 84 +++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |  6 ++
 drivers/iommu/iommufd/viommu.c          | 44 +++++++++++++
 include/linux/iommufd.h                 |  3 +
 4 files changed, 137 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 37ef6bec2009..984780c66ab2 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -3,6 +3,7 @@
  */
 #include <linux/iommu.h>
 #include <linux/iommufd.h>
+#include <linux/pci.h>
 #include <linux/pci-ats.h>
 #include <linux/slab.h>
 #include <uapi/linux/iommufd.h>
@@ -1561,3 +1562,86 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(ucmd->ictx, &idev->obj);
 	return rc;
 }
+
+/**
+ * iommufd_device_tsm_bind - Move a device to TSM Bind state
+ * @idev: device to attach
+ * @vdev_id: Input a IOMMUFD_OBJ_VDEVICE
+ *
+ * This configures for device Confidential Computing(CC), and moves the device
+ * to the TSM Bind state. Once this completes the device is locked down (TDISP
+ * CONFIG_LOCKED or RUN), waiting for guest's attestation.
+ *
+ * This function is undone by calling iommufd_device_tsm_unbind().
+ */
+int iommufd_device_tsm_bind(struct iommufd_device *idev, u32 vdevice_id)
+{
+	struct iommufd_vdevice *vdev;
+	int rc;
+
+	if (!dev_is_pci(idev->dev))
+		return -ENODEV;
+
+	vdev = container_of(iommufd_get_object(idev->ictx, vdevice_id, IOMMUFD_OBJ_VDEVICE),
+			    struct iommufd_vdevice, obj);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	if (vdev->dev != idev->dev) {
+		rc = -EINVAL;
+		goto out_put_vdev;
+	}
+
+	mutex_lock(&idev->igroup->lock);
+	if (idev->vdev) {
+		rc = -EEXIST;
+		goto out_unlock;
+	}
+
+	rc = iommufd_vdevice_tsm_bind(vdev);
+	if (rc)
+		goto out_unlock;
+
+	idev->vdev = vdev;
+	refcount_inc(&vdev->obj.users);
+	mutex_unlock(&idev->igroup->lock);
+
+	/*
+	 * Pairs with iommufd_device_tsm_unbind() - catches caller bugs attempting
+	 * to destroy a bound device.
+	 */
+	refcount_inc(&idev->obj.users);
+	goto out_put_vdev;
+
+out_unlock:
+	mutex_unlock(&idev->igroup->lock);
+out_put_vdev:
+	iommufd_put_object(idev->ictx, &vdev->obj);
+	return rc;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_tsm_bind, "IOMMUFD");
+
+/**
+ * iommufd_device_tsm_unbind - Move a device out of TSM bind state
+ * @idev: device to detach
+ *
+ * Undo iommufd_device_tsm_bind(). This removes all Confidential Computing
+ * configurations, Once this completes the device is unlocked (TDISP
+ * CONFIG_UNLOCKED).
+ */
+void iommufd_device_tsm_unbind(struct iommufd_device *idev)
+{
+	mutex_lock(&idev->igroup->lock);
+	if (!idev->vdev) {
+		mutex_unlock(&idev->igroup->lock);
+		return;
+	}
+
+	iommufd_vdevice_tsm_unbind(idev->vdev);
+	refcount_dec(&idev->vdev->obj.users);
+	idev->vdev = NULL;
+	mutex_unlock(&idev->igroup->lock);
+
+	refcount_dec(&idev->obj.users);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_tsm_unbind, "IOMMUFD");
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 297e4e2a12d1..29af8616e4aa 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -430,6 +430,7 @@ struct iommufd_device {
 	/* protect iopf_enabled counter */
 	struct mutex iopf_lock;
 	unsigned int iopf_enabled;
+	struct iommufd_vdevice *vdev;
 };
 
 static inline struct iommufd_device *
@@ -615,8 +616,13 @@ struct iommufd_vdevice {
 	struct iommufd_viommu *viommu;
 	struct device *dev;
 	u64 id; /* per-vIOMMU virtual ID */
+	struct mutex tsm_lock;
+	bool tsm_bound;
 };
 
+int iommufd_vdevice_tsm_bind(struct iommufd_vdevice *vdev);
+void iommufd_vdevice_tsm_unbind(struct iommufd_vdevice *vdev);
+
 #ifdef CONFIG_IOMMUFD_TEST
 int iommufd_test(struct iommufd_ucmd *ucmd);
 void iommufd_selftest_destroy(struct iommufd_object *obj);
diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 2fcef3f8d1a5..296143e21368 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -4,6 +4,7 @@
 #if IS_ENABLED(CONFIG_KVM)
 #include <linux/kvm_host.h>
 #endif
+#include <linux/pci-tsm.h>
 
 #include "iommufd_private.h"
 
@@ -193,11 +194,13 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_idev;
 	}
 
+	vdev->ictx = ucmd->ictx; //This is a unrelated fix for vdevice alloc
 	vdev->id = virt_id;
 	vdev->dev = idev->dev;
 	get_device(idev->dev);
 	vdev->viommu = viommu;
 	refcount_inc(&viommu->obj.users);
+	mutex_init(&vdev->tsm_lock);
 
 	curr = xa_cmpxchg(&viommu->vdevs, virt_id, NULL, vdev, GFP_KERNEL);
 	if (curr) {
@@ -220,3 +223,44 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(ucmd->ictx, &viommu->obj);
 	return rc;
 }
+
+int iommufd_vdevice_tsm_bind(struct iommufd_vdevice *vdev)
+{
+	struct kvm *kvm;
+	int rc;
+
+	mutex_lock(&vdev->tsm_lock);
+	if (vdev->tsm_bound) {
+		rc = -EEXIST;
+		goto out_unlock;
+	}
+
+	kvm = vdev->viommu->kvm;
+	if (!kvm) {
+		rc = -ENOENT;
+		goto out_unlock;
+	}
+
+	rc = pci_tsm_bind(to_pci_dev(vdev->dev), kvm, vdev->id);
+	if (rc)
+		goto out_unlock;
+
+	vdev->tsm_bound = true;
+
+out_unlock:
+	mutex_unlock(&vdev->tsm_lock);
+	return rc;
+}
+
+void iommufd_vdevice_tsm_unbind(struct iommufd_vdevice *vdev)
+{
+	mutex_lock(&vdev->tsm_lock);
+	if (!vdev->tsm_bound)
+		goto out_unlock;
+
+	pci_tsm_unbind(to_pci_dev(vdev->dev));
+	vdev->tsm_bound = false;
+
+out_unlock:
+	mutex_unlock(&vdev->tsm_lock);
+}
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 2712421802b9..5f9a286232ac 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -63,6 +63,9 @@ int iommufd_device_replace(struct iommufd_device *idev, ioasid_t pasid,
 			   u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev, ioasid_t pasid);
 
+int iommufd_device_tsm_bind(struct iommufd_device *idev, u32 vdevice_id);
+void iommufd_device_tsm_unbind(struct iommufd_device *idev);
+
 struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
 u32 iommufd_device_to_id(struct iommufd_device *idev);
 
-- 
2.25.1


