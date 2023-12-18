Return-Path: <kvm+bounces-4692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE469816848
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 09:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 654A71F22AF1
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2158611C95;
	Mon, 18 Dec 2023 08:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dIJXRBRk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A711E11C8E
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZV81U6zlZBlbDVr1GCqimEh4VIxT8mIKPQVpSt1gkxeq0OFZLYfApgbxJwPvbRgQF6vL5/zpS941KNymSgJxs9JNv6cHzDPNVGhHUGHqMM5qt+pfI/40cFsCaELvxwrAO39xbtdDI+nAJj5abSqLWkIMsnxxGotlQRRQyoxrfteFbROFc69Uf8LxM57mweLZRH8OaXdGbVjEkiLZAPnrkSqD5F0QR7zG7i5z9ZeDZAHQv9KHt7o1CeUUf1+YfczRo+/sDG7UxMD9R1I3t1XgCTYcG9XpXXzEV2SYll2C1JrKA6fh7ZEvJqdilr+1i05e7UJZCkwJFsX1F4/Rm7pvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ev4zXeggkV0JQmMudPAtl6b5/Q//DqIBPcVJEt1e1GM=;
 b=k/4JxTaEi65/4xsX/C06fb43yqw1M8OGvEdajSsZxGKzYAr0Ac2Fi9ZVfmpGae0cjWTzkzhu/TlN2UZhCucsXBZ67PydB65PHMlRvSzDvLF8iMj8GVz1clqLsVdNrsnxdsKbzXuVyXtCfrV6AWkl1/AkYCk9Li58uOtLGlP1f6jQK/bUtLPFXhN0S126W/wB+3i52RL7dVF2Gh317ShZPrnE/rgWBfhksphUHEvPhtHDeJZTikTrMAwAhTLTgKai1RE1lTCemGkyUHGN2JD9p9n4h32MwjGZaEVq+27JeSUVylt7xbenSmSaxxxJeMdq0e9hdWTFo8ohS4S+MkX/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ev4zXeggkV0JQmMudPAtl6b5/Q//DqIBPcVJEt1e1GM=;
 b=dIJXRBRkZzaSTDPf46ErFYix4VNqD46bORYfsNcQWbjbGkXG9W9gBIXfHLGJZPbezhzKuV82MgzamZtbMmeYKpJeb3/RWcivDg4B2S6G6NMMAvQQcTxIziigox9UGm7DJmLc2PKDL8c/Q3AOAEIqblv+P7TFKntAAn5JHsQoZHtRID/4XXSQYtzkub38JbQdmGYIKDnNmJIiiDZS6fz1hdiFzy3Vi4yewOdUVCzE2SIG2quIKrw+71yGIAFiXzdocUOCXXlqhd0XPJwgELUJTjc0Du7JQjhSgNpLiTghi4nks31HQn6zimRODT7RTe4Z76vcpfOlXcxKP8YYacFdlA==
