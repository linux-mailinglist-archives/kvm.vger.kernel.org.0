Return-Path: <kvm+bounces-5235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEABD81E157
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:14:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 364DF1F223E0
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D17D354BFC;
	Mon, 25 Dec 2023 15:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mDnl9TGk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8022A54674;
	Mon, 25 Dec 2023 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afUFbxl4yc7vX1642FGFulDneTptnbbtgVy21fJXeoJdGjgIbPAsY9A2nyQSdSx9+7h8tRBGRIpZy1k5BthKYsdrU5G4E9gyoKJwkfp1o1z+VHALkjSyj6q72Csgvbsb8CJJbK6cQNZlHpp7T7tkL3a6YMQetOAGILl1wskZMrhq9j6dI/x4pRQcjoeBLru3n0jprMwDARE4iBERLjmwTXua3JZx1E8VoUXBwVeQoD/1QsLVGARmVOBxB+/2mMyorDVV7HkmIxvx5o/9tTOuiSO0bgopu6eM0hSh4mKAgr/5fMhB2ptG71MJhb3qsvLTWOp8UqLqtDXfljGslwZHNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BvhinUE0/Ie9T6Y/T+V0UOcC0Gw8RvTH1dG+lWcaIA=;
 b=nqkoldsB8Aw+MQsriK8S0QnGER+7cIIpp0huosXYzu8S3VXcni5EJpNckCyFJoObJbz8wfWTLpMosNS+U9Kz0dk+pDtwEA6UPiA1DLlazKOsDzZ7c3BNoOP95KGwm0kkKG4564is2V4/z3vnfUv1mbOt0kz/bU2H//kkKkdLpPrIDTT1sSir1LuHHLrWV1vJYdJ+lQIKYZckHSaDwitISX1pVyGBCCDJAlubnTXWo8T4bVhu/eqb4GuHCnbX/OQ1hibpWk3BTQmrUZuyuB3o6V81xWcN3vnLJLx6pckcyEaqM8VmTBzY5TkJosGe0cTfCkRZQSpfDWfQmZzqmMj/BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BvhinUE0/Ie9T6Y/T+V0UOcC0Gw8RvTH1dG+lWcaIA=;
 b=mDnl9TGkC62/HT9FKqhjIByyemNaAhlNnRw47CQGyTVub8fBc1phBkopaQgqlqUgoe57SAlebK5B8xbQeLXwOCgvlwL/Hd+Vt7O04TyKY3LlOvj9Hx4CRQBsySAZ+OGqMVL/t4pTPdppo/aPAndRe8Zy2OgfTtd1y5y8l2qum0u5zQDvG22vV6hkC61+IYHaiFGuWg9S1BSG+IUUvJTVePtIX1ik/Kyf/A2ZemSHFNHFM50OJh4zvfV1dPuySSomLktZpXA4U9sp5poNmGw8Xk71ZRuIdHJixmW0+X30XAllosjNChbEEv9Ke9Nxtll+gS8J5Q4O1VPurIwi8D6NMA==
Received: from SJ0PR03CA0144.namprd03.prod.outlook.com (2603:10b6:a03:33c::29)
 by MW3PR12MB4522.namprd12.prod.outlook.com (2603:10b6:303:5f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 15:12:35 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::2b) by SJ0PR03CA0144.outlook.office365.com
 (2603:10b6:a03:33c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Mon, 25 Dec 2023 15:12:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 15:12:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 07:12:24 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 25 Dec 2023 07:12:24 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Mon, 25 Dec 2023 07:12:21 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v5 5/8] vdpa/mlx5: Mark vq state for modification in hw vq
Date: Mon, 25 Dec 2023 17:12:00 +0200
Message-ID: <20231225151203.152687-6-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231225151203.152687-1-dtatulea@nvidia.com>
References: <20231225151203.152687-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|MW3PR12MB4522:EE_
X-MS-Office365-Filtering-Correlation-Id: e03f2a29-80fe-436a-f684-08dc055bed03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8ysocV2AaPQ7EGQH20sRoaMIt0SMaXwb5T/PwTRQ/U2Y5Prt/GlpNNulp5dOsPt6491gdOyeafuZeXWmrWLluxpg7gj8FFbP3m0iXoroOnE1ThmqemqBJ9PQp2qcAmMjOZE2XttnwkXDUQfxU7Bb6hcRUa6R21JNxMeH7/jklsgUkyeu29BTBTbe5gK4WjCD//fkOLQeCLRY3jVBs/ZFvs35Uld6aUCp8a6DamL4G6m+NJloAIFgzgm0RWCgQvhwQIKzhYWnpuBIoX11x1aWmxh4AxCzimaJTlUTVopGq7N5BAMl2/5KW0GVGKy84aQtFjJ2xXMkswiXtCCi4JkSIQ6mjWVByh4MMXX4c+E5whTCt0Owhi0EWODVBNtQsmW2AVKFWKSqN1GsGtLrfcegg97tcGO2RSJCyyWTe0W4IYAdv4L7dJItabSPjZ/rKxiqfDXs6muLecd5/iYTiBLFajYETZCYM3YkYGnRZgUCLkq7Q/Z2ZrBzEYlaE1siCUiaxjypPq+X2dDyP2z2oeQh5GqAfnoIZAqw0bYyV1r7EroB33I2romiCKLuHmRrdDke2/q15HL8qF3pVdQQjwOwlhxYEE0lxcsTb6CbSkAJDdQZpZShrGNxwlYGiAzUI0TvKE77z0BH2TnLuOwr+oL9vRxiak/d3y+qfYzABYRE6bQrhF7TARhJ9AyV5c+587GnWDh+VsKzptAQbSt9BGVi1m8+nxEa5v0v9vsawY3ioN6rdgM9NMzafVJGvD+k9Nms
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(39860400002)(136003)(230922051799003)(1800799012)(451199024)(82310400011)(186009)(64100799003)(36840700001)(46966006)(40470700004)(478600001)(110136005)(7636003)(70586007)(4326008)(6666004)(47076005)(82740400003)(1076003)(2616005)(26005)(86362001)(8936002)(40480700001)(8676002)(316002)(54906003)(70206006)(6636002)(426003)(336012)(83380400001)(40460700003)(41300700001)(2906002)(36756003)(5660300002)(356005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 15:12:35.6078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e03f2a29-80fe-436a-f684-08dc055bed03
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4522

.set_vq_state will set the indices and mark the fields to be modified in
the hw vq.

Advertise that the device supports changing the vq state when the device
is in DRIVER_OK state and suspended.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 8 ++++++++
 include/linux/mlx5/mlx5_ifc_vdpa.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 80e066de0866..d6c8506cec8f 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1249,6 +1249,12 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 		MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
 	}
 
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_AVAIL_IDX)
+		MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail_idx);
+
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX)
+		MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
+
 	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
 	if (err)
@@ -2328,6 +2334,8 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
 
 	mvq->used_idx = state->split.avail_index;
 	mvq->avail_idx = state->split.avail_index;
+	mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_AVAIL_IDX |
+				MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX;
 	return 0;
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
index 9594ac405740..32e712106e68 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -146,6 +146,8 @@ enum {
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARAMS      = (u64)1 << 3,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP_ENABLE = (u64)1 << 4,
 	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS           = (u64)1 << 6,
+	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_AVAIL_IDX       = (u64)1 << 7,
+	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX        = (u64)1 << 8,
 	MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          = (u64)1 << 14,
 };
 
-- 
2.43.0


