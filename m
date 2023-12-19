Return-Path: <kvm+bounces-4853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C540818F57
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B8021F28F88
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F3E39FE0;
	Tue, 19 Dec 2023 18:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tkKuo4CE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDD139ADF;
	Tue, 19 Dec 2023 18:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXfc8hchL0+v6aNC9EUj8K/UCNAjztvhVN5wJ20zSc3x7wK6i5Ks+CE7SJy0QqXWjVgklI2zMeiaWnpY/vBFLFek8kkCaPa+MzM68Brf/oLhaasOkol+umFmDadK1jouGYnO45ftEn6qdLhDPwN78iX32EII7504rrUMDbruPqBKmDPkekOhAv3HlmwaZ8J/OOCXcyOFf0CO5BjvOwE5jzKIBpkGr4gjIX9LnkRzqatXx/XfC96L/hgKGWAr5nij2xMSZZxkTT2hNisdSGGTsH1pWuJoq9wXD5sV7ehm6FV7V1HsupRmlIor3AAsbZrrPiBgR0BbKWWRPO/+vJDfDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFTHaY9PtUATO1cmPdLknCzEq/FUKk+/vuKSvCcAzAk=;
 b=C2YGIuDbIx/6hwdFS+bXK43xm3uK7bZn/1Mbm5JtyNG0Ku6sNpsC+rrvshp98eyhvBHre7TeSnGqUV9dLpfltsXGrgmLZpREWZ5JSwKhwYK7bhpyoMnRB8NrtOomoQNGLDAz6K7+CA3vUGQvOt1GnJGQfj4v55vdQxtp/A1oVOfMv6boNT1/hSCPC+ggHXe2FgTmHWI6ohfllj1f7P9sOflXCO4XMaWnkpp9hLEppNRUcWPHkH5SEBXRXkfJMyiicwZGJNOUpNyVh6oLu0werI6D7QsbQcNlTZyHZsfFpNd6vgZ6rjVPyw5+S9jRfOJx2o/ELRn6Hlut5BpaIRdovw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFTHaY9PtUATO1cmPdLknCzEq/FUKk+/vuKSvCcAzAk=;
 b=tkKuo4CEWQoCKg7aXdBG+kGYgXaWi1y9r4KzEkKg45WO08k4tcS8DbR7DtNEAQjk/BlsvCDlAeqCHEkUvHQ3x3a3Y1qvR7aoszCeIriqWCJEdjyD/t9Lq1ron9U+jWGPVmTRQf9+CH3OXzVbo3I5KqE2iX7Ov5S3jExcf6rLUM0cmtN24MyZ9XmYRjM5YghA52bJHmYTd0aBYFOPYasomBliHj7hqrEt1g1Y4p6UXJVWaIu2Ef6z2Mt9v1sc9AKnhWOOFggavl9/6FmgOQXksQNuxLBDVNJgVxRSxAp/f0pa3uj2uLK2W8M5RrwCe6NK46WaDZ4jxJoHliuiMdmSPA==
Received: from BL1P221CA0003.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::9)
 by DM6PR12MB4546.namprd12.prod.outlook.com (2603:10b6:5:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.39; Tue, 19 Dec
 2023 18:09:26 +0000
Received: from BL6PEPF0001AB72.namprd02.prod.outlook.com
 (2603:10b6:208:2c5:cafe::4c) by BL1P221CA0003.outlook.office365.com
 (2603:10b6:208:2c5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB72.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:26 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:13 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:13 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:10 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 02/15] vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Date: Tue, 19 Dec 2023 20:08:45 +0200
Message-ID: <20231219180858.120898-3-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB72:EE_|DM6PR12MB4546:EE_
X-MS-Office365-Filtering-Correlation-Id: d4e7cc82-c982-4f55-7be0-08dc00bda317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	onUa2fx0UvWyG6ApRLkSf4/fc/VAGqo959+wNRV0SvK/E9InpGxx+wDU8RT7/IykFPW7/GBBf1kvWIzqolrAnuLw/9SG01FyfDt1SDEsVFesjRPy++uB7nnosU7nKOgzWKGT/34ez8zMdTT29cvpAtFesPlkSid7D4T7Dh+RkDwrtWz4B99OE1YlOi6H801PKcK0Z9acUW+QhN8glp0z6PdWMNUbOtM2I+528Ev1DoswsmuWDZ5ay9XAJo9+qegqsjHNvO0AXz+ucbInZx9c7Cx5F6nU+kYDnfs8Ru9He03bJPdWEyYnCQEEvW1Ss9cFBWQ7wLq1gO8VJXSUT/pqj08IKt3PsXyf8utWg/f5pJTRXO4v1RrzaJ1SPXsB6guwSgkOhrUHAsPb7aFU27AM19MPAEvzM1mitlDhPrjjT58GwOn100vy+RUojX6ktlPLDaWFHVXQoOrIVovNmyU8m/fl6CtfRk+xQyB5fW30VRFqbrgkWEUsaRMhs1WJlG5XuNBYNQXtkb3u8o1pSKmDndLO60MszRrawmQH7Cxe1t5LToyoqLJqSvcdq5HGSNe6KXMXE7/qX3nX0lS5lIEkBW+XhNBJMFPp705mfv1oSe2TYtFTnSXMN9fhKCT2Y/UbMdM9Cc28dfs6vYstT+QGG3vwwTIE7u1XJ66vAU96gOFSVaw3KTfqqSc0NFq6BJQLV1Lif9YUErRz7VKFjexErwYVwwyZhnrkTXIljAtfirSJ1suLIScdUfvSyo1icmWa
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(346002)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(82310400011)(40470700004)(36840700001)(46966006)(36860700001)(7636003)(356005)(40480700001)(47076005)(40460700003)(1076003)(336012)(426003)(83380400001)(2616005)(66574015)(26005)(36756003)(86362001)(82740400003)(6666004)(478600001)(6636002)(316002)(54906003)(110136005)(70586007)(70206006)(4744005)(4326008)(8676002)(8936002)(2906002)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:26.2936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e7cc82-c982-4f55-7be0-08dc00bda317
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB72.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4546

The virtio spec doesn't allow changing virtqueue addresses after
DRIVER_OK. Some devices do support this operation when the device is
suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
advertises this support as a backend features.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/uapi/linux/vhost_types.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index d7656908f730..aacd067afc89 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -192,5 +192,9 @@ struct vhost_vdpa_iova_range {
 #define VHOST_BACKEND_F_DESC_ASID    0x7
 /* IOTLB don't flush memory mapping across device reset */
 #define VHOST_BACKEND_F_IOTLB_PERSIST  0x8
+/* Device supports changing virtqueue addresses when device is suspended
+ * and is in state DRIVER_OK.
+ */
+#define VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND  0x9
 
 #endif
-- 
2.43.0


