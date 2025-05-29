Return-Path: <kvm+bounces-47960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCEFFAC786C
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 992C61C2265B
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC6F270542;
	Thu, 29 May 2025 05:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GQALThth"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39F826FDA8;
	Thu, 29 May 2025 05:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497488; cv=none; b=WxJyedeIUjsn3A8DOzUjSy+NC99o/nX3UlmGtM+YlA0tjgpMImkg+5M9SIZFtBx7WFBTQ40Ml1UPrA/yaRHO8HRp9LQ6w+gc8L7xyndvOKNEI5DkDgVn7F5dc/TLJ1uRsDJ7+/sser9fuoADKIlmeV73r2SCGtDsXNZPEsdUnK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497488; c=relaxed/simple;
	bh=5t1xbsesQU/RfLeQac4mL21mX07YhXCrMjP205S8yWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MaUxjCV67wnxANb7P8DD0YyundQokjzPv32f9gzr7VJt1Ai92sIVu5OsGqX9+CpUwUkpkKNN89Fw1W0oUxQf7O8MRHU6K2j+DKKkdpnAN2cNusPhii5m6PD9/7WMw5TL7ioryI9r/eY3AIiAkFRYEpNneQoVwJ7daMpNVVI46kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GQALThth; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497487; x=1780033487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5t1xbsesQU/RfLeQac4mL21mX07YhXCrMjP205S8yWk=;
  b=GQALThth886LPpqFb32T//2/yZDnHXFngYsNea9mRzKju0k5AKFFoDQE
   aq7k1I5iYE78Y5KlpRQnh2r7U2Gd7thC6buHgewWF8WiPDGw61jUqAboH
   oPZGRaCfP6MG6bU5c5WAGMb3NgJoRGLIVS9VPjz073jz+wWdbLqQ4082U
   YBo6AbD+N/oXSnBKDaWVlv9qij8AuH5VnBTskhNSb8SyavlNExLfDFvFn
   eKq4hSIyFLbjwOot+QM6l0L16kNhQI5gVJAzH8j0agPIvDc//XG2lnccp
   F0KV/muQIsEUvN/8fNApZIsBlfQ5ugrcCCN5VUuwyNi6xGwxvG2J+nswn
   A==;
X-CSE-ConnectionGUID: a3OZXH16QkSxJ8rrED2ZDA==
X-CSE-MsgGUID: 3bFjKOuzQb2VEm35xBgtNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963505"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963505"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:44:47 -0700
X-CSE-ConnectionGUID: w8s4Yi3kTTiJadEJ5384Ag==
X-CSE-MsgGUID: PoWShFvhTNGfLLU1Qt6FIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443689"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:44:40 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 29/30] iommufd/vdevice: Implement TSM handlers for trusted DMA
Date: Thu, 29 May 2025 13:35:12 +0800
Message-Id: <20250529053513.1592088-30-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IOMMUFD implements disable_trusted_dma() handler to clean up trusted
DMA configuration when device is to be unbound.

For now these handlers are mainly for Intel TDX Connect, but should
have no impact since other platform TSM drivers don't call these
handlers.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/iommu/iommufd/viommu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index c64ce1a9f87d..b7281a4422ff 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -255,8 +255,16 @@ static void iommufd_vdevice_disable_trusted_dma(struct iommufd_vdevice *vdev)
 	vdev->trusted_dma_enabled = false;
 }
 
+static void pci_driver_disable_trusted_dma(struct pci_dev *pdev)
+{
+	struct iommufd_vdevice *vdev = pdev->trusted_dma_owner;
+
+	iommufd_vdevice_disable_trusted_dma(vdev);
+}
+
 int iommufd_vdevice_tsm_bind(struct iommufd_vdevice *vdev)
 {
+	struct pci_dev *pdev = to_pci_dev(vdev->dev);
 	struct kvm *kvm;
 	int rc;
 
@@ -272,6 +280,9 @@ int iommufd_vdevice_tsm_bind(struct iommufd_vdevice *vdev)
 		goto out_unlock;
 	}
 
+	pdev->trusted_dma_owner = vdev;
+	pdev->driver->tsm_handler->disable_trusted_dma = pci_driver_disable_trusted_dma;
+
 	rc = iommufd_vdevice_enable_trusted_dma(vdev);
 	if (rc)
 		goto out_unlock;
@@ -292,12 +303,16 @@ int iommufd_vdevice_tsm_bind(struct iommufd_vdevice *vdev)
 
 void iommufd_vdevice_tsm_unbind(struct iommufd_vdevice *vdev)
 {
+	struct pci_dev *pdev = to_pci_dev(vdev->dev);
+
 	mutex_lock(&vdev->tsm_lock);
 	if (!vdev->tsm_bound)
 		goto out_unlock;
 
 	pci_tsm_unbind(to_pci_dev(vdev->dev));
 	iommufd_vdevice_disable_trusted_dma(vdev);
+	pdev->trusted_dma_owner = NULL;
+	pdev->driver->tsm_handler->disable_trusted_dma = NULL;
 	vdev->tsm_bound = false;
 
 out_unlock:
-- 
2.25.1


