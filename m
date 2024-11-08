Return-Path: <kvm+bounces-31255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 275529C1C9B
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:04:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5987C1C22CFE
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F121E631B;
	Fri,  8 Nov 2024 12:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E88p1+Tr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F431E47CB
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731067474; cv=none; b=H/Ln73D9bAwDSdajwGokV1Imk6M4Pb1HNcgKidmIC/NigiC2Q7XCz4S/2QhKwrMoNDUOrm/emi52495pV5+lIG5Cks9Or0dYCBVSsLdM7ixdGTNi/h401sg75hcHE+PXld9NFBCn2arr5iMdqT6OSEntG1npgWYZjfwSGoZQtmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731067474; c=relaxed/simple;
	bh=hga76UsnkngRS0zS8f0+ZljIoWVttNerXYCKXD9K8aE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JeIV9rUsiqAyrjF7cwUd6ld0xPT5R9ZsWm9Vo/J41aCAFfewXeI6nH03NkOvjY869hnfvkuyRBlDZR27aDvdUT7574wqIsMHKbuoFVBqw30kemWYM8PNEABCDaho2uNru82rLD77wQg0vJFnRltkDeZ9KIiHrMgXc4PcE4m8WUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E88p1+Tr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731067473; x=1762603473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hga76UsnkngRS0zS8f0+ZljIoWVttNerXYCKXD9K8aE=;
  b=E88p1+TrhnHxDJPTIXeu8P2j/E+2Duzsj2wfh4FKL3k7wKZCMLLWqTyM
   z+ldKPBGMyVhyAL/mOp5d5pk2ZuAXSgoXv1GBv8VQ2xV7YedxAs5XDj1N
   h6n1mtwnb2Wabwp46mHDNUTUUTSk4xObANfZgGrV8h22dVi9TbX3uzeZh
   4y2agN2px2pr2vyQAsfS8DcSjSQndfJ4dsWMiLry67mYbM7bVUUsYMtip
   n1o5Vp+igCvbtl+q95lrh5b9xbvTVIMFZirmKA2Iy8QF+cCDxNhGw0Xd0
   NhPObG4M9kdWaWDXwYtKGADemoqIqdynENozfOLUZUR1C4ItLUI9cycS0
   A==;
X-CSE-ConnectionGUID: nVsWI6ISTIeJ2j6DiEnN9Q==
X-CSE-MsgGUID: OdO2hmtkQ8WHO4QIPSAXzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31116406"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31116406"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:04:31 -0800
X-CSE-ConnectionGUID: EoOSmgAcR12+xNQz5v1n/A==
X-CSE-MsgGUID: GzrpdAunSya6SwNaKweqFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85679020"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa008.fm.intel.com with ESMTP; 08 Nov 2024 04:04:29 -0800
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
Subject: [PATCH v4 1/7] iommu: Prevent pasid attach if no ops->remove_dev_pasid
Date: Fri,  8 Nov 2024 04:04:21 -0800
Message-Id: <20241108120427.13562-2-yi.l.liu@intel.com>
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

driver should implement both set_dev_pasid and remove_dev_pasid op, otherwise
it is a problem how to detach pasid. In reality, it is impossible that an
iommu driver implements set_dev_pasid() but no remove_dev_pasid() op. However,
it is better to check it.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 13fcd9d8f2df..1c689e57928e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3352,17 +3352,19 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 			      struct iommu_attach_handle *handle)
 {
 	/* Caller must be a probed driver on dev */
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_group *group = dev->iommu_group;
 	struct group_device *device;
 	int ret;
 
-	if (!domain->ops->set_dev_pasid)
+	if (!domain->ops->set_dev_pasid ||
+	    !ops->remove_dev_pasid)
 		return -EOPNOTSUPP;
 
 	if (!group)
 		return -ENODEV;
 
-	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
+	if (!dev_has_iommu(dev) || ops != domain->owner ||
 	    pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
-- 
2.34.1


