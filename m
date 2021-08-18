Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC833F07BF
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239904AbhHRPRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:17:33 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:58811
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239765AbhHRPRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:17:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2JnnJ8lXn/dgqW7CWIXl0OzW1y4+nk0qdLdQRieoyzPAUzLSnPyEFQdYQqnCTAniGy6yQ+WGeIyVf2r5D0HI+/qXPP9w6l5fwRYpGkk2BpiebDQHhvRJlZ0vyjaLpwheZeDH2ThW88RhW8v26tZc3R8PP5GpMl4Yat2veh+uGstjyQ6wgcRb3MNkTKqq7PhXOoDPjcHsEOJH1z1TBC43NAQdESQBXW986rIYIIN6siuRmhToNpZt7rN/VG6XqPYSWMEnqhF2WbXyn93PA/76Lopvcg5MI3FmdMS2wYFvBtKshiK6JtsTbPBbSaQ535jU95/WWSEc9u0NAxsoThw8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avPJWx9gy4zVxC1qWS4sqVAT0xbrd6qNQq/ja6mJt34=;
 b=Zsh3nYUScv6POR/t9gpo0GtpsdF64Fh+tqrjp0d0DKZgpZKy1rQ7KH3YI4WLB2QSQFlqkaJmoJzp052s3/Ycs8PReeVJoaXEe/gTxSx1NYH/sIa6r7xBK8ZX6z304BJeYwELaNoQvWrvwIh4+wyqB23sWi9GJSBXmfKhY+wEFZV+ZJXt2biGsmZ8tCVxb2q+yfF8UE9dITGO0zMrc2CzlEZE//lJPYJi86jJF4t4lfiOXPn7szP3TL1hKJj9ZWcvQK3tvbNKyQnmcHVmomWbPS0RzSnxu7/6i1DsvvoMZXBX0Pa+w5Lp3VQJ52SdktmrJUGhNwOfc/6hLKcJ9cO1QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avPJWx9gy4zVxC1qWS4sqVAT0xbrd6qNQq/ja6mJt34=;
 b=Piu+1ah1m78jxa7hF8aTjeKfFQowGpwBx1Gf7LTdDWAJJDv4qpoGEsofRFOrMBpo7hLdmIxA4x4VQOAi9peo98RQnDdbtRn0GkUzS4vowyWzbEgYgY95XjzDppTi5xrJe+9MUsgRc1ElGwja7VZM94ZeYVUZXjc5itCbyhBSGWUun/8NBdArx1xhbofRYxKs27Rgnjf5u4JClx3yXd7DvohLN1QrO8k8AhmDuojn8S6zxHxgMr7g5a/T5ImsafO/4V1LReV67eZvXJEu+gyecMG20AD3k3hSW9uB3R+7yVNDcOOvjTmXGPKMuKZcUIQzSlmD85y75/221TzdjhgCYQ==
Received: from BN6PR18CA0008.namprd18.prod.outlook.com (2603:10b6:404:121::18)
 by MN2PR12MB2992.namprd12.prod.outlook.com (2603:10b6:208:d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 15:16:55 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:121:cafe::16) by BN6PR18CA0008.outlook.office365.com
 (2603:10b6:404:121::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend
 Transport; Wed, 18 Aug 2021 15:16:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:16:54 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:16:53 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:16:49 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V2 02/12] vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
Date:   Wed, 18 Aug 2021 18:15:56 +0300
Message-ID: <20210818151606.202815-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0980e150-4cf5-415f-29bc-08d9625b36dd
X-MS-TrafficTypeDiagnostic: MN2PR12MB2992:
X-Microsoft-Antispam-PRVS: <MN2PR12MB29924D037A907A8E3D943106C3FF9@MN2PR12MB2992.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HNi0Fqxh75pHs9HHII9BFhv74aAJFYiSa2iAaHzklS4m2Ub/wCH9UOcqWLPy24vKeCOlmXtrWpK6+BAg8AhCy+niGl0X/7zMO5ZGZlZJdVuHY8KZepuDR8fYcdCW8BLpT6Mprlx8noipmvR8sv9CAHK53q0TUWeCN/oUfBYg/Y9CkylZa/LqsD52BOlWJdYVsBJcl3kg1c1GGy0AXpIw0JKLJLliRWL2Cz/sSPaWBzj+LOu+akkYv1a87gLrXR7a4o7AMOIOV0c5ReoHnaug6IMziglp0uQfyfEgpAgJVBvaqj7+8wfdoS8rLsKheqEZHJ6iViiEPus/v4ybPBNS++gSACbNziXQ3F5G1iX+SRCdNoHWuuzzs/fbU+5mTI187SHOnolQAC0nWD1nW9jYcElWW+UggWI12DOsVYBamEsXfDIn9FvNNHGkwFXHlFEopBfnNUJeIKuIDfDq38ganiMC64n8lK8UJkC9uguBaWCJ1AkUmt6tgsJKk0Uj19ZCT1HOuLElwLllo5nQCrWspPXzQ7ls5ZAAmMzus4naovY9KcLgS5Egsx1+JGNjH8b2UVPxIHItg33ftGNGx3jy0npoSmVnRhUtyn/1SMagYO8pehPdWBrwR6ghI5tyzYrVSwxRQTo8TbARhG1EBv2HpZlm0KpxKLVxgvNZplVtb3dB6azcUKU4XYFoTcicrVCes8MXDOQdXQUWiAa6unk8RiwbfNgE/RskypB/980zEzA=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(54906003)(8676002)(2616005)(6666004)(186003)(86362001)(36756003)(1076003)(4326008)(70206006)(7416002)(70586007)(2906002)(508600001)(26005)(82310400003)(110136005)(83380400001)(5660300002)(8936002)(316002)(356005)(7636003)(47076005)(336012)(107886003)(426003)(36860700001)(7696005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:16:54.9976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0980e150-4cf5-415f-29bc-08d9625b36dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2992
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change any
logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
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
index a4f44ea52fa3..2a5dca0823c4 100644
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
index 70414b6c904d..ef26e781961d 100644
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
index aa0a29fd2762..d57c409b4033 100644
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
2.18.1

