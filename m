Return-Path: <kvm+bounces-2775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C82A7FD9C0
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:39:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EBD71C21197
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6A932C88;
	Wed, 29 Nov 2023 14:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N10yAWr5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7182ED5C
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 06:39:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpxKL8WB1vqyCZ3+AFFEb+DOX8Rd8HSWDAGQPgOawJ1UpmIa9p6mOG/Aq9UyUyZTkpvmtN6xM/6AWQtrz4kCVquoBBpU6MEliBoQ1xqGtVZHaLJAk1A3INFIqMIrlOHd3tAWRFdEmKUYUbMte5Vra/axxAVlq1iFTWlGgQS/0ErqYUhaJobWAjb1QxLw7X7y26smFTzedwFRf1uvGWATlyEp1h2S0Uo+tZjPX0xx7lsa1RErvgNwY1womzjdHcZuRmFAnzCl7ggR8t0SbfQpViu4MQ2DBzgmAgcXjI6TxTKdt8ax8DcCwAMJadkx/7KQxC7TD7k+TgJ+oTJHaXwhEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ueIy9hp+yuSDFUn+Cwq4VZ9wxfooOvfEfsfqTWEOdw=;
 b=ewxCObv1KQjxR1J9XWcn+YrIRGbOSsYN5T6L0DdbB0Rq1Hc5f8UY4z/XBGE15P6y6UWHis/MP/54BvADMXrmy5mWbOAGRpVoxpCh48k+mivfHeOK6lpU3pwWrjnKJ0G+XkInw1HK9fsR3sdrZMUinqNYl6n9nBBy4Jbr+1XnlmaU0Db6Q5k5xnRCx+3JZw9bYxbEUqDaSU64ha1RG2aG6WeuPFSdLMfWeL5m8f7J2gAvEIbxM8dGSUqrXUr71BAXesxQYJ3SZoh3TpNk0tlggjprbe0/6hH8oVGCOJweU9FndWvEUHrbGtFlUlx6wnGtiDBH+V+VjkwSmamuunOOrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ueIy9hp+yuSDFUn+Cwq4VZ9wxfooOvfEfsfqTWEOdw=;
 b=N10yAWr5MLxtEA2WFGCJD+n7mtDqMs3NEvOISayuhyiOnL1vFEc1cS1COOIJIXxMqJzQpy+/UN4m3uqmoNYJWhw9+owWqiWZN2vOD3gjnV/tvYbO6ycYvgLUlO4rDAh9THvexlkhMPx1xARXDK2lTsTVyBOWA2idCdLrvuo5JA3KfiBhzjwWA+RcNehzv8RgvIFCAEIOG6V0BlDRdtldiAC7SqApxCkbJH+lOOtP8kI30Q+hhdt+GHgVzb5lpKomUjQ7IU5L/2YemfSRnEAaXH5rkq1RihMGd4NjAZMTI8wmFVRMhjAx/L13WsEDJHaPG72x72AFiuUGUd636FR3OQ==
