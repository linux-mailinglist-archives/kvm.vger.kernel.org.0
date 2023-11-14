Return-Path: <kvm+bounces-1703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1907EB820
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 22:02:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DB401C20B25
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 21:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B283307F;
	Tue, 14 Nov 2023 21:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xs6fXE6V"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5716E33073
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 21:02:03 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2379F;
	Tue, 14 Nov 2023 13:02:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jf+PokhswOg8BJPBn7Mv9x/uWTGO2pVZDQn/2MBAL2ztra4DpHVzu0YpUKVWT2x7PITf1cDsHlvvxXUxo34RYbRzVnCztvv9ZOhvnANZMRZ/X8xS3uY0RwDUXRG0WMcGxIc1NUtIDJP2KW6Of+t969fU2UL6SkKzSW5uE1u8YXEQ04EldW+tH5gv7Pjruy12m46CSTw6PKLrSOKtCUlngIVJbbfhIJvGBLIbn+jVFMm6yZHEhLaiwu1+cE+gqtMlMBRMMtAa7QUJel9k9K3ZAAEXidJG9gg1fJbYDwacNIwe+XzacWLF7KZ/ywZhj3RYWQ+DicP3NjwmLl7lMFjwiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2t6K1YNg9q4RH8LBYZvgu0VAI1xleif3ksKZXGipFjw=;
 b=QJU65svYZ7fsClGeIE7wRsm/JGy+/YjqjF3dZSpatzH/r4b7cYdLCiHB89LZeebyXQY20IMdQtbD5Km879K5zO8r8/vYgfxQd05aamByagnf/PELGFZPRD8D7k2EljLW1OZBXC9OlaadEsdGnK/El+St99YNreegHryR0/0+ViSskEgj6pJMOk2cKtZ7kHcNZ2Ry2PQdktzEOaLlyRiIkwJHAZdvEXMy/sFNKld/6KdaIFJVdyMoVHLGLLLA47Zuaxn2FaxVGnv96qQeP736yTSMwl5dNZkgIinzfUsu7TV8cA+s7AMmQ/eD71rtY8hIgOZOy3WyM8FnWj2RkU9EUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2t6K1YNg9q4RH8LBYZvgu0VAI1xleif3ksKZXGipFjw=;
 b=xs6fXE6VRy1xctCUkE/93tX0UY+RDkyiFIzVI0hLtBkIC/48WIv1LHHs7JvO9P7TB3gMkkeiuqrzZvj7crd0sRYWFrJG8R9p13pDWBv5A2u2luyStNpL/ioOPUtMlxt1rYOinYugDqFta5KcClPJrF5Zhg2UOxdLUQUGTMy25/M=
Received: from BLAPR05CA0024.namprd05.prod.outlook.com (2603:10b6:208:36e::20)
 by SA0PR12MB4493.namprd12.prod.outlook.com (2603:10b6:806:72::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Tue, 14 Nov
 2023 21:01:57 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::88) by BLAPR05CA0024.outlook.office365.com
 (2603:10b6:208:36e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.18 via Frontend
 Transport; Tue, 14 Nov 2023 21:01:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.14 via Frontend Transport; Tue, 14 Nov 2023 21:01:56 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Tue, 14 Nov
 2023 15:01:54 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 5/5] pds-vfio-pci: Add multi-region support
