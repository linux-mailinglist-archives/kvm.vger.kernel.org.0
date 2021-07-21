Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0EC3D13E9
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhGUPhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:37:45 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:54881
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229726AbhGUPhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:37:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiFhB6stDZijCtUubuhRNGoaRL19h9V6xX2b7daHkCQQ9l5u1D4+59iSxD9WhaJVC4YeGzjSd14CBeaoI4c/MnXZ64DLSUMaN745ZoFtxRi5hzOUxvxnm8W8JB2wgZ6qcAe1xtxlQb0SPca11gIg1jQwYHtYuXR1gQQ+9RdxIbxIIvZAHFe4Po7K3uOiX0JIjxhqafTVHeztPyyG17UKN7jF9jboI4Je3U9CDn5X8i11SLDqjcbtZIXVqXDPGVRzgF9E+clfRQ5oH7dkQWbb1Su/J521XYaU/Jw7fSt93rotQlxKY6yBP28BRAjOy6GFrAnlq30KiTxEHQKTsF85IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8ZlsYrqdXr/iTEFamlYXIh1/D1tH+YmtqkEtGfurFc=;
 b=AEda/EmqkuB7hzgrD2+vrCjZbbuYwDX+SOeWZuDdKW4L0pcHVF025WD644g95CBcuFYohW9UmoA/LuhoLLF1ju1Pbl1viURaJRDQzKPOWv6jIPj3s/P/ON1sGxLmAnxGb/I6j8TqklGjXqYcAmNUc67Hthppov5NPA4/vNk/tA1ewg2/3o16dGI3mT1UFnAOk0Xj3fRwZvgW7TdU67NCgxurWy/sYz63ZUH2wwXq6aTsHBQ3YTU0cTaBR6H4HahJCYDf6sR8/+xXCsgwzLFz1+YGGshqVZ9ADcn/MGTujeZ2dTy02Fne/NJFiwiSUZFIghxJGQhPXIHbcDHi2dLygw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=markovi.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8ZlsYrqdXr/iTEFamlYXIh1/D1tH+YmtqkEtGfurFc=;
 b=LN2yh7U0Ou3lFJ8bP2m/oCyXI/Jw81Cc1Zvrd/zhOaVXlHl7plkoqLJUQ0ez171ATcfKf4L8uVZFr4J4HMKXPvFg4siR8E36baHEdqa9UeRsGz50rdXnMs4bIEqJvbat4w4tajmR00iIHQ0cx0qNPKHC4t4LWGcVaFy1iaB8cYgpdSAZWlWwDnl/492Ia/vFPtb9vv69C5sCY0AHvg72vK9qbvGx8lMau+lFucg50mFj+SkIgL+5Y+oAAk54z90Gnx5rKiPgZJyOju1qqnJLtk7RwB1GZcs7EJyr3FPm4s2OQCu64ElAJyRSLQIIWj1+Loej7wzUFVr8RjY9iWKxug==
