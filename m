Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C833320C1
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCIIe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:34:58 -0500
Received: from mail-dm6nam12on2087.outbound.protection.outlook.com ([40.107.243.87]:26880
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230422AbhCIIep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:34:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQtKBiNv0K6lG2AR9549zkMw6ZkxX+jjHxdCXoqy/felk4NXbY3ByGgSJZrLA63UOxxa7VoSzH6gVd7oYQydl2o3peM96FjzK8uRYjCWD6r2jniFCrl7QGacNtil8M1fwPEimWdpmtbvhZb7xMPeDXM/AIfmTX28U0uZxaUAY6XZLpHjujhxZ0PB5IuHJVJOoYtVi+A68HRAkowSsF1PXP2FwVnIgmkyIEzFrTe6wB7yYDamH2usbYSZA7BTG44RcCG1My0LXqx7raRiqb6QJapHJGxoPUqMVkjNSP4/GpWVYWJd9B97jm/P7Mn6RnWQiyJsAOEWfpiFnu4Jpf15xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44gkFOCvrgF+8Q9lSNHWLK6fQadlxTEs2tqxzuwl8pU=;
 b=apJI9t5UwIKiEmBDBW1IbPGHcxpKfz8Y0jOuamgWpvfX7HIB2/GVapul5La/dbFVh+FKV/C2MTGYAXd9Y2EQr4Z0fdR+IMmeCryoIJz2FndiB/xmGJQ6yKPeUY/imNh7ass+aXOS3lB+Tarx16W586J/08T1DoYjYREm5WfGvC+o9qAzpEalVnR2YAVtblCZ4Xrst26GD6lsgkT8HKZJ3wdaEVSZ6PkhXo+RDNoI6LTcC5kzlVFeAuMzfF/aqxE4CPU7wj7Kouy3fliRfK/ZRL+JggAYb4NrHIIrjfJeHnLgsE8X6KIdKisKHUc7l9lhz/R1euBfV28Fg1sJLEFlow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44gkFOCvrgF+8Q9lSNHWLK6fQadlxTEs2tqxzuwl8pU=;
 b=SNXxpB8DaUglPyhQKoGQSzpc6NwpzFVD5pcz5qPzbxuWLZulD3od5oQW34FxzBIGPuTXUvaHQaEw7om1+UQhwMx1KmoroRTAv4dy/oZibwyh05Pl+fqdgeYk1Or7bKkTkTm9dmCgm4MXLeZbfYotEPDn9UR0Q6Qmo+R51Kg79eEhIeYU+AN7aYOoQOqO0JtO9GKOEZO6+fxkhOcGYVEACfO96WXORYsC6Fp26meAxBVTdcZVaF1zeIBImtuAIhbhSEhT8qxiZFhoFc4s51CMkbDO+gLMrJ8vhBM/t0Rd1pSyPi4Ary2ByncHWqdY1zFFQMjYKmLCDYf1ri/UVMJW0g==
Received: from BN6PR12CA0043.namprd12.prod.outlook.com (2603:10b6:405:70::29)
 by MWHPR12MB1632.namprd12.prod.outlook.com (2603:10b6:301:10::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 08:34:41 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::61) by BN6PR12CA0043.outlook.office365.com
 (2603:10b6:405:70::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:34:40 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:34:39 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:33 +0000
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
Subject: [PATCH 6/9] vfio-pci-core: export vfio_pci_register_dev_region function
Date:   Tue, 9 Mar 2021 08:33:54 +0000
Message-ID: <20210309083357.65467-7-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309083357.65467-1-mgurtovoy@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 743bc449-4e82-4f16-6000-08d8e2d62e75
X-MS-TrafficTypeDiagnostic: MWHPR12MB1632:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1632669CBD163E158D314E25DE929@MWHPR12MB1632.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kr1EHgJkl4iEHVvHbGHzGEeu95ZGpOUYTd9+BfNZvuZhYoTV5cd5fdmgcy3iPNPhmhvuFTe5e/97UH4WLhm/LZKIggYCDipsMr0gMyjkbEF1XSjbyp8lkkJ/sYqdi0vV+5HgkEhEpfHD3NahuaGngPh+TftAg7pG+cNO5x+9ySre3CJy8aqjFBursTb+L1E9FjZsU6mjfNu8k0OluRBUtGbCOwpoOvV3hx7NEpjJRnMm1QOHtIFu1bCLCVc/U0BM/k1hYNXDU7osJHn+EFFgm4QC9nansKe68rJnE/Mw1HhmhNMLenYhmUg6zC+POhVNgMxnZ6YWnVhGJ5T2RxF+ciOsjF7xrwUwAtTs3rP/Z5JyEQoMmgEOlpYPCdY5vayLLPHhI4aQFsbfVnsniUodQMy8ZWZeXYt8Z/HqVjwZRe6piHzQUcujD5qgP1ooHB5zhtwfQ601Xq/KITc6Q9iJ5+fCqJsf3nWTMTLYtrjvKHTTLFI9iMWZsVYlCXWodGb+FVJ9lsh6od1Yr6xUaBVdK2dcxTdil5O0TjPeDo2V65CHY6GwOZl2XRCC8GiWe+dwtlYFzHu7ju+N9tcjkS76pXFJ4LvxgapeViGT7a8kQYUuDSI0bbong1T8ASwI/5qrwMFSg9XJRS0Aw5b8I7AjHw3V1Edaf3ESTq+bbCUzgAD3R7egDNa7QNxDLkw+JnNF
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(36840700001)(46966006)(426003)(186003)(5660300002)(336012)(1076003)(8936002)(36756003)(47076005)(86362001)(83380400001)(2616005)(6666004)(26005)(107886003)(4326008)(70206006)(356005)(82310400003)(8676002)(2906002)(478600001)(54906003)(110136005)(36860700001)(82740400003)(316002)(7636003)(34020700004)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:34:40.1719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 743bc449-4e82-4f16-6000-08d8e2d62e75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1632
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function will be used to allow vendor drivers to register regions
to be used and accessed by the core subsystem driver. This way, the core
will use the region ops that are vendor specific and managed by the
vendor vfio-pci driver.

Next step that can be made is to move the logic of igd and nvlink2 to a
dedicated module instead of managing their vendor specific extensions in
the core driver.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 1 +
 drivers/vfio/pci/vfio_pci_core.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7b6be1e4646f..ba5dd4321487 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -711,6 +711,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
 struct vfio_devices {
 	struct vfio_device **devices;
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 46eb3443125b..60b42df6c519 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -257,4 +257,9 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
 
 extern const struct pci_error_handlers vfio_pci_core_err_handlers;
 
+int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
+		unsigned int type, unsigned int subtype,
+		const struct vfio_pci_regops *ops,
+		size_t size, u32 flags, void *data);
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.25.4

