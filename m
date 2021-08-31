Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222263FC155
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 05:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbhHaDJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 23:09:00 -0400
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:38753
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239499AbhHaDIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 23:08:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jg7BPAWLhXDhRvKEar3yOrmd8jTiF8Ut+qaLU9Xg+ApqPgAb6cva/JA9yNbfTqYMUUgnQKtj9MLpYVs7n0m5/Lq+tfVYQX7qohJ03JoM077Er/cpefdYvXVvCwZ7P0oexMLqEiNFAB5E1BMffnFIQrciWFacpg+X0J285N+TjZgZ1TGeRf76VqTsyWeGBJ50HbijUhkcXj6rCN31/rQxCH/hAzkkwufj16y6D16cZTAPPA3cMYAMU08Xk0Ml5vXED7dhE6JszeBCcHgIwvIQAwlKGkBkhHZZl9fw/9ggD99hN475lnwBYB24/X6L57bhj3Ona1gXIp+7nNjEEtV9Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q+ODDv46OwMeWVxF1FFigBBMi3IbtSEoUn2InhM6po=;
 b=ZR5xYMpLV4iNwzG0M9yZ6kh6HbZHxEyfLaCB2pWs/i0aqAS9vS7jui8ZT0UHMhfBb2c07EDuPMB41UOzdNlRG+UVXmQmyf6JxFXe9foKK1yM+goZtVTj9eDTvZ/SzjtMpa2HGXGnzbr/VuZ8pDNlUDaAHYQaC+0n5YmOACtrXrMPzzuwGZmSuCsgaU05ivZ2q6NDvFYggCXthZT1l7/9G6Gh10FkkHbkpJ+ZLPd+VaZ3XDnnTBLsCfUiJsNQOWsqVHCpKZHa/RYX6Wr6IdFdj5XIlkJ8EJxZzVlRlAJtxvTsN0NgbbPOPk1AL/ebAm8YIc9DSBTpB1DoQEGO1o10dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q+ODDv46OwMeWVxF1FFigBBMi3IbtSEoUn2InhM6po=;
 b=cMe4HMkhUylX45lGyZPrri1Q5IiNp5z7UQUqkTrstpIL5QUqYV0pRDR3uEHp1RIpPm6tj1pcN4jMyrU2tcnw+7YiOJzJacbN1fHovM+/OrQLIouOv2af6YCBu7LqDMFnUzK+e63vksOs11AxevGDJw5GNcHQr+Qv3UlA+fs0zeqW5Ob/xb+SzOTmfUMiNs89xIakM1bHrfbP2RjPGy4iWfLCdWaK7p9NXtDA9wviZ2rC0+SQMTdCSpKsBE32wqgxYrELQVb+oiLwb6DLG7Sr2VITQnNQ5E56RYB5fJtlCDgxzId9QaoKSU9oB5VaZczZ8qr4oJuiKT8APzm4rQZADg==
