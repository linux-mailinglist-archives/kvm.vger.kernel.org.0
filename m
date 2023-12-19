Return-Path: <kvm+bounces-4864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EB7818F7D
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:15:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7B581F237B9
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1283B19E;
	Tue, 19 Dec 2023 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FEIkv8lr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC84B5BB;
	Tue, 19 Dec 2023 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0b89nPKlF51vUMBgEAwHtnl9iPM8huZ61z4ZUv/JRut0suuZoa4GPRUW5hfPwVnAJgjNQAZx2yQlLPZdqb8Z189pXHicBv6Fhc8pOqtPU2Yc7HGMp7nIc6x2pj0M6U55jL06u6WHHFx2c/WnLXwSYeCL+UGLcfmtQSuMbIMy9cx2j+ie0KqVu3eSozQVLZJEb4Z6nILflE9Nlcr/AxiJ/TdgPqDxso4GrFmhRGnKL2ZLQnAoNnRWkXLPiG7VxWGKy1UZ9IKKD/ZjNDbBTSYKPFVdRmT7z4lNt0VF5qSrIvHC6Y3KUtvSbEdbTfw8DA2HBmZh/XI8bJ1isHs+NGntQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWsw/BvKJBmDtMxN1GM40Dr5OaaudI4NDI0vMxWYfSI=;
 b=U4ldRSMv0gCE0zKrL+dB9Stf9oon59eZBxgYOayClupvhtE3/2dxPJ3xB82vMaYCZupOPR1vv7Y3/7mUvXlAZ/A1TCy2uxlxJP8CtVA42jhX+cr4dSGcfHipoG0WaJVhegIQBeGzwPFZcp7b78NDYPDCqEo/fWe8kcW5R613FVZs4JnjB+r3dwywI8KRuy3CLiVGuZbI/owC+Df3dgBsAs213AGo8zLdyfHkb5FTO5dC7yf18Bhl5pCUXBeOelW9ISOzFEaHsxKjB407mtUjUETLdez2QLNqPiWImN+gN9IkonX4nBpNjw/Ur4U67SMuV2rfiSZhQU9F6PF57S9ESQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWsw/BvKJBmDtMxN1GM40Dr5OaaudI4NDI0vMxWYfSI=;
 b=FEIkv8lrkRGU86QwIxWcjl0vubBEwT7gOVX7LcU7zuO8OH+E93+Nin8Wn3GxXHKrk9s0Nt9vf/rQ/quGvXVSpHVdICW531E8TC+IYlqx7krHCFj32VSWvguNhIpzgh9JLdxW4auFf4bqkg9oba9qjcmdOGo98KUK59pwH9X9hGHPjLob7Qzs/E661CFPaHt/6likRqB9uxbaZdkAnYt3eIWwVNcvwjod1sfAAn2PsvCKhb7bykBJgua7CaUJV/QhFVI0BhgxQyBGOUROjsE0j0V77Cb5Jhtb0cbYSI2sdr2x/TNmS0Z32cUPhLJB1UrNoCd48ailYnzw1ZZgSSencA==
