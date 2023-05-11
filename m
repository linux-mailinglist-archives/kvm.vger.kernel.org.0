Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF3A6FF653
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 17:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbjEKPpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 11:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbjEKPpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 11:45:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D431B5B93;
        Thu, 11 May 2023 08:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683819901; x=1715355901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+C6B7H7ve/lwfgUWQi6R33paNDdITx62G7bxEy6HEqA=;
  b=IwGfVQLezTasKcUFeB3X6ofNyhWDMwl7Mwen1aTIBDAPI03VfL8Zn3ps
   nRPOfVCwfLPGwERnZhqjwNDEEJHrcSLMQNxpM1Xdzox6aZsMMzCsI4iDY
   zbmQ/FGtxY1dgsUWJUtjXEmCmYKDch/4lOgSjxErDosLDv/BHuam2hddV
   kON5Bwlnq6TffAohBBdLd2uj4Jse2Lk3q/JJPvZ3j3jO62bIvwigwcrdx
   cz9TE0O9NfVC32Gd8pqxEhpYYfGHpvk6CGjeMHvT3JCjhboUL2hBDGAYU
   htDyA7SSsBErJeDyIO8yxnaPT5cEnJF3NLpNUVYj1WKPRJydHQtBeSxbn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335046681"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335046681"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699776239"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699776239"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:48 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V5 07/11] vfio/pci: Update stale comment
Date:   Thu, 11 May 2023 08:44:34 -0700
Message-Id: <5b605ce7dcdab5a5dfef19cec4d73ae2fdad3ae1.1683740667.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1683740667.git.reinette.chatre@intel.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Changes since V4:
- Restore text about backdoor reset as example to indicate that
  the restore may not be a severe problem but instead done in
  collaboration with user space. (Kevin)

Changes since V2:
- New patch.

 drivers/vfio/pci/vfio_pci_intrs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index e40eca69a293..867327e159c1 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -428,11 +428,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	}
 
 	/*
-	 * The MSIx vector table resides in device memory which may be cleared
-	 * via backdoor resets. We don't allow direct access to the vector
-	 * table so even if a userspace driver attempts to save/restore around
-	 * such a reset it would be unsuccessful. To avoid this, restore the
-	 * cached value of the message prior to enabling.
+	 * If the vector was previously allocated, refresh the on-device
+	 * message data before enabling in case it had been cleared or
+	 * corrupted (e.g. due to backdoor resets) since writing.
 	 */
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	if (msix) {
-- 
2.34.1

