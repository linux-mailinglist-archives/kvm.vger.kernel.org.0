Return-Path: <kvm+bounces-3507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F10805109
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79345281800
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEFD154BD3;
	Tue,  5 Dec 2023 10:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F/tA/RL6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E9B10F;
	Tue,  5 Dec 2023 02:46:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cAGWuOkAPSgZf47UgUIJc/EDqaq88vapzZGIsm1X2c9yDBtBmdnfGb4RuzCGNPzOl2SA7tORlSmaT7O9zr7lruamjYpec3Et8wBTpO5/LsLo7X3r9dHy01tOo2jML/jQhuDDwNzGLrlzWRGVEsJix3XrGRPGv3NZ47Q0fGszrPkrizzWMxSykO59Q5h+ecmZnwAMNxHr6YqhHpm13qBxKOUyzledptabQYToqL7yBkyLS1aGy+pVNYm0zERJWZJYOcB19Ea7sR/ntCYHgk7GEiTdT9UYqCmhe05f0C6Z1BfTaNJZTa6ut/7+jEYRzkoOMfZy+BVnd56dCHnhikuchw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=An8Syir92Vj8AodKfUp5XRBa97QSN66p6UCwyLSlCOQ=;
 b=NqFRK7/LOvYjVyVzg5sUn3chK0AOxzZBr21Ic2CQcAu3OxFd+IIipeN/eDHoSgPiTljYPqbQoR9gLocCgQyiVx/npYpkd/kd4wTaM57GELM+b1FueTNIFmtEbbdh2F7BnfW874qm/g9GYeaB56LVfx1vnnYEKeFOU9o6G1p2MktDx1d3fcs/E+af+B7hs7a2iUnGBNZKy2E1Bgj6vyoNAPL/wq1vyIBrtuxxARegkxbRZpdge40yFZMHSRpHi0ZnWb4CGW2+AexQ8FQ87TCjzt5ThaVan/CResb4wkMvJl8m4xjb0JIAVaMAcMUoBBH2DXe6Skia6M0CvZmh0ged2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=An8Syir92Vj8AodKfUp5XRBa97QSN66p6UCwyLSlCOQ=;
 b=F/tA/RL6s5ahgwNIe2dN2E/5SAUwEBuww7Wub/hm5Sl2wd09CWYgH4MPZRnZjZjq8gm9Jpx3Wca3nSbdB8vU2HO5kDdqHDpN9lxRStIgIr+SKbGmnoDUtgp4oQ9lpf/8oSBBwgOxD9MGIENhGGmqeKTTqW6B4NFmmDrtOEn+n8EzemdXGNNIuLSpRkzbtFjGJbwasCkq+lBf17OMtMKInDRYWA0+zn6GeBvp6vhMBvx4vVJyLbFmDJEK259q/BK9BLbF83KV8ENg92w1ZomhN7pEAYyBPSSGtayUy+f5a7qUA5kbCQgMb/2jKyRLk/jyWenF92BaC79/dnFLE6DGtw==
Received: from DS0PR17CA0002.namprd17.prod.outlook.com (2603:10b6:8:191::25)
 by PH7PR12MB8426.namprd12.prod.outlook.com (2603:10b6:510:241::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 10:46:39 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:8:191:cafe::38) by DS0PR17CA0002.outlook.office365.com
 (2603:10b6:8:191::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 10:46:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 10:46:39 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:27 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:27 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 5 Dec 2023 02:46:24 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v2 2/8] vdpa/mlx5: Allow modifying multiple vq fields in one modify command
Date: Tue, 5 Dec 2023 12:46:03 +0200
Message-ID: <20231205104609.876194-3-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|PH7PR12MB8426:EE_
X-MS-Office365-Filtering-Correlation-Id: ef98bad9-3676-41ce-027d-08dbf57f760d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AIBnSo+Y4nqUjO/K8pw0btR6huDh5PCkEE2r6rcvpim2+bfQN0YbBhX3RM6DeaUSmA/9EbKJrVaz1cRZziQal9HuMP2q27nD6U4xYcRf1JxuphvEos9TcAQSPOYWw9AaODKcKilG04HQMZH71vJuzPhav15GLJXaCWtPVMfP+xQAMfZbdB9wluLS/C3HJWCEvPlNGSotNlhDKygiAYb2SJSiqkSC/+l4Xe/cIaQDRxYcbk/q9dXhdZ4xgjWf60bace8w6lLz1HmiP4TsmWsY3GOwVd2+JdfsmgqukxnQzXvasS5Ap+1n5SXEBGnX3cbovcjidb42208Tqy5YZ6nXBhyiowC4Z3UOoXWvPDdzSGJo6nX4tv7aH4XVNQOElWaCbiZA+0JZgsH6CVJzQmK7yh6nD/y5MO9JtvDJnctMJH5YOF0CUh4tIEHSBE5HIMIyo87yDILrZjsnekyShw39aW7SB2AGvlgGzTMGoF4bRSrVkFLl3TFgRBf34Re5VxZtu2eEp+x98C4U18kv1lefyHFwmtQy+3cdZ9F8pLZeejKNpt/jHUDia+Lg3KpOmR16uAXZWxKGzZ7pNIFKmouCPbIdSGNTyPPVNjnSfwzWaBlw5yNUrjnLPNCwLw78XAjldes3Fgf2WCnKcavEdB3CbZ+l/J7TmnLLEE63iNqWbtXXjHCnrwTPVpPxqYh/Q/iYl8SnMI0phehN8LBrI8IXbAd+Alfit0FIxbBqQKA29e5bkzNnJkDS1RMsCvxK6sT2
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(230922051799003)(451199024)(82310400011)(64100799003)(1800799012)(186009)(36840700001)(46966006)(40470700004)(8936002)(83380400001)(426003)(8676002)(4326008)(40460700003)(66899024)(82740400003)(7636003)(36756003)(41300700001)(86362001)(356005)(2906002)(47076005)(36860700001)(5660300002)(6666004)(1076003)(26005)(478600001)(40480700001)(2616005)(70206006)(54906003)(110136005)(336012)(316002)(70586007)(6636002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 10:46:39.1866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef98bad9-3676-41ce-027d-08dbf57f760d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8426

Add a bitmask variable that tracks hw vq field changes that
are supposed to be modified on next hw vq change command.

This will be useful to set multiple vq fields when resuming the vq.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
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
2.42.0


