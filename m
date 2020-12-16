Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042B62DC790
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgLPUNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:13:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46276 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728734AbgLPUNL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:13:11 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK2s3H181080
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oFWHbR0tiNt/LYHoCfUszl+cnuJC8+R0h0RnvFHg/vM=;
 b=UAdJ4Sn8BeVjKK9Hbz61E0xD50HLmq4n6ULYzXk4fgZ80NrRYT0i3ZIRVcapiAkNjG3s
 B0Q2Tc+jsoY9dcaRNthbIpn39jjPFfUxmSjYYkCvYiU7vIDf3kj2CYlLxz91RQJnkd6t
 AWMPMazAdlM0TvALcnQGoPqnBmbZVGSAtI+MkyeTVAA+3NQQVGvQuZEccTY+pRvJCPum
 JhtPA7+W2o6CdWstRP9Hq6mQO8BMMgROOnsnR6qirgHhJ7i2ZEYi32NL1lNxovBbtc9f
 IYODnawvGbUruaMnylUXyUlL+3h/PgKyaV7RRBTYSwOxafQ2cRX0C8gicVpVs4zMhu0C ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35frs78fqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:30 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK35dv181588
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:29 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35frs78fpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:12:29 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK8h0K021154;
        Wed, 16 Dec 2020 20:12:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 35cng8cmmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:12:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCPUB33358134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8232D42042;
        Wed, 16 Dec 2020 20:12:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A0D042049;
        Wed, 16 Dec 2020 20:12:25 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 11/12] lib/alloc_page: Properly handle requests for fresh blocks
Date:   Wed, 16 Dec 2020 21:11:59 +0100
Message-Id: <20201216201200.255172-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160124
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
---
 lib/alloc_page.c | 51 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 8c79202..4d5722f 100644
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
 
@@ -364,13 +392,14 @@ void free_pages_special(phys_addr_t addr, size_t n)
 static void *page_memalign_order_flags(u8 ord, u8 al, u32 flags)
 {
 	void *res = NULL;
-	int i, area;
+	int i, area, fresh;
 
+	fresh = !!(flags & FLAG_FRESH);
 	spin_lock(&lock);
 	area = (flags & AREA_MASK) ? flags & areas_mask : areas_mask;
 	for (i = 0; !res && (i < MAX_AREAS); i++)
 		if (area & BIT(i))
-			res = page_memalign_order(areas + i, ord, al);
+			res = page_memalign_order(areas + i, ord, al, fresh);
 	spin_unlock(&lock);
 	if (res && (flags & FLAG_ZERO))
 		memset(res, 0, BIT(ord) * PAGE_SIZE);
-- 
2.26.2

