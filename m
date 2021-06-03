Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B055D39A562
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFCQKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:43 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:63457
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230097AbhFCQKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmUcG8ZyPDYfn9GM5Tu8qfQd3pRignaJ5FpTDpnK0Wb+vLHu2qfG2KiyoQlRns08dXhxU49l4QsMWSAeAQ+wtpA88zGaWat5jrX1GBYv5QIm5Tmqbm9KTsKf31caiDPATq1fCGZClCYVgIMUbjeAIz1xBJ03MisBdRtpt96OWmXVlsDyQwTeSGTTGRjl7WVdIURa8GtXqF01v0ULmj9SxruU1/vZN3JYHBCxT2uV7WTYPAK5Jauy60Wk5NiF0QFWz/aEliaFm1bbH0U/UhOkFjlDNaD2NXfnKSmkHG2EbTwjiYMurUxeQ4aDTk8O+xekc3zj5zBKbj43VbuuNbPjsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEHiwdaurHYJn0FoiiuZooTSByuH6O61okuZ1PXUgx8=;
 b=QIK1WALfeirLuDuxxvahU7d4+iUHV1pWLlf1oLOuCr/ZeBlyd321P+zUIsbl2oDmC7SMXZ7GNAx90BEXFeURrEUAkiMaaXbwujnipSJCjXf9vJwnZ9m7EK9axWkuU9tkc/hUep07qOBf3bzL5ga7Na/dNuXlisyNXBSlNS8A2J3I9ag0EzHTu5GWgMsgjtbFGDopEf62qYn67KddN06V7x8jLT0aPcNbHo4I86/Qj9Dz8lnr86ib8FLQ42QMiZ3hL/izk5Z1vXWpOss5TAn2YfAagjedZBPXK0mpPcXC25jBMwFumEK13AoH1qp++6WCMgmsnUTxtWbQ6W36icnCZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEHiwdaurHYJn0FoiiuZooTSByuH6O61okuZ1PXUgx8=;
 b=EVXSnb/ly9mB7kofdKM/XsNuIn9sNor4llXjTOybWtLNChE9g83pcwuUPvjlY3iLAwn9OxUQ3bfvlYnTAKnM4vw6vmXs2wvlkHY1FTYNfLDHOxZDHxt6mKlEDGx8MwfOUtUTsZVn1ObjYxYqPYqjzoGhzadRb/hNZ5Ed00tiqwOUtRcWhXZzqtUuutlKW64iDolibcIAy4+kl5Krh57OWY380KlzrH1goHTl29k5ipjrEL06n+u0J1T0F6QCipUrVC8N4keyvBAYYrQ1HmF8GAGbqkfd7pqHmeNT7EIwmknNTpTVNjsHlyy8ESePVUKLjlJE2y5e81brxGRc57VdzQ==
Received: from CO1PR15CA0059.namprd15.prod.outlook.com (2603:10b6:101:1f::27)
 by DM6PR12MB3465.namprd12.prod.outlook.com (2603:10b6:5:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 3 Jun
 2021 16:08:53 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:1f:cafe::e4) by CO1PR15CA0059.outlook.office365.com
 (2603:10b6:101:1f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:08:52 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:08:51 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:47 +0000
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
Subject: [PATCH 07/11] vfio-pci: move igd initialization to vfio_pci.c
Date:   Thu, 3 Jun 2021 19:08:05 +0300
Message-ID: <20210603160809.15845-8-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1c3a357-799a-4821-2801-08d926a9e19c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3465:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3465C514DEDBC9D116805597DE3C9@DM6PR12MB3465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+YphYz8LwV9uaryMa7NYguDveLZWxbLPKhLgHgKa3f4gXr3h/JXZz1l4l8nhU02zKMq8aHvegNWf8zw3/HaHqLdkiZi+pWesFgcSKW3rA4ZshAwWoyoE/St/pZk6FBA907eeuA7PMKpCxeepIDvx+FRBfyWr1J5u49Qyl2as9VfW1vIKO3WlONq2x6zaQBZ3oyNAlpXH9qouK0tckPGcl49Zthf5CF4Np+PR54wzoiXvS/nd8SgZTI+ITIAAt7XTUp2JtD7TJLy0n6z22S9+ICKZdmVt9fCoE+rAbbssymbzZSsHzfYYndR8HZQdWc72qjyQV/T3l3fj41o1TwAlL1F1NgJAbtLO7dHzYBmjK5BoNLUHLiTr+YkZ3418OOTBT9xT2S5pgwL4RWovAlub3W7CZ2thiFBl3oQJW6qax1v5cfyPLY3rkRHHGVtusheEApnXONlBLEqTV1TgLtcDPTjr8gJ1znX7DAkeKmtFWfcf5EcQA5B/ERcNigQPmJHp//6+VIpNBN4AGmEl7UwQfL9PhnRKjkHjIhNZ1+taMrW6lfkr2WlmdS3/HPoIYrCrY4z9KmLoro5sowmgzPh45J+XhqepZXjGsXNyWlIu/ZwQZmZMaZyUNuogN2H+Eq11SQb71f8blisqNp66P29LY4OJ6A8ZZ0u3rCIkT7VNQE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(36840700001)(46966006)(1076003)(336012)(36756003)(6666004)(186003)(478600001)(54906003)(110136005)(4326008)(36906005)(70206006)(70586007)(5660300002)(2616005)(316002)(426003)(107886003)(6636002)(7636003)(356005)(86362001)(47076005)(82310400003)(8936002)(82740400003)(8676002)(36860700001)(26005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:08:52.5028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c3a357-799a-4821-2801-08d926a9e19c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3465
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparation before splitting vfio_pci.ko to 2 drivers. Move
the vendor specific igd initialization from the core part to pci_driver
part.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      | 31 ++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_core.c | 46 +++++++++++---------------------
 drivers/vfio/pci/vfio_pci_core.h |  8 ++++++
 3 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 23a21ecbc674..850ea3a94e28 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -83,9 +83,38 @@ static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
 	return true;
 }
 
