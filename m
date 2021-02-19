Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729E931FCE4
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 17:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBSQO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 11:14:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60428 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBSQOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 11:14:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JGAvEj064720;
        Fri, 19 Feb 2021 16:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=H+U6Mx1HE8oAkiBafoQpVLBtZRD3caDRoqQ++m1Nj+4=;
 b=UFv2yQf2w2x16SNbnqGVFWh7N8t1ipe7LGOE3mE83Aw+0pGKLfSuQiHE9JZ/1R5TSdBQ
 m4AIwYA1XJ8yMLaDe7Trrx3gsn2PeBsBATMCUjC3dXxO3JwSa+aOyTR4Dj+Wj6pbZLR6
 UFb0d5C/UKCLFVzDcSA09XJWoYerJkXbtqwyq6NxTvrbBghU6fvXJjeQ8LHlKtdi3/RI
 tmJmxRzEDg/+LONmgyXFrrzSSesYuDeq0MVMseW3pLx+du8CpU3s9RnhKvu6/QgMZGLe
 2JmUNiJsQUOS0j8112VKCsdFla8qosMP9ovkufcHs6yx6SoEWuw8BU0XaK8wNOafk7jz YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36p49bj6p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 16:13:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JGBmer146540;
        Fri, 19 Feb 2021 16:13:25 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by userp3020.oracle.com with ESMTP id 36prhvtevc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 16:13:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrJ914+SM+iTPTSQFtm7W8C6Eq67Zk9Ant+G2p1jOIsWZr5Fzy9b7k+LHm2PoBMHU/PltyVX58A+6X3dAavt9YtZqqYfDQjumoykYKFjJXl+UC3VJK05TdwxUGPvPpiD5N5pX4dsNhzhE4Po09JsGugKxrEowxyCsIG1P/qw/HqNwk7TZiyWEQ0Z3dQnYtREg0pszzbj2YtExY3YDCnYRbsmDKXX6CRZ+uPoZeETO+Gi3MaHTLM2wLiDPOP4G+0/HpHd8ygLxHm8+/gK+af5rXj36pPhAWvvWsW4eDcCJ6dDxOn6f2wNnJSB/MzXYxNTsN6MmDj3vm8iERGeXgdK2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+U6Mx1HE8oAkiBafoQpVLBtZRD3caDRoqQ++m1Nj+4=;
 b=I1vB9c6LiVH7wg5aX4HfeO8GC7DIBlDYXeMGbPU1WKr2Gr2KlvOx7MF4bHM3L12W1l/ZKHBJ95VcLoI4kWd2JJIeaKBPzN+VbmgQmwXQlELiKz4dNASgnCTjKoINVxgtYwNxYUuxKOwDSwnlF563XACeqhIBUtfo8YgSCq0L38Q1YuxWq9aZG24MMBA4B+u9w8mhwsHZ5KjXAQEQAD19qDIvtufxjhMMQDep1j/vRP8uAAuNLxx1I3lFvHYiHAFGdc1tr1M6ZhiWPf3EJ8sWF+4VCp1v3H5g59z+3DWiZoYsiXfcD1zzTJXThGWgTn/oNuTsugCRBJhV/+4UPaYiow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+U6Mx1HE8oAkiBafoQpVLBtZRD3caDRoqQ++m1Nj+4=;
 b=El4iVc82i0Zf/eIafqmjJ1Fx+VKz/m7i4Rc4e4geEFCt5Y4e7TrLF0/qQvvdRciW+vydDR1rclUX0heKoJ9iak+zvPhh/lcz99wNf0m6CZidAVTHHHsRjUyWrpbDoVbF12Y3D37QRBJrWWK7E+QfDr3UYR14MASFKIH29jUPNm4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by MWHPR10MB1662.namprd10.prod.outlook.com (2603:10b6:301:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 19 Feb
 2021 16:13:24 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 16:13:24 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 3/3] vfio/type1: Batch page pinning
