Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2643F8579
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241547AbhHZKkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:40:40 -0400
Received: from mail-dm6nam08on2074.outbound.protection.outlook.com ([40.107.102.74]:1921
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241503AbhHZKkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:40:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jgj2yTX7gXNMytKlZEE8ESJnTLg+xsMrIE0lpFopdKo72Nkom2hfl+NiVsMEdy+XfSDbGJZsTMsmyR1eEif6iwMBTaSxKALmej63F/upUm4y0xKIfSkfm1H78S7E60ZtGtXLMqbpicWkdfqglpEYu/Bu91RjqRgKyHXNejW8Ff7l+RvjNluvWFYvTYAIimXxpe3Z7+IAVh18qgNfaZpd47+l5HIupD94ySZuVyUteRs6e/e3mqG3Z5afZNfM5NE9zbJtqA+gdQDefpR3VX90zCBOLuTLH9GkVGG7WcvmdJCkMotC3iIGd0fL7vcPG0eobrWvGO8d7lHjrZ9gMsdYhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFxqabfRMHSuXPSfnhgmqfWkppitTt4IcKBtD+Ecgv4=;
 b=XQhGq6K2q9WCXNWZ6OLb4+qlU5yZi+PYWOTWteg6qrXj1uKfYXlJkYLzq3ZCqbW7/5TzlUMK7oenFVpsw0BTadYLr6F2k8dC7yTUdnnnYBtIIjb6ASGL0JXqSZ5ODNU7dG8MqIS5obe6ZNO+JbPyadZLFBfNpQ1QK1OaUKYKm1dFdFeCpYd14rUfTWxZ5JZSkLM2lAmLJHj8XXy6HMHW7aOQ6ipVUf4SAcUm9/4Yk4Dlsx+ycFSoBX7xydXA+omhTNx8Xd1ElhoN7/Wb5jmZ6cLhuZAWBFcoucYsUVJVaE7JNxk28Po2fRjJQK+WyX+CR+M6rm0nEn80/aiU7jw+Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFxqabfRMHSuXPSfnhgmqfWkppitTt4IcKBtD+Ecgv4=;
 b=RzgWPsNT61ZO8ONnRws8U1213B+IkWH6oL4esAe9ESO6k8U+4X6uzWTTwirQwJFLQ8mj9jlLPDR0D/48Rs7BKbj65mb41mVMCHqE+si7Zaia4EnGPAviTyG3Yuhj7ThqJb4yqER5mdYXwtx6DPsgJEYwk3tLX6RAOUAVq+8ti/Mm+pTH3U+eVu2fAY+65DXPUW7ZCzhKFxwCqoF216StINcZd9gcWG/WGDy25sfjvC2VYrvv8n+WNtSr/fDExQzHBJZfjXX4KlNaD/5LED8l1YJ3a2zm+CFjVAZcjuV+mR3jXaSdjM4Umw6RrmlrzDVyiBxLPPkllfjtRWYnzZk+Sg==
Received: from MW4PR04CA0278.namprd04.prod.outlook.com (2603:10b6:303:89::13)
 by BL1PR12MB5364.namprd12.prod.outlook.com (2603:10b6:208:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 26 Aug
 2021 10:39:42 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::12) by MW4PR04CA0278.outlook.office365.com
 (2603:10b6:303:89::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Thu, 26 Aug 2021 10:39:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:39:41 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 10:39:40 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:39:36 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>, "Christoph Hellwig" <hch@lst.de>
Subject: [PATCH V5 01/13] vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
Date:   Thu, 26 Aug 2021 13:39:00 +0300
Message-ID: <20210826103912.128972-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0267708-fc9a-4270-b23b-08d9687dcfec
X-MS-TrafficTypeDiagnostic: BL1PR12MB5364:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5364DC626A8D73B8314DA629C3C79@BL1PR12MB5364.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L3wQvue5eOwZPDQn5CXdszye9Hz8LUaOKDZMIc5cANaREOPBXPyxkDUSAgdcuAjqGI7+BmOXtTY1o0yovFMM4umy0Owl182CprKtW96YdAqh6sZcbew/PooloT9LlyxbxMHAloBv46Flx5wQDnsoiv8EJ+aJR2zzyze2HOwxJ1h7q1kYMRIck+jdV+qC6xyTFYqi+GwBwNZy04CipUEPVfrVM0apmh/QQfzHQ3CDUq5I2ewWKHgMpRD2JDuAaVIeZyXHFnSl3InE1InvmUlJ1207KISp+Om7NN4IgQ0Q46HIEe8KnYeRnGNmVt7YtVB9HfqWMwJRYcNSqXfbHllFA95QhK8WV971V1aWxiwf63oNcX2SAYe84nFx1TnjceetKhYNUlLSA+uKQGo1HXyBrmqYuAG27MuRY34tHFFLtu1MOcXLJZtRrS+PIGv/wpydivemsOq0Y39jXUW8YM8xG24Z1951M2ou+57xNNnneub7fsQ4UnYZb66QKz41IepUI79CJtRmx9HVklnhAZqBK5VmY8I4gSaamzI5WLVnJJ+k11j1OJ8eIXZ+v5Ht/6twHRFdKqDB0qISCdxmSf4sAbGcD5STAlFy7tr5A4bLYwXp8OywlY1hBwInytTyzR3ps7bn0OJ8v5Nu/PUxRcn/VkWJKijlb0igeUIi8Q6EOJL9vEk6359MKyTDncL2FwTLHCVnQKIkFWIjo0EXRMS2x4UCAgJAY0P1DI4HfnUmbqU=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(36840700001)(46966006)(36756003)(426003)(70586007)(336012)(5660300002)(7696005)(70206006)(7416002)(36860700001)(6666004)(8936002)(110136005)(86362001)(54906003)(82740400003)(8676002)(478600001)(47076005)(82310400003)(26005)(2616005)(83380400001)(2906002)(4326008)(316002)(7636003)(1076003)(36906005)(356005)(186003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:39:41.7003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0267708-fc9a-4270-b23b-08d9687dcfec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5364
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change any
logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/Makefile                        | 2 +-
 drivers/vfio/pci/{vfio_pci.c => vfio_pci_core.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/vfio/pci/{vfio_pci.c => vfio_pci_core.c} (100%)

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 3ff42093962f..66a40488e967 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
 
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci_core.c
similarity index 100%
rename from drivers/vfio/pci/vfio_pci.c
rename to drivers/vfio/pci/vfio_pci_core.c
-- 
2.18.1

