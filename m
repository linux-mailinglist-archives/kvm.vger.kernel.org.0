Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67A83F85A3
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241762AbhHZKlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:41:15 -0400
Received: from mail-mw2nam08on2074.outbound.protection.outlook.com ([40.107.101.74]:14305
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241629AbhHZKlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:41:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQF0W96DuNGlYJd8SkwtbXfRfx44sUQdEa//XCb9n+H/6NkysfhSlhuVvAYfffhz1EIMMN7wDjyr8lwNU5Kk/udR07jAQTn55j1NSNGJoqYowtXCes4doNx0RPPyUtDZq/xRAumww3+jyj168W/EuWYipMOgejgRHEGVY5OUXZQEQn/i+OYPOKJze6QquRw/1m9AFB2eLZsQelcFCrwxykONMJYIPyhxK7uLi3s78ToKe/tPim+crf21aQHGXXl4DPPwLVPZNnRcAqdRfeV6nlatnKH+ZACrK/+NxbnmJPaIApPI+ceyl+Eb2AKA7wZnRPWVtDNP4vnAfYYpRh8oHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/rU0cj/KTs9me/HU8IY83D50+rOHgAuh7b7VcLp9q4=;
 b=oNyHwULbyB06BwMtJQmvbkvOVzUL6Jq1yNkxeHLOIWeTfGJ5URsQPd0G+G7WCJJ7PdCSd1vMCTGJEkaXTQL3REyHEh05yCGbhvvfwlZYlaohas2Dws3r1JsxKCcZ/tnsE8FMVgmWVzHO3pgMTuhTK1r3IKuE5x4dQnusp8XVTIpt6tRak6R/UPrN0AdoEPpw+TBD1bXR+NZyyw1+YNDxl0GV8GfFGH+mnJepy9ZkwLxYPS1Wj+G1rMJf2/epo3fqDHfQHTlMVRgvW5L8T2eKN5TvU8CkHweHDdY3mQKEXsxEgyLk/WCPzM3imsyGxu7/Y3ycdYpVnrYHSkbk/dpmGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/rU0cj/KTs9me/HU8IY83D50+rOHgAuh7b7VcLp9q4=;
 b=bphg2wVTHQxn3ch24oDgNmZt4bsSOwNEwfUOKThj1JD8gUsvkXQq4hMzkp5p6uYOX+Mll8+jrC8bbgqH9WwntuybxeymVdOPW0wPxD1XnJwHf9+vhT+vn0JAOEJC2A49Pmi67s+Fmgq3UjbtLqP6VUh4FWHwC9a2EEouzBjEV9IPTPgpm+nsdw+NiDvBiMWJAYYPHLRjGXvLzaxWt0ErKJ1ra/KwftSkTNE/nmVf2/X1lV4IgahV8GnqZly59iw0BAgArMI2ny0032scMJFDk+Yo+FYDmI7JYda2vx3YzU/xSDfetihX13+QclsdKdd2PzCOTz5agM4LD7pvyr3AmA==
Received: from DM5PR06CA0034.namprd06.prod.outlook.com (2603:10b6:3:5d::20) by
 BN9PR12MB5177.namprd12.prod.outlook.com (2603:10b6:408:11a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Thu, 26 Aug
 2021 10:40:22 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::34) by DM5PR06CA0034.outlook.office365.com
 (2603:10b6:3:5d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:40:21 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 03:40:21 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:17 +0000
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
Subject: [PATCH V5 10/13] PCI / VFIO: Add 'override_only' support for VFIO PCI sub system
Date:   Thu, 26 Aug 2021 13:39:09 +0300
Message-ID: <20210826103912.128972-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eb17815-6a06-4f4b-fdb8-08d9687de7ed
X-MS-TrafficTypeDiagnostic: BN9PR12MB5177:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5177DC36D00C8A13086399B9C3C79@BN9PR12MB5177.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13uSB/dL5/gDwYVU1DjpnN6QBk6beUkgRSWXoJSgZnLK1QkVv8RqJDlH8YNsCATujjhK7/tZRxalajBK7n1PzT60l12tOr+4wbry/uIaOHoRxKCC1EQnKsVvOWBAI1H6GPnqBoiliSCRfasrlpXHw5lvR+Z3tmY5ngKS8FjxKrjXCJnBPJ28/WoE4YBNk5uDIpckfQzoLyVThFsgtL+3W7C5fpcm1fQPJ5jLVsWo1dvijLT+6OK9G9djolY7inE0OlLR1SGrX3XGmile6qiaR9KA3wxAF+sUgDtjVlcZvMKQkNotAq6Sm0h9+STlUXzIBKa4hXOkpfy59C+4mkLjrRwdQsa6GX8+iWVgVHHzxTzxua+GozCZOxAn8joq8YJ6rbqyXSP8EvvmbLd4QbKPHLru9NSGuLQdPLMOvx1iJo2W5lmYM5TPZaIkrX+QaZo52Z4mFSFIFdj3LmXMhrxQFlpYnvYVxU4IcS7bfxr9FohEd9q658NC4nizivCXpgUzBlD46wVsQjq5iNmJBb+xRRKWixQCzAjdKNn9cFl6QNz1TKUpQ3JakGRlOQjak5Ec2cAQxzFR71BHTkgU5oPENqTNpG8+gw8IGKAsb80tqvqq4JlvUO/G3i497NbTNNsYTfRuSBeKrguaFEdRgfogolrPZ+CxPCxpfxqyD+bcPZhad2yfa5uC9Hd6E+SKy5dLiQ6xRFH1eeaTiVvnsNG+Pb7Y/7QNAE4kZ1UvtRZJdVk=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(46966006)(36840700001)(36860700001)(2616005)(70586007)(7696005)(70206006)(82310400003)(4326008)(186003)(478600001)(426003)(5660300002)(336012)(86362001)(54906003)(7416002)(2906002)(83380400001)(47076005)(8936002)(1076003)(316002)(8676002)(110136005)(26005)(82740400003)(7636003)(356005)(6666004)(107886003)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:40:21.9871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb17815-6a06-4f4b-fdb8-08d9687de7ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5177
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

Expose an 'override_only' helper macro (i.e.
PCI_DRIVER_OVERRIDE_DEVICE_VFIO) for VFIO PCI sub system and add the
required code to prefix its matching entries with "vfio_" in
modules.alias file.

It allows VFIO device drivers to include match entries in the
modules.alias file produced by kbuild that are not used for normal
driver autoprobing and module autoloading. Drivers using these match
entries can be connected to the PCI device manually, by userspace, using
the existing driver_override sysfs.

For example the resulting modules.alias may have:

  alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
  alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
  alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci

In this example mlx5_core and mlx5_vfio_pci match to the same PCI
device. The kernel will autoload and autobind to mlx5_core but the
kernel and udev mechanisms will ignore mlx5_vfio_pci.

When userspace wants to change a device to the VFIO subsystem it can
implement a generic algorithm:

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

The algorithm is independent of bus type. In future the other buses with
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
Acked-by: Bjorn Helgaas <bhelgaas@google.com>  # for pci.h
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
 include/linux/mod_devicetable.h   |  4 ++++
 include/linux/pci.h               | 14 ++++++++++++++
 scripts/mod/devicetable-offsets.c |  1 +
 scripts/mod/file2alias.c          | 17 +++++++++++++++--
 5 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 163e560c4495..85fd638a5955 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -178,9 +178,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
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
index 2e3ba6d9ece0..ae2e75d15b21 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -16,6 +16,10 @@ typedef unsigned long kernel_ulong_t;
 
 #define PCI_ANY_ID (~0)
 
+enum {
+	PCI_ID_F_VFIO_DRIVER_OVERRIDE = 1,
+};
+
 /**
  * struct pci_device_id - PCI device ID structure
  * @vendor:		Vendor ID to match (or PCI_ANY_ID)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0506b1a8c921..527a1dfd1d06 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -916,6 +916,20 @@ struct pci_driver {
 	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
 	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
 
+/**
+ * PCI_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
+ *                                   "driver_override" PCI device.
+ * @vend: the 16 bit PCI Vendor ID
+ * @dev: the 16 bit PCI Device ID
+ *
+ * This macro is used to create a struct pci_device_id that matches a
+ * specific device. The subvendor and subdevice fields will be set to
+ * PCI_ANY_ID and the driver_override will be set to
+ * PCI_ID_F_VFIO_DRIVER_OVERRIDE.
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
index 7c97fa8e36bc..49aba862073e 100644
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
@@ -440,8 +440,21 @@ static int do_pci_entry(const char *filename,
 	DEF_FIELD(symval, pci_device_id, subdevice);
 	DEF_FIELD(symval, pci_device_id, class);
 	DEF_FIELD(symval, pci_device_id, class_mask);
+	DEF_FIELD(symval, pci_device_id, override_only);
+
+	switch (override_only) {
+	case 0:
+		strcpy(alias, "pci:");
+		break;
+	case PCI_ID_F_VFIO_DRIVER_OVERRIDE:
+		strcpy(alias, "vfio_pci:");
+		break;
+	default:
+		warn("Unknown PCI driver_override alias %08X\n",
+		     override_only);
+		return 0;
+	}
 
-	strcpy(alias, "pci:");
 	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
 	ADD(alias, "d", device != PCI_ANY_ID, device);
 	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
-- 
2.18.1

