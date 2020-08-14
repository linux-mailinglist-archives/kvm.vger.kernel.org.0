Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7DF244BAC
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 17:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgHNPKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 11:10:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727870AbgHNPKT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Aug 2020 11:10:19 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07EF3jSa182438
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZAumW9o3bK0106HN/bx7SVh1BCRxP5FRqb9yjoqjWsw=;
 b=WK618qisN+x7AEzHt2+BHUqHaXlcPQRwhdOjbQDCd9HdsYH/s1nwDBf7Mir2wE6isq5v
 7NlMdlZ5cQ99Tv9PiJlw2JRCppp+ayovRfusFTCPqE+0TBGCaaUtjw8D963ASH+9Qgb2
 LPiF/xgrnWKLsnlLFJ3/bRXA52TcyJLtGbSCJJWk1AltHsFC60A7PimkYLpC0jjsPNSt
 +18u7wixR4E+a1erkqcqIf8H/X+474Q4PQDrcgzCV0lhfbOru7iluuEvdQAQ4GHVBUXP
 bFb1yiy03+W0LTA1fA/e7RKJbEhFWKspkNZZaajTisMRa1rFaCvpIVoe2lubzct7/t8V xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w4b6hasu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:18 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07EF4CgB183015
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:18 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w4b6har8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 11:10:18 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07EF0vfb011280;
        Fri, 14 Aug 2020 15:10:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 32ws99041v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 15:10:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07EFADUP65995016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 15:10:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4623DA4057;
        Fri, 14 Aug 2020 15:10:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0A21A4051;
        Fri, 14 Aug 2020 15:10:12 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.223])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 15:10:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests RFC v1 5/5] lib/alloc_page: allow reserving arbitrary memory ranges
Date:   Fri, 14 Aug 2020 17:10:09 +0200
Message-Id: <20200814151009.55845-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200814151009.55845-1-imbrenda@linux.ibm.com>
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_09:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 adultscore=0 suspectscore=2 phishscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two new functions are introduced, that allow specific memory ranges to
be reserved and freed.

This is useful when a testcase needs memory at very specific addresses,
with the guarantee that the page allocator will not touch those pages.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.h | 15 ++++++++++
 lib/alloc_page.c | 78 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 26caefe..7010b20 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -76,4 +76,19 @@ static inline void free_pages_by_order(void *mem, unsigned int order)
 	free_pages(mem);
 }
 
+/*
+ * Allocates and reserves the specified memory range if possible.
+ * Returns NULL in case of failure.
+ */
+void *alloc_pages_special(uintptr_t addr, size_t npages);
+
+/*
+ * Frees a reserved memory range that had been reserved with
+ * alloc_pages_special.
+ * The memory range does not need to match a previous allocation
+ * exactly, it can also be a subset, in which case only the specified
+ * pages will be freed and unreserved.
+ */
+void free_pages_special(uintptr_t addr, size_t npages);
+
 #endif
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index d3ade58..1ca905b 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -21,6 +21,7 @@
 
 #define ORDER_MASK	0x3f
 #define ALLOC_MASK	0x40
+#define SPECIAL_MASK	0x80
 
 struct free_list {
 	struct free_list *prev;
@@ -32,7 +33,7 @@ struct mem_area {
 	uintptr_t base;
 	/* Physical frame number of the first frame outside the area */
 	uintptr_t top;
-	/* Combination ALLOC_MASK and order */
+	/* Combination of SPECIAL_MASK, ALLOC_MASK, and order */
 	u8 *page_states;
 	/* One freelist for each possible block size, up to NLISTS */
 	struct free_list freelists[NLISTS];
@@ -166,6 +167,16 @@ static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
 	return res;
 }
 
+static struct mem_area *get_area(uintptr_t pfn)
+{
+	uintptr_t i;
+
+	for (i = 0; i < MAX_AREAS; i++)
+		if ((areas_mask & BIT(i)) && area_contains(areas + i, pfn))
+			return areas + i;
+	return NULL;
+}
+
 /*
  * Try to merge two blocks into a bigger one.
  * Returns true in case of a successful merge.
@@ -233,10 +244,7 @@ static void _free_pages(void *mem)
 	if (!mem)
 		return;
 	assert(IS_ALIGNED((uintptr_t)mem, PAGE_SIZE));
-	for (i = 0; !a && (i < MAX_AREAS); i++) {
-		if ((areas_mask & BIT(i)) && area_contains(areas + i, pfn))
-			a = areas + i;
-	}
+	a = get_area(pfn);
 	assert_msg(a, "memory does not belong to any area: %p", mem);
 
 	p = pfn - a->base;
@@ -267,6 +275,66 @@ void free_pages(void *mem)
 	spin_unlock(&lock);
 }
 
+static void *_alloc_page_special(uintptr_t addr)
+{
+	struct mem_area *a;
+	uintptr_t mask, i;
+
+	a = get_area(PFN(addr));
+	assert(a);
+	i = PFN(addr) - a->base;
+	if (a->page_states[i] & (ALLOC_MASK | SPECIAL_MASK))
+		return NULL;
+	while (a->page_states[i]) {
+		mask = GENMASK_ULL(63, PAGE_SHIFT + a->page_states[i]);
+		split(a, (void *)(addr & mask));
+	}
+	a->page_states[i] = SPECIAL_MASK;
+	return (void *)addr;
+}
+
+static void _free_page_special(uintptr_t addr)
+{
+	struct mem_area *a;
+	uintptr_t i;
+
+	a = get_area(PFN(addr));
+	assert(a);
+	i = PFN(addr) - a->base;
+	assert(a->page_states[i] == SPECIAL_MASK);
+	a->page_states[i] = ALLOC_MASK;
+	_free_pages((void *)addr);
+}
+
+void *alloc_pages_special(uintptr_t addr, size_t n)
+{
+	uintptr_t i;
+
+	assert(IS_ALIGNED(addr, PAGE_SIZE));
+	spin_lock(&lock);
+	for (i = 0; i < n; i++)
+		if (!_alloc_page_special(addr + i * PAGE_SIZE))
+			break;
+	if (i < n) {
+		for (n = 0 ; n < i; n++)
+			_free_page_special(addr + n * PAGE_SIZE);
+		addr = 0;
+	}
+	spin_unlock(&lock);
+	return (void *)addr;
+}
+
+void free_pages_special(uintptr_t addr, size_t n)
+{
+	uintptr_t i;
+
+	assert(IS_ALIGNED(addr, PAGE_SIZE));
+	spin_lock(&lock);
+	for (i = 0; i < n; i++)
+		_free_page_special(addr + i * PAGE_SIZE);
+	spin_unlock(&lock);
+}
+
 static void *page_memalign_order_area(unsigned area, u8 ord, u8 al)
 {
 	void *res = NULL;
-- 
2.26.2

