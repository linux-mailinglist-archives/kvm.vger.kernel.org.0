Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837BC3D13DA
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbhGUPh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:37:28 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:65120
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233381AbhGUPh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:37:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPx/ogYbn+wLLhFx3YPvRZAg8NWwN0ZTPDQMuyWGPhCe52hsqTzYTNLXSgq1m4c0W+7Fq+V2l/RPvJb+mZJRvAEDu60c4mdMyRiBPLhExqFqjKqsPoEK5UM8dXiNTFhTeeJi5Vau1JPJr0hi85ppnQKy2rvjooWcgA0h681Y3dhhUxUv6sFuNWccWdG9W0gYi3mGjkP6DfCoLyD6xXOLQtRifpNEHXLM6wXdpLlU7HKclUQXn02Nq3pzAaS+BJyyPaeNPqT55gmIkPbEfsoqXkHgQB7AptZTEI/GjSib6YbxphnBU9h/WC4k/7eAKNyYTk1Mrli8Vu5ostWiISvczg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGTCfkngep7nabu5tQBFpyBPkabqVEJjnhrB0tOYCXY=;
 b=lO1HVesR2apbPh3/xcpS00W4aAWhmCJhXnoMoqq9+t3PLjYlM/GkdWlNAHHAfVn3x0Njl38zKDELprpJyLWYoxoQ90dpJhpsfEA2TpSHz70J/LtnyoeYvfkGNnj4xPvtrmmwuPSw2rcQfWWanV4X97tF9mn8RUGz/NgM3nESPFQQLsRu7I4GKwWGyNKjLdFoBGzKzciIpdOXIL3knODkvzrjdhtoznWSUvFS/SDTf/HaETbiQ77wUEy4vm2yPT6hzXwfJRyVqKpF253PjdPLo1AjCmgJMf9b6pz7H3YZ/6VanctUXwFawAD+NgKb+LjlUZSJ1tnqt+4wzKvWuV/g2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=markovi.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGTCfkngep7nabu5tQBFpyBPkabqVEJjnhrB0tOYCXY=;
 b=qW7bh+hyqx+dAD8jXPuoQI1Bh7ztwYMOpcx7ix8/iEDT0oaJOXfphmBvsyQEXXq9MuylTeIfH5n+1ifpdH8UoZij8pa7Vm9C2uEa+4ZPkXs3PjxlZU6cLFOBm4LfTpn6+M4VHhUGqRXvAfycAmOon6fwu7HZg0dJ+MbjhRON4R91Xn8s61XlSag1ZfzHXrvi6tzjNicF3NUpK7c3+Rkg9MOrZyDdTG1ngEKZx7mUrloxsKzmEflgVb99UUvxWjQATHFqjiIcNG02VsSbVs3Ww9rNAveUNuQZJjuffbEjmaF74jaoKDBop2m5MXMZ22VNSSr+K5XMHykew3dLcR+dIQ==
