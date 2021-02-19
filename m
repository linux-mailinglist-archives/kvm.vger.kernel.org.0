Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F348131FCE9
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 17:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhBSQOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 11:14:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40172 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhBSQO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 11:14:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JG92u7160223;
        Fri, 19 Feb 2021 16:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=5zackTxoA0RJJHEkuijSFmeurzsR3/En0vMm++KsGWg=;
 b=f92D1SJdUsHWu1jUfprKh9ucgtSZQisyGeRihXh/dK4SrqAEbrNZtaqr3QwFOA3hT+f8
 xTTBIKV2DVbLT0KI+nV6COurknx+B1cQRfXT0Vr1eoC12Dma0f8RGunflaEpCECfn0Ng
 FqKl+82TSjQfEqJGZwrZuHfB6gkuqxUGyWKYAxQujR9xwHWC6HVsjS2KzHcHCABFEDsd
 DZIhIIEpXdh1bJtTIcewCN2zsKCpd+On9MVh711BfcYNrIF4lkxZZBGInu6tNW764aIT
 9ZPOERMKo9I42/5VM2b5pgLEPgPYSmcPCzbX8rKAYU3IHVw1eTlz340Kt+8ZZMpYNeb/ Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36p66ra26b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 16:13:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JGBmeq146540;
        Fri, 19 Feb 2021 16:13:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by userp3020.oracle.com with ESMTP id 36prhvtevc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 16:13:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDAhXsYdxObOFevVWpLuUyz/MblmH4f5HUWAanNCOZqHE4nIo513Oe6m+gjfq9zu2xf2CnoyQ8QnBNpAVsPTaDfVa4tclYUu2N71ygwGyv7hLPSi2rBOjqkOdb9deSCYjh2VPaK54yzYtbf4nQ+MPuJBvQbTVmRtrfk+Ff8B3oJbItA74w7JE8biSba1X0b9LPAObC/8qDNVi1IGCePXiLyH9n21iQ1SIo/tdXDN4RxI1idPNlmvCeP4I05ORabYKd3+lbCKvRcSw+DIIEmGgubQ0f+3XMaa/gqdbvKn1qe6deqog5+kXQFkM9oxJEhFdV2fHoH7QDV5ze+Wa74frw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zackTxoA0RJJHEkuijSFmeurzsR3/En0vMm++KsGWg=;
 b=nAjYZXUY+4Wy1asNRJs8ntv3uU/6TMlR1UCX8I5N4ln0PTq7pv0dpF2VdI/oUoHnRYkn3dtD4MT6PYgPLF/jT7vz4lQrZ6QhoJ9VhJdhkOQBsrTdP8Qt9OmjVyqyxbkvyVG63fesVmRnOgO4rlaJ7rQZKbIaqgZrUJJazdF2nooExHmci365El0TTBzUcpgE6pq5QdgwHsWOj9yxF49/LmXgTZ+Sv4hSGEz5zUePH/LNvNXjkrfo5kC+6mmGzndsYzSls0luNx2STLvWkynU8ixKUwi/6kDRsbxJ97OfZ9Zfl8FWWRm9ody8x1WxAfADL7n1pdrAIOvyVqs9wxq92Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zackTxoA0RJJHEkuijSFmeurzsR3/En0vMm++KsGWg=;
 b=BOu58/MB926FfGhS7eK/1iYB7V7iA9QOcln9vNbUfoaZOwmiMyMVwlCN5AeBsOMnbj9JOkwjf1cg3n23BYJVFguRSf8I2BC5+3qFPGHu6rfPzTvDSUHxXZS0R1xAiGm4S7MH9/gg4rixMaVlcdL+wkbc+ZfBDKAUsyMxCadYF/4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by MWHPR10MB1662.namprd10.prod.outlook.com (2603:10b6:301:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 19 Feb
 2021 16:13:22 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 16:13:22 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 2/3] vfio/type1: Prepare for batched pinning with struct vfio_batch
