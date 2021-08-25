Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A5E3F7662
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241463AbhHYNxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:53:06 -0400
Received: from mail-mw2nam12on2056.outbound.protection.outlook.com ([40.107.244.56]:60161
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240294AbhHYNxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:53:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOAHRqpAbh/WwBaOUki0Ln6FiSdHTDSfGSNQP6By1VSmMat9YNR+MVn6zNB912qQauqn4Gy24GI9VPHmN7yZAMgFLwuCqhBeyWpNQwLQGa6qAK0zp/ZSLLEvokhmVBIYKLkf4u/VBYjMtdfWG8A4oTTRDUueFRLIqj8hBswEdbaRqFqO0AiyacOezRyT3tUlK3g2AQFKow5KCJlVJa7331XWTBVEho2zpHMLfhorrRVIEQsC2PSBL9dr3yT8amT/CJXd8QwJVYbzojwhNOgDijAOmVc0fKGi+86ZcbwtLT1VvZ0yTPy8x4zGMJm2Xl7V+eU7Bt6wk7Lm/r/YuMwB9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avPJWx9gy4zVxC1qWS4sqVAT0xbrd6qNQq/ja6mJt34=;
 b=OwLdgaGpnRjf9XVqgix+0XmGXOYL6mXm1DmkNquPL8iOmO16H8LqW1rNWlQvi5H2RrP15b6SHB7rzwzsGqxdk1b9EjiTUGVEje8fHywlcFOl9/eCaHsmvYgKnxk2lq96WKXEwn8RUjVD8WV9QLKP2nBOmTp+PI9/Y2Bx+tpftFbSMYEhk/tRicJeJuaybcnz5GLacZKGqAtb2sXdIImEnHuFF3Lofj/w+Y/98dC915/ird6/Hw04up6TRkIDg4mvFIEL1MlvLiOTKjRAOWtA7k1jfDi8Yfc2wIqn9Yzm1BaUsyIN6zHeef44JRburN42F3WN0kr+K93j1ZAvRFdiuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avPJWx9gy4zVxC1qWS4sqVAT0xbrd6qNQq/ja6mJt34=;
 b=g1cw1H33wmOz37m/krmq7gFR3lPHLm+Ml9X0DY09Or8wH4SPoUINosjgKXcXCmYUJbZXpwh9G06Gc7Pab+UxwmUNtB2IkvgyN4NamVWw+4c4vNgIvVywbD5+xj5mBEpQ7Y7ZBRSTAaXV6YRHa5909KI1wwwXiXLTOAq66ONLliTTHw3JgBrA4PLxwFHpvMBsLcUks0/HfHhbIWBi5dWm9f53GcoG7TG27RoKa8kX7J4qKuXgxo3oa8xktHZvPShOoiIFs4xKRjafz26v4mUoEU7tSMJbJH8FtQ/gS9dfkCauhhYwCF9Whc+ZJgnNXbzTkrdvCllB+7ITy5uCj1xhvA==
Received: from MW4PR03CA0356.namprd03.prod.outlook.com (2603:10b6:303:dc::31)
 by MN2PR12MB2976.namprd12.prod.outlook.com (2603:10b6:208:c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 25 Aug
 2021 13:52:07 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::56) by MW4PR03CA0356.outlook.office365.com
 (2603:10b6:303:dc::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:07 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 06:52:05 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:02 -0700
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
Subject: [PATCH V4 02/13] vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
Date:   Wed, 25 Aug 2021 16:51:28 +0300
Message-ID: <20210825135139.79034-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b589d2c-5228-4c16-90b4-08d967cf870f
X-MS-TrafficTypeDiagnostic: MN2PR12MB2976:
X-Microsoft-Antispam-PRVS: <MN2PR12MB2976883AB757BB628FD46460C3C69@MN2PR12MB2976.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zhooTGu4cw6FS7mMwC6fMYk4XH1AsXvp1zF6dKzSOwftaXTIesXZ5Y7zSYeV29fTeHO0/2IG5FtozB/h6dWVAeo4Np2HqrJD0x21Tvb//+OsIJEWKBv2AcQHbh32Sa0ROtdFlf+UycL+bX29fXxo5cQVus7LODaGyt7nkA3uyaAdiida5ay1v6IoqP5kqApc/qZZQMCBLYlUAUqLyxfCsCnt3yts6IYwD1theWbE02vuRil5CXXFz0Rc2DoVlvo6qoSQh1qfTNgROW2xmi4qCDXmDF/R2Lz0FiHFwkcqodIL/CulhHW/7cqUxF8mbuQfIZrJbi696DQfCdSkgBR3PI3nSmHZNHFTaYZdPnJegz4gGhvRA0/Mg3L2/qgE3oK0WMRfXHIZZAgEisJ82fkhfzhqq+Mur7eHI+T4Na5XAZGcm5m9s8wDhsS4a5h+KGMqUKSUEfG1aBojmFBXn2SQUwoHodRPPpuM/ZKpbxP0AKYzXryHa/XOpCalEvb/a+drLmCu+4dVuYR81L0Qozt7P8n+OzPOyHE9bx3WUl/EuGIDWgrLNP+TTLAxHLZC0LLuolTtEhqJWtwh9a460wGOwPQb+hfs+WMQycBuVDzlUtsbw948mZQAr2wXCa9qUBLpynhEYvmIng3B306buG/M+U9peCTqYyFP11CXGMUtUdxsxp2NzCReV3nTk7ABjGPfIobwIX2n5IzpkLt+GvU3BEVzzW4U8Jf/bgst8Jw6t84=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(36840700001)(46966006)(316002)(36756003)(36860700001)(6666004)(478600001)(7696005)(2906002)(107886003)(47076005)(82740400003)(4326008)(7636003)(70586007)(70206006)(110136005)(54906003)(186003)(8676002)(2616005)(8936002)(7416002)(336012)(426003)(5660300002)(83380400001)(1076003)(356005)(86362001)(26005)(82310400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:07.0361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b589d2c-5228-4c16-90b4-08d967cf870f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2976
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

