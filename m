Return-Path: <kvm+bounces-47941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C2BAC7807
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B651F502008
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3621C25DCF3;
	Thu, 29 May 2025 05:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Knq/9+K8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DA525484D;
	Thu, 29 May 2025 05:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497364; cv=none; b=EMG5JHjaJD/q5srzSIbs6ljcRomVFkUo1/IT+Avf9dQsEWZeuSU+u95wgrKWIrg7EoQIcu9UwD5tip4g/yZd6bs/dQfgAClNeM4i/fmMubIlCRt0EdynoHEJrBb/uh2MPuMJWKuz3ZvpVQWHaGMENRoQE/x4njLLI3oXIZxjTvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497364; c=relaxed/simple;
	bh=r8jQZ+fhgbYHTsi3rR/12Px/bML06/rj6uFZHcdwCGw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cebBI36J07gXd0HDRuHzcPB9l4Mp5gD7zpecqkWJJSlxjffN1497rpQBfhxJ+ishcOvys+c97OoDioGlcBdNeIYeIRH0r0OQ6YzdZ7oXlgL4q4sWtuAWMMyk72KHQHUgqexQEslvHv5M7X2gOeTeEOvouJ3V0gCvODBeh5965EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Knq/9+K8; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497363; x=1780033363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r8jQZ+fhgbYHTsi3rR/12Px/bML06/rj6uFZHcdwCGw=;
  b=Knq/9+K8e4GzRc6xQZBT553+1EOzk88/Qdj78ALx0Ulxt+7wzJpM4EX8
   Mx/SFJYiUJzheaNDm6T3pCs8LgHwr6n7hPNAepaSwNdgvC2+TriYMzP3P
   o3jtrurFZVWJUIuqKKRj4Yy/6BX0spdFrnXJl9E6Cb+irs89oKfSraKUm
   DuAskrJJIV5uiXWu2P0WqYP7AgZiVsi14uUTjcOrVAeni7RGe46AnEknV
   G3SOzPv5hkos2CQXiESjP/BEZQhU/vLu9ExD85c8LLsp6OlL7N0buNzJq
   GXvKsTMpnvst6HFcAIL/filmmjeySnDHtR9SLKOHNJHujz1JWZoEHnfSe
   w==;
X-CSE-ConnectionGUID: iG1IEb/4S3eQLEVUA0jmFA==
X-CSE-MsgGUID: 8iU0S3GgQnS0vwcPTqnIPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963050"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963050"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:42:42 -0700
X-CSE-ConnectionGUID: Biwv1OXpRvy58RsS0/YMJQ==
X-CSE-MsgGUID: CIW/OnndQ3GZeLSRRy7fZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443347"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:42:35 -0700
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
Subject: [RFC PATCH 10/30] vfio/pci: Export vfio dma-buf specific info for importers
Date: Thu, 29 May 2025 13:34:53 +0800
Message-Id: <20250529053513.1592088-11-yilun.xu@linux.intel.com>
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

Export vfio dma-buf specific info by attaching vfio_dma_buf_data in
struct dma_buf::priv. Provide a helper vfio_dma_buf_get_data() for
importers to fetch these data. Exporters identify VFIO dma-buf by
successfully getting these data.

VFIO dma-buf supports disabling host access to these exported MMIO
regions when the device is converted to private. Exporters like KVM
need to identify this type of dma-buf to decide if it is good to use.
KVM only allows host unaccessible MMIO regions been mapped in private
roots.

Export struct kvm * handler attached to the vfio device. This
allows KVM to do another sanity check. MMIO should only be assigned to
a CoCo VM if its owner device is already assigned to the same VM.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 18 ++++++++++++++++++
 include/linux/vfio.h               | 18 ++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index cf9a90448856..4011545db3ad 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -10,6 +10,8 @@
 MODULE_IMPORT_NS("DMA_BUF");
 
 struct vfio_pci_dma_buf {
+	struct vfio_dma_buf_data export_data;
+
 	struct dma_buf *dmabuf;
 	struct vfio_pci_core_device *vdev;
 	struct list_head dmabufs_elm;
@@ -300,6 +302,8 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 	priv->nr_ranges = get_dma_buf.nr_ranges;
 	priv->dma_ranges = dma_ranges;
 
+	priv->export_data.kvm = vdev->vdev.kvm;
+
 	ret = check_dma_ranges(priv, &dmabuf_size);
 	if (ret)
 		goto err_free_priv;
@@ -391,3 +395,17 @@ void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
 	}
 	up_write(&vdev->memory_lock);
 }
+
+/*
+ * Only vfio/pci implements this, so put the helper here for now.
+ */
+struct vfio_dma_buf_data *vfio_dma_buf_get_data(struct dma_buf *dmabuf)
+{
+	struct vfio_pci_dma_buf *priv = dmabuf->priv;
+
+	if (dmabuf->ops != &vfio_pci_dmabuf_ops)
+		return ERR_PTR(-EINVAL);
+
+	return &priv->export_data;
+}
+EXPORT_SYMBOL_GPL(vfio_dma_buf_get_data);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ba65bbdffd0b..d521d2c01a92 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -9,6 +9,7 @@
 #define VFIO_H
 
 
+#include <linux/dma-buf.h>
 #include <linux/iommu.h>
 #include <linux/mm.h>
 #include <linux/workqueue.h>
@@ -383,4 +384,21 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
+/*
+ * DMA-buf - generic
+ */
+struct vfio_dma_buf_data {
+	struct kvm *kvm;
+};
+
+#if IS_ENABLED(CONFIG_DMA_SHARED_BUFFER) && IS_ENABLED(CONFIG_VFIO_PCI_CORE)
+struct vfio_dma_buf_data *vfio_dma_buf_get_data(struct dma_buf *dmabuf);
+#else
+static inline
+struct vfio_dma_buf_data *vfio_dma_buf_get_data(struct dma_buf *dmabuf)
+{
+	return NULL;
+}
+#endif
+
 #endif /* VFIO_H */
-- 
2.25.1


