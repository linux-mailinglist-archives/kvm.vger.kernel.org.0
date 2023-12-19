Return-Path: <kvm+bounces-4852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A56B818F54
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8DF91F28B84
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4489D39AC8;
	Tue, 19 Dec 2023 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BJ0ppR6i"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E977439854;
	Tue, 19 Dec 2023 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oq5LLEuAeRq3w8+CyCdQQ7IVzBqUIpL0H8GEzwNQSuRk68GYMFhKtsBp/XpAG0PSUWiw4ujjo9UGY1VW8Ud31jQRb9RgRe3nqIhD8E/VS0FA89dnhWlOkB0oYPTOTnrkgSWU3KCZSk6ehhd/lDUYoKG38tsuHu+Cs0RxSup3nIQU54yGFwrQxxw7O2f1yAQmt8BaVy81KVp6f8ihcnvcdl4fkAopnnmv/l9IKmxehV7osrVK9p1ecLsUmvJ+HVQoJR501Lu5DFe8sF19nco8Sh1HfLxmcG/tg7xdN6KJT6xK/E7843zqb/QIWoOePIB91AXQuvRfOWLkYCiakpIo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfHOQCLFJHnJBlBhyduPWB5HBqN4yk6hN4g/bB/sNgw=;
 b=VLHyWypmAD0iyyrHjAAn4BZjku9U33QD9eWWgt4Xjl/PbY0T4QVsTnREE5iXDzK1kZZYwcs37BDOeADjR8KSDCgPhgyAkWSN50CIAu1gFH6kuRhGtv6tks2ifcOWEQrHBtPeX2qLd8r3aXrjNHsr5bHOsm56nFxxYsuptNMkh6th05cHqAy+9erFYQKNZXZPRXiy2uDFORDqSdbiF0c43OEl0BlVZHNHkGmad3MhU6S6PI1vR1tcBqfMExfewre7D6aK+SiGNdOQbOntiZSWrP97nphRffgsba2lHvhy1dFNfeLWPW69U49JOUTBrhuu+u9rbS/eCToPG7BcTDBkeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfHOQCLFJHnJBlBhyduPWB5HBqN4yk6hN4g/bB/sNgw=;
 b=BJ0ppR6i7QUSld338BqP6rvFYB5PVrMNUJVn+BlM1waZxDNP4P2CvJJ+JAY2Md1QbNJ2vkSPraX21JOQ4iWK5ICbymJ4gQI/fxu+grusZF2zuu1WTyuqNKl5oYjGP+/XbiK0uSG66N5eO+PQeleGqp6TY8cwRRMgYA4azaRXWt/HqMIK7V9yA6IKx6uUqPqgAs2ij9hlEzjAOzzq8waNUCjzHJiA7qXU9pNPZcpjYrthqpK+qs7auHRu62Nblacp2YUg3FLmPZd5OyZmd26PJtpYmfsOOrxfZ7FvO5GaoK1e9G8sSeq/1Hzo/UvpMGGaTWX76HPvFxfRuPDa6nrDNw==
Received: from DS7PR03CA0269.namprd03.prod.outlook.com (2603:10b6:5:3b3::34)
 by CH3PR12MB8305.namprd12.prod.outlook.com (2603:10b6:610:12e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 18:09:20 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:5:3b3:cafe::1a) by DS7PR03CA0269.outlook.office365.com
 (2603:10b6:5:3b3::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:20 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:09 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:09 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:06 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH mlx5-vhost v4 01/15] vdpa/mlx5: Expose resumable vq capability
Date: Tue, 19 Dec 2023 20:08:44 +0200
Message-ID: <20231219180858.120898-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|CH3PR12MB8305:EE_
X-MS-Office365-Filtering-Correlation-Id: e189d0be-b292-4287-c46f-08dc00bd9fc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BiX/i7bsBjL0t8T3XDEl3fJmvZdUcfKuCZj0nSd32cljh7ZLLV7GScW446Hgb2bG2HMttvGbeMM5ApfsE3Jg2106kYukuhmGM8fizGAATvzirFQJ9vwzqPdPOhAP1tNqv0+vlcTHTeOWhFEYuq4gmoyvOmKWcu06EfMgmWKQx/QtGRne31gltTavsJs23KZy1dPa2cJL8lnZAcNAUf5jmoFGLppAnpMYCTzHXUQ2+NBx/6DkVwCDi5Ft2qLFF6cNtuFsU9lletf6DNahkEY0vZtwNHblv695AV/SDIod6Voon/kF/GBVUD5ZIeBQJf+HR3gz4nswtkdvTPkBNQM19EUxhhw1qE72U8NEJADVfIabCJ7UZ9A11hAi+DOc21FVt7TZndPvrlj/JzgSbomd31ZsfYENzB9ER/OZCxRLanJQPcZeENxaTZ/wi/uuuG2gAFJan/gRdVFAl78ema2qMA38kJHpYNScv+LF+IhXRvMijIi8WIvzyhNt2g+OpH2dJZr37/3uvsgOMzojevRJMeNHDjyqhLnMLWTipY1UfukxwpszYnbKWEFzKaNa+Yx0MLL1CVEgr/7kEiyPrDqRrLBx25eFEt3gjlvDiVWiDWK3sKDeEV8p48wgvYKU/z/9x3VmBv7QRJWihJ7TrCw0YD71ipiYoBTpwh6EN0flDYu5oALwIfPgsFOwkn4nAK0elSUja0g+mx5AbvKqVZB5WsEZmkL8ikxp24sMOBtbd0XXdCj1Bw6i8HIAqEWmSsyh
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(376002)(346002)(396003)(230922051799003)(64100799003)(451199024)(82310400011)(1800799012)(186009)(46966006)(36840700001)(40470700004)(36756003)(316002)(83380400001)(40480700001)(70206006)(426003)(336012)(66574015)(70586007)(54906003)(110136005)(4744005)(6636002)(2906002)(47076005)(4326008)(8936002)(5660300002)(36860700001)(82740400003)(6666004)(8676002)(1076003)(86362001)(2616005)(26005)(41300700001)(40460700003)(7636003)(478600001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:20.7849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e189d0be-b292-4287-c46f-08dc00bd9fc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8305

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


