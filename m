Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806455972AC
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240661AbiHQPHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240817AbiHQPGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:06:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037759DFB9;
        Wed, 17 Aug 2022 08:06:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcLR50ZWSswLMXDKAlyDC19DaRe3H3kP3qsPJRWGlQZrQBKaVqb/aspA17BE9X5JOXwg95jz8gqOsGjCjas95R3UNgSx9KLEFuxfqniJ+aSN4N8l/sJqbpoBXKkbrI0EBEahpeHSsNKGfTRGE2nOnhAmvXTLZrXipzWTrFx+dsOee4kigXwK+FMEfD9Zryc2mZZoD7mN8D4ku8v7eYQRKz011O2VLgZy09Qe6wO0PrZHQsxYQzw88v7j4ycCkGfzaCjyVuPGt0BK4PDhikd/UzU11jYTrzGpkxwIHTgTswyc7lpWjVH2fqrCfd3OQlv4V5PxGlenEOnpVtqJE9LYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//oiSzAS0jJBwvU06tDO4CuF/ujd7/cvmMMeLpSvxaQ=;
 b=Ko6CjpTJ/FCXxMQQkXONHqzBA5HRHJltQx35gEL6yTn450fOWM0F7pDyPfxDNcc//BQpkRWEQWwYEBVhgPmrmNpE2IlkuprTItlKBCqYmu1Zj1b8xTWXfBOJtdU6ac3tjLOEv0WlKCe6iHJp/KyBr52KYXuG5RJirYnRO7rpY/1JGClYyHQ6IDbqu8BLcXuaD/dMLpLzieFdjE846k9MwwFgZeZDZnuU2tZXqIH96EXFXFhryAWYqTUg5+N1G81mWrM8CVfthh8RQYDBtXR7o8Aw+IpbOXGx0b7mP6qdfaJXJ8HSruB6HziwxMnm93WpzNrCROU5m/ZabuFiMA1FLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//oiSzAS0jJBwvU06tDO4CuF/ujd7/cvmMMeLpSvxaQ=;
 b=LNVqZEVebs/XXMp9odR/CcCnrOsh6+tVRaAhsVZzH2LcD2d4/g6nyaNLttl1oz6MDf+f4DIBNdcEd+CSFj8fBpPiwPwJpJsDXwPTw+s/NLp5r9c5EnrcKAvx1hdDaaGU55FWNIC8MRUuNnz9iZl1Hznwa/ucc6Ux0Xqws0IbGbI=
