Return-Path: <kvm+bounces-4863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A4537818F76
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:15:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B52D1F2C53F
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E1038DF5;
	Tue, 19 Dec 2023 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NH/fne/4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175584B144;
	Tue, 19 Dec 2023 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCCK32o300sc3ZoJRATCagHIXzCXwWmzZjl5ctvA1Vc5HcnYEoU6LlJkPuD2EAc5q5EH5D1o5FGs5LlUdZ09RcK9IbsBydD9xwfxggVcx6Gr+wVrR20O8DpJhRro5NpuMYoJt+UloDLbt0x02wbJDsrTjcQ4bSr4Kom65U2Sa4BBbK5RuGaI8jc9FuUthY886wL1OSgwl69pX1Jonej+fyeWJK5CFAkLHROiJ6443HzYSFH4LOCUVZmFWSyFB7ZYhz9dE5RdXTkVzig6+O9ELMAYrzsgWpCCFQR3R39TBgo/xKKeOlkRUsF0SSyUdcXwQm6ihqcFbZFCIW2m3MUpSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIOWw8hu9FilT3R8SChRoV6sn+1Gou8Ky7fnsBKdc4g=;
 b=Efj4nPJnZdx+E+xx28ZFR43AHSo2LY5ZFhJmNnyxbtfHtjubMznuQ/CpjNlTq75JTxQN5aA8KT5syBmhlo2PA4FAmT36EzlXswFmfE32oVSewLQVpySsGqfg0WsfhfWM7VOb9wOAQ4sFydd0HU+44XQ8nkA4Mt0nkmya+ABKcx5jjZQ6f9w75Pfg9YN0o2DyBXJ/N4bFEsRj0DFjjiZQt34aKKSnsU81xYa6JjFpPJ/mbepu4NLwj+Rs5MzLSzYr9ezTz4kLi+MIXc5O8Jb1rkaEf3AszFInx8Sz/lRTxlsor2vl+LkrnChDRMIc/jDOduDHAqQbEXkLJsZfaif6lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIOWw8hu9FilT3R8SChRoV6sn+1Gou8Ky7fnsBKdc4g=;
 b=NH/fne/4TmugSJAYxqgyUAIwaWePYxb9IKJLRGhyFJIgnNWWTh/PRXJ3fYQXFg9oLC0Kx8XBqZzcxwrg3IiGAzu9Qre4unI3L0YJaCUPyd3ZIeLqBcb2wwjyJkeHI5sxQXtjYpFfl4xfHtfVIs/xsnB391uMI8s4KTZZuc0R5i02LSteOb42F12PLiTLsNhItU96eoS8oG0Gt2P0dCmN81EkWxZRpTG/CLdG48S2n9FTIyQ1/Jdss6RUdmgOALJq30gS7iNaBvBRSnmycFPh4NRFASVTg8x+F9pg/NXluhmKTGgN7NmYCuRXLqkfhUwHRiiBWSRL52sysK7ZAdXaDg==
Received: from MN2PR03CA0015.namprd03.prod.outlook.com (2603:10b6:208:23a::20)
 by DM6PR12MB4330.namprd12.prod.outlook.com (2603:10b6:5:21d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 18:10:06 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::95) by MN2PR03CA0015.outlook.office365.com
 (2603:10b6:208:23a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 18:10:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:10:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:51 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:51 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:48 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 12/15] vdpa/mlx5: Mark vq state for modification in hw vq
Date: Tue, 19 Dec 2023 20:08:55 +0200
Message-ID: <20231219180858.120898-13-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231219180858.120898-1-dtatulea@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|DM6PR12MB4330:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d155b3b-ea96-4e67-9c25-08dc00bdbaa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PAlMPqAUnOKZWNvSUaABNZO48i6Qh0aq5hM+vQrw7pvq53ZSaY9WZRPWyk2PDPu6PLXrBYswHR+HkSKZF4OzFwvWwRTKVvN6fpy5NlqyhkWd4qD2KOzrQOiSLvraodCkfydBuSiuQpTmdF/gHctXW2jLwDbKi9dlg5aqGBzK/RCTGk3ymBT4emyVyqokreG6eUvxwW/u0NngoK/dvGvJNmilegaHSnZlBMPXeNOteGEwjCIbDjOxw+CksO4CePImEXM8JVHEPa1+ix+4zeee4q19F6NOYUJAephLHstlFjeY2D4kJou09QxVv6C2w6zhcjhPZOt5S9Rjfb5z7cDRZnjQPYoG5iSPUAzuxZdENtGbqYexvfqX4GUx6dqQK2hbmgzhpsQTEfCR4eRf75AmmNRvIHBNyidCncGqyr1YeHs1ExcCedHPIiQzh98RiObN3kFRt7zddgSLxsHKfjgFmVOhN5g0bH3wtKb0RHzMjrR7MIVjUwa7EZBmRVepc6YK/jyG200ldyuWvpTZg2hEG2U8xGYyBWlmc8teN2L5NjxLSshhjUvl7QJfum1/SdGg3hlDXHIrUlxR+kU6/y8005Uzdz7KpHOjaK0FYjkI7bZOXdwgUT+Oot+84nXfu92vRS9/IaDeHLJ+9zm/qYUxpLsI/51ekjCTX9Eya2W6+OJLQZFVllPQRUN1fqFiY3WG/aV8o5q6ORqo/BTSUffwIDy2DmeiNgQ15NQSKVqoVbjjy+fU+vUzpn/yxeOKeQQA
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(396003)(376002)(230922051799003)(1800799012)(186009)(82310400011)(451199024)(64100799003)(46966006)(40470700004)(36840700001)(7636003)(40460700003)(356005)(40480700001)(82740400003)(86362001)(6636002)(54906003)(36860700001)(70206006)(110136005)(70586007)(316002)(83380400001)(2906002)(336012)(2616005)(426003)(8676002)(8936002)(1076003)(4326008)(478600001)(6666004)(26005)(5660300002)(36756003)(41300700001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:10:05.8061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d155b3b-ea96-4e67-9c25-08dc00bdbaa4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4330

.set_vq_state will set the indices and mark the fields to be modified in
the hw vq.

Advertise that the device supports changing the vq state when the device
is in DRIVER_OK state and suspended.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 11 ++++++++++-
 include/linux/mlx5/mlx5_ifc_vdpa.h |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 93812683c88c..b760005e2920 100644
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
 
@@ -2639,7 +2647,8 @@ static u64 mlx5_vdpa_get_backend_features(const struct vdpa_device *vdpa)
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdpa);
 
 	if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, freeze_to_rdy_supported))
-		features |= BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND);
+		features |= BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND) |
+			    BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND);
 
 	return features;
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


