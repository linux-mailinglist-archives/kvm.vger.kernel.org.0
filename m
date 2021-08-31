Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3273FC152
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 05:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239726AbhHaDIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 23:08:49 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:1313
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239476AbhHaDIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 23:08:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byZuiMxhePIjzqu2ZS9Jc5R60mDSc466ZcLWLhTpDDvBs8EyFlQDVDts2zdqmRlo0ZQNL8nKnrq+Gf74BmKwdYX5nRMUmQiJdBFGQxunyD7GSZidwFYvdwzEaPdeXnMjy1DhyJthr+MrZMQHCcfI4ASttWOY52a8wm+q72QGFYcH1et6Y7xiOA7aMyGdIcZeK3qCIS/G2ERm8tx/JaMFf/f4feXo/0g1+yUPUTceosINdsp6trGeRdSaOEfIuR5O519i+SuQ97mhQwNI6q/oabb/YMPk6Q+naH47kRMq7hHgSyRHDszOlFnyFsaIyBmWgbZHBFpD1kFc7gp9ptaDHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3MA/nnJIPzUVRSO/l+hNQzhL1G87DEel6bj6v2O+WA=;
 b=khWeHUwPclBczAtm3zLhMPeRMnqi7E+N+JCBy594s7pRR/1S0DOTQ0c1+4ewm3ZnopqcPFic8ktJstk3iJJrJZ/6iNgepZAWEFG7v2bRvaNz9gbzlfUB0Zk6RfRbjZM/gH0DNYIvM/jmhFelV6KoVRBEefOO7e4TBiS1QZngSg0YgC6fHHGHAiNmUADjJMHeTTKIqzcYyvjAf/qGyUHgUw5OXhhjXhfBtfl0nyfHaBOSHl1gYwsC5Tj0AK6nTvll4uFgBZH4fnSRt9OVGwtfOYPA3CZ8NAS1vwHR2dDYBZQ2BzJ9fGGQvIjgXSRO8Zy0nWZgnuTKfu8uypU+cQ69Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3MA/nnJIPzUVRSO/l+hNQzhL1G87DEel6bj6v2O+WA=;
 b=Fm0Kg/MeCp4H059djrWX3oH5nRAbR/FH4ur8OBYASOZ2kPYqofsz0UCl/7TcwnU22FbAoRdK+lszVFv3K6nyVgCsUmxs7WmUKRUvDjhBYsmUmvPlnf82Hy6GRxayUKRWVnB6BNAusJwjBBz8J9hvfI26sPfFP1F6wgXcJ+j7hshQ+Lk/NKEmkLv0fgNWrTbm2HeR9d7a1mpKkRDawcoBldotxIwGPKhiAdUL8D0qT9ifIGeyKL+fn0hGQM5f52qvNmc3mdxOunFUiyjcmZb04FGW+wTnK8uCAbY4i6fvZzPoIml+f3CbOmuCXbIveEqYRIXgsHh8a5fqkk459w+0Pw==
