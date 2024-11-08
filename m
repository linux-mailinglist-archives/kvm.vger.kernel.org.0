Return-Path: <kvm+bounces-31256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 845A29C1C9C
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:04:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CE89B2406A
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE3B1E5721;
	Fri,  8 Nov 2024 12:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JsBgB7kw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D051E5019
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731067476; cv=none; b=ImMI79YXVjA6R02gC5fOtGhocMsjkTNw3ZdqHnC2cpKuU9gQv6j0N132pvn2j8qu3+g30Va8zUHFD6ouo43PWSD6IMCUOS1jY38sqDVj1Eo5ecU8SnHANvn2/OVPbJi44RogtjElcvJEQe//uEgEMHLjIl33B3KV1kToL+kC27I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731067476; c=relaxed/simple;
	bh=h/iir5bbQI/sdAE4QJiveeaniAldZP8K2NkM9vUjrYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WhfwcYyOwTBfM4+Xw9OzwvuapVYhNZMn1qQ0ynvBE5CxxEoGZhdYMBGv0/WtJZY1kf9dglxEbG2YX/sFOi6QPRARJ6gz9GTOOnse2XmA28ENRnMw2VJzFVYQuJJYjE55L49zaSagCfFKYx5K0C4llC5ADabeiXBGxavUSWHhszk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JsBgB7kw; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731067474; x=1762603474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h/iir5bbQI/sdAE4QJiveeaniAldZP8K2NkM9vUjrYI=;
  b=JsBgB7kw1UXW3QKFA/aNRRH62lOtFtUkSmZsy/fLPuvreqi2oASxZbGd
   /ZFUlm+FELh15kmetgRvKUf1XLi6D7kK3clivE+ZWRf6XhQfHLxrWq+NH
   +VFXru1hcPUjt88bstaw5ayBdqzU/Y8T6X2vnKEWwe3OuwwE1bZ+7/ze2
   DYVD1xh/Jaeb/8jVnuOeGdLPGacdm8ghxYFhZ5lWoOuJfExHBpdwUOVyW
   U5wFrIBXDctSi2GXAKcbqNE9Xf0inxGLGsp/flSquIPmY+o9Y+0OKAkql
   5kA4/Sh8UnLNnviLqim5P0HvUVqt51RmIZUBJqTJhFJXQafmhfsmlJQEH
   Q==;
X-CSE-ConnectionGUID: 7elMSxrFT5WIMHt0IC6wQg==
X-CSE-MsgGUID: nWVOnRNyTdKUkItTWvB+SQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31116413"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31116413"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:04:31 -0800
X-CSE-ConnectionGUID: OvajEX1eTXONS94RaD+Hrw==
X-CSE-MsgGUID: FVcmXU9BSm6nsdqtjefGtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85679024"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa008.fm.intel.com with ESMTP; 08 Nov 2024 04:04:30 -0800
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
	willy@infradead.org
Subject: [PATCH v4 2/7] iommu: Consolidate the ops->remove_dev_pasid usage into a helper
Date: Fri,  8 Nov 2024 04:04:22 -0800
Message-Id: <20241108120427.13562-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241108120427.13562-1-yi.l.liu@intel.com>
References: <20241108120427.13562-1-yi.l.liu@intel.com>
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

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1c689e57928e..819c6e0188d5 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3298,6 +3298,14 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
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
@@ -3316,11 +3324,9 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
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
@@ -3330,12 +3336,9 @@ static void __iommu_remove_group_pasid(struct iommu_group *group,
 				       struct iommu_domain *domain)
 {
 	struct group_device *device;
-	const struct iommu_ops *ops;
 
-	for_each_group_device(group, device) {
-		ops = dev_iommu_ops(device->dev);
-		ops->remove_dev_pasid(device->dev, pasid, domain);
-	}
+	for_each_group_device(group, device)
+		iommu_remove_dev_pasid(device->dev, pasid, domain);
 }
 
 /*
-- 
2.34.1


