Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102804FC023
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 17:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347705AbiDKPSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 11:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347717AbiDKPS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 11:18:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3904532075
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 08:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5cNLDJB9Y2/XkX3qr4gAm8q37aie0aNQLTe4v7h4wec10eDMe+gSH/oGJALdZUuxkZeQDphPF6DlD24EwddPY4r9t5OnBFG9RXHL05U+Ond4l04bCshQAk0qBWbM0kEfklSrY/yBatvAWgX+S5ijjO96WEoCy2SVJ7wTYegCDeDnvf9uTcocA1bd49gkBN4n3IT59bk/eUaAF8L3UvWmvGB34qC8dlQjlCYFCejBFgFjCdyQbpdZHjE8GL0VMvNh6FxOEdeLfTxaCdFD1S+ZLfA9azD4Knd1gkH3yWpQ+P7u4dIeJgaJiH9ZaT/idCpDFb53oRlI034W7+JYxeF8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8q6brgFYVQBC3PGM/Oo8QVZ2WBlZJpe30DpGshQeNGo=;
 b=ERziZo95ODp/Rz53hwPKIwBcTgdhLyKew6qBEKCoT2duVBZfxSoiQuD2ndPfz0ttmKrXVIzsEgV66ZQBIFC19BK10A0IGhy02XJiZgNE+dkgj9XdmGmUhI13IVA5pEbk4tE8TL4xqg6N7Vc/7GIuN0SQYnf/gYZCGC+OhzD/G97oPp7bjDZzEke4jl+vEuatNTpJ/C1tgMx69/KIHnn7/jGPut3ZHOomq1fJ8f99ctkMXY2dBn+qLT/YjawmdYvXWknl2sDVl0GFlm34IB3WMyLbp9rgd45hKolXxi4VLm3nSDb9Y/J+LheC8utJkea/TYrXMf2akFGZ9AYb2SwzMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8q6brgFYVQBC3PGM/Oo8QVZ2WBlZJpe30DpGshQeNGo=;
 b=L/O8i714uqc6Zwn9bcBNBfDNW+P5nJtd1wPac9WrD87PCKNViKk3uDcoXXJt8U6TtOdXzvFXGueVYiEpLoN8OGPX5CJsMPfNpohAIXgTlxx/4Cr/VqGrSPWCXmerWfWFYAbUQT3Wtoa11qAqNXWHxZkkjYqQnWpo3zswmv2/UjgZnacXB9+2bc9sJUgqtgXb+GiLOCXgT1avVAeGzTqYwnplr7x+SiZD4Sf5hsGTNcah6fqICPlpaUGXaMEg6wbwBgc07cl8asFxXHlccagZ9tjHRZToGThLHrqcPGGa5ug3cjQzeRbkbl2jUjAvJpjYpHvnYyEKGXkMbuxBzjubKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB5927.namprd12.prod.outlook.com (2603:10b6:510:1da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 11 Apr
 2022 15:16:10 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 15:16:10 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 2/4] vfio: Move the Intel no-snoop control off of IOMMU_CACHE
