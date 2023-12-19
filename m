Return-Path: <kvm+bounces-4865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A52A7818F81
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:16:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D37128485E
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5056405C9;
	Tue, 19 Dec 2023 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VpJ9wUa+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E807138FA7;
	Tue, 19 Dec 2023 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgEGuFS6vv7nLwUrUrlzHPVn3lgd2nYejuiPL85d4mPSOmQkin0wCgkeFyjmUsfnx13jL+tT4pWbrRV7yyyIFEmA762e7ayuPCO/OyYvPm7lX6I+HTjZBGjqrKlHRoQhLqSIo274Q5xqWN4rVvVRD0TxUZ0AriUgeTW6UzbCtfmDtAKrQuhxSIEFmFGpvljYdKKZWIyQuSrDHOBwA7YvE6dnDRaBf+IaJGRCO1AtzPHhI3ymiys99gkIWNla32zDIDLzMrHE46f++p2Q63bWZKIcKFLzI3JqnPrp+7J3XX57e1yCyJaUopF7SGccymcBl9ZofNK8wzCliTZXOG7N/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDVmZqcRyoa1ZdteQQ5jmdeApTj3yX+tPraOMFSZZ/A=;
 b=aFS6rzkK6lVQMOXpTTHVedghKELeWvPBCacxRUWqyWwJrp32jrnZ4tKhHxAfdTJwT0iCDn1xYWFxXupqBpJ7lg4kgqQl+s0RMt2to5CSbY0xNxRBsANX0JhOUixmroDKdxGyOXRkL4+7bUH6ctmRQ1sRcIr7pKuuAbrv9dMwZelNPpnBGd7NrecOFWGtjWugukqbk0FvSYSwRARYS1/Gh8QrihE+x45o4Ho6kFUms+jd18jFdEYrpyEC0rrLPX+BhDVaiGsoZsxmjQSyXvZspnFBZyxiTXxF4tn3It9OtEcDe3xQac9pC6uAxIQlBzFeV9GEjN/R3jOOImEiKxfROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDVmZqcRyoa1ZdteQQ5jmdeApTj3yX+tPraOMFSZZ/A=;
 b=VpJ9wUa+ub/94cOKsX3wXRT1tfKxDIfEgoINYziVUjw//oEA6rANdQ+RXqhLUdf2e/8dlN5t8qqCyOBnL5MA9WKTagPZTqw9LPWsqITq0p9N8b2vNvDtSsdHqERXiQsdBewyV2HrKUeFsCTZKUZGzanQzeBB4vNW9V4X46vtaDMkh3CXiy7cT9Obq1/WSXkh+I5GwGFIMjZ4Ln9RLHBM2rOvwnFGIc2EJS/KQezYk97JFtyFxmCbM90tGZyVic95BBJ+6argOBtUoQOa/jVFkYtpeHkGCsZL8nU665aQko06qwjyXuMthbQgwFHOvbIkDjZs0YK27uBITqbmpATIOw==
Received: from BLAPR03CA0141.namprd03.prod.outlook.com (2603:10b6:208:32e::26)
 by DM6PR12MB4329.namprd12.prod.outlook.com (2603:10b6:5:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 18:10:14 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::a9) by BLAPR03CA0141.outlook.office365.com
 (2603:10b6:208:32e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 18:10:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:10:13 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:59 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:58 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:55 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 14/15] vdpa/mlx5: Introduce reference counting to mrs
Date: Tue, 19 Dec 2023 20:08:57 +0200
Message-ID: <20231219180858.120898-15-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231219180858.120898-1-dtatulea@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|DM6PR12MB4329:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b2c8442-81c3-4837-1705-08dc00bdbf5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	z47rwzkk3IykgzDNbqaRDHswtIx6j6qD0eHGo1Cw2DVfGzX27gG/ga/c/SmKOuZVl/si5lRI8dWDpDKz2MGyJdz2ggdbCYGFR34IY1Qq4v7uIN7G9beScaRlzJd7vpx5+VZbp0n7xr/uK/oxLSlspd/1jsN5dc1fvmuDVnbOb3flCu7dok8WtCh+X0SzF/nrRckYqLUkzJctg8kB3EZxACfDsQg0BafqG3BUMAZ3rQr5Nc9sLh22VlYgi5bPf1l78pRDjOdSOVABrlgUj95zNMYEaiTlMJRiDFbPnn37sTNskE999WHmHW803LNaiN9Y/O0LsCTqm9cTFjSfNZaH9v3gojHEtBnSDbSYqfbpYfMJRin0a3qhQIpaoy3qfZHWfEbgmAQ6UzJEJumm/y8QCbGj3yamLG1/5AxnSq3j4eDvXOKN3VEVniaqEFGFet1sxSL9wJzmABQCE7jiaV86w4ZCW0A4gDo6f83AyT/riSYb+bEimfTqP2HRn+JSl4AVq8t6NTydJCuCW1sBod2FdvJDxvSOn4SDNSYRYfBFgDJ3kcBi2InJqmiBxckJONLsyff796SHS6NX3CfTapzqYPmVcMZIF930PHc2V99s+vskEiO7AurI89Mn8h4shrONJrGY0zNFBa3cUTTqpFUngHjw6YqLjpfjYGXIwhLEhJTKISR6pDGM+6mtucRVbWW0EbXLpnmkcjLZ6beHcKMU7dzzpDnneN9mJfP1k38rsgDVtWXGTxCCFTkLPQ8ReWdC
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(82310400011)(40470700004)(36840700001)(46966006)(47076005)(2906002)(8936002)(8676002)(4326008)(40480700001)(54906003)(6636002)(83380400001)(316002)(5660300002)(36860700001)(70206006)(426003)(70586007)(66574015)(336012)(110136005)(82740400003)(356005)(41300700001)(40460700003)(36756003)(7636003)(1076003)(478600001)(2616005)(26005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:10:13.7038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2c8442-81c3-4837-1705-08dc00bdbf5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4329

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
index fcadbeede3e1..f81968b3f9cf 100644
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
@@ -3102,7 +3133,7 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
 
 out_err:
-	mlx5_vdpa_destroy_mr(mvdev, new_mr);
+	mlx5_vdpa_put_mr(mvdev, new_mr);
 	return err;
 }
 
-- 
2.43.0


