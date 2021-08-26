Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4CC3F859F
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241747AbhHZKlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:41:11 -0400
Received: from mail-dm3nam07on2047.outbound.protection.outlook.com ([40.107.95.47]:34112
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241629AbhHZKlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:41:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZTjt6nWSuDDB+7fvkxvkTAIZHdWWy79wgH/s4sbgGLv5Qt5L7B+jkF4Jk+g/pGnoBd/Av7oIBm8HBRZ73idcF6aGhbZGQoOJ5/RUwkQ13SaEd6TdEIj6WnTaMkA0fnBN2LXDORY78IX8jXE0P5bkVleC3CMuWR7TF4ez/c+q9X4D2WW0K6Vy5Ve2YsfJMPgFBQiQ0LsZt2Bym1qTZvWRh084bG2NmXxxr1anOv3N5SIiWHfENi0gs9fgqudrRTT70R1lhj4NilmvFdP2iOgtgdyJvsEnWfUilz3aoM5a1JL4eFurCDQ9GXvr7wVBb5inze43q9C0QF/BODo0FkdYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YX0Qcp4uqbDA/nX9m5AG67f99XmApPpA2zxpyXEKmNY=;
 b=bhYFc4jCoUp11zXYUlMiNrKOd5n59ongMkzUjJ8E3DLSqIukhO7G5mMYtPImovVgtDGddG7B2w+vQHkdHDg0EYwcj5ty+iuAk8xynn1SkgCNVrIKEST71LFCcOYmAqrF001AK+Y8/b5bDf2K2D7NEKwoUELXbV1zckffI6KwfeC8Lppr/kjN5ftjKbv8Y6piGPqaZjm0XWpH4+cDrQQahtxMHxSsAniB9fIwdjYLZD4S4xT9PzWC61nEJpwe2UOOaXlpLwXWVjFPgwhr7AqaHHVHQKqubzZO1oAPNhgmTTIAjqo7i7PQmThffDSuErRha3nnvgKMC/DkSnyuBzGcpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YX0Qcp4uqbDA/nX9m5AG67f99XmApPpA2zxpyXEKmNY=;
 b=YWPidgVgaAAxeQF3S9tsT/HM4dmhWhA55sFDr1rzIC1P8Ne7J8ai7wZEKNHVnMfQmUzFOz63o6kMEQ3REr8LK78bcHpHnsaXNiGYnsim2+PQbyXWqJcNGKSlNSaqILKHcOB+m2OK3fRJmbt7z7lbtUMGR6Y+1ePgmUQk9jzCSYCdU56zSNi72bEBPvdJMDRDdl4MKvB70iFxfEWY3HDFOdtQI8Xv2iNNHREIVtNJO5nEcz3bRrK7i/xXlVdajAzkFH08c91kjMuiOcRtwafjQTC4J5zSdDOFg9LqY6LSceMljQUElyoQyLS169hr/wzvbGSxZr/bpiLHBbO0+HzhXA==
Received: from MW4PR03CA0111.namprd03.prod.outlook.com (2603:10b6:303:b7::26)
 by BY5PR12MB4177.namprd12.prod.outlook.com (2603:10b6:a03:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Thu, 26 Aug
 2021 10:40:17 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::de) by MW4PR03CA0111.outlook.office365.com
 (2603:10b6:303:b7::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:40:17 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 10:40:17 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:12 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V5 09/13] PCI: Add 'override_only' field to struct pci_device_id
Date:   Thu, 26 Aug 2021 13:39:08 +0300
Message-ID: <20210826103912.128972-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69663ea8-d51b-4509-ceba-08d9687de54f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4177:
X-Microsoft-Antispam-PRVS: <BY5PR12MB417700F2444DFA83B6DD2DDDC3C79@BY5PR12MB4177.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z7rRpYPTycuzA3UQvZOwS8Abx1dnlr6QixJ0mHpKq5oK5miQxBV7qIg6YsXauDbTVJcpa5RS+n7dzLNM3bJBo56/sfWsUwuvuPiiRNowDJ6ZChtOACtfRItgMsi2c/ldkZHBXwQrtEAXS3DGfJoPbCcrWMx2QVEBK0f4Uo+FtD2ZfJVvlHj8UB0NL++34YnHWBfU3ar18FD6PLgEitJw9ckXOJ//9bh3LviF1qyNlRNiLsT7g1q4ZqlVqZ45+W69R0UR76IQPfk3+RF54qdvdHgOJ2PFzBspNUqCxrF3AuFgQZMYGAVS21k+M4BeGwMBNsLBvJ9Ms6x1cbIruVOiRPse49yswh+ux5cqaUJ43IR7cvx3a9Bn8Cebr9orW7dDt4GGmBrqc6rsiDY9KjnKnqQ/38ETnOe+j2nQ0Od+R7Da5wdCehRUPaR4XQm598ou0QCM2Z+cKQroILewFPDCPPLImPnHPxi+7YpPFVLIoGRTvY/5faRJn6EhSBRq08WVoznpxWu6I7X2l1TW5kCByCmtUDqOsw+4XsBUhwJrmdiUJPFMedMLjT2TMG4eRUOJgS3QndpxaBhVDBfMaWRsyOK4a0cF90PNYhJKSlhj36kOuoMuVYWpN0GNeh+NWMJKGcVMJyAOkLkx4PxYoV6GSWsikWnXjxuL1NrsuTjirvPyoZlntQHVNaFmb/zeOxZiNTTGXdO2ERImi+bI8IiHdnH9IFu4/nuhalkLxNly6PM=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(36840700001)(86362001)(107886003)(36860700001)(47076005)(356005)(36756003)(82740400003)(7636003)(8676002)(70586007)(316002)(54906003)(70206006)(83380400001)(26005)(110136005)(7416002)(2906002)(426003)(1076003)(8936002)(2616005)(336012)(4326008)(7696005)(82310400003)(186003)(36906005)(6666004)(478600001)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:40:17.5929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69663ea8-d51b-4509-ceba-08d9687de54f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4177
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

Add 'override_only' field to struct pci_device_id to be used as part of
pci_match_device().

When set, a driver only matches the entry when dev->driver_override is
set to that driver.

In addition, add a helper macro named 'PCI_DEVICE_DRIVER_OVERRIDE' to
enable setting some data on it.

Next patch from this series will use the above functionality.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 Documentation/PCI/pci.rst       |  1 +
 drivers/pci/pci-driver.c        | 28 +++++++++++++++++++++-------
 include/linux/mod_devicetable.h |  2 ++
 include/linux/pci.h             | 15 +++++++++++++++
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
index fa651e25d98c..87c6f4a6ca32 100644
--- a/Documentation/PCI/pci.rst
+++ b/Documentation/PCI/pci.rst
@@ -103,6 +103,7 @@ need pass only as many optional fields as necessary:
   - subvendor and subdevice fields default to PCI_ANY_ID (FFFFFFFF)
   - class and classmask fields default to 0
   - driver_data defaults to 0UL.
+  - override_only field defaults to 0.
 
 Note that driver_data must match the value used by any of the pci_device_id
 entries defined in the driver. This makes the driver_data field mandatory
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 3a72352aa5cf..123c590ebe1d 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -136,7 +136,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 						    struct pci_dev *dev)
 {
 	struct pci_dynid *dynid;
-	const struct pci_device_id *found_id = NULL;
+	const struct pci_device_id *found_id = NULL, *ids;
 
 	/* When driver_override is set, only bind to the matching driver */
 	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
@@ -152,14 +152,28 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	}
 	spin_unlock(&drv->dynids.lock);
 
