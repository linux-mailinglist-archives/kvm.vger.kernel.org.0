Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B593320BE
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhCIIey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:34:54 -0500
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:4226
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230112AbhCIIec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:34:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnNMfwMkWtACh98ATYvPowEKMEFowWkH6KXIkRIZirIUi/X9LvBvNoaUT2alUybvE6QZPauZRfoHO15WH49zmZA9Y0fYBrvACP3GhKcDVSa8pYrjX9/nYUNKtuVfQl+u3mGPmlsVuqbgIOyRIcTq6++p4TaTTZ9cEwHMlpvBgDSEV2w9oJ2ZERp6aGyvSNVHu04urctr2tfwb9+5CXyzds+hVU8NNSuKv9djfAEpyBP4AfIIMMtwGbyyQ0YNrSBPpi9cjeHNRB9XOOaqcCwArHBl01ICGnKgrQYEte2BDjODl3u+HddL1qevbQMqylAXBDbGl7MLJQzCeQuH7s0IIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpoZVBBPjW94JYFpN28otilku2QhJFNv24oeWXA07d0=;
 b=ZXF+ky1C/ZUYlYwIFDC4trndbq548yPYT0sGyEJlM2lPUlBQhZAlSW5Qz+J+nD7/xRgT4lAqliLGyb00RbOYGNjqmCdTY3kydKfks82VymlNBY7VOD3WSSrnORK820WwhZO2Fqk6SsQNTe8LBIwggva4VkA62ZuqA03V+UI3FZ7r6kBR+furGdILOksJtAcccg7chz4PwqEfzO3TKj6NGGUj0ehWCyTRf/xkrXP9s2nXKv53Gt9D9wCjqifrLkvdCG7xk8Q86YsdI/TXipsSsnCZR8ihVBTW8WnzqMz1oERycY/e7M7HMb5KSmk5qHJXCO7hONAFqD6V2JFCxldijA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpoZVBBPjW94JYFpN28otilku2QhJFNv24oeWXA07d0=;
 b=qYFbNDKjimhFo8ae7Zdwfgdwgcuqn/sQEXUbCrdFDOzifBUe5BF+Qx6sOR9yNQppYnKWxJNEOZBoHKLAZL+LBk2EHAPg/OyPv4R12PzJwsQ+jCa4Zc4xO7VCm1ZuS7v15lkUIkOFqS5I92Sov82P3zqmNQ0Bj68qhAjME9CXiHA9Yxhltz/kZpgFCYfkQbjWjOcg4qggu9sZk0vx2BnruQX1xk4dL0kD/1q2SQfCSaKJbYZMXFoG8tfi9ZZg78716x+FfAXZqQ9dajO2lwPDuPFLJ0kY6nkGDqGKXcSG8CHOKthbf0Jws1duVBiAXISAJb6HJk3kTxzCIfEuigsEIg==