Received: from BL0PR02CA0063.namprd02.prod.outlook.com (2603:10b6:207:3d::40)
 by CY5PR12MB6033.namprd12.prod.outlook.com (2603:10b6:930:2f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Mon, 18 Dec
 2023 08:39:03 +0000
Received: from BL6PEPF0001AB72.namprd02.prod.outlook.com
 (2603:10b6:207:3d:cafe::48) by BL0PR02CA0063.outlook.office365.com
 (2603:10b6:207:3d::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Mon, 18 Dec 2023 08:39:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB72.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Mon, 18 Dec 2023 08:39:02 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:38:47 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:38:46 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Mon, 18 Dec
 2023 00:38:41 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V9 vfio 5/9] virtio-pci: Initialize the supported admin commands
Date: Mon, 18 Dec 2023 10:37:51 +0200
Message-ID: <20231218083755.96281-6-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB72:EE_|CY5PR12MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef78de7-c0d7-4fa5-0cd7-08dbffa4c9ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jsBh6AJ509OdmQ1nvvWZhNM8QctlUEdOcn3jit2JrFblQpDOCuBG24X7kEzLyQ7kn5Ikp7XY+Y9OfgfyXAP+b2ZiNTzLtLItfzjuVaubLagEzkSBTSKSv60fJMlyGve7m22Hg/qwAhEtLtKB2J2BUiD9IBPCzugYhZ/xKwuNbc6gFgdxtJR0mXfoWPueycXjRB/YsP7kmF7kfER8upHW6z2UJb2vCj/Y/FLeScrblibkEs7nscWAb652zPPexYypYSPN0xkoKhb6wy6H1p9G0/4IyFQcf2k+NA2R7zzf+1N7nJlIUxa20hHTs8Zk0f0J2qhQcuY09xGWAqvI5/HiWUIXADa/Kwjx0HrdZbqztKs17bspi28KXaT4BEJdxXvMDi/+TwV5wnHvnYIMQ1gRLqMWVw7tUau6Qe1vyhk+KxMeTQxn3GGvwodnydLCfvlV/6ip/n41qEuZPmcsMsXeBeS+aw76cAwwyQV4g8aM3KKoniPkp8e8QeeriFegqTtRLfrQOpdYpYJ9mTKXXc4I3X9XpF4JmuvTUOzTEQBXO7gIYMOoE85olLYGj2MM8yI3y/HKTRtByWAUWWcu+/pWsrpO0F0nVXDd7D25qaKU+nzCO9+99MngSNZtPyZVPISySV+pSd9D+t7/6j4xJ7N/Or7Ehxmvs7e9cs4nw+5pDrf1HPSFCBKToCu3c2hqs0/9ZgbV7b6gORiKs749g6hQVhzBkhabsAPNBTFXxR+cfR8SqKsTLkKY4QbDD2CgkkA/0b9OK9CcYGtWMJ5YkQ5XDA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(64100799003)(82310400011)(186009)(1800799012)(451199024)(36840700001)(40470700004)(46966006)(40480700001)(1076003)(426003)(336012)(26005)(107886003)(2616005)(40460700003)(356005)(82740400003)(36756003)(86362001)(7636003)(47076005)(83380400001)(5660300002)(7696005)(6666004)(36860700001)(8936002)(8676002)(4326008)(70586007)(70206006)(316002)(54906003)(110136005)(6636002)(2906002)(41300700001)(478600001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 08:39:02.5314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef78de7-c0d7-4fa5-0cd7-08dbffa4c9ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB72.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6033

Initialize the supported admin commands upon activating the admin queue.

The supported commands are saved as part of the admin queue context.

Next patches in this series will expose APIs to use them.

Reviewed-by: Feng Liu <feliu@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |  1 +
 drivers/virtio/virtio_pci_modern.c | 48 ++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 282d087a9266..c2cb4b713897 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -47,6 +47,7 @@ struct virtio_pci_admin_vq {
 	struct virtio_pci_vq_info info;
 	/* serializing admin commands execution and virtqueue deletion */
 	struct mutex cmd_lock;
+	u64 supported_cmds;
 	/* Name of the admin queue: avq.$vq_index. */
 	char name[10];
 	u16 vq_index;
@@ -155,6 +156,24 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
 int virtio_pci_modern_probe(struct virtio_pci_device *);
 void virtio_pci_modern_remove(struct virtio_pci_device *);
 
+#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
+	(BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
+
+/* Unlike modern drivers which support hardware virtio devices, legacy drivers
+ * assume software-based devices: e.g. they don't use proper memory barriers
+ * on ARM, use big endian on PPC, etc. X86 drivers are mostly ok though, more
+ * or less by chance. For now, only support legacy IO on X86.
+ */
+#ifdef CONFIG_X86
+#define VIRTIO_ADMIN_CMD_BITMAP VIRTIO_LEGACY_ADMIN_CMD_BITMAP
+#else
+#define VIRTIO_ADMIN_CMD_BITMAP 0
+#endif
+
 int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
 			     struct virtio_admin_cmd *cmd);
 
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9bd66300a80a..f62b530aa3b5 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -39,6 +39,7 @@ static bool vp_is_avq(struct virtio_device *vdev, unsigned int index)
 }
 
 static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
+				    u16 opcode,
 				    struct scatterlist **sgs,
 				    unsigned int out_num,
 				    unsigned int in_num,
@@ -51,6 +52,11 @@ static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
 	if (!vq)
 		return -EIO;
 
+	if (opcode != VIRTIO_ADMIN_CMD_LIST_QUERY &&
+	    opcode != VIRTIO_ADMIN_CMD_LIST_USE &&
+	    !((1ULL << opcode) & admin_vq->supported_cmds))
+		return -EOPNOTSUPP;
+
 	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, GFP_KERNEL);
 	if (ret < 0)
 		return -EIO;
@@ -117,8 +123,9 @@ int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
 	}
 
 	mutex_lock(&vp_dev->admin_vq.cmd_lock);
-	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
-				       out_num, in_num, sgs);
+	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq,
+				       le16_to_cpu(cmd->opcode),
+				       sgs, out_num, in_num, sgs);
 	mutex_unlock(&vp_dev->admin_vq.cmd_lock);
 
 	if (ret) {
@@ -142,6 +149,43 @@ int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
 	return ret;
 }
 
+static void virtio_pci_admin_cmd_list_init(struct virtio_device *virtio_dev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist result_sg;
+	struct scatterlist data_sg;
+	__le64 *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return;
+
+	sg_init_one(&result_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.result_sg = &result_sg;
+
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto end;
+
+	*data &= cpu_to_le64(VIRTIO_ADMIN_CMD_BITMAP);
+	sg_init_one(&data_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = NULL;
+
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto end;
+
+	vp_dev->admin_vq.supported_cmds = le64_to_cpu(*data);
+end:
+	kfree(data);
+}
+
 static void vp_modern_avq_activate(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -151,6 +195,7 @@ static void vp_modern_avq_activate(struct virtio_device *vdev)
 		return;
 
 	__virtqueue_unbreak(admin_vq->info.vq);
+	virtio_pci_admin_cmd_list_init(vdev);
 }
 
 static void vp_modern_avq_deactivate(struct virtio_device *vdev)
-- 
2.27.0


