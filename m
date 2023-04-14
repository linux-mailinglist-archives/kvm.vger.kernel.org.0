Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2F56E2360
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 14:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjDNMen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 08:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjDNMel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 08:34:41 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBDBAF16;
        Fri, 14 Apr 2023 05:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKU7nfGcdRCWaXtbkCSj0laT8VtR+3OkN/dIjQGR/xUBCuqTixhPSizzeTwf6G9+SKwshxrYYL+cKztxxLgzIvOTa+CXp6JiEE3S0jGh7dy/21G6isRYfiqULzrkeV809boc5cfGCJSrjOhntaOtbVK0wWpnVqGamXN9dHWK6yRCFfX4A3udoLNj8gJoO0nQVCuC1yDmU7r03OvViIwFRFyy13oDQX4gmtBv7jQkKE1IGZFTSun9KyoLiw17Ppp3k7Wwmniw/uN1glrIKU9X6C3N7zICxdkNUQFTTF/iG1EbT84dHmLUMn17CQsWsXC6gr5/tMV58tVeep2V6DCZ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5l4g/DEjRQYbMGzu02SrT3OUreH4If6ysLYwk4fcTvc=;
 b=gPUe//kGQfawYo9KcX1bEo//8WBfHFEkm3ATEGV9Wj5M2ItWzn80pifPbxAnKXWY+siHc3qLNk43k4mObZ35xp6iWADjquUEwusQXnNg44sL+dzzCZtBf6pZVdkIccIYsKPIh6ghoreUBboxUHP1v4cqKQ6gnPV9wBkWy0nygwnrF57NveAmBiqhp88OO+fehp7Bd9sz8Qska9UGV1Qi9YM2o84KvGJ5icDcUVzsu947kDF5NlcCDSjSrQJYz+DrRQQ6Rmek9C2FoKbzzxqag4ffVS3YVskdYcSRnYvY2AwdSKI+5dCz7AU4SeXT5s+0ghxorkTQYFC1880KeEKRkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5l4g/DEjRQYbMGzu02SrT3OUreH4If6ysLYwk4fcTvc=;
 b=0PuyH4wrQqHa6pA/GFukTh8aiinBn3Bgx3TbS3zrTbXWDaUnEOjWZwEj1FeRYEElopyKF8RfrQyKjRBBcY0Qykni0VOfuBPwUtAyJCggDEKUiEFQR8docRXUy8vqkmRqJr/xg3pBSoPeI6n/k0yegQCI9Rr/NIO5+Y4W5E3Aab4=
Received: from BN0PR08CA0021.namprd08.prod.outlook.com (2603:10b6:408:142::16)
 by DM4PR12MB6279.namprd12.prod.outlook.com (2603:10b6:8:a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 12:34:33 +0000
Received: from BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::7f) by BN0PR08CA0021.outlook.office365.com
 (2603:10b6:408:142::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.36 via Frontend
 Transport; Fri, 14 Apr 2023 12:34:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT078.mail.protection.outlook.com (10.13.176.251) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.37 via Frontend Transport; Fri, 14 Apr 2023 12:34:33 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 14 Apr
 2023 07:34:32 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 14 Apr
 2023 07:34:32 -0500
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 14 Apr 2023 07:34:28 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <alex.williamson@redhat.com>, <jgg@ziepe.ca>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <masahiroy@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <nicolas@fjasle.eu>
CC:     <git@amd.com>, <harpreet.anand@amd.com>,
        <pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
        <michal.simek@amd.com>, Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v2] vfio/cdx: add support for CDX bus
