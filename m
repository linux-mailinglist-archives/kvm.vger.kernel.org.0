Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A02840C2FE
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 11:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbhIOJwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 05:52:43 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3815 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhIOJwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 05:52:30 -0400
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8b5M1PYcz67bjB;
        Wed, 15 Sep 2021 17:48:55 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:51:09 +0200
Received: from A2006125610.china.huawei.com (10.47.83.177) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 10:51:03 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v3 1/6] crypto: hisilicon/qm: Move the QM header to include/linux
Date:   Wed, 15 Sep 2021 10:50:32 +0100
Message-ID: <20210915095037.1149-2-shameerali.kolothum.thodi@huawei.com>
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

Since we are going to introduce VFIO PCI HiSilicon ACC
driver for live migration in subsequent patches, move
the ACC QM header file to a common include dir

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h                         | 2 +-
 drivers/crypto/hisilicon/qm.c                                | 2 +-
 drivers/crypto/hisilicon/sec2/sec.h                          | 2 +-
 drivers/crypto/hisilicon/sgl.c                               | 2 +-
 drivers/crypto/hisilicon/zip/zip.h                           | 2 +-
 drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h | 0
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h (100%)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index e0b4a1982ee9..9a0558ed82f9 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -4,7 +4,7 @@
 #define __HISI_HPRE_H
 
 #include <linux/list.h>
-#include "../qm.h"
+#include <linux/hisi_acc_qm.h>
 
 #define HPRE_SQE_SIZE			sizeof(struct hpre_sqe)
 #define HPRE_PF_DEF_Q_NUM		64
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 369562d34d66..e791a4fe47bc 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -15,7 +15,7 @@
 #include <linux/uacce.h>
 #include <linux/uaccess.h>
 #include <uapi/misc/uacce/hisi_qm.h>
-#include "qm.h"
+#include <linux/hisi_acc_qm.h>
 
 /* eq/aeq irq enable */
 #define QM_VF_AEQ_INT_SOURCE		0x0
diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index d97cf02b1df7..c2e9b01187a7 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -4,7 +4,7 @@
 #ifndef __HISI_SEC_V2_H
 #define __HISI_SEC_V2_H
 
-#include "../qm.h"
+#include <linux/hisi_acc_qm.h>
 #include "sec_crypto.h"
 
 /* Algorithm resource per hardware SEC queue */
diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 057273769f26..534687401135 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -3,7 +3,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include "qm.h"
+#include <linux/hisi_acc_qm.h>
 
 #define HISI_ACC_SGL_SGE_NR_MIN		1
 #define HISI_ACC_SGL_NR_MAX		256
diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index 517fdbdff3ea..1997c3233911 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -7,7 +7,7 @@
 #define pr_fmt(fmt)	"hisi_zip: " fmt
 
 #include <linux/list.h>
-#include "../qm.h"
+#include "linux/hisi_acc_qm.h"
 
 enum hisi_zip_error_type {
 	/* negative compression */
diff --git a/drivers/crypto/hisilicon/qm.h b/include/linux/hisi_acc_qm.h
similarity index 100%
rename from drivers/crypto/hisilicon/qm.h
rename to include/linux/hisi_acc_qm.h
-- 
2.17.1

