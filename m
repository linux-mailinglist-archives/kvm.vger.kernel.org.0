Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E713F07E3
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbhHRPSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:18:11 -0400
Received: from mail-co1nam11on2081.outbound.protection.outlook.com ([40.107.220.81]:24129
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240021AbhHRPSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:18:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nI1X6GJRD392BGuGl1IqVgHz1L23KLhCOJfZH8WDKs/vGZLy6uI6Ryi1cC7yhQxcT3+Bxxn1iIl7Cfh0gYejm1fuyrmKHezgEeQP8Uxm6pqjkZlkJOVT6VDnJWG/bhB4kXJSE5Rofi8jrc71BMx1VB3E60iR+c1miqFk+Lz44D135a0TQa4yTAZSwHo1xXmWUhVyVjdoRVU77fJ0d/wHuflrI6NXGKxDNlDwL/wlB5BUr1llCfQzoiDrGmP0aQ5Q5+F87i3khTztMLuKTqSOOuoHLpynWKtZmqLZ5JIw1SKhc1HHwfFPnjAKscg4NCyhEKiXzsb08sXiKY/mXFFFeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2naXBxw00aMUj+WtY5j3l3iWggv8i2JgkKudE6jBg8=;
 b=bfaqNggRnS3KLA3dC2GHYv395ZnUGPKpvkvAP4wfdhUSp1ecxymL05PxmjqiKJkbyz0HNloEBv1UKBtOjP+xYvkezaowrK57YM8yuzf3XuwxKh1AXq4pDFDkAbpxQJyi/hZ8l3hOwglNn3rXeBFjbcgp6QD1VboTIQNOe8Op6AHaTid9QsBOFFxU2zWEGHZJ1xBbotlIajFl3YffxiHJBKJ3Xr9kHEKBNzQ+KQQP0GdSxEV6kdKjZu+hoUNARe+fzAR+AcjRTfJ9HGjBFHoM9vXkug0ulFgMwWhGJXq8KtFFAMEghOWBfsJcmewSqg5BVItlrEoEta/ElGEvckc5LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2naXBxw00aMUj+WtY5j3l3iWggv8i2JgkKudE6jBg8=;
 b=e/BuAxdQiI74LMb7YovKI75YiXAiDdotXERt3l3Dg4dU8TGUopGz8jxlHRO8UptqcHPhGmCoRFp7tJlpIoqBfcp9nuLbbr40hDJIAduaRvw87kUxowmHd28sNQp9UfI5Hice38lHsZj3xw/4MAzkRiy+qjyM/ECMgC/RKKBFun6Ifrfa4Aasr1jlwVbQdNvMVWsqxV1YsOCmBWXVOQrvEnDdmTom8U+qeKWzx1OwS3GNKI7BT2cBcwDvThUwgWPKs/Sa6QXeyF73UIDftZwAitGOkjwnrz7qCixbvAIh8AH3fQaVn2M0I9JSINS3HRGmsiETcswwh2jdq5qJHhTIkA==
Received: from BN9PR03CA0610.namprd03.prod.outlook.com (2603:10b6:408:106::15)
 by BN6PR12MB1795.namprd12.prod.outlook.com (2603:10b6:404:107::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 15:17:25 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::5e) by BN9PR03CA0610.outlook.office365.com
 (2603:10b6:408:106::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:17:24 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:17:23 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:19 +0000
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
Subject: [PATCH V2 09/12] PCI: Add 'override_only' bitmap to struct pci_device_id
Date:   Wed, 18 Aug 2021 18:16:03 +0300
Message-ID: <20210818151606.202815-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c57767f-b8d9-48eb-f61d-08d9625b48bf
X-MS-TrafficTypeDiagnostic: BN6PR12MB1795:
X-Microsoft-Antispam-PRVS: <BN6PR12MB179533BF9C38D883A6EBA68BC3FF9@BN6PR12MB1795.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WCAQGaLbb9uNHgUOAZMiwEmM9kQpDz6AwaS4CSej0wk3Dcf+oxzm5/wh84o8Y9YJcjVtx6hC3YeU6USVo3BZEbwNrAaxzMEkpA0ngHd8P/BhZlgRWGmb6AGXAQ2YYH38C1jsbB+5R4X/bWr5EDxIEfde0prN+Kdb8WgwAwthLPQ7hNFn20D1LRBBzuxfiXAxdlQ9YTfjZbLtXgE2c2YCeN0v3MwvxjHyt0aIi4JHmAz+dyfOKTnxZb+cniA2YBmvjMvyu6BavLvWAgijli0Ch568BrzxZZc1jM4fb/7+aSDq2Ovmy6obORZZ3Vyt6y6yXBLoCBKjeITMQrCCxZ7Nei+aGv3FgWyHnsTlOeAQNkdjSNp//7K/a2m4nuQrdLALC6VpJcEDTPwKfiYsVSGRj/d3OCzD50+D2g/AlWbuR5ZnEtcOIScI383WtRtMAkDZeSRt4iywyGR6Pkc9IBghPVTUuVdOtXFI2bazSTYU83BQ0xKjmRe2Ne6VQlgW0CRyw8zQbMB3nnAbIa3xLT/xVhi5RSe7QSjbIRC1ywLKvceoJprC/C8q7HYLqWKjgKnPfiIGyu5Ezm4c1ELmYaGfCD5BiOsv68a3/dzigMjk98+E0cxZgJ2dYUzW4UYAiQHEYlgefHEPspOMZSzLj4dcGgT1VAXWU6D8nJ2BLZnVgjqdsy6PsSYVeeSmrMr1WCBzzIYR30x5GCArzgVBV6j0p9n8CwpLXGUY04yD+NkDYeE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(107886003)(508600001)(7416002)(1076003)(110136005)(54906003)(7696005)(316002)(36756003)(4326008)(2906002)(356005)(6666004)(7636003)(2616005)(336012)(82310400003)(26005)(426003)(47076005)(70586007)(70206006)(83380400001)(8676002)(8936002)(36860700001)(5660300002)(86362001)(186003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:17:24.9592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c57767f-b8d9-48eb-f61d-08d9625b48bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1795
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

Allow device drivers to include match entries in the modules.alias file
produced by kbuild that are not used for normal driver autoprobing and
module autoloading. Drivers using these match entries can be connected
to the PCI device manually, by userspace, using the existing
driver_override sysfs.

To achieve it, we add the 'override_only' bitmap to struct pci_device_id
and a helper macro named 'PCI_DEVICE_DRIVER_OVERRIDE' to enable setting
specific bits on it.

The first bit (i.e. 'PCI_ID_F_VFIO_DRIVER_OVERRIDE') indicates that the
match entry is for the VFIO subsystem, it can be set by another helper
macro named 'PCI_DRIVER_OVERRIDE_DEVICE_VFIO'.

These match entries are prefixed with "vfio_" in the modules.alias.

For example the resulting modules.alias may have:

  alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
  alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
  alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci

In this example mlx5_core and mlx5_vfio_pci match to the same PCI
device. The kernel will autoload and autobind to mlx5_core but the kernel
and udev mechanisms will ignore mlx5_vfio_pci.

When userspace wants to change a device to the VFIO subsystem userspace
can implement a generic algorithm:

   1) Identify the sysfs path to the device:
    /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0

   2) Get the modalias string from the kernel:
    $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
    pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00

   3) Prefix it with vfio_:
    vfio_pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00

   4) Search modules.alias for the above string and select the entry that
      has the fewest *'s:
    alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci

   5) modprobe the matched module name:
    $ modprobe mlx5_vfio_pci

   6) cat the matched module name to driver_override:
    echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override

   7) unbind device from original module
    echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind

   8) probe PCI drivers (or explicitly bind to mlx5_vfio_pci)
    echo 0000:01:00.0 > /sys/bus/pci/drivers_probe

