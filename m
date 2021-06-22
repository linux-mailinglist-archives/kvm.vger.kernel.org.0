Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F188D3AFF29
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhFVIYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:24:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhFVIX7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:23:59 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M83VZb020870;
        Tue, 22 Jun 2021 04:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VbgoqI8xf5FF04ubf+nNB2NABedf5yP5YcO7TRDVgGE=;
 b=KnzNyyn6FHHsGgdMh2Rn5Ty/HzhoECVK1B4CGovyNoVgOennvYeJrnBDOAV38AStNls+
 fji3lavNGoWGobmcn32RmurpmWpsAjAM69TAytZmN82wD2zyp97a32SwSdaGIewNyYVa
 HM5tt6e2KdFPwiL7Hwwuc3lja0rWmebbwnuwl8CPwJmJIXsXs+LPbjhKFdqDMaXin7Z3
 zP45a9Qpy1ylkKE+CCIdppoPdeV7PoF6W6L+2DfZK5dTwbGMU4Vrv2tTn6NqbJsHitYQ
 cuvDNa5wjnUezZza9XBV2th4RE6ZQdDF9o0KDqqiSAqSqFPrXN/1LYe5VmcwLsuEsQe7 gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b8ng5ukk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:43 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M83ovj022033;
        Tue, 22 Jun 2021 04:21:43 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b8ng5uk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:42 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8Ex2V004795;
        Tue, 22 Jun 2021 08:21:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3997uhgqg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8Lbpj31654288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:21:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2284AE053;
        Tue, 22 Jun 2021 08:21:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F8C3AE04D;
        Tue, 22 Jun 2021 08:21:37 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 11/12] s390x: mmu: add support for large pages
Date:   Tue, 22 Jun 2021 10:20:41 +0200
Message-Id: <20210622082042.13831-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622082042.13831-1-frankja@linux.ibm.com>
References: <20210622082042.13831-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M5sPKiCkNu46-BO3LCbdrmo9zdGVv92R
X-Proofpoint-ORIG-GUID: -mqYF1Wr8Bj5_Ha8yP1lr4VXDKZSCiM3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Add support for 1M and 2G pages.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@de.ibm.com>
Message-Id: <20210611140705.553307-7-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/mmu.c | 264 +++++++++++++++++++++++++++++++++++++++++++-----
 lib/s390x/mmu.h |  84 ++++++++++++++-
 2 files changed, 321 insertions(+), 27 deletions(-)

diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
index 5c517366..c973443b 100644
--- a/lib/s390x/mmu.c
+++ b/lib/s390x/mmu.c
@@ -15,6 +15,18 @@
 #include <vmalloc.h>
 #include "mmu.h"
 
+/*
+ * The naming convention used here is the same as used in the Linux kernel;
+ * this is the correspondence between the s390x architectural names and the
+ * Linux ones:
+ *
+ * pgd - region 1 table entry
+ * p4d - region 2 table entry
+ * pud - region 3 table entry
+ * pmd - segment table entry
+ * pte - page table entry
+ */
+
 static pgd_t *table_root;
 
 void configure_dat(int enable)
@@ -46,54 +58,256 @@ static void mmu_enable(pgd_t *pgtable)
 	lc->pgm_new_psw.mask |= PSW_MASK_DAT;
 }
 
