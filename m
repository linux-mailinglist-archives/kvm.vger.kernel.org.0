Return-Path: <kvm+bounces-4567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD0E88149FB
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0F861C20F9B
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14DD34560;
	Fri, 15 Dec 2023 14:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sl57bRPD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6845931A6E;
	Fri, 15 Dec 2023 14:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRG5KDQaVIMV8wIRcZy5zxscgOrW1ilPyFbDVlpIIzQyssibabkUEQOOYVHPHwGWIXy0ZUCx3fUdWn2GQaIEA7ByQKlFvs5IN4QDwdvXmX0YUbf6YJRQu4au839He5Zb9evVTZJI+0L43Dx6Gl27hFl0dYaN09u4HrW/B3pI/F3tKvzaKLLzYG1iD1hgop99etmO8uIktcS1p/M4Jti6ContxrhHTPu+gCV2JKRsuvWGsMA6FWP/YdqqwZ18OM021PakZ3H2X9YI7CJNIGEfOusH3lQ90n2YJKIq8j7vd7odJv6i6EHd3ZsY3J4zXh5vqJsqOJWqzStzk22daIZwdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TylNfpW+6Q9SObHOV4Gz2YDSDSlijQBPCRfcODsmnw=;
 b=BSIONikxP6+uJPfJjOKyXpE7JdDm0uHz347wW9DVwV6IauuAsg6ySSnKzYdjpYGnnoUg95xzjTNI/N8z8IdlRaCMLVPiJRLNr4mzv6xedGYsfc/wWvZUXcPP9+RRBkl08RZ2SZiUWk0dJWwIivFbGuvkDv62VjVym68Ib8e88AyTJyqlFj2AML4QjH4OdnhQmFRI0qryAd/dZMUS13exBAZmHxDWQUqt4+usMiQ8D5G2Bcs3r8g7c5Cr6nOgSq7SCFVU61+P9zcLZ2dD5J1VGTcDAtyltmz7v2aqJa4KL5rWLtxT59AthgWQvliF/cS8GLPID5hv+hYNvNmmX6ZwzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TylNfpW+6Q9SObHOV4Gz2YDSDSlijQBPCRfcODsmnw=;
 b=Sl57bRPDtA2DhLbHFnUT1pVK4+qh2T/CMQdOY3iTwjjEc4K7ERgHck3lzX7w8ZMjjKAdPWwxlVUDNhHAVOE6KQfFULqR88FZJvLQg8xQeqabGK8i/eGPaHQtIKMaASmI9MIfIX1c0xoqQNTMyt4guyOXwap30yikASggcx/MpmbcOuI0fHgogLbeWf2U1BBFyPbHFB3dcrT4clK7piBroKb8C2xBMqu69h11aUhfDC7tXlroqkIu7wx2YrRmuK+fFCZi0r/eTe64Ne9afHGTJSZUrLi4L0ObQP/U1wspqyavwOfZS25QSLbYiZFzSNb3+w1IFGQ6l0YKpus+6hIzyw==
