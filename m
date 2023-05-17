Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB337064BE
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 11:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjEQJ6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 05:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjEQJ6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 05:58:01 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8AD40E5;
        Wed, 17 May 2023 02:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GplOyp+jdVhVDtEchZay+np9KyYbE2hO34P1W1UpX+0bsajcR8AIlADJ+jqKQCcNlKwwHgH0GqcuSkr1M5gOgj7gSAUgzwljBDCRYu2d73F282Sum3MJ98W74Oej3mQvqfbuLAkQW6Y4+zkEsnA3upvnHydEyh2zBY++FQKKNBqp2U1LmOs7u1TANffkGT3ijz7k8TPEIrmXpo1XrfdlY3SjHqL6iDWfWhX7hHFwRfO9rceShrCQptcwxIs+WK3oME4xJVOav21xxNBnNH6bcpVnBRbARPv/oyNwibGshmb3w2EPjJETFR1V52m75s7MENLtcHpnIba/lWsqwa7Qrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gny153OYHsp6zYJBJk0ymt76bzDROfYUlxrrzTLpLos=;
 b=m9Lyvfs87m/GlliKXk0bzX11L/c/7azWaYwIDO2CD2ufaxKbYDkYe0hk0U7j5JpirKExNObumrV2ApQjny/ZmhfdPIQba7q7dGn6nwz5CMm9ra1kI/iuknGWrHKQIcFlmqiF0LxQFKYgfI3xuqHNHyiEzmxPpXZp0KVXWSTCBbBZxmfEJH0QkCjBIdKcgkI9uNwokS//fuz1v6HWkpEef7rGKFswWvDB3+B5h5kS7SaE3u9YIRYx7SjXafJcBYdI/1OKza1hJFPUBpYY/pFWdFf1ZHB4FXbsPQWC/zPKuXWkLCrcUR3aN48oyxNE2E6WBPzfkQZ08Q4EbQhwqZzNVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gny153OYHsp6zYJBJk0ymt76bzDROfYUlxrrzTLpLos=;
 b=A8DE671JXMweWE4isq4trypAz/I5WfxHbQLVHYVWEHF196Yb5CRZVU1s2g+bIKkAcWy8TFQin+7kEhnu09hq8t3h1yJvB9zyzdVHH6wPHCDx+ky5kBmNzVwUn2N9Ys9elx6QypEEBsCfepV9DXCJrR2ocoQzhYmJRhwrDfU4aYQ=
Received: from MW4PR03CA0034.namprd03.prod.outlook.com (2603:10b6:303:8e::9)
 by CH2PR12MB4939.namprd12.prod.outlook.com (2603:10b6:610:61::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 09:57:55 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::c6) by MW4PR03CA0034.outlook.office365.com
 (2603:10b6:303:8e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.18 via Frontend
 Transport; Wed, 17 May 2023 09:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.18 via Frontend Transport; Wed, 17 May 2023 09:57:54 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 17 May
 2023 04:57:45 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 17 May
 2023 02:57:37 -0700
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 17 May 2023 04:57:33 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <alex.williamson@redhat.com>, <jgg@ziepe.ca>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <masahiroy@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <nicolas@fjasle.eu>
CC:     <git@amd.com>, <harpreet.anand@amd.com>,
        <pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
        <michal.simek@amd.com>, Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v6] vfio/cdx: add support for CDX bus
