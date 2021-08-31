Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DE23FC15A
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 05:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbhHaDJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 23:09:04 -0400
Received: from mail-dm3nam07on2063.outbound.protection.outlook.com ([40.107.95.63]:51872
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229723AbhHaDIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 23:08:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfTJokrU+47o8SSVDaQFlznEYNIOPbUHBQXzUD5SqOaApTsffiBC1BtNH5dOnVNPLKK5GDNmpa2MCxTGJDwIZHHHLc+RFP2H44+P1DOGwWyMa7JyBfFuQHNLrEj5SeJuudHGGPfrR6D60diADrqKQ3YWZvblbR+avc9RHat0nxnGdMO84oLNlU1LaTCDR26j/j9CO/cz1sv65MS6qS29gVUR6otjK4hKkRHas3FFlHx7CHx7BerMF19KlmaBeDBPE6jO3EBiBE8v2LyNrFDLUFVSUsA3ZbWFwFFIC13LsUSFV0vR9pTNIHdEaOL3ggtYZMnP1pcnBt52VGExblCeYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ0o5bMZrWvzcXcCC6oaT/Mg1xmI76laas2vbwCzNyY=;
 b=fx9LMqakDLc2c7rrp5sft4EQiJJLeYmiJGDDz1fZzxBCBK3GR40VHWFOGJFF5i/zwioCbI71EiN0V5kQAb4P+T35gNfxKAghsqboJSvgDfdF2LxuvsQ+/iRanuKm8OBDQc1POn6UJvm5IGmAJfUduYu1FRnkUUB0Jb+keAhAdbKskMhDJkYUB3NmDYCTP408jdIhNeTAORY6xfNmhUJMJ3UeYtE7XfWl6cH4KdPcJoXFzvdOhlenjZGEhyUUKquElMVEwp/XQjZzYPvmPw70p1ooJZK8FYgQt0dLZJmdZXSkWU8uTdwxQ81Rbhhpox7WtwvhIiBSbzh9aJArMucEJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ0o5bMZrWvzcXcCC6oaT/Mg1xmI76laas2vbwCzNyY=;
 b=pl5YRyCXMHgYlo0hOd/WHVthgLJSNjxRwBQRHLaDHgFzSKM3qBpHtZI0k4H6/lR9p6VBxgMS+FVIFG/0PkI/GrYV00pm1dS7aTBfgV6hvkc8VrtVI3hQpmC9AsEtgD09bh1zCpxuvxIQD9eXEfy5c15Lj91MwRBHiAchfj0dZEr70cm3k+MeW68e0TXyMJbMJ7w2VJWV2ANulzvHx212+cxANWM2w79WfAKDLp6VEW/dMEdpfzVMYleFsWC2UFKOpGBM+XJWniH+nea4pFE8cOt8isP2aHDp1HOwgr3wpfRqVafwAsAyXQY6DdFBSJJYHFgVim9hRb/TWlG+YpGJPw==
Received: from BN9P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::29)
 by BY5PR12MB3746.namprd12.prod.outlook.com (2603:10b6:a03:1a7::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Tue, 31 Aug
 2021 03:07:34 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::5a) by BN9P222CA0024.outlook.office365.com
 (2603:10b6:408:10c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Tue, 31 Aug 2021 03:07:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 03:07:34 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Aug
 2021 03:07:32 +0000
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
Subject: [RFC][PATCH v2 12/13] iommu/arm-smmu-v3: Add support for NVIDIA CMDQ-Virtualization hw
Date:   Mon, 30 Aug 2021 19:59:22 -0700
Message-ID: <20210831025923.15812-13-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64a16d72-351a-4a37-e383-08d96c2c7af2
X-MS-TrafficTypeDiagnostic: BY5PR12MB3746:
X-Microsoft-Antispam-PRVS: <BY5PR12MB37467601BE40248EE3CA8E21ABCC9@BY5PR12MB3746.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7NTCVP9TuoaWTMaq0yGCUXElIjoSb3iZzw1aHNsKqpuFlWz+A5SW2MeI8XVloE3zWvW+UhSzzoWMexAdo3pjfsCkGXtYmlt+1DSeQB6x5/HAjPBbSf8DWcGtiiU4LTrhbqdZ8lOrPzUV9MTYFkPx0PHSKccJ6ka/lx2yOaMCpdP/4Pd8lU/5QCvMNrkBMYMSOewmfv9ry6LhrbUJRC1Zgt66h7RVB/+tdLpl/WftBXFanz2yU7brXf2U4ZsdhpF6F7v00BW1VbMjBj5iFpDqV0R/wF7HnLdYbfPUToyvjuUlqwrhM1ho+jJrxuicOveVxLQtmcs9GUTZwlE5xoAf53oQhZ7x3B9b0aIkYc0/FynkBotnJGNmXSQF35bik531eQRZP23r/M/Rfsz6S13MV2BBL8gj6CM9XZ/MAsh9Tz1rVYFCn4t3WREZBK2sJHSxaaXnGvF+CP0da2Ixrq35JVFY6MLQo0nbD4D+LQwmLigXlixSgshLHNLmJHtYbRHIBkyilIsDJAPaV3TovVx/0daOCQCTiClEj0ot7LrdgszgC/EhxFgQl5dS6+oaNhTae2XoI6kEXYQQ94QIpIGv2SlhFllrW5+79HyjHaJZUId75p/Sj/37woCerxLjD3J3WCUl9aNc6baj2J8RUO4K9f3BtZJnpP8kvB4eDltdqffv07uH9Ee2giF96LT+xvGJPiFQYdmcr6l8bUCye/il72v3P7Ugq7dqAjk9HJ9zhTE=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(46966006)(36840700001)(36906005)(47076005)(70206006)(7636003)(54906003)(36756003)(7416002)(2906002)(8676002)(186003)(356005)(83380400001)(316002)(478600001)(426003)(110136005)(82310400003)(70586007)(30864003)(82740400003)(7696005)(36860700001)(26005)(1076003)(86362001)(8936002)(6666004)(336012)(5660300002)(2616005)(4326008)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 03:07:34.5055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64a16d72-351a-4a37-e383-08d96c2c7af2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3746
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nate Watterson <nwatterson@nvidia.com>

NVIDIA's Grace SoC has a CMDQ-Virtualization (CMDQV) hardware,
which adds multiple VCMDQ interfaces (VINTFs) to supplement the
architected SMMU_CMDQ in an effort to reduce contention.

To make use of these supplemental CMDQs in arm-smmu-v3 driver,
this patch borrows the "implemenatation infrastructure" design
from the arm-smmu driver, and then adds implementation specific
supports for ->device_reset() and ->get_cmdq() functions. Since
nvidia's ->get_cmdq() implemenatation needs to check the first
command of the cmdlist to determine whether to redirect to its
own vcmdq, this patch also adds augments to arm_smmu_get_cmdq()
function.

For the CMDQV driver itself, this patch only adds the essential
parts for the host kernel, in terms of virtualization use cases.
VINTF0 is being reserved for host kernel use, so is initialized
with the driver also.

Note that, for the current plan, the CMDQV driver only supports
ACPI configuration.

Signed-off-by: Nate Watterson <nwatterson@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 MAINTAINERS                                   |   2 +
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c  |   7 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  15 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   8 +
 .../iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c    | 432 ++++++++++++++++++
 6 files changed, 463 insertions(+), 3 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c

diff --git a/MAINTAINERS b/MAINTAINERS
index f800abca74b0..7a2f21279d35 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18428,8 +18428,10 @@ F:	drivers/i2c/busses/i2c-tegra.c
 TEGRA IOMMU DRIVERS
 M:	Thierry Reding <thierry.reding@gmail.com>
 R:	Krishna Reddy <vdumpa@nvidia.com>
+R:	Nicolin Chen <nicoleotsuka@gmail.com>
 L:	linux-tegra@vger.kernel.org
 S:	Supported
+F:	drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c
 F:	drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
 F:	drivers/iommu/tegra*
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 1f5838d3351b..0aa84c0a50ea 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
-arm_smmu_v3-objs-y += arm-smmu-v3.o arm-smmu-v3-impl.o
+arm_smmu_v3-objs-y += arm-smmu-v3.o arm-smmu-v3-impl.o nvidia-smmu-v3.o
 arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c
index 6947d28067a8..37d062e40eb5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c
@@ -4,5 +4,12 @@
 
 struct arm_smmu_device *arm_smmu_v3_impl_init(struct arm_smmu_device *smmu)
 {
+	/*
+	 * Nvidia implementation supports ACPI only, so calling its init()
+	 * unconditionally to walk through ACPI tables to probe the device.
+	 * It will keep the smmu pointer intact, if it fails.
+	 */
+	smmu = nvidia_smmu_v3_impl_init(smmu);
+
 	return smmu;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 510e1493fd5a..1b9459592f76 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -335,8 +335,11 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 	return 0;
 }
 
-static struct arm_smmu_cmdq *arm_smmu_get_cmdq(struct arm_smmu_device *smmu)
+static struct arm_smmu_cmdq *arm_smmu_get_cmdq(struct arm_smmu_device *smmu, u64 *cmds, int n)
 {
+	if (smmu->impl && smmu->impl->get_cmdq)
+		return smmu->impl->get_cmdq(smmu, cmds, n);
+
 	return &smmu->cmdq;
 }
 
@@ -742,7 +745,7 @@ static int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 	u32 prod;
 	unsigned long flags;
 	bool owner;
-	struct arm_smmu_cmdq *cmdq = arm_smmu_get_cmdq(smmu);
+	struct arm_smmu_cmdq *cmdq = arm_smmu_get_cmdq(smmu, cmds, n);
 	struct arm_smmu_ll_queue llq, head;
 	int ret = 0;
 
@@ -3487,6 +3490,14 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
 		return ret;
 	}
 