Received: from DM6PR08CA0055.namprd08.prod.outlook.com (2603:10b6:5:1e0::29)
 by BN6PR1201MB0113.namprd12.prod.outlook.com (2603:10b6:405:55::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Wed, 21 Jul
 2021 16:18:02 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::67) by DM6PR08CA0055.outlook.office365.com
 (2603:10b6:5:1e0::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Wed, 21 Jul 2021 16:18:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; markovi.net; dkim=none (message not signed)
 header.d=none;markovi.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:18:01 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 09:18:00 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:18:00 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:56 +0000
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
Subject: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to struct pci_device_id
Date:   Wed, 21 Jul 2021 19:16:06 +0300
Message-ID: <20210721161609.68223-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f61cdd9a-21fa-4fa6-29a7-08d94c631c9e
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0113:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0113EAAF2960F312E36C15C7C3E39@BN6PR1201MB0113.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwHbHlAdtwi4IaHflTmIghqPpjuheOHCp29rpSakNqUeQeyzJXB+K79tM2YdHy9t4hu2itChVFIsXFKO/3Y4DyfV4t7ANNcOcUI7pRV7eW4vhpX+NDCkn1eDQ8EDefI+caFc3TP9Ve6ING9P4gyQmyB7dqka64bO/j21jgihCCKiQNJVFf6i0Lo4mFgeIeZS+H01HsCO6NrbybQShLW5TPavi69RcHsZVhYLmN5xbwkCJYZkvGe0LrbtbBfA6NSPNH2U9Pf0eYndbm7l6yf6S2vbON/84/yoIRQAGQ3VoXPcQ33QxLOXTaQQYxpNz8iHbT/17pL9jp93lwt0cUAQWXmqKcfM3tQ7JbBZio7eVmT1uxtPRUFpTWOd7a/gLJZh4X1j0S7KNzO4prY8CTNpW9hO56w+rewuZ91ROo66gfY9PVbE9oFvpM0OKQLwz8lLk8CUU5ECNaxSR4LdBKLO3gzOxYT2s5SKaPJAxcrf6DYq64FZD33aHNAermR6fpw+2EnMs5tSmNOTzImmfBkWvoCtuYRLfwxLmtuJA/FKLkaLZ+4Sb3YxgzEsQ+ShikXVMwCA57zGHKDtd5RtFBenHU0h/qDZUA+fGkE0698tgZW/vTXk/p0oc+eMZ98MC1Z9l5NrqdoapWmd/iQLqlG9hr8tBMTbFcDeEat/FIj0ko6BtHXCU4z67KtgqeKO5jL4U3Om148+zviBTK0bV8yQvDOypUZcTfIzhkZ0Pb76QDw=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(336012)(47076005)(426003)(2616005)(7636003)(70206006)(82310400003)(70586007)(356005)(36756003)(186003)(26005)(36860700001)(8676002)(110136005)(54906003)(4326008)(5660300002)(508600001)(7696005)(8936002)(6666004)(2906002)(7416002)(83380400001)(1076003)(86362001)(107886003)(316002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:18:01.4077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f61cdd9a-21fa-4fa6-29a7-08d94c631c9e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

The new flag field is be used to allow PCI drivers to signal the core code
during driver matching and when generating the modules.alias information.

The first use will be to define a VFIO flag that indicates the PCI driver
is a VFIO driver.

VFIO drivers have a few special properties compared to normal PCI drivers:
 - They do not automatically bind. VFIO drivers are used to swap out the
   normal driver for a device and convert the PCI device to the VFIO
   subsystem.

   The admin must make this choice and following the current uAPI this is
   usually done by using the driver_override sysfs.

 - The modules.alias includes the IDs of the VFIO PCI drivers, prefixing
   them with 'vfio_pci:' instead of the normal 'pci:'.

   This allows the userspace machinery that switches devices to VFIO to
   know what kernel drivers support what devices and allows it to trigger
   the proper device_override.

As existing tools do not recognize the "vfio_pci:" mod-alias prefix this
keeps todays behavior the same. VFIO remains on the side, is never
autoloaded and can only be activated by direct admin action.

This patch is the infrastructure to provide the information in the
modules.alias to userspace and enable the only PCI VFIO driver. Later
series introduce additional HW specific VFIO PCI drivers.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 Documentation/PCI/pci.rst         |  1 +
 drivers/pci/pci-driver.c          | 25 +++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
 include/linux/mod_devicetable.h   |  7 +++++++
 include/linux/pci.h               | 27 +++++++++++++++++++++++++++
 scripts/mod/devicetable-offsets.c |  1 +
 scripts/mod/file2alias.c          |  8 ++++++--
 7 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
index fa651e25d98c..24e70a386887 100644
--- a/Documentation/PCI/pci.rst
+++ b/Documentation/PCI/pci.rst
@@ -103,6 +103,7 @@ need pass only as many optional fields as necessary:
   - subvendor and subdevice fields default to PCI_ANY_ID (FFFFFFFF)
   - class and classmask fields default to 0
   - driver_data defaults to 0UL.
+  - flags field defaults to 0.
 
 Note that driver_data must match the value used by any of the pci_device_id
 entries defined in the driver. This makes the driver_data field mandatory
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 3a72352aa5cf..1ed8a4ab96f1 100644
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
@@ -152,10 +152,27 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	}
 	spin_unlock(&drv->dynids.lock);
 
-	if (!found_id)
-		found_id = pci_match_id(drv->id_table, dev);
+	if (found_id)
+		return found_id;
+
+	ids = drv->id_table;
+	while ((found_id = pci_match_id(ids, dev))) {
+		/*
+		 * The match table is split based on driver_override. Check the
+		 * flags as well so that any matching PCI_ID_F_DRIVER_OVERRIDE
+		 * entry is returned.
+		 */
+		if ((found_id->flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE) &&
+		    !dev->driver_override)
+			ids = found_id + 1;
+		else
+			break;
+	}
 
-	/* driver_override will always match, send a dummy id */
+	/*
+	 * if no static match, driver_override will always match, send a dummy
+	 * id.
+	 */
 	if (!found_id && dev->driver_override)
 		found_id = &pci_device_id_any;
 
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 0272b95d9c5f..7a43edbe8618 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -181,9 +181,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
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
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 8e291cfdaf06..cd256d9c60d2 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -16,6 +16,11 @@ typedef unsigned long kernel_ulong_t;
 
 #define PCI_ANY_ID (~0)
 
+
+enum pci_id_flags {
+	PCI_ID_F_VFIO_DRIVER_OVERRIDE	= 1 << 0,
+};
+
 /**
  * struct pci_device_id - PCI device ID structure
  * @vendor:		Vendor ID to match (or PCI_ANY_ID)
@@ -34,12 +39,14 @@ typedef unsigned long kernel_ulong_t;
  *			Best practice is to use driver_data as an index
  *			into a static list of equivalent device types,
  *			instead of using it as a pointer.
+ * @flags:		PCI flags of the driver. Bitmap of pci_id_flags enum.
  */
 struct pci_device_id {
 	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
 	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
 	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
 	kernel_ulong_t driver_data;	/* Data private to the driver */
+	__u32 flags;
 };
 
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 540b377ca8f6..fd84609ff06b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -901,6 +901,33 @@ struct pci_driver {
 	.vendor = (vend), .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 
+/**
+ * PCI_DEVICE_FLAGS - macro used to describe a PCI device with specific flags.
+ * @vend: the 16 bit PCI Vendor ID
+ * @dev: the 16 bit PCI Device ID
+ * @fl: PCI Device flags as a bitmap of pci_id_flags enum
+ *
+ * This macro is used to create a struct pci_device_id that matches a
+ * specific device. The subvendor and subdevice fields will be set to
+ * PCI_ANY_ID.
+ */
+#define PCI_DEVICE_FLAGS(vend, dev, fl) \
+	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
+	.subdevice = PCI_ANY_ID, .flags = (fl)
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
+	PCI_DEVICE_FLAGS(vend, dev, PCI_ID_F_VFIO_DRIVER_OVERRIDE)
+
 /**
  * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
  * @vend: the 16 bit PCI Vendor ID
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index 9bb6c7edccc4..b927c36b8333 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -42,6 +42,7 @@ int main(void)
 	DEVID_FIELD(pci_device_id, subdevice);
 	DEVID_FIELD(pci_device_id, class);
 	DEVID_FIELD(pci_device_id, class_mask);
+	DEVID_FIELD(pci_device_id, flags);
 
 	DEVID(ccw_device_id);
 	DEVID_FIELD(ccw_device_id, match_flags);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 7c97fa8e36bc..f53b38e8f696 100644
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
+	DEF_FIELD(symval, pci_device_id, flags);
 
-	strcpy(alias, "pci:");
+	if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
+		strcpy(alias, "vfio_pci:");
+	else
+		strcpy(alias, "pci:");
 	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
 	ADD(alias, "d", device != PCI_ANY_ID, device);
 	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
-- 
2.18.1

