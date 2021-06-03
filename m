Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F7139A564
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhFCQKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:46 -0400
Received: from mail-sn1anam02on2084.outbound.protection.outlook.com ([40.107.96.84]:42924
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230247AbhFCQKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a05eGUxToBlDT5aXMynj0QtEqe+nJ4cz8cmkq++pE8eb3gHtYK2i0bqDz52X2a8VyJ4Onk1C4Jb1nfVBSQHG6KJbiAoi4Sifrrlc2LuEPfh666Ve5y4U9uIsGetzhtcjD2BN9UxVmM1WGu6Q9LSkAJDUpRRaDuRF4/sfMLtLLC39tkPowL24zeNMQhu+IVYaQssJHKkm0gHBCJTVNmi5KxfPDr/Z8kSe+l46cOSSpmQWsJySZEXoJ+nruMp6xy+23tyxQMbywgIfKhriIYHynuSifulj+FzF86CkE+LPSm+hrRwTUgYoHmECZ7rOiPsL05ZKX42ogB6UwqprGntyNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XeIWBMvjjxEnGRUf1h5uJtIdeEaaeXaLM5bCkodPmk=;
 b=NCidFwgsPmL8eXHCRShaR5HFqM4Ua7C2YeUFsJZBCf5kS/0VitZiiqmGO+0DcrD0MfdLcC/yOXu8JllcAzOMJVrQE8U3MZtqfNNZCuWwZy9+3xTo+jmNJZTKew9GFSdn6pOL0eXaIl4etyn+5WSvJ+BEGNvm3ANACojjpHUiCxG6ZyaHUvIwb11eEi5GBh7iIZAHBd7lVT5SbG8H4mqhTUhnDC65D4TQPeLAk40GX+4K6RuYQgUxA0T5BUTRKlfGcTZu2uY6SnXR3HbBthlUcfMa9+EfBZ2jRo8ACg1/hgIP2J1DLFH3xTh0JVKzuXG2/TGbST5P2ALhEdqsrMdSdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XeIWBMvjjxEnGRUf1h5uJtIdeEaaeXaLM5bCkodPmk=;
 b=KogviuUPtcx4MkUFmmZ8LVB+I1bUSLbZ1P/fjzAVkBHGZ4FufVU2kw/HybZ+GpVvrEfTLAhC3a9XriAP+qBjcPcbBfa5R4gnwobd2WqdkX8Fvi0bhm+lrjlIxOHoFUl4HJzBonHan0KHazpeAJ9Piv7PBQhCglb2OVhUm5QUcevw7z0luGJsp4qbufRY3O/Wq77DZc4ncJZSsO1Cv7FfBgKvIlUODNsCs22hbNee0u+iwRv+r/Hu1UkLt1U+k5o0oOdt7anCmsHlQEBZzX3XWSSMTWmQmIzakW9l37sz46716OPdYDnnhDaCCP3jcReP511mzFIF4Z2/GDONBWfGNA==
Received: from BN6PR11CA0043.namprd11.prod.outlook.com (2603:10b6:404:4b::29)
 by DM4PR12MB5344.namprd12.prod.outlook.com (2603:10b6:5:39f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Thu, 3 Jun
 2021 16:08:58 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:4b:cafe::5a) by BN6PR11CA0043.outlook.office365.com
 (2603:10b6:404:4b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:08:58 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 09:08:57 -0700
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:52 +0000
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
Subject: [PATCH 08/11] PCI: add flags field to pci_device_id structure
Date:   Thu, 3 Jun 2021 19:08:06 +0300
Message-ID: <20210603160809.15845-9-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4c95ec2-3ecb-421b-a841-08d926a9e503
X-MS-TrafficTypeDiagnostic: DM4PR12MB5344:
X-Microsoft-Antispam-PRVS: <DM4PR12MB53448106C7164CF1E4109DD0DE3C9@DM4PR12MB5344.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0TkoCWBThi4cSbxwNBQ7S5v3JG+8g31NDa0oshA58fDgS7XbCNtaOmCq26IeAmZl3JZjs1C1wRn9GEZcspzlWsY6cJi7dNL6COrDu8dVli0fgK5QpegoB5SL4G2tcjWSPHZY93S+u472RERFYOmHXe9rvWm7F/qyG5k+cGNeSAoaGLBXhkGgqn9SdNObl4tKwpsQSeig2q4M7ltIPe3KbsjuA9GlpTCVcICVZ4EfD9UBBPdMaO7v/BxHu2SAzk8L3qWwSGpf3mqIHECmYaeJ0vh1cZ5wpfPTXG4cF3ugRkU6Krfk9vkFbv4+T5c1ZvWJbyFe2InqYDKoTUs8hjriOSy8tMBPSWUOIJdogD3kJViV77dqNU7PY9eSNUMGVL9/BsAR7DoyizLh43oLH+0wD2R6deGBa8m41ZujzGmNPT5iR+YZnpXO0G5GgTvpPyiWoFR5cj+/09BcEPxhJ+OxaJtdwDE20g5Z8MZi/o67/sfNJyT5ug8nfxAkWOJuf0pyEnKqi9nnCn53R+Xr6DROuE6TT8Ha5dC662Azla60GLY8QYC2HmMzgtybJPnLj27IoQZd3l5UXxSB8HGcPOUvY8tlScCoH02qiNLSnxKnfiXF1ykLYxHbgp8fGPnwCRxXs2sVz5zITFvaLbFxphJh7P/c/LsAdniiagGgnXh2Fk=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(110136005)(54906003)(107886003)(36756003)(8936002)(8676002)(186003)(26005)(6666004)(5660300002)(2906002)(336012)(426003)(1076003)(2616005)(498600001)(36860700001)(6636002)(82310400003)(47076005)(83380400001)(356005)(4326008)(70206006)(86362001)(70586007)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:08:58.0611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c95ec2-3ecb-421b-a841-08d926a9e503
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5344
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This field will be used to allow pci modules to set some specific data
that can be used for matching, aliases and other hints. Add example for
"driver_override" pci drivers that will set a special prefix in the
modules.alias table. In the future, this flag will enforce
"driver_override" to work on drivers that specifically opt into this
feature. The udev utility will not try to load these drivers
automatically in order to bind to new discovered devices. This will be
because the modalias tables populated by those drivers will be different
from "regular" pci modalias tables. Userspace utilities, such as
libvirt, will need to adjust and bind devices according to new matching
mechanism with taking "driver_override" enforcement into consideration.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 Documentation/PCI/pci.rst         |  1 +
 include/linux/mod_devicetable.h   |  9 +++++++++
 include/linux/pci.h               | 27 +++++++++++++++++++++++++++
 scripts/mod/devicetable-offsets.c |  1 +
 scripts/mod/file2alias.c          |  8 ++++++--
 5 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
index 814b40f8360b..0855657daf93 100644
--- a/Documentation/PCI/pci.rst
+++ b/Documentation/PCI/pci.rst
@@ -103,6 +103,7 @@ need pass only as many optional fields as necessary:
   - subvendor and subdevice fields default to PCI_ANY_ID (FFFFFFFF)
   - class and classmask fields default to 0
   - driver_data defaults to 0UL.
+  - flags field defaults to 0.
 
 Note that driver_data must match the value used by any of the pci_device_id
 entries defined in the driver. This makes the driver_data field mandatory
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 7d45b5f989b0..0f5c0355992c 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -16,6 +16,13 @@ typedef unsigned long kernel_ulong_t;
 
 #define PCI_ANY_ID (~0)
 
+
+enum pci_id_flags {
+	PCI_ID_F_VFIO_DRIVER_OVERRIDE	= 1 << 0,
+};
+
+#define PCI_ID_F_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
+
 /**
  * struct pci_device_id - PCI device ID structure
  * @vendor:		Vendor ID to match (or PCI_ANY_ID)
@@ -34,12 +41,14 @@ typedef unsigned long kernel_ulong_t;
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
index c20211e59a57..602603526327 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -898,6 +898,33 @@ struct pci_driver {
 	.vendor = (vend), .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 
+/**
+ * PCI_DEVICE_FLAGS - macro used to describe a PCI device with specific flags.
+ * @vend: the 16 bit PCI Vendor ID
+ * @dev: the 16 bit PCI Device ID
+ * @flags: PCI Device flags as a bitmap of pci_id_flags enum
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
index 7c97fa8e36bc..b0add27de795 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
 	return 1;
 }
 
-/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
+/* Looks like: pci:vNdNsvNsdNbcNscNiN or driver_override_pci:vNdNsvNsdNbcNscNiN. */
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
2.21.0

