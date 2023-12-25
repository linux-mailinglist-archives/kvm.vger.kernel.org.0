Return-Path: <kvm+bounces-5237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD7D81E15E
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:15:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8239280E70
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C04A55793;
	Mon, 25 Dec 2023 15:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QgT4KrPM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F002B5576D;
	Mon, 25 Dec 2023 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auyXTVrwa89LHpV7BqPNErRrbSdyY0BrEIXKrqbRXr9b68XefBTyAhgpDYDsRr7iaqO+sSOXazPnePRH8F32JfiFrYdG5SlmvCIjGJvoyFxHD8lkoowXUnQVHkVmrfwVZaF1Evywd0VcpyFjOKDpFsCGtMHl63fnlVOs32oU3McGHvRd0ujgEBE2zZkdoa1hi+vMaqokoe83U5MlM0zZBDJAYQbtOmrTXLO6hj54P62nKZOY81N4p0ANU+ufSOZdl5Se5NB6OyLEmiaAXcS9fQGi8tMraycGUuYNOFWWmwB0qChBlpjk1gK4SLLwzyBtJyvoNTkaakFUolbkJJrAfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEwXsxLIfAPMkPFEOMoOV5LXFnJAUiliHV9A5DqpaC0=;
 b=Io+wKrAMmCu9EhyA4cAFlwPzAnlT4nBt3VChJgYbVGXeeJkjll/K16PpiZRA+1nHppEXegaXaskIrUf20BQ7sjPb33+a+7qwnLEsksbQiBaSMZ9C2ObRRw1uXl/yRqGHFNiXCLMSV//TOVKKZGxZR42/e6p2VUIRarGSNwfdSzvycenFOQmij/kjM6TABRe0w9SEmp0jtS1xsIlBbhR6S1P04hAGbej3h5o+5KqYfsixnIIYAu6osD/KO58wkNeGxnjb6bBed3C6zbDb4CrFypos68gAzMZH+VqrrLKYmNsvTeWQ8XWHWV6NrbO9ctl61wnHsm/RhXFH+8DyIaFayQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEwXsxLIfAPMkPFEOMoOV5LXFnJAUiliHV9A5DqpaC0=;
 b=QgT4KrPMIoE6TZx8Z16qsp44MSz0r6qpFmhtbhT/8JSwIrhi+/YSA6N+xYSM2S+PF33O9EqnZOseciLzHz/NkYS+sjvEmd/JeZkYiNvLVHKTk3LjACo8pPMcCttlXdbT14ablAmWCtpkZlvx1xQj1YC5RwC69sp5uQinm9XqqJW46eOm6BGUbU55++4X/uBj3R1t8WQ3WhMlGtpGB2Vv1YR+2NKIXHQ2ji1GgRpHJ0kr7PrdEefqcDI5ulQjnWNm+69AFnyQtLL1stS/ZCYf0hGZDini3ymXmGtxVQ6poOIdzcrXz4ZIfM7jS3igtBeTVYIGk3ZYlN+MIbD3vF4lhg==
Received: from SJ0PR03CA0127.namprd03.prod.outlook.com (2603:10b6:a03:33c::12)
 by MW6PR12MB8759.namprd12.prod.outlook.com (2603:10b6:303:243::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 15:12:40 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::94) by SJ0PR03CA0127.outlook.office365.com
 (2603:10b6:a03:33c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Mon, 25 Dec 2023 15:12:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 15:12:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 07:12:35 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 25 Dec 2023 07:12:35 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Mon, 25 Dec 2023 07:12:32 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v5 8/8] vdpa/mlx5: Add mkey leak detection
