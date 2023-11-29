Return-Path: <kvm+bounces-2772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BEC7FD9BC
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BA1A2832A9
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BDC232C9D;
	Wed, 29 Nov 2023 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Fy0QTCXl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ABF171C
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 06:38:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yg1VSp5pwk63qSLAJgETmdSZL319lHr8LoXzaCDfwEgK/V1bx2Z/1hiAZmVveu9IFS7DlV0RX3pnDBXW5JY4LBM5vQhlf4MAEIQR+BUTtxrIN+mhdqxlScV/FHN9mkVQbCO1XTS4+GbI3ffpEVRBUZmDM9sLLlegvoUzr8WxmuFPayGLuKxDlFY48jhq5HJS6GRe4UEdaGhyL4VPjZ1xhfnRZ52plBt/eZ+Yx+L7eOPcyGLQHvxfdn6H45tUJdtuUSVYZ3AU37YpkhfhdZdvm3gwtTRKErcFNuiuP+RRjRcRljzOKzeBk+oVaPWfJy78LwrEgN+2L3nUERtLAR9vsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MYDLCmSNAW0vQdRpN04LFWE6CiA0tdsGcRzR7BengeA=;
 b=iW6DTWeeemNyxiJK2dzGB58+SDpuyar2fuRrGsTgOp1mfsvCCSwKWgX8tADO76fvPb4Z5oODq4uxapc/SdVH4O7JQAttJa04flwKywgFSpPgSy3A7snXYrexwoHkSqgM1ebwHMCrYbPFN4NbGCecLeP3EtOBLMuqMgl5qdjMEZxIyDdUB5KzxDWf9PlmdMXTUabsNeOSBxUoBPUAeZBkMfLHghBk1rddWfG7liy8+KdFrHhkpFvBDRCTyP/VifoAg3cc36A7P9pA+vUYiN2llBFLARLD2oCOHh3bOHuYXN0ujrgVzOJV2dCwCehXejAI4Q/jToT0EGPG25wIfe8bpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYDLCmSNAW0vQdRpN04LFWE6CiA0tdsGcRzR7BengeA=;
 b=Fy0QTCXlN3iEpucGnj+miFyRH07/5ivyPVYCx4+Ew/q8TOiD/L/YxSgsH2ew63p4ASQsRwx24chjjigkpe8BQ5qOINo3NRKZU7POstraePKAY1S2b2YPlGSR0cH4M7bQcWNhAvZBHqoo+ON9Eyz/V6nFPm4NhLk60ZQRoCV7seVFOciVAQ0oJHjCOsPQKseCenUW7+FPRcVL8FjEXJbNNOphwkCqrn1On7dRc/NDt+qXIiwP/xv/AL8TcrUrmxEGOLp+2+DkARiewe2Pu6/WmOeccy1yLdbzJDaHeFT/Lgtr9fMWl27HImGMvkMsYxQv1ErHcyFnUW+TgZmtoIADww==
Received: from DS7PR03CA0334.namprd03.prod.outlook.com (2603:10b6:8:55::11) by
 PH7PR12MB8595.namprd12.prod.outlook.com (2603:10b6:510:1b5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.29; Wed, 29 Nov 2023 14:38:52 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:8:55:cafe::69) by DS7PR03CA0334.outlook.office365.com
 (2603:10b6:8:55::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.18 via Frontend
 Transport; Wed, 29 Nov 2023 14:38:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Wed, 29 Nov 2023 14:38:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 29 Nov
 2023 06:38:50 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Wed, 29 Nov 2023 06:38:50 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Wed, 29 Nov 2023 06:38:46 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 vfio 6/9] virtio-pci: Introduce APIs to execute legacy IO admin commands
