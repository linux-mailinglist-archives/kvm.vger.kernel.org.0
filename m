Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8A63F859A
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241726AbhHZKlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:41:06 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:23137
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241690AbhHZKlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:41:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uf5TVze+dFa/E3Y8/k5FBBr79361ZTCE32VlwCvmJsC7OVRH+ka8tvOrRGOyvQ+eG2Ab3+d8+jpzssGFQA2N4cZgEVUcgURJ1aKKq8y2oMxdwBjC2JEHuzSyvx5LKfjD01nXJuZKVX5o5uw/zyxFsLAiXuT4+U14gum6s0s+pcqsjWTL4s6WQYGMbx1p/HU/ZPGA/Htlqf4eDkACkuZJoMDoj9K0/AsSXpP3X9BdtaBLIz5YqBJHysWPJPDpUjQ7FyttCc604uOX1S/vX7soC6d/Yz5lak7UhUxzuAgflqIO6u8mU/la+NX8QAwCsLS6sY4ttrucz98J1moB1aFc0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUSn0nEom8rJJtbT4qqyvZpCQGVT0e8L2QpoR5e6e2Q=;
 b=DsF8GB3uLi7c4NW9MgJziJx4CT2bLIr7zed0am2dd7LpkNT5IxC47enk7sqqgdE8y4nJVmJjoM5cIBnJDuQRlB2gLuFtOYrhPf/NU/7k/Pv3T693TL4OHgI3nAmjaoRySqFsumTjKfY368YzZysKexblUta2/jrQc0gLKJjej7av0BfVRt9JAviTWMr45wMrVbDjYucRkzvb8N2yKWS4fDiRCjLoS/j2v5ZG6dn6HZjgghESs6t6SXZUb3P4yM079nddIqJsghZ2fDd48bes8bUZZwZgJiM/qg96ydEdMpYYcQQF0oEwGZkbDiriow3UN/aK4zZADQ5eXgGiuefUsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUSn0nEom8rJJtbT4qqyvZpCQGVT0e8L2QpoR5e6e2Q=;
 b=bwcB1d5XCmps6rwFQ+zVJvlQM4SVQtr47tgGjHUebc7qhXDElpVjCNauxfOJWkcXJ/WcL8ef993tyIIVc3s7ZNp6Rwg/2/+14JHvzyqEfwqir5ld/w/ozIXTl7HXkiOFWM45X8dc6QGL3BVgEoV2963cQ77Ckx7iXRjy5OswN9VlodRcxQgal82c8MwXYCvWvegvAAlJGi7mEb0i16pKeYKW93XDUrZ0q1B+uS0VZBTPyxAQ5aoBtNC3zbeJdApig/B8SD9oI5E8lnAGDlycdCKZ+16/BqXahGx/ukTduoWnVd5MIjSvLwJ+DfwMbaDumGIqCNKc/z+cCt5dfsfZ0A==
Received: from MW2PR2101CA0008.namprd21.prod.outlook.com (2603:10b6:302:1::21)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Thu, 26 Aug
 2021 10:40:13 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::34) by MW2PR2101CA0008.outlook.office365.com
 (2603:10b6:302:1::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:40:13 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 10:40:12 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:08 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>, "Christoph Hellwig" <hch@lst.de>
Subject: [PATCH V5 08/13] vfio/pci: Move module parameters to vfio_pci.c
Date:   Thu, 26 Aug 2021 13:39:07 +0300
Message-ID: <20210826103912.128972-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1aebb0f-b17a-4f0c-a2e9-08d9687de2b1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52869C36F685E8E5ACD0742BC3C79@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmEYR59f2otqhNLWiWUJkw4RtPpFcJ8GgUCwfI0kUuIIehdAkguUzjW/kTRTeHDDlzNQ5dHiHUlV+sxd7vAR0au6aBiFA2n45ZLVVeTZGIennU3/CI9F8WueWGp8CQpsCgpwpHyL1xoPYg3Lm22icfZL3J1qCB1YQ6QO8WPSkKQMJMklkFNkRhkJycGTvZYscJle230iMeiEv/SIeyXJwLJ2KALgzCWGFgf64WWcHYKLdbyOvoxGQ2hVdGpqY2yv0U0/kJuddeIkqJIHFuDUcKxkfqMHzXudH+Lo5EPsDOjt8oFDjHAGhrD3z8D7r+EBsj+IkGTCcTGkxeMKKITFyym0z2ljd1HdGgeb+XQ9sWHfuQn0Uws/YR0unaRxCk6Isjs3fxMEr5F/4EuqCe9vtd7T4Rjv6jTy9Dtd38Py7Hf9ITlu8WE3M04ywhG16f7vTiMG3i/cyoSVXaMx7uhLvhQopQ0+7CP619CzyX+cKYKfsvPMGE79B2ymKr2irpDUaZfkVVrHUGi345WJrCKLNsHpElBaJ3V/L8DqTSogO5yXZyLXQK5mdRWMT6vYzBa/abMZ3POdXI/Pk/bBUk8khnjIVEkl85yDNfXVd/WKkLXPlFz3PHR55vubgb75WQlaDQMpNeCiquqvn/wJbwdE8U0TdG3M27PpRJN/4hLPWmLFuhRp4zBvAuk39cDcBR/hY/NPcG8zjudlLgVkNMwQrQGDazzjC1cpopbdR2PpX20=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966006)(36840700001)(8676002)(83380400001)(1076003)(478600001)(36860700001)(82310400003)(186003)(2906002)(8936002)(4326008)(7696005)(356005)(7636003)(36906005)(82740400003)(26005)(36756003)(316002)(2616005)(7416002)(110136005)(70586007)(426003)(54906003)(70206006)(86362001)(336012)(5660300002)(47076005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:40:13.1949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1aebb0f-b17a-4f0c-a2e9-08d9687de2b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      | 23 +++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c | 20 ++++++++------------
 drivers/vfio/pci/vfio_pci_core.h |  2 ++
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2729b777a56d..163e560c4495 100644
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
@@ -215,6 +231,13 @@ static void __init vfio_pci_fill_ids(void)
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
index 3b3bf7445367..65eafaafb2e0 100644
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
@@ -2121,6 +2109,14 @@ static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
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