Received: from DS7PR03CA0213.namprd03.prod.outlook.com (2603:10b6:5:3ba::8) by
 SN1PR12MB2432.namprd12.prod.outlook.com (2603:10b6:802:29::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Tue, 9 Mar 2021 08:34:29 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::58) by DS7PR03CA0213.outlook.office365.com
 (2603:10b6:5:3ba::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:34:28 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:34:27 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:21 +0000
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
Subject: [PATCH 4/9] vfio-pci: introduce vfio_pci_core subsystem driver
Date:   Tue, 9 Mar 2021 08:33:52 +0000
Message-ID: <20210309083357.65467-5-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309083357.65467-1-mgurtovoy@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5c22a79-0c0c-469d-9e73-08d8e2d62782
X-MS-TrafficTypeDiagnostic: SN1PR12MB2432:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2432A2411DF5FAE91ECB0199DE929@SN1PR12MB2432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4y3B+l7/fpf4qS0cTkccfws8hSmJRwN6ofBPoygyutC5VlmXnYJ4XuoU8pD1t55imdeUI2WdlsBAwtS/ao0jZIa/F7WT7sVRgd/liius+raUpvD2XFP8PbSakCvolXR77uZDJujQOysw1m4fnFjG4nyU9paOb2iXZi3+honz86xN2mFv9njbmsIDRmbsvWDgAqRbPR4pSidZog9+OIv4GBgTPIOgZxqoUlzO55WJuxQ5pJGNeKjU+ldNskZOUZA/DfzR26sSExDrcqiBH1IZR+zbIgBZeg6Ox6StWHt6prCgTCAFWnbXDTdJ/X6++Gl2fdAvlN5b6nvNkIGaDEwW7c3t6UUJuP0S69afjYM8vE4QA0qMKJ/RoQUe2DFS+ZeYwiUHBPxdefGKuPt6+NsLxOCt/WU17CXahvkNJMARI6h5oTXBQLm28A4AF6Q2AQLTcWc8s3SOqbr1gboC6AzwdbSonDcX4lhLm88OtQa42EnwvER7FEWFBbgfBNHwVM2ydLdbPyduzY/vIrQgwOUxynpEYxj+vOg/0XxP+WXhHxxSRl5hrcaoKlpWmNRcE8kYwNWAzh3u7ltvbrD/X5nhCqj5AyB9fscbmW4PqBHim2NDMVl1dGXyRh34VQ5EPryMrJWXZ8gCuvNXMi/TiMmIDLvek/zZn3NbRxM1RDbxTrMCzqNwVjvdbKzjzOTvI25b
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(46966006)(36840700001)(83380400001)(82310400003)(36860700001)(4326008)(107886003)(5660300002)(34020700004)(6666004)(86362001)(2616005)(30864003)(47076005)(1076003)(8936002)(36756003)(356005)(2906002)(54906003)(8676002)(82740400003)(336012)(70586007)(26005)(70206006)(478600001)(110136005)(426003)(186003)(316002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:34:28.5236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c22a79-0c0c-469d-9e73-08d8e2d62782
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the vfio_pci driver into two parts, the 'struct pci_driver'
(vfio_pci) and a library of code (vfio_pci_core) that helps creating a
VFIO device on top of a PCI device.

As before vfio_pci.ko continues to present the same interface under
sysfs and this change should have no functional impact.

vfio_pci_core exposes an interface that is similar to a typical
Linux subsystem, in that a pci_driver doing probe() can setup a number
of details and then create the VFIO char device.

Allowing another module to provide the pci_driver allows that module
to customize how VFIO is setup, inject its own operations, and easily
extend vendor specific functionality.

This is complementary to how VFIO's mediated devices work. Instead of
custome device lifecycle managmenet and a special bus drivers using
this approach will rely on the normal driver core lifecycle (e.g.
bind/unbind) management and this is optimized to effectively support
customization that is only making small modifications to what vfio_pci
would do normally.

This approach is also a pluggable alternative for the hard wired
CONFIG_VFIO_PCI_IGD and CONFIG_VFIO_PCI_NVLINK2 "drivers" that are
built into vfio-pci. Using this work all of that code can be moved to
a dedicated device-specific modules and cleanly split out of the
generic vfio_pci driver.

Below is an example for adding new driver to vfio pci subsystem:
	+-------------------------------------------------+
	|                                                 |
	|                     VFIO                        |
	|                                                 |
	+-------------------------------------------------+

	+-------------------------------------------------+
	|                                                 |
	|                  VFIO_PCI_CORE                  |
	|                                                 |
	+-------------------------------------------------+

	+--------------+ +---------------+ +--------------+
	|              | |               | |              |
	|  VFIO_PCI    | | MLX5_VFIO_PCI | | IGD_VFIO_PCI |
	|              | |               | |              |
	+--------------+ +---------------+ +--------------+

In this way mlx5_vfio_pci will use vfio_pci_core to register to vfio
subsystem and also use the generic PCI functionality exported from it.
Additionally it will add the needed vendor specific logic for HW
specific features such as Live Migration. Same for the igd_vfio_pci that
will add special extensions for Intel Graphics cards (GVT-d).

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig         |  22 ++-
 drivers/vfio/pci/Makefile        |  13 +-
 drivers/vfio/pci/vfio_pci.c      | 247 ++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c | 318 ++++++++-----------------------
 drivers/vfio/pci/vfio_pci_core.h | 113 +++++++----
 5 files changed, 423 insertions(+), 290 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index ac3c1dd3edef..829e90a2e5a3 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PCI
-	tristate "VFIO support for PCI devices"
+config VFIO_PCI_CORE
+	tristate "VFIO core support for PCI devices"
 	depends on VFIO && PCI && EVENTFD
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
@@ -10,9 +10,17 @@ config VFIO_PCI
 
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
@@ -21,16 +29,16 @@ config VFIO_PCI_VGA
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
 	bool "VFIO PCI extensions for Intel graphics (GVT-d)"
-	depends on VFIO_PCI && X86
+	depends on VFIO_PCI_CORE && X86
 	default y
 	help
 	  Support for Intel IGD specific extensions to enable direct
@@ -42,6 +50,6 @@ config VFIO_PCI_IGD
 
 config VFIO_PCI_NVLINK2
 	def_bool y
-	depends on VFIO_PCI && PPC_POWERNV
+	depends on VFIO_PCI_CORE && PPC_POWERNV
 	help
 	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index bbf8d7c8fc45..16e7d77d63ce 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,8 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
-vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
-vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
-vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
-
+obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
+
+vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
+vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
+
+vfio-pci-y := vfio_pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
new file mode 100644
index 000000000000..447c31f4e64e
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2020, Mellanox Technologies, Ltd.  All rights reserved.
+ *
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * Derived from original vfio:
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include "vfio_pci_core.h"
+
+#define DRIVER_VERSION  "0.2"
+#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
+
+static char ids[1024] __initdata;
+module_param_string(ids, ids, sizeof(ids), 0);
+MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
+
+static bool enable_sriov;
+#ifdef CONFIG_PCI_IOV
+module_param(enable_sriov, bool, 0644);
+MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
+#endif
+
+static bool disable_denylist;
+module_param(disable_denylist, bool, 0444);
+MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabling the denylist allows binding to devices with known errata that may lead to exploitable stability or security issues when accessed by untrusted users.");
+
+static bool vfio_pci_dev_in_denylist(struct pci_dev *pdev)
+{
+	switch (pdev->vendor) {
+	case PCI_VENDOR_ID_INTEL:
+		switch (pdev->device) {
+		case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
+		case PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF:
+		case PCI_DEVICE_ID_INTEL_QAT_C62X:
+		case PCI_DEVICE_ID_INTEL_QAT_C62X_VF:
+		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
+		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF:
+			return true;
+		default:
+			return false;
+		}
+	}
+
+	return false;
+}
+
+static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
+{
+	if (!vfio_pci_dev_in_denylist(pdev))
+		return false;
+
+	if (disable_denylist) {
+		pci_warn(pdev,
+			 "device denylist disabled - allowing device %04x:%04x.\n",
+			 pdev->vendor, pdev->device);
+		return false;
+	}
+
+	pci_warn(pdev, "%04x:%04x exists in vfio-pci device denylist, driver probing disallowed.\n",
+		 pdev->vendor, pdev->device);
+
+	return true;
+}
+
+static void vfio_pci_release(void *device_data)
+{
+	struct vfio_pci_core_device *vdev = device_data;
+
+	mutex_lock(&vdev->reflck->lock);
+	if (!(--vdev->refcnt)) {
+		vfio_pci_vf_token_user_add(vdev, -1);
+		vfio_pci_core_spapr_eeh_release(vdev);
+		vfio_pci_core_disable(vdev);
+	}
+	mutex_unlock(&vdev->reflck->lock);
+
+	module_put(THIS_MODULE);
+}
+
+static int vfio_pci_open(void *device_data)
+{
+	struct vfio_pci_core_device *vdev = device_data;
+	int ret = 0;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	mutex_lock(&vdev->reflck->lock);
+
+	if (!vdev->refcnt) {
+		ret = vfio_pci_core_enable(vdev);
+		if (ret)
+			goto error;
+
+		vfio_pci_probe_mmaps(vdev);
+		vfio_pci_core_spapr_eeh_open(vdev);
+		vfio_pci_vf_token_user_add(vdev, 1);
+	}
+	vdev->refcnt++;
+error:
+	mutex_unlock(&vdev->reflck->lock);
+	if (ret)
+		module_put(THIS_MODULE);
+	return ret;
+}
+
+static const struct vfio_device_ops vfio_pci_ops = {
+	.name		= "vfio-pci",
+	.open		= vfio_pci_open,
+	.release	= vfio_pci_release,
+	.ioctl		= vfio_pci_core_ioctl,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+};
+
+static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct vfio_pci_core_device *vdev;
+
+	if (vfio_pci_is_denylisted(pdev))
+		return -EINVAL;
+
+	vdev = vfio_create_pci_device(pdev, &vfio_pci_ops);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	return 0;
+}
+
+static void vfio_pci_remove(struct pci_dev *pdev)
+{
+	vfio_destroy_pci_device(pdev);
+}
+
+static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+{
+	might_sleep();
+
+	if (!enable_sriov)
+		return -ENOENT;
+
+	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
+}
+
+static struct pci_driver vfio_pci_driver = {
+	.name			= "vfio-pci",
+	.id_table		= NULL, /* only dynamic ids */
+	.probe			= vfio_pci_probe,
+	.remove			= vfio_pci_remove,
+	.sriov_configure	= vfio_pci_sriov_configure,
+	.err_handler		= &vfio_pci_core_err_handlers,
+};
+
+static void __exit vfio_pci_cleanup(void)
+{
+	pci_unregister_driver(&vfio_pci_driver);
+}
+
+static void __init vfio_pci_fill_ids(void)
+{
+	char *p, *id;
+	int rc;
+
+	/* no ids passed actually */
+	if (ids[0] == '\0')
+		return;
+
+	/* add ids specified in the module parameter */
+	p = ids;
+	while ((id = strsep(&p, ","))) {
+		unsigned int vendor, device, subvendor = PCI_ANY_ID,
+			subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
+		int fields;
+
+		if (!strlen(id))
+			continue;
+
+		fields = sscanf(id, "%x:%x:%x:%x:%x:%x",
+				&vendor, &device, &subvendor, &subdevice,
+				&class, &class_mask);
+
+		if (fields < 2) {
+			pr_warn("invalid id string \"%s\"\n", id);
+			continue;
+		}
+
+		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
+				   subvendor, subdevice, class, class_mask, 0);
+		if (rc)
+			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
+				vendor, device, subvendor, subdevice,
+				class, class_mask, rc);
+		else
+			pr_info("add [%04x:%04x[%04x:%04x]] class %#08x/%08x\n",
+				vendor, device, subvendor, subdevice,
+				class, class_mask);
+	}
+}
+
+static int __init vfio_pci_init(void)
+{
+	int ret;
+
+	/* Register and scan for devices */
+	ret = pci_register_driver(&vfio_pci_driver);
+	if (ret)
+		return ret;
+
+	vfio_pci_fill_ids();
+
+	if (disable_denylist)
+		pr_warn("device denylist disabled.\n");
+
+	return 0;
+}
+
+module_init(vfio_pci_init);
+module_exit(vfio_pci_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 557a03528dcd..878a3609b916 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
-#include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
@@ -32,11 +31,7 @@
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
-#define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
-
-static char ids[1024] __initdata;
-module_param_string(ids, ids, sizeof(ids), 0);
-MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
+#define DRIVER_DESC "core driver for VFIO based PCI devices"
 
 static bool nointxmask;
 module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
@@ -54,16 +49,6 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
 
-static bool enable_sriov;
-#ifdef CONFIG_PCI_IOV
-module_param(enable_sriov, bool, 0644);
-MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
-#endif
-
-static bool disable_denylist;
-module_param(disable_denylist, bool, 0444);
-MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabling the denylist allows binding to devices with known errata that may lead to exploitable stability or security issues when accessed by untrusted users.");
-
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -73,44 +58,6 @@ static inline bool vfio_vga_disabled(void)
 #endif
 }
 
