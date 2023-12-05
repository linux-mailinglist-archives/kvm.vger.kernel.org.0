Return-Path: <kvm+bounces-3512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D046805117
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B247A1F21597
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806495D49A;
	Tue,  5 Dec 2023 10:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j2fRFkv6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D646109;
	Tue,  5 Dec 2023 02:47:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAugOt3xDWDHTWQwQgOcf2TYv2BaK1DOxY4NTUBVUtuayrjGKV4l9NVGF4P99KKdwHMQiOwO81khhJZZcnshlbZWlSVFGjR2vkAQ00y/vwo4tf5UxewoX5Stq4Rj+xAw+9Z508c62Pl1Hp3eZAJ2RtLQmxIJZgnGa4c+rY8+p5//ob+fUDDV8OUtiYOfaW7TOINzA9b3qfqH+7yT1jztVaNgXVQjhr/oltVz62LooWdd4ptArbK1whvvAsoIrV/GZ7ZsGH+tpfunqlfa3u4UvNxEQve7lUIgWxhf0erCsNegXGWr2AwRK+xfJYy4mWHSPl9YdmcNZCqyDYgToTGOkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmnTSuDMlg6UrNUarJnZfl2MUGLgu9oqKhmm0RZDiAY=;
 b=f+YIq94A5Vwe+fxG7eKEwXXoxqSGUNVmopxxftrlgZiZ1lxS6lkxQ/5JPF9HIIaU1L2FYQBmV/pI2kaTLYLslGwzA4hju96L8h7W/IJr1wzAe8FP1sOaxxtgCrvNkilNpGiT3letyQfMLloJWsbPG0M0OshNe/3S2Wba16lH5FKjnNWJ+llCP7A5MiSe/VD/Oo962ZBKVxQVdorEgHLdl8gCzNlIAxu+BK9FA1uDseZMM0Lb0hzDJ2kx4MTOKKVj4hMAqKt40QGE8aeBUc10cB6Im/LG7CDfAkk9slUB87DAdXN7UB6xUxu1Qj2mtBvnh1/1vXqHN53fQt0ZOsCnDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmnTSuDMlg6UrNUarJnZfl2MUGLgu9oqKhmm0RZDiAY=;
 b=j2fRFkv6N4XZzYW1y4U2EgabHDz0OYrtDEFOviUoSQ04QpURwpM3nEq6g9T4Kgw+JYOPEMQlNfiHf/B7UKE/UoPA387veYXqBlqJrUfm933W7OUQ3eSRquHOhlGDujlUlyY1R6c3x87ghJiEMYXpj4L5ZLQoyIdRP6EhEwIFnnLRtgmgIaVVmgAC//HXPQmfX5uM0kaG23LyarbaK0dwu7xTxIxzrcEcpayIjNxj+ET9vNvEe14LoF+PVlDQf2wG45jrtQT9smfVRuKxxXCi4P9kg6YRWFb1b08Xgtz2wwlHaQjcaX5b61B20E5JM5ZRnBoAPfUDMM6Zpdpd9r1RkQ==
Received: from SA1P222CA0192.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::13)
 by SA1PR12MB6775.namprd12.prod.outlook.com (2603:10b6:806:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 10:47:04 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:806:3c4:cafe::ac) by SA1P222CA0192.outlook.office365.com
 (2603:10b6:806:3c4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.26 via Frontend
 Transport; Tue, 5 Dec 2023 10:47:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 10:47:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:45 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:45 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 5 Dec 2023 02:46:42 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v2 7/8] vdpa/mlx5: Introduce reference counting to mrs