Received: from DM6PR02CA0154.namprd02.prod.outlook.com (2603:10b6:5:332::21)
 by MN6PR12MB8513.namprd12.prod.outlook.com (2603:10b6:208:472::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22; Wed, 29 Nov
 2023 14:39:12 +0000
Received: from CY4PEPF0000EDD6.namprd03.prod.outlook.com
 (2603:10b6:5:332:cafe::dd) by DM6PR02CA0154.outlook.office365.com
 (2603:10b6:5:332::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Wed, 29 Nov 2023 14:39:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD6.mail.protection.outlook.com (10.167.241.210) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Wed, 29 Nov 2023 14:39:12 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 29 Nov
 2023 06:38:58 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Wed, 29 Nov 2023 06:38:58 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Wed, 29 Nov 2023 06:38:54 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 vfio 8/9] vfio/pci: Expose vfio_pci_iowrite/read##size()
Date: Wed, 29 Nov 2023 16:37:45 +0200
Message-ID: <20231129143746.6153-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231129143746.6153-1-yishaih@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD6:EE_|MN6PR12MB8513:EE_
X-MS-Office365-Filtering-Correlation-Id: b18d5039-d6f7-4d9f-384c-08dbf0e8f446
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LWP/YPDcViPO/+QOeEj68sbVw8KNo85h5yJ45ivm2tUAw71GVpufxXPag92D8/Cbzxd/pITX0XVeSVkOWBflZy/MXAj+OBtd/iUb3AoxWd+z68ZI86eYhdX5BLORTshvIcCnnnFCJXwQRCPSPox+5n000gOozKjBycCHukhG/j7+fScWrw9ka+7S/AcsmxZR3wjSOLAN/QLxy/0b7nZb8Oz3rFqsnB3mIxS/vwPOQ3TMywF+ZcdmAGrAtovG7NyW7JjDOv3Jiw1VaA2JxmzkT7Lj27K+vEH8ahWJ1Q0mLtesWjO4V/h1Ul2k9MZacN+REIPCuyNlSypCniwxkqwhbjGuj8nanCNsUE2bG4VWgdU4Dnu29Tupt7uSJIKkXSrp1/Zvo2vImPPmnsOrn65jMGuZD9tibhpFrgXU9EvF7HzRCccamP53YZQn49Id1ooOqncyH7zwy0sg+Fv62JxTZYbf6FMF4f7r6MAVpZGpPl0jS/mjJv6P1AX03mMnVvpC1DVE2YLByivyNzQBf3f4NescHIt9Vjg2OV7OQ6KmKUQzxxfYqz2lm4/K7WnnBrBUqTDEWiTnRiDLJ9yLyBDK9/iU0zWuTsGHT4jPMTSmSD6nLKi5x2iKbHy79qi1xByf8WB/XDEIEHhIGVaUx+OgzclYtkKF/bBkk5pQ0qvTpzax+Uw1FSapKbfr/ICztXIhJiFhb7dUsAK+oTEab2K9bjQo3OpFgY4NzB3QnCivNN20fSv4hgk/t+i2C+a6/WKURQF1DDM37pxJiuc9Y8CnaA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(136003)(396003)(230922051799003)(451199024)(186009)(1800799012)(82310400011)(64100799003)(46966006)(36840700001)(40470700004)(26005)(2616005)(107886003)(336012)(426003)(1076003)(478600001)(47076005)(6666004)(54906003)(7696005)(36860700001)(83380400001)(5660300002)(70586007)(41300700001)(70206006)(110136005)(2906002)(6636002)(316002)(8676002)(4326008)(8936002)(82740400003)(7636003)(40460700003)(356005)(36756003)(86362001)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:39:12.3284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b18d5039-d6f7-4d9f-384c-08dbf0e8f446
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8513

Expose vfio_pci_iowrite/read##size() to let it be used by drivers.

This functionality is needed to enable direct access to some physical
BAR of the device with the proper locks/checks in place.

The next patches from this series will use this functionality on a data
path flow when a direct access to the BAR is needed.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 10 ++++++----
 include/linux/vfio_pci_core.h    | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 6f08b3ecbb89..817ec9a89123 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -38,7 +38,7 @@
 #define vfio_iowrite8	iowrite8
 
 #define VFIO_IOWRITE(size) \
-static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
+int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -55,7 +55,8 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 		up_read(&vdev->memory_lock);				\
 									\
 	return 0;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(vfio_pci_iowrite##size);
 
 VFIO_IOWRITE(8)
 VFIO_IOWRITE(16)
@@ -65,7 +66,7 @@ VFIO_IOWRITE(64)
 #endif
 
 #define VFIO_IOREAD(size) \
-static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
+int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size *val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -82,7 +83,8 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 		up_read(&vdev->memory_lock);				\
 									\
 	return 0;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(vfio_pci_ioread##size);
 
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 67ac58e20e1d..22c915317788 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -131,4 +131,23 @@ int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
+#define VFIO_IOWRITE_DECLATION(size) \
+int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
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
+int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
+			bool test_mem, u##size *val, void __iomem *io);
+
+VFIO_IOREAD_DECLATION(8)
+VFIO_IOREAD_DECLATION(16)
+VFIO_IOREAD_DECLATION(32)
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.27.0


