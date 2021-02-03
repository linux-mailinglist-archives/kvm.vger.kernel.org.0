Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E3F30E447
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 21:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhBCUwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 15:52:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38962 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbhBCUtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:49:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113Kdohe011002;
        Wed, 3 Feb 2021 20:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/qhLUwOrPFbO4aWZQWhK5m6Jxbc7cmweuAyR4M8rvL8=;
 b=PdqKrwYv+z634mqBGSE4UYimTtO0zIQlqteQCnqFQG9DVqJKAIcRrJHM242iUgXFSRrA
 4vgyMnALsr8KIpRnQ7QiGLn1P/ISkKhCgs37OjnhrIyx1Ihg9Kufb6dPCfxrN9N242d7
 M4K+9fanrdjonShIuiFscTq8T4hp2KsmS/UAmKiJElw8A3esRonR9O6KURRS92ZsRXJA
 GLQjyzbLT1bxFu450XbE/cfnMKS6d6yTfqPwoqGcJsmHf3zffSNgNfYYzY1zd/osbd4x
 B/eE6t3x+4cj5A/cSXO+kfkFX7YbCNtVaF5J+ehE9OCgdN5pqLxj+s1ZJQOWEp0sugG0 dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36cvyb2btm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 20:48:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113KkHkn169343;
        Wed, 3 Feb 2021 20:48:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by userp3020.oracle.com with ESMTP id 36dh7u4fjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 20:48:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOM12L6fSIAjCJ75h44goSql0FOs2BgdP6qefLJCC+P25Ga3c0VfTrkb3Ezom2RrtRNchuvVKOKssaKov0u9ER4iGxDiesxZoEY3091+YlXCJupKICE2hfp6gPOTHQmIH6EFZl0qXi9PE1vWhvTA6EC2wxUF5AjkMmWa4f2pWit4fzyX1Q7bM/m1XoQIa65QJLXPwq68nr9bhEaSi4srnGvUaRLlzI14nU4y5+OUwGN3CmF+/whDZrh1MyRWffWqdz0GH82wZYipHZFjesdN4aTBtG9QvFPh+MMRHrXGbp1qqKYSPQ8yXmZqL85HWtERVmbhlwH6/J8LuudgW74XuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qhLUwOrPFbO4aWZQWhK5m6Jxbc7cmweuAyR4M8rvL8=;
 b=EmA+HHqqVD/uknC85tIe3DYaKdCeu4xaJ0l8UEZ44qb++pV+7PZC+U5Co4YdvRKcx3Qgcs6BqD6wDrfTrpmM7tf6JJoVOO/uz7gJyQAfom8r3Y9VQMsSpM9OziOMF5X6IQj/fP3YIAUM1zu4O8vwWY7tA39xoqHgQYfejFqOqC4+UCm69jYFyTSq6Pi4ERfGMx+ulGjJ/4T0fbGWysCS1KAnfoDV2xNKPoTk+HFqGyrSdxbEoCdaiAgxlYIAIJmFpEZH88WQrg2p9YDlP5noVsvomsRnvb5k9XFHDYU9xNJCyjcq8F6KYUMOLk9ZIDCyPjaG67tcpgZ4go/TsUxBXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qhLUwOrPFbO4aWZQWhK5m6Jxbc7cmweuAyR4M8rvL8=;
 b=aie/PSKhoSrjeWYUguVlDRHKReblBqY2H6SjMhEepu9T3hlfs9yEiVaatvhyje4CLWlLaun5RSrHt56jXUrnlrAenZBujxnBFhrdoT9rMovMDol4jyePl5PlYZwx7HLQzqCNKWg1lPHghfI8rvGGEven8Th8guRyDllwde2lBvA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by CO1PR10MB4691.namprd10.prod.outlook.com (2603:10b6:303:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 3 Feb
 2021 20:48:15 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3805.027; Wed, 3 Feb 2021
 20:48:15 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 2/3] vfio/type1: prepare for batched pinning with struct vfio_batch
