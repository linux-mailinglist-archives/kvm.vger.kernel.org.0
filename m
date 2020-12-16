Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C212DC78C
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgLPUNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:13:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31388 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728533AbgLPUNJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:13:09 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK6VuC157930
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wVpd1t0ftlLtvfnnG9sLjczal4UvdC4tN6mnpoZX9xQ=;
 b=pCRQlkLFptddF+BMyJi/8G+smQuA48z4eq48hfIM0W50+5BJogw+r0UD4MwsUkTJf31b
 gMrXhMOc+Utuq0S3Nv8v3U+MOFXmjaASTFq4n6V5d2NwKNRrqu899KQ5reoJLdn1wn3F
 yawxro/xAbRUayDbK8vq/4PD2no3LrYsKo9bLMlmLci6xTXRmEF6jYbLKIkf9GjOJQMd
 Y+Ke2nVCKojPVKNz9rpqa8Cia9mfj/Q1GhSUDnN9DU9JmXBQBY/BCfTK8pPGI8QtV9zW
 HuWQ5DeWTrSe4IifI+CZR41FosOFmCx+KJ9gRwKe2xmgJovPMueyPYr2X6UFU3blZiKC 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35frac94hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:28 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK6hBf158625
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:27 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35frac94hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:12:27 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK7Z9u021512;
        Wed, 16 Dec 2020 20:12:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8evjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:12:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCNZ031392144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CFC142042;
        Wed, 16 Dec 2020 20:12:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16B8C4204C;
        Wed, 16 Dec 2020 20:12:23 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 07/12] lib/alloc_page: Optimization to skip known empty freelists
Date:   Wed, 16 Dec 2020 21:11:55 +0100
Message-Id: <20201216201200.255172-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Keep track of the largest block order available in each area, and do not
search past it when looking for free memory.

This will avoid needlessly scanning the freelists for the largest block
orders, which will be empty in most cases.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index b1cdf21..6a76b45 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -31,6 +31,8 @@ struct mem_area {
 	pfn_t top;
 	/* Per page metadata, each entry is a combination *_MASK and order */
 	u8 *page_states;
+	/* Highest block order available in this area */
+	u8 max_order;
 	/* One freelist for each possible block size, up to NLISTS */
 	struct linked_list freelists[NLISTS];
 };
@@ -104,6 +106,8 @@ static void split(struct mem_area *a, void *addr)
 		assert(a->page_states[idx + i] == order);
 		a->page_states[idx + i] = order - 1;
 	}
+	if ((order == a->max_order) && (is_list_empty(a->freelists + order)))
+		a->max_order--;
 	order--;
 	/* add the first half block to the appropriate free list */
 	list_add(a->freelists + order, addr);
@@ -127,13 +131,13 @@ static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
 	order = sz > al ? sz : al;
 
 	/* search all free lists for some memory */
-	for ( ; order < NLISTS; order++) {
+	for ( ; order <= a->max_order; order++) {
 		p = a->freelists[order].next;
 		if (!is_list_empty(p))
 			break;
 	}
 	/* out of memory */
-	if (order >= NLISTS)
+	if (order > a->max_order)
 		return NULL;
 
 	/*
@@ -201,6 +205,8 @@ static bool coalesce(struct mem_area *a, u8 order, pfn_t pfn, pfn_t pfn2)
 	}
 	/* finally add the newly coalesced block to the appropriate freelist */
 	list_add(a->freelists + order + 1, pfn_to_virt(pfn));
+	if (order + 1 > a->max_order)
+		a->max_order = order + 1;
 	return true;
 }
 
@@ -438,6 +444,7 @@ static void _page_alloc_init_area(u8 n, pfn_t start_pfn, pfn_t top_pfn)
 	a->page_states = pfn_to_virt(start_pfn);
 	a->base = start_pfn + table_size;
 	a->top = top_pfn;
+	a->max_order = 0;
 	npages = top_pfn - a->base;
 	assert((a->base - start_pfn) * PAGE_SIZE >= npages);
 
@@ -472,6 +479,8 @@ static void _page_alloc_init_area(u8 n, pfn_t start_pfn, pfn_t top_pfn)
 		/* initialize the metadata and add to the freelist */
 		memset(a->page_states + (i - a->base), order, BIT(order));
 		list_add(a->freelists + order, pfn_to_virt(i));
+		if (order > a->max_order)
+			a->max_order = order;
 	}
 	/* finally mark the area as present */
 	areas_mask |= BIT(n);
-- 
2.26.2

