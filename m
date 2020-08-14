Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90EF244BAD
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 17:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgHNPKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 11:10:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726662AbgHNPKU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Aug 2020 11:10:20 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07EF33Ys002274
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RUqV4vMJCBD9nBXYTrkbrppvXKnStVXiSkg0xvXvJJY=;
 b=f7d3SYUN1NN+teUc9gtpuuecqwAZmIdRQ+3jeFQkFX2PrLGs7ZUO8GyW+ln8xg5oKRQ/
 +CeSu5Wc20/tbpBcyNu9z7zEBYXvsaAo9CYqjaMPmlAvnuMdIf8gp4FPSWWeU/maiPWV
 7JKXl5mCXzRWNBR8TiglmLVBpEifNXqNyq7IpawMcZHbRA5dK9Zp1tg8+5lrfcFTtOML
 FgBOn3NefmtkPbdYogcpHvf6g2NSUgHTgs9X6X75GcT482NNVHMsBkGwFLjYhZBuQdGM
 VulPGzg9nj7fuHZMoLHBUJJPHbAdfnaPkYsSrwHZ7YqPD9iAylh4aVN0lByGYDTZ7eWE Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w70757q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:16 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07EF3S4n003505
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:16 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w70757nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 11:10:16 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07EF1AUb011387;
        Fri, 14 Aug 2020 15:10:14 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 32ws99041t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 15:10:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07EFABV917498410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 15:10:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9295FA4051;
        Fri, 14 Aug 2020 15:10:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E14AA404D;
        Fri, 14 Aug 2020 15:10:11 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.223])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 15:10:11 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests RFC v1 2/5] lib/alloc_page: complete rewrite of the page allocator
Date:   Fri, 14 Aug 2020 17:10:06 +0200
Message-Id: <20200814151009.55845-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200814151009.55845-1-imbrenda@linux.ibm.com>
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_09:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=2 adultscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140111
Sender: kvm-owner@vger.kernel.org
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
* arm and x86 have been adapted to put all the memory in just one big
  area (or two, for x86_64 with highmem).
* s390x instead creates one area below 2GiB and one above; the area
  below 2GiB is used for SMP lowcore initialization.

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
 lib/alloc_page.h |  64 ++++++-
 lib/alloc_page.c | 451 ++++++++++++++++++++++++++++++++++++-----------
 lib/arm/setup.c  |   2 +-
 lib/s390x/sclp.c |  11 +-
 lib/s390x/smp.c  |   2 +-
 lib/vmalloc.c    |  13 +-
 6 files changed, 427 insertions(+), 116 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 88540d1..6472abd 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -8,12 +8,72 @@
 #ifndef ALLOC_PAGE_H
 #define ALLOC_PAGE_H 1
 
+#define _AREA(x) (1 << (x))
+
+/* Returns true if the page allocator has been initialized */
 bool page_alloc_initialized(void);
+
+/*
+ * Initializes a memory area.
+ * n is the number of the area to initialize; if n == -1, the first available
+ * area is used
+ * base_pfn is the physical frame number of the start of the area to initialize
+ * top_pfn is the physical frame number of the first page immediately after
+ * the end of the area to initialize
+ */
+void page_alloc_init_area(int n, uintptr_t base_pfn, uintptr_t top_pfn);
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
index 74fe726..7c91f91 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -13,165 +13,410 @@
 #include <asm/io.h>
 #include <asm/spinlock.h>
 