Received: from MWHPR07CA0022.namprd07.prod.outlook.com (2603:10b6:300:116::32)
 by DM5PR12MB1595.namprd12.prod.outlook.com (2603:10b6:4:3::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.23; Tue, 31 Aug 2021 03:07:33 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::1f) by MWHPR07CA0022.outlook.office365.com
 (2603:10b6:300:116::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 03:07:33 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Aug
 2021 03:07:31 +0000
Received: from Asurada-Nvidia.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:31 +0000
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>, <corbet@lwn.net>
CC:     <nicoleotsuka@gmail.com>, <vdumpa@nvidia.com>,
        <thierry.reding@gmail.com>, <linux-tegra@vger.kernel.org>,
        <nwatterson@nvidia.com>, <Jonathan.Cameron@huawei.com>,
        <jean-philippe@linaro.org>, <song.bao.hua@hisilicon.com>,
        <eric.auger@redhat.com>, <thunder.leizhen@huawei.com>,
        <yuzenghui@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [RFC][PATCH v2 09/13] iommu/arm-smmu-v3: Pass dev pointer to arm_smmu_detach_dev
Date:   Mon, 30 Aug 2021 19:59:19 -0700
Message-ID: <20210831025923.15812-10-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fb0a8dd-ad65-4ee9-5896-08d96c2c7a0a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1595:
X-Microsoft-Antispam-PRVS: <DM5PR12MB15953EAEE85F61C07DF0A7D4ABCC9@DM5PR12MB1595.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LPfNiHWT4Omk8Vh9rBMlSkgMrnl4dbUIJQWOssst0nxkQG+Hbna4yTUEfw23iPApnG2NvIDdRPT05/E2UNTh+QedHInlexzeGe0gid56FE+tw3lUzPojQc83FAV7hsYR1giRPRMHPzQzM0NCJihasxDYbERWTvy4w+VvHQCUsYXpXPO/4HzDoFkXLcZlEnuLR3vIxaLXCBwmG735D5ryp4BM7FER7lYmjpPJFkalsgHaEv/4rXKIrNgi0tx90mJNbY0/m0DimUI9U3nJAKqUFKC1Rd9xQLUXrp6zzCHv7mJz7ZxO7Vn91DsZzb31Yx8jeAksqvo8B+/+qxBhrENYcpVGRIez8PrwsGNoaE8gmJAMzGlr39pTWHgo4lWj5r/EIZgV1EsqILCOXQECO/mcPTLLup7q6+D8+USpdWqK9ggg/8fS63uirtMt9r3T+toIhbX/+xJPlvCVKxLaev6o1pVs4axT/vSeXDqq0DS8Wbn5W0yKxLWg0NcRpNaf8eSYdSuIEcrcHaAM2DSOTl+o2Dd/fzyJ5E+dv59GO9jtxsa6ov8VloJa5LNk9Vv7KTKNy46/Er/gPDJzrm/3fd9QOxGoHqMRide4LFME9Lq5yTH4ME2x11xKbzXuZsu6MpCdjwE2Nz5B7A6Ne2EHVBsP6VjBoMN1YIV2LTGKb3VklWuu01g88qzhK5qaRqzm4+MyaAtV2SIoav0HnLzj6FLqzslDlih8+63DMpE5XV0eJxk=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(70206006)(82740400003)(47076005)(1076003)(7636003)(5660300002)(86362001)(316002)(186003)(110136005)(36906005)(70586007)(356005)(83380400001)(26005)(478600001)(36756003)(36860700001)(8676002)(6666004)(2906002)(54906003)(426003)(82310400003)(336012)(8936002)(7696005)(7416002)(4326008)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 03:07:33.0345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb0a8dd-ad65-4ee9-5896-08d96c2c7a0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1595
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are adding NVIDIA implementation that will need a ->detach_dev()
callback along with the dev pointer to grab client information.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 497d55ec659b..6878a83582b9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2377,7 +2377,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 	pci_disable_pasid(pdev);
 }
 
-static void arm_smmu_detach_dev(struct arm_smmu_master *master)
+static void arm_smmu_detach_dev(struct arm_smmu_master *master, struct device *dev)
 {
 	unsigned long flags;
 	struct arm_smmu_domain *smmu_domain = master->domain;
@@ -2421,7 +2421,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		return -EBUSY;
 	}
 
-	arm_smmu_detach_dev(master);
+	arm_smmu_detach_dev(master, dev);
 
 	mutex_lock(&smmu_domain->init_mutex);
 
@@ -2713,7 +2713,7 @@ static void arm_smmu_release_device(struct device *dev)
 	master = dev_iommu_priv_get(dev);
 	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
 		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
-	arm_smmu_detach_dev(master);
+	arm_smmu_detach_dev(master, dev);
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
 	kfree(master);
-- 
2.17.1

