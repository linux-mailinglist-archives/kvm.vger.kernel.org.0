Return-Path: <kvm+bounces-3096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD20800902
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAE341F20FC4
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71F5210E4;
	Fri,  1 Dec 2023 10:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hEiawE8z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985EA1992;
	Fri,  1 Dec 2023 02:49:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCSjNbBdIWSL63lPSQGllvT9KP4SDnkUVlEpMcHyYtBt1ufKgUox+e2XzKHh85yc8DzSHTuJymQzSwGkhkfLMyRNf3SB+HBpUO+EIhufZSzKXz6wcrR6FUw/a5N4x/zgyh1D8UT5b9GQz71XPDrrjhzMg5VeQOCTOq5I468CkMJWhqvKu5nKYitP108ZYq63HN7kxCYv4qFHiu4KHgJ/miJ0pyW1RTN31otO/BYFK2gR9kHxS7MEifg/yggvI0ndTuL11fDMnM9VNR15cbfLvItvC6UVOiBNc/JsbRik5eS0VZlLSFeAfH9/fKaUMWOM58Hw+BvuaoNd4zzwrmCZkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51vWU5QOyBdAV9Vx5J79GCDO5Bn3tO/JvvgMCz/mhCc=;
 b=JbDbfd/ezK68w0YPJPwG0lbRPeHaEOJhBLIY74J+9cogE9t9rHkrfO24ep6Rt58Vb68G1BAfwNMTl5ABErMHVIHReR+I1U9sM0mjR3Unjwt7sbq096K0e2aHd1uG6j5GrL8PxJovdzmhc6S/mNtPo9ckak1QAwKpgksyu7T0eEx33ZAIhW8eZ16Ja+NelZbA0ldeSo/rmwYkmcpIdnoaNIoWh7nw2orEL+M9pClHSrS9aryvy8+vvM7Reh1iNGLdk4oE4uui6W/TkHkMkpkiBEKoc6orqO6wXE8CDBM2u3DNRojqXLTO5OCGvbaer647Y/tHq+1HJ7LBipXxrdD1cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51vWU5QOyBdAV9Vx5J79GCDO5Bn3tO/JvvgMCz/mhCc=;
 b=hEiawE8zzVq3/HYVYsLJX2IX0d1q0Xsj+5Q5L7nfpKgxv33MeYMNajF0LvbHkbIi/BIMoJ77BqBWR3err2ya1yPyGkYX7yqvo6AsXILAwvhyR1zG6EA3s21otFdd35zgWF0ugvuxgdse/x+V8SV5/me3fA6mjSurZvt7poyCG/1/EM0qemwL4UUjiSv8Q8NFF0j5zY1uBlfgemvzE2iujm2rcEEdRg9uFDXigYl3JXa7LkCDclPcH2vZGTC3xRabN1y3GyhKdTxC59GII9DRULdAANf62XDHfeqw7TF3/WrdKda5PPxlKMk/v48UhBiVkoDZntTFCbND0cGKfTaZvw==
Received: from MN2PR20CA0051.namprd20.prod.outlook.com (2603:10b6:208:235::20)
 by IA1PR12MB6530.namprd12.prod.outlook.com (2603:10b6:208:3a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 10:49:55 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:208:235:cafe::5b) by MN2PR20CA0051.outlook.office365.com
 (2603:10b6:208:235::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Fri, 1 Dec 2023 10:49:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Fri, 1 Dec 2023 10:49:54 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:38 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:38 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 1 Dec 2023 02:49:35 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <galp@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 5/7] vdpa/mlx5: Mark vq addrs for modification in hw vq