+static int vfio_pci_open(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	lockdep_assert_held(&core_vdev->reflck->lock);
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	if (vfio_pci_is_vga(pdev) &&
+	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
+		ret = vfio_pci_igd_init(vdev);
+		if (ret && ret != -ENODEV) {
+			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
+			vfio_pci_core_disable(vdev);
+			return ret;
+		}
+	}
+
+	vfio_pci_core_finish_enable(vdev);
+
+	return 0;
+}
+
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
-	.open		= vfio_pci_core_open,
+	.open		= vfio_pci_open,
 	.release	= vfio_pci_core_release,
 	.ioctl		= vfio_pci_core_ioctl,
 	.read		= vfio_pci_core_read,
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 12d5392c78cc..39a3f18bbc08 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -91,11 +91,6 @@ static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 	return decodes;
 }
 
-static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
-{
-	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
-}
-
 static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 {
 	struct resource *res;
@@ -165,7 +160,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 }
 
 static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev);
-static void vfio_pci_disable(struct vfio_pci_core_device *vdev);
 static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data);
 
 /*
@@ -250,7 +244,7 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
-static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
+int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -319,26 +313,11 @@ static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-	if (vfio_pci_is_vga(pdev) &&
-	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
-		ret = vfio_pci_igd_init(vdev);
-		if (ret && ret != -ENODEV) {
-			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
-			goto disable_exit;
-		}
-	}
-
-	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
-
-disable_exit:
-	vfio_pci_disable(vdev);
-	return ret;
 }
 
-static void vfio_pci_disable(struct vfio_pci_core_device *vdev)
+void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
@@ -481,7 +460,7 @@ void vfio_pci_core_release(struct vfio_device *core_vdev)
 
 	vfio_pci_vf_token_user_add(vdev, -1);
 	vfio_spapr_pci_eeh_release(vdev->pdev);
-	vfio_pci_disable(vdev);
+	vfio_pci_core_disable(vdev);
 
 	mutex_lock(&vdev->igate);
 	if (vdev->err_trigger) {
@@ -495,6 +474,13 @@ void vfio_pci_core_release(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
+void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
+{
+	vfio_pci_probe_mmaps(vdev);
+	vfio_spapr_pci_eeh_open(vdev->pdev);
+	vfio_pci_vf_token_user_add(vdev, 1);
+}
+
 int vfio_pci_core_open(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
@@ -503,13 +489,13 @@ int vfio_pci_core_open(struct vfio_device *core_vdev)
 
 	lockdep_assert_held(&core_vdev->reflck->lock);
 
-	ret = vfio_pci_enable(vdev);
+	ret = vfio_pci_core_enable(vdev);
 	if (ret)
-		goto error;
-	vfio_spapr_pci_eeh_open(vdev->pdev);
-	vfio_pci_vf_token_user_add(vdev, 1);
-error:
-	return ret;
+		return ret;
+
+	vfio_pci_core_finish_enable(vdev);
+
+	return 0;
 }
 
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 245862d5d6e4..406e934e23b2 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -227,5 +227,13 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_reflck_attach(struct vfio_device *core_vdev);
+int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+
+static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
+{
+	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
+}
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.21.0

