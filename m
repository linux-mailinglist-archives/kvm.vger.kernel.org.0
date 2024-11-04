Return-Path: <kvm+bounces-30519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E05F79BB5B8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:20:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E8F21C213F0
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8965618651;
	Mon,  4 Nov 2024 13:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lp/nr6rL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CDF70824
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726339; cv=none; b=n+uwW8lpp0Lm5ACN//DJlmirvLuiVkmdy+pHt6BaKUk+YyZCmDWuZsjfLRUZbivdEz2tD+CXrnR9LtzJfescFK1Ri5+kdxvouWcAcdQ37Dl8mwGxLJ9W3WrjoSUdQsq6lRdKuZlCOCqiSM+RQ/ekPdNu3X7oYEwNC69D0IWlYxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726339; c=relaxed/simple;
	bh=RHRk93t5dgAaoW9PhV/TAGRxLx3TadEz8INI814V7EU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AIe5ntqfS4HhbiqwwZJf1NNBECuj/S+MUl2Bz42Xfd5xAsPL2FzpCeU2lLaHJhmwZfik3P71Q91kC/fNViKFkQ3shAjHayZV2KLxdwwQPElBssdwDzmQ1bo17OZZt+srlG44hbqePa9DjEuznT4ZFDaHDJiSKm7vw+eK3Ll+49M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lp/nr6rL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726338; x=1762262338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RHRk93t5dgAaoW9PhV/TAGRxLx3TadEz8INI814V7EU=;
  b=Lp/nr6rLEiHkyAxrraCw8e8pLw5sNgPtETbRW/ULIgEgoNIPRG0oaYDq
   2PA0VUkLc1dTiWs5SC1fd/QcmseTiZRmjkfkKO1joYHZyi6SAjP0Gncxl
   FAAtLQpke10IWlHkZku6mqtdGTAcZb4TkgsPaZfyQBBJm7yQVACMKKpVA
   9ElwgHyMMZ+rMdFZyKkZmwsrLEt9hpLrKZoU3iz0niuIlXswOlCkpFkFV
   l+NVGqAwqsmF5wgt7iT4BCTAiCkBKU9FhoT2aafmVn++Zft+9OFRHTSUp
   HmfDofXYjZXTQ4c0S8joGKp6jjSe1Upl3jw0oGDd4ICxIiiFBIaPQSpy7
   w==;
X-CSE-ConnectionGUID: RIHpVgBnQz2upSxmclG6aQ==
X-CSE-MsgGUID: mU/68DshRGue99UUkvGU2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41003785"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="41003785"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:18:57 -0800
X-CSE-ConnectionGUID: E2dgKaAvR+Wok9LrirQMBQ==
X-CSE-MsgGUID: MVMJoamMSleJmJCHhu7lwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83999542"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 04 Nov 2024 05:18:57 -0800
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
Subject: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for nested domain
Date: Mon,  4 Nov 2024 05:18:40 -0800
Message-Id: <20241104131842.13303-12-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104131842.13303-1-yi.l.liu@intel.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

Add intel_nested_set_dev_pasid() to set a nested type domain to a PASID
of a device.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Co-developed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c  |  2 +-
 drivers/iommu/intel/iommu.h  |  7 ++++++
 drivers/iommu/intel/nested.c | 43 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel/pasid.h  | 11 +++++++++
 4 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7e82b3a4bba7..7f1ca3c342a3 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1944,7 +1944,7 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 					     flags);
 }
 
-static bool dev_is_real_dma_subdevice(struct device *dev)
+bool dev_is_real_dma_subdevice(struct device *dev)
 {
 	return dev && dev_is_pci(dev) &&
 	       pci_real_dma_dev(to_pci_dev(dev)) != to_pci_dev(dev);
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 8e7ffb421ac4..55478d7b64cf 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -818,6 +818,11 @@ domain_id_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	return info->did;
 }
 
+static inline int domain_type_is_nested(struct dmar_domain *domain)
+{
+	return domain->domain.type == IOMMU_DOMAIN_NESTED;
+}
+
 /*
  * 0: readable
  * 1: writable
@@ -1225,6 +1230,8 @@ void __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
  */
 #define QI_OPT_WAIT_DRAIN		BIT(0)
 
+bool dev_is_real_dma_subdevice(struct device *dev);
+
 int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
 void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
 void device_block_translation(struct device *dev);
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index 3ce3c4fd210e..890087f3509f 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -130,8 +130,51 @@ static int intel_nested_cache_invalidate_user(struct iommu_domain *domain,
 	return ret;
 }
 
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
+	/* No SVA domain replacement usage so far */
+	if (old && old->type == IOMMU_DOMAIN_SVA)
+		return -EOPNOTSUPP;
+
+	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
+		return -EOPNOTSUPP;
+
+	if (context_copied(iommu, info->bus, info->devfn))
+		return -EBUSY;
+
+	ret = prepare_domain_attach_device(&dmar_domain->s2_domain->domain,
+					   dev);
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
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index a3b5945a1812..31a4e7c01853 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -335,6 +335,17 @@ static inline int domain_setup_passthrough(struct intel_iommu *iommu,
 	return intel_pasid_setup_pass_through(iommu, dev, pasid);
 }
 
+static inline int domain_setup_nested(struct intel_iommu *iommu,
+				      struct dmar_domain *domain,
+				      struct device *dev, ioasid_t pasid,
+				      struct iommu_domain *old)
+{
+	if (old)
+		return intel_pasid_replace_nested(iommu, dev,
+						  pasid, domain);
+	return intel_pasid_setup_nested(iommu, dev, pasid, domain);
+}
+
 void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
 				 struct device *dev, u32 pasid,
 				 bool fault_ignore);
-- 
2.34.1


