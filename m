Return-Path: <kvm+bounces-4861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2EF5818F6F
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37A9A1F2BD8A
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA39945C17;
	Tue, 19 Dec 2023 18:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MbuDuNi2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1127A41C8F;
	Tue, 19 Dec 2023 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQXz++aF/+Bv0tt0QKW9AKpsHN7lEwRWXOpAa5tbeGbSseK1OrongwickP9JmtUZvLAHehYpqOynmdLn7UD7+P5WaZ8VYKa4cjSP9jdV8RpuP3iFnWEb7Wak7IZaxDSPUl6iNi/pB190UG8MjWK+Qxi7EKr4/MjzRQtVhlvgbAbH5l9u+A09geBfGyMYEIGB8jY6Iv0Uv1pujZ7ecPVbXuwXihK4sx3ad82cW1b/dRNt5qKXcqjgO+qldNhhnIJY3vt5rIFoi7Ls9r7lD6YtTWD5MV0TnEaiVJ8nTQB9te37R4shiqdZb9EObNft7lvIrXL6OjvxKsrj0s7xWp1grQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWpOeWI+R1cb4FK6LjTB81MteAujPvP3wVhkPCOcOb0=;
 b=nOc1gI+VXx5xa0iG0jGYtj+Yo9s46kC+GmA0LVdzUjSFSfENzhWhedbcPLkwfJ77X2NE98NCJDhc2Xp2oqG2t9NgtLj7A3gRK7sHbpXXuZn7typevSgWPFR+flRklHkZq+C9gSodw/eZDBiSRQgkYf3NEu4vDz+eaxGEJfw8O6Vl1mSryJkZ829oi/EV31f/dg3WjnBmhC3k+EFR3X5URdUhWXLoVGR6i4zeeiOzP2gnLz80Ya/g8SNESzoRHhDjq2Q4dGxALiA8BqCh2V0GBTHH2qAETzxPu9F/hrLR7++SFZ5aChQg0SDwxwLdi/K+h2sasVi6MaxEFU2UNH7IPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWpOeWI+R1cb4FK6LjTB81MteAujPvP3wVhkPCOcOb0=;
 b=MbuDuNi2jAIGRXjcsxnWnQuqHmPSBiqxU4UhDRu83xbgLCJZJBqSV1Qx/wX/xLNpyjNPHeL9TIOQ5mdAumL4VeJrKuivLBY8cPYQCrdsHZ41oSunp/P8NkT5tWdU58GhO0VRw7iF/wZef0A5ir4hRfPgMt9QamTAPhXmxMZqVNPPhqDRO4CAUKm00sqat2kvUDBbGA38DQKEDtZ9X9G/yMQQjeey/3RNV0JEfvxZsqv+oDwGYNAFmx/BS2enfEUndNvqz39P2F0nxVvmybm6BQ3c4dVzdIcRNCzx9R2swikgEpRC6WGi+wfk8uZENAXQ5amuZa0Sq1kou7zHyMMp3g==
Received: from CH0P221CA0014.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::12)
 by SN7PR12MB8101.namprd12.prod.outlook.com (2603:10b6:806:321::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Tue, 19 Dec
 2023 18:09:57 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::24) by CH0P221CA0014.outlook.office365.com
 (2603:10b6:610:11c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:44 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:43 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:40 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 10/15] vdpa/mlx5: Introduce per vq and device resume
Date: Tue, 19 Dec 2023 20:08:53 +0200
Message-ID: <20231219180858.120898-11-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|SN7PR12MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: 03a1d461-438f-4908-5a43-08dc00bdb54e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NNqX+JG2vcYilVMZ2GMv09CeRLzI+XFL4hyMykRyXa3jJiBBGgntE1K6dOg2VVI06NgCBYCiK4mZsapwq1eUfoQb4aTfWxJaqvUbDYsVcFCd/6QT7x+TxeEpOaLW+B6TH1ZTPF6C77lGuACrXax+3i84ZGdANWE0bc3ef0uxI8v8gAmvDbxyvPCpO49gqBZSSUqMpHiiqGtPD4XWLHb87XMUtOcMQt9NJZ/fK/827UnmcvNvzKOmJOzcaJGKLYS12HHLpsj8eMD2+K8A2/C2LnVjZymKkrwcY2oSRaC7dZ5RWyHTIr5GPjjScPcq4qVB6rl2LUbRHqFEcQ2QT3ZljBSJAWKuJbQ7HUcIR0gfTrJ+bSZOmHawy6QRKDDvBzuwNtf7v2FWJAgXLIHTm6VQEHkUl2SCKM8YHjcjLyG7Aj3CiXwNP4UyoCXT2JzqdNWRXQdL00wZstbs3pKnFv50LnHHkUB2oTKvxfWG0RU19ps0/bsJN1+9VLq1LINXFCiXKbgnNL7qWj8CfrL8+Ud0C6HUrrgt3nBdE5ut9KXC9elGMZ10Aes0jbWIpHE+gtf6X2t4LIGTY+7MKv8xhWh658Xzbpn6hRx/mSt7H3gbdhB8hcGCRIMvnd2WrlaEyGROSXvcmSIFTtYIqR32YJl+GV29uLYiSNJ1SZ/P67UDaQQqfDtYvZlEXnce6Owr939RyQ1DGq20Z+6tePpzvwE4qIJFDvGIV+6KNVho2j0wAcTXbEzan5FLNBUfhKv1rsBs
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(39860400002)(396003)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(82310400011)(36840700001)(40470700004)(46966006)(40480700001)(36860700001)(356005)(7636003)(47076005)(1076003)(26005)(40460700003)(66574015)(336012)(426003)(83380400001)(2616005)(86362001)(36756003)(82740400003)(478600001)(6666004)(6636002)(316002)(54906003)(110136005)(70586007)(70206006)(4326008)(8936002)(8676002)(2906002)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:56.8835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a1d461-438f-4908-5a43-08dc00bdb54e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8101

