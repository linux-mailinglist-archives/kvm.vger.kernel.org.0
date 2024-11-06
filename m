Return-Path: <kvm+bounces-30987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2489BF21A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66AEFB23D55
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C90204939;
	Wed,  6 Nov 2024 15:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D+06OOt2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7216208225
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907983; cv=none; b=MqQC6EHM/BC8fQWBjktnnC2+dAJanSal/ZvEZe2Yqias2x1yvzLnRotyWX7aAokgbjf/DKPYaPc+HDjEfyqnoYdvXSFVC6aZvJYHDXbu+yu/cI9CCH0jAXNVJW0CXLu6GQhghyYmyCq6SJIoGE0uHrPV+rL/mAcFviS5BOXThSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907983; c=relaxed/simple;
	bh=YQbNiBetTn/f7PT9oR9wqLpSCGd2nngC6kfX9asM9Go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BuvsYlLImwV59OVeibDhscMj20g5LP/HngmQHoKgszjwm1Hir+5d4O+IpYrgvMXZTyCBsctsb5yhh/uj/clAYjDT5c5/JAAs6mcsKtuiNZ/zfFL0bBVqFkEVZGRJaLTUxgetqy3Z40vwKPLLGbqJQcKmh9kTxzcBdFcJgD5ivY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D+06OOt2; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907979; x=1762443979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YQbNiBetTn/f7PT9oR9wqLpSCGd2nngC6kfX9asM9Go=;
  b=D+06OOt2FQb44HfedWwZmwWNjpAwF6YPyjDMyGHQSbvmarLwFzePhYll
   GT3bq0WkJ+fRMoVSequL/TLM3wF19RrJmzVCFvaeX0i7+dOu2M2POTyqX
   i0a4ziY1T33uQE4/cYGEfaAwTuYeRAQL5lTIHBsOz5uMLfzP9eue7m3jR
   MrwlYJWsVoXmIXyyts/0+wiB8lRM5l5IVC45qkEV+zojAdQzKayKJN7lc
   NVvGN2Ad8EtzVUJT/XLMhsbM5TG88S5coi/V2in+dB4v+iABmYg/3uZf7
   Pb0D4lzYjGH6nVWzk2N2Tu97ES/SPTAC0NODNIZSxT0j23X/LmvhP8u2j
   Q==;
X-CSE-ConnectionGUID: z2i4kb85T020jes4t7w5wA==
X-CSE-MsgGUID: gQAIKHwdQI2meXDZ4m6Wow==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174312"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174312"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:14 -0800
X-CSE-ConnectionGUID: XAytVs9dS9eK5gK9OU6qlw==
X-CSE-MsgGUID: yvY5lH2cSTG1xvi02f3EGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468331"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2024 07:46:13 -0800
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
Subject: [PATCH v5 13/13] iommu: Make set_dev_pasid op support domain replacement
Date: Wed,  6 Nov 2024 07:46:06 -0800
Message-Id: <20241106154606.9564-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106154606.9564-1-yi.l.liu@intel.com>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iommu core is going to support domain replacement for pasid, it needs
to make the set_dev_pasid op support replacing domain and keep the old
domain config in the failure case.

AMD iommu driver does not support domain replacement for pasid yet, so it
would fail the set_dev_pasid op to keep the old config if the input @old
is non-NULL. Till now, all the set_dev_pasid callbacks can handle the old
parameter and can keep the old config when failed, so update the kdoc of
set_dev_pasid op.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/amd/pasid.c | 3 +++
 include/linux/iommu.h     | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index d1dfc745f55e..8c73a30c2800 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -109,6 +109,9 @@ int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
 	unsigned long flags;
 	int ret = -EINVAL;
 
+	if (old)
+		return -EOPNOTSUPP;
+
 	/* PASID zero is used for requests from the I/O device without PASID */
 	if (!is_pasid_valid(dev_data, pasid))
 		return ret;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 56653af5edcb..0c3bfb66dc7c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -614,7 +614,8 @@ struct iommu_ops {
  * * EBUSY	- device is attached to a domain and cannot be changed
  * * ENODEV	- device specific errors, not able to be attached
  * * <others>	- treated as ENODEV by the caller. Use is discouraged
- * @set_dev_pasid: set an iommu domain to a pasid of device
+ * @set_dev_pasid: set or replace an iommu domain to a pasid of device. The pasid of
+ *                 the device should be left in the old config in error case.
  * @map_pages: map a physically contiguous set of pages of the same size to
  *             an iommu domain.
  * @unmap_pages: unmap a number of pages of the same size from an iommu domain
-- 
2.34.1


