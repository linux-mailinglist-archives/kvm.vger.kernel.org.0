Return-Path: <kvm+bounces-4695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 869AA816851
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 09:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A39101C22413
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B175310A3A;
	Mon, 18 Dec 2023 08:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oDavut2I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5282C12B6F
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBcrMckSnbLiqKQDf1gyduG4p4Lt8uLWExw0mqWHdj4SS0iTeVO2XbyYbnC7XqojMPCnb4b7GxRrCL14QX7tM0TQk3pBOHyaV0Ttkm0jOMNJH+D/8I2Rku61qYy6f+YbIqCtux7q4wXVdKg4y03kni7pQ0MyES/6Agaq8CpDi2AzqqpFPLseEDLJKDsFcjklALxoOSvNaVaIeIX8+fMCbTe9dt+VY2eMKSDe9nFeamJ/w90ycQQT/rsW3idYi5alHtGaBf0Ws82Bu+zNU9fdxC5KZ/D14bj76amntz3F675LF6QKXTIL3Zb6bGo1DaYToCOja8qt7kggnc7lpRNd0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXcK/G8oJC+S6lyVvbGQZzxzVj/DYU7hqLkvWu6O0BI=;
 b=EqXs5IIKakdpT5f1O0FYaiKpdBiJnltZr51Rgpr5quae4rPGZucHv0AAfDoJcGuhQ9Y++Nk7L0KkrDzoeJvdz5gyFAz2i9Uv23ubawrTDea7saIImNtjbsgyOY47M60i1ikHXSDqPLKZIDkqou7quUtsaOKDi6RyN+TCGR0Akm7oVgsmPjpqYpQSXC/aYrWiFbfGwT89qioMmqLg6bq56mjqyJ5wFYKDnD2BufkZ1MGU234r8z6Ko+X/pgYk6qnPWGo+Gp8Bmi2/h8kt6yecvIXwZgQ1RM4ZGgw6MlGiVRXHY5qfxCuU5HK/5UCadevqL6F68RO7vOzHl+VYS4IHJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXcK/G8oJC+S6lyVvbGQZzxzVj/DYU7hqLkvWu6O0BI=;
 b=oDavut2IKrjKYeOb1rVirlEifvXRhZoJdUdU6nCNxzBTRUMPjFjiS5ofNINpaLXGcxKbQl2qj/pkN5kkmQ/J94/eb/tCn0Jyg+TlMkn12rNB5717Pd2ZFAlrCQipSEH4dPa6pkBYrSqkUQUlDRcvnF2z6r1XHjLylBu4Jh7pxfQ59Ox3AGC3cEr+uhmVWk4SUl6wrZofhe+OVmrxKsjCJuAOZ4dcTSarffDSYdbDpLybB029RD3g4r+B5HI49qyyO9isbJsoq12ypufYlZj9F4DmcNup6h1m1u81cj9ZgIB6a3Nk0QT0qzMkWJa1+nG+Ks9WpVDqpX/lIgiaSAN+Lw==
Received: from MN2PR12CA0023.namprd12.prod.outlook.com (2603:10b6:208:a8::36)
 by BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Mon, 18 Dec
 2023 08:39:20 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:a8:cafe::b6) by MN2PR12CA0023.outlook.office365.com
 (2603:10b6:208:a8::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37 via Frontend
 Transport; Mon, 18 Dec 2023 08:39:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Mon, 18 Dec 2023 08:39:19 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:39:03 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:39:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Mon, 18 Dec
 2023 00:38:59 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V9 vfio 8/9] vfio/pci: Expose vfio_pci_core_iowrite/read##size()
Date: Mon, 18 Dec 2023 10:37:54 +0200
Message-ID: <20231218083755.96281-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231218083755.96281-1-yishaih@nvidia.com>
References: <20231218083755.96281-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|BY5PR12MB4116:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ee5ceaa-68a0-4e23-3241-08dbffa4d3e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P42JNc3pb31z50oojqGT3gKff57YJ/7LS08SbawHqVDKGGm9xm/8OJNwm8fPRWUPyjlsIR3mPDJVu4cV0eJ2xNyaX2eaCp1NxQnCwpInL9DxPuBH6qhVCn031p2Wyb4oqjF6WsImW12WiTUotm8HuiB00ZFB4oeFMKcJIkMhunRc5ySreChb4vYfxbRowX5UtP+MwYp7bqCBzsAea+Zl2PA9wlsTY2kdjryy1VkDUHwWIG2ToLddvQ18xtxmH0SCSUkRiKEjUefLEeV4QC3h+LcIlHbbXdJrdQWQP6ILdYeAUE2KkZQcnHK1Lsed0jN4ok1gX/oCQXYMas7A+UWIozSKVYDdRD5w7XTZeAU1MsETszKUuWKzBr8OJok3k02ce+ANzm3wZXK1GDxvFSL8mYoCGX6bcgWwTfZ0N43EG6ualfrwwe66eYgm/wosAyNHbZaxueQ4nzPFVH2zGBMnZXqmHVHn53qIH7agYjH0WqovOIuDz0Bx7613RHu9QJ2p3Oupe5a6rVyirkhaiiKvCc2w3axsK5x5RQD4MDBKI+IRKRuxMXn3PJx5SDG8bRiGGuE7gNhC5WoCUIF5kz16CG+P0w3oCoMp+cPvqCXrQdMq+Y05gprfYeTb1JLm+GZOZpwFlmZJ+e+5JbiSF4WrZHfl/Mpq97Slb0CaMP47TRx+UhK1BsrvWkq6ug0GzlQ5EocEWTmlqR8ATXrojsCl2FQLtuPhamy5f3R2YQehen0=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(39850400004)(396003)(230922051799003)(82310400011)(64100799003)(451199024)(1800799012)(186009)(36840700001)(46966006)(26005)(336012)(107886003)(2616005)(1076003)(426003)(83380400001)(6666004)(478600001)(7696005)(36860700001)(40480700001)(7636003)(5660300002)(4326008)(8676002)(8936002)(41300700001)(82740400003)(86362001)(47076005)(356005)(36756003)(2906002)(6636002)(70206006)(110136005)(316002)(54906003)(70586007)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 08:39:19.5733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee5ceaa-68a0-4e23-3241-08dbffa4d3e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4116

