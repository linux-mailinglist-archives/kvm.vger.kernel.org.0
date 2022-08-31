Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC755A79A5
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 11:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiHaJAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 05:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiHaJAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 05:00:14 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90DC22B00
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 02:00:10 -0700 (PDT)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MHdQv2HJPz67hlj;
        Wed, 31 Aug 2022 16:59:35 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 11:00:08 +0200
Received: from A2006125610.china.huawei.com (10.195.245.177) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 31 Aug 2022 10:00:04 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <liulongfang@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for hssi_acc_drvdata()
Date:   Wed, 31 Aug 2022 09:59:43 +0100
Message-ID: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.195.245.177]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.2 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the
vfio_pci_core_device in drvdata") introduced a helper function to
retrieve the drvdata but used "hssi" instead of "hisi" for the
function prefix. Correct that and also while at it, moved the
function a bit down so that it's close to other hisi_ prefixed
functions.

No functional changes.

Fixes: 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata")
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index ea762e28c1cc..258cae0863ea 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -337,14 +337,6 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
 	return 0;
 }
 
-static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev *pdev)
-{
-	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
-
-	return container_of(core_device, struct hisi_acc_vf_core_device,
-			    core_device);
-}
-
 static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 			    struct hisi_qm *qm)
 {
@@ -552,6 +544,14 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	return 0;
 }
 
+static struct hisi_acc_vf_core_device *hisi_acc_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct hisi_acc_vf_core_device,
+			    core_device);
+}
+
 /* Check the PF's RAS state and Function INT state */
 static int
 hisi_acc_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
@@ -970,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 
 static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 
 	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
 				VFIO_MIGRATION_STOP_COPY)
@@ -1301,7 +1301,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 
 static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
 	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
-- 
2.34.1