Date: Tue, 14 Nov 2023 13:01:29 -0800
Message-ID: <20231114210129.34318-6-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|SA0PR12MB4493:EE_
X-MS-Office365-Filtering-Correlation-Id: f32e8817-81f7-42e8-0880-08dbe554f002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fFkrSoJoZ0kqhcNNlP0AMzs89HBYDMhru4p6+H2eq8UmvlF3OB0scYJ8ekwbRyJT1OwsHAvusgmQJVJT+QgREZJ3UJipnY7JE6BOeusTgjWc24GbV41jTXgmoEYLpqnQp0HyhGwBRFaEJDw6Jyawr8MWuGh/uY8X4aLSu0hoGEgxwNbHpXm6TVffC23eEGisZhx1pKx+hxWya/4B/wiOolEhdcOL+rOeT5NxqxMMFMtMJZiykvOF840nzWJf+XqgwDXpncGF8pvw+tfinAUGaffwRj7Ev5ksKCh7kMLodlWBqggzG6aNzgxOOcZq1EsVhDZMDeSsMEPf9at3mddAjKMlN0P5FP8Ui3kB5YTP/YLPgc1QyUZ5Rk7tY88lVjCTYOXsUBvJp7lYb0wNymDa2i1e39vh2A5cimJz1uL+x2DS8KCtvjIw7oy5O3SYiqNlWi3vaQZihA6krnKXhaivRXUlTLgfX1F3M3VwQP/xwUTOZJk6UoUbI2zRhkwNeH+XLHNjC4GWf5gFt4H7X9125Q4vuWqKqmqcIhURLiyUF8CuorOt7UeA2Lu5za1pkO96KphiRnJbOlkJ7SjDvrKTht1sVNyNg2JbAEZkW51EeCPWlzz47bLg9Tz+AwQNAqmyXC1Dmsn3U+KMA+ata4Bbkj9Mf2Q6WQ8ltTmNyEoePogz9z/EWLCiVAQEv1DiDCMliO+IoYWDAkkJ/0dDmf2CzVZh1VtulDKwc1mjqzZsyMnyELBA4OcghBxxgoZPQI9uzr3wt5QuFU7OiUl/c8Gh1g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(136003)(346002)(230922051799003)(1800799009)(82310400011)(186009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(40480700001)(426003)(40460700003)(70586007)(316002)(110136005)(70206006)(54906003)(81166007)(26005)(356005)(82740400003)(86362001)(36756003)(83380400001)(1076003)(336012)(16526019)(6666004)(2616005)(36860700001)(30864003)(478600001)(2906002)(47076005)(5660300002)(44832011)(41300700001)(4326008)(8676002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 21:01:56.6298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f32e8817-81f7-42e8-0880-08dbe554f002
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4493

Only supporting a single region/range is limiting,
wasteful, and in some cases broken (i.e. when there
are large gaps in the iova memory ranges). Fix this
by adding support for multiple regions based on
what the device tells the driver it can support.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/dirty.c | 227 ++++++++++++++++++++++++-----------
 drivers/vfio/pci/pds/dirty.h |   4 +-
 2 files changed, 161 insertions(+), 70 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index d4ab97e39d3f..882e43e6c598 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -70,7 +70,7 @@ pds_vfio_print_guest_region_info(struct pds_vfio_pci_device *pds_vfio,
 	kfree(region_info);
 }
 
-static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
+static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_region *region,
 					unsigned long bytes)
 {
 	unsigned long *host_seq_bmp, *host_ack_bmp;
@@ -85,20 +85,29 @@ static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
 		return -ENOMEM;
 	}
 
-	dirty->region.host_seq = host_seq_bmp;
-	dirty->region.host_ack = host_ack_bmp;
-	dirty->region.bmp_bytes = bytes;
+	region->host_seq = host_seq_bmp;
+	region->host_ack = host_ack_bmp;
+	region->bmp_bytes = bytes;
 
 	return 0;
 }
 
 static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
 {
-	vfree(dirty->region.host_seq);
-	vfree(dirty->region.host_ack);
-	dirty->region.host_seq = NULL;
-	dirty->region.host_ack = NULL;
-	dirty->region.bmp_bytes = 0;
+	int i;
+
+	if (!dirty->regions)
+		return;
+
+	for (i = 0; i < dirty->num_regions; i++) {
+		struct pds_vfio_region *region = &dirty->regions[i];
+
+		vfree(region->host_seq);
+		vfree(region->host_ack);
+		region->host_seq = NULL;
+		region->host_ack = NULL;
+		region->bmp_bytes = 0;
+	}
 }
 
 static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
