Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5AA2816FE
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388062AbgJBPod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:44:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26278 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388040AbgJBPo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:44:28 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092FWm4M142555
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XbOg4Q6+DrwFlErUmMzG4UbfnyVXPsTfI5UU2re81SM=;
 b=OHzto9H0s1U+KqqjKnVf52eL1H7zCoduu5indWGH7QGGuP6pwvd6QatgcW6sA9MrNmZr
 fMXTKhpoMzvCZTRHL9wmUSlvWUJ2RVSyU2lLEeE7serLEgg0eoJwweIIzwRZegJ1e8hq
 /2jT13CCFpOmuXiALnzvcSeMAwFVEi6g5nAHG4f2zv1+vCyFlhbH5SKQrAvHCDpqVZm0
 S2eQqOq8L4AtX9WdhMpoYFptDnG5LUk3JwrgyMnKWtKkeVhGXoDmO9Pu7WSM2KBPduTb
 GLJAzHmYoN4ugRpzG3G43H+QlyyfgHGBVemUQKampd4xsAiEOi1fqMrjErbb0ZkbTYUU yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x6sv0m3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 11:44:27 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092FXscf150831
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:27 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x6sv0m2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:44:26 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092FhF23011091;
        Fri, 2 Oct 2020 15:44:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 33svwguhm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:44:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092FiMfU33817004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:44:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5433D4203F;
        Fri,  2 Oct 2020 15:44:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED91442041;
        Fri,  2 Oct 2020 15:44:21 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.90])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:44:21 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/7] lib/vmalloc: vmalloc support for handling allocation metadata
Date:   Fri,  2 Oct 2020 17:44:15 +0200
Message-Id: <20201002154420.292134-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002154420.292134-1-imbrenda@linux.ibm.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=2 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add allocation metadata handling to vmalloc.

In upcoming patches, allocation metadata will have to be handled
directly bt the lower level allocators, and will not be handled by the
common wrapper.

In this patch, the number of allocated pages plus a magic value are
written immediately before the returned pointer. This means that multi
page allocations will allocate one extra page (which is not worse than
what the current allocator does).

For small allocations there is an optimization: the returned address is
intentionally not page-aligned. This signals that the allocation
spanned one page only. In this case the metadata is only the magic
value, and it is also saved immediately before the returned pointer.
Since the pointer does not point to the begininng of the page, there is
always space in the same page for the magic value.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/vmalloc.c | 105 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 95 insertions(+), 10 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index e0c7b6b..2f25734 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -15,6 +15,16 @@
 #include <bitops.h>
 #include "vmalloc.h"
 
+#define VM_MAGIC 0x7E57C0DE
+
+#define GET_METADATA(x) (((struct metadata *)(x)) - 1)
+#define GET_MAGIC(x) (*((unsigned long *)(x) - 1))
+
+struct metadata {
+	unsigned long npages;
+	unsigned long magic;
+};
+
 static struct spinlock lock;
 static void *vfree_top = 0;
 static void *page_root;
@@ -25,8 +35,14 @@ static void *page_root;
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
 
@@ -34,6 +50,8 @@ void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
 	ptr = (uintptr_t)vfree_top;
 	ptr -= PAGE_SIZE * nr;
 	ptr &= GENMASK_ULL(63, PAGE_SHIFT + align_order);
+	if (metadata)
+		ptr -= PAGE_SIZE;
 	vfree_top = (void *)ptr;
 	spin_unlock(&lock);
 
@@ -41,6 +59,11 @@ void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
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
@@ -69,35 +92,97 @@ void *vmap(phys_addr_t phys, size_t size)
 	return mem;
 }
 
+/*
+ * Allocate one page, for an object with specified alignment.
+ * The resulting pointer will be aligned to the required alignment, but
+ * intentionally not page-aligned.
+ * The metadata for single pages allocation is just the magic value,
+ * which is placed right before the pointer, like for bigger allocations.
+ */
+static void *vm_alloc_one_page(size_t alignment)
+{
+	void *p;
+
+	/* this guarantees that there will be space for the magic value */
+	assert(alignment >= sizeof(uintptr_t));
+	assert(alignment < PAGE_SIZE);
+	p = alloc_vpage();
+	install_page(page_root, virt_to_phys(alloc_page()), p);
+	p = (void *)((uintptr_t)p + alignment);
+	/* write the magic value right before the returned address */
+	GET_MAGIC(p) = VM_MAGIC;
+	return p;
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
+	m = GET_METADATA(mem);
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
+		assert(GET_MAGIC(mem) == VM_MAGIC);
+		ptr = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
+		free_page(phys_to_virt(ptr));
+		return;
 	}
+
+	/* the pointer is page-aligned, it was a multi-page allocation */
+	m = GET_METADATA(mem);
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

