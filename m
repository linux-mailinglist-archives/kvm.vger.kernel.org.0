Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0E439A560
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhFCQKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:36 -0400
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:46017
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230097AbhFCQKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALZVoyZ1UFIHA5TBZlqL2NAfEDy0rBednpH+vDeWXXLLx0MjL6GwQ4rOseUAZCo2YYyQPQM+Ifm31ePbT0iDX82xjjLzcrhpPw9RzdJMBVoNX+xLrRZKseCewlxRXe/REhg4vzTVqmDqYxyEFkT1ZINT733ReGyzDPCqwRy+suxa9YFssbldChxUZRsnGF4esvB6OsC9iSylRrz3nnC/mdR0P+XRWfPgJqKhY/Ji//Ouv1I97VCXYdIh0x01hyYlDKd3k0bGUlXDhW6d2kK3UzgQwHrGVrx+8BVecj4zeXMyW0aE9l0dLEK2yaeJ0aElNtq9mv7BLAPLWgg5cu9Rwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tdlcuXhKsuG5a+WszNVrHfdRSZ3W1LraCtS7l+xOHo=;
 b=MPuJlOon2GIwl8+NIDjEFEv97GVq3WxuWbUmqXNoV5nINXFnTCythLcm1mtHRc9eFrjXvgVOVhtZi7OgFQtutcPU4rr3pHvl0auZFbKNmHbbS622E6KHg3uuUIKiv8KCRhvtloHiR9yKuVfspCwYJS4NLY3HQnhOmhHk64T9/OemnTM5qv8KMr4pUFTGsUWTo9xjCUZHuFcQvOZdRk0vodqgNxUgniR6VwxqCLAteq+duIcnHxXT7XG6GTXcIdsc0weUTCufr+nXogJJCAtD5BqfWB9bmrRY+4XV5RgneWmuST4PjHa25Iqq/q4DrGB8CjyxLhmOgM7H94cMExeDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tdlcuXhKsuG5a+WszNVrHfdRSZ3W1LraCtS7l+xOHo=;
 b=ugUySHkg3jWUsVpdiWEzXieYeKxz8266ZZWPEOl/1lk7Zy1+L2izYRvgsqGyDm7tUq2LVeafFnXsshDk6bThFF0SqlSZoGhuuarJV8P0nIEED7n+rwwRZy5xvbL119hFYqh6UD2oTMgesH8fSQ4eVgHamLSBA9UKdIx8KVfO777iuye+Hexolsmk2gmueQP8mPKQTi00Wd5GJYMck6AV9qEaCTbvoIDop2B/yhefUzFaPcdRYzOQeQ6O91IzQiEOCvJxz/cA9StP4k07+0sG+vkh0up0z+5pmFJFl8l5g+6n4AwlKxYVbbrlbKzx4LJSp1wM/ivkThs6lJWrEe2Mow==
