Return-Path: <kvm+bounces-4568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C990A8149FE
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 401E11F23334
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFBE364BB;
	Fri, 15 Dec 2023 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="It42GM0c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA68135884;
	Fri, 15 Dec 2023 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fknp4VgVobpX36TRR63RGj/cgRDBrMDBM8fA7eqmjHtDIBIGkPQ9w+liG0LYrjM70AKmsYHAh4Q7FnuQpizgWtCwOEu9jXd6e4RHtg5ZJg1OeGfj3i9AaotFUKLlwTdZ6nCkq8X+pA7lXEXBpBCvjqU8Eyf9NBns275YrkZfcxnv3avggRJZy5XC6BCDADOlvtUO2wU4wFCE5AfK+l6qK0DuNBec2dQKgeoCefpDuO5xBXHzxXz3QJsY+RsfttqmvCRM6dlovf6Es0HooULUUMlZnNf38QgPqOG+/l6FpgKAIApg1zb3OUadFZ0EQqXHXb8es8RsHrfmPVVFt9PY9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWpOeWI+R1cb4FK6LjTB81MteAujPvP3wVhkPCOcOb0=;
 b=K5nO+3dIfD74pDv0iPRfPKNsP0bRqGC+wEkocce0lbUJNFT0Q2qzvS4MBjemEu3Iw6lZE9Yir7vzRgvhHQohvg/bmAM2PoQ5hqOw6+ZVqE7tViD21NGra92xI190q/7PNFrRz5RLW6M3VxeFLbppe6lDYz2gHp5lvHEMR4SDeARvJS/XhygZ9qYfZob0HA119vf6lXKVQ335gXfP1UrE+dCr9tz2hNUWX5FDlBGFwV3X8Ift27OQkZ3hQweBxs2J3PKXeWIkk8LJNKZ74846Hc1w9uTb+1qxBzl3GBcoLWvLAFPVUpmY4ZHzHrgOJO0DpGQ58wRZLQkuJULn2lf2Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWpOeWI+R1cb4FK6LjTB81MteAujPvP3wVhkPCOcOb0=;
 b=It42GM0cf80XSmMezeVXbsJIYeFfKTV5PBP50+wUlrES8SdH5KPRfWG6rymgEhsFjWR9+MMMMBHmnk86kSl+B7SsZnCsKqCPDE1WF5m5rVVBgOvePSmJaNnKLfEz9tsDPV/LHHVPO4V+cEeCuXs5eXfbFpRYV/82bhSZwxxqVWH4yPcaaUxuIN1+sBsNvNiivl9hBKRWpY0Fq25/koWgZLNbXpwS7XvuDXYh2sOPieGa/Ql4XOypAKZ+4b+l3eVPFAulCEntL9jJ9yKyO2Mld4eUs8/Ebam8L5RpCQpl9dohq02MvTbv81zzHuCjtKkFkS889BENPxwzR8Z1bIAHCg==
Received: from MW4PR03CA0281.namprd03.prod.outlook.com (2603:10b6:303:b5::16)
 by IA0PR12MB7601.namprd12.prod.outlook.com (2603:10b6:208:43b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Fri, 15 Dec
 2023 14:02:21 +0000
Received: from CO1PEPF000044FC.namprd21.prod.outlook.com
 (2603:10b6:303:b5:cafe::e7) by MW4PR03CA0281.outlook.office365.com
 (2603:10b6:303:b5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31 via Frontend
 Transport; Fri, 15 Dec 2023 14:02:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044FC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.7 via Frontend Transport; Fri, 15 Dec 2023 14:02:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:06 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:06 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 15 Dec 2023 06:02:03 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 3/6] vdpa/mlx5: Introduce per vq and device resume
Date: Fri, 15 Dec 2023 16:01:43 +0200
Message-ID: <20231215140146.95816-4-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FC:EE_|IA0PR12MB7601:EE_
X-MS-Office365-Filtering-Correlation-Id: 170d9b8c-2690-40fc-e621-08dbfd76749c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KvDpnAfGQhiEbdkNYI67O/SNlKc42Lwipc3mQBRLdW5q2kWsPmBmCck2v1K+9E0oJwmLqyDhf8JcHGvbD5f+hS/Pxe1dsWjT6MdEDvs1RhySKTOctHSxVpRN689wrWnOmo/A1V8Zho4F4OJS8AlQgFW9AHst1MWytlPZNLJvuLbIT0zKuq4+i1kmx2t3RyJlGiMmWtAH1sr04JDZcAd76Vdv09Awj3tqBjC0SxOTGdP7x3cbfpBqC4pp6b1mEfkL2i5ZtTVAxTmanShsQ1FKzIWWsDJ5lq7EEADdsSmXOl8qOIPyLlrrsM/aGnOdXBNmt4uUXjHvB7CzS0d/F3LocsaxfM9Z8QQDtbaxN2Tg6UioSIJFzaO+LrDH2uER1GYOBpU3aejf0YzHpo+Du8TNIYkpFsOmJ2ohDZojXr4U4vQT90LX62nWawiIQw1uDkZcTbRNvKCiNfaLBCWkn1YVjw2PGwlFsIAm/CZmGhxolFV04Z/WfXQfu5Y0JRkGveq73ZnJogqgd6qSsqaj8WJh4faXUar/46ecVFV9wyGQO74aDmIYgajz6fl9Y0t3B7WkBYNhp183+qkAnF0DA8idmYuQhoFuZb6RUP/abtPZP9ApZYL/X7cTRHt4pPacvHST8Y/j5W6dg5mLgj6V9CHL5U1BDuaFJa+B9xZSi4cHVppUiwciKqwQ7/JrE3nWFtZzst3LvqFoKrSwFdfrjBWrI6rxebUZS8WzUJV9n4CbAx1RTJltt+zEWwo0Jp7kh5N9
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(39860400002)(346002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(82310400011)(40470700004)(46966006)(36840700001)(47076005)(8676002)(8936002)(4326008)(83380400001)(40460700003)(54906003)(6636002)(316002)(36756003)(356005)(7636003)(41300700001)(82740400003)(2906002)(86362001)(26005)(5660300002)(70206006)(40480700001)(1076003)(2616005)(478600001)(36860700001)(6666004)(336012)(426003)(66574015)(110136005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 14:02:20.6527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 170d9b8c-2690-40fc-e621-08dbfd76749c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7601

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


