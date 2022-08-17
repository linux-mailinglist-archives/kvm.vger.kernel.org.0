Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86205972A7
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbiHQPGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240791AbiHQPGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:06:30 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FD0642F6;
        Wed, 17 Aug 2022 08:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpHXDGG7cdn98Hfo+cBSYLRcKdww2xPL1ehLteeciWn7rRxXOyh3CPqhtOkLecNwc9HgoQ4+rK8ebw6Uky3w8/DR44HDOkijrVJALDYotKxzV23IDXiTtjh820kdH+GU/nzgITMK8nSsZiHslNO+Jfl5yLxi/QX9d+/WAe9LVVVsawaRvZ4XbTzeOXrvbmbdTEAzZ70NT/4h7Cg2bOws9zNuKI1GMY9wDNws2sseJ77SNMwda0iLjQ4NgH/xuUppcgTYa6lfDdZTo9B6PjSX8xw4wtz+1clRs8EZnDZCoc0/tA1hYBbwbtYSkLXzk1eZKj+XwUf0A1EWr72SaT+F2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hkt0XasYX4ZqBxeN1sxAb5XphuclOa/pqn5Cx6zfYNg=;
 b=nbm5PI6ZE0hLqd1NHTyPwCPDvB2JwNWkg7+S9DWOQcgKjZ93dQNFCTpOqZK21hyH0O2k91ZjaacB+fCsdFJfXjW9rmYLH558ZDV30Xc/GVs7oquaOMt0eYdYrQJbpCILrCu1vKAcTGIMF95MNMy3F2nlHNpB/Sl6OF18XBvqBBcBUVz/0fM3paAHUcwn5LBoW1+1+LPNKDDbXrMjy6w/FErG6cwzbRyZXaFpdzc4N0Kq/CpOKuWyQBoTmWA68UzubnDurlA1Id6oXH0PmQCGb6sn73GjzUPvYt3OFqdVx2/aLxSIn6nAmUm1SjNnyqIqQrK/ykcm3P2RGJ96NPhT1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hkt0XasYX4ZqBxeN1sxAb5XphuclOa/pqn5Cx6zfYNg=;
 b=X9eiMP9zC3eR/EFlij4xngOzzrU7UawBSi4cOSbvhKUb66RwxntrhkFhXvpUHJ2NepWKnSa59+vGMgXcxulzY1wd298gDwmQzzXFjnIyiCsF0oJamRYGpYHPB/p4N9a0gQ8tSGbb5IJtjoWLhJHTNCx/qUCRHAGCPmMNN5j46wo=
