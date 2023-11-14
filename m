Return-Path: <kvm+bounces-1701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9FDA7EB81E
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 22:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54C451F25CAB
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 21:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E633C27;
	Tue, 14 Nov 2023 21:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ctg8utJ+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C901F2FC33
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 21:01:57 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4C7C9;
	Tue, 14 Nov 2023 13:01:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8Mn64DiPoAN9YDJABODl895zrvnA4GDTWQPTFMT57+iI4N2Nzc81rIjpzOft41APlawY9lk2y7a1k9TsfI0IaqdWscwITwE8Ddwm8avCmK3lesC4cx20k4KOv2PE+Sdd5G9/PSR/5jG6QzriCX3qFSDSgfbzJjDqyRTKbS39JKqtmzdV3IzQPFIIQGNypVSAQ96y5oLcfkpvu/tr0+/SA6dSGTbsBUld/VDovQHWBb2j+Ee6YesIf2EN5YZeJz01CXVkeyP0KoyVrByE8+WpAcabMQONGiSkh7OwAsefB/L2eRKCFMmwZAsKX9syR2MrZzCLtfSIgwgvOWDd2SGZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZTcjmSwgQqbOWrhuqxVWrni0Hc9E7K7wBX1ZhkwQc8s=;
 b=LRJIQt4AzDAG4EzicWtVySspwdfsmg9e4ccEZ/8B8jBK47OW6lIBSe+Ah2BUDfztvqwFvuZAJFnxCJDJ5aNx2O23CSCkUfFFScwUTbxBP51AHxqYB3bOwrC0zyyNHDPmy/qa0HMRNbsspbp5ep5JJDJ6A0Fpg8gUBrPwHlBqeeYJSGOin8FrPkrG4WIObTx/E02F/PN7NO5Jx1F7mT8vK6FstL3I3iEvoI6f2t6lXC//nrV4Lthq9d/qBFCzjmVYKvA3LBkPQhimPYBVXEfJAb2ZZR1FQwqcJ58ArdfL8X+FXxestX39l8ut9lAiZ3bfK7jqEVsOLgnNIdCyuR3sZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTcjmSwgQqbOWrhuqxVWrni0Hc9E7K7wBX1ZhkwQc8s=;
 b=ctg8utJ+HJ1s+E8Zgs8VCvrJMnpVbkyngWEvmyzM0odIhO/AOAx9hf/zbUgUaf2m/sFtfpG5mk7RzRUYDfT/+1k1nF2GdixkuGjNZqMnN+/3Xe6EB8M7iE+1bmZy6xrnwAMZZSzz156MbSIawTkHgGxcvTfQ1ExXkUWeoNot+LE=
Received: from BL1PR13CA0300.namprd13.prod.outlook.com (2603:10b6:208:2bc::35)
 by BY5PR12MB5013.namprd12.prod.outlook.com (2603:10b6:a03:1dc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17; Tue, 14 Nov
 2023 21:01:52 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2bc:cafe::9e) by BL1PR13CA0300.outlook.office365.com
 (2603:10b6:208:2bc::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17 via Frontend
 Transport; Tue, 14 Nov 2023 21:01:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.13 via Frontend Transport; Tue, 14 Nov 2023 21:01:51 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Tue, 14 Nov
 2023 15:01:49 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 3/5] pds-vfio-pci: Pass region info to relevant functions
