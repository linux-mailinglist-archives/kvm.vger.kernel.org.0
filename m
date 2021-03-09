Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6863320CD
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhCIIf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:35:27 -0500
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:50147
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230526AbhCIIfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:35:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQ9u2fZMXQJhnkkPpgtfoDaWbT52KEeLWiFuKAqliLkTQJe35z5t6FftTQTjW8/wi3SNgJfYKZK2JHR0tW0rAbCVr9t05qdyCSXdtprILSOSZvsx8eAwHyC6zwO/zE1dDC7kw41osNd1QH6ofGSXvHu2wxdp5A2KLl2EdOJqeA8lMx66nMcbNfsbD2yRmxltudXoV9PL8OmUQjc1zBVv8PWi4p/o67dScrtNmRRJfY2qNZjz8YhRIbHp86mAeujZLBUJX2V/tCzim97tiKKZKEQ4VlX6Ko989P2l8yQyd3bTQrjRVrsBEMDQ3vd3REwclrsN5DYxtqsceAoEFu5skw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yh7Sv51obkkSmM/XL2iq8xuUwpYOztQTlt6iapqpfBU=;
 b=N2s6OxM+JzXZPzOrZ24F5E1M5DLNwGQilb/F6tWvXLLMmCvWGTcDjayDaW02m1axehscJz2HrpCc+RvyAV8dhgM2RWcqT2m4bqazoaoz7P6SqWI7gTdE422IF8ZeDdqEVCwAtxr4Qx9Nuvopq3Kpe7GnF1iLRXSCviKqQp501tFpQLeHgUqgMRWOJUfQhdF1ohGNnE+SFlXGFIVkHaxffL6Bc93+wOpq++SlB+qLCUgAG+zYG6vmiNwJ20Ucf0lUks/bcj9V59UZlEdc/B9hnpJeHi6+tMLdBpxmknnxBxceoxU3TObVe1wzAe0aER/hSyXrq2kVThcGYnvUnBWKIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yh7Sv51obkkSmM/XL2iq8xuUwpYOztQTlt6iapqpfBU=;
 b=a6tx8UjZpSWkGXNYJvfwzZWLAAVljygILvotg0oZpFx2InCIEyPml+5PmZP5MJ7hXCKhfoiRN04CKsFDdm9JqCfoj0D6v9Y748ewbSweIUKjSDnCYeALh/R1gtzR78D1NYtdb7hmwbRvd4B6HGUWIt+PGwbYzAJUfDXRGY/Wj5NG3i9OA/Wea5puxIF5o/uWjkJLt/f1mzVBGl2rTmdqxeLqiRQ8ItqTtyk1PVofdKtEeJZUkAu9J1Wpl/0wCnd88SXs223qnjjdYvVggCOjITt5mXxA07V+Fvzy860ILK305niyZsJKFiRNsQRMRLw3+eArdlEmBZfm97/pEom1Jg==
