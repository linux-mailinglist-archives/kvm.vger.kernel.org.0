Return-Path: <kvm+bounces-4859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1756818F68
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A91942875BD
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370B741C70;
	Tue, 19 Dec 2023 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nTt1YB6c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976534185D;
	Tue, 19 Dec 2023 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceA3Erkev07AWpWJZArd/1i2ONQyTjSCrrdkCN2FVbQifZIGRkzvgtsHiU05R9E+s1OZDsPALKWTLX9CbXFj1+oKLJ3Jclc8Ac5EOHDjYjjjC2xSuVaUXQUVBj4DSnKgt7zmlCsxxv6Y5jMJSRqkfW/UwgStwRf9W5CGgCqndOJ2FteSFVyiwPysWW1aVJ6QexKLvy1CUZf9UpQp1/4LVR4td6yB+YUmxqa9LqCJJyzdP799AN4xEswC3+aX6gt9QsCRc8BTuJlgk544fkJteYWZTK0tTC6pif/uQom54cQcerwJ+HrTI4D6DoJmc5wMBhtKSW873dXDjThwf2x26A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPdT9vtITGHn3MYb+1Dsvi1MMhbs1EU5ai/kuf3a03Q=;
 b=d7tbeYUDmmapNOhKHf7p3uu2rdGMWCdWs2TQuhM0B7rqxYFxhj+qvuz12H9VdET5eSTity41jVbKK1YbtxcwP71Xb48seCwhJCTSuo7TFlE8ORG8uNo7nGfJZ0qnrGRc5RFOIUABCxwGTWTcOZ5quM/PV1Nc8AnAaYU7kKis78aD8532pvhRlKHRZnQelZJV2Qdd8ZD3/FRAE+BhuZ8i7Qlx7lpcUNSym7F/Xe+5XCGsC0CDwNFOF90FidwLbZ2XZUDvJDn8Lu0PiLl0/8BIycCsj6RiwAdEqUIwJxwiGF8tz47b3HdLXmafIbzNXjW7kD5O8xglH1ytGC7Jw6aM1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPdT9vtITGHn3MYb+1Dsvi1MMhbs1EU5ai/kuf3a03Q=;
 b=nTt1YB6ch51WgxpNPbRlgFteiAPqyzmX53klER0HM+C3AgIbtkCguf3Ill5mjRDGtKvGMdQeqJ18pabqcR7khuBlLJuxJU4LFupNnFwEjNWi/o0Ez/vmnWB1WOYbHAdfLeodiDra9i8T2Q28rT+1mZbR8d/FGtAG5O8iiW/rDxkGU1YF7iRopZL2dBkJbjxHPh2UN1gIw4PhtSRUFj4HhTxpmvWpcG5W6SUNkneq3PmDkzfA5bu/GCJEut78Ni+1brHJBpGkNbxPKBmRZAmiw5AmOl2VwQfnA2dCM1PLz5JTCVFoqZnp8B5IWP3XP1pJ42JQ7rUyBkeXXEcHAMU2mQ==
Received: from CH0PR13CA0053.namprd13.prod.outlook.com (2603:10b6:610:b2::28)
 by IA0PR12MB8424.namprd12.prod.outlook.com (2603:10b6:208:40c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Tue, 19 Dec
 2023 18:09:53 +0000
Received: from DS3PEPF000099D8.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::5c) by CH0PR13CA0053.outlook.office365.com
 (2603:10b6:610:b2::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.17 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D8.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:40 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:39 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:36 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 09/15] vdpa/mlx5: Allow modifying multiple vq fields in one modify command
Date: Tue, 19 Dec 2023 20:08:52 +0200
Message-ID: <20231219180858.120898-10-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D8:EE_|IA0PR12MB8424:EE_
X-MS-Office365-Filtering-Correlation-Id: 591a0248-5841-4061-9987-08dc00bdb340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RT7UreJ5nnXh9NCEk6grvdxtov1WZh4Nh1/s7zWGmNfqcHPHKha8Fcq4ZM65jPA2t8bNSPPWp4fCe9+NmbmRswmnvFjW59upOBXXnLjTQxquVNL3wln5/hF4JAk1usDJuSrvisB1afvweRFgIoBjj+kT8Pmp+JMdkpKf/KEBkOO7ekjxcCzPhi4uhXQ8XKTDmLX7A3DuiIZy8dGMpFiDXUYmn4lBlOoV3+xezSYquyvJkCyq4n6TfGfDy9Dp5Vwe+XP3zRqD6zbeSQzLvn1j7SbZpRjPAKJSldrNUqJnbR4SOU/7uofiu5+R6W/Ywkh4oKmqMAQsXvo/4NhvLuUgtNGn61LL/lVU1sBFqm2eO2Ky2IueIyjI1dp/NUDCNW++c1z3t+0KsXsz7UAbjN47yH3SuQQJFtYmjFrtkiQp949wVtZnHOgExw45ttkrH0TOvMz/1ziZQWpsghae0SXj9QiYVPihdje25Pp0gmspGCSM+La3kQodOVZ/UFxKVWir5s4wNqhhYLCCBGNdIcokUvFbPW3El6r+0e4o3KTb/u0LrYGo+/bRXHgJuS4e4NO8tICLvQLbvEYf3gea641Hk3gPa8qEFo1HWabJbRbFIVPt9vcJF/zSdv9cfYToukdlwv5is33GSu8mZBvpacYMz5yzgHi3tjpTg8cbyHyt5FPDq+fisva6xJN1UKA/zPB0dNDptHlHs20F44P/qjY6j+Py4QJnuQr7VKi2fDCDSuPm2wVnbm4k4+ZdNYK9y8Gg
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(136003)(39860400002)(230922051799003)(82310400011)(1800799012)(64100799003)(451199024)(186009)(40470700004)(36840700001)(46966006)(86362001)(356005)(40480700001)(26005)(5660300002)(6636002)(478600001)(40460700003)(110136005)(54906003)(70586007)(70206006)(82740400003)(6666004)(7636003)(8676002)(1076003)(4326008)(316002)(2616005)(66899024)(41300700001)(66574015)(47076005)(2906002)(83380400001)(36756003)(426003)(36860700001)(8936002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:53.4379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 591a0248-5841-4061-9987-08dc00bdb340
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8424

Add a bitmask variable that tracks hw vq field changes that
are supposed to be modified on next hw vq change command.

This will be useful to set multiple vq fields when resuming the vq.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
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