Received: from MW4PR04CA0060.namprd04.prod.outlook.com (2603:10b6:303:6a::35)
 by BN6PR1201MB0036.namprd12.prod.outlook.com (2603:10b6:405:4e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 16:18:18 +0000
Received: from CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::81) by MW4PR04CA0060.outlook.office365.com
 (2603:10b6:303:6a::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend
 Transport; Wed, 21 Jul 2021 16:18:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; markovi.net; dkim=none (message not signed)
 header.d=none;markovi.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT039.mail.protection.outlook.com (10.13.174.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:18:16 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:18:14 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:18:13 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:18:09 +0000
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
Subject: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Date:   Wed, 21 Jul 2021 19:16:09 +0300
Message-ID: <20210721161609.68223-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0339a154-040a-49de-0478-08d94c6325da
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0036:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0036B8904AF1363C2692CADFC3E39@BN6PR1201MB0036.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: THduhGpQYk4GSIm6c6HyOKahIZGl0yjsHXRyf88j6dKIhCKyAyFw6LKVNQ5dKJaN8cDDckouGzr+uEApiIWLCMFc2eAIo2ZxahvJ31/V7z8Un70FdjJRRd/fYCVeReuxJ8+ErT+sVlE0i3emIxiin2gzVVcTdBjr2wZf2AoZXShqIYFBfXywl5H16HLuW6Q/WGCpiay551dQ5LQPhwCOfgZaF2cjdxRQbVkd9O7oi1hfJcxY9iuuHR3+67czyN9KfqKqg9D9n8MalCOIHiKFCR14Lp7lrXiDLsZPjmvITqtxCiX2X6I/9IXhQvXmypZNI5NO+faiOMpc6BhkTm9hZu6X4CpR19yrN9j8/cGlAgSp5Mgo4n3VfA+tFgPPUSDiwuFyTchilkd2t0kw4c5QUp7OrHvJN0BI/kYfPp8Pb3sR83qo2ZDAGBbZheXudEXprP1UQivOM3M6FW5VI55kZgCpnm56tyMhdcu5/86aUnQNzEzv8yZeTYfPoKEpiQsX2v5/NM/nQliLM6KyAkXsIP+c6lOYdLC/fYy4TC9jXQXQNNVzDkjVbxxiniHxW5nhRY7+yyChSeCkj9pT3rBptSO7teL/ESNcVnxZEfqKb6cIJcrKDPVx1JqIwS1JfTo2VK7o+T6VqorUGg1nYmZjPyNlCLxPwb1FTE7rxNPRHB+4G19PvX5kPWViZptkoC4lU8BSees687y/IA8BXYm9swz6IPqUB+BY6t0yt7me/Y4=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(46966006)(36840700001)(82310400003)(47076005)(7636003)(83380400001)(316002)(36756003)(356005)(82740400003)(86362001)(478600001)(36860700001)(36906005)(5660300002)(336012)(426003)(8936002)(110136005)(8676002)(2906002)(70206006)(107886003)(7696005)(4326008)(70586007)(7416002)(26005)(1076003)(30864003)(186003)(2616005)(54906003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:18:16.8764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0339a154-040a-49de-0478-08d94c6325da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0036
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

Now that vfio_pci has been split into two source modules, one focusing
on the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
(vfio_pci_core.c), complete the split and move them into two different
kernel modules.

As before vfio_pci.ko continues to present the same interface under
sysfs and this change will have no functional impact.

Splitting into another module and adding exports allows creating new HW
specific VFIO PCI drivers that can implement device specific
functionality, such as VFIO migration interfaces or specialized device
requirements.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/Kconfig                      | 30 ++++++++------
 drivers/vfio/pci/Makefile                     |  8 ++--
 drivers/vfio/pci/vfio_pci.c                   | 14 ++-----
 drivers/vfio/pci/vfio_pci_config.c            |  2 +-
 drivers/vfio/pci/vfio_pci_core.c              | 41 ++++++++++++++++---
 drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c             |  2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |  2 +-
 .../pci => include/linux}/vfio_pci_core.h     |  2 -
 10 files changed, 66 insertions(+), 39 deletions(-)
 rename {drivers/vfio/pci => include/linux}/vfio_pci_core.h (99%)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index afdab7d71e98..18898ae49919 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,19 +1,31 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PCI
+config VFIO_PCI_CORE
 	tristate "VFIO support for PCI devices"
 	depends on PCI
 	depends on MMU
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
 	help
-	  Support for the PCI VFIO bus driver.  This is required to make
-	  use of PCI drivers using the VFIO framework.
+	  Support for using PCI devices with VFIO.
+
+if VFIO_PCI_CORE
+config VFIO_PCI_MMAP
+	def_bool y if !S390
+
+config VFIO_PCI_INTX
+	def_bool y if !S390
+
+config VFIO_PCI
+	tristate "Generic VFIO support for any PCI device"
+	help
+	  Support for the generic PCI VFIO bus driver which can connect any
+	  PCI device to the VFIO framework.
 
 	  If you don't know what to do here, say N.
 
 if VFIO_PCI
 config VFIO_PCI_VGA
-	bool "VFIO PCI support for VGA devices"
+	bool "Generic VFIO PCI support for VGA devices"
 	depends on X86 && VGA_ARB
 	help
 	  Support for VGA extension to VFIO PCI.  This exposes an additional
@@ -22,14 +34,8 @@ config VFIO_PCI_VGA
 
 	  If you don't know what to do here, say N.
 
-config VFIO_PCI_MMAP
-	def_bool y if !S390
-
-config VFIO_PCI_INTX
-	def_bool y if !S390
-
 config VFIO_PCI_IGD
-	bool "VFIO PCI extensions for Intel graphics (GVT-d)"
+	bool "Generic VFIO PCI extensions for Intel graphics (GVT-d)"
 	depends on X86
 	default y
 	help
@@ -39,5 +45,5 @@ config VFIO_PCI_IGD
 	  and LPC bridge config space.
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
-
+endif
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 8aa517b4b671..349d68d242b4 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,7 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci.o vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
-vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
-vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
+vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
+obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
+vfio-pci-y := vfio_pci.o
+vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7a43edbe8618..41b4742aef20 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -25,7 +25,7 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
@@ -154,6 +154,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = vfio_pci_core_register_device(vdev);
 	if (ret)
 		goto out_free;
+	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_free:
@@ -249,14 +250,10 @@ static int __init vfio_pci_init(void)
 
 	vfio_pci_core_set_params(nointxmask, is_disable_vga, disable_idle_d3);
 
-	ret = vfio_pci_core_init();
-	if (ret)
-		return ret;
-
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
 	if (ret)
-		goto out;
+		return ret;
 
 	vfio_pci_fill_ids();
 
@@ -264,17 +261,12 @@ static int __init vfio_pci_init(void)
 		pr_warn("device denylist disabled.\n");
 
 	return 0;
-
-out:
-	vfio_pci_core_cleanup();
-	return ret;
 }
 module_init(vfio_pci_init);
 
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_core_cleanup();
 }
 module_exit(vfio_pci_cleanup);
 
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 1f034f768a27..6e58b4bf7a60 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -26,7 +26,7 @@
 #include <linux/vfio.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 /* Fake capability ID for standard config space */
 #define PCI_CAP_ID_BASIC	0
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index e65b154f17c3..3a5b6d889a69 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -8,6 +8,8 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/eventfd.h>
 #include <linux/file.h>
