Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6AC563BEB
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 23:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiGAVpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 17:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiGAVpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 17:45:09 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE6E5A2DF;
        Fri,  1 Jul 2022 14:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IChMtKf0R/iOR7pytjbKYjLOU1L1KYEZKnnZKzrBjM6+47ewkuv8QYOFuZOMA3AKjJ8spd0+M5+zvU8TVKQb3VPIZlx5RiES9buJGr9RARe/IbjJdSyUBXbmwk8wCh3P8YasBDNyxPtSumKBPiT2+oNYmcu4lX7xempdfJBFAlsBjvdgYObSBX0qmrl83kYcHKyF5dv3NPj0AVVdN7H6tcwD2/kgPwDCvUJ9+rNvM1GP/uF/Tet5zgqm200cAI0J8wwHB4sySHFZ5MAcKOJDLCeehOSyq8IMCf5EVilggtRYaZw3d613OAb4LKEj7meimIYnnQ/diktg19I4CGu++Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BAJf9+wzngUYHhzYRGKJeseya+Rr4fgAG4Yv4gHz1Kg=;
 b=CXSDQg5jZOt1r3ShhMtVY/vpjXlAZNl0pmni3oSiLXLT1ogUSBwvT2nE+zddUqvUp3AwOhHPozuMlua/CokQasdpQv/XrL6pT0J8LNVVfw08o4YUya3DrM5mGd/F/mNIpgntRguRIp9RlWyWeuLn8+HpQAP0HZe5wSkvG98Eg2wkImXIO9jM+U0rD4cQN+wNM0Zxk27L/tEzXWkfAjL++eXchf16SP/N41KJxEy2eBrdpA+h89Sd6GbWtIlokx/QPgWXEbA+fsMGZiOkK0eoF1qzg1OOrmCWxDCVads8mxDE3fj6k+qgxsVor5SbLR+shwt/nENobmCNYAxKd6fMOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAJf9+wzngUYHhzYRGKJeseya+Rr4fgAG4Yv4gHz1Kg=;
 b=krk6YGqIzh3tA392esqpjNXhRwYlsQXhG0PiCOBduoZr6sEHHwhxlplpzIiKuoe4rgFUeTHBfX1SFhuIk98yADwt2pV7KIHCFij/TMHwI7xNxw/Uw+f7kECkwtzdxpryO6ena/1Fk1i1RHmBmX9J8plnvezr3sQNxPrN1SMsr9vvA+YmJt8QFld7Dno6DgfASm81iNbDQkkebYuKRyD7boHx7Vi3peX5PJ/Qx4dm+m5lZ1z0zLFk7smN/wO1vu/a1yR5UBFTZw2oY3LgRN8PNlgMEUAIXi7j+27h4ZUWLQ4o4K1wrUpzgGNgnWYers898R9mfxw7pLK20zzHl771iQ==
