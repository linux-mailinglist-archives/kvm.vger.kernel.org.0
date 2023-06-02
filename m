Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4EE720152
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 14:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbjFBMPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 08:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbjFBMPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 08:15:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9742E1BF;
        Fri,  2 Jun 2023 05:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685708118; x=1717244118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PCisGYDRxuCZiZ9JGfK9mHAN8YQFOf+oWDiI76hrHHg=;
  b=PE6naXsr6IqbQ6QCnHt7zNBvc1PbC4Y9JaeBALhhZgK49iHjYUiwYsdF
   jgkDa30T4uyipFz98R4sKuUMhc0EANGpPbQCzp9cERCrbh7/e+2ST0cmL
   oinKCWg27XuWZgADBvEFMkBNk9h+jhynnL/o+JPs8Tl8pxJ/WbeZqSimV
   rdgKvDoZJS1MdXQsgE5GHqYxXBnGl/Ow7t7MyldFQM6/0T8nJQ4N8QRFH
   OAB/tOuGOK/EDWVkGNTsKZf1qy8idvJMXbCkwwk7XYmFa/TQDYLgimlw6
   qJe+1iUrnfZ4g0/pxaF3mXr+ff1spfTkofMGut6VTgssFR+koxqvtNPTO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="335467446"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="335467446"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 05:15:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="772876450"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="772876450"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 02 Jun 2023 05:15:17 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v7 1/9] vfio/pci: Update comment around group_fd get in vfio_pci_ioctl_pci_hot_reset()
Date:   Fri,  2 Jun 2023 05:15:07 -0700
Message-Id: <20230602121515.79374-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602121515.79374-1-yi.l.liu@intel.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This suits more on what the code does.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a5ab416cf476..f824de4dbf27 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1308,9 +1308,8 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	}
 
 	/*
-	 * For each group_fd, get the group through the vfio external user
-	 * interface and store the group and iommu ID.  This ensures the group
-	 * is held across the reset.
+	 * Get the group file for each fd to ensure the group is held across
+	 * the reset
 	 */
 	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
 		struct file *file = fget(group_fds[file_idx]);
-- 
2.34.1

