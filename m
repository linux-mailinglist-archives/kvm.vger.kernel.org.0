Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B68F5972B9
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240835AbiHQPGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240806AbiHQPGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:06:39 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485DF9D8DF;
        Wed, 17 Aug 2022 08:06:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6PDM0eOkUDj9xIKaK9UoURUtQcu2oKJm50c0BCqAHTkkwBZwf9KNLLhcWCi4txXR6bLt/6hBCTF5MYt+iH4UBm/8ARQfnGqn6xxjAH+rTcBg+xVm017LfWZefVHQdiyz78J2b4JeujE5YyhnfSS+hoG6Z7HrECjRAKPjbuvOAEiJRHJ2HmC9J9ivptgduQj2ww/FEKmylV5Vc2VnResQr8Dt4kEc5MY8uymbVXaTeUjTClmVf3binH8Q8X7AQXEiV1+fyX1DStN5BWwnnrZn3Ardk30VhKx/KZg3OGIQsaiPBCEPsg4wuyxBijke+rxQPiZxpzjl1vxTiuvA/eg1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilBa/HzkzngUmD+olqRPylzU1Ftm0aNrIXpPJUM0dXM=;
 b=Akh8ik+WV99Ebi2I9A55LRvK1EVebRq0sZBzx0Rqc1hlKMfTFF6fKq18ISxYtaPNvQYUmWE1uM2Bk1ng35L7fiikF0rpT23qtQHEA/3S/IIFrDJ05dFdst6S1GSuOEfov5BV14KdQVuSpXbo4ndysHbv4FkaASXzSuWcAQkEvAqyDEK3uMSKtUGcBFpVzKANZ1KbxFN41B2AE+pzUgYuDK+4wmHJYG+R/4dnY2nsz/owDWrb4PM+SgYJKdN1weOE7ULme/kCtn26sCchZ52dOqCqtTyrggsO83gM+QaatQZKO5Fq6JfWq63Tkfpm0zcPI8dZQfChlL72fEkWHEy94Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilBa/HzkzngUmD+olqRPylzU1Ftm0aNrIXpPJUM0dXM=;
 b=wqzrVuJpGJI3w8ODMGVSO24IhxGChohdVHOmO6FBTUz9m1SHXaC8nrwBiivb2AX+MLsyZdBz0uoAOT07gqzfXTbXbJtxNG3GklQJWk5Ral9Yav+6MVGL58iXztbRhGRlsAyFbkKHYJaOhJCN+2OiDHSdeRtR5zyLxNk80KeZoxU=
Received: from MW4PR04CA0033.namprd04.prod.outlook.com (2603:10b6:303:6a::8)
 by DM6PR12MB4960.namprd12.prod.outlook.com (2603:10b6:5:1bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 15:06:34 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::16) by MW4PR04CA0033.outlook.office365.com
 (2603:10b6:303:6a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.12 via Frontend
 Transport; Wed, 17 Aug 2022 15:06:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 15:06:34 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 10:06:32 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 08:06:32 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Wed, 17 Aug 2022 10:06:24 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v2 5/6] vfio: platform: reset: add reset for cdx devices