The algorithm is independent of bus type. In future the other buses's with
VFIO device drivers, like platform and ACPI, can use this algorithm as
well.

This patch is the infrastructure to provide the information in the
modules.alias to userspace. Convert the only VFIO pci_driver which results
in one new line in the modules.alias:

  alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci

Later series introduce additional HW specific VFIO PCI drivers, such as
mlx5_vfio_pci.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 Documentation/PCI/pci.rst         |  1 +
 drivers/pci/pci-driver.c          | 27 ++++++++++++++++++++-------
 drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
 include/linux/mod_devicetable.h   |  6 ++++++
 include/linux/pci.h               | 28 ++++++++++++++++++++++++++++
 scripts/mod/devicetable-offsets.c |  1 +
 scripts/mod/file2alias.c          |  8 ++++++--
 7 files changed, 70 insertions(+), 10 deletions(-)

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
index 3a72352aa5cf..8a6bd3364127 100644
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
@@ -152,14 +152,27 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
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
+		 * The match table is split based on driver_override. Check the
+		 * override_only as well so that any matching entry is
+		 * returned.
+		 */
+		if (!found_id->override_only || dev->driver_override)
+			return found_id;
+	}
 
-	return found_id;
+	/*
+	 * if no static match, driver_override will always match, send a dummy
+	 * id.
+	 */
+	if (dev->driver_override)
+		return &pci_device_id_any;
+	return NULL;
 }
 
 /**
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 07edddf7e6ca..c52620ac5e70 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -180,9 +180,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
 }
 
+static const struct pci_device_id vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_ANY_ID, PCI_ANY_ID) }, /* match all by default */
+	{}
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
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 8e291cfdaf06..39c229a7ab8c 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -16,6 +16,10 @@ typedef unsigned long kernel_ulong_t;
 
 #define PCI_ANY_ID (~0)
 
