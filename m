Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8EA39A56C
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFCQLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:11:03 -0400
Received: from mail-dm6nam11on2070.outbound.protection.outlook.com ([40.107.223.70]:21888
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230048AbhFCQLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:11:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAry6ZJRz2+T58CUqWKFW9e9GRNbtPSLNZ9qsyF9YljRaOzIcnXIUs4btXS7Vx+CNMSYPJ82qbPz9wXeQRbfjyfnGk6UqZtKU/qghHp12vctmxJyFZI880wuFYqQ00kyfwfBQ1nz5/7B0HqALzyp3U+GEi1q6UziPGrtXufgjEo6csmV3wXLWowPAeZGd+ClU2cUbN37UdUlauNvGwpdvSm9EHcEvvJPg6fg4OgVg7tyM0+ii/5qrqsu1nRzgGj+fJWtuLU1/vSWFkmnnqUWDn/WRHilZFD9wefBXZIQ78y59j08tHrjDkeWsmRjFblM0CA0I3/FChY/6nMa6fEAsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubKKbABrpeG97j71RniAQ+2O6fSno18o9dpWL7ZMEF8=;
 b=Y/SU1QG09flVWyyOzVQTOvzm7SyLufDZuH+YRKaMyYDEhGLCzbOTjV7g/DzmzkBY9m4U1i7kPdKi6Pln8bEZ7DKLVqpqqX1APYuq/3ZttvSfhYGz3uWbzdz+yMjVl4zRFcdRGi8cvnw/npEdbAgQqfkexOEsC0SVl5vAOL3NSBpkpsuor/5Zu6Yy7xIzzB9qJQhAB/5H1oBJ4+iIQa+vLjw5Kc8MLoWcXNKhZJXyevnxLTSIA/IA1AwpZcMN0EmFC2uzzyXpVy/K8JZxIP2v7p4lKCcsBG/hRuyVnkTpLijWir4kCC7h27qbTpy50MQuyK3Qs31yVfAx/mnxEhCgnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubKKbABrpeG97j71RniAQ+2O6fSno18o9dpWL7ZMEF8=;
 b=L61lvj0+W83/nAIGnEkv2su9w2+fgRdCMyz0pE05RmfhMuYSOouVf3tBoY8DIT4i7Ntu19caIXZXjIujl/eZpuC4lpZlyOOAjUx3dNB85UDpd31FMW2GQqEwA8gm8Bepc9S2l0M0sCz1s4rgJ29h8bikOWvNMwLHfNUmGaKcXrcfXiD2wUj2nXOPByjSg60zG/PEfU2Ay46cSNyV5e8eWVHeuWD6LNtC33wT62r51vtZ5JSNTsu5TwX9sTHKkxuU8dwHd8kIRL94R5fY1Er9mOebxTqfV7xphjnsAt6sDYqmvowi4AD3PJzsN6IfmLJmRGLmjdTEZG+6nad92TJnKg==
Received: from BN6PR21CA0018.namprd21.prod.outlook.com (2603:10b6:404:8e::28)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Thu, 3 Jun
 2021 16:09:15 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:8e:cafe::a8) by BN6PR21CA0018.outlook.office365.com
 (2603:10b6:404:8e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.3 via Frontend
 Transport; Thu, 3 Jun 2021 16:09:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:09:15 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 09:09:12 -0700
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:09:08 +0000
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
Subject: [PATCH 11/11] mlx5-vfio-pci: add new vfio_pci driver for mlx5 devices
Date:   Thu, 3 Jun 2021 19:08:09 +0300
Message-ID: <20210603160809.15845-12-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91c72f39-a076-4633-4bdd-08d926a9ef7a
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-Microsoft-Antispam-PRVS: <SN6PR12MB4751068BB2DC5E094F51BDDDDE3C9@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +gKxEFzRogquxedIutc1BPA0hQFxO7hEWYtRYclzAI15OS84vEh7ASOBowqYZTT9+qLc5SlcWgxUIelL687w2AlYtl2kTqfxTf/c4DjsOrD9f29kz9kv+4SxqF+SXMRxVcZl2v6UaKKvjDl7lmbDbTgw4PZ4KQ5bv/ArRS6J24+Mdm84PiATAaBZTcn8ajMslwLce5N0rmVPRxhrOiC/EofbW0jasWAzq6z260S3+jVj20vkfUgKgYjSN9J5c8IQ4lVZ40WrjgHJ4F5CyPq7TiP4zMb9y0SNgyyol+tYI29hawFXDVt7CX6ZWZL7qika66aw+IXqIgLeu/H18YrCE+vn6hxmRjWlOU+fs2NYyeOEkv437aHUT42deI2J6j2wz4Wn8UzIuuwGGwJRu+GDXmMV1bjoiiAdPPAo7tUwEm4xQhNm2Ap/gcuVky2BAj1U9KFMu5ToUCFs7a6RsIRQQ7u80YMIME/cxgvXeEP+nNzwcya2IMfabjoSimiRDGVASSC/oNE7ZtW8OXiFCnp5k2HTNk9VR8grDEfY6T3RxnVBQVygC0RXmKI9pQwF9jsZ89iKSZE41Uu8yPXHtWgAhkdlej04EQWPuKevlha5COgXmnJHwF1orG85it77tDb8vMLyE3N7AbX5lFqgIifTj8Kv9OPMHmSMoI3cW5Z7TSw=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(36840700001)(46966006)(2906002)(107886003)(478600001)(36860700001)(110136005)(83380400001)(54906003)(82310400003)(26005)(316002)(4326008)(36756003)(86362001)(47076005)(426003)(82740400003)(7636003)(1076003)(8936002)(6636002)(356005)(8676002)(70586007)(2616005)(186003)(5660300002)(70206006)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:09:15.6894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c72f39-a076-4633-4bdd-08d926a9ef7a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the initial step for adding vendor specific vfio_pci driver for
mlx5 devices. mlx5_vfio_pci use vfio_pci_core to register to the VFIO
subsystem and also to implement the basic functionality of a pci device.

It will also extend this basic functionality and add mlx5 specific logic
for various features (such as live migration, for example).

Note: Although we've created the mlx5-vfio-pci.ko, the binding to
vfio-pci.ko will still work as before. It's fully backward compatible.
Of course, the extended vendor functionality will not exist in case one
will bind the device to the generic vfio_pci.ko.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig         |   9 +++
 drivers/vfio/pci/Makefile        |   3 +
 drivers/vfio/pci/mlx5_vfio_pci.c | 130 +++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+)
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 384d06661f30..9cdef46dd299 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -48,3 +48,12 @@ config VFIO_PCI_IGD
 	  and LPC bridge config space.
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
+
+config MLX5_VFIO_PCI
+	tristate "VFIO support for MLX5 PCI devices"
+	depends on VFIO_PCI_CORE && MLX5_CORE
+	help
+	  This provides a generic PCI support for MLX5 devices using the VFIO
+	  framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index ddba4759cde7..a0df9c2a4bd9 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -2,9 +2,12 @@
 
 obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
+obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
 
 vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
 
 vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
+
+mlx5-vfio-pci-y := mlx5_vfio_pci.o
diff --git a/drivers/vfio/pci/mlx5_vfio_pci.c b/drivers/vfio/pci/mlx5_vfio_pci.c
new file mode 100644
index 000000000000..0153682a3d3f
--- /dev/null
+++ b/drivers/vfio/pci/mlx5_vfio_pci.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, Mellanox Technologies. All rights reserved.
+ *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
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
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/sched/mm.h>
+#include <linux/mlx5/driver.h>
+
+#include <linux/vfio_pci_core.h>
+
+static int mlx5_vfio_pci_open(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int ret;
+
+	lockdep_assert_held(&core_vdev->reflck->lock);
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	/* TODO: register migration region here for capable devices */
+
+	vfio_pci_core_finish_enable(vdev);
+
+	return 0;
+}
+
+static const struct vfio_device_ops mlx5_vfio_pci_ops = {
+	.name		= "mlx5-vfio-pci",
+	.open		= mlx5_vfio_pci_open,
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
+static int mlx5_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct vfio_pci_core_device *vdev;
+	int ret;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	ret = vfio_pci_core_register_device(vdev, pdev, &mlx5_vfio_pci_ops);
+	if (ret)
+		goto out_free;
+
+	dev_set_drvdata(&pdev->dev, vdev);
+	return 0;
+
+out_free:
+	kfree(vdev);
+	return ret;
+}
+
+static void mlx5_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(vdev);
+	kfree(vdev);
+}
+
+static const struct pci_device_id mlx5_vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0x101b) }, /* ConnectX-6 */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0x101c) }, /* ConnectX-6 VF */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0x101d) }, /* ConnectX-6 Dx */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0x101e) }, /* ConnectX Family mlx5Gen Virtual Function */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0x101f) }, /* ConnectX-6 LX */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0x1021) }, /* ConnectX-7 */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0xa2d2) }, /* BlueField integrated ConnectX-5 network controller */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0xa2d3) }, /* BlueField integrated ConnectX-5 network controller VF */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0xa2d6) }, /* BlueField-2 integrated ConnectX-6 Dx network controller */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0xa2dc) }, /* BlueField-3 integrated ConnectX-7 network controller */
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, mlx5_vfio_pci_table);
+
+static struct pci_driver mlx5_vfio_pci_driver = {
+	.name			= "mlx5-vfio-pci",
+	.id_table		= mlx5_vfio_pci_table,
+	.probe			= mlx5_vfio_pci_probe,
+	.remove			= mlx5_vfio_pci_remove,
+#ifdef CONFIG_PCI_IOV
+	.sriov_configure	= vfio_pci_core_sriov_configure,
+#endif
+	.err_handler		= &vfio_pci_core_err_handlers,
+};
+
+static void __exit mlx5_vfio_pci_cleanup(void)
+{
+	pci_unregister_driver(&mlx5_vfio_pci_driver);
+}
+
+static int __init mlx5_vfio_pci_init(void)
+{
+	return pci_register_driver(&mlx5_vfio_pci_driver);
+}
+
+module_init(mlx5_vfio_pci_init);
+module_exit(mlx5_vfio_pci_cleanup);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");
+MODULE_DESCRIPTION("MLX5 VFIO PCI - User Level meta-driver for MLX5 device family");
-- 
2.21.0