@@ -119,10 +128,18 @@ static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
 
 static void pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio)
 {
-	struct pds_vfio_region *region = &pds_vfio->dirty.region;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	int i;
+
+	if (!dirty->regions)
+		return;
+
+	for (i = 0; i < dirty->num_regions; i++) {
+		struct pds_vfio_region *region = &dirty->regions[i];
 
-	if (region->sgl)
-		__pds_vfio_dirty_free_sgl(pds_vfio, region);
+		if (region->sgl)
+			__pds_vfio_dirty_free_sgl(pds_vfio, region);
+	}
 }
 
 static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
@@ -156,22 +173,90 @@ static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
 	return 0;
 }
 
+static void pds_vfio_dirty_free_regions(struct pds_vfio_dirty *dirty)
+{
+	vfree(dirty->regions);
+	dirty->regions = NULL;
+	dirty->num_regions = 0;
+}
+
+static int pds_vfio_dirty_alloc_regions(struct pds_vfio_pci_device *pds_vfio,
+					struct pds_lm_dirty_region_info *region_info,
+					u64 region_page_size, u8 num_regions)
+{
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	u32 dev_bmp_offset_byte = 0;
+	int err, i;
+
+	dirty->regions = vcalloc(num_regions, sizeof(struct pds_vfio_region));
+	if (!dirty->regions)
+		return -ENOMEM;
+	dirty->num_regions = num_regions;
+
+	for (i = 0; i < num_regions; i++) {
+		struct pds_lm_dirty_region_info *ri = &region_info[i];
+		struct pds_vfio_region *region = &dirty->regions[i];
+		u64 region_size, region_start;
+		u32 page_count;
+
+		/* page_count might be adjusted by the device */
+		page_count = le32_to_cpu(ri->page_count);
+		region_start = le64_to_cpu(ri->dma_base);
+		region_size = page_count * region_page_size;
+
+		err = pds_vfio_dirty_alloc_bitmaps(region,
+						   page_count / BITS_PER_BYTE);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to alloc dirty bitmaps: %pe\n",
+				ERR_PTR(err));
+			goto out_free_regions;
+		}
+
+		err = pds_vfio_dirty_alloc_sgl(pds_vfio, region, page_count);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
+				ERR_PTR(err));
+			goto out_free_regions;
+		}
+
+		region->size = region_size;
+		region->start = region_start;
+		region->page_size = region_page_size;
+		region->dev_bmp_offset_start_byte = dev_bmp_offset_byte;
+
+		dev_bmp_offset_byte += page_count / 8;
+		if (dev_bmp_offset_byte % 8) {
+			dev_err(&pdev->dev, "Device bitmap offset is mis-aligned\n");
+			err = -EINVAL;
+			goto out_free_regions;
+		}
+	}
+
+	return 0;
+
+out_free_regions:
+	pds_vfio_dirty_free_bitmaps(dirty);
+	pds_vfio_dirty_free_sgl(pds_vfio);
+	pds_vfio_dirty_free_regions(dirty);
+
+	return err;
+}
+
 static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 				 struct rb_root_cached *ranges, u32 nnodes,
 				 u64 *page_size)
 {
 	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
 	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
-	u64 region_start, region_size, region_page_size;
 	struct pds_lm_dirty_region_info *region_info;
 	struct interval_tree_node *node = NULL;
+	u64 region_page_size = *page_size;
 	u8 max_regions = 0, num_regions;
 	dma_addr_t regions_dma = 0;
 	u32 num_ranges = nnodes;
-	u32 page_count;
+	int err, i;
 	u16 len;
-	int err;
 
 	dev_dbg(&pdev->dev, "vf%u: Start dirty page tracking\n",
 		pds_vfio->vf_id);
@@ -198,39 +283,38 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 		return -EOPNOTSUPP;
 	}
 
