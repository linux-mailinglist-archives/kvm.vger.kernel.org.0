Return-Path: <kvm+bounces-30985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7AFB9BF218
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F6F91F23E5A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193D420896B;
	Wed,  6 Nov 2024 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GQn7vgFS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829AA2071F9
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907979; cv=none; b=UFpsltkwcQLJvCh1+MBZUGzmuMnNDZwv3SUjI7IrsDbJGjNNInGMK0tbaQ7nWIb6ytKlKwr3Nz7bRbmLpc+E3pcaI1FYtCG66BwCCbqA/rX56FTYbSerYTLjDWwnCUnWnZvN9urNQjVgZfaGBQPRk2inP+oC6mZdsfiH3nJgtGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907979; c=relaxed/simple;
	bh=rELXPbrtcyc9J3I3hQziii8ddQrXQes4Oz6iT73iRTU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nihVwT22IplJzhVuFFQKsVT//Mag+FSkRZdxkcuivMph8nbHgwSRJbjqFn87W1y7GRMB0ySLjd5i6np9vlHM3Am06XSJl3S0I5IWrBUpnG2+xNtI+rFf0NK9KblonFav7WPcmEKvNMNmQaj85bH+TxsQGBZsjR4sNndGzC54va8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GQn7vgFS; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907977; x=1762443977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rELXPbrtcyc9J3I3hQziii8ddQrXQes4Oz6iT73iRTU=;
  b=GQn7vgFScfF8GDJMhUeA2NvjVLT/GNz2SjUgNn4P20vOoFTdMG0+Qo+4
   zN7ykh6Wm1CB5w+lPOJfS2u43lozlXZiquiTNRCFYbucbuh3rMUHg5Pgr
   zpDqo3aciiSF24JRcS+5d74vmLrI1/qj6BC13wOD94IiPAXdkLSKt7LMs
   JbPlMLl5zXT6HLtdUv5LCYYpGWxoSmVHyN0clD6vyBl5eCAtaLmHk67eT
   UI8HTkkWOyR3FjeylXV5UC3ePNFF6X/XqPOgl7Ojc8PqqCtVl8Cs4Go9l
   rPJdb9gVmRplys5BmxkONK0vKV1qV8ZRrSLQHlg7rajTj7KO9RZq9zDOp
   A==;
X-CSE-ConnectionGUID: 1hUKa5b9SCupb4OEOF4LTw==
X-CSE-MsgGUID: 4s7DKU2jR2KJ170pKmrOaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174291"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174291"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:12 -0800
X-CSE-ConnectionGUID: v5nxOpKETzuLVdYY01fGoQ==
X-CSE-MsgGUID: oNbGVfgfSYCwhdPBQ6qn1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468262"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2024 07:46:12 -0800
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
Subject: [PATCH v5 11/13] iommu/vt-d: Add set_dev_pasid callback for nested domain
Date: Wed,  6 Nov 2024 07:46:04 -0800
Message-Id: <20241106154606.9564-12-yi.l.liu@intel.com>
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

Add intel_nested_set_dev_pasid() to set a nested type domain to a PASID
of a device.

Co-developed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c  |  6 -----
 drivers/iommu/intel/iommu.h  |  7 +++++
 drivers/iommu/intel/nested.c | 50 ++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f69ea5b48ee8..527f6f89d8a1 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1812,12 +1812,6 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 					  (pgd_t *)pgd, flags, old);
 }
 
-static bool dev_is_real_dma_subdevice(struct device *dev)
-{
-	return dev && dev_is_pci(dev) &&
-	       pci_real_dma_dev(to_pci_dev(dev)) != to_pci_dev(dev);
-}
-
 static int dmar_domain_attach_device(struct dmar_domain *domain,
 				     struct device *dev)
 {
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index d23977cc7d90..2cca094c259d 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -22,6 +22,7 @@
 #include <linux/bitfield.h>
 #include <linux/xarray.h>
 #include <linux/perf_event.h>
+#include <linux/pci.h>
 
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
@@ -832,6 +833,12 @@ iommu_domain_did(struct iommu_domain *domain, struct intel_iommu *iommu)
 	return domain_id_iommu(to_dmar_domain(domain), iommu);
 }
 
+static inline bool dev_is_real_dma_subdevice(struct device *dev)
+{
+	return dev && dev_is_pci(dev) &&
+	       pci_real_dma_dev(to_pci_dev(dev)) != to_pci_dev(dev);
+}
+
 /*
  * 0: readable
  * 1: writable
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index 989ca5cc04eb..42c4533a6ea2 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -130,8 +130,58 @@ static int intel_nested_cache_invalidate_user(struct iommu_domain *domain,
 	return ret;
 }
 
+static int domain_setup_nested(struct intel_iommu *iommu,
+			       struct dmar_domain *domain,
+			       struct device *dev, ioasid_t pasid,
+			       struct iommu_domain *old)
+{
+	if (!old)
+		return intel_pasid_setup_nested(iommu, dev, pasid, domain);
+	return intel_pasid_replace_nested(iommu, dev, pasid,
+					  iommu_domain_did(old, iommu),
+					  domain);
+}
+
+static int intel_nested_set_dev_pasid(struct iommu_domain *domain,
+				      struct device *dev, ioasid_t pasid,
+				      struct iommu_domain *old)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct intel_iommu *iommu = info->iommu;
+	struct dev_pasid_info *dev_pasid;
+	int ret;
+
+	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
+		return -EOPNOTSUPP;
+
+	if (context_copied(iommu, info->bus, info->devfn))
+		return -EBUSY;
+
+	ret = paging_domain_compatible(&dmar_domain->s2_domain->domain, dev);
+	if (ret)
+		return ret;
+
+	dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
+	if (IS_ERR(dev_pasid))
+		return PTR_ERR(dev_pasid);
+
+	ret = domain_setup_nested(iommu, dmar_domain, dev, pasid, old);
+	if (ret)
+		goto out_remove_dev_pasid;
+
+	domain_remove_dev_pasid(old, dev, pasid);
+
+	return 0;
+
+out_remove_dev_pasid:
+	domain_remove_dev_pasid(domain, dev, pasid);
+	return ret;
+}
+
 static const struct iommu_domain_ops intel_nested_domain_ops = {
 	.attach_dev		= intel_nested_attach_dev,
+	.set_dev_pasid		= intel_nested_set_dev_pasid,
 	.free			= intel_nested_domain_free,
 	.cache_invalidate_user	= intel_nested_cache_invalidate_user,
 };
-- 
2.34.1