Date:   Wed,  3 Feb 2021 15:47:55 -0500
Message-Id: <20210203204756.125734-3-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210203204756.125734-1-daniel.m.jordan@oracle.com>
References: <20210203204756.125734-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: BL1PR13CA0215.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::10) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (98.229.125.203) by BL1PR13CA0215.namprd13.prod.outlook.com (2603:10b6:208:2bf::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 20:48:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 450f9811-a3bc-474b-2e43-08d8c8850709
X-MS-TrafficTypeDiagnostic: CO1PR10MB4691:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB46910DAE4BF54CF49EE10AC1D9B49@CO1PR10MB4691.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8xSy8nSzdx6vdrHb1s8X8KolF0nHHd2uj+IfwJ+YiIpKw1BZzqMaEch6uiTwSFEJUmJqUf9CmzOUkd2tlWlw98x7AMVorh+z05iA6Mxmcxm7wyhA3b5sPE7LldwI+OJmse6bYg2rjIdJsxvTSgp7djWRcD6KdttnMJoBlUH5txUt/p+xjBg/Z4ipMMXeiNSRW61A7Y2jjrBENH5k4YMNspJQ5Fl1G8hVWEJgW9I1cFLsZ8tw4c8s0xSIYbEd/6MrpZDqtlS9WMM/ibDJ7vMQDQ4i0lxkZioqfZSZaeNav7/PwMm/ieX0xwITp2o4MwQ31N6bhtvSwjcSyEnRIMtNE+6sQhc1N1oupo2+jI0RxWeqUiwxxfZ2L7Hrq7hzwnLf0TXuuAKlNi55cTmblESy90ogeKZFTYZqSgHWRj1GPwWOrQm0oRU6prBsom87+Z7F7bOiLSEf2SG8Wb2zFrWDat9fXkb5NmwPP3MgwpH0AaLa7M8lAOUjbqQB7vYSfJj1N69W0YmRBgWobZmwD4bbnOooun2JK9vWHww11+QCJbv0gR7JWRHebhqxtRqsYu1e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(103116003)(6486002)(478600001)(36756003)(107886003)(4326008)(66946007)(8936002)(1076003)(16526019)(5660300002)(110136005)(54906003)(26005)(186003)(6506007)(69590400011)(52116002)(8676002)(86362001)(83380400001)(316002)(2906002)(6512007)(956004)(66476007)(66556008)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UdnrC7sjyAMZavNdMbcdISqtExEDr6X8+a+YiYD327suJOi/T9ArOKbVix4R?=
 =?us-ascii?Q?Y8eWpQceEDq4/1Yh1x08BbITGVWaCNTSSI2vhyAJPo3mdcEcCyyIgBls+0Rk?=
 =?us-ascii?Q?c9Oz7C3hi4WcsOeYPIiiPE++b/d72ksX6Nq4SjWM8CZu7ZLK9a3R7egwOnd6?=
 =?us-ascii?Q?KvVYI1IczPWT0LG9meyolErQhnV4aMRKBiFbKNeejZSp+sd3FPXElidcScS2?=
 =?us-ascii?Q?scmPIbbr66/75A/oeuOEkg4kjX1jhOQOFRpHNrKrdBBvaqVWnen/n0Mjsont?=
 =?us-ascii?Q?n0elAK4S0KTorYIR2TJ17UU5zv1PqS7THLh1wUHtzBuxvy9m9vZGLNzAujXE?=
 =?us-ascii?Q?5Ugf2+8LooiOIMBlhn1hw+gXtNK1o3FKGuR8e73RWtwuolsnF8EHYuNnxKHB?=
 =?us-ascii?Q?tBGo/vbUnTAKvG2FWZmL2rvVQcB9F+Suzw0mGtmTfztBZ7ZBIYtBWdLQWsgL?=
 =?us-ascii?Q?iJtLOSz24t5sAk0wK/llif2uXWPU9SC+KEp5A09xAp+1BJGcZEGjyCJ6JaCJ?=
 =?us-ascii?Q?dAwfApkpOtwznJnzM3UVkyBUBIcJv3HkdlJUEW/TNWqu+SPgKZQTXZm5CzVC?=
 =?us-ascii?Q?gsXVS2odGp0F1Z4GZjId2UI8IPqyLMayjBvQNAJ9h008jItHGQVxHjsx05kj?=
 =?us-ascii?Q?tBbmHxijxBD/yVSgFx7JLG4QO8SyftRUauA2/vviSgViA0NycQGa3Zx3L98B?=
 =?us-ascii?Q?f9/75YjnHeAJn6gVteiaftxh2g0WbNZ5SbYqnsG3Pi8bplyQScz6xE2cgULm?=
 =?us-ascii?Q?3d2peHtqk0API8zH8HfLo3jgbxMBttOtoeaTBze/H9TAqiXcaVNlWJNVQLeX?=
 =?us-ascii?Q?bNeAMKYet+fAt4lzjlWTBeRvNKRhUUTZAlH7g4bkjeiTCU5SNucDgKSkVEgJ?=
 =?us-ascii?Q?KCLvHAnq6pzxm/rXjbWsG+Pboj3sbnUkDWLJkjHhydU2eGgoENyVsjh2zNjT?=
 =?us-ascii?Q?ocP7S+4S629EXs5VZ1S5lhGLuPVyiFSOs3vRK4j8+ng8/49nPT5kuMywniPC?=
 =?us-ascii?Q?e4dOFlmlhF0crA538NrkyS0kSDh9rieVb6tz1RX7MIH3oh+8dDYVq63+0AWV?=
 =?us-ascii?Q?IKe3Ej8J9fAmcV4j9CNy+JCp306vPelX3pJ3knHbGteNh0oJPyynb5/kUp28?=
 =?us-ascii?Q?Wiog8BHCEaHQJedT37OPQggASSY/G8UOuQvTCE4QSm1Hz4VbkX3vJ/vuxow+?=
 =?us-ascii?Q?xMeDnlGyeWjXs2wbQ5W7Zrr+9jHoHK4FEkgGjrp3N921vvxOgNyRsBkdYC+u?=
 =?us-ascii?Q?GKiEkjW1Li9mmXlbLpDDip5s1wY1WXdvCzEnlFgj3GG9lAaASU8pa2Sl+94Q?=
 =?us-ascii?Q?lJSjsjCqsJv6GvMChXeUjfE0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 450f9811-a3bc-474b-2e43-08d8c8850709
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 20:48:14.9341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIAzH9RjzStBopsKy9Z8E0oEQDeEn3B1HailIDTHKxG9ZRI0cTSN3LOs7zEpZ1gXUkq5LPsx+wZYVyvWM5cMevlinroRV0dXAXIZ5/rfpDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4691
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030124
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get ready to pin more pages at once with struct vfio_batch, which
represents a batch of pinned pages.

The struct has a fallback page pointer to avoid two unlikely scenarios:
pointlessly allocating a page if disable_hugepages is enabled or failing
the whole pinning operation if the kernel can't allocate memory.

vaddr_get_pfn() becomes vaddr_get_pfns() to prepare for handling
multiple pages, though for now only one page is stored in the pages
array.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 71 +++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4d608bc552a4..c26c1a4697e5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -97,6 +97,12 @@ struct vfio_dma {
 	unsigned long		*bitmap;
 };
 
+struct vfio_batch {
+	struct page		**pages;	/* for pin_user_pages_remote */
+	struct page		*fallback_page; /* if pages alloc fails */
+	int			capacity;	/* length of pages array */
+};
+
 struct vfio_group {
 	struct iommu_group	*iommu_group;
 	struct list_head	next;
@@ -415,6 +421,31 @@ static int put_pfn(unsigned long pfn, int prot)
 	return 0;
 }
 
+#define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
+
+static void vfio_batch_init(struct vfio_batch *batch)
+{
+	if (unlikely(disable_hugepages))
+		goto fallback;
+
+	batch->pages = (struct page **) __get_free_page(GFP_KERNEL);
+	if (!batch->pages)
+		goto fallback;
+
+	batch->capacity = VFIO_BATCH_MAX_CAPACITY;
+	return;
+
+fallback:
+	batch->pages = &batch->fallback_page;
+	batch->capacity = 1;
+}
+
+static void vfio_batch_fini(struct vfio_batch *batch)
+{
+	if (batch->capacity == VFIO_BATCH_MAX_CAPACITY)
+		free_page((unsigned long)batch->pages);
+}
+
 static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
 			    bool write_fault)