-	/*
-	 * Only support 1 region for now. If there are any large gaps in the
-	 * VM's address regions, then this would be a waste of memory as we are
-	 * generating 2 bitmaps (ack/seq) from the min address to the max
-	 * address of the VM's address regions. In the future, if we support
-	 * more than one region in the device/driver we can split the bitmaps
-	 * on the largest address region gaps. We can do this split up to the
-	 * max_regions times returned from the dirty_status command.
-	 */
-	max_regions = 1;
 	if (num_ranges > max_regions) {
 		vfio_combine_iova_ranges(ranges, nnodes, max_regions);
 		num_ranges = max_regions;
 	}
 
+	region_info = kcalloc(num_ranges, sizeof(*region_info), GFP_KERNEL);
+	if (!region_info)
+		return -ENOMEM;
+	len = num_ranges * sizeof(*region_info);
+
 	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
 	if (!node)
 		return -EINVAL;
+	for (i = 0; i < num_ranges; i++) {
+		struct pds_lm_dirty_region_info *ri = &region_info[i];
+		u64 region_size = node->last - node->start + 1;
+		u64 region_start = node->start;
+		u32 page_count;
 
-	region_size = node->last - node->start + 1;
-	region_start = node->start;
-	region_page_size = *page_size;
+		page_count = DIV_ROUND_UP(region_size, region_page_size);
 
-	len = sizeof(*region_info);
-	region_info = kzalloc(len, GFP_KERNEL);
-	if (!region_info)
-		return -ENOMEM;
+		ri->dma_base = cpu_to_le64(region_start);
+		ri->page_count = cpu_to_le32(page_count);
+		ri->page_size_log2 = ilog2(region_page_size);
 
-	page_count = DIV_ROUND_UP(region_size, region_page_size);
+		dev_dbg(&pdev->dev,
+			"region_info[%d]: region_start 0x%llx region_end 0x%lx region_size 0x%llx page_count %u page_size %llu\n",
+			i, region_start, node->last, region_size, page_count,
+			region_page_size);
 
-	region_info->dma_base = cpu_to_le64(region_start);
-	region_info->page_count = cpu_to_le32(page_count);
-	region_info->page_size_log2 = ilog2(region_page_size);
+		node = interval_tree_iter_next(node, 0, ULONG_MAX);
+	}
 
 	regions_dma = dma_map_single(pdsc_dev, (void *)region_info, len,
 				     DMA_BIDIRECTIONAL);
@@ -239,39 +323,20 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 		goto out_free_region_info;
 	}
 
-	err = pds_vfio_dirty_enable_cmd(pds_vfio, regions_dma, max_regions);
+	err = pds_vfio_dirty_enable_cmd(pds_vfio, regions_dma, num_ranges);
 	dma_unmap_single(pdsc_dev, regions_dma, len, DMA_BIDIRECTIONAL);
 	if (err)
 		goto out_free_region_info;
 
-	/*
-	 * page_count might be adjusted by the device,
-	 * update it before freeing region_info DMA
-	 */
-	page_count = le32_to_cpu(region_info->page_count);
-
-	dev_dbg(&pdev->dev,
-		"region_info: regions_dma 0x%llx dma_base 0x%llx page_count %u page_size_log2 %u\n",
-		regions_dma, region_start, page_count,
-		(u8)ilog2(region_page_size));
-
-	err = pds_vfio_dirty_alloc_bitmaps(dirty, page_count / BITS_PER_BYTE);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to alloc dirty bitmaps: %pe\n",
-			ERR_PTR(err));
-		goto out_free_region_info;
-	}
-
-	err = pds_vfio_dirty_alloc_sgl(pds_vfio, &dirty->region, page_count);
+	err = pds_vfio_dirty_alloc_regions(pds_vfio, region_info,
+					   region_page_size, num_ranges);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
-			ERR_PTR(err));
-		goto out_free_bitmaps;
+		dev_err(&pdev->dev,
+			"Failed to allocate %d regions for tracking dirty regions: %pe\n",
+			num_regions, ERR_PTR(err));
+		goto out_dirty_disable;
 	}
 
-	dirty->region.start = region_start;
-	dirty->region.size = region_size;
-	dirty->region.page_size = region_page_size;
 	pds_vfio_dirty_set_enabled(pds_vfio);
 
 	pds_vfio_print_guest_region_info(pds_vfio, max_regions);
