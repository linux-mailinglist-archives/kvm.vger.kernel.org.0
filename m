Return-Path: <kvm+bounces-5234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3B6681E152
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59E712825F6
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E3B54BD0;
	Mon, 25 Dec 2023 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q7QITSAK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A22253E2F;
	Mon, 25 Dec 2023 15:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMtGw1HIuyhczNb4fBt+QTleod7uW89Zmco9OTWZTUaApC4tzjoI12otWSUxd461LB6rmwbhBVREoaeM8YatD/U8WWjY+vXdEalkPsfGv+ZZ5sdUR4++efjARe+T+awPVrxggnSsbAja1HsCI6yfuSx+uQZTJf6q73oYk7xWy2Z/rh7KLAxXehedgzFRo9TbNCTghsS57HMXClUN3zCmYH6Q/vzBLOz3g1ZAZaYf0AEra2I7y3b+xe9QMbdjnQxVDc3zOEhr8ej6L8x3tIRx22o6qgTNNNI8ZgVVuBaJKritJkF2VqY0JdoAfYh+RfCiKULmCu6nB4q/ZbKnrN8QjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g66ghTZLtFZ6RKVbTDHL2s76ERbT1RNFRTFxRVjIuHE=;
 b=kbCuh7bLHCD9h7tvBzZT/GQePOOL9/UcMSTaGicWonC7HsaD040UKSMtnByIp25bZDPlj2nUKWjCTK/bCm6y1AWStPkaAr+vX9ZDEeIK50GLZfFrkiJATzUFwJpOhsP1AJfF6mDQ8dD8j6TuRKhtT5lfXIembEbgZiPvgdlm+UoYOE4QS9PjLgmnieA9N+mBzKGsPBwCbwXl8tg9e8hUqjUdugGU/ZkhXzEazQnMIz/XLcRITppwd/byH1d9yRNMkwQT3ZY4ILeQipFuKpRvtUM7TC7b+gbhh6AnpiXgltKp2tedMYaXWfLfjZafAqJ3IfLn/SyVENYcFYrapr20/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g66ghTZLtFZ6RKVbTDHL2s76ERbT1RNFRTFxRVjIuHE=;
 b=Q7QITSAKQ8KTRFe3tK5CcjywXKsYwBe1PZkPO/fKWx5/5YBOK7kvdh3sNyvJqpQs4RiyoBe72uSy+6JSbsIxfWz5epy21xbufKH5P7zUhWWg+uRFNYaX27/YRxAQ91O3Tmh3Uf0zkIqbf1zBrW1vXCLoFZANILKTg09COf5tqum2/nHv5yyyxRqULEe9QP9sCSX0mTuQ6eV7bBsw2lYcAhnEsJUaw2Gxpp5L4ri8+5G/VwXpxf6SdBdrE8uiJwDU1JR2SYIV62e/aBUUUW/2CRYpAaLEOLfLfCqNGW+OvB3gMuzGeRUetJzkGssTNQ4jUlBWwG+Z2ESMieKrzimIVA==
Received: from MN2PR13CA0030.namprd13.prod.outlook.com (2603:10b6:208:160::43)
 by IA1PR12MB6602.namprd12.prod.outlook.com (2603:10b6:208:3a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 15:12:34 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:208:160:cafe::c5) by MN2PR13CA0030.outlook.office365.com
 (2603:10b6:208:160::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.16 via Frontend
 Transport; Mon, 25 Dec 2023 15:12:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 15:12:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 07:12:32 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 25 Dec 2023 07:12:31 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Mon, 25 Dec 2023 07:12:28 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v5 7/8] vdpa/mlx5: Introduce reference counting to mrs
Date: Mon, 25 Dec 2023 17:12:02 +0200
Message-ID: <20231225151203.152687-8-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|IA1PR12MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: d0f719d3-d8bd-408a-7fe7-08dc055bec17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k+Hq/zByhw8i5h1r4LByIGA51HetOMimB6U6EMeFemkmfBcbNyxHSjawJTn0UAlv/fBrbiAonV3x6g2ucR5tYvYVD9/xNBMnER/xOoKERO4/rpnly9oa7+H34zvB99+7kApKkfSjLFV1T+JEM1r/71y77Z/Ci1Pb3IevqNUWy0UAYISp5wnoHMtedk/BXEZe/eeoj0z5XgjVYqhGyNowKWCREQXVEHa5+VIHfsN3OjLiei7BulHAQHBkCXEHDa4cPP48V0WPVLkBKts/cQcmjQoNbu0Hzk3S8QdUuL7/40IZMNIEfcWMF0dNiNCENufirfpOSVr14eGGca7PzGMtUxzn5ukT9pJIi7zwpJkoPuUntR1Rx/K+xRhwWgCmW3zxt2lIn3OfXZy8FTvGVSxHJwAhS5jNOqfQUIvv5YmDnOoa7dtpZnABr7zvT5QwIwRygBgLB96bA4TyoV2ij17LTutJCaQQpdAxh6LlBW+IFPlTDkWX5e3nt2I8jq/a7fcTvKpcYD76CjhGRp5zpqzHopZBt9tvSXX/gwPl+/Ut4+HBPxHo4pZGdhDym+hyiCqF0IllHotMMB13xXNJTQKVSz0luINIheogGT9gm0mTbKrQkKJhIKvYaGVmb4pV29yV0gKak5ihWrLCAVSSYlrwtC3P/klbaooEYs2S/32xNcnbF9qzgWHz14qFAm54j5Dc/31mgExjfNr5wrcTYQhNvMQHi1UCm9jYYTVp/KoXrZXokvfe5K3NsyvsW4M0bU/V
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(451199024)(82310400011)(64100799003)(1800799012)(186009)(46966006)(40470700004)(36840700001)(86362001)(66574015)(426003)(2616005)(1076003)(26005)(6666004)(336012)(356005)(7636003)(82740400003)(47076005)(41300700001)(36860700001)(83380400001)(40480700001)(36756003)(70586007)(5660300002)(70206006)(8936002)(8676002)(110136005)(54906003)(6636002)(4326008)(316002)(478600001)(2906002)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 15:12:33.9174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f719d3-d8bd-408a-7fe7-08dc055bec17
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6602

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
Acked-by: Jason Wang <jasowang@redhat.com>
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
2.43.0


