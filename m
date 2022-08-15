Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1705934E0
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 20:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbiHOSRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 14:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239461AbiHOSQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 14:16:33 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1242E2B191;
        Mon, 15 Aug 2022 11:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/OJAhF2xpsKnJRO+Z5+X4q3n1iyccisPiJkfEPv9oJcEE+PrX8x4EZ70qluBFO3GNUOvHp95xCg1/KauoE7YaaRKn0cVv9bQUKGuHTYtNXqYGVJj9r3sgV4tIg1n2OpGBjJ9QfhuUJjZUu86S8h/2KX+k3P3JuzNF6IVfNAq4LzgcY1m+t5JJP3qj8YLny/CAPP16zNOd2ArecX87QqJ6+Q42q9LL4m+fnhPZtKjICULWRLZciCJFL4MopHL92lf0zM5YWQKDETLHnpINIBj3X2TQK7jH8EV7zFHI6/LrMrxtFS4TKjBKusCl+Yk/V6Dpj/1CLfj6lC/JvnP4q8uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfuIw8r2VprovpFieVxl3HwAyp4VFvyCxXd9MG/xlT8=;
 b=BKQnujqpNl0qY/1Q7I+Tqm1wcrNKn6337eK+wFge1FHywCL4wpBSAG20YRKs3Kykmkeod8AYpi1SN/TVmDkdhbLtKwgJW5B/i101tVbdcSkq16HNNzL0xfla7RvITukd4qlfnjnx4IkMStKjVesk5D87CIWAczO7BFNhXPB7lqmOyb9TZpDcZBIzvLyTWgLexkNvbLwwFRjhx1pf7tTsdosZOsMNmC+L5pToJnl6BJxgFM2vRcK2TiYeZGWbFcbcjvd5URRMSNx1ghJg/80MUywwymCew8Lk4QQGXujZ777tpLeOWoOLtK1L/DiU+Hj2zmmmyPT+BjG8EdUZjnMJFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=rosenzweig.io smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfuIw8r2VprovpFieVxl3HwAyp4VFvyCxXd9MG/xlT8=;
 b=aNq02Vi7ApzOKILgUyL1JCumiPISeaC+t6jH2IjDXMy7Vj/dBRpAohiFvL8HNjbEtzTtuTIta+vSgVlDBS5T5K9csTIeHAg8iaPwqj2aWRS08sqiMEEIhzuFEBj2gsHrsNpzeyVMGyAxCBy7U20lXnO/mjYeiCVB1CnTZcSiNDYDVHo3FAHXjaB7zrEitK9JhaQrYrgS0JaFEN4Qmr18ZeHls9u7qSETWsHz4tGwyUg/OPE+YkWauObM3FDiClJ67mHGVOqinyi+2rypPJg7ma/h1H2IZ4rdSBEi5TV2a32HNwRJ1RiVbTgVrQpKPGjL6svPMaHpfNha4eXW8PKgZw==
