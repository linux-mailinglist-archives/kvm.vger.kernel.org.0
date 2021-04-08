Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EB7357DD1
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 10:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhDHILh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 04:11:37 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:19041
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229777AbhDHILc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 04:11:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwmT4da2xyNwK4QyMk8Q4D/ERNBqTOurQrygjCnb9Zuxg3swEVrqjjkI8vdeIBQLvx+uXjGqQkQvi5yrmmFcppdQRVVyMRj/Ye0yI1wCfyeo5LhXaqh6uO7J32hx+UYizK/piA0m20peD1xcnsKNIEByCOGZhSKrh2fJ8JnjTLY6UPl8McHeQOZ1XzH1wHVsD1d9ZGgC0fNUMAHlG6036/dySUbSZA+oJ96UYEfL/hzVHtV8F0R9Uz4XSFCZ7UcDfUtmnYmLLN16BMnV+FlL8kuCQJkvCaKW8KAE2x1xq8/BORSgzK7lMixnzS8Vj472ZQguQb7G2E5yumk80HsC8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amHnrLvTvWjsynprryF/7TQPxzXdsSUM7yMqWphDQTs=;
 b=oaVnFs3v4LxivaM46TGDE7789cuo2OVUSOYBxBdFu63kvyVnOHRhuabgZ6k691AYTVzL0S8KGw4qLXLS6EBRLZ8undo7K4Vg0VxjQB0wdIKMRtl5DDpabH/8rIcpNphFN2CPDuzv90qFhbr1u47mMxyXN9+XXXDG8R8ehxSrvDoxF7gxmSqKJCi4FPdhjc0zQi6XVblFlLCpznxdh+kmMB5aV53CZZYhmLuz17lKN6p9yGIaC48Z6KgPw86bsYKLZS4PVdJE9In57eMewvmqOsl4t+s9TRpk5PUC/P5VanwZU74yi5KHDG/dbCxOhMDE2odIOnjQVPrlEfYnDrCR9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amHnrLvTvWjsynprryF/7TQPxzXdsSUM7yMqWphDQTs=;
 b=LJgrIRwCuoGc254Spv2Nw0PWsri7ogNr9ezc/s7G5BBnLohA3qNA27jz3MDvG+ytz/+Mh29hp4Eqf1ft0tiVNdaQkQ/PdvMQYdkQHoX0sJQr7AhtMwpBa8F8Tjp5Wd+zRfK2hvJlESGxYEQHCAgAS7mAmDU6VQQDcW2b0ueAuDCIolpBTdttzPaqGfNL21mx3rFoVl4tPC862cbKH4HB6Y5ogWGVqMxHNLQv3EGXaIVQ0Tgs50n1i6Pjeea970qTdT9ZnnSkV/gCBWB0MQRm/FS26MalJ4ltIiOBj1KZW/tpHVNzNV0uoFqaHb2rKrDhq7TefBww5pHJe6BXzQQu/g==
Received: from BN9PR12CA0008.namprd12.prod.outlook.com (2603:10b6:408:10c::27)
 by DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 8 Apr
 2021 08:11:19 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c::4) by BN9PR12CA0008.outlook.office365.com
 (2603:10b6:408:10c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Thu, 8 Apr 2021 08:11:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 08:11:18 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 01:11:17 -0700
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 01:11:15 -0700
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>, <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v2 3/3] virtio_pci: add module param for reset_timeout
Date:   Thu, 8 Apr 2021 08:11:09 +0000
Message-ID: <20210408081109.56537-3-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210408081109.56537-1-mgurtovoy@nvidia.com>
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80163d91-117a-4163-1f04-08d8fa65e31e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3834:
X-Microsoft-Antispam-PRVS: <DM6PR12MB383479BC1BEFEF25A75E625EDE749@DM6PR12MB3834.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4IdHBQ2G4TXktjDCB9fs5nvMmrsHpiuk2ADMPE2Dzw1wB17E//HErMSINuAIKEJhSB7eZo+RU8f9kTB6Ka9PgCUMLtAv66BhQr5uSFy6cU1ecpf2JLoc9GLnl1d12qtDROoBxD2+rw2gKp6SQHJ25LDff64Dwc7subTe24iHW4HdfGXCmjILSZXgoLom+g6mmyhJGstR7bRdUhOtTSEpNYRdAXOPbGrcZk8OHPYWeFkDvrqMjP1p7EvXORfiscjbsyqdfitZMxiVLXl8bq7YcrT1z8smr6N0dtJ8FyS1ExnsQuptgiU5hNHeV0Uyv8L+T9YacU7QJtS3jCkwhKpY2p8LtqP3whJZ4C/7erUaywRVrF9RPyBjIbnMXSdjFpMpMnIBxlM+qfGcVMrq31BIUEnYHuA72mwKLJ0SUvWh5l0TppEkjbmrhcI2D+BpUJpzFZlldaaf9YlZflKkc7LWHDr6TL+QEfOb4gN5jOi8jkNCo3YZLr7jJ43sJe0Gnfrh5PJ9k3jeHqeRLV2wtENZGiEGKY1ePOX1i7ukfeasd9vCvzyuKvB1vrHS+Hkk87igymWH29avIOPXnRr5AMcc1YmcAAkvA7OTPf650N1br74TsR0aw8TYFPy/wLOLDiwWt5iBZzueODcUkT5fg/JxLj57elJ8+/uDW5B2JMGoaak=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(46966006)(7636003)(86362001)(107886003)(82310400003)(8676002)(316002)(356005)(8936002)(336012)(426003)(36860700001)(82740400003)(5660300002)(186003)(70206006)(70586007)(2906002)(26005)(47076005)(6666004)(54906003)(2616005)(83380400001)(110136005)(4326008)(36756003)(1076003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 08:11:18.0119
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80163d91-117a-4163-1f04-08d8fa65e31e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3834
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable the user to set the time for waiting for successful reset by the
virtio controller. Set the default to 180 seconds.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/virtio/virtio_pci_common.c | 5 +++++
 drivers/virtio/virtio_pci_common.h | 2 ++
 drivers/virtio/virtio_pci_modern.c | 3 ++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 222d630c41fc..3a4c57839ed8 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -24,6 +24,11 @@ MODULE_PARM_DESC(force_legacy,
 		 "Force legacy mode for transitional virtio 1 devices");
 #endif
 
+unsigned int reset_timeout = 180;
+module_param_named(reset_timeout, reset_timeout, uint, 0644);
+MODULE_PARM_DESC(reset_timeout,
+		 "timeout in seconds for reset virtio device operation");
+
 /* wait for pending irq handlers */
 void vp_synchronize_vectors(struct virtio_device *vdev)
 {
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index beec047a8f8d..4760cdf74961 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -29,6 +29,8 @@
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 
+extern unsigned int reset_timeout;
+
 struct virtio_pci_vq_info {
 	/* the actual virtqueue */
 	struct virtqueue *vq;
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index dcee616e8d21..811fc1719d8c 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -162,7 +162,8 @@ static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
-	unsigned long timeout = jiffies + msecs_to_jiffies(180000);
+	unsigned long timeout = jiffies +
+		msecs_to_jiffies(reset_timeout * 1000);
 
 	/* 0 status means a reset. */
 	vp_modern_set_status(mdev, 0);
-- 
2.25.4