Date: Tue, 5 Dec 2023 12:46:08 +0200
Message-ID: <20231205104609.876194-8-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231205104609.876194-1-dtatulea@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|SA1PR12MB6775:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ed7a8db-f89d-4855-e4bf-08dbf57f84fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JGkvOteMhvcOUByllclwWHAcwEy8meYtnfmvWJgHQci4314Xhb07c7GrYbpGBlEA2289NDHbWwsySTodFAnRWUTrgbXArkkgIMTc4vmZxxS5Oh6cTq+M+4PDoebwQ2r1C3RmZpFSgqZ3E9i83v+XP9EpoUkDvo/BqTLjNo9WrQQv6nBAgKaCgxK6MCUU+roOuMdoH8KiY4w5LtOYezJ7PI8apm+dLv4V8nlOiwluu0PxljjSuc1bwTmZwY3knfjgasqY7uPelWEJNEvHHkvVjMoEa4ki0X471GMrJo/gq2rO7tQq8P+fKPPdGsL6C7jTmt7LJpEg1gIBSVpP5MnHLQAjQKjnom9CAu3vjkmrgkyyJWH1GOWc9czorZUKKngB1Bq8Wa5Wlxc7+KIHHDUy2LtNQltBWHtZxAUqVIVumpJSX1A89S7ZG0eb+g2am/qmcGCPdVIskQbo1PFocQUb1GhG79lj5KgsCw/Lg215m7APiLgmM0idpXP4Asj2hirNK5DJb9ln3DriCw69SZhB+GrOmuhnK3sFE15XJSYoAFDN3ez5tlz9WV9qkvtWCiKOkjgFNVa16cB1wBSbVh6+9a/NuZ6CFTswRvrsYeyb46yKU4difsyPk2XqIhE/hSp3p+YNEfJq/Qxqehqp92+h1kxmGTUwJDRi/9uObTYcH1aqrbS03FDG+wnAsQNiYhq5LYQZh5uaxkGmL8dK94svO0qqoMeCj5VUlxy2zq6klcbks/2MT2iJi+pRddqbIMFM
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(39860400002)(376002)(396003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(82310400011)(40470700004)(46966006)(36840700001)(336012)(426003)(83380400001)(82740400003)(478600001)(6666004)(1076003)(26005)(40480700001)(2616005)(110136005)(316002)(4326008)(70586007)(8936002)(6636002)(54906003)(8676002)(70206006)(36860700001)(356005)(47076005)(7636003)(5660300002)(40460700003)(2906002)(41300700001)(36756003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 10:47:04.2534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed7a8db-f89d-4855-e4bf-08dbf57f84fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6775

Deleting the old mr during mr update (.set_map) and then modifying the
vqs with the new mr is not a good flow for firmware. The firmware
expects that mkeys are deleted after there are no more vqs referencing
them.

Introduce reference counting for mrs to fix this. It is the only way to
make sure that mkeys are not in use by vqs.

An mr reference is taken when the mr is associated to the mr asid table
and when the mr is linked to the vq on create/modify. The reference is
released when the mkey is unlinked from the vq (trough modify/destroy)
and from the mr asid table.

To make things consistent, get rid of mlx5_vdpa_destroy_mr and use
get/put semantics everywhere.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  8 +++--
 drivers/vdpa/mlx5/core/mr.c        | 50 ++++++++++++++++++++----------
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 45 ++++++++++++++++++++++-----
 3 files changed, 78 insertions(+), 25 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 84547d998bcf..1a0d27b6e09a 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -35,6 +35,8 @@ struct mlx5_vdpa_mr {
 	struct vhost_iotlb *iotlb;
 
 	bool user_mr;
+
+	refcount_t refcount;
 };
 
 struct mlx5_vdpa_resources {
@@ -118,8 +120,10 @@ int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
 struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 					 struct vhost_iotlb *iotlb);
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
-void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
-			  struct mlx5_vdpa_mr *mr);
+void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
+		      struct mlx5_vdpa_mr *mr);
+void mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
+		      struct mlx5_vdpa_mr *mr);
 void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 			 struct mlx5_vdpa_mr *mr,
 			 unsigned int asid);
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 2197c46e563a..c7dc8914354a 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -498,32 +498,52 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 
 static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 {
+	if (WARN_ON(!mr))
+		return;
+
 	if (mr->user_mr)
 		destroy_user_mr(mvdev, mr);
 	else
 		destroy_dma_mr(mvdev, mr);
 
 	vhost_iotlb_free(mr->iotlb);
+
+	kfree(mr);
 }
 
-void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
-			  struct mlx5_vdpa_mr *mr)
+static void _mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
+			      struct mlx5_vdpa_mr *mr)
 {
 	if (!mr)
 		return;
 
+	if (refcount_dec_and_test(&mr->refcount))
+		_mlx5_vdpa_destroy_mr(mvdev, mr);
+}
+
+void mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
+		      struct mlx5_vdpa_mr *mr)
+{
 	mutex_lock(&mvdev->mr_mtx);
+	_mlx5_vdpa_put_mr(mvdev, mr);
+	mutex_unlock(&mvdev->mr_mtx);
+}
 
-	_mlx5_vdpa_destroy_mr(mvdev, mr);
+static void _mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
+			      struct mlx5_vdpa_mr *mr)
+{
+	if (!mr)
+		return;
 
-	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++) {
-		if (mvdev->mr[i] == mr)
-			mvdev->mr[i] = NULL;
-	}
+	refcount_inc(&mr->refcount);
+}
 
+void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
+		      struct mlx5_vdpa_mr *mr)
+{
+	mutex_lock(&mvdev->mr_mtx);
+	_mlx5_vdpa_get_mr(mvdev, mr);
 	mutex_unlock(&mvdev->mr_mtx);
-
-	kfree(mr);
 }
 
 void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