-static bool vfio_pci_dev_in_denylist(struct pci_dev *pdev)
-{
-	switch (pdev->vendor) {
-	case PCI_VENDOR_ID_INTEL:
-		switch (pdev->device) {
-		case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
-		case PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF:
-		case PCI_DEVICE_ID_INTEL_QAT_C62X:
-		case PCI_DEVICE_ID_INTEL_QAT_C62X_VF:
-		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
-		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF:
-			return true;
-		default:
-			return false;
-		}
-	}
-
-	return false;
-}
-
-static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
-{
-	if (!vfio_pci_dev_in_denylist(pdev))
-		return false;
-
-	if (disable_denylist) {
-		pci_warn(pdev,
-			 "device denylist disabled - allowing device %04x:%04x.\n",
-			 pdev->vendor, pdev->device);
-		return false;
-	}
-
-	pci_warn(pdev, "%04x:%04x exists in vfio-pci device denylist, driver probing disallowed.\n",
-		 pdev->vendor, pdev->device);
-
-	return true;
-}
-
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -155,7 +102,7 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
 
-static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
+void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 {
 	struct resource *res;
 	int i;
@@ -222,6 +169,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 		vdev->bar_mmap_supported[bar] = false;
 	}
 }
+EXPORT_SYMBOL_GPL(vfio_pci_probe_mmaps);
 
 static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev);
 static void vfio_pci_disable(struct vfio_pci_core_device *vdev);
