Return-Path: <kvm+bounces-4851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6BD818F51
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20DFB283B52
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE20338F91;
	Tue, 19 Dec 2023 18:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r5J0w6uC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B06A38DF5;
	Tue, 19 Dec 2023 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPV8qIGKKdz5filA/JOwXOlTsy76c6Nf5H2EFd1UHv4IoJrlZnb4r+OjMH6L9yCMIHE9XhqdkzANLBx9LG2yRymJaA/FTTGV2E5lDSIU9vFirlUyrTbPMvfdyzxldseJAWPwJwSHW+PIf7O2/oTGI5OoSrKGlJGovZYhi8Qhhr8emlZptpTtT2PhrGXLcxsbVyfcDuZOJceINkvQm6B+kdzndCdwhlTjQVoyt3K1p8nasIwS1pV9pl5gw9INNmIPuRM1DmqdiYZflCPLpcYexqTMoadLohjyit0Y9YcZYa4JIlnlvVe3OpdbEtMkwgsIVNoqn4+YoRyhgNa2NfyqcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FaBK0ijv2agMx5HmoqqLlqw1E/4ExoiPprvsez1t0As=;
 b=i7lruV8l0fBxMTSK4Rm9jevWshzVNTWqPsjZ2GKiX9bmP+trElnQNUJKeklODxwO/OU5S4d7nO0Hxq6VUU1Tp88AP7QWmHAN/AQBPKusb2eK7VbgK0G4VvXqBIQdIP2JQRgMPvmjuA5R5HJqOOTVc0EtYlL8MVKeVXK8yU09PzUJZOuIgqNuUg+0T+zQ2CtrWkv69anzVgBfcGOoMbf7DPj22SkSSpGSXkcsAahKhu1B0pvcrw/Z83B3K8rdMxOGIMgH/onC61y7XDKEoQUjVhlJ4+ja7J08NRdOlPdRIJ7D0HSLCjIx15TtVtlDss7LPkG8+0dwxICNKFU70V3lBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FaBK0ijv2agMx5HmoqqLlqw1E/4ExoiPprvsez1t0As=;
 b=r5J0w6uCd7+fhH2pQKO9k+E3x/E/c+xQcMvm5DTvqZZ7jQB29p0fmB5wFb+zV0l6GSy7jf1t2u1v2K4/XE3JSwj8Vcv1TIj8dZFOxtefbDOdNOy/ukR8zZCqvNE+KE6w49y9skTFBUkZzok7nHCiszhU83ID/X1GSyFPh79qiGO0hn1MHIVXKshGTbeYbTWlHQSP9XDN/y8Twq0iaIDOCdGMLvzwtmaUUmoeWoGL7LufGR3gov0ROmgXXH5V7pnmsEyM0QRJSz+v/YFs7y8uRrOSGGXS1tKu+R0UOdFPxxNjmCg5huU4JcHws5mPugTTj3UG/BPBJTo5HRYpM3Mz9Q==
Received: from MN2PR03CA0016.namprd03.prod.outlook.com (2603:10b6:208:23a::21)
 by SA1PR12MB5640.namprd12.prod.outlook.com (2603:10b6:806:23e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 18:09:17 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::8b) by MN2PR03CA0016.outlook.office365.com
 (2603:10b6:208:23a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:17 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:05 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:04 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:01 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 00/15] vdpa/mlx5: Add support for resumable vqs