-static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
+/*
+ * Get the pud (region 3) DAT table entry for the given address and root,
+ * allocating it if necessary
+ */
+static inline pud_t *get_pud(pgd_t *pgtable, uintptr_t vaddr)
 {
 	pgd_t *pgd = pgd_offset(pgtable, vaddr);
 	p4d_t *p4d = p4d_alloc(pgd, vaddr);
 	pud_t *pud = pud_alloc(p4d, vaddr);
-	pmd_t *pmd = pmd_alloc(pud, vaddr);
-	pte_t *pte = pte_alloc(pmd, vaddr);
 
-	return &pte_val(*pte);
+	return pud;
+}
+
+/*
+ * Get the pmd (segment) DAT table entry for the given address and pud,
+ * allocating it if necessary.
+ * The pud must not be huge.
+ */
+static inline pmd_t *get_pmd(pud_t *pud, uintptr_t vaddr)
+{
+	pmd_t *pmd;
+
+	assert(!pud_huge(*pud));
+	pmd = pmd_alloc(pud, vaddr);
+	return pmd;
+}
+
+/*
+ * Get the pte (page) DAT table entry for the given address and pmd,
+ * allocating it if necessary.
+ * The pmd must not be large.
+ */
+static inline pte_t *get_pte(pmd_t *pmd, uintptr_t vaddr)
+{
+	pte_t *pte;
+
+	assert(!pmd_large(*pmd));
+	pte = pte_alloc(pmd, vaddr);
+	return pte;
+}
+
+/*
+ * Splits a large pmd (segment) DAT table entry into equivalent 4kB small
+ * pages.
+ * @pmd The pmd to split, it must be large.
+ * @va the virtual address corresponding to this pmd.
+ */
+static void split_pmd(pmd_t *pmd, uintptr_t va)
+{
+	phys_addr_t pa = pmd_val(*pmd) & SEGMENT_ENTRY_SFAA;
+	unsigned long i, prot;
+	pte_t *pte;
+
+	assert(pmd_large(*pmd));
+	pte = alloc_pages(PAGE_TABLE_ORDER);
+	prot = pmd_val(*pmd) & (SEGMENT_ENTRY_IEP | SEGMENT_ENTRY_P);
+	for (i = 0; i < PAGE_TABLE_ENTRIES; i++)
+		pte_val(pte[i]) =  pa | PAGE_SIZE * i | prot;
+	idte_pmdp(va, &pmd_val(*pmd));
+	pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT;
+
+}
+
+/*
+ * Splits a huge pud (region 3) DAT table entry into equivalent 1MB large
+ * pages.
+ * @pud The pud to split, it must be huge.
+ * @va the virtual address corresponding to this pud.
+ */
+static void split_pud(pud_t *pud, uintptr_t va)
+{
+	phys_addr_t pa = pud_val(*pud) & REGION3_ENTRY_RFAA;
+	unsigned long i, prot;
+	pmd_t *pmd;
+
+	assert(pud_huge(*pud));
+	pmd = alloc_pages(SEGMENT_TABLE_ORDER);
+	prot = pud_val(*pud) & (REGION3_ENTRY_IEP | REGION_ENTRY_P);
+	for (i = 0; i < SEGMENT_TABLE_ENTRIES; i++)
+		pmd_val(pmd[i]) =  pa | SZ_1M * i | prot | SEGMENT_ENTRY_FC | SEGMENT_ENTRY_TT_SEGMENT;
+	idte_pudp(va, &pud_val(*pud));
+	pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 | REGION_TABLE_LENGTH;
+}
+
+void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level)
+{
+	uintptr_t va = (uintptr_t)vaddr;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	assert(level && (level <= 5));
+	pgd = pgd_offset(pgtable, va);
+	if (level == pgtable_level_pgd)
+		return pgd;
+	p4d = p4d_alloc(pgd, va);
+	if (level == pgtable_level_p4d)
+		return p4d;
+	pud = pud_alloc(p4d, va);
+
+	if (level == pgtable_level_pud)
+		return pud;
+	if (!pud_none(*pud) && pud_huge(*pud))
+		split_pud(pud, va);
+	pmd = get_pmd(pud, va);
+	if (level == pgtable_level_pmd)
+		return pmd;
+	if (!pmd_none(*pmd) && pmd_large(*pmd))
+		split_pmd(pmd, va);
+	return get_pte(pmd, va);
+}
+
+void *split_page(pgd_t *pgtable, void *vaddr, enum pgt_level level)
+{
+	assert((level >= 3) && (level <= 5));
+	return get_dat_entry(pgtable ? pgtable : table_root, vaddr, level);
 }
 
 phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *vaddr)
 {
-	return (*get_pte(pgtable, (uintptr_t)vaddr) & PAGE_MASK) +
-	       ((unsigned long)vaddr & ~PAGE_MASK);
+	uintptr_t va = (uintptr_t)vaddr;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pud = get_pud(pgtable, va);
+	if (pud_huge(*pud))
+		return (pud_val(*pud) & REGION3_ENTRY_RFAA) | (va & ~REGION3_ENTRY_RFAA);
+	pmd = get_pmd(pud, va);
+	if (pmd_large(*pmd))
+		return (pmd_val(*pmd) & SEGMENT_ENTRY_SFAA) | (va & ~SEGMENT_ENTRY_SFAA);
+	pte = get_pte(pmd, va);
+	return (pte_val(*pte) & PAGE_MASK) | (va & ~PAGE_MASK);
 }
 
