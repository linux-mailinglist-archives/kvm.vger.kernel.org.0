Return-Path: <kvm+bounces-3604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 094C5805AC6
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C8AE1C2166F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7B9692B2;
	Tue,  5 Dec 2023 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c0VUCmtN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F6E188
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:07:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8i1XY1O3wCtLAo1AFotE/tbHHg48fyw0OATFJ/u2SMa7zKTlzvkRUWoCHUQ0WYm+iprgd6a9YnACMpYnO5L9VSsFpuouh8aRHHt2VVbMNt5FK7n+Pi8CwIkMDMF0tAiY/YhWqBYpoKCLB5PoMy4lxgjffmFwx3q303xyZMX3C/P8P//MnafXD7S0kWre2iophtRAQP36J+GA/+8UsKAxlYzHd0R6uWo2HMROgk2qB+J87+xPD5qhFD5/b49OKMEa/neuV68jzU6bHyDauheTk/qOipujU6KSTXLtpOh5/pfkaVyjg8Q2PN1ML0kXjhDqvoceJnZO2W3O2Kgyue+2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hi0XY5g/f5M1A4bC1GvlmpAy3GL0utyR5QxW/yOU2U=;
 b=KPPVTHW1AxCQDsYolb2el9ZBrq7cVATU+jT3pncozPcWVeW+D9cB7NILgvoTD/8EXC9pSlF/O+hXWczAnH14B/Lptlr5JdTGvQ15OuOZ4isQhQTmIcWsDEaLaJhjkFFrSUkGEFgv+HFGAm6NWT18qKNPFB1bIsBbfTvNSfGbZJL+TXpSSVd5sLw85YwFk9UhZmq95JyPlfSZgQ2dlVQKv1/KdD80HAyfPPfEXm265T4UK6hou5VjdHKdMjg+q7LyP4DqFsbdQZDlApVxLSGxCxh6+5UQYxogOmKSHOlW9vjY3Yc1Djzzk4CqN6dJHdE02qBSSMnSSePTd5Fbel1mPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hi0XY5g/f5M1A4bC1GvlmpAy3GL0utyR5QxW/yOU2U=;
 b=c0VUCmtNnrymPWvmwilhUIO1AnV5+mFG+oWAWHBpcM4ieYXSUOKHlQDf8t9eGi9sOFixS2g6pT/TXI0bIf1WbDIgvHoxbUWGX2nxAY0YPIrMZORyEZjJ8W/5yYipQDu4uKNdLKyz0flIyGbgTlyyp0dl2bYMz2TWQXGp7TXjCTrIIMntzD5wVSq5w2DDoNx6qnfaOXnSPbc/uAyW8bYym/56xwD55Ra9HyLVHCbe4OkDCM4Rpxgk5CY6QUIs3HfNX3hbKfBz49qEo1d0tM4Hrxo7mxulRR7Xf0rp6pr9/sXjKuf5ZFWoFVmFeoo9mOpt/L/uY6XaX1aZuGXWw5KR8A==
Received: from MW4PR04CA0055.namprd04.prod.outlook.com (2603:10b6:303:6a::30)
 by DM8PR12MB5399.namprd12.prod.outlook.com (2603:10b6:8:34::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.33; Tue, 5 Dec 2023 17:07:37 +0000
Received: from CO1PEPF000044FC.namprd21.prod.outlook.com
 (2603:10b6:303:6a:cafe::b0) by MW4PR04CA0055.outlook.office365.com
 (2603:10b6:303:6a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 17:07:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044FC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.2 via Frontend Transport; Tue, 5 Dec 2023 17:07:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:20 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:20 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 5 Dec
 2023 09:07:16 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 vfio 6/9] virtio-pci: Introduce APIs to execute legacy IO admin commands
Date: Tue, 5 Dec 2023 19:06:20 +0200
Message-ID: <20231205170623.197877-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231205170623.197877-1-yishaih@nvidia.com>
References: <20231205170623.197877-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FC:EE_|DM8PR12MB5399:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f17c91e-7771-4d12-9a98-08dbf5b4ae28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3RIkGRZcuU+rzNnO7Onk1Kc2huA3+BzMlQnKQo3qzgeXeBYJmFhvDxPt7Mviwt7wenzSnCvPN6UkS4kZGiUsT3sBobwMCZHXHDXxFzaZlNAdqLaM3mE2pPv+GyDyN1US6u2ybm7DAytoCRk64wYa4oRD7NpVRSZ/oyWTLUIFUVyvnlVp/TKhRIqsX0HbC924pm1OSMwUYC4WRoA0jAqc3N2hXuUGQ24w0c5sRf0bUlrzFLcN5uIn7Vuc0MOAEhbyNX1ne5IZ+fLDJfqtA034dW5u/062QT/SCrqOM18ZjHlkSTG080ckhII/UIGDFN3IssGvVjiRj6NqZL3ZfolMhKVavT8XiEU7XSCCPt7VqYco761GxFs1M4TfISnDHSAOxmDDyF3oDlDxxG99V8yHVQPhfckxNM5/OF462mMvhmcWXCoLwTxCdXIc6sGGXROKqH9q/srjofvGqQcNWnsm7hmJmG3i20CPZ2+WVE55bXxYJM9d9op9scn8QAXxkBsbybkfGgvEZwAk3VBz9+OCnZb+P+RM4C156Wkp86UJMjXPchFMLGdocTa0AkS/sOi9sK1yM7vB03JVze1FoYQTVQt9w6LeoS1gAOpsWLIjMAIzqGiY5el6nXrd+mgbGdtckBqHQjN8nGjhVyVQ0vezreqXZzpdptLo2vqC9bkclNK4O3WL8C4Cb9KX7MczOva6bB0Cb0We6znDsTZcjj1RBHygWwRVWhmFxc7VHQXbSbnvXpRcsOUtf9zOq6BWfewIpTLgSY5xEIl1FtRvEPD7VQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(376002)(396003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(82310400011)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(36860700001)(47076005)(356005)(7636003)(2906002)(30864003)(5660300002)(82740400003)(83380400001)(6666004)(336012)(26005)(107886003)(7696005)(1076003)(2616005)(70586007)(36756003)(110136005)(478600001)(41300700001)(426003)(70206006)(54906003)(86362001)(8676002)(6636002)(8936002)(316002)(4326008)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:07:36.6309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f17c91e-7771-4d12-9a98-08dbf5b4ae28
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399

Introduce APIs to execute legacy IO admin commands.

It includes: io_legacy_read/write for both common and the device
configuration, io_legacy_notify_info.

In addition, exposing an API to check whether the legacy IO commands are
supported. (i.e. virtio_pci_admin_has_legacy_io()).

Those APIs will be used by the next patches from this series.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
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


