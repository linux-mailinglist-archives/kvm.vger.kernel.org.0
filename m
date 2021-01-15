Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229EA2F79EB
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388170AbhAOMi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:38:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387511AbhAOMiZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:38:25 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCVnn5143999;
        Fri, 15 Jan 2021 07:37:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EOlOoWT2raHD1+EscM9RXvmuhF3b3l+vzFFX3f8lKzI=;
 b=lCq5MQxlJhV3Bp5E1JpDoId6XfaVx11kJlNQWCz8cMuNshzVefvYhdWipMGSV2tr/s1A
 Hma5R3Qx5EniJL4xY2PdgBVxwCq2PMUmV8qKlxJA4of+qtM0Eo7SW7x0tTfB3zZB8LdJ
 0xLBKpEDrRyhIThIwwYAjpfsM8Ng2G3N9DIenD/FwbNr4TxOw+V2nw9jLhFrVqccKqqI
 raxZzvkom6emOLRwd3wZPIpVf2yebxmjz+HH3u1mFmHLyohngC5gUhDeRYV8RJqzMVMB
 MMVywbJVRc2/H1ji6yC8HOa6LHtADj6BxvMW7ELKUEaB3V8v5rNM6BzoENg0E2P/2Hd+ 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 363a3qt3u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:40 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCVxKj144684;
        Fri, 15 Jan 2021 07:37:40 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 363a3qt3td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:40 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FCbcbk021963;
        Fri, 15 Jan 2021 12:37:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 35y448kyek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbUiV20971936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1C71AE045;
        Fri, 15 Jan 2021 12:37:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90763AE051;
        Fri, 15 Jan 2021 12:37:35 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:35 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 08/11] lib/alloc_page: rework metadata format
Date:   Fri, 15 Jan 2021 13:37:27 +0100
Message-Id: <20210115123730.381612-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 impostorscore=0 adultscore=0 suspectscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch changes the format of the metadata so that the metadata is
now a 2-bit field instead of two separate flags.

This allows to have 4 different states for memory:

STATUS_FRESH: the memory is free and has not been touched at all since
              boot (not even read from!)
STATUS_FREE: the memory is free, but it is probably not fresh any more
STATUS_ALLOCATED: the memory has been allocated and is in use
STATUS_SPECIAL: the memory has been removed from the pool of allocated
                memory for some kind of special purpose according to
                the needs of the caller

Some macros are also introduced to test the status of a specific
metadata item.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/alloc_page.c | 49 +++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 37f28ce..d8b2758 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -18,9 +18,20 @@
 #define IS_ALIGNED_ORDER(x,order) IS_ALIGNED((x),BIT_ULL(order))
 #define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
 
-#define ORDER_MASK	0x3f
-#define ALLOC_MASK	0x40
-#define SPECIAL_MASK	0x80
+#define ORDER_MASK		0x3f
+#define STATUS_MASK		0xc0
+
+#define STATUS_FRESH		0x00
+#define STATUS_FREE		0x40
+#define STATUS_ALLOCATED	0x80
+#define STATUS_SPECIAL		0xc0
+
+#define IS_FRESH(x)	(((x) & STATUS_MASK) == STATUS_FRESH)
+#define IS_FREE(x)	(((x) & STATUS_MASK) == STATUS_FREE)
+#define IS_ALLOCATED(x)	(((x) & STATUS_MASK) == STATUS_ALLOCATED)
+#define IS_SPECIAL(x)	(((x) & STATUS_MASK) == STATUS_SPECIAL)
+
+#define IS_USABLE(x)	(IS_FREE(x) || IS_FRESH(x))
 
 typedef phys_addr_t pfn_t;
 
