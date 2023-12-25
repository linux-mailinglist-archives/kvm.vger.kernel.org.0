Return-Path: <kvm+bounces-5236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D0181E15B
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91B501C20F89
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB0654FA5;
	Mon, 25 Dec 2023 15:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XsrbFQWn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4491054BC4;
	Mon, 25 Dec 2023 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5nErJVBIZJWxhHclQKPDp8CkSmH0LoC/fTnAvabicgaDfiBhWGg989AjJygUbqI4uhue8ZUxQmio0FQhWuZtNduySqBvxmDD+5IlWe+SqypTg/3EEm/I4RLW9gYSFWagXQgRW2g+bBtmDMvf1WYbJjz8tFE5bKbtSt8Zn4B/RJPDNH9cJ/QwK87ZN1ZbEWf4Tez08+464fev5F0NVuaFeYpoalGllRc5osz/vk8K6hrdK9zPHFp3hputE0UT6eP/NhCk2Gt+SqHeiR8E/C/JW1CMrZLOvi1yiS8yK8CUa6mKIaTmwtyycx+8t+isnfbvzalD+TUi7cqPy+8xzKgOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3FT8XZHAI7WIdCRDOPtdU7tXx+bsHH1iqAAYhKHTUU=;
 b=N7YfglJi5soFLmANnAn/5wA4G3zMC75wnHNU4nddNe5RnRZfCDliK8nFCfaVjSsbijcQh9hx8bQ3lXZi9kFPffLS+8G+kB2mO+ly60H8Ef3rTpAKBc108cuLUg2l+wpAv3XHus2lTZ9AasgIz/iCI46a0/LaQ7k/YapomCJbImyUkV45aJ80ZuTxj7KXDK9UwV6/D/fGgNOqxvgP4D7CIe2k2ww6a9T+OcFGhe3jeascJpmWsHMEZGqYJqAH0iUCBPseKSQB61C/lmFKWULdorsQxjAKawhSZwexdBFKN+JoCaQz5D0G62XMMuqEW0KgUu7fc8ajmdqBhWWps7X3HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3FT8XZHAI7WIdCRDOPtdU7tXx+bsHH1iqAAYhKHTUU=;
 b=XsrbFQWnerOAbxkBuM7RjaIRMmRMSB/GIKCEPnQCNpk4DGtkS+N0Ibgz73TnYUhRY3ikQ89KiIej3RU33W06dWLXEPk4BxdI4bDA9xVQ/Z/w0vWCMhxln9Y15HWpSyJUHH2S89DlSCz1RLldXbK5UNSpFIq/jreCf/tG1ubXO1t1C6HmSMwBH7pQl1EJdcgCf6K0zwg4gnYqZTv6AgGC0e9YdfMtlelRjm1elJZLmqEjVdcBN7b4g2GEiwhOzTWf6ILeJ44XUqMcvasN9f1a3H5/1zsHDGaUdvbz57EpfP3ScbBR9wwU70PC9/PfhreGkGJ2wJYJx744bYbbCNKx6w==
Received: from SJ0PR03CA0138.namprd03.prod.outlook.com (2603:10b6:a03:33c::23)
 by SA1PR12MB5638.namprd12.prod.outlook.com (2603:10b6:806:229::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 15:12:36 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::20) by SJ0PR03CA0138.outlook.office365.com
 (2603:10b6:a03:33c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26 via Frontend
 Transport; Mon, 25 Dec 2023 15:12:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 15:12:36 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 07:12:28 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 25 Dec 2023 07:12:28 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Mon, 25 Dec 2023 07:12:25 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v5 6/8] vdpa/mlx5: Use vq suspend/resume during .set_map
