Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEFF2DC78F
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgLPUNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:13:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728724AbgLPUNK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:13:10 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK4kOO127073
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Aoo4jJ0Vh+3jZT3+Av/NDvrUny4ll0RKxTqBANDA0EI=;
 b=LjLQA4fWteQ+mJ+pcJs8HcFcdAYrpizfafvZZ7N7b0Hf9FLV59BNtBpAXImK+n4PMFZf
 ei7Lduwia5gTE0Jb+cz5GWA+gY31uREAqn5ARwUWtl7hkkJLrQMkTMAEQwbBAhIkAzXL
 m2/00yFzauPzRgSyTOou5ymYgi1AUDr8h6PlzdavPJXIzVBbaUgN09mV1JzB5BO/qS8+
 RK9/jEvAVI6X05tr4XneQysSC1uT9lsJGHageYMxCzUNoGnKkeviI1ey2+s1D4ixFbsn
 HK/I5Y5i9IDhYDJ/75Zz5ESzOFt5Syi0dcFks4x8Ic3p1zVzE5VJcaDNuktkrS1f1FpV dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35frmfrnr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:28 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK5WAr133985
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:28 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35frmfrnqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:12:28 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK8mOT017402;
        Wed, 16 Dec 2020 20:12:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 35cng8adts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:12:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCOEw28901850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3C884204B;
        Wed, 16 Dec 2020 20:12:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9074842047;
        Wed, 16 Dec 2020 20:12:23 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 08/12] lib/alloc_page: rework metadata format
Date:   Wed, 16 Dec 2020 21:11:56 +0100
Message-Id: <20201216201200.255172-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160120
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
---
 lib/alloc_page.c | 49 +++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 6a76b45..dfa43d5 100644
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
@@ -294,13 +305,13 @@ static bool _alloc_page_special(pfn_t pfn)
 	if (!a)
 		return false;
 	i = pfn - a->base;
-	if (a->page_states[i] & (ALLOC_MASK | SPECIAL_MASK))
+	if (!IS_USABLE(a->page_states[i]))
 		return false;
 	while (a->page_states[i]) {
 		mask = GENMASK_ULL(63, a->page_states[i]);
 		split(a, pfn_to_virt(pfn & mask));
 	}
-	a->page_states[i] = SPECIAL_MASK;
+	a->page_states[i] = STATUS_SPECIAL;
 	return true;
 }
 
@@ -312,8 +323,8 @@ static void _free_page_special(pfn_t pfn)
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