@@ -87,14 +98,14 @@ static inline bool usable_area_contains_pfn(struct mem_area *a, pfn_t pfn)
  */
 static void split(struct mem_area *a, void *addr)
 {
-	pfn_t pfn = virt_to_pfn(addr);
-	pfn_t i, idx;
-	u8 order;
+	pfn_t i, idx, pfn = virt_to_pfn(addr);
+	u8 metadata, order;
 
 	assert(a && usable_area_contains_pfn(a, pfn));
 	idx = pfn - a->base;
-	order = a->page_states[idx];
-	assert(!(order & ~ORDER_MASK) && order && (order < NLISTS));
+	metadata = a->page_states[idx];
+	order = metadata & ORDER_MASK;
+	assert(IS_USABLE(metadata) && order && (order < NLISTS));
 	assert(IS_ALIGNED_ORDER(pfn, order));
 	assert(usable_area_contains_pfn(a, pfn + BIT(order) - 1));
 
@@ -103,8 +114,8 @@ static void split(struct mem_area *a, void *addr)
 
 	/* update the block size for each page in the block */
 	for (i = 0; i < BIT(order); i++) {
-		assert(a->page_states[idx + i] == order);
-		a->page_states[idx + i] = order - 1;
+		assert(a->page_states[idx + i] == metadata);
+		a->page_states[idx + i] = metadata - 1;
 	}
 	if ((order == a->max_order) && (is_list_empty(a->freelists + order)))
 		a->max_order--;
@@ -149,7 +160,7 @@ static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
 		split(a, p);
 
 	list_remove(p);
-	memset(a->page_states + (virt_to_pfn(p) - a->base), ALLOC_MASK | order, BIT(order));
+	memset(a->page_states + (virt_to_pfn(p) - a->base), STATUS_ALLOCATED | order, BIT(order));
 	return p;
 }
 
@@ -243,7 +254,7 @@ static void _free_pages(void *mem)
 	order = a->page_states[p] & ORDER_MASK;
 
 	/* ensure that the first page is allocated and not special */
-	assert(a->page_states[p] == (order | ALLOC_MASK));
+	assert(IS_ALLOCATED(a->page_states[p]));
 	/* ensure that the order has a sane value */
 	assert(order < NLISTS);
 	/* ensure that the block is aligned properly for its size */
@@ -253,9 +264,9 @@ static void _free_pages(void *mem)
 
 	for (i = 0; i < BIT(order); i++) {
 		/* check that all pages of the block have consistent metadata */
-		assert(a->page_states[p + i] == (ALLOC_MASK | order));
+		assert(a->page_states[p + i] == (STATUS_ALLOCATED | order));
 		/* set the page as free */
-		a->page_states[p + i] &= ~ALLOC_MASK;
+		a->page_states[p + i] = STATUS_FREE | order;
 	}
 	/* provisionally add the block to the appropriate free list */
 	list_add(a->freelists + order, mem);
@@ -294,13 +305,13 @@ static int _reserve_one_page(pfn_t pfn)
 	if (!a)
 		return -1;
 	i = pfn - a->base;
-	if (a->page_states[i] & (ALLOC_MASK | SPECIAL_MASK))
+	if (!IS_USABLE(a->page_states[i]))
 		return -1;
 	while (a->page_states[i]) {
 		mask = GENMASK_ULL(63, a->page_states[i]);
 		split(a, pfn_to_virt(pfn & mask));
 	}
-	a->page_states[i] = SPECIAL_MASK;
+	a->page_states[i] = STATUS_SPECIAL;
 	return 0;
 }
 
@@ -312,8 +323,8 @@ static void _unreserve_one_page(pfn_t pfn)
 	a = get_area(pfn);
 	assert(a);
 	i = pfn - a->base;
-	assert(a->page_states[i] == SPECIAL_MASK);
-	a->page_states[i] = ALLOC_MASK;
+	assert(a->page_states[i] == STATUS_SPECIAL);
+	a->page_states[i] = STATUS_ALLOCATED;
 	_free_pages(pfn_to_virt(pfn));
 }
 
@@ -477,7 +488,7 @@ static void _page_alloc_init_area(u8 n, pfn_t start_pfn, pfn_t top_pfn)
 			order++;
 		assert(order < NLISTS);
 		/* initialize the metadata and add to the freelist */
-		memset(a->page_states + (i - a->base), order, BIT(order));
+		memset(a->page_states + (i - a->base), STATUS_FRESH | order, BIT(order));
 		list_add(a->freelists + order, pfn_to_virt(i));
 		if (order > a->max_order)
 			a->max_order = order;
-- 
2.26.2

