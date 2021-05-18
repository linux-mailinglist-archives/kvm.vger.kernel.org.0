Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BB638806E
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 21:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346055AbhERTW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:22:57 -0400
Received: from mail-mw2nam12on2089.outbound.protection.outlook.com ([40.107.244.89]:64256
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237739AbhERTW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 15:22:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCp0+QtBpnHOoMRXx3j9LIAD5sfJJf/BafVvsgcWTDYUYBnqwYO7G7kQ+CRSv8wGWDQpYdgSgRn4O0JdBU2DPDVAu397r78glc7drgp8n7SmNKgUwsQZuJ/fAXG8qGqSfzQU6mW2/lc3p1Q9CiN4EAW0mNhfY6aFawmEm61TAwKf0MXjQSRa0CMAivIGop37hzvgfFtxtQGqMHdMj4J+QO4FuDl6j0DRtSI2plwUaFDz9aVAXYCAAWBEnbhl9R4weUTh0wGKt4yKGGKYyqekBP6HNi2gw11RTLJiIw1Rbk88xipR7s0uJT2mi6/cjIaoHjI352T92GuxGwNBnl2rPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcnTnGk4MKucZ5I2jfckFtN2j5CTu6Fp125uCcm022A=;
 b=RMGkE8DCHHEr/hTkwtfskGjE9NNS/Fm2fhfXD0UAVFCilkXt5P2yDIJsHEdF3FSYA97OWudJ/XncVKK7tfhzalNTZvM2N+Ru6eQEJKSanJUEW/m6d8GR4Kz8RMin+dV9jnFEb7vAx8ezEOhoeW72CgT8ooc2d+RYPx0p7Pbcb7qkRTeb+2K+C/9IEq/56pFYA73FEnh6CM+OwkOiCcE9XSGJHbYqekKdbcLbCcBO35P78GXXmKPgplpZFGbMZ8bz5VmzHQCEUsTdwEY/edOvDM7VuVasGvaDflmY+KV7Tc2WAftEE0BnDzfhxFO4OP1nLXeLO2ktMIJMP9MlGv1Kog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcnTnGk4MKucZ5I2jfckFtN2j5CTu6Fp125uCcm022A=;
 b=X21r1NwuSPLcPFFOdVf2KYbqz2TYx6VhHC0cJyUGkYmuj+WF841VXMx1HjhlkFtj5m4snw9C1TNEgmyJBj/g6CbZP6Ii7Nu2tJu7QkXfp5kt/4l+xwTT1p79eT6MSnppfol2MQL042kVmHsVidlcs3/t1kea78RPym6nQtbZlRwZ1SvYU+6bDrvBFOmHQY2iu7x5NyK22X55SHDfMY0AF0bEWssFh2j670QX1kCFjjuOM5vTPD7QxROl23yc21e/cYUER+PMyVKHoDw3dZNoEKx1CzlvKgHnBXTzuQEwY+I0EL+2c4JzSZUqRvJzDE8LTvjUFRxj+00mIO2vZTr6+Q==
Received: from BN6PR18CA0013.namprd18.prod.outlook.com (2603:10b6:404:121::23)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Tue, 18 May
 2021 19:21:37 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:121:cafe::2a) by BN6PR18CA0013.outlook.office365.com
 (2603:10b6:404:121::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Tue, 18 May 2021 19:21:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 18 May 2021 19:21:37 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 May
 2021 19:21:36 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 May 2021 19:21:34 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>
CC:     <oren@nvidia.com>, <eric.auger@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/3] vfio/platform: fix module_put call in error flow
Date:   Tue, 18 May 2021 22:21:31 +0300
Message-ID: <20210518192133.59195-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bc92793-59fa-41a6-e77e-08d91a322806
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB02552E1D75670B5263B1B322DE2C9@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EnCdjKX8zbDKGqgC70wKUCfx9tsi/qrDVCqXETqGZFweAL35MjU2ZWTTnQolM4UCb3kGVcQ487Ntx2TaTVyqg+l1/yov3yWziTlDvgmX8Yc8/VwwwwJUURQqkERm/0loo0Uqu6ye9IfFzkQOk7ngxA+sJpGMdawGUfkFskxHCRhjxo2l02N9ZKXeYhneyvnYOs5o0tbshLoC7X/DecVAvPmbkypdReY9NUOVxFGA6rDN4LXwbCCsMQuVJRkyrguox3FpfIwBgkTh6Kz1inOSIJJouAtydmvckk9EO79ACyfI4wc3PgQPlllB6NwR/RWueVm62/saFdYEmEKg/JKrjTW27Nb4G3+0BYCO6F4pteLE4w0GX8zv0mRkFHd+0ANPc2AhvBVgfSiVYse3F36WKagEC47E+sN6vwOguWcLXrFfm7H7GexseMNQXJfo5BJURJ0lBrzT0hQLQ2Q6gH0nBxpWtRBVxmGfjRizoQ4o1f5vOfjaVxCwEXVIGAsDsRBQoNAlcaMyLngcHGzAa3poadQL4NOXOU4e5hqLnZMsk2SivyZvE4gTBB5J678FjnOs4yGaWOMHxMm+QY7INxT39srxhUN08DinVoA4nOoE4sizsuGX9u2px/FO8npiHnbJU1qp180EqF5Mm4/GgpmT9w==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(36840700001)(46966006)(4326008)(356005)(70586007)(6666004)(7636003)(82740400003)(70206006)(36860700001)(426003)(5660300002)(478600001)(186003)(8676002)(4744005)(336012)(2616005)(47076005)(82310400003)(83380400001)(8936002)(54906003)(36756003)(316002)(36906005)(26005)(2906002)(86362001)(110136005)(107886003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 19:21:37.0104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc92793-59fa-41a6-e77e-08d91a322806
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0255
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ->parent_module is the one that use in try_module_get. It should
also be the one the we use in module_put during vfio_platform_open().

Fixes: 32a2d71c4e808 ("vfio: platform: introduce vfio-platform-base module")

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 361e5b57e369..470fcf7dac56 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -291,7 +291,7 @@ static int vfio_platform_open(struct vfio_device *core_vdev)
 	vfio_platform_regions_cleanup(vdev);
 err_reg:
 	mutex_unlock(&driver_lock);
-	module_put(THIS_MODULE);
+	module_put(vdev->parent_module);
 	return ret;
 }
 
-- 
2.18.1

