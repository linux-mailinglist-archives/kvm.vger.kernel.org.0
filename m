Return-Path: <kvm+bounces-3098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04C6E80090C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 273781C21078
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650D921A18;
	Fri,  1 Dec 2023 10:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qBGTlKRS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B961170F;
	Fri,  1 Dec 2023 02:50:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1Uy7AtnTX6+PsciGjfrnHsJYljcQ5zMsampAL/IEZRbsLh0i1WlmZj1TxaG7awjDrTF91Fx8QiaIA6XLKHOaCj4a5bkx7sLnIuoF5qY5rNL38ghbZgNTO+yOqaM/YvXMicOhLXMWBsctdccHJtPQt2IwiQHGSGh7LIciy9cVSey5jTci93zkgVkmPW1E2OHKtCSHVHQ8wfPugqJzqJh/tLtWnFww6OcLE4A8puCBxKWDHI96W7EGd5OILmuZoAWCoaCSDaL+phIvfra2h1ovtnca668bFmtrK2+/erxx5QLq1R53Qd2ChjvDSxmTT3jk9z6QjO+SD+V/mMSsZ/enA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgPfObaWb0RRVtn7uMUlOSz5sZ2GrOBEfteGvXPSkDE=;
 b=X4fbsM+xtkZiImMcyyP9s2EpszpiGXpEctzk1RMWSSMfzlpjBTeCBwnlOjAR9ay4VgQnUp0tTf+oIrE4k4XFM4HG1Tk3HTNLbqiDJL//YsC7XxE2Qc1dHGXxhCYVi0njGCWzxRk9+Blxn6NXumiuwlBNbqxFjjhC/XoZjwvG1RHWoq9iqzHfDvAiI+ZsXT/NaqFriVV2+Mv/u1HpDqJJw0qCJRGDqPjVxhZ8aY7qpTGr6PvaRF9R/E7rXCBUJlnl16+kQjACIpjzEvqNCQ8kHYCTDseapF2Ga+Mv/2qj8Ue1L/KKboDQ64UWb3+bQdpSfWKW9I87MMche8C7raWOqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgPfObaWb0RRVtn7uMUlOSz5sZ2GrOBEfteGvXPSkDE=;
 b=qBGTlKRS5E0coY0PgEelMwcPLj3AjMVFcM+r+eet38YWBSQqkOoBecZezl3BHcD3SnMk8He46F+t5hNb0nqrqnM8TUAdzb3zZUQ7rswXMpcTFnJLL0xJlgTxoD2IQ349X2cEOsPMf31vu6UkVbK9Cb/2voqH5ZiYnBblIBCUwmY9IvAFlo0jbxztyOmVz37LV7e4H8cIyMAfdtm2YHhCls2r9BH3euhQM+uAHtBZoXXtep8gArvdrW8LAoBYEoFC7j/E4zqc1gUB55DN9h+42ydRAfnBgZHLnrYQLmBQjPzIT9pgTrsPYew2ELo425cHg03Cni/pU+HMhyLF9p5TVg==
Received: from MN2PR02CA0001.namprd02.prod.outlook.com (2603:10b6:208:fc::14)
 by PH7PR12MB8122.namprd12.prod.outlook.com (2603:10b6:510:2b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 10:50:02 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2603:10b6:208:fc:cafe::a8) by MN2PR02CA0001.outlook.office365.com
 (2603:10b6:208:fc::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24 via Frontend
 Transport; Fri, 1 Dec 2023 10:50:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Fri, 1 Dec 2023 10:50:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:45 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:45 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 1 Dec 2023 02:49:42 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <galp@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 7/7] vdpa/mlx5: Use vq suspend/resume during .set_map
Date: Fri, 1 Dec 2023 12:48:57 +0200
Message-ID: <20231201104857.665737-8-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|PH7PR12MB8122:EE_
X-MS-Office365-Filtering-Correlation-Id: eb842aa8-2c05-4d55-cd2c-08dbf25b4524
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lP7yC7mm+hhX2Ew99I4UXE2wLk15YRdAZrewYfe3DLydqEO6VgPeWXFcVn+9wbg1pSpW0REvWWRav/5KjR5HQyipDEXFc1166caUBUu9LZBb/8ZqCnlStQI6KYuaHdhSRFeF+Uqg1RoTbG+sQesyBJ5iApTLU5LVzMCDd3RAf4C38arbbELHsVbmZuNG9OQgNPZyV2h9+3ZW1kPIQSYv3IXZI2uvm2IKFk054ZD+bZJk3jKZyaB74/NhH4eJmLqvC9CH6BmXJKRQ1vkhVV7MNNzHT51TzpJVmYmGxjcah394OmSWtYDFZyZmgf9fMy8/AVBrGPrWsQnAAQxVAMJPcdMW7L5/g4YmjiJazN8q6UMpopAtkyxFmWfgSxqgl14j9D/4rx7KJcPraBXol6Le1Kw8T1UV6HoEbTTNCsMKar7NGvopWwU/adexJDli1P8aLOx7ogEsWQcEudufCemc1rAS4/b0E1lQzWsJdwZJNfQFJQ2vlt4ET31pSkdBq42D8rGeG46R62EyvtCUrhnOVKdFzMFDnw/z9MpXRacjo/kjc7VdXroD36rAynOD7pJhvLVfAfZq/UieLeu6MkLFBHJ252hzbTvb/jt+22+zz2en3oF9GS2DEjc+4VpU7Qq+PawSxd58oQ9+zDxefX1N/g0bfnh8HJLB2O3RuxBQmMBYMAHTaDuTj00gUCy9fMHdIF5vXBdo+d0RnoM4fv7eAQOP9sifU+QjsqGp9vJe5/XKIF/TSdro15q6ti3ohIRagD5sM1iUO2OIt0UvxrQNUg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(136003)(396003)(230922051799003)(1800799012)(186009)(82310400011)(64100799003)(451199024)(36840700001)(46966006)(40470700004)(1076003)(26005)(2616005)(478600001)(6666004)(47076005)(336012)(426003)(83380400001)(15650500001)(5660300002)(41300700001)(2906002)(110136005)(70586007)(36860700001)(54906003)(70206006)(4326008)(8676002)(8936002)(316002)(7636003)(82740400003)(356005)(86362001)(36756003)(40480700001)(40460700003)(142923001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 10:50:01.7011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb842aa8-2c05-4d55-cd2c-08dbf25b4524
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8122

Instead of tearing down and setting up vq resources, use vq
suspend/resume during .set_map to speed things up a bit.

The vq mr is updated with the new mapping while the vqs are suspended.

If the device doesn't support resumable vqs, do the old teardown and
setup dance.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 46 ++++++++++++++++++++++++------
 include/linux/mlx5/mlx5_ifc_vdpa.h |  1 +
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 6325aef045e2..eb0ac3d9c9d2 100644
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
@@ -2784,24 +2803,35 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
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
2.42.0


