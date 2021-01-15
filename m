Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539812F7A01
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbhAOMnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:43:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388197AbhAOMie (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:38:34 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCXI9p019867;
        Fri, 15 Jan 2021 07:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cUnR5ChKYHPQMwBBkTykL0wWrqbLLjjZ/eDxY+avFM0=;
 b=jDBhI7HmarTidBPcqOXPwKiP/fu6G454GSYBYn6wAJalCW42rewlDxdQzkWwhWHbIhHN
 Q8Q3Y8Ui3BYExCp5VpXH4oZ0aQv8a3ZqTb/FSA9C7zLmbZ/bfKk4Fq5ZYK9iQzONtVRR
 FZq4V6ryD/ElTHLrKh74bZktdjwBJTS2XgVy4e/p/xPbZjZmHO03FPi2Rbf5PhSwUyFn
 Z1x7VlHqae0I9/22X4C33gHNW3fJJ+NURDlpItAD885OTyxG7esLQI786y4JpjhkzRS2
 1HmI19CcJXCXirxMZZ4qaJvoM5Bcq0l0yhoIrTaY+s9VrSPp8Q4dZRB1iHroQchnulhn Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363b1dga46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:49 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCXJhU019965;
        Fri, 15 Jan 2021 07:37:46 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363b1dga1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:45 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FCb0ig025922;
        Fri, 15 Jan 2021 12:37:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 35y448byvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbVIJ20971940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CD0AAE053;
        Fri, 15 Jan 2021 12:37:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A593AE056;
        Fri, 15 Jan 2021 12:37:36 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 09/11] lib/alloc: replace areas with more generic flags
Date:   Fri, 15 Jan 2021 13:37:28 +0100
Message-Id: <20210115123730.381612-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 malwarescore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the areas parameter with a more generic flags parameter. This
allows for up to 16 allocation areas and 16 allocation flags.

This patch introduces the flags and changes the names of the funcions,
subsequent patches will actually wire up the flags to do something.

The first two flags introduced are:
- FLAG_DONTZERO to ask the allocated memory not to be zeroed
- FLAG_FRESH to indicate that the allocated memory should have not been
  touched (READ or written to) in any way since boot.

This patch also fixes the order of arguments to consistently have alignment
first and then size, thereby fixing a bug where the two values would get
swapped.

Fixes: 8131e91a4b61 ("lib/alloc_page: complete rewrite of the page allocator")

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/alloc_page.h | 39 ++++++++++++++++++++++-----------------
 lib/alloc_page.c | 16 ++++++++--------
 lib/s390x/smp.c  |  2 +-
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 6fd2ff0..1af1419 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -11,8 +11,13 @@
 #include <stdbool.h>
 #include <asm/memory_areas.h>
 
-#define AREA_ANY -1
-#define AREA_ANY_NUMBER 0xff
+#define AREA_ANY_NUMBER	0xff
+
+#define AREA_ANY	0x00000
+#define AREA_MASK	0x0ffff
+
+#define FLAG_DONTZERO	0x10000
+#define FLAG_FRESH	0x20000
 
 /* Returns true if the page allocator has been initialized */
 bool page_alloc_initialized(void);
@@ -30,39 +35,39 @@ void page_alloc_init_area(u8 n, phys_addr_t base_pfn, phys_addr_t top_pfn);
 void page_alloc_ops_enable(void);
 
 /*
- * Allocate aligned memory from the specified areas.
- * areas is a bitmap of allowed areas
+ * Allocate aligned memory with the specified flags.
+ * flags is a bitmap of allowed areas and flags.
  * alignment must be a power of 2
  */
