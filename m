Return-Path: <kvm+bounces-5231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0900281E14B
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D4681C219BD
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98605380B;
	Mon, 25 Dec 2023 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="suTD/beW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDC153805;
	Mon, 25 Dec 2023 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGHqDZ+9TXSter1TBb12BDpVijafa63vOY44f1n5jgIBE2qGFvX5/xI6XlzOc+Djsu53dclqlBvLfiApCU0HsYgmujytp/eLZOpDUVqUViChDA43ROTyJRebvr3oyGKAn2QshVaIk6M+Dc1vSGeAQzO7uZwXHpjNh7EZoeSBo0ZdT8IOwfpX5XunczZp2XTy6MVrg4zn8O3lXaJ7JmUmI0haBG2HAu1PW9a4IY+0leL69zcoIG5VcGUAEKec2VtFFeA0Al5Z46bV2ICpxM+OCXEsR01AW0g/aeXWgZ9dcgw/JpmUaBSykJ+N+dZoUFY4lPjZ2ZXWbxjKb9vsakotnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sWgIp9I4kovwVObHi1LqHJ8vdH7vji4dtQH3gkxaR8=;
 b=XEMg+qV2P3NkW/oBv76ApbxhCBIRIsOxRrRjt6yqsPac3+BO/mzS8iNw5SAA6uNKQfoG9eS5ZGB6hPRqQ8rV8mnY+rkkU8/MiFowrgKjk8/7JCzPPSKq32bbQUcG/VJ/gcPy9YfTSl4zf04fDEQVrfmyCsrpjRWl5KpqML28vIJtcAzu9F96tgs/zAFTr5nSWEGWw+sr7ynjt9Nj8hfj1T721CKOsiA7gGWSxjTXEWmNJ3e67AOWu7TfDcxIafKynhcvp6bCBnegtxXH3hQRaI5xke52C5Gh4npU4KuROVXSaI5/ytN8U9a4a+PTbq4LSrWRrZiW8zsXAYC5cA4iOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sWgIp9I4kovwVObHi1LqHJ8vdH7vji4dtQH3gkxaR8=;
 b=suTD/beWt08ecs/KCNHRsO2XR55p33W4G4JcMXsk0xIY6JW9PfiUYCkDKqVjchngQAh1HRnBTV7lIdc4MMbo4c6uAAdSM/6cqDoHiejMBr6haH85t3H430Wxuiifj65WwpytVj5yDRGLKUIlig4xLIiQ4eGQzrxIFi6Pnssf0tBOMaTM4pNHHuTZYGZhMEi7nie+xyK+zbeP6/rVG8n+FidL0JoDj1w4y+cbLQZ1Qk0VbFVQG0DeLNJPmA2C1lxOq5CQUMKG7YMihXNH9srqzD3JuxMqHvbbGrkNoFEcsjjKhrsJAWhCDck43oNDvd+HVJHa5HtP+euQM6R1OX8WHw==
Received: from SJ0PR03CA0211.namprd03.prod.outlook.com (2603:10b6:a03:39f::6)
 by PH7PR12MB6666.namprd12.prod.outlook.com (2603:10b6:510:1a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27; Mon, 25 Dec
 2023 15:12:24 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::fe) by SJ0PR03CA0211.outlook.office365.com
 (2603:10b6:a03:39f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Mon, 25 Dec 2023 15:12:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 15:12:23 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 07:12:14 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 25 Dec 2023 07:12:14 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Mon, 25 Dec 2023 07:12:11 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v5 2/8] vdpa/mlx5: Allow modifying multiple vq fields in one modify command
Date: Mon, 25 Dec 2023 17:11:57 +0200
Message-ID: <20231225151203.152687-3-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|PH7PR12MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: acfa0632-18ba-48c0-a7a0-08dc055be5ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/aB0x0zi4ykjyk1LdIq8cmgolFrz7nLpNQpqZO2mIu8KayDAvCzHWIg5AwIt3O1OVgSHDXCUXFQJKvA86C19iqFSr/qze8+xGugmvUOmrqgWHSQCQWk9tSHxgFgo6n9q4+b9SnahVOJyGGFkNldG8YVBlU1gkTm79JvwvRW1N6tubN6ksIoi3h8PwsIXzgqYehLCFDudaqAkglZxKB/QD2wSFFY+1G2TNvsdwA3oZvua5yTFooy/H/EaAnEPvrlMBh/TSqASxriqKWRAv8eHzmpLaweEtXNNsAZM8ePzCERmbFPZrxpOEfPHAAFNvzLufGcm+EedKC52o5cT9ssQ5507/GFbSSv5OMOLk3k7GVsJbc9pUqaKI8SKtljsnf5idd9eRE/pLFyO0zK32aAgSH26OiE+J+rC6hZR/dGfylAlkNRR5eWTUPzUIZ9h4SlsJCgkV5RLi1KIs8Z+qv7Pdni1+WZkuquWi/KnAhZkmrE9miZlL/mMrhuDDIQOkh5jn1qqlXfZtmB2slpuNPzyEFrGzSJXmRBAQ/9QtbtbZ3ldU6B3kOjlB1mVvJ485DXrieevm2fnTewF0arGSiWeIX5f6KjOWRrKHvpZAsz81z7sVjK7qogLtzCXStkBGZW8y+xECgdSc79TUrdiWUHDICrjzSMoW0VXy0nJxqrgAUFAbw60TaeDDXbdXcD8Bh2CdkdrsxrenhBb/Jm37tMPkp+P0DFRGkrzjGxTATZfdht2CcbCrzo2CmI+V6L8oUv5
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(396003)(136003)(230922051799003)(64100799003)(82310400011)(1800799012)(451199024)(186009)(46966006)(40470700004)(36840700001)(6636002)(70586007)(2906002)(5660300002)(110136005)(54906003)(316002)(478600001)(6666004)(70206006)(36860700001)(7636003)(356005)(8936002)(8676002)(4326008)(40460700003)(40480700001)(66899024)(41300700001)(47076005)(83380400001)(82740400003)(66574015)(1076003)(426003)(336012)(2616005)(26005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 15:12:23.8355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acfa0632-18ba-48c0-a7a0-08dc055be5ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6666

Add a bitmask variable that tracks hw vq field changes that
are supposed to be modified on next hw vq change command.

This will be useful to set multiple vq fields when resuming the vq.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
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


