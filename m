Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83902816F7
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388058AbgJBPoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:44:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387777AbgJBPoa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:44:30 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092FVTw6109057
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=99VxAMhjIlbO8ommuZ8vYILz5NGD6QmMGy+OtreF4NE=;
 b=GkC8QdDcbpq8D9LSkMiB/EjdmhlWlibe37T0jpmBIYKLaMmr4xhJlBFXWKGZKBLPnV9+
 giRgkVb9+vkYdoe1IvFKjVBFm8q0bjmKlcj8Fd1RtqsnZXhEThbzdXUI+MNvGeuDw60z
 flh5EfA4ei8gQtVh+4YJCDjEwGHIa2M/xhvxrd0vpz2oe138WHjHO/68eFl1s3kdHYk6
 cECkazd3Hd0tgOVLsMRgjhrIgA1bOXCQoU2g43kPJDlGSFCb6MWnHNfnTzbn2WfNjzwX
 FSYZ9r1DVozD5tYQKO6gS1qXW+V0lJrj2ptQdQU/3EZJ5RwBfZ9FPimU/vz0ZPuFibFj JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33x6cbshqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 11:44:29 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092FiS5a144801
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:28 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33x6cbshq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:44:28 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092Fh2GG031064;
        Fri, 2 Oct 2020 15:44:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97xqj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:44:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092FiOAX31981926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:44:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD7B742047;
        Fri,  2 Oct 2020 15:44:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BCF042041;
        Fri,  2 Oct 2020 15:44:24 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.90])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:44:24 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 7/7] lib/alloc_page: allow reserving arbitrary memory ranges
Date:   Fri,  2 Oct 2020 17:44:20 +0200
Message-Id: <20201002154420.292134-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002154420.292134-1-imbrenda@linux.ibm.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020119
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
index 6c23018..816ff5d 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -75,4 +75,19 @@ static inline void free_pages_by_order(void *mem, unsigned int order)
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
index 3c6c4ee..d9665a4 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -23,13 +23,14 @@
 
 #define ORDER_MASK	0x3f
 #define ALLOC_MASK	0x40
+#define SPECIAL_MASK	0x80
 
 struct mem_area {
 	/* Physical frame number of the first usable frame in the area */
 	uintptr_t base;
 	/* Physical frame number of the first frame outside the area */
 	uintptr_t top;
-	/* Combination ALLOC_MASK and order */
+	/* Combination of SPECIAL_MASK, ALLOC_MASK, and order */
 	u8 *page_states;
 	/* One freelist for each possible block size, up to NLISTS */
 	struct linked_list freelists[NLISTS];
@@ -136,6 +137,16 @@ static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
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
@@ -210,10 +221,7 @@ static void _free_pages(void *mem)
 	assert(IS_ALIGNED((uintptr_t)mem, PAGE_SIZE));
 
 	/* find which area this pointer belongs to*/
-	for (i = 0; !a && (i < MAX_AREAS); i++) {
-		if ((areas_mask & BIT(i)) && area_contains(areas + i, pfn))
-			a = areas + i;
-	}
+	a = get_area(pfn);
 	assert_msg(a, "memory does not belong to any area: %p", mem);
 
 	p = pfn - a->base;
@@ -262,6 +270,66 @@ void free_pages(void *mem)
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

