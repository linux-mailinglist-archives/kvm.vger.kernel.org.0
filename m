Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A8D388070
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 21:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351792AbhERTXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:23:03 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:61793
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237739AbhERTXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 15:23:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFaSBuxe3b/2aFfVlk/DzCGwXP8NUaBavSJoTsW2CovLofFkaBW4s31/i92HuuCDF6HAFwzvz342+c82zCvN6Dx0MtP99dbRMdb1Vp/W5CCENa/Fx4657OmOFm665k4NyyFznCQSZBJ2WSF7IEJmvOK8Rlq/to4fo8d3ZCfVyL76t+7/t0cfX37rx6alJXLy2Q/tODonDeVlH1mgvjpaeuMj3vfhBQO+q9Lt1IhLWEfel+5uQhE3RB4zB8rbiLXIe2f6slm9s6cFn+SMj5ZBLWroDOIhxlgwculPnOafZJ9v4KHCqsvRS6n1mG1FxjDXWj3MdgEsd3LUVjB2eSLVKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBwLHiw9ajzyRzm1MlIY1rVbZsPqz/BnhHZL9bDzJEM=;
 b=R75H4IjRFcvZc7pFaMY/9Et81dJqh8gGqkhjtyVyinJYZFbQSZBRi4JY/4UYJBEtd0aBJadB9R65ed7b4OPIJ+OZ1BONrhGngqNFZFGs+b6S5lmcbTQmIe7d/EYzNUfsrOlXIfMv1fOwbUUChqZPMS8PtPK0O8TmaIdvqsgJs6W+HKmGR4ljxdtsXUsoVlwzXYJImoauoEaxZYrE4Rh8P5dddQeBkmVDi53++YdhQhyVG3UZHeSnhKZfzaHeGjmL0HNZvGnlf3E9OPOnVqqe7zNSe9KclqyBeHy0i+nxrr5ZxAIouUOuNKffeT3MZCuYX9sq7Oy8QRnDMbaiiNWwIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBwLHiw9ajzyRzm1MlIY1rVbZsPqz/BnhHZL9bDzJEM=;
 b=jOigKUJfqK5cKUOMNOP/L55qMq3zG36gda0BQQLpLg/d11pwOKauBtN8wlIgksKUFwy7pg/+e9I4SAZ+woiBHlTPZ5HkhpsLZoJP8qRSSt2FvtjGKc1drObtg8V+mlKfSQlJl6cmDaT7eBvBtobptDPAzO37YHJrceYkusv0HYTpPJbwHejJdrv0HDhjtoHnaXySlWh0JW9z+y4f43+1cqTgb+jQNemfuUT/7RdZHabomsOsAualzGNnTfwaVBAiF7kKNU7RJThe/vMu/KLm2KiC/xjNPoy9NqbnEaJ8bJggVck6lyi6cIJp7W8OWIMoizAlSX8eJjr3gd3jvjlhng==
Received: from DM6PR06CA0038.namprd06.prod.outlook.com (2603:10b6:5:54::15) by
 BL0PR12MB4706.namprd12.prod.outlook.com (2603:10b6:208:82::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.25; Tue, 18 May 2021 19:21:41 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::ff) by DM6PR06CA0038.outlook.office365.com
 (2603:10b6:5:54::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Tue, 18 May 2021 19:21:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 18 May 2021 19:21:41 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 May
 2021 12:21:40 -0700
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 May 2021 19:21:39 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>
CC:     <oren@nvidia.com>, <eric.auger@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 3/3] vfio/platform: remove unneeded parent_module attribute
Date:   Tue, 18 May 2021 22:21:33 +0300
Message-ID: <20210518192133.59195-3-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210518192133.59195-1-mgurtovoy@nvidia.com>
References: <20210518192133.59195-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79ca27cc-1201-4c76-d29b-08d91a322a68
X-MS-TrafficTypeDiagnostic: BL0PR12MB4706:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4706A36923D66F02D68D8EEFDE2C9@BL0PR12MB4706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VuSZqT/KJS2yeWV2P4HtYl4CeUpgkAitXTMr3GaBRqhVSZq3aVwPVVUc1BIAdF0luQNV0AdInD/v0YNT8fL1CAdFU/0Kjf6ZS7VYVysJDYtbOtgZciY/1QS3htD+VGzNTZdF+4jw5gfWMm6TR5E+uXe+5lUJAAidKAqAU+x36komMMpvbzyw0qd2IswKQUj1WhdE4o/xgkjtwIQ4niZfNnnFn4jDXQ80HRocQ8S5hsDe+hv9M4FCwVEh3isU34xupzdQGTe72WTnXx57hlFDwdpbNgJVmEh1pJq4PMCsagyjWyJg6R1cfR0OqnhIZnA+XoTYm4ChvRIQh1247G3mjiAK6VKfcVeh2Iir8vLrdmGAdwTd59RqPkf0AFanSurrxfpqEzTUxIJ+zhsYznTtI3Gux8H/ucrrjI7bLo3z6gsn48/G6yA5DA2PsGSWBPfc8Xjmp/hK0absZMSUUPIJPA97ZihNlphwTl5vY3POKqZpdXxha0dv64/edolMlzR8qvvxbJdhr6OvbkXxs16Rsabv4LiQrSBglqNPEUWBeD0gULbmWb7kdefSAlYmGhe6keD2XIvbS52l2ax+i15ZHb+oVBznNftFvYxCQoR8qkXhytU5i6f/q5XKvsKpTNja3/WybMPOI3M6tNr10Gwa5+XHEgRDUjIJaSvOc1zHWw4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(36840700001)(46966006)(110136005)(186003)(426003)(336012)(36756003)(1076003)(7636003)(316002)(83380400001)(356005)(82310400003)(82740400003)(47076005)(54906003)(107886003)(2906002)(6666004)(70586007)(36860700001)(86362001)(4326008)(70206006)(8676002)(8936002)(26005)(478600001)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 19:21:41.0856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ca27cc-1201-4c76-d29b-08d91a322a68
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4706
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio core driver is now taking refcount on the provider drivers,
remove redundant parent_module attribute from vfio_platform_device
structure.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/platform/vfio_amba.c             | 1 -
 drivers/vfio/platform/vfio_platform.c         | 1 -
 drivers/vfio/platform/vfio_platform_private.h | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
index f970eb2a999f..badfffea14fb 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -59,7 +59,6 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
 	vdev->flags = VFIO_DEVICE_FLAGS_AMBA;
 	vdev->get_resource = get_amba_resource;
 	vdev->get_irq = get_amba_irq;
-	vdev->parent_module = THIS_MODULE;
 	vdev->reset_required = false;
 
 	ret = vfio_platform_probe_common(vdev, &adev->dev);
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index e4027799a154..68a1c87066d7 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -50,7 +50,6 @@ static int vfio_platform_probe(struct platform_device *pdev)
 	vdev->flags = VFIO_DEVICE_FLAGS_PLATFORM;
 	vdev->get_resource = get_platform_resource;
 	vdev->get_irq = get_platform_irq;
-	vdev->parent_module = THIS_MODULE;
 	vdev->reset_required = reset_required;
 
 	ret = vfio_platform_probe_common(vdev, &pdev->dev);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index a5ba82c8cbc3..dfb834c13659 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -50,7 +50,6 @@ struct vfio_platform_device {
 	u32				num_irqs;
 	int				refcnt;
 	struct mutex			igate;
-	struct module			*parent_module;
 	const char			*compat;
 	const char			*acpihid;
 	struct module			*reset_module;
-- 
2.18.1

