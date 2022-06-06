Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56EDF53E37A
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 10:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiFFGU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 02:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiFFGUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 02:20:10 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5362A21E0B;
        Sun,  5 Jun 2022 23:20:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMbTNfsQzZZ4Hu4qxRN2xdahDyj1n2imrw9YtdF0ZVkWdgw46P4qx66u8y6dP6lncvNcLcpH+1zsL7amCYCMyN+qJLNXda4GvCftu+AQO4M48/c74khbsDKU3B/JEJJQ2gYHU/A2BVDZTfasFzJoxhJ/gMfZm9gWrisO3mTgIN9W5Cj8Zzjzq/739CMjQJzt8t3w5ZhTRbQwWnrDQRochhDXYo3OyJWf6d5zu7HG/2CQ9FQe++efqE5zVQ2JIeHqVpHMdDMc5MKgmUHKRXboWxPRdFyKWq3oYiKJX9mk5wrQj+KghBtbHtSvZ0PlF9yQxHWTNOprdmZHfbyMZVK2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8B+c+H2V+bCnzCJetNz/ttkZvQqE/XCS0a2agveDiyc=;
 b=MTSAv9EdIrbVQU0RbsIpUvsH5rvxCIC+WYiry5QSzrvgl02B/9zxxqxlb9KqC9GAvGFBWXCAbZRoo9Oq51bKITFL/Hrx7ppk5y77/o8n1vL8AHfXeHYUAvf5LSK8zi+3dGOxLR8A33asY8mBo4eqRe0dVnisP/rkbJrjUvz0hwUA7ognpr7vIF6TpwPSGuZkOHVNwdvbJUp1WvrhgAjuPBVIbeWtUXOTT2V+5NO9dLyrkjHuY+2aPKqDpkDPgO2e4Q2zALeFnEJw5MtpMKFi4RdZVdtvY/Wz7TpIcczXr6UdynXdAeC7uMOlbKUa2LwptOUfI2wfv7/oQbdQzS9aaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=samsung.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8B+c+H2V+bCnzCJetNz/ttkZvQqE/XCS0a2agveDiyc=;
 b=H2+4eFhBXOQACIvRHWsHO018QqmROfBzKwfUz+n7RdbMNflN1GdFKX2hd2kl9v/VN7EO5eP3TjiKyLbN+CwLgQJ9OrJ2XFD5EpzqKNyis2vUchqoUSg1MnHy6lnez+DrNB/ycmbTr8Pe3pnHCuhleI9dXZP3MtZuUcGlf5Zh3b1AWN/zn7t5jvifAIylp94XCgZhaZBWABttPpNg+96mxLstBHOs7qn6cM/fwQcagkvvTuEfZtpDpfvLmrO3VKCy+4IqDvh+Wj0PecwyKfeVCovyvtNlros0iINDa2vp4bxsLOWdP9nJhFiDQoZBGnifQuji6w/o57jDl2kXRIwMxA==
Received: from BN9PR03CA0604.namprd03.prod.outlook.com (2603:10b6:408:106::9)
 by DM6PR12MB3801.namprd12.prod.outlook.com (2603:10b6:5:1cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Mon, 6 Jun
 2022 06:20:06 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::7) by BN9PR03CA0604.outlook.office365.com
 (2603:10b6:408:106::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Mon, 6 Jun 2022 06:20:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 06:20:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 6 Jun
 2022 06:20:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 5 Jun 2022
 23:20:03 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 5 Jun 2022 23:20:01 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <joro@8bytes.org>, <will@kernel.org>,
        <marcan@marcan.st>, <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <m.szyprowski@samsung.com>,
        <krzysztof.kozlowski@linaro.org>, <baolu.lu@linux.intel.com>,
        <agross@kernel.org>, <bjorn.andersson@linaro.org>,
        <matthias.bgg@gmail.com>, <heiko@sntech.de>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <alim.akhtar@samsung.com>, <dwmw2@infradead.org>,
        <yong.wu@mediatek.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-rockchip@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-sunxi@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH 5/5] vfio/iommu_type1: Simplify group attachment
