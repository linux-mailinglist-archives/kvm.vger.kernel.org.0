Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A672816F8
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbgJBPof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:44:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388052AbgJBPob (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:44:31 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092FgpDO143006
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bRV+H/6IR7geygWeBivh99r4JvUGMj1FTV1s2OTa2TE=;
 b=r1SMCnRGqx80pn7kKriGkFgoCvEzPejKJXI/6rnnhv/6IotZt5UGeU0C0k7lbZ+kLRVv
 8f3p8YCjAwtrjVVz7D6k503Y0u4iiVMzKtbe0O6c8u232pPMeuxir7PpR7w/fXY90W0v
 nm57dhiT/MI7+qFgmVvB91aqLiAZkAgmQ/3G6g2KrqSDDrGWw7FD22czeKV9xb5mf0vl
 jlWq6lrqSSWEF/8S077k6CL4ExsOtYsyKgFZKftpOE2olhfZe7gaKPxrIPdGDjrT+lzK
 MPqynvHoyscaQ4zwRw466ZGdT0dXEs9lKpInV/B5UdoEq5cd5veNSntAt1CP77xdrNLo GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x73br0rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 11:44:28 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092FhpKL145010
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:28 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x73br0r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:44:27 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092FfTXQ032314;
        Fri, 2 Oct 2020 15:44:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw986qcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:44:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092FiNHp16056802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:44:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59D304203F;
        Fri,  2 Oct 2020 15:44:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE35A42042;
        Fri,  2 Oct 2020 15:44:22 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.90])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:44:22 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite of the page allocator
Date:   Fri,  2 Oct 2020 17:44:17 +0200
Message-Id: <20201002154420.292134-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002154420.292134-1-imbrenda@linux.ibm.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=2 bulkscore=0
 phishscore=0 adultscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a complete rewrite of the page allocator.

This will bring a few improvements:
* no need to specify the size when freeing
* allocate small areas with a large alignment without wasting memory
* ability to initialize and use multiple memory areas (e.g. DMA)
* more sanity checks

A few things have changed:
* initialization cannot be done with free_pages like before,
  page_alloc_init_area has to be used instead

Arch-specific changes:
* s390x now uses the area below 2GiB for SMP lowcore initialization.

Details:
Each memory area has metadata at the very beginning. The metadata is a
byte array with one entry per usable page (so, excluding the metadata
itself). Each entry indicates if the page is special (unused for now),
if it is allocated, and the order of the block. Both free and allocated
pages are part of larger blocks.

Some more fixed size metadata is present in a fixed-size static array.
This metadata contains start and end page frame numbers, the pointer to
the metadata array, and the array of freelists. The array of freelists
has an entry for each possible order (indicated by the macro NLISTS,
defined as BITS_PER_LONG - PAGE_SHIFT).

On allocation, if the free list for the needed size is empty, larger
blocks are split. When a small allocation with a large alignment is
requested, an appropriately large block is split, to guarantee the
alignment.

When a block is freed, an attempt will be made to merge it into the
neighbour, iterating the process as long as possible.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.h |  63 +++++-
 lib/alloc_page.c | 484 +++++++++++++++++++++++++++++++++++++----------
 lib/arm/setup.c  |   2 +-
 lib/s390x/sclp.c |   6 +-
 lib/s390x/smp.c  |   2 +-
 lib/vmalloc.c    |  13 +-
 6 files changed, 453 insertions(+), 117 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 88540d1..81847ae 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -8,12 +8,71 @@
 #ifndef ALLOC_PAGE_H
 #define ALLOC_PAGE_H 1
 
+#include <asm/memory_areas.h>
+
+/* Returns true if the page allocator has been initialized */
 bool page_alloc_initialized(void);
+
+/*
+ * Initializes a memory area.
+ * n is the number of the area to initialize
+ * base_pfn is the physical frame number of the start of the area to initialize
+ * top_pfn is the physical frame number of the first page immediately after
+ * the end of the area to initialize
+ */
+void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t top_pfn);
+
+/* Enables the page allocator. At least one area must have been initialized */
 void page_alloc_ops_enable(void);
