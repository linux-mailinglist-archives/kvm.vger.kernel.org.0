Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0834539A568
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFCQK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:58 -0400
Received: from mail-dm3nam07on2061.outbound.protection.outlook.com ([40.107.95.61]:64481
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230284AbhFCQK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1H6xWbGcuoDDMIYB77OgKgWkbvZNUGqneWchR+xyP+LyeFfZsXCiArg9N3h4GhImJviCBFbYxlGgaadaQTuAb2yhk9jlhZhY5Chu2a/KmLfwV6S2yUHl9YfGtAfA2a9UqUN8dumOAYxPzMqj9aWgMHjSHSeIAzqtWKE+FAPu4DPDwn/R1m/5UEm6m2/BfRZgUxV+22HkeGNa0hMWyjjMQv7/SEssvr4PVo9xnt+fgJDQURrgh50SLIYYekWHbhGCr4/22cfjUkbjUHG4wkqS9FkIfchYRzjInBlMcNDtfB17gLL9K10TbtKo+SWU/qvx9NjIepxcEcZNmjjqgsaiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyIz480FSUC4OW/wskj6QchUea2/SO/0meplgDdTlto=;
 b=VaTg81EgJAe8meGDGDNVUv3zjNaZh/Fr2oPeESQO987wciS5fwDkZ9Zov07yn5X1fjj27uzyViU5zGIwsEfdQ7ihYESps/ec3DtGiPNezfE4kOnhp9djH45fhF5//bw6sF3j57cAhRUh8eRuPjCo00NH3hAiQ0IreXCfzkB21adnd64kdAWYMqx2L17cyNb0raM66B24RqmbyM4fcDPppa8uGEr0rMz+eqL9BH3FA1MRemyFDHK634YTU4K6aeLWVpSMLfgdM68sDMTuVyECDQyKntmuotZGJpsgezCcJMm0kQgfHLregSr11jNgJCmH+cO/N//q16gI2Ze69uTjTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyIz480FSUC4OW/wskj6QchUea2/SO/0meplgDdTlto=;
 b=OJMpWTj6Ov+5vdds981jZXuaImef304PDmFaOSPrhSipNBm40l4F1dijRBork4uhLJ32L7J0iC8iB6GSGIkn4Xi/oNaCwXr6fniuo6nyiSTY/5/DZVqX7MJxmzIRDWVWW9I4p4jhY6fnJjFQB9HQx6ItMCTpXYedPgEs0nGNy0jfZN7W22Xz9S8QgSWbDGU1iLw4fQ+cb+JWJ0St6Ks4oYF8nfSurdDRlkVSwtRKmZ6eKh9JFTFFqutcio/1QbrGUE1bvY3pGZoN81fcqFwMhanZHkJ/GSlAG2j4wu3CXrTvSxjmToEkr0gZzXFmoF2j3cyxotpYLfgtAuhbXE4O8A==
Received: from BN6PR21CA0024.namprd21.prod.outlook.com (2603:10b6:404:8e::34)
 by BN6PR12MB1844.namprd12.prod.outlook.com (2603:10b6:404:fc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Thu, 3 Jun
 2021 16:09:09 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:8e:cafe::ab) by BN6PR21CA0024.outlook.office365.com
 (2603:10b6:404:8e::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.3 via Frontend
 Transport; Thu, 3 Jun 2021 16:09:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:09:09 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 09:09:07 -0700
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:09:02 +0000
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
Subject: [PATCH 10/11] vfio-pci: introduce vfio_pci_core subsystem driver
Date:   Thu, 3 Jun 2021 19:08:08 +0300
Message-ID: <20210603160809.15845-11-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c2788eb-feb3-476f-60ba-08d926a9ebb2
X-MS-TrafficTypeDiagnostic: BN6PR12MB1844:
X-Microsoft-Antispam-PRVS: <BN6PR12MB184484A0A18124EA756971CDDE3C9@BN6PR12MB1844.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Agg1b8PnBJEDoIVFn5066QZsTPGSH+0vsEhyLEKQh/3zWpOirdpWjC1NFJmyFN0ypQy0Z9B7ipkPZJdPCrHl5sfR/wEhBS7H5jaFYiFqjs+CG635+KrRvjvlVlANVjBG/7A+ir+XkyIdMILbYudqhSd31vPQJEHbJWrT+kGVM3lthhE46xuzCQPzRT4AyuoZ9ToEhC9iOIFfiHh3LtUx6I5Nc/4cH9eV1BSjAVkdqECCisR614AS/pZdxtASpLsgPI7djuKBJvhYgWrntT/vFq59hL9vkrk5Urx1dG6nCwLurHO32/9MVKmoLg9aV45EKpxKdpsgCxk0YaSs96zDfykLF38WIchmBHLfskQNnUIfj4lCMcV0Xyp4Zjl7mjSY6jDI2WBIUFvRCRelAMZoVQUpyAiEvlCsN373gz5vIyBWJNqExURu8jZFLgAnO69ndApIh9MI2TarWGMsgdcrdz2EvQzydpHLkAr0pRTx0KRzWxtkBdkG9WR7DOR0GzqZp70s4ge7D4diIGQFqbYNHGuxygrCS8TbIG4hcZBQovwc0B1acA1fpXHNbAcg+j6HqhkDLqtsLkwiCIwMw8Tjm8Br2stbAR4EKMlVvkCrwePgMwC1ZeW5kl5HCmPDabHG4kdEwfhNhRdm/1otidoYYA3d2hIZStr/3Hakt7ZvLwc=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36756003)(1076003)(30864003)(5660300002)(4326008)(7636003)(6636002)(356005)(86362001)(8936002)(8676002)(107886003)(498600001)(70586007)(47076005)(186003)(36860700001)(2616005)(2906002)(70206006)(26005)(82310400003)(426003)(336012)(83380400001)(110136005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:09:09.3401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2788eb-feb3-476f-60ba-08d926a9ebb2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1844
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that vfio_pci has been split into two source modules, one focusing
on the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
(vfio_pci_core.c), complete the split and move them into two different
modules.

As before vfio_pci.ko continues to present the same interface under
sysfs and this change will have no functional impact.

Below is an example for adding new driver that will use vfio pci
subsystem:

	+---------------------------------------------------+
	|                                                   |
	|                     VFIO                          |
	|                                                   |
	+---------------------------------------------------+

	+---------------------------------------------------+
	|                                                   |
	|                  VFIO_PCI_CORE                    |
	|                                                   |
	+---------------------------------------------------+

	+----------+ +---------------+ +--------------------+
	|          | |               | |                    |
	| VFIO_PCI | | MLX5_VFIO_PCI | | HISILICON_VFIO_PCI |
	|          | |               | |                    |
	+----------+ +---------------+ +--------------------+

Splitting into another module and adding exports allows creating new HW
specific vfio_pci drivers that can implement device specific
functionality, such as VFIO migration interfaces or specialized device
requirements.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig                      | 18 ++++++---
 drivers/vfio/pci/Makefile                     | 11 +++--
 drivers/vfio/pci/vfio_pci.c                   | 14 ++-----
 drivers/vfio/pci/vfio_pci_config.c            |  2 +-
 drivers/vfio/pci/vfio_pci_core.c              | 40 ++++++++++++++++---
 drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c             |  2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |  2 +-
 .../pci => include/linux}/vfio_pci_core.h     | 10 ++---
 10 files changed, 66 insertions(+), 37 deletions(-)
 rename {drivers/vfio/pci => include/linux}/vfio_pci_core.h (96%)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 5e2e1b9a9fd3..384d06661f30 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PCI
-	tristate "VFIO support for PCI devices"
+config VFIO_PCI_CORE
+	tristate "VFIO core support for PCI devices"
 	depends on VFIO && PCI && EVENTFD
 	depends on MMU
 	select VFIO_VIRQFD
@@ -11,9 +11,17 @@ config VFIO_PCI
 
 	  If you don't know what to do here, say N.
 
+config VFIO_PCI
+	tristate "VFIO support for PCI devices"
+	depends on VFIO_PCI_CORE
+	help
+	  This provides a generic PCI support using the VFIO framework.
+
+	  If you don't know what to do here, say N.
+
 config VFIO_PCI_VGA
 	bool "VFIO PCI support for VGA devices"
-	depends on VFIO_PCI && X86 && VGA_ARB
+	depends on VFIO_PCI_CORE && X86 && VGA_ARB
 	help
 	  Support for VGA extension to VFIO PCI.  This exposes an additional
 	  region on VGA devices for accessing legacy VGA addresses used by
@@ -22,11 +30,11 @@ config VFIO_PCI_VGA
 	  If you don't know what to do here, say N.
 
 config VFIO_PCI_MMAP
-	depends on VFIO_PCI
+	depends on VFIO_PCI_CORE
 	def_bool y if !S390
 
 config VFIO_PCI_INTX
-	depends on VFIO_PCI
+	depends on VFIO_PCI_CORE
 	def_bool y if !S390
 
 config VFIO_PCI_IGD
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 8aa517b4b671..ddba4759cde7 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,7 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci.o vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
-vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
-vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
-
+obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
+
+vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
+
+vfio-pci-y := vfio_pci.o
+vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 9beb4b841945..56870a6540d7 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -25,7 +25,7 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
@@ -141,6 +141,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto out_free;
 
+	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_free:
@@ -185,7 +186,6 @@ static struct pci_driver vfio_pci_driver = {
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_core_cleanup();
 }
 
 static void __init vfio_pci_fill_ids(void)
@@ -233,14 +233,10 @@ static int __init vfio_pci_init(void)
 {
 	int ret;
 
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
 
@@ -248,10 +244,6 @@ static int __init vfio_pci_init(void)
 		pr_warn("device denylist disabled.\n");
 
 	return 0;
-
-out:
-	vfio_pci_core_cleanup();
-	return ret;
 }
 
 module_init(vfio_pci_init);
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
index 39a3f18bbc08..a1ce79160f6f 100644
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
 module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
@@ -316,6 +322,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
@@ -415,6 +422,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
 static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
 {
@@ -473,6 +481,7 @@ void vfio_pci_core_release(struct vfio_device *core_vdev)
 	}
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_release);
 
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
@@ -480,6 +489,7 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 	vfio_spapr_pci_eeh_open(vdev->pdev);
 	vfio_pci_vf_token_user_add(vdev, 1);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 
 int vfio_pci_core_open(struct vfio_device *core_vdev)
 {
@@ -497,6 +507,7 @@ int vfio_pci_core_open(struct vfio_device *core_vdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_open);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
@@ -681,6 +692,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
 struct vfio_devices {
 	struct vfio_pci_core_device **devices;
@@ -1287,6 +1299,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
 static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1330,6 +1343,7 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_read);
 
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos)
@@ -1342,6 +1356,7 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 
 	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_write);
 
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
 static int vfio_pci_zap_and_vma_lock(struct vfio_pci_core_device *vdev, bool try)
