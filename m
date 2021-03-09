Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067643320BA
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhCIIeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:34:50 -0500
Received: from mail-bn8nam11on2069.outbound.protection.outlook.com ([40.107.236.69]:42879
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230134AbhCIIeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:34:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhUkMXaPWFJ/aZE1BhDRC4eDuA5haklIyMTwj5oDH9ctHi+bBDTyVBth2SOiykcqaWt6f7noyRHTZ1mL4cvUdXKgtq8Gdo/IA9DggA6eEaNJP7ZaWjKrYxM+hthvPm8rn8G0IkVivjXeNYXPDRV82qfFM/StC9juIU7138DruVcWw+qsIPRNHAovFsdQsPVV0IZuZeHoT51KwfdN63XZgAuPuHW4NgM9UZZjVxmYldSs7NbUJRIkma//76dKEzn7hsuoAXfIvzyuweTgr/3Okk5mpPb7v3jh8u4BGgiwhkav6/We/GtTUpJgROjXTdBAFR9lpAsr+6arvle8uHFZ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5LYrJahpjqSwVw1fv3zp9zwi0fj1XXWGqQlvpTGALo=;
 b=YgHuQDSndnCEPA9CUs0z3VOfqfIhJO+N3QTYdTvDi0lWOWHFehNqOhe18/5ERdZpFxjdfabQE/VlB3A+hKHxyZdfqN7ruMBzbYL4wiVjldySrw4deaE1s3PM98yu1mmFeQXDosoVEFMqAwjjgDH1GJTy9CfmxcHtDySvgrzPooryDB8fszB1ho6g1cmXBn1XHwmyAyT3zB6UXKU7spebDwW5Itf2ngtK73yQjtiJxFsZzYJ0aPY+o312r7fHCcu+a9PQj66G4K5XQte++hIiNfu8JV/DrXgGszMTgRElQABS70qcpSBoBQmzViS3eOnsclVSBaxhDp+2H39slrHvOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5LYrJahpjqSwVw1fv3zp9zwi0fj1XXWGqQlvpTGALo=;
 b=RG4ormKCQvVqrWNuw7r3Qv09Vt6UuM0zFsTD/qmfi2MIkt3juEm0SXJNvzfdQek17GpJ+EFTm8kSrWFG/f1oHBZ9ZsfXlr88zj/b0YrthjdBG73D94Dvdzgvuj+ehfIa+k87T2tDbYowH8+Rs7NpegY/zuEYZm2Q6Mns9t+6Tcj4v5wLC7MUbUYh9uHPmURn8UNV67LPxf51Q4meBfitdWmQrHTshiye3uPIk+IfQMWtst8QEaT0CsedNDpMDaZF3FlnfXWLishk+LlADbGW/DEjKpiAftd9uQ/MHVslssa9meyMsFjhbrUCbrpYEmv74G3oY9WpAm3Iqjt9J6Ur3Q==
Received: from DS7PR03CA0183.namprd03.prod.outlook.com (2603:10b6:5:3b6::8) by
 DM5PR12MB1642.namprd12.prod.outlook.com (2603:10b6:4:7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.19; Tue, 9 Mar 2021 08:34:17 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::e1) by DS7PR03CA0183.outlook.office365.com
 (2603:10b6:5:3b6::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:34:16 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:34:15 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:10 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <mjrosato@linux.ibm.com>, <aik@ozlabs.ru>, <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 2/9] vfio-pci: rename vfio_pci_private.h to vfio_pci_core.h
Date:   Tue, 9 Mar 2021 08:33:50 +0000
Message-ID: <20210309083357.65467-3-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309083357.65467-1-mgurtovoy@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74cf09a9-430f-4aa8-964e-08d8e2d62065
X-MS-TrafficTypeDiagnostic: DM5PR12MB1642:
X-Microsoft-Antispam-PRVS: <DM5PR12MB16423400E760E18F417CAE64DE929@DM5PR12MB1642.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FI189oxNfwx3dsgtdOQeiQ7gorOuSpVm0vJZS5G6zw6iYe9eu6AHMcpK9VEsQ2hLVuR6ngdlkf3iUXutHrcuqNDKQp7oK45h/mm48Qc/a3jfRJb0mk1up1lY5JWDvwEB6/IARoXdTcJp36mxmXLSpy7wSNH40CIxEPYTb8tdRap6G1p5VmkrHIZbCnr21cltM9zScOAUkqtcmc2NMBT2XiNMYqbzIvg5UhkC2aCIQ2jFym7ZMHazt72aleEe+OwG/Leha6LLzjKMiaZ8FJEZ5IcUFBBaqe1OP45aAD7M446h5j+7Te/jxkxYpmf0SVhqEDARODBvprrWEJbmLafyvt1KAqelfjIOJJBRcPrxMBZBqTAGK/FiC/Za9qk9MYZhHT5vxzlCPgb0qLeit1Go38vVZWjinDOVIh34VX+vb7v5hm6kbyVv1+aPmpYJtO9QuWpv2U/jz6QPzwtiRNKngFWTy5fKkxXmhHiKx7McPo2EwR51gylP7ZexvcM7DOaFn1W7zinrzmNf+XxlPeXy2qunzx3vjfMD4TFzNHED2oOnOeFekeWT8/K8vnY4zFOPZHMo1u8tUm97vTEBsLgxXWdEi/Xn+5P0PnxWj4vxW9TuU+Yz7AfJab5QyIeAWcPCh29WmizUnWLAzMWkRJ7V2SyAFRThnn1NXzXqpuoFEcP7ZWUdJ9IqqA2T9oO/2QYm
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(36840700001)(46966006)(2616005)(107886003)(36756003)(5660300002)(82310400003)(186003)(4326008)(70206006)(70586007)(47076005)(8936002)(2906002)(7636003)(83380400001)(8676002)(316002)(478600001)(336012)(110136005)(356005)(86362001)(6666004)(26005)(36860700001)(54906003)(34020700004)(1076003)(82740400003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:34:16.6213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74cf09a9-430f-4aa8-964e-08d8e2d62065
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1642
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
 drivers/vfio/pci/vfio_pci_nvlink2.c                      | 2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                         | 2 +-
 drivers/vfio/pci/vfio_pci_zdev.c                         | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)
 rename drivers/vfio/pci/{vfio_pci_private.h => vfio_pci_core.h} (98%)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index a402adee8a21..5e9d24992207 100644
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
index 65e7e6b44578..bd587db04625 100644
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
index 9cd1882a05af..b9ac7132b84a 100644
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
 
@@ -225,4 +225,4 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 }
 #endif
 
-#endif /* VFIO_PCI_PRIVATE_H */
+#endif /* VFIO_PCI_CORE_H */
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 53d97f459252..0c599cd33d01 100644
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
diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index 9adcf6a8f888..326a704c4527 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -19,7 +19,7 @@
 #include <linux/sched/mm.h>
 #include <linux/mmu_context.h>
 #include <asm/kvm_ppc.h>
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
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
index 229685634031..3e91d49fa3f0 100644
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
2.25.4