Date: Fri, 1 Dec 2023 12:48:55 +0200
Message-ID: <20231201104857.665737-6-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|IA1PR12MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: 59916c1e-55c0-48a5-a3e6-08dbf25b40fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZY0Mty1JnBPkuhhNRBmn4igHXCBvA1Q13wMSRhmZGpx1b1vZ2iYNgESd1tdBcRMX961UWO1C5+QncQQq+SowmI+Jl2z9Nwe3qG+89G1kb05gKarInk44GRaaYLxRRaY7jHXTCxThi28mXp0lZCuukXGBXzsEDVsOPdxvKCSiZHzbt6iEhLlpns92hfsZ09EW7lK8OA1CMptKvRZAyfO+fFTIvIs6foGSzzgJeyoBfeBUc52srzaNUopeO+GOpkuDc8b1fos09qmNFGeSj2ASLB6MD6g0+6n4gdro2IppYeP3BPa7/Rt2CnlVtbxC5973RAnipJHLVbI5sNv8I9ATHicP8Sq8J1HLGLEWY8ChkdKb+3HPAe3RBTQoFBmP6rLLq9IfnVmg7y/uonYRUhJb9gqkDaYStk8d5Fb51/95ow9Hxfl08nQiKUndAx9/0csYmzeQ4ZteahU3HoFV5o+l1BhtH1UCSJ9Ey6YqyXgZ0hO7DIEDHGrgDzNmSZIXr06ioi97TLSpv6G1Ymsf2lJRg7ovUz126scT8PwDDYP/oNeqIqMa2ImZQMyXBajsZI3bTwESHB7SjE+yZYaOU6zevbHK4fe3rYTpuXgnB3LchI1P69KnrN4GQk4xOFWs417rSVIwcZmrZHGqk9VVlot5XlNt6CNabz554+eBlLPN3EYgYAcw1TTg0ll0Nl/X+6+4wZLk8snQCBQq7h85MAkqsPl6a/lUrQPaVvHDFp0eHG/mUZQfa6uKgdj2/NUU6cV9
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(346002)(376002)(396003)(230922051799003)(1800799012)(186009)(64100799003)(82310400011)(451199024)(46966006)(40470700004)(36840700001)(40460700003)(86362001)(26005)(1076003)(6666004)(2616005)(47076005)(36860700001)(426003)(336012)(5660300002)(8936002)(41300700001)(478600001)(8676002)(2906002)(110136005)(4326008)(316002)(70586007)(70206006)(54906003)(36756003)(356005)(7636003)(82740400003)(83380400001)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 10:49:54.7401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59916c1e-55c0-48a5-a3e6-08dbf25b40fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6530

Addresses get set by .set_vq_address. hw vq addresses will be updated on
next modify_virtqueue.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 9 +++++++++
 include/linux/mlx5/mlx5_ifc_vdpa.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 68e534cb57e2..2277daf4814f 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1209,6 +1209,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	bool state_change = false;
 	void *obj_context;
 	void *cmd_hdr;
+	void *vq_ctx;
 	void *in;
 	int err;
 
@@ -1230,6 +1231,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
 
 	obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_context);
+	vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE) {
 		if (!is_valid_state_change(mvq->fw_state, state, is_resumable(ndev))) {
@@ -1241,6 +1243,12 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 		state_change = true;
 	}
 
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS) {
+		MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
+		MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
+		MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
+	}
+
 	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
 	if (err)
@@ -2202,6 +2210,7 @@ static int mlx5_vdpa_set_vq_address(struct vdpa_device *vdev, u16 idx, u64 desc_
 	mvq->desc_addr = desc_area;
 	mvq->device_addr = device_area;
 	mvq->driver_addr = driver_area;
+	mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS;
 	return 0;
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
index b86d51a855f6..9594ac405740 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -145,6 +145,7 @@ enum {
 	MLX5_VIRTQ_MODIFY_MASK_STATE                    = (u64)1 << 0,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARAMS      = (u64)1 << 3,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP_ENABLE = (u64)1 << 4,
+	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS           = (u64)1 << 6,
 	MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          = (u64)1 << 14,
 };
 
-- 
2.42.0