Date:   Fri, 14 Apr 2023 18:04:14 +0530
Message-ID: <20230414123414.21645-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT078:EE_|DM4PR12MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 96f0ff32-d5e7-4172-d272-08db3ce499a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqO8E/KaQ0cqXvWT12c6sE/q7jLARogMMNPLBhpZP+DF0nYz1AQOIq0Bb26R+HN1LXzKQBg5ZMXiZ+8heeYIiAj9TCWaelun2ZrzGArEJYHpMHSKCaBg3AJLZUHycwIjXfp6TXDr3mc6INfUBBzjOhFTilHKt5MHdgZNzrNgGFifVY/eM5ondFy1MFMHzywObgGd6tux57MXACmdD5aTj+1Z69gmkpppPfNGYRSI0JTwAXv1HjmQo//ZeIIEqSGeNMRHwWJB7JOlzt0hfwwPMaHOOgqBqTqj2HXpaocnc87YuntAQVpmewAqEwLeHI6nTVAwr2GYWvlZpPQ5aSmATRFUKE29O3s3mjP3xPBtSMuYgUTbLVj5n1l8kSV0DMopp2vAf24L5Tp/ZXhGtySvVNfktrhXI+qshfsQl7Xn3/oUh4z/jbreNJa4Lcsea2Y0JhpW/RHZ1LU52sazm4tdctgx/WbeuuCQo5Qh21M5igNuHBJJAmghDvZnkEIPzYuLInvmIC+jJZcd+wEOfycP/k6SCKxTcSAI/acbs8Rd8R3vvCiWok3Xv+HAJ9vVsNldIVlknAkW35oJTELBYB7IMItJ50PX+I+Xs8S1hS+zqotJGoeaUd/oBTGdgFrpV5M4F+lc3hYYqb2Jes9N3fSF7jIu+u+qD8vEpQ2LlbkAa6KozqP0EEcJLc4PtQW5R+YpQcsiL5KqZvtIkfJ0PBf7VkOSvSIaErZ/9qfZMsYpA4I0k3ra73xKl1e+eZAY8jSZ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(316002)(41300700001)(26005)(1076003)(81166007)(6666004)(186003)(86362001)(47076005)(2616005)(356005)(82310400005)(36860700001)(336012)(426003)(36756003)(83380400001)(82740400003)(40480700001)(110136005)(4326008)(54906003)(70586007)(8676002)(70206006)(8936002)(5660300002)(2906002)(30864003)(44832011)(478600001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 12:34:33.0473
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f0ff32-d5e7-4172-d272-08db3ce499a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6279
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio-cdx driver enables IOCTLs for user space to query
MMIO regions for CDX devices and mmap them. This change
also adds support for reset of CDX devices.

This change adds the VFIO CDX driver and enables the following
ioctls for CDX devices:
 - VFIO_DEVICE_GET_INFO:
 - VFIO_DEVICE_GET_REGION_INFO
 - VFIO_DEVICE_RESET

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Tested-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
---

Changes v1->v2:
- Updated file2alias to support vfio_cdx
- removed some un-necessary checks in mmap
- removed vfio reset wrapper API
- converted complex macros to static APIs
- used pgprot_device and io_remap_pfn_range

 MAINTAINERS                         |   7 +
 drivers/vfio/Kconfig                |   1 +
 drivers/vfio/Makefile               |   1 +
 drivers/vfio/cdx/Kconfig            |  17 ++
 drivers/vfio/cdx/Makefile           |   8 +
 drivers/vfio/cdx/vfio_cdx.c         | 290 ++++++++++++++++++++++++++++
 drivers/vfio/cdx/vfio_cdx_private.h |  31 +++
 include/linux/cdx/cdx_bus.h         |   1 -
 include/linux/mod_devicetable.h     |   6 +
 scripts/mod/devicetable-offsets.c   |   1 +
 scripts/mod/file2alias.c            |  17 +-
 11 files changed, 378 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/cdx/Kconfig
 create mode 100644 drivers/vfio/cdx/Makefile
 create mode 100644 drivers/vfio/cdx/vfio_cdx.c
 create mode 100644 drivers/vfio/cdx/vfio_cdx_private.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f74d8571ac9..c4fd42ba8f46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22064,6 +22064,13 @@ F:	Documentation/filesystems/vfat.rst
 F:	fs/fat/
 F:	tools/testing/selftests/filesystems/fat/
 
