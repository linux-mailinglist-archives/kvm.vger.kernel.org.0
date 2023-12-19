Return-Path: <kvm+bounces-4866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83BFA818F83
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:17:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AF12285AC1
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC4A3481BD;
	Tue, 19 Dec 2023 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dwKZsxvI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7163EA7A;
	Tue, 19 Dec 2023 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYDzmx52GbsOqF8a+KVSazDhdsyjEIDc2d/5D+pGi9Bxu7nFIs7fVpLgvPgdby6YGl9m5us8/vmwrm2pGF/Rd6ujr6o647RKiDFUbf3b1Vt22Cht6GKFlhIRIpnldQZd/wKURjiEu5+WaLlwAfE8/rOGLFysfnGkNouc34sIXt/bbD3D0NXzBIQBEjsh6CCH03OdkfDdj8wQiQ9WbIit8jh/pCqBj42a06TyKQBaOD5BmOHcSnR4amFqy4VkLWE0xteNuYZRb1RZDljloFwIbJ/U+f653ymAlZD8BZjeljasus5D67bwJ/Pm7QEoxKIvQv4AzLltIIpljib3xU/PZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKO46lgwXxoc9p1PhLlI2slnpBU+0n8UQO1kpc1S1rY=;
 b=REQnaZ5+5f7rSFoalnvhmNY9V+SD36M2n3ZgMeQrCZA3b8u9L7S10IOn9HvT46D74hzA67zMfAVxyqQHhcDzz+glmRLRXt86cpZKWKLWLSpsdr/3swuD8cSIQWzg36hYdlXHZVT03I/UpCkVsQ6RxjU67nTjUg4+HyxWmR7hFn500q8xTPzGgHZCyvkhIK9eAXNocRfht/BFZO7y+Er6NA+CKh9ZJ9erEMP6hvgFo3NSzic3LhXSwx4ZC17qEKl6DWbqAmBqjECs/0dseyin+M2SVHKBk29dOknp0apOTzLwqOljDIkKYdpb6pqiu0i8rB/lQ3Oi6YianwULITeolA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKO46lgwXxoc9p1PhLlI2slnpBU+0n8UQO1kpc1S1rY=;
 b=dwKZsxvIf45R6vg6rhgRJhIBlL+JMp+3qErlkXy+k9D+O6+l3vhNK+KB1uORd9Dz8vagfVW6C7S7rpM1UZlFBtY5cmvrTkK6i6vP1F5Bv7pa2RG8Gmvi/p+pc60MiGEHNWN1+Hgq8ZQJQQoRIMennmsz6qyRyGqzLeFAQMTV/FT2zvykFzdj9CuShIN8no4btHMhtYiLJi9f4IvutY/KHqdCwM3ZV3XdgQ0ZB3hEP7hF/uF1wuiF+R7t4T6d7OAtaYU+h2oCDe6pCUGC2su8OnKiQWrqdmRv5tLEp3G3DiEV8TsZOkkYErsL5LRhxTbr/k5ne4Xn839aR9l2Gxn3TQ==
Received: from BLAPR03CA0129.namprd03.prod.outlook.com (2603:10b6:208:32e::14)
 by DS0PR12MB7996.namprd12.prod.outlook.com (2603:10b6:8:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 18:10:16 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::b8) by BLAPR03CA0129.outlook.office365.com
 (2603:10b6:208:32e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 18:10:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:10:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:10:03 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:10:02 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:59 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 15/15] vdpa/mlx5: Add mkey leak detection
Date: Tue, 19 Dec 2023 20:08:58 +0200
Message-ID: <20231219180858.120898-16-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|DS0PR12MB7996:EE_
X-MS-Office365-Filtering-Correlation-Id: a8c7a0a5-8d40-424c-4fe3-08dc00bdc11c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fD3pj2K2/23gktmNY3Dcxb1UftwqDM1kCHqkbjdv7cjLER9zcsgHprv3dp49p/m6RUzGqFa5/p4/hLGCq7MPgknUPz4vFr7UNP0B9TnwKmS2MUg5vQ3BzJLZtQXeY+dw2whzpgwNod50seX39zbdiG5rlaRFp8CixefEoqqZ4S32qvHOFM0JtRVD9dnFviYq+ghjxI6TYXEyZqxpGDOsLZi5ExDs+cDCC0ypK8SUw3wrEoAiuoPvdsz1FYlw3YqrXWPJdcoMAYtDhOM5eBdTHB8gb7EuzxDvlsYBUwfpaY9nT46ILqz4uHr/sst5pTr40Hn7r+UGytL3jFNJlLVpGylQCVOOCz4YCuUqittqdxGDtQd9d14c1m4NRb+GBmpKBTvh2q6JCGjQPetZnunem7ZDpTuovyUwQRPfFkWDwQCTqasz+c41eL1CS7TBFPv22nIRzRTVPuDrsd7lN7+d2lnLG8OPHNho/lRgCqRXIhbJANwrdR7wYkzqEZsTQ2CPehedWThTE7Ye+4cHiMmnXfQGY7i+KB8X3dSPRw5Qh1bysvUczR4wxV2kn1xX/nauJmjNZDFxBoXaFs3YzqipE5YNshTTfpb+WD55ztaWuYXEPPoGVCC7M3nFcPxSf+jjoJpwNrPbD8HXM0caeoQXQIj01OCS/gi83ANw5BmCAoGAC2qTVnWNpzdn3w1fvORejI2l7eajjiE+5Js6ydnuVe56AjS2oEsn1uxDS8BBgu0qxw+weWKRlegSlyi8284muIEp6Q46oQmsmodllLNCQJUZ9YmtCUNm7KJbM59yB5U=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230273577357003)(230922051799003)(230173577357003)(1800799012)(82310400011)(451199024)(64100799003)(186009)(36840700001)(40470700004)(46966006)(336012)(26005)(82740400003)(426003)(2616005)(66574015)(1076003)(2906002)(47076005)(36860700001)(5660300002)(83380400001)(4326008)(110136005)(8936002)(8676002)(478600001)(41300700001)(316002)(6636002)(70206006)(54906003)(70586007)(7636003)(356005)(86362001)(36756003)(40480700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:10:16.6413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c7a0a5-8d40-424c-4fe3-08dc00bdc11c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7996

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
index f81968b3f9cf..a783e8bd784d 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3729,6 +3729,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	if (err)
 		goto err_mpfs;
 
+	INIT_LIST_HEAD(&mvdev->mr_list_head);
+
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		err = mlx5_vdpa_create_dma_mr(mvdev);
 		if (err)
-- 
2.43.0


