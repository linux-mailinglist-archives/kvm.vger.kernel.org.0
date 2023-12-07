Return-Path: <kvm+bounces-3844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8610A808583
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 11:30:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41F87284245
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 10:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ACAC37D15;
	Thu,  7 Dec 2023 10:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a1MEMDOt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E073813D
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 02:29:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGETPkUneHXOKkgkoRWcSR47VdxP7Plbf3A+6AEsaB5EIumxmR6wCdgd1ynqigZQ+wY9VJkzWAq1tM0HicOmVkIBrImhTSGA+VPjyBwS8ivXfOeIXcC8S34UbUY/OGr6pCnnZxVHp1m9qWUaaUB5xW+cCHO4GJb0UOo2z5n/M9UaqUM/mEcYwF6DF4hNS5+qZzJmZyATMiFjv1P3zGTumViaSUHhAqtZR2HGzxDI6cQS9hgIFMUz6Tfxf9U4vPknf0F72vdIfzbFXXmOY3fWR2KVY1pXZ5jFoky83OJZezTKBfUO3Xu9CCktvSXJp37yc4es0mewabMTcB0sf8Wb3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7oLb85HQw7P1bY7AAnoMmPgBK7IvcTVUkhPkmtSGN6k=;
 b=cQTguN+Sb7a0nfht61EBYVJwvHgsUPmgzDmlIAcVkCkY7RTRPvlPVSI3+YzFPkH+KEfO3I+0EP5fF/VB9UEpKxUoQNZMnnB8Zr/ofs/HbxREn99+NjJwa9yilv78PtAfojVeAnxqwWuM6V4ow+khBpbdnyRNhH+eF97y+IS++MiRASLiKiN6leoNjSIs8x2ajLHnvFiROYcTQoENJOKE1IVnOuttvVgZEzMc11NYoBmtkApsJJRpPquVdc5SoJAqHjSq7fY+2dkf98W1aKkFqyKhIPK3EWl+/EQNSEtiwGyYzWlha1tYf9exLPGzOrvzJ9nt7gNYD4L2zs2mkyHhFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7oLb85HQw7P1bY7AAnoMmPgBK7IvcTVUkhPkmtSGN6k=;
 b=a1MEMDOtLYd0us8Q9n+1F2odpxnc1qg4xE7rkhQgL8KWoSZO6G0AGM5EI/491fVlzSMxbGuNkNwFf1jVdfAHJ0p7DfEqczGFqTczwYDMqdCfzqiHX2EX5ZqXdQS+1N4vF+wmDrqFaMcjJsyt6cyikgTMo9p9HnFCPRxvuGAYZOcvuIFKHagWa1y/fqo6N3cU3VyV/zrlx06bwyU+5UZYbWEXIK2cykkbX005atroCMiRR7V7TQIwZZMzq/eSuduW4L41wDGaq1gy4cgB3BvOXJKhCUFjcb/SCWzoCjalKnbuq7sXZQZmkZ+KAMQLHTZCEDKgqMKygeJN1iwxJ/QACg==
Received: from DS7PR07CA0013.namprd07.prod.outlook.com (2603:10b6:5:3af::19)
 by PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Thu, 7 Dec
 2023 10:29:36 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:3af:cafe::80) by DS7PR07CA0013.outlook.office365.com
 (2603:10b6:5:3af::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25 via Frontend
 Transport; Thu, 7 Dec 2023 10:29:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Thu, 7 Dec 2023 10:29:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 02:29:27 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 02:29:27 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 7 Dec
 2023 02:29:23 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V7 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Date: Thu, 7 Dec 2023 12:28:18 +0200
Message-ID: <20231207102820.74820-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231207102820.74820-1-yishaih@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|PH7PR12MB5757:EE_
X-MS-Office365-Filtering-Correlation-Id: c7d14a23-bd4b-4eb3-e357-08dbf70f6903
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VEfDbdeb3nheevALM/wAskc+8ukYImN/NKeI4YdO1OggU8hf/+SP7TwDn3aJdUlFIbFgSJ36kwBsJ7Xi7RQQ6Us/siaA0JyLbHyO8UfZG3BNPRPsFsPyPT17ExsjhV7asmSFqiOBdL6KDr58gZlxHfqEXPB/5MEs2giDDDfIvIEx4IvSvukkPCMaPFroIrz9lKO/QAEaI/fKaoSxEBmSIeiWhZySlhmAMmZgm6gAQim0xzI7DjpXxLTN+I58OI+oypBM4DoWV+36FGk2oA8AXw2tvvRdy0TiO7bQtZeZ88PYQjJ1V/gMW3cOrBlgYTlyc2SHHIoSDTUKzIWg2ugI1Yo4b3scmWoD9D4u32SyHCc3QlWj0FHa5ZtuUabfHkEho36iuFgzaQ2y0CBUIL5Gxmy1cJSWjqQq/OwxYvVgWRfkjbxqdgpmVYXiX8JXwzRruy4qW3DQ6b6/CGoy77dEdNbgmu2f9+KCd/P8eJNTWePF/2nlGjOOnxz+L/PVk++szY9A1/k6TtpSMvqH/B94tBLnnfozej4rjAaQs3DBKcFt0EwD+JIbn0OD5Fm+hWX7UDtbd9YBB6PyoCi68EL25Dd4HyMrq0llNx3ed2CzY3pYceyIZVvRfqiacDUOHiO+/5qjECfBUophRuulKK5XDQeJsg3KcLQvIEb1H1lm4LSoaJXx3m0okEolq//opOtgY4pXadnkoZqm1J9uVMe0B5hJzrT4yx5IcvNhpIY6uVYHtbk7rBtdIxYOHajU98VT+a+ZVki1mshcKPYeUxczkA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(186009)(82310400011)(1800799012)(451199024)(64100799003)(40470700004)(36840700001)(46966006)(41300700001)(36756003)(40460700003)(5660300002)(86362001)(2906002)(7636003)(356005)(47076005)(36860700001)(40480700001)(7696005)(26005)(426003)(336012)(107886003)(478600001)(1076003)(82740400003)(2616005)(6666004)(83380400001)(6636002)(8676002)(8936002)(316002)(54906003)(70586007)(110136005)(4326008)(70206006)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 10:29:36.0083
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d14a23-bd4b-4eb3-e357-08dbf70f6903
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5757

Expose vfio_pci_core_setup_barmap() to be used by drivers.

This will let drivers to mmap a BAR and re-use it from both vfio and the
driver when it's applicable.

This API will be used in the next patches by the vfio/virtio coming
driver.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 7 ++++---
 include/linux/vfio_pci_core.h    | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e27de61ac9fe..a9887fd6de46 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -200,7 +200,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -223,6 +223,7 @@ static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_setup_barmap);
 
 ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
@@ -262,7 +263,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		}
 		x_end = end;
 	} else {
-		int ret = vfio_pci_setup_barmap(vdev, bar);
+		int ret = vfio_pci_core_setup_barmap(vdev, bar);
 		if (ret) {
 			done = ret;
 			goto out;
@@ -438,7 +439,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 		return -EINVAL;
 #endif
 
-	ret = vfio_pci_setup_barmap(vdev, bar);
+	ret = vfio_pci_core_setup_barmap(vdev, bar);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..67ac58e20e1d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -127,6 +127,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
-- 
2.27.0