@@ -309,7 +257,24 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
-static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
+void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
+{
+	vfio_pci_disable(vdev);
+
+	mutex_lock(&vdev->igate);
+	if (vdev->err_trigger) {
+		eventfd_ctx_put(vdev->err_trigger);
+		vdev->err_trigger = NULL;
+	}
+	if (vdev->req_trigger) {
+		eventfd_ctx_put(vdev->req_trigger);
+		vdev->req_trigger = NULL;
+	}
+	mutex_unlock(&vdev->igate);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
+
+int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -407,14 +372,13 @@ static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
 		}
 	}
 
-	vfio_pci_probe_mmaps(vdev);
-
 	return 0;
 
 disable_exit:
 	vfio_pci_disable(vdev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
 static void vfio_pci_disable(struct vfio_pci_core_device *vdev)
 {
@@ -515,8 +479,6 @@ static void vfio_pci_disable(struct vfio_pci_core_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
 
-static struct pci_driver vfio_pci_driver;
-
 static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev,
 					   struct vfio_device **pf_dev)
 {
@@ -529,7 +491,7 @@ static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vde
 	if (!*pf_dev)
 		return NULL;
 
-	if (pci_dev_driver(physfn) != &vfio_pci_driver) {
+	if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(*pf_dev);
 		return NULL;
 	}
@@ -537,7 +499,7 @@ static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vde
 	return vfio_device_data(*pf_dev);
 }
 
-static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int val)
+void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int val)
 {
 	struct vfio_device *pf_dev;
 	struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev, &pf_dev);