+
+/*
+ * Allocate aligned memory from the specified areas.
+ * areas is a bitmap of allowed areas
+ * alignment must be a power of 2
+ */
+void *memalign_pages_area(unsigned int areas, size_t alignment, size_t size);
+
+/*
+ * Allocate aligned memory from any area.
+ * Equivalent to memalign_pages_area(~0, alignment, size).
+ */
+void *memalign_pages(size_t alignment, size_t size);
+
+/*
+ * Allocate naturally aligned memory from the specified areas.
+ * Equivalent to memalign_pages_area(areas, 1ull << order, 1ull << order).
+ */
+void *alloc_pages_area(unsigned int areas, unsigned int order);
+
+/*
+ * Allocate one page from any area.
+ * Equivalent to alloc_pages(0);
+ */
 void *alloc_page(void);
+
+/*
+ * Allocate naturally aligned memory from any area.
+ * Equivalent to alloc_pages_area(~0, order);
+ */
 void *alloc_pages(unsigned int order);
-void free_page(void *page);
+
+/*
+ * Frees a memory block allocated with any of the memalign_pages* or
+ * alloc_pages* functions.
+ * The pointer must point to the start of the block.
+ */
 void free_pages(void *mem, size_t size);
-void free_pages_by_order(void *mem, unsigned int order);
+
+/* For backwards compatibility */
+static inline void free_page(void *mem)
+{
+	return free_pages(mem, 1);
+}
+
+/* For backwards compatibility */
+static inline void free_pages_by_order(void *mem, unsigned int order)
+{
+	free_pages(mem, 1ull << order);
+}
 
 #endif
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 74fe726..29d221f 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -9,169 +9,445 @@
 #include "alloc_phys.h"
 #include "alloc_page.h"
 #include "bitops.h"
+#include "list.h"
 #include <asm/page.h>
 #include <asm/io.h>
 #include <asm/spinlock.h>
+#include <asm/memory_areas.h>
 
+#define IS_ALIGNED_ORDER(x,order) IS_ALIGNED((x),BIT_ULL(order))
+#define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
+#define PFN(x) ((uintptr_t)(x) >> PAGE_SHIFT)
+
+#define MAX_AREAS	6
+
+#define ORDER_MASK	0x3f
+#define ALLOC_MASK	0x40
+
+struct mem_area {
+	/* Physical frame number of the first usable frame in the area */
+	uintptr_t base;
+	/* Physical frame number of the first frame outside the area */
+	uintptr_t top;
+	/* Combination ALLOC_MASK and order */
+	u8 *page_states;
+	/* One freelist for each possible block size, up to NLISTS */
+	struct linked_list freelists[NLISTS];
+};
+
+static struct mem_area areas[MAX_AREAS];
+static unsigned int areas_mask;
 static struct spinlock lock;
-static void *freelist = 0;
 
 bool page_alloc_initialized(void)
 {
-	return freelist != 0;
+	return areas_mask != 0;
 }
 
-void free_pages(void *mem, size_t size)
+static inline bool area_or_metadata_contains(struct mem_area *a, uintptr_t pfn)
 {
-	void *old_freelist;
-	void *end;
+	return (pfn >= PFN(a->page_states)) && (pfn < a->top);
+}
 
-	assert_msg((unsigned long) mem % PAGE_SIZE == 0,
-		   "mem not page aligned: %p", mem);
+static inline bool area_contains(struct mem_area *a, uintptr_t pfn)
+{
+	return (pfn >= a->base) && (pfn < a->top);
+}
 
