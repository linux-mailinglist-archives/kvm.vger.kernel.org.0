Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6935B6E6B08
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbjDRRaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjDRR3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:29:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E802F26BC;
        Tue, 18 Apr 2023 10:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681838990; x=1713374990;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QtN+Gn8m6GoE1K9sHr26L3K3cEPPiJQ24QAc56BarA0=;
  b=Xotw5asohSB3xO2dxfHqcfTxSI0pBPb1cB1WVDbVz2HCY50egUGZznEq
   jZGaX3M3T9i9dPyAe8xGsjc25fNp/COexxWIpDX9SMLvG9Q5vIXElxpqj
   IeZlnlaQAGE2wbucNpJm2Yy8DvLAj7H4NfG9+PbELCxRmmcgRAEXcg8ar
   Lr94DNt9E6C2Lueeu3HckEiGQjJ7/zVCk9bkoTE3TERxUTcLcwex7BHP1
   jUul28UcFFaj8mDvfIPibxnYErW5da+7Pvx4mAeXyeiXMUHqR3d/8h0LO
   Y+T/XqJ4DNQhAwQriMB4t4WuiP8JjEmHgRPJaj85Z8uYcJPawEtm6unrJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="410466481"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="410466481"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="865503487"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="865503487"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:42 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V3 07/10] vfio/pci: Update stale comment
Date:   Tue, 18 Apr 2023 10:29:18 -0700
Message-Id: <f16872889aed9a7b042a7e53722b9ae83430a126.1681837892.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1681837892.git.reinette.chatre@intel.com>
References: <cover.1681837892.git.reinette.chatre@intel.com>
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

In preparation for surrounding code change it is helpful to
ensure that existing comments are accurate.

Remove inaccurate comment about direct access and update
the rest of the comment to reflect the purpose of writing
the cached MSI message to the device.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Link: https://lore.kernel.org/lkml/20230330164050.0069e2a5.alex.williamson@redhat.com/
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V2:
- New patch.

 drivers/vfio/pci/vfio_pci_intrs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 5e3de004f4cb..bdda7f46c2be 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -419,11 +419,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	}
 
 	/*
-	 * The MSIx vector table resides in device memory which may be cleared
-	 * via backdoor resets. We don't allow direct access to the vector
-	 * table so even if a userspace driver attempts to save/restore around
-	 * such a reset it would be unsuccessful. To avoid this, restore the
-	 * cached value of the message prior to enabling.
+	 * If the vector was previously allocated, refresh the on-device
+	 * message data before enabling in case it had been cleared or
+	 * corrupted since writing.
 	 */
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	if (msix) {
-- 
2.34.1

