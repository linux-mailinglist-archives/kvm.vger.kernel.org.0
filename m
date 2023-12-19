Return-Path: <kvm+bounces-4793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8015818492
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50C1B1F26779
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4328C14288;
	Tue, 19 Dec 2023 09:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FFZzfirT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE92313FEC
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 09:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dd8gvCNAEsPRcp/+3AFR6VeoCOel8AGbwy0R6RRasfOup/bzKtOlly8+LRvWdgQ+YoLLz9FoquGE8zy7qUwzq90JdkgReMdfndptnET8PDlVHxjs5dw51ptkGNfjSgNVPy2z1Lzh0x3J1Fv7cu6A3KJ1J4Xwhu0F6zelPdX5zr7QFC6EDWScm880Cke4HDwAhiyzn0SZhML4zJM965w8CQOA8AT0OkBYkNFYZjDGsFYO8jP3FS276rTa/5ZmBmns1UU6RRFPLzyMfbEq7HeRy7v6TXeVauPSWT8rNQKT4VvSxCH8vPqWLpHd20HEt1k/hEIMZhYqc/lzjMi/dhPTsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A++3yuKKQheNoq/8ne69fmALtWgjNee3wpBIrcBt4lA=;
 b=FLzM+QY9aU2+VKD9J75oaQxiKUQb642rfzoNN+Z1PWR/GfK1+Rfk5R4kncOnerXxMpd0gL6nH4HlpkL+4x3ny99F4HbQj5vtSvbt+ONHEMirMQU/uNXVivP4aUPfy0hrdOZIp0d+RYI6XS6YsYjNihTo9+X732/gbEh6ALoN/OKGEPLxeH6bKNNmULrJwLjD0B/E/+I5Xc9osfD2fwi3bWTjn3eDZj+eVpNmqeVQ6Yt5woPmD7gDf3Ky+ncaZuQrLDgCKxECgUc52MOxBQaAf8i1ULWSGAF/AY0rjR81lSBdzX6lUXwrW8M+odyS6tX4k1DDkAeBQx16KSt9UJ85lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A++3yuKKQheNoq/8ne69fmALtWgjNee3wpBIrcBt4lA=;
 b=FFZzfirT4JSwY8dJ36/z2tzMmCSRZGDi64Ev6jirfMqwEvXDymkgBPWELsx6Hn3hXD2vAuFKxoojlOusH6nkmtd8q6a5p5dBNtYpvdlSrjRWHYHBR5HErr4Dgj1DezSQ8niaZ0TWysuA5/Wy/T1/ojDGBmRIX7uHTzg1tkxqLFlkN15UkMKMR980t9lNYUy3udslQr8+01ot9GunYuIBmBM+lrCv9cH9hpxloM8Qnyug9xgnIi3K/YTcCypipuT3YuNuDfwSB3+o0t5LDiQxszPM8TbCrj6t3EoiWZzyHZOqV0sScbWKLN7e/xywMhE3c7EC9okDiv49IRoPB+KMvA==
Received: from DM6PR02CA0132.namprd02.prod.outlook.com (2603:10b6:5:1b4::34)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 09:34:24 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:5:1b4:cafe::92) by DM6PR02CA0132.outlook.office365.com
 (2603:10b6:5:1b4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.39 via Frontend
 Transport; Tue, 19 Dec 2023 09:34:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 09:34:24 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 01:34:13 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 19 Dec 2023 01:34:12 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 19 Dec 2023 01:34:09 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V10 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Date: Tue, 19 Dec 2023 11:32:45 +0200
Message-ID: <20231219093247.170936-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231219093247.170936-1-yishaih@nvidia.com>
References: <20231219093247.170936-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: 621f8f4a-69e2-451e-3b7f-08dc0075afd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qVGuYU/ip5XXtgpSyOqbpNsu+udfNkzeoM3dVlcOsAY1wECANBuH62A/bZ5M54xpL29dV+2ROPrx/CXisQ3IGouRmraMZkyx8erLOzFWmvJTa7j22J2tt/Qj9UPaYCkK8O3KLgk8q5lTfOLmsvMBWsKfS57EkkLKk2UZ/HvizhR8hv3hAuvl7vqC9xTLmG59WjYUkrKN0f+LYt75rC0iPwGEuaVh4ctUGBtdXt26sOAsBAlqtLCm8wFrjZS5+kYrRzydhoAwecUpJ9uGYZdAKcvw/oVc4s0iHarelfjZgvHqN9pp3+V4hFj+wETUWW4I13DqfrsQUXNPoNpCbkPQeaW9kSSGpPOuZAj+iYwx0ZhooIpcDJNMQUQEZJjmJ8JvxAbngB4pGszV/Tthrc6xzyuhsNPo+CaUzjU22+03ITQeENAKmtPFUpO/1kvOKT/GYSNeNNeJIanuxu2TU0NHJDwXNJmZ96I9TQaGMK1tn33xeLDSz6sQ1T/BHOXqsmRANgbjuA+PRd106K40/bUfciKwraklnkPlaIe/H3JT2fF1gAL2tr6YHcn0/zr0rjnPKbq+YoNxMElJTdjE5nbRGPtjDnNrYPZ/yEFAxUPtzNnrnBMAPuVdMjQIlfRu70x/Ti8ZK54u2ypLwM5W2ILaqaAaIO9FD8ouXMFpt4KECArP4EAmzNqhEQ8X35gdLVQjUHGpBkn5MjU4AKCO3WA0nZsWeySQGy9PJ5JGfTIrJtF04tghfHdUBO7r/PVbzO34SeCdhujc7V8b562q3eh9Dg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(376002)(396003)(230922051799003)(1800799012)(451199024)(82310400011)(64100799003)(186009)(46966006)(40470700004)(36840700001)(4326008)(8936002)(8676002)(5660300002)(2906002)(7696005)(478600001)(6666004)(110136005)(70206006)(70586007)(54906003)(316002)(6636002)(41300700001)(356005)(7636003)(40480700001)(36860700001)(47076005)(86362001)(36756003)(82740400003)(40460700003)(107886003)(26005)(426003)(336012)(1076003)(2616005)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 09:34:24.0187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 621f8f4a-69e2-451e-3b7f-08dc0075afd8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270

Expose vfio_pci_core_setup_barmap() to be used by drivers.

This will let drivers to mmap a BAR and re-use it from both vfio and the
driver when it's applicable.

This API will be used in the next patches by the vfio/virtio coming
driver.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 7 ++++---
 include/linux/vfio_pci_core.h    | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e27de61ac9fe..a9887fd6de46 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -200,7 +200,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -223,6 +223,7 @@ static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_setup_barmap);
 
 ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
@@ -262,7 +263,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		}
 		x_end = end;
 	} else {
-		int ret = vfio_pci_setup_barmap(vdev, bar);
+		int ret = vfio_pci_core_setup_barmap(vdev, bar);
 		if (ret) {
 			done = ret;
 			goto out;
@@ -438,7 +439,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 		return -EINVAL;
 #endif
 
-	ret = vfio_pci_setup_barmap(vdev, bar);
+	ret = vfio_pci_core_setup_barmap(vdev, bar);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..67ac58e20e1d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -127,6 +127,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
-- 
2.27.0