@@ -534,20 +554,16 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 
 	mutex_lock(&mvdev->mr_mtx);
 
+	_mlx5_vdpa_put_mr(mvdev, old_mr);
 	mvdev->mr[asid] = new_mr;
-	if (old_mr) {
-		_mlx5_vdpa_destroy_mr(mvdev, old_mr);
-		kfree(old_mr);
-	}
 
 	mutex_unlock(&mvdev->mr_mtx);
-
 }
 
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
-		mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[i]);
+		mlx5_vdpa_update_mr(mvdev, NULL, i);
 
 	prune_iotlb(mvdev->cvq.iotlb);
 }
@@ -607,6 +623,8 @@ struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 	if (err)
 		goto out_err;
 
+	refcount_set(&mr->refcount, 1);
+
 	return mr;
 
 out_err:
@@ -651,7 +669,7 @@ int mlx5_vdpa_reset_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 	if (asid >= MLX5_VDPA_NUM_AS)
 		return -EINVAL;
 
-	mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[asid]);
+	mlx5_vdpa_update_mr(mvdev, NULL, asid);
 
 	if (asid == 0 && MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		if (mlx5_vdpa_create_dma_mr(mvdev))
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 6a21223d97a8..133cbb66dcfe 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -123,6 +123,9 @@ struct mlx5_vdpa_virtqueue {
 
 	u64 modified_fields;
 
+	struct mlx5_vdpa_mr *vq_mr;
+	struct mlx5_vdpa_mr *desc_mr;
+
 	struct msi_map map;
 
 	/* keep last in the struct */
@@ -946,6 +949,14 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	kfree(in);
 	mvq->virtq_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
 
+	mlx5_vdpa_get_mr(mvdev, vq_mr);
+	mvq->vq_mr = vq_mr;
+
+	if (vq_desc_mr && MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, desc_group_mkey_supported)) {
+		mlx5_vdpa_get_mr(mvdev, vq_desc_mr);
+		mvq->desc_mr = vq_desc_mr;
+	}
+
 	return 0;
 
 err_cmd:
@@ -972,6 +983,12 @@ static void destroy_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtq
 	}
 	mvq->fw_state = MLX5_VIRTIO_NET_Q_OBJECT_NONE;
 	umems_destroy(ndev, mvq);
+
+	mlx5_vdpa_put_mr(&ndev->mvdev, mvq->vq_mr);
+	mvq->vq_mr = NULL;
+
+	mlx5_vdpa_put_mr(&ndev->mvdev, mvq->desc_mr);
+	mvq->desc_mr = NULL;
 }
 
 static u32 get_rqpn(struct mlx5_vdpa_virtqueue *mvq, bool fw)
@@ -1207,6 +1224,8 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	int inlen = MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
 	u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] = {};
 	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
+	struct mlx5_vdpa_mr *desc_mr = NULL;
+	struct mlx5_vdpa_mr *vq_mr = NULL;
 	bool state_change = false;
 	void *obj_context;
 	void *cmd_hdr;
@@ -1257,19 +1276,19 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 		MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY) {
-		struct mlx5_vdpa_mr *mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]];
+		vq_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]];
 
-		if (mr)
-			MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, mr->mkey);
+		if (vq_mr)
+			MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, vq_mr->mkey);
 		else
 			mvq->modified_fields &= ~MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY;
 	}
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY) {
-		struct mlx5_vdpa_mr *mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
+		desc_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
 
-		if (mr && MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, desc_group_mkey_supported))
-			MLX5_SET(virtio_q, vq_ctx, desc_group_mkey, mr->mkey);
+		if (desc_mr && MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, desc_group_mkey_supported))
+			MLX5_SET(virtio_q, vq_ctx, desc_group_mkey, desc_mr->mkey);
 		else
 			mvq->modified_fields &= ~MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY;
 	}
@@ -1282,6 +1301,18 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	if (state_change)
 		mvq->fw_state = state;
 
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY) {
+		mlx5_vdpa_put_mr(mvdev, mvq->vq_mr);
+		mlx5_vdpa_get_mr(mvdev, vq_mr);
+		mvq->vq_mr = vq_mr;
+	}
+
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY) {
+		mlx5_vdpa_put_mr(mvdev, mvq->desc_mr);
+		mlx5_vdpa_get_mr(mvdev, desc_mr);
+		mvq->desc_mr = desc_mr;
+	}
+
 	mvq->modified_fields = 0;
 
 done:
@@ -3095,7 +3126,7 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
 
 out_err:
-	mlx5_vdpa_destroy_mr(mvdev, new_mr);
+	mlx5_vdpa_put_mr(mvdev, new_mr);
 	return err;
 }
 
-- 
2.42.0


