Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5697536EE26
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240839AbhD2Qaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:30:39 -0400
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:38944
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240824AbhD2Qai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 12:30:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HigXDxsrr9C3Lg9kfODmflrVI0DVvvGkuoc04TDVl7rJLoREscHLrd0kEqT3xg1F88bryehAHT2O5LPZDSwo5u9mf43F/IbB4cqy7pEfXL8zNCZKqaf1D2INXPZ2mA5kq3n6IZ59+VsQz8nQRzrwPCmYHCZxp3cHzxD6ZtNxoUzpP3KelY3IoKsMNvAbmurAzRcexJwqk99VBeSNrJjmIGlV0z7RsI2tOlV4+fDNn4eVNyDf+SMewP2kwf7f0uypdSdyYXiojqdOXfDJQN2yGgmMc0SyF+o1Fa7sOyn1I+s3ubOvUxksmpW1HSioxEIsNC43h0+Se9IL78scbHMOFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qc1ZY0y/mmzxUignXhrkMhd0H8c12S9xVSQzGDOnvmI=;
 b=cFykG61wl4h6ScSZTVmYGy2oQG7vKqYT2JL5uaTD7uh6o+Wg02uOc+W/+vto1ZMSnP5cf/i8bphnkfvtq7uQeox0jveLs/wy1MRNTeX9vx/Hbrw+zCAdm5ghl2iGQNJI9cN0F7iVjPmQqg2oNGx1UMQOsaZ+Thi2Qt8aJpg2RuJ77fvagtr/UiTt+xAKjPFzeODKIk8PbfxSYUomRY98T1OZ0L3h1zhqjYMr+tggOEXCEsNBMm+wgfohOsbs5b9G3OgGTi6Mb91llr78h3B9HJqk9/DHJTw91ma/ayS+PuWqNJ7CO0MN0I1bcC9YhUkECMHaRvA0Ckws3rS4LH5lcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.cs.columbia.edu
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qc1ZY0y/mmzxUignXhrkMhd0H8c12S9xVSQzGDOnvmI=;
 b=iHrucmpRoNOuv1ch20G5La28U4gyu5ktOZmEtMRKUKbJJa+PlL0x9AH8NtS1V93jJdaR7KJzO+yW4WV5ySyAL/r2WGroohQUgCk5wKjsahWdlB2mKtbPnCFWqCW36MG4yeVrjafzGROtBiFXeLfdK6q3qbt1tpGydA4ld4AZQnzVVjYBhOTuQsRPYjCCuFNkKDaQqj55Z08gZkbQxD6bi35PQYbkgi2XN2eNZ4nCQf3QSBH2ntkjBVtGvCcyUGsJQQompS8ysCuKw2Tn4WHnI5imJDceAGLFCtJru8MeJsMtlDwCgSMO5jfN3Ezq17DS4XFWCq2nxgXItTA+BnrBzg==
Received: from DS7PR05CA0004.namprd05.prod.outlook.com (2603:10b6:5:3b9::9) by
 MN2PR12MB3279.namprd12.prod.outlook.com (2603:10b6:208:105::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Thu, 29 Apr
 2021 16:29:49 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::5f) by DS7PR05CA0004.outlook.office365.com
 (2603:10b6:5:3b9::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend
 Transport; Thu, 29 Apr 2021 16:29:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lists.cs.columbia.edu; dkim=none (message not
 signed) header.d=none;lists.cs.columbia.edu; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.32 via Frontend Transport; Thu, 29 Apr 2021 16:29:49 +0000
Received: from SDONTHINENI-DESKTOP.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Apr 2021 16:29:47 +0000
From:   Shanker Donthineni <sdonthineni@nvidia.com>
To:     Marc Zyngier <maz@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Vikram Sethi <vsethi@nvidia.com>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        "Jason Sequeira" <jsequeira@nvidia.com>
Subject: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR region in VMA
Date:   Thu, 29 Apr 2021 11:29:05 -0500
Message-ID: <20210429162906.32742-2-sdonthineni@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210429162906.32742-1-sdonthineni@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a05a37d-ff50-4df9-2514-08d90b2c0257
X-MS-TrafficTypeDiagnostic: MN2PR12MB3279:
X-Microsoft-Antispam-PRVS: <MN2PR12MB327973533D144AA452CBFB0BC75F9@MN2PR12MB3279.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R5uV8e2n/TzbukeRD5bi7IhDHNlzBheZ0tv4afAb8qoH1xLRRFeXD+m+G9V1w/rPVQVZhb0UPaL5d0HXenU52hMhtRIKBP13Ag+sKbzxbL0bx2aZLLyltuqVjsdf3jWpvIw+AR6aKOBZnF7Lg8Yd9+LagWdE9+eC7gvBn03TACgRnT4Dw1rNJl1WbW+RHCZCDOTwC7nB7jifDWANDX8Fb2shiyXJ6r5cl+KK3ilEOrLz8kxNkRhiYSIEO7i5/1x/6LgAj41aXN52eI3Q6rg8Zak8PSXroqu8/haJFh8XwXP1eYqfKKWt4j7Rxsabb73iqyeiLimsAgWQPrQR9zdPXphINUJN7z0/skRibrf7xGgHYaPdrfpCQN1VBIUpLqDjMZkLH9ADut8ume6WP6ypRbjNivKN40c7c0nb6rNeEbXhTeuFWeXjjyREyX8TE9JYPCasnxpu9xnoq6OZi9+C5DyPfgb+457IGM6ZUB7+M7ahyiZrldUzim3O+mIuTsCDVibZp4v58j6g35YDGq/bX/6sBSi+HbZEBLemvQEFV3vDUFlJXgZtnFk3Qv7MmznqK+IkvI1b98wUzilAeelNYLZoGUpbedIm3mAmpAmK4XWr0yyafGVczsnUQCr2oFqWYFnOJTP9cdT0lE4pGGBOaQqbAspzfwApUuNMGsMHMnXaJMkmYwogeV/oQtoeyi+A
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(46966006)(36840700001)(16526019)(336012)(110136005)(186003)(5660300002)(426003)(2906002)(2616005)(1076003)(36756003)(8936002)(70206006)(54906003)(107886003)(36860700001)(86362001)(6666004)(47076005)(26005)(316002)(7696005)(70586007)(8676002)(82310400003)(82740400003)(4326008)(7636003)(83380400001)(356005)(36906005)(478600001)(3714002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 16:29:49.4348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a05a37d-ff50-4df9-2514-08d90b2c0257
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3279
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For pass-through device assignment, the ARM64 KVM hypervisor retrieves
the memory region properties physical address, size, and whether a
region backed with struct page or not from VMA. The prefetchable
attribute of a BAR region isn't visible to KVM to make an optimal
decision for stage2 attributes.

This patch updates vma->vm_page_prot and maps with write-combine
attribute if the associated BAR is prefetchable. For ARM64
pgprot_writecombine() is mapped to memory-type MT_NORMAL_NC which
has no side effects on reads and multiple writes can be combined.

Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 5023e23db3bc..1b734fe1dd51 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1703,7 +1703,11 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	}
 
 	vma->vm_private_data = vdev;
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	if (IS_ENABLED(CONFIG_ARM64) &&
+	    (pci_resource_flags(pdev, index) & IORESOURCE_PREFETCH))
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
 
 	/*
-- 
2.17.1