-static pteval_t *set_pte(pgd_t *pgtable, pteval_t val, void *vaddr)
+/*
+ * Get the DAT table entry of the given level for the given address,
+ * splitting if necessary. If the entry was not invalid, invalidate it, and
+ * return the pointer to the entry and, if requested, its old value.
+ * @pgtable root of the page tables
+ * @vaddr virtual address
+ * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4kB pages)
+ * @old if not NULL, will be written with the old value of the DAT table
+ * entry before invalidation
+ */
+static void *dat_get_and_invalidate(pgd_t *pgtable, void *vaddr, enum pgt_level level, unsigned long *old)
 {
-	pteval_t *p_pte = get_pte(pgtable, (uintptr_t)vaddr);
+	unsigned long va = (unsigned long)vaddr;
+	void *ptr;
 
-	/* first flush the old entry (if we're replacing anything) */
-	if (!(*p_pte & PAGE_ENTRY_I))
-		ipte((uintptr_t)vaddr, p_pte);
+	ptr = get_dat_entry(pgtable, vaddr, level);
+	if (old)
+		*old = *(unsigned long *)ptr;
+	if ((level == pgtable_level_pgd) && !pgd_none(*(pgd_t *)ptr))
+		idte_pgdp(va, ptr);
+	else if ((level == pgtable_level_p4d) && !p4d_none(*(p4d_t *)ptr))
+		idte_p4dp(va, ptr);
+	else if ((level == pgtable_level_pud) && !pud_none(*(pud_t *)ptr))
+		idte_pudp(va, ptr);
+	else if ((level == pgtable_level_pmd) && !pmd_none(*(pmd_t *)ptr))
+		idte_pmdp(va, ptr);
+	else if (!pte_none(*(pte_t *)ptr))
+		ipte(va, ptr);
+	return ptr;
+}
 
-	*p_pte = val;
-	return p_pte;
+static void cleanup_pmd(pmd_t *pmd)
+{
+	/* was invalid or large, nothing to do */
+	if (pmd_none(*pmd) || pmd_large(*pmd))
+		return;
+	/* was not large, free the corresponding page table */
+	free_pages((void *)(pmd_val(*pmd) & PAGE_MASK));
+}
+
+static void cleanup_pud(pud_t *pud)
+{
+	unsigned long i;
+	pmd_t *pmd;
+
+	/* was invalid or large, nothing to do */
+	if (pud_none(*pud) || pud_huge(*pud))
+		return;
+	/* recursively clean up all pmds if needed */
+	pmd = (pmd_t *)(pud_val(*pud) & PAGE_MASK);
+	for (i = 0; i < SEGMENT_TABLE_ENTRIES; i++)
+		cleanup_pmd(pmd + i);
+	/* free the corresponding segment table */
+	free_pages(pmd);
+}
+
+/*
+ * Set the DAT entry for the given level of the given virtual address. If a
+ * mapping already existed, it is overwritten. If an existing mapping with
+ * smaller pages existed, all the lower tables are freed.
+ * Returns the pointer to the DAT table entry.
+ * @pgtable root of the page tables
+ * @val the new value for the DAT table entry
+ * @vaddr the virtual address
+ * @level 3 for pud (region 3), 4 for pmd (segment) and 5 for pte (pages)
+ */
+static void *set_dat_entry(pgd_t *pgtable, unsigned long val, void *vaddr, enum pgt_level level)
+{
+	unsigned long old, *res;
+
+	res = dat_get_and_invalidate(pgtable, vaddr, level, &old);
+	if (level == pgtable_level_pmd)
+		cleanup_pmd((pmd_t *)&old);
+	if (level == pgtable_level_pud)
+		cleanup_pud((pud_t *)&old);
+	*res = val;
+	return res;
 }
 
 pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr)
 {
-	return set_pte(pgtable, __pa(phys), vaddr);
+	assert(IS_ALIGNED(phys, PAGE_SIZE));
+	assert(IS_ALIGNED((uintptr_t)vaddr, PAGE_SIZE));
+	return set_dat_entry(pgtable, phys, vaddr, pgtable_level_pte);
 }
 
-void protect_page(void *vaddr, unsigned long prot)
+pmdval_t *install_large_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr)
 {
-	pteval_t *p_pte = get_pte(table_root, (uintptr_t)vaddr);
-	pteval_t n_pte = *p_pte | prot;
-
-	set_pte(table_root, n_pte, vaddr);
+	assert(IS_ALIGNED(phys, SZ_1M));
+	assert(IS_ALIGNED((uintptr_t)vaddr, SZ_1M));
+	return set_dat_entry(pgtable, phys | SEGMENT_ENTRY_FC, vaddr, pgtable_level_pmd);
 }
 
-void unprotect_page(void *vaddr, unsigned long prot)
+pudval_t *install_huge_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr)
 {
-	pteval_t *p_pte = get_pte(table_root, (uintptr_t)vaddr);
-	pteval_t n_pte = *p_pte & ~prot;
+	assert(IS_ALIGNED(phys, SZ_2G));
+	assert(IS_ALIGNED((uintptr_t)vaddr, SZ_2G));
+	return set_dat_entry(pgtable, phys | REGION3_ENTRY_FC | REGION_ENTRY_TT_REGION3, vaddr, pgtable_level_pud);
+}
 