@@ -280,8 +345,8 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 
 	return 0;
 
-out_free_bitmaps:
-	pds_vfio_dirty_free_bitmaps(dirty);
+out_dirty_disable:
+	pds_vfio_dirty_disable_cmd(pds_vfio);
 out_free_region_info:
 	kfree(region_info);
 	return err;
@@ -295,6 +360,7 @@ void pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio, bool send_cmd)
 			pds_vfio_dirty_disable_cmd(pds_vfio);
 		pds_vfio_dirty_free_sgl(pds_vfio);
 		pds_vfio_dirty_free_bitmaps(&pds_vfio->dirty);
+		pds_vfio_dirty_free_regions(&pds_vfio->dirty);
 	}
 
 	if (send_cmd)
@@ -365,6 +431,7 @@ static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
 
 	num_sge = sg_table.nents;
 	size = num_sge * sizeof(struct pds_lm_sg_elem);
+	offset += region->dev_bmp_offset_start_byte;
 	dma_sync_single_for_device(pdsc_dev, region->sgl_addr, size, dma_dir);
 	err = pds_vfio_dirty_seq_ack_cmd(pds_vfio, region->sgl_addr, num_sge,
 					 offset, bmp_bytes, read_seq);
@@ -437,13 +504,28 @@ static int pds_vfio_dirty_process_bitmaps(struct pds_vfio_pci_device *pds_vfio,
 	return 0;
 }
 
+static struct pds_vfio_region *
+pds_vfio_get_region(struct pds_vfio_pci_device *pds_vfio, unsigned long iova)
+{
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	int i;
+
+	for (i = 0; i < dirty->num_regions; i++) {
+		struct pds_vfio_region *region = &dirty->regions[i];
+
+		if (iova >= region->start && iova < (region->size - 1))
+			return region;
+	}
+
+	return NULL;
+}
+
 static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 			       struct iova_bitmap *dirty_bitmap,
 			       unsigned long iova, unsigned long length)
 {
 	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
-	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
-	struct pds_vfio_region *region = &dirty->region;
+	struct pds_vfio_region *region;
 	u64 bmp_offset, bmp_bytes;
 	u64 bitmap_size, pages;
 	int err;
@@ -456,6 +538,13 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
+	region = pds_vfio_get_region(pds_vfio, iova);
+	if (!region) {
+		dev_err(dev, "vf%u: Failed to find region that contains iova %lx\n",
+			pds_vfio->vf_id, iova);
+		return -EINVAL;
+	}
+
 	pages = DIV_ROUND_UP(length, region->page_size);
 	bitmap_size =
 		round_up(pages, sizeof(u64) * BITS_PER_BYTE) / BITS_PER_BYTE;
@@ -490,8 +579,8 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	bmp_offset = DIV_ROUND_UP(iova / region->page_size, sizeof(u64));
-
+	bmp_offset = DIV_ROUND_UP((iova - region->start) /
+				  region->page_size, sizeof(u64));
 	dev_dbg(dev,
 		"Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu bmp_bytes %llu\n",
 		iova, length, bmp_offset, bmp_bytes);
diff --git a/drivers/vfio/pci/pds/dirty.h b/drivers/vfio/pci/pds/dirty.h
index a1f6d894f913..c8e23018b801 100644
--- a/drivers/vfio/pci/pds/dirty.h
+++ b/drivers/vfio/pci/pds/dirty.h
@@ -13,11 +13,13 @@ struct pds_vfio_region {
 	u64 page_size;
 	struct pds_lm_sg_elem *sgl;
 	dma_addr_t sgl_addr;
+	u32 dev_bmp_offset_start_byte;
 	u16 num_sge;
 };
 
 struct pds_vfio_dirty {
-	struct pds_vfio_region region;
+	struct pds_vfio_region *regions;
+	u8 num_regions;
 	bool is_enabled;
 };
 
-- 
2.17.1


