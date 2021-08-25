Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E0C3F767C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbhHYNx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:53:28 -0400
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:13761
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241548AbhHYNxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:53:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0X+OOiHm0zy6fBjmhD5AAMonlszVMvZjcRr4AInWHkjP0rpZhsIbcR7T6Gs/C1bNZG8NJpYSftutOVX/w6Xs3orp/ssjS3vUXCelDX/xIP3+c0NPXXDeno7COfTjqc7V0m0kGX5lBxo9WnlKsIpUthcDgg4DRSEXzY+QdiAFkvkEHAdiYlhQaVaQLbdwKnV4dLbTiwnHkyt3ztVE0DQMr0Y5Ik0SZezMpSb6fBKFN9fd/xUWUIiSVX8K2fYF9pfTePbJB+O9zxY3joU5ixeq7pxl6zoTCOawR5GZoA9GAg49cLDlUmFVJBX0+OhXg99TvCws/sRFPublSlWBaNIOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UHQwRjPpZ2S7q9O8WpCaY6gZO2rDNrbtMFwTeI8xws=;
 b=QilhA+801L4Ag9bHlSdQWPv2fE2lCnwMjKdKcJAi+Qwqy+lrqL/rIv0WkDILmKKT5Q8AFWrl24tysUFC1BzlTMJ+OlQA2WL9Sq/2M8Jrm6FKvD75+QTB2H/lBz3+v0y6XOQYnN/cyHR2SlZBYoEW8Sc/gbJheBiXUujQLalv6rnpRjviYfecyu2LWiM/c5GpDl+1JOMrohPI+WDhEwIFVQRhCV5uFVsLAll0uwZpmhos8lC3cc0be+UEB/fDMaAq94NOA/NWnTTVXI9Cj2Ph3E6m+ylip/o0hEAglHHtPVzYSpMJNnPTu299EDSTRypNZvYGwpom7Y9YrSykWCZUpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UHQwRjPpZ2S7q9O8WpCaY6gZO2rDNrbtMFwTeI8xws=;
 b=ksxo9bLi5rZsiJZLwC921bqzDYB6X+dAxqVzs6tglqAm1Eaylfi5IqEyJMWApHsxYCqdX9NTMDPb9HrV4e1v1X05uCzzqdKpCBWhglJ3b7Gt7FUo6LPfoWVEiU17u5MGjdO1o70IxQIiFjeZOIVf3T04FKe8RQJrvItz93VExeYk2lAeiak6D/xXHfKb9yE6qO7pH6/XbHJx7aqyancNcNoZzMPK2IkuxFl0qa2BqMM1McSJ9zuMfujppTpQRfMEQZiLwf3tb3zaver+ZxJv/cIGCVrUniBRj+rGUj6wUvdUfzNH/TCpD5VqSVDlO9WUtS8pHGHRdozu82pbeZue1Q==
Received: from MWHPR19CA0069.namprd19.prod.outlook.com (2603:10b6:300:94::31)
 by DM6PR12MB3403.namprd12.prod.outlook.com (2603:10b6:5:11d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Wed, 25 Aug
 2021 13:52:32 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:94:cafe::4f) by MWHPR19CA0069.outlook.office365.com
 (2603:10b6:300:94::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:32 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 06:52:32 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:28 -0700
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
Subject: [PATCH V4 08/13] vfio/pci: Move module parameters to vfio_pci.c
Date:   Wed, 25 Aug 2021 16:51:34 +0300
Message-ID: <20210825135139.79034-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 957c3814-3789-437c-bf7b-08d967cf964e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3403:
X-Microsoft-Antispam-PRVS: <DM6PR12MB340389ECBD3D4C9B4B4E6A08C3C69@DM6PR12MB3403.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tv6ENG2GZN+qmcgDTthlOrCEc7wqw+OB0F2gsM5sHRkWnD4TLORJEwEOFK8mb4WtpHLTfYZ7EhCsHDv6YBT3292aXfDm4ntHeSt8imrYJh+haiWQrpW9w/uouzWTSQzpIUDntJKdsamA7n6UAG7x2AK6WNG/CTh3yGnlLDPboj1uuaAobSR1QV3Wh1q1mnYeOr5OFrVV0nHY3d5PNC86WCxscycPUeM3zYMGQT9ZbP71GyJaqkhtdBRMHc6EoVIxnAA1Y0DOOYLJ7Ix9AsjJ/NKj/+kg2GgtxU7QXeY9phi2aE3ny14fy/DAPWYsyAYf3RB+MgJaQ16SfO7OaDpDS+GPi2S4rcvGLx+SzhUtFkQTwqxSxyCW5kGmAhrBhmg/NYGAKYlB2GykNdms/vVCtK+RirXhbbesi0TtwqeVAKTVhm6J1WzIGTYRG7a8jEt+Zdp/OMRvcgauzTvRZcJsHwW4H77df66ZidF/MA5zo3xVzTFejyxQmPiIqLo4zPIR+jm390aw5Fv/zOteenL4lW5YqnpLbeYGR3HvvMNV5MU2uB2RP3WLBQxWzVoQiAy114EJvH6W1MgrHDqBlnLWE+XTANS2hX5eEMu4X9tdqk3Jm2efM6Ya8yD9S0bpX6QKpQvpd+BHGiYa+c0l1whYaLIGH35TxOmDUVDBtTu5sNqw/L13Or4kPtn727xvtRWlZG1UAg/ZyTF8uZmODJ0Cm/f3pOCsjKBG5NNUxF2o8Yo=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(46966006)(36840700001)(107886003)(186003)(7636003)(36756003)(8936002)(1076003)(336012)(26005)(82740400003)(70206006)(426003)(8676002)(6666004)(356005)(36860700001)(4326008)(5660300002)(47076005)(110136005)(54906003)(7416002)(2616005)(83380400001)(2906002)(478600001)(86362001)(7696005)(82310400003)(316002)(70586007)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:32.6000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 957c3814-3789-437c-bf7b-08d967cf964e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3403
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

