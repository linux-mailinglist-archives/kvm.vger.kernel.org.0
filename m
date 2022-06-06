Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84A253E226
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 10:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiFFGUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 02:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiFFGUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 02:20:07 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BF721E0B;
        Sun,  5 Jun 2022 23:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmFuRlq4B4zmQhM4Y9wGdVA1y94RhEqErEs1UibVsoG+O7WxlQkABLa0+q5k31/4SBFRl0be9BUazhuveu9ZW8nlRXTZfNk9xOMY1NqmkP9jxbmxZnUw3TDhG+OcrZU1OfKJp2CVtT5fxXK4FUQzwT6jwTG7BOk15tUY6Y1ix2jRsyJTyO1mfXEo3S3FlAKrUIYD2fOcXuTFX9f/VN0XcoAJma0Bt6W+/3hYWfYFSNItO2KLfNojreKr2y5Dqy6qetQL/srLp4k8NISB6v2VszpBnO4SLo2kClAOfkBXWsvHfEFdA4cglrHB2KXLnRWqCJb3VvSuwVoD9Q26c71lcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vJi8j8ipUwYoCOTfV3pczsa/F9LbUb944CBW72LYXQ=;
 b=jMXGB+b3mxbfgb6jruDlFAOcHDinm211tGnDCeiGv4CcKZqwEaxijRgVBGNGmuuL6gYzVdKSChD4PmeW6V4ZxkjNpEnVT+VT1af3u5lR1BvwCk6ArbT3nxQyobNEFw/ePx2x5SltRxGXOCrdbkX5a7yTtBDx6P+qKkCy4gwkgcntNAdEpGRmbNoxLfqFjGaJbV00NGOABgNEYROxdcamTz60/ET151ziUm9EEriKHhim+eA39nNySgm3MGKb07or31aCWgS4zqrRGJKwg1SrtqLLfvQsWqmpJjHIO5x8HVZzLNZ3dwrx9E6amP3Gg5X0rnCPVmIiO4s27kNnpTnuxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=samsung.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vJi8j8ipUwYoCOTfV3pczsa/F9LbUb944CBW72LYXQ=;
 b=Y9mxZ2H14k4Swu3gnZ+EN4wHTmyF8OH8NOJ0m0SoMC1g3YMKG/AhS30MQcRdJvl2pOK/D2G4LB5hp6Rn1yYzxQE5O+c1KabLg31D79SJHajoSuLTOKvcX6MDs/Mx7sBZJ8OOdH0nJNtfnJzbX6CfoYEA0XEjOQ+MTAonuIBWFQWVk5BbqfyE0bNjbv3cD3vIqKSLjPte0EFfy4vSTGqtQoiWneXPmlc2NYQWIxvpzZyJrvp5Z9KOxZaIgZ2dqZWggRTKk6fsfD4s7r2DCFI43Z6V/QHR20VqRwD7C74rg1KHW+dHBPCWotMzDPaLBT+Wz/cjiZLUy7DYi+RminIoUw==
