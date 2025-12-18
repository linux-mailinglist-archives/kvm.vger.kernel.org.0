Return-Path: <kvm+bounces-66223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D87CCAFB3
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF2C531024F6
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B7A2F1FDA;
	Thu, 18 Dec 2025 08:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hMCu05DP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23046333448;
	Thu, 18 Dec 2025 08:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766045637; cv=none; b=TCk8jcim9wfaCUUiNsTtt9Go2Y+MBrAGZyG4Z9KlxIE/nWOX9MOeUNcRZyGcYhSHVQ4ohPB1TIA1Hj6ACETbJnWupRYXLJOh9iLGOiLw3fZDdYVAuGxtR1a8s7XfDopMZPIyv5vYlxJO2rEYSbS4AzAwGKHLTiXzAl52eyjLH4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766045637; c=relaxed/simple;
	bh=LPy2nkr2uUsa/AsKo+y0EL7tSUw/KvNubvu4ZE1BNng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYxBSfkdB5ukRLFaNGA2D/blOAgpVxtdC4Foa18ajaLVV6nZLnLHoiFhGfYEZ33SReMcTeyhSJmQfnWeWBPmqd4+UphZr5zEQbFUqcauXG96vRPZn2x5quQ2Y6OZO3ZHeh7Yw3tMrm1L67sIfQRZRk47hALF6eIr9VRRS+hqhtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hMCu05DP; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766045636; x=1797581636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LPy2nkr2uUsa/AsKo+y0EL7tSUw/KvNubvu4ZE1BNng=;
  b=hMCu05DPt/fiP8DH0/7q9Xsm6AR0MXqb9sdAZZcKsJetcG4b6L9+GXG6
   A1wG24NA7evqJhaKLMCL9o3S9bt76zWu+E4W5k29ae/TEDagdBv011Guf
   12dLh4+g/CCQuKjIlg8raB1u60ioYNbbCxXD1BiNzB3Q4ie9lUT3AH72Y
   JZOWxrRgjcWvHsZ6otZllc9sM74VU0B/bTffkYCSZ+Pl8RKmR2V7J4ru1
   HQcQQjTKxkpRHfrxwc3quFmPfZi6oTJIhjmUHpsPMumN3f7fcWO0ON38l
   hh5imuf0cqda5/tCtOYq0SI897J9C/uPm8VVpPhK8C5P/F5BSpdTMSm29
   g==;
X-CSE-ConnectionGUID: 5R1I9wRSSVqV+STwsYgLNA==
X-CSE-MsgGUID: F16WcVLnS4WS9F+BVKUCew==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="67188175"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="67188175"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 00:13:55 -0800
X-CSE-ConnectionGUID: 3fKHEHmORKuIuE/8DtECpw==
X-CSE-MsgGUID: 9E3bKr33S360M2EEpzTzFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198599624"
Received: from ktian1-pkvm.sh.intel.com ([10.239.48.205])
  by orviesa008.jf.intel.com with ESMTP; 18 Dec 2025 00:13:52 -0800
From: Kevin Tian <kevin.tian@intel.com>
To: Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ramesh Thomas <ramesh.thomas@intel.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] vfio/pci: Disable qword access to the PCI ROM bar
Date: Thu, 18 Dec 2025 08:16:49 +0000
Message-ID: <20251218081650.555015-2-kevin.tian@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251218081650.555015-1-kevin.tian@intel.com>
References: <20251218081650.555015-1-kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 2b938e3db335 ("vfio/pci: Enable iowrite64 and ioread64 for vfio
pci") enables qword access to the PCI bar resources. However certain
devices (e.g. Intel X710) are observed with problem upon qword accesses
to the rom bar, e.g. triggering PCI aer errors.

This is triggered by Qemu which caches the rom content by simply does a
pread() of the remaining size until it gets the full contents. The other
bars would only perform operations at the same access width as their
guest drivers.

Instead of trying to identify all broken devices, universally disable
qword access to the rom bar i.e. going back to the old way which worked
reliably for years.

Reported-by: Farrah Chen <farrah.chen@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220740
Fixes: 2b938e3db335 ("vfio/pci: Enable iowrite64 and ioread64 for vfio pci")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c |  4 ++--
 drivers/vfio/pci/vfio_pci_rdwr.c    | 25 ++++++++++++++++++-------
 include/linux/vfio_pci_core.h       | 10 +++++++++-
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 84d142a47ec6..b45a24d00387 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -561,7 +561,7 @@ nvgrace_gpu_map_and_read(struct nvgrace_gpu_pci_core_device *nvdev,
 		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
 					     nvdev->resmem.ioaddr,
 					     buf, offset, mem_count,
-					     0, 0, false);
+					     0, 0, false, VFIO_PCI_IO_WIDTH_8);
 	}
 
 	return ret;
