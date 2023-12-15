Return-Path: <kvm+bounces-4571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD2F814A0A
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9517528606A
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755953EA9C;
	Fri, 15 Dec 2023 14:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dyN5JGxF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874133EA83;
	Fri, 15 Dec 2023 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXWzqydgXSDt5+tKH3xPvmTbeNiOIShCu2O7faypghniqc1tJryYFTGrzBkk2u1IHM6aA2Z9x00C8rdzI4wU4+oxP5887m6GicBovltkzvXjwkgBXqmdydA98i3YYyDlVacLSXWW8PP2qsm7ZjzizAi8lahLEUsHbdKz7HzgEzXUAkVY1cnBADLeBFjxMGDjRGeDb7hAca3GqZLEzNwTrOSQtL1HLeJ0FfTAtCHk52hNt4Qfuv7u3dJ7hz0PGuorLuEdy7G6DjgsvT/+2l77NrgC2ZN/QfCAJxQWeLQuTV3Gc9yPOhWWNZnynNxDbOEwd1446v2eNAC3ouscTbAVnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCkDUWSVBbPDHMGVxZ/kQ/O3FYpPFUjYdtgplbmD6Uo=;
 b=ngaN7Dq8f+PkYcj1S23p9Lo1R0LKPgc9ZtWS+PD0Ba7pyRJQkLbmMMVoSpTaeP+auH1YclmMwEPvqJ9EtG3e2jyykXOvpApa4JIMNE5+t0AFBSwKhM2FOwwTswtiOcKybOm26WmJUA/UkGJqdOE8s35DWM2U4eH6qwTltHTGodMsD0OKZb5EmLmeE+MU1NL/e7ptnABU5CcTEK9N9YCJ4GJJFBk6gQqZHvs79rPwR5CsjI+nrI+CmpCQzX7Fi4ibpaDWhFk3ESlv8a5UQVJJtfIAZy1HEoQLWSpmle1rRNCvsxLNIwQdvptC5SbYjwotbKDklfJDbwP6nK7C826s7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCkDUWSVBbPDHMGVxZ/kQ/O3FYpPFUjYdtgplbmD6Uo=;
 b=dyN5JGxFllxDknEvZzmMyoP70ap9DwRd/TAEWADJuNP0cNgRLB1Kd6XhvZWE9xW9Yy/tQei2X0p59IM1BLxY3+UeY4mdr9cuURV0x7MV3lejPB+AqYHW/8mrcVsJSlA2WrvijDS0gxX7WOoxOfyoyA731EqOQnUVwrn6a5kqa7LFX59KoXK5t3qZVjGzA6N1muCt0LMig8gNlpDQgFQGgwRAGEjNPOvRw3/I6BAHV1CD7xYZnGKGnoNLzA9ndvlIksVgKZNWkXmdTCI8EnGTp7ky/ilXOfQF+Y3K76t+dj8YtD2Pa4BCEkFVTu1hKBm7Qye7fszZHa/mlFo1ek7DZg==
Received: from DM6PR11CA0007.namprd11.prod.outlook.com (2603:10b6:5:190::20)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31; Fri, 15 Dec
 2023 14:02:37 +0000
Received: from CY4PEPF0000EDD6.namprd03.prod.outlook.com
 (2603:10b6:5:190:cafe::6) by DM6PR11CA0007.outlook.office365.com
 (2603:10b6:5:190::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31 via Frontend
 Transport; Fri, 15 Dec 2023 14:02:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EDD6.mail.protection.outlook.com (10.167.241.210) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Fri, 15 Dec 2023 14:02:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:17 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:02:17 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 15 Dec 2023 06:02:14 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 6/6] vdpa/mlx5: Add mkey leak detection
Date: Fri, 15 Dec 2023 16:01:46 +0200
Message-ID: <20231215140146.95816-7-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD6:EE_|SA0PR12MB4509:EE_
X-MS-Office365-Filtering-Correlation-Id: 26b1cacc-f9af-4db3-c419-08dbfd767e47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dUbJnda7EaM6vJarQQp9MA0aAeVY4ql/JEBNq8PVkkpCKPMydK5Cdhkj6EnDmomIHprFCQc1tj1hOJDQHwHvGisTbFe9sfnM3Ajh01adtGCc+1FgiRyB5yy+/T/kHeQZi/OGtZ4gZYycXU1zHAMM6qj1bckrtgMFaQ5EcOqaKfoEMEBrthAGz47Q/q85AMxHssGfXmmPsqwefmcvipYzgX7FyfXFJeGaQN1/3Et/lQVp7CgEIgGCd1b0jw2dN6yCPhXybMe8S5R20HvEaj6NVIUbE9rT5vUnm8WciRMigioq9rRgEBG2s2r7N/WEC1LFgpZoAsFNzLMDO/6hTJZ8xwbJOUq1VCMbg+EabQ6OR20/kUDUZC9kGwmO53x9YfJ4HOKHpFnFgPrN25or2b+hq8s3tCIp/MaI/aeheqfCqYWVa/kMzZIjFgtYgG6WGiafquMlotxUMUf1IeHtujAoRZQLuQMTl599Hf34by/TdVAP8pNjZ3jTXi6mRA+M9PHhZLM3UZMI0glWHd5BPXi4TmUSf8+KHVCvuj7pgszObIHRIqeyyMFco0rYuL+1xQX6lokuoWot8+q2e8oiQK62Fhhd1ZIXJVowj4psQ1IjlLVP9jqc9HhDv22A7gTkzPXWIaH4zZR4rwevexvAoT0AP1cjToROtmxdeqQy/337iMnTd1tCseCBNAEJA7z+5uG822GRd2lGJ3kf85k12poooHVchSnVqiONTPrbXBlNgYKYajjMzqDa0jXFEn4KjOF+yjlEofiZzOG1yC8uTChdnM5EEiKc00OknWHR+e1igH3QdcbhH0+n2DzftfaFN9XffylscB5nWTawGbKxMNHAGw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(346002)(136003)(230273577357003)(230173577357003)(230922051799003)(1800799012)(186009)(64100799003)(82310400011)(451199024)(46966006)(40470700004)(36840700001)(40480700001)(40460700003)(36860700001)(47076005)(356005)(82740400003)(2906002)(36756003)(5660300002)(83380400001)(336012)(6666004)(66574015)(426003)(7636003)(1076003)(26005)(2616005)(478600001)(54906003)(70206006)(70586007)(41300700001)(86362001)(110136005)(4326008)(8676002)(8936002)(6636002)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 14:02:36.8251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b1cacc-f9af-4db3-c419-08dbfd767e47
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509

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
index 0df82e4d13f4..88b633682e18 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3707,6 +3707,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	if (err)
 		goto err_mpfs;
 
+	INIT_LIST_HEAD(&mvdev->mr_list_head);
+
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		err = mlx5_vdpa_create_dma_mr(mvdev);
 		if (err)
-- 
2.43.0


