Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D62410A52
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbhISGoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:44:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:59281 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237818AbhISGn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:43:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="221116027"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="221116027"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:42:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510702015"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:42:24 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 09/20] iommu: Add page size and address width attributes
Date:   Sun, 19 Sep 2021 14:38:37 +0800
Message-Id: <20210919063848.1476776-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

This exposes PAGE_SIZE and ADDR_WIDTH attributes. The iommufd could use
them to define the IOAS.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 943de6897f56..86d34e4ce05e 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -153,9 +153,13 @@ enum iommu_dev_features {
 /**
  * enum iommu_devattr - Per device IOMMU attributes
  * @IOMMU_DEV_INFO_FORCE_SNOOP [bool]: IOMMU can force DMA to be snooped.
+ * @IOMMU_DEV_INFO_PAGE_SIZE [u64]: Page sizes that iommu supports.
+ * @IOMMU_DEV_INFO_ADDR_WIDTH [u32]: Address width supported.
  */
 enum iommu_devattr {
 	IOMMU_DEV_INFO_FORCE_SNOOP,
+	IOMMU_DEV_INFO_PAGE_SIZE,
+	IOMMU_DEV_INFO_ADDR_WIDTH,
 };
 
 #define IOMMU_PASID_INVALID	(-1U)
-- 
2.25.1

