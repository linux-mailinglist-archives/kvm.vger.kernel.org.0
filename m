Return-Path: <kvm+bounces-65807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A45BCB79D8
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 03:07:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3AC383049B0A
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 02:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A3D279795;
	Fri, 12 Dec 2025 02:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GVWKU+4l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0688428B3E7;
	Fri, 12 Dec 2025 02:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505172; cv=none; b=N7eUG7a4uib+SOvYEt7rPUI84a3R6o5TxvYySNeVUYTZX+aCEX+L2ZhcQRj/inDEDupODvuCa1qd7Wc7IB/0TsM9ofnA+v6ZYriIqQMmh4QUw+ygWiI0m3jKZLGWt4GHGu8gnAJs7FoI9kviLjSY4BawMRmvrOiLu26cVuLMpg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505172; c=relaxed/simple;
	bh=zWYSYTi2Ehk5Tt/y3fdV2e1WlZ0xEil7gXV+7es5qx0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L6Q3on9F5PX7ofzumsA1i/tDBf04VxdqytmFgm8u+jjskcQs+TyeHgZqEtPVKYwsteomoPcZnePj9YECvKkuuHeUE0YYt4NTAuZ9mGNaAsVO8i4XPh3IuLrp+lx9/6OMeOkh2hDfyA3WZsBp0Bq4APe1ewhFZinEYzENl7JFoto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GVWKU+4l; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765505170; x=1797041170;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zWYSYTi2Ehk5Tt/y3fdV2e1WlZ0xEil7gXV+7es5qx0=;
  b=GVWKU+4lO9xgytUdtWCzjEmSbQgtWTdmq55K8WrHnoNGDKTWlWuAcCTn
   K7uOJm6JEucSfB3Oo16Lmpe03l1N14I7zufpxk28NBKaHC6NqUxhK0snM
   MvDrX9KqntUp/IIhR7UCBjtmANf/F6SMVFxLh13ohPCXJ/HaDu7rkLmBz
   503CDO51xDSmzb9XrS16I/5cPpJF14OTK8H8ORuDxa1EmZsv6ELBW+lQb
   TC27XtKcvbfl4m2zhmT6uiWZm4ghLntwQUzljD1USV2cEZVGvK2UVQJkE
   Dqn/MTsePWcv26Jpc7JEZEKX+nQnTjGAFugfRUY56ZIJmJxagGiYbOLpg
   g==;
X-CSE-ConnectionGUID: zEFudGiNRxCgFDj+pPzw0Q==
X-CSE-MsgGUID: LhAE9XZyT2K4dtkq0PT/wA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67426620"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="67426620"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:06:09 -0800
X-CSE-ConnectionGUID: N0HMPccjQ16B1lIH6itCpw==
X-CSE-MsgGUID: +m5jObAeSVyE4l0jvy/4YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="197768043"
Received: from ktian1-pkvm.sh.intel.com ([10.239.48.205])
  by fmviesa010.fm.intel.com with ESMTP; 11 Dec 2025 18:06:06 -0800
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
Subject: [PATCH] vfio/pci: Disable qword access to the PCI ROM bar
Date: Fri, 12 Dec 2025 02:09:41 +0000
Message-ID: <20251212020941.338355-1-kevin.tian@intel.com>
X-Mailer: git-send-email 2.43.0
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
 drivers/vfio/pci/vfio_pci_rdwr.c    | 19 +++++++++++++++----
 include/linux/vfio_pci_core.h       |  2 +-
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..9b39184f76b7 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -491,7 +491,7 @@ nvgrace_gpu_map_and_read(struct nvgrace_gpu_pci_core_device *nvdev,
 		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
 					     nvdev->resmem.ioaddr,
 					     buf, offset, mem_count,
-					     0, 0, false);
+					     0, 0, false, true);
 	}
 
 	return ret;
@@ -609,7 +609,7 @@ nvgrace_gpu_map_and_write(struct nvgrace_gpu_pci_core_device *nvdev,
 		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
 					     nvdev->resmem.ioaddr,
 					     (char __user *)buf, pos, mem_count,
-					     0, 0, true);
+					     0, 0, true, true);
 	}
 
 	return ret;
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 6192788c8ba3..95dc7e04cb08 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -135,7 +135,7 @@ VFIO_IORDWR(64)
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
-			       size_t x_end, bool iswrite)
+			       size_t x_end, bool iswrite, bool allow_qword)
 {
 	ssize_t done = 0;
 	int ret;
@@ -150,7 +150,7 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
-		if (fillable >= 8 && !(off % 8)) {
+		if (allow_qword && fillable >= 8 && !(off % 8)) {
 			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
 			if (ret)
@@ -234,6 +234,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	void __iomem *io;
 	struct resource *res = &vdev->pdev->resource[bar];
 	ssize_t done;
+	bool allow_qword = true;
 
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
+		allow_qword = false;
 	} else {
 		int ret = vfio_pci_core_setup_barmap(vdev, bar);
 		if (ret) {
@@ -278,7 +289,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	}
 
 	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
-				      count, x_start, x_end, iswrite);
+				      count, x_start, x_end, iswrite, allow_qword);
 
 	if (done >= 0)
 		*ppos += done;
@@ -352,7 +363,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	 * to the memory enable bit in the command register.
 	 */
 	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
-				      0, 0, iswrite);
+				      0, 0, iswrite, true);
 
 	vga_put(vdev->pdev, rsrc);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..3a75b76eaed3 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -133,7 +133,7 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
-			       size_t x_end, bool iswrite);
+			       size_t x_end, bool iswrite, bool allow_qword);
 bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
 					 loff_t reg_start, size_t reg_cnt,
 					 loff_t *buf_offset,
-- 
2.43.0


