Return-Path: <kvm+bounces-34728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A98D6A050BD
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 03:30:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F08BD3A728A
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87F719F42D;
	Wed,  8 Jan 2025 02:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SNXDyByd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C4519E98B;
	Wed,  8 Jan 2025 02:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736303333; cv=none; b=YRKIB+nvg+RRJt+n9XDhGvy39YpKTvDwp3KqrhNAl7Y+4vxV52vmN61W/RDycE0yYLS9AyNFWi+GIbsXY1a/fB/qYOX1s8RM2xmM4ZGFmgyhGrNKh4aGOe4Qa+iMxL7L7M7oixTXCN9hMprU7E9koTaw4KeTu2AhQWwTrHT9juY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736303333; c=relaxed/simple;
	bh=otWkkgUeiMivJEjrgfsr/A/0Wt8yPpouFUFtERZOVd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A7sJ8vHFr2OtysE4hSZXhN+Z9jqANJOD0yRt2QrOAjoIX548PM4e6FNGxZ7mWJ7tWGAMa1rH7N34EXayCEzSxXOQL1tfpMkRmaDrOV6VXIoF7OXf87eU6KV/IxdSR0oBp068Vg0/WMjxsbGFdAahJCltGkO6YYzmBIOaGZpseeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SNXDyByd; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736303332; x=1767839332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=otWkkgUeiMivJEjrgfsr/A/0Wt8yPpouFUFtERZOVd0=;
  b=SNXDyByd46+6XIEXNduokyMO+rw+vjtXeV08FAklMm6lcgMWX3MempGw
   U1woe1xKCrsgjiQyw2kGYO/GRFse89O3Cr8sEf5Q7NJlMX/tU9HB/a6K+
   fqf9QO6b50UWQ0SdXgUxPx4LCOmVCTqXVeRvidapjh+oJzTOH6qBpfnBg
   7Isx71ilh1zeLmJ4uLH57eLDcfxSvWvku4KXvd4t/oeTDVXwLm7suLPJu
   96KtJComV4EAdRZyJU2FGW8Cb7OeDGUb+kWLPTMIVji7EithiY43raqNo
   qAveJzst2t++hRU3s2BOwJajBo/xu980GhUiCRzYwy4iZ8Rls9QNwSj2g
   A==;
X-CSE-ConnectionGUID: PX6InvjuT/KAndtPDFMwNA==
X-CSE-MsgGUID: AXIAptNFSw+qe6LAaht/xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47010499"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="47010499"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 18:28:52 -0800
X-CSE-ConnectionGUID: AYUspgPUQrSA4seOzX8GZA==
X-CSE-MsgGUID: ZHy1gbacQMGfWoRc81VWEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103793662"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 07 Jan 2025 18:28:47 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	vivek.kasireddy@intel.com,
	dan.j.williams@intel.com,
	aik@amd.com
Cc: yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: [RFC PATCH 05/12] vfio/pci: Support get_pfn() callback for dma-buf
Date: Tue,  7 Jan 2025 22:27:12 +0800
Message-Id: <20250107142719.179636-6-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250107142719.179636-1-yilun.xu@linux.intel.com>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement get_pfn() callback for exported MMIO resources.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/vfio/pci/dma_buf.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/dma_buf.c b/drivers/vfio/pci/dma_buf.c
index 1d5f46744922..ad12cfb85099 100644
--- a/drivers/vfio/pci/dma_buf.c
+++ b/drivers/vfio/pci/dma_buf.c
@@ -33,8 +33,34 @@ static int vfio_pci_dma_buf_pin(struct dma_buf_attachment *attachment)
 static int vfio_pci_dma_buf_get_pfn(struct dma_buf_attachment *attachment,
 				    pgoff_t pgoff, u64 *pfn, int *max_order)
 {
-	/* TODO */
-	return -EOPNOTSUPP;
+	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
+	struct vfio_region_dma_range *dma_ranges = priv->dma_ranges;
+	u64 offset = pgoff << PAGE_SHIFT;
+	int i;
+
+	dma_resv_assert_held(priv->dmabuf->resv);
+
+	if (priv->revoked)
+		return -ENODEV;
+
+	if (offset >= priv->dmabuf->size)
+		return -EINVAL;
+
+	for (i = 0; i < priv->nr_ranges; i++) {
+		if (offset < dma_ranges[i].length)
+			break;
+
+		offset -= dma_ranges[i].length;
+	}
+
+	*pfn = PHYS_PFN(pci_resource_start(priv->vdev->pdev, dma_ranges[i].region_index) +
+			dma_ranges[i].offset + offset);
+
+	/* TODO: large page mapping is yet to be supported */
+	if (max_order)
+		*max_order = 0;
+
+	return 0;
 }
 
 static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
-- 
2.25.1