Date:   Mon, 11 Apr 2022 12:16:06 -0300
Message-Id: <2-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0124.namprd02.prod.outlook.com
 (2603:10b6:208:35::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db351221-c540-4037-86e2-08da1bce352a
X-MS-TrafficTypeDiagnostic: PH7PR12MB5927:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB59273FD85549CA86180A7042C2EA9@PH7PR12MB5927.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I7t6Y80Ev8dKWVsYG5EUEBAnjDb7e8b6J4OezXKo7qbNoeKU/ofmJH43kqTTXioLvHk9Y+57mFx9VDrYyj3+AZHHYvmzvlbgoqVj3Je+zdSCwZ8MLxFDa6EPkwcfQ4mcgozveIaX7i5jF95yWv9VWrIUW0N6/SmmuoVoj9F7isrTBMun6va6GaEhUAC/AMu3OFwz9+zYhWO+HdWatmmPBZz6DqT1QM1RupMlb76/ZW5gF767ZetJKSBLAbprMo6KryOYTXk8FLkE7ZZdCCRP6ihhzMBtJE6HKU4hV8bTdZYIvItCXoUQHaGWQHi8EC7VSNyMFF/nq1vREHfJVdm6QeuoP9YxiLvR2pQ7HfnxuoPdR4SWb1oP3/TQKcSBh0dwmpHY56uswy7LdrVIQh0D6WUWhaK4t0BvO+jw5AvfIrKo5lhL5PzPa58lZ19S0fKZ7slgho+obDcPPrWQVFlKKQTJIECpiGfa5w1lAKeBKmd9VO/JOAMlIyPJhnxjjTLVGGNoIkDn4bq+1yx3WfXe7ZfcCAEjb1SDKgtvQ84ifQ5GGiqwd5YtxoUI07vqzqOPMH8keHL/ZcXimu10xaRSjM+Ubod8OvL8P2m25IaN23bOInSEcyDxi0aFFaaewASYEMcz9rMYMpb1PirZihgna48MkTtZwZoLELORX1v84mCuSH1DUAU54VMOwJ5m7UcG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(54906003)(6512007)(38100700002)(8676002)(508600001)(6666004)(6506007)(8936002)(5660300002)(2616005)(4326008)(110136005)(316002)(83380400001)(86362001)(66946007)(66556008)(36756003)(66476007)(7416002)(186003)(26005)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QTLiJdTjzmaDOunUjOGosr1Xpal9jbwRYZJgp2HqkXHItBJAeRpaZsVwoQ/2?=
 =?us-ascii?Q?K8ExZeGVnby6KYHxFzqjHdhHHQlJMGKUoUKGvVuONNCVNQ+hocid6Q+15ORP?=
 =?us-ascii?Q?bibClFJRdTyrWeVVZVSQgOsDkS6rapIesKd1+LiuwUa58R0Tp952rNoh/cPv?=
 =?us-ascii?Q?kaGeOC2beAQsn0VmZlvqn6JnpNCmg3Ki9vlm4fkpZut9cto2ycchjTCYMRTO?=
 =?us-ascii?Q?BkNgOLsHDtn459YektkLA6epce3D7DdAJCbWl3yTPeC50Fs46LLOPmXyjclA?=
 =?us-ascii?Q?eyd/hcZWHaquHZG6/bC2rQPkOQjV454juX0tx4j7aSNajLxNWctL93+gTTQo?=
 =?us-ascii?Q?3HVZR1/lTkQhgcUg/1oFxI9H/2JYO0c8qDTItNTbPmv6xuPTZSpVwAKl0UMd?=
 =?us-ascii?Q?N253fxh4DD+0V3hPmS2a7BIbzVatOrfU05gPKvUhiCCaPJt58F9eW+nHWX/6?=
 =?us-ascii?Q?iF2+XyofGbI9D2p6gROO/NIkZuV9hm5dbt4yjTQsGCrlFK5C2aYSmFqWFCl5?=
 =?us-ascii?Q?btMcD3XuIFHTqrlku2Kxr+cOnpH5EdB4xS6AEiaJuzttpzZAoIz0CfKD+Wjn?=
 =?us-ascii?Q?CoQXV98dAh7HpZ/ysrC8V/xEHBOqvLBtYv2iTERLHaaC4TD4y6DOAInjcv4u?=
 =?us-ascii?Q?kkZnxAucUilvL7J3nVJ3EY611+ZLPVH0Z9SAhLbysAlQIxPApssvXdYO7tRs?=
 =?us-ascii?Q?B8s7T+zABYqBxbE+AtrdO8xMFWIHTUjEY1wWVTt0Vv5pczHpF5egs+xtDhA9?=
 =?us-ascii?Q?wVaH0A6anCqLWRQn3dd/8OKCfiHmzvQrASj9l+hKLzqZmYEoG+X48XD1x671?=
 =?us-ascii?Q?sEoMt5w8GhUWQmJRXIyCUwLLKUsLvZ2et7yX0Eas7vVUHyQDKa6QT5+cOMts?=
 =?us-ascii?Q?BaaJ3hj3pqiHripxLCAyUNbavcrcYRugr+ht3JQ1I4+IV3Iwl8oGyKwU9eAK?=
 =?us-ascii?Q?P1kazFfxD+K2q4n3e8EEBtlhnk/I7oYGG85Tbwz1jvAEPwHfF/osJ99WeREz?=
 =?us-ascii?Q?cC4x8FyU4rguWLQUx9Ke9fhS2HwGIJVaAb+qGp9/0QJw2giEX35YSOD+S56+?=
 =?us-ascii?Q?MgcgiFKOPsvS/yRyCnNZmZ5X6UPdVGEf09d0MG6fqi9ZSXN8erHqqmT1cJpo?=
 =?us-ascii?Q?R4M5riZngnyzU7Wlj7CohXILHs2HCKRVdT/yH+wIfVKz8EdhRyWyGQXqvltu?=
 =?us-ascii?Q?oxA0llQhUpyT+Z9scobqrE9olGHuge1ZYDm5TD/mhHjpG7eRUa4e6Uha6kwy?=
 =?us-ascii?Q?/LiS4YjOopC+RdXQktnrhoFCwRYQTsykFHiwD4a7Ni+FC8HfbZFrpcM2ca6F?=
 =?us-ascii?Q?q+bciBDTHJU5wqNrPUZfoxJDItRvIikRhVSoxPjAV+Y0v+be1uBve4HGgbXQ?=
 =?us-ascii?Q?9mSdo+ZEtriig3ln2UN3uimzzEYXnkquC4IN5+j4yKr9R1Tpl4f8wWTgOmZO?=
 =?us-ascii?Q?wtniCTLAZz5ysAuYVxThNH+5voHRDXB87ROIrI4I39AcpKy9AFmwctUs3aw9?=
 =?us-ascii?Q?aIsmYbcwEkiK2JvMo806iRRvioWgNu3rDP2nbzxWbQlOmwOtJoS/wyEJFemp?=
 =?us-ascii?Q?k0KTwyK8hXifp29hOTcWGD13a/whA1Y5/oVs2uHvINbcYUtGzm4RY9yLdPvh?=
 =?us-ascii?Q?fXXdL5rXAhfnziLPtaPwn1j+vVr7dg1m8C8+fBR1rDBQMEY0DKMMR2c4KYEC?=
 =?us-ascii?Q?IZoxP5gUtOUIj3jASmwnC9A2fZgsuP6lJO81NftG5I448wy92CSeC1EHB7uR?=
 =?us-ascii?Q?fFwCiCFhKQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db351221-c540-4037-86e2-08da1bce352a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 15:16:09.8975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LjvVDomLxjWt9Ov6g+XSfS5/BSeupwG5qita3QkhZxjjPQXXUgSCHzVWZzedI419
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5927
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU_CACHE means "normal DMA to this iommu_domain's IOVA should be cache
coherent" and is used by the DMA API. The definition allows for special
non-coherent DMA to exist - ie processing of the no-snoop flag in PCIe
TLPs - so long as this behavior is opt-in by the device driver.

The flag is mainly used by the DMA API to synchronize the IOMMU setting
with the expected cache behavior of the DMA master. eg based on
dev_is_dma_coherent() in some case.

For Intel IOMMU IOMMU_CACHE was redefined to mean 'force all DMA to be
cache coherent' which has the practical effect of causing the IOMMU to
ignore the no-snoop bit in a PCIe TLP.

x86 platforms are always IOMMU_CACHE, so Intel should ignore this flag.

Instead use the new domain op enforce_cache_coherency() which causes every
IOPTE created in the domain to have the no-snoop blocking behavior.

Reconfigure VFIO to always use IOMMU_CACHE and call
enforce_cache_coherency() to operate the special Intel behavior.

Remove the IOMMU_CACHE test from Intel IOMMU.

Ultimately VFIO plumbs the result of enforce_cache_coherency() back into
the x86 platform code through kvm_arch_register_noncoherent_dma() which
controls if the WBINVD instruction is available in the guest.  No other
archs implement kvm_arch_register_noncoherent_dma() nor are there any
other known consumers of VFIO_DMA_CC_IOMMU that might be affected by the
user visible result change on non-x86 archs.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c     |  7 ++-----
 drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
 include/linux/intel-iommu.h     |  1 -
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 8e8adecc6a434e..2332060e059c3d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -641,7 +641,6 @@ static unsigned long domain_super_pgsize_bitmap(struct dmar_domain *domain)
 static void domain_update_iommu_cap(struct dmar_domain *domain)
 {
 	domain_update_iommu_coherency(domain);
-	domain->iommu_snooping = domain_update_iommu_snooping(NULL);
 	domain->iommu_superpage = domain_update_iommu_superpage(domain, NULL);
 
 	/*
@@ -4283,7 +4282,6 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	domain->agaw = width_to_agaw(adjust_width);
 
 	domain->iommu_coherency = false;
-	domain->iommu_snooping = false;
 	domain->iommu_superpage = 0;
 	domain->max_addr = 0;
 
@@ -4422,8 +4420,7 @@ static int intel_iommu_map(struct iommu_domain *domain,
 		prot |= DMA_PTE_READ;
 	if (iommu_prot & IOMMU_WRITE)
 		prot |= DMA_PTE_WRITE;
-	if (((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping) ||
-	    dmar_domain->force_snooping)
+	if (dmar_domain->force_snooping)
 		prot |= DMA_PTE_SNP;
 
 	max_addr = iova + size;
@@ -4550,7 +4547,7 @@ static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 
-	if (!dmar_domain->iommu_snooping)
+	if (!domain_update_iommu_snooping(NULL))
 		return false;
 	dmar_domain->force_snooping = true;
 	return true;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9394aa9444c10c..c13b9290e35759 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -84,8 +84,8 @@ struct vfio_domain {
 	struct iommu_domain	*domain;
 	struct list_head	next;
 	struct list_head	group_list;
-	int			prot;		/* IOMMU_CACHE */
-	bool			fgsp;		/* Fine-grained super pages */
+	bool			fgsp : 1;	/* Fine-grained super pages */
+	bool			enforce_cache_coherency : 1;
 };
 
 struct vfio_dma {
@@ -1461,7 +1461,7 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
-				npage << PAGE_SHIFT, prot | d->prot);
+				npage << PAGE_SHIFT, prot | IOMMU_CACHE);
 		if (ret)
 			goto unwind;
 
