Return-Path: <kvm+bounces-3233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68147801BE0
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:53:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99A481C20A9E
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA281401D;
	Sat,  2 Dec 2023 09:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jeGcBlzy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A29197;
	Sat,  2 Dec 2023 01:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510772; x=1733046772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=4XuvqJzELS5xzXnhxrYHtRshvrsQAG9FckEEWisSVfA=;
  b=jeGcBlzyeYqbIYpbHw9YFd3s1iQIiYgnehIrJV7lLBqhWECps9dgrXpX
   CHPfy55cz2Hd/jvkJd/0FeaujyYhcnQyZOxKPQe6fqGahDZ7fwN6jToze
   +6XOJj7Dk72ccwcPxeohPEDVLV8TBe9cUVxJJ5YY/sTfPef1nQ6H7lsc3
   W7JNOEKmkKcjDvT56AaQw7tb8FeVurWLVnPY7VjFvL1nsiJKZ+T4LBumv
   E0TtlmtnhWf9zAdks1rnGMdEvYti0vhy89UK/YlXUHeBasIjwaObJjQhv
   pnic/iNLkVY/8XqRT2+Ev2BsiqRmr3g5nsVNq0zMvFAFhwIW4NCJ9bdp9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="397479499"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="397479499"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:52:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="913853337"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="913853337"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:52:47 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 17/42] iommu/vt-d: Make some macros and helpers to be extern
Date: Sat,  2 Dec 2023 17:23:52 +0800
Message-Id: <20231202092352.14452-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This makes the macros and helpers visible to outside of iommu.c, which
is a preparation for next patch to create domain of IOMMU_DOMAIN_KVM.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/iommu/intel/iommu.c | 39 +++----------------------------------
 drivers/iommu/intel/iommu.h | 35 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5df6c21781e1c..924006cda18c5 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -49,7 +49,6 @@
 #define MAX_AGAW_PFN_WIDTH	(MAX_AGAW_WIDTH - VTD_PAGE_SHIFT)
 
 #define __DOMAIN_MAX_PFN(gaw)  ((((uint64_t)1) << ((gaw) - VTD_PAGE_SHIFT)) - 1)
-#define __DOMAIN_MAX_ADDR(gaw) ((((uint64_t)1) << (gaw)) - 1)
 
 /* We limit DOMAIN_MAX_PFN to fit in an unsigned long, and DOMAIN_MAX_ADDR
    to match. That way, we can use 'unsigned long' for PFNs with impunity. */
@@ -62,10 +61,6 @@
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
 
-/* page table handling */
-#define LEVEL_STRIDE		(9)
-#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
-
 static inline int agaw_to_level(int agaw)
 {
 	return agaw + 2;
@@ -76,11 +71,6 @@ static inline int agaw_to_width(int agaw)
 	return min_t(int, 30 + agaw * LEVEL_STRIDE, MAX_AGAW_WIDTH);
 }
 
-static inline int width_to_agaw(int width)
-{
-	return DIV_ROUND_UP(width - 30, LEVEL_STRIDE);
-}
-
 static inline unsigned int level_to_offset_bits(int level)
 {
 	return (level - 1) * LEVEL_STRIDE;
@@ -281,8 +271,6 @@ static LIST_HEAD(dmar_satc_units);
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
 
-static void intel_iommu_domain_free(struct iommu_domain *domain);
-
 int dmar_disabled = !IS_ENABLED(CONFIG_INTEL_IOMMU_DEFAULT_ON);
 int intel_iommu_sm = IS_ENABLED(CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON);
 
@@ -450,12 +438,6 @@ int iommu_calculate_agaw(struct intel_iommu *iommu)
 	return __iommu_calculate_agaw(iommu, DEFAULT_DOMAIN_ADDRESS_WIDTH);
 }
 
-static inline bool iommu_paging_structure_coherency(struct intel_iommu *iommu)
-{
-	return sm_supported(iommu) ?
-			ecap_smpwc(iommu->ecap) : ecap_coherent(iommu->ecap);
-}
-
 static void domain_update_iommu_coherency(struct dmar_domain *domain)
 {
 	struct iommu_domain_info *info;
@@ -1757,7 +1739,7 @@ static bool first_level_by_default(unsigned int type)
 	return type != IOMMU_DOMAIN_UNMANAGED;
 }
 
-static struct dmar_domain *alloc_domain(unsigned int type)
+struct dmar_domain *alloc_domain(unsigned int type)
 {
 	struct dmar_domain *domain;
 
@@ -1842,20 +1824,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	spin_unlock(&iommu->lock);
 }
 
-static inline int guestwidth_to_adjustwidth(int gaw)
-{
-	int agaw;
-	int r = (gaw - 12) % 9;
-
-	if (r == 0)
-		agaw = gaw;
-	else
-		agaw = gaw + 9 - r;
-	if (agaw > 64)
-		agaw = 64;
-	return agaw;
-}
-
 static void domain_exit(struct dmar_domain *domain)
 {
 	if (domain->pgd) {
@@ -4106,7 +4074,7 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 	return domain;
 }
 
-static void intel_iommu_domain_free(struct iommu_domain *domain)
+void intel_iommu_domain_free(struct iommu_domain *domain)
 {
 	if (domain != &si_domain->domain)
 		domain_exit(to_dmar_domain(domain));
@@ -4155,8 +4123,7 @@ int prepare_domain_attach_device(struct iommu_domain *domain,
 	return 0;
 }
 
-static int intel_iommu_attach_device(struct iommu_domain *domain,
-				     struct device *dev)
+int intel_iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	int ret;
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 6acb0211e85fe..c76f558ae6323 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1021,4 +1021,39 @@ static inline const char *decode_prq_descriptor(char *str, size_t size,
 	return str;
 }
 
+#define __DOMAIN_MAX_ADDR(gaw) ((((uint64_t)1) << (gaw)) - 1)
+
+/* page table handling */
+#define LEVEL_STRIDE		(9)
+#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
+
+int intel_iommu_attach_device(struct iommu_domain *domain, struct device *dev);
+void intel_iommu_domain_free(struct iommu_domain *domain);
+struct dmar_domain *alloc_domain(unsigned int type);
+
+static inline int guestwidth_to_adjustwidth(int gaw)
+{
+	int agaw;
+	int r = (gaw - 12) % 9;
+
+	if (r == 0)
+		agaw = gaw;
+	else
+		agaw = gaw + 9 - r;
+	if (agaw > 64)
+		agaw = 64;
+	return agaw;
+}
+
+static inline bool iommu_paging_structure_coherency(struct intel_iommu *iommu)
+{
+	return sm_supported(iommu) ?
+			ecap_smpwc(iommu->ecap) : ecap_coherent(iommu->ecap);
+}
+
+static inline int width_to_agaw(int width)
+{
+	return DIV_ROUND_UP(width - 30, LEVEL_STRIDE);
+}
+
 #endif
-- 
2.17.1


