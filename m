Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E443F400C
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhHVOi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:38:27 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:5729
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234497AbhHVOiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:38:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4ZshAaHdBGYMv6RfpVB8oiknrZe6IXPB5KC8kXJmX6Xqphtf+AwylkN6GarxvScwZxh+cmZvnIeRl+0qv+nMZoscSupjgdXYIpvvShV85ra9WzMPDENFLRmOX/NfJLqahC2qC25zEVOiDgKcrv+2Xaqwb8tEK2K1OOpeDnDH9fGTuwK4w1YL+cjme6FgjGuKDmtfvbbESgRZsYl7NJw7ErOi2QTq7NFCzNpboanj8JBFiPo/+222ys1PsbZ0qvkFiS+0d4YWwJRCPNhGKsU2xGTQV3Mdl1M+t+SMNc6H9LQWxM5GxZ2LP2OtUCtSEnnQz2O36bEI5OFzwlvNu/Xtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcoz+mtO8t1q9AsRo4d5AWcflMVS8b8syDqG8CJho7c=;
 b=QhGkmr4hmdnVZX6ko9fSxc1D508ZHC5qSeVzfmSwVM+6u8Tmn0NssfqGDfvNWKeBpHUDJOSGRXmBR3FOqBwwyNimHUA7sJd9lhHjQ/2lZ/L/jl/x3Klh3RE6S1BGCcuXqlwhkgJvuHM0TgyIiFzMHkdd+NeeyOdu2Q6rrCh5NDo0i8FCN4P3BWvI82wgrEG7E2/NQUDBlcLpNOMB6h9jrpvUmYvAXKZEljkwy9S288Ih7oU8QbexSPwlPM9CadniFXDNiQ2TvWp2nfQOZE5jn1JbRS8pbi17wEkx6uSpJB5GpXqKhgZxWbxo53/IZo9uM/MNPXo8CwsAOLnSJ3tbmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcoz+mtO8t1q9AsRo4d5AWcflMVS8b8syDqG8CJho7c=;
 b=rKH/PYDkME3a24vYZyI6KWQAWvGHOl5Y430S08TBxbmP1HS+Y6bEmaSypzNH+a4TtSaACL97dW2TbSRB+lG6uVcOiOfAS651lw3+Nbn8RfUhcYUEj6/juugNNgFgm+SAyKzrqKiNI3d5EIaQIdMtxdDvf0ZryPa4+OyYpsiMv+qlUGa1cWV8sy1po0azilh8TzBM2/akltM7+rWqihIwPKnjBjnd1nc/Txl9Ssb97xob0eCj/0rcHk2mHpaPdS+eqf50j4CMIl0uGbWSBYnZQaBsgBZlUFdoRWri147O+IMWDIE8ztXlE9mJBKA2JewFMW9BLTn8noR5TNw+Wq4V9w==
Received: from DM5PR07CA0067.namprd07.prod.outlook.com (2603:10b6:4:ad::32) by
 BL0PR12MB4948.namprd12.prod.outlook.com (2603:10b6:208:1cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sun, 22 Aug
 2021 14:37:43 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::7e) by DM5PR07CA0067.outlook.office365.com
 (2603:10b6:4:ad::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:43 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 07:37:42 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:38 +0000
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
Subject: [PATCH V3 11/13] vfio: Use select for eventfd
Date:   Sun, 22 Aug 2021 17:36:00 +0300
Message-ID: <20210822143602.153816-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b19185d1-f971-418f-76a7-08d9657a669c
X-MS-TrafficTypeDiagnostic: BL0PR12MB4948:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4948C4268EF24E27BA8CFA77C3C39@BL0PR12MB4948.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4zyemKeiOBeR7KR9Lx1nqTmQ1GE6tf9LFCm2tR6Q0Txbzffvh4brvIjtLNw4CRA56ZLrtxYCwQd62wmYssEAfKkNvBOPAhQPonQugjbdFUwyUq7zj0FGbi/IVfFWx0P4fk4g9+Ljpq4tZDoZbelHEa887eMtlj1HTlE1QbvVv5GAV3K00UPgQNbG7XrUAdjjy+6+Y1NNUZ7z+tt3sZNp+8JWWOnkkWjO6VF3pLDOQehrPI05y0/2b+NRWw+o0ipmW3FGstoAQAC++H2F3MsU0I01TJuS9u6JSMD3zCpC1oxaJmERet8w4NRyAj7Haz/jnJjIr3UeMvYBgFqooCdjXX+OqU2YbXmREKsQdVJNeFFb/LuQcPAT26a/7Qm2IDSFHp/b8SZjapePUCaIvAFlyF0k8s+QHP9ps1tGC7KHoiVJ5RlHu6vLfXy6BWbNBu0zNnVRMWoeVHepU/oo01pv3h+XFB/1v//Q2yxDZeQOmxbwSaYkdqPcyU1SeKBJWBPZkif6aiQpRrk9aYKfM63d6u8G5tJywx9chwvp4O9li1nEhpFTw+waF83uaU4rCxlFcGUDWIVFTdKbxy3H33IiI+4WUbUoLyG7ZA9u94j+mQu2KdKRUHJAfPrMBizysLJ0lZW770MJ+Ecq1TRDAygQztaaXD2PnQ+fuWHXaa0W5xbIqr+BqfslmC/mdRPXcftbzbLGEYzGPX1QF65W6pcPTo3KnHZ8dVtKG+0VualA9P8=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(36840700001)(46966006)(4326008)(5660300002)(8676002)(54906003)(2906002)(426003)(107886003)(1076003)(36860700001)(36756003)(83380400001)(8936002)(86362001)(7696005)(70586007)(2616005)(47076005)(82740400003)(478600001)(26005)(186003)(6666004)(70206006)(82310400003)(7416002)(336012)(110136005)(7636003)(356005)(316002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:43.0501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b19185d1-f971-418f-76a7-08d9657a669c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4948
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