Date: Mon, 25 Dec 2023 17:12:01 +0200
Message-ID: <20231225151203.152687-7-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231225151203.152687-1-dtatulea@nvidia.com>
References: <20231225151203.152687-1-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|SA1PR12MB5638:EE_
X-MS-Office365-Filtering-Correlation-Id: 367ba304-9d93-4421-0589-08dc055bed74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7K+tF2H/vC6+zGUhJZxmX2qlvVfbqAlbdM2eHcsjhq8AHM1RS68Sn4JLhwrGaKgEF6Vh+StYCN2JVVgccIA46PpWyqjSd0GrRstdgZFptH95cYvoHUWmqRrUBAZP7KrT7T1OyK93FufFDR2W4r0ZOozLx1j+sbB6+49mtDgoJrbQe43ofrbf4oS8hnouY6uixNaDTe3yISQZirZ4gl4lNs2M9vu4yuP16UVPR4YAUw6JDYczmj79Ft0ar+PVKsjFAVHNZLObnFrqMECn6xOLsFsY3SrTNEikeetosTcjyx5BMqERht8NGpQ2aICk4pnDjQzvz9703ZIkUw8WtA9wG2Qm1voLeDCZ1RFvMBO9Dcvphz4EQCDGLlHZPwhkZhZcDqOz1hhbTttqu8xzG1tiMJPW/guF+JA4xWBKzKmWV9hP2keWuJwU63M9vvkc2tVD0f2ITbnhMGZgs6gLS1kgp4TSUHUDL2jq3VaSdw/FhltiiMHi4qEnJ8gXDE4fVVq3lV0jEv9kM115lEzLHxP8BLITy0qWPufB4asWdhUjQSuKYYAoFVm8f7a/HlhhLc3shDq1Vo2DbE5+QdLDUNl3BcCJvtnRBAhXDqWoXxrGRZwFd7ph6iG0RoV3XICZkmOwLgYVDQw3hv/Bu92Bwxaj570XL+yrOq0CvuqD6bILTOrzvmVp6p6oLNYjAMMSJE5Yjp9bx+Docf/+YaCiuDaOG+FGC2uAOTsHBR3/xqemsavPNNPWHe4oYykr2uLGq9v6kGjy9gf4Ay1T5TwpdY9QMg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(136003)(346002)(230922051799003)(82310400011)(186009)(64100799003)(451199024)(1800799012)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(36756003)(6666004)(70586007)(70206006)(86362001)(6636002)(66574015)(1076003)(7636003)(356005)(82740400003)(26005)(83380400001)(2616005)(41300700001)(47076005)(2906002)(15650500001)(5660300002)(336012)(8936002)(426003)(8676002)(478600001)(316002)(36860700001)(54906003)(4326008)(110136005)(142923001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 15:12:36.3578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 367ba304-9d93-4421-0589-08dc055bed74
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5638

Instead of tearing down and setting up vq resources, use vq
suspend/resume during .set_map to speed things up a bit.

The vq mr is updated with the new mapping while the vqs are suspended.

If the device doesn't support resumable vqs, do the old teardown and
setup dance.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 46 ++++++++++++++++++++++++------
 include/linux/mlx5/mlx5_ifc_vdpa.h |  1 +
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index d6c8506cec8f..6a21223d97a8 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1206,6 +1206,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 {
 	int inlen = MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
 	u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] = {};
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
 	bool state_change = false;
 	void *obj_context;
 	void *cmd_hdr;
@@ -1255,6 +1256,24 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX)
 		MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
 
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY) {
+		struct mlx5_vdpa_mr *mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]];
+
+		if (mr)
+			MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, mr->mkey);
+		else
+			mvq->modified_fields &= ~MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY;
+	}
+
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY) {
+		struct mlx5_vdpa_mr *mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
+
+		if (mr && MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, desc_group_mkey_supported))
+			MLX5_SET(virtio_q, vq_ctx, desc_group_mkey, mr->mkey);
+		else
+			mvq->modified_fields &= ~MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY;
+	}
+
 	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
 	if (err)
@@ -2784,24 +2803,35 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 				unsigned int asid)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+	bool teardown = !is_resumable(ndev);
 	int err;
 
 	suspend_vqs(ndev);
-	err = save_channels_info(ndev);
-	if (err)
-		return err;
+	if (teardown) {
+		err = save_channels_info(ndev);
+		if (err)
+			return err;
 
-	teardown_driver(ndev);
+		teardown_driver(ndev);
+	}
 
 	mlx5_vdpa_update_mr(mvdev, new_mr, asid);
 
+	for (int i = 0; i < ndev->cur_num_vqs; i++)
+		ndev->vqs[i].modified_fields |= MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY |
+						MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY;
+
 	if (!(mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK) || mvdev->suspended)
 		return 0;
 
-	restore_channels_info(ndev);
-	err = setup_driver(mvdev);
-	if (err)
-		return err;
+	if (teardown) {
+		restore_channels_info(ndev);
+		err = setup_driver(mvdev);
+		if (err)
+			return err;
+	}
+
+	resume_vqs(ndev);
 
 	return 0;
 }
diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
index 32e712106e68..40371c916cf9 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -148,6 +148,7 @@ enum {
 	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS           = (u64)1 << 6,
 	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_AVAIL_IDX       = (u64)1 << 7,
 	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX        = (u64)1 << 8,
+	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY            = (u64)1 << 11,
 	MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          = (u64)1 << 14,
 };
 
-- 
2.43.0


