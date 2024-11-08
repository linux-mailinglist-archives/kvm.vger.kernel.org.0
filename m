Return-Path: <kvm+bounces-31259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF609C1C9F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47DCFB24563
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE671E882D;
	Fri,  8 Nov 2024 12:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hHKk23/E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FE01E7C1B
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731067483; cv=none; b=JvJvH/+MVuOcdVex81ukafEKGPZL+wXGM5MzBmN7UiNC6ZtUUvEeBsO4g98pel2xi0Oi7c27EkxA20+cRwHCWcqqdAkxj7DKPGunHY0aDwoTnF2f2+jRh6vTl4rQY68OKolKx/w+6/cmIykPt0Z0V9bagsWL92AP4dlS5zF7cmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731067483; c=relaxed/simple;
	bh=Mejinn7dwxrWFJJxi0gYE+6CIjdQ4PZ7QCUJBDIlsZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qjEDkp0lGyao18nH6Nk/4IqvUZC5yukxYABpo9+DGgfXJJTHgpqY5eIMGY/gUxt+2/E7T9GCzsl5qEFiynpVG7n5KTL8QBCCTD3KKdS9LbbTmYI6n5BDs70w043KAG4Yqp/l0D2olfWDu13qZCXTiVWD009WJW1CFLiNYmrzaTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hHKk23/E; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731067483; x=1762603483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mejinn7dwxrWFJJxi0gYE+6CIjdQ4PZ7QCUJBDIlsZY=;
  b=hHKk23/EoFTKOlJwqVV9XOsql7H24N0vMTJLPp3hrTad622SvQk6yJ1P
   /ZaRpJRG+pY2aecbqnvYrbLhBf3TmUdwsyDOuXEeAE3v4lWTLzK2JDzKX
   LqXooBmc4zLqdw4fg6fL5FJZLad1q0RyFhA596YStEf+Oj5gPT+TrxXBH
   VSpPj4Dkv7SeF/yiBW/Ccl8vAkcp6oq0LLmqExv+6UPSbnLPU3QUJHiJm
   8z2kQu2PrpliYuMzF/Jq96WLVG4TGp+PIufFIeE40gUQvS3f9thhsErn0
   sETP8mX1iekwXtuTpuSXC1JV2whu+nrjPGBe3sahdg0yz4TP6YPCKae7g
   A==;
X-CSE-ConnectionGUID: U7A82M5tRL+Z7Jwb6mSNIw==
X-CSE-MsgGUID: rcKuPaK7TreDGas5Vpn8ng==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31116448"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31116448"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:04:34 -0800
X-CSE-ConnectionGUID: HeJOK7pPTzO1DxBE0Wu1HA==
X-CSE-MsgGUID: xGl0tHZJTbawrD+vXM23Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85679050"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa008.fm.intel.com with ESMTP; 08 Nov 2024 04:04:33 -0800
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
Subject: [PATCH v4 6/7] iommu/amd: Make the blocked domain support PASID
Date: Fri,  8 Nov 2024 04:04:26 -0800
Message-Id: <20241108120427.13562-7-yi.l.liu@intel.com>
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

The blocked domain can be extended to park PASID of a device to be the
DMA blocking state. By this the remove_dev_pasid() op is dropped.

Remove PASID from old domain and device GCR3 table. No need to attach
PASID to the blocked domain as clearing PASID from GCR3 table will make
sure all DMAs for that PASID are blocked.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/amd/iommu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5ce8e6504ba7..d216313b6d44 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2468,10 +2468,19 @@ static int blocked_domain_attach_device(struct iommu_domain *domain,
 	return 0;
 }
 
+static int blocked_domain_set_dev_pasid(struct iommu_domain *domain,
+					struct device *dev, ioasid_t pasid,
+					struct iommu_domain *old)
+{
+	amd_iommu_remove_dev_pasid(dev, pasid, old);
+	return 0;
+}
+
 static struct iommu_domain blocked_domain = {
 	.type = IOMMU_DOMAIN_BLOCKED,
 	.ops = &(const struct iommu_domain_ops) {
 		.attach_dev     = blocked_domain_attach_device,
+		.set_dev_pasid  = blocked_domain_set_dev_pasid,
 	}
 };
 
@@ -2894,7 +2903,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.def_domain_type = amd_iommu_def_domain_type,
 	.dev_enable_feat = amd_iommu_dev_enable_feature,
 	.dev_disable_feat = amd_iommu_dev_disable_feature,
-	.remove_dev_pasid = amd_iommu_remove_dev_pasid,
 	.page_response = amd_iommu_page_response,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= amd_iommu_attach_device,
-- 
2.34.1