@@ -693,7 +693,7 @@ nvgrace_gpu_map_and_write(struct nvgrace_gpu_pci_core_device *nvdev,
 		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
 					     nvdev->resmem.ioaddr,
 					     (char __user *)buf, pos, mem_count,
-					     0, 0, true);
+					     0, 0, true, VFIO_PCI_IO_WIDTH_8);
 	}
 
 	return ret;
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 6192788c8ba3..25380b7dfe18 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -135,7 +135,8 @@ VFIO_IORDWR(64)
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
-			       size_t x_end, bool iswrite)
+			       size_t x_end, bool iswrite,
+			       enum vfio_pci_io_width max_width)
 {
 	ssize_t done = 0;
 	int ret;
@@ -150,20 +151,19 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
-		if (fillable >= 8 && !(off % 8)) {
+		if (fillable >= 8 && !(off % 8) && max_width >= 8) {
 			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
 			if (ret)
 				return ret;
 
-		} else
-		if (fillable >= 4 && !(off % 4)) {
+		} else if (fillable >= 4 && !(off % 4) && max_width >= 4) {
 			ret = vfio_pci_iordwr32(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
 			if (ret)
 				return ret;
 
-		} else if (fillable >= 2 && !(off % 2)) {
+		} else if (fillable >= 2 && !(off % 2) && max_width >= 2) {
 			ret = vfio_pci_iordwr16(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
 			if (ret)
@@ -234,6 +234,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	void __iomem *io;
 	struct resource *res = &vdev->pdev->resource[bar];
 	ssize_t done;
+	enum vfio_pci_io_width max_width = VFIO_PCI_IO_WIDTH_8;
 
 	if (pci_resource_start(pdev, bar))
 		end = pci_resource_len(pdev, bar);
@@ -262,6 +263,16 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		if (!io)
 			return -ENOMEM;
 		x_end = end;
+
+		/*
+		 * Certain devices (e.g. Intel X710) don't support qword
+		 * access to the ROM bar. Otherwise PCI AER errors might be
+		 * triggered.
+		 *
+		 * Disable qword access to the ROM bar universally, which
+		 * worked reliably for years before qword access is enabled.
+		 */
+		max_width = VFIO_PCI_IO_WIDTH_4;
 	} else {
 		int ret = vfio_pci_core_setup_barmap(vdev, bar);
 		if (ret) {
@@ -278,7 +289,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	}
 
 	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
-				      count, x_start, x_end, iswrite);
+				      count, x_start, x_end, iswrite, max_width);
 
 	if (done >= 0)
 		*ppos += done;
@@ -352,7 +363,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	 * to the memory enable bit in the command register.
 	 */
 	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
-				      0, 0, iswrite);
+				      0, 0, iswrite, VFIO_PCI_IO_WIDTH_8);
 
 	vga_put(vdev->pdev, rsrc);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 706877f998ff..1ac86896875c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -145,6 +145,13 @@ struct vfio_pci_core_device {
 	struct list_head	dmabufs;
 };
 
+enum vfio_pci_io_width {
+	VFIO_PCI_IO_WIDTH_1 = 1,
+	VFIO_PCI_IO_WIDTH_2 = 2,
+	VFIO_PCI_IO_WIDTH_4 = 4,
+	VFIO_PCI_IO_WIDTH_8 = 8,
+};
+
 /* Will be exported for vfio pci drivers usage */
 int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 				      unsigned int type, unsigned int subtype,
@@ -188,7 +195,8 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
-			       size_t x_end, bool iswrite);
+			       size_t x_end, bool iswrite,
+			       enum vfio_pci_io_width max_width);
 bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
 bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
 					 loff_t reg_start, size_t reg_cnt,
-- 
2.43.0