Date: Tue, 14 Nov 2023 13:01:27 -0800
Message-ID: <20231114210129.34318-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231114210129.34318-1-brett.creeley@amd.com>
References: <20231114210129.34318-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|BY5PR12MB5013:EE_
X-MS-Office365-Filtering-Correlation-Id: aaef09d7-b39b-48e1-c082-08dbe554ece0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IbG/E8MkdhJZrQrnBf9dJC/BppPf7c061F6LMGOL9OIC2/DfTSKc6JwNr2bn50q8QXQppJuxXs0OGUU5LLJIMh/Go6Q/7sidZAnAFCz+FnVHepk4gUhsaY4RUmIqzh1n38sKU9TYMn8ZmzjMcTAhuSWabfamd+DI/0/QG3Ik2R0zGeQtnfmWYe1JQhExbhV2Gn8fEII3/NHafO3w4sKZRHvky38FFWjhqtDPg8aQbbKzrGPT0sjTGO4X60/SaiDhtTml53mDetaCE+bhx0SirDDUlakQgJwXI77PRpbTGW0lSa4oBmA/rIKmbJ5Ude1Jo6JV2PJji+6JHjd9/BZsAd2iXeJ7vEWsEjKsKMffcGS1ylQ8E6wZsqFiEsdCpNXagPSvfB+sa0+0KFQJfr8yT8Mq75R4aG2QxPEDUxsMvkQkPWCcvO05a7H6ymd/Wr8RZ3PkgR8GmqSxf9R9cNcFgjVMDVoOUZp1r3z37Ct6Qr05U2E2EVGmQhKxfweLbzDKtCgoGfPr41gmRcoGxfu2l1ArgKvsWOm75L0ZhPVhiOFJa+A8iNm7NO4yTNeV6M3D+KgQlh2Qhly/H6JramYeYoOu0BfHbiJgOg+KINx91Fx8k+Q6aGhHwf5xpqHVMZAfWQnnFJAe9KgWKfmEsEqE4CBU52fbRuJWzGGDQVRrWkqFOnhNH96hvSZwMBfw6lM6CX7TWrQqHKHpmG7efnJkb03Eznz12k0xpZJT7600dbXUGIMdHNvpsT8hPPTLmbpWeFK5Gj3Ryi80HJUD2H+sBg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(186009)(1800799009)(82310400011)(451199024)(64100799003)(40470700004)(46966006)(36840700001)(8936002)(8676002)(40460700003)(44832011)(36756003)(4326008)(6666004)(82740400003)(47076005)(81166007)(110136005)(83380400001)(356005)(70586007)(70206006)(316002)(54906003)(36860700001)(40480700001)(478600001)(1076003)(16526019)(26005)(5660300002)(426003)(2616005)(336012)(41300700001)(2906002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 21:01:51.4879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aaef09d7-b39b-48e1-c082-08dbe554ece0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5013

A later patch in the series implements multi-region
support. That will require specific regions to be
passed to relevant functions. Prepare for that change
by passing the region structure to relevant functions.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/dirty.c | 74 ++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index bee1bfdcbda9..50df526a5ccc 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -100,35 +100,35 @@ static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
 }
 
 static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
-				      struct pds_vfio_dirty *dirty)
+				      struct pds_vfio_region *region)
 {
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
 
-	dma_unmap_single(pdsc_dev, dirty->region.sgl_addr,
-			 dirty->region.num_sge * sizeof(struct pds_lm_sg_elem),
+	dma_unmap_single(pdsc_dev, region->sgl_addr,
+			 region->num_sge * sizeof(struct pds_lm_sg_elem),
 			 DMA_BIDIRECTIONAL);
-	kfree(dirty->region.sgl);
+	kfree(region->sgl);
 
-	dirty->region.num_sge = 0;
-	dirty->region.sgl = NULL;
-	dirty->region.sgl_addr = 0;
+	region->num_sge = 0;
+	region->sgl = NULL;
+	region->sgl_addr = 0;
 }
 
 static void pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio)
 {
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	struct pds_vfio_region *region = &pds_vfio->dirty.region;
 
-	if (dirty->region.sgl)
-		__pds_vfio_dirty_free_sgl(pds_vfio, dirty);
+	if (region->sgl)
+		__pds_vfio_dirty_free_sgl(pds_vfio, region);
 }
 
 static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
+				    struct pds_vfio_region *region,
 				    u32 page_count)
 {
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
 	struct pds_lm_sg_elem *sgl;
 	dma_addr_t sgl_addr;
 	size_t sgl_size;
@@ -147,9 +147,9 @@ static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
 		return -EIO;
 	}
 
-	dirty->region.sgl = sgl;
-	dirty->region.num_sge = max_sge;
-	dirty->region.sgl_addr = sgl_addr;
+	region->sgl = sgl;
+	region->num_sge = max_sge;
+	region->sgl_addr = sgl_addr;
 
 	return 0;
 }
@@ -260,7 +260,7 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 		goto out_free_region_info;
 	}
 
-	err = pds_vfio_dirty_alloc_sgl(pds_vfio, page_count);
+	err = pds_vfio_dirty_alloc_sgl(pds_vfio, &dirty->region, page_count);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
 			ERR_PTR(err));
@@ -300,11 +300,11 @@ void pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio, bool send_cmd)
 }
 
 static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
