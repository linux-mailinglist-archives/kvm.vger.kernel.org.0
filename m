Return-Path: <kvm+bounces-33415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B5C9EB1D8
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:26:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5688228465A
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 13:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE75D1AAA01;
	Tue, 10 Dec 2024 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F6DqMCih"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6765E1A9B35;
	Tue, 10 Dec 2024 13:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733837138; cv=none; b=elbZUkFTj54KO+XSIKzSTnlwUc+x7LABm6J1GxmJJtS0AJSsLSBnOahogYG562a3y3xR/tzonS5OJ/BloWvTJIeHkT4mP/K0D/ZoW7U76n+pa/cI+N+UUoTDg3n5oHkLN64vRLsCoLGrBRn6s1LyBit6IMlTxiK+tqfzFJtCWWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733837138; c=relaxed/simple;
	bh=bi31w4C9P7/TJaW7cGQs0Y+Rs38Ld+aZeTlgD6CpGxM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RDVo2QCKBITvmOdi330JZs/scjlZTLQv8cuouy54UsUiKBQCwddlNOz1zw9gyNSeU6glb/d0jaAewKlKIbNcvReNxp0ykfN5iZFT42+ku7UrDJSBch1YdfHvdVkYJv0ml7aW4psU9xadtl4LtrlWss/yWaj4uTEbjrEXlZZ7zRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F6DqMCih; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733837136; x=1765373136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bi31w4C9P7/TJaW7cGQs0Y+Rs38Ld+aZeTlgD6CpGxM=;
  b=F6DqMCihYYsIXCZEtafPyN5nrKvs2B5tJza257eVOM+MYMZXSFizvV0X
   RL6xhtllGHSLmPdSnQOxHb9fQc1Mcn8dhl4uDce7aVynuaN80LVWcmhwT
   +5VmBJKVXYvP2kfKRE/5NBdN2Z0L2r/p9gGt6GHesedLIIj1cO2pNsXaE
   GtHP/BmbP/SXD1+TotkINPVaCuPcdu3rEG4UpQ4udw+o5Kqus2Bxq8JlQ
   PzHaIRNTimZD9wRKTaQjoBVwG3tnojBdkObFZjmWfOhT56NHP7/RoXYJI
   4qw8uFI8wVE/2Hm0kmnU8pF8Y7GA7kZxc5vvb/aRqrWoB9PGe0h116E+F
   w==;
X-CSE-ConnectionGUID: nQARR9UGSxKYGBbOmbk58g==
X-CSE-MsgGUID: ebumhScYRH+QXlMT3o/mxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="37864755"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="37864755"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 05:25:34 -0800
X-CSE-ConnectionGUID: xA0Vhk/WRHK7ZqrGa8LK6g==
X-CSE-MsgGUID: IC4iE49KTOWRATKi0w7bCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="95750023"
Received: from rthomas.sc.intel.com ([172.25.112.51])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 05:25:33 -0800
From: Ramesh Thomas <ramesh.thomas@intel.com>
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	schnelle@linux.ibm.com,
	gbayer@linux.ibm.com
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	ankita@nvidia.com,
	yishaih@nvidia.com,
	pasic@linux.ibm.com,
	julianr@linux.ibm.com,
	bpsegal@us.ibm.com,
	ramesh.thomas@intel.com,
	kevin.tian@intel.com,
	cho@microsoft.com
Subject: [PATCH v3 2/2] vfio/pci: Remove #ifdef iowrite64 and #ifdef ioread64
Date: Tue, 10 Dec 2024 05:19:38 -0800
Message-Id: <20241210131938.303500-3-ramesh.thomas@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241210131938.303500-1-ramesh.thomas@intel.com>
References: <20241210131938.303500-1-ramesh.thomas@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the #ifdef iowrite64 and #ifdef ioread64 checks around calls to
64 bit IO access. Since default implementations have been enabled, the
checks are not required.

Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a0595c745732..78a3d0809415 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -62,9 +62,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_iowrite##size);
 VFIO_IOWRITE(8)
 VFIO_IOWRITE(16)
 VFIO_IOWRITE(32)
-#ifdef iowrite64
 VFIO_IOWRITE(64)
-#endif
 
 #define VFIO_IOREAD(size) \
 int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
@@ -90,9 +88,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
 VFIO_IOREAD(32)
-#ifdef ioread64
 VFIO_IOREAD(64)
-#endif
 
 #define VFIO_IORDWR(size)						\
 static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
@@ -128,9 +124,7 @@ static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
 VFIO_IORDWR(8)
 VFIO_IORDWR(16)
 VFIO_IORDWR(32)
-#if defined(ioread64) && defined(iowrite64)
 VFIO_IORDWR(64)
-#endif
 
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
@@ -156,7 +150,6 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
-#if defined(ioread64) && defined(iowrite64)
 		if (fillable >= 8 && !(off % 8)) {
 			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
@@ -164,7 +157,6 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 				return ret;
 
 		} else
-#endif
 		if (fillable >= 4 && !(off % 4)) {
 			ret = vfio_pci_iordwr32(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
@@ -382,12 +374,10 @@ static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 		vfio_pci_core_iowrite32(ioeventfd->vdev, test_mem,
 					ioeventfd->data, ioeventfd->addr);
 		break;
-#ifdef iowrite64
 	case 8:
 		vfio_pci_core_iowrite64(ioeventfd->vdev, test_mem,
 					ioeventfd->data, ioeventfd->addr);
 		break;
-#endif
 	}
 }
 
@@ -441,10 +431,8 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 	      pos >= vdev->msix_offset + vdev->msix_size))
 		return -EINVAL;
 
-#ifndef iowrite64
 	if (count == 8)
 		return -EINVAL;
-#endif
 
 	ret = vfio_pci_core_setup_barmap(vdev, bar);
 	if (ret)
-- 
2.34.1


