Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CBA3F07CE
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbhHRPRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:17:45 -0400
Received: from mail-dm3nam07on2077.outbound.protection.outlook.com ([40.107.95.77]:36096
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239765AbhHRPRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:17:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQcSZ+E5LnKDE5qN2c63219KSfcG65CjtlQJlQYEefT1rjejhxOF4gaSDuE/+Z28dIWtbOj9OPTlCuU5U3jRJUdojCRXHd/fSMJv4goISJh0Bguji8+qAooGO/Z7+t5EjAQkfMdBVqtmdYy8OGzDYCI+TQO2BhzybMFCcyJNaIrrYDC68HqcJrQYpaJ3tPOJT0oRBcYAK8Vgg9RJzaRskT10xrqNMOPmInX5hh2gCyuC7Y5/mVKVXMlK0DLsZTxJ02P4nQKC4SKsYkb4Vapxk9kxj8tGhIXDu3zJlLous8ymzscM2f2FzuQNIu4vJfNBwxLRgJT1Uc0lhaiWj61rvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA12dOSs+X500lgNhQm9waVsEnhHX7aMIyxRdvZyw+8=;
 b=Qcma1/dhDmytlUp8Y9CHdOdKCcjDvnQu829s0insE+DfIjeHlX0fjDXOJGER4WsU3xQmT9h+XG7f470st3vhCGZxOszarttAXon55HM4Bm1pd4tObr9fk1yxbNRMHuaHaagq8dKlxG6gfEzrf2MA5czCImkI3sKLjpMl3UlGz/jMX/gTh39d03JfCRsylXggh/zFCM+argOBKIp6xkpx7Ej5SS8AY3ddj4yXp5j/BOnFVXbBIcvVUGIZMT2pMENIMQxh6pAZb/n5zs4/RPNocAwPkDiR3bjNoFbJVO7J3a9oF/cJMlBD5VtJZf7oT62w/Ijulq6P3XQ3qNGtaG3k4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA12dOSs+X500lgNhQm9waVsEnhHX7aMIyxRdvZyw+8=;
 b=cgP9ax4gT2MYdNjhvVb/kESbcsdc5ED/WFf/kNsw0SvOZ5gohnS/A7ROsafAI5CXedEPme1L4iqIz7nG8dDPLRqbG7CdJYx/G9sVXC2G49OaO0NUltPgu1h4jKcLMHll5j4z1sl1uKSABLKsxU/J+NDIvb8G2Pr+SaLUlqx81I/EpH4nyDXBNJhxgD/jlPAtihhEFSYnjGRU3ZH7YdqulnkZjJRPy1cx0riH8VCBqtXJDSE82MkG3ougLW5ybxNKRPdi+qkaOeGwNcKVWzjwkLAMEMbXv1rCzrz7av5251MLT0QqB9v2PutNVwz7cP5nU8K7ePFa+9kRTrTv23cdWw==
Received: from BN9PR03CA0960.namprd03.prod.outlook.com (2603:10b6:408:108::35)
 by SN1PR12MB2589.namprd12.prod.outlook.com (2603:10b6:802:2c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 18 Aug
 2021 15:17:07 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::8e) by BN9PR03CA0960.outlook.office365.com
 (2603:10b6:408:108::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:17:06 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:17:06 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:02 +0000
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
Subject: [PATCH V2 05/12] vfio/pci: Include vfio header in vfio_pci_core.h
Date:   Wed, 18 Aug 2021 18:15:59 +0300
Message-ID: <20210818151606.202815-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6f113d7-3cd0-4ff4-601c-08d9625b3e01
X-MS-TrafficTypeDiagnostic: SN1PR12MB2589:
X-Microsoft-Antispam-PRVS: <SN1PR12MB258946E14858C65871BD6FF2C3FF9@SN1PR12MB2589.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fOAzjakwGuZ2K3hASqbTkFptWIK1hkbJsEq+o9rlLsg2SrQeQ5gfkQmJEbyzyIBnB0xqiqt+mWNfWPOJaDrxfXlNfzm/in/GPY+P3VZqy5F9Tg4FJ4MtHBn+SO7/4LeNyXINaP4ZqygqMPacLDcpv+j/MdB5EPhe6TE30/0T0chtQ1wfbw9I3cgnC3iqgC0IbenwC0qoL0VGgLnXTWytkaTah7vh3FAslacqjjuzccXYKiakPgSfp6mNok99S8qxowWDUUB6hDXLxtNRp3sz9IP+anOav/RhBDOkp5BTxeXR4PtyxFgCswiprX8wZ6MsnIzC71sGO4IP0Q5gT3DkLUzDczesrDz0FH1ebXhFiwe4ai26bKb4EYq6W1X1a1EpcjIXZqTsWNABlVpQvA4TMz0ufeElS1hbl6k/ugHqOV+puiNo/y8jKxY86g+cs3W4yrDfIM1UXd4UIp1extPg7mqutdvmblEH+A1m5R1nDnHLI9x6ccr9KM4q1cQZr/SkYWQXhJBe/83hs8N4JKSuvBfV5YaLRgViKibTj6LeVagqH8TfEKnJCZIaW/LXSVzwmElNhcSdr5mLH0HSwOJPOwGvrBqCyxGqp+Z148CqBYGKqjokm78lSkApua8XQGsiQEDO82V7J/cPZQ3dKBXfqJ7TAUNxgkCUT4ztQ72RuQFpRzfRPGgwAenhuGKj+IWXCgg79O3gR2k7KpGMTg3bfMoCxIKPUaEStzkIUUtTK2E=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(46966006)(36840700001)(70206006)(356005)(186003)(5660300002)(7696005)(6666004)(336012)(83380400001)(4326008)(2906002)(426003)(110136005)(7636003)(26005)(86362001)(82310400003)(7416002)(36860700001)(1076003)(107886003)(82740400003)(47076005)(8676002)(70586007)(54906003)(478600001)(8936002)(2616005)(36756003)(316002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:17:06.9690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f113d7-3cd0-4ff4-601c-08d9625b3e01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2589
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

