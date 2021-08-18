Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8031C3F07E1
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240043AbhHRPSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:18:13 -0400
Received: from mail-bn1nam07on2079.outbound.protection.outlook.com ([40.107.212.79]:41479
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240000AbhHRPSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:18:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvM0Ig9YIkmqDoptiCG9iAr6C9/kdI8ECwqHOCWAJnAiWskW3deQ4yFbvfBzdeB2Ois9koOl5Dgx37PPgleOt8dvZ5R1jvt+zhP0VrXAW2BBSf4xpT2pNX/wfbtClOfbxC/OiGpdrgbGb+1VZl7aXzFLbFxEcByt9ApQ9gR4j9tpYr6PsOoSPwR0ztK1OExcgU76V49JGjCbcEnTWKo3Bn3Hs4Ho+1LfgeFTj8isa5H4uFFF+OGSjJvN7zBtiaj9vSed9iFGIJiFv1YcQ/TCOpT6NT0ZRw9v8ix3sB+Cmw2T8h2p1YTLxbGvmxDwBxW+M9ckPRzwAoB8hyXhOlyc3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtEHt0mbBXSTRf9IrEgC5X5UbbT5Zb9pzcA0RliKvI4=;
 b=QgzM6mCI0YO537ussLJ3VUY2CMAaRwTsg8cGzYpEnGLt8zWVtVepQIbZIa9pjjq0Gy4QWDK0GPaxKdWFJi7GGkSZHI4Wl0f7EfF6B2J46/g1oLMInHuusI+PAmNtlSuyUuyNltrVi8H5PPN0JSRhNL5VXr+xWJXWnht6fZVn7SC7qxQl3zp/HhGnsheL1FC34vp8O/qVIwkOGDmgddLtQh70sBP28b3OWiPMbM0GnlssFV+sGDm8KAANUTG9A/nJ8bbp5PbivIA2rH6BaBgfChROVjwplCH/io+nILyHU/ZhIG9Zo1tnzdn/WE1em/GqsaH8hGplbQXtlQDhLAz/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtEHt0mbBXSTRf9IrEgC5X5UbbT5Zb9pzcA0RliKvI4=;
 b=QU93LLNwG4g91Q+IlvFRl7iS91q/9xVkndrX46vWtimOzB9IQX+PgisYoAQ8Kx1XLD5P/w52F7zP18en8Hgwhml7rF+zstaxZ6+Idoz5VYefnyAEKBrdoIRY1cvlVEAgLnpxyKlp3ha5NbsP7+M4s6bzZT5VYJ2DRfw7FbEZ9dsGTcQcplRlcUKL4cqnbLRfQxVzFVRtMq9mJ2SLgFG4k/DckX93mF89xVClv33mdsiAuGLTWE5wJbNADVFpcLyT3ZWmErPvgfgq4tBXb2W21qOBiVT/838OKvcFxYxc1EiGUXTHnXVWlRJeQ3b+ek7OlvyFy7D0UuvSCtXnH10bjg==
Received: from BN9PR03CA0195.namprd03.prod.outlook.com (2603:10b6:408:f9::20)
 by BYAPR12MB4982.namprd12.prod.outlook.com (2603:10b6:a03:106::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 15:17:21 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::7e) by BN9PR03CA0195.outlook.office365.com
 (2603:10b6:408:f9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:17:21 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 08:17:19 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:15 +0000
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
Subject: [PATCH V2 08/12] vfio/pci: Move module parameters to vfio_pci.c
Date:   Wed, 18 Aug 2021 18:16:02 +0300
Message-ID: <20210818151606.202815-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 689f14eb-4508-46d5-a3b5-08d9625b46a6
X-MS-TrafficTypeDiagnostic: BYAPR12MB4982:
X-Microsoft-Antispam-PRVS: <BYAPR12MB4982A42386FA093C9054F73BC3FF9@BYAPR12MB4982.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUjxEg8vI/hT2JnI7rxqWb3aW3SkZPFUsIqpHx8FgVfSE3fxe94voD38SUvnqia9gRC13O14AiFCVMrKkuycsaUPpGlKwgsP0k0NJaDYLqW9tWP+zGObH71pr+MtV3JQc33PcCUhfscpB21fCgFCVeWvl2RDO64Mf68uCUzDWuR601ffoyKi0GmQNFVlICGkq4XyZP3zAHxWlK0y+JzyqC3C96M4dZdIyQy7MHBD7l4jWBuw1Ldzz2tb1GDNaQLGE2zYcs1HTestaHy3KRfN9xs8zjieSvvUqKhLGds4B/S2peFiKhF6cw9XA+2FgekBiH4Nlm1LaKggajxsB42hTbq9+lItN/y9P2h0IlkTf3kII2eT49UTcjJm9I2dJ9nLXbT7ZtGnQ/PpEM+ttcH+Tmxe6lqpRUW2L8nVBc2mtiuUFYzuvY/9IZg1k9soqybVku9u2t7v5WJQXuKuSFU18glzhK+dUNX4F6XVaEPubimJg9ntwnlX0odXrZ7ia6EWNk0jS+6FLPRxNGh1h+CwVx30bku/j+iydPU/CU1c+sDF8lQw1EMHkajf7uFdO6P+OnYHaT2wB4m+p8oJ66/UrT9lnRDU8Vry13LOhryiwvGZUFfR7vlGXtugILPc1IYctCOdm7KYBhwz+8I5FaW+oC6w1NZmAP8CTWhmAwx0rFvCtlculvWab3f5v1ToXURUEvgjghcRycytweHhtN4UFQrFHYm4D2+X/Ue7QYMehJM=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(336012)(508600001)(107886003)(110136005)(5660300002)(4326008)(1076003)(2616005)(26005)(186003)(54906003)(316002)(7696005)(7636003)(36756003)(70586007)(36860700001)(8936002)(7416002)(426003)(8676002)(2906002)(86362001)(70206006)(356005)(6666004)(47076005)(82310400003)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:17:21.4748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 689f14eb-4508-46d5-a3b5-08d9625b46a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4982
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
index 5ed2490d4f39..6ecbab65a262 100644
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
@@ -2122,6 +2110,14 @@ static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
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

