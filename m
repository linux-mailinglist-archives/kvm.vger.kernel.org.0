Return-Path: <kvm+bounces-30525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 10CA49BB5C7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E448B20C82
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D812AE72;
	Mon,  4 Nov 2024 13:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mUgd4Uxg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3900B1CD02
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726440; cv=none; b=HxtU9BriVdaw+uZ0m2NGfRFRsjUTcLyogBrdJDTe2Yke3JYwTAG3XeceK5shmL2SpSTD8EyF6QS/nYRDlcrRrPJ/xRwgPWT1U3oJ4m49ngco4L2ZW0Nh7onUF7ksiKsV4lYwjy0691bZ0PhTy/NyXTUj3ixtzObWSyi6hm9heGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726440; c=relaxed/simple;
	bh=eEHmXayK9QK4m707aejwlJqo2aRjzbrQ+Mcejqkcg9A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rcHTnsus0H/QIHLb0tyrM8wugXZNAxXjO3nGNcBBH+xIL4Gb7aq/joRxnZyuBEMgF0BAx2BC7Z+5zfr0QWlqo2YFMm63qmlc1VGd7bBo+QcVlS9Ge5Og499SZMh8toA4hFsNljm06fJ9vTfBOuO2GfzxTaiVCimasXMzd1ND1uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mUgd4Uxg; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726440; x=1762262440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eEHmXayK9QK4m707aejwlJqo2aRjzbrQ+Mcejqkcg9A=;
  b=mUgd4UxgTDq9nkWOKGUK3LbSOAFgNGKuEJMtAWlRU4KMqcd8mo/q8tC+
   TOfhJ899zDBZGNKKtfVJiL6ad6zvjeCLfc+87S8TTn65YAwjha2qew8fb
   fMGY2UH8cx9boFdDp0j5SIn1EChsLim+EvvSSWSQZMNhkiocvMrIqi7p9
   VSOtz1R8uYNMoQBS1C1vsaKBNOaZSbqZICFMm3ezE+v2+bbCiO7ZMxdAS
   yURVPX5aFEH/iAOiCB4vzVoEDJ0vPYCIr0eM7fG5RhVgtnpEzoMhyN0pv
   t/rMlvkYdnOowzub6GejAJm/HguZlQgAYfMxtn64Xy1GHsFSFymPwckUb
   w==;
X-CSE-ConnectionGUID: tl7GdnnXShea2TqIHujSTQ==
X-CSE-MsgGUID: fqmwppc1SZ2Iqr45jbr/KQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47883267"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47883267"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:20:37 -0800
X-CSE-ConnectionGUID: dj2GGPTeROWX/0WAwiVvBA==
X-CSE-MsgGUID: fhWxWlAkTR6ifLFiiqDuLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84099713"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:20:37 -0800
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
	vasant.hegde@amd.com,
	will@kernel.org
Subject: [PATCH v3 2/7] iommu: Consolidate the ops->remove_dev_pasid usage into a helper
Date: Mon,  4 Nov 2024 05:20:28 -0800
Message-Id: <20241104132033.14027-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132033.14027-1-yi.l.liu@intel.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a wrapper for the ops->remove_dev_pasid, this consolidates the iommu_ops
fetching and callback invoking. It is also a preparation for starting the
transition from using remove_dev_pasid op to detach pasid to the way using
blocked_domain to detach pasid.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 866559bbc4e4..21320578d801 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3400,6 +3400,14 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
 
+static void iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+				   struct iommu_domain *domain)
+{
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+
+	ops->remove_dev_pasid(dev, pasid, domain);
+}
+
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
 				   struct iommu_group *group, ioasid_t pasid)
 {
@@ -3418,11 +3426,9 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
 err_revert:
 	last_gdev = device;
 	for_each_group_device(group, device) {
-		const struct iommu_ops *ops = dev_iommu_ops(device->dev);
-
 		if (device == last_gdev)
 			break;
-		ops->remove_dev_pasid(device->dev, pasid, domain);
+		iommu_remove_dev_pasid(device->dev, pasid, domain);
 	}
 	return ret;
 }
@@ -3432,11 +3438,9 @@ static void __iommu_remove_group_pasid(struct iommu_group *group,
 				       struct iommu_domain *domain)
 {
 	struct group_device *device;
-	const struct iommu_ops *ops;
 
 	for_each_group_device(group, device) {
-		ops = dev_iommu_ops(device->dev);
-		ops->remove_dev_pasid(device->dev, pasid, domain);
+		iommu_remove_dev_pasid(device->dev, pasid, domain);
 	}
 }
 
-- 
2.34.1


