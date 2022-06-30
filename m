Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259E8562458
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 22:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbiF3Uh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 16:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237220AbiF3UhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 16:37:05 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFAF44A18;
        Thu, 30 Jun 2022 13:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsrWc9LP1/x3Gr29KFWUFwckz2TE/+SfFF81KBdGjb/l//H9MxqelvuaNY9h3tLg0kET4eLda6hU5/wtbaji+NQcJanxL1ALWAebqrKboLh7++7VSksFj3QW7LNNjNrxrZL6mAVhghFv/y0Mk+FGkYGGVTU6RkYJ5MERnCC1wfmbhC3q8rIC9kISGw4TRvrgZQWF0S6Kiy1Db/xiXN0eBtbXiPftqW4AGsH6+qg8tQJ455C9+T602zt7LLfRN1v7Rear7Ii+coTB0m58UkhyiRV4CyW6k5SmWi4r9ialnfUqitXdWn4O9NXTaBOh8JvI7C2ButtI1plhaH+/Qwg+Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=febXSRzXK0Ih93Xah1RdUyDSoDrY6EiMpBtiKcEx6to=;
 b=EOkQBkEKSeBgAAdvynnWAOymZ1Kzu3joJwTxKgA84gZz+w+coUiC/AsIZ/wKSGLk3IkSUAOnJEOIRmDWlo0PrJH1bV4NQ4EUGborLGpia5TFF2NtOS9Lz4vdrjh9U/wMWRBrW0OwcBmNEUfQ+oxQkv4DHCMm9nWQy+igBr71VtIV8nWTVdZY8W30kwVgGRFpqBDBKLXzehWbD45PLvfpaGKC7qO7HHTGyxIgjfQlrJ5TX1sTjx5sqOv8CpfzhZKEf/Al3EB3u1JviYuPpXDwyD4UsK30Kt30JYlp/O3AnmF2donFrLPkmUkm7ZZYTOQCrIIgvAADAnN5irDcmKY+DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=febXSRzXK0Ih93Xah1RdUyDSoDrY6EiMpBtiKcEx6to=;
 b=mS26Z44Jj3O7Qxeh5u8g+Z+VVPOJwsMH83fJpXlqwdnFuUNdfrGE0zSOpryzJnfV/2Ad1X42mDG8MmnbaADPtBtRd5al9dyRr7DALBiX7qxv+YgHxP8kp0vEm2V6N8cDnCXqulxgfsTV3JsNfKYuHLmTNZdDraZDLOX3mPh22gorV70G722CZdQcDkUt/Hoii+bdh296PvKUNILouZ8UOkIK87J+lEnNN5bYd0WSfSyBeDLidX6e/v8iIB3E9hxLtA9hyLbnQsIM2A3MdmP3Tk5KG8ssnTmkWR16ntM+/X8UFEMqYvJaRnDZvPdxW0u6dsqSTMxyP3sUm9MGsgNJ+A==
Received: from DS7PR03CA0221.namprd03.prod.outlook.com (2603:10b6:5:3ba::16)
 by DM6PR12MB4010.namprd12.prod.outlook.com (2603:10b6:5:1ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Thu, 30 Jun
 2022 20:37:01 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::2c) by DS7PR03CA0221.outlook.office365.com
 (2603:10b6:5:3ba::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 20:37:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.17 via Frontend Transport; Thu, 30 Jun 2022 20:37:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 20:37:00 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 13:36:59 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 13:36:58 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <jean-philippe@linaro.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <chenxiang66@hisilicon.com>, <john.garry@huawei.com>,
        <yangyingliang@huawei.com>, <iommu@lists.linux-foundation.org>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 0/5] Simplify vfio_iommu_type1 attach/detach routine
