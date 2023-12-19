Return-Path: <kvm+bounces-4858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A34818F66
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3BFFB2368B
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B7A40C1C;
	Tue, 19 Dec 2023 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mKUth2pU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78540405CB;
	Tue, 19 Dec 2023 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTpCiLdYLfAJ4k6LGSX9tqDSepAMwTYCF8aabYHwMzdwyRLz7UEmVl+7SvE08Ia0b7xPZcZ3ikDtcP/vxSr3MLQJRPun77zWe0ledi2p4mZoJ0W6A/Efq/MCLtOmrJrUjNTEZz3YnyK/5gC/+Wlhmp7gwpKBY+XetjRYPuQqjBATLCTeRV634yUZ56mrBVxgd+R5tTT06uoDzv/n+hglRc07ulCvKN5+B1MrAcTgssAqB1r4+QoFehx0k6apIvfLRF6WaIdIGvjRT74EEGTOtMcn3dae3mEAnUUK6BiRdSFqSlUB6BIyQynCzJ0Rj9XQi759XEVILHiXVNHqm6RrcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ah/KgQ3doi5dp5nhrYCt9Wh2CB6FV9/WRtkHhh0JYIA=;
 b=D865j/7qjkjlzl6wf5veCa5vrCwHpZVFgEYDKF8O2VB/BekDdO85ZHVJ5EkbbdMI/yY8N2EHoevirTqdBj8y1dCh93yAeHrmLZs5lWR528pEMmOiho00Y2Fd31rMXPPZTRXRTU4Oq1fLYAa37qFm+GSEGIBV3GIOlep6keURIN5cbgMEuAf9J1bsLBVfmOV1uYW6CJQipIz+I2FsO5IunHeyIW2G1n3EdvtSeZVXWtUtSqVnsIbgFpWxNOrjlmhOhRkcOY6pF6+OLEVnH7SxaaQbMLFBDyKIlgoYKfmb/eLL41B5rN+YlcaQ+vH1HOW5xrDtD6fu1DPa/DimomzCyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ah/KgQ3doi5dp5nhrYCt9Wh2CB6FV9/WRtkHhh0JYIA=;
 b=mKUth2pUzI5SrNV02nwdSirHq2S2ncIQk8HFfKo/nafnyKMzqK7IiZN0EzjjBJl5dPSYVP1+5fo9+VJQrl1xynWSFuxJUGRH7zYmOipo81Epmu45oaA8AqCl8ZOh5281ssaq3BzrBaWAXW5LQRNHDCAq3IuHum9KSprmzzZa67/lCa+vegd7p4U2jfGaCOr4Qu7dI49vVnnOR4zPULIvB2wuV1zbPCrCtef6sZgdG53S5lqX289IW9TeiXlLcL4hftBJU5J2ugrO8FzBpOsln4BlHKA30kCfq9ovkmIiy+Sk9nW6wQdZUekPKjBnN+tLAZ1KiX6jTiaPcuPFWNclvA==
Received: from DM6PR03CA0075.namprd03.prod.outlook.com (2603:10b6:5:333::8) by
 DS0PR12MB7605.namprd12.prod.outlook.com (2603:10b6:8:13d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.18; Tue, 19 Dec 2023 18:09:45 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:5:333:cafe::f4) by DM6PR03CA0075.outlook.office365.com
 (2603:10b6:5:333::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:32 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:32 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:29 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 07/15] vdpa: Block vq address change in DRIVER_OK unless device supports it
Date: Tue, 19 Dec 2023 20:08:50 +0200
Message-ID: <20231219180858.120898-8-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|DS0PR12MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: af5971da-9b31-48dd-c75f-08dc00bdae87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3CiTZoBNujGltv99325bCAMjhNAsNXP5YRnnSZveR8vBDgYC8aiEnnA2VYbG82/smDRCzoRO4jpyrW9pJAdedzFrH6/+2Z80w9teqYXyFrysU7WFU9qjOsC3riXl23xdF2FhINt9YDmA9pFCp3BjqP8jrAbtmUfl0XeT+DDAclwPJsbuua2g4TUkz1QUzLT0wQmr8HUTphnymg7Xwxqvv1/m2jh0DCDoy20TfkdMC5bq2IPXT0fQMLOk0GpGDkfUmud8iMJ74oEQH0GN7wsLpZSt1x3yAT4iLHKrqj/fxwwDt0EfuvHWroppv0EgtYlA3JOo7ho6BnUOwx2NLiBsWclX1EOQftnijHy4vYdkLx9c+8HAZrw67Une+8Lo1s9yhSFyZqwABx8ECYXhiz8blix69G9ov4eR8rZqHzH4jznDZwrjMFWn9c050+bqeEgHhZbM1IwKqyg0oVN6pKhlP0fMwjEeUL5WE2hzusheK/Kq6xtKVGgsdZxJhOgUmU2YM8hvArQg3I22EDpohhLYKnwkkGaYgZw11kw3OprqQmaMplCywQ8ry/vjO+8o/I1bq1RLvV7y+oAz0scwAVvBYeLzDZxFoNZqkydL7Rr+vDG4TyjCWFHUc6T4/e29ICdWWYqOgEtMqzkDg5jG2ucobYQuC36Uyr/rNyjUQDu7G+DG8LuEhEH1qOu/RIabzY6K5L0jT8P9iIWEB4VaQJuzRch1F2mONCLHtNQ9QvTd0h1X+bcrDfsvsDO4OsTcCpR7
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(346002)(39860400002)(230922051799003)(1800799012)(82310400011)(64100799003)(451199024)(186009)(46966006)(40470700004)(36840700001)(36860700001)(2906002)(4326008)(8936002)(47076005)(8676002)(6666004)(6636002)(83380400001)(110136005)(40480700001)(5660300002)(316002)(336012)(66574015)(70206006)(54906003)(70586007)(426003)(40460700003)(7636003)(356005)(82740400003)(2616005)(1076003)(41300700001)(478600001)(26005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:45.5158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af5971da-9b31-48dd-c75f-08dc00bdae87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7605

Virtqueue address change during DRIVE_OK is not supported by the virtio
standard. Allow this op in DRIVER_OK only for devices that support
changing the address during DRIVER_OK if the device is suspended.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 00b4fa8e89f2..6bfa3391935a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -625,6 +625,29 @@ static long vhost_vdpa_resume(struct vhost_vdpa *v)
 	return ret;
 }
 
+static bool vhost_vdpa_vq_config_allowed(struct vhost_vdpa *v, unsigned int cmd)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+	int feature;
+
+	if (!(ops->get_status(vdpa) & VIRTIO_CONFIG_S_DRIVER_OK))
+		return true;
+
+	if (!v->suspended)
+		return false;
+
+	switch (cmd) {
+	case VHOST_SET_VRING_ADDR:
+		feature = VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND;
+		break;
+	default:
+		return false;
+	}
+
+	return v->vdev.vqs && vhost_backend_has_feature(v->vdev.vqs[0], feature);
+}
+
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
 {
@@ -703,6 +726,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 
 	switch (cmd) {
 	case VHOST_SET_VRING_ADDR:
+		if (!vhost_vdpa_vq_config_allowed(v, cmd))
+			return -EOPNOTSUPP;
+
 		if (ops->set_vq_address(vdpa, idx,
 					(u64)(uintptr_t)vq->desc,
 					(u64)(uintptr_t)vq->avail,
-- 
2.43.0


