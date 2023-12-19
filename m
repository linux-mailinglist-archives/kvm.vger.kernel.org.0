Return-Path: <kvm+bounces-4795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5736818497
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE5071C23DB1
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8600614AA6;
	Tue, 19 Dec 2023 09:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="okvAA6Dx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C96414A9F
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 09:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UY3/nnxKM3wWuIvS9kQHPdQP0Y8xan3gKaco3sRuCFLKdUqHDm2JwX5+oUFGQNeaD+JfU7uYasNIeWWHy2Vn2J+LU6vlPPGMQBX/T1npMM+S1vHEuAx7EY2kl1zzeYUcMUASUKYAQrqX57dccYjtiukpYef0YzTT2mbWghtUGWxHGJnYyL5pi0JkW1cYM59qTXVIhUg2SWsQu7Lz6ZDnCpIZjFF05MAvhwMvPogKsMoflq1+emAy+Sp/JyHQ3U5PFj3gDfhU+0e/zZh7xiYCC5QXT9AM/SBqowcB+la+suA9A32DqY/J5NgZ7evMeA3pw5uJNYsPWtMVBB647BaI6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysoTx+FTSfzxu1L6kcf0Gh30AlyaZ5TFjETSYlzyrR0=;
 b=F6mny/tj0DLR7YWuPsmnsNrjz0L6VedrBurg0EzoluMLPf4Ju17l9Hw7/owAvyrNbF+3hg5CLSK0mejfYlhOKiIEOa///9Lu1PgOt8t1CPMjVqo3Jb+1z/c+bBjctnxc64pxeFUlVwilWViJ+kts7rN7AdyrRIomA0WCkX8VSdlu5MFtuf+ucyflrbG5ft0up14E46Pbw1O7yJU4h0JGopPRCPCGiacXODTeyE77VPkObwIFVg3r/0nsQIfrJ3kuZgxxXdIynZoSKNFtIe5gI9pa8wYvYDkqMX64IVc+63MO05aH0e8O7LzU45SQCjpcyWLguCSA29oSTP8U7d0d/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysoTx+FTSfzxu1L6kcf0Gh30AlyaZ5TFjETSYlzyrR0=;
 b=okvAA6DxnCSjgleNVsjSRsJECYVkkj6QtE/u6h38jXr6bfJnlCnLySFKsVC1eitacl3EAga3L7JAqRiVoN9faaLxrNzcOUo7Ej64dbVn02khQgryA8UBcQDOb4kVCyAKGrV9l1lNMicbGkGs4n8HOxd+Ar14XawpYXtAnqlcP7pmL/odWsrUbMI9swl/1bppyBJBHZIlX9q1x3omfJXN8pHcgLYAW4lKv0ysbeF06cqzzS0hueseK2jHsIA8CeVZrfGZc9NNn6EphJkyZign6WBQG09i9BUGPcw8fnm/IYAS5eUyfSsOZoKDk7k9lFh5h36GDETVJuRqsdfdVOKDwA==
Received: from BLAP220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::11)
 by DS7PR12MB8322.namprd12.prod.outlook.com (2603:10b6:8:ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Tue, 19 Dec
 2023 09:34:35 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:32c:cafe::be) by BLAP220CA0006.outlook.office365.com
 (2603:10b6:208:32c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 09:34:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 09:34:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 01:34:20 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 19 Dec 2023 01:34:20 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 19 Dec 2023 01:34:16 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V10 vfio 9/9] vfio/virtio: Introduce a vfio driver over virtio devices
