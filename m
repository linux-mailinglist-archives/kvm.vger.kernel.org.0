Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3483F768C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241539AbhHYNxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:53:36 -0400
Received: from mail-mw2nam10on2075.outbound.protection.outlook.com ([40.107.94.75]:7863
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241553AbhHYNxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:53:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7Fnxshk+yjdYrJdYjcG1Bv+gu1bsaL/wV4Hycsd8gKvysGFcUujKsXg5jy0eViHl3Q1HOJxelbUXSlDGclrhLqAuMcEI+JpNwL7r8kvCw1wzUFa5qWdY+WkfBHyeGl2QaqguBffMPcCeclJYXtvnWGSOkt0/60Iu3pRTDa3N1gjHj0RgDjN93mZREkA6BCqMxSSWd3fJFSqYWRPsk7c/TdrWrff04EpHsPW4O2nL/7Lhb/ad01KXUeyCJlw29syrwg/T4I6LKID3kVbD7ZFEkS4ecjPrvSDHei4WHr9URNwhG3uR30I24NMHXwIi6gtJEX9HAGJgs1cQmLCTvwnMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcoz+mtO8t1q9AsRo4d5AWcflMVS8b8syDqG8CJho7c=;
 b=JBVChuPz4ArIZWNKMTskVnG/RFLSiUZh2wplNK9aLOuewWusKh8egGCpuQEV7G31xoGglRh3kBYgaDOY7GV5jsAR7sLDLAdiS72yJcn4JFXAyhKLe6qnm2mP0hRSQ8mRsjkArByrsOvhOnTh4wuSHtOA+VG1Tm4rg7HXkEQq2BBc2OpG/ZBq5r93r/Qs2szrRNAMsXJ8rgZoYqUbcn9+k1doyQU7KmOStJNBEgvX4QWb7adQhSrpADsFqOa9nGUeUGBpYmebT5JlxhvoqI1ZHALhiJ+Az5i2POgPFBvp82tzmMcflHPFrPIBP3q/mgDYOLeEmzJ9qzsbw/T1CzPaWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcoz+mtO8t1q9AsRo4d5AWcflMVS8b8syDqG8CJho7c=;
 b=mrkvbiUbX6YeAQDUXRkRt31i2YM6WNZiAHYi674C6zG+NCV/NtPrNXLpVPNBetMgMbVQqLHF53MwWfgUSKRbAJX2OghVQFrnAnUwhG38QaQyPr1pU2stMZd3IRI8hE4U0oJDVec1UfurZxp56y1um7C7DvN/gVNb7UDMbaCQTcUXDKheZD2sTY9Vz1DqUJenk59uHaxS+JOu9KAx2+CViOYvnKdLUo7WuYUuu9ROMWxmyGaGk0IsUidDR/MpR7FiC4cb70htrpgTZBr/BbO3CTqIm7WEO4Y2CSRDVIMMgDr5k83tTaXbebC/MDl9keFfD1b854Tj/hIGA8pPLy8vjQ==
Received: from MWHPR12CA0038.namprd12.prod.outlook.com (2603:10b6:301:2::24)
 by CH2PR12MB4101.namprd12.prod.outlook.com (2603:10b6:610:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Wed, 25 Aug
 2021 13:52:46 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:2:cafe::c8) by MWHPR12CA0038.outlook.office365.com
 (2603:10b6:301:2::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:45 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 13:52:45 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:41 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V4 11/13] vfio: Use select for eventfd
Date:   Wed, 25 Aug 2021 16:51:37 +0300
Message-ID: <20210825135139.79034-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bfde61f-2b1b-4d84-a3f2-08d967cf9e11
X-MS-TrafficTypeDiagnostic: CH2PR12MB4101:
X-Microsoft-Antispam-PRVS: <CH2PR12MB41018E659CD4F4D4367D00BFC3C69@CH2PR12MB4101.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DLOQZc4T3M87sKLsFmS1vDQr/wEEmx5DMQXuu8mdsGieOd3se9JKBoCs5XmFrcQT3hHdfUPmp0by+GLwXHtPsJmeyX5cXkax7Ji3zLs+6EeMx/UnIYFMI2XuRslrzEoagEQ7pIU/VfUF7sJleTtyLT9NtHpUcLhLD+c17SNjQV+TwHmD+/c/s527YxE92sEbte4ULL2dOk9cXqTXrS/BmSTuqJlmcgKjelD17GZ8CZeGJYhSPMBmbno2n0PClOlWst5XNnbYNM2AVNNKZolWV5z3WzcnN9pPfGlsTHeMtiORc/0rCXmKxzK2rR7SYKcIQGGJWCu/8/XdaWsNmjAe0/GwjC426nXwDoDI3FTVKxuKXMq4sq1NpUOOYU/oz0Sn51daE42TZ+iry676D0g/jxrvAsxxCkly8/J7tUEk1emC9cZEd66gIqp2c49idXJQjn7LXuGtcgkQEp5dp7dNYj1syeT9y3qcqy6sLDIkJk2KARaUrub0PPAqpO2T8EiV+7C4FS9nnXlKelSGfOtm5D8gQMGhMG/tnpOyO8sWD6Zv2C1lXeeJDTX2zSQr1541TBFZP5cGv4pcSqMlIxZposc/J1AfBHTAI//x9nwR1CtqdpnK7GxkgwcEjjQMAtHmOf5IbWlAgnjgdfOOUwPobIrfK0c5Cy2kIsfDLNuo9eEnVH+UMG1EPjF7cYFliEP2x2kzRmfrYA+bVcER9AAeL/94FQs/AQXoun1rSzWHhQc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(1076003)(508600001)(4326008)(82310400003)(336012)(47076005)(6666004)(8936002)(36860700001)(426003)(107886003)(7636003)(7696005)(83380400001)(186003)(5660300002)(36906005)(70206006)(316002)(8676002)(86362001)(26005)(36756003)(54906003)(110136005)(2906002)(7416002)(70586007)(356005)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:45.6403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bfde61f-2b1b-4d84-a3f2-08d967cf9e11
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

If VFIO_VIRQFD is required then turn on eventfd automatically.
The majority of kconfig users of the EVENTFD use select not depends on.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/Kconfig          | 3 ++-
 drivers/vfio/fsl-mc/Kconfig   | 3 ++-
 drivers/vfio/pci/Kconfig      | 2 +-
 drivers/vfio/platform/Kconfig | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index e44bf736e2b2..698ca35b3f03 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -16,7 +16,8 @@ config VFIO_SPAPR_EEH
 
 config VFIO_VIRQFD
 	tristate
-	depends on VFIO && EVENTFD
+	depends on VFIO
+	select EVENTFD
 	default n
 
 menuconfig VFIO
diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
index b1a527d6b6f2..6df66813c882 100644
--- a/drivers/vfio/fsl-mc/Kconfig
+++ b/drivers/vfio/fsl-mc/Kconfig
@@ -1,6 +1,7 @@
 config VFIO_FSL_MC
 	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
-	depends on VFIO && FSL_MC_BUS && EVENTFD
+	depends on VFIO && FSL_MC_BUS
+	select EVENTFD
 	help
 	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
 	  (Management Complex) devices. This is required to passthrough
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 5e2e1b9a9fd3..d208a95a2767 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PCI
 	tristate "VFIO support for PCI devices"
-	depends on VFIO && PCI && EVENTFD
+	depends on VFIO && PCI
 	depends on MMU
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index ab341108a0be..7f78eb96a5d5 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PLATFORM
 	tristate "VFIO support for platform devices"
-	depends on VFIO && EVENTFD && (ARM || ARM64 || COMPILE_TEST)
+	depends on VFIO && (ARM || ARM64 || COMPILE_TEST)
 	select VFIO_VIRQFD
 	help
 	  Support for platform devices with VFIO. This is required to make
-- 
2.18.1