Received: from BN6PR16CA0041.namprd16.prod.outlook.com (2603:10b6:405:14::27)
 by SN1PR12MB2430.namprd12.prod.outlook.com (2603:10b6:802:30::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Tue, 31 Aug
 2021 03:07:35 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::70) by BN6PR16CA0041.outlook.office365.com
 (2603:10b6:405:14::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 03:07:34 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Aug
 2021 20:07:32 -0700
Received: from Asurada-Nvidia.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:32 +0000
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
Subject: [RFC][PATCH v2 11/13] iommu/arm-smmu-v3: Add implementation infrastructure
Date:   Mon, 30 Aug 2021 19:59:21 -0700
Message-ID: <20210831025923.15812-12-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2afdddf8-9d34-45b1-7101-08d96c2c7b09
X-MS-TrafficTypeDiagnostic: SN1PR12MB2430:
X-Microsoft-Antispam-PRVS: <SN1PR12MB243097F34B30DA6E2AE6FFD6ABCC9@SN1PR12MB2430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pr8d9RCZajpsf5YFtdIZQ+IYwEEVNsaxJ+lUtBDvuFVOO5+0boWYjXoNB+2f5GKbD6qltWQ28BU1baul07pl+A0YH/lx+eoB8kj+FJtE/z8J5yAAjrzBBE6ERmfQlxz7mOy+MWK0Zw2xBlGZMZibcWfnyKupWkTtbWwqJHi49mAJf5uZcT/XYLW5gIU3Jv3gnl6We+GUUFRR86d7Xu0HN29Zsq6zMVVhrzJqyI/xcDCXXJNCTY2Pur/8qpSbsp94Ehxl6sPhlqhGKRIGlogbNLwrdU4zhPDO/hGx/3DLZUGQjldyH61IpmAt3XvGpK+Q3FfmOjn5HrF4Hy0ajB3CErJWtT+YI3GviWlJyW7FqT7uRx+OT80VOVWr/2kTPae1dYlIkMOSK5Ngx8uk3/qXJiMnQUHkYx7THxIsMPrghxbmnbToM1N4WwKNhKQFZ6ANNMZvDTptTA4uHa1zvHf+WL1lieJkPnT+Yf077bKy5+3e9ETkrWalG2DUv7qWEQaEW7O9zlzTS5id4Zkl0ZgfVMNC4aPyU0YBxU4dD6JNAiTj9lBQs9txrCqXurKgr7vpdPVHDkgCT+YklrVPTy94RRcWNZB4JI9WstCPzXNgixjf8WLawHjwa0JyeKJtgH3EudkahGB5Y2KJCmiXs8g6UYcFu+kxhcAExuc2/Dcd8GpDm90FJ4idXMnInXi5YE2BKc9YPpVWN6k0POaC427GvfHLnNv0bAEoWYf6mvmGBSuZcnSgdqZ8iZ0sI7+EopQN
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(46966006)(36840700001)(336012)(186003)(36860700001)(83380400001)(7636003)(70586007)(70206006)(82740400003)(54906003)(5660300002)(36756003)(2906002)(26005)(426003)(47076005)(2616005)(8676002)(82310400003)(478600001)(356005)(1076003)(110136005)(7416002)(316002)(4326008)(6666004)(7696005)(86362001)(8936002)(2101003)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 03:07:34.6493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afdddf8-9d34-45b1-7101-08d96c2c7b09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2430
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nate Watterson <nwatterson@nvidia.com>

Follow arm-smmu driver's infrastructure for handling implementation
specific details outside the flow of architectural code.

Signed-off-by: Nate Watterson <nwatterson@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/Makefile           | 2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c | 8 ++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c      | 4 ++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h      | 4 ++++
 4 files changed, 17 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 54feb1ecccad..1f5838d3351b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
-arm_smmu_v3-objs-y += arm-smmu-v3.o
+arm_smmu_v3-objs-y += arm-smmu-v3.o arm-smmu-v3-impl.o
 arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c
new file mode 100644
index 000000000000..6947d28067a8
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "arm-smmu-v3.h"
+
+struct arm_smmu_device *arm_smmu_v3_impl_init(struct arm_smmu_device *smmu)
+{
+	return smmu;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 216f3442aac4..510e1493fd5a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3844,6 +3844,10 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 			return ret;
 	}
 
+	smmu = arm_smmu_v3_impl_init(smmu);
+	if (IS_ERR(smmu))
+		return PTR_ERR(smmu);
+
 	/* Set bypass mode according to firmware probing result */
 	bypass = !!ret;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 20463d17fd9f..c65c39336916 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -810,4 +810,8 @@ static inline u32 arm_smmu_sva_get_pasid(struct iommu_sva *handle)
 
 static inline void arm_smmu_sva_notifier_synchronize(void) {}
 #endif /* CONFIG_ARM_SMMU_V3_SVA */
+
+/* Implementation details */
+struct arm_smmu_device *arm_smmu_v3_impl_init(struct arm_smmu_device *smmu);
+
 #endif /* _ARM_SMMU_V3_H */
-- 
2.17.1

