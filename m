Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7877D562459
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 22:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbiF3Uha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 16:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237235AbiF3UhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 16:37:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAFB48819;
        Thu, 30 Jun 2022 13:37:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwvUaiOZMWjyl03BplyVi1JCYgDynXZR/to30/dGBjyFHPcq5Dq+GYSCZo2MmrPzb2frKgjZ5pGhnmP3cV0wkyAPLyJfrgh8T1FAx5Zj0hxwov0barcWwEz4/DGUdGelxGH1mUMeELiXWNaanrb/DbtWvzZTbH/pzr/1O1QBRZK/LyfeY2UDB+BQoALQfUL8ChIUzHqDM21QXcBkCRUi3L664r4UgJ6O8McOMzOt9n4bAQvxBSzH2rCMr6DRmCVPSf9VnBgN6d5KIm+VUcXRTkNPWlmPLNmu69dQNAv5u+2A1w8NKi4ZL9MjjuwHQoxOWqVhslcRtw6duw5SqEccOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irkkFHA7twGydvDFI2ZKqQaxPWWKcoUw/9J/WEG46Ps=;
 b=ijouepWtFTdydRlNxX5hrZ/tS3AYOSfQ4ONK+FwUPbJe939+Spwrlx5Z6tRKk5RQV6yaHCtI0eu1GghzYi6/V3VI5jErX5SDF2A3Ett0kAbphQk+00MCCMOJyiRIghlD3eOYzAdfGqPHo7C2QS4bJMLRlFDudKF00mKlyTjdQZgJLPNXB1rsHcl1xXuxHzmz+bMYMMqMwUgVcNOtDNB9P57JtJSzRFkf8l0sydxAROlrPCJbLohkYA1BVAXUBvk3qugE4Sg1EczygjjPJMSd95Mv1NX5iBbTz7jnE4e1P6tfYa16C2CgsbPbjbyH9+IJA8g1QsfVLNeh/OYGD2ImbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irkkFHA7twGydvDFI2ZKqQaxPWWKcoUw/9J/WEG46Ps=;
 b=fxKpOR60EW79IHPbH1YUs5mpt2xqrG/rs3AMHZQ+JCcM/ZWpQVTWinrZnif3FjCB6d0xpNMQk+WiBqcXhSN5XVISO9trJYxeDp8VkrXALpMUAUiyhrmBr00je9iRpYIZlY8XopMeEoPXc8OIgFWEC7C4dI2jukKbp/iurQUlqe7JuoJg10RidD/x0obp9b0XpERwvYY+uor9JFQiMv0qJ2aWpplAo/pNSVADAggIviuCKri5rFxCH5FQM2/YLOIiyzjTfVul6VOcnO1sh3Nk34VWFTOwDbyYXi2aPplYLrrulvbHy49zP/IgTCasQFemHZGwks/13ew2tow3ty/8oQ==
