Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBEA244BAA
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 17:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgHNPKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 11:10:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19342 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbgHNPKS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Aug 2020 11:10:18 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07EF3SQk028132
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w8meVLNey0xASmxau/J9RSSC9HDR0GHF1RCuhf2tWXk=;
 b=CMLVI04XT4BCDjkQQyUWR5CC3wcBs4ya5c/Ime4ZBuNYJrZ+y45iwcQuV4qs06vhF9NN
 tavA0I0ILUoQqIXZb0kjEu+fb9i2JwTlWB1dyMntcY5w4ERIACXISXU5MZpaiO/O4Ogk
 8fAPHyIHFysUns7n/4ZRItOAm/Qk2arYeirYW/cbxiJ5Fceaj+U4NEWgV2shZJKqpBTf
 e/cBFW5IkYD/LL/iwyipzDBBWn0oogbU58Znc37cBs7wY4S7z9jbqG9G6E1bf6RS8H58
 urjQGVapsHb/X6W9zFsn8ajbCcb/WzIwSUZqB96yZazTSMf0ch1SreInR3d4NMEmpXuH pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32wm3w0hqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:17 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07EF3eUp029303
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:17 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32wm3w0hnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 11:10:17 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07EF0Nrs006876;
        Fri, 14 Aug 2020 15:10:14 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 32skp86r4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 15:10:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07EFACjn14287150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 15:10:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27A49A4053;
        Fri, 14 Aug 2020 15:10:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B35C4A405D;
        Fri, 14 Aug 2020 15:10:11 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.223])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 15:10:11 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests RFC v1 3/5] lib/alloc: simplify free and malloc
Date:   Fri, 14 Aug 2020 17:10:07 +0200
Message-Id: <20200814151009.55845-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200814151009.55845-1-imbrenda@linux.ibm.com>
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_09:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 suspectscore=2 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the size parameter from the various free functions

Since the backends can handle the allocation sizes on their own,
simplify the generic malloc wrappers.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc.h      |  2 +-
 lib/alloc_page.h |  6 +++---
 lib/alloc.c      | 42 +++++-------------------------------------
 lib/alloc_page.c |  2 +-
 lib/s390x/smp.c  |  4 ++--
 lib/vmalloc.c    |  2 +-
 s390x/smp.c      |  4 ++--
 7 files changed, 15 insertions(+), 47 deletions(-)

diff --git a/lib/alloc.h b/lib/alloc.h
index c44d459..9b4b634 100644
--- a/lib/alloc.h
+++ b/lib/alloc.h
@@ -24,7 +24,7 @@
 
 struct alloc_ops {
 	void *(*memalign)(size_t alignment, size_t size);
-	void (*free)(void *ptr, size_t size);
+	void (*free)(void *ptr);
 	size_t align_min;
 };
 
diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 6472abd..26caefe 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -62,18 +62,18 @@ void *alloc_pages(unsigned int order);
  * alloc_pages* functions.
  * The pointer must point to the start of the block.
  */
-void free_pages(void *mem, size_t size);
+void free_pages(void *mem);
 
 /* For backwards compatibility */
 static inline void free_page(void *mem)
 {
-	return free_pages(mem, 1);
+	return free_pages(mem);
 }
 
 /* For backwards compatibility */
 static inline void free_pages_by_order(void *mem, unsigned int order)
 {
-	free_pages(mem, 1ull << order);
+	free_pages(mem);
 }
 
 #endif
diff --git a/lib/alloc.c b/lib/alloc.c
index 9d89d24..a46f464 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -50,56 +50,24 @@ void *calloc(size_t nmemb, size_t size)
 	return ptr;
 }
 
-#define METADATA_EXTRA	(2 * sizeof(uintptr_t))
-#define OFS_SLACK	(-2 * sizeof(uintptr_t))
-#define OFS_SIZE	(-sizeof(uintptr_t))
-
-static inline void *block_begin(void *mem)
-{
-	uintptr_t slack = *(uintptr_t *)(mem + OFS_SLACK);
-	return mem - slack;
-}
-
-static inline uintptr_t block_size(void *mem)
-{
-	return *(uintptr_t *)(mem + OFS_SIZE);
-}
-
 void free(void *ptr)
 {
-	if (!alloc_ops->free)
-		return;
-
-	void *base = block_begin(ptr);
-	uintptr_t sz = block_size(ptr);
-
-	alloc_ops->free(base, sz);
+	if (alloc_ops->free)
+		alloc_ops->free(ptr);
 }
 
 void *memalign(size_t alignment, size_t size)
 {
 	void *p;
-	uintptr_t blkalign;
-	uintptr_t mem;
 
 	if (!size)
 		return NULL;
 
-	assert(alignment >= sizeof(void *) && is_power_of_2(alignment));
+	assert(is_power_of_2(alignment));
 	assert(alloc_ops && alloc_ops->memalign);
 
-	size += alignment - 1;
-	blkalign = MAX(alignment, alloc_ops->align_min);
-	size = ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
-	p = alloc_ops->memalign(blkalign, size);
+	p = alloc_ops->memalign(alignment, size);
 	assert(p);
 
-	/* Leave room for metadata before aligning the result.  */
-	mem = (uintptr_t)p + METADATA_EXTRA;
-	mem = ALIGN(mem, alignment);
-
-	/* Write the metadata */
-	*(uintptr_t *)(mem + OFS_SLACK) = mem - (uintptr_t)p;
-	*(uintptr_t *)(mem + OFS_SIZE) = size;
-	return (void *)mem;
+	return (void *)p;
 }
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 7c91f91..0e720ad 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -260,7 +260,7 @@ static void _free_pages(void *mem)
 	} while (coalesce(a, order, pfn, pfn2));
 }
 
-void free_pages(void *mem, size_t size)
+void free_pages(void *mem)
 {
 	spin_lock(&lock);
 	_free_pages(mem);
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index d954094..1bee8a9 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -163,8 +163,8 @@ int smp_cpu_destroy(uint16_t addr)
 	rc = smp_cpu_stop_nolock(addr, false);
 	if (!rc) {
 		cpu = smp_cpu_from_addr(addr);
-		free_pages(cpu->lowcore, 2 * PAGE_SIZE);
-		free_pages(cpu->stack, 4 * PAGE_SIZE);
+		free_pages(cpu->lowcore);
+		free_pages(cpu->stack);
 		cpu->lowcore = (void *)-1UL;
 		cpu->stack = (void *)-1UL;
 	}
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index f72c5b3..55b7a74 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -159,7 +159,7 @@ static void *vm_memalign(size_t alignment, size_t size)
 	return mem;
 }
 
-static void vm_free(void *mem, size_t size)
+static void vm_free(void *mem)
 {
 	struct metadata *m;
 	uintptr_t ptr, end;
diff --git a/s390x/smp.c b/s390x/smp.c
index ad30e3c..4ca1dce 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -143,7 +143,7 @@ static void test_store_status(void)
 	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
 	while (!status->prefix) { mb(); }
 	report(1, "status written");
-	free_pages(status, PAGE_SIZE * 2);
+	free_pages(status);
 	report_prefix_pop();
 	smp_cpu_stop(1);
 
@@ -276,7 +276,7 @@ static void test_reset_initial(void)
 	report_prefix_pop();
 
 	report(smp_cpu_stopped(1), "cpu stopped");
-	free_pages(status, PAGE_SIZE);
+	free_pages(status);
 	report_prefix_pop();
 }
 
-- 
2.26.2

