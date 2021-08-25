Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6383F765C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241458AbhHYNww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:52:52 -0400
Received: from mail-bn7nam10on2055.outbound.protection.outlook.com ([40.107.92.55]:53144
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240294AbhHYNwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:52:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYUsdWfy8QEiovp4fQTQGVnBrUpfww2EA1KM34zCy4TjbiLUc16KanVWusIyP1YadNYepH/Ys5Yumz49cRZOHz93BavtLuCdlk+dZfTTJdlOgTF2AEtrG4liXKGRiXYtluceJkonb30FX2obo4HH0N08qNWxmKtMBMTcu/ZKAQUetj0P2Mt21bQs1qMQcD+bbIJoKgcfwy8zQBPBludH8YKqIj1BXeEFiKATuhAJDJXUToedSKsWdtV9u7g8RTPgB91k+7lZYzk9hoGR18Xat3qi7y27zus85FoKmHLykkUYKUNxJgRE9fzZ0/8WoqZ8zf37GIWP8p8tLZobUFDAbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zp+Wv3I6Lwwlt2ddO5B9K3CvX1Q/7KFCOBAY9VFDsM=;
 b=EypXfk0L83bP7Gr6Bq9eNezbUSTenNUg70IZrjlc0aawJivpsWCnIa10Uw5WDXXMm/BspVnNdJquoOwt+2mqFIiA2bOONq0X9yjmErKbGlSXa6J95IazqUTheGj5KXCSYdd+qoKxvlIQ+MP0zx0s8eSqgslGMjuJaOF9x1czryhM7G/0kBAPl0kJdG9mLrzWhQ0pIAESQvNEqJSn/SnOMIa4E8tY2/SMhH7ZsLohmW+h57u5fFjj0MMmCjb3vDW/U6aoVH+179vzbzmThkcURm6rQxXaFC6HXcmLIyExaO8aCq1zzNCIYaBK4XS4i2swPQ8GB1QI6HNSO+YU17H1wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=markovi.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zp+Wv3I6Lwwlt2ddO5B9K3CvX1Q/7KFCOBAY9VFDsM=;
 b=beypHP0HpsTco9B+ryZ/Fn7lU5KDrcjOBTbPDAqnANvzM+fxaD2j9INTrasgo7sEnttGrIBH4F5i2feZ9ejEruMZVK/N7cKE4JZRHEyNfJjGdzm1QoSgEMlmtBS6G3On3I/B7c5SC7HdqmWW2Wt6drFGUtSE71b9esqGS0hfO+oeXJ4Ls6cnfnyLdD7+k9iJF0CTtlRQsHsPWENbZ8BDQyS313S/FX1N8qJNpIGBANXAxYlyvyWucBUVmc8I4X5cINAhFfzxjOkGsdXc1n7WwQUmTnyNJ4KvILN7/YdZnWjRBklZv8knCKx3g7hvxAjApnWEGcbTUTswAaStQ96QCw==
Received: from BN8PR15CA0063.namprd15.prod.outlook.com (2603:10b6:408:80::40)
 by MN2PR12MB4799.namprd12.prod.outlook.com (2603:10b6:208:a2::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Wed, 25 Aug
 2021 13:52:04 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::34) by BN8PR15CA0063.outlook.office365.com
 (2603:10b6:408:80::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; markovi.net; dkim=none (message not signed)
 header.d=none;markovi.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 13:52:02 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 13:52:01 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:51:57 -0700
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
Subject: [PATCH V4 01/13] vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
Date:   Wed, 25 Aug 2021 16:51:27 +0300
Message-ID: <20210825135139.79034-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19c6dc4e-1f54-4cd5-47a8-08d967cf84ce
X-MS-TrafficTypeDiagnostic: MN2PR12MB4799:
X-Microsoft-Antispam-PRVS: <MN2PR12MB47994EA9FDCF2F85CDEC5D31C3C69@MN2PR12MB4799.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gvpwlPNiVM7SWdBi667gozND36nIYOWrDWpl+Z0h6Vb+v+AiSY3hPtTsLtHBFxWCuUoL/c43wDBHFN/LW31r1S+uunJnB1tb1YIEvk8Bqs7sdewwvCG+YLFP+AEl+OI4LZ37855o2iFKqQk/SngBp7mBs2omDe2Kqp+a1qzgccR29IVlKOMWQfQQvh146zJAg7Jmd6YS3VFdT/jHcQnSR5pf+rOqCFU8a1oJ+M51vmfbaLJG2rku4X1FZi/nv44vyF0u0PsE4Gz+fsOVvhVJvqCnaRED3g7o8XCbtDVaKbJwPcjzMdR8y2NkYPUP7n6I9KNyGktF6x6Ovfof09YfaCHHZFzsFMTwEUFzvgtx8l8kjwnKAvZsWZngp6EOD+NvBIJJWhZ3egOYkAFWu2dorIZuuOea4/Lyl1LEgJ/mdwX/gSlfba9vP8RlX8A2PLMqNcP8LXJ2NZN7KkxQBIyB1VmdLhlaup4AisszfOtmbPQ7nTeB3VdEiYCBXugPAzS2CRWEMC2EpKt3zMUAk0LFj+iV/DiD3jjPCxHg14X7P0FuivQNYOrpnvvC0A1yzH+QK0jSB9BK7ng/cnXlG6h6YaHjnPob3Gz50LUrxeArvComQcnUoLgStOd85v0FrFzlPJVk01EZOoTWQy0A6dOHbQ1VXZDirklf6C1u20U6Qi3JwAqBINCwuk/a60nq5F6RmNatQC1I9xLcW/PnzP20uLni9BhnEnNbqYlbQIglBZM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(46966006)(36840700001)(82740400003)(7696005)(426003)(4326008)(186003)(70206006)(70586007)(7416002)(316002)(8676002)(6666004)(5660300002)(54906003)(26005)(356005)(107886003)(110136005)(47076005)(82310400003)(1076003)(36906005)(36860700001)(86362001)(36756003)(478600001)(83380400001)(336012)(7636003)(8936002)(2906002)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:03.2009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c6dc4e-1f54-4cd5-47a8-08d967cf84ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4799
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change any
logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
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

