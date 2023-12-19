Return-Path: <kvm+bounces-4862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59889818F72
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD0F31F2C20D
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2BE849F66;
	Tue, 19 Dec 2023 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tH50IN93"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8455547F5F;
	Tue, 19 Dec 2023 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdw+EI1c+lT/xR2jEst/Qj85XAPGqRptvyDbMR5gE9VQshSXs+b4T9tM6Jvf/eQXJnFNcTgjyddGhSB1q3XXVpJFXNIdL2DD3NZ/ZtZwphoAaoK/xg783aEPdlxzHjf+Iehbv+bRz8GCcfNmKX8EA3XMskxaJiNKn5i+e8xbpip7DpTcBoUEZ14CoKXEJZSa6Oc9WOzBoKDlKXqzpD0+C01Dh0LzZPDxEkPEB4X1Z++Y3ArTBmPTKTfGaXXzk0wQYtyiSed1i1RSi/1g7HfqwtA/axcq94HTyf6RWpNePghXqxMsovHiQdO+1S3yYLS42KSrEpLAAwoj/3QLhJstHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bUG4piYXpvfVFnQYkmolDKFtW4yjyp7QBkHdKBaJgEI=;
 b=ALRr/4+ele59JgnJVP7By0sffJHrL7UuwWLAwLIWy6OPMqvJuDM07tgXhKaSglLwptpTl1f7XCGqNIspbjvUZbkAK+sB6A9SaWZOlCo1HUj9i416oVd7urOY/0UNHNglZWmgJiicUroA+5tfQezKknU4Z6HfUofzg7Legl8eOmIh2El04nHcQzMTydH5mMxzpV5RxuEvIXL58BHjhFwYMLLw47aIWXXhQLkRityxJOkR4s1qvRMmzVzhcALkDiv1sgEhgwFQBOpkr8Aau6CRFB0z8T9Ecjyml1VJXGYg9CZBLojkrH5APQz6u/Z7YtYJSK73MqEk/qWjgs+G2PvAqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUG4piYXpvfVFnQYkmolDKFtW4yjyp7QBkHdKBaJgEI=;
 b=tH50IN93fo2ERl9GRNzotnr4Tbx+E35bf2TmuUZMqKyt5jwSz4Gle2nmSIGXBRSXfOJbrA8AoHkwhqwfzt1XgnVTCNA4t/RRUO4XuoRTZKeGLTL2XkksRLFWJ5Gz5C/r6lq9gVKMar2a4cU4hs7fL2CgZcNQ4Mw691arrrejDZoLNFh5MA0g0PoVxgWUX0Dx6p+D81kCCmgRdZ4ZPwErpsbbIcdkXMfrk64+hjQyStgOAXx7LnILcSCS+j2dJunTxXvGjmFYgR8WgOBXdyFAxws59gh5AzvHdMe0rjbdxXwncp+HgFx8Tj2cEtTqqdZ6IvIyw3U/BCAeHTMI9EYaWw==
Received: from BLAPR05CA0038.namprd05.prod.outlook.com (2603:10b6:208:335::19)
 by PH7PR12MB7210.namprd12.prod.outlook.com (2603:10b6:510:205::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 18:10:02 +0000
Received: from BL6PEPF0001AB76.namprd02.prod.outlook.com
 (2603:10b6:208:335:cafe::e) by BLAPR05CA0038.outlook.office365.com
 (2603:10b6:208:335::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 18:10:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB76.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:10:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:47 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:47 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:44 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 11/15] vdpa/mlx5: Mark vq addrs for modification in hw vq
Date: Tue, 19 Dec 2023 20:08:54 +0200
Message-ID: <20231219180858.120898-12-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB76:EE_|PH7PR12MB7210:EE_
X-MS-Office365-Filtering-Correlation-Id: d4d39210-0d25-407a-8f66-08dc00bdb84b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7SVdkiy75Oe/OiyYr0v2HQEdJORfVlrthecj0cwS5aoE60+d07YAa09g7h5ke17i80uOwQDfprT6DAY99ZbAwwcFILhtZDod4FB0DOFj2WGyY4XPNk+23cbo+PtOwsGUMlm4p0loZDoNrfmv8vOdVaobBtSpTak5AGAypq5avZuo2fX3ZOQH+py/+74tyUalOdl9pXSPQVh+78/In7shov9NCR+jca6wvvZpK9Bs/RD+J2O13LzR49j8xkZB5R9Jmel/ns5hRDfslXC8BR6IdYYIe3ip8gErtHISMT7j7yDpaicTmfaTcfILYwzD5/fsXuMjW9jHtAaz7+GbQx6IoNTVM35andkT07xu3Seox1I/yZK1axYacAJXRR3suACJRQfMgTdLN6GjrrPxD21TOoexGKvq+dt4UO2pGF+FJXSy5uOdbwrNDlMhrFbKLhIBbnFmWqpzPyojtuNa3BJz7Eb/PxfBN1OPRjel+psr9BxfRdbRnEYuDE0CV2GvesabrU6vAi3ktkd35mk2gDROLGpgxUC3G4rSh6yVWUzwoElj32sHOm6DDXN3WOWSYiX0e+huJarEJ+FU/Z8DToU5c30UktU8lnfzFlVwKtuxXcgiAthaBqW2pFa5692XIS75Xv3puS+A+IiyymEFjVlZpgG6W6/+3cwLWJtTHPQYfj/Fv5IGOxFaW+tSktuduYstiRqjwm0HSL/2jd974tJp7wustrMepLrpjfE0mURBbFQ5GFANTzZobLFGb3/45lCW
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(82310400011)(36840700001)(46966006)(40470700004)(36860700001)(110136005)(2616005)(70586007)(6636002)(478600001)(54906003)(70206006)(316002)(40480700001)(83380400001)(336012)(26005)(1076003)(426003)(40460700003)(47076005)(8676002)(8936002)(4326008)(6666004)(5660300002)(2906002)(86362001)(356005)(82740400003)(7636003)(36756003)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:10:01.8671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d39210-0d25-407a-8f66-08dc00bdb84b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB76.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7210

Addresses get set by .set_vq_address. hw vq addresses will be updated on
next modify_virtqueue.

Advertise that the device supports changing the vq addresses when
device is in DRIVER_OK state and suspended.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 17 ++++++++++++++++-
 include/linux/mlx5/mlx5_ifc_vdpa.h |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index f8f088cced50..93812683c88c 100644
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
 
@@ -2626,7 +2635,13 @@ static void unregister_link_notifier(struct mlx5_vdpa_net *ndev)
 
 static u64 mlx5_vdpa_get_backend_features(const struct vdpa_device *vdpa)
 {
-	return BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK);
+	u64 features = BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK);
+	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdpa);
+
+	if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, freeze_to_rdy_supported))
+		features |= BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND);
+
+	return features;
 }
 
 static int mlx5_vdpa_set_driver_features(struct vdpa_device *vdev, u64 features)
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
2.43.0


