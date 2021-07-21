Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F216D3D13E4
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhGUPhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:37:37 -0400
Received: from mail-dm6nam08on2079.outbound.protection.outlook.com ([40.107.102.79]:45280
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233994AbhGUPhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:37:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgGXNT6SQvAdzqHVrkUYgOjN4KdYtFt74wQfZytG55uqvU1KssfQLAz890SAZXpZaHKBxdSwVywRre9hjl3RyPCOC39LOmCNdwSWluY+VsXR8Gb44v5hOXC/kx1fM+xvpMq6liZROCQQkSI2oPMkXtVEAiIEs9RCeUq5oyKvuOdlq42SeqB5C6uTsu3PronSCv/kiUk5o7J+J8soN3BNBbcVaIBL4sRybWxm4hmwe/DbqQkLhLJXOQr1LCycBdP1N2cEyvnT23+Wi0SlXnhX1wn+pAforSdSTXm4Gty0F9ltNmJE86ZU1GKN6Axyu664QA4LzzCW3tm79DN3pJIuQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScvnVbH5aFpm4+rLMaeiRmg0U15ebcGKQVsrvV9fT14=;
 b=Tebie+JuXIxlluh8uIaTljRl0ueaZU7pKyXLyMo4ITB9gwyqSYbcmG/KvQRaK9ZeVME46yypjj2HPvCdvZdi7omiZS4b1e0MWYmCJuptzv7Dw2V0gHWJMauKVD36cI+SlOHkcAdHQ4+00cmGOTNSMbf70KrKPm78V3CzdTFGpKeYA1hssI5alad1kOxyJEk+ltnjPPuLPA8czhyOJ0mbbwkxMSHCzp9p9nsrsqKi+2Cf+b8H/DK5M7W6bvyWllFv4JVfDqRffdbtHPZ1hD6RAILUbb1Va5+YdcrgaIvCDZ4I9Pg4gBCgbITsdNdawoEsSS64BNWwcKALhUV+p+uT3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScvnVbH5aFpm4+rLMaeiRmg0U15ebcGKQVsrvV9fT14=;
 b=PdIFbq71kxxg9YVK1xl3p9JVMrjGoWDToO0P7RcqJQt40MguSzDXqvens4mmyXwtdhpjuhqPgsuw7mV+kcDPPqqbsJGsgi45zzwXthoXED/rKHmwFJ0fONDZKIEnuRkU24lLwVmyM7aBICitc79neNWikvka+EqICyV99tfs5Rx9nWFQYZr+gHfB5SDtM2grI8GlzDjVBldFksJfqvf8yoEo0M+1AoQutb+8WUdH+/3rqFxCxk7wFjrzzP3L1H9tWU8pVi35Z0DPUGzhpKEmWL+nKKIqQnpxBOCStd/JtM0FB7plHLk3VTK67aY4jVfi+N1aFRG1oUUGOyuqHwRXLA==
Received: from MW4PR03CA0336.namprd03.prod.outlook.com (2603:10b6:303:dc::11)
 by DM6PR12MB3113.namprd12.prod.outlook.com (2603:10b6:5:11b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 21 Jul
 2021 16:18:10 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::54) by MW4PR03CA0336.outlook.office365.com
 (2603:10b6:303:dc::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Wed, 21 Jul 2021 16:18:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:18:10 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:18:09 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:18:05 +0000
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
Subject: [PATCH 11/12] vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'
Date:   Wed, 21 Jul 2021 19:16:08 +0300
Message-ID: <20210721161609.68223-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf16230e-feb1-45cf-00bd-08d94c63221b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3113:
X-Microsoft-Antispam-PRVS: <DM6PR12MB311325ADA586D01DFB0CB0CDC3E39@DM6PR12MB3113.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: USub15KJOcsWLxDYXp4aSfiSqtnJNoLKbuLLdu5W287vRnEJSgi3nnXGlEjJ85RlIZzg6GIJ85s/zQd5q9yINQSMvBga+MbXjIsSxY9GXouckETdE4v4fCCxb27nY5UKq01nSpwGpMrl+E+tMwJIPXzkp3ZE2LES5V/bmjEo9WqGGfkmhsYSOzOXTFXzf0Rc9KlVaPk3wAgKW8YRGyOuYdezP0iC2APcnw0SlPigYdEOeIe4trtXnOt66LV1PTezdinGvCbmlnXFOQjmASwhrJnGCpfdQOnQdMz0/yDAHsNbqqHORbcftZnPtmlwYuKVjd+AoSWJ1ZpCANIkqdbhfy0Jx6yJIAgPa3dFVvy3W9VLAkagQS7QSyjGDmt1jmIFd2/o8k3jQElOSik0HvYjhKoI6Me3Ur7DKppRNBeRcuz2w8Xahb8q9fHZXS5/cN5zDr9GHG7RyAMYInOdbtD7UseRj+xpPJVyCvKrfGH1kphshM0kxflmHalJbjmFy43/P02UL791a8AeElwuv0aWsaQ2YHvcGb/nTiW1G8csf82Eo6+HZWJEFOb8G9DoEcOnYkJPnnIIVrZuuM33TUk2CQtm0ZfLTQZXw0toVXn0pUHzoqgo5jUCErzi/+lgkJ66Fjyx5DhYxZ6u+fuhWUU4wVKPC+sKdik4ARkTE+gwm4bluFPVvtURnrVvW3Lfldy4lAfITGdscajckcBbr3PKbBdaYVfMOyuo08h7DFQl1Bo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(46966006)(36840700001)(54906003)(36756003)(356005)(7636003)(47076005)(478600001)(2906002)(7416002)(316002)(2616005)(336012)(1076003)(110136005)(82740400003)(4326008)(7696005)(5660300002)(426003)(8676002)(36860700001)(36906005)(107886003)(82310400003)(186003)(8936002)(70206006)(83380400001)(26005)(70586007)(86362001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:18:10.6174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf16230e-feb1-45cf-00bd-08d94c63221b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

This results in less kconfig wordage and a simpler understanding of the
required "depends on" to create the menu structure.

The next patch increases the nesting level a lot so this is a nice
preparatory simplification.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/Kconfig                | 28 ++++++++++++++--------------
 drivers/vfio/fsl-mc/Kconfig         |  2 +-
 drivers/vfio/mdev/Kconfig           |  1 -
 drivers/vfio/pci/Kconfig            | 11 ++++++-----
 drivers/vfio/platform/Kconfig       |  6 ++++--
 drivers/vfio/platform/reset/Kconfig |  4 +---
 6 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 698ca35b3f03..6130d00252ed 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -1,12 +1,22 @@
 # SPDX-License-Identifier: GPL-2.0-only
+menuconfig VFIO
+	tristate "VFIO Non-Privileged userspace driver framework"
+	select IOMMU_API
+	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
+	help
+	  VFIO provides a framework for secure userspace device drivers.
+	  See Documentation/driver-api/vfio.rst for more details.
+
+	  If you don't know what to do here, say N.
+
+if VFIO
 config VFIO_IOMMU_TYPE1
 	tristate
-	depends on VFIO
 	default n
 
 config VFIO_IOMMU_SPAPR_TCE
 	tristate
-	depends on VFIO && SPAPR_TCE_IOMMU
+	depends on SPAPR_TCE_IOMMU
 	default VFIO
 
 config VFIO_SPAPR_EEH
@@ -16,23 +26,11 @@ config VFIO_SPAPR_EEH
 
 config VFIO_VIRQFD
 	tristate
-	depends on VFIO
 	select EVENTFD
 	default n
 
-menuconfig VFIO
-	tristate "VFIO Non-Privileged userspace driver framework"
-	select IOMMU_API
-	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
-	help
-	  VFIO provides a framework for secure userspace device drivers.
-	  See Documentation/driver-api/vfio.rst for more details.
-
-	  If you don't know what to do here, say N.
-
 config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
-	depends on VFIO
 	help
 	  VFIO is built on the ability to isolate devices using the IOMMU.
 	  Only with an IOMMU can userspace access to DMA capable devices be
@@ -49,4 +47,6 @@ source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
 source "drivers/vfio/mdev/Kconfig"
 source "drivers/vfio/fsl-mc/Kconfig"
+endif
+
 source "virt/lib/Kconfig"
diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
index 6df66813c882..597d338c5c8a 100644
--- a/drivers/vfio/fsl-mc/Kconfig
+++ b/drivers/vfio/fsl-mc/Kconfig
@@ -1,6 +1,6 @@
 config VFIO_FSL_MC
 	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
-	depends on VFIO && FSL_MC_BUS
+	depends on FSL_MC_BUS
 	select EVENTFD
 	help
 	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 763c877a1318..646dbed44eb2 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -2,7 +2,6 @@
 
 config VFIO_MDEV
 	tristate "Mediated device driver framework"
-	depends on VFIO
 	default n
 	help
 	  Provides a framework to virtualize devices.
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index d208a95a2767..afdab7d71e98 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PCI
 	tristate "VFIO support for PCI devices"
-	depends on VFIO && PCI
+	depends on PCI
 	depends on MMU
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
@@ -11,9 +11,10 @@ config VFIO_PCI
 
 	  If you don't know what to do here, say N.
 
+if VFIO_PCI
 config VFIO_PCI_VGA
 	bool "VFIO PCI support for VGA devices"
-	depends on VFIO_PCI && X86 && VGA_ARB
+	depends on X86 && VGA_ARB
 	help
 	  Support for VGA extension to VFIO PCI.  This exposes an additional
 	  region on VGA devices for accessing legacy VGA addresses used by
@@ -22,16 +23,14 @@ config VFIO_PCI_VGA
 	  If you don't know what to do here, say N.
 
 config VFIO_PCI_MMAP
-	depends on VFIO_PCI
 	def_bool y if !S390
 
 config VFIO_PCI_INTX
-	depends on VFIO_PCI
 	def_bool y if !S390
 
 config VFIO_PCI_IGD
 	bool "VFIO PCI extensions for Intel graphics (GVT-d)"
-	depends on VFIO_PCI && X86
+	depends on X86
 	default y
 	help
 	  Support for Intel IGD specific extensions to enable direct
@@ -40,3 +39,5 @@ config VFIO_PCI_IGD
 	  and LPC bridge config space.
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
+
+endif
diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index 7f78eb96a5d5..331a5920f5ab 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PLATFORM
 	tristate "VFIO support for platform devices"
-	depends on VFIO && (ARM || ARM64 || COMPILE_TEST)
+	depends on ARM || ARM64 || COMPILE_TEST
 	select VFIO_VIRQFD
 	help
 	  Support for platform devices with VFIO. This is required to make
@@ -10,9 +10,10 @@ config VFIO_PLATFORM
 
 	  If you don't know what to do here, say N.
 
+if VFIO_PLATFORM
 config VFIO_AMBA
 	tristate "VFIO support for AMBA devices"
-	depends on VFIO_PLATFORM && (ARM_AMBA || COMPILE_TEST)
+	depends on ARM_AMBA || COMPILE_TEST
 	help
 	  Support for ARM AMBA devices with VFIO. This is required to make
 	  use of ARM AMBA devices present on the system using the VFIO
@@ -21,3 +22,4 @@ config VFIO_AMBA
 	  If you don't know what to do here, say N.
 
 source "drivers/vfio/platform/reset/Kconfig"
+endif
diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
index 1edbe9ee7356..12f5f3d80387 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PLATFORM_CALXEDAXGMAC_RESET
 	tristate "VFIO support for calxeda xgmac reset"
-	depends on VFIO_PLATFORM
 	help
 	  Enables the VFIO platform driver to handle reset for Calxeda xgmac
 
@@ -9,7 +8,6 @@ config VFIO_PLATFORM_CALXEDAXGMAC_RESET
 
 config VFIO_PLATFORM_AMDXGBE_RESET
 	tristate "VFIO support for AMD XGBE reset"
-	depends on VFIO_PLATFORM
 	help
 	  Enables the VFIO platform driver to handle reset for AMD XGBE
 
@@ -17,7 +15,7 @@ config VFIO_PLATFORM_AMDXGBE_RESET
 
 config VFIO_PLATFORM_BCMFLEXRM_RESET
 	tristate "VFIO support for Broadcom FlexRM reset"
-	depends on VFIO_PLATFORM && (ARCH_BCM_IPROC || COMPILE_TEST)
+	depends on ARCH_BCM_IPROC || COMPILE_TEST
 	default ARCH_BCM_IPROC
 	help
 	  Enables the VFIO platform driver to handle reset for Broadcom FlexRM
-- 
2.18.1