@@ -445,10 +476,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
  * Returns the positive number of pfns successfully obtained or a negative
  * error code.
  */
-static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
-			 int prot, unsigned long *pfn)
+static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
+			  long npages, int prot, unsigned long *pfn,
+			  struct page **pages)
 {
-	struct page *page[1];
 	struct vm_area_struct *vma;
 	unsigned int flags = 0;
 	int ret;
@@ -457,10 +488,10 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 		flags |= FOLL_WRITE;
 
 	mmap_read_lock(mm);
-	ret = pin_user_pages_remote(mm, vaddr, 1, flags | FOLL_LONGTERM,
-				    page, NULL, NULL);
-	if (ret == 1) {
-		*pfn = page_to_pfn(page[0]);
+	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
+				    pages, NULL, NULL);
+	if (ret > 0) {
+		*pfn = page_to_pfn(pages[0]);
 		goto done;
 	}
 
@@ -493,7 +524,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
  */
 static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
-				  unsigned long limit)
+				  unsigned long limit, struct vfio_batch *batch)
 {
 	unsigned long pfn = 0;
 	long ret, pinned = 0, lock_acct = 0;
@@ -504,7 +535,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	if (!current->mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, pfn_base,
+			     batch->pages);
 	if (ret < 0)
 		return ret;
 
@@ -531,7 +563,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	/* Lock all the consecutive pages from pfn_base */
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
-		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
+		ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, &pfn,
+				     batch->pages);
 		if (ret < 0)
 			break;
 