-	assert_msg(size % PAGE_SIZE == 0, "size not page aligned: %#zx", size);
+/*
+ * Splits the free block starting at addr into 2 blocks of half the size.
+ *
+ * The function depends on the following assumptions:
+ * - The allocator must have been initialized
+ * - the block must be within the memory area
+ * - all pages in the block must be free and not special
+ * - the pointer must point to the start of the block
+ * - all pages in the block must have the same block size.
+ * - the block size must be greater than 0
+ * - the block size must be smaller than the maximum allowed
+ * - the block must be in a free list
+ * - the function is called with the lock held
+ */
+static void split(struct mem_area *a, void *addr)
+{
+	uintptr_t pfn = PFN(addr);
+	struct linked_list *p;
+	uintptr_t i, idx;
+	u8 order;
 
-	assert_msg(size == 0 || (uintptr_t)mem == -size ||
-		   (uintptr_t)mem + size > (uintptr_t)mem,
-		   "mem + size overflow: %p + %#zx", mem, size);
+	assert(a && area_contains(a, pfn));
+	idx = pfn - a->base;
+	order = a->page_states[idx];
+	assert(!(order & ~ORDER_MASK) && order && (order < NLISTS));
+	assert(IS_ALIGNED_ORDER(pfn, order));
+	assert(area_contains(a, pfn + BIT(order) - 1));
 
-	if (size == 0) {
-		freelist = NULL;
-		return;
-	}
+	/* Remove the block from its free list */
+	p = list_remove(addr);
+	assert(p);
 
-	spin_lock(&lock);
-	old_freelist = freelist;
-	freelist = mem;
-	end = mem + size;
-	while (mem + PAGE_SIZE != end) {
-		*(void **)mem = (mem + PAGE_SIZE);
-		mem += PAGE_SIZE;
+	/* update the block size for each page in the block */
+	for (i = 0; i < BIT(order); i++) {
+		assert(a->page_states[idx + i] == order);
+		a->page_states[idx + i] = order - 1;
 	}
-
-	*(void **)mem = old_freelist;
-	spin_unlock(&lock);
+	order--;
+	/* add the first half block to the appropriate free list */
+	list_add(a->freelists + order, p);
+	/* add the second half block to the appropriate free list */
+	list_add(a->freelists + order, (void *)((pfn + BIT(order)) * PAGE_SIZE));
 }
 
-void free_pages_by_order(void *mem, unsigned int order)
+/*
+ * Returns a block whose alignment and size are at least the parameter values.
+ * If there is not enough free memory, NULL is returned.
+ *
+ * Both parameters must be not larger than the largest allowed order
+ */
+static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
 {
-	free_pages(mem, 1ul << (order + PAGE_SHIFT));
+	struct linked_list *p, *res = NULL;
+	u8 order;
+
+	assert((al < NLISTS) && (sz < NLISTS));
+	/* we need the bigger of the two as starting point */
+	order = sz > al ? sz : al;
+
+	/* search all free lists for some memory */
+	for ( ; order < NLISTS; order++) {
+		p = a->freelists[order].next;
+		if (!is_list_empty(p))
+			break;
+	}
+	/* out of memory */
+	if (order >= NLISTS)
+		return NULL;
+
+	/*
+	 * the block is bigger than what we need because either there were
+	 * no smaller blocks, or the smaller blocks were not aligned to our
+	 * needs; therefore we split the block until we reach the needed size
+	 */
+	for (; order > sz; order--)
+		split(a, p);
+
+	res = list_remove(p);
+	memset(a->page_states + (PFN(res) - a->base), ALLOC_MASK | order, BIT(order));
+	return res;
 }
 
-void *alloc_page()
+/*
+ * Try to merge two blocks into a bigger one.
+ * Returns true in case of a successful merge.
+ * Merging will succeed only if both blocks have the same block size and are
+ * both free.
+ *
+ * The function depends on the following assumptions:
+ * - the first parameter is strictly smaller than the second
+ * - the parameters must point each to the start of their block
+ * - the two parameters point to adjacent blocks
+ * - the two blocks are both in a free list
+ * - all of the pages of the two blocks must be free
+ * - all of the pages of the two blocks must have the same block size
+ * - the function is called with the lock held
+ */
+static bool coalesce(struct mem_area *a, u8 order, uintptr_t pfn, uintptr_t pfn2)
 {
-	void *p;
+	uintptr_t first, second, i;
+	struct linked_list *li;
 
-	if (!freelist)
-		return 0;
+	assert(IS_ALIGNED_ORDER(pfn, order) && IS_ALIGNED_ORDER(pfn2, order));
+	assert(pfn2 == pfn + BIT(order));
+	assert(a);
 
-	spin_lock(&lock);
-	p = freelist;
-	freelist = *(void **)freelist;
-	spin_unlock(&lock);
+	/* attempting to coalesce two blocks that belong to different areas */
+	if (!area_contains(a, pfn) || !area_contains(a, pfn2 + BIT(order) - 1))
+		return false;
+	first = pfn - a->base;
+	second = pfn2 - a->base;
+	/* the two blocks have different sizes, cannot coalesce */
+	if ((a->page_states[first] != order) || (a->page_states[second] != order))
+		return false;
 
-	if (p)
-		memset(p, 0, PAGE_SIZE);
-	return p;
+	/* we can coalesce, remove both blocks from their freelists */
+	li = list_remove((void *)(pfn2 << PAGE_SHIFT));
+	assert(li);
+	li = list_remove((void *)(pfn << PAGE_SHIFT));
+	assert(li);
+	/* check the metadata entries and update with the new size */
+	for (i = 0; i < (2ull << order); i++) {
+		assert(a->page_states[first + i] == order);
+		a->page_states[first + i] = order + 1;
+	}
+	/* finally add the newly coalesced block to the appropriate freelist */
+	list_add(a->freelists + order + 1, li);
+	return true;
 }
 
 /*
- * Allocates (1 << order) physically contiguous and naturally aligned pages.
- * Returns NULL if there's no memory left.
+ * Free a block of memory.
+ * The parameter can be NULL, in which case nothing happens.
+ *
+ * The function depends on the following assumptions:
+ * - the parameter is page aligned
+ * - the parameter belongs to an existing memory area
+ * - the parameter points to the beginning of the block
+ * - the size of the block is less than the maximum allowed
+ * - the block is completely contained in its memory area
+ * - all pages in the block have the same block size
+ * - no pages in the memory block were already free
+ * - no pages in the memory block are special
  */
-void *alloc_pages(unsigned int order)
+static void _free_pages(void *mem)
 {
-	/* Generic list traversal. */
-	void *prev;
-	void *curr = NULL;
-	void *next = freelist;
-
-	/* Looking for a run of length (1 << order). */
-	unsigned long run = 0;
-	const unsigned long n = 1ul << order;
-	const unsigned long align_mask = (n << PAGE_SHIFT) - 1;
-	void *run_start = NULL;
-	void *run_prev = NULL;
-	unsigned long run_next_pa = 0;
-	unsigned long pa;
+	uintptr_t pfn2, pfn = PFN(mem);
+	struct mem_area *a = NULL;
+	uintptr_t i, p;
+	u8 order;
 
-	assert(order < sizeof(unsigned long) * 8);
+	if (!mem)
+		return;
+	assert(IS_ALIGNED((uintptr_t)mem, PAGE_SIZE));
 
-	spin_lock(&lock);
-	for (;;) {
-		prev = curr;
-		curr = next;
+	/* find which area this pointer belongs to*/
+	for (i = 0; !a && (i < MAX_AREAS); i++) {
+		if ((areas_mask & BIT(i)) && area_contains(areas + i, pfn))
+			a = areas + i;
+	}
+	assert_msg(a, "memory does not belong to any area: %p", mem);
 
-		if (!curr) {
-			run_start = NULL;
-			break;
-		}
+	p = pfn - a->base;
+	order = a->page_states[p] & ORDER_MASK;
 
-		next = *((void **) curr);
-		pa = virt_to_phys(curr);
-
-		if (run == 0) {
-			if (!(pa & align_mask)) {
-				run_start = curr;
-				run_prev = prev;
-				run_next_pa = pa + PAGE_SIZE;
-				run = 1;
-			}
-		} else if (pa == run_next_pa) {
-			run_next_pa += PAGE_SIZE;
-			run += 1;
-		} else {
-			run = 0;
-		}
+	/* ensure that the first page is allocated and not special */
+	assert(a->page_states[p] == (order | ALLOC_MASK));
+	/* ensure that the order has a sane value */
+	assert(order < NLISTS);
+	/* ensure that the block is aligned properly for its size */
+	assert(IS_ALIGNED_ORDER(pfn, order));
+	/* ensure that the area can contain the whole block */
+	assert(area_contains(a, pfn + BIT(order) - 1));
 
-		if (run == n) {
-			if (run_prev)
-				*((void **) run_prev) = next;
-			else
-				freelist = next;
-			break;
-		}
+	for (i = 0; i < BIT(order); i++) {
+		/* check that all pages of the block have consistent metadata */
+		assert(a->page_states[p + i] == (ALLOC_MASK | order));
+		/* set the page as free */
+		a->page_states[p + i] &= ~ALLOC_MASK;
 	}
-	spin_unlock(&lock);
-	if (run_start)
-		memset(run_start, 0, n * PAGE_SIZE);
-	return run_start;
+	/* provisionally add the block to the appropriate free list */
+	list_add(a->freelists + order, mem);
+	/* try to coalesce the block with neighbouring blocks if possible */
+	do {
+		/*
+		 * get the order again since it might have changed after
+		 * coalescing in a previous iteration
+		 */
+		order = a->page_states[p] & ORDER_MASK;
+		/*
+		 * let's consider this block and the next one if this block
+		 * is aligned to the next size, otherwise let's consider the
+		 * previous block and this one
+		 */
+		if (!IS_ALIGNED_ORDER(pfn, order + 1))
+			pfn = pfn - BIT(order);
+		pfn2 = pfn + BIT(order);
+		/* repeat as long as we manage to coalesce something */
+	} while (coalesce(a, order, pfn, pfn2));
 }
 
+void free_pages(void *mem, size_t size)
+{
+	spin_lock(&lock);
+	_free_pages(mem);
+	spin_unlock(&lock);
+}
 
-void free_page(void *page)
+static void *page_memalign_order_area(unsigned area, u8 ord, u8 al)
 {
+	void *res = NULL;
+	int i;
+
 	spin_lock(&lock);
-	*(void **)page = freelist;
-	freelist = page;
+	area &= areas_mask;
+	for (i = 0; !res && (i < MAX_AREAS); i++)
+		if (area & BIT(i))
+			res = page_memalign_order(areas + i, ord, al);
 	spin_unlock(&lock);
+	return res;
 }
 
-static void *page_memalign(size_t alignment, size_t size)
+/*
+ * Allocates (1 << order) physically contiguous and naturally aligned pages.
+ * Returns NULL if the allocation was not possible.
+ */
+void *alloc_pages_area(unsigned int area, unsigned int order)
 {
-	unsigned long n = ALIGN(size, PAGE_SIZE) >> PAGE_SHIFT;
-	unsigned int order;
+	return page_memalign_order_area(area, order, order);
+}
 
-	if (!size)
-		return NULL;
+void *alloc_pages(unsigned int order)
+{
+	return alloc_pages_area(AREA_ANY, order);
+}
 
-	order = get_order(n);
+/*
+ * Allocates (1 << order) physically contiguous aligned pages.
+ * Returns NULL if the allocation was not possible.
+ */
+void *memalign_pages_area(unsigned int area, size_t alignment, size_t size)
+{
+	assert(is_power_of_2(alignment));
+	alignment = get_order(PAGE_ALIGN(alignment) >> PAGE_SHIFT);
+	size = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
+	assert(alignment < NLISTS);
+	assert(size < NLISTS);
+	return page_memalign_order_area(area, size, alignment);
+}
 
-	return alloc_pages(order);
+void *memalign_pages(size_t alignment, size_t size)
+{
+	return memalign_pages_area(AREA_ANY, alignment, size);
 }
 
-static void page_free(void *mem, size_t size)
+/*
+ * Allocates one page
+ */
+void *alloc_page()
 {
-	free_pages(mem, size);
+	return alloc_pages(0);
 }
 
 static struct alloc_ops page_alloc_ops = {
-	.memalign = page_memalign,
-	.free = page_free,
+	.memalign = memalign_pages,
+	.free = free_pages,
 	.align_min = PAGE_SIZE,
 };
 
+/*
+ * Enables the page allocator.
+ *
+ * Prerequisites:
+ * - at least one memory area has been initialized
+ */
 void page_alloc_ops_enable(void)
 {
+	spin_lock(&lock);
+	assert(page_alloc_initialized());
 	alloc_ops = &page_alloc_ops;
+	spin_unlock(&lock);
+}
+
+/*
+ * Adds a new memory area to the pool of available memory.
+ *
+ * Prerequisites:
+ * - the lock is held
+ * - start and top are page frame numbers
+ * - start is smaller than top
+ * - top does not fall outside of addressable memory
+ * - there is at least one more slot free for memory areas
+ * - if a specific memory area number has been indicated, it needs to be free
+ * - the memory area to add does not overlap with existing areas
+ * - the memory area to add has at least 5 pages available
+ */
+static void _page_alloc_init_area(u8 n, uintptr_t start_pfn, uintptr_t top_pfn)
+{
+	size_t table_size, npages, i;
+	struct mem_area *a;
+	u8 order = 0;
+
+	/* the number must be within the allowed range */
+	assert(n < MAX_AREAS);
+	/* the new area number must be unused */
+	assert(!(areas_mask & BIT(n)));
+
+	/* other basic sanity checks */
+	assert(top_pfn > start_pfn);
+	assert(top_pfn - start_pfn > 4);
+	assert(top_pfn < BIT_ULL(sizeof(void *) * 8 - PAGE_SHIFT));
+
+	/* calculate the size of the metadata table in pages */
+	table_size = (top_pfn - start_pfn + PAGE_SIZE) / (PAGE_SIZE + 1);
+
+	/* fill in the values of the new area */
+	a = areas + n;
+	a->page_states = (void *)(start_pfn << PAGE_SHIFT);
+	a->base = start_pfn + table_size;
+	a->top = top_pfn;
+	npages = top_pfn - a->base;
+	assert((a->base - start_pfn) * PAGE_SIZE >= npages);
+
+	/* check that the new area does not overlap with any existing areas */
+	for (i = 0; i < MAX_AREAS; i++) {
+		if (!(areas_mask & BIT(i)))
+			continue;
+		assert(!area_or_metadata_contains(areas + i, start_pfn));
+		assert(!area_or_metadata_contains(areas + i, top_pfn - 1));
+		assert(!area_or_metadata_contains(a, PFN(areas[i].page_states)));
+		assert(!area_or_metadata_contains(a, areas[i].top - 1));
+	}
+	/* initialize all freelists for the new area */
+	for (i = 0; i < NLISTS; i++)
+		a->freelists[i].next = a->freelists[i].prev = a->freelists + i;
+
+	/* initialize the metadata for the available memory */
+	for (i = a->base; i < a->top; i += 1ull << order) {
+		/* search which order to start from */
+		while (i + BIT(order) > a->top) {
+			assert(order);
+			order--;
+		}
+		/*
+		 * we need both loops, one for the start and the other for
+		 * the end of the block, in case it spans a power of two
+		 * boundary
+		 */
+		while (IS_ALIGNED_ORDER(i, order + 1) && (i + BIT(order + 1) <= a->top))
+			order++;
+		assert(order < NLISTS);
+		/* initialize the metadata and add to the freelist */
+		memset(a->page_states + (i - a->base), order, BIT(order));
+		list_add(a->freelists + order, (void *)(i << PAGE_SHIFT));
+	}
+	/* finally mark the area as present */
+	areas_mask |= BIT(n);
+}
+
+static void __page_alloc_init_area(u8 n, uintptr_t cutoff, uintptr_t base_pfn, uintptr_t *top_pfn)
+{
+	if (*top_pfn > cutoff) {
+		spin_lock(&lock);
+		if (base_pfn >= cutoff) {
+			_page_alloc_init_area(n, base_pfn, *top_pfn);
+			*top_pfn = 0;
+		} else {
+			_page_alloc_init_area(n, cutoff, *top_pfn);
+			*top_pfn = cutoff;
+		}
+		spin_unlock(&lock);
+	}
+}
+
+/*
+ * Adds a new memory area to the pool of available memory.
+ *
+ * Prerequisites:
+ * see _page_alloc_init_area
+ */
+void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t top_pfn)
+{
+	if (n != AREA_ANY_NUMBER) {
+		__page_alloc_init_area(n, 0, base_pfn, &top_pfn);
+		return;
+	}
+#ifdef AREA_HIGH_PFN
+	__page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN), base_pfn, &top_pfn);
+#endif
+	__page_alloc_init_area(AREA_NORMAL_NUMBER, AREA_NORMAL_PFN, base_pfn, &top_pfn);
+#ifdef AREA_LOW_PFN
+	__page_alloc_init_area(AREA_LOW_NUMBER, AREA_LOW_PFN, base_pfn, &top_pfn);
+#endif
+#ifdef AREA_LOWEST_PFN
+	__page_alloc_init_area(AREA_LOWEST_NUMBER, AREA_LOWEST_PFN, base_pfn, &top_pfn);
+#endif
 }
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 78562e4..3f03ca6 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -155,7 +155,7 @@ static void mem_init(phys_addr_t freemem_start)
 	assert(sizeof(long) == 8 || !(base >> 32));
 	if (sizeof(long) != 8 && (top >> 32) != 0)
 		top = ((uint64_t)1 << 32);
