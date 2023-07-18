Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DE17579C3
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 12:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjGRKzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 06:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjGRKzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 06:55:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5207A10D2;
        Tue, 18 Jul 2023 03:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689677746; x=1721213746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x9Za36sOUoLPDoOSgZukY7zrqhJK91tAIzXkyH0NbWU=;
  b=cW7U4KhyLTS4ADjLNxCYRoCtR4iAwC1DTELtRbTNHhs7m4FpOEm4ERrd
   OS5N7f+3y9tWYBgulibifp4IQQGcRo0FU/5Xzp6JCZa2bUYD81NKMVEUr
   doCyElMjww+E6IJvWbWek7wHlT6MmOzBCOVeWX1Jd/UL3fAotQwfYZxTW
   EdEM2CUP6MfSyaRSK7bjbI6nPm9Sgn4zC7mEgf3a6SdKB8TZQu26TPo+i
   II7wmZwajDTl7a+d8AiPpJBMI0aSUU6S+HAEqxK6sRcL9TTNwh07s4nKV
   TF7yQBTasf7U/tGFW3J5r3LJgQTk/Nz0SElP520b95lTfx7zD6FdK72M+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="452553515"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452553515"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 03:55:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="673863792"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="673863792"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga003.jf.intel.com with ESMTP; 18 Jul 2023 03:55:44 -0700
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
Subject: [PATCH v10 01/10] vfio/pci: Update comment around group_fd get in vfio_pci_ioctl_pci_hot_reset()
Date:   Tue, 18 Jul 2023 03:55:33 -0700
Message-Id: <20230718105542.4138-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230718105542.4138-1-yi.l.liu@intel.com>
References: <20230718105542.4138-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This suits more on what the code does.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 20d7b69ea6ff..4e228e2a6d99 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1349,9 +1349,8 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
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

