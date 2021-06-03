Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF1739A558
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFCQKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:16 -0400
Received: from mail-bn8nam11on2042.outbound.protection.outlook.com ([40.107.236.42]:32453
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229755AbhFCQKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3r5WXZ/rqLCbQ+XMeyW3OF194qOuK78mgwwkHW3BPV/h/p5Vk1mOhPiE2P2XSeAdg2uKUfrdFl90z9/fh6jelXJ1gpKuxB15EpKIlLT+ZG+53tM8E1z3yUW8B8VpL6kYY1ID7jKxmO6LYFIbzjIOujOeSfZFR2kLmiGjp/QzjvOzM2S+ytXmdWQ1x42s2bS6KwAhmeRk4PskVjyyBktx8FD19TWmk5hdtwsu6gmy171+sh/ozy0bgEluUAUCO/thmCk2wMdmbzo7EJ3L0zu4aSipuXHQL2mqb3J5qpDnJXPiCLRYH4jkW0x/eOj0UHumxAVrro/v+Yp5PEx9H616A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKdwbCTb/KGQH+rz3WFnJ8z0CToEmzY+m3yOzLLiefw=;
 b=nErerJRHN5kK5fWvcFwS8WWA3rzPVOENdW60tDY9YWE9Df3nWNkTccUcowUDfmXYvzibcw5AVs8DCK1NYNR14w0DA5CkI/E5GvBKLl2mSgGfHaeFTEJFzQBk3QejfF92/D45F0HDtB04radvcVXHQ4hxjwUsS/lY19ECy0Nzdx4Dte7tjHEun2Az0R6RwLITPTRTTWv4JdcUDBeQsz+iNON7RLiQc1pdUSb0YTlAdCc/yeHRZquBlGY71RuxNPJNq7WIBPrqWdgbr0jZMFe77X71JMZZZUptilS4c6EpmeOy01jOJRj49cizLEwTMmdfxV/ob9TpVjOaUJPVJHUQeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKdwbCTb/KGQH+rz3WFnJ8z0CToEmzY+m3yOzLLiefw=;
 b=hR6qZr2dFSDuWf0x+//EVS48NscGDmWahYfNnzj/mBlTqI46Et5z9iFJKJPCQLZj5CNEy/Uy8ic0nAgkvzlZzhzmkg1kUlnBFRY3O59xHi16K2N0W0zUk+3RIQwKc3kv+TplzcBSBCLUFUKv1olcUjJsKCM/NZ3dr0/pTl8uni+5STziemvxEcgnIxPuvdcJha1JmbobE5vkz1YzenFXang9VauqK3mFfGy36dj//CCH1TUl3DUsuuPfYsohnLYO7wKoTAKN6Hdl1v86DAt1DUnXq2TFuu6URow/7+OsrURheN4qQEQ2lfjztd1X/zGypMEXk+SP0lZ+J3sdtjg4rQ==
Received: from MW4PR03CA0208.namprd03.prod.outlook.com (2603:10b6:303:b8::33)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Thu, 3 Jun
 2021 16:08:27 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::54) by MW4PR03CA0208.outlook.office365.com
 (2603:10b6:303:b8::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:08:27 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:08:26 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:08:25 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:21 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jgg@nvidia.com>
CC:     <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 02/11] vfio-pci: rename vfio_pci_private.h to vfio_pci_core.h
Date:   Thu, 3 Jun 2021 19:08:00 +0300
Message-ID: <20210603160809.15845-3-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5b50715-5417-45d6-7883-08d926a9d283
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5456:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB54567B01BAF95622195FBCCBDE3C9@SJ0PR12MB5456.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dyzbj0bT/3krxDFC564EZt6gHZsUX19HHdPBEidRIENXVa+83rY8UAG2psGwkTcTgwqJ6ZKPI7CaZqYNQoV8v6MxAmGA8HQ88z1DjlY5hFt0RSLQCAQMJ3dfw3eI7XfqrlPSUchS4aeQZ2Zvo85Gjv/OW2OGevODZGrVYUW0ydxlnzANmZ0YUnBgaGrk2nMbNuACvq30vEPDG+HBj9VZs3fDLyIgi6KEKQORikpjwqz1z/aiqaEWKSJF7Op/KgYRQi2grwDbk9m87fF5S5tfLt9NHpzX3dd43HEdTyH+JSvCxET3G/Bm9wnzr1ACAa2nAEQTtwyazP7YI1cKJhmFrBQ/axlyG7m1i13GYoicQVBLpvaFf+zPx/WT3NvM3eG6jP9+3cJ48Y1PVkThcIjzjj7yEz8DWGVHhWSiamV1LICjt+2QirJM49d+1P/NnsmJyaY2hPQKyimUVUzNjcbLxKxFuuAMoprmUeMS2v8bntT4xHBbsqTAwCUVQoj3NnsNMnR+5GCn9f619CQCFatqloYHQExL/gTO0crm3LykPZcTrltxhsCBZqdz+Ol0ZolN99P6kNVR0R4olOTzok0GQ7LBdAF3jMnN+c6Hp9akPKBtNHpY2Mv8Mmgij7tgwM63K094Z7Hxg8FIdR/37VpWBf4bidvrMHGAlGnL7QAOulA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966006)(36840700001)(36860700001)(2616005)(8676002)(36756003)(8936002)(478600001)(110136005)(54906003)(83380400001)(1076003)(6666004)(82310400003)(5660300002)(70586007)(2906002)(70206006)(4326008)(356005)(316002)(426003)(86362001)(336012)(186003)(7636003)(6636002)(82740400003)(47076005)(36906005)(26005)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:08:27.1696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b50715-5417-45d6-7883-08d926a9d283
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change
any logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c                       | 2 +-
 drivers/vfio/pci/vfio_pci_core.c                         | 2 +-
 drivers/vfio/pci/{vfio_pci_private.h => vfio_pci_core.h} | 6 +++---
 drivers/vfio/pci/vfio_pci_igd.c                          | 2 +-
 drivers/vfio/pci/vfio_pci_intrs.c                        | 2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                         | 2 +-
 drivers/vfio/pci/vfio_pci_zdev.c                         | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)
 rename drivers/vfio/pci/{vfio_pci_private.h => vfio_pci_core.h} (98%)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 70e28efbc51f..0bc269c0b03f 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -26,7 +26,7 @@
 #include <linux/vfio.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 /* Fake capability ID for standard config space */
 #define PCI_CAP_ID_BASIC	0
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b87fefc475c7..dc99a546ffe5 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,7 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_core.h
similarity index 98%
rename from drivers/vfio/pci/vfio_pci_private.h
rename to drivers/vfio/pci/vfio_pci_core.h
index ae83c2eada3a..b73abba881e9 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -15,8 +15,8 @@
 #include <linux/uuid.h>
 #include <linux/notifier.h>
 
-#ifndef VFIO_PCI_PRIVATE_H
-#define VFIO_PCI_PRIVATE_H
+#ifndef VFIO_PCI_CORE_H
+#define VFIO_PCI_CORE_H
 
 #define VFIO_PCI_OFFSET_SHIFT   40
 
@@ -205,4 +205,4 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 }
 #endif
 
-#endif /* VFIO_PCI_PRIVATE_H */
+#endif /* VFIO_PCI_CORE_H */
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 228df565e9bc..214b6d629b21 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -15,7 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 #define OPREGION_SIGNATURE	"IntelGraphicsMem"
 #define OPREGION_SIZE		(8 * 1024)
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 869dce5f134d..df1e8c8c274c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -20,7 +20,7 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 /*
  * INTx
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a0b5fc8e46f4..667e82726e75 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,7 +17,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 #ifdef __LITTLE_ENDIAN
 #define vfio_ioread64	ioread64
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 7b011b62c766..ecae0c3d95a0 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -19,7 +19,7 @@
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 /*
  * Add the Base PCI Function information to the device info region.
-- 
2.21.0

