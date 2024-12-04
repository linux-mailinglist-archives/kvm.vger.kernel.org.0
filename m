Return-Path: <kvm+bounces-33010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 759ED9E39F4
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3955C286143
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3FA1BBBE3;
	Wed,  4 Dec 2024 12:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z84rW8VG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8571ADFFB
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733315374; cv=none; b=IwZ6Uqm6OnVblhWLl52AX8roU7ow+isoPkJMZU/IzczC3cuh4LuJBd+h66tUefmjpaELvCuvY9lL5xIePybxAS2LYP+PQFwquXTV0idI3Z7P8r17LhlKuY6CHRdr0aIYDfzisWkKnrM8BHsyWSFL9+leeAOq9O3SCE2cB++pt7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733315374; c=relaxed/simple;
	bh=6PUXI+3NsTHsfAL2o1cIt8/S23ikcs+UsrxO1KYisNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MQEuynGlaxmB+U0xMdJIYVpDESFaQH7RM1IG0LNy5OwbdguTlBpgTA9X3scW1GpVz7Mln4QJ3JSxx9oD8xiQFlD9lr/ZjIrihhmRyFJA+t+RnsHwpIxw5cGWEsrw5ps9IbUv2L8b1gxLliRX257XJCJYGvZp+Q6OlrQuej2CEpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z84rW8VG; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733315373; x=1764851373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6PUXI+3NsTHsfAL2o1cIt8/S23ikcs+UsrxO1KYisNQ=;
  b=Z84rW8VG4IWESRyMJ5vB3swSAaoRtuaOOx1ZmFBgs5S/3NnbMm/s+kT4
   dIpM5OVnVwc5U6WxO910vFIJ0e4XR3Y+pdwQ0jvMhWpp7RG4kaMzVDTAV
   9L4GoclUwcqZdNCcD/v3f+C6HQGdNBQkNkMGeqwbimWXfpPzDgugW26Px
   zlunQ+twm5IGp1KTS/8LiqXmobk0Gw1JE8NbHm0ONF4BLNOwrkyULd9rV
   1HMf5kJKLU8XdD7YoXyoxCOpr65moE8LjC5X253Qx1d2Ae6Cj19rne8En
   7WcprltBf5MO6C1QX/yrecjhZKtJadVYvnOym3bzSb1AGgcZJqv6wgCP1
   w==;
X-CSE-ConnectionGUID: l3uNs14nT5mo8fVQsgwLCQ==
X-CSE-MsgGUID: Ahok8FWOT0SZL/lHTBoabQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="32937877"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="32937877"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 04:29:32 -0800
X-CSE-ConnectionGUID: DyUOY3OOQ/GzbGdPILecOA==
X-CSE-MsgGUID: sM8NdmSDSQuavqRraIpWFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93599065"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 04 Dec 2024 04:29:31 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	will@kernel.org
Subject: [PATCH v6 1/7] iommu: Prevent pasid attach if no ops->remove_dev_pasid
Date: Wed,  4 Dec 2024 04:29:22 -0800
Message-Id: <20241204122928.11987-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241204122928.11987-1-yi.l.liu@intel.com>
References: <20241204122928.11987-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

driver should implement both set_dev_pasid and remove_dev_pasid op, otherwise
it is a problem how to detach pasid. In reality, it is impossible that an
iommu driver implements set_dev_pasid() but no remove_dev_pasid() op. However,
it is better to check it.

Move the group check to be the first as dev_iommu_ops() may fail when there
is no valid group. Also take the chance to remove the dev_has_iommu() check
as it is duplicated to the group check.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 9bc0c74cca3c..38c3f67e441f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3368,16 +3368,19 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	/* Caller must be a probed driver on dev */
 	struct iommu_group *group = dev->iommu_group;
 	struct group_device *device;
+	const struct iommu_ops *ops;
 	int ret;
 
-	if (!domain->ops->set_dev_pasid)
-		return -EOPNOTSUPP;
-
 	if (!group)
 		return -ENODEV;
 
-	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
-	    pasid == IOMMU_NO_PASID)
+	ops = dev_iommu_ops(dev);
+
+	if (!domain->ops->set_dev_pasid ||
+	    !ops->remove_dev_pasid)
+		return -EOPNOTSUPP;
+
+	if (ops != domain->owner || pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
-- 
2.34.1