-	free_pages((void *)(unsigned long)base, top - base);
+	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
 	page_alloc_ops_enable();
 }
 
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 4054d0e..4e2ac18 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -37,11 +37,11 @@ static void mem_init(phys_addr_t mem_end)
 
 	phys_alloc_init(freemem_start, mem_end - freemem_start);
 	phys_alloc_get_unused(&base, &top);
-	base = (base + PAGE_SIZE - 1) & -PAGE_SIZE;
-	top = top & -PAGE_SIZE;
+	base = PAGE_ALIGN(base) >> PAGE_SHIFT;
+	top = top >> PAGE_SHIFT;
 
 	/* Make the pages available to the physical allocator */
-	free_pages((void *)(unsigned long)base, top - base);
+	page_alloc_init_area(AREA_ANY_NUMBER, base, top);
 	page_alloc_ops_enable();
 }
 
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 2860e9c..ea93329 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -190,7 +190,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 
 	sigp_retry(cpu->addr, SIGP_INITIAL_CPU_RESET, 0, NULL);
 
-	lc = alloc_pages(1);
+	lc = alloc_pages_area(AREA_DMA31, 1);
 	cpu->lowcore = lc;
 	memset(lc, 0, PAGE_SIZE * 2);
 	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 2f25734..3aec5ac 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -217,18 +217,19 @@ void setup_vm()
 	 * so that it can be used to allocate page tables.
 	 */
 	if (!page_alloc_initialized()) {
-		base = PAGE_ALIGN(base);
-		top = top & -PAGE_SIZE;
-		free_pages(phys_to_virt(base), top - base);
+		base = PAGE_ALIGN(base) >> PAGE_SHIFT;
+		top = top >> PAGE_SHIFT;
+		page_alloc_init_area(AREA_ANY_NUMBER, base, top);
+		page_alloc_ops_enable();
 	}
 
 	find_highmem();
 	phys_alloc_get_unused(&base, &top);
 	page_root = setup_mmu(top);
 	if (base != top) {
-		base = PAGE_ALIGN(base);
-		top = top & -PAGE_SIZE;
-		free_pages(phys_to_virt(base), top - base);
+		base = PAGE_ALIGN(base) >> PAGE_SHIFT;
+		top = top >> PAGE_SHIFT;
+		page_alloc_init_area(AREA_ANY_NUMBER, base, top);
 	}
 
 	spin_lock(&lock);
-- 
2.26.2

