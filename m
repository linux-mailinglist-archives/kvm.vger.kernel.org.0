Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A1C3D13D3
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhGUPhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:37:23 -0400
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:12928
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233381AbhGUPhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:37:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQxdmOjCkFD7EaMoDG7ULCd0KjS4ymh8eDRNrXf3d7IbiHdwCmBzeh+2oYPCxV4HJZT0LRy1c/Oy5byQjpwcefVQlMX9C81WIhEmcxZHhssOZCFUdW1AZcaB2iPA2BQWp67+vprgp2yMtF7kvAc6eAc+5io46Emgq5sk/m4u0p7qyzTVGeWXMmRW1miau3H4OwNG94GMOaeiCcXvy8LH3HVTnSut24i0vBr0jtsGbim3qANpPYpYbTXfZBy1jIkDIdisBxdkWJZ6rsUwwiGjKDtXTjKCahsvZxzdVsarRjKzE4mgzA5y2q239MwR9VbkTbhvf83Ohhrku1fZyfEHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDwnuhwu9zlt3ojB5mAuwGwrJEJO1LTKx3B2owsvPAM=;
 b=M+3tz2itUD7Bsd6AF7KSul8kfK+2o735M5TDWwxfJyzKwXeeYYDfVRYHNs6qMLq/htix1NNkmcKkEARGMWjUm+fP09TMV9gd4VJSlMAkdpILeZ4aYO9gipbsaZk3SfKCpGavRAAYzvKWUq0n4/hePlkltNRCbT1lXI2PgdOEu8Zb4YXkOJ09LXO1G7yTI3nJLKUQiI30gUGlu167Z76s8QDE7DKI/QNMwLr14UpzPKKJi8ejVdxXzWmyfLNPUWe8wgoxVQsGDzky6dDHDaq0Ni5GcI0Fe9fi9TLgicHOT178yxXieXdERF66GA3rBnGT2NqGNZhPQ4ZcStdebUfPbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDwnuhwu9zlt3ojB5mAuwGwrJEJO1LTKx3B2owsvPAM=;
 b=ENxsoZSj8d3NvUDYEvabo8Hou+GFm0+LaYBV8s/E6oXSXhU9rV26jf8uNs8lyhoKc4b5vcgvb1UFIs5/fQdQaQYGVvzjIvgAxyaWJZAmWLP/eHm238C4Tf3Pm1lisbxY6Nnpv37Nkogy5WBaIqdwh0OH2JnsTHY+7kKjDGJZ6acNoEG64EEXqImFxrKGkeoZ5qNyCMHNq8z+725yr9718IkBJNLvcchJuTW9PV4vu6fJLReNZcECLLl43g9Cm08vXTRcp2qbUKEjzh97n4UFzapuFK29iDlzqL8p/gTv8rYvrAK3vbSOEnRbAkQilXYybWfUhkRQASWTER+P5+CtKA==