+enum {
+	PCI_ID_F_VFIO_DRIVER_OVERRIDE	= 1 << 0,
+};
+
 /**
  * struct pci_device_id - PCI device ID structure
  * @vendor:		Vendor ID to match (or PCI_ANY_ID)
@@ -34,12 +38,14 @@ typedef unsigned long kernel_ulong_t;
  *			Best practice is to use driver_data as an index
  *			into a static list of equivalent device types,
  *			instead of using it as a pointer.
+ * @override_only:	Bitmap for override_only PCI drivers.
  */
 struct pci_device_id {
 	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
 	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
 	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
 	kernel_ulong_t driver_data;	/* Data private to the driver */
+	__u32 override_only;
 };
 
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 540b377ca8f6..57f9aa60f3b4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -901,6 +901,34 @@ struct pci_driver {
 	.vendor = (vend), .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 
+/**
+ * PCI_DEVICE_DRIVER_OVERRIDE - macro used to describe a PCI device with
+ *                              override_only flags.
+ * @vend: the 16 bit PCI Vendor ID
+ * @dev: the 16 bit PCI Device ID
+ * @driver_override: PCI Device override_only bitmap
+ *
+ * This macro is used to create a struct pci_device_id that matches a
+ * specific device. The subvendor and subdevice fields will be set to
+ * PCI_ANY_ID.
+ */
+#define PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, driver_override) \
+	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
+	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
+
+/**
+ * PCI_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
+ *                                   "driver_override" PCI device.
+ * @vend: the 16 bit PCI Vendor ID
+ * @dev: the 16 bit PCI Device ID
+ *
+ * This macro is used to create a struct pci_device_id that matches a
+ * specific device. The subvendor and subdevice fields will be set to
+ * PCI_ANY_ID and the flags will be set to PCI_ID_F_VFIO_DRIVER_OVERRIDE.
+ */
+#define PCI_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
+	PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, PCI_ID_F_VFIO_DRIVER_OVERRIDE)
+
 /**
  * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
  * @vend: the 16 bit PCI Vendor ID
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index 9bb6c7edccc4..cc3625617a0e 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -42,6 +42,7 @@ int main(void)
 	DEVID_FIELD(pci_device_id, subdevice);
 	DEVID_FIELD(pci_device_id, class);
 	DEVID_FIELD(pci_device_id, class_mask);
+	DEVID_FIELD(pci_device_id, override_only);
 
 	DEVID(ccw_device_id);
 	DEVID_FIELD(ccw_device_id, match_flags);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 7c97fa8e36bc..c3edbf73157e 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
 	return 1;
 }
 
-/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
+/* Looks like: pci:vNdNsvNsdNbcNscNiN or <prefix>_pci:vNdNsvNsdNbcNscNiN. */
 static int do_pci_entry(const char *filename,
 			void *symval, char *alias)
 {
@@ -440,8 +440,12 @@ static int do_pci_entry(const char *filename,
 	DEF_FIELD(symval, pci_device_id, subdevice);
 	DEF_FIELD(symval, pci_device_id, class);
 	DEF_FIELD(symval, pci_device_id, class_mask);
+	DEF_FIELD(symval, pci_device_id, override_only);
 
-	strcpy(alias, "pci:");
+	if (override_only & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
+		strcpy(alias, "vfio_pci:");
+	else
+		strcpy(alias, "pci:");
 	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
 	ADD(alias, "d", device != PCI_ANY_ID, device);
 	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
-- 
2.18.1