Received: from BN9PR03CA0192.namprd03.prod.outlook.com (2603:10b6:408:f9::17)
 by BY5PR12MB3873.namprd12.prod.outlook.com (2603:10b6:a03:1a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Thu, 3 Jun
 2021 16:08:48 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::68) by BN9PR03CA0192.outlook.office365.com
 (2603:10b6:408:f9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:08:47 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 09:08:46 -0700
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:41 +0000
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
Subject: [PATCH 06/11] vfio-pci: introduce vfio_pci.c
Date:   Thu, 3 Jun 2021 19:08:04 +0300
Message-ID: <20210603160809.15845-7-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e66eef2-632e-4293-b0f2-08d926a9dec6
X-MS-TrafficTypeDiagnostic: BY5PR12MB3873:
X-Microsoft-Antispam-PRVS: <BY5PR12MB38734083D69A9B3977794DF5DE3C9@BY5PR12MB3873.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pw/F8OcZvz5nv8WjWtS25pKW8zIdv3+mCgkvS0vhDsTEUJ5xRV1DY391WmrxWVCAACz0syqFUj6xp4g2BOaKi2shclcAJhLE69zv7t6ah6xlQ5Btf2Iqk840LffPXl576Cjf9qhEzURxjq7jyCMGSB05lJ0tU8aHK9wSHc0x4+T71cCdsmWF8FxCsqtktNCak7A34ndfxAjVOP1ZV31LrsTNVhuu1b1A2gHAe/pAlemXzfQXLGErV1PTuJQKrr4dd4J6zrpUG3v7/0YyE4owsXKxuHksV7wbZVNNGklDmzUxfRCN0l7/jrEKYq1WmDeoJiMoQXIjuKrjOEhAh66swVdXCW+VARmgY6qwq24P4naPi3KlDKGFxE587dqUVPkY6J5vnqreWY9bG6uXr/6lFzKo5xrVNo9aRFBY4CYhPJakKbkSQSBP7PLELqbM9aQ1mKiOEMM1cBEaNHQh7WyDLotyf8Pj2u0wHmy/atg/9ikB3SjBLdLPxHauEYcvrW5feaKWhXj8cCq6zUpJ9vbWbE0Hg7Stc1lv6ZvQquBFr/qdnXhzOwIszsAqRdwCLcVCPBK5exxLCVVsNVaUpp80B1l5kCzR1PjhtT+Vs9Q5RUhOy9/izgQJXh+xHeZccVlLgTp7VGtyjLdUEAiSjz90wvfInXN7ML9kYwoQ/Dx8j3Y=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966006)(36840700001)(6636002)(26005)(426003)(70586007)(2906002)(4326008)(107886003)(36756003)(36860700001)(8676002)(186003)(83380400001)(8936002)(86362001)(1076003)(47076005)(82310400003)(110136005)(2616005)(478600001)(7636003)(6666004)(30864003)(356005)(82740400003)(5660300002)(54906003)(70206006)(336012)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:08:47.5719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e66eef2-632e-4293-b0f2-08d926a9dec6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3873
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the vfio_pci driver into two logical parts, the 'struct pci_driver'
(vfio_pci.c) and a library of code (vfio_pci_core.c) that helps creating
a VFIO device on top of a PCI device.

As before vfio_pci.ko continues to present the same interface under
sysfs and this change should have no functional impact.

vfio_pci_core.c exposes an interface that is similar to a typical
Linux subsystem (and in the future it will become a separate module), in
that a pci_driver doing probe() can setup a number of details and then
register and create the VFIO char device.

This is a preparation for allowing another module to provide the
pci_driver and allow that module to customize how VFIO is setup, inject
its own operations, and easily extend vendor specific functionality.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Makefile        |   2 +-
 drivers/vfio/pci/vfio_pci.c      | 227 ++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c | 234 +++++--------------------------
 drivers/vfio/pci/vfio_pci_core.h |  22 +++
 4 files changed, 286 insertions(+), 199 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci.c

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 66a40488e967..8aa517b4b671 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-y := vfio_pci.o vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
 
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
new file mode 100644
index 000000000000..23a21ecbc674
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, Mellanox Technologies, Ltd.  All rights reserved.
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
+static const struct vfio_device_ops vfio_pci_ops = {
+	.name		= "vfio-pci",
+	.open		= vfio_pci_core_open,
+	.release	= vfio_pci_core_release,
+	.ioctl		= vfio_pci_core_ioctl,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+	.reflck_attach	= vfio_pci_core_reflck_attach,
+};
+
+static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct vfio_pci_core_device *vdev;
+	int ret;
+
+	if (vfio_pci_is_denylisted(pdev))
+		return -EINVAL;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	ret = vfio_pci_core_register_device(vdev, pdev, &vfio_pci_ops);
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	kfree(vdev);
+	return ret;
+}
+
+static void vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(vdev);
+	kfree(vdev);
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
+	vfio_pci_core_cleanup();
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
+	ret = vfio_pci_core_init();
+	if (ret)
+		return ret;
+
+	/* Register and scan for devices */
+	ret = pci_register_driver(&vfio_pci_driver);
+	if (ret)
+		goto out;
+
+	vfio_pci_fill_ids();
+
+	if (disable_denylist)
+		pr_warn("device denylist disabled.\n");
+
+	return 0;
+
+out:
+	vfio_pci_core_cleanup();
+	return ret;
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
index 61cd785c80e8..12d5392c78cc 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -8,8 +8,6 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/device.h>
 #include <linux/eventfd.h>
 #include <linux/file.h>
@@ -29,14 +27,6 @@
 
 #include "vfio_pci_core.h"
 
