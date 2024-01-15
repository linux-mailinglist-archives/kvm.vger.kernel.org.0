Return-Path: <kvm+bounces-6284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A54A782E21C
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 22:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30668B21FC8
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 21:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5954C1B27A;
	Mon, 15 Jan 2024 21:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tixj1iHq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2041.outbound.protection.outlook.com [40.107.101.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CD21865A;
	Mon, 15 Jan 2024 21:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRM9z88406658r/xCt/tV/g0r5bNwSjYte3+35cz65y2TDDf38+FZCIhxHyelaxU++GaqCGFixyzp9Y21V0ajKqzj7FnYD7m6X4icxKzwpS4/0mwx+/NWYrwIJTEJ1obLxWR22KHi6OfSukzPSFqw46Z5TQpS9VdiwRHg4kfnE92S1hrqhJAFw2usT6I7BbSNBz4c8CUcZ/oG9aL++/hEwhpUWYdYsCMLRjoh+NupxiMYacqT6dJpNHhtoLFXb41ftAsK6f8n97uDjCjrcRwcbo1cq/oHQDPUHn3+BHt3urDE144/OrR42F+Br8cvihrg7OxHXAuM/OXYFJhaaK3Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8n/tpp8z39YEtvBWstqd+B0PJaW2S8lkCAQJ4R6vMAc=;
 b=LmbXIwoKz4JylXEWmON2wO3f0BWyZuc3bBPU4jV/fFrCftlc1rQmDuW8BDkXOOLiccsjXPEsoALEbx5zrhX31vnugy7bUcixnwWz4sSQfqmHFYNO54YTbreCfl53mosNNaEOzIAFCm/1e8jHif7oUxAnL7VrM82r/lG1ZoPrSVa4tpR3D6vyv6CNTevR1rkRXo0MQzeB9IiLqZcyvl6zhvBthnnsqLWJcRW1c3hgHlDO5+B2doclLF53J7njA6RH5dPpfPQ3sjGqXYmYgWTDdZNEEZ44OQN4VjXN/HliQyrNBZyGWpr+24XAgpTIj7NPcxqg03w0Y/t7wARS0Elp/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8n/tpp8z39YEtvBWstqd+B0PJaW2S8lkCAQJ4R6vMAc=;
 b=tixj1iHqSvvdlxvEaR2MoeJ4qIyeaIw0nboFD+xdkMZfYha3cAIq+upzQx2fH/b9y/itJuIIGWrK8oCyEz133valbqzHuLdaymQDpuvUwHjzz4knLBsvzVNBvXA3v9SfB90e02SrcNrjHvuAWopTcW0Lj/fbVqQqHx7c0Im1/PMV3ftPRFmopZSUsVBGP2sWIbYEiwxxSQ1vUSLMxSeyporno+niZJsazKy5rD/SZr6dgD4NDBwCfhLvpiLhImRhwV2SoeUV2gLc5C21/xFWZCp08qdEArsj9dXStd5Ar41nWkVCkETSTy5kb+DF0LUtt+6/7S3jy8+hQCEwxtcSVQ==
Received: from SA1PR05CA0011.namprd05.prod.outlook.com (2603:10b6:806:2d2::13)
 by SJ2PR12MB9163.namprd12.prod.outlook.com (2603:10b6:a03:559::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23; Mon, 15 Jan
 2024 21:15:35 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:806:2d2:cafe::25) by SA1PR05CA0011.outlook.office365.com
 (2603:10b6:806:2d2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.17 via Frontend
 Transport; Mon, 15 Jan 2024 21:15:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.16 via Frontend Transport; Mon, 15 Jan 2024 21:15:35 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 15 Jan
 2024 13:15:18 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 15 Jan
 2024 13:15:17 -0800
Received: from localhost.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 15 Jan 2024 13:15:17 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <eric.auger@redhat.com>, <brett.creeley@amd.com>,
	<horms@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v16 1/3] vfio/pci: rename and export do_io_rw()
Date: Mon, 15 Jan 2024 21:15:14 +0000
Message-ID: <20240115211516.635852-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240115211516.635852-1-ankita@nvidia.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|SJ2PR12MB9163:EE_
X-MS-Office365-Filtering-Correlation-Id: d96586ab-95a1-48c7-3d90-08dc160f1d51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	prZ5K56ESu1/6Aau1pV5qRQyqNxdQXaNvrHoSo8f/XpjkCMpEVBOmnOjDdvsXFTKIViM3qe/bQeu+PQLsi7TfY8yD6G56sxvbeDGC2Pnd85XQvL85mSz2/BzEvFAS+3pmcgivv7ORPwReUhCM0HhpTUiUPt6lbvngzekZ6Dzb/yKGISqLJ5XFImeh2fVe319ZhMZgyWq6GvpUxJifFJcOoHgRlKvxNabeGWj4MVYsrftSydIPiLPUnTbsKlDYgIBa/4TJbo5IPfzfIIsZtljhUyEt0cfirZ6yGe77RMDmlhOFNzcCula4IXYmBBH6CiLUTdcbynAWL1FXl9oo2Sn82wv9tZYc6AZM/UCcpKRpGwzOlx2gk9MMv6+5DU6+fD9/78Mjh2r0rEw0lDh+JAltCKbYgtdVvsMXXudIFVFtAeBHwwAcgHKnymO+Joo53pV4D2x6xDzyWnYML6dhI34kZyab0psz+PX11EeL9M6yOyN84vAMKbiKQ4rNdLIg8+4BtUU+gDSm9FzD3l6y/gdId+LX+AGwK7cwyTde5URoIzLyx5ch1v0IO2MjEyQRy6jlRWnIz5mJtg1Z6WE6CT3/o2a51IMlG2ctGBOZAVNwdCnGmNp6rC+aqixTpN5qddGXCxQBTXfJwqMbJbRtjKiTylZi8Jv/od2KSdD/WzJ+aFXvsMl6m7mU+F8iFoQ2qFOgEaMcNRp4Qs7eEK8Z8oPH+saeDmvOnJkTTBxMLMROOc=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(396003)(376002)(230922051799003)(451199024)(186009)(82310400011)(1800799012)(64100799003)(36840700001)(46966006)(40470700004)(8676002)(4326008)(110136005)(70206006)(8936002)(5660300002)(70586007)(86362001)(54906003)(316002)(2876002)(2906002)(36756003)(47076005)(36860700001)(478600001)(6666004)(82740400003)(2616005)(7636003)(356005)(7696005)(83380400001)(26005)(426003)(336012)(41300700001)(1076003)(40480700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2024 21:15:35.0701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d96586ab-95a1-48c7-3d90-08dc160f1d51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9163

From: Ankit Agrawal <ankita@nvidia.com>

do_io_rw() is used to read/write to the device MMIO. The grace hopper
VFIO PCI variant driver require this functionality to read/write to
its memory.

Rename this as vfio_pci_core functions and export as GPL.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 16 +++++++++-------
 include/linux/vfio_pci_core.h    |  5 ++++-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e27de61ac9fe..15484e27b26f 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -94,10 +94,10 @@ VFIO_IOREAD(32)
  * reads with -1.  This is intended for handling MSI-X vector tables and
  * leftover space for ROM BARs.
  */
-static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
-			void __iomem *io, char __user *buf,
-			loff_t off, size_t count, size_t x_start,
-			size_t x_end, bool iswrite)
+ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
+			       void __iomem *io, char __user *buf,
+			       loff_t off, size_t count, size_t x_start,
+			       size_t x_end, bool iswrite)
 {
 	ssize_t done = 0;
 	int ret;
@@ -199,6 +199,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 
 	return done;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_do_io_rw);
 
 static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
@@ -276,8 +277,8 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		x_end = vdev->msix_offset + vdev->msix_size;
 	}
 
-	done = do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
-			count, x_start, x_end, iswrite);
+	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
+				      count, x_start, x_end, iswrite);
 
 	if (done >= 0)
 		*ppos += done;
@@ -345,7 +346,8 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	 * probing, so we don't currently worry about access in relation
 	 * to the memory enable bit in the command register.
 	 */
-	done = do_io_rw(vdev, false, iomem, buf, off, count, 0, 0, iswrite);
+	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
+				      0, 0, iswrite);
 
 	vga_put(vdev->pdev, rsrc);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..d478e6f1be02 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -129,5 +129,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
-
+ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
+			       void __iomem *io, char __user *buf,
+			       loff_t off, size_t count, size_t x_start,
+			       size_t x_end, bool iswrite);
 #endif /* VFIO_PCI_CORE_H */
-- 
2.34.1


