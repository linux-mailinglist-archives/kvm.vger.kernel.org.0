Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DDA39A556
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhFCQKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:08 -0400
Received: from mail-mw2nam10on2089.outbound.protection.outlook.com ([40.107.94.89]:23236
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230055AbhFCQKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZkQRu67Pd6bLrL7JGgQzoPVoowTp2C01fjTHDfrvzHnKh5IFjETcD1zRhVHBU4UVGmg1W65X8yq3g+Oqu2Ig0xLdzARnINpBhh4TAJ4To3X65rzToZttUeAmhFOa5Aii5i1f4pqgOdEboL8vEA08wXOR4KR4CP55tpxQMGyQvDDa0eVNXw6uFxR+msHstI4njSh2R/75L/dZelvizUfyqRwjJZ8DS21XutZBoWpsRSU/NxXbN3JGRgtmvIMNuFVZpw/XUlQW6yCUNcGOKfFWlRDsbjBoPoY9PzGG07braBwq6ZsFjVQ2SZ8zpNjclbvZ4hSesUqtLm7HyPHEzuhtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwPmXRYdRXPn/RiDuZ1iZuOwaa54zlsGBBi1DjxxJEE=;
 b=Vr2qwVlrWEGFh7LTEYR0ZctYNQz8EZ3QDpx5nWNKTGZD+kmSpjmhJVVBzvLIcs4kehMR8bu9uGXnUc0i2eXiTSG0CEV6QM81Rvr67EkmYVgR4zAUF/N0P9H9iM2TXqfNT1cGkZ4/YQiDFIdZ+PUu89EaUE7NmwhLAZTfcM9f6NRfJqblpYhoegeAo1SL+XmDgApdjvxcapIApnEvyiJSbJ0fpOuPg73z0byYTpiHwZTSjIfTJWSSigXCyyN5pQ5XP2ZkaE/IlY1cgsT6wxR7H7XTK0Nr54erqe/7OrrVcyRbxd5bjY9MU3yQa+KL71mR2JVckn0nlNw2egN/OE3+kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwPmXRYdRXPn/RiDuZ1iZuOwaa54zlsGBBi1DjxxJEE=;
 b=Z/lfKI8CPA7gn0YhirArB+FTchZYwP0i/SEdwXdDutNqOEWVhjmoiboOw0eTDx5nU/mx3rP69mNSCwm4YbFvwZZF8SVIHVhgc4IL0BpThsg4L0ikXzluDx2oUceFdPuHwU7U88kDud0rjWs3X4aRGgLMWS3z/yXlDuuGcROKlurmJVmlQh3z1F8/Ll5zdLOwsjx2ekLsE3Y6ZT3VCJWlaBR7iDgExiSSJ9cUAKr12NTrNM6pgmu8kIDxG9MDKxD5HXwLMEVwHQD3uv271KA3WGbk/TAnjI8IkCgeXQAz6SXSlSAYFeow3DDz6sifX0seTsFwXymcpsfT0yJl3tE+dw==
Received: from CO1PR15CA0046.namprd15.prod.outlook.com (2603:10b6:101:1f::14)
 by DM5PR12MB2469.namprd12.prod.outlook.com (2603:10b6:4:af::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 3 Jun
 2021 16:08:21 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:1f:cafe::3) by CO1PR15CA0046.outlook.office365.com
 (2603:10b6:101:1f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:08:21 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:08:20 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:15 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jgg@nvidia.com>
CC:     <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 01/11] vfio-pci: rename vfio_pci.c to vfio_pci_core.c
Date:   Thu, 3 Jun 2021 19:07:59 +0300
Message-ID: <20210603160809.15845-2-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ff0d18d-9851-4725-03d4-08d926a9cf04
X-MS-TrafficTypeDiagnostic: DM5PR12MB2469:
X-Microsoft-Antispam-PRVS: <DM5PR12MB24697E7C42728AE0E1249919DE3C9@DM5PR12MB2469.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tFdkMhJEU2gvlEGz2ZI1jeoBi5PBFsd1nFxrvqJh5Fo4OKoaAZ3joJ8PhbNLD7riz1Ch7YmvSl85Z9JozS2aUwdsbSbZkwxeJkPZ8Bg4LMB/bffO6WSysEbhN3B2VuE1EQllERN9dNaR/PVBxdJxJF3Mcd4YADb2jJBh8c6a+fpFShmDd8e/0Ec3jNk3mUn2pZz7r6X9KB7HKpnUvzO/xwnFucsWiYn+FxAtBt6j6V29yJDpKHnMCDZ/Mj0/mbg6Ke2pEyz7IZqE9I5KTLUdw+04j/jBGiAx9BSs938gCB7P60QmawJqBWNmP56jC/pJfnFGJ0UiOFclX0L58XrYNF1gRHRpCsmyaApnOtea1FFRpfO0y3CcfVtVaPLvA4dru8bZtj/jMqTO3Vbi3D4yOLSpE+ttsHYEV9OF/cQLcYLvlCB4RAqAk+ezb0LUqlCyB3WNXCuFLWQRYgcG6FmEKEMBV8ZSMK4RSfTAPaRsdCqU5B3zsZzpyZHW8d8X0+79sOMMph68xVjd1Ze/DqJswhxAqVsyjK2MXXlKHXuumzcuHizLq2k+U/xKapa9Y4/8N7GRyeb1/a3JJfnyQ7bGKfRQYkDdvwoFWKUR2YzaI/lkfoVpRnFJPUs8zB22aohP9rJPRNNFuwADcG7THzCF1g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(36840700001)(46966006)(1076003)(478600001)(36906005)(356005)(316002)(107886003)(82310400003)(36860700001)(47076005)(36756003)(110136005)(82740400003)(86362001)(7636003)(8936002)(70206006)(2906002)(70586007)(4326008)(6666004)(186003)(5660300002)(8676002)(336012)(6636002)(26005)(2616005)(83380400001)(426003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:08:21.2072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ff0d18d-9851-4725-03d4-08d926a9cf04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2469
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
2.21.0