@@ -1771,7 +1771,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			}
 
 			ret = iommu_map(domain->domain, iova, phys,
-					size, dma->prot | domain->prot);
+					size, dma->prot | IOMMU_CACHE);
 			if (ret) {
 				if (!dma->iommu_mapped) {
 					vfio_unpin_pages_remote(dma, iova,
@@ -1859,7 +1859,7 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain)
 		return;
 
 	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
-			IOMMU_READ | IOMMU_WRITE | domain->prot);
+			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
 	if (!ret) {
 		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
 
@@ -2267,8 +2267,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_detach;
 	}
 
-	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
-		domain->prot |= IOMMU_CACHE;
+	/*
+	 * If the IOMMU can block non-coherent operations (ie PCIe TLPs with
+	 * no-snoop set) then VFIO always turns this feature on because on Intel
+	 * platforms it optimizes KVM to disable wbinvd emulation.
+	 */
+	if (domain->domain->ops->enforce_cache_coherency)
+		domain->enforce_cache_coherency =
+			domain->domain->ops->enforce_cache_coherency(
+				domain->domain);
 
 	/*
 	 * Try to match an existing compatible domain.  We don't want to
@@ -2279,7 +2286,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 */
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		if (d->domain->ops == domain->domain->ops &&
-		    d->prot == domain->prot) {
+		    d->enforce_cache_coherency ==
+			    domain->enforce_cache_coherency) {
 			iommu_detach_group(domain->domain, group->iommu_group);
 			if (!iommu_attach_group(d->domain,
 						group->iommu_group)) {
@@ -2611,14 +2619,14 @@ static void vfio_iommu_type1_release(void *iommu_data)
 	kfree(iommu);
 }
 
-static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
+static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
 {
 	struct vfio_domain *domain;
 	int ret = 1;
 
 	mutex_lock(&iommu->lock);
 	list_for_each_entry(domain, &iommu->domain_list, next) {
-		if (!(domain->prot & IOMMU_CACHE)) {
+		if (!(domain->enforce_cache_coherency)) {
 			ret = 0;
 			break;
 		}
@@ -2641,7 +2649,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
 			return 0;
-		return vfio_domains_have_iommu_cache(iommu);
+		return vfio_domains_have_enforce_cache_coherency(iommu);
 	default:
 		return 0;
 	}
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 4c2baf2446c277..72e5d7900e717f 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -539,7 +539,6 @@ struct dmar_domain {
 
 	u8 has_iotlb_device: 1;
 	u8 iommu_coherency: 1;		/* indicate coherency of iommu access */
-	u8 iommu_snooping: 1;		/* indicate snooping control feature */
 	u8 force_snooping : 1;		/* Create IOPTEs with snoop control */
 
 	struct list_head devices;	/* all devices' list */
-- 
2.35.1

