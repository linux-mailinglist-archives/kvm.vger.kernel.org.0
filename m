Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53FC6D316D
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 16:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjDAOof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 10:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjDAOoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 10:44:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FD11B7D6;
        Sat,  1 Apr 2023 07:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680360272; x=1711896272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IPobf8cBYDdoCsj9nkBcWaL+xVq1fXMUUNMJHvpfpYY=;
  b=MjW9aR8aHfndUMcNqpP4CyrKHO7uhfnRI3YzoG2KYxTHTNcdnJ5E3nCO
   bEGDSJxlu4ozowvT5vi9/7y76M+lsSAk9AibQ9kz1Mf0jlWt/c4GMezNf
   v8wP69wcFIVegBVsTUbs9stOEEst5basPML7tzmmX3Pjv1qyJFTRRzclL
   FSUzfrGLCw0v1o0M6RLM0Yfg5dnTaGguS6/v8Q2NCZPBDCb9Pn99beS2M
   RDwAqk7pHY1sSkzquSlABpYPHD34LMBFc75yNWjvEkVtKuiG4vbF0knel
   iBl8NGSB2jRq4Yr30lMOx6AxLLsHBn3AIHyQT9Xf7TR7IXHS9rULa1Oei
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="340385071"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="340385071"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 07:44:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="662705808"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="662705808"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 01 Apr 2023 07:44:31 -0700
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
        yanting.jiang@intel.com
Subject: [PATCH v3 01/12] vfio/pci: Update comment around group_fd get in vfio_pci_ioctl_pci_hot_reset()
Date:   Sat,  1 Apr 2023 07:44:18 -0700
Message-Id: <20230401144429.88673-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401144429.88673-1-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

this suits more on what the code does.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a5ab416cf476..65bbef562268 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1308,9 +1308,8 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	}
 
 	/*
-	 * For each group_fd, get the group through the vfio external user
-	 * interface and store the group and iommu ID.  This ensures the group
-	 * is held across the reset.
+	 * Get the group file for each fd to ensure the group held across
+	 * the reset
 	 */
 	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
 		struct file *file = fget(group_fds[file_idx]);
-- 
2.34.1

