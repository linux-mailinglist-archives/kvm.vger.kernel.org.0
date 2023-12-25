Return-Path: <kvm+bounces-5232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 156B081E14E
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FE12B21750
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35C253E2B;
	Mon, 25 Dec 2023 15:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QRajsdIV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4278553E1A;
	Mon, 25 Dec 2023 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jyokgj2CyW7dF6DzKjX67ry2klaDGfTwPe0iWw8HoIEHlVXcDfAKoIBLL/AskZUt40ctnNe9S28m6cE67rBwIJY1Sw6M0EX1LMrFkLYk8Xogqj1GdGPppH2QwxOUMpsZG+Xq56T8wTP51mdsrEk8DGIKq7aFzKd94oLeyr08d+r0kkghpQS64kwDD9kq1oWK4GMSfpuNEtw0arzubTlXjODzjDU41IlvXidM6FnHU44DUSjfF1E2cSHC45d9hAZuVwVyAYaGxcx5B7U3xelbByBMTisqdqIAP3g309Mau3Q9HBrj8uAo6HdKKCJymZrDVboS2qStNufGk52hpAv9iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVDoJmSQupK17Y+Qik8kUfWqQ0tIv1ellLdoc84RNLg=;
 b=A3Rv6iLbOLryVk39YvoSIHLpVsnrNXqNUjHiMHP2mY1b7qxoacpb2D0Y+rExzbsNBzOwAk7JDfmGyNhju6pQ2fjw6yLwMwR37M0UACncfBzeO0EuOBUcnryBOJaMShwCePFripKUMiB0c7DLc07i4a4ZGk8GEdBxpH7fLhXaFOlkF37QeSCj1r6muhKhC91m7rIhsnw1V5IzC5ESqaIg5XyCxViijmPl3j2KV++8kyWsXV0hVuRMqYgGG2zCqf6jBWRLGWcFlXkB/Y+/PJtG/Nva8xWBv/7UxsShhjOTO1PWfAKPGsEP5XaSZeq4lCIh3ObthpXUSo3KWbOaR46jRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVDoJmSQupK17Y+Qik8kUfWqQ0tIv1ellLdoc84RNLg=;
 b=QRajsdIVKs99ch8OnBS/6FyycWwe6soX265a0zuX5j8SZLaJhY8qrOYV3TMUQsI5XtOFrJd7hcCrAPu4j9QN2A7SK5wPoAYiBcoZIRldQD4hjWtXPdgIHJ3mjYvVSd2BDynaMmlw66EuAfgSM39scGcdjdZF9dkGaDHtNrebnNpTQQeyhTenNmSWjAN3jssv8zk4V3ykVZ2d1bO7beYWWAPIyfSxhWWlnybhEoDwk7WUg0f0NArw+LhqpAejqryzMnPuXYksHGuBgA8BpWnXfU00UHSlVNJRmLPRHDBYVl/8QUA1fTuUCL23/0B16TgTBll2k6EFczkGs//BvBMsAw==
Received: from SJ0PR03CA0234.namprd03.prod.outlook.com (2603:10b6:a03:39f::29)
 by SA3PR12MB7857.namprd12.prod.outlook.com (2603:10b6:806:31e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 15:12:27 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::a8) by SJ0PR03CA0234.outlook.office365.com
 (2603:10b6:a03:39f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Mon, 25 Dec 2023 15:12:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 15:12:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 07:12:18 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 25 Dec 2023 07:12:17 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Mon, 25 Dec 2023 07:12:14 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v5 3/8] vdpa/mlx5: Introduce per vq and device resume
Date: Mon, 25 Dec 2023 17:11:58 +0200
Message-ID: <20231225151203.152687-4-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|SA3PR12MB7857:EE_
X-MS-Office365-Filtering-Correlation-Id: ee029173-fdda-4bc8-2f9b-08dc055be7ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n7ZLSeKETmPMhkyGNSVUAv2d4eBg+e3l35KB+xb0fqg2dB9cd2dvmKRR9gCKEE/W10+MA0KMZUeEgi8++kF902OEaT8tIrwg24EnFhDRvU84UUBbbhzmb43BvurjduzIDtcgv7A1osswqxsZhoumsDyy/KgPaGYtvDFLfVQIGaQYNuwwUm6DhW2V2ZuUyJBP5Uxnvv0JVzXcTTmdxabT0HkjnYUf9h6tx5LhWDm/99KtShwT3O2K7xk4M5vJg2fqwDMew8SRWvA3YZaw5WPOR/Yb+xlPSqMuqM1JYdO0J8WGiZoYVGw2x9YoYZ/bn2lYnRowBBdjcW9HzskkP7o6ZCydX6f2xA70KbAKwCHn+W3UjDMkWfXwMVVAwFDVFIAT/Ovs6RPQx46E80UqrW6M5WdbJbTsFoOqFE+kflJuy0uhO6hWceAUGYoGHP61LnojmWRycUVz8JwtYoV5RA501NKJjjS2QKfIsydKdgEnCkme29Bk3OkTTc9GNJ5z0UpICN3VAKFWCgQ1c8PQI56iag1HJa4YiopRiX1ItEUUMdgAzgiW7W9kjevof4l1RA8/0spP5fPauELkPt1bYc/UhPS2Re7IWayO8jiEmDDMdNcRbZ8Bc1NPaUTzmZefnWUQ7YDczqtgbM8BQbRhLU5hTh/1nq/pJmKVoEasznJKyq4YC65pSmWqdbxPA7XUMMdc8Y6+AcP1e1rcTjQ4Cjrrpq4aqOe0TquOV5GyPSfUn7Yihm6dnIftFlQ+PWF9IaTE
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(230922051799003)(64100799003)(1800799012)(82310400011)(451199024)(186009)(36840700001)(46966006)(40470700004)(8676002)(8936002)(5660300002)(2906002)(4326008)(316002)(478600001)(6666004)(70206006)(70586007)(54906003)(110136005)(6636002)(41300700001)(36860700001)(47076005)(356005)(7636003)(40480700001)(82740400003)(40460700003)(26005)(66574015)(2616005)(426003)(336012)(1076003)(36756003)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 15:12:27.0855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee029173-fdda-4bc8-2f9b-08dc055be7ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7857

Implement vdpa vq and device resume if capability detected. Add support
for suspend -> ready state change.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
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


