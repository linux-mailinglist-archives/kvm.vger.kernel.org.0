Return-Path: <kvm+bounces-31110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 632119C05A6
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:23:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 934C71C2228F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070F621219A;
	Thu,  7 Nov 2024 12:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nEBC2xkm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A102101AD
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982166; cv=none; b=esdHEDvr4DebOtOfms7ODAcS29l3f1nDS5XL31WcEJ1M2bRUPy85oDjJJOhPgTdl5iau0mJ+xxLfiUI66ri4uRRDqQpWf45em+z6IUSwfA0YFXX/oQ9c7bzTuN37zVPDXOETQhdWN+9UfXm70OcBYtKOd31Wyr3FdDVzkQukQpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982166; c=relaxed/simple;
	bh=rELXPbrtcyc9J3I3hQziii8ddQrXQes4Oz6iT73iRTU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tn+7Bned5kfR1sKUEHfEea1eaRl1gpF1JIxzQTR3PeIz7mZTyBdpEn371wwwDzN19Pkcnqog/H0Y2pOYttaFhSu8H6HloNjdSocLJp7TAuVYKkyVohP8Oa0ttYwYUkTjESkXqSnNeFBNkJDAPObEwdB8oMF18Xy1ApVViLkKL9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nEBC2xkm; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982164; x=1762518164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rELXPbrtcyc9J3I3hQziii8ddQrXQes4Oz6iT73iRTU=;
  b=nEBC2xkmAkC9IroS+9vnbpdXMt3+fkr0GJRj6OueNied4fVRkjnqWDBW
   PkyHyfXNzLrzRTDicGhmAG4hYaOGFXkGrAqvjG843BBhSt8VvJcqqltxx
   IqnnqzDJ/gEYRpI1U2NHj2jXvBXW/ovzw1ZJpxUWcYU5PfcM67+aWOMEq
   /QWwYE4bkw90iXTCBftLJBICJnquGnGvrJFLVstZweANFl5HEWkyI7Kce
   EJX2UsbstAL40TRxHwhFPF2OCef5n4Yy3jZzDjqGTxl7uOB7SlX96isod
   CoUWzyMn6iYfGVuMCPo1VhtwNI8XEQQZpJVX7WY8HYu9cNvN7GEpl1uOg
   g==;
X-CSE-ConnectionGUID: 5S23/g98TgquJ4SN66xWWw==
X-CSE-MsgGUID: pfFUJGoQRAqkJZQ1Q3ZLnw==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744661"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744661"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:41 -0800
X-CSE-ConnectionGUID: zlZisCOpQ9yymRHfoTiEWw==
X-CSE-MsgGUID: 28XUfHaWRo6Sk7cYkoiBBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180606"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:42 -0800
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
Subject: [PATCH v6 11/13] iommu/vt-d: Add set_dev_pasid callback for nested domain
Date: Thu,  7 Nov 2024 04:22:32 -0800
Message-Id: <20241107122234.7424-12-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241107122234.7424-1-yi.l.liu@intel.com>
References: <20241107122234.7424-1-yi.l.liu@intel.com>
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


