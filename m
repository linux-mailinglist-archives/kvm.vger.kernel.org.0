Return-Path: <kvm+bounces-4856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D5F818F5F
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 434001F29F0E
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F403EA92;
	Tue, 19 Dec 2023 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c2DRyu8c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896153D3B7;
	Tue, 19 Dec 2023 18:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fS3n2aoMkbtfiLertH9ft6Vo/HVHxQhOWjMDv/ZwV+qtIRi8eYIfziCFL61QMycWGF+YDKA2eavXTTRU2xHXCUQHeeWKWU6FBSbHCYpmTFYlN1jAKo2MjtPxILj4PffkOp+ibgmlQFr6h30gsG9mE2C02tOodCCViR/n/LTzaQoV43FWBlo+foi3HUbA/TGFWBC6jIpA7iYmr/5B5PwnkzLOqnPozLwbWAMZuPq3PhJ8g9yNsALnp0Lyh6Aex/33j/HMU1JfOUXA0SVJZOL3dBVJNtvr3M5XSxlwtsVHQ9WGgZurUhZ5so5uD5OJhZ4kmvGWWU5Mk5hHsQq6EfanoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QIfSBnXmuVIqu1lAUk6iMnr++Wfajo5Pv3OFCXdv0GI=;
 b=alBkkNUNelnnXkFgBpFxFaQwz8hELS3GX2gRlo/yeekb1LoWwH6z+r1DEFqGPOEzz2/dZOwRQg5F2GrZgDq8E/6LIdJLb0xXTESgvsAY4DX2nJOHpufd5ngJN4XS3QwAxkR5zO4t/puQ1zu+oE+QKBifgJxee12qg10quzrDXLPBcjX4oo2DQ3URZodW3wYT1TRTgSrfkLDKb2/ll4uaTQmvx9RRIgn6pv+LE6u3F3/BHEYf1B5ffhPiZX2EXpHgzWsG9YO4XQ1T8bHlGBAvX+12InpaxweaW9O2D4rDXG8ZGQbrhT5d8HHqlMqY6lNcgs67LnDiZ+T0Nz0PjgI5dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QIfSBnXmuVIqu1lAUk6iMnr++Wfajo5Pv3OFCXdv0GI=;
 b=c2DRyu8c6iBgEkskiy+nug+zc1MFX5QjBLRqXMiwpKF/cTT1tqgy8j9T+ALQs1bhhICb0Pjy8GWIh7adYkCpUM7v8+1SWgm79WURy8omqVPeaQiiHQaIgq7ApBwyBhKXcyuaGfQfMF5zMQsdg3jZkEcfK5uiwUHE5o5FyN/b02vhPCwooNFwnPVV2KeN+fGT+nAB6C+b6/fE2QOLIt//8IKj/JAXUHgrjqcfk0QC/7uE/sm4q2xy9E7eS0ffbyREjp0EEcG/j9KQkxDvBaOBVp9irJOWMv2xbfNeFkdgejThNdXzeZP1AiekWcuHGrF07AnsbzwgVPQSvuU110EZ7w==
Received: from DM6PR03CA0084.namprd03.prod.outlook.com (2603:10b6:5:333::17)
 by PH7PR12MB9222.namprd12.prod.outlook.com (2603:10b6:510:2ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Tue, 19 Dec
 2023 18:09:39 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:5:333:cafe::81) by DM6PR03CA0084.outlook.office365.com
 (2603:10b6:5:333::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:39 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:29 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:28 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:25 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 06/15] vdpa: Track device suspended state
