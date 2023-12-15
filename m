Return-Path: <kvm+bounces-4569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A80D814A01
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9609DB2285B
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8932330330;
	Fri, 15 Dec 2023 14:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G2YiH9LO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D229F358B4;
	Fri, 15 Dec 2023 14:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LePkPbGBgnf1hc/g4K4R2D1I3N+KK50BBAnyRRx2uMNxpDBpTmWdJceYhvrODqlszF+93RqJzeoXXdKph2ErN7gb7dnwZbQmwPS30342Q0Mga2FFDhpNnHgW2+M0sSQEQi5P6u54nlbszPO4FwE+D53uRhpMZbUGuWfFI/eCTd396v6chEyPPn7K4sCS9cSTcRwYpERWz5gvm40QyVuhYZlH2crbnzTHrxGUGOMijjOZxPEi+FgN+RQI36mys66lp9mGT6T+w/vARQNMpDRiZQbnYpKFWID0Y/3qZlntLhsfp5F6Mpc27NUi4waIyymUxTZ0SMa/1u+ykP4F5JeOIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Imd95NVOb0WyUcAorgggfZuy+9KsIAF5FVX6Zde8bIQ=;
 b=ix7TYj1Q5qPv4z5IvkOTPy2liWDVUPxSRUUqUw/LJiK+i8zv0k8DRvDrl2SrUybwdQ/KDe48TKVPc97PImOmDlpeOqOGdaIjeHrYkktu2HiNWvc4jGCqYzbZWbkwEKjFQWVmdeEgNE36HB1dcTQpqOie2UaU8Bjg5WJQP87rAFlLKRMq7H+2Wd2nzl+sOKzeBq9P89byONck+Z7zNrKlsCEqCSqBIWiAq7cT+JdAmD2/o7cZXJaCNTNs4QLWRw5KryJg6xviXH3+HQCjg/4JBwKoPFPmjitI/CkjUQP+qZgBHo5h7o4UFovkJvciV+/juS9MW8unZvrhyvufFI4Ksw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Imd95NVOb0WyUcAorgggfZuy+9KsIAF5FVX6Zde8bIQ=;
 b=G2YiH9LOYieZUwJ4tkjvbrwjyuxMq3BqNKBw874R4ppMgmviTtNCTYBhHsTtBdco233wE0tDhNMoM/c6suNOAmfwN/ccWfldtk2vg5B2OYHf7eFnmqDgB+N+Vv8ptfkZ1Jc7F+u0yA/23yVka9xaah0dZtN9gm91bov4CTSoGIfLV4jTMfgL4M+rYWhiY0qSTAr4iu9YL6/5PPL3Pr0DnANKUOsRIg9YZyWT3res7ymSuWygTqhiRBarfrdkaUgOO52y8/bYoySpARvD5ITmtBhDu4kWZNaqN5M4IZbuGplHsIzORuO20IJe6Shn575dG7YHI5O5MTT0lmC2TA4I5w==
Received: from MW4PR03CA0293.namprd03.prod.outlook.com (2603:10b6:303:b5::28)
 by MW6PR12MB8959.namprd12.prod.outlook.com (2603:10b6:303:23c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Fri, 15 Dec
 2023 14:02:26 +0000
Received: from CO1PEPF000044FC.namprd21.prod.outlook.com
 (2603:10b6:303:b5:cafe::2c) by MW4PR03CA0293.outlook.office365.com
 (2603:10b6:303:b5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31 via Frontend
 Transport; Fri, 15 Dec 2023 14:02:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044FC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.7 via Frontend Transport; Fri, 15 Dec 2023 14:02:26 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:14 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:13 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 15 Dec 2023 06:02:10 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 5/6] vdpa/mlx5: Introduce reference counting to mrs
Date: Fri, 15 Dec 2023 16:01:45 +0200
Message-ID: <20231215140146.95816-6-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231215140146.95816-1-dtatulea@nvidia.com>
References: <20231215140146.95816-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FC:EE_|MW6PR12MB8959:EE_
X-MS-Office365-Filtering-Correlation-Id: 20d4cfb8-d4d7-4d1c-6e26-08dbfd7677f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oqKdiIp7bM9XMZ7A50kq5OgH57HHZgkY/Js5uZtBF5nzoY83GTgouSxokCYWEcAf4pfQLGfjmsUT/G7RM9s/M2vxT7RvwP5NuhWiUU9Gf4nR1GNpNVwjEUAwvKYCOZDiXqqs8cqXjgh+Vt+Lp/woqg1Q2Qbq8cmS7UU8ZDJoZI7QG2mtxvJPJ7DuOg6kfdragAkRugS4N2ap3EW+NhMEniSgAlJ9OKWT9vSVLKoDJOXde9d/Fqq+pbvA/wwPtVr4OfKvgzvpRaG9Nib6f9ehTERzIbuwuoAepTFH71fgURz56J2HWPY9vbLPCT7dk1n60E9RQA4jT99JpZM66KQqmjymw4l6SiwWPpV7Bkifsarv5UEHEck5k0rXR7h7r5Nee622wCZxeNkVaI5too0U1DHA98dLXQXTL4O8J1zJbZNqeDij/KhI9o+4FIBL8UYwkQfmIg/Yrjb/0pB3XtqkSPhdVvLnSZtv6w0fvWoY//KzM+WN/ihX5qsIqDQkiV+sS49/lkcf9OdVRA6WOqYIlHmCh1Md1eca1ZAxDuOAsBH4cIOLdcRlBchL89PS9TTCLn6yZthy8jksqSOWCIgSCQ/jbBo4av60VrIrdg36aaTOLfQOylV2z76ZQj+Ul+ps6J1OM8DfU9vnhcFbkEN3uau3MrW1MzzeeBo5DfOIatLq6Jy1MV56ATgtoV7ryQzMA/1TtJWZSbcHdG+L98vNfhavs9+agJCoGJy0FXaCXhUjG856uK49/wtAnSNTbKp2
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(346002)(136003)(230922051799003)(64100799003)(1800799012)(82310400011)(451199024)(186009)(40470700004)(46966006)(36840700001)(5660300002)(2616005)(1076003)(26005)(47076005)(336012)(426003)(66574015)(36860700001)(83380400001)(2906002)(478600001)(316002)(54906003)(6636002)(36756003)(110136005)(41300700001)(70206006)(70586007)(4326008)(8676002)(8936002)(6666004)(40460700003)(40480700001)(82740400003)(86362001)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 14:02:26.2464
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d4cfb8-d4d7-4d1c-6e26-08dbfd7677f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8959

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

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
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
index d5883c554333..0df82e4d13f4 100644
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
@@ -1245,19 +1264,19 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	}
 
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
@@ -1270,6 +1289,18 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
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
@@ -3080,7 +3111,7 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
 
 out_err:
-	mlx5_vdpa_destroy_mr(mvdev, new_mr);
+	mlx5_vdpa_put_mr(mvdev, new_mr);
 	return err;
 }
 
-- 
2.43.0