Date: Tue, 19 Dec 2023 20:08:43 +0200
Message-ID: <20231219180858.120898-1-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|SA1PR12MB5640:EE_
X-MS-Office365-Filtering-Correlation-Id: 31d2790a-2f59-4c29-ff0c-08dc00bd9de6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1WPJwcVIAK2tyWhIMtI56qIO9+w6Sl1uaWqiY8JIdsnN8leHdvzpEZli1d3jUXMzuByOp/62YNapFCZDJlKUcvaCQtBudaFjBlDO9y2vwgBwOfvixacDGuGpQyn+RbaLtbMGPaBLtv6YfMacOxxVKtj4EJE+WYC4CawFnSAFuCHKJ/CwKIYKoxLMkHAGjBt59yDiMB19nLOLJN+ji+GsJAKFos0fO1QP9XaKCVYowpSte6vyvy3Q5aMQPPjfxUoW6pMG1K4F6vj3i2TeoaulFilo92UEB4x96yI92Hg3fN0zHTEEb1hCyXuxGh+BtXvHxHxdxb5GX5zNY0wRYwNZ/qYCqRC/FZSPmFvfvL3oKDNJavLz6moB58+AzzD49x3bD7U0NWg37+7hlzH9miGvnt+9yZDeZ1ZmpW1nFvtC+mX7dBJ605VpWDFPezxS9aIG1gPC/eX+abOfaHNpHInpluWm7+SQJ5bkzzjn1N+6AJPExQ3qPOhUEhh0U2ixR4d3x/bOgVYoXiTGuiwp7WMmF8Pspdz+jZxAsLnJYLmIDCJzIkGG0NH0ODVgIE/UoVJZmXpiI+tzZk/JRCm4bn4KWXNuawBnTwjsvajBmz5oz4a4Wd4ehAKdUmH0Ue4vmu5CiuXpx3134BzJVAp+/DiBrzh33rTu53xiG/7QvJ3kTZ1uF+Ebe9FKYCgPq5taEpjnhTfIptr2i3/rc0bSN/z9GVGCdmmRQ560SjDsL2YGDwoEshviyHk5Wt9f+Kd20yfW
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(451199024)(186009)(1800799012)(82310400011)(64100799003)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(426003)(2616005)(336012)(1076003)(6666004)(26005)(82740400003)(356005)(7636003)(36756003)(86362001)(478600001)(8676002)(8936002)(4326008)(110136005)(41300700001)(36860700001)(5660300002)(47076005)(2906002)(83380400001)(70206006)(54906003)(6636002)(70586007)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:17.5716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d2790a-2f59-4c29-ff0c-08dc00bd9de6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5640

Add support for resumable vqs in the mlx5_vdpa driver. This is a
firmware feature that can be used for the following benefits:
- Full device .suspend/.resume.
- .set_map doesn't need to destroy and create new vqs anymore just to
  update the map. When resumable vqs are supported it is enough to
  suspend the vqs, set the new maps, and then resume the vqs.

The first patch exposes relevant bits for the feature in mlx5_ifc.h.
That means it needs to be applied to the mlx5-vhost tree [0] first. Once
applied there, the change has to be pulled from mlx5-vhost into the
vhost tree and only then the remaining patches can be applied. Same flow
as the vq descriptor mappings patchset [1].

The second part implements the vdpa backend feature support to allow
vq state and address changes when the device is in DRIVER_OK state and
suspended.

The third part adds support for seletively modifying vq parameters. This
is needed to be able to use resumable vqs.

Then the actual support for resumable vqs is added.

The last part of the series introduces reference counting for mrs which
is necessary to avoid freeing mkeys too early or leaking them.

* Changes in v4:
- Added vdpa backend feature support for changing vq properties in
  DRIVER_OK when device is suspended. Added support in the driver as
  well.
- Dropped Acked-by for the patches that had the tag mistakenly
  added.

* Changes in v3:
- Faulty version. Please ignore.

* Changes in v2:
- Added mr refcounting patches.
- Deleted unnecessary patch: "vdpa/mlx5: Split function into locked and
  unlocked variants"
- Small print improvement in "Introduce per vq and device resume"
  patch.
- Patch 1/7 has been applied to mlx5-vhost branch.


Dragos Tatulea (15):
  vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
  vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND flag
  vdpa: Accept VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND backend
    feature
  vdpa: Accept VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND backend
    feature
  vdpa: Track device suspended state
  vdpa: Block vq address change in DRIVER_OK unless device supports it
  vdpa: Block vq state change in DRIVER_OK unless device supports it
  vdpa/mlx5: Expose resumable vq capability
  vdpa/mlx5: Allow modifying multiple vq fields in one modify command
  vdpa/mlx5: Introduce per vq and device resume
  vdpa/mlx5: Mark vq addrs for modification in hw vq
  vdpa/mlx5: Mark vq state for modification in hw vq
  vdpa/mlx5: Use vq suspend/resume during .set_map
  vdpa/mlx5: Introduce reference counting to mrs
  vdpa/mlx5: Add mkey leak detection

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  10 +-
 drivers/vdpa/mlx5/core/mr.c        |  69 +++++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 218 ++++++++++++++++++++++++++---
 drivers/vhost/vdpa.c               |  51 ++++++-
 include/linux/mlx5/mlx5_ifc.h      |   3 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h |   4 +
 include/uapi/linux/vhost_types.h   |   8 ++
 7 files changed, 322 insertions(+), 41 deletions(-)

-- 
2.43.0


