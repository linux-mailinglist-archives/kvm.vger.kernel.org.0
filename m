Return-Path: <kvm+bounces-5233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E54BD81E150
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:13:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B1482824B5
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3452454667;
	Mon, 25 Dec 2023 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fdi3Z+pQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C733E53E1D;
	Mon, 25 Dec 2023 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXHLvKw7Ilfyg7/jxS9k3RA4THOhxTgaKzGyPSLSr4NTJyf7huHfzOS8mRbqb+/xfzmRaRkTTu8bIEuqsJ4cdgezYUWvIQv6ipuO2CDi30XHygQdaTxg71uZ3Xu1KVmlPZTHnS2VLQjLVhpGaqvR/bd9zj7e+4+UCh8LYGSrP6Pj1/qEUiJbppxs90H/VyhZkp69qVvXQNWs4u1QGtLx7YJ0Y4XNKyyixQHceava5o45e6Nm/0JZngu3h3UfACfd3BeX/XHlzYBSg5dohXjgNibb7oX4cLB5slRtzlkAkGdf6ebgnNKczwb5osrnDj1KrtjsAgqAJuj+WvUOuqOsmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LduFBRYy0l4xJfLA6oXFFuivGEd9tzOzf63wTytIXn4=;
 b=khaIyFlJGKRp1N/FMX/1mk6fpIn1X8QcZC17v3a2maQHZcFHjiKe40UEZTvVGypTK6XBr/0N/akb7v9DiiEC9KrjbAs+oFrVymqzZwUBI/rfbMwdktesIz+pHNyMqbyzTpi/XVcscXY3kq9htU7A5PzdfAPgQ/4CYdcaT1PaXFx9fKCHVM/zk0cTioh91lSg1qkZ/9R21HhidaKncWExrQr2m1pyL6KjmFicfbHrLlx7FH/uaEwxO0guAGOMbd/jHC13W9AiaHmrvIeGMvWhJm9Wkixe6plWkfIULTYJnh3emQ5qBmxu4kUF7yQWEC2KsXw2zOqaXcWMVP67oi7Q3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LduFBRYy0l4xJfLA6oXFFuivGEd9tzOzf63wTytIXn4=;
 b=fdi3Z+pQ/osGL3t4KiF88qmVMEgiYAIC/+VoUNUVsfj1OrENFe/VKVDOmbts1HOThD0nJ7zKCJ3w350exmH+m+SDD7ugEWNVvX2F1J/Ge4+qck0Gm8CikvN698GrokzSdWoQ4CqEt5MKr/AQjBLKEB+zPTDopzRMe3EEhYSIwCkIm/sU26eTqT7xpbzZjtPP6IYajaZu5OpxWw85oA8ulAe1/0+lzJLECVADehQwvu8xlz/MbGUaDGxl+H2YxNbn4LmcHocsMgffnw54xh+ibbVS6Y7dvw6m2yS9RImSRxazogHOZdIDu1uwLRtmRfx7JbnX6cEBeu03EJ7taRpd3A==
Received: from SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26)
 by LV8PR12MB9110.namprd12.prod.outlook.com (2603:10b6:408:18b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 15:12:33 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::a4) by SJ0PR03CA0231.outlook.office365.com
 (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26 via Frontend
 Transport; Mon, 25 Dec 2023 15:12:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 15:12:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 07:12:21 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 25 Dec 2023 07:12:21 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Mon, 25 Dec 2023 07:12:18 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v5 4/8] vdpa/mlx5: Mark vq addrs for modification in hw vq
Date: Mon, 25 Dec 2023 17:11:59 +0200
Message-ID: <20231225151203.152687-5-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|LV8PR12MB9110:EE_
X-MS-Office365-Filtering-Correlation-Id: 452bf9cc-fef5-4271-f738-08dc055beb3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B74+bjQ/o8yx7kMF7bCO4I0ZRnn9EsKsZ0uA3l3xLQ/zYLlpJmMkl0KQmWIZLiuptfsMH15L8jAsNjAypLilBv5OAjNo1jTse65EmPEJQltrYzdYW0+STjf6m9IeJHscJF5favCQtjWGMj/yyfn4arIFClk6FmpKM3aYrbl64q1qTa/+U31LkDM3sMnZNUaFfG152DJ+vfHT2h4l6AWJRrKxtEwVAqQp73IcKzHtyvhv/EaFUzhPUoYqkvGUsj6jSRgMTdkXtvOiMnk2OEcn0ZS6gcAEXPiL+Ojwffk2ju6eYuUn2LbL5wMFF0z7eSeiTx2E8+EEM7ETqNn2uyS5SFW/BA4MpuqmcEMjGxEjMriNhHJzV+v4etgzfnmGqykP3J3GeKaTSqotpjXOo58AVJKJuhq+Oc5/8kgSsuoXo7J/uuDJGEBSgEXRZ5pEDpeOIFbKVfCKnweHvSvnJneU7T6CIBxuaSCglt4rQ5TlkkYbGMmVq9m7wuLjK/DE++IRGT6HfENt9L1eQpcCl8mWMXZRQ/V5NQckMJe3cQdiIl+43rSkrtypsVH7gVOepAmc5fVu7EaIFZ4MRbePwmO6RWB52tExqHtYi2A0cV28lvhMm2QnehhbiNb8IbGCVc8Tk0NPgdaJlLuW6Scrr3j4c9cqcqgqFQ2AfXtK0bNR5IDLfsrMRFIHudhK00fCnDGFmAV79mhInDSXxWhO3xjk1W9ja0jxs85cvcTy6XK3ZxtwXSrKPOaa6E0l2NW2k85T
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(82310400011)(46966006)(40470700004)(36840700001)(86362001)(2906002)(6666004)(478600001)(83380400001)(47076005)(36860700001)(41300700001)(356005)(7636003)(26005)(1076003)(426003)(82740400003)(336012)(2616005)(110136005)(4326008)(54906003)(316002)(40480700001)(36756003)(6636002)(70586007)(70206006)(40460700003)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 15:12:32.6324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 452bf9cc-fef5-4271-f738-08dc055beb3d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9110

Addresses get set by .set_vq_address. hw vq addresses will be updated on
next modify_virtqueue.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 9 +++++++++
 include/linux/mlx5/mlx5_ifc_vdpa.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index f8f088cced50..80e066de0866 100644
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
2.43.0


