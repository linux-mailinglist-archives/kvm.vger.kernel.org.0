Return-Path: <kvm+bounces-66224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E50CCAF0B
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EEBBE3021F77
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FED334C22;
	Thu, 18 Dec 2025 08:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EN8uJaOJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CC9334682;
	Thu, 18 Dec 2025 08:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766045664; cv=none; b=lQHjVnPbrX5vAoIAp6qYDdzrRb7hXqXC8iT7aBwiINWWvCvPVyqQVDfDhehzYKuRZWcz6VEA/Nl5+N70FwZSOZ9MvnFPBwI7PMKL10jxq4CUM3CnIIdiLykoCg2sAEB5lzsCLMEFmBx1Qn+7VoucTgPzJ+8/xRoFgf/8Y5a6wPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766045664; c=relaxed/simple;
	bh=EkXp/yoJkC8tUk2OxE2Ch9XQbJPir8bxJvRZkcywgB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7gCZutMxKGGx5rGiRvFA056FmhD4eZJUJwuSXx1zy6ncyEfEbVoeQNXbsiIyH9D7mqgJj0E9S3cbL0YRxkM4u42cnq7NlvRgZUQDXeSZU7cIQlKHreJgL6Y88Wdz7/2sevcc5P3LWvTk+yAouUhtF+txmsfP5A3uRQ85OO69as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EN8uJaOJ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766045662; x=1797581662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EkXp/yoJkC8tUk2OxE2Ch9XQbJPir8bxJvRZkcywgB8=;
  b=EN8uJaOJHfw/hU5p7H9zz5+QNhFwWb3qDCqk5scRmK+zUWXSC8CItUi0
   x0/N/CFmAANO+WVnFOJVKGL4DeNwl/Ja5PKI2Ozb5XNPDp+9av8q+ZqB/
   ekTAdsHRt7E6894uo5OdkkuORUz5JerBpiexDWUGkhQWMRtLnysRNY+Xn
   aytBNjBBf1GMYL7x8uEb7JE7aOrBBnNK19/s3ClpoDErv3fQ/pm/Ywg0e
   NOhpr13HEWv1y5hiDdCdxyCg9hsi08fNlx7f+P+vOz7qgGKESnvdmR/3W
   xlAeUWaik/TN/3ekxmPAqaRt8uUdpSzuWoXfDInENa3z/aXNWoh9ad5Ib
   g==;
X-CSE-ConnectionGUID: hSjzLYqUQEaOgZboxn5dbA==
X-CSE-MsgGUID: fINESjY6SrmOzB7sdJPnrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="67188220"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="67188220"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 00:14:22 -0800
X-CSE-ConnectionGUID: nWA+t2cJTZeF7CdSB4hr7g==
X-CSE-MsgGUID: DZRwOJ+KQgW24zgyZ4+EAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198599641"
Received: from ktian1-pkvm.sh.intel.com ([10.239.48.205])
  by orviesa008.jf.intel.com with ESMTP; 18 Dec 2025 00:14:19 -0800
From: Kevin Tian <kevin.tian@intel.com>
To: Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ramesh Thomas <ramesh.thomas@intel.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] vfio/pci: Disable qword access to the VGA region
Date: Thu, 18 Dec 2025 08:16:50 +0000
Message-ID: <20251218081650.555015-3-kevin.tian@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251218081650.555015-1-kevin.tian@intel.com>
References: <20251218081650.555015-1-kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Seems no reason to allow qword access to the old VGA resource. Better
restrict it to dword access as before.

Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 25380b7dfe18..b38627b35c35 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -363,7 +363,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	 * to the memory enable bit in the command register.
 	 */
 	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
-				      0, 0, iswrite, VFIO_PCI_IO_WIDTH_8);
+				      0, 0, iswrite, VFIO_PCI_IO_WIDTH_4);
 
 	vga_put(vdev->pdev, rsrc);
 
-- 
2.43.0


