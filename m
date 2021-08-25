Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8A73F7687
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241537AbhHYNxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:53:34 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:46625
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241539AbhHYNxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:53:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GY6SFbqXBhsO2iMl8Ml8pNFJ72wOZQxtOAal7Gxa3C+WcXDwek5Of6muqYF/Gimaae3uCYU+T3KvdmsDEoxi9NSymdGB7feoYG87xOAsoO7GaiuGUqI0Ag96uI9TIxhw3DTRD5hgloVIuP4PUAnrCgDCOWeKHQQ4rpa1iBbBhcf+KWqZF0sQeEnCflo6AyFj6vxiePVzgsVrVPy1MeD4yt4poHtYNJ+MUh/wCesyB52YhRtbnTjpPDOYVP4nBLI7XoQ8YiWl8HHyR96m+iEwSE3xbdKfFTdkp2g+EWBazH+NdNq2HE0pISmKKSplZVxyCWeXtdC3ep7K0w5j151HRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lybDEgD89Iu+brGZXFo8/8cT6avyp1myjn9U09oznq0=;
 b=Mq5Q8H8SfzhcZ/U96oZsX+Kh2my06wXkbqXD/I8QqVfspG5UJZadWKeKXAjcNvHmK0QizfYsl54z9qgsuhE+gClCXBkfsXuOSfNEhuxFtg+YQ6VUNkQvSGW3ofEqsWoRl9jxTkbWLsQrxKRfEP8xbsRUpJu2139hcN8IjVa7FQyUUilqHkCv9cqHUFYZ2p1jcMk7/REUKjMQUaKL9JpmKlLckfBwefNCgLcVq/eTCgb1PXD7PcpL6XDZfn0uP9cPwrbR+sLVLgoluGJ2XTTy4Rc3DyKk8fSyn2TaEodmu2IMn+7eAYN8yIVooC+lrLt9LXMRaoU+PRrTUAsl+mS7iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lybDEgD89Iu+brGZXFo8/8cT6avyp1myjn9U09oznq0=;
 b=eVFAGXMJMJf4yg5eXCweJ0CESUIUEGF+k8lqx5EM4U+2kDwXO3SAV9tDtOeD/bxQ/U9DSzqxwYbakOjn+MEWaGAymfEd0OQJx8+BX4uotgZtY9CPMQn3U01dyDEK7nqLs24ySEFrL3rMX9QhYOmfM8Noj2E+8TZiI1YSVxTHY0K14I55WKajH+ey/WvdMeNq0hIpj7PFhlYvcmrH0tlrACOHGoOVWhpel/OXGl6RsmKtHhlPUiPELY2KekUR0KlDbfUAPFknTKefoqYknn+ym6gB2vsbGW+P+lKXQ6CJKX1xHsHUaHCPt3NzBiAsnDWD8mNa+gR/PgZSasc+GiyRMA==
Received: from MWHPR22CA0062.namprd22.prod.outlook.com (2603:10b6:300:12a::24)
 by DM6PR12MB2731.namprd12.prod.outlook.com (2603:10b6:5:45::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Wed, 25 Aug
 2021 13:52:42 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::cf) by MWHPR22CA0062.outlook.office365.com
 (2603:10b6:300:12a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:41 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 06:52:40 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:36 -0700
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
Subject: [PATCH V4 10/13] PCI / VFIO: Add 'override_only' support for VFIO PCI sub system
Date:   Wed, 25 Aug 2021 16:51:36 +0300
Message-ID: <20210825135139.79034-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fef2c87e-6b77-4e4f-533f-08d967cf9be2
X-MS-TrafficTypeDiagnostic: DM6PR12MB2731:
X-Microsoft-Antispam-PRVS: <DM6PR12MB27316BE5C9D54480E772DF61C3C69@DM6PR12MB2731.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TIdk0aW3S8NEixzuUWMNOJC3RqAjJIi6Rd6b56MXuw91BR76laf78FFCU/gYqgBGt/ZwcVsfLczl2RBjjs2TV7yjCwA12H6ndf5UpVj4M4d5it7pqyz8GeSARGrVPcTBthW8BD0J2Sh9gj3UANLurD52mRuBC9SNSanO5tiLB5bHAZW/P+EexnLBo2JB25WmjtN/+RwN259T0Quf0/y83lAwm6PnL52qLk2h9DEqzFv/KVCXAdltGVLWdjBoNDBJpj4fWeqf19LXlsrVLO6lPQNQHANrL8i6VcIK5h/K3nlViVdx6Yn16cUzfwabIWrOqmCZ0nRyigDgJfRvAx8M9DzdDfpkRnUJ3pKoVpG/C8mWWoisBihcopz+JIsYA/uj7x9wEJrIPra182BKeQr0oIBR5p93a1KbI+gIs9gRJpoVBscU1m7sxOC/dbXFJNYLfjHXAqv6Wam0u2cz3zr9nChqUPohoXIes5dE0k3cyY+twkd4Do7GkrFyfxVcYmWyTY8c2cJnkmuxWWGG1Pu5/Tf0rKEPGmPMOOziS23d72K2oETB6AHlkT6SzzG56mE8KuZkGm8sT3RybryriGh6livf+hdVlyNfmkTpizY/wi0yYKzTqfAG3dUMaQrKLRU4+E9OnY0sInk74Kh/H3DIJ0LfsBzNIJhc61GL+Pn7wh71sFXK6DMr0yrcMcxBXS0NUydfnQ+vWH+4b4DvQWOfWk3e885Sz2lqz+GuNztGxxw=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(46966006)(36840700001)(47076005)(7416002)(186003)(2906002)(7696005)(86362001)(26005)(1076003)(478600001)(8936002)(8676002)(336012)(5660300002)(426003)(82740400003)(54906003)(36756003)(107886003)(4326008)(83380400001)(82310400003)(36860700001)(316002)(7636003)(70586007)(70206006)(356005)(110136005)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:41.9618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fef2c87e-6b77-4e4f-533f-08d967cf9be2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2731
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
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
 include/linux/mod_devicetable.h   |  4 ++++
 include/linux/pci.h               | 14 ++++++++++++++
 scripts/mod/devicetable-offsets.c |  1 +
 scripts/mod/file2alias.c          |  8 ++++++--
 5 files changed, 33 insertions(+), 3 deletions(-)

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
index 2e3ba6d9ece0..f0325a172f87 100644
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