-	if (!found_id)
-		found_id = pci_match_id(drv->id_table, dev);
+	if (found_id)
+		return found_id;
 
-	/* driver_override will always match, send a dummy id */
-	if (!found_id && dev->driver_override)
-		found_id = &pci_device_id_any;
+	for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
+	     ids = found_id + 1) {
+		/*
+		 * The match table is split based on driver_override.
+		 * In case override_only was set, enforce driver_override
+		 * matching.
+		 */
+		if (found_id->override_only) {
+			if (dev->driver_override)
+				return found_id;
+		} else {
+			return found_id;
+		}
+	}
 
-	return found_id;
+	/* driver_override will always match, send a dummy id */
+	if (dev->driver_override)
+		return &pci_device_id_any;
+	return NULL;
 }
 
 /**
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 8e291cfdaf06..2e3ba6d9ece0 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -34,12 +34,14 @@ typedef unsigned long kernel_ulong_t;
  *			Best practice is to use driver_data as an index
  *			into a static list of equivalent device types,
  *			instead of using it as a pointer.
+ * @override_only:	Match only when dev->driver_override is this driver.
  */
 struct pci_device_id {
 	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
 	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
 	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
 	kernel_ulong_t driver_data;	/* Data private to the driver */
+	__u32 override_only;
 };
 
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 540b377ca8f6..0506b1a8c921 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -901,6 +901,21 @@ struct pci_driver {
 	.vendor = (vend), .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 
+/**
+ * PCI_DEVICE_DRIVER_OVERRIDE - macro used to describe a PCI device with
+ *                              override_only flags.
+ * @vend: the 16 bit PCI Vendor ID
+ * @dev: the 16 bit PCI Device ID
+ * @driver_override: the 32 bit PCI Device override_only
+ *
+ * This macro is used to create a struct pci_device_id that matches only a
+ * driver_override device. The subvendor and subdevice fields will be set to
+ * PCI_ANY_ID.
+ */
+#define PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, driver_override) \
+	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
+	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
+
 /**
  * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
  * @vend: the 16 bit PCI Vendor ID
-- 
2.18.1