Received: from BN8PR15CA0056.namprd15.prod.outlook.com (2603:10b6:408:80::33)
 by BL1PR12MB5270.namprd12.prod.outlook.com (2603:10b6:208:31e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 18:14:49 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::12) by BN8PR15CA0056.outlook.office365.com
 (2603:10b6:408:80::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12 via Frontend
 Transport; Mon, 15 Aug 2022 18:14:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Mon, 15 Aug 2022 18:14:48 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 18:14:47 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 11:14:47 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 11:14:46 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <alex.williamson@redhat.com>
CC:     <suravee.suthikulpanit@amd.com>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <alyssa@rosenzweig.io>,
        <robdclark@gmail.com>, <dwmw2@infradead.org>,
        <baolu.lu@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <orsonzhai@gmail.com>,
        <baolin.wang@linux.alibaba.com>, <zhang.lyra@gmail.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <jean-philippe@linaro.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <tglx@linutronix.de>,
        <shameerali.kolothum.thodi@huawei.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <yangyingliang@huawei.com>, <jon@solid-run.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <asahi@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>
Subject: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
Date:   Mon, 15 Aug 2022 11:14:33 -0700
Message-ID: <20220815181437.28127-2-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220815181437.28127-1-nicolinc@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2794b503-8b13-4f9e-01af-08da7eea0a83
X-MS-TrafficTypeDiagnostic: BL1PR12MB5270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Df6JL2AdNs2b/gPU45ctyeBfbQyhpEnRbkF1EWi+GpzvZ9gNaQaOaPE8Muv9rl3hUVMmtw6pHiL4gZQaBpKVN+nPjdMVJKQlEgjzXb4zGAYVWexlv3kwbX2gdZTJyM+GBDP8FvAUpc66BK5UrEWh8PTNOC1oQNMoCaGirjOzJ0zT8gj5BEaUq0lbm08+a3BkW2Q/eK8MiVaAPSh/3mstMXKIBK1vRjKeNBF/kqdFpi9kBagtH8Ge1sVHGVZaDKFoEYqLbv0PptRZIBnbzvZomlyqAcJ1NzPI7EdaPvBq0UMy9kJi8VTKagJy6xggPHIRIef71Fkj4OFoHpeh2Rt81HJnq18q72J6GPozJZssTgPTOg9hjDOtw+6reDGpdPv1p8NbNJnVjB6+C+D2yDeQQuYRxpwEbUK9bb6ZVjoX1nI8cQyzxr5tIsf4YEp+iFbajHoPs1iZ2LBpC2lEo8mjuAK29yitXDr5YRsV8PbNxYsaQllIGT/dY4XnlqBGYxOZzjCO7vcVW/GeDp5SFZL/RWPFTaC0fF27o1vGtxO0Lr+7hqZ04LuFTneQSu2BshzXkwmzkHBNIv6RMGYrvVAxW4PyWtCxxGNlJ/X9ZFYrooOoGLxGp7bmuPnQsD0a33Qi4H9iDqQDWWOgJ+83dueSz+gvmCl1YNMCCrAHBBH5qTKWnjUxbQSgsh68zJdNDwE4v1yGxov4Zm5thsN6syHYR6NmTABWIjJhk/VOCgxfV/iu/qQKB2ZtdgnoYtXd2wSGj5p0PBLqTr9jCy+rh9Eb46x1DCmzOEFfz9kC3xTXk/rnhC9zi0k+0exAkdeA/rNnHXQxI3dPKXrMvraK3BkFtRVKQI3gKfVtWKLaf48Q5rClrmMuFdU0NGTcrOW5GDPOspnqXXBf/sSlJBkPyG7XzA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(40470700004)(36840700001)(7406005)(7416002)(40460700003)(1076003)(5660300002)(8936002)(40480700001)(2906002)(26005)(356005)(86362001)(30864003)(81166007)(82310400005)(41300700001)(426003)(186003)(7696005)(36860700001)(6666004)(2616005)(336012)(47076005)(83380400001)(478600001)(4326008)(8676002)(316002)(82740400003)(70206006)(54906003)(110136005)(70586007)(36756003)(334744004)(36900700001)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 18:14:48.7651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2794b503-8b13-4f9e-01af-08da7eea0a83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5270
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
related to domain incompatability. Also remove adjacent error prints for
these soft failures, to prevent a kernel log spam, since -EMEDIUMTYPE is
clear enough to indicate an incompatability error.

Add kdocs describing this behavior.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/amd/iommu.c                   |  2 +-
 drivers/iommu/apple-dart.c                  |  4 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 +++--------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  5 +---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  9 ++-----
 drivers/iommu/intel/iommu.c                 | 10 +++-----
 drivers/iommu/iommu.c                       | 28 +++++++++++++++++++++
 drivers/iommu/ipmmu-vmsa.c                  |  4 +--
 drivers/iommu/omap-iommu.c                  |  3 +--
 drivers/iommu/s390-iommu.c                  |  2 +-
 drivers/iommu/sprd-iommu.c                  |  6 ++---
 drivers/iommu/tegra-gart.c                  |  2 +-
 drivers/iommu/virtio-iommu.c                |  3 +--
 13 files changed, 47 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 65b8e4fd8217..6a5bd0cfc06a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1755,7 +1755,7 @@ static int attach_device(struct device *dev,
 	if (domain->flags & PD_IOMMUV2_MASK) {
 		struct iommu_domain *def_domain = iommu_get_dma_domain(dev);
 
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		if (def_domain->type != IOMMU_DOMAIN_IDENTITY)
 			goto out;
 
diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index 1b1725759262..87f1829d24ea 100644
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
index d32b02336411..a3717961d248 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2429,24 +2429,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			goto out_unlock;
 		}
 	} else if (smmu_domain->smmu != smmu) {
-		dev_err(dev,
-			"cannot attach to SMMU %s (upstream of %s)\n",
-			dev_name(smmu_domain->smmu->dev),
-			dev_name(smmu->dev));
-		ret = -ENXIO;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 &&
 		   master->ssid_bits != smmu_domain->s1_cfg.s1cdmax) {
-		dev_err(dev,
-			"cannot attach to incompatible domain (%u SSID bits != %u)\n",
-			smmu_domain->s1_cfg.s1cdmax, master->ssid_bits);
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 &&
 		   smmu_domain->stall_enabled != master->stall_enabled) {
-		dev_err(dev, "cannot attach to stall-%s domain\n",
-			smmu_domain->stall_enabled ? "enabled" : "disabled");
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index dfa82df00342..26af6d923321 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1167,10 +1167,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 * different SMMUs.
 	 */
 	if (smmu_domain->smmu != smmu) {
-		dev_err(dev,
-			"cannot attach to SMMU %s whilst already attached to domain on SMMU %s\n",
-			dev_name(smmu_domain->smmu->dev), dev_name(smmu->dev));
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		goto rpm_put;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 17235116d3bb..0daee6d8d993 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -381,13 +381,8 @@ static int qcom_iommu_attach_dev(struct iommu_domain *domain, struct device *dev
 	 * Sanity check the domain. We don't support domains across
 	 * different IOMMUs.
 	 */
-	if (qcom_domain->iommu != qcom_iommu) {
-		dev_err(dev, "cannot attach to IOMMU %s while already "
-			"attached to domain on IOMMU %s\n",
-			dev_name(qcom_domain->iommu->dev),
-			dev_name(qcom_iommu->dev));
-		return -EINVAL;
-	}
+	if (qcom_domain->iommu != qcom_iommu)
+		return -EMEDIUMTYPE;
 
 	return 0;
 }
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7cca030a508e..560d2c3e9304 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4174,19 +4174,15 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 		return -ENODEV;
 
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
-		return -EOPNOTSUPP;
+		return -EMEDIUMTYPE;
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
 	if (addr_width > cap_mgaw(iommu->cap))
 		addr_width = cap_mgaw(iommu->cap);
 
-	if (dmar_domain->max_addr > (1LL << addr_width)) {
-		dev_err(dev, "%s: iommu width (%d) is not "
-		        "sufficient for the mapped address (%llx)\n",
-		        __func__, addr_width, dmar_domain->max_addr);
-		return -EFAULT;
-	}
+	if (dmar_domain->max_addr > (1LL << addr_width))
+		return -EMEDIUMTYPE;
 	dmar_domain->gaw = addr_width;
 
 	/*
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 780fb7071577..d7416f6d9bab 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1975,6 +1975,20 @@ static int __iommu_attach_device(struct iommu_domain *domain,
 	return ret;
 }
 
+/**
+ * iommu_attach_device - Attach a device to an IOMMU domain
+ * @domain: IOMMU domain to attach
+ * @dev: Device that will be attached
+ *
+ * Returns 0 on success and error code on failure
+ *
+ * Specifically, -EMEDIUMTYPE is returned as a soft failure if the domain and
+ * the device are incompatible in some way. This indicates that a caller should
+ * try another existing IOMMU domain or allocate a new one. And note that it's
+ * recommended to keep kernel print free when reporting -EMEDIUMTYPE error, as
+ * this function can be called to test compatibility with domains that will fail
+ * the test, which will result in a kernel log spam.
+ */
 int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
 	struct iommu_group *group;
@@ -2101,6 +2115,20 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 	return ret;
 }
 
+/**
+ * iommu_attach_group - Attach an IOMMU group to an IOMMU domain
+ * @domain: IOMMU domain to attach
+ * @group: IOMMU group that will be attached
+ *
+ * Returns 0 on success and error code on failure
+ *
+ * Specifically, -EMEDIUMTYPE is returned as a soft failure if the domain and
+ * the device are incompatible in some way. This indicates that a caller should
+ * try another existing IOMMU domain or allocate a new one. And note that it's
+ * recommended to keep kernel print free when reporting -EMEDIUMTYPE error, as
+ * this function can be called to test compatibility with domains that will fail
+ * the test, which will result in a kernel log spam.
+ */
 int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
 {
 	int ret;
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 1d42084d0276..0103480648cb 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -628,9 +628,7 @@ static int ipmmu_attach_device(struct iommu_domain *io_domain,
 		 * Something is wrong, we can't attach two devices using
 		 * different IOMMUs to the same domain.
 		 */
-		dev_err(dev, "Can't attach IPMMU %s to domain on IPMMU %s\n",
-			dev_name(mmu->dev), dev_name(domain->mmu->dev));
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 	} else
 		dev_info(dev, "Reusing IPMMU context %u\n", domain->context_id);
 
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index d9cf2820c02e..6bc8925726bf 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1471,8 +1471,7 @@ omap_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	/* only a single client device can be attached to a domain */
 	if (omap_domain->dev) {
-		dev_err(dev, "iommu domain is already attached\n");
-		ret = -EBUSY;
+		ret = -EMEDIUMTYPE;
 		goto out;
 	}
 
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index c898bcbbce11..ddcb78b284bb 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -127,7 +127,7 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	/* Allow only devices with identical DMA range limits */
 	} else if (domain->geometry.aperture_start != zdev->start_dma ||
 		   domain->geometry.aperture_end != zdev->end_dma) {
-		rc = -EINVAL;
+		rc = -EMEDIUMTYPE;
 		spin_unlock_irqrestore(&s390_domain->list_lock, flags);
 		goto out_restore;
 	}
diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
index 511959c8a14d..2bc1d34981cc 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -237,10 +237,8 @@ static int sprd_iommu_attach_device(struct iommu_domain *domain,
 	struct sprd_iommu_domain *dom = to_sprd_domain(domain);
 	size_t pgt_size = sprd_iommu_pgt_size(domain);
 
-	if (dom->sdev) {
-		pr_err("There's already a device attached to this domain.\n");
-		return -EINVAL;
-	}
+	if (dom->sdev)
+		return -EMEDIUMTYPE;
 
 	dom->pgt_va = dma_alloc_coherent(sdev->dev, pgt_size, &dom->pgt_pa, GFP_KERNEL);
 	if (!dom->pgt_va)
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index e5ca3cf1a949..9d81cc467651 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -112,7 +112,7 @@ static int gart_iommu_attach_dev(struct iommu_domain *domain,
 	spin_lock(&gart->dom_lock);
 
 	if (gart->active_domain && gart->active_domain != domain) {
-		ret = -EBUSY;
+		ret = -EMEDIUMTYPE;
 	} else if (dev_iommu_priv_get(dev) != domain) {
 		dev_iommu_priv_set(dev, domain);
 		gart->active_domain = domain;
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 08eeafc9529f..6172763c69b8 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -733,8 +733,7 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		 */
 		ret = viommu_domain_finalise(vdev, domain);
 	} else if (vdomain->viommu != vdev->viommu) {
-		dev_err(dev, "cannot attach to foreign vIOMMU\n");
-		ret = -EXDEV;
+		ret = -EMEDIUMTYPE;
 	}
 	mutex_unlock(&vdomain->mutex);
 
-- 
2.17.1

