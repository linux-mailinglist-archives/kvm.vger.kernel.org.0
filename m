Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BDE2DC796
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgLPUO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:14:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727656AbgLPUO0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:14:26 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK32vB112851
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:13:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8TVbNkzDTC8MDl4iMn0bY9wkiVPUsMTRegb7/UJTNnw=;
 b=XMU+9w9sDJUNTquut7NYZsqk+9+MEZ5WHg7I7S4/+OQXIgX1pQxts2P2Qjc/epnbc2m7
 BmnUuWr+FpSZ498wdoRMNwOXlopFo/dlnh86Ml5hcsAU2IKhhew2+Lrg5VNgh1UdZXYg
 Se/t8F3bbZ/KUXbk/6jrc1/nCmJRtdGn6ZtAZawdqXiFVG43zRHY4+aAvs/Oih6c3K7o
 nfL+k8sYFMdBC6203217lt2DZhRcM3L9z7+i4gt0cgab8vILtYmep/UdyjSibpOqS8Cv
 YlWSJRmJrRcMH/cw1qV19eotSitafTMb32ZOUXR/WaWxfslG3LZpayagpkof+l5RqJvr ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fpywuj09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:13:45 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK7DLk138282
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:13:44 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fpywuhyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:13:44 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK7N9T021484;
        Wed, 16 Dec 2020 20:13:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8evkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:13:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCOse34079148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77C5642047;
        Wed, 16 Dec 2020 20:12:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 138E342045;
        Wed, 16 Dec 2020 20:12:24 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:24 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 09/12] lib/alloc: replace areas with more generic flags
Date:   Wed, 16 Dec 2020 21:11:57 +0100
Message-Id: <20201216201200.255172-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012160120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the areas parameter with a more generic flags parameter.

This allows for up to 16 allocation areas and 16 allocation flags.

This patch introduces the flags and changes the names of the funcions,
subsequent patches will actually wire up the flags to do something.

The first two flags introduced are:

FLAG_ZERO to ask the allocated memory to be zeroed

FLAG_FRESH to indicate that the allocated memory should have not been
touched (READ or written to) in any way since boot.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.h | 21 +++++++++++++--------
 lib/alloc_page.c | 14 +++++++-------
 lib/s390x/smp.c  |  2 +-
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index d8550c6..1039814 100644
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
+#define FLAG_ZERO	0x10000
+#define FLAG_FRESH	0x20000
 
 /* Returns true if the page allocator has been initialized */
 bool page_alloc_initialized(void);
@@ -34,22 +39,22 @@ void page_alloc_ops_enable(void);
  * areas is a bitmap of allowed areas
  * alignment must be a power of 2
  */
-void *memalign_pages_area(unsigned int areas, size_t alignment, size_t size);
+void *memalign_pages_flags(size_t alignment, size_t size, unsigned int flags);
 
 /*
  * Allocate aligned memory from any area.
- * Equivalent to memalign_pages_area(AREA_ANY, alignment, size).
+ * Equivalent to memalign_pages_flags(alignment, size, AREA_ANY).
  */
 static inline void *memalign_pages(size_t alignment, size_t size)
 {
-	return memalign_pages_area(AREA_ANY, alignment, size);
+	return memalign_pages_flags(alignment, size, AREA_ANY);
 }
 
 /*
  * Allocate naturally aligned memory from the specified areas.
- * Equivalent to memalign_pages_area(areas, 1ull << order, 1ull << order).
+ * Equivalent to memalign_pages_flags(1ull << order, 1ull << order, flags).
  */
-void *alloc_pages_area(unsigned int areas, unsigned int order);
+void *alloc_pages_flags(unsigned int order, unsigned int flags);
 
 /*
  * Allocate naturally aligned memory from any area.
@@ -57,7 +62,7 @@ void *alloc_pages_area(unsigned int areas, unsigned int order);
  */
 static inline void *alloc_pages(unsigned int order)
 {
-	return alloc_pages_area(AREA_ANY, order);
+	return alloc_pages_flags(order, AREA_ANY);
 }
 
 /*
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index dfa43d5..d850b6a 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -361,13 +361,13 @@ void free_pages_special(phys_addr_t addr, size_t n)
 	spin_unlock(&lock);
 }
 
-static void *page_memalign_order_area(unsigned area, u8 ord, u8 al)
+static void *page_memalign_order_flags(u8 ord, u8 al, u32 flags)
 {
 	void *res = NULL;
-	int i;
+	int i, area;
 
 	spin_lock(&lock);
-	area &= areas_mask;
+	area = (flags & AREA_MASK) ? flags & areas_mask : areas_mask;
 	for (i = 0; !res && (i < MAX_AREAS); i++)
 		if (area & BIT(i))
 			res = page_memalign_order(areas + i, ord, al);
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
+	return page_memalign_order_flags(size, alignment, flags);
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

