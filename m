Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB9D3320B3
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhCIIeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:34:25 -0500
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:59872
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230112AbhCIIeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:34:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkxA1xutPMYvvAm+C01fTRmFmZ0LaJhuzvQGQi9+nREs7Rif5YHkKgZX8FALd05mqZ+iMyvZtrfa+1lRaawYBAiM+7pYxyR+jAxsvqKvl3HUkVbH8zvyFvVgaQkc82RXgPpXTK592IWKUgl43Vv3xH2SgZ4A1IdSoz7isrSDVwgyyiLFOOzlLlbXJs7r9U/KPlJTyRZlnK7y5SggKzkOReSsMbz9KTEv4sg5WVoLLP+mXVtl8af10cwP54afRI62yKRej7w00XqTS54EIE2PmZ8ZhVP3FFE1rfjlATfrmon+63icbaNzClzQyfHyJ6IorRdwPuCCkOlgJY0C+AYitw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOoeO+9FPJVvbWDwQUx7tjOUVKIcCTn6cS4IiPHKSOM=;
 b=TeHHY+iNk8uuQPbTHRa+oRDgE9nC9mTChkDJU6JVbzpe+AUwdLRzxDso7D9nEnRAHXRnvvEcQe1rT6j029oCqP4atwUkrXZtqzdMX4uvCMEx7xwTtZoGuuD9gSg36nS1AWtxKNoBv+sThcYnAGJtZUUKL2TslN3CY0kf3bbhLEkD/WK7DVpRVSz0J7kGLtMqqHDOyfir19Uybu+GarFkFS4DtBN2/SqNRAjK5+gQDx40uSEQzhm4m1TJz4zLSlzDZSDTfRGdrEBDSuPTkCoYCrFosRPSmB03n3H4O9ubdqC8hsRQSzm2+UnB3o8x9YXsqQR8TQ2QFNM+ZHGSs08MLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOoeO+9FPJVvbWDwQUx7tjOUVKIcCTn6cS4IiPHKSOM=;
 b=Oj3mqYNeMs8XATzu6g5ZDWrw5cGTLePbW1OR+/XdQ+sVvTayDZbSDRtouVuYM+qKi33e9vbKh91aSAbMew+fqIvZmiNfQG0AF7gB4WccLX1AlxHR6MXULFbNOHGZZF9I3oi+DKnlI38anoMkFV/fqqcLPXXnKTpIUEHjkC7wML3SjmG1zr7b9bWRdmDOof0OEh4XxvjaBXHDu6kuuSRzcHEbNMyWEGUNHYh2b3RrbFMhE1zFFw99ukJVUaQm7GVlJ/Z80jnr2azlil0kaatfJrPvQ/2FqRbfgrJowu3ryPbss9t8O5vT3UJ5FBH3UrwPa5Js1b5j+/WBZnVibJHLCg==
Received: from DM3PR12CA0110.namprd12.prod.outlook.com (2603:10b6:0:55::30) by
 CY4PR12MB1301.namprd12.prod.outlook.com (2603:10b6:903:3e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.23; Tue, 9 Mar 2021 08:34:11 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::ac) by DM3PR12CA0110.outlook.office365.com
 (2603:10b6:0:55::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:34:10 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:34:09 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:04 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <mjrosato@linux.ibm.com>, <aik@ozlabs.ru>, <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/9] vfio-pci: rename vfio_pci.c to vfio_pci_core.c
Date:   Tue, 9 Mar 2021 08:33:49 +0000
Message-ID: <20210309083357.65467-2-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309083357.65467-1-mgurtovoy@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80edac84-688a-415e-9864-08d8e2d61cd9
X-MS-TrafficTypeDiagnostic: CY4PR12MB1301:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1301D957E44698D855F95B9EDE929@CY4PR12MB1301.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rxTFvQ/Z2w6ld0uo4j909wjLtUxroh3fRivum682i1tAIVBy1mW8eD9/J3XXg2EBC5XakkAeqU/79WSGOsrfnCGC6gIXNmAxuNONyTVy5r2nP3NtPbcF20+HRVI8+I88FL8q2OyxVcM/NKMH7/fpqgsSG2b5wf36E2CCnduJZOBo2sITzz+M0orMrA4a0vDHGQO+MZWe11BT+qSZ1Uk6FrDXhABX6NkZQ4d317o18Ju+KFH9fUQYFxE55ejSSUfJEz4bnHxErujlwLoP80J5vZ+loVDOG8P3VTZCzfSzI4/RhVZn1ImzMDl352zaXiTr39vZFmcvHRmzJ8PFC2G3fm5fS7nbevXY4M/KBAuXFGeDSkVkRduHfx65fH/UhkaUkbyoYThfAf1hWTwap6CmUNBO//YtAXeeZPtgKjkE6uboHaHUt4qKWW+c5BXZWnTyBnav+owKwVCBV6hEti5cQSVpiy0vPd7Lw/mg69aWM+0Tpd0UdFpZGtZI/g2S8TUbvI5T18FJDYV3tQBKG8sdsWr0RafOepBNCHVEYn7PAg4wuANPuW7I9jjg+6dRXLkpCIckFyHAjW9kfFP9/soH2QmYKGqSSpSV4RBZKP+BEZiO7aL+Rr2miCCt8T/L2BCvJGW7Uf22CAet6frJvM2kjh7YHdosIi5qGVHXelhiVSsasArUCmOpOwm6byw9MSC7
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(46966006)(36840700001)(47076005)(7636003)(2906002)(107886003)(6666004)(36756003)(478600001)(82740400003)(8676002)(83380400001)(8936002)(26005)(336012)(356005)(186003)(2616005)(54906003)(110136005)(34020700004)(4326008)(86362001)(426003)(5660300002)(1076003)(70586007)(70206006)(82310400003)(36860700001)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:34:10.6636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80edac84-688a-415e-9864-08d8e2d61cd9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1301
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change any
logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Makefile                        | 2 +-
 drivers/vfio/pci/{vfio_pci.c => vfio_pci_core.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/vfio/pci/{vfio_pci.c => vfio_pci_core.c} (100%)

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index eff97a7cd9f1..bbf8d7c8fc45 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
 vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci_core.c
similarity index 100%
rename from drivers/vfio/pci/vfio_pci.c
rename to drivers/vfio/pci/vfio_pci_core.c
-- 
2.25.4