Received: from DM6PR06CA0048.namprd06.prod.outlook.com (2603:10b6:5:54::25) by
 BL0PR12MB4945.namprd12.prod.outlook.com (2603:10b6:208:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 20:37:05 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::b1) by DM6PR06CA0048.outlook.office365.com
 (2603:10b6:5:54::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 20:37:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 20:37:05 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 20:37:03 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 13:37:03 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 13:37:01 -0700
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
Subject: [PATCH v4 2/5] vfio/iommu_type1: Prefer to reuse domains vs match enforced cache coherency
Date:   Thu, 30 Jun 2022 13:36:32 -0700
Message-ID: <20220630203635.33200-3-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630203635.33200-1-nicolinc@nvidia.com>
References: <20220630203635.33200-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df73119d-8134-4d53-25fb-08da5ad84b78
X-MS-TrafficTypeDiagnostic: BL0PR12MB4945:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBV5zFkv2H+jHTdOd9Heu2p/XiUxoYOxaquwgtDUPed47itvP6e9sF7MHkBGVh94L1jxFDKSDUaCiWi5sja0uFpxeB5CQ7C6YpkWkGvNa2X1G6NkaOriR2eYyKrt4n8SOUqmQeU31WkT+gn/ToIoDdm7t5OZRO6U6pGnW98gEr6XSdGFA5D7HEZSaGyEOrJg6q0+GwQr/MLSXLA8SkevPpNIXvpUzbv+BquVWhw3PChcWRTb8AOL5Dz39pgO7IdQ7b/kzoHdQBXayUXVW1K7ogcLdIEmewMkUle/wRBLAutiGsClUdE/AXF4X050qE3fxpYiOU7BGg1xQf/TwpuZu2KNrNicgp1PQ+fyzc1bEwehlApU9Mr2VuucCp+qvqz9ns/0QqvS+Foi3IIo14fB4JBAWD0ktVMdLvrtFJfuTAEj6im3Np4ePjy0q5DqsD4bJcwZquvWx+Kmdu0aV6hfAuH+Lfb7tBseeGehXIJb96xTnGPTfr7SrVfG2YAi8B4K7SfSPJbQLqLkEizaMLOsxzDoqWyclJqDrpX9ZJ+mq5tfN85WOYb/kcnn2JUpmzBslEuyYzFh2oDifcxt6x93BfYTgbR7dK5ik874GLFkEXZMsWOdFy1lPuuiV0moPC3rd2i0nkv/gJMNQuKqPg3KnDEn6QJx83dWsCk9mu90n4G/rChT6KHWgfxIKqJjYTf63d8wSl+yyVLm4v+7GJIOJz9QfqgOlJL3yU0/WcOC97wwmY8/Vhktj3H0XfEqAJRsnd07NTJ+iNnAe1sJVqr44WrR8XgYvkV6MeCNDX1bvs79faseTdVC6DXhMJCuYlvIVYcM3UwYG/iSlF88h32WAWRI7FNsuisSUk5npNfKM41Je1FufObcU3BKRAxn9r5I4Z7NR19A63krJqn1vDaQJdJZZ4lkGbLsKqjf9e/dZBA=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(376002)(36840700001)(40470700004)(46966006)(356005)(921005)(7696005)(70586007)(8936002)(70206006)(8676002)(2906002)(41300700001)(54906003)(82740400003)(86362001)(478600001)(4326008)(26005)(6666004)(186003)(36860700001)(36756003)(110136005)(316002)(81166007)(336012)(426003)(82310400005)(47076005)(40480700001)(83380400001)(2616005)(5660300002)(40460700003)(1076003)(7406005)(7416002)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 20:37:05.0853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df73119d-8134-4d53-25fb-08da5ad84b78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4945
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The KVM mechanism for controlling wbinvd is based on OR of the coherency
property of all devices attached to a guest, no matter whether those
devices are attached to a single domain or multiple domains.

On the other hand, the benefit to using separate domains was that those
devices attached to domains supporting enforced cache coherency always
mapped with the attributes necessary to provide that feature, therefore
if a non-enforced domain was dropped, the associated group removal would
re-trigger an evaluation by KVM.

In practice however, the only known cases of such mixed domains included
an Intel IGD device behind an IOMMU lacking snoop control, where such
devices do not support hotplug, therefore this scenario lacks testing and
is not considered sufficiently relevant to support.

After all, KVM won't take advantage of trying to push a device that could
do enforced cache coherency to a dedicated domain vs re-using an existing
domain, which is non-coherent.

Simplify this code and eliminate the test. This removes the only logic
that needed to have a dummy domain attached prior to searching for a
matching domain and simplifies the next patches.

It's unclear whether we want to further optimize the Intel driver to
update the domain coherency after a device is detached from it, at
least not before KVM can be verified to handle such dynamics in related
emulation paths (wbinvd, vcpu load, write_cr0, ept, etc.). In reality
we don't see an usage requiring such optimization as the only device
which imposes such non-coherency is Intel GPU which even doesn't
support hotplug/hot remove.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c13b9290e357..f4e3b423a453 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2285,9 +2285,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 * testing if they're on the same bus_type.
 	 */
 	list_for_each_entry(d, &iommu->domain_list, next) {
-		if (d->domain->ops == domain->domain->ops &&
-		    d->enforce_cache_coherency ==
-			    domain->enforce_cache_coherency) {
+		if (d->domain->ops == domain->domain->ops) {
 			iommu_detach_group(domain->domain, group->iommu_group);
 			if (!iommu_attach_group(d->domain,
 						group->iommu_group)) {
-- 
2.17.1

