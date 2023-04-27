Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098106F0AF2
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbjD0Rgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244436AbjD0Rg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:36:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D9035A4;
        Thu, 27 Apr 2023 10:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682616986; x=1714152986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cSgLlGdyxaXFMa3vrlcEIL4XkCkVpS7t5FiSBXiFMow=;
  b=AsvZtfkhjWhYkIOzSUUTF8NOt5+p58ne09Qs98uPd/DtS/hTsEakcDjg
   Ta/csH/pS0i5YfvXvFV5GeTjnCsqTHdWN+cERCpImxXO6f0atJDN+nXgO
   c5Yfn2o8FERX6Xo0i9Ua1b9k450+u8zL0QiJsvBe9jEZzs9vBCf7Lejlb
   VRzbejDlazqAuYKYvSrVsb+tMMSS+7ts9zeNv6Q6TtEShkLNXFUxoLxTp
   W0ImXyZfOA5YYgV9w/ZJZlH5okkeSvDJFt55H1wBJ0dLFT3npBrm/QRAz
   klTQJzPo3Q+2vXYrm3+b41Cv9NuiHMBKwZnhcF97dvOnLty2WqYJ9KLrS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349496916"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="349496916"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697172986"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="697172986"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:21 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V4 07/11] vfio/pci: Update stale comment
Date:   Thu, 27 Apr 2023 10:36:04 -0700
Message-Id: <f16872889aed9a7b042a7e53722b9ae83430a126.1682615447.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1682615447.git.reinette.chatre@intel.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
No changes since V3.

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

