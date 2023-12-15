Return-Path: <kvm+bounces-4570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94978814A05
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:06:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C896285BBE
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A217A30D0C;
	Fri, 15 Dec 2023 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m8ST4cMn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA7635F03;
	Fri, 15 Dec 2023 14:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VI+Pgvg9qJkKn3MyUdEoP2dv8Rn8GQfnbR1RvUG0DBO8s5wAODQ3r17foqxM6LJSu9sPyJm6wkAukhwRXe8O8pOHZ6KTT7GmSDG9Ts5jp2nRQs98fzRSqacbtPSLXU32k0Cfa0oinMuXAy466Gbh0fnraTG+Chv58gN+070faKqcS+g1yt9KXsjVyrtXm+uEbveteMecxiaTGihz42MPnKZT/GKTbJtpPovsKMqcLXZnEb+V6ssZjXoUt6M4n1YU+TvNRqvNn1GNFVMEQ/xBWqRNvQxuNEolEPcZxc73Wft/WWbA4uo00AMvsgGe6V7PTUgubhLOkHTHxDK0jsZadw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/RPprGigKEvLPsDUA9HGlOzP1Vcg6FVBTRieXdpHO8=;
 b=T2//tTucw+6LDsnlmrvlzWSmizPhiUBGAmLp7A3+F56tZi+qSmQqQKZ8m4foHMMWIFJ29qGczaxtPjhgB+/m2CIuvFkXT5y3t7vDp2u7kPnB1BXuUlpRE92/QkqgEyyrPO5FzP8+ZoUnZJAv2cEidaLnjUN72GVRTqlVAqkCIKW64LyD9rhPuT+gDzsptp1Q5WH8Zswgv9rnpIRoRmEK/N9s+/Ir2sJMS25sqIUl7FJmZFQSEwq2QuKhy8UvFBYgtXk/7eMDuz9er4WQl0KplJD/Kml/t3kSSMu8AyjC5pMhHOhbL6RJMf8iQGyxO5agAnmk9vNvRPU+gPyaQse9Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/RPprGigKEvLPsDUA9HGlOzP1Vcg6FVBTRieXdpHO8=;
 b=m8ST4cMn4x8prFHVPoTk18G5KweOnXDqo4fsRMSaqRcuS9Zi7apLkOyXj2vewerg9pmQRayfaqtVf5eJIMg/Mk1v9IFw31oF3UR5jvBUFgkLZxL1Jr4R/rCWEnKWQdCrm5srHTttEOmo2nhWY8V9GXCARJ35XZFHU0+AC509dAcjB+Ey+WNvJSzGPYF+qj82DiLs5P8wFS7uMrurEcxfhz5D8U3Pv8jenXxntBWxK5dC8gUEnHBY6ycL1ZvLv1PktXcUGyGWI+b3brCiRB9yTTpXlUTtFJQYFU1kntGL6ZGZtVot61LDdiUTgJLI1aSPR7erx8mXuVP1nYUIWrSYAw==
