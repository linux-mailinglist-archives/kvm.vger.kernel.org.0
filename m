Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D096553E29C
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 10:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiFFGUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 02:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiFFGUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 02:20:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB2821E0C;
        Sun,  5 Jun 2022 23:19:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZs1Isgo5gYBbEZVXT8C39faLJaXE1cXQRLasDvvbzqMrHpAUMWZzK9/cK9+kyqBYK6OyOxPsWnMsRYDsDgCCCGI6PjsbppkETWBSdowrUwgIkMmECaVoAGoNaX9OfbenXEz9OxGvDWCkZ0Ii/XokAXCdrplFa7x/BcEUE1TzC/EqCncCFBMB5uh1dWY9DhMPnHTVKMqJQo5FZDaVYUhcJWY8HQFYlXiOP1LgTVyb2O9nckVWqW9UFF91S4QdgGDUGeLLjJMvXHoNfDGd0Dg2rhadfEzlmTAj+CgxSWeFe8gAp3tErHwSCRADnKL1Znbqtm4wuvY3em9/wUbjIGWmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lD6En4jLD2A0WwJaY5egXjV7PHtQKwxdT6UcRXfAro=;
 b=WVz3jQaucBxcU3/wthTiL1bXrbIU70YSiSZRMrK3h44uaZaOFgxGzjrLjnkpmPMGMZQve8PoeZJ3+C94e5YGo0/pHrpdbYd/qOXJ/YpN2Mj7HtRSt4yH3zlnmT7j+XvRr/Fg4NI/X5AOnXlieJ4n8o2/cDfY5ZHLuxSna9JNayBZEqlI4GPJ8Fkqc/Hk4FCZFd4qXNUM4aOi75uz5VIf2f3FSs2wwAf+ilzD8a7gLfIFfapk/W02wNgu06qKK0ZhAliRB7/lDEIUtCFwclRkafqDYC+jHNXSVyEubziYq2khEZTq87eP5mQ5n2wjpZwmZriVLVYNURsAlMNVHV4VDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=samsung.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lD6En4jLD2A0WwJaY5egXjV7PHtQKwxdT6UcRXfAro=;
 b=DQ4Bp67Hl7HCHGTOzmnvgy0+KA9n62Y6U2o4hNe9tHjjtTPG/41iHH6piyvxFE/FmC2+9s1+dEXeHO9cuW2doRsQZX1jgczPvbhJtEg50WkQ5OSulArDkorGQMqrWHrR0oU/1VcRpxACGtOegEwPTzmA5sYifczXQZen76CfgSSvO/hHde1r1HvxowYYiDnZlIsA+aLBfly6IvqFKM001ap8GliCprzWX8x7Okl3VBNNLm7l7259ALiZLmMr//bx96Vs3K7gQraLpe5ua5FMQqHiBfaoevoAWrQWUK3X7cLs1V9VkWQVN371VQufS/WLoB9Yqrn4Mdbh8cs2KJ/ytg==
