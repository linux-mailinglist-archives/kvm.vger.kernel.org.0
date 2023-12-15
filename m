Return-Path: <kvm+bounces-4565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F4948149F4
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D0AC1C203E2
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8EE130FBC;
	Fri, 15 Dec 2023 14:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NpdIUB3P"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F17630F8F;
	Fri, 15 Dec 2023 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjL4+QHptssua1PEzn4p5j+pRzI1a4OAb0ulz068xAqXe5EIpm2AVhjOjbFexn+M7la6i0zsBK4rhHCqfcu2uPXMnU/VASMNNtzhRxa693m3N1RchzMk8ru1wWteA3z2Zjtm9v2nLfVLYWY4dQZgFkC7t0JtIbfrxd+Ko0iAA7V5GT/dDUxoszPVq2Vbq9fcggAXBbbGyNTDiZSgw6o7CphlnACG2k5BGMMwYWxbho1JuguEYYHE2w2us2w+qM8Z9r86pldcWPzG88EjtJzraOqfr7W1ZpxB5us5Xb0V6etAJWLqwzGmHoa+U+AEvyRs0zUVb0ueLBPT/Px05E/yHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+IHvmAfjUqijN8PnCS+2/qUcK2cIWV+k6bjPEbRCSk8=;
 b=aNtwisfaWC/oL8qiiSMl+fSRNNIj/OWn0v7M77jPFXAYXCWJlwGRJMr9rDAu1iCN1qZBEeEURn/IAxVGE4vYlKqoOn4ZDRpDuP15bmtuLH7N14/vz6dHY5dhaHukZVoAPOpIeAWpal5iVLSucXH3DEKmKN1xZiTgjAHTOxRTZpCAHCMYjIUbAZyIux89VenqqIiC8mvW2B0vm7PmoG9ZzfhdCBE9TwbXr5EwqEJ7wYTtF0l9G3qDYjXsHrxas/w3uLvlyVs1iHKQcFBW5kdS2qmFLgxHds+w3YlJtg1+SmjWocBhxYLbCAqSn/8tLBMvBND6V/UOqTjiu8jXNQTonA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IHvmAfjUqijN8PnCS+2/qUcK2cIWV+k6bjPEbRCSk8=;
 b=NpdIUB3PLqcjrnMCq3D4teQnciwYb9x6HoJ8uFWZwW8jDNs0uUA6hGsnLdI0WFFfyjhaVt3Gzz6j9slYF8zUm306wveEJ/LQkAxhUsmot6j15ZHSfIAX8uSNVIUEPNCB50HOTATLQ+9nJIi/klmo+oSBCH3SdgRCjREah0RFFNUx7o5zTljzG3F877BcNi3WqoqNEFGIQjg1coIZhy4U4vCUbUZHTnkm0gi7o9Vp1motNRcKrFS/fRGKrG1L0ODKyy4RUjpGcOHbgowuf7yhK72c/YHtu2Y0vHWY6KUP8XCEnS0D7qM+v4aq8MsPi22nwBvX3pE2ZCvZV+cBZjXR7w==
Received: from MW4PR03CA0140.namprd03.prod.outlook.com (2603:10b6:303:8c::25)
 by IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Fri, 15 Dec
 2023 14:02:11 +0000
Received: from CO1PEPF000044F7.namprd21.prod.outlook.com
 (2603:10b6:303:8c:cafe::76) by MW4PR03CA0140.outlook.office365.com
 (2603:10b6:303:8c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.32 via Frontend
 Transport; Fri, 15 Dec 2023 14:02:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.8 via Frontend Transport; Fri, 15 Dec 2023 14:02:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:01:54 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Dec
 2023 06:01:54 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 15 Dec 2023 06:01:51 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 0/6] vdpa/mlx5: Add support for resumable vqs