Received: from MW4PR03CA0070.namprd03.prod.outlook.com (2603:10b6:303:b6::15)
 by SN7PR12MB8820.namprd12.prod.outlook.com (2603:10b6:806:341::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Fri, 15 Dec
 2023 14:02:24 +0000
Received: from CO1PEPF000044F6.namprd21.prod.outlook.com
 (2603:10b6:303:b6:cafe::83) by MW4PR03CA0070.outlook.office365.com
 (2603:10b6:303:b6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.32 via Frontend
 Transport; Fri, 15 Dec 2023 14:02:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.7 via Frontend Transport; Fri, 15 Dec 2023 14:02:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:10 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:10 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 15 Dec 2023 06:02:07 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 4/6] vdpa/mlx5: Use vq suspend/resume during .set_map
Date: Fri, 15 Dec 2023 16:01:44 +0200
Message-ID: <20231215140146.95816-5-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F6:EE_|SN7PR12MB8820:EE_
X-MS-Office365-Filtering-Correlation-Id: 39065171-2217-4f62-447f-08dbfd767688
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Mb2mkI4izN1DK8fidftjXkpzL9mcbJUEdUF8jdbWes1J1EN2J2bAG7vYFbZcAqX70nL/9xrP/MAn7hwul/5NE2eWdT+Swl0fBy45mo1+WcFMDrU5AcBPJPH7ZRoCg7sFLlwHhQJuQ+6F15p80suv4v4Rt4EN+fV+wCpol4El6YIYU96sFkh+QRyU+znODBd0wuiJVjbxNScE69rEdQ4YTcMHZ4iWNztBzUoMDEvqw4xRcSRGQf0NE8kqkOmlNWzOvnSxSOiiOuUY3r2XRiWNQmbnU+RdPw5ttOjyZDy/8LF9QMBeG7A2SRTDiH5pQSx5EA8Hgm0/ZN05XqY3YH4kzSOsJAogvApvwff8kieUzbggzvfUovMxlTN4X7SFmT083mfFtGiYCDhHtRMALvUnBCnumbr24Ue064DB7wKe/wV4OiunJ2OBIiTvQqljGdAfYjnMgK58CRij2oVwQzZswmdXDNIrvIwFY9BrALfpeD+klr/C8GPRR57Ouz2w7tcryTQu2Dvc1qubHqhX9+IES0eun5w038X0E//ZDR2ubCl6F/8CwFXrFYp9cdGSMfZhlrgsZ3Hgx7Osj77PS3+iQpTrFzbgHiJySFXkPfKGoJ0v4nXhTiSPCoypyaSNYX3QO20tDBsaCHKT26pVtc0envxN++iNrRlqdY8BtcznSPDnNlLVp//D1tCF1BHu1TRtTHBtY8FKt5fqlsEqRCk3gvdzCStWaovJsDOGdQ/6JYwQbIc38DmFhIwKLfCXtEW1Lic0AOkjeu1++bQJD5ShFw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(82310400011)(451199024)(1800799012)(64100799003)(186009)(36840700001)(46966006)(40470700004)(40460700003)(2616005)(1076003)(426003)(26005)(336012)(6666004)(83380400001)(15650500001)(36860700001)(47076005)(5660300002)(6636002)(4326008)(8676002)(8936002)(54906003)(41300700001)(2906002)(478600001)(316002)(110136005)(70586007)(70206006)(82740400003)(86362001)(36756003)(356005)(7636003)(66574015)(40480700001)(142923001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 14:02:23.8729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39065171-2217-4f62-447f-08dbfd767688
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8820

Instead of tearing down and setting up vq resources, use vq
suspend/resume during .set_map to speed things up a bit.

The vq mr is updated with the new mapping while the vqs are suspended.

If the device doesn't support resumable vqs, do the old teardown and
setup dance.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 48 +++++++++++++++++++++++++-----
 include/linux/mlx5/mlx5_ifc_vdpa.h |  1 +
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index f8f088cced50..d5883c554333 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1206,9 +1206,11 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 {
 	int inlen = MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
 	u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] = {};
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
 	bool state_change = false;
 	void *obj_context;
 	void *cmd_hdr;
+	void *vq_ctx;
 	void *in;
 	int err;
 
@@ -1230,6 +1232,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
 
 	obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_context);
+	vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE) {
 		if (!is_valid_state_change(mvq->fw_state, state, is_resumable(ndev))) {
@@ -1241,6 +1244,24 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 		state_change = true;
 	}
 
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
@@ -2767,24 +2788,35 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
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
index b86d51a855f6..8cbc2592d0f1 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -145,6 +145,7 @@ enum {
 	MLX5_VIRTQ_MODIFY_MASK_STATE                    = (u64)1 << 0,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARAMS      = (u64)1 << 3,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP_ENABLE = (u64)1 << 4,
+	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY            = (u64)1 << 11,
 	MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          = (u64)1 << 14,
 };
 
-- 
2.43.0


