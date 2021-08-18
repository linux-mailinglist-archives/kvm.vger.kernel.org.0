Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11543F07F2
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbhHRPSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:18:25 -0400
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:2801
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240062AbhHRPSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:18:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWGUyxX+VgCZ6Ee+my4M3YFlwStX9xDzV1SzBeEJ5meAuzRA2GphLRObObmjBXdv7btBWLjo5uW+UhV0EeuZ0nNM57JflwZrDp0DSbFxQeIvWgX2f3i65+7oxsfDgeb78qm4r8BAVkB77J3mk4YBbWAmmIf8cVYPYtW3skFD/EelIJwRZZ8cZswqzHJlIXVILPKPgxQFT25CXLkTy/tSMbLqMxoStXg+zeRdGo6ypnW1giiIlkzzSQWrYbAjADu99vgXsKfWFfhbdBdZcnmrA7xzIx/ReqHVqypv4nxMa46UbfefFLOs6iqWObnHvCuKUbILAnpXPg6ZSKJNnNQgSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6I+Q3LcnuoEk92GDFpBXGwkw1R3l2KtPbzClKvQFfn8=;
 b=jq4020SjMD5VA0u0yLnT+Ds2tqdTIYfqtVzdk+/9NgZw53mysi60c8WMJBpX8kbkMq95a9zhDIiqJtgoW6tRlgQrWS8otZeyqxKUZeZdK2W7pywbHcb0pnHRC7kGeGNqXfcyzfg6h7ixUNxAMdlNj+lxK2C8B9aqjsAkEJt7Aznz8M848x88I3DjCNhrNRPlIotDvQ0WclN9R5vhf1cDlw1v9XU6MFxy8gcxV7+GNkfUvffQdhqnyYmp92WSg6y5zJm5HYFh8UQhFpZZNesFOb4sfFBGUMmTlTV+Rp6sh7UvTCfwrJpGnUweg4w4PLkmuQCiQ16xZV3af9i7wHrAHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6I+Q3LcnuoEk92GDFpBXGwkw1R3l2KtPbzClKvQFfn8=;
 b=ahjFSbl6ZUtaBrn8sQKVjcFkziN/8lV322OzAycw6MrY/+WmfdkW/HCR2QFElu6RoIyB9fWZI4upF8kmO9EYqdNnY0ROtkVSjdVoidoJOzNEx51CQDqIvdMrubTb7dXYa5gQfOForHGJV4UvyhRaUVCxIXIbqG+1yVkVcPu+jyHKjwm9VtyxbHXnwscpHXwQaqz+KQr1lZRHxIhOs+yJNY8NfLNB5JJjRTwNDX2o8Mwo1jNS6qVPDOln2DfMd+wrgetpsHVPcHSiybNVOlU1b/04TJoeYdokNXQ08iebWp2oJm+1sSs36g/HRLiTImaAQChNepB8dL8T2V5Ef3FdPg==
Received: from BN6PR14CA0009.namprd14.prod.outlook.com (2603:10b6:404:79::19)
 by SJ0PR12MB5501.namprd12.prod.outlook.com (2603:10b6:a03:304::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Wed, 18 Aug
 2021 15:17:38 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::60) by BN6PR14CA0009.outlook.office365.com
 (2603:10b6:404:79::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:17:38 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 08:17:36 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:32 +0000
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
Subject: [PATCH V2 12/12] vfio/pci: Introduce vfio_pci_core.ko
Date:   Wed, 18 Aug 2021 18:16:06 +0300
Message-ID: <20210818151606.202815-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71d68684-ff32-4bc7-53e8-08d9625b508d
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5501:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB55015BB2611BC977B04A458AC3FF9@SJ0PR12MB5501.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rlSY1BK9OxPjG6UskPMitf3uIme9xL+9V8CjRryt4xGjciPcqx/+BIJgM/KcEaSCEfrrTqIuc/d4aWUcgo9LvlxsFMqz+OwVQcOjCIvYh0zWqQ+KF3if0Yd+JtEhT39jr8NjRjtovJ32zb7gYK/2lSdbf/pjUdNmtCG8BQyMK1Raq3nj45ys7K+ACAhENJnJVGwp2PemEPiWX5d9Nt+cteM8va9dG5n4aUfU2cKgxKR+4ipiHKTtzqmXGenodIbhCCyXrpb0nS42gr1FI2eeQnjJC4W+4ob4Q0+kuACKoWODI8MuWcTvYNWbcnX1gDWRPCDTTwRX1rq//sgq/9P1ZUe+vIe7YVfO8dbWI7zgS4IIfAGtUo87RuOqpfpwbqq+bpMN7dcsocE0rSvekVuLjwxyOFJcNg0hpn+31kwCoV9svKCxFzwyfvUyK4X5ZVN7AsZ4lBHXNiT5qDoyFWU0z44QfTPrj+CUSUURLdnCYuL760wuVcUaqp4EaGoADK7E2VFgw52NT8VJIcfoTwKZ7ZYeiiTCj+J1aBPma2uIMeRxUtXH5dTWzPG/ow6p97oZHJ4ErTsNn7iXHDgQWQ9fDYWV7ITI/TvkQK5wjKbIhQx+KG2JoGT+HUsLQYUaNvCxLTf03Q5nv+c53qHfjqLhkg7Eehy28uGVAa4dXurjzw08/F4A919hF3bUub2MRGYK5obPgapvXKDDx6Un+Q9SpaBi3ZuqyPosWpSADnWYb1U=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(36840700001)(46966006)(30864003)(4326008)(356005)(8936002)(86362001)(70206006)(7696005)(8676002)(54906003)(6666004)(110136005)(82740400003)(478600001)(7636003)(36756003)(83380400001)(107886003)(70586007)(36860700001)(2616005)(1076003)(336012)(5660300002)(47076005)(26005)(186003)(2906002)(426003)(316002)(82310400003)(7416002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:17:38.0012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d68684-ff32-4bc7-53e8-08d9625b508d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5501
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

Now that vfio_pci has been split into two source modules, one focusing on
the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
(vfio_pci_core.c), complete the split and move them into two different
kernel modules.

As before vfio_pci.ko continues to present the same interface under sysfs
and this change will have no functional impact.

Splitting into another module and adding exports allows creating new HW
specific VFIO PCI drivers that can implement device specific
functionality, such as VFIO migration interfaces or specialized device
requirements.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/Kconfig                      | 33 +++++++++-------
 drivers/vfio/pci/Makefile                     |  8 ++--
 drivers/vfio/pci/vfio_pci.c                   | 14 ++-----
 drivers/vfio/pci/vfio_pci_config.c            |  2 +-
 drivers/vfio/pci/vfio_pci_core.c              | 39 ++++++++++++++++---
 drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c             |  2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |  2 +-
 .../pci => include/linux}/vfio_pci_core.h     |  2 -
 10 files changed, 64 insertions(+), 42 deletions(-)
 rename {drivers/vfio/pci => include/linux}/vfio_pci_core.h (99%)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index afdab7d71e98..860424ccda1b 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,19 +1,28 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PCI