Date: Tue, 19 Dec 2023 20:08:49 +0200
Message-ID: <20231219180858.120898-7-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|PH7PR12MB9222:EE_
X-MS-Office365-Filtering-Correlation-Id: 940319ce-a940-4cfd-2d59-08dc00bdab00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tnOMGzmrt/bHF/+Ug1DF6OYO9Gc6NnX+7juJ9uw0dMVcqLzfLx7ZdYVxZkVlC3zlqyXomP99QdwJxcf1a/p7/CUzQKaoWR6+ozU+VY3Su7b2Jydqhq9lj5Y+9rbFwZ6pLqHwbF6q2TNcnB8A+Vz6hlQE7tHUK4oXBcVBXIDtfmD9AG+YwUT1oRrREoTczBmixy8FJadpNLkxT/8BZeeIlgl3hFjYeJh+UgLs4a67Q6X3b2X6qRTER6DyzKKcBH8G9DmznW2XaRIKn80WN4HyI9OYSUJv1dZHDdubzHZp1sDULqbSTuaot7+hN60wTiJ/lQFvW9zB5DQ34uS2BH9mfgIq2s6FmP8Q5N6pUWJrIYM9nAGsJrab/mxLC2JSLuVhtZJiBNMnq2MXAzg/ZSWv4YZOXUYmaVeyODH8w4Yb8U06b1cNJ0TYpssIhq/rtQJGv8/oWeMbSJ3RHZnAAnaRsHw2Msaro0hSj2lgm+nrnsFDDDMvDwDCOTOUmknqq4TK4QPgUCRy0jcp8IrLPsV0KiRVjMnu2e+drnODWL8LvsW3892LxyRjeay65oW3ClAzFcn3kj1uWhGA6Aknx56lkxALRSJkRKyXWh3gwzazxEPUhTtuTXXa6GmzgtW+u7JRz+hkW3+scTYIgWUD5h4Ddv6IVzP7NxRVX+I1WQeV9ixXSj5WF1cWiidH/xT2AtRP1uniJ/uK64dE+txdv4DFauh0Zz9tRA5iF1d/oKDbMPkQnCwM/7waJ16z0QrxJOYr
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(346002)(39860400002)(230922051799003)(64100799003)(186009)(82310400011)(451199024)(1800799012)(46966006)(36840700001)(40470700004)(316002)(8676002)(8936002)(4326008)(6636002)(26005)(478600001)(2906002)(40480700001)(40460700003)(70586007)(54906003)(110136005)(70206006)(6666004)(5660300002)(86362001)(83380400001)(36860700001)(1076003)(47076005)(356005)(7636003)(82740400003)(36756003)(2616005)(15650500001)(336012)(66574015)(426003)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:39.5939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 940319ce-a940-4cfd-2d59-08dc00bdab00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9222

Set vdpa device suspended state on successful suspend. Clear it on
successful resume and reset.

The state will be locked by the vhost_vdpa mutex. The mutex is taken
during suspend, resume and reset in vhost_vdpa_unlocked_ioctl. The
exception is vhost_vdpa_open which does a device reset but that should
be safe because it can only happen before the other ops.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index b4e8ddf86485..00b4fa8e89f2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -59,6 +59,7 @@ struct vhost_vdpa {
 	int in_batch;
 	struct vdpa_iova_range range;
 	u32 batch_asid;
+	bool suspended;
 };
 
 static DEFINE_IDA(vhost_vdpa_ida);
@@ -232,6 +233,8 @@ static int _compat_vdpa_reset(struct vhost_vdpa *v)
 	struct vdpa_device *vdpa = v->vdpa;
 	u32 flags = 0;
 
+	v->suspended = false;
+
 	if (v->vdev.vqs) {
 		flags |= !vhost_backend_has_feature(v->vdev.vqs[0],
 						    VHOST_BACKEND_F_IOTLB_PERSIST) ?
@@ -590,11 +593,16 @@ static long vhost_vdpa_suspend(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	int ret;
 
 	if (!ops->suspend)
 		return -EOPNOTSUPP;
 
-	return ops->suspend(vdpa);
+	ret = ops->suspend(vdpa);
+	if (!ret)
+		v->suspended = true;
+
+	return ret;
 }
 
 /* After a successful return of this ioctl the device resumes processing
@@ -605,11 +613,16 @@ static long vhost_vdpa_resume(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	int ret;
 
 	if (!ops->resume)
 		return -EOPNOTSUPP;
 
-	return ops->resume(vdpa);
+	ret = ops->resume(vdpa);
+	if (!ret)
+		v->suspended = false;
+
+	return ret;
 }
 
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
-- 
2.43.0