Date:   Fri, 19 Feb 2021 11:13:04 -0500
Message-Id: <20210219161305.36522-3-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
References: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: BL0PR0102CA0052.prod.exchangelabs.com
 (2603:10b6:208:25::29) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (98.229.125.203) by BL0PR0102CA0052.prod.exchangelabs.com (2603:10b6:208:25::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Fri, 19 Feb 2021 16:13:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab5be0c1-f341-40c8-cd48-08d8d4f1473f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1662EBC5E4D44A8A7F7C22CBD9849@MWHPR10MB1662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ywCh3DmjWTj74BBQF8FGdHxRmnj/5n8x8U1cJ/hwt7CZy+EH+pCl/ZKM6INpERINQjp1qlmP6Bg1AuyCDnR+iD45k/rzFwDa40nyEiC+MqY4NT2WO/hHjvomIdi9cPamaVLu1T5YhV/lmBamcG4Xyk2pxaGQL5vgQx5Cm61FgOHxR9FDRYVltzR8B90FkaIXSHoZlBGpXp3Acody10xfB7pay6SQAcnzNWMsu2eK6JyYABP1jNsL0m0s8+qqnLFn/C45KJmAOk92Q1Xlzs5MODT88hbokQEmNniWtC5ondY3VE1fJrR11iC9JbK7F30AtMYG71LQedhhuLHQbXzSAS7inGh6rEYJen64NsQMjjMTPjgdwrxUfGDfiVSgqxVWGXNtKt625e9OBZ2bQA02S3eD2upVMQRkctx6gnjDDpS/Ql3c28BaRVa2DAO0+69R5eDDeYOnQWVQjkMiQdOuxC6p+vXbDLGHX1TE8IPKdQXnNDxYk9R/EnKKnwRFZCoWebcrCHvP4uR1dczX1YS8m0glm28ViOEhNGhZaa1uli4VVFh0b45DA54+SNX93FZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(136003)(346002)(376002)(83380400001)(2906002)(36756003)(316002)(2616005)(186003)(54906003)(110136005)(6486002)(4326008)(16526019)(66946007)(8676002)(1076003)(5660300002)(26005)(69590400012)(86362001)(103116003)(8936002)(107886003)(6512007)(6506007)(6666004)(478600001)(956004)(52116002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PR+oKP99vKV9IaXx21eNZc5kMvbqWExNravFKcCtITPlKp7z6J/0PaHkyEJL?=
 =?us-ascii?Q?6IrxfujiiONZox/lsooOqZmNY/xobRsietrIxvrLgGhXHdfxpFrPqpHZO2jn?=
 =?us-ascii?Q?exa9VzfW1i9ivCG+jgVraB/Y9XOy3+2q2TFHq2Q7RulckMPKqTiq3ld4LTLo?=
 =?us-ascii?Q?z2GixZG367BeT/rG7PO6jPuAUFJm4peW0NE/jtQaftZPWN30CEKXVq2dDu+U?=
 =?us-ascii?Q?Ihpr1H3Q7goD2vZcBUmlqjzA2Ec4227lPHGsPJIvoH0h5dabZFhh12CcvVCv?=
 =?us-ascii?Q?fKIH+E/91tUFLHdar+CvjI1J+OQsuNoa0mCbEtYNmt0x4RrKSHFtyztbxSJa?=
 =?us-ascii?Q?8waUXlKmAIVK2Tx8DaM715IzHkpjmjTP2ZSYLbWBP8WK0atatY6AUiBoFsLS?=
 =?us-ascii?Q?XcEK91BS7LhX07orelrRHP3fKn8RuHsWLYNAqBLErRCVr50ZKpxUChzhwV2v?=
 =?us-ascii?Q?8tWMDBT3x01o1fB+TwQtkcnw/jmDuqWv1ehOrfXO4aZOy7hIj3RjLd/OZK3G?=
 =?us-ascii?Q?cVW3we6I4QIHeRXwM9ceULt1heOTMo7h2XF4IO0U6oZo1eLNWZzk0J0IirZw?=
 =?us-ascii?Q?MZoBNajJ0Xj/le+D7X3OuM7KJk58EjECNqxvP9sBO/edg8CRPvGrRu02N9fu?=
 =?us-ascii?Q?Gls39YyCHMIWoTGtaBCLcKRqx5sqqm6Sd8wQQo1trvLiv+kbwwcp3ls8Zy7a?=
 =?us-ascii?Q?ekZoWw53pSpu6Tmy8FTE3zbl8N07QMC1dK1ZnqmCoO9ly1hFNLvE3LjvsRNi?=
 =?us-ascii?Q?b0ibIDDgXIpDnxnPVJPuoLJzmXSj9OQfO8GUsXxAM/0VDr9eHFMEQ5xuhuEz?=
 =?us-ascii?Q?enuMgAYNmceHzyqTKYxbqi4bPi1tpNFYXgzCT5osbh2sqMfthJEYgmqsZLfH?=
 =?us-ascii?Q?PkowcogKrESt2aQWFvcMOYs+P0HtxWzm7SzuLFt/sSZYVhkl85HB2BP0O1d1?=
 =?us-ascii?Q?TMkrcq1DJi3Qh0QQyjIHh46JZICyZZv+32EkT1cOjSLMymDkDPYU33RRDAh4?=
 =?us-ascii?Q?/IiwJCwRNIbH7Lw1UeOdurStcgRfRO/Nrju8LndEukz6lJaa7YVidmvMy+nm?=
 =?us-ascii?Q?BJuUkpKsxBgzJEsps6luyaf1UvNQMtuM1jJu8ISfStf7hw0lzPe+zaCWGobR?=
 =?us-ascii?Q?AeqmyBXzATggSkFsQ6n/EctZ5rqPpCTwE+A7uHCgpH4rL+qfiBp/sBCO7eUX?=
 =?us-ascii?Q?EnYSpirjcloSpGUhGQLJ7sS7T4O3G/WqTF5+/rrl+Nu0zpBHo/eqOyUmSSY/?=
 =?us-ascii?Q?3P6EZDHlAEnCnV5LA4cF5U22XmNaqvAlADEpILjsflMRTjYlQfU0fDP87eb2?=
 =?us-ascii?Q?X5ORsjtk5tYk2cyvQ8tI13E3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5be0c1-f341-40c8-cd48-08d8d4f1473f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 16:13:22.3354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OyDnk6cgODIbyVeiHvDAfVs9xE643RX49f41/BamdhNzB/6etxHzysO4jULaJMRW8rOYyiS3IKEuC8faf9J9FbeqSh3HqzkQcyDCismCvaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1662
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190127
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190127
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
index 7abaaad518a6..b7247a2fc87e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -103,6 +103,12 @@ struct vfio_dma {
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
@@ -459,6 +465,31 @@ static int put_pfn(unsigned long pfn, int prot)
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
@@ -489,10 +520,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
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
@@ -501,10 +532,10 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
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
 
@@ -592,7 +623,7 @@ static int vfio_wait_all_valid(struct vfio_iommu *iommu)
  */
 static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
-				  unsigned long limit)
+				  unsigned long limit, struct vfio_batch *batch)
 {
 	unsigned long pfn = 0;
 	long ret, pinned = 0, lock_acct = 0;
@@ -603,7 +634,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	if (!current->mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, pfn_base,
+			     batch->pages);
 	if (ret < 0)
 		return ret;
 
@@ -630,7 +662,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	/* Lock all the consecutive pages from pfn_base */
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
-		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
+		ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, &pfn,
+				     batch->pages);
 		if (ret < 0)
 			break;
 
@@ -693,6 +726,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 				  unsigned long *pfn_base, bool do_accounting)
 {
+	struct page *pages[1];
 	struct mm_struct *mm;
 	int ret;
 
@@ -700,7 +734,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	if (!mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
 	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
@@ -1394,15 +1428,19 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
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
@@ -1422,6 +1460,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		dma->size += npage << PAGE_SHIFT;
 	}
 
+	vfio_batch_fini(&batch);
 	dma->iommu_mapped = true;
 
 	if (ret)
@@ -1598,6 +1637,7 @@ static int vfio_bus_type(struct device *dev, void *data)
 static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			     struct vfio_domain *domain)
 {
+	struct vfio_batch batch;
 	struct vfio_domain *d = NULL;
 	struct rb_node *n;
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -1612,6 +1652,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		d = list_first_entry(&iommu->domain_list,
 				     struct vfio_domain, next);
 
+	vfio_batch_init(&batch);
+
 	n = rb_first(&iommu->dma_list);
 
 	for (; n; n = rb_next(n)) {
@@ -1659,7 +1701,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
 				npage = vfio_pin_pages_remote(dma, vaddr,
 							      n >> PAGE_SHIFT,
-							      &pfn, limit);
+							      &pfn, limit,
+							      &batch);
 				if (npage <= 0) {
 					WARN_ON(!npage);
 					ret = (int)npage;
@@ -1692,6 +1735,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		dma->iommu_mapped = true;
 	}
 
+	vfio_batch_fini(&batch);
 	return 0;
 
 unwind:
@@ -1732,6 +1776,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		}
 	}
 
+	vfio_batch_fini(&batch);
 	return ret;
 }
 
-- 
2.30.1

