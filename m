Return-Path: <kvm+bounces-5223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F395E81E0FB
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76E4EB20E1E
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B926524C4;
	Mon, 25 Dec 2023 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tUNwWgwn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4020F524A4;
	Mon, 25 Dec 2023 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ls4cTceGbRUxSswUyDh0mkQm1HQgQ06e+WKkaH4Nm/cTLja4VUeRe+s5GJzYX6S9SCWFguNj1aGASq5XOGRRIe65zmxDSQp9X9RlfjGZft/rdsGnXYFQBALfyOeg8uBQfwKkIGekg0qXy+BDpipMLwMppyKa47SqkG7HwM0sQ5Vs+nmuctBd32kP4mEU3YYktoboE7nB9v6XiK7DDoHLsM8YW8HsQrXKpwArni6XdQV3vw89nUmC2bZ5U8PD+K/3w7IR39NRTLIF/bmAzL8rq/Xek2a+UrwO7o9X9HikAA3+f38sKE9YUMLwPcgQnxyzO8EzQqRPwbrfymlnqP0UnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBfyYSvTtsV8U/bPOwpFxpHHQ3hgt4hXnhFlHJScCx0=;
 b=VHcDLUaf2Ewhj8kHyBRzPClgrf5mvJmcVCt+dIPNF4tfSuoGTf+/sbtxB92qZEHn+eRjKMBsvvRaQWZirVYLNO6b0z1GqkLUXg3Fv1Z+EQLZyJj72eEl1o+q+6JB0JS1j0MxFHEKnqUn1OTP4LZe9JpY0dntZNLjfLlG42dn9WVjVrLXEDZaMYwVsMraySNjAbmL6H58BUr99QC2KNVEbOp7Xgpr9X+uJrxLOtHzpG2rJpIVzvWeC23Fqx6iacaq9VmQkR+mOD4r7jW9JZyIDjIHb+jjGOG2H7VmmiXz54X9YTyAyZ+pRvFZ8qXnEiYfjr0fnYefs/MWcZmWVzMOkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBfyYSvTtsV8U/bPOwpFxpHHQ3hgt4hXnhFlHJScCx0=;
 b=tUNwWgwntKo7Lmte0gKhvz8Puhz40buvRuA2SKVLiLfZVOEI4rCMELon8x9WtXQiZXO4KT7fXfM4yR3/4Nu+TLB3BzBPf2DhruozbeN8BAefJF8fzTnv5vADDraA8Lrpm9bMeX+y6Zc3cxUTQOTaSXAqNOiWkzeJR1iFUP57cfvRUoKTfcAOSoSCrQmLMokCmE+pDvyyk+mSaOUhEC7xbD+XuHJOYOgkmyWyp3cu8b2TDCBoSRhhCXJPfdKohobwUMftDOE3b0/aiU2NCXx3lDmsS8aKMbZ23KDZM69CeOJC63niSTvjcfwMjKQTsH2lwnerI9VEBs7EIwL0fETq0g==
Received: from BL1P223CA0010.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::15)
 by MN2PR12MB4517.namprd12.prod.outlook.com (2603:10b6:208:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27; Mon, 25 Dec
 2023 13:42:50 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:2c4:cafe::32) by BL1P223CA0010.outlook.office365.com
 (2603:10b6:208:2c4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26 via Frontend
 Transport; Mon, 25 Dec 2023 13:42:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 13:42:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 05:42:38 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 05:42:38 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 25 Dec 2023 05:42:35 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH 2/2] vdpa: Block vq property changes in DRIVER_OK
Date: Mon, 25 Dec 2023 15:42:10 +0200
Message-ID: <20231225134210.151540-3-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|MN2PR12MB4517:EE_
X-MS-Office365-Filtering-Correlation-Id: aeed7c76-c2a4-4168-7e95-08dc054f635f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RwbPnSBdoluD3T4nF7Ew2ofQZc6V8Hpdl+zgworaKrzwoHaAhHC9ElxhLSRJDf1wA8W7p4QEMvFc96gFKuhHAU9exgGAl5ppgTs6qhls48RcqmaETSNEB/glOs5A+yPVQTbA1VOS3hwYP87OgOBOSy9RDMljRFoB/7pSaNoa4bCLQ/n+BkqBGzScxBMzi7rnmWiobYfLKQKhq6BVh7C+MH3yfnua6XApRy0BFSVPu5P/uMiZXOPi1ghKx6QZCk6xAiF/xghiIaZS7n+AJSFp+w4BjyjgTZgjIJ8dy/njdiR8E3OjIiglpRX0BKx1IpAgVCVI1UVkxLnnwIGtroI66UxcjZgMNc6og1QGD7FUGwUJNWyKHVg2TMM2JGB2POwvGRwrLsD1y9YECWnk+K7xV6kBJNC/6rWzgmtBuUMCQfg1sFOniaeZg/Sdsio5qvuInvErNRVjqyae+LEWxrmIU36WgGCFz8IPmGgcMg8tJRfJPxvuM6LK+7d3bnJUS8ebItJtF8lAIQkP2waVavCEWH7DxT6lL+U4c8LS1kFI9/C6spjSiBs8t7Jw5t43XElBInmyNv6p3OTCN81wyHVChJNKJU1B6obKiiQ0ovHb11GWfMlLZTLmo7jQBjiUnfUJTnpbya1iGYxdXgNyjRQ8FwybE4gU98Iw9YWnEVFnap0EO+bPRooQmDpryWOZzoTCBlrbFGqMH7J2ii3XGPBujVe/ZEi/tz6v/RWbSAWWeg79fFijmzpSZtIjjqb3w8Ym
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(376002)(396003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(82310400011)(46966006)(40470700004)(36840700001)(82740400003)(7636003)(356005)(83380400001)(110136005)(6636002)(70206006)(316002)(70586007)(54906003)(47076005)(8936002)(4326008)(8676002)(6666004)(66574015)(478600001)(1076003)(26005)(336012)(426003)(2616005)(41300700001)(36860700001)(5660300002)(2906002)(40480700001)(40460700003)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 13:42:50.5494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aeed7c76-c2a4-4168-7e95-08dc054f635f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4517

The virtio standard doesn't allow for virtqueue address and state
changes when the device is in DRIVER_OK. Return an error in such cases
unless the device is suspended.

The suspended device exception is needed because some devices support
virtqueue changes when the device is suspended.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 4c422be7d1e7..620073383d15 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -703,6 +703,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 
 	switch (cmd) {
 	case VHOST_SET_VRING_ADDR:
+		if ((ops->get_status(vdpa) & VIRTIO_CONFIG_S_DRIVER_OK) && !v->suspended)
+			return -EINVAL;
+
 		if (ops->set_vq_address(vdpa, idx,
 					(u64)(uintptr_t)vq->desc,
 					(u64)(uintptr_t)vq->avail,
@@ -711,6 +714,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		break;
 
 	case VHOST_SET_VRING_BASE:
+		if ((ops->get_status(vdpa) & VIRTIO_CONFIG_S_DRIVER_OK) && !v->suspended)
+			return -EINVAL;
+
 		if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED)) {
 			vq_state.packed.last_avail_idx = vq->last_avail_idx & 0x7fff;
 			vq_state.packed.last_avail_counter = !!(vq->last_avail_idx & 0x8000);
-- 
2.43.0