@@ -552,60 +514,19 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int va
 
 	vfio_device_put(pf_dev);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_vf_token_user_add);
 
-static void vfio_pci_release(void *device_data)
+void vfio_pci_core_spapr_eeh_open(struct vfio_pci_core_device *vdev)
 {
-	struct vfio_pci_core_device *vdev = device_data;
-
-	mutex_lock(&vdev->reflck->lock);
-
-	if (!(--vdev->refcnt)) {
-		vfio_pci_vf_token_user_add(vdev, -1);
-		vfio_spapr_pci_eeh_release(vdev->pdev);
-		vfio_pci_disable(vdev);
-
-		mutex_lock(&vdev->igate);
-		if (vdev->err_trigger) {
-			eventfd_ctx_put(vdev->err_trigger);
-			vdev->err_trigger = NULL;
-		}
-		if (vdev->req_trigger) {
-			eventfd_ctx_put(vdev->req_trigger);
-			vdev->req_trigger = NULL;
-		}
-		mutex_unlock(&vdev->igate);
-	}
-
-	mutex_unlock(&vdev->reflck->lock);
-
-	module_put(THIS_MODULE);
+	vfio_spapr_pci_eeh_open(vdev->pdev);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_spapr_eeh_open);
 
-static int vfio_pci_open(void *device_data)
+void vfio_pci_core_spapr_eeh_release(struct vfio_pci_core_device *vpdev)
 {
-	struct vfio_pci_core_device *vdev = device_data;
-	int ret = 0;
-
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
-	mutex_lock(&vdev->reflck->lock);
-
-	if (!vdev->refcnt) {
-		ret = vfio_pci_enable(vdev);
-		if (ret)
-			goto error;
-
-		vfio_spapr_pci_eeh_open(vdev->pdev);
-		vfio_pci_vf_token_user_add(vdev, 1);
-	}
-	vdev->refcnt++;
-error:
-	mutex_unlock(&vdev->reflck->lock);
-	if (ret)
-		module_put(THIS_MODULE);
-	return ret;
+	vfio_spapr_pci_eeh_release(vpdev->pdev);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_spapr_eeh_release);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
@@ -797,8 +718,8 @@ struct vfio_devices {
 	int max_index;
 };
 
-static long vfio_pci_ioctl(void *device_data,
-			   unsigned int cmd, unsigned long arg)
+long vfio_pci_core_ioctl(void *device_data, unsigned int cmd,
+		unsigned long arg)
 {
 	struct vfio_pci_core_device *vdev = device_data;
 	unsigned long minsz;
@@ -1401,6 +1322,7 @@ static long vfio_pci_ioctl(void *device_data,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
 static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1434,23 +1356,25 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
-			     size_t count, loff_t *ppos)
+ssize_t vfio_pci_core_read(void *device_data, char __user *buf, size_t count,
+		loff_t *ppos)
 {
 	if (!count)
 		return 0;
 
 	return vfio_pci_rw(device_data, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_read);
 
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
-			      size_t count, loff_t *ppos)
+ssize_t vfio_pci_core_write(void *device_data, const char __user *buf,
+		size_t count, loff_t *ppos)
 {
 	if (!count)
 		return 0;
 
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_write);
 
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
 static int vfio_pci_zap_and_vma_lock(struct vfio_pci_core_device *vdev, bool try)
@@ -1646,7 +1570,7 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_fault,
 };
 
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+int vfio_pci_core_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1713,8 +1637,9 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_mmap);
 