Date: Mon, 25 Dec 2023 17:12:03 +0200
Message-ID: <20231225151203.152687-9-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231225151203.152687-1-dtatulea@nvidia.com>
References: <20231225151203.152687-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|MW6PR12MB8759:EE_
X-MS-Office365-Filtering-Correlation-Id: 45980458-9126-4e42-24ee-08dc055beffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0CR+Nq3Il5sjwjWUgR+wri9Ec3eSvbVkdn0gQDCJfOscmYIl2K3mQfVShFTDGNl2NngL0HCfGeWgUxs0jisVCrqZSEPgHa8pIDaHYxoFNgaz3wpRHraUJ3xzq+NY9iJRQyYwhnbNG9wep6SSsW5KJBbdnOXNDFq6OfAviy2Mh0QJKY3rvFEtgbHaQmy87ifedRxYLOP+FZBkuX6vDHG/2V62s/Y+EWJaVu3EqGIz6rCPK5vOTRzn6H997/e0mipqkIQB6Ack5vQ5Wk+xTeMuxbVEKlTpkyD/D6vk0ItzBopT+wtG9OW5utUJfuNhKY9O6LZls9UCVK0z0+nqxFvqkuKYplzQPdFXje/wqLAIubgJOZ4+kU8PXe5Kv1hthEDQNIQyu0wA3XxcytHpiym3D9O3PXLhCYaU4bu8tIPbM74H6wQx1cxy2OxSpWNSfX5hFlwhaa/ch4p957/sY+C84zFbem9R8RCMCr8ngn5HwnqxS1+ka5hpWFTMQzzB1iQpQmrNP1n7KfuASi/Sv75od5bTiuQCGz6mRkntDgByzrRR6pyuAj5S4Me9MAyFbbI8eq2XyXpFvCWs6s3/3j33jhONBTD6goa3hxmBmVnbF9Lx+gwM2SgUprU0isTZ9IaA+pmweHpCe0wvPIZapC1qGS/1+YM3VK0uqZ87vqL5zJuNyBH6ugNfYSsaSm0MRwVW3+1657PXbbz9EeLansGYfvZz2m75evD4j3VXyImsUwIbmw9xbLKrYW7dBA2T0AQdH/C+QtCT7Jh0R9cR1/6Kbblr6D35Fr6064c98IizGyE=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(230273577357003)(230173577357003)(451199024)(82310400011)(1800799012)(64100799003)(186009)(36840700001)(40470700004)(46966006)(5660300002)(36860700001)(2906002)(478600001)(26005)(336012)(426003)(1076003)(2616005)(66574015)(41300700001)(86362001)(36756003)(40480700001)(40460700003)(356005)(82740400003)(7636003)(47076005)(316002)(54906003)(70586007)(6636002)(70206006)(6666004)(8936002)(8676002)(4326008)(110136005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 15:12:40.5922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45980458-9126-4e42-24ee-08dc055beffa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8759

Track allocated mrs in a list and show warning when leaks are detected
on device free or reset.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 ++
 drivers/vdpa/mlx5/core/mr.c        | 23 +++++++++++++++++++++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 1a0d27b6e09a..50aac8fe57ef 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -37,6 +37,7 @@ struct mlx5_vdpa_mr {
 	bool user_mr;
 
 	refcount_t refcount;
+	struct list_head mr_list;
 };
 
 struct mlx5_vdpa_resources {
@@ -95,6 +96,7 @@ struct mlx5_vdpa_dev {
 	u32 generation;
 
 	struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
+	struct list_head mr_list_head;
 	/* serialize mr access */
 	struct mutex mr_mtx;
 	struct mlx5_control_vq cvq;
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index c7dc8914354a..4758914ccf86 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -508,6 +508,8 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_
 
 	vhost_iotlb_free(mr->iotlb);
 
+	list_del(&mr->mr_list);
+
 	kfree(mr);
 }
 
@@ -560,12 +562,31 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 	mutex_unlock(&mvdev->mr_mtx);
 }
 
+static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
+{
+	struct mlx5_vdpa_mr *mr;
+
+	mutex_lock(&mvdev->mr_mtx);
+
+	list_for_each_entry(mr, &mvdev->mr_list_head, mr_list) {
+
+		mlx5_vdpa_warn(mvdev, "mkey still alive after resource delete: "
+				      "mr: %p, mkey: 0x%x, refcount: %u\n",
+				       mr, mr->mkey, refcount_read(&mr->refcount));
+	}
+
+	mutex_unlock(&mvdev->mr_mtx);
+
+}
+
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
 		mlx5_vdpa_update_mr(mvdev, NULL, i);
 
 	prune_iotlb(mvdev->cvq.iotlb);
+
+	mlx5_vdpa_show_mr_leaks(mvdev);
 }
 
 static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
@@ -592,6 +613,8 @@ static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 	if (err)
 		goto err_iotlb;
 
+	list_add_tail(&mr->mr_list, &mvdev->mr_list_head);
+
 	return 0;
 
 err_iotlb:
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 133cbb66dcfe..778821bab7d9 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3722,6 +3722,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	if (err)
 		goto err_mpfs;
 
+	INIT_LIST_HEAD(&mvdev->mr_list_head);
+
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		err = mlx5_vdpa_create_dma_mr(mvdev);
 		if (err)
-- 
2.43.0