@@ -594,6 +627,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 				  unsigned long *pfn_base, bool do_accounting)
 {
+	struct page *pages[1];
 	struct mm_struct *mm;
 	int ret;
 
@@ -601,7 +635,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	if (!mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
 	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
@@ -1246,15 +1280,19 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 {
 	dma_addr_t iova = dma->iova;
 	unsigned long vaddr = dma->vaddr;
+	struct vfio_batch batch;
 	size_t size = map_size;
 	long npage;
 	unsigned long pfn, limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret = 0;
 
+	vfio_batch_init(&batch);
+
 	while (size) {
 		/* Pin a contiguous chunk of memory */
 		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
-					      size >> PAGE_SHIFT, &pfn, limit);
+					      size >> PAGE_SHIFT, &pfn, limit,
+					      &batch);
 		if (npage <= 0) {
 			WARN_ON(!npage);
 			ret = (int)npage;
@@ -1274,6 +1312,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		dma->size += npage << PAGE_SHIFT;
 	}
 
+	vfio_batch_fini(&batch);
 	dma->iommu_mapped = true;
 
 	if (ret)
@@ -1432,6 +1471,7 @@ static int vfio_bus_type(struct device *dev, void *data)
 static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			     struct vfio_domain *domain)
 {
+	struct vfio_batch batch;
 	struct vfio_domain *d = NULL;
 	struct rb_node *n;
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -1442,6 +1482,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		d = list_first_entry(&iommu->domain_list,
 				     struct vfio_domain, next);
 
+	vfio_batch_init(&batch);
+
 	n = rb_first(&iommu->dma_list);
 
 	for (; n; n = rb_next(n)) {
@@ -1489,7 +1531,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
 				npage = vfio_pin_pages_remote(dma, vaddr,
 							      n >> PAGE_SHIFT,
-							      &pfn, limit);
+							      &pfn, limit,
+							      &batch);
 				if (npage <= 0) {
 					WARN_ON(!npage);
 					ret = (int)npage;
@@ -1522,6 +1565,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		dma->iommu_mapped = true;
 	}
 
+	vfio_batch_fini(&batch);
 	return 0;
 
 unwind:
@@ -1562,6 +1606,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		}
 	}
 
+	vfio_batch_fini(&batch);
 	return ret;
 }
 
-- 
2.30.0

