Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2DA30E446
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 21:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhBCUwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 15:52:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbhBCUtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:49:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113KeFL7119281;
        Wed, 3 Feb 2021 20:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=x1HsHGHBL4DZdlrq2nrVX7p/QFdq5VzZ4UU2FXa3U+g=;
 b=SXIGUTwuXK+NMC/dz1IImi306/y2haSmLPbY1Iu+S5+7/IhgOBZVXpEKYJGemLWF9HHA
 9UWrBNNbJj/mPtjIzx1k4Fgfl/bLtAraakVt2L25x0amsGRnyGUmdyfc3Dqnyvb21Wzz
 MWftzJI/aeVJWehap9vpILAN8VPA1+tjcfZLZ6NscrBg8ciHaWuBY+pzKh1TrAD9JJED
 W2hBzmt9nz2fgQhfXrZAai1CFlbtjxh+uBpvo7+XrUs1bJueUWxLOm1IWAhnpNPYM7yY
 fSiC+uJ7Nn7zKomgJF3YPM4T/4ry7QA9IyTAaahgm8N6USJ0fi+DBkLTiv1eGKRVpRD3 bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36cxvr4wuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 20:48:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113KkHko169343;
        Wed, 3 Feb 2021 20:48:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by userp3020.oracle.com with ESMTP id 36dh7u4fjv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 20:48:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVLZj+1qhIj3Y61wEb2u/UhrBvO9VGh14uK+V6ASbMDuEMYrKBRW0IGNE2PgMYwYOiHL3waaaRhWsd2BMyUm9eCQG7Un3749bsJt4FTFIApVkp1WP//5SWgtxfSiR5WHvXEjj5dVjUKASfqQGB28eY1gFs+1bacU1TrLQnokBty0ONg0v3/rKtaW90xaPhEHFjD/t1JJmDou2TA7T6N4N321ideiINx0gasK4vEEdos44IMoOgDnHLHQN3mJr+PppDNhWgWuvgDRClhbw1GjPE5pQggLxMWjBYYAbTmRxowOFzKJNc5TAa9FvwN3iptjdySMX1BGxBJVGihyo18TpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1HsHGHBL4DZdlrq2nrVX7p/QFdq5VzZ4UU2FXa3U+g=;
 b=neL0OcvsLNCmy3FZhL9rOqnANE4wNa+4mE7LaNWm/vSzTGjxklFdoQmWecPTBkjzH2PRGwgWvTQtkOkKPEAuqMTyXAyG+sgefD9fFOQcO3SrWFT1+q+2J/jiz3vUIxkUXKZgynshNzUkcMamiIVal1FDdGLyFu63k/RkySNqAKhUAKXdk6CQC15w18VaDa+C1Dr4zemIZktF/6cJ+QrQVk5YIp9Bs7T1C9tFDcsTAUZ4oJfU5kFEld5xZDAfR1SP8mFgHu8fANV67iYNqbQXwpy4rMBll95AuGdr1NeXtwRlvFkbZfwVOQSpwGZ9L68RbkiBFEKDRs32JWLPoIFxAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1HsHGHBL4DZdlrq2nrVX7p/QFdq5VzZ4UU2FXa3U+g=;
 b=IEJoW0k0UV2aYgAbwqxdgEhE1/tCvdPK7e2MuNavaBIaSsdUhP4mL1LFiKne8Q+Y34Nzk/dxNYHcEx1n8/+5TswOKrz6QhY6sHvm+3IgfVUEG5xcqkKclA3uyfGYc1yrZSmGLwBBtKU4cMhO5XzY3Tz2HmFPrvz829WoLx7vEtk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by CO1PR10MB4691.namprd10.prod.outlook.com (2603:10b6:303:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 3 Feb
 2021 20:48:16 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3805.027; Wed, 3 Feb 2021
 20:48:16 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 3/3] vfio/type1: batch page pinning