Received: from MW4PR04CA0285.namprd04.prod.outlook.com (2603:10b6:303:89::20)
 by PH0PR12MB5435.namprd12.prod.outlook.com (2603:10b6:510:ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 16:17:57 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::2a) by MW4PR04CA0285.outlook.office365.com
 (2603:10b6:303:89::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:17:56 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:17:56 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:52 +0000
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
Subject: [PATCH 08/12] vfio/pci: Move module parameters to vfio_pci.c
Date:   Wed, 21 Jul 2021 19:16:05 +0300
Message-ID: <20210721161609.68223-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8df7e8ed-ab1a-42c3-04ae-08d94c6319fa
X-MS-TrafficTypeDiagnostic: PH0PR12MB5435:
X-Microsoft-Antispam-PRVS: <PH0PR12MB5435A279648164C7E24B439BC3E39@PH0PR12MB5435.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiDx8wmOSAsITJcW/dpQnqxYcdvbSqRKfX4JUH8E63H9AhNAV8wUvgIhu/RGh9ELVbaV3UuCScc3blfUwtbrtPcvRWD8DINgv9HGPT8LhJKIdPZAsflkXsJLk0jTDgZMJYqCejgA1qsxuuttwoSVRYiLDf6k/TELM03NSFB7kou912Xm7/2HYIW0RZsZRKIOZNvImvOFaua50p2i7Kudhsicqjbg8J43DSfpc3qj/rgQ1GlAyEsKvibbQfZCGmZIFmx1NSnAuLyUUxZ/Zxtl6kfetdE+SNhe9IGZxoc392BhUQUilK/u/33A/7yNiIzJn5aZcgNtgSq8gxUvIWkEdjLpJHoaaDsxo6PRw/cdOwlWIF8Txqxy8l+oHp6pCO0LOK6cqs98vL8bm3Og6Qs0jhvzG6hC73xi2EbOVDxBUUFZYJ5mTH3ELffFgCVkeFOHfrAj4buE7f1Fo6aeQOZuE5UtEidcAe3NSkoVou/yY0LoqGwDWu5BLi4nYK4SMqLkg+hi0M+pxSqhM+uy4JxIzgSyaDYSfGOVlQ/mM/GrMY7wKq0rhKW/LJfp7G1KYqoRQtV9womzvIdP3xeySJ5dA6xeIDjmJemojDTR3YkqSaUj9+VsCJLBZSHn+6Jul5qJ5mBiZgC+FQHeIPiDtqM6eua0b8HmiaKEsXImlkLXh6d1E+Vk2LQ0LA9eXuzdfPsRok1oqW1aANV1MYUCSfnh899/Q7P7MchckH9g9fBuNXg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(46966006)(36840700001)(1076003)(7636003)(186003)(4326008)(83380400001)(70206006)(7696005)(7416002)(107886003)(478600001)(5660300002)(2906002)(8676002)(26005)(82310400003)(36860700001)(356005)(426003)(6666004)(8936002)(2616005)(336012)(86362001)(54906003)(36756003)(110136005)(82740400003)(316002)(36906005)(47076005)(70586007)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:17:56.9755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df7e8ed-ab1a-42c3-04ae-08d94c6319fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5435
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparation before splitting vfio_pci.ko to 2 modules.

As module parameters are a kind of uAPI they need to stay on vfio_pci.ko
to avoid a user visible impact.

For now continue to keep the implementation of these options in
vfio_pci_core.c. Arguably they are vfio_pci functionality, but further
splitting of vfio_pci_core.c will be better done in another series

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      | 23 +++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c | 20 ++++++++------------
 drivers/vfio/pci/vfio_pci_core.h |  2 ++
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 801f66454e70..0272b95d9c5f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -35,6 +35,22 @@ static char ids[1024] __initdata;
 module_param_string(ids, ids, sizeof(ids), 0);
 MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
 
+static bool nointxmask;
+module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(nointxmask,
+		  "Disable support for PCI 2.3 style INTx masking.  If this resolves problems for specific devices, report lspci -vvvxxx to linux-pci@vger.kernel.org so the device can be fixed automatically via the broken_intx_masking flag.");
+
+#ifdef CONFIG_VFIO_PCI_VGA
+static bool disable_vga;
+module_param(disable_vga, bool, S_IRUGO);
+MODULE_PARM_DESC(disable_vga, "Disable VGA resource access through vfio-pci");
+#endif
+
+static bool disable_idle_d3;
+module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(disable_idle_d3,
+		 "Disable using the PCI D3 low power state for idle, unused devices");
+
 static bool enable_sriov;
 #ifdef CONFIG_PCI_IOV
 module_param(enable_sriov, bool, 0644);
@@ -218,6 +234,13 @@ static void __init vfio_pci_fill_ids(void)
 static int __init vfio_pci_init(void)
 {
 	int ret;
+	bool is_disable_vga = true;
+
+#ifdef CONFIG_VFIO_PCI_VGA
+	is_disable_vga = disable_vga;
+#endif
+
+	vfio_pci_core_set_params(nointxmask, is_disable_vga, disable_idle_d3);
 
 	ret = vfio_pci_core_init();
 	if (ret)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 811601425798..e65b154f17c3 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,20 +28,8 @@
 #include "vfio_pci_core.h"
 
 static bool nointxmask;
-module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(nointxmask,
-		  "Disable support for PCI 2.3 style INTx masking.  If this resolves problems for specific devices, report lspci -vvvxxx to linux-pci@vger.kernel.org so the device can be fixed automatically via the broken_intx_masking flag.");
-
-#ifdef CONFIG_VFIO_PCI_VGA
 static bool disable_vga;
-module_param(disable_vga, bool, S_IRUGO);
-MODULE_PARM_DESC(disable_vga, "Disable VGA resource access through vfio-pci");
-#endif
-
 static bool disable_idle_d3;
-module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(disable_idle_d3,
-		 "Disable using the PCI D3 low power state for idle, unused devices");
 
 static inline bool vfio_vga_disabled(void)
 {
@@ -2099,6 +2087,14 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev)
 	}
 }
 
+void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
+			      bool is_disable_idle_d3)
+{
+	nointxmask = is_nointxmask;
+	disable_vga = is_disable_vga;
+	disable_idle_d3 = is_disable_idle_d3;
+}
+
 /* This will become the __exit function of vfio_pci_core.ko */
 void vfio_pci_core_cleanup(void)
 {
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index ffaf544f35db..7a2da1e14de3 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -209,6 +209,8 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 /* Will be exported for vfio pci drivers usage */
 void vfio_pci_core_cleanup(void);
 int vfio_pci_core_init(void);
+void vfio_pci_core_set_params(bool nointxmask, bool is_disable_vga,
+			      bool is_disable_idle_d3);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
 void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 			       struct pci_dev *pdev,
-- 
2.18.1

