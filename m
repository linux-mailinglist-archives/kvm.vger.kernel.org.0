Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB81339A567
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhFCQK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:57 -0400
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:47201
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230329AbhFCQKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WT8lqrriDdlmoXR/tblJc7+VIXchOd6u8K41Y0/ILV0VCSzUQ4lMdJDnMBanV+FmlTL9nrra7nGVsU/IdkI5gMf1jRC/Tkg2+ipONt+99VZK6l1urlDnIbRJ7MabNmplD43mdZof4gA6srwQD7p2oPLip18xU44ngWz3rDRYQAcNhg/5x1LdqZOqwzXK/qOD0nxu+ztzGD/8DbTYvqgEIM4aqeSu2dpynykvEOmLzUcDfDg+NKmMySfucigjy/7aHB/ysCWEpty0pjAPfUlRNXn3Xdyc6tIHw7DYCWOLLOo8hO4Vpmhb2vFlI0dLW1X0+9eZvrw1lKYgY5w0Gu8xAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHErFZdmeWBERuCyLPF7f7NhUfBS8lsQWkNRfjOOMvo=;
 b=fTZUJfzlw4POm80iEDW2EMSvy0ASFWkYl+hbRVS73G65bXvRjedIOhUaTMiy4nJhPzw/k3QEjLHJImz+lDlvRZ0ZujBN06DfjbFTfoRACjkfHhd8WSoH+/XWtDRLydxW61mPQsEoZ3MSc/1/mO5OAYcR/G/7EmH4OnOPkVk6Ii8+nX0fMBbphfFyCuqm9yoSs2J/YAUwTyEX4w/3brnkd4oBWxW0MWINk1fKOWpRSNCxDV7WsFkIOI1hkVyWksJ/3t09n6wka+6Ksxwdq8wWopeXo834/UEh0jWXeVGcFhU+Ih72kYggxiOZ9efOue4cRjPlaIpQJnHCx4LgD/SBmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHErFZdmeWBERuCyLPF7f7NhUfBS8lsQWkNRfjOOMvo=;
 b=Z2Od/6yBIF/oL4YeQ1l/vANzE/S2Dz+j8zAaTNcRQu2M4FNQvPmho8npW6DrpFOi6kcl4AQm1iYxIY2x5W3XXTbmu2RtHc8+gQJeTUxcY20zWt53Bu5yfZ73uz2p/5MDGETyk35FBSSMUW3jbzuaVKLCb0Q/MYyjmdBn5m9ztNMLB6OXGXwhrzVUGVGy5NFd4/XDqmSk0yokvXbA3NBHOxgcgShftZGIhFW7+R7ijyA7HCHCitBJLra+anjvzqhbo8umxgVJvaXLkrINTa4uF6yCbHNUxP2Y2SfbazFeCXZkmZ6d47DjWIv/BFqIDoH9yvCtSgs51hJBPpRojfTBew==
