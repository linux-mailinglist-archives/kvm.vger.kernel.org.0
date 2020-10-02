Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFF82816FD
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388065AbgJBPod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:44:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10324 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388053AbgJBPo3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:44:29 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092FVbUa035607
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4rnYkq1xA25KtIa/ibM5hIb56rez3PjIOa7BmxeeNeU=;
 b=nh3puc7vf0mEybRPToAAI38iJwA5AiHAxbtKOx8fV1KnKDSZHQpbDFk/JYLIsbbpl5Hh
 HrONRzvzJqDGfCq8FhGm0jv6OwR6dpSIqVAjO4bgQqxHnoXRgC1Pbcp/+RSYakUokudQ
 isx+el0rZWUmsNUEiE4VKLqIEeOkwMdZOyPoIBM9Tt2TNjdzqQZYtYnXQDsmoT1PvlT6
 tvkJE2/h/+KSQPGlomZlRjK5lXyXBlnCNa3pFZQBiG9ROGxZOecR9UVZTcN7xB+GR72E
 Kh9aljjoQatxfVyjuqQkfDoUY57At66NQwHpzAmn3nvJcSsD9vwwR7TJI0hqUkMXKijF lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x6wg8c3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 11:44:28 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092FW7Ad037856
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:28 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x6wg8c2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:44:28 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092FhGI0015509;
        Fri, 2 Oct 2020 15:44:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 33v5kg1rrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:44:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092FiNxL32637354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:44:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7EE44203F;
        Fri,  2 Oct 2020 15:44:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BB1042041;
        Fri,  2 Oct 2020 15:44:23 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.90])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:44:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 5/7] lib/alloc: simplify free and malloc
Date:   Fri,  2 Oct 2020 17:44:18 +0200
Message-Id: <20201002154420.292134-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002154420.292134-1-imbrenda@linux.ibm.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 suspectscore=2 impostorscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020119
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
index 81847ae..6c23018 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -61,18 +61,18 @@ void *alloc_pages(unsigned int order);
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
index 29d221f..046082a 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -255,7 +255,7 @@ static void _free_pages(void *mem)
 	} while (coalesce(a, order, pfn, pfn2));
 }
 
-void free_pages(void *mem, size_t size)
+void free_pages(void *mem)
 {
 	spin_lock(&lock);
 	_free_pages(mem);
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index ea93329..77d80ca 100644
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
index 3aec5ac..986a34c 100644
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

