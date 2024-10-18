Return-Path: <kvm+bounces-29136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CA4C9A34D8
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A46161F24ECD
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 05:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520BC191F89;
	Fri, 18 Oct 2024 05:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CW7Z3qqG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57641917E4
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230851; cv=none; b=tBXCD9GPr8cPzEaIEVC7mj9YiyTEUmvYL/pDsseB90tz1RS9FqfQ9bUhWmb7lOh1VUQ+bQiFtun5wHtqEjmsmfic+JlkwA+i2yuu9YR8byAGv1TlEG69ON2cw4hQ5I1j2C06yqV0eOFomeiKko+IM8ixmZpS/doZeDf5aBb373w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230851; c=relaxed/simple;
	bh=cVcpJG58ZwwlEe+0JpLEUe88ZZHXyK1Q+Un+3Blnk6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k7BXjcZhZ21GIkmN6e5gS7ik1SehG5WIAJb3XcqLzoIzlJJdCNJQ+uAQSCmb2wc8CD6B6vjAHraxd1f5a6LoGfC9lcoG82sA2neMjbu2aZI4D2oR5DdU9BJHkepFnxk7+ovlaIAQxWjvEkOD3NZjNsLzr0doXtr2YZZR4o2cGdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CW7Z3qqG; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729230850; x=1760766850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cVcpJG58ZwwlEe+0JpLEUe88ZZHXyK1Q+Un+3Blnk6A=;
  b=CW7Z3qqGlvkEuR5Yt/k8ILdkqQGkmDKi5lutbE2OVLiPL3EP/jaGdx5G
   wX41xXi9W10RMdZgBkNnxFEXJNil9zRXvUYKmildLl2btoFMalg+jw+nf
   +RdxWlPQV26ppRQ2et7VEGzMgZ7lXoLLdUTBZhLTAWsE134QC+u9b2hmI
   F0yyT4bi7ZgmfcL9iNP0XgyUuHHsLq43FV+ixgXYggXDluwhPiDDydIPg
   Xe8gb9L6yNjCVqaxVFHrjpMAAFw5pvZyk1JmCdCvUYRDT1HgTRiXmF0rh
   ck7BaCWljyM74quT2PyLw9iNS9Q2Rm+MKtv35NMVPhIp2JzRGKV+Iktkf
   Q==;
X-CSE-ConnectionGUID: NVaPmQRuQW+ninE6pqV79A==
X-CSE-MsgGUID: 1mBl7KhAR8ilI1zsusVyxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28708826"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28708826"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:54:08 -0700
X-CSE-ConnectionGUID: piAgi7oxSI2vf2ZzoDDHOA==
X-CSE-MsgGUID: azzAZwIUS9eq5kPDBjJM2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="79188591"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 17 Oct 2024 22:54:08 -0700
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
Subject: [PATCH v3 7/9] iommu/vt-d: Add set_dev_pasid callback for nested domain
Date: Thu, 17 Oct 2024 22:54:00 -0700
Message-Id: <20241018055402.23277-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241018055402.23277-1-yi.l.liu@intel.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

Extend intel_iommu_set_dev_pasid() to set a nested type domain to a PASID
of a device.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Co-developed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c  | 23 ++++++++++++++++++-----
 drivers/iommu/intel/iommu.h  |  3 +++
 drivers/iommu/intel/nested.c |  1 +
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 302260898c36..d089ac148a7e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -284,6 +284,11 @@ static int __init intel_iommu_setup(char *str)
 }
 __setup("intel_iommu=", intel_iommu_setup);
 
+static int domain_type_is_nested(struct dmar_domain *domain)
+{
+	return domain->domain.type == IOMMU_DOMAIN_NESTED;
+}
+
 static int domain_pfn_supported(struct dmar_domain *domain, unsigned long pfn)
 {
 	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
@@ -4304,7 +4309,12 @@ domain_add_dev_pasid(struct iommu_domain *domain,
 	unsigned long flags;
 	int ret;
 
-	ret = domain_attach_device_sanitize(domain, dev);
+	/* Nested type domain should sanitize its parent domain */
+	if (domain_type_is_nested(dmar_domain))
+		ret = domain_attach_device_sanitize(
+				&dmar_domain->s2_domain->domain, dev);
+	else
+		ret = domain_attach_device_sanitize(domain, dev);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -4334,9 +4344,9 @@ domain_add_dev_pasid(struct iommu_domain *domain,
 	return ERR_PTR(ret);
 }
 
-static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
-				     struct device *dev, ioasid_t pasid,
-				     struct iommu_domain *old)
+int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
+			      struct device *dev, ioasid_t pasid,
+			      struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
@@ -4357,7 +4367,10 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (IS_ERR(dev_pasid))
 		return PTR_ERR(dev_pasid);
 
-	if (dmar_domain->use_first_level)
+	if (domain_type_is_nested(dmar_domain))
+		ret = intel_pasid_setup_nested(iommu, dev, pasid,
+					       dmar_domain);
+	else if (dmar_domain->use_first_level)
 		ret = domain_setup_first_level(iommu, dmar_domain,
 					       dev, pasid);
 	else
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index b020ae90c47e..d045397b0a4c 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1233,6 +1233,9 @@ void device_block_translation(struct device *dev);
 int domain_attach_device_sanitize(struct iommu_domain *domain,
 				  struct device *dev);
 void domain_update_iommu_cap(struct dmar_domain *domain);
+int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
+			      struct device *dev, ioasid_t pasid,
+			      struct iommu_domain *old);
 
 int dmar_ir_support(void);
 
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index c1e97ad6be24..d57abca32810 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -132,6 +132,7 @@ static int intel_nested_cache_invalidate_user(struct iommu_domain *domain,
 
 static const struct iommu_domain_ops intel_nested_domain_ops = {
 	.attach_dev		= intel_nested_attach_dev,
+	.set_dev_pasid		= intel_iommu_set_dev_pasid,
 	.free			= intel_nested_domain_free,
 	.cache_invalidate_user	= intel_nested_cache_invalidate_user,
 };
-- 
2.34.1


