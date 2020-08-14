Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868E1244BAE
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 17:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgHNPK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 11:10:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727900AbgHNPKU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Aug 2020 11:10:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07EF3nnk001439
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=42z7/syVnL4rJ1PUj2m77ri03EIabqjzkgk4Sj1XGQI=;
 b=J+NK9mw6zkUuM8WPX6E++oSD1rkjKFxjoOoBY/mw4T/A5q5p/i5HMuguXOomoqP57A00
 VBpx4LnBDoFRGOG2O5Hf15R7frjLeTEHgn+ZVl/cD8xAyvMcrhjqzQD5uKiHwp/FWd3k
 xqJqAhO0vojUBX3k4D6VSYLsqlJozq6ouc6ZjC4GV1cX97Y3Wn2EIgVKHEjqYR9wtD0a
 Pblr3fraDmx+y5FgcgadeGK6iTu4gF0Caj34Y9cH5/KWxgu0jNKjlfiF7dd+p5INhOfQ
 I4cTQ5SHd2pz232b33lv85RvBmR7dqBNi2DrbnML5+oTNNPdjQ3FeVhH78j5tTKHcRL0 Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w5mxgs5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:19 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07EF47pK002805
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:19 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w5mxgs3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 11:10:19 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07EF87oV006172;
        Fri, 14 Aug 2020 15:10:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 32skah45e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 15:10:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07EFABe517826184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 15:10:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE51CA4040;
        Fri, 14 Aug 2020 15:10:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 861EAA404D;
        Fri, 14 Aug 2020 15:10:10 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.223])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 15:10:10 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests RFC v1 1/5] lib/vmalloc: vmalloc support for handling allocation metadata
Date:   Fri, 14 Aug 2020 17:10:05 +0200
Message-Id: <20200814151009.55845-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200814151009.55845-1-imbrenda@linux.ibm.com>
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_09:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=2 clxscore=1015 impostorscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008140114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/vmalloc.c | 105 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 95 insertions(+), 10 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index e0c7b6b..aca0876 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -15,6 +15,13 @@
 #include <bitops.h>
 #include "vmalloc.h"
 
+#define VM_MAGIC 0x7E57C0DE
+
+struct metadata {
+	unsigned long npages;
+	unsigned long magic;
+};
+
 static struct spinlock lock;
 static void *vfree_top = 0;
 static void *page_root;
@@ -25,8 +32,14 @@ static void *page_root;
  *
  * nr is the number of pages to allocate
  * alignment_pages is the alignment of the allocation *in pages*
+ * metadata indicates whether an extra (unaligned) page needs to be allocated
+ * right before the main (aligned) allocation.
+ *
+ * The return value points to the first allocated virtual page, which will
+ * be the (potentially unaligned) metadata page if the metadata flag is
+ * specified.
  */
-void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
+static void *do_alloc_vpages(ulong nr, unsigned int align_order, bool metadata)
 {
 	uintptr_t ptr;
 
@@ -34,6 +47,8 @@ void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
 	ptr = (uintptr_t)vfree_top;
 	ptr -= PAGE_SIZE * nr;
 	ptr &= GENMASK_ULL(63, PAGE_SHIFT + align_order);
+	if (metadata)
+		ptr -= PAGE_SIZE;
 	vfree_top = (void *)ptr;
 	spin_unlock(&lock);
 
@@ -41,6 +56,11 @@ void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
 	return (void *)ptr;
 }
 
+void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
+{
+	return do_alloc_vpages(nr, align_order, false);
+}
+
 void *alloc_vpages(ulong nr)
 {
 	return alloc_vpages_aligned(nr, 0);
@@ -69,35 +89,100 @@ void *vmap(phys_addr_t phys, size_t size)
 	return mem;
 }
 
+/*
+ * Allocate one page, for an object with specified alignment.
+ * The resulting pointer will be aligned to the required alignment, but
+ * intentionally not page-aligned.
+ */
+static void *vm_alloc_one_page(size_t alignment)
+{
+	void *p;
+
+	assert(alignment >= sizeof(uintptr_t));
+	assert(alignment < PAGE_SIZE);
+	p = alloc_vpage();
+	install_page(page_root, virt_to_phys(alloc_page()), p);
+	/* write the magic at the beginning of the page */
+	*(uintptr_t *)p = VM_MAGIC;
+	return (void*)((uintptr_t)p + alignment);
+}
+
+static struct metadata *get_metadata(void *p)
+{
+	struct metadata *m = p;
+
+	return m - 1;
+}
+
 /*
  * Allocate virtual memory, with the specified minimum alignment.
+ * If the allocation fits in one page, only one page is allocated. Otherwise
+ * enough pages are allocated for the object, plus one to keep metadata
+ * information about the allocation.
  */
 static void *vm_memalign(size_t alignment, size_t size)
 {
+	struct metadata *m;
 	phys_addr_t pa;
-	void *mem, *p;
+	uintptr_t p;
+	void *mem;
+	size_t i;
 
+	if (!size)
+		return NULL;
 	assert(is_power_of_2(alignment));
 
+	if (alignment < sizeof(uintptr_t))
+		alignment = sizeof(uintptr_t);
+	/* it fits in one page, allocate only one page */
+	if (alignment + size <= PAGE_SIZE)
+		return vm_alloc_one_page(alignment);
 	size = PAGE_ALIGN(size) / PAGE_SIZE;
 	alignment = get_order(PAGE_ALIGN(alignment) / PAGE_SIZE);
-	mem = p = alloc_vpages_aligned(size, alignment);
-	while (size--) {
+	mem = do_alloc_vpages(size, alignment, true);
+	p = (uintptr_t)mem;
+	/* skip the metadata page */
+	mem = (void *)(p + PAGE_SIZE);
+	/*
+	 * time to actually allocate the physical pages to back our virtual
+	 * allocation; note that we need to allocate one extra page (for the
+	 * metadata), hence the <=
+	 */
+	for (i = 0; i <= size; i++, p += PAGE_SIZE) {
 		pa = virt_to_phys(alloc_page());
 		assert(pa);
-		install_page(page_root, pa, p);
-		p += PAGE_SIZE;
+		install_page(page_root, pa, (void *)p);
 	}
+	m = get_metadata(mem);
+	m->npages = size;
+	m->magic = VM_MAGIC;
 	return mem;
 }
 
 static void vm_free(void *mem, size_t size)
 {
-	while (size) {
-		free_page(phys_to_virt(virt_to_pte_phys(page_root, mem)));
-		mem += PAGE_SIZE;
-		size -= PAGE_SIZE;
+	struct metadata *m;
+	uintptr_t ptr, end;
+
+	/* the pointer is not page-aligned, it was a single-page allocation */
+	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
+		ptr = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
+		assert(*(uintptr_t *)ptr == VM_MAGIC);
+		free_page(phys_to_virt(ptr));
+		return;
 	}
+
+	/* the pointer is page-aligned, it was a multi-page allocation */
+	m = get_metadata(mem);
+	assert(m->magic == VM_MAGIC);
+	assert(m->npages > 0);
+	/* free all the pages including the metadata page */
+	ptr = (uintptr_t)mem - PAGE_SIZE;
+	end = ptr + m->npages * PAGE_SIZE;
+	for ( ; ptr < end; ptr += PAGE_SIZE)
+		free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));
+	/* free the last one separately to avoid overflow issues */
+	free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));
 }
 
 static struct alloc_ops vmalloc_ops = {
-- 
2.26.2