-static void vfio_pci_request(void *device_data, unsigned int count)
+void vfio_pci_core_request(void *device_data, unsigned int count)
 {
 	struct vfio_pci_core_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1734,6 +1659,7 @@ static void vfio_pci_request(void *device_data, unsigned int count)
 
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
 static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 				      bool vf_token, uuid_t *uuid)
@@ -1830,7 +1756,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_match(void *device_data, char *buf)
+int vfio_pci_core_match(void *device_data, char *buf)
 {
 	struct vfio_pci_core_device *vdev = device_data;
 	bool vf_token = false;
@@ -1878,18 +1804,7 @@ static int vfio_pci_match(void *device_data, char *buf)
 
 	return 1; /* Match */
 }
-
-static const struct vfio_device_ops vfio_pci_ops = {
-	.name		= "vfio-pci",
-	.open		= vfio_pci_open,
-	.release	= vfio_pci_release,
-	.ioctl		= vfio_pci_ioctl,
-	.read		= vfio_pci_read,
-	.write		= vfio_pci_write,
-	.mmap		= vfio_pci_mmap,
-	.request	= vfio_pci_request,
-	.match		= vfio_pci_match,
-};
+EXPORT_SYMBOL_GPL(vfio_pci_core_match);
 
 static int vfio_pci_reflck_attach(struct vfio_pci_core_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
@@ -1908,12 +1823,12 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 		pci_info(vdev->pdev, "Captured SR-IOV VF %s driver_override\n",
 			 pci_name(pdev));
 		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
-						  vfio_pci_ops.name);
+						  vdev->vfio_pci_ops->name);
 	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
 		   pdev->is_virtfn && physfn == vdev->pdev) {
 		struct pci_driver *drv = pci_dev_driver(pdev);
 
-		if (drv && drv != &vfio_pci_driver)
+		if (drv && drv != pci_dev_driver(vdev->pdev))
 			pci_warn(vdev->pdev,
 				 "VF %s bound to driver %s while PF bound to vfio-pci\n",
 				 pci_name(pdev), drv->name);
@@ -1922,17 +1837,15 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 	return 0;
 }
 