@@ -1607,6 +1622,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_mmap);
 
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
@@ -1629,6 +1645,7 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
 static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 				      bool vf_token, uuid_t *uuid)
@@ -1773,6 +1790,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 
 	return 1; /* Match */
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_match);
 
 static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 {
@@ -1814,6 +1832,7 @@ int vfio_pci_core_reflck_attach(struct vfio_device *core_vdev)
 
 	return PTR_ERR_OR_ZERO(core_vdev->reflck);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_reflck_attach);
 
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
@@ -1972,7 +1991,6 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
 	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
 		goto out_power;
-	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_power:
@@ -1987,6 +2005,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
 	vfio_iommu_group_put(group, &pdev->dev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
 
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
@@ -2009,6 +2028,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	kfree(vdev->region);
 	kfree(vdev->pm_save);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 						  pci_channel_state_t state)
@@ -2054,10 +2074,12 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 
 	return ret < 0 ? ret : nr_virtfn;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
 const struct pci_error_handlers vfio_pci_core_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
+EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
 static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 {
@@ -2197,15 +2219,21 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev)
 	kfree(devs.devices);
 }
 
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
index 2295eaac4bc9..f04774cd3a7f 100644
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
similarity index 96%
rename from drivers/vfio/pci/vfio_pci_core.h
rename to include/linux/vfio_pci_core.h
index 406e934e23b2..5a48c3c552b1 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -171,10 +171,10 @@ extern void vfio_pci_uninit_perm_bits(void);
 extern int vfio_config_init(struct vfio_pci_core_device *vdev);
 extern void vfio_config_free(struct vfio_pci_core_device *vdev);
 
-extern int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
-					unsigned int type, unsigned int subtype,
-					const struct vfio_pci_regops *ops,
-					size_t size, u32 flags, void *data);
+int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
+		unsigned int type, unsigned int subtype,
+		const struct vfio_pci_regops *ops,
+		size_t size, u32 flags, void *data);
 
 extern int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
 				    pci_power_t state);
@@ -207,8 +207,6 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 #endif
 
 /* Will be exported for vfio pci drivers usage */
-void vfio_pci_core_cleanup(void);
-int vfio_pci_core_init(void);
 void vfio_pci_core_release(struct vfio_device *core_vdev);
 int vfio_pci_core_open(struct vfio_device *core_vdev);
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
-- 
2.21.0

