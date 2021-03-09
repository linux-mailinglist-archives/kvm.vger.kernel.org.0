Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6213320C0
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCIIe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:34:56 -0500
Received: from mail-dm6nam11on2079.outbound.protection.outlook.com ([40.107.223.79]:41230
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230150AbhCIIeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:34:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akyktj/l8MiwQl46le2Y1mC96POhzbkwD6g8UQWVWZTwWufkdFWOCaSUAN6gTShXpd/LhHvvrrKKZbhLv3XGoEKNM0ylK8JppuVDDqsMWAbdaF1CbnsDLAp+eY+C7s98P+UkIQUXSUvQRF/WhlXdJbNX9E12pbG+Le4R9SL85jtkFi/RMHhwxADkIRyOuY08rO8QErwPlE5MGkeojpTYJhvmenlkQzOHSt+eT9EwG67OjN8XiZxKLNlurX4lVChp2ghRC/96XHUgU6SNaxHlyeAZoY5FDkc/3eQXS/eHREMoDZsR0pn+N32qV/ShrM7LxQeyaNmwDvEEaLRk/L4odQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB9uqE6/X34dyaE1Dfm2VA3wxh8WZp0X3Rc2bxqdFow=;
 b=IQK4TuUm6Bbuh6buGHrJlxAHBuhivZFjZ2xFJg9MiakalI1cqAuN4qONEdLqbQ/Ab6VygwoFIQyX6qzJho5mMYEvU0unMZfYkTEDSVgUu5s+nv01Q/eRGpExLHMO+D/4xmc5nCKa/Nco4JjVUKWxkRGas952U6RT3j0ItVAsOtJMZx38Cu9A5dpiGc+S2/CVjxjBbFAyHWIz/o3MVmo1+xOrAN1fBdYYYDNQ0sClxQm6R9NBYRoXxU2d5AyUqrwKbsUnWMeqy+1x2i4hMdHRjrxLLwpXA0gLqDrpnglLmVFT7VBN+NOSYJYFUAUJmhb31VWv6rKx9ycA1mwgcedaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB9uqE6/X34dyaE1Dfm2VA3wxh8WZp0X3Rc2bxqdFow=;
 b=Pbn8huwfoMT6LUf9ELgp9k4Sz7ugg/3tB6m/XIvSj2cVbB+3Yldk38skYYwCWwLjCkqZBk1FD17+1af8aOz/IFDymgZil0YY7YwFyzNq7DrSmoX4t+8ecxtzS/yaoTdzXC7TCL4OYYSdqMOhB9g5zcemd9U3mYYjXA1y+26p3LASguciRRc7cbk8cJvzdhMx/auh8yl7T5uI91N3jYVznUOeMiXsv5QCFUM/jy0kaq6Qms5jA6fKocTUV0u/70ZA5UQBgeImtdwprzfUKNouOv76UsdlOA/2eBa1/cXnEDbNlsisttkrqhlMZKsNzxQ0Omc0rBsMOchdttAZ1uYU+w==
Received: from DM6PR07CA0075.namprd07.prod.outlook.com (2603:10b6:5:337::8) by
 BL0PR12MB2337.namprd12.prod.outlook.com (2603:10b6:207:45::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.19; Tue, 9 Mar 2021 08:34:34 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::50) by DM6PR07CA0075.outlook.office365.com
 (2603:10b6:5:337::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:34:34 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:34:33 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:27 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <mjrosato@linux.ibm.com>, <aik@ozlabs.ru>, <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 5/9] vfio/pci: introduce vfio_pci_device structure
Date:   Tue, 9 Mar 2021 08:33:53 +0000
Message-ID: <20210309083357.65467-6-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309083357.65467-1-mgurtovoy@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b53e8bf9-86ba-47ba-97e0-08d8e2d62aca
X-MS-TrafficTypeDiagnostic: BL0PR12MB2337:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2337EF573F7B70D918CFDAA4DE929@BL0PR12MB2337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xXXwRHqZhurji66F6O5YDvxm+9MsSaFrTQnP6IkRWu9uEJCJukojBKaxULTg+Hq1AEk/Z5+2OYyOInu3kXusEKQaGhE9PraABmgjkX3igs/ZlZ9p0+gKz8PI9iYPohEgErsCzhLRoQNFrVg1o2DVCdMpUjiPq5amaWIdhArz8tUoFhIh6V5Ngl07C0Ndvkke6nIZEvZgkQgNl7/Tcw/flYUMkmEzuY9iYOw/KmVyMLkUAI3KPJEAxBYBKzAY2HPytyGPTApkHxRmm+SN94E5BYW0TAhpUwairmSbGduuJ5UBhRrg2l1ZO1dI6TL4iuR2J24HVYawItDB9zhjYr1CJEmvd4+xLbK32YHpAJ+KAvwq3GPQNvK/m+bliC7svxucN6kkU9WqjnDqDemAB3fmvD+8LFxEen8t3x2JtLQNnuwLjg9jDzEE9BKUxJh0//EDuZqqoaAvSVX0EgsSw6fQop7LRE2YIUCLJbWYVdA8DvsEZn3bijXIe7B5+lgQZK+DsyOOaSsfRMrciaBYZhPTmUjdSXJnEU+Vkc9t7exVX61t6j6wp40GrV9HTd+kcflMDeoHlabtRMgENzjKmqffqCg3ytzda9XBiegI2vHFXDLWpp6bg4dOZ1vFFEpUUjOQxDWXkNdm0KX0z7Un1H+H6hmNUwkiLSm/Qdd+3kRbMQRUI2jYGEMvM7ls0xpicmg
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(36840700001)(46966006)(478600001)(2616005)(34020700004)(86362001)(186003)(4326008)(5660300002)(1076003)(107886003)(336012)(6666004)(70206006)(47076005)(70586007)(36860700001)(2906002)(83380400001)(8936002)(82740400003)(36756003)(7636003)(8676002)(82310400003)(26005)(54906003)(36906005)(110136005)(316002)(356005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:34:34.0674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b53e8bf9-86ba-47ba-97e0-08d8e2d62aca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2337
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This structure will hold the specific attributes for the generic
vfio_pci.ko driver. It will be allocated by the vfio_pci driver that
will register the vfio subsystem using vfio_pci_core_register_device
and it will unregister the using vfio_pci_core_unregister_device. In
this way every vfio_pci future driver will be able to use this mechanism
to set vendor specific attributes in its vendor specific structure and
register to subsystem core while utilizing vfio_pci_core library.

This is a standard Linux subsystem behaviour and will also ease on
vfio_pci drivers to extend callbacks of vfio_device_ops and will be able
to use container_of mechanism as well (instead of passing void pointers
as around the stack).

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      | 31 +++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_core.c | 39 +++++++++++++-------------------
 drivers/vfio/pci/vfio_pci_core.h |  5 ++--
 3 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 447c31f4e64e..dbc0a6559914 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
@@ -31,6 +32,10 @@
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
 
+struct vfio_pci_device {
+	struct vfio_pci_core_device	vdev;
+};
+
 static char ids[1024] __initdata;
 module_param_string(ids, ids, sizeof(ids), 0);
 MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
@@ -139,21 +144,37 @@ static const struct vfio_device_ops vfio_pci_ops = {
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct vfio_pci_core_device *vdev;
+	struct vfio_pci_device *vpdev;
+	int ret;
 
 	if (vfio_pci_is_denylisted(pdev))
 		return -EINVAL;
 
-	vdev = vfio_create_pci_device(pdev, &vfio_pci_ops);
-	if (IS_ERR(vdev))
-		return PTR_ERR(vdev);
+	vpdev = kzalloc(sizeof(*vpdev), GFP_KERNEL);
+	if (!vpdev)
+		return -ENOMEM;
+
+	ret = vfio_pci_core_register_device(&vpdev->vdev, pdev, &vfio_pci_ops);
+	if (ret)
+		goto out_free;
 
 	return 0;
+
+out_free:
+	kfree(vpdev);
+	return ret;
 }
 
 static void vfio_pci_remove(struct pci_dev *pdev)
 {
-	vfio_destroy_pci_device(pdev);
+	struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
+	struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
+	struct vfio_pci_device *vpdev;
+
+	vpdev = container_of(core_vpdev, struct vfio_pci_device, vdev);
+
+	vfio_pci_core_unregister_device(core_vpdev);
+	kfree(vpdev);
 }
 
 static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 878a3609b916..7b6be1e4646f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1837,15 +1837,15 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 	return 0;
 }
 
-struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
+int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
+		struct pci_dev *pdev,
 		const struct vfio_device_ops *vfio_pci_ops)
 {
-	struct vfio_pci_core_device *vdev;
 	struct iommu_group *group;
 	int ret;
 
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	/*
 	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
@@ -1857,18 +1857,12 @@ struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
 	 */
 	if (pci_num_vf(pdev)) {
 		pci_warn(pdev, "Cannot bind to PF with SR-IOV enabled\n");
-		return ERR_PTR(-EBUSY);
+		return -EBUSY;
 	}
 
 	group = vfio_iommu_group_get(&pdev->dev);
 	if (!group)
-		return ERR_PTR(-EINVAL);
-
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev) {
-		ret = -ENOMEM;
-		goto out_group_put;
-	}
+		return -EINVAL;
 
 	vdev->pdev = pdev;
 	vdev->vfio_pci_ops = vfio_pci_ops;