+VFIO CDX DRIVER
+M:	Nipun Gupta <nipun.gupta@amd.com>
+M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/cdx/*
+
 VFIO DRIVER
 M:	Alex Williamson <alex.williamson@redhat.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 89e06c981e43..aba36f5be4ec 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -57,6 +57,7 @@ source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
 source "drivers/vfio/mdev/Kconfig"
 source "drivers/vfio/fsl-mc/Kconfig"
+source "drivers/vfio/cdx/Kconfig"
 endif
 
 source "virt/lib/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 70e7dcb302ef..1a27b2516612 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_VFIO_PCI) += pci/
 obj-$(CONFIG_VFIO_PLATFORM) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
 obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
+obj-$(CONFIG_VFIO_CDX) += cdx/
diff --git a/drivers/vfio/cdx/Kconfig b/drivers/vfio/cdx/Kconfig
new file mode 100644
index 000000000000..e6de0a0caa32
--- /dev/null
+++ b/drivers/vfio/cdx/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# VFIO CDX configuration
+#
+# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+#
+
+config VFIO_CDX
+	tristate "VFIO support for CDX bus devices"
+	depends on CDX_BUS
+	select EVENTFD
+	help
+	  Driver to enable VFIO support for the devices on CDX bus.
+	  This is required to make use of CDX devices present in
+	  the system using the VFIO framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
new file mode 100644
index 000000000000..82e4ef412c0f
--- /dev/null
+++ b/drivers/vfio/cdx/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+#
+
+obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
+
+vfio-cdx-objs := vfio_cdx.o
diff --git a/drivers/vfio/cdx/vfio_cdx.c b/drivers/vfio/cdx/vfio_cdx.c
new file mode 100644
index 000000000000..c19062ce7680
--- /dev/null
+++ b/drivers/vfio/cdx/vfio_cdx.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/vfio.h>
+#include <linux/cdx/cdx_bus.h>
+
+#include "vfio_cdx_private.h"
+
+static struct cdx_driver vfio_cdx_driver;
+
+static int vfio_cdx_init_device(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
+
+	vdev->cdx_dev = cdx_dev;
+	vdev->dev = &cdx_dev->dev;
+
+	return 0;
+}
+
+static void vfio_cdx_release_device(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+
+	vdev->cdx_dev = NULL;
+	vdev->dev = NULL;
+}
+
+/**
+ * CDX_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
+ *                                   "driver_override" CDX device.
+ * @vend: the 16 bit CDX Vendor ID
+ * @dev: the 16 bit CDX Device ID
+ *
+ * This macro is used to create a struct cdx_device_id that matches a
+ * specific device. driver_override will be set to
+ * CDX_ID_F_VFIO_DRIVER_OVERRIDE.
+ */
+#define CDX_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
+	CDX_DEVICE_DRIVER_OVERRIDE(vend, dev, CDX_ID_F_VFIO_DRIVER_OVERRIDE)
+
+static int vfio_cdx_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = vdev->cdx_dev;
+	int count = cdx_dev->res_count;
+	int i;
+
+	vdev->regions = kcalloc(count, sizeof(struct vfio_cdx_region),
+				GFP_KERNEL);
+	if (!vdev->regions)
+		return -ENOMEM;
+
+	for (i = 0; i < count; i++) {
+		struct resource *res = &cdx_dev->res[i];
+
+		vdev->regions[i].addr = res->start;
+		vdev->regions[i].size = resource_size(res);
+		vdev->regions[i].type = res->flags;
+		/*
+		 * Only regions addressed with PAGE granularity may be
+		 * MMAP'ed securely.
+		 */
+		if (!(vdev->regions[i].addr & ~PAGE_MASK) &&
+		    !(vdev->regions[i].size & ~PAGE_MASK))
+			vdev->regions[i].flags |=
+					VFIO_REGION_INFO_FLAG_MMAP;
+		vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
+		if (!(cdx_dev->res[i].flags & IORESOURCE_READONLY))
+			vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
+	}
+
+	return 0;
+}
+
+static void vfio_cdx_regions_cleanup(struct vfio_cdx_device *vdev)
+{
+	kfree(vdev->regions);
+}
+
+static void vfio_cdx_close_device(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	int ret;
+
+	vfio_cdx_regions_cleanup(vdev);
+
+	/* reset the device before cleaning up the interrupts */
+	ret = cdx_dev_reset(&vdev->cdx_dev->dev);
+	if (WARN_ON(ret))
+		dev_warn(core_vdev->dev,
+			 "VFIO_CDX: reset device has failed (%d)\n", ret);
+}
+
+static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
+			   unsigned int cmd, unsigned long arg)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = vdev->cdx_dev;
+	unsigned long minsz;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+	{
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		info.flags = VFIO_DEVICE_FLAGS_RESET;
+
+		info.num_regions = cdx_dev->res_count;
+		info.num_irqs = 0;
+
+		return copy_to_user((void __user *)arg, &info, minsz) ?
+			-EFAULT : 0;
+	}
+	case VFIO_DEVICE_GET_REGION_INFO:
+	{
+		struct vfio_region_info info;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index >= cdx_dev->res_count)
+			return -EINVAL;
+
+		/* map offset to the physical address  */
+		info.offset = vfio_cdx_index_to_offset(info.index);
+		info.size = vdev->regions[info.index].size;
+		info.flags = vdev->regions[info.index].flags;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+		return 0;
+	}
+	case VFIO_DEVICE_RESET:
+	{
+		return cdx_dev_reset(&vdev->cdx_dev->dev);
+	}
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int vfio_cdx_mmap_mmio(struct vfio_cdx_region region,
+			      struct vm_area_struct *vma)
+{
+	u64 size = vma->vm_end - vma->vm_start;
+	u64 pgoff, base;
+
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	base = pgoff << PAGE_SHIFT;
+
+	if (region.size < PAGE_SIZE || base + size > region.size)
+		return -EINVAL;
+
+	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
+	vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
+
+	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+				  size, vma->vm_page_prot);
+}
+
+static int vfio_cdx_mmap(struct vfio_device *core_vdev,
+			 struct vm_area_struct *vma)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = vdev->cdx_dev;
+	unsigned int index;
+
+	index = vma->vm_pgoff >> (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT);
+
+	if (index >= cdx_dev->res_count)
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ) &&
+	    (vma->vm_flags & VM_READ))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &&
+	    (vma->vm_flags & VM_WRITE))
+		return -EINVAL;
+
+	return vfio_cdx_mmap_mmio(vdev->regions[index], vma);
+}
+
+static const struct vfio_device_ops vfio_cdx_ops = {
+	.name		= "vfio-cdx",
+	.init		= vfio_cdx_init_device,
+	.release	= vfio_cdx_release_device,
+	.open_device	= vfio_cdx_open_device,
+	.close_device	= vfio_cdx_close_device,
+	.ioctl		= vfio_cdx_ioctl,
+	.mmap		= vfio_cdx_mmap,
+};
+
+static int vfio_cdx_probe(struct cdx_device *cdx_dev)
+{
+	struct vfio_cdx_device *vdev = NULL;
+	struct device *dev = &cdx_dev->dev;
+	int ret;
+
+	vdev = vfio_alloc_device(vfio_cdx_device, vdev, dev,
+				 &vfio_cdx_ops);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	ret = vfio_register_group_dev(&vdev->vdev);
+	if (ret) {
+		dev_err(dev, "VFIO_CDX: Failed to add to vfio group\n");
+		goto out_uninit;
+	}
+
+	dev_set_drvdata(dev, vdev);
+	return 0;
+
+out_uninit:
+	vfio_put_device(&vdev->vdev);
+	return ret;
+}
+
+static int vfio_cdx_remove(struct cdx_device *cdx_dev)
+{
+	struct device *dev = &cdx_dev->dev;
+	struct vfio_cdx_device *vdev;
+
+	vdev = dev_get_drvdata(dev);
+	vfio_unregister_group_dev(&vdev->vdev);
+	vfio_put_device(&vdev->vdev);
+
+	return 0;
+}
+
+static const struct cdx_device_id vfio_cdx_table[] = {
+	{ CDX_DRIVER_OVERRIDE_DEVICE_VFIO(CDX_ANY_ID, CDX_ANY_ID) }, /* match all by default */
+	{}
+};
+
+MODULE_DEVICE_TABLE(cdx, vfio_cdx_table);
+
+static struct cdx_driver vfio_cdx_driver = {
+	.probe		= vfio_cdx_probe,
+	.remove		= vfio_cdx_remove,
+	.match_id_table	= vfio_cdx_table,
+	.driver	= {
+		.name	= "vfio-cdx",
+		.owner	= THIS_MODULE,
+	},
+	.driver_managed_dma = true,
+};
+
+static int __init vfio_cdx_driver_init(void)
+{
+	return cdx_driver_register(&vfio_cdx_driver);
+}
+
+static void __exit vfio_cdx_driver_exit(void)
+{
+	cdx_driver_unregister(&vfio_cdx_driver);
+}
+
+module_init(vfio_cdx_driver_init);
+module_exit(vfio_cdx_driver_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("VFIO for CDX devices - User Level meta-driver");
diff --git a/drivers/vfio/cdx/vfio_cdx_private.h b/drivers/vfio/cdx/vfio_cdx_private.h
new file mode 100644
index 000000000000..5f143736eb7a
--- /dev/null
+++ b/drivers/vfio/cdx/vfio_cdx_private.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef VFIO_CDX_PRIVATE_H
+#define VFIO_CDX_PRIVATE_H
+
+#define VFIO_CDX_OFFSET_SHIFT    40
+
+static inline u64 vfio_cdx_index_to_offset(u32 index)
+{
+	return ((u64)(index) << VFIO_CDX_OFFSET_SHIFT);
+}
+
+struct vfio_cdx_region {
+	u32			flags;
+	u32			type;
+	u64			addr;
+	resource_size_t		size;
+	void __iomem		*ioaddr;
+};
+
+struct vfio_cdx_device {
+	struct vfio_device	vdev;
+	struct cdx_device	*cdx_dev;
+	struct device		*dev;
+	struct vfio_cdx_region	*regions;
+};
+
+#endif /* VFIO_CDX_PRIVATE_H */
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
index 35ef41d8a61a..bead71b7bc73 100644
--- a/include/linux/cdx/cdx_bus.h
+++ b/include/linux/cdx/cdx_bus.h
@@ -14,7 +14,6 @@
 #include <linux/mod_devicetable.h>
 
 #define MAX_CDX_DEV_RESOURCES	4
-#define CDX_ANY_ID (0xFFFF)
 #define CDX_CONTROLLER_ID_SHIFT 4
 #define CDX_BUS_NUM_MASK 0xF
 
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index ccaaeda792c0..ccf017353bb6 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -912,6 +912,12 @@ struct ishtp_device_id {
 	kernel_ulong_t driver_data;
 };
 
+#define CDX_ANY_ID (0xFFFF)
+
+enum {
+	CDX_ID_F_VFIO_DRIVER_OVERRIDE = 1,
+};
+
 /**
  * struct cdx_device_id - CDX device identifier
  * @vendor: Vendor ID
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index 62dc988df84d..abe65f8968dd 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -265,6 +265,7 @@ int main(void)
 	DEVID(cdx_device_id);
 	DEVID_FIELD(cdx_device_id, vendor);
 	DEVID_FIELD(cdx_device_id, device);
+	DEVID_FIELD(cdx_device_id, override_only);
 
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 28da34ba4359..38120f932b0d 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1458,8 +1458,23 @@ static int do_cdx_entry(const char *filename, void *symval,
 {
 	DEF_FIELD(symval, cdx_device_id, vendor);
 	DEF_FIELD(symval, cdx_device_id, device);
+	DEF_FIELD(symval, cdx_device_id, override_only);
 
-	sprintf(alias, "cdx:v%08Xd%08Xd", vendor, device);
+	switch (override_only) {
+	case 0:
+		strcpy(alias, "cdx:");
+		break;
+	case CDX_ID_F_VFIO_DRIVER_OVERRIDE:
+		strcpy(alias, "vfio_cdx:");
+		break;
+	default:
+		warn("Unknown CDX driver_override alias %08X\n",
+		     override_only);
+		return 0;
+	}
+
+	ADD(alias, "v", vendor != CDX_ANY_ID, vendor);
+	ADD(alias, "d", device != CDX_ANY_ID, device);
 	return 1;
 }
 
-- 
2.17.1

