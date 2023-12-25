Return-Path: <kvm+bounces-5230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC6E81E148
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2910F2818F6
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7EB537E5;
	Mon, 25 Dec 2023 15:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lBryqk72"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0445052F78;
	Mon, 25 Dec 2023 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iskEjZTJxHtSuW5ECl7xQdVf2zjE7+otAJUgriT1p2tVubKCI3nlmn58L5fVKD0ur1NgfKmhzIJba/C1qjO45T1atNvYPfyhrCjUvhU+55VijUzwOjbkCO69UPFfa0mUFuGG2/B+yDz2+tk4gXcDoboZT8dP+qBUFQcEMQvHS/41vuUreGoymjJkL7SJ7+MiZt1MNFQKEL1YIPoWCq7ifDxV/5OOcchYKaaq5hunLqFSlp0UQtpzivC5gcljtJluO1ycXLczA/GtS9wQfcBrc5J3utmMdu7ToaPr+gnE/Js+Dwn83rETm/uFQRwQo+qZUmCL7HJqPIznVtzxpx6g3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfHOQCLFJHnJBlBhyduPWB5HBqN4yk6hN4g/bB/sNgw=;
 b=Fg2pgD6fr1vklDleYjr58s4k2aNz+789jrOmW6HZ01VOcDRC6C13Okiq7kG3UCxZ5U9SUbL4s4GZ6RNAPWq0ZXOH/V4zumSIzqBPPkG+lpjBDi6PA0Q7k5YFseRiDOEand4g45FvAcVRS6wRLkf8Ab5FbNdksCvKwwYBb87gfN1tXky8ibpdMDbQAxgA3JejAkpYnJ0FD8mMS7ayEpB5oPkl3WJsC9qAI6E6/iU+DhFEkUmxMqQfFHfYu9tjow+rWSRYB6dGTno1P6o0ouh4ruqbH99IDek74OLVm/dGjPRIp5DelI82lrdx3qOfnpwHWoVKI+siGoQqD5Ge4gI+sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfHOQCLFJHnJBlBhyduPWB5HBqN4yk6hN4g/bB/sNgw=;
 b=lBryqk72be9TSXEHLSykRXCO2i8i0wCpyXUyy3NiRd7bXZTfPUd8LY1qujGdJv+jhAr19BOtZuokBHOoMaWXDUx3w+kNLppxcaW2rGDKitqyQKe2ee8p/Muwf9Cmi0b2WNTSgy3FC1Ug395e69VTGnqMA5EP46vC+rUtn/RU4b7sOFJKcmc0PHj+4y9WYkzKsnn6gjAYuzxzw3oLVtAqwVFZmNpIXDk9d+BTN999p+NRI+gzegt8tOCG8+E24/88Dx1VlbXElyrv6PfLvZv2fHbC/Ooci6//rNttdS+81a44Mu5FBHLyXAJeN5+CPa5RUJeD4GDhhYquJ4mRFhqZow==
Received: from MN2PR13CA0019.namprd13.prod.outlook.com (2603:10b6:208:160::32)
 by CYYPR12MB8653.namprd12.prod.outlook.com (2603:10b6:930:c5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27; Mon, 25 Dec
 2023 15:12:20 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:208:160:cafe::4e) by MN2PR13CA0019.outlook.office365.com
 (2603:10b6:208:160::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.16 via Frontend
 Transport; Mon, 25 Dec 2023 15:12:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 15:12:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 07:12:11 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 25 Dec 2023 07:12:10 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Mon, 25 Dec 2023 07:12:07 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH mlx5-vhost v5 1/8] vdpa/mlx5: Expose resumable vq capability
Date: Mon, 25 Dec 2023 17:11:56 +0200
Message-ID: <20231225151203.152687-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|CYYPR12MB8653:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a3384b6-ae4e-4336-130a-08dc055be434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lYxNVcwBxJeeLDR+aUjeO9D9vkngNoz8u7S2bVxnYc8uTNlkA+FVt1+tup/F/PAAtB2GnxZnxQFTWeUIGRFiWNPRM0hkOVQtUOVY765TRpPW6vMd+iCDV6M94XUJCVwNJK2EeduBn+k2O6Aw7kwJIO2OPsUeK2NRHSIXDIej4xjVIIgutuso2jv20wHsYIck1DelhZxNZ34Xv30XyJMmNuQ4IR6eBG7JCOuyJsmGXzY3krDXamwePBNry3hTXsPJWfltwFzyXcK2gLXrzl5z58BYqMSt104EVc2+Fh/DgMeJOYyszMxbBuAadLjwHfOIcuqzvXV7T6S2R4+EOjUapuxer8BoFD2q8BQjAYIfMYXiI+hONfz3meTbayaYgjdlyjECuQWnx+GJdoza6AuZAFSkeyJTovKOHnFGDEeB8CchXKcrAQow4bhsltFGlCP+7YAvYok1V4QQF9rvqTibjDih1DOiCw10pam5AsI74REojd24Mg7oSeY6+OkzPMxbkNIPSw4U35bSE2D25TIx58PzHXZjbySV395zojUWmjsPwr/H2UigKUwR55DZmSWPvdlb+4ExZr+5goRikaZFNyE9qJ2NHqYx7RTfY2RFY9ZLkgT+jw+OwjUr60+6Ik8DhQZUwj0iyHkM3gd2QMgBhy3uB62W8eVIQJQAYZFrScdX7IZN5TtS0xa/4mI49FiQbaBlD8Qf/VJGYBJrYQvI6xjTfWbVb+ZxZEAScJ2t/EMFVjV87QqCbKBn7pNZSqq2
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(82310400011)(451199024)(1800799012)(186009)(64100799003)(40470700004)(46966006)(36840700001)(40480700001)(66574015)(2616005)(26005)(426003)(336012)(1076003)(40460700003)(86362001)(36756003)(7636003)(82740400003)(356005)(47076005)(83380400001)(8676002)(4326008)(5660300002)(6666004)(36860700001)(110136005)(478600001)(54906003)(6636002)(70586007)(316002)(70206006)(41300700001)(2906002)(4744005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 15:12:20.6517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3384b6-ae4e-4336-130a-08dc055be434
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8653

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