+				  struct pds_vfio_region *region,
 				  struct pds_vfio_bmp_info *bmp_info,
 				  u32 offset, u32 bmp_bytes, bool read_seq)
 {
 	const char *bmp_type_str = read_seq ? "read_seq" : "write_ack";
-	struct pds_vfio_region *region = &pds_vfio->dirty.region;
 	u8 dma_dir = read_seq ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
@@ -383,36 +383,36 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 }
 
 static int pds_vfio_dirty_write_ack(struct pds_vfio_pci_device *pds_vfio,
+				   struct pds_vfio_region *region,
 				    u32 offset, u32 len)
 {
-	struct pds_vfio_region *region = &pds_vfio->dirty.region;
 
-	return pds_vfio_dirty_seq_ack(pds_vfio, &region->host_ack,
+	return pds_vfio_dirty_seq_ack(pds_vfio, region, &region->host_ack,
 				      offset, len, WRITE_ACK);
 }
 
 static int pds_vfio_dirty_read_seq(struct pds_vfio_pci_device *pds_vfio,
+				   struct pds_vfio_region *region,
 				   u32 offset, u32 len)
 {
-	struct pds_vfio_region *region = &pds_vfio->dirty.region;
-
-	return pds_vfio_dirty_seq_ack(pds_vfio, &region->host_seq,
+	return pds_vfio_dirty_seq_ack(pds_vfio, region, &region->host_seq,
 				      offset, len, READ_SEQ);
 }
 
 static int pds_vfio_dirty_process_bitmaps(struct pds_vfio_pci_device *pds_vfio,
+					  struct pds_vfio_region *region,
 					  struct iova_bitmap *dirty_bitmap,
 					  u32 bmp_offset, u32 len_bytes)
 {
-	u64 page_size = pds_vfio->dirty.region.page_size;
-	u64 region_start = pds_vfio->dirty.region.start;
+	u64 page_size = region->page_size;
+	u64 region_start = region->start;
 	u32 bmp_offset_bit;
 	__le64 *seq, *ack;
 	int dword_count;
 
 	dword_count = len_bytes / sizeof(u64);
-	seq = (__le64 *)((u64)pds_vfio->dirty.region.host_seq.bmp + bmp_offset);
-	ack = (__le64 *)((u64)pds_vfio->dirty.region.host_ack.bmp + bmp_offset);
+	seq = (__le64 *)((u64)region->host_seq.bmp + bmp_offset);
+	ack = (__le64 *)((u64)region->host_ack.bmp + bmp_offset);
 	bmp_offset_bit = bmp_offset * 8;
 
 	for (int i = 0; i < dword_count; i++) {
@@ -441,6 +441,7 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 {
 	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
 	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	struct pds_vfio_region *region = &dirty->region;
 	u64 bmp_offset, bmp_bytes;
 	u64 bitmap_size, pages;
 	int err;
@@ -453,25 +454,26 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	pages = DIV_ROUND_UP(length, pds_vfio->dirty.region.page_size);
+	pages = DIV_ROUND_UP(length, region->page_size);
 	bitmap_size =
 		round_up(pages, sizeof(u64) * BITS_PER_BYTE) / BITS_PER_BYTE;
 
 	dev_dbg(dev,
 		"vf%u: iova 0x%lx length %lu page_size %llu pages %llu bitmap_size %llu\n",
-		pds_vfio->vf_id, iova, length, pds_vfio->dirty.region.page_size,
+		pds_vfio->vf_id, iova, length, region->page_size,
 		pages, bitmap_size);
 
-	if (!length || ((dirty->region.start + iova + length) >
-			(dirty->region.start + dirty->region.size))) {
+	if (!length || ((region->start + iova + length) >
+			(region->start + region->size))) {
 		dev_err(dev, "Invalid iova 0x%lx and/or length 0x%lx to sync\n",
 			iova, length);
 		return -EINVAL;
 	}
 
 	/* bitmap is modified in 64 bit chunks */
-	bmp_bytes = ALIGN(DIV_ROUND_UP(length / dirty->region.page_size,
-				       sizeof(u64)), sizeof(u64));
+	bmp_bytes = ALIGN(DIV_ROUND_UP(length / region->page_size,
+				       sizeof(u64)),
+			  sizeof(u64));
 	if (bmp_bytes != bitmap_size) {
 		dev_err(dev,
 			"Calculated bitmap bytes %llu not equal to bitmap size %llu\n",
@@ -479,22 +481,22 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	bmp_offset = DIV_ROUND_UP(iova / dirty->region.page_size, sizeof(u64));
+	bmp_offset = DIV_ROUND_UP(iova / region->page_size, sizeof(u64));
 
 	dev_dbg(dev,
 		"Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu bmp_bytes %llu\n",
 		iova, length, bmp_offset, bmp_bytes);
 
-	err = pds_vfio_dirty_read_seq(pds_vfio, bmp_offset, bmp_bytes);
+	err = pds_vfio_dirty_read_seq(pds_vfio, region, bmp_offset, bmp_bytes);
 	if (err)
 		return err;
 
-	err = pds_vfio_dirty_process_bitmaps(pds_vfio, dirty_bitmap, bmp_offset,
-					     bmp_bytes);
+	err = pds_vfio_dirty_process_bitmaps(pds_vfio, region, dirty_bitmap,
+					     bmp_offset, bmp_bytes);
 	if (err)
 		return err;
 
-	err = pds_vfio_dirty_write_ack(pds_vfio, bmp_offset, bmp_bytes);
+	err = pds_vfio_dirty_write_ack(pds_vfio, region, bmp_offset, bmp_bytes);
 	if (err)
 		return err;
 
-- 
2.17.1


