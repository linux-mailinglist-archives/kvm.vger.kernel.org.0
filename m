Return-Path: <kvm+bounces-29141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68F639A34ED
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 08:00:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D5BF1C2236D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 06:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F288188CC6;
	Fri, 18 Oct 2024 05:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="anTxONkt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1041184535
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729231109; cv=none; b=gQBnX6hCv6naK48r0oX54W29mJXqiRUlGN2KWFVbjczYZBGs2b/BQa+/pCXGwaOrZgUy8NwCyZVKMjHL/V8IQ2lqs4XsrCDs9Ebd0GJPKY2ksoJPfK2GWqY7syo4MATV50S06B/GA0R6BNYuQV97JDCVRf7wFhzmV9dnqPcLNo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729231109; c=relaxed/simple;
	bh=hQh/alPdWirG+fauDX2BRT65avMKmeffGeTFMuJoT9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cgnHmucBtmZnIfij19uFBLgV2prFGo1IAW1ghccYaiiLi0RA2tVKCiePj0CpKS5gRGFX0/taJ1roxF6fDN6jgIUFI0eVfpzjC9/SNDPC+GZcJAkT8RrLDVxFeQknzdegNdBxwIhmj6S3roM8dp3mMb4e10REP6NBRJg6rSDeGbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=anTxONkt; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729231107; x=1760767107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hQh/alPdWirG+fauDX2BRT65avMKmeffGeTFMuJoT9M=;
  b=anTxONktRBvQC+gv2jY86AHIVz5XkMs6DHBLuK3q4QlAqPDPqMc237x4
   wyJwx3lk4fhHW9MRIA/kIRni4J7w94ZHQP02OLT7LSiA5aZRDRist9bEY
   6q7IqRT+Qi3VOeF6NWV8EcEmUblo7TrhHWHfe7kKxFlSSMX46FyceuDi3
   5FcbUh3Xjmy9Ci16TrpzOtTSpjK4VhwpO4vjzAfEwbKwUqXdyZ6uqKbeU
   3MTKHQVKkm3TEZcZm0zdUmvUL0g0lw9CPm/h+FZcFV0p28qQcJoeb39In
   isG4PUigTU83jSRRYbAmtG2/d24nz6PNAejsb4IgkIErrC3fyyB9jvYli
   w==;
X-CSE-ConnectionGUID: 2+HCHanSRvundOFGEm58wA==
X-CSE-MsgGUID: jQJ8zExqQOyShU/k1ynA7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39879122"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="39879122"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:58:26 -0700
X-CSE-ConnectionGUID: FWHub406T+S05+lIMpI0dg==
X-CSE-MsgGUID: 6LKb6JYQQ6OA4tC/G/bvuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="78675724"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa009.jf.intel.com with ESMTP; 17 Oct 2024 22:58:26 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	will@kernel.org
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com
Subject: [PATCH v2 1/3] iommu: Add a wrapper for remove_dev_pasid
Date: Thu, 17 Oct 2024 22:58:22 -0700
Message-Id: <20241018055824.24880-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241018055824.24880-1-yi.l.liu@intel.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iommu drivers are on the way to drop the remove_dev_pasid op by
extending the blocked_domain to support PASID. However, this cannot be
done in one shot. So far, the Intel iommu and the ARM SMMUv3 driver have
supported it, while the AMD iommu driver has not yet. During this
transition, the IOMMU core needs to support both ways to destroy the
attachment of device/PASID and domain.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f3f81c04b8fb..9266e4ebebc2 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3324,6 +3324,28 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
 
+/*
+ * This is gated by AMD's blocked domain pasid support, it should be
+ * dropped once AMD iommu driver is ready.
+ */
+static void iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+				   struct iommu_domain *domain)
+{
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	struct iommu_domain *blocked_domain = ops->blocked_domain;
+	int ret = 1;
+
+	if (blocked_domain->ops->set_dev_pasid) {
+		ret = blocked_domain->ops->set_dev_pasid(blocked_domain,
+							 dev, pasid, domain);
+	} else if (ops->remove_dev_pasid) {
+		ops->remove_dev_pasid(dev, pasid, domain);
+		ret = 0;
+	}
+
+	WARN_ON(ret);
+}
+
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
 				   struct iommu_group *group, ioasid_t pasid)
 {
@@ -3342,11 +3364,9 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
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
@@ -3356,11 +3376,9 @@ static void __iommu_remove_group_pasid(struct iommu_group *group,
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


