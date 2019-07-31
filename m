Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8017C581
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388440AbfGaPIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:08:19 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35904 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387662AbfGaPIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:19 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so66032612edq.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wLPXwl8hvJobXFCl++g4aCvf+npUzZ0QqPbdONmdAQc=;
        b=R36gYrhWPE65DAN624GOKj6Zcvo/ac/skfKDjJ3xcAQFiNmr7dX573jmLVCRaNG72Z
         xcMGnyIs1LpXnhGK5JxEboIEAPxR/EeGcod/4MYW/A0bbBy9yBKnmU2CF6SqodBq1bbG
         2et49Q8QeC0Gi2N/dOFWHDkpO2qo6+z6lshk3KNGVbQlqNYxKAMnCnpgag0jzwh5HEUj
         dMc4Sem5sBJAfoYBQzfFvzczhmipMrh7ObYbRCqFmv9xdDuVsiGlTB/dwRP9co2iZadV
         LxdeXO4uRP+DUWTuqbPXM46fxWLgXQuCInUrkr1thUYy5i2Mt2bnKrQGqLbEspEV6MTU
         W2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wLPXwl8hvJobXFCl++g4aCvf+npUzZ0QqPbdONmdAQc=;
        b=lY5/alwe8gc+UCmQ5oqlljtb+MJqoeEV34v3Sw8XWGuxJYo9OQRq6aV4iX1cg2Q8z9
         IQEhz2HvsuJ4B+K5SNfRUB4v5aMzPUJWP29YhPcaF7tOrm0gMkpxMMwfWgDdCWTG5MGB
         3wiGJnLC/YHZWi5J3ZLr0GeMIDu4RT/8HrL+FwA4lRj6uFBhVHTlQSns67F9sHGRLsBK
         AcCueidsK8n6josAuNmh23PbUW2gtVbOk7MtU8MXVnCTxpyzHOMu7y7jBFKU9lQW719z
         tzWBPjrHJtR/tKD508QxAaQB5/qj90LexF5qJkHe2jjfxkgxxJxukNr8VPIIMp3Z43i0
         AItg==
X-Gm-Message-State: APjAAAWLGMas3ATmwHXPx9soBGOr7b3pf1vJNzY2LZm4Xr4dByakGzQo
        Id9ugxhF++87Yp5YBd23/J0=
X-Google-Smtp-Source: APXvYqw0oWdSxi7D+H/1P5QUyRaVYREdYgbW7LIf4XE4H22UAM6yie49PO/SDUQu/e/ngKqwbq3xkA==
X-Received: by 2002:a17:906:430a:: with SMTP id j10mr10514767ejm.92.1564585696918;
        Wed, 31 Jul 2019 08:08:16 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id y11sm12444493ejb.54.2019.07.31.08.08.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:15 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id F174F101319; Wed, 31 Jul 2019 18:08:15 +0300 (+03)
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 02/59] mm: Add helpers to setup zero page mappings
Date:   Wed, 31 Jul 2019 18:07:16 +0300
Message-Id: <20190731150813.26289-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When kernel sets up an encrypted page mapping, encryption KeyID is
derived from a VMA. KeyID is going to be part of vma->vm_page_prot and
it will be propagated transparently to page table entry on mk_pte().

But there is an exception: zero page is never encrypted and its mapping
must use KeyID-0, regardless VMA's KeyID.

Introduce helpers that create a page table entry for zero page.

The generic implementation will be overridden by architecture-specific
code that takes care about using correct KeyID.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/dax.c                      | 3 +--
 include/asm-generic/pgtable.h | 8 ++++++++
 mm/huge_memory.c              | 6 ++----
 mm/memory.c                   | 3 +--
 mm/userfaultfd.c              | 3 +--
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index a237141d8787..6ecc9c560e62 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1445,8 +1445,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		mm_inc_nr_ptes(vma->vm_mm);
 	}
-	pmd_entry = mk_pmd(zero_page, vmf->vma->vm_page_prot);
-	pmd_entry = pmd_mkhuge(pmd_entry);
+	pmd_entry = mk_zero_pmd(zero_page, vmf->vma->vm_page_prot);
 	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
 	spin_unlock(ptl);
 	trace_dax_pmd_load_hole(inode, vmf, zero_page, *entry);
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 75d9d68a6de7..afcfbb4af4b2 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -879,8 +879,16 @@ static inline unsigned long my_zero_pfn(unsigned long addr)
 }
 #endif
 
+#ifndef mk_zero_pte
+#define mk_zero_pte(addr, prot) pte_mkspecial(pfn_pte(my_zero_pfn(addr), prot))
+#endif
+
 #ifdef CONFIG_MMU
 
+#ifndef mk_zero_pmd
+#define mk_zero_pmd(zero_page, prot) pmd_mkhuge(mk_pmd(zero_page, prot))
+#endif
+
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1334ede667a8..e9a791413730 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -678,8 +678,7 @@ static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 	pmd_t entry;
 	if (!pmd_none(*pmd))
 		return false;
-	entry = mk_pmd(zero_page, vma->vm_page_prot);
-	entry = pmd_mkhuge(entry);
+	entry = mk_zero_pmd(zero_page, vma->vm_page_prot);
 	if (pgtable)
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
@@ -2109,8 +2108,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
 		pte_t *pte, entry;
-		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
-		entry = pte_mkspecial(entry);
+		entry = mk_zero_pte(haddr, vma->vm_page_prot);
 		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, haddr, pte, entry);
diff --git a/mm/memory.c b/mm/memory.c
index e2bb51b6242e..81ae8c39f75b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2970,8 +2970,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	/* Use the zero-page for reads */
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm)) {
-		entry = pte_mkspecial(pfn_pte(my_zero_pfn(vmf->address),
-						vma->vm_page_prot));
+		entry = mk_zero_pte(vmf->address, vma->vm_page_prot);
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				vmf->address, &vmf->ptl);
 		if (!pte_none(*vmf->pte))
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c7ae74ce5ff3..06bf4ea3ee05 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -120,8 +120,7 @@ static int mfill_zeropage_pte(struct mm_struct *dst_mm,
 	pgoff_t offset, max_off;
 	struct inode *inode;
 
-	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
-					 dst_vma->vm_page_prot));
+	_dst_pte = mk_zero_pte(dst_addr, dst_vma->vm_page_prot);
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
 	if (dst_vma->vm_file) {
 		/* the shmem MAP_PRIVATE case requires checking the i_size */
-- 
2.21.0

