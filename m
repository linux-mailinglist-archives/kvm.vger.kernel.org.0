Return-Path: <kvm+bounces-3095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30AE18008FB
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:50:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 525851C20CBA
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F622134E;
	Fri,  1 Dec 2023 10:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OysHD+s5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464E41704;
	Fri,  1 Dec 2023 02:49:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Co24YRV2t+8sYdjvGE9HfiCMdhV8uHCUbLqu/wwXMDZ4Urmdv07Ykv9axzuFnAWgy3OTLYL0hGAVwKd4KcgWY9Pfc3qNzgNvV1bPMQGwssjaePV2Er7irgu3pHxRHL+I4FoCEPyXh01tprQFv9wnwgX2cRbUl0O6+gnM1As2a+yQgWVdjilXGvNTCzSO2//WHQG9LFs2UyPDZcRWyj0KgjB43A87nERuhc/AuEkg0nuhmJH44F4FjdpoIWNU5usc/+sRVZZQ0cybK91IIY6Bgiz1zpk6TDeEmF6LIoBU/w37dyujaC3pN27EG9fkPUXPBUA3r0LSEl9F8mn1TZYJ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ept1Tf2SnzBMD4BLVt8Odf9sFEtXbZW1+WTxNC48gAI=;
 b=lx8wYttaPgSp9wKXya8KGxCVOhxk9gnTu3m29+/DsrKGAymMq1XvgdMaQzgjUxFfaYKDTMbOgjKxeTSMIWso7gDrniPvkN9Y3c8dYWxveRPl2f9qASVu9QJI91P6XFB7GzeRk6+TM2VoQOFN3cI5yOMBLxgxgedfxurAiSzMOASLQ5yulP9Xlear7bB4dVOjFJsJwbdcCJSQMqU0I1jAntx7eEs92hjtxHNqVS9mFJ+/nrG6qA22hcO21ngDmO2tosmtrlzMuns86J3KJoE19lFG55i5LFsaZdiEp1/EZ1KaGIqbC9LH2KEajA5sZhBgravdafskedJ9R5FCVbz6oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ept1Tf2SnzBMD4BLVt8Odf9sFEtXbZW1+WTxNC48gAI=;
 b=OysHD+s5UJknLkE/Oi7VzC9Mgp2BW56FtV9XSpe35wkyxKYe7CYHJR4iJwgZ4CfW07++mPugZae8nl7mbWLtUU1blWTneX/d5LWqjBIMk6FQ9sQkKrecYTXTvI9fQ6zCUos74QfpTpU4QLu0Trkx1uukFErZ6X2PDdIExXycw3bxRNQ6uf5fLIKp+jiYPrWQ+kM4PG9LYVVWkQ/DvrzTiroNOjz4T6i+yVmQ6gE4dwBn+PAmDmiqic1ezczRxh7zkLXBxgTSlzEQBJX3n3KE7SQNrZUPfP4aWP/OseGABvdcCtBioHOysS9qfz/YXjaIR2wld9F2/t/UnnzvUHijOA==
Received: from MN2PR20CA0060.namprd20.prod.outlook.com (2603:10b6:208:235::29)
 by IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 10:49:52 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::42) by MN2PR20CA0060.outlook.office365.com
 (2603:10b6:208:235::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Fri, 1 Dec 2023 10:49:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Fri, 1 Dec 2023 10:49:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:34 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:34 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 1 Dec 2023 02:49:31 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <galp@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 4/7] vdpa/mlx5: Introduce per vq and device resume
Date: Fri, 1 Dec 2023 12:48:54 +0200
Message-ID: <20231201104857.665737-5-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|IA1PR12MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d62fbca-2648-4b26-2e1f-08dbf25b3f92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5v0hwFR4APWRLGbjDBeNs3gzx7ZIUg6F21gHalWJRNgFd5xzG3a5M21Tv9SXtLI+zI93liIwqAng1DX82Sz1Y/iksr5Xpg2ic7fqdzl5S36GnyIfvgyiuCQnR1XeEDOV2SUi6QY+zk8/j1U1PDBVO7fL4/9WZWum+a8HHerVqZEqXE1plBumtFUfRppVJ/0qQgReFMOULssEQzTc00vM/hisyf/9o68r5TS58mu4D4Q9bFWEgcX/OF4D0O/Q5/cJcnsNsCLZavp0dROlhLLA2uaqHi5t48lTnwfCnY3bK4Ivc6FS3xzFQCf9B9Hz+0RaYuErfhPRmkwDl5rw/DL+1Mh3cnNNTYM3wnAptXLDV9X5tFXjRkFWrE5D9ypjcx5IjizSjiqSNc6AfDq6i5oR3Vuqn1P+uqXbK/anDtqll8bnHDIq2XQM/+7vdFjQ8MZlA9kcIjxfEynonZTCj6xDsU+j1MN9i2wJ9dD+/aPMZnVJiGl5dotuJs+ZoyA6z5HiOGNkhSzRMKCuVthu//AQiFbmm7zgOpay0HfetG9qwWVn92tG130eWrkOr+5BurfPO4KLu1+7RzJEqKhPQwnKs4/8BpbnfmQQQHYZ/4Ypt+2f5O/i8w1H9v9BC5OAPYLIdH2oND7v+uTarnxvbnq8V4DDIRtodSutP6fL3SQx+xcDb5dMo1WSnn1o5Lwyv5qIpapb5wfh3OEb2CcQ0KZDhQ7/QqrMQ5jFQG424JQb7Rj7pmzJHPwg5e2F3/1dsB/D
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(186009)(64100799003)(82310400011)(451199024)(1800799012)(40470700004)(36840700001)(46966006)(40480700001)(86362001)(40460700003)(70586007)(70206006)(7636003)(356005)(82740400003)(36756003)(83380400001)(54906003)(47076005)(426003)(36860700001)(1076003)(26005)(2616005)(6666004)(110136005)(2906002)(316002)(4326008)(8676002)(5660300002)(336012)(8936002)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 10:49:52.3672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d62fbca-2648-4b26-2e1f-08dbf25b3f92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9031

Implement vdpa vq and device resume if capability detected. Add support
for suspend -> ready state change.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 67 +++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 7 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index d06285e46fe2..68e534cb57e2 100644
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
+		mlx5_vdpa_warn(&ndev->mvdev, "modify to resume failed\n");
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
@@ -3256,6 +3290,21 @@ static int mlx5_vdpa_suspend(struct vdpa_device *vdev)
 	return 0;
 }
 
+static int mlx5_vdpa_resume(struct vdpa_device *vdev)
+{
+	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
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
@@ -3312,6 +3361,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.get_vq_dma_dev = mlx5_get_vq_dma_dev,
 	.free = mlx5_vdpa_free,
 	.suspend = mlx5_vdpa_suspend,
+	.resume = mlx5_vdpa_resume, /* Op disabled if not supported. */
 };
 
 static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
@@ -3683,6 +3733,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	if (!MLX5_CAP_DEV_VDPA_EMULATION(mdev, desc_group_mkey_supported))
 		mgtdev->vdpa_ops.get_vq_desc_group = NULL;
 
+	if (!MLX5_CAP_DEV_VDPA_EMULATION(mdev, freeze_to_rdy_supported))
+		mgtdev->vdpa_ops.resume = NULL;
+
 	err = vdpa_mgmtdev_register(&mgtdev->mgtdev);
 	if (err)
 		goto reg_err;
-- 
2.42.0


