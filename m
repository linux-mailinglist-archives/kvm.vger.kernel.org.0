Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7752740C303
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 11:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhIOJxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 05:53:09 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3817 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237403AbhIOJwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 05:52:46 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8b5T68skz67xLd;
        Wed, 15 Sep 2021 17:49:01 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:51:25 +0200
Received: from A2006125610.china.huawei.com (10.47.83.177) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 10:51:19 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v3 3/6] hisi_acc_qm: Move PCI device IDs to common header
Date:   Wed, 15 Sep 2021 10:50:34 +0100
Message-ID: <20210915095037.1149-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.83.177]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the PCI Device IDs of HiSilicon ACC devices to
a common header and use a uniform naming convention.

This will be useful when we introduce the vfio PCI
HiSilicon ACC live migration driver in subsequent patches.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 12 +++++-------
 drivers/crypto/hisilicon/sec2/sec_main.c  |  2 --
 drivers/crypto/hisilicon/zip/zip_main.c   | 11 ++++-------
 include/linux/hisi_acc_qm.h               |  7 +++++++
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 65a641396c07..1de67b5baae3 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -68,8 +68,6 @@
 #define HPRE_REG_RD_INTVRL_US		10
 #define HPRE_REG_RD_TMOUT_US		1000
 #define HPRE_DBGFS_VAL_MAX_LEN		20
-#define HPRE_PCI_DEVICE_ID		0xa258
-#define HPRE_PCI_VF_DEVICE_ID		0xa259
 #define HPRE_QM_USR_CFG_MASK		GENMASK(31, 1)
 #define HPRE_QM_AXI_CFG_MASK		GENMASK(15, 0)
 #define HPRE_QM_VFG_AX_MASK		GENMASK(7, 0)
@@ -111,8 +109,8 @@
 static const char hpre_name[] = "hisi_hpre";
 static struct dentry *hpre_debugfs_root;
 static const struct pci_device_id hpre_dev_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PCI_DEVICE_ID) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PCI_VF_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PF_PCI_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_VF_PCI_DEVICE_ID) },
 	{ 0, }
 };
 
@@ -242,7 +240,7 @@ MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
 
 static int pf_q_num_set(const char *val, const struct kernel_param *kp)
 {
-	return q_num_set(val, kp, HPRE_PCI_DEVICE_ID);
+	return q_num_set(val, kp, HPRE_PF_PCI_DEVICE_ID);
 }
 
 static const struct kernel_param_ops hpre_pf_q_num_ops = {
@@ -921,7 +919,7 @@ static int hpre_debugfs_init(struct hisi_qm *qm)
 	qm->debug.sqe_mask_len = HPRE_SQE_MASK_LEN;
 	hisi_qm_debug_init(qm);
 
-	if (qm->pdev->device == HPRE_PCI_DEVICE_ID) {
+	if (qm->pdev->device == HPRE_PF_PCI_DEVICE_ID) {
 		ret = hpre_ctrl_debug_init(qm);
 		if (ret)
 			goto failed_to_create;
@@ -958,7 +956,7 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	qm->sqe_size = HPRE_SQE_SIZE;
 	qm->dev_name = hpre_name;
 
-	qm->fun_type = (pdev->device == HPRE_PCI_DEVICE_ID) ?
+	qm->fun_type = (pdev->device == HPRE_PF_PCI_DEVICE_ID) ?
 			QM_HW_PF : QM_HW_VF;
 	if (qm->fun_type == QM_HW_PF) {
 		qm->qp_base = HPRE_PF_DEF_Q_BASE;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 90551bf38b52..890ff6ab18dd 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -20,8 +20,6 @@
 
 #define SEC_VF_NUM			63
 #define SEC_QUEUE_NUM_V1		4096
-#define SEC_PF_PCI_DEVICE_ID		0xa255
-#define SEC_VF_PCI_DEVICE_ID		0xa256
 
 #define SEC_BD_ERR_CHK_EN0		0xEFFFFFFF
 #define SEC_BD_ERR_CHK_EN1		0x7ffff7fd
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 7148201ce76e..f35b8fd1ecfe 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -15,9 +15,6 @@
 #include <linux/uacce.h>
 #include "zip.h"
 
-#define PCI_DEVICE_ID_ZIP_PF		0xa250
-#define PCI_DEVICE_ID_ZIP_VF		0xa251
-
 #define HZIP_QUEUE_NUM_V1		4096
 
 #define HZIP_CLOCK_GATE_CTRL		0x301004
@@ -246,7 +243,7 @@ MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
 
 static int pf_q_num_set(const char *val, const struct kernel_param *kp)
 {
-	return q_num_set(val, kp, PCI_DEVICE_ID_ZIP_PF);
+	return q_num_set(val, kp, ZIP_PF_PCI_DEVICE_ID);
 }
 
 static const struct kernel_param_ops pf_q_num_ops = {
@@ -268,8 +265,8 @@ module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
 MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63), 0(default)");
 
 static const struct pci_device_id hisi_zip_dev_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_PF) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_VF) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, ZIP_PF_PCI_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, ZIP_VF_PCI_DEVICE_ID) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
@@ -834,7 +831,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	qm->sqe_size = HZIP_SQE_SIZE;
 	qm->dev_name = hisi_zip_name;
 
-	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ?
+	qm->fun_type = (pdev->device == ZIP_PF_PCI_DEVICE_ID) ?
 			QM_HW_PF : QM_HW_VF;
 	if (qm->fun_type == QM_HW_PF) {
 		qm->qp_base = HZIP_PF_DEF_Q_BASE;
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 8befb59c6fb3..2d209bf15419 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -9,6 +9,13 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
+#define ZIP_PF_PCI_DEVICE_ID		0xa250
+#define ZIP_VF_PCI_DEVICE_ID		0xa251
+#define SEC_PF_PCI_DEVICE_ID		0xa255
+#define SEC_VF_PCI_DEVICE_ID		0xa256
+#define HPRE_PF_PCI_DEVICE_ID		0xa258
+#define HPRE_VF_PCI_DEVICE_ID		0xa259
+
 #define QM_QNUM_V1			4096
 #define QM_QNUM_V2			1024
 #define QM_MAX_VFS_NUM_V2		63
-- 
2.17.1

