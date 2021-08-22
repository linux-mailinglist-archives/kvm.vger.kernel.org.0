Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F1E3F3FDB
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhHVOhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:37:47 -0400
Received: from mail-mw2nam08on2058.outbound.protection.outlook.com ([40.107.101.58]:36489
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233450AbhHVOhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:37:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JK9pt37JSU4qn6FWlpDZ9lf3VaAjZySkSTeO0+BtAABXWebaFeByGdSinsHQbC0KEPTZOeMOvjWl7BpRPBZbpd7fJ1gcXbqky8/G6ymtfsqbpZG6NrPogieInoH8wN/1bOfDOj5V5cn+gY4Ykrddp/1MeX0lSUsZVEdeLA9kaxGH6V9SbRqP2Oe30sie7BFvO9grphWGwFiZg7XzHldN/cs9gt9kP7ocWWP/GPbVc10gzmLDPOuGrjWc+quP6/ru+M4tJUWN0W+AEUX3YaK7NMf9oXJ7t3qlfMeO4/Wmvdrr6zdn5ODGBwGFheKMu04y2shSgbkoJhTkzPvi59MPIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avPJWx9gy4zVxC1qWS4sqVAT0xbrd6qNQq/ja6mJt34=;
 b=RyujcBUK2VHX8Gs2qfUCk3dIWF35QSRA8EE+rFI/gCEviZYZwOztYkRYhKFc/vQE4/VrdyvM15LZXIawoVJu3Gh3gPU0UaVky3JbJbYi33iYcuJc/RSxTJir7sb1KD/eoytYLK0X37MLerCYdSdtMfO/dznluagNiur3xOaHELeulbZbl/oEIU3zps8dAqEXJ9lL6m3oqStr+EUDUcKq5os/NhRM8Xga0wXAR+MWbFECbxmCVulbsahxxUe6fZPHHly06/Jp7Cz763BXAl9qIgsub8j4BoqNasOK8XB4FekMymL8PUUKlZNauPgOXxT+9fhF6/Vfjc9MfrqpTl79Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avPJWx9gy4zVxC1qWS4sqVAT0xbrd6qNQq/ja6mJt34=;
 b=Fiq4JoZA+UZon5NbpC0j/VkzN6sErzMoVIaXOnSAAoM0VUKaKb3UeZHBEavzOQ1Opn0Qz2SSrIgtiDJvJ+PJ+n/uMDjU89EhvGvQYkU7qMlMQppwYM6qWes5Us0sZ34hQoRITJaLlPY4ld3jKgOOCDBVJZADRK37eJLLVju4bHIy8J9AsSDO69wiKpVP6ssPxBdRw5N35KMx5iSksZrjxBf8fIKjVquirjDaeNBTsKqod8GbYXyMu6ySW0wADpz7xmYinW9Pky/F99NInL7DrBqfwBZqtQmRTBr+oq9kyHrDWxYVpqT0bH1Kq6LWoYny0e+U7hdVetAIuPOQfb2FbQ==
Received: from BN9PR03CA0640.namprd03.prod.outlook.com (2603:10b6:408:13b::15)
 by BY5PR12MB4083.namprd12.prod.outlook.com (2603:10b6:a03:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sun, 22 Aug
 2021 14:37:03 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::e0) by BN9PR03CA0640.outlook.office365.com
 (2603:10b6:408:13b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 14:37:02 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:36:59 +0000
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
Subject: [PATCH V3 02/13] vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
Date:   Sun, 22 Aug 2021 17:35:51 +0300
Message-ID: <20210822143602.153816-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dedcefc-cadd-4c21-ab37-08d9657a4f24
X-MS-TrafficTypeDiagnostic: BY5PR12MB4083:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4083FA75A1BCA7E5B90639E7C3C39@BY5PR12MB4083.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tr9TPUxoGynlNtvLg4gWFlki3m9AzhFQE5QqpgsXRwhvwJoOD5iORiKDhrW3oXok+42HQpEUzPJkg4wp+du+n1k+k54ej+5hELUJqEZlkGnvppaxnX5QTKG8174pfNP75ZcOEdAkoriGjbKj0iUrdaO7s5B4A6W4xtCp+P3QPf/Bb6R118VHedUICBaU4cZuklN4AkicIW8yDvvr0OD8gJLzPos5yxI8c321F3auYhAcLw5QxT6GFe9UyMFEhrTUbvBtyMBu0kpwAehrx/UIC65LtIywMqkzsDe+uBCd/fU+BhYl/6EOyYAMH1qOK9tNQQCmgLVR8MRLCzAquBijOYUBlrj6UofnL9NVVMfb9biEhT4HSUH2GxTcGZ81tc5GOSj1WRDfcR32JL4L22TWeIE4Y60zrvxtA8xGZydS4x6p/k/gN3nKmOPq44Zt00G0eck690SEDsHSO7o/IuBJEgT9+WxjlRF7nr1dorThdlZhl+c9A+OnxMzeeQ+Dmq7kC/DH9dBJL85/lrheqr1/yGB7ey/d7XEt9YYEg1LydozWhq9TamFqpVVLtXR72U+aso73HeCfgz+vIPQMuNfnWC8mb4G20hNrj6w+c3fYD814BcX8FA8JhFYlQeBkGn4DBX6Ks3t8b8B9vZNKnva5CiKJ9j8omuzfM7aHm7BK5H6SFtBa8Okxeohhe74+LB31s7OVFkpVrPG25QV6PNzzGGtzbIE3920DVBBQon4IUoI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(36840700001)(46966006)(47076005)(6666004)(83380400001)(107886003)(36756003)(426003)(70206006)(82310400003)(26005)(86362001)(36860700001)(316002)(7636003)(82740400003)(8936002)(2906002)(5660300002)(110136005)(54906003)(7696005)(1076003)(4326008)(356005)(36906005)(70586007)(2616005)(186003)(8676002)(478600001)(7416002)(336012)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:03.6265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dedcefc-cadd-4c21-ab37-08d9657a4f24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4083
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