Received: from MW4PR03CA0066.namprd03.prod.outlook.com (2603:10b6:303:b6::11)
 by BL0PR12MB4882.namprd12.prod.outlook.com (2603:10b6:208:1c3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.30; Fri, 15 Dec
 2023 14:02:18 +0000
Received: from CO1PEPF000044F6.namprd21.prod.outlook.com
 (2603:10b6:303:b6:cafe::50) by MW4PR03CA0066.outlook.office365.com
 (2603:10b6:303:b6::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31 via Frontend
 Transport; Fri, 15 Dec 2023 14:02:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.7 via Frontend Transport; Fri, 15 Dec 2023 14:02:18 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:03 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:02 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 15 Dec 2023 06:01:59 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 2/6] vdpa/mlx5: Allow modifying multiple vq fields in one modify command
Date: Fri, 15 Dec 2023 16:01:42 +0200
Message-ID: <20231215140146.95816-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231215140146.95816-1-dtatulea@nvidia.com>
References: <20231215140146.95816-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F6:EE_|BL0PR12MB4882:EE_
X-MS-Office365-Filtering-Correlation-Id: 632488e5-0448-4309-928c-08dbfd76734a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SiaGfGF7BsKy3s+OhtLvkncrFj/v7qpWuHVIdUpiyeLUhvayeiOslYQ7Ml0pv2KThLwkebR7uOxAAEht96dtOEMOVrkcAgm6gC24xAt1izF7bN/RmCBe8CS4npM8SsjV2hn82DMfMVCL5P69DVGhkmWcuMlWpmtEkta5NT/nn722nZR2IBTfJ4u3NobdPgj3S26DwzRzewe2VB0fpAILWoEpsF7eGwa1sohIUdTA/T2oDTdblbpzIXWQxdlF9x9EBxCk80tIxN04Opk5ROfzRUKvGjODlF9khSLgqrLUKKA9poxh4fzVvymX6hfOSnYsVyXWEloAkrmiVAaMgvoKe11SWibH2eUWxBpGkfI2MNx+BEAjdB+rPWgN4EIA6tjjxfXU5AszlY3bmClofoKcC0w1ZsL6+zCRJErCABxANI6JtkZZvOud8XPm/3WXESFcFuFXIYbYI5t+BpyIEK+zFQuXVEjmp+JzyUT4dIQk5hWT7aT1wTfYOyV9afpvlRFD5u2g5FLtK/DeVV76X3MRzOg0m3r3vraYgEDg2y0nOlOckb3GhgfHyaGcqL/8X49+Gzlhkl+cXM47Oi0g3lkvOUId5kVqkWHPmWr3qMDrISWdJMcvkOXBz+BOqx4ABKaQemsgOnFmcPFBq8SjNhVXbgjtGojg6EswkR+tVm2yAO3kKWft5Ro3QwiG+nz2kOdW79W7kALOJxMth5F/afv2wnsBLKLQiY0uz9F1l1wbyFzrRh9Y7+a9FEyM/wWV+PkB
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(451199024)(186009)(82310400011)(64100799003)(1800799012)(40470700004)(36840700001)(46966006)(40480700001)(66899024)(478600001)(40460700003)(6666004)(8676002)(4326008)(8936002)(47076005)(2616005)(426003)(336012)(110136005)(70206006)(316002)(83380400001)(6636002)(70586007)(54906003)(26005)(5660300002)(1076003)(82740400003)(7636003)(36756003)(356005)(2906002)(86362001)(36860700001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 14:02:18.3104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 632488e5-0448-4309-928c-08dbfd76734a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4882

Add a bitmask variable that tracks hw vq field changes that
are supposed to be modified on next hw vq change command.

This will be useful to set multiple vq fields when resuming the vq.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 48 +++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 26ba7da6b410..1e08a8805640 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -120,6 +120,9 @@ struct mlx5_vdpa_virtqueue {
 	u16 avail_idx;
 	u16 used_idx;
 	int fw_state;
+
+	u64 modified_fields;
+
 	struct msi_map map;
 
 	/* keep last in the struct */
@@ -1181,7 +1184,19 @@ static bool is_valid_state_change(int oldstate, int newstate)
 	}
 }
 
-static int modify_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq, int state)
+static bool modifiable_virtqueue_fields(struct mlx5_vdpa_virtqueue *mvq)
+{
+	/* Only state is always modifiable */
+	if (mvq->modified_fields & ~MLX5_VIRTQ_MODIFY_MASK_STATE)
+		return mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_STATE_INIT ||
+		       mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND;
+
+	return true;
+}
+
+static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
+			    struct mlx5_vdpa_virtqueue *mvq,
+			    int state)
 {
 	int inlen = MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
 	u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] = {};
@@ -1193,6 +1208,9 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	if (mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_NONE)
 		return 0;
 
+	if (!modifiable_virtqueue_fields(mvq))
+		return -EINVAL;
+
 	if (!is_valid_state_change(mvq->fw_state, state))
 		return -EINVAL;
 
@@ -1208,17 +1226,28 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
 
 	obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_context);
-	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select,
-		   MLX5_VIRTQ_MODIFY_MASK_STATE);
-	MLX5_SET(virtio_net_q_object, obj_context, state, state);
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE)
+		MLX5_SET(virtio_net_q_object, obj_context, state, state);
+
+	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
 	kfree(in);
 	if (!err)
 		mvq->fw_state = state;
 
+	mvq->modified_fields = 0;
+
 	return err;
 }
 
+static int modify_virtqueue_state(struct mlx5_vdpa_net *ndev,
+				  struct mlx5_vdpa_virtqueue *mvq,
+				  unsigned int state)
+{
+	mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_STATE;
+	return modify_virtqueue(ndev, mvq, state);
+}
+
 static int counter_set_alloc(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 {
 	u32 in[MLX5_ST_SZ_DW(create_virtio_q_counters_in)] = {};
@@ -1347,7 +1376,7 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 		goto err_vq;
 
 	if (mvq->ready) {
-		err = modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
+		err = modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
 		if (err) {
 			mlx5_vdpa_warn(&ndev->mvdev, "failed to modify to ready vq idx %d(%d)\n",
 				       idx, err);
@@ -1382,7 +1411,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
 	if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
 		return;
 
-	if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
+	if (modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
 		mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
 
 	if (query_virtqueue(ndev, mvq, &attr)) {
@@ -1407,6 +1436,7 @@ static void teardown_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *
 		return;
 
 	suspend_vq(ndev, mvq);
+	mvq->modified_fields = 0;
 	destroy_virtqueue(ndev, mvq);
 	dealloc_vector(ndev, mvq);
 	counter_set_dealloc(ndev, mvq);
@@ -2207,7 +2237,7 @@ static void mlx5_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx, bool ready
 	if (!ready) {
 		suspend_vq(ndev, mvq);
 	} else {
-		err = modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
+		err = modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
 		if (err) {
 			mlx5_vdpa_warn(mvdev, "modify VQ %d to ready failed (%d)\n", idx, err);
 			ready = false;
@@ -2804,8 +2834,10 @@ static void clear_vqs_ready(struct mlx5_vdpa_net *ndev)
 {
 	int i;
 
-	for (i = 0; i < ndev->mvdev.max_vqs; i++)
+	for (i = 0; i < ndev->mvdev.max_vqs; i++) {
 		ndev->vqs[i].ready = false;
+		ndev->vqs[i].modified_fields = 0;
+	}
 
 	ndev->mvdev.cvq.ready = false;
 }
-- 
2.43.0