Date:   Wed, 17 May 2023 15:27:18 +0530
Message-ID: <20230517095718.16117-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|CH2PR12MB4939:EE_
X-MS-Office365-Filtering-Correlation-Id: ebbf7abc-7ab0-4ebb-f88b-08db56bd2f4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13W/QtXc7v3nVfpEn1dqeY/OTjfn5T+AOJF6VDdUlh9azS6QCUcJM5yPyPxLcKGUaj6bJNpGBdH7ye2z17JZ7UfnbcsDmDDIEaCS50I/efElwhlMsLW6yoHdpi1vLKBtn810XVkHnC7D5thnFO4aqPpVDOqgd4ycnbAjmGdckr0Y79+LJYzKPrTL9FpKnk32w0BZDK1bn37sr87xIFra0iVDyhTooxMZl0kkNK02ie06r6L1DFy5vYgYR4vMI47UjRbFGr6uThNVkEeNnIH5hG8nLek4oyR3/qGiacfSi76VSZS0bc8fBCz5M0EUFObehU1wCaPJBLFHCEExhxY76V5f/EPo+PaDVbgAiFaMhyNJz2LvpTho02JQF5ZF4lmm5SjycL8IHlBrQb+ZteFCGLg7IVO5zRTaLrWFZ00wcI+DtRmIwr8+GsI9JbOWrqxi9mqzWUj0B/wRdWYh5w0ff2DyBwzP3/FRgQgsLef2+ywtbwdDH8yxLvkXS6vK2XkddW0MkspZoxawjoA7/sxtUD4mdVAumy/ApcxiEIDpdTypUo+OE7sqGafz5r5bp5y2thCcJ0d4g1vRDbAHAv8pcfi3unw6pT33ZAdWP4vCoyzHpJr17h6QQPU5QCXES4W/kMkhvHQ00CgccVV64zcFrEoi0b+Ao2ClVfGU3Olk+L1Mu0JS7obYCK+ZI5+65jo1fMTraGsfYFX77FCvCzAK2EpPzQn3UPN/TVtwzbaB4UA2vbu18V9Uu5X2MaMPFWB+vnJLBddco4p/Ybq2BMaVR4qKA4UkphJ3LLT7EmIil2I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199021)(36840700001)(40470700004)(46966006)(4326008)(36756003)(30864003)(2906002)(426003)(44832011)(336012)(8676002)(5660300002)(8936002)(40460700003)(41300700001)(40480700001)(86362001)(70206006)(70586007)(54906003)(478600001)(110136005)(316002)(6666004)(82740400003)(186003)(83380400001)(356005)(1076003)(36860700001)(47076005)(82310400005)(2616005)(81166007)(26005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 09:57:54.3966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbf7abc-7ab0-4ebb-f88b-08db56bd2f4b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4939
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio-cdx driver enables IOCTLs for user space to query
MMIO regions for CDX devices and mmap them. This change
also adds support for reset of CDX devices. With VFIO
enabled on CDX devices, user-space applications can also
exercise DMA securely via IOMMU on these devices.

This change adds the VFIO CDX driver and enables the following
ioctls for CDX devices:
 - VFIO_DEVICE_GET_INFO:
 - VFIO_DEVICE_GET_REGION_INFO
 - VFIO_DEVICE_RESET

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Tested-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
---

Changes v5->v6:
- removed forward declaration of vfio_cdx_driver
- removed un-necessary CDX_DRIVER_OVERRIDE_DEVICE_VFIO and
  vfio_cdx_regions_cleanup.
- removed unrequired dev_warn/dev_err
- used module_driver instead of module_init/exit

Changes v4->v5:
- renamed vfio_cdx.c to main.c and vfio_cdx_private.h
  to private.h
- have separate functions for get_info and get_region_info

Changes v3->v4:
- fix vfio info flags

Changes v2->v3:
- removed redundant init and release functions
- removed redundant dev and cdx_dev from vfio_cdx_device
- added support for iommufd
- added VFIO_DEVICE_FLAGS_CDX
- removed unrequried WARN_ON
- removed unused ioaddr

Changes v1->v2:
- Updated file2alias to support vfio_cdx
- removed some un-necessary checks in mmap
- removed vfio reset wrapper API
- converted complex macros to static APIs
- used pgprot_device and io_remap_pfn_range

 MAINTAINERS                       |   7 +
 drivers/vfio/Kconfig              |   1 +
 drivers/vfio/Makefile             |   1 +
 drivers/vfio/cdx/Kconfig          |  17 +++
 drivers/vfio/cdx/Makefile         |   8 +
 drivers/vfio/cdx/main.c           | 234 ++++++++++++++++++++++++++++++
 drivers/vfio/cdx/private.h        |  28 ++++
 include/linux/cdx/cdx_bus.h       |   1 -
 include/linux/mod_devicetable.h   |   6 +
 include/uapi/linux/vfio.h         |   1 +
 scripts/mod/devicetable-offsets.c |   1 +
 scripts/mod/file2alias.c          |  17 ++-
 12 files changed, 320 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/cdx/Kconfig
 create mode 100644 drivers/vfio/cdx/Makefile
 create mode 100644 drivers/vfio/cdx/main.c
 create mode 100644 drivers/vfio/cdx/private.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a72b8fcea261..d6d1ddb854d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22096,6 +22096,13 @@ F:	Documentation/filesystems/vfat.rst
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
index 000000000000..cd4a2e6fe609
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
+vfio-cdx-objs := main.o
diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
new file mode 100644
index 000000000000..f03f491e0435
--- /dev/null
+++ b/drivers/vfio/cdx/main.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/vfio.h>
+#include <linux/cdx/cdx_bus.h>
+
+#include "private.h"
+
+static int vfio_cdx_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
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
+static void vfio_cdx_close_device(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+
+	kfree(vdev->regions);
+	cdx_dev_reset(core_vdev->dev);
+}
+
+static int vfio_cdx_ioctl_get_info(struct vfio_cdx_device *vdev,
+				   struct vfio_device_info __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_device_info, num_irqs);
+	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
+	struct vfio_device_info info;
+
+	if (copy_from_user(&info, arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	info.flags = VFIO_DEVICE_FLAGS_CDX;
+	info.flags |= VFIO_DEVICE_FLAGS_RESET;
+
+	info.num_regions = cdx_dev->res_count;
+	info.num_irqs = 0;
+
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
+}
+
+static int vfio_cdx_ioctl_get_region_info(struct vfio_cdx_device *vdev,
+					  struct vfio_region_info __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
+	struct vfio_region_info info;
+
+	if (copy_from_user(&info, arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	if (info.index >= cdx_dev->res_count)
+		return -EINVAL;
+
+	/* map offset to the physical address */
+	info.offset = vfio_cdx_index_to_offset(info.index);
+	info.size = vdev->regions[info.index].size;
+	info.flags = vdev->regions[info.index].flags;
+
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
+}
+
+static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
+			   unsigned int cmd, unsigned long arg)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+		return vfio_cdx_ioctl_get_info(vdev, uarg);
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return vfio_cdx_ioctl_get_region_info(vdev, uarg);
+	case VFIO_DEVICE_RESET:
+		return cdx_dev_reset(core_vdev->dev);
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
+	struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
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
+	.open_device	= vfio_cdx_open_device,
+	.close_device	= vfio_cdx_close_device,
+	.ioctl		= vfio_cdx_ioctl,
+	.mmap		= vfio_cdx_mmap,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
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
+	if (ret)
+		goto out_uninit;
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
+	struct vfio_cdx_device *vdev = dev_get_drvdata(dev);
+
+	vfio_unregister_group_dev(&vdev->vdev);
+	vfio_put_device(&vdev->vdev);
+
+	return 0;
+}
+
+static const struct cdx_device_id vfio_cdx_table[] = {
+	{ CDX_DEVICE_DRIVER_OVERRIDE(CDX_ANY_ID, CDX_ANY_ID,
+				     CDX_ID_F_VFIO_DRIVER_OVERRIDE) }, /* match all by default */
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
+module_driver(vfio_cdx_driver, cdx_driver_register, cdx_driver_unregister);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("VFIO for CDX devices - User Level meta-driver");
diff --git a/drivers/vfio/cdx/private.h b/drivers/vfio/cdx/private.h
new file mode 100644
index 000000000000..8bdc117ea88e
--- /dev/null
+++ b/drivers/vfio/cdx/private.h
@@ -0,0 +1,28 @@
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
+};
+
+struct vfio_cdx_device {
+	struct vfio_device	vdev;
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
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..8e91aaf973e7 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -213,6 +213,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
 #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
 #define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
+#define VFIO_DEVICE_FLAGS_CDX	(1 << 8)	/* vfio-cdx device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
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