-static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
+		const struct vfio_device_ops *vfio_pci_ops)
 {
 	struct vfio_pci_core_device *vdev;
 	struct iommu_group *group;
 	int ret;
 
-	if (vfio_pci_is_denylisted(pdev))
-		return -EINVAL;
-
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	/*
 	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
@@ -1944,12 +1857,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	if (pci_num_vf(pdev)) {
 		pci_warn(pdev, "Cannot bind to PF with SR-IOV enabled\n");
-		return -EBUSY;
+		return ERR_PTR(-EBUSY);
 	}
 
 	group = vfio_iommu_group_get(&pdev->dev);
 	if (!group)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
 	if (!vdev) {
@@ -1958,6 +1871,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	vdev->pdev = pdev;
+	vdev->vfio_pci_ops = vfio_pci_ops;
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
@@ -1968,7 +1882,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	ret = vfio_add_group_dev(&pdev->dev, vfio_pci_ops, vdev);
 	if (ret)
 		goto out_free;
 
@@ -2014,7 +1928,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
-	return ret;
+	return vdev;
 
 out_vf_token:
 	kfree(vdev->vf_token);
@@ -2026,10 +1940,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, &pdev->dev);
-	return ret;
+	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(vfio_create_pci_device);
 
-static void vfio_pci_remove(struct pci_dev *pdev)
+void vfio_destroy_pci_device(struct pci_dev *pdev)
 {
 	struct vfio_pci_core_device *vdev;
 
@@ -2067,9 +1982,10 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
 	}
 }
+EXPORT_SYMBOL_GPL(vfio_destroy_pci_device);
 
-static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
-						  pci_channel_state_t state)
+static pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+		pci_channel_state_t state)
 {
 	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
@@ -2096,7 +2012,7 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
 	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
@@ -2104,9 +2020,6 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 
 	might_sleep();
 
-	if (!enable_sriov)
-		return -ENOENT;
-
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return -ENODEV;
@@ -2126,19 +2039,12 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 
 	return ret < 0 ? ret : nr_virtfn;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
-static const struct pci_error_handlers vfio_err_handlers = {
-	.error_detected = vfio_pci_aer_err_detected,
-};
-
-static struct pci_driver vfio_pci_driver = {
-	.name			= "vfio-pci",
-	.id_table		= NULL, /* only dynamic ids */
-	.probe			= vfio_pci_probe,
-	.remove			= vfio_pci_remove,
-	.sriov_configure	= vfio_pci_sriov_configure,
-	.err_handler		= &vfio_err_handlers,
+const struct pci_error_handlers vfio_pci_core_err_handlers = {
+	.error_detected = vfio_pci_core_aer_err_detected,
 };
+EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
 static DEFINE_MUTEX(reflck_lock);
 
@@ -2171,13 +2077,13 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 	if (!device)
 		return 0;
 
-	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+	vdev = vfio_device_data(device);
+
+	if (pci_dev_driver(pdev) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return 0;
 	}
 
-	vdev = vfio_device_data(device);
-
 	if (vdev->reflck) {
 		vfio_pci_reflck_get(vdev->reflck);
 		*preflck = vdev->reflck;
@@ -2233,13 +2139,13 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 	if (!device)
 		return -EINVAL;
 
-	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+	vdev = vfio_device_data(device);
+
+	if (pci_dev_driver(pdev) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
 
-	vdev = vfio_device_data(device);
-
 	/* Fault if the device is not unused */
 	if (vdev->refcnt) {
 		vfio_device_put(device);
@@ -2263,13 +2169,13 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
 	if (!device)
 		return -EINVAL;
 
-	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+	vdev = vfio_device_data(device);
+
+	if (pci_dev_driver(pdev) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
 
-	vdev = vfio_device_data(device);
-
 	/*
 	 * Locking multiple devices is prone to deadlock, runaway and
 	 * unwind if we hit contention.
@@ -2358,81 +2264,19 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev)
 	kfree(devs.devices);
 }
 
-static void __exit vfio_pci_cleanup(void)
+static void __exit vfio_pci_core_cleanup(void)
 {
-	pci_unregister_driver(&vfio_pci_driver);
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(void)
+static int __init vfio_pci_core_init(void)
 {
-	char *p, *id;
-	int rc;
-
-	/* no ids passed actually */
-	if (ids[0] == '\0')
-		return;
-
-	/* add ids specified in the module parameter */
-	p = ids;
-	while ((id = strsep(&p, ","))) {
-		unsigned int vendor, device, subvendor = PCI_ANY_ID,
-			subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
-		int fields;
-
-		if (!strlen(id))
-			continue;
-
-		fields = sscanf(id, "%x:%x:%x:%x:%x:%x",
-				&vendor, &device, &subvendor, &subdevice,
-				&class, &class_mask);
-
-		if (fields < 2) {
-			pr_warn("invalid id string \"%s\"\n", id);
-			continue;
-		}
-
-		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
-				   subvendor, subdevice, class, class_mask, 0);
-		if (rc)
-			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
-				vendor, device, subvendor, subdevice,
-				class, class_mask, rc);
-		else
-			pr_info("add [%04x:%04x[%04x:%04x]] class %#08x/%08x\n",
-				vendor, device, subvendor, subdevice,
-				class, class_mask);
-	}
-}
-
-static int __init vfio_pci_init(void)
-{
-	int ret;
-
 	/* Allocate shared config space permision data used by all devices */
-	ret = vfio_pci_init_perm_bits();
-	if (ret)
-		return ret;
-
-	/* Register and scan for devices */
-	ret = pci_register_driver(&vfio_pci_driver);
-	if (ret)
-		goto out_driver;
-
-	vfio_pci_fill_ids();
-
-	if (disable_denylist)
-		pr_warn("device denylist disabled.\n");
-
-	return 0;
-
-out_driver:
-	vfio_pci_uninit_perm_bits();
-	return ret;
+	return vfio_pci_init_perm_bits();
 }
 
-module_init(vfio_pci_init);
-module_exit(vfio_pci_cleanup);
+module_init(vfio_pci_core_init);
+module_exit(vfio_pci_core_cleanup);
 
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 3964ca898984..a3517a9472bd 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -10,6 +10,7 @@
 
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/vfio.h>
 #include <linux/irqbypass.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
@@ -100,48 +101,52 @@ struct vfio_pci_mmap_vma {
 };
 
 struct vfio_pci_core_device {
-	struct pci_dev		*pdev;
-	void __iomem		*barmap[PCI_STD_NUM_BARS];
-	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
-	u8			*pci_config_map;
-	u8			*vconfig;
-	struct perm_bits	*msi_perm;
-	spinlock_t		irqlock;
-	struct mutex		igate;
-	struct vfio_pci_irq_ctx	*ctx;
-	int			num_ctx;
-	int			irq_type;
-	int			num_regions;
-	struct vfio_pci_region	*region;
-	u8			msi_qmax;
-	u8			msix_bar;
-	u16			msix_size;
-	u32			msix_offset;
-	u32			rbar[7];
-	bool			pci_2_3;
-	bool			virq_disabled;
-	bool			reset_works;
-	bool			extended_caps;
-	bool			bardirty;
-	bool			has_vga;
-	bool			needs_reset;
-	bool			nointx;
-	bool			needs_pm_restore;
-	struct pci_saved_state	*pci_saved_state;
-	struct pci_saved_state	*pm_save;
-	struct vfio_pci_reflck	*reflck;
-	int			refcnt;
-	int			ioeventfds_nr;
-	struct eventfd_ctx	*err_trigger;
-	struct eventfd_ctx	*req_trigger;
-	struct list_head	dummy_resources_list;
-	struct mutex		ioeventfds_lock;
-	struct list_head	ioeventfds_list;
+	/* below are the public fields used by vfio_pci drivers */
+	struct pci_dev			*pdev;
+	const struct vfio_device_ops	*vfio_pci_ops;
+	struct vfio_pci_reflck		*reflck;
+	int				refcnt;
+	struct vfio_pci_region		*region;
+	u8				*pci_config_map;
+	u8				*vconfig;
+
+	/* below are the private internal fields used by vfio_pci_core */
+	void __iomem			*barmap[PCI_STD_NUM_BARS];
+	bool				bar_mmap_supported[PCI_STD_NUM_BARS];
+	struct perm_bits		*msi_perm;
+	spinlock_t			irqlock;
+	struct mutex			igate;
+	struct vfio_pci_irq_ctx		*ctx;
+	int				num_ctx;
+	int				irq_type;
+	int				num_regions;
+	u8				msi_qmax;
+	u8				msix_bar;
+	u16				msix_size;
+	u32				msix_offset;
+	u32				rbar[7];
+	bool				pci_2_3;
+	bool				virq_disabled;
+	bool				reset_works;
+	bool				extended_caps;
+	bool				bardirty;
+	bool				has_vga;
+	bool				needs_reset;
+	bool				nointx;
+	bool				needs_pm_restore;
+	struct pci_saved_state		*pci_saved_state;
+	struct pci_saved_state		*pm_save;
+	int				ioeventfds_nr;
+	struct eventfd_ctx		*err_trigger;
+	struct eventfd_ctx		*req_trigger;
+	struct list_head		dummy_resources_list;
+	struct mutex			ioeventfds_lock;
+	struct list_head		ioeventfds_list;
 	struct vfio_pci_vf_token	*vf_token;
-	struct notifier_block	nb;
-	struct mutex		vma_lock;
-	struct list_head	vma_list;
-	struct rw_semaphore	memory_lock;
+	struct notifier_block		nb;
+	struct mutex			vma_lock;
+	struct list_head		vma_list;
+	struct rw_semaphore		memory_lock;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
@@ -225,4 +230,30 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 }
 #endif
 
+/* Exported functions */
+struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
+		const struct vfio_device_ops *vfio_pci_ops);
+void vfio_destroy_pci_device(struct pci_dev *pdev);
+
+long vfio_pci_core_ioctl(void *device_data, unsigned int cmd,
+		unsigned long arg);
+ssize_t vfio_pci_core_read(void *device_data, char __user *buf, size_t count,
+		loff_t *ppos);
+ssize_t vfio_pci_core_write(void *device_data, const char __user *buf,
+		size_t count, loff_t *ppos);
+int vfio_pci_core_mmap(void *device_data, struct vm_area_struct *vma);
+void vfio_pci_core_request(void *device_data, unsigned int count);
+int vfio_pci_core_match(void *device_data, char *buf);
+
+void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
+int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_spapr_eeh_open(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_spapr_eeh_release(struct vfio_pci_core_device *vdev);
+void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int val);
+void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev);
+
+int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
+
+extern const struct pci_error_handlers vfio_pci_core_err_handlers;
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.25.4