Received: from MW2PR2101CA0019.namprd21.prod.outlook.com (2603:10b6:302:1::32)
 by BL0PR12MB4945.namprd12.prod.outlook.com (2603:10b6:208:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 15:06:21 +0000
Received: from CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::32) by MW2PR2101CA0019.outlook.office365.com
 (2603:10b6:302:1::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.4 via Frontend
 Transport; Wed, 17 Aug 2022 15:06:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT091.mail.protection.outlook.com (10.13.175.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5546.7 via Frontend Transport; Wed, 17 Aug 2022 15:06:21 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 10:06:15 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Wed, 17 Aug 2022 10:06:08 -0500
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
Subject: [RFC PATCH v2 3/6] bus/cdx: add cdx-MSI domain with gic-its domain as parent
Date:   Wed, 17 Aug 2022 20:35:39 +0530
Message-ID: <20220817150542.483291-4-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817150542.483291-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbf0ef30-0df3-4fc2-7a1d-08da80620b9c
X-MS-TrafficTypeDiagnostic: BL0PR12MB4945:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6NdsGKParlVDpOmqiByxatPl7zQ+brCrtk2u2wFLQNHlak0xeurR1aquznEdOqwe+f6QDvo3beD5801jIUunzGZZDFqm0x3LatW4ldxo/OdTvoy4GR+AUTWvy4GwZbu0rh6+/MFRdj/G97iM3/Sw1I3RYilRJwwOQ69kk16L9P1Ruv8kLyR0nOS9eybxX7WFCfWpq0dKv/3JKYQt70k6i7HDRRtvNsuCvdc284BiXmX62sUlCi47gUVkOPD340YjR3j5ho0jXneMmaFkSO0h8tyZl+uFRP+Hb4MlWlQ8ViyISjrHXi8BZo11xJHl4qM1JbVE3ozkk0AbxLh6e8GNboNlHh9A5sMZzBkPXZZC2RFhdROxcyau/BmZyadtPDHIF9VaCPXRxOWlv2zMpiATfigEcKrbcKQ3DNBTu2OY56jY/MMdoRKzpWjYiqKOHAf9sCRXAVflPEEGyO+oeodp15t3144MpueRJfmwIdZZ4uxL1yMdY6qqSUHiRPf4SVKLs4N5xn81O1A5Rm1eAMD89EqEr3BkwC5WekYRWJEQaUEHZpdY/1v+2HiDAjR1r6m4E3cFVQDdUR+Ah7qSI1F4fguaXQkq1C6K9d1kN2jbcbFnMk2BZaQBVkIk3uxL+BrcrbPAnQrFATlrCgGBbbjQsz5Bv9ktGu0cBNR+p9SF6Z1jDhcjj6/qSvT2xLPBTxHpyl6FeJNY+M3n3dSZ8JIq6OV9ac4ziNzv378bYyXW7jLldOy6B6K+OfgyHqLy9Zoc4mIuwNxB85n15HDqF4B/Mwg5PAbwxoH7ukmQchmrSm1eSEmrt6mNMaLY80P6MCTHc3Tp3vKhTd80s93KIhR29d/Ben3O0ts/CjMR3RcCl3cQvLrgxFMRyf4ngxd7PQEqlNFZLg9VUtZb23E66NrihA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(40470700004)(36840700001)(8676002)(316002)(4326008)(36860700001)(54906003)(70206006)(40480700001)(70586007)(40460700003)(2906002)(82740400003)(44832011)(8936002)(82310400005)(7416002)(81166007)(921005)(5660300002)(356005)(36756003)(86362001)(186003)(41300700001)(47076005)(336012)(426003)(6666004)(26005)(1076003)(83380400001)(478600001)(110136005)(2616005)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:06:21.4426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf0ef30-0df3-4fc2-7a1d-08da80620b9c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4945
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Devices on cdx bus are dynamically detected and registered using
platform_device_register API. As these devices are not linked to
of node they need a separate MSI domain for handling device ID
to be provided to the GIC ITS domain.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Signed-off-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
---
 drivers/bus/cdx/Makefile         |  2 +-
 drivers/bus/cdx/cdx.c            | 31 +++++++++++
 drivers/bus/cdx/cdx.h            | 16 ++++++
 drivers/bus/cdx/cdx_msi_domain.c | 90 ++++++++++++++++++++++++++++++++
 4 files changed, 138 insertions(+), 1 deletion(-)
 create mode 100644 drivers/bus/cdx/cdx_msi_domain.c

diff --git a/drivers/bus/cdx/Makefile b/drivers/bus/cdx/Makefile
index c9cee5b6fa8a..5dc7874530f5 100644
--- a/drivers/bus/cdx/Makefile
+++ b/drivers/bus/cdx/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_CDX_BUS) += cdx-bus-device-driver.o
 
-cdx-bus-device-driver-objs := cdx.o
+cdx-bus-device-driver-objs := cdx.o cdx_msi_domain.o
diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
index f28329770af8..cd916ef5f2bc 100644
--- a/drivers/bus/cdx/cdx.c
+++ b/drivers/bus/cdx/cdx.c
@@ -15,7 +15,9 @@
 #include <linux/of_platform.h>
 #include <linux/dma-mapping.h>
 #include <linux/property.h>
+#include <linux/msi.h>
 #include <linux/cdx/cdx_bus.h>
+#include "cdx.h"
 
 #include "cdx.h"
 
@@ -47,6 +49,8 @@ static int cdx_populate_one(struct platform_device *pdev_parent,
 
 	dev_data.bus_id = dev_params->bus_id;
 	dev_data.func_id = dev_params->func_id;
+	dev_data.dev_id = dev_params->msi_device_id;
+	dev_data.num_msi = dev_params->num_msi;
 
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
 	pdevinfo.fwnode = swnode;
@@ -76,6 +80,10 @@ static int cdx_populate_one(struct platform_device *pdev_parent,
 		goto out;
 	}
 
+	/* Set the MSI domain */
+	dev_set_msi_domain(&new_pdev->dev,
+			   irq_find_host(pdev_parent->dev.of_node));
+
 	return 0;
 
 out:
@@ -109,8 +117,22 @@ static int cdx_bus_device_discovery(struct platform_device *pdev)
 	int num_cdx_bus = 0, num_cdx_func = 0;
 	int bus_id = 0, func_id = 0;
 	struct device_node *np = pdev->dev.of_node;
+	struct irq_domain *cdx_msi_domain;
 	int ret;
 
+	/* If CDX MSI domain is not created, create one. */
+	cdx_msi_domain = irq_find_host(pdev->dev.of_node);
+	if (!cdx_msi_domain) {
+		np = pdev->dev.of_node;
+
+		ret = cdx_msi_domain_init(&pdev->dev, np->full_name);
+		if (ret != 0) {
+			dev_err(&pdev->dev,
+				"cdx_msi_domain_init() failed: %d", ret);
+			return ret;
+		}
+	}
+
 	/* TODO: Get number of busses from firmware */
 	num_cdx_bus = 1;
 
@@ -144,7 +166,16 @@ static int cdx_bus_device_discovery(struct platform_device *pdev)
 					ret);
 				goto fail;
 			}
+			ret = of_map_id(np, req_id, "msi-map", "msi-map-mask",
+					NULL, &dev_params.msi_device_id);
+			if (ret != 0) {
+				dev_err(&pdev->dev,
+					"of_map_id failed for MSI: %d\n",
+					ret);
+				goto fail;
+			}
 