Received: from DM6PR13CA0025.namprd13.prod.outlook.com (2603:10b6:5:bc::38) by
 BN6PR12MB1202.namprd12.prod.outlook.com (2603:10b6:404:1c::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.19; Tue, 9 Mar 2021 08:34:58 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::b7) by DM6PR13CA0025.outlook.office365.com
 (2603:10b6:5:bc::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.22 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:34:57 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:34:56 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:51 +0000
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
Subject: [PATCH 9/9] vfio/pci: export igd support into vendor vfio_pci driver
Date:   Tue, 9 Mar 2021 08:33:57 +0000
Message-ID: <20210309083357.65467-10-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309083357.65467-1-mgurtovoy@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c9a7aaf-db9d-4dfa-f2c9-08d8e2d638f1
X-MS-TrafficTypeDiagnostic: BN6PR12MB1202:
X-Microsoft-Antispam-PRVS: <BN6PR12MB12029B11644F7532115C5703DE929@BN6PR12MB1202.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:268;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zZp4SJecrXzWxkAwqtDtaGMKNxPYbimvSnS5V/tomYaNp4DB67nVFuiL0emcTdXym+4BlRHwAtQdfv4+Ksm7i8NRYOzivU7USoNr/u7wH348nXK4B/gmmTMzoFaWR07+YI5QIsuFAoGDn7SEOZARcvsbVwiDAlkFAl2+OzErgQDDSUB2GkHVCUaaCrBXgjYaWx03MQpjoPxNvrP7oIOR+D0/647N4U2NOAGcaox3Gxwmzg3KEGb9SahPMzZaZBUWwCvRWSuU1qTyDwsQ84ppj8OpnvvIuE9wpFT8lktWGKMOYwGW10wFrYbkWKtMR90lEewze1ay4YDKHFwJKmCYz1HP/impMpNT4p8uyX9rbSVXrOsgj/0Ka7FUtqIyEk1SZMEKF/WW1NrDhGgR8BPO7pWtBoQYSskmSD+ybbAPWduFEjDfa4XmpxvvUuwzfx9XSjCLRdM91B+Q5LOt0zZfYtQzez2CKRpqe9er9Md7rQ4KDtuxzsvYYPBSa22CJGlhPnciDOAUvz7LUoszbIk3943EF4GaOMfOYbkLU1HpFJUMvfNQ1bTmskUgDA8V8WTdv/pm2InZw7zTPm8NPfBHIKeTVoQiEfmEeaT7vdgKZg+4BC4K0L1f2c9ZojmcbkZCy2ilhr1x6Qvl5JVQ9U03g2E+FwpzbzeYPIuMzlTD9JjIkIuUWLlZZbXslDZWsDIZ
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(36840700001)(46966006)(426003)(36860700001)(70586007)(83380400001)(36756003)(107886003)(82740400003)(2906002)(70206006)(34020700004)(478600001)(82310400003)(186003)(336012)(8676002)(26005)(8936002)(356005)(2616005)(5660300002)(110136005)(86362001)(4326008)(54906003)(1076003)(7636003)(47076005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:34:57.7575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9a7aaf-db9d-4dfa-f2c9-08d8e2d638f1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1202
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a new driver igd_vfio_pci.ko that will be responsible for
providing special extensions for INTEL Graphics card (GVT-d).

Also preserve backward compatibility with vfio_pci.ko vendor specific
extensions.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig                      |   5 +-
 drivers/vfio/pci/Makefile                     |   4 +-
 .../pci/{vfio_pci_igd.c => igd_vfio_pci.c}    | 147 +++++++++++++++++-
 drivers/vfio/pci/igd_vfio_pci.h               |  24 +++
 drivers/vfio/pci/vfio_pci.c                   |   4 +
 drivers/vfio/pci/vfio_pci_core.c              |  15 --
 drivers/vfio/pci/vfio_pci_core.h              |   9 --
 7 files changed, 176 insertions(+), 32 deletions(-)
 rename drivers/vfio/pci/{vfio_pci_igd.c => igd_vfio_pci.c} (62%)
 create mode 100644 drivers/vfio/pci/igd_vfio_pci.h

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 88c89863a205..09d85ba3e5b2 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -37,17 +37,14 @@ config VFIO_PCI_INTX
 	def_bool y if !S390
 
 config VFIO_PCI_IGD
-	bool "VFIO PCI extensions for Intel graphics (GVT-d)"
+	tristate "VFIO PCI extensions for Intel graphics (GVT-d)"
 	depends on VFIO_PCI_CORE && X86
-	default y
 	help
 	  Support for Intel IGD specific extensions to enable direct
 	  assignment to virtual machines.  This includes exposing an IGD
 	  specific firmware table and read-only copies of the host bridge
 	  and LPC bridge config space.
 
-	  To enable Intel IGD assignment through vfio-pci, say Y.
-
 config VFIO_PCI_NVLINK2GPU
 	tristate "VFIO support for NVIDIA NVLINK2 GPUs"
 	depends on VFIO_PCI_CORE && PPC_POWERNV
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 86fb62e271fc..298b2fb3f075 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -4,9 +4,9 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 obj-$(CONFIG_VFIO_PCI_NPU2) += npu2-vfio-pci.o
 obj-$(CONFIG_VFIO_PCI_NVLINK2GPU) += nvlink2gpu-vfio-pci.o
+obj-$(CONFIG_VFIO_PCI_IGD) += igd-vfio-pci.o
 
 vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
-vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
 
 vfio-pci-y := vfio_pci.o
@@ -14,3 +14,5 @@ vfio-pci-y := vfio_pci.o
 npu2-vfio-pci-y := npu2_vfio_pci.o
 
 nvlink2gpu-vfio-pci-y := nvlink2gpu_vfio_pci.o
+
+igd-vfio-pci-y := igd_vfio_pci.o
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/igd_vfio_pci.c
similarity index 62%
rename from drivers/vfio/pci/vfio_pci_igd.c
rename to drivers/vfio/pci/igd_vfio_pci.c
index 2388c9722ed8..bbbc432bca82 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/igd_vfio_pci.c
@@ -10,19 +10,32 @@
  * address is also virtualized to prevent user modification.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
 #include <linux/io.h>
 #include <linux/pci.h>
+#include <linux/list.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 
 #include "vfio_pci_core.h"
+#include "igd_vfio_pci.h"
 
 #define OPREGION_SIGNATURE	"IntelGraphicsMem"
 #define OPREGION_SIZE		(8 * 1024)
 #define OPREGION_PCI_ADDR	0xfc
 
-static size_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev, char __user *buf,
-			      size_t count, loff_t *ppos, bool iswrite)
+#define DRIVER_VERSION  "0.1"
+#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC     "IGD VFIO PCI - User Level meta-driver for Intel Graphics Processing Unit"
+
+struct igd_vfio_pci_device {
+	struct vfio_pci_core_device	vdev;
+};
+
+static size_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
+		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
 	void *base = vdev->region[i].data;
@@ -261,7 +274,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
 	return 0;
 }
 
-int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
+static int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 {
 	int ret;
 
@@ -275,3 +288,131 @@ int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 
 	return 0;
 }
