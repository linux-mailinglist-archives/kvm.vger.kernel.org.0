Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DFE2F7A09
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732014AbhAOMoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:44:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732039AbhAOMoQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:44:16 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCHQ78062172;
        Fri, 15 Jan 2021 07:37:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lDrsl4UKieZ2DHQ1tl12vIF5+ujR80MYZZ7g+qq5p/M=;
 b=kJMqkqdQG2/iEWf9zqSc9JacfGORfBwm/bcxacFJCcFFhhUy+3atXPzRxfIGIzTwyjnb
 mpcAKM8TvBvHII7+B0Rllnpd9E3GzQI3eqSj3Hzw1DbRAaadoGj++5hCAyaYR98bD4/3
 RFR6NSRPFWTbOtvQ0tAhBww2DPO0KSVAIYEDC9weYk1DlF/UJkY35nY2XVc/VnSQ3CKb
 Q2WAmmy7ydCzM2kz/cxrjRJX/Nu8gptp1kxp4RGh0ytSovBUaIac5Mlio8QPsK4QRZTV
 BjB4Vb1VWftC4TiNe0UavnwU1UE9UNcbRXDe67f9Hdq/PraOcXNnG1ZA5cbImrKf4BeG Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363ax38gss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:44 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCHvnm064922;
        Fri, 15 Jan 2021 07:37:43 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363ax38gqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:43 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FCbe4U032468;
        Fri, 15 Jan 2021 12:37:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 361wgq9gcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbWWs34013542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91F09AE045;
        Fri, 15 Jan 2021 12:37:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D54AAE056;
        Fri, 15 Jan 2021 12:37:37 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:37 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 11/11] lib/alloc_page: Properly handle requests for fresh blocks
Date:   Fri, 15 Jan 2021 13:37:30 +0100
Message-Id: <20210115123730.381612-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon initialization, all memory in an area is marked as fresh. Once
memory is used and freed, the freed memory is marked as free.

Free memory is always appended to the front of the freelist, meaning
that fresh memory stays on the tail.

When a block of fresh memory is split, the two blocks are put on the
tail of the appropriate freelist, so they can be found when needed.

When a fresh block is requested, a fresh block one order bigger is
taken, the first half is put back in the free pool (on the tail), and
the second half is returned. The reason behind this is that the first
page of every block always contains the pointers of the freelist.
Since the first page of a fresh block is actually not fresh, it cannot
be returned when a fresh allocation is requested.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/alloc_page.c | 51 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 95d957b..84f01e1 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -120,10 +120,17 @@ static void split(struct mem_area *a, void *addr)
 	if ((order == a->max_order) && (is_list_empty(a->freelists + order)))
 		a->max_order--;
 	order--;
-	/* add the first half block to the appropriate free list */
-	list_add(a->freelists + order, addr);
-	/* add the second half block to the appropriate free list */
-	list_add(a->freelists + order, pfn_to_virt(pfn + BIT(order)));
+
+	/* add the two half blocks to the appropriate free list */
+	if (IS_FRESH(metadata)) {
+		/* add to the tail if the blocks are fresh */
+		list_add_tail(a->freelists + order, addr);
+		list_add_tail(a->freelists + order, pfn_to_virt(pfn + BIT(order)));
+	} else {
+		/* add to the front if the blocks are dirty */
+		list_add(a->freelists + order, addr);
+		list_add(a->freelists + order, pfn_to_virt(pfn + BIT(order)));
+	}
 }
 
 /*
@@ -132,21 +139,33 @@ static void split(struct mem_area *a, void *addr)
  *
  * Both parameters must be not larger than the largest allowed order
  */
-static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
+static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz, bool fresh)
 {
 	struct linked_list *p;
+	pfn_t idx;
 	u8 order;
 
 	assert((al < NLISTS) && (sz < NLISTS));
 	/* we need the bigger of the two as starting point */
 	order = sz > al ? sz : al;
+	/*
+	 * we need to go one order up if we want a completely fresh block,
+	 * since the first page contains the freelist pointers, and
+	 * therefore it is always dirty
+	 */
+	order += fresh;
 
 	/* search all free lists for some memory */
 	for ( ; order <= a->max_order; order++) {
-		p = a->freelists[order].next;
-		if (!is_list_empty(p))
-			break;
+		p = fresh ? a->freelists[order].prev : a->freelists[order].next;
+		if (is_list_empty(p))
+			continue;
+		idx = virt_to_pfn(p) - a->base;
+		if (fresh && !IS_FRESH(a->page_states[idx]))
+			continue;
+		break;
 	}
+
 	/* out of memory */
 	if (order > a->max_order)
 		return NULL;
@@ -160,7 +179,16 @@ static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
 		split(a, p);
 
 	list_remove(p);
-	memset(a->page_states + (virt_to_pfn(p) - a->base), STATUS_ALLOCATED | order, BIT(order));
+	/* We now have a block twice the size, but the first page is dirty. */
+	if (fresh) {
+		order--;
+		/* Put back the first (partially dirty) half of the block */
+		memset(a->page_states + idx, STATUS_FRESH | order, BIT(order));
+		list_add_tail(a->freelists + order, p);
+		idx += BIT(order);
+		p = pfn_to_virt(a->base + idx);
+	}
+	memset(a->page_states + idx, STATUS_ALLOCATED | order, BIT(order));
 	return p;
 }
 
@@ -364,13 +392,14 @@ void unreserve_pages(phys_addr_t addr, size_t n)
 static void *page_memalign_order_flags(u8 al, u8 ord, u32 flags)
 {
 	void *res = NULL;
-	int i, area;
+	int i, area, fresh;
 
+	fresh = !!(flags & FLAG_FRESH);
 	spin_lock(&lock);
 	area = (flags & AREA_MASK) ? flags & areas_mask : areas_mask;
 	for (i = 0; !res && (i < MAX_AREAS); i++)
 		if (area & BIT(i))
-			res = page_memalign_order(areas + i, al, ord);
+			res = page_memalign_order(areas + i, al, ord, fresh);
 	spin_unlock(&lock);
 	if (res && !(flags & FLAG_DONTZERO))
 		memset(res, 0, BIT(ord) * PAGE_SIZE);
-- 
2.26.2