Date: Wed, 29 Nov 2023 16:37:43 +0200
Message-ID: <20231129143746.6153-7-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|PH7PR12MB8595:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f81c777-666d-403f-19df-08dbf0e8e80f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hgAkpb29NkNnp5XCFYJpN1T5ENvYkYZ18Miogb+QshCTf53UHRKHfCxU1ZgjkaroxniniJXy4C0XG4IogB/HEO+O0yQMwViFhClVVO1W+j4QBwtD9/TYrlwYs38wyh4q0w2yIvBozT3FV9PYGHLrLTHzrZx0MkCdBmltfVCeOL1YdyhUPBTF82bZCKRLypmLSRT1nM3y0+iCXcus7SZsCx/qBQ671db3fEVeETcxm6fbTmorNV9aMPztR2WmZTpH9pEei0EbFtdTjjEwsfP1ZKaHRuh+xPXTkQAQw2XlZuaHJF2pBh9b+0mS8WJRxd9NXUikv095VGc0hJ7mCRCMCj2Sjy+DKyYrD97C8dmXpq3vehHBGRw8N/3Y2PYAWjWM9/jW/f+3C+tRveXQr4Weg1Ca12pSY4UkjYrSGNUNkWtNkdBTKSXY3SLL6XZDGYahHG4fBJovaQhO6Yauc94i6Hjv/IK0tFXWUCljkku5IOpXPg3jNOnidg7A9+Xb9hLtu9hzCFQ1nHspt87kr+1VcUl0bBDnSVJ5y+pG/svpL57xaygKpHv2Y92EAcuDIKnJtmZCT+XnSBwjzJsJ6DmYCa1/rbPr+4WiFwJczfJcwGP9fDbSck10Jab/XJu/IqE3K0l0VvXkoVfbVS2+MTgix/Dam1tPzo8Ov7aHm2xCouIX4/X+AQYDzm/HRh6/Fb6G3ncUTZcF85ertt9CAcRhtNf1IGK0SFJw0df60ZwDXTVacFvVn+r8CT4T7fpzDHll/r9jPcQ6V0deRfBf824/yw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(136003)(39860400002)(396003)(230922051799003)(1800799012)(82310400011)(64100799003)(451199024)(186009)(46966006)(36840700001)(40470700004)(41300700001)(36756003)(1076003)(86362001)(36860700001)(356005)(47076005)(7636003)(30864003)(83380400001)(5660300002)(82740400003)(426003)(336012)(26005)(107886003)(2616005)(2906002)(40480700001)(7696005)(6666004)(4326008)(8676002)(8936002)(478600001)(40460700003)(70206006)(70586007)(110136005)(54906003)(6636002)(316002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:38:51.8502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f81c777-666d-403f-19df-08dbf0e8e80f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8595

Introduce APIs to execute legacy IO admin commands.

It includes: io_legacy_read/write for both common and the device
configuration, io_legacy_notify_info.

In addition, exposing an API to check whether the legacy IO commands are
supported. (i.e. virtio_pci_admin_has_legacy_io()).

Those APIs will be used by the next patches from this series.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.c |  11 ++
 drivers/virtio/virtio_pci_common.h |   2 +
 drivers/virtio/virtio_pci_modern.c | 245 +++++++++++++++++++++++++++++
 include/linux/virtio_pci_admin.h   |  21 +++
 4 files changed, 279 insertions(+)
 create mode 100644 include/linux/virtio_pci_admin.h

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index fafd13d0e4d4..9f93330fc2cc 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -645,6 +645,17 @@ static struct pci_driver virtio_pci_driver = {
 	.sriov_configure = virtio_pci_sriov_configure,
 };
 
+struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
+{
+	struct virtio_pci_device *pf_vp_dev;
+
+	pf_vp_dev = pci_iov_get_pf_drvdata(pdev, &virtio_pci_driver);
+	if (IS_ERR(pf_vp_dev))
+		return NULL;
+
+	return &pf_vp_dev->vdev;
+}
+
 module_pci_driver(virtio_pci_driver);
 
 MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 2e3ae417519d..af676b3b9907 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -156,4 +156,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
 int virtio_pci_modern_probe(struct virtio_pci_device *);
 void virtio_pci_modern_remove(struct virtio_pci_device *);
 
+struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
+
 #endif
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 951014dbb086..37a0035f8381 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/virtio_pci_admin.h>
 #define VIRTIO_PCI_NO_LEGACY
 #define VIRTIO_RING_NO_LEGACY
 #include "virtio_pci_common.h"
@@ -774,6 +775,250 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
 	vp_dev->del_vq(&vp_dev->admin_vq.info);
 }
 