Received: from DM6PR07CA0116.namprd07.prod.outlook.com (2603:10b6:5:330::13)
 by LV2PR12MB5848.namprd12.prod.outlook.com (2603:10b6:408:173::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 06:20:04 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::3) by DM6PR07CA0116.outlook.office365.com
 (2603:10b6:5:330::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13 via Frontend
 Transport; Mon, 6 Jun 2022 06:20:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 06:20:03 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 6 Jun
 2022 06:20:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 5 Jun 2022
 23:20:01 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 5 Jun 2022 23:19:59 -0700
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
Subject: [PATCH 4/5] vfio/iommu_type1: Clean up update_dirty_scope in detach_group()
Date:   Sun, 5 Jun 2022 23:19:26 -0700
Message-ID: <20220606061927.26049-5-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220606061927.26049-1-nicolinc@nvidia.com>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dec089d7-760e-4a1c-a1ee-08da478497fd
X-MS-TrafficTypeDiagnostic: LV2PR12MB5848:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5848FC09B20B51B5588AF464ABA29@LV2PR12MB5848.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJTkLbx5IPx/ufeIfWPJtNWb2YjIH1e0tlNwLL3W7ptuwVGCNN/EQOR5eUkaVNHjTudD/133+wd0AO8oq/10vfkHliTEeDiey1/fWClQAAnsbQNyAGQSVuD5cMdFkU4tKWa/f+OPtwFC7mn9NQUcsP4QOPmkY1rsgJ9G/mek4AZRmKy9q81B4vEuilPo+oTg33pObpU7l3y3g8SXnyA7WW/HI5mUsrplSidaQopeVMyhuG2ftIjVV+azHYq9i0BBbU+cnXWTCFiHDAlugK5ijQpmBtTqlT6CBRDLl4APD3mDiHIzUGSodS4ar7WxUVnm5t0MsEcmyy1zh/NqtfwDRDW6+gD6i61egyYq8yCmz9PvBllAsoEg6OpdDG99HfXXufRE9FscFKd1mklK3pl0jL+FlAMM+MNQX6eKHRjnHlxzMDHnU8JOHGZlMKW1N/hIv9Nxv4MfgDGPGVvyefilUOJ4YsiCUvss0EnJGmReCglgYRo+wQ7oRbf6wU5i/xlXspF5vCbU5u6OM4huulnTmmyfTCMxqqLwkAGsLJGFdT1e+ktwoVNd9Lhz+nxBsdCQYKhRCA+xXpeXKnPUVThLpEuzQcK/ZIeJpgVOssgm/w9B3vznsoU9vb4nIVXymKj05swFG/ydpSN5o5gtCJltd3pHrEJOaZ6K3uBSZdEDkZEVNhc8AzjCgLe6jOZxJz5ZKlIZCvhzv9MtdV5/tfbFrca09/7zdHC5MxICsXaknJfQiN0ZsutPXhlw9hD3Q1TQzhoQUOJ2Q9z0sMrH62CFNw10fSVG3pt73iNdOTA+KKA=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(336012)(426003)(2616005)(47076005)(316002)(1076003)(70206006)(54906003)(83380400001)(110136005)(70586007)(6666004)(2906002)(7696005)(15650500001)(36756003)(508600001)(8936002)(7406005)(7416002)(40460700003)(4326008)(26005)(5660300002)(82310400005)(8676002)(36860700001)(86362001)(81166007)(356005)(921005)(14143004)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 06:20:03.6489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dec089d7-760e-4a1c-a1ee-08da478497fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5848
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All devices in emulated_iommu_groups have pinned_page_dirty_scope
set, so the update_dirty_scope in the first list_for_each_entry
is always false. Clean it up, and move the "if update_dirty_scope"
part from the detach_group_done routine to the domain_list part.

Rename the "detach_group_done" goto label accordingly.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f4e3b423a453..b45b1cc118ef 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2463,14 +2463,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_domain *domain;
 	struct vfio_iommu_group *group;
-	bool update_dirty_scope = false;
 	LIST_HEAD(iova_copy);
 
 	mutex_lock(&iommu->lock);
 	list_for_each_entry(group, &iommu->emulated_iommu_groups, next) {
 		if (group->iommu_group != iommu_group)
 			continue;
-		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
 		kfree(group);
 
@@ -2479,7 +2477,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			WARN_ON(iommu->notifier.head);
 			vfio_iommu_unmap_unpin_all(iommu);
 		}
-		goto detach_group_done;
+		goto out_unlock;
 	}
 
 	/*
@@ -2495,9 +2493,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			continue;
 
 		iommu_detach_group(domain->domain, group->iommu_group);
-		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
-		kfree(group);
 		/*
 		 * Group ownership provides privilege, if the group list is
 		 * empty, the domain goes away. If it's the last domain with
@@ -2519,7 +2515,17 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			kfree(domain);
 			vfio_iommu_aper_expand(iommu, &iova_copy);
 			vfio_update_pgsize_bitmap(iommu);
+			/*
+			 * Removal of a group without dirty tracking may allow
+			 * the iommu scope to be promoted.
+			 */
+			if (!group->pinned_page_dirty_scope) {
+				iommu->num_non_pinned_groups--;
+				if (iommu->dirty_page_tracking)
+					vfio_iommu_populate_bitmap_full(iommu);
+			}
 		}
+		kfree(group);
 		break;
 	}
 
@@ -2528,16 +2534,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	else
 		vfio_iommu_iova_free(&iova_copy);
 
-detach_group_done:
-	/*
-	 * Removal of a group without dirty tracking may allow the iommu scope
-	 * to be promoted.
-	 */
-	if (update_dirty_scope) {
-		iommu->num_non_pinned_groups--;
-		if (iommu->dirty_page_tracking)
-			vfio_iommu_populate_bitmap_full(iommu);
-	}
+out_unlock:
 	mutex_unlock(&iommu->lock);
 }
 
-- 
2.17.1

