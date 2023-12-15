Return-Path: <kvm+bounces-4566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 958498149F8
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D368282309
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5267B31A94;
	Fri, 15 Dec 2023 14:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TfJmdQuW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ABF31A60;
	Fri, 15 Dec 2023 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJNtR2g13HatLfOlwHeHobJbnBvmC8CKD8v7BxjXiwhPFdaetRaCtXXpqsp1KEuUc7hRCKxw3lm6x+TCQIdSndZGZKfPkOnPXJ+FuCgsa6HrbqZV2ytPPvpu5NR8P4hqr2yx6hzbBZDjt1Zz4CdbkLRVpiORUmjoeZuz+IzWYHu//16C4Ab6UmPEF0Itr5IofSZSnTPIymWCl/z4gVgWLlCWGP6kbNEilRHcg/FN/5DndMHzbSvbiXG7ZPbfh/qvwBzpwuW4lQxi4FSftepuCtL7KvXjG8FveIagtr/O5h5FNmD/n/OvpJ5q4IoIYdBwiuVt2UhhaNwUS0WeDjeaqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfHOQCLFJHnJBlBhyduPWB5HBqN4yk6hN4g/bB/sNgw=;
 b=JOrsbCBB7I7h80gtf6ZBaZ0IfMjn3kBY1D3j3ux5wSzwhkwt+gYhdJ4GgE8YHhx25M6cLIIxmMPMzRR7Dktwytc+7ahJdcv7+6VFsax76BNxke/zVMdm1AYoAK/oqFTO7+R6YxVWA8fn8OwmecJ7eGTeIKTokroBcP/J3nfpgAfASc3EzAGwPmWaYWt6mDFSHQbcSp3JJyuf8P2EdxHyytkTBqzWw4rghpOcdLZzgKVgjHPmqsX7pnGOm0BJu0k180fcf4Q25PhnhsowSG6tZ4qr32vrDckyxKtDsfupK3rODmNslzmPZ4TNRtiDIT9Gbm2zEgn6hM/IYCByPPIFWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfHOQCLFJHnJBlBhyduPWB5HBqN4yk6hN4g/bB/sNgw=;
 b=TfJmdQuW8DP5Xn3po+kBLAYDssI1RJ/RKM/vKEUe2QEXDmCKAncesTl8X2R0rwBEaZsfK7AQmOyYI0cYzHMN3xj62zx5ezCYx41bz5yKbYWYdT6YVkmN42/8aSjKSr1T/O5eg2I/hzmNB8S2ZCpA/PTyCd6xMdXDFufAIFLazhQVeOxbXb7RlVFZzMpnwQPRxq0jHycJWK9tZzSV0vF6OgOO8l5gPH9ubP6XeyWdhC5H+TGK1VAlCkWndDxfEhgChomCaLWTWxxFo+f/GtZpgroJD0BZSR95d+HrvlPsOBm0ftLFgpnvzqSYmU21Ad9Mxrcoegr7uHqSvNfis2FksA==
Received: from DS7PR03CA0185.namprd03.prod.outlook.com (2603:10b6:5:3b6::10)
 by IA1PR12MB7661.namprd12.prod.outlook.com (2603:10b6:208:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Fri, 15 Dec
 2023 14:02:17 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:5:3b6:cafe::8d) by DS7PR03CA0185.outlook.office365.com
 (2603:10b6:5:3b6::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31 via Frontend
 Transport; Fri, 15 Dec 2023 14:02:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Fri, 15 Dec 2023 14:02:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:01:59 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:01:59 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 15 Dec 2023 06:01:56 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH mlx5-vhost v3 1/6] vdpa/mlx5: Expose resumable vq capability
Date: Fri, 15 Dec 2023 16:01:41 +0200
Message-ID: <20231215140146.95816-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|IA1PR12MB7661:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b7372a3-5f66-48f8-ba4c-08dbfd767270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wkJ6lVnStwZAM0uGmCztfdTgQuyGlXmeIIekbiRqr8+e7lrKm6tVLmCpGPW0bXJSks6GI7PjGcQTy8n7hP2PWac5VrpvFpkzbsg7aZULv+uO1L/6bLpvaIQGekTdlizF7L+9fgXJ8Hk6KkOXgBW0zHQSdBVktoabQFKwOfuHgSAptRZH3nYoIwiAzUvtf3fSYKgpyVizrbtABqfzMxSOGZ6+Krbcx+j+k9RuO03xO0s/2LI7FyzmwitqUnh09uZZKu/sLDW/3fS/vxmwTajhFsyFklO9C4vYP/JskLVkLLftCIfXVWshRzH8yXLZKEhS/NIT1w49TEsvBl53uZl0WCz8ZLDEE2OoMn0iQp+38RLXWeBvScCyIig75mVnVPCuMFH4fPrpHG2AieHQXgX/K0ro1ymXhcpxQzH0zNRvUuC8mvKRCYEkCS4maznK3QrCghqeczTeUEraqFVUDi5QvJwBIyYDFmwt01BMKD/lwnnOo2un+A32NqrHbz2TvQ7RifKwCocIxnmVqFeNmByb0mTPEsQg5TvhADmAu80lzwWGif6wAYKfYZLJUeVnbHh2wPEaQEBXN5DQVUdQ8ALlXl2+BDpF+1lZAqnWYzaXuZNU3J2dHskOzSZz67aSjH2oqC98DTgeWW55qL90YwSl1CB3q2SoDdsvXshgHp8Pc/xbbgB+wqfuT8tAvWJ3q84uuNSoQnvsXzmzFnrFWQWSZHjNRY1c4npARerMdJWMR4DiBqXcHho+TL+mxeNSYNaU
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(136003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(82310400011)(46966006)(36840700001)(40470700004)(5660300002)(40480700001)(478600001)(6666004)(54906003)(82740400003)(4744005)(2906002)(1076003)(66574015)(2616005)(26005)(86362001)(426003)(336012)(36756003)(70206006)(70586007)(316002)(6636002)(110136005)(40460700003)(4326008)(8676002)(8936002)(7636003)(356005)(41300700001)(47076005)(83380400001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 14:02:16.9609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7372a3-5f66-48f8-ba4c-08dbfd767270
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7661

Necessary for checking if resumable vqs are supported by the hardware.
Actual support will be added in a downstream patch.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6f3631425f38..9eaceaf6bcb0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1236,7 +1236,8 @@ struct mlx5_ifc_virtio_emulation_cap_bits {
 
 	u8	   reserved_at_c0[0x13];
 	u8         desc_group_mkey_supported[0x1];
-	u8         reserved_at_d4[0xc];
+	u8         freeze_to_rdy_supported[0x1];
+	u8         reserved_at_d5[0xb];
 
 	u8         reserved_at_e0[0x20];
 
-- 
2.43.0


