Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFF43F8595
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241653AbhHZKlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:41:02 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:40160
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S241679AbhHZKk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:40:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L642Hwj8r6SSq6NytBrqcj0IRZjooqOdYAO4xW58VSBwHGyURCa9et63rQto16Tfhmm14vOG7OSv/ZBwE5sujida8SkOn9L9fXxsBahYCqj0OgCRrw575V/Tefv5aHmhhJHffVVJYyOu/MtUSZS8O9qzcq1Fb8kJNx1sDleBMuLLc4pm50EO2rIdBCBcEcW94cN+lzdKhyfnGoNx76IjEkod7FcWaDphZp2Qkb5U1TqQuKwPnAxfd46QGE2ymYNWn8d/JGaj8ltATwzzbmdwhNq8HXCEyEb0GWmlXPUwHUSAzaXl7nqwLNPGZAJKJJExQsnXVwZAGkNdRpb/MfxfmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpVuGpX6kSVykU+bp5x/uGKW5QSdh1LlVTD49IBobMQ=;
 b=H7QhJrWwqr4vbi7lGqWSpAQTyWs9ThbwE7pupfcUMLJ8s0nNpj7Vdv3lsvtWrRkg7CF9ITqD3kIlS3H6g79zVRF/LwxoJvtBOk8597+HF8Ijp4DIxqKy+FVpedKL7wmWxaJmyPO5wXsWB+QFvTUTc1zwapWhmCpaK+1e7GY/YP8Z8YquCROKMKt33mVxiikC5KbmMu0p9OsL1fFjbsnXzdY9o4N/zPWdhA9Y0nklQOOdjSsIEg8H+M5wh6fFthz1TF/OIcpWfZl8QiG2SCsaPUBmtQIGPYRo3TMAw1orujI+kh6fy1jb+p0b/iXtmgHJB4rhUJmDTr9HaGqj0bNiNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpVuGpX6kSVykU+bp5x/uGKW5QSdh1LlVTD49IBobMQ=;
 b=t94B6MaQ84E/lRoIN82+iEsrj4hODdNRKhFDmbH0qL6iDAmUH0TbUVCygus9jRRGB9RDmdBFqssoiBfmi7ndme/fEnL7Y6Scnw1TmhHZjnpUS/Wyz4hKyFnHGYmMKBR9Yz26yeD1gVGXthY+AZR9Bvr3y7+MNCgiVIFHeozzX4VRA5gCnW/+6H0vQXxRvPI3h3C/4ZQl1wYon31A37dTILZXlhnWwqLLTGnOvtFqeadoKYo4cG++dYwt3zcSHq0C3vFvlSfDP0NHIki4wUuKgmx+F6Ki93AZJwXyTIAEIotIHYyMj1bqc959CWZv6cGNskf6j27LIziLnRezqwnZOA==
