Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000975589C3
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiFWUCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiFWUBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:01:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E7038BDA;
        Thu, 23 Jun 2022 13:01:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRbTCqaqKCDwb1tE0z/IcOKc8JVrg4gv8gFlmXo1sXJwkkT5sA0xQYBKjNBU/JD2tUcEoTRbCFth/05RBmqviGesfahmQwfOUkN5XQ8P5lPPdw3P7qyWmwMs3ztSY+o9O+sWsm8uhqDSGZprMA+jcfixNlJO9JFwWB42bYyA/cZ50i+y2j7hbmOWJtg7V1i6C+rAJo7482COyzF4TiOwONLLn0xdhJfCtenmSl0A0R7mjFXqZXlAMJF3Gbb4Defkgh+KorRQrsxa9g4GvPqGP5kA/oFVIhgqanCj5bemWsB+Et02I7WpQTBODxZt3LEj8iXbxlRD7+E/Rd3cYRkaBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lQkyMkplKbQHcqGH5YFAzHcgEPv2A86aLtKZgyrHgk=;
 b=m8sHzo1qEfl/z7pcwkaV5sUQCDsBuVLnL7ZXnLMdzyFUenY1XIPYGzhBv4Vun1YMOfDCH10YtdHQU3S2NGQr47qsbdyLOoRiGMJQc9AbIUSjQLhbDtPsAabUijOHMZkWDr1pbK7frACBa3DSTO1qPyw5s5Zgk1rmfJS82x+v39tDllycAnPs1lOk2Vxqa0glUNEqWPWg9qMJNdm36maa/RP0ZSlCm+m2gfzQkmOagpv55OddSAKxOUAH07vEgTOB8rp/plRjFEqGZLdD0SyD3wB4BJgjMT6hwUCCIJyKE8EJvgLyBZgSze2jKV+gWOYp6irSUqloMMXQV8RNooISVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lQkyMkplKbQHcqGH5YFAzHcgEPv2A86aLtKZgyrHgk=;
 b=HDvnVV0v2CSYvIYqvi4KIowz8s+szJOh4D7QY6Tb1Fhzcjb1AURyMtgSHX0KeJxboafrJXMKFgV4lcgg5geDfIlirPefGp+933Pgk6XbOX77MC7+9lmNm6OeNYmN030nh5wOZ7d71OR4qjTtCC9UUoohaYTRAwzZoVdCBl4mt/IUnNZMNUnKxPYSUeQXjuZU0OGvtrwDTKmHtvFNIysAR8Vzuz/Ttq9gmDIFINMD6CapWkb8ZEt8MKPMMjwsFyPr7/68gFOYJJl2Dtp4Qe8ak0R+O0cb6aA6T9/4Fnsi8Wg6ziY773OPK+RHsZSUukcT4xcKR1xzV1W1WhFLYTuq2A==
Received: from DM6PR14CA0054.namprd14.prod.outlook.com (2603:10b6:5:18f::31)
 by BN9PR12MB5129.namprd12.prod.outlook.com (2603:10b6:408:136::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Thu, 23 Jun
 2022 20:01:45 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::f5) by DM6PR14CA0054.outlook.office365.com
 (2603:10b6:5:18f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19 via Frontend
 Transport; Thu, 23 Jun 2022 20:01:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 20:01:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 20:01:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 13:01:43 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 23 Jun 2022 13:01:41 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <yong.wu@mediatek.com>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <chenxiang66@hisilicon.com>, <christophe.jaillet@wanadoo.fr>,
        <john.garry@huawei.com>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 5/5] vfio/iommu_type1: Simplify group attachment