Received: from MN2PR15CA0044.namprd15.prod.outlook.com (2603:10b6:208:237::13)
 by PH7PR12MB5781.namprd12.prod.outlook.com (2603:10b6:510:1d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Tue, 19 Dec
 2023 18:10:09 +0000
Received: from BL6PEPF0001AB74.namprd02.prod.outlook.com
 (2603:10b6:208:237:cafe::b7) by MN2PR15CA0044.outlook.office365.com
 (2603:10b6:208:237::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 18:10:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB74.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:10:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:55 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:55 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:51 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 13/15] vdpa/mlx5: Use vq suspend/resume during .set_map
Date: Tue, 19 Dec 2023 20:08:56 +0200
Message-ID: <20231219180858.120898-14-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB74:EE_|PH7PR12MB5781:EE_
X-MS-Office365-Filtering-Correlation-Id: f4c411a6-cedc-457b-ae01-08dc00bdbc3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9B5Jwi0A+bWa/ycD2FRPnAI+ZjJDGbYQFPinA/a5ZQiaBico6Lt+5Kl1ZfxHuTL5E2OsPPQtiYPKt6Tl6PTOioYp2wLGNwre+6Xk8YmDfrJMZJioemKTC5Qb6FLVGB/ZzvTQ2GHEOHa8HYnP1IX+elLcF6JoYnbJ5NkUyJrPl/DGz+SMFZAgaYTSHHTq9fbijBa293VM0R1DYBRUk72dFOmcm63RMO2vHMAR29l5RsQJyC1ufNjzbnpCJv4odlUhTrm5ZgW/prn9VofnLBtd2wZy/SIvfopkojv45KI85z2zJhvU2PFyYdudW3FmIS15xYhTS4lIa79VyTsHfKjXyeZfuZ4/OkygEtltwhqfUjkyLmNwaPAOzTaWb7U7zhZE7E+R8IZHZOESFYf68MAsH7m06bHDLCa0s/3UPC2pdwwssWvnBKSrznkkWW7omdfc0+w2dmR4COaiY8pGaJIvS4S02vcgar3kRx1UUZTO4UoHyl9Dt5Djqt1dYnws6qftUCp6vd/QHjArecp+xw5GIdoYbFN178oWySDJkFPd3AtDoShTVH5OYBbUfQwJr/AFbub5c5roccspExfsHhcbArjtQyw8Zk2FmIgl/7Qf6A9o4b4U22nxA1h//Hl2A+U63eIAeoLAYf/2PUgrdd59hweQlokXwFByEeTDSNTEuAmp+vYsx4hDx1VgdguDGiGITLqRNCRgIOtqivai3eC0QlEcWOA1o30QTjRDhrFGzDwOfbiZNLu03Hbh/nR23mR8t7yX6Yaqt+QgQLnem9MBsA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(136003)(396003)(230922051799003)(451199024)(1800799012)(82310400011)(186009)(64100799003)(46966006)(36840700001)(40470700004)(5660300002)(66574015)(426003)(336012)(41300700001)(82740400003)(7636003)(36756003)(1076003)(86362001)(83380400001)(36860700001)(47076005)(356005)(15650500001)(2616005)(26005)(2906002)(40480700001)(478600001)(4326008)(6636002)(316002)(8676002)(8936002)(54906003)(70586007)(70206006)(110136005)(40460700003)(142923001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:10:08.4715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c411a6-cedc-457b-ae01-08dc00bdbc3d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5781

Instead of tearing down and setting up vq resources, use vq
suspend/resume during .set_map to speed things up a bit.

The vq mr is updated with the new mapping while the vqs are suspended.

If the device doesn't support resumable vqs, do the old teardown and
setup dance.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 46 ++++++++++++++++++++++++------
 include/linux/mlx5/mlx5_ifc_vdpa.h |  1 +
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index b760005e2920..fcadbeede3e1 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1206,6 +1206,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 {
 	int inlen = MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
 	u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] = {};
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
 	bool state_change = false;
 	void *obj_context;
 	void *cmd_hdr;
@@ -1255,6 +1256,24 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX)
 		MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
 
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY) {
+		struct mlx5_vdpa_mr *mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]];
+
+		if (mr)
+			MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, mr->mkey);
+		else
+			mvq->modified_fields &= ~MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY;
+	}
+
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY) {
+		struct mlx5_vdpa_mr *mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
+
+		if (mr && MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, desc_group_mkey_supported))
+			MLX5_SET(virtio_q, vq_ctx, desc_group_mkey, mr->mkey);
+		else
+			mvq->modified_fields &= ~MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY;
+	}
+
 	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
 	if (err)
@@ -2791,24 +2810,35 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 				unsigned int asid)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+	bool teardown = !is_resumable(ndev);
 	int err;
 
 	suspend_vqs(ndev);
-	err = save_channels_info(ndev);
-	if (err)
-		return err;
+	if (teardown) {
+		err = save_channels_info(ndev);
+		if (err)
+			return err;
 
-	teardown_driver(ndev);
+		teardown_driver(ndev);
+	}
 
 	mlx5_vdpa_update_mr(mvdev, new_mr, asid);
 
+	for (int i = 0; i < ndev->cur_num_vqs; i++)
+		ndev->vqs[i].modified_fields |= MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY |
+						MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY;
+
 	if (!(mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK) || mvdev->suspended)
 		return 0;
 
-	restore_channels_info(ndev);
-	err = setup_driver(mvdev);
-	if (err)
-		return err;
+	if (teardown) {
+		restore_channels_info(ndev);
+		err = setup_driver(mvdev);
+		if (err)
+			return err;
+	}
+
+	resume_vqs(ndev);
 
 	return 0;
 }
diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
index 32e712106e68..40371c916cf9 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -148,6 +148,7 @@ enum {
 	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS           = (u64)1 << 6,
 	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_AVAIL_IDX       = (u64)1 << 7,
 	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX        = (u64)1 << 8,
+	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY            = (u64)1 << 11,
 	MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          = (u64)1 << 14,
 };
 
-- 
2.43.0