Date:   Fri, 19 Feb 2021 11:13:05 -0500
Message-Id: <20210219161305.36522-4-daniel.m.jordan@oracle.com>
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
Received: from localhost.localdomain (98.229.125.203) by BL0PR0102CA0052.prod.exchangelabs.com (2603:10b6:208:25::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Fri, 19 Feb 2021 16:13:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f1999e2-4ce9-4281-20ac-08d8d4f1481b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1662C1E75A616CF0BE86F0B5D9849@MWHPR10MB1662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xg6yqba/Gi2lrMNtNpLaDDh1GupUKk/E8IyD3rcjeK1x3/KFXEFN6xu5wXAn3DQXxtCpPK0tyYAHEGwEpq7Cbr2Il3rMRjt0YUdwsQ0huxt6Rd6F6fHA630zJW2/vq3m35e8uewdL5q74U183OJqCERL4haT0qbiDgq+crEk+tLMrU/WeX35wbRSYicx+p4WC+tmTubVb+gg02UlbLUgbVdaOxxlzWgvGrbSfzaR1QJeyKIGqEwnN3QFmIP1ETi4e0V7wLL+wYkikGzLA0amhVKcP1qZGjN4MnDAAz4C+mitLWw7mTVRARp8/N4ZL4o3UsTwiQ+66nPGJ9PtE2wY4/n/AiSLFxBUpyLWLr3TvYbwV47rTQ0VYaINE7KG9zsrAV6EL2rPnjgbyuPjY/KRYbdQtsN1vu/rHfrdIR0DvxexjzDG+V5IRmvTphgAdNyuOicaTsUG8VVzM/CxWkkyJDoK9HIhj2K66VtWBt3VTSIT53lOD9RpLZUXwnV3+r+BDm/q1Nv+2NOSNCiYkXsKoDUAwhmeHytElE6iSALPp+mRLJqdM0nboZWT/CoLUKzP3k2gzNxaFNBOuZ2hgi+E5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(136003)(346002)(376002)(83380400001)(2906002)(36756003)(316002)(2616005)(186003)(54906003)(110136005)(6486002)(4326008)(16526019)(66946007)(8676002)(1076003)(5660300002)(26005)(69590400012)(86362001)(103116003)(8936002)(107886003)(6512007)(6506007)(6666004)(478600001)(956004)(52116002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GhAt6oSfl0Ddk+7Pae87fxBy4Vvki+CxmDpI5ow1AHnLOaOnofiuNkDBNy3Q?=
 =?us-ascii?Q?AHYuVGNN1nXGhjM6foP7PckpyDiA0N9eowy5L9sBGOzwv8EUGGEBEEuPzwlj?=
 =?us-ascii?Q?3oOSI7VtV5tnmwdgIsHy5PAN2YTa5aMOeNDcBxi9BRvFFk+r4TFFXBhfRG4L?=
 =?us-ascii?Q?GQ8L5NOwaBnu4x4XIZ8hnDtsQLJGYT6oPFWye/cqFpg9dMWpv9GOVWMB+WdG?=
 =?us-ascii?Q?ic+ZagH1RswzW6u/6OJbs/ZqfuRduu5Ze2zYwJiIq7UmoUXy48YullsEGPrq?=
 =?us-ascii?Q?7VcNNHPUJEg7grsr/zpYMIiCUwIoiiyVIXfc9ct0qWmsMBhAA5EqNygJcKUw?=
 =?us-ascii?Q?drl4AjWQkDd6eqPpSAG0yGGHEMne3MdurwICbJ3cMD23V8DDMU4S4DzTjp7g?=
 =?us-ascii?Q?yFZmZJBRju87nd8qRGOsGODLig8LXdnLcb0ma39ybNUSU5UgiiYghB04HrbA?=
 =?us-ascii?Q?Y0CTQUq/20OZSkfgqDN6LNo9R/vXiI4pCeJ4aW79Hkum6TE0WVdMaoG3b7Dl?=
 =?us-ascii?Q?6UCuvU7HMHB9gGYbex3J3zFkXYstW/WMoLV9ij0i+Y3V2jQ+q8Q58OTAQIvq?=
 =?us-ascii?Q?1ODWYutavk+Do4pPXYyGjh41corSeZI+gpzggefANw1kwy3v2TyVxwoy3cSC?=
 =?us-ascii?Q?hIbb9x9LuuW0MbELgxNTyIOkx2vXvb+Jbiw/CEsmpntaGtB29Zu7A2dPPQBv?=
 =?us-ascii?Q?5PajH2+BG3JFiLbwZseba3AJNtcLG0JeQXrCmkPW69wxEmZWgO9ruaeV84vX?=
 =?us-ascii?Q?azlYPP7WLg8a/mQLXl8eJfl1LbqJAeCokqXg4ML0zolsMiBE0Gz4xm4uO8zE?=
 =?us-ascii?Q?zBhgbR+lNubdZ9lATycfCr9gHelV4wiIdS1kxGCo41BhYTl0/uo70ur8SNgP?=
 =?us-ascii?Q?VYS+h0VvPV5XETK+ZHnBUzRbM+gp88rFxNtk2nc6I59wzkfkDjxt7N2fUe3x?=
 =?us-ascii?Q?lu4PRZGHnioIXGlPTK12j0q3jkhR12oyU4z7gzCWEaVxU745AJTW+16ZS7Dy?=
 =?us-ascii?Q?laImCzAiGUHUO9aidqMoLj6AkQs/yQ+MJT7vr36mbQu0+qIl3D2yLuTnonbf?=
 =?us-ascii?Q?x522GLgZxA2OimWpPEYGkKLuI/h1zR3t6ChBk+OiwRTSuRlpYjZkbrS/wz0I?=
 =?us-ascii?Q?aGmn1eQakxP8eCOAU26QDTTWScK1u2g6KekaXzXOvHv4ZAF40HLrr5N3y7Ze?=
 =?us-ascii?Q?kUOoSo+4GtDblRSXqa3t9426PXnFhpy1iiXv6fplMbtJ9vhq+tO6YBQIvo1B?=
 =?us-ascii?Q?f/3/vC5ap/SNlEtl3gwXlDvNbxggBa9iQ7+biLzVQ31b+YkDKQqnnuw5vJvC?=
 =?us-ascii?Q?v4ZXvvLZxZh1XxnPiP1owWvs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f1999e2-4ce9-4281-20ac-08d8d4f1481b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 16:13:23.8847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Ln290VfWfJ0iIDJKQMIO2sYq4itId/Q8yFg0a59qKF+hHAUKzK7SBceAyxV/SxYCT239bVcJpM/1n/rHS/AflUaCmFJzELlvjZ3nGLXtkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1662
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190127
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pinning one 4K page at a time is inefficient, so do it in batches of 512
instead.  This is just an optimization with no functional change
intended, and in particular the driver still calls iommu_map() with the
largest physically contiguous range possible.

Add two fields in vfio_batch to remember where to start between calls to
vfio_pin_pages_remote(), and use vfio_batch_unpin() to handle remaining
pages in the batch in case of error.

qemu pins pages for guests around 8% faster on my test system, a
two-node Broadwell server with 128G memory per node.  The qemu process
was bound to one node with its allocations constrained there as well.

                             base               test
          guest              ----------------   ----------------
       mem (GB)   speedup    avg sec    (std)   avg sec    (std)
              1      7.4%       0.61   (0.00)      0.56   (0.00)
              2      8.3%       0.93   (0.00)      0.85   (0.00)
              4      8.4%       1.46   (0.00)      1.34   (0.00)
              8      8.6%       2.54   (0.01)      2.32   (0.00)
             16      8.3%       4.66   (0.00)      4.27   (0.01)
             32      8.3%       8.94   (0.01)      8.20   (0.01)
             64      8.2%      17.47   (0.01)     16.04   (0.03)
            120      8.5%      32.45   (0.13)     29.69   (0.01)

perf diff confirms less time spent in pup.  Here are the top ten
functions:

             Baseline  Delta Abs  Symbol

               78.63%     +6.64%  clear_page_erms
                1.50%     -1.50%  __gup_longterm_locked
                1.27%     -0.78%  __get_user_pages
                          +0.76%  kvm_zap_rmapp.constprop.0
                0.54%     -0.53%  vmacache_find
                0.55%     -0.51%  get_pfnblock_flags_mask
                0.48%     -0.48%  __get_user_pages_remote
                          +0.39%  slot_rmap_walk_next
                          +0.32%  vfio_pin_map_dma
                          +0.26%  kvm_handle_hva_range
                ...

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 135 +++++++++++++++++++++-----------
 1 file changed, 89 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b7247a2fc87e..cec2083dd556 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -107,6 +107,8 @@ struct vfio_batch {
 	struct page		**pages;	/* for pin_user_pages_remote */
 	struct page		*fallback_page; /* if pages alloc fails */
 	int			capacity;	/* length of pages array */
+	int			size;		/* of batch currently */
+	int			offset;		/* of next entry in pages */
 };
 
 struct vfio_group {
@@ -469,6 +471,9 @@ static int put_pfn(unsigned long pfn, int prot)
 
 static void vfio_batch_init(struct vfio_batch *batch)
 {
+	batch->size = 0;
+	batch->offset = 0;
+
 	if (unlikely(disable_hugepages))
 		goto fallback;
 
@@ -484,6 +489,17 @@ static void vfio_batch_init(struct vfio_batch *batch)
 	batch->capacity = 1;
 }
 
+static void vfio_batch_unpin(struct vfio_batch *batch, struct vfio_dma *dma)
+{
+	while (batch->size) {
+		unsigned long pfn = page_to_pfn(batch->pages[batch->offset]);
+
+		put_pfn(pfn, dma->prot);
+		batch->offset++;
+		batch->size--;
+	}
+}
+
 static void vfio_batch_fini(struct vfio_batch *batch)
 {
 	if (batch->capacity == VFIO_BATCH_MAX_CAPACITY)
@@ -625,65 +641,88 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
 				  unsigned long limit, struct vfio_batch *batch)
 {
-	unsigned long pfn = 0;
+	unsigned long pfn;
+	struct mm_struct *mm = current->mm;
 	long ret, pinned = 0, lock_acct = 0;
 	bool rsvd;
 	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
 
 	/* This code path is only user initiated */
-	if (!current->mm)
+	if (!mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, pfn_base,
-			     batch->pages);
-	if (ret < 0)
-		return ret;
-
-	pinned++;
-	rsvd = is_invalid_reserved_pfn(*pfn_base);
-
-	/*
-	 * Reserved pages aren't counted against the user, externally pinned
-	 * pages are already counted against the user.
-	 */
-	if (!rsvd && !vfio_find_vpfn(dma, iova)) {
-		if (!dma->lock_cap && current->mm->locked_vm + 1 > limit) {
-			put_pfn(*pfn_base, dma->prot);
-			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n", __func__,
-					limit << PAGE_SHIFT);
-			return -ENOMEM;
-		}
-		lock_acct++;
+	if (batch->size) {
+		/* Leftover pages in batch from an earlier call. */
+		*pfn_base = page_to_pfn(batch->pages[batch->offset]);
+		pfn = *pfn_base;
+		rsvd = is_invalid_reserved_pfn(*pfn_base);
+	} else {
+		*pfn_base = 0;
 	}
 
-	if (unlikely(disable_hugepages))
-		goto out;
+	while (npage) {
+		if (!batch->size) {
+			/* Empty batch, so refill it. */
+			long req_pages = min_t(long, npage, batch->capacity);
 
-	/* Lock all the consecutive pages from pfn_base */
-	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
-	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
-		ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, &pfn,
-				     batch->pages);
-		if (ret < 0)
-			break;
+			ret = vaddr_get_pfns(mm, vaddr, req_pages, dma->prot,
+					     &pfn, batch->pages);
+			if (ret < 0)
+				goto unpin_out;
 
-		if (pfn != *pfn_base + pinned ||
-		    rsvd != is_invalid_reserved_pfn(pfn)) {
-			put_pfn(pfn, dma->prot);
-			break;
+			batch->size = ret;
+			batch->offset = 0;
+
+			if (!*pfn_base) {
+				*pfn_base = pfn;
+				rsvd = is_invalid_reserved_pfn(*pfn_base);
+			}
 		}
 
-		if (!rsvd && !vfio_find_vpfn(dma, iova)) {
-			if (!dma->lock_cap &&
-			    current->mm->locked_vm + lock_acct + 1 > limit) {
-				put_pfn(pfn, dma->prot);
-				pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
-					__func__, limit << PAGE_SHIFT);
-				ret = -ENOMEM;
-				goto unpin_out;
+		/*
+		 * pfn is preset for the first iteration of this inner loop and
+		 * updated at the end to handle a VM_PFNMAP pfn.  In that case,
+		 * batch->pages isn't valid (there's no struct page), so allow
+		 * batch->pages to be touched only when there's more than one
+		 * pfn to check, which guarantees the pfns are from a
+		 * !VM_PFNMAP vma.
+		 */
+		while (true) {
+			if (pfn != *pfn_base + pinned ||
+			    rsvd != is_invalid_reserved_pfn(pfn))
+				goto out;
+
+			/*
+			 * Reserved pages aren't counted against the user,
+			 * externally pinned pages are already counted against
+			 * the user.
+			 */
+			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
+				if (!dma->lock_cap &&
+				    mm->locked_vm + lock_acct + 1 > limit) {
+					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
+						__func__, limit << PAGE_SHIFT);
+					ret = -ENOMEM;
+					goto unpin_out;
+				}
+				lock_acct++;
 			}
-			lock_acct++;
+
+			pinned++;
+			npage--;
+			vaddr += PAGE_SIZE;
+			iova += PAGE_SIZE;
+			batch->offset++;
+			batch->size--;
+
+			if (!batch->size)
+				break;
+
+			pfn = page_to_pfn(batch->pages[batch->offset]);
 		}
+
+		if (unlikely(disable_hugepages))
+			break;
 	}
 
 out:
@@ -691,10 +730,11 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 
 unpin_out:
 	if (ret < 0) {
-		if (!rsvd) {
+		if (pinned && !rsvd) {
 			for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
 				put_pfn(pfn, dma->prot);
 		}
+		vfio_batch_unpin(batch, dma);
 
 		return ret;
 	}
@@ -1453,6 +1493,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		if (ret) {
 			vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
 						npage, true);
+			vfio_batch_unpin(&batch, dma);
 			break;
 		}
 
@@ -1716,11 +1757,13 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			ret = iommu_map(domain->domain, iova, phys,
 					size, dma->prot | domain->prot);
 			if (ret) {
-				if (!dma->iommu_mapped)
+				if (!dma->iommu_mapped) {
 					vfio_unpin_pages_remote(dma, iova,
 							phys >> PAGE_SHIFT,
 							size >> PAGE_SHIFT,
 							true);
+					vfio_batch_unpin(&batch, dma);
+				}
 				goto unwind;
 			}
 
-- 
2.30.1

