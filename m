Return-Path: <kvm+bounces-3094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFD268008F8
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0C0A1C210B7
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793462110E;
	Fri,  1 Dec 2023 10:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G1dsSuB8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2089.outbound.protection.outlook.com [40.107.95.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793D2170E;
	Fri,  1 Dec 2023 02:49:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4v5PMou7X0UrRJFP3JtnRIa4YEALvESf0HNWNWkOD7VGNEle8gjf7s3tw7L9ndN/l5LM/ahG3ffPOTLjMEjt5vxgtkuy2WrDRVE9NtwjDj8X8iaVRBMW9M2IZq9xPaH6xxTLJh63HChabvvYmtvIKhshtfXKpb+cuidwiiojidz2nI2Mx70XqaJbt6ldDjHpetZ2Col41a4+xN91Q44+wJhVD7rzwVDGbR+in+NOoHNosrT0DtcEYRDG5bxyoHOE7auRDFBAdyrvcWA0b5WqhQklVyaGLpIgMV1mRRBKW+UoFAjkaG0MApzOo2tGYPYlCriXhNySiTN7OfTj9cHQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbkkSRuhAnoXxmmmaWrUCRkEl/cD3hqskadOAIqvb/g=;
 b=SQLmG5IkCBIiUo5TNv6evMZhohvOPNdqI7LHEcsB1X9jZ/1OuYD3j4QztJDUX0R9EOmraqf5ReFaitq2qFqdENjpGsk4x8RKihGW4i2QY5IvP2OuSIzbVNEs95G8BOYm9yOzT7FV/mdumIBOT5UTuy+eRh6CyiEKgYkeB5TXqUWxSaKQmQbxTlX/0mQyBmpYzXuH3eK0T3fAh2t9ZPSp0pnKnATANw0rkx/WWr6E1yCx/nQYeX/FvnqBLftl//r6ZTyZQ7v1ZbsvZGXBt4dh2oAX3gkDdHh1YtzI8AwaEG4pleqB/Hi1U3ng5jf+fVQRvjKmusUrJgxjAzUCFnFzPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbkkSRuhAnoXxmmmaWrUCRkEl/cD3hqskadOAIqvb/g=;
 b=G1dsSuB8rtBLNM3Aa4T1+ml7mYl+Rw+J5chgMtFHjg/Kk0sYbSNaj4LSX5LJ8JGec5mjnpdVJ1Pp/ZvnqSFa0JEUtwvK2fZZ+S7TTBw9wG/eprZ6tOqD9IW2avgefe+Y4hNeW/v5bCpp/3Ebqkv22eFhDe4ka08xh1MLHxRJzj9IrOG2YddracIFYrFRk5BMGNt10TnYQZvZEqd6tgNA/nx9E5PwmF7QPRoAxIRPOhZyRba7N0VaAD1XW4se7eMtBMr9R2r/goIDfcHMKebkG3q+cBhcvSUrEnaZ/Ul+IWz6DjAfYQVA9oO5ZPq46H9YcgyXRtwPJy/eJArKUB2Igg==
Received: from BL0PR02CA0103.namprd02.prod.outlook.com (2603:10b6:208:51::44)
 by DM4PR12MB5723.namprd12.prod.outlook.com (2603:10b6:8:5e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.27; Fri, 1 Dec 2023 10:49:47 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:51:cafe::19) by BL0PR02CA0103.outlook.office365.com
 (2603:10b6:208:51::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22 via Frontend
 Transport; Fri, 1 Dec 2023 10:49:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Fri, 1 Dec 2023 10:49:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:31 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:30 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 1 Dec 2023 02:49:27 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <galp@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 3/7] vdpa/mlx5: Allow modifying multiple vq fields in one modify command
Date: Fri, 1 Dec 2023 12:48:53 +0200
Message-ID: <20231201104857.665737-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231201104857.665737-1-dtatulea@nvidia.com>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|DM4PR12MB5723:EE_
X-MS-Office365-Filtering-Correlation-Id: 6179766c-a5ec-41c3-c62f-08dbf25b3c9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5kJWC9zPolktG+YSeSwWTnGFVcE+I04TD1wn941VTluQLB9kPtVGetdsAUq2uTLOHmoK3cYlu4WH9I2hr2uAkb2/Pyin0rPCjLWDUtqhMBP9Ip/QzfRqmXzlkJkjZSb8r6cFvMYOpl7nHstwWpwvMH5LfQSoCOlzJEn/PlVYLbBWdwc/GW3x6ixBpOolZPrXkjVe0Zrh21F9VYJK95o6SM/h2IqLZZdIDgThSdRRgkThwgLuTS/xroZqysvFwPtopXOyZAJ8QiD6XBOPJ+Pad/ELF/t8gRUHw8j20G8PrvQmAnvAjGW2md72T8AYLa7VCekir+M1Z8lsy9A+hLr2GwXsUjW7cNP3Z3AHjfis/CEFUqPT8MLdDfXYRTRH1+W12sN7gAE5HAQ1u3u4WeBF+AoflZ5rGQ9pZ36r4BN1wprcDdvWAozLlQoPAe/JJhXv3YAtHgD/yER3XWkQubMwWkxca3895jpWmBI+HYdfNrPHu/4dzISJ7v1I6dT4L1S58z9AHAikWvwouj0FM6KjQRTdD/3VLI5Hh3FeUvCrduXfbwRkpdDXT7aBR5mTK0Sincz8dsEVcXrWft4Nqeaf9qDf26cO0/EWjZ697BMFs7JVeps6ZrKrHFcd0zMWNk+DmmxR7bKv94IScFZmFVIxrEEBhQzSqA8A3zScCGvn9b9sHYLKXdFFQsgGug/ihg4HRyjagbe6l/7pxvwEekds/WM/PnzlNK89qbwGo68vqk4Jb5dJbu93FIKSNE/jw8I+
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(186009)(82310400011)(64100799003)(451199024)(1800799012)(40470700004)(36840700001)(46966006)(316002)(66899024)(54906003)(70206006)(110136005)(70586007)(478600001)(40460700003)(6666004)(5660300002)(41300700001)(36756003)(2906002)(8676002)(8936002)(86362001)(336012)(426003)(2616005)(26005)(4326008)(1076003)(40480700001)(356005)(47076005)(7636003)(36860700001)(82740400003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 10:49:47.4034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6179766c-a5ec-41c3-c62f-08dbf25b3c9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5723

Add a bitmask variable that tracks hw vq field changes that
are supposed to be modified on next hw vq change command.

This will be useful to set multiple vq fields when resuming the vq.

The state needs to remain as a parameter as it doesn't make sense to
make it part of the vq struct: fw_state is updated only after a
successful command.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 48 +++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 12ac3397f39b..d06285e46fe2 100644
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
2.42.0