Expose vfio_pci_core_iowrite/read##size() to let it be used by drivers.

This functionality is needed to enable direct access to some physical
BAR of the device with the proper locks/checks in place.

The next patches from this series will use this functionality on a data
path flow when a direct access to the BAR is needed.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 50 +++++++++++++++++---------------
 include/linux/vfio_pci_core.h    | 19 ++++++++++++
 2 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a9887fd6de46..07fea08ea8a2 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -38,7 +38,7 @@
 #define vfio_iowrite8	iowrite8
 
 #define VFIO_IOWRITE(size) \
-static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
+int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -55,7 +55,8 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 		up_read(&vdev->memory_lock);				\
 									\
 	return 0;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(vfio_pci_core_iowrite##size);
 
 VFIO_IOWRITE(8)
 VFIO_IOWRITE(16)
@@ -65,7 +66,7 @@ VFIO_IOWRITE(64)
 #endif
 
 #define VFIO_IOREAD(size) \
-static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
+int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size *val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -82,7 +83,8 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 		up_read(&vdev->memory_lock);				\
 									\
 	return 0;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
 
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
@@ -119,13 +121,13 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 				if (copy_from_user(&val, buf, 4))
 					return -EFAULT;
 
-				ret = vfio_pci_iowrite32(vdev, test_mem,
-							 val, io + off);
+				ret = vfio_pci_core_iowrite32(vdev, test_mem,
+							      val, io + off);
 				if (ret)
 					return ret;
 			} else {
-				ret = vfio_pci_ioread32(vdev, test_mem,
-							&val, io + off);
+				ret = vfio_pci_core_ioread32(vdev, test_mem,
+							     &val, io + off);
 				if (ret)
 					return ret;
 
@@ -141,13 +143,13 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 				if (copy_from_user(&val, buf, 2))
 					return -EFAULT;
 
-				ret = vfio_pci_iowrite16(vdev, test_mem,
-							 val, io + off);
+				ret = vfio_pci_core_iowrite16(vdev, test_mem,
+							      val, io + off);
 				if (ret)
 					return ret;
 			} else {
-				ret = vfio_pci_ioread16(vdev, test_mem,
-							&val, io + off);
+				ret = vfio_pci_core_ioread16(vdev, test_mem,
+							     &val, io + off);
 				if (ret)
 					return ret;
 
@@ -163,13 +165,13 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 				if (copy_from_user(&val, buf, 1))
 					return -EFAULT;
 
-				ret = vfio_pci_iowrite8(vdev, test_mem,
-							val, io + off);
+				ret = vfio_pci_core_iowrite8(vdev, test_mem,
+							     val, io + off);
 				if (ret)
 					return ret;
 			} else {
-				ret = vfio_pci_ioread8(vdev, test_mem,
-						       &val, io + off);
+				ret = vfio_pci_core_ioread8(vdev, test_mem,
+							    &val, io + off);
 				if (ret)
 					return ret;
 
@@ -364,21 +366,21 @@ static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 {
 	switch (ioeventfd->count) {
 	case 1:
-		vfio_pci_iowrite8(ioeventfd->vdev, test_mem,
-				  ioeventfd->data, ioeventfd->addr);
+		vfio_pci_core_iowrite8(ioeventfd->vdev, test_mem,
+				       ioeventfd->data, ioeventfd->addr);
 		break;
 	case 2:
-		vfio_pci_iowrite16(ioeventfd->vdev, test_mem,
-				   ioeventfd->data, ioeventfd->addr);
+		vfio_pci_core_iowrite16(ioeventfd->vdev, test_mem,
+					ioeventfd->data, ioeventfd->addr);
 		break;
 	case 4:
-		vfio_pci_iowrite32(ioeventfd->vdev, test_mem,
-				   ioeventfd->data, ioeventfd->addr);
+		vfio_pci_core_iowrite32(ioeventfd->vdev, test_mem,
+					ioeventfd->data, ioeventfd->addr);
 		break;
 #ifdef iowrite64
 	case 8:
-		vfio_pci_iowrite64(ioeventfd->vdev, test_mem,
-				   ioeventfd->data, ioeventfd->addr);
+		vfio_pci_core_iowrite64(ioeventfd->vdev, test_mem,
+					ioeventfd->data, ioeventfd->addr);
 		break;
 #endif
 	}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 67ac58e20e1d..85e84b92751b 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -131,4 +131,23 @@ int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
+#define VFIO_IOWRITE_DECLATION(size) \
+int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
+			bool test_mem, u##size val, void __iomem *io);
+
+VFIO_IOWRITE_DECLATION(8)
+VFIO_IOWRITE_DECLATION(16)
+VFIO_IOWRITE_DECLATION(32)
+#ifdef iowrite64
+VFIO_IOWRITE_DECLATION(64)
+#endif
+
+#define VFIO_IOREAD_DECLATION(size) \
+int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
+			bool test_mem, u##size *val, void __iomem *io);
+
+VFIO_IOREAD_DECLATION(8)
+VFIO_IOREAD_DECLATION(16)
+VFIO_IOREAD_DECLATION(32)
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.27.0


