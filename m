Return-Path: <kvm+bounces-4486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D68F81305A
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A3DA2831DC
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3274B5C2;
	Thu, 14 Dec 2023 12:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NWC+1qza"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32332113
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:39:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOfV6WoANZypWCsjg5MBuFqa1VpO+/HS1vfKWY6vOf6BfTSVHvSlg145fWZWciq3FBraKegn56VoRsAzMCipmQNiIU24i2AeCVrHFkLVbbu939zoxFuWO1C7p3YaBGLM1Q97tS2NZIyYgd9Bq2NtqTUY7sEYkkDI3K9KP6bdZJinm3ddqLP/Le4ly70n6N6YTWKS0MGbkY9Sk4/Z0FTEFO7kybwtr0Kg3lxAwaEtjHlzK7XbE9TvuJ6iCezkxaDDw3CdXC3cODbWGjgxGKkZKBhld+ea7dyO5OQigTBLXU5nIhzRA6QTdAHaQnCabY2GBKIqZbND6cg24v/HmVGEsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXcK/G8oJC+S6lyVvbGQZzxzVj/DYU7hqLkvWu6O0BI=;
 b=KurA6W+mFr1ROySdba0O+Cf0i6DXVEzPt5rs8wUtG+5unTy7VNgyP70tk1dPWo5D8SX7bDxgUAlo3N4QhleLf40NVpMheqW+XxfPDefoIzBISg9AXxajfFkmcAdheqeoJtuDX+nTFjw/chg9XdJ68rKydjhDDUG0OBssr9qnyTwVBlLtCQzPdGVzK09If0zZwFz2aLcLiOGA0i+BRaXftfX7PGhVdgFktLwGT5j+z0HBJZpWxjoIcR+fGQ5fpjQ8qjTfAGKTjaufnJGbKHNS/Cv0L/6uzBJUJp9trXe0WJNRCl9JiRzggPdHjK3YBc4F4BIeNcPCcfw5Jd2H5nZ8QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXcK/G8oJC+S6lyVvbGQZzxzVj/DYU7hqLkvWu6O0BI=;
 b=NWC+1qzaaRMMRIDD1ZWGEWd7Nu02/jkp1Cr9RLE0+nRzRGJJ5uclsiTK67OR7VLHT40Y/OvMzd2tK0MoTwxL6uFtcA3vOAzfQNTieDP8T8toBpL6QgYkirVseB4ibO0LXDoCPk7li6Gyu/KciFl7PAvDVS2IvMyRjY580GtsI5N/VQNftG73d0CfTdY573Y2LJGhwTpQkpEZmm30Uv9Odil2uzWV5q+S6SOqZ4/8v6g/q/Uk7rI3A5Al8jhQ8flPpb3F0XForiEwKTNZuqI08CgQHGGk7yLSAL7Rjk3uGp3ByVvTCpTgGxg3QMXIzGz4WQIUY9yWI7aSqLkjcvavLg==
Received: from DM6PR06CA0037.namprd06.prod.outlook.com (2603:10b6:5:54::14) by
 CH2PR12MB4150.namprd12.prod.outlook.com (2603:10b6:610:a6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.28; Thu, 14 Dec 2023 12:39:17 +0000
Received: from DS3PEPF000099D8.namprd04.prod.outlook.com
 (2603:10b6:5:54:cafe::b0) by DM6PR06CA0037.outlook.office365.com
 (2603:10b6:5:54::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.29 via Frontend
 Transport; Thu, 14 Dec 2023 12:39:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D8.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 12:39:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:39:02 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:39:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 14 Dec
 2023 04:38:58 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V8 vfio 8/9] vfio/pci: Expose vfio_pci_core_iowrite/read##size()
Date: Thu, 14 Dec 2023 14:38:07 +0200
Message-ID: <20231214123808.76664-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231214123808.76664-1-yishaih@nvidia.com>
References: <20231214123808.76664-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D8:EE_|CH2PR12MB4150:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b71baea-cfb2-4f0f-2fd4-08dbfca1b011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TXDHzVb9xP6Gex6/pV87DefP4C2C2YuOQW1EwrK3mg20kKcCKEKKQ/8uGr6iu5vu4c5gmti1PNKw2PWE3EHazoHMxd//edAwgQAU9DuCa/GHDduGGCTBhCzD1EE5/BQLb5mUdmWoBlxI9mLxbmN7xDwqH7r7CpqwrwEGU55TzR17WU8rcsK7gYIso9WVrWkzGf+3vZl4vyIcI5kLYsECmbJLxStnL0Ny8cX8/qQYKkAGf6PEvA0FpXzY2U8KZHeJpL05Yz0Hai4VrOw8xlltLSvppcICN4rvmoZHy8d6WOCWx6ZnGnTUm4PkPtgLnaa6emaU2R0E4tfgIxxhYw7qmC6FISIzUTsfjvv2RSlK1Qdb57535ncUwc1gl/XI2oSTL/eM9a291aBneRamdxBdIQrhXpNaYFG6rerDUZoOW35+dZhfc2j42onUwpw9ee5Y5uUfiSVoZ/N2fcaYhSQ2ZsIPPIWI4NHnFm7KDcvnmbxHaJ5vy68kZVBNTRnOpdQZiJ8FDCRr0ZPAWWM0aS0Blh4bDhD9AEcxknjEMM3Okbko8KsUCgLHObRZLezteOj5bryJ6fcp7zl0IwdHb3jUJ4kb8mNjpR+TAUue+kjy+L/0hGNaz3hhX+gQygIX8HXpU43KPWIUM/2i4kRxldJT1MfwJ0/KkCsy7CuW0qZNhcrX7BrO7IfHHWQYrAyZhkq/KOfdoWmHMmTx/TSqEHn6m3l+IVV6qEGH5rlJVttXa6vouuVroSJ7srS2gt/vGMCKIHmGS4zAbvrhjWriRwtqmQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(451199024)(1800799012)(82310400011)(64100799003)(186009)(36840700001)(46966006)(40470700004)(426003)(41300700001)(83380400001)(336012)(36860700001)(47076005)(7696005)(5660300002)(40480700001)(478600001)(82740400003)(356005)(2906002)(6666004)(54906003)(6636002)(70586007)(316002)(4326008)(8676002)(8936002)(70206006)(110136005)(107886003)(40460700003)(86362001)(2616005)(26005)(7636003)(36756003)(1076003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 12:39:17.5501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b71baea-cfb2-4f0f-2fd4-08dbfca1b011
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4150

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