Date:   Sun, 5 Jun 2022 23:19:27 -0700
Message-ID: <20220606061927.26049-6-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220606061927.26049-1-nicolinc@nvidia.com>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0965645e-e480-4d14-69be-08da4784994f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3801:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3801A1221DF32B1824A1EA93ABA29@DM6PR12MB3801.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YvfS3ssPqqS5158rpVqrnyBXpmtW8PgI33WsDidNZ53bZQHUsl8rq3mpdGppPdocv/bcj7I0tB4TDIiXkNQ/BHchidxrvIm9AQntNRVyds4Z9Sxv+7q3rMqTboYh2Z9g96ngDSyKrmt66x81CVDPTOP9zT5mfi2MJWr4Ff5GpC8gV8OinO0yawsmanxxKDOX22+ptl4Wk6v7CrJsgm/apOI66ehzXr3cRURFWr4kSuytX2urfvGDthYpV9vSeBmUYGlnAu0qE4a2dDU4heI8nOOcS1xN7MJomELyCKFyV1r5xtYN9XNPaxsFEXxJorrmsQxY2vAL73vj7IaTh7Dh2c5Pti+Q5LB6nQ+0PMb+rbNSa9HPSIIKiY8WC14YV2l//rVR0eT+W7fUFHQdv+81JGaFOs9GKaVV72T2/lQpVpJBSUMrES8pvK78nieglpm3uCs3lL3wKxmYN6G+bfBqKNFwS6vXLW28cGaNd4ESEhBDohCjMv0Mbpd4ZGyxMnE7nClZPHI2OZg7njWg6YGRSeVoDtZZW0deXOObO2/Z47hR+tlA0LywS4FQXsLAczlvrezR8hsLwEMlKM/0eeRH4y4tp6+dwPfBOn0/DH2CO6NaXhg4E6cAw1yqIwZiwb9da7KSUiqHnQTX4PyrRxB0rXHP4aFOixDj9zsUbWB3CfJiHWzFOgocnN5ZdzXWQYltWKVmziqbV2BM7Fmp4rlb0iVEpA3/ioQECZ4/kbyIsoYRS+oWIa/6qEGHAa0KHv7LwUkQnFav5co4tjMW0OgKLw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(47076005)(30864003)(7416002)(7406005)(70586007)(426003)(36756003)(356005)(70206006)(921005)(8676002)(1076003)(82310400005)(36860700001)(4326008)(5660300002)(8936002)(186003)(336012)(83380400001)(81166007)(2616005)(40460700003)(26005)(7696005)(2906002)(6666004)(316002)(86362001)(508600001)(54906003)(110136005)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 06:20:05.7845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0965645e-e480-4d14-69be-08da4784994f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3801
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Un-inline the domain specific logic from the attach/detach_group ops into
two paired functions vfio_iommu_alloc_attach_domain() and
vfio_iommu_detach_destroy_domain() that strictly deal with creating and
destroying struct vfio_domains.

Add the logic to check for EMEDIUMTYPE return code of iommu_attach_group()
and avoid the extra domain allocations and attach/detach sequences of the
old code. This allows properly detecting an actual attach error, like
-ENOMEM, vs treating all attach errors as an incompatible domain.