Date: Fri, 15 Dec 2023 16:01:40 +0200
Message-ID: <20231215140146.95816-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F7:EE_|IA1PR12MB8189:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b516d8-351b-4398-627c-08dbfd766e8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	J88lf+Jk/fhU6Mm0hSkEnJi/cCipyJWnFxAgrqzAp05qEDjMlXqfAdg2BNlOeQBud6n9Dw0w9IVl7YwF4rtVp7AWuaylmijxKlar2hE42OfCMt1yMTGFcx/84vZVA5v/dDCXqfF2WGGg8N3KX5BKoXcEW9t3UxpAz1yDNH5NHDMZZ6lHZqIKb85Ik6JdcPpoL2ir0mtCh1B84JYjYLwN65p+qyC+PJpOdkbAvKel6Rc7YhYKunPwDqNEDoWzKXNbOP82GyLsirsEvwHeG3SE7yRSSBSPDhwEFL7bGIJ9r2TV1BlkV0OGDpa08VQD8XRQwXDwXYGE3oG+c3YdVPbRgNNxJejnQRu5vmFbpeDMXlE8oEeWKSfSq+9CKmUHgl5JIoT5ypUjsyV/ZrNmgpogIKoTues/9qhCTLWrgnptB11mwuo+wUgwGWvfwwFxfg6oG2eHQ06cvOSfjWLLNDZ5lVfGTbz+TdAzj7OUzpJYk6JnSjM99WnpElEoKXozgobaJnx0Zud1hAhGnexM4GVZkrNODxTcxbwE1DvnSaLFbUgw+Ofqbj2kBfVTo+rT956B4Gv63m15sXwzxIkS/5KcjxEVVu1n16mTrf7u3lskTDcfThp6dhulDCHX/XeoCwsalXwMVOiw7M3hepbM5wxuL4fXLoABuwC2C0qCQ1/gawA03jeOPOyNFA1zl3K3l7WzfV+XcHl2rHAVo/Yl/l8AK2tYC7rDrrjydvoGtapFtfKw8IcNHTX8/p35BHjIIURYMx3pK49UXmAa7N5kLE5tejakCpMb+3PbW88p8/lAJ7E=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(82310400011)(36840700001)(40470700004)(46966006)(478600001)(5660300002)(40480700001)(966005)(54906003)(6666004)(82740400003)(2906002)(47076005)(1076003)(2616005)(26005)(86362001)(426003)(336012)(36756003)(70206006)(70586007)(316002)(6636002)(110136005)(40460700003)(8676002)(4326008)(8936002)(7636003)(356005)(41300700001)(83380400001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 14:02:10.4978
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b516d8-351b-4398-627c-08dbfd766e8f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8189

Add support for resumable vqs in the driver. This is a firmware feature
that can be used for the following benefits:
- Full device .suspend/.resume.
- .set_map doesn't need to destroy and create new vqs anymore just to
  update the map. When resumable vqs are supported it is enough to
  suspend the vqs, set the new maps, and then resume the vqs.

The first patch exposes the relevant bits in mlx5_ifc.h. That means it
needs to be applied to the mlx5-vhost tree [0] first. Once applied
there, the change has to be pulled from mlx5-vhost into the vhost tree
and only then the remaining patches can be applied. Same flow as the vq
descriptor mappings patchset [1].

The second part adds support for resumable vqs in the form of a device .resume
operation but also for the .set_map call (suspend/resume device instead
of re-creating vqs with new mappings).

The last part of the series introduces reference counting for mrs which
is necessary to avoid freeing mkeys too early or leaking them.

* Changes in v3:
- Dropped patches that allowed vq modification of state and addresses
  when state is DRIVER_OK. This is not allowed by the standard.
  Should be re-added under a vdpa feature flag.

* Changes in v2:
- Added mr refcounting patches.
- Deleted unnecessary patch: "vdpa/mlx5: Split function into locked and
  unlocked variants"
- Small print improvement in "Introduce per vq and device resume"
  patch.
- Patch 1/7 has been applied to mlx5-vhost branch.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vhost
[1] https://lore.kernel.org/virtualization/20231018171456.1624030-2-dtatulea@nvidia.com/


Dragos Tatulea (6):
  vdpa/mlx5: Expose resumable vq capability
  vdpa/mlx5: Allow modifying multiple vq fields in one modify command
  vdpa/mlx5: Introduce per vq and device resume
  vdpa/mlx5: Use vq suspend/resume during .set_map
  vdpa/mlx5: Introduce reference counting to mrs
  vdpa/mlx5: Add mkey leak detection

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  10 +-
 drivers/vdpa/mlx5/core/mr.c        |  69 +++++++---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 194 +++++++++++++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h      |   3 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h |   1 +
 5 files changed, 239 insertions(+), 38 deletions(-)

-- 
2.43.0