Received: from BN1PR12CA0023.namprd12.prod.outlook.com (2603:10b6:408:e1::28)
 by LV2PR12MB5893.namprd12.prod.outlook.com (2603:10b6:408:175::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Mon, 6 Jun
 2022 06:19:56 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::fd) by BN1PR12CA0023.outlook.office365.com
 (2603:10b6:408:e1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18 via Frontend
 Transport; Mon, 6 Jun 2022 06:19:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 06:19:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 6 Jun
 2022 06:19:54 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 5 Jun 2022
 23:19:53 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 5 Jun 2022 23:19:51 -0700
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
Subject: [PATCH 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
Date:   Sun, 5 Jun 2022 23:19:23 -0700
Message-ID: <20220606061927.26049-2-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220606061927.26049-1-nicolinc@nvidia.com>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b0e22f2-25ab-4220-9b4d-08da4784935c
X-MS-TrafficTypeDiagnostic: LV2PR12MB5893:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB589361D4BA2573B725FA2AE6ABA29@LV2PR12MB5893.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MAESquNyov2hSlN2LefCZ1SDG3fhf1NCMjKy4+Wu3pjUcI0vw3MFZO88F5cIvmMSyFqYY2Ai6CXdvk9eGdjQpBBXglWenu3n1LbkKCv59qoPZRWBPYkluOaztJmLAMbNURV1kw6GShrI20s02fgKL6facc+JU+PbklOF8cKCv89g+xjDmP3cN45D4cKyHJHJU7G4LdjgOWz4p2tccjZ74G7VjPUwaAskilJ0Ksd9MNBLe0ey+YYWcmiwHuyKiHPEM7z57baiZPzqkJdOxDiW4UqCp8Yop89Mk70rgcftvJAPoru1/LCkNN80ovttpZ7kutOsnJgjyQ967e6jOpD+NsGkmds9ClDSvdmENKgd8nKV/qdxSzWKaQw3Mw+BJhQvb/dzTGEOYOAoxcj+aUVeTiH2z3sBl0R+GEkMYygQTL97wWuT6KbcsRhxCYih+BoTzIOGU8Y9RBQYOdUU32ew+vLtvAWwA5QzWEmgS5Iu6V8SqGBIrQD8c/sB0sRoglXvKi6ENJB9FrOL2aDukOvimacO3XhwbYvv3rvbaB0Tgy/o1VLApdfYpcCw5mFHhCdN4sFYly+FPyjXCP+EnPKvfG7680j8/uuK0Slkq1tc1x0zS/NZl8xFNExQvI7WeROd2NapAyHysGp2+yyvI6M0reRBI/mB2CSW6Y18sWK5GKuc4Qg2Gq06Z5kCSMpOCtDJi/aoQDqUU24n39OE/uGE54yEN2nSZbIojFHumwImgE0eGnZyOSAzpkHVt9at3zfBSL4bYizNBDoPKJiDHZJdJQQqyPYTNGPp4xF4daYS6scTK1Pk4Fd8RwhVVSmxZfYKe+X+9brpCYul4LI0VfGKDQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(356005)(1076003)(508600001)(81166007)(4326008)(54906003)(110136005)(36756003)(921005)(70586007)(8676002)(2616005)(186003)(26005)(83380400001)(6666004)(5660300002)(8936002)(2906002)(336012)(47076005)(426003)(7406005)(70206006)(40460700003)(86362001)(316002)(7696005)(36860700001)(82310400005)(7416002)(334744004)(2101003)(83996005)(36900700001)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 06:19:55.8046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0e22f2-25ab-4220-9b4d-08da4784935c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5893
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cases like VFIO wish to attach a device to an existing domain that was
not allocated specifically from the device. This raises a condition
where the IOMMU driver can fail the domain attach because the domain and
device are incompatible with each other.

This is a soft failure that can be resolved by using a different domain.

Provide a dedicated errno from the IOMMU driver during attach that the
reason attached failed is because of domain incompatability. EMEDIUMTYPE
is chosen because it is never used within the iommu subsystem today and
evokes a sense that the 'medium' aka the domain is incompatible.

VFIO can use this to know attach is a soft failure and it should continue
searching. Otherwise the attach will be a hard failure and VFIO will
return the code to userspace.

Update all drivers to return EMEDIUMTYPE in their failure paths that are
related to domain incompatability.

Add kdocs describing this behavior.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/amd/iommu.c                   |  2 +-
 drivers/iommu/apple-dart.c                  |  4 ++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  6 +++---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  2 +-
 drivers/iommu/intel/iommu.c                 |  4 ++--
 drivers/iommu/iommu.c                       | 22 +++++++++++++++++++++
 drivers/iommu/ipmmu-vmsa.c                  |  2 +-
 drivers/iommu/omap-iommu.c                  |  2 +-
 drivers/iommu/virtio-iommu.c                |  2 +-
 9 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 840831d5d2ad..ad499658a6b6 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1662,7 +1662,7 @@ static int attach_device(struct device *dev,
 	if (domain->flags & PD_IOMMUV2_MASK) {
 		struct iommu_domain *def_domain = iommu_get_dma_domain(dev);
 
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		if (def_domain->type != IOMMU_DOMAIN_IDENTITY)
 			goto out;
 
diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index 8af0242a90d9..e58dc310afd7 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -495,10 +495,10 @@ static int apple_dart_attach_dev(struct iommu_domain *domain,
 
 	if (cfg->stream_maps[0].dart->force_bypass &&
 	    domain->type != IOMMU_DOMAIN_IDENTITY)
-		return -EINVAL;
+		return -EMEDIUMTYPE;
 	if (!cfg->stream_maps[0].dart->supports_bypass &&
 	    domain->type == IOMMU_DOMAIN_IDENTITY)
-		return -EINVAL;
+		return -EMEDIUMTYPE;
 
 	ret = apple_dart_finalize_domain(domain, cfg);
 	if (ret)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 88817a3376ef..6c393cd84925 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2424,20 +2424,20 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			"cannot attach to SMMU %s (upstream of %s)\n",
 			dev_name(smmu_domain->smmu->dev),
 			dev_name(smmu->dev));
-		ret = -ENXIO;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 &&
 		   master->ssid_bits != smmu_domain->s1_cfg.s1cdmax) {
 		dev_err(dev,
 			"cannot attach to incompatible domain (%u SSID bits != %u)\n",
 			smmu_domain->s1_cfg.s1cdmax, master->ssid_bits);
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 &&
 		   smmu_domain->stall_enabled != master->stall_enabled) {
 		dev_err(dev, "cannot attach to stall-%s domain\n",
 			smmu_domain->stall_enabled ? "enabled" : "disabled");
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 4c077c38fbd6..a8b63b855ffb 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -386,7 +386,7 @@ static int qcom_iommu_attach_dev(struct iommu_domain *domain, struct device *dev
 			"attached to domain on IOMMU %s\n",
 			dev_name(qcom_domain->iommu->dev),
 			dev_name(qcom_iommu->dev));
-		return -EINVAL;
+		return -EMEDIUMTYPE;
 	}
 
 	return 0;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 44016594831d..0813b119d680 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4323,7 +4323,7 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 		return -ENODEV;
 
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
-		return -EOPNOTSUPP;
+		return -EMEDIUMTYPE;
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
@@ -4334,7 +4334,7 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 		dev_err(dev, "%s: iommu width (%d) is not "
 		        "sufficient for the mapped address (%llx)\n",
 		        __func__, addr_width, dmar_domain->max_addr);
-		return -EFAULT;
+		return -EMEDIUMTYPE;
 	}
 	dmar_domain->gaw = addr_width;
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 847ad47a2dfd..19cf28d40ebe 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1972,6 +1972,17 @@ static int __iommu_attach_device(struct iommu_domain *domain,
 	return ret;
 }
 
+/**
+ * iommu_attach_device - Attach a device to an IOMMU domain
+ * @domain: IOMMU domain to attach
+ * @dev: Device that will be attached
+ *
+ * Returns 0 on success and error code on failure
+ *
+ * Specifically, -EMEDIUMTYPE is returned if the domain and the device are
+ * incompatible in some way. This indicates that a caller should try another
+ * existing IOMMU domain or allocate a new one.
+ */
 int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
 	struct iommu_group *group;
@@ -2098,6 +2109,17 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 	return ret;
 }
 
+/**
+ * iommu_attach_group - Attach an IOMMU group to an IOMMU domain
+ * @domain: IOMMU domain to attach
+ * @dev: IOMMU group that will be attached
+ *
+ * Returns 0 on success and error code on failure
+ *
+ * Specifically, -EMEDIUMTYPE is returned if the domain and the group are
+ * incompatible in some way. This indicates that a caller should try another
+ * existing IOMMU domain or allocate a new one.
+ */
 int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
 {
 	int ret;
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 8fdb84b3642b..e491e410add5 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -630,7 +630,7 @@ static int ipmmu_attach_device(struct iommu_domain *io_domain,
 		 */
 		dev_err(dev, "Can't attach IPMMU %s to domain on IPMMU %s\n",
 			dev_name(mmu->dev), dev_name(domain->mmu->dev));
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 	} else
 		dev_info(dev, "Reusing IPMMU context %u\n", domain->context_id);
 
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index d9cf2820c02e..bbc6c4cd7aae 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1472,7 +1472,7 @@ omap_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	/* only a single client device can be attached to a domain */
 	if (omap_domain->dev) {
 		dev_err(dev, "iommu domain is already attached\n");
-		ret = -EBUSY;
+		ret = -EMEDIUMTYPE;
 		goto out;
 	}
 
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 25be4b822aa0..e3b812d8fa96 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -734,7 +734,7 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		ret = viommu_domain_finalise(vdev, domain);
 	} else if (vdomain->viommu != vdev->viommu) {
 		dev_err(dev, "cannot attach to foreign vIOMMU\n");
-		ret = -EXDEV;
+		ret = -EMEDIUMTYPE;
 	}
 	mutex_unlock(&vdomain->mutex);
 
-- 
2.17.1