Remove the duplicated domain->ops comparison that is taken care of in the
IOMMU core.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 306 +++++++++++++++++---------------
 1 file changed, 161 insertions(+), 145 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b45b1cc118ef..c6f937e1d71f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -86,6 +86,7 @@ struct vfio_domain {
 	struct list_head	group_list;
 	bool			fgsp : 1;	/* Fine-grained super pages */
 	bool			enforce_cache_coherency : 1;
+	bool			msi_cookie : 1;
 };
 
 struct vfio_dma {
@@ -2153,12 +2154,161 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
+static struct vfio_domain *
+vfio_iommu_alloc_attach_domain(struct bus_type *bus, struct vfio_iommu *iommu,
+			       struct vfio_iommu_group *group)
+{
+	struct iommu_domain *new_domain;
+	struct vfio_domain *domain;
+	int ret = 0;
+
+	/* Try to match an existing compatible domain */
+	list_for_each_entry (domain, &iommu->domain_list, next) {
+		ret = iommu_attach_group(domain->domain, group->iommu_group);
+		if (ret == -EMEDIUMTYPE)
+			continue;
+		if (ret)
+			return ERR_PTR(ret);
+		list_add(&group->next, &domain->group_list);
+		return domain;
+	}
+
+	new_domain = iommu_domain_alloc(bus);
+	if (!new_domain)
+		return ERR_PTR(-EIO);
+
+	if (iommu->nesting) {
+		ret = iommu_enable_nesting(new_domain);
+		if (ret)
+			goto out_free_iommu_domain;
+	}
+
+	ret = iommu_attach_group(new_domain, group->iommu_group);
+	if (ret)
+		goto out_free_iommu_domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain) {
+		ret = -ENOMEM;
+		goto out_detach;
+	}
+
+	domain->domain = new_domain;
+	vfio_test_domain_fgsp(domain);
+
+	/*
+	 * If the IOMMU can block non-coherent operations (ie PCIe TLPs with
+	 * no-snoop set) then VFIO always turns this feature on because on Intel
+	 * platforms it optimizes KVM to disable wbinvd emulation.
+	 */
+	if (new_domain->ops->enforce_cache_coherency)
+		domain->enforce_cache_coherency =
+			new_domain->ops->enforce_cache_coherency(new_domain);
+
+	/* replay mappings on new domains */
+	ret = vfio_iommu_replay(iommu, domain);
+	if (ret)
+		goto out_free_domain;
+
+	/*
+	 * An iommu backed group can dirty memory directly and therefore
+	 * demotes the iommu scope until it declares itself dirty tracking
+	 * capable via the page pinning interface.
+	 */
+	iommu->num_non_pinned_groups++;
+
+	INIT_LIST_HEAD(&domain->group_list);
+	list_add(&group->next, &domain->group_list);
+	list_add(&domain->next, &iommu->domain_list);
+	vfio_update_pgsize_bitmap(iommu);
+	return domain;
+
+out_free_domain:
+	kfree(domain);
+out_detach:
+	iommu_detach_group(domain->domain, group->iommu_group);
+out_free_iommu_domain:
+	iommu_domain_free(new_domain);
+	return ERR_PTR(ret);
+}
+
+static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
+{
+	struct rb_node *node;
+
+	while ((node = rb_first(&iommu->dma_list)))
+		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
+}
+
+static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
+{
+	struct rb_node *n, *p;
+
+	n = rb_first(&iommu->dma_list);
+	for (; n; n = rb_next(n)) {
+		struct vfio_dma *dma;
+		long locked = 0, unlocked = 0;
+
+		dma = rb_entry(n, struct vfio_dma, node);
+		unlocked += vfio_unmap_unpin(iommu, dma, false);
+		p = rb_first(&dma->pfn_list);
+		for (; p; p = rb_next(p)) {
+			struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn,
+							 node);
+
+			if (!is_invalid_reserved_pfn(vpfn->pfn))
+				locked++;
+		}
+		vfio_lock_acct(dma, locked - unlocked, true);
+	}
+}
+
+static void vfio_iommu_detach_destroy_domain(struct vfio_domain *domain,
+					     struct vfio_iommu *iommu,
+					     struct vfio_iommu_group *group)
+{
+	iommu_detach_group(domain->domain, group->iommu_group);
+	list_del(&group->next);
+	if (!list_empty(&domain->group_list))
+		return;
+
+	/*
+	 * Group ownership provides privilege, if the group list is empty, the
+	 * domain goes away. If it's the last domain with iommu and external
+	 * domain doesn't exist, then all the mappings go away too. If it's the
+	 * last domain with iommu and external domain exist, update accounting
+	 */
+	if (list_is_singular(&iommu->domain_list)) {
+		if (list_empty(&iommu->emulated_iommu_groups)) {
+			WARN_ON(iommu->notifier.head);
+			vfio_iommu_unmap_unpin_all(iommu);
+		} else {
+			vfio_iommu_unmap_unpin_reaccount(iommu);
+		}
+	}
+	iommu_domain_free(domain->domain);
+	list_del(&domain->next);
+	kfree(domain);
+
+	/*
+	 * Removal of a group without dirty tracking may allow the iommu scope
+	 * to be promoted.
+	 */
+	if (!group->pinned_page_dirty_scope) {
+		iommu->num_non_pinned_groups--;
+		if (iommu->dirty_page_tracking)
+			vfio_iommu_populate_bitmap_full(iommu);
+	}
+
+	vfio_update_pgsize_bitmap(iommu);
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 		struct iommu_group *iommu_group, enum vfio_group_type type)
 {
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_iommu_group *group;
-	struct vfio_domain *domain, *d;
+	struct vfio_domain *domain;
 	struct bus_type *bus = NULL;
 	bool resv_msi, msi_remap;
 	phys_addr_t resv_msi_base = 0;
@@ -2197,26 +2347,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_free_group;
 
-	ret = -ENOMEM;
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
+	domain = vfio_iommu_alloc_attach_domain(bus, iommu, group);
+	if (IS_ERR(domain)) {
+		ret = PTR_ERR(domain);
 		goto out_free_group;
-
-	ret = -EIO;
-	domain->domain = iommu_domain_alloc(bus);
-	if (!domain->domain)
-		goto out_free_domain;
-
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
 	}
 
-	ret = iommu_attach_group(domain->domain, group->iommu_group);
-	if (ret)
-		goto out_domain;
-
 	/* Get aperture info */
 	geo = &domain->domain->geometry;
 	if (vfio_iommu_aper_conflict(iommu, geo->aperture_start,
@@ -2254,9 +2390,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	resv_msi = vfio_iommu_has_sw_msi(&group_resv_regions, &resv_msi_base);
 
-	INIT_LIST_HEAD(&domain->group_list);
-	list_add(&group->next, &domain->group_list);
-
 	msi_remap = irq_domain_check_msi_remap() ||
 		    iommu_capable(bus, IOMMU_CAP_INTR_REMAP);
 
@@ -2267,117 +2400,32 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_detach;
 	}
 
-	/*
-	 * If the IOMMU can block non-coherent operations (ie PCIe TLPs with
-	 * no-snoop set) then VFIO always turns this feature on because on Intel
-	 * platforms it optimizes KVM to disable wbinvd emulation.
-	 */
-	if (domain->domain->ops->enforce_cache_coherency)
-		domain->enforce_cache_coherency =
-			domain->domain->ops->enforce_cache_coherency(
-				domain->domain);
-
-	/*
-	 * Try to match an existing compatible domain.  We don't want to
-	 * preclude an IOMMU driver supporting multiple bus_types and being
-	 * able to include different bus_types in the same IOMMU domain, so
-	 * we test whether the domains use the same iommu_ops rather than
-	 * testing if they're on the same bus_type.
-	 */
-	list_for_each_entry(d, &iommu->domain_list, next) {
-		if (d->domain->ops == domain->domain->ops) {
-			iommu_detach_group(domain->domain, group->iommu_group);
-			if (!iommu_attach_group(d->domain,
-						group->iommu_group)) {
-				list_add(&group->next, &d->group_list);
-				iommu_domain_free(domain->domain);
-				kfree(domain);
-				goto done;
-			}
-
-			ret = iommu_attach_group(domain->domain,
-						 group->iommu_group);
-			if (ret)
-				goto out_domain;
-		}
-	}
-
-	vfio_test_domain_fgsp(domain);
-
-	/* replay mappings on new domains */
-	ret = vfio_iommu_replay(iommu, domain);
-	if (ret)
-		goto out_detach;
-
-	if (resv_msi) {
+	if (resv_msi && !domain->msi_cookie) {
 		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
 		if (ret && ret != -ENODEV)
 			goto out_detach;
+		domain->msi_cookie = true;
 	}
 
-	list_add(&domain->next, &iommu->domain_list);
-	vfio_update_pgsize_bitmap(iommu);
-done:
 	/* Delete the old one and insert new iova list */
 	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
 
-	/*
-	 * An iommu backed group can dirty memory directly and therefore
-	 * demotes the iommu scope until it declares itself dirty tracking
-	 * capable via the page pinning interface.
-	 */
-	iommu->num_non_pinned_groups++;
 	mutex_unlock(&iommu->lock);
 	vfio_iommu_resv_free(&group_resv_regions);
 
 	return 0;
 
 out_detach:
-	iommu_detach_group(domain->domain, group->iommu_group);
-out_domain:
-	iommu_domain_free(domain->domain);
-	vfio_iommu_iova_free(&iova_copy);
-	vfio_iommu_resv_free(&group_resv_regions);
-out_free_domain:
-	kfree(domain);
+	vfio_iommu_detach_destroy_domain(domain, iommu, group);
 out_free_group:
 	kfree(group);
 out_unlock:
 	mutex_unlock(&iommu->lock);
+	vfio_iommu_iova_free(&iova_copy);
+	vfio_iommu_resv_free(&group_resv_regions);
 	return ret;
 }
 
-static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
-{
-	struct rb_node *node;
-
-	while ((node = rb_first(&iommu->dma_list)))
-		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
-}
-
-static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
-{
-	struct rb_node *n, *p;
-
-	n = rb_first(&iommu->dma_list);
-	for (; n; n = rb_next(n)) {
-		struct vfio_dma *dma;
-		long locked = 0, unlocked = 0;
-
-		dma = rb_entry(n, struct vfio_dma, node);
-		unlocked += vfio_unmap_unpin(iommu, dma, false);
-		p = rb_first(&dma->pfn_list);
-		for (; p; p = rb_next(p)) {
-			struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn,
-							 node);
-
-			if (!is_invalid_reserved_pfn(vpfn->pfn))
-				locked++;
-		}
-		vfio_lock_acct(dma, locked - unlocked, true);
-	}
-}
-
 /*
  * Called when a domain is removed in detach. It is possible that
  * the removed domain decided the iova aperture window. Modify the
@@ -2491,44 +2539,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		group = find_iommu_group(domain, iommu_group);
 		if (!group)
 			continue;
-
-		iommu_detach_group(domain->domain, group->iommu_group);
-		list_del(&group->next);
-		/*
-		 * Group ownership provides privilege, if the group list is
-		 * empty, the domain goes away. If it's the last domain with
-		 * iommu and external domain doesn't exist, then all the
-		 * mappings go away too. If it's the last domain with iommu and
-		 * external domain exist, update accounting
-		 */
-		if (list_empty(&domain->group_list)) {
-			if (list_is_singular(&iommu->domain_list)) {
-				if (list_empty(&iommu->emulated_iommu_groups)) {
-					WARN_ON(iommu->notifier.head);
-					vfio_iommu_unmap_unpin_all(iommu);
-				} else {
-					vfio_iommu_unmap_unpin_reaccount(iommu);
-				}
-			}
-			iommu_domain_free(domain->domain);
-			list_del(&domain->next);
-			kfree(domain);
-			vfio_iommu_aper_expand(iommu, &iova_copy);
-			vfio_update_pgsize_bitmap(iommu);
-			/*
-			 * Removal of a group without dirty tracking may allow
-			 * the iommu scope to be promoted.
-			 */
-			if (!group->pinned_page_dirty_scope) {
-				iommu->num_non_pinned_groups--;
-				if (iommu->dirty_page_tracking)
-					vfio_iommu_populate_bitmap_full(iommu);
-			}
-		}
+		vfio_iommu_detach_destroy_domain(domain, iommu, group);
 		kfree(group);
 		break;
 	}
 
+	vfio_iommu_aper_expand(iommu, &iova_copy);
 	if (!vfio_iommu_resv_refresh(iommu, &iova_copy))
 		vfio_iommu_iova_insert_copy(iommu, &iova_copy);
 	else
-- 
2.17.1