Received: from MW2PR2101CA0034.namprd21.prod.outlook.com (2603:10b6:302:1::47)
 by BL1PR12MB5333.namprd12.prod.outlook.com (2603:10b6:208:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Thu, 26 Aug
 2021 10:40:09 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::d9) by MW2PR2101CA0034.outlook.office365.com
 (2603:10b6:302:1::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.1 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:40:08 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 10:40:08 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:03 +0000
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
Subject: [PATCH V5 07/13] vfio/pci: Move igd initialization to vfio_pci.c
Date:   Thu, 26 Aug 2021 13:39:06 +0300
Message-ID: <20210826103912.128972-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6e86400-1b85-450a-d41d-08d9687de00e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5333:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5333248D6C092AC6ACFBF8A3C3C79@BL1PR12MB5333.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBjyVBNK66P61HrYKkDv3hE5L94zFRJHkz0O0mG1qBkgJzl+pvFmEsTkTVk2Dk8w/9g1tpxK4gwyFhJz71Z0ENXG7p+yWjoN6GLfRYcubjWfC3VWHHFgS+kWuOjNWnok3UJtoQQKXj13XnoYGRQEmyEiqllNEr9VjfVfjBVRLqDPMjwD9gZUVLhFxYnbaFna+ySfHplZaHo+fAfAAZ6FNnB17DM79lQO0X80kI1RlAwqZHVYl9c1+NQC0qjlp/bCMAQnbNV2oxSl19XXuP+yaMEhtabbyxtPxlJhHriQGaJ8FWJD0P29FbWHq/qRDkR38P757c4FfDopor1go9X5L5jqevhpESQXbqIXL5J0YhY02HsqX684I8LvPrYs2xKm3d2oR+vQx8wlRViEPqw87StMP4E2VaVQn91q6kqqZ6Eh0YDUY8LzW5j9ToWsmZ99eGmGuNgnzkHvMrzhDiMo3g9dY6VUpUejLn8q0hv/WdyBVsZJDN8kGp6cLtJhcK2OVhyZxudAGMM0Q8nVrOrr9iGdkSpG4Pj/ZoorxTLMiORjMz927no/rxc8jP/XvUp7Mi5SMDzmC37b7cigeb+9BUUPXN52JjWqtaA7k6rQiQuiBbPvEJI5kikAlM6HyEiyVsRzhtF5KfmBIKxV5PaFgVw5XFFCg3nGkmTGp0WuU/V/6b5DGBODzOyADaUUngwgEQd5BT+W+IUibNHVtGvv9h1OsV6zmKWWoa5PkcI+aG4=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(36840700001)(46966006)(186003)(26005)(336012)(36756003)(8936002)(7636003)(1076003)(426003)(82740400003)(8676002)(70206006)(82310400003)(36860700001)(316002)(110136005)(47076005)(54906003)(5660300002)(4326008)(36906005)(7416002)(2616005)(2906002)(7696005)(86362001)(70586007)(83380400001)(478600001)(356005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:40:08.7765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e86400-1b85-450a-d41d-08d9687de00e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5333
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

igd is related to the vfio_pci pci_driver implementation, move it out of
vfio_pci_core.c.

This is preparation for splitting vfio_pci.ko into 2 drivers.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      | 29 +++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_core.c | 39 ++++----------------------------
 drivers/vfio/pci/vfio_pci_core.h |  9 +++++++-
 3 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 4e31bd3001ad..2729b777a56d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -82,9 +82,36 @@ static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
 	return true;
 }
 
+static int vfio_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
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
-	.open_device	= vfio_pci_core_open_device,
+	.open_device	= vfio_pci_open_device,
 	.close_device	= vfio_pci_core_close_device,
 	.ioctl		= vfio_pci_core_ioctl,
 	.read		= vfio_pci_core_read,
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c0d71f72d4f1..3b3bf7445367 100644
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
@@ -166,7 +161,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 
 struct vfio_pci_group_info;
 static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
-static void vfio_pci_disable(struct vfio_pci_core_device *vdev);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 				      struct vfio_pci_group_info *groups);
 
@@ -252,7 +246,7 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
-static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
+int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -321,26 +315,11 @@ static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
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
@@ -479,7 +458,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 
 	vfio_pci_vf_token_user_add(vdev, -1);
 	vfio_spapr_pci_eeh_release(vdev->pdev);
-	vfio_pci_disable(vdev);
+	vfio_pci_core_disable(vdev);
 
 	mutex_lock(&vdev->igate);
 	if (vdev->err_trigger) {
@@ -493,19 +472,11 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
-int vfio_pci_core_open_device(struct vfio_device *core_vdev)
+void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(core_vdev, struct vfio_pci_core_device, vdev);
-	int ret = 0;
-
-	ret = vfio_pci_enable(vdev);
-	if (ret)
-		return ret;
-
+	vfio_pci_probe_mmaps(vdev);
 	vfio_spapr_pci_eeh_open(vdev->pdev);
 	vfio_pci_vf_token_user_add(vdev, 1);
-	return 0;
 }
 
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 7dbdd4dda5c0..ffaf544f35db 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -210,7 +210,6 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 void vfio_pci_core_cleanup(void);
 int vfio_pci_core_init(void);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
-int vfio_pci_core_open_device(struct vfio_device *core_vdev);
 void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 			       struct pci_dev *pdev,
 			       const struct vfio_device_ops *vfio_pci_ops);
@@ -228,5 +227,13 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
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
2.18.1