-void *memalign_pages_area(unsigned int areas, size_t alignment, size_t size);
+void *memalign_pages_flags(size_t alignment, size_t size, unsigned int flags);
 
 /*
- * Allocate aligned memory from any area.
- * Equivalent to memalign_pages_area(AREA_ANY, alignment, size).
+ * Allocate aligned memory from any area and with default flags.
+ * Equivalent to memalign_pages_flags(alignment, size, AREA_ANY).
  */
 static inline void *memalign_pages(size_t alignment, size_t size)
 {
-	return memalign_pages_area(AREA_ANY, alignment, size);
+	return memalign_pages_flags(alignment, size, AREA_ANY);
 }
 
 /*
- * Allocate naturally aligned memory from the specified areas.
- * Equivalent to memalign_pages_area(areas, 1ull << order, 1ull << order).
+ * Allocate 1ull << order naturally aligned pages with the specified flags.
+ * Equivalent to memalign_pages_flags(1ull << order, 1ull << order, flags).
  */
-void *alloc_pages_area(unsigned int areas, unsigned int order);
+void *alloc_pages_flags(unsigned int order, unsigned int flags);
 
 /*
- * Allocate naturally aligned pages from any area; the number of allocated
- * pages is 1 << order.
- * Equivalent to alloc_pages_area(AREA_ANY, order);
+ * Allocate 1ull << order naturally aligned pages from any area and with
+ * default flags.
+ * Equivalent to alloc_pages_flags(order, AREA_ANY);
  */
 static inline void *alloc_pages(unsigned int order)
 {
-	return alloc_pages_area(AREA_ANY, order);
+	return alloc_pages_flags(order, AREA_ANY);
 }
 
 /*
- * Allocate one page from any area.
+ * Allocate one page from any area and with default flags.
  * Equivalent to alloc_pages(0);
  */
 static inline void *alloc_page(void)
@@ -83,7 +88,7 @@ void free_pages(void *mem);
  */
 static inline void free_page(void *mem)
 {
-	return free_pages(mem);
+	free_pages(mem);
 }
 
 /*
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index d8b2758..47e2981 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -361,16 +361,16 @@ void unreserve_pages(phys_addr_t addr, size_t n)
 	spin_unlock(&lock);
 }
 
-static void *page_memalign_order_area(unsigned area, u8 ord, u8 al)
+static void *page_memalign_order_flags(u8 al, u8 ord, u32 flags)
 {
 	void *res = NULL;
-	int i;
+	int i, area;
 
 	spin_lock(&lock);
-	area &= areas_mask;
+	area = (flags & AREA_MASK) ? flags & areas_mask : areas_mask;
 	for (i = 0; !res && (i < MAX_AREAS); i++)
 		if (area & BIT(i))
-			res = page_memalign_order(areas + i, ord, al);
+			res = page_memalign_order(areas + i, al, ord);
 	spin_unlock(&lock);
 	return res;
 }
@@ -379,23 +379,23 @@ static void *page_memalign_order_area(unsigned area, u8 ord, u8 al)
  * Allocates (1 << order) physically contiguous and naturally aligned pages.
  * Returns NULL if the allocation was not possible.
  */
-void *alloc_pages_area(unsigned int area, unsigned int order)
+void *alloc_pages_flags(unsigned int order, unsigned int flags)
 {
-	return page_memalign_order_area(area, order, order);
+	return page_memalign_order_flags(order, order, flags);
 }
 
 /*
  * Allocates (1 << order) physically contiguous aligned pages.
  * Returns NULL if the allocation was not possible.
  */
-void *memalign_pages_area(unsigned int area, size_t alignment, size_t size)
+void *memalign_pages_flags(size_t alignment, size_t size, unsigned int flags)
 {
 	assert(is_power_of_2(alignment));
 	alignment = get_order(PAGE_ALIGN(alignment) >> PAGE_SHIFT);
 	size = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
 	assert(alignment < NLISTS);
 	assert(size < NLISTS);
-	return page_memalign_order_area(area, size, alignment);
+	return page_memalign_order_flags(alignment, size, flags);
 }
 
 
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 77d80ca..44b2eb4 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -190,7 +190,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 
 	sigp_retry(cpu->addr, SIGP_INITIAL_CPU_RESET, 0, NULL);
 
-	lc = alloc_pages_area(AREA_DMA31, 1);
+	lc = alloc_pages_flags(1, AREA_DMA31);
 	cpu->lowcore = lc;
 	memset(lc, 0, PAGE_SIZE * 2);
 	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
-- 
2.26.2