Date:   Thu, 23 Jun 2022 13:00:29 -0700
Message-ID: <20220623200029.26007-6-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623200029.26007-1-nicolinc@nvidia.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36d7d09a-9a4e-4e66-cf69-08da55533300
X-MS-TrafficTypeDiagnostic: BN9PR12MB5129:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNhZireHiuSNVSHTJm/ZOZYocFVGm3ljZzYLTM3RW6sJDJ/yg4f6RngPQcMoqXvMjNa1J9Hm9xHrsvoWD3UmFTQ2VgaXfCHLJGAK/BPdclhVBq8YdQH7L+TB0g7k2DuLmpnZyF5lrWb8R0WKocEfR7azZAoeROzlAKa6WxqC3tpFvwQySCRXjf+Mavr322XS97b0FEe4qiv80X7jVQhF2+/L4vyjgzUNSGqY7/V8OBwvhzv1xX9m0Al0wb1de6+5yvmyyw9XLKduDGvB56HOYToczfrVovJFnbGuH2lmIE0ppT4XSIO3LKh233maJQau0ax/Yy2ei3IMfuXNCeww6sQoa/DGD5W79vDx/fa9TPAIAkJj38v9S/t25lmUn/B1s7VLzZrdWvGr7/JIns6msF9cB+cH/22hL1H3kvDxSVrBht3JXimssJshw0QiPlx0aiQtq/AqbcKASR+hudsqWHyuTvcpObMk6VbcDlmVqGkaC1mwmbvmgmdU/2Pw9Y6fNUva8MFag3eRXzGbprC3Z1VwEphYlvIwskpdLqFU5ZN2Fr5ohU51OaqCop2M7T5H0JEoLajc2wMn2LtrBPBBfDYVGPcAXFVwOD+kUITEuP6ii5wsiMSdTJQp/hQEElTLw4S2cUAwEMnNCBgL6wqasC6PbCWL20cbEYoFKQOljpJYG3gKy9gBzVl5EIpE8HCM7V09PO+5m6wVUaSjU52MBjMxCVwKWPkYSTXLKrAjoAk3vb/9EusqIMUOhkTLoYkPe/6xA74ar+ZfM564khezE4PLn4Li8uj8QmEHzupYdgYU1ZyRTlkokofnW7PP/GgN9Y5QaBmZJi8vXCpg8Iy73467YdOAgj5bJ0jYzpRuZRPg9nJckrsq0YfFr5gvb7BjiMCy6R88iwNy4sxsHKaGjw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(346002)(376002)(36840700001)(46966006)(40470700004)(5660300002)(30864003)(36756003)(40480700001)(86362001)(7696005)(7406005)(70586007)(7416002)(54906003)(70206006)(110136005)(40460700003)(316002)(2906002)(8676002)(478600001)(356005)(186003)(36860700001)(81166007)(41300700001)(82310400005)(4326008)(8936002)(921005)(26005)(336012)(426003)(2616005)(47076005)(82740400003)(6666004)(83380400001)(1076003)(2101003)(83996005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:01:45.0965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d7d09a-9a4e-4e66-cf69-08da55533300
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5129
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 321 +++++++++++++++++---------------
 1 file changed, 174 insertions(+), 147 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b9ccb3cfac5d..3ffa4e2d9d18 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2153,15 +2153,174 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
+static struct vfio_domain *
+vfio_iommu_alloc_attach_domain(struct bus_type *bus, struct vfio_iommu *iommu,
+			       struct vfio_iommu_group *group,
+			       struct list_head *group_resv_regions)
+{
+	struct iommu_domain *new_domain;
+	struct vfio_domain *domain;
+	phys_addr_t resv_msi_base;
+	int ret = 0;
+
+	/* Try to match an existing compatible domain */
+	list_for_each_entry (domain, &iommu->domain_list, next) {
+		ret = iommu_attach_group(domain->domain, group->iommu_group);
+		/* -EMEDIUMTYPE means an incompatible domain, so try next one */
+		if (ret == -EMEDIUMTYPE)
+			continue;
+		if (ret)
+			return ERR_PTR(ret);
+		goto done;
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
+	if (vfio_iommu_has_sw_msi(group_resv_regions, &resv_msi_base)) {
+		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
+		if (ret && ret != -ENODEV)
+			goto out_free_domain;
+	}
+
+	INIT_LIST_HEAD(&domain->group_list);
+	list_add(&domain->next, &iommu->domain_list);
+	vfio_update_pgsize_bitmap(iommu);
+
+done:
+	list_add(&group->next, &domain->group_list);
+
+	/*
+	 * An iommu backed group can dirty memory directly and therefore
+	 * demotes the iommu scope until it declares itself dirty tracking
+	 * capable via the page pinning interface.
+	 */
+	iommu->num_non_pinned_groups++;
+
+	return domain;
+
+out_free_domain:
+	kfree(domain);
+out_detach:
+	iommu_detach_group(new_domain, group->iommu_group);
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
+		goto out_dirty;
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
+	vfio_update_pgsize_bitmap(iommu);
+
+out_dirty:
+	/*
+	 * Removal of a group without dirty tracking may allow the iommu scope
+	 * to be promoted.
+	 */
+	if (!group->pinned_page_dirty_scope) {
+		iommu->num_non_pinned_groups--;
+		if (iommu->dirty_page_tracking)
+			vfio_iommu_populate_bitmap_full(iommu);
+	}
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
-	bool resv_msi, msi_remap;
-	phys_addr_t resv_msi_base = 0;
+	bool msi_remap;
 	struct iommu_domain_geometry *geo;
 	LIST_HEAD(iova_copy);
 	LIST_HEAD(group_resv_regions);
@@ -2197,26 +2356,17 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_free_group;
 
-	ret = -ENOMEM;
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
+	ret = iommu_get_group_resv_regions(iommu_group, &group_resv_regions);
+	if (ret)
 		goto out_free_group;
 
-	ret = -EIO;
-	domain->domain = iommu_domain_alloc(bus);
-	if (!domain->domain)
-		goto out_free_domain;
-
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
+	domain = vfio_iommu_alloc_attach_domain(bus, iommu, group,
+						&group_resv_regions);
+	if (IS_ERR(domain)) {
+		ret = PTR_ERR(domain);
+		goto out_free_group;
 	}
 
-	ret = iommu_attach_group(domain->domain, group->iommu_group);
-	if (ret)
-		goto out_domain;
-
 	/* Get aperture info */
 	geo = &domain->domain->geometry;
 	if (vfio_iommu_aper_conflict(iommu, geo->aperture_start,
@@ -2225,10 +2375,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_detach;
 	}
 
-	ret = iommu_get_group_resv_regions(iommu_group, &group_resv_regions);
-	if (ret)
-		goto out_detach;
-
 	if (vfio_iommu_resv_conflict(iommu, &group_resv_regions)) {
 		ret = -EINVAL;
 		goto out_detach;
@@ -2252,11 +2398,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_detach;
 
-	resv_msi = vfio_iommu_has_sw_msi(&group_resv_regions, &resv_msi_base);
-
-	INIT_LIST_HEAD(&domain->group_list);
-	list_add(&group->next, &domain->group_list);
-
 	msi_remap = irq_domain_check_msi_remap() ||
 		    iommu_capable(bus, IOMMU_CAP_INTR_REMAP);
 
@@ -2267,107 +2408,25 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
-	/* Try to match an existing compatible domain */
-	list_for_each_entry(d, &iommu->domain_list, next) {
-		iommu_detach_group(domain->domain, group->iommu_group);
-		if (!iommu_attach_group(d->domain, group->iommu_group)) {
-			list_add(&group->next, &d->group_list);
-			iommu_domain_free(domain->domain);
-			kfree(domain);
-			goto done;
-		}
-
-		ret = iommu_attach_group(domain->domain,  group->iommu_group);
-		if (ret)
-			goto out_domain;
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
-		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
-		if (ret && ret != -ENODEV)
-			goto out_detach;
-	}
-
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
@@ -2482,44 +2541,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
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
-		}
-		/*
-		 * Removal of a group without dirty tracking may allow
-		 * the iommu scope to be promoted.
-		 */
-		if (!group->pinned_page_dirty_scope) {
-			iommu->num_non_pinned_groups--;
-			if (iommu->dirty_page_tracking)
-				vfio_iommu_populate_bitmap_full(iommu);
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