Received: from MW4PR03CA0031.namprd03.prod.outlook.com (2603:10b6:303:8e::6)
 by MWHPR12MB1615.namprd12.prod.outlook.com (2603:10b6:301:10::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Thu, 3 Jun
 2021 16:09:06 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::44) by MW4PR03CA0031.outlook.office365.com
 (2603:10b6:303:8e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Thu, 3 Jun 2021 16:09:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:09:03 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:09:02 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:57 +0000
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
Subject: [PATCH 09/11] PCI: add matching checks for driver_override binding
Date:   Thu, 3 Jun 2021 19:08:07 +0300
Message-ID: <20210603160809.15845-10-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1c03cc3-0dc5-48fd-854a-08d926a9e805
X-MS-TrafficTypeDiagnostic: MWHPR12MB1615:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1615BA6C2101AD89753193ACDE3C9@MWHPR12MB1615.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LsjRjNVGy+Kwi4BCUfDmijghYGIyB9yYl/g109myCfTLmj9rmHZEPEE+ynUYr7Zjpc+vLmh7WrRqvu7b90sh4FR5y+rjvxkL4OAmOwGJeUIRIsdx9Od9jAWt/qML/76zEojvXMIj4b6NK/XwPbEKGEt/hHt+fe2StCKSh+QzuhnkMk4ehs5n33nbGb3esPsH9Dot/n7agCSqiwZC70u168JpTJMqmtOVSu3fAAbiQfF3Zv9cJagvkk09Sodm+xMDlRky1lSLVbdpSQW1qbyCVM4HyWRCifxWRK5eQChj95UeNgNAlvS+RsEUgN6X2meRQ75g6BJAytR1rCGXi6UIrVinh4aqnDfAlRR1kJlbOhwnkDE5X/4BYOOEHta12pqilv4H9eah7lYafiSI8bzjnIdLAk0iVIE97R+aPVma5Pe8W/MH781hyaigAuIw01EiOanLJy24t2JnMCr2jdg+o8Ydi5pv9LUBCnO4WdrTJQTZw4CLYp7Fmu4ChyWKuAhSaJK+kI2cF0olVK2RA/XDmezyUyGZkHZ1nksGrxEEd9PKZzW4KDP47Hf9aZ46U9Rp+z8KQK0QJkyMGRhdzxO5yH9ONB7+He+rEpMR0rLfSOfQ30A59BbmFjA6kEfRR32cXbaPjRBuNETANcqzy2IXVNTPyfcukzbz75UAsEzn04c=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(46966006)(36840700001)(8936002)(6636002)(82310400003)(8676002)(36860700001)(5660300002)(86362001)(47076005)(83380400001)(4326008)(107886003)(1076003)(356005)(316002)(36906005)(426003)(110136005)(54906003)(478600001)(82740400003)(36756003)(2616005)(336012)(2906002)(186003)(70206006)(7636003)(26005)(6666004)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:09:03.2530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c03cc3-0dc5-48fd-854a-08d926a9e805
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1615
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allowing any driver in the system to be unconditionally bound to any
PCI HW is dangerous. Connecting a driver to a physical HW device it was
never intended to operate may trigger exploitable kernel bugs, or worse.
It also allows userspace to load and run kernel code that otherwise
would never be runnable on the system.

driver_override was designed to make it easier to load vfio_pci, so
focus it on that single use case. driver_override will only work on
drivers that specifically opt into this feature and the driver now has
the opportunity to provide a proper match table that indicates what HW
it can properly support. vfio-pci continues to support everything.

This also causes the modalias tables to be populated with dedicated
match table and userspace now becomes aware that vfio-pci can be loaded
against any PCI device using driver_override.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 Documentation/ABI/testing/sysfs-bus-pci |  6 +++++-
 drivers/pci/pci-driver.c                | 22 ++++++++++++----------
 drivers/vfio/pci/vfio_pci.c             |  9 ++++++++-
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ef00fada2efb..6d78970b1c69 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -289,7 +289,11 @@ Description:
 		will not bind to any driver.  This also allows devices to
 		opt-out of driver binding using a driver_override name such as
 		"none".  Only a single driver may be specified in the override,
-		there is no support for parsing delimiters.
+		there is no support for parsing delimiters.  The binding to the
+		device is allowed if and only if the matching driver has
+		enabled the driver_override alias in the ID table (by setting
+		a suitable bit in the "flags" field of pci_device_id
+		structure).
 
 What:		/sys/bus/pci/devices/.../numa_node
 Date:		Oct 2014
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index ec44a79e951a..e4037db817da 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -115,13 +115,6 @@ const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 }
 EXPORT_SYMBOL(pci_match_id);
 
-static const struct pci_device_id pci_device_id_any = {
-	.vendor = PCI_ANY_ID,
-	.device = PCI_ANY_ID,
-	.subvendor = PCI_ANY_ID,
-	.subdevice = PCI_ANY_ID,
-};
-
 /**
  * pci_match_device - See if a device matches a driver's list of IDs
  * @drv: the PCI driver to match against
@@ -137,6 +130,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 {
 	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL;
+	bool is_driver_override;
 
 	/* When driver_override is set, only bind to the matching driver */
 	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
@@ -155,9 +149,17 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (!found_id)
 		found_id = pci_match_id(drv->id_table, dev);
 
-	/* driver_override will always match, send a dummy id */
-	if (!found_id && dev->driver_override)
-		found_id = &pci_device_id_any;
+	/*
+	 * if and only if PCI_ID_F_DRIVER_OVERRIDE flag is set, driver_override
+	 * should be provided.
+	 */
+	if (found_id) {
+		is_driver_override =
+			(found_id->flags & PCI_ID_F_DRIVER_OVERRIDE) != 0;
+		if ((is_driver_override && !dev->driver_override) ||
+		    (dev->driver_override && !is_driver_override))
+			return NULL;
+	}
 
 	return found_id;
 }
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 850ea3a94e28..9beb4b841945 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -166,9 +166,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
 }
 
+static const struct pci_device_id vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_ANY_ID, PCI_ANY_ID) }, /* match all by default */
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, vfio_pci_table);
+
 static struct pci_driver vfio_pci_driver = {
 	.name			= "vfio-pci",
-	.id_table		= NULL, /* only dynamic ids */
+	.id_table		= vfio_pci_table,
 	.probe			= vfio_pci_probe,
 	.remove			= vfio_pci_remove,
 	.sriov_configure	= vfio_pci_sriov_configure,
-- 
2.21.0

