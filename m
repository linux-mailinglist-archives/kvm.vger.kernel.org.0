Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16D53F766D
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241482AbhHYNxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:53:12 -0400
Received: from mail-dm6nam10on2063.outbound.protection.outlook.com ([40.107.93.63]:59120
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240294AbhHYNxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:53:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BuylUnUKL+9dUk9GbCnyjgsNVvaO+92QJvHbKWFUZd5cNq3hupnduo9qCtEGTY3JoHOigD5j8ZHBTiFQoH7aDXkkLUqgsFZ+rbHdMNUz26oeMkQxuIaUZlseClBmmTzQQFKAg6RtAlA6rp8M5JFsEBTzoSod6nUm+ymFkqf0pIke7eyWN6s7aTTi4ONZPwWQR9GTw97NXE71oqwWIF0+4Lu3llHEboFz3XX7VJU4XinrIPvO0EXfxvde0MGPZveDMS3QWN40+xO2JNWlVHbIUYLfsG0DBel2iwnfPnn/i6K6zMHXUF6UD5/QODp3asAkwe11zvrIy2v1Zuf66+ZcEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA12dOSs+X500lgNhQm9waVsEnhHX7aMIyxRdvZyw+8=;
 b=Er9vG6FGv0UDa8UHRVWDiyZP9Zin6afYbRAXdn1ID+2rRwH5rfv5Oqg1AciDlMKWBA2C9PDz8COGsNIsKvS7bWDIoDmdG+IfccjRNmi4tUlIVr7VCOnuCRlfx+Z00IIA3VgDL6dww9SzcwaW2rS3fDKePjMOPDg/rGA12hXCJDVBVppygNs1LGsNBu/aG8qBr2lwlXodk2SQPI+aOZBfUp+GBHXLM5Zq/meuYFzCfq1fHCBbAKGQYSoyfJTB/pKeZu+hZ9Gk8NgOa8W6+rS2cdMB308+Z5T8XijDDSyLe9MV6GQouXo2sjOY7GNfn+tFRpkrlK4h1c/ClokoN+tyow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=markovi.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA12dOSs+X500lgNhQm9waVsEnhHX7aMIyxRdvZyw+8=;
 b=tNHpCxG47eprM4B+KhSnq3rpeag0RzMjzSOgb+YbfgoZfiHoV1C4VbABu2ZKmrfRfnDf/y7Zp1ky4Hayl6NDyh5QDlSa8MFN32CHyRUJJ1UGLBuwnyDr0QpcPpxWfT9hWHqLy69kSk46LbCtYqY9+gbVI7ziStBgXwx+ZTf/T/bzFupKYX/znUJ080tWtQ3nD5y2HCD9+E55UsWYjwnPNqM2+jqunJ3WJAYTTpQEstmVAONPKl7j6ZGYzJq60y5bW7dvueANaRDLJ636XVaaAjXwUnympc0KiNaUs5I+TKOB6mvcRSeYud7Svokh/79WtVyRXE6OFo8oqgQSMunFpg==
Received: from MWHPR17CA0087.namprd17.prod.outlook.com (2603:10b6:300:c2::25)
 by BYAPR12MB2677.namprd12.prod.outlook.com (2603:10b6:a03:69::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 25 Aug
 2021 13:52:21 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::c3) by MWHPR17CA0087.outlook.office365.com
 (2603:10b6:300:c2::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; markovi.net; dkim=none (message not signed)
 header.d=none;markovi.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:20 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 13:52:19 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 13:52:19 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:15 -0700
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
Subject: [PATCH V4 05/13] vfio/pci: Include vfio header in vfio_pci_core.h
Date:   Wed, 25 Aug 2021 16:51:31 +0300
Message-ID: <20210825135139.79034-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10a4c34b-4bdd-45fa-136a-08d967cf8f14
X-MS-TrafficTypeDiagnostic: BYAPR12MB2677:
X-Microsoft-Antispam-PRVS: <BYAPR12MB26778C1AE2D7D7DDB200F4CAC3C69@BYAPR12MB2677.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KbZWxMXDw5wy9rvJTBbV1ZNKQqmk3KhymFEgy975fWZq+WnibKlqJ0oE0mZyRPQj9MQhpZaRo/JHrfyVJOqhdc/sSpdQI53A/Su1UFFe0v4xiIFOG9oGu7L5lDeCjJztVnFhxPavR9mhe4js9xUPJXrrlIPdzGmfME0QQoH6yn9LDwB7UMn/L5CukHyWf39wyIJDWENW12+L7aCYxCv3J5RNXnD+gFVWT2biMAupV3igDyHyfgjZRjlbyus7YkAWhn4pse+ydw7+rAgmPo0GkxwPn4cI9aeqqJboextdmlQBIBEdG9N7tZpZkSuRQkA3NH1lzR5TLB8NCSzaYE/5C5rNlo/Lraa29hwB/Si5bDugWKtyww+NkYow3cPj/UByV/3I9xlWZLW68iThoYRtHrrxJJzIwEpAGa3yz0d30KhuB1JUdayM4s4gEg+u0CHtzp/0Wg86Q56+5Ib6JqQgsHebqCyYlgUPym3f73CtfSOsquCTSP4Pr5UtBwHi4zx/kiGb/ayjWV5hxf478JdOdU1ewCwFerQLIv+cCZTpfpiFiupe3aEP/DJKBad8yEJt0e2nVCkjymkn+CGC+YmmA41j45KIuMb8QcRymW2zf3DP9B0A+/UQ1IiJ1ZzIZllPBoFzS4KMas31gTKxKioaOU48oklP9Qg8rbK3TyIyEx2PpBar9XXudty+K1+nuTDAr9guxcejAUnWWo5QZ+QDkK+VUoB5fP+rdRT1iZZQgXA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(46966006)(36840700001)(2906002)(4326008)(36756003)(478600001)(2616005)(107886003)(7416002)(186003)(316002)(47076005)(1076003)(70586007)(7636003)(336012)(82310400003)(82740400003)(110136005)(54906003)(7696005)(83380400001)(6666004)(26005)(5660300002)(8676002)(8936002)(36906005)(70206006)(356005)(426003)(86362001)(36860700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:20.4875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a4c34b-4bdd-45fa-136a-08d967cf8f14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2677
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

The vfio_device structure is embedded into the vfio_pci_core_device
structure, so there is no reason for not including the header file in the
vfio_pci_core header as well.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 1 -
 drivers/vfio/pci/vfio_pci_core.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ee5c8fe2a324..94f062818e0c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
-#include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 2ceaa6e4ca25..17ad048752b6 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -10,6 +10,7 @@
 
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/vfio.h>
 #include <linux/irqbypass.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
-- 
2.18.1

