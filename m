Return-Path: <kvm+bounces-5222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB10D81E0F8
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:43:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC0621C21A12
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C23A52F7E;
	Mon, 25 Dec 2023 13:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K2jI58W+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3DA52F65;
	Mon, 25 Dec 2023 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k82Th7v9OGKBtC9YoBy0Gz74hbEK7nCz7nniyeFiSEB9b9LeEC799/w6aCegW3dChLAjpYarEYoJTmyCcUr9ctImqoCsn4FU4UNL56mqfdAT2zqFAgNY+3Be06Y+U7hOSSDed4tUudxEcvbhQDE2oUVFMI5rEB850wAYYdjkjkdxIQ3vYitwjvoNYt7HP1zIxEpwMlBDGvHGf4hQP01lgxgQCv0kEo3KYYNI1bZfeEOnfncIvtR8dHE+Xbjyyfrb7PI4ezsAAt7Vor0lm0tVV8qyca6e7DtnwsCqhNN5wXThVIeBbuw8I+Vp5hakznlLMcFbBS6o7lBB7Tifif+K0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvaJ5qRnej7WGFnOQvn9JQGmb6CfIBXSHf6q8pzSba8=;
 b=aYQ1ix127thdRPv943CNOw+Q2srKpWWna+bSHCAB+l1jkdYAzr4VBYY5vXl+lEmVyzaLETr2vKAHah/rLcBPt5W6LrUyOtINLUlgojucYJD5BwS1EGKN9LLQUA4/zl7djQ9YKf8OJY9rncTgfucyIA48ZZzYeNV9GQIcBY9aItztRlTLSmmgOXDycMwAuVQigEzOczaDFdCA8Tcoxj9iGkIyB+CJG+WVh64Y802Ppp+3PQ/SGletkqKiT8xg+PU/aUpqEAHtpufY6uoRrjKOdoM/eYI/9cUPAJOkdgp47RwxVqzq5Zu4DxlOWZCyNhHrfxKMsmLZDFqcGdafzT/sTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvaJ5qRnej7WGFnOQvn9JQGmb6CfIBXSHf6q8pzSba8=;
 b=K2jI58W+4BgdyM0Y72bZ42vfyLGuI+Q55lgj173ebKxm+nXT39vDKSNgKI5AitFvy0xzF/zmmvmbEm0jdnYa3I8aXP2MSAUK5FoVp2A2xOJCrccfPEilo2/jefUORa7Wiofdw96Y+s4BGThTN1Y1gLky5TKOR0/hZ9VJNXIyxsm/OGAbk6+Yh3htunpRrZbxBgQI2LBNjw7qUiS+ovqjWrHGdm+DF8vP2C/zdA7dtKCRI9wFUA4/o6y0daC6eYgcV+Mbg5htxO7RehXrdvcRx2T4kAq/tSmYOh7+64/Q+M9fDyO4TUZSRVEFzFA61RCT0pxhsy3vjcAHMox6mD22Uw==
Received: from BL1P221CA0028.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::18)
 by MN2PR12MB4423.namprd12.prod.outlook.com (2603:10b6:208:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27; Mon, 25 Dec
 2023 13:42:35 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:208:2c5:cafe::9f) by BL1P221CA0028.outlook.office365.com
 (2603:10b6:208:2c5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Mon, 25 Dec 2023 13:42:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 13:42:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 05:42:19 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 05:42:19 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 25 Dec 2023 05:42:16 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH 1/2] vdpa: Track device suspended state
Date: Mon, 25 Dec 2023 15:42:09 +0200
Message-ID: <20231225134210.151540-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231225134210.151540-1-dtatulea@nvidia.com>
References: <20231225134210.151540-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|MN2PR12MB4423:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c480dc1-4a9b-4518-64ec-08dc054f5a66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xPx1j6+n9NX8/g/JphRNgo6YMJQwSR6umMTrRBf23x9MR4GlRbV5kV57if/fKNyBKqN7aFCC5EAEoOmtO6fZy0QrlvTWnwXLjoAOsy4Faj1vJ5m44RUO+ywqP7K7Cb2dZ4VDMY5LNpS8XKx/IcSgOJO703B5bx+VOvO31e9nhrWfYKp4K5Gu3IglvXzrTMeDsqn8AqRaMn1rZ1Pyl6ZS7167eh1BXMSybw6yLN8ZyKEPhrxXnqsd2SPrs9IV5c5w1AgXaf2Ug/zLP1H+7wH00x6ap4SS+JQ+NfppxosBPZSUceEFOkPvHcb0m3eH1xm4TOoSoHv2PADVWj+wq4mumjC7S3zW9RVAbBk8iFA6mfoGkfX2A87KZSowRCca7FHwAZffbP8b9T6+1pSEmRe8VXQKZGtQydTSfD7a7SxXPChH7IuhL7mETpXRWKuPwP4GyJs6dSeiaSHZSTDtxjdSBa09V0ZmZGaSlOrs1NV1okRZWytN0qHh2aFMabsNdsSWkVgI2mrvISyu8imSzlW9dNjxKj2u+cZuHGcNJxzIGhUw8G8mzSV0I0agvDR/FmRMVILJJE0+dxUQagvKe0X8MHpMKIkT7KRezAzYXNUMATCYB2+hzjaHZPO2meHTZ5wfm10WembtR8p0FFoIOzFO0nT2omaZn6qsfMeSDUh3MEQe1uXHtCypwlEc08Rzi4+sUwjXWTAypWgGsx9kst/Fbz2amOPDRHoHtq1wAnV/MJ0naiMDonsJBwpj2g6i865u
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(186009)(82310400011)(64100799003)(451199024)(1800799012)(46966006)(40470700004)(36840700001)(40480700001)(36756003)(40460700003)(6666004)(6636002)(70586007)(70206006)(86362001)(336012)(66574015)(426003)(1076003)(7636003)(356005)(82740400003)(26005)(83380400001)(2616005)(47076005)(41300700001)(2906002)(15650500001)(5660300002)(8936002)(8676002)(478600001)(36860700001)(54906003)(316002)(4326008)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 13:42:35.4795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c480dc1-4a9b-4518-64ec-08dc054f5a66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4423

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
index da7ec77cdaff..4c422be7d1e7 100644
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