+#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
+	(BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
+
+/*
+ * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
+ * commands are supported
+ * @dev: VF pci_dev
+ *
+ * Returns true on success.
+ */
+bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_pci_device *vp_dev;
+
+	if (!virtio_dev)
+		return false;
+
+	if (!virtio_has_feature(virtio_dev, VIRTIO_F_ADMIN_VQ))
+		return false;
+
+	vp_dev = to_vp_device(virtio_dev);
+
+	if ((vp_dev->admin_vq.supported_cmds & VIRTIO_LEGACY_ADMIN_CMD_BITMAP) ==
+		VIRTIO_LEGACY_ADMIN_CMD_BITMAP)
+		return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
+
+static int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
+					    u8 offset, u8 size, u8 *buf)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_legacy_wr_data *data;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist data_sg;
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	data = kzalloc(sizeof(*data) + size, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->offset = offset;
+	memcpy(data->registers, buf, size);
+	sg_init_one(&data_sg, data, sizeof(*data) + size);
+	cmd.opcode = cpu_to_le16(opcode);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(data);
+	return ret;
+}
+
+/*
+ * virtio_pci_admin_legacy_io_write_common - Write legacy common configuration
+ * of a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the common configuration area to write to
+ * @size: size of the data to write
+ * @buf: buffer which holds the data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8 offset,
+					    u8 size, u8 *buf)
+{
+	return virtio_pci_admin_legacy_io_write(pdev,
+					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE,
+					offset, size, buf);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_common_io_write);
+
+/*
+ * virtio_pci_admin_legacy_io_write_device - Write legacy device configuration
+ * of a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the device configuration area to write to
+ * @size: size of the data to write
+ * @buf: buffer which holds the data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_device_io_write(struct pci_dev *pdev, u8 offset,
+					    u8 size, u8 *buf)
+{
+	return virtio_pci_admin_legacy_io_write(pdev,
+					VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE,
+					offset, size, buf);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_device_io_write);
+
+static int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
+					   u8 offset, u8 size, u8 *buf)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_legacy_rd_data *data;
+	struct scatterlist data_sg, result_sg;
+	struct virtio_admin_cmd cmd = {};
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->offset = offset;
+	sg_init_one(&data_sg, data, sizeof(*data));
+	sg_init_one(&result_sg, buf, size);
+	cmd.opcode = cpu_to_le16(opcode);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = &result_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(data);
+	return ret;
+}
+
+/*
+ * virtio_pci_admin_legacy_device_io_read - Read legacy device configuration of
+ * a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the device configuration area to read from
+ * @size: size of the data to be read
+ * @buf: buffer to hold the returned data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_device_io_read(struct pci_dev *pdev, u8 offset,
+					   u8 size, u8 *buf)
+{
+	return virtio_pci_admin_legacy_io_read(pdev,
+					VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ,
+					offset, size, buf);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_device_io_read);
+
+/*
+ * virtio_pci_admin_legacy_common_io_read - Read legacy common configuration of
+ * a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the common configuration area to read from
+ * @size: size of the data to be read
+ * @buf: buffer to hold the returned data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_common_io_read(struct pci_dev *pdev, u8 offset,
+					   u8 size, u8 *buf)
+{
+	return virtio_pci_admin_legacy_io_read(pdev,
+					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ,
+					offset, size, buf);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_common_io_read);
+
+/*
+ * virtio_pci_admin_legacy_io_notify_info - Read the queue notification
+ * information for legacy interface
+ * @dev: VF pci_dev
+ * @req_bar_flags: requested bar flags
+ * @bar: on output the BAR number of the owner or member device
+ * @bar_offset: on output the offset within bar
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
+					   u8 req_bar_flags, u8 *bar,
+					   u64 *bar_offset)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_notify_info_result *result;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist result_sg;
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	result = kzalloc(sizeof(*result), GFP_KERNEL);
+	if (!result)
+		return -ENOMEM;
+
+	sg_init_one(&result_sg, result, sizeof(*result));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.result_sg = &result_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (!ret) {
+		struct virtio_admin_cmd_notify_info_data *entry;
+		int i;
+
+		ret = -ENOENT;
+		for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
+			entry = &result->entries[i];
+			if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
+				break;
+			if (entry->flags != req_bar_flags)
+				continue;
+			*bar = entry->bar;
+			*bar_offset = le64_to_cpu(entry->offset);
+			ret = 0;
+			break;
+		}
+	}
+
+	kfree(result);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_notify_info);
+
 static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.get		= NULL,
 	.set		= NULL,
diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
new file mode 100644
index 000000000000..446ced8cb050
--- /dev/null
+++ b/include/linux/virtio_pci_admin.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
+#define _LINUX_VIRTIO_PCI_ADMIN_H
+
+#include <linux/types.h>
+#include <linux/pci.h>
+
+bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev);
+int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8 offset,
+					    u8 size, u8 *buf);
+int virtio_pci_admin_legacy_common_io_read(struct pci_dev *pdev, u8 offset,
+					   u8 size, u8 *buf);
+int virtio_pci_admin_legacy_device_io_write(struct pci_dev *pdev, u8 offset,
+					    u8 size, u8 *buf);
+int virtio_pci_admin_legacy_device_io_read(struct pci_dev *pdev, u8 offset,
+					   u8 size, u8 *buf);
+int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
+					   u8 req_bar_flags, u8 *bar,
+					   u64 *bar_offset);
+
+#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
-- 
2.27.0


