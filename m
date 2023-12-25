Return-Path: <kvm+bounces-5229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F72781E145
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 16:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73AAD1C2193C
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 15:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F060352F81;
	Mon, 25 Dec 2023 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O9jJqXXQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD8652F61;
	Mon, 25 Dec 2023 15:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0lpCGLxlPbgXVPtYXJ46TUUU5o2uqzXZF8r6TZ8aXu5m2koZDaD8OMp4InMrAzGVY274A+VX4T6c7VH7rcNgiy8L2tsR8g3O4gm/QMTN0P2oKbU7ZJTsFoRj6fcko/+o60Q0yzm1MVA6P0TKm/ZOxh7GnFR/qI2huJt+TIl4jIEfhqYFj8Js4x0iP8EAJV6J73NA0yaDJemX7UWoLU4bkJpizzXtC77WkmN0IiePGxwfoLhqXntwVy7XoUZwLKC3UlFMA+OhTHh3BRUdOT5++OTKD0niJaYFqy/9Mwd9iQ9XWYqIjhC9jOUwZZD+18l9zYaHCFlZ7HrbYKJdx/5+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fdyzga269TON7etIuAsUiwHiZpnBbeXdSusUYxZM3c0=;
 b=mzg5Uhe6WG4G69aBYhQ35jTfxBSmhANRpOygBWmLU7Qwpopgr2Jxqxitf9jbQ4RUA+gHsz5GtLHWOD9auX5D14AvAJfB1PCy/u+vdwcHR6DrruOdvsr3xsYBTCa9PsMqH+5BBKCzaiK3OvSdb8gnq/Me378Ha7MbJQnYSQrzXWA5AWukEnj7L3mFXZE6AOYa+bP+7m00ma9dflX72KThpgp2kZnBgxv0+u5gkpVFJZliOLuomRxbLcNA69FohZTsO1FKyAsy3fEU3LhgAtXbIi8S2zzIJCHt4CD0XlVMJLU3CXiNowrK9fjjvNuQwNmezc/5Gy/deRgEFEx0xv7nDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fdyzga269TON7etIuAsUiwHiZpnBbeXdSusUYxZM3c0=;
 b=O9jJqXXQ7zhvWEEq44+BhqOgFycWxe5tYo0pybBZl8wePj536j12EmyG2zEFN+fMImXPeDg1zAv2WpMmQ17Rb8QCBGDbbbe5q0HADakG8RYwePzYwwGZy6XUaWavL+6XU9DGIph7x2gNf7OV5gw+apQV2zwl5uLuw+LfC15pyaXkqVhF/A9wGqz9se4W3h2caMIaKl0ekhb+C18CXKeHYAtDXeAyjjMFHNkZl2H4xrJ5mlVQveVjnrUAAJgP9lRepzrktPDq2M/Rkhy9k1yukTN3vy0l+F28uMcYZzZtOspKYRj/X6XW4zNQtXBQ8eUA5ZWaFrJHUkOxe7vUQ9ygBg==
Received: from SJ0PR03CA0215.namprd03.prod.outlook.com (2603:10b6:a03:39f::10)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 15:12:15 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::dd) by SJ0PR03CA0215.outlook.office365.com
 (2603:10b6:a03:39f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Mon, 25 Dec 2023 15:12:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.14 via Frontend Transport; Mon, 25 Dec 2023 15:12:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 25 Dec
 2023 07:12:06 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 25 Dec 2023 07:12:05 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Mon, 25 Dec 2023 07:12:02 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v5 0/8] vdpa/mlx5: Add support for resumable vqs
