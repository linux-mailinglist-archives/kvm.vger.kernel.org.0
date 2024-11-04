Return-Path: <kvm+bounces-30518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC419BB5B7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4B161F224FB
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D478182D2;
	Mon,  4 Nov 2024 13:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FNd4YbEg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C8842AA6
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726338; cv=none; b=O6iHB9IZtcyNWN85Di/rWMB+mw2pIWN+QkiU3iGCvcr+dXZbNwedNNuE0whzVUP/7v2gJIJGpomzCF76RW8/e4VUnKa0ofa3PxJ3fa8Gh6nEFn0gVWWZqu6fTNY1GVIXfodzId94I/ta16MkKZb+2WXOGwBVXsvu3NyFDfCx5r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726338; c=relaxed/simple;
	bh=qBn1R+L4GbptDhCNckwrH16RhCPdk4cd27n1M1O+ooA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QQJT6iZfqobIuGu8e2QO/P0mMyy2mq5Gx0KZ3HoT3CGIoh0b6Zl9lc9HQaqqZ5SJ9K1mSqIBwGewFFev1rGvcn6BBEGyEYN+lfC9nT5hvQBydz9kHHbphBV3smY2YESC1zbfeoFAK9yogFCEbYUnZEezO+bIlmgrZNDJyXeiQjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FNd4YbEg; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726336; x=1762262336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qBn1R+L4GbptDhCNckwrH16RhCPdk4cd27n1M1O+ooA=;
  b=FNd4YbEgapYokYRHldQVZtSLigaBEq15ZPdr5bE/zoLfRKTLr/gQWE5g
   TsfSo8RL7eEH+ryn+3YH4gU7h+LsDJTxgNK6UDVJ2z5xsfioaz1Aledw0
   8FxkoONgrzxX+05SdRE+e9ONzILDVmbvbSyoBOEBAXqJDzWRqjqrE+gFA
   t+RwXT3BqU7LYiP6HUJBSGPE4k8mplt+Vw7A3Tglu4lI/92nYVBLm7xoC
   eSgFaGqAv74ApyGI3/OruJ6B8P/Tz8Sxt6s4Aul210vXHkWxHgFzECH3n
   kWTm0KxCUVGidUf0nbRWtPda+q/01Zuo2GoPB3fjQn0J8kkklutN9Gmsq
   A==;
X-CSE-ConnectionGUID: H1o20aFmSK+gVRz8bzOFiw==
X-CSE-MsgGUID: m68MH0CAQKmay2JPJ9IBLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41003773"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="41003773"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:18:56 -0800
X-CSE-ConnectionGUID: 341kIP6XTjOn6JAbusowGA==
X-CSE-MsgGUID: McItsJudQb2JseRSe3ujew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83999523"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 04 Nov 2024 05:18:55 -0800
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
Subject: [PATCH v4 10/13] iommu/vt-d: Fail SVA domain replacement
Date: Mon,  4 Nov 2024 05:18:39 -0800
Message-Id: <20241104131842.13303-11-yi.l.liu@intel.com>
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

There is no known usage that will attach SVA domain or detach SVA domain
by replacing PASID to or from SVA domain. It is supposed to use the
iommu_sva_{un}bind_device() which invoke the  iommu_{at|de}tach_device_pasid().
So Intel iommu driver decides to fail the domain replacement if the old
domain or new domain is SVA type.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 8 ++++++++
 drivers/iommu/intel/svm.c   | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 0e0e9eb5188a..7e82b3a4bba7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4352,6 +4352,10 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING)))
 		return -EINVAL;
 
+	/* No SVA domain replacement usage so far */
+	if (old && old->type == IOMMU_DOMAIN_SVA)
+		return -EOPNOTSUPP;
+
 	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
 		return -EOPNOTSUPP;
 
@@ -4620,6 +4624,10 @@ static int identity_domain_set_dev_pasid(struct iommu_domain *domain,
 	struct intel_iommu *iommu = info->iommu;
 	int ret;
 
+	/* No SVA domain replacement usage so far */
+	if (old && old->type == IOMMU_DOMAIN_SVA)
+		return -EOPNOTSUPP;
+
 	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
 		return -EOPNOTSUPP;
 
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 925afca7529e..06404716ad37 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -207,6 +207,9 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 	unsigned long sflags;
 	int ret = 0;
 
+	if (old)
+		return -EOPNOTSUPP;
+
 	dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
 	if (IS_ERR(dev_pasid))
 		return PTR_ERR(dev_pasid);
-- 
2.34.1