-#define DRIVER_VERSION  "0.2"
-#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
-#define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
-
-static char ids[1024] __initdata;
-module_param_string(ids, ids, sizeof(ids), 0);
-MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
-
 static bool nointxmask;
 module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(nointxmask,
@@ -53,16 +43,6 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
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
@@ -72,44 +52,6 @@ static inline bool vfio_vga_disabled(void)
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
@@ -495,8 +437,6 @@ static void vfio_pci_disable(struct vfio_pci_core_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
 
-static struct pci_driver vfio_pci_driver;
-
 static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *physfn = pci_physfn(vdev->pdev);
@@ -509,7 +449,7 @@ static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vde
 	if (!pf_dev)
 		return NULL;
 
-	if (pci_dev_driver(physfn) != &vfio_pci_driver) {
+	if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(pf_dev);
 		return NULL;
 	}
@@ -532,7 +472,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int va
 	vfio_device_put(&pf_vdev->vdev);
 }
 
-static void vfio_pci_core_release(struct vfio_device *core_vdev)
+void vfio_pci_core_release(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -555,7 +495,7 @@ static void vfio_pci_core_release(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
-static int vfio_pci_core_open(struct vfio_device *core_vdev)
+int vfio_pci_core_open(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -762,8 +702,8 @@ struct vfio_devices {
 	int max_index;
 };
 
-static long vfio_pci_core_ioctl(struct vfio_device *core_vdev,
-			   unsigned int cmd, unsigned long arg)
+long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+		unsigned long arg)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1393,8 +1333,8 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
-			     size_t count, loff_t *ppos)
+ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
+		size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1405,8 +1345,8 @@ static ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *bu
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
-			      size_t count, loff_t *ppos)
+ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
+		size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1611,7 +1551,7 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_fault,
 };
 
-static int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
+int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1682,7 +1622,7 @@ static int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_stru
 	return 0;
 }
 
-static void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
+void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1798,7 +1738,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
+int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1852,12 +1792,14 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 {
 	struct vfio_reflck **preflck = data;
 	struct vfio_device *device;
+	struct vfio_pci_core_device *vdev;
 
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return 0;
 
-	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	if (pci_dev_driver(pdev) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return 0;
 	}
@@ -1873,7 +1815,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
-static int vfio_pci_core_reflck_attach(struct vfio_device *core_vdev)
+int vfio_pci_core_reflck_attach(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1887,19 +1829,6 @@ static int vfio_pci_core_reflck_attach(struct vfio_device *core_vdev)
 	return PTR_ERR_OR_ZERO(core_vdev->reflck);
 }
 
-static const struct vfio_device_ops vfio_pci_ops = {
-	.name		= "vfio-pci",
-	.open		= vfio_pci_core_open,
-	.release	= vfio_pci_core_release,
-	.ioctl		= vfio_pci_core_ioctl,
-	.read		= vfio_pci_core_read,
-	.write		= vfio_pci_core_write,
-	.mmap		= vfio_pci_core_mmap,
-	.request	= vfio_pci_core_request,
-	.match		= vfio_pci_core_match,
-	.reflck_attach	= vfio_pci_core_reflck_attach,
-};
-
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
 {
@@ -1914,12 +1843,12 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 		pci_info(vdev->pdev, "Captured SR-IOV VF %s driver_override\n",
 			 pci_name(pdev));
 		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
-						  vfio_pci_ops.name);
+						  vdev->vdev.ops->name);
 	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
 		   pdev->is_virtfn && physfn == vdev->pdev) {
 		struct pci_driver *drv = pci_dev_driver(pdev);
 
-		if (drv && drv != &vfio_pci_driver)
+		if (drv && drv != pci_dev_driver(vdev->pdev))
 			pci_warn(vdev->pdev,
 				 "VF %s bound to driver %s while PF bound to vfio-pci\n",
 				 pci_name(pdev), drv->name);
@@ -1990,15 +1919,13 @@ static void vfio_pci_vga_uninit(struct vfio_pci_core_device *vdev)
 					      VGA_RSRC_LEGACY_MEM);
 }
 
