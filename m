Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1380B3F3FFB
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbhHVOiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:38:18 -0400
Received: from mail-co1nam11on2048.outbound.protection.outlook.com ([40.107.220.48]:30241
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234338AbhHVOiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:38:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghr/dSjW2H6PmdxwzkcTslRAwGnVuF5Gu79MPPij2zPFx1YqwXxR49ZlPvCK2JZntEHHmhFWCvQ7mwhdPjrdKIms4w4KLywSPqql66jRwFuznEgt8WOifTi8hbzJryVcevyuzxqzK3funtDTeSZr16J41Eab6a0upo21xBXBJIOew8En6mIUcTWaHJaguMVK0PzNpqxOAXfGbd0YEn5PVEZcKiRLoLl8rrb/XY+fXgFcQ4TB64U4HvNqX1wgxfdNiXrmr0uY7MvzjtTlGtxtytggzkapHS+F3B7Fo99f86TlOTqvzLjNdGLKk9/seJjujH9WwQagP6yKA/FyTt+n3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uj+3ioZ3rFnPuyn9z8hjFqn7vu7tqJUzD7slM5gcNUY=;
 b=K6Kw92prIdK+QuH52tWoqo5Yq3RJborgDyuB7/wiaCWQ80xmTYSgPz3XkILUkQQmM8Ng8QENnrj3dsBGfIq/tsyJzTpsm2InYnDXY8DziprLdkWxb2s2no9dUzGpFPRzTowZfV8fFxCD7NmXseCnGbrdZBSD4nz2qsXyv8tMHEkQAffQWLH2h6An9zo6xq+W+gIW15GuAKSknauFjEvzKH2jurHtAhnc7gFCCat3oWkT9WZw9xsYbrEEHu//x9s7hknWJ8uDJX/eUQ8N6Ly05aVGwSknu7VNlrO1JCA3pGygfyghks6wz0Jr6V4w7KI0zRMFst3CJ7TV9LKFU9oPpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uj+3ioZ3rFnPuyn9z8hjFqn7vu7tqJUzD7slM5gcNUY=;
 b=GyzCh/M4r+VjUnAXJtCabl1yP4gxU8Q/bfqJdtfmeyc7oAQiNv3qj+tYxOFkQSYRCcHhvC2wTaTyd23iToDAUp02LauHVVtoRAIOrh5b+6xa6XJ/PGYan1qgEi3YTr5VxY/SqC+W986Uef0XsZj734+mow90AOdwKxKIyVPayFyI7k8j4E+8jWj/V9TYFvtoIUTE5oHOmWCUQXUYt6XIAtc7IPUw7gSM4XKsX9QUDzkz2kmerEYqJ3pkippgjDPW/NqCrFcMdSQ1ApDxCC3buSpRBjKJeod7jLH76NQJGFTINX3PDJfnOoaIf+N7xFulSfpfkmuybLsZmr9nL/rqbQ==
Received: from DM6PR12CA0016.namprd12.prod.outlook.com (2603:10b6:5:1c0::29)
 by MN2PR12MB4254.namprd12.prod.outlook.com (2603:10b6:208:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sun, 22 Aug
 2021 14:37:30 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::af) by DM6PR12CA0016.outlook.office365.com
 (2603:10b6:5:1c0::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:29 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 14:37:29 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:25 +0000
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
Subject: [PATCH V3 08/13] vfio/pci: Move module parameters to vfio_pci.c
Date:   Sun, 22 Aug 2021 17:35:57 +0300
Message-ID: <20210822143602.153816-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 907617d9-6f11-4939-0fec-08d9657a5eb6
X-MS-TrafficTypeDiagnostic: MN2PR12MB4254:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4254C1B34BDF0BD9A8A25AC5C3C39@MN2PR12MB4254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S6GQKJ+I/xQcypA1mU4nTIJ/CMGLMUshpMX40UaBpHbNH4mwuO338BQlPUlOEZR3Dm9hfe/sq7kdUF1u23qOQqVGgMUetKF1wzsL0/nk4uM/iPsEdmfPG/IKNtK7MGqUc6WajbNTYz+d4AqFOsgLYopb3Hk4W7G4oEQ7qQyfXbiJFOruJpi/tOuwunVDgm2mbQWHfBwvHSZUPTzND3/4J4eDrxkxkh4X6iseNChNc9mMxy96MqwskJn6xSMU+CPBlVFO9L4N7G187cv1b6F0ack2nGAajUmPabPsb3Pl6SUjdMZ+jtOc9wp4NmZ9HwokiOaxU2Vx9uofbzKKazFLGocLE2hSqYn0qASEJLM9EQM0/WhzoqGcI78IEGU6fpigTGvhWLEndUfiFflPOxGWlA5IAz9ZWNyX8oxv4KHYWg7W7pGChLvrs077+n8II08AqvHNfRPtt76EwSBJ4mk0u3UPDUrupXcf3G4gXJ+7gVm2HbgZ3Z4ejDUuhq6soKUQ3nlg84KKZIdY14j/0tEZZnuWntuiLVPzohesHvz5pwox4rzeKaPRa+mBa+OtO18Chc6TlGBOv7WoLtczs/J2HmcJBrWye5IsokvqcLGHCTAv1tQLUzB2bj/MVy0kjxijmqyHOFB6hstxJBQowU9IFj9d+o0J33lv9wnTOS/eGvBGO4qa8uWI/x1RxZM67Hvs+Jt1uRTnI1dRyIynqHGH1mccEjKur1ehlHQ+IcQdQxY=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(36840700001)(46966006)(54906003)(36756003)(8676002)(478600001)(4326008)(316002)(26005)(8936002)(107886003)(1076003)(186003)(47076005)(2906002)(36906005)(2616005)(110136005)(5660300002)(36860700001)(7636003)(6666004)(70586007)(83380400001)(82310400003)(86362001)(70206006)(426003)(7696005)(356005)(82740400003)(336012)(7416002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:29.7961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 907617d9-6f11-4939-0fec-08d9657a5eb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4254
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
index 121a7296ac63..07edddf7e6ca 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -34,6 +34,22 @@ static char ids[1024] __initdata;
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
@@ -217,6 +233,13 @@ static void __init vfio_pci_fill_ids(void)
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
index d4b3a53ee2ed..8908725c13f6 100644
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
@@ -2123,6 +2111,14 @@ static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
 	return true;
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