Date:   Wed, 17 Aug 2022 20:35:41 +0530
Message-ID: <20220817150542.483291-6-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817150542.483291-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b8a3961-c4f5-4fd7-928b-08da80621348
X-MS-TrafficTypeDiagnostic: DM6PR12MB4960:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SRtwl9Jlfh73ikpRk+hC4ovAeHcKOpNDh9WkQpspkwqNUBYoe3krXCTJloGgpuiBeaVwvEOLJw5R7L258AjsyqVFzqYrMWwqey3r/GGmBvZfndbmRw7WpeY8qQWrfki0mdkQk8O3d2eQZeQhVdHLcPR0/2c60O42LaW6KhHgZE++gocZlX/fsU1vpAbbbWiKuopnf3W5VZfxEhyU3axVTni5ocEeaMF0XEWwmUCCPCrtCCrM8KGlhtEJ7DgFwrOMDdlsRlwvgBvEwmKs7hoA4hywKHuDym4VEfbdWnquMkByBQSxH9f/GMW2y7iEbZKw/wYzpWuQgPJfnmYAEB7w1XyOrMhawqOC/S2gslUSpZmJsr2ZkyTuEvXqg8Q7o/YVBBruxU2nIu0Ys54I1Q2SFAZSo6vZGy+PhrsI7Tngc1/5c2svVbQNEYb65I3sObwkn/kV4U+WzIf8FXhHPAQuAFXSEFMgvh3YEh/3XnnTqWls9EmsRrVq57gL0Nz8bTdxeQBkUJvwLxQxLIJVsMl6FS6t8EbaeecHAzXZT0NgNZNkC6tbQvO0awF/oW2LWqmvbe6IAxYtrQuZpvhjNjyXmn6Leu/wx5z40wDV1QtGH35JSWpaWPSD/xz5AtSfqtNhZOp8UH3/c3BbB7xwjPeOqjQPOc21poX/DxwZ6Jj489KBh1arRsBs9hgavxW3cAOw2s9lj9eJGDPsIjQ10rXHW51WGifohcBh2DxvWWwuMDaTtovqziaK6PJuWJAB3THqjpar9B38i1STppXePqUBdLXRbcoANlAXDt27pXRqbyh74E3tC4KslgxBOGH+6tlY93I/hI6y7wQ86yppKATIqFfbTeo0ci8aMv8nrSD8veGDn1ZKPHDK5HzkbcilqkxliGTSSB3GsLMXzVNEnXhRA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(46966006)(40470700004)(36840700001)(7416002)(44832011)(2906002)(82310400005)(70586007)(4326008)(8676002)(70206006)(110136005)(54906003)(86362001)(316002)(81166007)(921005)(5660300002)(40480700001)(356005)(36756003)(83380400001)(8936002)(36860700001)(478600001)(336012)(426003)(47076005)(26005)(1076003)(41300700001)(82740400003)(6666004)(186003)(2616005)(40460700003)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:06:34.3145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8a3961-c4f5-4fd7-928b-08da80621348
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4960
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a VFIO reset module that registers and
implements basic reset functionality for CDX based platform
devices. It interfaces with the CDX bus controller to
register all the types of devices supported on the CDX bus,
and uses CDX bus interface to reset the device.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 MAINTAINERS                                   |   1 +
 drivers/bus/cdx/cdx.c                         |  42 +++++++
 drivers/vfio/platform/reset/Kconfig           |   8 ++
 drivers/vfio/platform/reset/Makefile          |   1 +
 .../vfio/platform/reset/vfio_platform_cdx.c   | 106 ++++++++++++++++++
 include/linux/cdx/cdx_bus.h                   |  27 +++++
 6 files changed, 185 insertions(+)
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_cdx.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b0eea32dbb39..4794401f07c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22302,6 +22302,7 @@ M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
 F:	drivers/bus/cdx/*
+F:	drivers/vfio/platform/reset/vfio_platform_cdx.c
 
 XILINX GPIO DRIVER
 M:	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
index 5fb9a99b3c97..262db9071108 100644
--- a/drivers/bus/cdx/cdx.c
+++ b/drivers/bus/cdx/cdx.c
@@ -72,6 +72,48 @@ static ssize_t reset_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_WO(reset);
 
+int cdx_get_num_device_types(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_CDX_DEVICE_TYPES; i++)
+		if (strlen(dev_types[i].compat) == 0)
+			break;
+
+	return i;
+}
+
+int cdx_get_device_types(struct cdx_device_types_t *cdx_dev_types)
+{
+	int num_dev_types;
+
+	if (cdx_dev_types == NULL) {
+		pr_err("Invalid argument to %s\n", __func__);
+		return -EINVAL;
+	}
+
+	num_dev_types = cdx_get_num_device_types();
+
+	memcpy(cdx_dev_types, &dev_types[0], (num_dev_types *
+		sizeof(struct cdx_device_types_t)));
+
+	return num_dev_types;
+}
+
+int cdx_dev_reset(struct device *dev)
+{
+	return reset_cdx_device(dev, NULL);
+}
+
+int cdx_dev_num_msi(struct device *dev)
+{
+	struct cdx_device_data *dev_data;
+
+	/* Retrieve number of MSI from platform data */
+	dev_data = dev->platform_data;
+	return dev_data->num_msi;
+}
+
 static int cdx_populate_one(struct platform_device *pdev_parent,
 		struct cdx_dev_params_t *dev_params)
 {
diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
index 12f5f3d80387..bbbee3f7f5ca 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -21,3 +21,11 @@ config VFIO_PLATFORM_BCMFLEXRM_RESET
 	  Enables the VFIO platform driver to handle reset for Broadcom FlexRM
 
 	  If you don't know what to do here, say N.
+
+config VFIO_PLATFORM_CDXDEV_RESET
+	tristate "VFIO support for cdx devices reset"
+	default n
+	help
+	  Enables the VFIO platform driver to handle reset for devices on CDX bus
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
index 7294c5ea122e..1b1f65945934 100644
--- a/drivers/vfio/platform/reset/Makefile
+++ b/drivers/vfio/platform/reset/Makefile
@@ -5,3 +5,4 @@ vfio-platform-amdxgbe-y := vfio_platform_amdxgbe.o
 obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
 obj-$(CONFIG_VFIO_PLATFORM_AMDXGBE_RESET) += vfio-platform-amdxgbe.o
 obj-$(CONFIG_VFIO_PLATFORM_BCMFLEXRM_RESET) += vfio_platform_bcmflexrm.o
+obj-$(CONFIG_VFIO_PLATFORM_CDXDEV_RESET) += vfio_platform_cdx.o
diff --git a/drivers/vfio/platform/reset/vfio_platform_cdx.c b/drivers/vfio/platform/reset/vfio_platform_cdx.c
new file mode 100644
index 000000000000..10bb27379205
--- /dev/null
+++ b/drivers/vfio/platform/reset/vfio_platform_cdx.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VFIO platform driver specialized for reset of devices on AMD CDX bus.
+ *
+ * Copyright(C) 2022 Xilinx Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <uapi/linux/mdio.h>
+#include <linux/cdx/cdx_bus.h>
+
+#include "../vfio_platform_private.h"
+
+static int vfio_platform_cdxdev_reset(struct vfio_platform_device *vdev)
+{
+	return cdx_dev_reset(vdev->device);
+}
+
+static struct vfio_platform_reset_node *vfio_platform_cdxdev_reset_nodes;
+
+static int __init vfio_platform_cdxdev_reset_module_init(void)
+{
+	struct cdx_device_types_t *cdx_dev_types;
+	struct vfio_platform_reset_node *reset_node;
+	int num_dev_types, ret, i;
+
+	ret = cdx_get_num_device_types();
+	if (ret < 0) {
+		pr_err("cdx_get_num_device_types failed: %d\n", ret);
+		return ret;
+	}
+	num_dev_types = ret;
+
+	vfio_platform_cdxdev_reset_nodes = kcalloc(num_dev_types,
+			sizeof(struct vfio_platform_reset_node), GFP_KERNEL);
+	if (IS_ERR_OR_NULL(vfio_platform_cdxdev_reset_nodes)) {
+		pr_err("memory allocation for cdxdev_reset_nodes failed\n");
+		return -ENOMEM;
+	}
+
+	cdx_dev_types = kcalloc(num_dev_types,
+				sizeof(struct cdx_device_types_t), GFP_KERNEL);
+	if (IS_ERR_OR_NULL(cdx_dev_types)) {
+		pr_err("memory allocation for cdx_dev_types failed\n");
+		kfree(vfio_platform_cdxdev_reset_nodes);
+		return -ENOMEM;
+	}
+
+	ret = cdx_get_device_types(cdx_dev_types);
+	if (ret < 0) {
+		pr_err("cdx_get_devices_info failed: %d\n", ret);
+		kfree(vfio_platform_cdxdev_reset_nodes);
+		kfree(cdx_dev_types);
+		return ret;
+	}
+
+	for (i = 0; i < num_dev_types; i++) {
+		reset_node = &vfio_platform_cdxdev_reset_nodes[i];
+		reset_node->owner = THIS_MODULE;
+
+		reset_node->compat =
+				kzalloc(strlen(cdx_dev_types[i].compat + 1),
+				GFP_KERNEL);
+		memcpy(reset_node->compat, cdx_dev_types[i].compat,
+				MAX_CDX_COMPAT_LEN);
+
+		reset_node->of_reset = vfio_platform_cdxdev_reset;
+
+		__vfio_platform_register_reset(reset_node);
+	}
+	kfree(cdx_dev_types);
+
+	return 0;
+}
+
+static void __exit vfio_platform_cdxdev_reset_module_exit(void)
+{
+	struct vfio_platform_reset_node *reset_node;
+	int num_dev_types, ret, i;
+
+	ret = cdx_get_num_device_types();
+	if (ret < 0) {
+		pr_err("cdx_get_num_device_types failed: %d\n", ret);
+		return;
+	}
+
+	num_dev_types = ret;
+	for (i = 0; i < num_dev_types; i++) {
+		reset_node = &vfio_platform_cdxdev_reset_nodes[i];
+		vfio_platform_unregister_reset(reset_node->compat,
+					       vfio_platform_cdxdev_reset);
+		kfree(reset_node->compat);
+	}
+	kfree(vfio_platform_cdxdev_reset_nodes);
+}
+
+module_init(vfio_platform_cdxdev_reset_module_init);
+module_exit(vfio_platform_cdxdev_reset_module_exit);
+
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nipun Gupta<nipun.gupta@amd.com>");
+MODULE_DESCRIPTION("Reset support for cdx devices");
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
index 7c6ad7dfe97a..47c60edb49fd 100644
--- a/include/linux/cdx/cdx_bus.h
+++ b/include/linux/cdx/cdx_bus.h
@@ -23,4 +23,31 @@ struct cdx_device_types_t {
 	char compat[MAX_CDX_COMPAT_LEN];
 };
 
+/**
+ * cdx_get_num_device_types - Get total number of CDX device types.
+ *
+ * Return number of types of devices, -errno on failure
+ */
+int cdx_get_num_device_types(void);
+
+/**
+ * cdx_get_device_types - Get info related to all types of devices
+ *	supported on the CDX bus.
+ * @cdx_dev_types: Pointer to cdx_devices_type_t structure.
+ *	Memory for this structure should be allocated by the
+ *	caller, where the memory allocated should be more than
+ *	available_device_types * sizeof(struct cdx_device_types_t).
+ *
+ * Return number of types of devices, -errno on failure
+ */
+int cdx_get_device_types(struct cdx_device_types_t *cdx_dev_types);
+
+/**
+ * cdx_dev_reset - Reset CDX device
+ * @dev: device pointer
+ *
+ * Return 0 for success, -errno on failure
+ */
+int cdx_dev_reset(struct device *dev);
+
 #endif /* _CDX_H_ */
-- 
2.25.1