Received: from MW2PR2101CA0003.namprd21.prod.outlook.com (2603:10b6:302:1::16)
 by BN6PR12MB1203.namprd12.prod.outlook.com (2603:10b6:404:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 17 Aug
 2022 15:06:37 +0000
Received: from CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::c0) by MW2PR2101CA0003.outlook.office365.com
 (2603:10b6:302:1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.4 via Frontend
 Transport; Wed, 17 Aug 2022 15:06:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT091.mail.protection.outlook.com (10.13.175.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5546.7 via Frontend Transport; Wed, 17 Aug 2022 15:06:36 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 10:06:23 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Wed, 17 Aug 2022 10:06:16 -0500
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
Subject: [RFC PATCH v2 4/6] bus/cdx: add rescan and reset support
Date:   Wed, 17 Aug 2022 20:35:40 +0530
Message-ID: <20220817150542.483291-5-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817150542.483291-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0173809e-8eb4-4a24-dce3-08da806214cf
X-MS-TrafficTypeDiagnostic: BN6PR12MB1203:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bd67jDz+h8gzPhdQK2T4bUwiGUO50Qs0pnZfq2lj0LG31LqLlIaXMzWHIQQAu2M/ARCTxNK26G+YycBA8hm409PE4K7R+gket6/UEs55vwbxbcgdOgKQSnolAfK/ghkFnXReLeBtF/Sp+Wxi/ZECtYsE5XRdRm0tBl7dgBWd0ejwzPhaSzSoyyqS3uYI7dkDvKqryXMXzlQ95d3OLTS9Zo1b4LuYkPoam3l9OHu75ZCJmttrE9nesZ2xO20jovhxCnd/2GdfHHoa3zwWU+7+3PRAH8PDIm8ito9hs+fWwHoLP9oiYxhGis9BSpVV2lQUVZ0mnliPg1S5FXWompnzB/72hjnaSVAlv16KCWBJQvaIGQOwgWwT1py4J7MSMmRFLIkX8vpn9KofcVV1oOJzc7ob210bNZpkCs3FhjJBaWBZMksRrMdLkLNKYU+rP6gDjMjzrqox+ysi79VJoCMfqhUlp1yxpwRJ4g6y03f1hDQkc7BMTBSL33LrRmpQTyL9tad3QJzPM5BsEeWfqIYhpC9Nc5NFBoU79U5s2QOUCWwClHY4++K3fYD2kFElAaVDeRwy3H4OnODCHFE/PNIara+emEr4M80reiG3/HvQkrRZ0dPWILaCpjJqofnszfmzffGw+Lt9+3uIoCBlP0qvr3vUeUEBGA+q7fsOtzrhRaRhdd+xXQec7JbCQihyDEpyfPwktZHVfTr4dancLo9UiLLa0FaOltKXaR0DmR8ZATzjkLtExvjX97GIjRUTpfAVdg3ciU3vFbt2SnWVS/5pvnmOROcgMXowseNUr0sNWYbpuEUu4u8TBEjJB4qNxJmAGzzkxuVPpfgMqp3w2umfQNKkYxm19srDmx+SX9eFA1lT0UfmJ86Ztcn9SUj5ajP+Gco98zYSjzzzpA433+z/+A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(36840700001)(46966006)(40470700004)(54906003)(478600001)(6666004)(26005)(36756003)(110136005)(41300700001)(8936002)(2906002)(86362001)(40480700001)(82310400005)(40460700003)(7416002)(70586007)(8676002)(70206006)(4326008)(44832011)(316002)(36860700001)(5660300002)(186003)(83380400001)(356005)(82740400003)(81166007)(1076003)(2616005)(336012)(921005)(426003)(47076005)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:06:36.8788
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0173809e-8eb4-4a24-dce3-08da806214cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds te support for rescanning and reset
of the CDX buses, as well as option to optionally reset
any devices on the bus.

Sysfs entries are provided in CDX controller:
- rescan of the CDX controller.
- reset all the devices present on CDX buses.

Sysfs entry is provided in each of the platform device
detected by the CDX controller
- reset of the device.

Signed-off-by: Puneet Gupta <puneet.gupta@amd.com>
Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 Documentation/ABI/testing/sysfs-bus-cdx | 34 +++++++++++
 drivers/bus/cdx/cdx.c                   | 81 ++++++++++++++++++++++++-
 2 files changed, 113 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-cdx

diff --git a/Documentation/ABI/testing/sysfs-bus-cdx b/Documentation/ABI/testing/sysfs-bus-cdx
new file mode 100644
index 000000000000..8a20b50a449f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-cdx
@@ -0,0 +1,34 @@
+What:		/sys/devices/platform/cdxbus/rescan
+Date:		August 2022
+Contact:	puneet.gupta@amd.com
+Description:
+		Writing 1 to this would cause rescan of the bus
+		and devices on the CDX bus. Any new devices would
+		be scanned and added to the list of linux devices
+		and any devices removed are also deleted from linux.
+
+                For example::
+
+		  # echo 1 > /sys/devices/platform/cdxbus/rescan
+
+What:		/sys/devices/platform/cdxbus/reset_all
+Date:		August 2022
+Contact:	puneet.gupta@amd.com
+Description:
+		Writing 1 to this would reset all the devices present
+		on the CDX bus
+
+                For example::
+
+		  # echo 1 > /sys/devices/platform/cdxbus/reset_all
+
+What:		/sys/devices/platform/cdxbus/<device>/reset
+Date:		August 2022
+Contact:	puneet.gupta@amd.com
+Description:
+		Writing 1 to this would reset the specific device
+		for which the reset is set.
+
+                For example::
+
+		  # echo 1 > /sys/devices/platform/cdxbus/.../reset
diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
index cd916ef5f2bc..5fb9a99b3c97 100644
--- a/drivers/bus/cdx/cdx.c
+++ b/drivers/bus/cdx/cdx.c
@@ -25,10 +25,57 @@ static struct cdx_device_types_t dev_types[MAX_CDX_DEVICE_TYPES] = {
 	{"cdx-cdma-1.0", "xlnx,cdx-cdma-1.0"}
 };
 
+static int reset_cdx_device(struct device *dev, void * __always_unused data)
+{
+	struct platform_device *cdx_bus_pdev = to_platform_device(dev->parent);
+	struct cdx_device_data *dev_data = dev->platform_data;
+
+	/* TODO: Call reset from firmware using dev_data->bus_id and
+	 * dev_data->dev_id.
+	 */
+	return 0;
+}
+
+static ssize_t reset_all_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	int ret = 0;
+	bool reset = count > 0 && *buf != '0';
+
+	if (!reset)
+		return count;
+
+	/* Reset all the devices attached to cdx bus */
+	ret = device_for_each_child(dev, NULL, reset_cdx_device);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR_WO(reset_all);
+
+static ssize_t reset_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	int ret = 0;
+	bool reset = count > 0 && *buf != '0';
+
+	if (!reset)
+		return count;
+
+	ret = reset_cdx_device(dev, NULL);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR_WO(reset);
+
 static int cdx_populate_one(struct platform_device *pdev_parent,
-			    struct cdx_dev_params_t *dev_params)
+		struct cdx_dev_params_t *dev_params)
 {
-	struct platform_device *new_pdev;
+	struct platform_device *new_pdev = NULL;
 	struct fwnode_handle *swnode;
 	struct platform_device_info pdevinfo;
 	struct cdx_device_data dev_data;
@@ -84,6 +131,9 @@ static int cdx_populate_one(struct platform_device *pdev_parent,
 	dev_set_msi_domain(&new_pdev->dev,
 			   irq_find_host(pdev_parent->dev.of_node));
 
+	/* Creating reset entry */
+	device_create_file(&new_pdev->dev, &dev_attr_reset);
+
 	return 0;
 
 out:
@@ -101,6 +151,7 @@ static int cdx_unregister_device(struct device *dev,
 {
 	struct platform_device *pdev = to_platform_device(dev);
 
+	device_remove_file(dev, &dev_attr_reset);
 	platform_device_unregister(pdev);
 	fwnode_remove_software_node(pdev->dev.fwnode);
 
@@ -215,6 +266,28 @@ static int cdx_bus_device_discovery(struct platform_device *pdev)
 	return ret;
 }
 
+static ssize_t rescan_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	int ret = 0;
+	struct platform_device *pdev = to_platform_device(dev);
+	bool rescan = count > 0 && *buf != '0';
+
+	if (!rescan)
+		return count;
+
+	/* Unregister all the devices */
+	cdx_unregister_devices(dev);
+
+	/* do the device discovery again */
+	ret = cdx_bus_device_discovery(pdev);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR_WO(rescan);
+
 static int cdx_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -225,6 +298,10 @@ static int cdx_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	/* Creating reset_all entry */
+	device_create_file(&pdev->dev, &dev_attr_reset_all);
+	device_create_file(&pdev->dev, &dev_attr_rescan);
+
 	return 0;
 }
 
-- 
2.25.1

