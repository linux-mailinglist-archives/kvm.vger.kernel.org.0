Return-Path: <kvm+bounces-3510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 829FC805113
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 379E12818FE
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC9A5ABBF;
	Tue,  5 Dec 2023 10:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KcG8UknJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80A2199;
	Tue,  5 Dec 2023 02:47:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9cue5zzItLrXSH7xylix6m+bsBbVAoIJ8qV3t7etr2ict4qpYnZsfZwQ8Suc9vSfGpdySWVRc8YuTSXttMngI0/zzeceN4BuuNiFniTdF1F0LbbCXB/E2l86jHsKE6YK+SSHZcBggSMc+YN1ddl4EVNoBsCaOVoLNPBLcB4uJM8RIqpvG8HyPAXvJWTN3zVPnOt+BLPAiDQlrE6+WNNiQaC82BqOmRs/7MN75DqADJb60uLJvJJHaaci1hftmRTcYYrmdP/kXu7EmXP3ImC328ukXMZ4bZ3DAmCUgAXw7BxEJHdDamz0x5tCwFEOtkv6HBYXFeNZD1hpwyNblAbnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kv7GtFG/dFKlyxKDXcQOoXI8ps+BEnx9aFSvOOlvkuo=;
 b=Eu+p6zcLzcqAqzJQgLWSRt6+cTXm1Z++YIO45zcXLpl+QbpvzBJcmhy155qlfVrq1R2HCYeVAc1brM3B0ZYRom5jQ0vQzQRSsjpt0jYpwF4ZKtPTpRrq4VgWJbrUq/MDqFVRmPYJVNVOKM8kOAGUOPiY/vOdIPORJ8HE331/Wl46rgsraEx1yv4EXaH33sQXpuPpGzz5LzL/r1NPoVV4sacY0LrVUAww0KkY0y1cSgb8jKG9UCMTZ69Rk7ddOTyfNaumRHVXFYp8ENoPqy4zKIsy6Ewm3hjVk8RJuWIxwothTbiLgK5iXdNGDbA/23pN3RqRbnQoxNXmshOKA4QLEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kv7GtFG/dFKlyxKDXcQOoXI8ps+BEnx9aFSvOOlvkuo=;
 b=KcG8UknJQtaOOELADtJzXNnHmOq+DIL+Bgb39byiUxUzDlQ07c88u/WZnlwPTHUlD/WMezpafj3Ud0jnyoHuyVip2g+MDkGnsikW5WtLNLfyAgMdnDVwWeArJK2TE/O8Mo+UZjHnk7cdLHqXa+v0wQCU3Hq9XM5KgpSWHFNuNe2X4WJyyXOZbWcNrrG8cUwY58lLGDP3+FeejaChyCiVPtft/yf328oF5RXoARZmb0nRR8oCZNqYcH/J88xE1/GXLl+e1jOkYaEEtwXpq5/DKXWp0SCjR46H7/XsDz/Nh7yxX/1YozifVlcE5A2PLwdCf/iP0WjSVfUMD1gD0iwimg==
Received: from PR0P264CA0156.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1b::24)
 by LV3PR12MB9439.namprd12.prod.outlook.com (2603:10b6:408:20e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 10:46:57 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10a6:100:1b:cafe::41) by PR0P264CA0156.outlook.office365.com
 (2603:10a6:100:1b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 10:46:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 10:46:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:38 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:38 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 5 Dec 2023 02:46:35 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v2 5/8] vdpa/mlx5: Mark vq state for modification in hw vq
Date: Tue, 5 Dec 2023 12:46:06 +0200
Message-ID: <20231205104609.876194-6-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231205104609.876194-1-dtatulea@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|LV3PR12MB9439:EE_
X-MS-Office365-Filtering-Correlation-Id: a87d189b-ced2-480c-126a-08dbf57f8021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4rQ3UbeYE2+FYjqlHb0uA9ixd1AHNJ6JWT3PkSn0YFOEzQcHJbS+FoEa01P16BF6Ptx2tXQomyU3vu1LXududk09KjrdSDNKBsXhfIVsGWCiFQ0q/k8TgmOzCbNZIrw5UDMEkHgfoGObG0ycNPvzqGsdamT8725dfAFnl/w65l/zfXuB6Sn2B935804AYfFwxzsKy81jG/0BCmqLxCJ4BiwrNS11qjkxWRmgBcsXvT2d7tKA0/ZX94JALKxA6Mhh8VJfVs78QxKsl7FhJ/C5mzCYUN2YbHpxm5bT/s6VPa8WHkY9CpimneUqWCQggF5oFkkP+wTelwKBYL+euaMmF7hLfMsJSEucHlwKO92vTUONmU5tcVXvO2hp37nldeaXE9lW0ykL+bsB7L/R62SeQlLQn1MPWpFsoNhqqWK+cL4vARbbhIFYkADJphIrHLb9NTEXwscl0xrFYZrE8HCorYowgRop5gjarptz6eg7odjUcZjvPC6hGKd2CxAWw95xK/OZA+TjW3hx2UvcR6EiDhtCx1i+xeyLeHDaxIz0EJzaBcPCuKUGrkq3KLJqskzPkTupb38uoUl+xs3SQiPIdXhg7PTYLnbXVLhGlD+aSynRc+t1h+3xJedvFm8sgWrDeWrAieZ8rU8J+K7LSUIOIKbQwVwjLJNsgfCrXYz5JhNEyKNSmOCA8oBOdvhZCYx8WYBQWGuH3//ILJus9RDbJ2VnmhomDCNJyicNaU6kzYu/ToyShCXAX894Q13tsJ8F
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(39860400002)(346002)(230922051799003)(64100799003)(82310400011)(1800799012)(451199024)(186009)(36840700001)(40470700004)(46966006)(6666004)(36756003)(478600001)(1076003)(26005)(2616005)(70586007)(6636002)(70206006)(110136005)(336012)(54906003)(40480700001)(316002)(426003)(4326008)(8676002)(8936002)(47076005)(36860700001)(5660300002)(2906002)(7636003)(356005)(82740400003)(41300700001)(86362001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 10:46:56.0953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a87d189b-ced2-480c-126a-08dbf57f8021
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9439

.set_vq_state will set the indices and mark the fields to be modified in
the hw vq.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
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
2.42.0