+
+static void igd_vfio_pci_release(void *device_data)
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
+static int igd_vfio_pci_open(void *device_data)
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
+		ret = vfio_pci_igd_init(vdev);
+		if (ret && ret != -ENODEV) {
+			pci_warn(vdev->pdev, "Failed to setup Intel IGD regions\n");
+			vfio_pci_core_disable(vdev);
+			goto error;
+		}
+		ret = 0;
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
+static const struct vfio_device_ops igd_vfio_pci_ops = {
+	.name		= "igd-vfio-pci",
+	.open		= igd_vfio_pci_open,
+	.release	= igd_vfio_pci_release,
+	.ioctl		= vfio_pci_core_ioctl,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+};
+
+static int igd_vfio_pci_probe(struct pci_dev *pdev,
+		const struct pci_device_id *id)
+{
+	struct igd_vfio_pci_device *igvdev;
+	int ret;
+
+	igvdev = kzalloc(sizeof(*igvdev), GFP_KERNEL);
+	if (!igvdev)
+		return -ENOMEM;
+
+	ret = vfio_pci_core_register_device(&igvdev->vdev, pdev,
+			&igd_vfio_pci_ops);
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	kfree(igvdev);
+	return ret;
+}
+
+static void igd_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
+	struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
+	struct igd_vfio_pci_device *igvdev;
+
+	igvdev = container_of(core_vpdev, struct igd_vfio_pci_device, vdev);
+
+	vfio_pci_core_unregister_device(core_vpdev);
+	kfree(igvdev);
+}
+
+static const struct pci_device_id igd_vfio_pci_table[] = {
+	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xff0000, 0 },
+	{ 0, }
+};
+
+static struct pci_driver igd_vfio_pci_driver = {
+	.name			= "igd-vfio-pci",
+	.id_table		= igd_vfio_pci_table,
+	.probe			= igd_vfio_pci_probe,
+	.remove			= igd_vfio_pci_remove,
+#ifdef CONFIG_PCI_IOV
+	.sriov_configure	= vfio_pci_core_sriov_configure,
+#endif
+	.err_handler		= &vfio_pci_core_err_handlers,
+};
+
+#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
+struct pci_driver *get_igd_vfio_pci_driver(struct pci_dev *pdev)
+{
+	if (pci_match_id(igd_vfio_pci_driver.id_table, pdev))
+		return &igd_vfio_pci_driver;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(get_igd_vfio_pci_driver);
+#endif
+
+module_pci_driver(igd_vfio_pci_driver);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/igd_vfio_pci.h b/drivers/vfio/pci/igd_vfio_pci.h
new file mode 100644
index 000000000000..859aeca354cb
--- /dev/null
+++ b/drivers/vfio/pci/igd_vfio_pci.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2020, Mellanox Technologies, Ltd.  All rights reserved.
+ *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
+ */
+
+#ifndef IGD_VFIO_PCI_H
+#define IGD_VFIO_PCI_H
+
+#include <linux/pci.h>
+#include <linux/module.h>
+
+#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
+#if defined(CONFIG_VFIO_PCI_IGD) || defined(CONFIG_VFIO_PCI_IGD_MODULE)
+struct pci_driver *get_igd_vfio_pci_driver(struct pci_dev *pdev);
+#else
+struct pci_driver *get_igd_vfio_pci_driver(struct pci_dev *pdev)
+{
+	return NULL;
+}
+#endif
+#endif
+
+#endif /* IGD_VFIO_PCI_H */
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 8e81ea039f31..1c2f6d55a243 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -30,6 +30,7 @@
 #ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
 #include "npu2_vfio_pci.h"
 #include "nvlink2gpu_vfio_pci.h"
+#include "igd_vfio_pci.h"
 #endif
 
 #define DRIVER_VERSION  "0.2"
@@ -170,6 +171,9 @@ static struct pci_driver *vfio_pci_get_compat_driver(struct pci_dev *pdev)
 		default:
 			return NULL;
 		}
+	case PCI_VENDOR_ID_INTEL:
+		if (pdev->class == PCI_CLASS_DISPLAY_VGA << 8)
+			return get_igd_vfio_pci_driver(pdev);
 	}
 
 	return NULL;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f9b39abe54cb..59c9d0d56a0b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -343,22 +343,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-
-	if (vfio_pci_is_vga(pdev) &&
-	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
-		ret = vfio_pci_igd_init(vdev);
-		if (ret && ret != -ENODEV) {
-			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
-			goto disable_exit;
-		}
-	}
-
 	return 0;
-
-disable_exit:
-	vfio_pci_disable(vdev);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 31f3836e606e..2b5ea0db9284 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -196,15 +196,6 @@ extern u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
 extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
 					       u16 cmd);
 
-#ifdef CONFIG_VFIO_PCI_IGD
-extern int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
-#else
-static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
-{
-	return -ENODEV;
-}
-#endif
-
 #ifdef CONFIG_S390
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
-- 
2.25.4

