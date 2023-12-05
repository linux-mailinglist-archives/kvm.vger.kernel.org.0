Return-Path: <kvm+bounces-3511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B4B805114
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15E241C20E80
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784E25B1E8;
	Tue,  5 Dec 2023 10:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="elslTy+o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDD7198;
	Tue,  5 Dec 2023 02:47:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feyWx9dbtVq6WJRDqetAzi+iMDblae1M6i3BX38xf7vD3YTi4FQ4Bf+QEShqOn20JMUqp9Jf2YJSngw/RSZdAfYLEVbQxTbs4zV8OqhhBdcvtMPWBOB1NS5ZXV5jh6Zp+lajqwGUPFB5zo7iE05yYPoeOpdzgblusNEvgNF3r3fVzoa6Hna8eW7DCY42j2anDYyIEFMFs5wPY2H1DEDTJ89QhmXJ0D8cPy1WMonXOBvPMPGRnWeW4Ieh4B924E2+U4FLvm0PdiIiMuk2jJGXOBxSCusn8+ZAe//txYlQklXokKON2QFyfFhttE3LPE0Fk+fEiEBKxCM1msk56xDtWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxdASW21yJ2XNUrGBMJT6rmW3BFXdPpM3w/CAWePScM=;
 b=U4fJy0TgOqOW2uibam3htnFI//cNYnm9rvOQo5aMZwyUMCnuhB+f7bS22TPIndMPwzgHvMu/eVRgHzcByUrq31aUBYeaGRXwZvIbxBYZJkbV437LrERm6sGyL8Lc8JDarqwRQljNOM1aXdRon4pdC9a+oIh8sN8li6euyKKhc7kTMFU9v/3XMkiUoagPy9Mwqm0XSyCj9h4TQgZOZHqDrN4OEoEcTZedY4HSaV/G/D8UrbqGyU51J0h0dzeb1f2HLXTSxQsU9KgXiHgVyi5kv5/QpTuD1CtmjeSO9PfxAMFvsWUSssHtYn5+jH0Za/UHImQx3IbG/j+u/RrKi8py9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxdASW21yJ2XNUrGBMJT6rmW3BFXdPpM3w/CAWePScM=;
 b=elslTy+otnoyfxRr5Jc7JwawtxNoJaiS0A8zLNmbZoZURmCtcQdq9IomK60meAJ8HLXxPmEsjz7L/ZzHd9YTgoulpHrMO/ghExVJZssGzsZBZzdapYdjxrcyoq6e6suXBCP0RzKK85zdJmf1Ge1bbH43aNg/map3mb/yeDPBgOG2ZZyWPC6bflP6CH8IQppWpJ6oQOzJQs/MzebdkrNsOxNGnpNI2MDJYXWCoIgKIn1Fynremsvok0B9kFIB2hJIKQqeqBucB6G5VUdrU8KfEi7bPubv7sA0Qh+wbPB5QGZ/V1FDy2xFcY6Ol1KtvYSMnxnt/ow3DEoFfdMfQ+UnmA==
Received: from SJ0PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:33a::32)
 by PH7PR12MB6858.namprd12.prod.outlook.com (2603:10b6:510:1b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 10:46:56 +0000
Received: from DS3PEPF000099DA.namprd04.prod.outlook.com
 (2603:10b6:a03:33a:cafe::8e) by SJ0PR03CA0027.outlook.office365.com
 (2603:10b6:a03:33a::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 10:46:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099DA.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 10:46:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:42 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:41 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 5 Dec 2023 02:46:38 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v2 6/8] vdpa/mlx5: Use vq suspend/resume during .set_map
Date: Tue, 5 Dec 2023 12:46:07 +0200
Message-ID: <20231205104609.876194-7-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DA:EE_|PH7PR12MB6858:EE_
X-MS-Office365-Filtering-Correlation-Id: ee727bf1-056b-4170-dec1-08dbf57f802e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	thBRXEv8w0Xhydt0DYssxXitr9Q266aJdb6WsKJCF44X/WZbWo2g+k9CkNe89U9K7Iz5jvekKsko+W6aHDxIGlV7zRCunQs9Apj4PQGvrZcpKImx1/772wzK3sWPKSsiN7o11gIizvRIbJiKoT+aYMXinbXxBk3CKgMf7asPnKvNtUqyjlu6ERLW8YS2Uv6vMzdxjFMQbDYWPXs6XWv40mqOF97kHs3eHKDx8AuR+0oirbAhdyLT5XBQXkyKPEg7hGDxfkjHQAwfjH/ZCygEq/T5fZiWx9ym8IKDaA1Z2WcMLd7iNDcCy2YPsKXfauFj4MGDvhBsqc9KtxnACB6ZM6TJh7Y2jRui/f6y9qPxQbKJxodYR3GJR9j2F425Okk4wJmxuzRniwabICAgfmMKVY1z++YCeEPphVzzckgbimFG8G7YSud9Nc1MmJ379UDdhQx96BMQx0WkBFxhbWAuFeiZfy4jfgSQDepUb4vRmYLdVvAk0z+vXtcj+2Di68aqgGKvyJFF+ygQyqD53KcdvqHaNovMkh9UipfxvS/OHk05jYIRsERwnCdwziGhHYTsGlkGhaADthL0IDEsht8ob7f8GT5Qoig9ZuQcw5zIjj9zHYRYix+W81SAJOunBGvcsY8CQtVJuaRQ8XX5zUwcWiOckjuHfosoNfO3QMAm4uSvLk6WIuN6Gy3u7qbV8nlwWX7Mpy3ZbnRwQhyk+xtVQ+C2gfPrn0XIpj8zXVZ6njqf6lEetANt8zbI21MR/w6fuANvQJk/WHiV8iA4DmnGgA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(82310400011)(64100799003)(186009)(451199024)(1800799012)(40470700004)(46966006)(36840700001)(26005)(66574015)(1076003)(36860700001)(82740400003)(356005)(7636003)(47076005)(336012)(426003)(40480700001)(36756003)(2616005)(83380400001)(41300700001)(6666004)(40460700003)(15650500001)(2906002)(86362001)(54906003)(70206006)(70586007)(110136005)(5660300002)(6636002)(316002)(478600001)(8676002)(4326008)(8936002)(142923001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 10:46:56.1701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee727bf1-056b-4170-dec1-08dbf57f802e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6858

Instead of tearing down and setting up vq resources, use vq
suspend/resume during .set_map to speed things up a bit.

The vq mr is updated with the new mapping while the vqs are suspended.

If the device doesn't support resumable vqs, do the old teardown and
setup dance.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 46 ++++++++++++++++++++++++------
 include/linux/mlx5/mlx5_ifc_vdpa.h |  1 +
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index d6c8506cec8f..6a21223d97a8 100644
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