-	set_pte(table_root, n_pte, vaddr);
+void protect_dat_entry(void *vaddr, unsigned long prot, enum pgt_level level)
+{
+	unsigned long old, *ptr;
+
+	ptr = dat_get_and_invalidate(table_root, vaddr, level, &old);
+	*ptr = old | prot;
+}
+
+void unprotect_dat_entry(void *vaddr, unsigned long prot, enum pgt_level level)
+{
+	unsigned long old, *ptr;
+
+	ptr = dat_get_and_invalidate(table_root, vaddr, level, &old);
+	*ptr = old & ~prot;
 }
 
 void protect_range(void *start, unsigned long len, unsigned long prot)
@@ -102,7 +316,7 @@ void protect_range(void *start, unsigned long len, unsigned long prot)
 
 	len &= PAGE_MASK;
 	for (; len; len -= PAGE_SIZE, curr += PAGE_SIZE)
-		protect_page((void *)curr, prot);
+		protect_dat_entry((void *)curr, prot, 5);
 }
 
 void unprotect_range(void *start, unsigned long len, unsigned long prot)
@@ -111,7 +325,7 @@ void unprotect_range(void *start, unsigned long len, unsigned long prot)
 
 	len &= PAGE_MASK;
 	for (; len; len -= PAGE_SIZE, curr += PAGE_SIZE)
-		unprotect_page((void *)curr, prot);
+		unprotect_dat_entry((void *)curr, prot, 5);
 }
 
 static void setup_identity(pgd_t *pgtable, phys_addr_t start_addr,
diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
index b995f85b..ab35d782 100644
--- a/lib/s390x/mmu.h
+++ b/lib/s390x/mmu.h
@@ -10,9 +10,89 @@
 #ifndef _S390X_MMU_H_
 #define _S390X_MMU_H_
 
-void protect_page(void *vaddr, unsigned long prot);
+enum pgt_level {
+	pgtable_level_pgd = 1,
+	pgtable_level_p4d,
+	pgtable_level_pud,
+	pgtable_level_pmd,
+	pgtable_level_pte,
+};
+
+/*
+ * Splits the pagetables down to the given DAT tables level.
+ * Returns a pointer to the DAT table entry of the given level.
+ * @pgtable root of the page table tree
+ * @vaddr address whose page tables are to split
+ * @level 3 (for 2GB pud), 4 (for 1 MB pmd) or 5 (for 4KB pages)
+ */
+void *split_page(pgd_t *pgtable, void *vaddr, enum pgt_level level);
+
+/*
+ * Applies the given protection bits to the given DAT tables level,
+ * splitting if necessary.
+ * @pgtable root of the page table tree
+ * @vaddr address whose protection bits are to be changed
+ * @prot the protection bits to set
+ * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4KB pages)
+ */
+void protect_dat_entry(void *vaddr, unsigned long prot, enum pgt_level level);
+
+/*
+ * Clears the given protection bits from the given DAT tables level,
+ * splitting if necessary.
+ * @pgtable root of the page table tree
+ * @vaddr address whose protection bits are to be changed
+ * @prot the protection bits to clear
+ * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4kB pages)
+ */
+void unprotect_dat_entry(void *vaddr, unsigned long prot, enum pgt_level level);
+
+/*
+ * Applies the given protection bits to the given 4kB pages range,
+ * splitting if necessary.
+ * @start starting address whose protection bits are to be changed
+ * @len size in bytes
+ * @prot the protection bits to set
+ */
 void protect_range(void *start, unsigned long len, unsigned long prot);
-void unprotect_page(void *vaddr, unsigned long prot);
+
+/*
+ * Clears the given protection bits from the given 4kB pages range,
+ * splitting if necessary.
+ * @start starting address whose protection bits are to be changed
+ * @len size in bytes
+ * @prot the protection bits to set
+ */
 void unprotect_range(void *start, unsigned long len, unsigned long prot);
 
+/* Similar to install_page, maps the virtual address to the physical address
+ * for the given page tables, using 1MB large pages.
+ * Returns a pointer to the DAT table entry.
+ * @pgtable root of the page table tree
+ * @phys physical address to map, must be 1MB aligned!
+ * @vaddr virtual address to map, must be 1MB aligned!
+ */
+pmdval_t *install_large_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr);
+
+/* Similar to install_page, maps the virtual address to the physical address
+ * for the given page tables, using 2GB huge pages.
+ * Returns a pointer to the DAT table entry.
+ * @pgtable root of the page table tree
+ * @phys physical address to map, must be 2GB aligned!
+ * @vaddr virtual address to map, must be 2GB aligned!
+ */
+pudval_t *install_huge_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr);
+
+static inline void protect_page(void *vaddr, unsigned long prot)
+{
+	protect_dat_entry(vaddr, prot, pgtable_level_pte);
+}
+
+static inline void unprotect_page(void *vaddr, unsigned long prot)
+{
+	unprotect_dat_entry(vaddr, prot, pgtable_level_pte);
+}
+
+void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
+
 #endif /* _ASMS390X_MMU_H_ */
-- 
2.31.1