+			dev_params.num_msi = 2;
 			dev_params.dev_type_idx = 0;
 			dev_params.res_cnt = 1;
 
diff --git a/drivers/bus/cdx/cdx.h b/drivers/bus/cdx/cdx.h
index 7db8b06de9cd..da2c282d4d93 100644
--- a/drivers/bus/cdx/cdx.h
+++ b/drivers/bus/cdx/cdx.h
@@ -19,6 +19,8 @@ struct cdx_dev_params_t {
 	struct resource res[CDX_DEV_NUM_RESOURCES];
 	int res_cnt;
 	u32 stream_id;
+	u32 msi_device_id;
+	u32 num_msi;
 };
 
 /**
@@ -26,10 +28,24 @@ struct cdx_dev_params_t {
  *	CDX device.
  * @bus_id: Bus ID for reset
  * @func_id: Function ID for reset
+ * @dev_id: Device ID for MSI.
+ * @num_msi: Number of MSI supported by the device
  */
 struct cdx_device_data {
 	u32 bus_id;
 	u32 func_id;
+	u32 dev_id;
+	u32 num_msi;
 };
 
+/**
+ * cdx_msi_domain_init - Init the CDX bus MSI domain.
+ * @cbus_dev: Device of the CDX bus
+ * @name: Name to be assigned to the newly created domain
+ *
+ * Return 0 on success, <0 on failure
+ */
+int cdx_msi_domain_init(struct device *cdev_bus,
+			 const char *name);
+
 #endif /* _CDX_H_ */
diff --git a/drivers/bus/cdx/cdx_msi_domain.c b/drivers/bus/cdx/cdx_msi_domain.c
new file mode 100644
index 000000000000..44472ae02d1c
--- /dev/null
+++ b/drivers/bus/cdx/cdx_msi_domain.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CDX bus driver MSI support
+ *
+ * Copyright(c) 2022 Xilinx.
+ *
+ */
+
+#include <linux/irq.h>
+#include <linux/msi.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_irq.h>
+
+#include "cdx.h"
+
+static struct irq_chip cdx_msi_irq_chip = {
+	.name = "CDX-MSI",
+	.irq_mask = irq_chip_mask_parent,
+	.irq_unmask = irq_chip_unmask_parent,
+	.irq_eoi = irq_chip_eoi_parent,
+	.irq_set_affinity = msi_domain_set_affinity
+};
+
+static int cdx_msi_prepare(struct irq_domain *msi_domain,
+		struct device *dev,
+		int nvec, msi_alloc_info_t *info)
+{
+	struct msi_domain_info *msi_info;
+	struct cdx_device_data *dev_data;
+	u32 dev_id;
+
+	/* Retrieve device ID from platform data */
+	dev_data = dev->platform_data;
+	dev_id = dev_data->dev_id;
+
+	/* Set the device Id to be passed to the GIC-ITS */
+	info->scratchpad[0].ul = dev_id;
+
+	msi_info = msi_get_domain_info(msi_domain->parent);
+
+	/* Allocate at least 32 MSIs, and always as a power of 2 */
+	nvec = max_t(int, 32, roundup_pow_of_two(nvec));
+	return msi_info->ops->msi_prepare(msi_domain->parent, dev, nvec, info);
+}
+
+static struct msi_domain_ops cdx_msi_ops __ro_after_init = {
+	.msi_prepare = cdx_msi_prepare,
+};
+
+static struct msi_domain_info cdx_msi_domain_info = {
+	.flags	= (MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS),
+	.ops	= &cdx_msi_ops,
+	.chip	= &cdx_msi_irq_chip,
+};
+
+int cdx_msi_domain_init(struct device *cbus_dev,
+		const char *name)
+{
+	struct irq_domain *parent;
+	struct irq_domain *cdx_msi_domain;
+	struct fwnode_handle *fwnode_handle;
+	struct device_node *parent_node;
+	struct device_node *np;
+
+	np = cbus_dev->of_node;
+	parent_node = of_parse_phandle(np, "msi-map", 1);
+
+	parent = irq_find_matching_fwnode(of_node_to_fwnode(parent_node),
+			DOMAIN_BUS_NEXUS);
+	if (!parent || !msi_get_domain_info(parent)) {
+		dev_err(cbus_dev, "%s: unable to locate ITS domain\n", name);
+		return -ENODEV;
+	}
+
+	fwnode_handle = of_node_to_fwnode(np);
+	cdx_msi_domain = platform_msi_create_irq_domain(fwnode_handle,
+						&cdx_msi_domain_info,
+						parent);
+	if (!cdx_msi_domain) {
+		dev_err(cbus_dev, "%s: unable to create cdx bus domain\n",
+			name);
+		return -1;
+	}
+
+	dev_info(cbus_dev, "cdx bus MSI: %s domain created\n", name);
+
+	return 0;
+}
-- 
2.25.1