Date:   Wed,  3 Feb 2021 15:47:56 -0500
Message-Id: <20210203204756.125734-4-daniel.m.jordan@oracle.com>
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
Received: from localhost.localdomain (98.229.125.203) by BL1PR13CA0215.namprd13.prod.outlook.com (2603:10b6:208:2bf::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 20:48:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06b395ec-4776-459f-33e6-08d8c88507db
X-MS-TrafficTypeDiagnostic: CO1PR10MB4691:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB46914727CA1EE33D13773A91D9B49@CO1PR10MB4691.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1CXpS2wML9GWNaM3s2C/VW2tB5p5Ng6izqmUnvs+NFu1VZkUl9azFoGDIKNHygBr5rfwtgfnqy2fyGgkWENtpyyON150tf54crCX3kjlv2tr7sBc/lVOzPSQenDXoEE+jn7j1DL+PphdTLCLv7yjcsovqpXOiIfi+rZgINMlfv43suI8kv9NClv3czey4dZZwZz2w2xMbGmNxk3w4H+2MBweVsY5JJG1H5UxoGx0N/67kAJryVNcoo2HcH2yMGWG6Rlrj35EBX36sJtYLq0BmWiiKQTo0ZGeCDOciMlr0vxheixWq8YoH9uljZB+awPoeQSVCinAc3vMSNyXcCnLZ++aClCYRlIGES7ZfDGJzrBUPoOtgxmdFdDTrU4FzaMpBHD5QzfMYjb7sB2dUE/Rkt91Njqs4xdXEr2NUJhBdz+jGqaxa+p79QRRksJdAEg/EcNzBz4IJhCENsUNUc1P94A0ULUuBQH3FUDLWbubyxzWDX9zYWsLc5Bpc97Up6RV8qeqVamkcJKJhWcfRikiHdYL6m595991XfFWfvYMiUH39/nTUY8rlodYS1vAtOVlDbnKFt3umog39MCoYs30A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(103116003)(6486002)(478600001)(36756003)(107886003)(4326008)(66946007)(8936002)(1076003)(16526019)(5660300002)(110136005)(54906003)(26005)(186003)(6506007)(69590400011)(52116002)(8676002)(86362001)(83380400001)(316002)(2906002)(6512007)(956004)(66476007)(66556008)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qAtPtSkXG31doFvsdmja6Uxe3HjRhy9RKMLIYQdKqLve2ujYPQVBddJO3brC?=
 =?us-ascii?Q?0u4gyP4FY9GyR4+jXK4aFSstRKFXS16+qnitNbvEjLrmnsT1aHrzCs5o9+15?=
 =?us-ascii?Q?/xWx9E0plMHE1Kkuw9ZTh3+VdlZCjINebrZdACgAoFB5SFeZaCdd0E/zceUI?=
 =?us-ascii?Q?u221ULrYeMfCG6YPNVgWpCRnQ9OSCk2/dhRWADujlz8y9N34oNgvQxujzWw/?=
 =?us-ascii?Q?MLgtloOAjUa0xr2wEcNrVcDnHYEvMmS7fYg1gsXuKV5PKnB7PVTpsb0k6O2h?=
 =?us-ascii?Q?F0z4m63U7bWV9rkRlMzTJm+umBo3v1GUYbEJFJdq/y0o8EynprNHbJAIoOCJ?=
 =?us-ascii?Q?Hws8ss8dYQnvgYJasPxXHDfkCjtZaABYEEdtz9F1n+0BSs7Nsho9Fx1neTWH?=
 =?us-ascii?Q?iBLXngZDYPRCdbFQdZ7KuXm+pESMo6mjbc6Lb5SYin+cbkSiuOhz1YZBE0o6?=
 =?us-ascii?Q?TBxWbtyID9zWYn9ZTTkfqPPSfw0yZv8M4KTIjFK8eFd52HPlLiYr7pu4b9j8?=
 =?us-ascii?Q?x8fMCNekaWN2Bk/jn1R5ZwDOKWIWu3RMl6bCaO6BOmDx822vmIsUJnVlTxTG?=
 =?us-ascii?Q?FNNwNvAwtpQUFZ23cu8eFOTAmYpg2g8J/nJbgUTSXkKw9Zyf3NcVg1LNxRE+?=
 =?us-ascii?Q?aS+u/L73P5TEEcydygJtCEKBZ2IjjurMhP9cQC1pfSi6DMLl+BsTOO9XF8oq?=
 =?us-ascii?Q?or0K4PW14vQYaou5L9miNKT/YS5AQW/Z+NXZC609Q3zzkd4Cl+NzJLRNxyHx?=
 =?us-ascii?Q?OT56rOQe2dQtpB7F0PraGZOgNlJxoXWvZvM6er86vfOF/hVKl+EZUiY8qKEf?=
 =?us-ascii?Q?AprnzgnRFtJVeidPPpxBTkXbXPiSETOPMGhRpI9zxpW3uS59bzEDaOCYfo4d?=
 =?us-ascii?Q?GxV+G/ucKMgBzY+kCfBAOAnsxDT12XXg573Pbuihm8k2KsCYElkn9zmIsvy8?=
 =?us-ascii?Q?/yq0IgOFNKCCv5SWL25BoVNOuMZEILAl9zs6tGpX7ri3XNuvGYzUtKhyu4vB?=
 =?us-ascii?Q?lTkrFQTmB7t7MZw8X3OQuOkBdL1OXpRdv0OZVJDQUbvXqBQ/TwTLNqS2KJmj?=
 =?us-ascii?Q?mqGxVu+g1ttyOR0PJqn1QljMv/vrht7eNoEWyFVh30w5M6eRGUB3bhd9n+jk?=
 =?us-ascii?Q?x99TgMiAsHHPgbSUa3LrNDlLSB7bAWUuSAsYsfhBdGguJc6BbNqlNJ0ZLOf5?=
 =?us-ascii?Q?ulKyyx0XP/IwZTNG7/DnGQrVv4pgljWuMpuunGMJ5pvU0qWw2epLpkpdICFX?=
 =?us-ascii?Q?zL5H7ga7aUiGVSjl33F/GFD3AkD+atPqyMoydob+k4gT+Uus/owRiayZ8pkv?=
 =?us-ascii?Q?N7oyMwvN7LLP0yYmJpTGBZ/D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b395ec-4776-459f-33e6-08d8c88507db
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 20:48:16.3635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivnwRNmVXAI0QlczbKhxhXhKmDEWP80Ikn7VItJ14HixxuAy4cIfs9xuLIUBgzir9pyhS7B0z0btSpqug31WsoSO+7CNcpt6VjFziO989Fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4691
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030124
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030123
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
 drivers/vfio/vfio_iommu_type1.c | 133 +++++++++++++++++++++-----------
 1 file changed, 88 insertions(+), 45 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c26c1a4697e5..ac59bfc4e332 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -101,6 +101,8 @@ struct vfio_batch {
 	struct page		**pages;	/* for pin_user_pages_remote */
 	struct page		*fallback_page; /* if pages alloc fails */
 	int			capacity;	/* length of pages array */
+	int			size;		/* of batch currently */
+	int			offset;		/* of next entry in pages */
 };
 
 struct vfio_group {
@@ -425,6 +427,9 @@ static int put_pfn(unsigned long pfn, int prot)
 
 static void vfio_batch_init(struct vfio_batch *batch)
 {
+	batch->size = 0;
+	batch->offset = 0;
+
 	if (unlikely(disable_hugepages))
 		goto fallback;
 
@@ -440,6 +445,17 @@ static void vfio_batch_init(struct vfio_batch *batch)
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
@@ -526,65 +542,88 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
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
+				return ret;
 
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
@@ -596,6 +635,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
 				put_pfn(pfn, dma->prot);
 		}
+		vfio_batch_unpin(batch, dma);
 
 		return ret;
 	}
@@ -1305,6 +1345,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		if (ret) {
 			vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
 						npage, true);
+			vfio_batch_unpin(&batch, dma);
 			break;
 		}
 
@@ -1546,11 +1587,13 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
2.30.0