Implement vdpa vq and device resume if capability detected. Add support
for suspend -> ready state change.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 69 +++++++++++++++++++++++++++----
 1 file changed, 62 insertions(+), 7 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 1e08a8805640..f8f088cced50 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1170,7 +1170,12 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
 	return err;
 }
 
-static bool is_valid_state_change(int oldstate, int newstate)
+static bool is_resumable(struct mlx5_vdpa_net *ndev)
+{
+	return ndev->mvdev.vdev.config->resume;
+}
+
+static bool is_valid_state_change(int oldstate, int newstate, bool resumable)
 {
 	switch (oldstate) {
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_INIT:
@@ -1178,6 +1183,7 @@ static bool is_valid_state_change(int oldstate, int newstate)
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY:
 		return newstate == MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND;
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND:
+		return resumable ? newstate == MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY : false;
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_ERR:
 	default:
 		return false;
@@ -1200,6 +1206,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 {
 	int inlen = MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
 	u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] = {};
+	bool state_change = false;
 	void *obj_context;
 	void *cmd_hdr;
 	void *in;
@@ -1211,9 +1218,6 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	if (!modifiable_virtqueue_fields(mvq))
 		return -EINVAL;
 
-	if (!is_valid_state_change(mvq->fw_state, state))
-		return -EINVAL;
-
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -1226,17 +1230,29 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
 
 	obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_context);
-	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE)
+
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE) {
+		if (!is_valid_state_change(mvq->fw_state, state, is_resumable(ndev))) {
+			err = -EINVAL;
+			goto done;
+		}
+
 		MLX5_SET(virtio_net_q_object, obj_context, state, state);
+		state_change = true;
+	}
 
 	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
-	kfree(in);
-	if (!err)
+	if (err)
+		goto done;
+
+	if (state_change)
 		mvq->fw_state = state;
 
 	mvq->modified_fields = 0;
 
+done:
+	kfree(in);
 	return err;
 }
 
@@ -1430,6 +1446,24 @@ static void suspend_vqs(struct mlx5_vdpa_net *ndev)
 		suspend_vq(ndev, &ndev->vqs[i]);
 }
 
+static void resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
+{
+	if (!mvq->initialized || !is_resumable(ndev))
+		return;
+
+	if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND)
+		return;
+
+	if (modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY))
+		mlx5_vdpa_warn(&ndev->mvdev, "modify to resume failed for vq %u\n", mvq->index);
+}
+
+static void resume_vqs(struct mlx5_vdpa_net *ndev)
+{
+	for (int i = 0; i < ndev->mvdev.max_vqs; i++)
+		resume_vq(ndev, &ndev->vqs[i]);
+}
+
 static void teardown_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 {
 	if (!mvq->initialized)
@@ -3261,6 +3295,23 @@ static int mlx5_vdpa_suspend(struct vdpa_device *vdev)
 	return 0;
 }
 
+static int mlx5_vdpa_resume(struct vdpa_device *vdev)
+{
+	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	struct mlx5_vdpa_net *ndev;
+
+	ndev = to_mlx5_vdpa_ndev(mvdev);
+
+	mlx5_vdpa_info(mvdev, "resuming device\n");
+
+	down_write(&ndev->reslock);
+	mvdev->suspended = false;
+	resume_vqs(ndev);
+	register_link_notifier(ndev);
+	up_write(&ndev->reslock);
+	return 0;
+}
+
 static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 			       unsigned int asid)
 {
@@ -3317,6 +3368,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.get_vq_dma_dev = mlx5_get_vq_dma_dev,
 	.free = mlx5_vdpa_free,
 	.suspend = mlx5_vdpa_suspend,
+	.resume = mlx5_vdpa_resume, /* Op disabled if not supported. */
 };
 
 static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
@@ -3688,6 +3740,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	if (!MLX5_CAP_DEV_VDPA_EMULATION(mdev, desc_group_mkey_supported))
 		mgtdev->vdpa_ops.get_vq_desc_group = NULL;
 
+	if (!MLX5_CAP_DEV_VDPA_EMULATION(mdev, freeze_to_rdy_supported))
+		mgtdev->vdpa_ops.resume = NULL;
+
 	err = vdpa_mgmtdev_register(&mgtdev->mgtdev);
 	if (err)
 		goto reg_err;
-- 
2.43.0