Received: from BN6PR20CA0059.namprd20.prod.outlook.com (2603:10b6:404:151::21)
 by CY5PR12MB6622.namprd12.prod.outlook.com (2603:10b6:930:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 21:45:05 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::18) by BN6PR20CA0059.outlook.office365.com
 (2603:10b6:404:151::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Fri, 1 Jul 2022 21:45:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Fri, 1 Jul 2022 21:45:04 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 1 Jul
 2022 21:45:04 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 1 Jul 2022
 14:45:03 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 14:45:01 -0700
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
Subject: [PATCH v5 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
Date:   Fri, 1 Jul 2022 14:44:51 -0700
Message-ID: <20220701214455.14992-2-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220701214455.14992-1-nicolinc@nvidia.com>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d96553b-de02-4f2c-962a-08da5baaf5b2
X-MS-TrafficTypeDiagnostic: CY5PR12MB6622:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?s4f4/lP0JusuAN091ATJrZ/fq9i0bO35KQWSGK0/o3eB95FF9Sv/Y4rUwXfx?=
 =?us-ascii?Q?7+OYLFtprKMLY93fpSMzaxkEcu5u/brVCuuCQPwLVX6Fb1wzfd0YryXzIIwB?=
 =?us-ascii?Q?ujMMWkuwBoCV6RdqhMgwKBN/+k5HvQZedl85Dxe1lNL7daSpnLk9xNEVVPZe?=
 =?us-ascii?Q?lMkyiqFh9cOSVQEOoowanXlpzaa8tetCP74lZA5mL3ugrVV8tLHfKi839YQ2?=
 =?us-ascii?Q?UarhsrjqpFcsFYhkrZF3ukXumzpZDI2GZHDa4t2T4lcRBF+ET57zCIw3xLu+?=
 =?us-ascii?Q?w/NKFigRWGRdQU6mXtTuDVCZt4bfabeyzXMbMFpH++PDgmTf9szfwnPt1csx?=
 =?us-ascii?Q?mYwGiXYLMePlB86zTNbPZqc9fghvJsLqHIVoizOzBBEYTJFb+gB92znh1AC7?=
 =?us-ascii?Q?b2IsKDBE3ukMPr47E/DZ0RnOmENUSGRcom2LYW84hwfY2+GnzHwdgoewQdAd?=
 =?us-ascii?Q?HwTYbReUgbZ/fnBoqaVdWInCJwzgwkr2NDMUp8ztZC/vIhjoWGE75y+RT8th?=
 =?us-ascii?Q?DDAWPSLFqX8MWWUCqJ/Sn3V7m2lS5EdWsXflCmTjlyzxzGTA6ebpey1IBJek?=
 =?us-ascii?Q?Kr5cdE2O7JoJKnCae8eQyp7IVSUv6Hda58uyzhpuXSw/8eEeJKonOv8MYPjs?=
 =?us-ascii?Q?DUmtOzOl5CUkm9EflCOmIqlt7WfSusBekx9THgoNpO7+Bu6/FQqes1Lqe5x2?=
 =?us-ascii?Q?twk0Cv3n7KkNmru5FKezKChHkgtTvVJ8Fbh3ykfGGVrnd0SN3nrZl34rM3/p?=
 =?us-ascii?Q?sxHqvCyUKk27jJZGT0FBNGOGh8zjELpTUKbU2SxQCTArSEsX/T+eEX6k86nP?=
 =?us-ascii?Q?89V/nHhlZaSD5xc4wkD/2LUyWfOTp9di9AY6bx9mdXks1IvIgObZsO35CzCB?=
 =?us-ascii?Q?M2V9X6iq0suzJeEsP8DOCIOVwVSb6U7IQPoPZZdNPIUeYpC7AOAJq4adG3Wh?=
 =?us-ascii?Q?EluJT7XfVIfYSwMgziDKzCY6Bout6SLU60c0JcLmkHg=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(136003)(346002)(36840700001)(40470700004)(46966006)(82310400005)(36756003)(40480700001)(316002)(5660300002)(7406005)(70586007)(110136005)(30864003)(8936002)(8676002)(4326008)(7416002)(2906002)(54906003)(86362001)(478600001)(36860700001)(2616005)(6666004)(70206006)(426003)(1076003)(7696005)(47076005)(336012)(186003)(41300700001)(83380400001)(356005)(82740400003)(81166007)(40460700003)(921005)(26005)(334744004)(36900700001)(83996005)(2101003)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 21:45:04.8536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d96553b-de02-4f2c-962a-08da5baaf5b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6622
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 88817a3376ef..5b64138f549d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2420,24 +2420,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
index 2ed3594f384e..4b95673be076 100644
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
index 4c077c38fbd6..8372f985c14a 100644
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
index 44016594831d..db5fb799e350 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4323,19 +4323,15 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
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
index 847ad47a2dfd..5b0afe39275e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1972,6 +1972,20 @@ static int __iommu_attach_device(struct iommu_domain *domain,
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
@@ -2098,6 +2112,20 @@ static int __iommu_attach_group(struct iommu_domain *domain,
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
index 8fdb84b3642b..82d63394b166 100644
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
index bd409bab6286..f6ae230ca1cd 100644
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
index a6700a40a6f8..011c33e6ae31 100644
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
index 25be4b822aa0..a41a62dccb4d 100644
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