+#define IS_ALIGNED_ORDER(x,order) IS_ALIGNED((x),BIT_ULL(order))
+#define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
+#define PFN(x) ((uintptr_t)(x) >> PAGE_SHIFT)
+
+#define MAX_AREAS	4
+
+#define ORDER_MASK	0x3f
+#define ALLOC_MASK	0x40
+
+struct free_list {
+	struct free_list *prev;
+	struct free_list *next;
+};
+
+struct mem_area {
+	/* Physical frame number of the first usable frame in the area */
+	uintptr_t base;
+	/* Physical frame number of the first frame outside the area */
+	uintptr_t top;
+	/* Combination ALLOC_MASK and order */
+	u8 *page_states;
+	/* One freelist for each possible block size, up to NLISTS */
+	struct free_list freelists[NLISTS];
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
+static inline bool area_overlaps(struct mem_area *a, uintptr_t pfn)
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
+static inline bool is_list_empty(struct free_list *p)
+{
+	return !p->next || !p->prev || p == p->next || p == p->prev;
+}
 
-	assert_msg(size == 0 || (uintptr_t)mem == -size ||
-		   (uintptr_t)mem + size > (uintptr_t)mem,
-		   "mem + size overflow: %p + %#zx", mem, size);
+static struct free_list *list_remove(struct free_list *l)
+{
+	if (is_list_empty(l))
+		return NULL;
 
-	if (size == 0) {
-		freelist = NULL;
-		return;
-	}
+	l->prev->next = l->next;
+	l->next->prev = l->prev;
+	l->prev = l->next = NULL;
 
-	spin_lock(&lock);
-	old_freelist = freelist;
-	freelist = mem;
-	end = mem + size;
-	while (mem + PAGE_SIZE != end) {
-		*(void **)mem = (mem + PAGE_SIZE);
-		mem += PAGE_SIZE;
-	}
+	return l;
+}
 
-	*(void **)mem = old_freelist;
-	spin_unlock(&lock);
+static void list_add(struct free_list *head, struct free_list *li)
+{
+	assert(li);
+	assert(head);
+	li->prev = head;
+	li->next = head->next;
+	head->next->prev = li;
+	head->next = li;
 }
 
-void free_pages_by_order(void *mem, unsigned int order)
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
 {
-	free_pages(mem, 1ul << (order + PAGE_SHIFT));
+	uintptr_t pfn = PFN(addr);
+	struct free_list *p;
+	uintptr_t i, idx;
+	u8 order;
+
+	assert(a && area_contains(a, pfn));
+	idx = pfn - a->base;
+	order = a->page_states[idx];
+	assert(!(order & ~ORDER_MASK) && order && (order < NLISTS));
+	assert(IS_ALIGNED_ORDER(pfn, order));
+	assert(area_contains(a, pfn + BIT(order) - 1));
+
+	/* Remove the block from its free list */
+	p = list_remove(addr);
+	assert(p);
+
+	/* update the block size for each page in the block */
+	for (i = 0; i < BIT(order); i++) {
+		assert(a->page_states[idx + i] == order);
+		a->page_states[idx + i] = order - 1;
+	}
+	order--;
+	/* add the first half block to the appropriate free list */
+	list_add(a->freelists + order, p);
+	/* add the second half block to the appropriate free list */
+	list_add(a->freelists + order, (void *)((pfn + BIT(order)) * PAGE_SIZE));
 }
 
-void *alloc_page()
+/*
+ * Returns a block whose alignment and size are at least the parameter values.
+ * If there is not enough free memory, NULL is returned.
+ *
+ * Both parameters must be not larger than the largest allowed order
+ */
+static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
 {
-	void *p;
+	struct free_list *p, *res = NULL;
+	u8 order;
 
-	if (!freelist)
-		return 0;
+	assert((al < NLISTS) && (sz < NLISTS));
+	/* we need the bigger of the two as starting point */
+	order = sz > al ? sz : al;
 
-	spin_lock(&lock);
-	p = freelist;
-	freelist = *(void **)freelist;
-	spin_unlock(&lock);
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
 
-	if (p)
-		memset(p, 0, PAGE_SIZE);
-	return p;
+	res = list_remove(p);
+	memset(a->page_states + (PFN(res) - a->base), ALLOC_MASK | order, BIT(order));
+	return res;
 }
 
 /*
- * Allocates (1 << order) physically contiguous and naturally aligned pages.
- * Returns NULL if there's no memory left.
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
  */
-void *alloc_pages(unsigned int order)
+static bool coalesce(struct mem_area *a, u8 order, uintptr_t pfn, uintptr_t pfn2)
 {
-	/* Generic list traversal. */
-	void *prev;
-	void *curr = NULL;
-	void *next = freelist;
+	uintptr_t first, second, i;
+	struct free_list *li;
 
-	/* Looking for a run of length (1 << order). */
-	unsigned long run = 0;
-	const unsigned long n = 1ul << order;
-	const unsigned long align_mask = (n << PAGE_SHIFT) - 1;
-	void *run_start = NULL;
-	void *run_prev = NULL;
-	unsigned long run_next_pa = 0;
-	unsigned long pa;
+	assert(IS_ALIGNED_ORDER(pfn, order) && IS_ALIGNED_ORDER(pfn2, order));
+	assert(pfn2 == pfn + BIT(order));
+	assert(a);
 
-	assert(order < sizeof(unsigned long) * 8);
+	if (!area_contains(a, pfn) || !area_contains(a, pfn2 + BIT(order) - 1))
+		return false;
+	first = pfn - a->base;
+	second = pfn2 - a->base;
+	if ((a->page_states[first] != order) || (a->page_states[second] != order))
+		return false;
 
-	spin_lock(&lock);
-	for (;;) {
-		prev = curr;
-		curr = next;
+	li = list_remove((void *)(pfn2 << PAGE_SHIFT));
+	assert(li);
+	li = list_remove((void *)(pfn << PAGE_SHIFT));
+	assert(li);
+	for (i = 0; i < (2ull << order); i++) {
+		assert(a->page_states[first + i] == order);
+		a->page_states[first + i] = order + 1;
+	}
+	list_add(a->freelists + order + 1, li);
+	return true;
+}
 
-		if (!curr) {
-			run_start = NULL;
-			break;
-		}
+/*
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
+ */
+static void _free_pages(void *mem)
+{
+	uintptr_t pfn2, pfn = PFN(mem);
+	struct mem_area *a = NULL;
+	uintptr_t i, p;
+	u8 order;
 
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
+	if (!mem)
+		return;
+	assert(IS_ALIGNED((uintptr_t)mem, PAGE_SIZE));
+	for (i = 0; !a && (i < MAX_AREAS); i++) {
+		if ((areas_mask & BIT(i)) && area_contains(areas + i, pfn))
+			a = areas + i;
+	}
+	assert_msg(a, "memory does not belong to any area: %p", mem);
 
-		if (run == n) {
-			if (run_prev)
-				*((void **) run_prev) = next;
-			else
-				freelist = next;
-			break;
-		}
+	p = pfn - a->base;
+	order = a->page_states[p] & ORDER_MASK;
+
+	assert(a->page_states[p] == (order | ALLOC_MASK));
+	assert(order < NLISTS);
+	assert(IS_ALIGNED_ORDER(pfn, order));
+	assert(area_contains(a, pfn + BIT(order) - 1));
+
+	for (i = 0; i < BIT(order); i++) {
+		assert(a->page_states[p + i] == (ALLOC_MASK | order));
+		a->page_states[p + i] &= ~ALLOC_MASK;
 	}
-	spin_unlock(&lock);
-	if (run_start)
-		memset(run_start, 0, n * PAGE_SIZE);
-	return run_start;
+	list_add(a->freelists + order, mem);
+	do {
+		order = a->page_states[p] & ORDER_MASK;
+		if (!IS_ALIGNED_ORDER(pfn, order + 1))
+			pfn = pfn - BIT(order);
+		pfn2 = pfn + BIT(order);
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
+	return alloc_pages_area(~0, order);
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
+	return memalign_pages_area(~0, alignment, size);
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
+static void _page_alloc_init_area(int n, uintptr_t start, uintptr_t top)
+{
+	size_t table_size, npages, i;
+	struct mem_area *a;
+	u8 order = 0;
+
+	if (n == -1) {
+		for (n = 0; n < MAX_AREAS; n++) {
+			if (!(areas_mask & BIT(n)))
+				break;
+		}
+	}
+	assert(n < MAX_AREAS);
+	assert(!(areas_mask & BIT(n)));
+
+	assert(top > start);
+	assert(top - start > 4);
+	assert(top < BIT_ULL(sizeof(void *) * 8 - PAGE_SHIFT));
+
+	table_size = (top - start + PAGE_SIZE) / (PAGE_SIZE + 1);
+
+	a = areas + n;
+	a->page_states = (void *)(start << PAGE_SHIFT);
+	a->base = start + table_size;
+	a->top = top;
+	npages = top - a->base;
+
+	assert((a->base - start) * PAGE_SIZE >= npages);
+	for (i = 0; i < MAX_AREAS; i++) {
+		if (!(areas_mask & BIT(i)))
+			continue;
+		assert(!area_overlaps(areas + i, start));
+		assert(!area_overlaps(areas + i, top - 1));
+		assert(!area_overlaps(a, PFN(areas[i].page_states)));
+		assert(!area_overlaps(a, areas[i].top - 1));
+	}
+	for (i = 0; i < NLISTS; i++)
+		a->freelists[i].next = a->freelists[i].prev = a->freelists + i;
+
+	for (i = a->base; i < a->top; i += 1ull << order) {
+		while (i + BIT(order) > a->top) {
+			assert(order);
+			order--;
+		}
+		while (IS_ALIGNED_ORDER(i, order + 1) && (i + BIT(order + 1) <= a->top))
+			order++;
+		assert(order < NLISTS);
+		memset(a->page_states + (i - a->base), order, BIT(order));
+		list_add(a->freelists + order, (void *)(i << PAGE_SHIFT));
+	}
+	areas_mask |= BIT(n);
+}
+
+/*
+ * Adds a new memory area to the pool of available memory.
+ *
+ * Prerequisites:
+ * see _page_alloc_init_area
+ */
+void page_alloc_init_area(int n, uintptr_t base_pfn, uintptr_t top_pfn)
+{
+	spin_lock(&lock);
+	_page_alloc_init_area(n, base_pfn, top_pfn);
+	spin_unlock(&lock);
 }
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 78562e4..a3c573f 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -155,7 +155,7 @@ static void mem_init(phys_addr_t freemem_start)
 	assert(sizeof(long) == 8 || !(base >> 32));
 	if (sizeof(long) != 8 && (top >> 32) != 0)
 		top = ((uint64_t)1 << 32);
-	free_pages((void *)(unsigned long)base, top - base);
+	page_alloc_init_area(-1, base, top);
 	page_alloc_ops_enable();
 }
 
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 4054d0e..c25d442 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -37,11 +37,16 @@ static void mem_init(phys_addr_t mem_end)
 
 	phys_alloc_init(freemem_start, mem_end - freemem_start);
 	phys_alloc_get_unused(&base, &top);
-	base = (base + PAGE_SIZE - 1) & -PAGE_SIZE;
-	top = top & -PAGE_SIZE;
+	base = PAGE_ALIGN(base) >> PAGE_SHIFT;
+	top = top >> PAGE_SHIFT;
 
 	/* Make the pages available to the physical allocator */
-	free_pages((void *)(unsigned long)base, top - base);
+	if (top > (2ull * SZ_1G >> PAGE_SHIFT)) {
+		page_alloc_init_area(0, 2ull * SZ_1G >> PAGE_SHIFT, top);
+		page_alloc_init_area(1, base, 2ull * SZ_1G >> PAGE_SHIFT);
+	} else {
+		page_alloc_init_area(1, base, top);
+	}
 	page_alloc_ops_enable();
 }
 
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 2860e9c..d954094 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -190,7 +190,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 
 	sigp_retry(cpu->addr, SIGP_INITIAL_CPU_RESET, 0, NULL);
 
-	lc = alloc_pages(1);
+	lc = alloc_pages_area(_AREA(1), 1);
 	cpu->lowcore = lc;
 	memset(lc, 0, PAGE_SIZE * 2);
 	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index aca0876..f72c5b3 100644
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
+		page_alloc_init_area(1, base, top);
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
+		page_alloc_init_area(0, base, top);
 	}
 
 	spin_lock(&lock);
-- 
2.26.2

