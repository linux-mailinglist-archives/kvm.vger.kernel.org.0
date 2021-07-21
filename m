Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD353D13C3
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhGUPhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:37:11 -0400
Received: from mail-mw2nam08on2040.outbound.protection.outlook.com ([40.107.101.40]:41057
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233372AbhGUPhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:37:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqGZvpegs01gVBIVm2ATLTmO8j4MuSF5SAT4zHHYmg3eaq8d9qWkwpQ1pUleCXnDQxIn+417E9XDfboUd8/DMOrz9e8e12x5ECny+8Lht4di0OD/Ax1vdI5hDXZmdLxDPTAj65kX1EvKa2mbdIjA+tnZsHePIZTijfB5Y63z72sMuM1uM2qr7WjPN8E8K36JSjMuGZKcNLniYAffLwT2fJT/L3jYQuK2AUsMXL6osJ5c9bpK8m+nPFIGI0NgXBbbNAVdFt+TAVcPTAuw1CPvIXTcZQ81QTRCnnfm/L7RBy/B5EBE9+flv/27xU0ff7t8jyJd1VlMmPQ2rYwpvxZYVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82kgahkYIquX6/nJcGWe1OE2kHSKQsOHWuoU9E1fk74=;
 b=aEieq1ELCZLLXLjuSHsPBDBt7s6vFXKEIstJfxThsswTHZL8CBbvGx5GGi/5IX5fqVzZcWEz/2ZshssRurxdnQkUCwWuy3i3cEyqHsbyMltRdbUFXEab1WSdjoVSK+dQeuSe3p3OfEepaVhQzEEt5/U/DWzgqcGaFQrpnzd9vwESaMrqf91bZHD0rPKfFN3TQbI1g42laVEt+I2DlkA8RiK6Fey+90XL53htQyWEA6Ep0pYFxVEhuR0SEFgjcJGheo0JPEXpHKuZLKGX6W77J2roROp7ndFLoZ5XbgzLH/SQP0lO1ddmQXt786eT72DGjTjhDdgxvCtDPsIzVMvMlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82kgahkYIquX6/nJcGWe1OE2kHSKQsOHWuoU9E1fk74=;
 b=siR0U1c4riYOsXCayIHftl3oaNL1Zin/MZw8FZ4AC5DwoMUKuMwK5hVwEgQAiYtmidLl00Dnq0Ml7L9xiEX9t+mdhvGb5SEnz4KuPIvkjClQ/hmaDTWC0BrZlf2KkoEEQvs2zesQIhpGqW0UYaB63w/SRwN34vaIwSbPul8jfLSGQCADVXzo0wJkLBGmnryAtiD04yTb83yQGckLh9u9kx7RbBUKpmtEFaIgdlR5x5PSrXXTQBXVrTnJSzrW9rf19TfGd+aZN6+GBSHp/lF1F3rvvGo38WG+ft9DqEvnu1CZhYgoyh7iMRJk+6nrHz1xa/a8Ejy9of4GBipvBIa7UA==
Received: from CO2PR05CA0060.namprd05.prod.outlook.com (2603:10b6:102:2::28)
 by CH2PR12MB3688.namprd12.prod.outlook.com (2603:10b6:610:28::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Wed, 21 Jul
 2021 16:17:44 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::cc) by CO2PR05CA0060.outlook.office365.com
 (2603:10b6:102:2::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:17:43 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:17:43 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:39 +0000
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
Subject: [PATCH 05/12] vfio/pci: Include vfio header in vfio_pci_core.h
Date:   Wed, 21 Jul 2021 19:16:02 +0300
Message-ID: <20210721161609.68223-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2acbf084-755f-455d-8b5d-08d94c631225
X-MS-TrafficTypeDiagnostic: CH2PR12MB3688:
X-Microsoft-Antispam-PRVS: <CH2PR12MB36888B2806CB70B65ADFD03BC3E39@CH2PR12MB3688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CrGnNukOHrg6jvSyKVoxG4LVZZ4X4yBoKppLhOeOLWAMjptdA9S6dsWSY9J1SAi64niViSaiBR6WpEpMCiPxd5ff6PITBFF5FAKHMV4jY9Us99/Jgni5i0lAJu7co/du4MsDOU0i4qXpaeG9HS4ZzCGV1bZSOWCdL4DVF+2v15ZfOL40ay28KFWPN0/yD7udO+6VO7DzYv+Pq4cu5QsHQmO6jjNwiZpzlaeE4hw6Qk/EdLHsPYsttAUAao0hRymx2lKrDjjYJT4Mi/R5PgixYCKwKqyNswRh/FjVVUPOdUawKuxPrUunS+w7z5dm8OZWnzW5k1zwXb4p4aXdqeTfPH+1MTGi2giJZRiwp5ab/2cYbHW8+dAdVuyspIh3qOjsM/i/b4Ov7CQgvKlOUWGSYg9pHWj3mY6sDCWilgop/r35efHs0npEe/kv6wHmnCbYMS7tDTjv9f2thmDAYo7F5kbjwaTB8llghtX1gD1veSyllHb/+Vue5ETd6ET1A8sBtOp0qDVyA79WqrJWrtDJHPVazIrl3+8ayVSEkQn45r83tv1l4UDr3RrAEqndRzwPqDnUEYDNPvr25doIJOb9y5ThKaBwFQ09qTDDHYas4+AuiStdMyQZONPKPUCtPf4bKkcCHZuV4JvMlZchvmRjFAIwIzbAEZsngCrnI3raHHlFTh7ohzl20PyqMpQt+suoL0Ygn9xelIJEUDSsiPGE6PTK7RtzCbV5zvcs+HIKBY=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(46966006)(4326008)(54906003)(8936002)(478600001)(1076003)(110136005)(7416002)(70206006)(86362001)(2616005)(316002)(82740400003)(5660300002)(336012)(82310400003)(426003)(6666004)(36756003)(26005)(107886003)(7696005)(356005)(36906005)(36860700001)(83380400001)(8676002)(2906002)(47076005)(186003)(70586007)(7636003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:17:43.8520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acbf084-755f-455d-8b5d-08d94c631225
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

The vfio_device structure is embedded into the vfio_pci_core_device
structure, so there is no reason for not including the header file in
the vfio_pci_core header as well.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 1 -
 drivers/vfio/pci/vfio_pci_core.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ab22b0db064a..99f579c23ddd 100644
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