-static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
+		struct pci_dev *pdev,
+		const struct vfio_device_ops *vfio_pci_ops)
 {
-	struct vfio_pci_core_device *vdev;
 	struct iommu_group *group;
 	int ret;
 
-	if (vfio_pci_is_denylisted(pdev))
-		return -EINVAL;
-
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
@@ -2019,12 +1946,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!group)
 		return -EINVAL;
 
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev) {
-		ret = -ENOMEM;
-		goto out_group_put;
-	}
-
 	vdev->pdev = pdev;
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
@@ -2036,9 +1957,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 
-	ret = vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops);
+	ret = vfio_init_group_dev(&vdev->vdev, &pdev->dev, vfio_pci_ops);
 	if (ret)
-		goto out_free;
+		goto out_group_put;
 	ret = vfio_pci_vf_init(vdev);
 	if (ret)
 		goto out_uninit;
@@ -2075,17 +1996,15 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	vfio_pci_vf_uninit(vdev);
 out_uninit:
 	vfio_uninit_group_dev(&vdev->vdev);
-out_free:
 	kfree(vdev->pm_save);
-	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, &pdev->dev);
 	return ret;
 }
 
-static void vfio_pci_remove(struct pci_dev *pdev)
+void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
-	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+	struct pci_dev *pdev = vdev->pdev;
 
 	pci_disable_sriov(pdev);
 
@@ -2103,7 +2022,6 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	mutex_destroy(&vdev->ioeventfds_lock);
 	kfree(vdev->region);
 	kfree(vdev->pm_save);
-	kfree(vdev);
 }
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
@@ -2130,16 +2048,13 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
 	struct vfio_device *device;
 	int ret = 0;
 
 	might_sleep();
 
-	if (!enable_sriov)
-		return -ENOENT;
-
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return -ENODEV;
@@ -2154,19 +2069,10 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	return ret < 0 ? ret : nr_virtfn;
 }
 
-static const struct pci_error_handlers vfio_err_handlers = {
+const struct pci_error_handlers vfio_pci_core_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
 
-static struct pci_driver vfio_pci_driver = {
-	.name			= "vfio-pci",
-	.id_table		= NULL, /* only dynamic ids */
-	.probe			= vfio_pci_probe,
-	.remove			= vfio_pci_remove,
-	.sriov_configure	= vfio_pci_sriov_configure,
-	.err_handler		= &vfio_err_handlers,
-};
-
 static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_devices *devs = data;
@@ -2180,12 +2086,12 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 	if (!device)
 		return -EINVAL;
 
-	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	if (pci_dev_driver(pdev) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
 
-	vdev = container_of(device, struct vfio_pci_core_device, vdev);
 
 	/* Fault if the device is not unused */
 	if (device->refcnt) {
@@ -2210,12 +2116,12 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
 	if (!device)
 		return -EINVAL;
 
-	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	if (pci_dev_driver(pdev) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
 
-	vdev = container_of(device, struct vfio_pci_core_device, vdev);
 
 	/*
 	 * Locking multiple devices is prone to deadlock, runaway and
@@ -2305,83 +2211,15 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev)
 	kfree(devs.devices);
 }
 
-static void __exit vfio_pci_cleanup(void)
+/* This will become the __exit function of vfio_pci_core.ko */
+void vfio_pci_core_cleanup(void)
 {
-	pci_unregister_driver(&vfio_pci_driver);
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(void)
+/* This will become the __init function of vfio_pci_core.ko */
+int __init vfio_pci_core_init(void)
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
 	/* Allocate shared config space permission data used by all devices */
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
-
-module_init(vfio_pci_init);
-module_exit(vfio_pci_cleanup);
-
-MODULE_VERSION(DRIVER_VERSION);
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index cb24d229df66..245862d5d6e4 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -206,4 +206,26 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 }
 #endif
 
+/* Will be exported for vfio pci drivers usage */
+void vfio_pci_core_cleanup(void);
+int vfio_pci_core_init(void);
+void vfio_pci_core_release(struct vfio_device *core_vdev);
+int vfio_pci_core_open(struct vfio_device *core_vdev);
+int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
+		struct pci_dev *pdev,
+		const struct vfio_device_ops *vfio_pci_ops);
+void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
+int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
+extern const struct pci_error_handlers vfio_pci_core_err_handlers;
+long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+		unsigned long arg);
+ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
+		size_t count, loff_t *ppos);
+ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
+		size_t count, loff_t *ppos);
+int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
+void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
+int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
+int vfio_pci_core_reflck_attach(struct vfio_device *core_vdev);
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.21.0