+	if (smmu->impl && smmu->impl->device_reset) {
+		ret = smmu->impl->device_reset(smmu);
+		if (ret) {
+			dev_err(smmu->dev, "failed at implementation specific device_reset\n");
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c65c39336916..bb903a7fa662 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -647,6 +647,8 @@ struct arm_smmu_device {
 #define ARM_SMMU_OPT_MSIPOLL		(1 << 2)
 	u32				options;
 
+	const struct arm_smmu_impl	*impl;
+
 	struct arm_smmu_cmdq		cmdq;
 	struct arm_smmu_evtq		evtq;
 	struct arm_smmu_priq		priq;
@@ -812,6 +814,12 @@ static inline void arm_smmu_sva_notifier_synchronize(void) {}
 #endif /* CONFIG_ARM_SMMU_V3_SVA */
 
 /* Implementation details */
+struct arm_smmu_impl {
+	int (*device_reset)(struct arm_smmu_device *smmu);
+	struct arm_smmu_cmdq *(*get_cmdq)(struct arm_smmu_device *smmu, u64 *cmds, int n);
+};
+
 struct arm_smmu_device *arm_smmu_v3_impl_init(struct arm_smmu_device *smmu);
+struct arm_smmu_device *nvidia_smmu_v3_impl_init(struct arm_smmu_device *smmu);
 
 #endif /* _ARM_SMMU_V3_H */
diff --git a/drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c
new file mode 100644
index 000000000000..0c92fe433c6e
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c
@@ -0,0 +1,432 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define dev_fmt(fmt) "nvidia_smmu_cmdqv: " fmt
+
+#include <linux/acpi.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/iopoll.h>
+#include <linux/platform_device.h>
+
+#include <acpi/acpixf.h>
+
+#include "arm-smmu-v3.h"
+
+#define NVIDIA_SMMU_CMDQV_HID		"NVDA0600"
+
+/* CMDQV register page base and size defines */
+#define NVIDIA_CMDQV_CONFIG_BASE	(0)
+#define NVIDIA_CMDQV_CONFIG_SIZE	(SZ_64K)
+#define NVIDIA_VCMDQ_BASE		(0 + SZ_64K)
+#define NVIDIA_VCMDQ_SIZE		(SZ_64K * 2) /* PAGE0 and PAGE1 */
+
+/* CMDQV global config regs */
+#define NVIDIA_CMDQV_CONFIG		0x0000
+#define  CMDQV_EN			BIT(0)
+
+#define NVIDIA_CMDQV_PARAM		0x0004
+#define  CMDQV_NUM_VINTF_LOG2		GENMASK(11, 8)
+#define  CMDQV_NUM_VCMDQ_LOG2		GENMASK(7, 4)
+
+#define NVIDIA_CMDQV_STATUS		0x0008
+#define  CMDQV_STATUS			GENMASK(2, 1)
+#define  CMDQV_ENABLED			BIT(0)
+
+#define NVIDIA_CMDQV_VINTF_ERR_MAP	0x000C
+#define NVIDIA_CMDQV_VINTF_INT_MASK	0x0014
+#define NVIDIA_CMDQV_VCMDQ_ERR_MAP	0x001C
+
+#define NVIDIA_CMDQV_CMDQ_ALLOC(q)	(0x0200 + 0x4*(q))
+#define  CMDQV_CMDQ_ALLOC_VINTF		GENMASK(20, 15)
+#define  CMDQV_CMDQ_ALLOC_LVCMDQ	GENMASK(7, 1)
+#define  CMDQV_CMDQ_ALLOCATED		BIT(0)
+
+/* VINTF config regs */
+#define NVIDIA_CMDQV_VINTF(v)		(0x1000 + 0x100*(v))
+
+#define NVIDIA_VINTF_CONFIG		0x0000
+#define  VINTF_HYP_OWN			BIT(17)
+#define  VINTF_VMID			GENMASK(16, 1)
+#define  VINTF_EN			BIT(0)
+
+#define NVIDIA_VINTF_STATUS		0x0004
+#define  VINTF_STATUS			GENMASK(3, 1)
+#define  VINTF_ENABLED			BIT(0)
+
+/* VCMDQ config regs */
+/* -- PAGE0 -- */
+#define NVIDIA_CMDQV_VCMDQ(q)		(NVIDIA_VCMDQ_BASE + 0x80*(q))
+
+#define NVIDIA_VCMDQ_CONS		0x00000
+#define  VCMDQ_CONS_ERR			GENMASK(30, 24)
+
+#define NVIDIA_VCMDQ_PROD		0x00004
+
+#define NVIDIA_VCMDQ_CONFIG		0x00008
+#define  VCMDQ_EN			BIT(0)
+
+#define NVIDIA_VCMDQ_STATUS		0x0000C
+#define  VCMDQ_ENABLED			BIT(0)
+
+#define NVIDIA_VCMDQ_GERROR		0x00010
+#define NVIDIA_VCMDQ_GERRORN		0x00014
+
+/* -- PAGE1 -- */
+#define NVIDIA_VCMDQ_BASE_L(q)		(NVIDIA_CMDQV_VCMDQ(q) + SZ_64K)
+#define  VCMDQ_ADDR			GENMASK(63, 5)
+#define  VCMDQ_LOG2SIZE			GENMASK(4, 0)
+
+struct nvidia_smmu_vintf {
+	u16			idx;
+	u32			cfg;
+	u32			status;
+
+	void __iomem		*base;
+	struct arm_smmu_cmdq	*vcmdqs;
+};
+
+struct nvidia_smmu {
+	struct arm_smmu_device	smmu;
+
+	struct device		*cmdqv_dev;
+	void __iomem		*cmdqv_base;
+	int			cmdqv_irq;
+
+	/* CMDQV Hardware Params */
+	u16			num_total_vintfs;
+	u16			num_total_vcmdqs;
+	u16			num_vcmdqs_per_vintf;
+
+	/* CMDQV_VINTF(0) reserved for host kernel use */
+	struct nvidia_smmu_vintf vintf0;
+};
+
+static irqreturn_t nvidia_smmu_cmdqv_isr(int irq, void *devid)
+{
+	struct nvidia_smmu *nsmmu = (struct nvidia_smmu *)devid;
+	struct nvidia_smmu_vintf *vintf0 = &nsmmu->vintf0;
+	u32 vintf_err_map[2];
+	u32 vcmdq_err_map[4];
+
+	vintf_err_map[0] = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_VINTF_ERR_MAP);
+	vintf_err_map[1] = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_VINTF_ERR_MAP + 0x4);
+
+	vcmdq_err_map[0] = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_VCMDQ_ERR_MAP);
+	vcmdq_err_map[1] = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_VCMDQ_ERR_MAP + 0x4);
+	vcmdq_err_map[2] = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_VCMDQ_ERR_MAP + 0x8);
+	vcmdq_err_map[3] = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_VCMDQ_ERR_MAP + 0xC);
+
+	dev_warn(nsmmu->cmdqv_dev,
+		 "unexpected cmdqv error reported: vintf_map %08X %08X, vcmdq_map %08X %08X %08X %08X\n",
+		 vintf_err_map[0], vintf_err_map[1], vcmdq_err_map[0], vcmdq_err_map[1],
+		 vcmdq_err_map[2], vcmdq_err_map[3]);
+
+	/* If the error was reported by vintf0, avoid using any of its VCMDQs */
+	if (vintf_err_map[vintf0->idx / 32] & (1 << (vintf0->idx % 32))) {
+		vintf0->status = readl_relaxed(vintf0->base + NVIDIA_VINTF_STATUS);
+
+		dev_warn(nsmmu->cmdqv_dev, "error (0x%lX) reported by host vintf0 - disabling its vcmdqs\n",
+			 FIELD_GET(VINTF_STATUS, vintf0->status));
+	} else if (vintf_err_map[0] || vintf_err_map[1]) {
+		dev_err(nsmmu->cmdqv_dev, "cmdqv error interrupt triggered by unassigned vintf!\n");
+	}
+
+	return IRQ_HANDLED;
+}
+
+/* Adapt struct arm_smmu_cmdq init sequences from arm-smmu-v3.c for VCMDQs */
+static int nvidia_smmu_init_one_arm_smmu_cmdq(struct nvidia_smmu *nsmmu,
+					      struct arm_smmu_cmdq *cmdq,
+					      void __iomem *vcmdq_base,
+					      u16 qidx)
+{
+	struct arm_smmu_queue *q = &cmdq->q;
+	size_t qsz;
+
+	/* struct arm_smmu_cmdq config normally done in arm_smmu_device_hw_probe() */
+	q->llq.max_n_shift = ilog2(SZ_64K >> CMDQ_ENT_SZ_SHIFT);
+
+	/* struct arm_smmu_cmdq config normally done in arm_smmu_init_one_queue() */
+	qsz = (1 << q->llq.max_n_shift) << CMDQ_ENT_SZ_SHIFT;
+	q->base = dmam_alloc_coherent(nsmmu->cmdqv_dev, qsz, &q->base_dma, GFP_KERNEL);
+	if (!q->base) {
+		dev_err(nsmmu->cmdqv_dev, "failed to allocate 0x%zX bytes for VCMDQ%u\n",
+			qsz, qidx);
+		return -ENOMEM;
+	}
+	dev_dbg(nsmmu->cmdqv_dev, "allocated %u entries for VCMDQ%u @ 0x%llX [%pad] ++ %zX",
+		1 << q->llq.max_n_shift, qidx, (u64)q->base, &q->base_dma, qsz);
+
+	q->prod_reg = vcmdq_base + NVIDIA_VCMDQ_PROD;
+	q->cons_reg = vcmdq_base + NVIDIA_VCMDQ_CONS;
+	q->ent_dwords = CMDQ_ENT_DWORDS;
+
+	q->q_base  = q->base_dma & VCMDQ_ADDR;
+	q->q_base |= FIELD_PREP(VCMDQ_LOG2SIZE, q->llq.max_n_shift);
+
+	q->llq.prod = q->llq.cons = 0;
+
+	/* struct arm_smmu_cmdq config normally done in arm_smmu_cmdq_init() */
+	atomic_set(&cmdq->owner_prod, 0);
+	atomic_set(&cmdq->lock, 0);
+
+	cmdq->valid_map = (atomic_long_t *)bitmap_zalloc(1 << q->llq.max_n_shift, GFP_KERNEL);
+	if (!cmdq->valid_map) {
+		dev_err(nsmmu->cmdqv_dev, "failed to allocate valid_map for VCMDQ%u\n", qidx);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int nvidia_smmu_cmdqv_init(struct nvidia_smmu *nsmmu)
+{
+	struct nvidia_smmu_vintf *vintf0 = &nsmmu->vintf0;
+	u32 regval;
+	u16 qidx;
+	int ret;
+
+	/* Setup vintf0 for host kernel */
+	vintf0->idx = 0;
+	vintf0->base = nsmmu->cmdqv_base + NVIDIA_CMDQV_VINTF(0);
+
+	regval = FIELD_PREP(VINTF_HYP_OWN, nsmmu->num_total_vintfs > 1);
+	writel_relaxed(regval, vintf0->base + NVIDIA_VINTF_CONFIG);
+
+	regval |= FIELD_PREP(VINTF_EN, 1);
+	writel_relaxed(regval, vintf0->base + NVIDIA_VINTF_CONFIG);
+
+	vintf0->cfg = regval;
+
+	ret = readl_relaxed_poll_timeout(vintf0->base + NVIDIA_VINTF_STATUS,
+					 regval, regval == VINTF_ENABLED,
+					 1, ARM_SMMU_POLL_TIMEOUT_US);
+	vintf0->status = regval;
+	if (ret) {
+		dev_err(nsmmu->cmdqv_dev, "failed to enable VINTF%u: STATUS = 0x%08X\n",
+			vintf0->idx, regval);
+		return ret;
+	}
+
+	/* Allocate vcmdqs to vintf0 */
+	for (qidx = 0; qidx < nsmmu->num_vcmdqs_per_vintf; qidx++) {
+		regval  = FIELD_PREP(CMDQV_CMDQ_ALLOC_VINTF, vintf0->idx);
+		regval |= FIELD_PREP(CMDQV_CMDQ_ALLOC_LVCMDQ, qidx);
+		regval |= CMDQV_CMDQ_ALLOCATED;
+		writel_relaxed(regval, nsmmu->cmdqv_base + NVIDIA_CMDQV_CMDQ_ALLOC(qidx));
+	}
+
+	/* Build an arm_smmu_cmdq for each vcmdq allocated to vintf0 */
+	vintf0->vcmdqs = devm_kcalloc(nsmmu->cmdqv_dev, nsmmu->num_vcmdqs_per_vintf,
+				      sizeof(*vintf0->vcmdqs), GFP_KERNEL);
+	if (!vintf0->vcmdqs)
+		return -ENOMEM;
+
+	for (qidx = 0; qidx < nsmmu->num_vcmdqs_per_vintf; qidx++) {
+		void __iomem *vcmdq_base = nsmmu->cmdqv_base + NVIDIA_CMDQV_VCMDQ(qidx);
+		struct arm_smmu_cmdq *cmdq = &vintf0->vcmdqs[qidx];
+
+		/* Setup struct arm_smmu_cmdq data members */
+		nvidia_smmu_init_one_arm_smmu_cmdq(nsmmu, cmdq, vcmdq_base, qidx);
+
+		/* Configure and enable the vcmdq */
+		writel_relaxed(0, vcmdq_base + NVIDIA_VCMDQ_PROD);
+		writel_relaxed(0, vcmdq_base + NVIDIA_VCMDQ_CONS);
+
+		writeq_relaxed(cmdq->q.q_base, nsmmu->cmdqv_base + NVIDIA_VCMDQ_BASE_L(qidx));
+
+		writel_relaxed(VCMDQ_EN, vcmdq_base + NVIDIA_VCMDQ_CONFIG);
+		ret = readl_poll_timeout(vcmdq_base + NVIDIA_VCMDQ_STATUS,
+					 regval, regval == VCMDQ_ENABLED,
+					 1, ARM_SMMU_POLL_TIMEOUT_US);
+		if (ret) {
+			u32 gerror = readl_relaxed(vcmdq_base + NVIDIA_VCMDQ_GERROR);
+			u32 gerrorn = readl_relaxed(vcmdq_base + NVIDIA_VCMDQ_GERRORN);
+			u32 cons = readl_relaxed(vcmdq_base + NVIDIA_VCMDQ_CONS);
+
+			dev_err(nsmmu->cmdqv_dev,
+				"failed to enable VCMDQ%u: GERROR=0x%X, GERRORN=0x%X, CONS=0x%X\n",
+				qidx, gerror, gerrorn, cons);
+			return ret;
+		}
+
+		dev_info(nsmmu->cmdqv_dev, "VCMDQ%u allocated to VINTF%u as logical-VCMDQ%u\n",
+			 qidx, vintf0->idx, qidx);
+	}
+
+	return 0;
+}
+
+static int nvidia_smmu_probe(struct nvidia_smmu *nsmmu)
+{
+	struct platform_device *cmdqv_pdev = to_platform_device(nsmmu->cmdqv_dev);
+	struct resource *res;
+	u32 regval;
+
+	/* Base address */
+	res = platform_get_resource(cmdqv_pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
+	nsmmu->cmdqv_base = devm_ioremap_resource(nsmmu->cmdqv_dev, res);
+	if (IS_ERR(nsmmu->cmdqv_base))
+		return PTR_ERR(nsmmu->cmdqv_base);
+
+	/* Interrupt */
+	nsmmu->cmdqv_irq = platform_get_irq(cmdqv_pdev, 0);
+	if (nsmmu->cmdqv_irq < 0) {
+		dev_warn(nsmmu->cmdqv_dev, "no cmdqv interrupt - errors will not be reported\n");
+		nsmmu->cmdqv_irq = 0;
+	}
+
+	/* Probe the h/w */
+	regval = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_CONFIG);
+	if (!FIELD_GET(CMDQV_EN, regval)) {
+		dev_err(nsmmu->cmdqv_dev, "CMDQV h/w is disabled: CMDQV_CONFIG=0x%08X\n", regval);
+		return -ENODEV;
+	}
+
+	regval = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_STATUS);
+	if (!FIELD_GET(CMDQV_ENABLED, regval) || FIELD_GET(CMDQV_STATUS, regval)) {
+		dev_err(nsmmu->cmdqv_dev, "CMDQV h/w not ready: CMDQV_STATUS=0x%08X\n", regval);
+		return -ENODEV;
+	}
+
+	regval = readl_relaxed(nsmmu->cmdqv_base + NVIDIA_CMDQV_PARAM);
+	nsmmu->num_total_vintfs = 1 << FIELD_GET(CMDQV_NUM_VINTF_LOG2, regval);
+	nsmmu->num_total_vcmdqs = 1 << FIELD_GET(CMDQV_NUM_VCMDQ_LOG2, regval);
+	nsmmu->num_vcmdqs_per_vintf = nsmmu->num_total_vcmdqs / nsmmu->num_total_vintfs;
+
+	return 0;
+}
+
+static struct arm_smmu_cmdq *nvidia_smmu_get_cmdq(struct arm_smmu_device *smmu, u64 *cmds, int n)
+{
+	struct nvidia_smmu *nsmmu = (struct nvidia_smmu *)smmu;
+	struct nvidia_smmu_vintf *vintf0 = &nsmmu->vintf0;
+	u16 qidx;
+
+	/* Make sure vintf0 is enabled and healthy */
+	if (vintf0->status != VINTF_ENABLED)
+		return &smmu->cmdq;
+
+	/* Check for illegal CMDs */
+	if (!FIELD_GET(VINTF_HYP_OWN, vintf0->cfg)) {
+		u64 opcode = (n) ? FIELD_GET(CMDQ_0_OP, cmds[0]) : CMDQ_OP_CMD_SYNC;
+
+		/* List all non-illegal CMDs for cmdq overriding */
+		switch (opcode) {
+		case CMDQ_OP_TLBI_NH_ASID:
+		case CMDQ_OP_TLBI_NH_VA:
+		case CMDQ_OP_TLBI_S12_VMALL:
+		case CMDQ_OP_TLBI_S2_IPA:
+		case CMDQ_OP_ATC_INV:
+			break;
+		default:
+			/* Skip overriding for illegal CMDs */
+			return &smmu->cmdq;
+		}
+	}
+
+	/*
+	 * Select a vcmdq to use. Here we use a temporal solution to
+	 * balance out traffic on cmdq issuing: each cmdq has its own
+	 * lock, if all cpus issue cmdlist using the same cmdq, only
+	 * one CPU at a time can enter the process, while the others
+	 * will be spinning at the same lock.
+	 */
+	qidx = smp_processor_id() % nsmmu->num_vcmdqs_per_vintf;
+	return &vintf0->vcmdqs[qidx];
+}
+
+static int nvidia_smmu_device_reset(struct arm_smmu_device *smmu)
+{
+	struct nvidia_smmu *nsmmu = (struct nvidia_smmu *)smmu;
+	int ret;
+
+	ret = nvidia_smmu_cmdqv_init(nsmmu);
+	if (ret)
+		return ret;
+
+	if (nsmmu->cmdqv_irq) {
+		ret = devm_request_irq(nsmmu->cmdqv_dev, nsmmu->cmdqv_irq, nvidia_smmu_cmdqv_isr,
+				       IRQF_SHARED, "nvidia-smmu-cmdqv", nsmmu);
+		if (ret) {
+			dev_err(nsmmu->cmdqv_dev, "failed to claim irq (%d): %d\n",
+				nsmmu->cmdqv_irq, ret);
+			return ret;
+		}
+	}
+
+	/* Disable FEAT_MSI and OPT_MSIPOLL since VCMDQs only support CMD_SYNC w/CS_NONE */
+	smmu->features &= ~ARM_SMMU_FEAT_MSI;
+	smmu->options &= ~ARM_SMMU_OPT_MSIPOLL;
+
+	return 0;
+}
+
+const struct arm_smmu_impl nvidia_smmu_impl = {
+	.device_reset = nvidia_smmu_device_reset,
+	.get_cmdq = nvidia_smmu_get_cmdq,
+};
+
+#ifdef CONFIG_ACPI
+struct nvidia_smmu *nvidia_smmu_create(struct arm_smmu_device *smmu)
+{
+	struct nvidia_smmu *nsmmu = NULL;
+	struct acpi_iort_node *node;
+	struct acpi_device *adev;
+	struct device *cmdqv_dev;
+	const char *match_uid;
+
+	if (acpi_disabled)
+		return NULL;
+
+	/* Look for a device in the DSDT whose _UID matches the SMMU's iort_node identifier */
+	node = *(struct acpi_iort_node **)dev_get_platdata(smmu->dev);
+	match_uid = kasprintf(GFP_KERNEL, "%u", node->identifier);
+	adev = acpi_dev_get_first_match_dev(NVIDIA_SMMU_CMDQV_HID, match_uid, -1);
+	kfree(match_uid);
+
+	if (!adev)
+		return NULL;
+
+	cmdqv_dev = bus_find_device_by_acpi_dev(&platform_bus_type, adev);
+	if (!cmdqv_dev)
+		return NULL;
+
+	dev_info(smmu->dev, "found companion CMDQV device, %s", dev_name(cmdqv_dev));
+
+	nsmmu = devm_krealloc(smmu->dev, smmu, sizeof(*nsmmu), GFP_KERNEL);
+	if (!nsmmu)
+		return ERR_PTR(-ENOMEM);
+
+	nsmmu->cmdqv_dev = cmdqv_dev;
+
+	return nsmmu;
+}
+#else
+struct nvidia_smmu *nvidia_smmu_create(struct arm_smmu_device *smmu)
+{
+	return NULL;
+}
+#endif
+
+struct arm_smmu_device *nvidia_smmu_v3_impl_init(struct arm_smmu_device *smmu)
+{
+	struct nvidia_smmu *nsmmu;
+	int ret;
+
+	nsmmu = nvidia_smmu_create(smmu);
+	if (!nsmmu)
+		return smmu;
+
+	ret = nvidia_smmu_probe(nsmmu);
+	if (ret)
+		return ERR_PTR(ret);
+
+	nsmmu->smmu.impl = &nvidia_smmu_impl;
+
+	return &nsmmu->smmu;
+}
-- 
2.17.1