Date:   Thu, 30 Jun 2022 13:36:30 -0700
Message-ID: <20220630203635.33200-1-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bba5a0c-a2a0-4a11-cb62-08da5ad848fb
X-MS-TrafficTypeDiagnostic: DM6PR12MB4010:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2tJAYCh8hUV0685hr3N1WIte9lg+WsqOiINyu57rPFT9XJkyAD/1aoe71jXZ?=
 =?us-ascii?Q?O+9MwsDLBvbrSNgPYAuK8JhuNtkJsQzK137haKWqBkFBOe4rvvnMcXiJecEP?=
 =?us-ascii?Q?+XO54KC4ly0QVP5THjtiEKRGbF2nkbs0nxWJuCLtag2qFnZdqDFu+nD/LdW2?=
 =?us-ascii?Q?0+jl9XxtEd5P9N1WQFFQOHYAi5n6+OocUzwcQMMdgEIQG+PKEin2HYvNliAV?=
 =?us-ascii?Q?y3lqGwIaBCpCs7vbPfYzwjpahkrqNZJoSmuht0Q6TRMyWN97zhohyBBpb637?=
 =?us-ascii?Q?lcLaWopoWdXtkf547OR4QF9VDyEvrML0vs9sumFiMWPN7pwuQfu+8/Pk9Dmc?=
 =?us-ascii?Q?o8UBeEWPqAh7PFXV6Z6z7ah8IMfvx6jbFKtFI8mpTXyvyPZYQBoILup82kyN?=
 =?us-ascii?Q?8y2QTAvTSQ8uqlzaUtPF+u7pKgLqeVD3jO4fnCqi/8QhYoMdHtLfUoOciJLu?=
 =?us-ascii?Q?ECFY3US0kV7dZrJigWG1VHcUkH/sVA6+i8lQh1qn4jDK+rEx/hd9uHTylTBa?=
 =?us-ascii?Q?JlaSryOLQyEjCQvk6AAbQHtZuOvldbGIXEtzMOeFI1aIiN9VOXyAyFN+Lcip?=
 =?us-ascii?Q?1kzP+gYg/U76rKINLU/LsCL4hWJjrjuBDZ2VcHb6xfhMsBSEXtxbMCipGZMp?=
 =?us-ascii?Q?CvEsgvNsMguIRLHz+ons3BFKH9qCTqdQpyRlu5Y83hNgxJ5J2V6053Yz+F+F?=
 =?us-ascii?Q?rq+JDjdTQz5EPV/VGqdtmmNbwalvCo0pHIdDPugsJts39mccPF3jW8Chbjpv?=
 =?us-ascii?Q?awry/vV9F3Al+CH83/cH+LntMPepPrGCbaDq/QNxoKThYhNXzPFR9vEf7OiT?=
 =?us-ascii?Q?0rDqJ5xZOrYITUJivS3SYDJ6HzUKgeMK/liTbZUcoLvIj4GsWDOVLtV3WDA/?=
 =?us-ascii?Q?Fezhywr4WfltfJHRGMjcfQPQW962wzrojf91h6fvYec0s0dnVDpSAuVQmgQh?=
 =?us-ascii?Q?0hZbhrvPK+uolOL713jD7Zq1BMMn0RBVyI5CkJ4iHj2HJAjz8kZDsb99Z3Da?=
 =?us-ascii?Q?v7ppHSz5/r6VlyGpsTzk5zOUSPjS9eghBa8wchgC3DFwTTk=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(396003)(376002)(36840700001)(40470700004)(46966006)(186003)(70586007)(5660300002)(70206006)(316002)(966005)(86362001)(8676002)(8936002)(921005)(1076003)(356005)(4326008)(2906002)(47076005)(82740400003)(36860700001)(7406005)(83380400001)(7416002)(54906003)(81166007)(40460700003)(426003)(110136005)(7696005)(41300700001)(478600001)(82310400005)(2616005)(6666004)(336012)(26005)(40480700001)(36756003)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 20:37:00.8993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bba5a0c-a2a0-4a11-cb62-08da5ad848fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4010
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparatory series for IOMMUFD v2 patches. It enforces error
code -EMEDIUMTYPE in iommu_attach_device() and iommu_attach_group() when
an IOMMU domain and a device/group are incompatible. It also drops the
useless domain->ops check since it won't fail in current environment.

These allow VFIO iommu code to simplify its group attachment routine, by
avoiding the extra IOMMU domain allocations and attach/detach sequences
of the old code.

Worths mentioning the exact match for enforce_cache_coherency is removed
with this series, since there's very less value in doing that as KVM will
not be able to take advantage of it -- this just wastes domain memory.
Instead, we rely on Intel IOMMU driver taking care of that internally.

This is on github:
https://github.com/nicolinc/iommufd/commits/vfio_iommu_attach

Changelog
v4:
 * Dropped EMEDIUMTYPE change in mtk_v1 driver per Robin's input
 * Added Baolu's and Kevin's Reviewed-by lines
v3: https://lore.kernel.org/kvm/20220623200029.26007-1-nicolinc@nvidia.com/
 * Dropped all dev_err since -EMEDIUMTYPE clearly indicates what error.
 * Updated commit message of enforce_cache_coherency removing patch.
 * Updated commit message of domain->ops removing patch.
 * Replaced "goto out_unlock" with simply mutex_unlock() and return.
 * Added a line of comments for -EMEDIUMTYPE return check.
 * Moved iommu_get_msi_cookie() into alloc_attach_domain() as a cookie
   should be logically tied to the lifetime of a domain itself.
 * Added Kevin's "Reviewed-by".
v2: https://lore.kernel.org/kvm/20220616000304.23890-1-nicolinc@nvidia.com/
 * Added -EMEDIUMTYPE to more IOMMU drivers that fit the category.
 * Changed dev_err to dev_dbg for -EMEDIUMTYPE to avoid kernel log spam.
 * Dropped iommu_ops patch, and removed domain->ops in VFIO directly,
   since there's no mixed-driver use case that would fail the sanity.
 * Updated commit log of the patch removing enforce_cache_coherency.
 * Fixed a misplace of "num_non_pinned_groups--" in detach_group patch.
 * Moved "num_non_pinned_groups++" in PATCH-5 to the common path between
   domain-reusing and new-domain pathways, like the code previously did.
 * Fixed a typo in EMEDIUMTYPE patch.
v1: https://lore.kernel.org/kvm/20220606061927.26049-1-nicolinc@nvidia.com/

Jason Gunthorpe (1):
  vfio/iommu_type1: Prefer to reuse domains vs match enforced cache
    coherency

Nicolin Chen (4):
  iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
  vfio/iommu_type1: Remove the domain->ops comparison
  vfio/iommu_type1: Clean up update_dirty_scope in detach_group()
  vfio/iommu_type1: Simplify group attachment

 drivers/iommu/amd/iommu.c                   |   2 +-
 drivers/iommu/apple-dart.c                  |   4 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  15 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |   6 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |   9 +-
 drivers/iommu/intel/iommu.c                 |  10 +-
 drivers/iommu/iommu.c                       |  28 ++
 drivers/iommu/ipmmu-vmsa.c                  |   4 +-
 drivers/iommu/omap-iommu.c                  |   3 +-
 drivers/iommu/s390-iommu.c                  |   2 +-
 drivers/iommu/sprd-iommu.c                  |   6 +-
 drivers/iommu/tegra-gart.c                  |   2 +-
 drivers/iommu/virtio-iommu.c                |   3 +-
 drivers/vfio/vfio_iommu_type1.c             | 340 ++++++++++----------
 14 files changed, 224 insertions(+), 210 deletions(-)

-- 
2.17.1