-	tristate "VFIO support for PCI devices"
-	depends on PCI
-	depends on MMU
+if PCI && MMU
+config VFIO_PCI_CORE
+	tristate
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
+
+config VFIO_PCI_MMAP
+	def_bool y if !S390
+
+config VFIO_PCI_INTX
+	def_bool y if !S390
+
+config VFIO_PCI
+	tristate "Generic VFIO support for any PCI device"
+	select VFIO_PCI_CORE
 	help
-	  Support for the PCI VFIO bus driver.  This is required to make
-	  use of PCI drivers using the VFIO framework.
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
@@ -22,14 +31,8 @@ config VFIO_PCI_VGA
 
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
@@ -39,5 +42,5 @@ config VFIO_PCI_IGD
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
index c52620ac5e70..24ea9f4ff0d7 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -25,7 +25,7 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
@@ -153,6 +153,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = vfio_pci_core_register_device(vdev);
 	if (ret)
 		goto out_free;
+	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_free:
@@ -248,14 +249,10 @@ static int __init vfio_pci_init(void)
 
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
 
@@ -263,17 +260,12 @@ static int __init vfio_pci_init(void)
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
index 6ecbab65a262..cd691738b91f 100644
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
@@ -25,7 +27,10 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
+
+#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC "core driver for VFIO based PCI devices"
 
 static bool nointxmask;
 static bool disable_vga;
@@ -306,6 +311,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
@@ -403,6 +409,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
 static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
 {
@@ -459,6 +466,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 	}
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
@@ -466,6 +474,7 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 	vfio_spapr_pci_eeh_open(vdev->pdev);
 	vfio_pci_vf_token_user_add(vdev, 1);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
@@ -624,6 +633,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg)
@@ -1168,6 +1178,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
 static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1211,6 +1222,7 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_read);
 
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos)
@@ -1223,6 +1235,7 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 
 	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_write);
 
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
 static int vfio_pci_zap_and_vma_lock(struct vfio_pci_core_device *vdev, bool try)
@@ -1501,6 +1514,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_mmap);
 
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
@@ -1523,6 +1537,7 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
 static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 				      bool vf_token, uuid_t *uuid)
@@ -1667,6 +1682,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 
 	return 1; /* Match */
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_match);
 
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
@@ -1774,6 +1790,7 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_init_device);
 
 void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
 {
@@ -1784,6 +1801,7 @@ void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
 	kfree(vdev->region);
 	kfree(vdev->pm_save);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
 
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 {
@@ -1851,7 +1869,6 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
 		goto out_power;
-	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_power:
@@ -1863,6 +1880,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	vfio_iommu_group_put(group, &pdev->dev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
 
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
@@ -1880,6 +1898,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 						  pci_channel_state_t state)
@@ -1925,10 +1944,12 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 
 	return ret < 0 ? ret : nr_virtfn;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
 const struct pci_error_handlers vfio_pci_core_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
+EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
 static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 			       struct vfio_pci_group_info *groups)
@@ -2117,16 +2138,22 @@ void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
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