@@ -25,7 +27,11 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
+
+#define DRIVER_VERSION  "0.2"
+#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC "core driver for VFIO based PCI devices"
 
 static bool nointxmask;
 static bool disable_vga;
@@ -306,6 +312,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
@@ -405,6 +412,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
 static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
 {
@@ -461,6 +469,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 	}
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
@@ -468,6 +477,7 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 	vfio_spapr_pci_eeh_open(vdev->pdev);
 	vfio_pci_vf_token_user_add(vdev, 1);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
@@ -626,6 +636,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg)
@@ -1170,6 +1181,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
 static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1213,6 +1225,7 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_read);
 
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos)
@@ -1225,6 +1238,7 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 
 	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_write);
 
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
 static int vfio_pci_zap_and_vma_lock(struct vfio_pci_core_device *vdev, bool try)
@@ -1503,6 +1517,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_mmap);
 
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
@@ -1525,6 +1540,7 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
 static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 				      bool vf_token, uuid_t *uuid)
@@ -1669,6 +1685,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 
 	return 1; /* Match */
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_match);
 
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
@@ -1776,6 +1793,7 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_init_device);
 
 void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
 {
@@ -1786,6 +1804,7 @@ void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
 	kfree(vdev->region);
 	kfree(vdev->pm_save);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
 
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 {
@@ -1847,7 +1866,6 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
 		goto out_power;
-	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_power:
@@ -1859,6 +1877,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	vfio_iommu_group_put(group, &pdev->dev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
 
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
@@ -1876,6 +1895,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 						  pci_channel_state_t state)
@@ -1921,10 +1941,12 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 
 	return ret < 0 ? ret : nr_virtfn;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
 const struct pci_error_handlers vfio_pci_core_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
+EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
 static int vfio_pci_check_all_devices_bound(struct pci_dev *pdev, void *data)
 {
@@ -2094,16 +2116,23 @@ void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
 	disable_vga = is_disable_vga;
 	disable_idle_d3 = is_disable_idle_d3;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_set_params);
 
-/* This will become the __exit function of vfio_pci_core.ko */
-void vfio_pci_core_cleanup(void)
+static void vfio_pci_core_cleanup(void)
 {
 	vfio_pci_uninit_perm_bits();
 }
 
-/* This will become the __init function of vfio_pci_core.ko */
-int __init vfio_pci_core_init(void)
+static int __init vfio_pci_core_init(void)
 {
 	/* Allocate shared config space permission data used by all devices */
 	return vfio_pci_init_perm_bits();
 }
+
+module_init(vfio_pci_core_init);
+module_exit(vfio_pci_core_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index a324ca7e6b5a..7ca4109bba48 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -15,7 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 #define OPREGION_SIGNATURE	"IntelGraphicsMem"
 #define OPREGION_SIZE		(8 * 1024)
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 945ddbdf4d11..6069a11fb51a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -20,7 +20,7 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 /*
  * INTx
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 8fff4689dd44..57d3b2cbbd8e 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,7 +17,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 #ifdef __LITTLE_ENDIAN
 #define vfio_ioread64	ioread64
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 2ffbdc11f089..fe4def9ffffb 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -19,7 +19,7 @@
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 /*
  * Add the Base PCI Function information to the device info region.
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/include/linux/vfio_pci_core.h
similarity index 99%
rename from drivers/vfio/pci/vfio_pci_core.h
rename to include/linux/vfio_pci_core.h
index 7a2da1e14de3..ef9a44b6cf5d 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -207,8 +207,6 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 #endif
 
 /* Will be exported for vfio pci drivers usage */
-void vfio_pci_core_cleanup(void);
-int vfio_pci_core_init(void);
 void vfio_pci_core_set_params(bool nointxmask, bool is_disable_vga,
 			      bool is_disable_idle_d3);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
-- 
2.18.1