@@ -1884,7 +1878,7 @@ struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
 
 	ret = vfio_add_group_dev(&pdev->dev, vfio_pci_ops, vdev);
 	if (ret)
-		goto out_free;
+		goto out_group_put;
 
 	ret = vfio_pci_reflck_attach(vdev);
 	if (ret)
@@ -1928,7 +1922,7 @@ struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
-	return vdev;
+	return 0;
 
 out_vf_token:
 	kfree(vdev->vf_token);
@@ -1936,22 +1930,22 @@ struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
 	vfio_pci_reflck_put(vdev->reflck);
 out_del_group_dev:
 	vfio_del_group_dev(&pdev->dev);
-out_free:
-	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, &pdev->dev);
-	return ERR_PTR(ret);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(vfio_create_pci_device);
+EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
 
-void vfio_destroy_pci_device(struct pci_dev *pdev)
+void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
-	struct vfio_pci_core_device *vdev;
+	struct pci_dev *pdev;
+	struct vfio_pci_core_device *g_vdev;
 
+	pdev = vdev->pdev;
 	pci_disable_sriov(pdev);
 
-	vdev = vfio_del_group_dev(&pdev->dev);
-	if (!vdev)
+	g_vdev = vfio_del_group_dev(&pdev->dev);
+	if (g_vdev != vdev)
 		return;
 
 	if (vdev->vf_token) {
@@ -1973,7 +1967,6 @@ void vfio_destroy_pci_device(struct pci_dev *pdev)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
 	kfree(vdev->pm_save);
-	kfree(vdev);
 
 	if (vfio_pci_is_vga(pdev)) {
 		vga_client_register(pdev, NULL, NULL, NULL);
@@ -1982,7 +1975,7 @@ void vfio_destroy_pci_device(struct pci_dev *pdev)
 				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
 	}
 }
-EXPORT_SYMBOL_GPL(vfio_destroy_pci_device);
+EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
 static pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 		pci_channel_state_t state)
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index a3517a9472bd..46eb3443125b 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -231,9 +231,10 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 #endif
 
 /* Exported functions */
-struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
+int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
+		struct pci_dev *pdev,
 		const struct vfio_device_ops *vfio_pci_ops);
-void vfio_destroy_pci_device(struct pci_dev *pdev);
+void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
 
 long vfio_pci_core_ioctl(void *device_data, unsigned int cmd,
 		unsigned long arg);
-- 
2.25.4