Date: Tue, 19 Dec 2023 11:32:47 +0200
Message-ID: <20231219093247.170936-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231219093247.170936-1-yishaih@nvidia.com>
References: <20231219093247.170936-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|DS7PR12MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: 55a39bb0-80c4-40de-7ce3-08dc0075b6ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eNqYjQw2AePnmS9a2deLV/FgWSowNCwaqsTmmVCKYy4DHyIPZ4S9E2zb9EPS/I+XXiFuiAU79fsycDCtvW6WGRE85DDw1l1o7HXIbQm6f9AtijBjXnNdw+pw/qgmspFMhqYrG0Wb61q1w7exfDkMgus6sxZYzMJVZVRi7DWRSpr/OsiCRWpwPozLxSfMvLdATQjA0ykjLr+MW7AHkat2lej9X04Sx/SJQBZQpYX/aAYYZcwt4Ku/0NH2z8iY2G1KgvMu3qMON0p8MG46jfZ5O228qVwfy8uARENxqXqYM6nLjIvTnKBRc0b7bLvJlfQIjaZvexPQCh1zvxBxWHWzq9HcQDcbDfnrt/cjmxRdrF3Byfu5tS+J21mUY/BqFiu7/gDVsvi9+NhWCEO1gcGx9yOJbNIMf+uiIfJvxdVQHwJKCDJBjgyFrmOxuQzMjoBXaj5JbX3eB1hOe42qQviW1F2OiDjrb+NiufmDd1wr6Y/CTeAUnWy5rGYTJa1EE6Z8hjHbNSub8/PI8T07e7a+PyFPCGZUm+918xQNj6IaQC7BWBLkQLQyxOFYpriquT8MI5awRjt8T+B/2SftGx8XD8rM7nBN74HsLqqZKz/w23QHWpmNX1hMzQKi6UsIpFNgK4fOu4O70q1KwIp+QzKfZqmubNuVLuAcPx+fV0H3Tnxca9ijVBDgDWYniP9p78MXDs5UAvqxiE3Lmva322pwn4Gva55k9x3YpsN0aEJQwkyc7ZiNRhQ1vNOqpQre1VUE9LjY3D+brIxHcHyF5dLyXv47DP3yAQDuVnKxX4o+hev5SQR057g5N7lg81/iBpiT
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(376002)(396003)(230922051799003)(186009)(64100799003)(1800799012)(82310400011)(451199024)(36840700001)(40470700004)(46966006)(26005)(107886003)(336012)(1076003)(2616005)(426003)(7696005)(6666004)(36860700001)(83380400001)(47076005)(5660300002)(30864003)(2906002)(8676002)(8936002)(4326008)(41300700001)(478600001)(110136005)(966005)(70586007)(70206006)(54906003)(6636002)(316002)(7636003)(356005)(82740400003)(36756003)(86362001)(40460700003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 09:34:35.3914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a39bb0-80c4-40de-7ce3-08dc0075b6ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8322

Introduce a vfio driver over virtio devices to support the legacy
interface functionality for VFs.

Background, from the virtio spec [1].
--------------------------------------------------------------------
In some systems, there is a need to support a virtio legacy driver with
a device that does not directly support the legacy interface. In such
scenarios, a group owner device can provide the legacy interface
functionality for the group member devices. The driver of the owner
device can then access the legacy interface of a member device on behalf
of the legacy member device driver.

For example, with the SR-IOV group type, group members (VFs) can not
present the legacy interface in an I/O BAR in BAR0 as expected by the
legacy pci driver. If the legacy driver is running inside a virtual
machine, the hypervisor executing the virtual machine can present a
virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
legacy driver accesses to this I/O BAR and forwards them to the group
owner device (PF) using group administration commands.
--------------------------------------------------------------------

Specifically, this driver adds support for a virtio-net VF to be exposed
as a transitional device to a guest driver and allows the legacy IO BAR
functionality on top.

This allows a VM which uses a legacy virtio-net driver in the guest to
work transparently over a VF which its driver in the host is that new
driver.

The driver can be extended easily to support some other types of virtio
devices (e.g virtio-blk), by adding in a few places the specific type
properties as was done for virtio-net.

For now, only the virtio-net use case was tested and as such we introduce
the support only for such a device.

Practically,
Upon probing a VF for a virtio-net device, in case its PF supports
legacy access over the virtio admin commands and the VF doesn't have BAR
0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
transitional device with I/O BAR in BAR 0.

The existence of the simulated I/O bar is reported later on by
overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
exposes itself as a transitional device by overwriting some properties
upon reading its config space.

Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
guest may use it via read/write calls according to the virtio
specification.

Any read/write towards the control parts of the BAR will be captured by
the new driver and will be translated into admin commands towards the
device.

In addition, any data path read/write access (i.e. virtio driver
notifications) will be captured by the driver and forwarded to the
physical BAR which its properties were supplied by the admin command
VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the probing/init flow.

With that code in place a legacy driver in the guest has the look and
feel as if having a transitional device with legacy support for both its
control and data path flows.

[1]
https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 MAINTAINERS                      |   7 +
 drivers/vfio/pci/Kconfig         |   2 +
 drivers/vfio/pci/Makefile        |   2 +
 drivers/vfio/pci/virtio/Kconfig  |  15 +
 drivers/vfio/pci/virtio/Makefile |   3 +
 drivers/vfio/pci/virtio/main.c   | 576 +++++++++++++++++++++++++++++++
 6 files changed, 605 insertions(+)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 012df8ccf34e..b246b769092d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22872,6 +22872,13 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/pci/mlx5/
 
+VFIO VIRTIO PCI DRIVER
+M:	Yishai Hadas <yishaih@nvidia.com>
+L:	kvm@vger.kernel.org
+L:	virtualization@lists.linux-foundation.org
+S:	Maintained
+F:	drivers/vfio/pci/virtio
+
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	Yishai Hadas <yishaih@nvidia.com>
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 8125e5f37832..18c397df566d 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
 
 source "drivers/vfio/pci/pds/Kconfig"
 
+source "drivers/vfio/pci/virtio/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 45167be462d8..046139a4eca5 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
 
 obj-$(CONFIG_PDS_VFIO_PCI) += pds/
+
+obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
new file mode 100644
index 000000000000..fc3a0be9d8d4
--- /dev/null
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config VIRTIO_VFIO_PCI
+        tristate "VFIO support for VIRTIO NET PCI devices"
+        depends on VIRTIO_PCI_ADMIN_LEGACY
+        select VFIO_PCI_CORE
+        help
+          This provides support for exposing VIRTIO NET VF devices which support
+          legacy IO access, using the VFIO framework that can work with a legacy
+          virtio driver in the guest.
+          Based on PCIe spec, VFs do not support I/O Space.
+          As of that this driver emulates I/O BAR in software to let a VF be
+          seen as a transitional device by its users and let it work with
+          a legacy driver.
+
+          If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
new file mode 100644
index 000000000000..7171105baf33
--- /dev/null
+++ b/drivers/vfio/pci/virtio/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
+virtio-vfio-pci-y := main.o
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
new file mode 100644
index 000000000000..291c55b641f1
--- /dev/null
+++ b/drivers/vfio/pci/virtio/main.c
@@ -0,0 +1,576 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/virtio_pci.h>
+#include <linux/virtio_net.h>
+#include <linux/virtio_pci_admin.h>
+
+struct virtiovf_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	u8 *bar0_virtual_buf;
+	/* synchronize access to the virtual buf */
+	struct mutex bar_mutex;
+	void __iomem *notify_addr;
+	u64 notify_offset;
+	__le32 pci_base_addr_0;
+	__le16 pci_cmd;
+	u8 bar0_virtual_buf_size;
+	u8 notify_bar;
+};
+
+static int
+virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
+			     loff_t pos, char __user *buf,
+			     size_t count, bool read)
+{
+	bool msix_enabled =
+		(virtvdev->core_device.irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
+	struct pci_dev *pdev = virtvdev->core_device.pdev;
+	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
+	bool common;
+	u8 offset;
+	int ret;
+
+	common = pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled);
+	/* offset within the relevant configuration area */
+	offset = common ? pos : pos - VIRTIO_PCI_CONFIG_OFF(msix_enabled);
+	mutex_lock(&virtvdev->bar_mutex);
+	if (read) {
+		if (common)
+			ret = virtio_pci_admin_legacy_common_io_read(pdev, offset,
+					count, bar0_buf + pos);
+		else
+			ret = virtio_pci_admin_legacy_device_io_read(pdev, offset,
+					count, bar0_buf + pos);
+		if (ret)
+			goto out;
+		if (copy_to_user(buf, bar0_buf + pos, count))
+			ret = -EFAULT;
+	} else {
+		if (copy_from_user(bar0_buf + pos, buf, count)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (common)
+			ret = virtio_pci_admin_legacy_common_io_write(pdev, offset,
+					count, bar0_buf + pos);
+		else
+			ret = virtio_pci_admin_legacy_device_io_write(pdev, offset,
+					count, bar0_buf + pos);
+	}
+out:
+	mutex_unlock(&virtvdev->bar_mutex);
+	return ret;
+}
+
+static int
+virtiovf_pci_bar0_rw(struct virtiovf_pci_core_device *virtvdev,
+		     loff_t pos, char __user *buf,
+		     size_t count, bool read)
+{
+	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
+	struct pci_dev *pdev = core_device->pdev;
+	u16 queue_notify;
+	int ret;
+
+	if (!(le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO))
+		return -EIO;
+
+	if (pos + count > virtvdev->bar0_virtual_buf_size)
+		return -EINVAL;
+
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret) {
+		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
+		return -EIO;
+	}
+
+	switch (pos) {
+	case VIRTIO_PCI_QUEUE_NOTIFY:
+		if (count != sizeof(queue_notify)) {
+			ret = -EINVAL;
+			goto end;
+		}
+		if (read) {
+			ret = vfio_pci_core_ioread16(core_device, true, &queue_notify,
+						     virtvdev->notify_addr);
+			if (ret)
+				goto end;
+			if (copy_to_user(buf, &queue_notify,
+					 sizeof(queue_notify))) {
+				ret = -EFAULT;
+				goto end;
+			}
+		} else {
+			if (copy_from_user(&queue_notify, buf, count)) {
+				ret = -EFAULT;
+				goto end;
+			}
+			ret = vfio_pci_core_iowrite16(core_device, true, queue_notify,
+						      virtvdev->notify_addr);
+		}
+		break;
+	default:
+		ret = virtiovf_issue_legacy_rw_cmd(virtvdev, pos, buf, count,
+						   read);
+	}
+
+end:
+	pm_runtime_put(&pdev->dev);
+	return ret ? ret : count;
+}
+
+static bool range_intersect_range(loff_t range1_start, size_t count1,
+				  loff_t range2_start, size_t count2,
+				  loff_t *start_offset,
+				  size_t *intersect_count,
+				  size_t *register_offset)
+{
+	if (range1_start <= range2_start &&
+	    range1_start + count1 > range2_start) {
+		*start_offset = range2_start - range1_start;
+		*intersect_count = min_t(size_t, count2,
+					 range1_start + count1 - range2_start);
+		*register_offset = 0;
+		return true;
+	}
+
+	if (range1_start > range2_start &&
+	    range1_start < range2_start + count2) {
+		*start_offset = 0;
+		*intersect_count = min_t(size_t, count1,
+					 range2_start + count2 - range1_start);
+		*register_offset = range1_start - range2_start;
+		return true;
+	}
+
+	return false;
+}
+
+static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
+					char __user *buf, size_t count,
+					loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	size_t register_offset;
+	loff_t copy_offset;
+	size_t copy_count;
+	__le32 val32;
+	__le16 val16;
+	u8 val8;
+	int ret;
+
+	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
+	if (ret < 0)
+		return ret;
+
+	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
+				  &copy_offset, &copy_count, &register_offset)) {
+		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
+			return -EFAULT;
+	}
+
+	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
+	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
+				  &copy_offset, &copy_count, &register_offset)) {
+		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
+				   copy_count))
+			return -EFAULT;
+		val16 |= cpu_to_le16(PCI_COMMAND_IO);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
+				 copy_count))
+			return -EFAULT;
+	}
+
+	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
+				  &copy_offset, &copy_count, &register_offset)) {
+		/* Transional needs to have revision 0 */
+		val8 = 0;
+		if (copy_to_user(buf + copy_offset, &val8, copy_count))
+			return -EFAULT;
+	}
+
+	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
+				  &copy_offset, &copy_count, &register_offset)) {
+		u32 bar_mask = ~(virtvdev->bar0_virtual_buf_size - 1);
+		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
+
+		val32 = cpu_to_le32((pci_base_addr_0 & bar_mask) | PCI_BASE_ADDRESS_SPACE_IO);
+		if (copy_to_user(buf + copy_offset, (void *)&val32 + register_offset, copy_count))
+			return -EFAULT;
+	}
+
+	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
+				  &copy_offset, &copy_count, &register_offset)) {
+		/*
+		 * Transitional devices use the PCI subsystem device id as
+		 * virtio device id, same as legacy driver always did.
+		 */
+		val16 = cpu_to_le16(VIRTIO_ID_NET);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
+				 copy_count))
+			return -EFAULT;
+	}
+
+	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID, sizeof(val16),
+				  &copy_offset, &copy_count, &register_offset)) {
+		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
+				 copy_count))
+			return -EFAULT;
+	}
+
+	return count;
+}
+
+static ssize_t
+virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
+		       size_t count, loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
+
+	if (index == VFIO_PCI_BAR0_REGION_INDEX)
+		return virtiovf_pci_bar0_rw(virtvdev, pos, buf, count, true);
+
+	return vfio_pci_core_read(core_vdev, buf, count, ppos);
+}
+
+static ssize_t virtiovf_pci_write_config(struct vfio_device *core_vdev,
+					 const char __user *buf, size_t count,
+					 loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	size_t register_offset;
+	loff_t copy_offset;
+	size_t copy_count;
+
+	if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
+				  &copy_offset, &copy_count,
+				  &register_offset)) {
+		if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
+				   buf + copy_offset,
+				   copy_count))
+			return -EFAULT;
+	}
+
+	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
+				  sizeof(virtvdev->pci_base_addr_0),
+				  &copy_offset, &copy_count,
+				  &register_offset)) {
+		if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
+				   buf + copy_offset,
+				   copy_count))
+			return -EFAULT;
+	}
+
+	return vfio_pci_core_write(core_vdev, buf, count, ppos);
+}
+
+static ssize_t
+virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return virtiovf_pci_write_config(core_vdev, buf, count, ppos);
+
+	if (index == VFIO_PCI_BAR0_REGION_INDEX)
+		return virtiovf_pci_bar0_rw(virtvdev, pos, (char __user *)buf, count, false);
+
+	return vfio_pci_core_write(core_vdev, buf, count, ppos);
+}
+
+static int
+virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
+				   unsigned int cmd, unsigned long arg)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+	void __user *uarg = (void __user *)arg;
+	struct vfio_region_info info = {};
+
+	if (copy_from_user(&info, uarg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	switch (info.index) {
+	case VFIO_PCI_BAR0_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = virtvdev->bar0_virtual_buf_size;
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+static long
+virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+			     unsigned long arg)
+{
+	switch (cmd) {
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+static int
+virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
+{
+	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
+	int ret;
+
+	/*
+	 * Setup the BAR where the 'notify' exists to be used by vfio as well
+	 * This will let us mmap it only once and use it when needed.
+	 */
+	ret = vfio_pci_core_setup_barmap(core_device,
+					 virtvdev->notify_bar);
+	if (ret)
+		return ret;
+
+	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
+			virtvdev->notify_offset;
+	return 0;
+}
+
+static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	if (virtvdev->bar0_virtual_buf) {
+		/*
+		 * Upon close_device() the vfio_pci_core_disable() is called
+		 * and will close all the previous mmaps, so it seems that the
+		 * valid life cycle for the 'notify' addr is per open/close.
+		 */
+		ret = virtiovf_set_notify_addr(virtvdev);
+		if (ret) {
+			vfio_pci_core_disable(vdev);
+			return ret;
+		}
+	}
+
+	vfio_pci_core_finish_enable(vdev);
+	return 0;
+}
+
+static int virtiovf_get_device_config_size(unsigned short device)
+{
+	/* Network card */
+	return offsetofend(struct virtio_net_config, status);
+}
+
+static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
+{
+	u64 offset;
+	int ret;
+	u8 bar;
+
+	ret = virtio_pci_admin_legacy_io_notify_info(virtvdev->core_device.pdev,
+				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
+				&bar, &offset);
+	if (ret)
+		return ret;
+
+	virtvdev->notify_bar = bar;
+	virtvdev->notify_offset = offset;
+	return 0;
+}
+
+static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct pci_dev *pdev;
+	int ret;
+
+	ret = vfio_pci_core_init_dev(core_vdev);
+	if (ret)
+		return ret;
+
+	pdev = virtvdev->core_device.pdev;
+	ret = virtiovf_read_notify_info(virtvdev);
+	if (ret)
+		return ret;
+
+	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
+				virtiovf_get_device_config_size(pdev->device);
+	BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
+	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
+					     GFP_KERNEL);
+	if (!virtvdev->bar0_virtual_buf)
+		return -ENOMEM;
+	mutex_init(&virtvdev->bar_mutex);
+	return 0;
+}
+
+static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+
+	kfree(virtvdev->bar0_virtual_buf);
+	vfio_pci_core_release_dev(core_vdev);
+}
+
+static const struct vfio_device_ops virtiovf_vfio_pci_tran_ops = {
+	.name = "virtio-vfio-pci-trans",
+	.init = virtiovf_pci_init_device,
+	.release = virtiovf_pci_core_release_dev,
+	.open_device = virtiovf_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = virtiovf_vfio_pci_core_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = virtiovf_pci_core_read,
+	.write = virtiovf_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+	.detach_ioas = vfio_iommufd_physical_detach_ioas,
+};
+
+static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
+	.name = "virtio-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
+	.open_device = virtiovf_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+	.detach_ioas = vfio_iommufd_physical_detach_ioas,
+};
+
+static bool virtiovf_bar0_exists(struct pci_dev *pdev)
+{
+	struct resource *res = pdev->resource;
+
+	return res->flags;
+}
+
+static int virtiovf_pci_probe(struct pci_dev *pdev,
+			      const struct pci_device_id *id)
+{
+	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
+	struct virtiovf_pci_core_device *virtvdev;
+	int ret;
+
+	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
+	    !virtiovf_bar0_exists(pdev))
+		ops = &virtiovf_vfio_pci_tran_ops;
+
+	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
+				     &pdev->dev, ops);
+	if (IS_ERR(virtvdev))
+		return PTR_ERR(virtvdev);
+
+	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
+	ret = vfio_pci_core_register_device(&virtvdev->core_device);
+	if (ret)
+		goto out;
+	return 0;
+out:
+	vfio_put_device(&virtvdev->core_device.vdev);
+	return ret;
+}
+
+static void virtiovf_pci_remove(struct pci_dev *pdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(&virtvdev->core_device);
+	vfio_put_device(&virtvdev->core_device.vdev);
+}
+
+static const struct pci_device_id virtiovf_pci_table[] = {
+	/* Only virtio-net is supported/tested so far */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
+
+void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
+
+	virtvdev->pci_cmd = 0;
+}
+
+static const struct pci_error_handlers virtiovf_err_handlers = {
+	.reset_done = virtiovf_pci_aer_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
+static struct pci_driver virtiovf_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = virtiovf_pci_table,
+	.probe = virtiovf_pci_probe,
+	.remove = virtiovf_pci_remove,
+	.err_handler = &virtiovf_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(virtiovf_pci_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
+MODULE_DESCRIPTION(
+	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");
-- 
2.27.0