Date: Mon, 25 Dec 2023 17:11:55 +0200
Message-ID: <20231225151203.152687-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|BL1PR12MB5350:EE_
X-MS-Office365-Filtering-Correlation-Id: d72ebb84-b2fe-4cd5-f9fa-08dc055be061
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4pbBqzytMsWCGxDa1vwI3V+cfUFdUPkvkQpbM20Mc/V9QzTvtimqfcXoG47nJNiQaElJAtSgiklKD8WtHROsF6dXxHHtV6tGTs2KFNkh1BMuiZZSVdQJGX/FOsfkzP/rFkOtVdMo9yjidpOiKU4k6QzKDJOvyafUB8IJSp0WelGPL4nZEkSo93vNjdxyi1BF4P3otG+nEdSIH+WUwuW4lEvTLyEkKNs1lg1tHtMcoBIcp9wplpQFZ0JU5+G1Ui648YnIa620y2HL2Ae9ZtIoE0XWe7EUM47BK3arqjIBPSy2HG+druj1W7XZtWka96ISs04Ju7o+IqWNP450ZUzjPaYR9j2+VC9NHM7QX+7RRhFwTXVgc0ZHTVuMhVag6/OXf1vHOFwiN0sFzoZIlshlKU087/qDyBGCu+q1ZBtfMYp3MqPVzxfvs0eUUiN5tYJvePtQ7oZb43IHIvlAtjXSTkn45elSmf/hnD/vvWEiApfGju8FweE2pxws3/GLJRhPNPFC8FssfZGHKCcxT2J9wd3SFFRxPHRolMP2I7ABnXPayWxa8U2NP4eCnQbk8Ma/ZNCZ0BULEm3SKlM5kufF5o7xtwnazBBI42PEJd0BCusT6FP1GMEOvkPB12AmsUX15Ygxj6nG2yoZmtl1PY8hlvTi0jJM3aLuj/eq6hcLDxXqCskZyb9pHTjVbD5dlgNXMMcP4dwZuNYfutJAoZQ2oARVmD3Sl/6ur2js7Yglkrp/plmAp/5vfeiHorZc8U0fn75Lc5eO702BNCSDSAngHFfPjh/h019FJCbe2y+b75Y=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(230922051799003)(64100799003)(1800799012)(82310400011)(451199024)(186009)(36840700001)(46966006)(40470700004)(8676002)(8936002)(5660300002)(2906002)(4326008)(316002)(478600001)(966005)(6666004)(70206006)(70586007)(54906003)(110136005)(6636002)(41300700001)(36860700001)(47076005)(356005)(7636003)(40480700001)(82740400003)(40460700003)(26005)(2616005)(426003)(336012)(1076003)(36756003)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2023 15:12:14.4291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d72ebb84-b2fe-4cd5-f9fa-08dc055be061
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5350

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

The second part adds support for selectively modifying vq parameters. This
is needed to be able to use resumable vqs.

The third part adds the actual support for resumable vqs.

The last part of the series introduces reference counting for mrs which
is necessary to avoid freeing mkeys too early or leaking them.

* Changes in v5:
- Same as v2 with additional Acked-by tags. Based on review discussion
  in this thread [0].

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

[0] - https://lore.kernel.org/virtualization/4abd7d516a9e82ebf41b1ea98475341844186568.camel@nvidia.com/T/#mb0433c4f1705fc2cdaa7c926f352c26f6b54444d

Dragos Tatulea (8):
  vdpa/mlx5: Expose resumable vq capability
  vdpa/mlx5: Allow modifying multiple vq fields in one modify command
  vdpa/mlx5: Introduce per vq and device resume
  vdpa/mlx5: Mark vq addrs for modification in hw vq
  vdpa/mlx5: Mark vq state for modification in hw vq
  vdpa/mlx5: Use vq suspend/resume during .set_map
  vdpa/mlx5: Introduce reference counting to mrs
  vdpa/mlx5: Add mkey leak detection

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  10 +-
 drivers/vdpa/mlx5/core/mr.c        |  69 ++++++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 209 ++++++++++++++++++++++++++---
 include/linux/mlx5/mlx5_ifc.h      |   3 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h |   4 +
 5 files changed, 257 insertions(+), 38 deletions(-)

-- 
2.43.0


