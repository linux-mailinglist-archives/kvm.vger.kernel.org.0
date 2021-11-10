Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBD144CB43
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhKJVXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbhKJVXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:36 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE02C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:35 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id w5-20020a654105000000b002692534afceso2139305pgp.8
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h3spP/vp31gv6EH9eeJCr+gicdzSKq1WmRD/CWJvpPw=;
        b=QgHYUwUsWz1Zq9or9EO86AThBuYMfz38j4gTTuQ3D1oJnYBe8h0+cU6XIFg8PAyyRO
         FbXkifjGf8jD0RhSGXqyri6KXqNqdp7PdtL+csl5gyS43zHbBXUku5JC4jZtMw4tV/vg
         ceBxCZ6BcbMKfvhiYB9vlXhO25TxUtj7/CcduCXz8rtzEp6pffkTXn/Atpi5l0uiiC6P
         a/r9K6sBYE0m1pw7qqPEV4iDhuyZ5bEYdbRorpJD1yCECmbmrom7hjl6y/hzo2GxHyFC
         ZYziJt1KdBVSqgIrsKs+QXTnJHJworCUTvtur6HebPFklOsgke2soLcVgtGmSbP5Tffo
         V/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h3spP/vp31gv6EH9eeJCr+gicdzSKq1WmRD/CWJvpPw=;
        b=GOk2IMPZC3zi1Mk52/JVigum0xM6Q6Kmt3uJ2qZL2wKKoYyg6ouaesD8V0t84UwZ8x
         ObeAIVmkMbcIAVA/ERYkpr757/n0qVxrhQ9WhMrpWQNI2m9VSY4KA/t4oeRWv6TE1jbw
         Ami8VxIWaWwa3TUaO3p2rfFWZ7PcfNceukN47sJj2T7ROVrfmQ7nFHOcjbOJZbfvJXnp
         0nuADSosLr5EMyeMhMbKyYXH3i39A9Z74Gr3l/vXrVAYHuxBE3Wh4RS7svKUkRxlg5A5
         8DNGd73CK1lt7kOrcEkDbaGaB0SnOIjBggQUvQ0+BHXh7qGOSg9OsE+tZr0DbXwA7zlp
         ZcxQ==
X-Gm-Message-State: AOAM532ya1Cb+hmVU8KOxSSJIwSVGsArVFuQAfEe9k6hk9uW2cDCFL0W
        iqdSwO6mET+53LMr0uDUMG2yR/eVdAGz79OG+wknAwG/8tDcrSnS3M8PRwI6/UsFO7HiVutI4qu
        /xgsWX1De2RSbWWbsMVZgEcEG2FXt5h04wKiVhvYPEjVEiLYOAPHVyyyKVvweGHGNsdhs
X-Google-Smtp-Source: ABdhPJycw/K00/FvNWgadpeN2hp8y2rq9jjXkD8In/RVHyJm3R7UFImaxBJdwecyI9k47PN7V8vhmYqE+XxewGj8
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:c3:: with SMTP id
 v3mr17607pjd.0.1636579234404; Wed, 10 Nov 2021 13:20:34 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:59 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-13-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 12/14] x86: Fix tabs in access.c
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tabs and spaces in this file are inconsistent and don't follow the
coding style.  Correct them to adhere to the standard and make it easier
to work in this file.

No functional change intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/access.c | 1383 +++++++++++++++++++++++++-------------------------
 1 file changed, 691 insertions(+), 692 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index de6726e..f832385 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -30,57 +30,57 @@ int page_table_levels;
 #define PFERR_PK_MASK (1U << 5)
 
 #define MSR_EFER 0xc0000080
-#define EFER_NX_MASK		(1ull << 11)
+#define EFER_NX_MASK            (1ull << 11)
 
 #define PT_INDEX(address, level)       \
-       ((address) >> (12 + ((level)-1) * 9)) & 511
+	  ((address) >> (12 + ((level)-1) * 9)) & 511
 
 /*
  * page table access check tests
  */
 
 enum {
-    AC_PTE_PRESENT_BIT,
-    AC_PTE_WRITABLE_BIT,
-    AC_PTE_USER_BIT,
-    AC_PTE_ACCESSED_BIT,
-    AC_PTE_DIRTY_BIT,
-    AC_PTE_NX_BIT,
-    AC_PTE_BIT51_BIT,
-    AC_PTE_BIT36_BIT,
-
-    AC_PDE_PRESENT_BIT,
-    AC_PDE_WRITABLE_BIT,
-    AC_PDE_USER_BIT,
-    AC_PDE_ACCESSED_BIT,
-    AC_PDE_DIRTY_BIT,
-    AC_PDE_PSE_BIT,
-    AC_PDE_NX_BIT,
-    AC_PDE_BIT51_BIT,
-    AC_PDE_BIT36_BIT,
-    AC_PDE_BIT13_BIT,
-
-    /*
-     *  special test case to DISABLE writable bit on page directory
-     *  pointer table entry.
-     */
-    AC_PDPTE_NO_WRITABLE_BIT,
-
-    AC_PKU_AD_BIT,
-    AC_PKU_WD_BIT,
-    AC_PKU_PKEY_BIT,
-
-    AC_ACCESS_USER_BIT,
-    AC_ACCESS_WRITE_BIT,
-    AC_ACCESS_FETCH_BIT,
-    AC_ACCESS_TWICE_BIT,
-
-    AC_CPU_EFER_NX_BIT,
-    AC_CPU_CR0_WP_BIT,
-    AC_CPU_CR4_SMEP_BIT,
-    AC_CPU_CR4_PKE_BIT,
-
-    NR_AC_FLAGS
+	AC_PTE_PRESENT_BIT,
+	AC_PTE_WRITABLE_BIT,
+	AC_PTE_USER_BIT,
+	AC_PTE_ACCESSED_BIT,
+	AC_PTE_DIRTY_BIT,
+	AC_PTE_NX_BIT,
+	AC_PTE_BIT51_BIT,
+	AC_PTE_BIT36_BIT,
+
+	AC_PDE_PRESENT_BIT,
+	AC_PDE_WRITABLE_BIT,
+	AC_PDE_USER_BIT,
+	AC_PDE_ACCESSED_BIT,
+	AC_PDE_DIRTY_BIT,
+	AC_PDE_PSE_BIT,
+	AC_PDE_NX_BIT,
+	AC_PDE_BIT51_BIT,
+	AC_PDE_BIT36_BIT,
+	AC_PDE_BIT13_BIT,
+
+	/*
+	 *  special test case to DISABLE writable bit on page directory
+	 *  pointer table entry.
+	 */
+	AC_PDPTE_NO_WRITABLE_BIT,
+
+	AC_PKU_AD_BIT,
+	AC_PKU_WD_BIT,
+	AC_PKU_PKEY_BIT,
+
+	AC_ACCESS_USER_BIT,
+	AC_ACCESS_WRITE_BIT,
+	AC_ACCESS_FETCH_BIT,
+	AC_ACCESS_TWICE_BIT,
+
+	AC_CPU_EFER_NX_BIT,
+	AC_CPU_CR0_WP_BIT,
+	AC_CPU_CR4_SMEP_BIT,
+	AC_CPU_CR4_PKE_BIT,
+
+	NR_AC_FLAGS
 };
 
 #define AC_PTE_PRESENT_MASK   (1 << AC_PTE_PRESENT_BIT)
@@ -120,65 +120,65 @@ enum {
 #define AC_CPU_CR4_PKE_MASK   (1 << AC_CPU_CR4_PKE_BIT)
 
 const char *ac_names[] = {
-    [AC_PTE_PRESENT_BIT] = "pte.p",
-    [AC_PTE_ACCESSED_BIT] = "pte.a",
-    [AC_PTE_WRITABLE_BIT] = "pte.rw",
-    [AC_PTE_USER_BIT] = "pte.user",
-    [AC_PTE_DIRTY_BIT] = "pte.d",
-    [AC_PTE_NX_BIT] = "pte.nx",
-    [AC_PTE_BIT51_BIT] = "pte.51",
-    [AC_PTE_BIT36_BIT] = "pte.36",
-    [AC_PDE_PRESENT_BIT] = "pde.p",
-    [AC_PDE_ACCESSED_BIT] = "pde.a",
-    [AC_PDE_WRITABLE_BIT] = "pde.rw",
-    [AC_PDE_USER_BIT] = "pde.user",
-    [AC_PDE_DIRTY_BIT] = "pde.d",
-    [AC_PDE_PSE_BIT] = "pde.pse",
-    [AC_PDE_NX_BIT] = "pde.nx",
-    [AC_PDE_BIT51_BIT] = "pde.51",
-    [AC_PDE_BIT36_BIT] = "pde.36",
-    [AC_PDE_BIT13_BIT] = "pde.13",
-    [AC_PDPTE_NO_WRITABLE_BIT] = "pdpte.ro",
-    [AC_PKU_AD_BIT] = "pkru.ad",
-    [AC_PKU_WD_BIT] = "pkru.wd",
-    [AC_PKU_PKEY_BIT] = "pkey=1",
-    [AC_ACCESS_WRITE_BIT] = "write",
-    [AC_ACCESS_USER_BIT] = "user",
-    [AC_ACCESS_FETCH_BIT] = "fetch",
-    [AC_ACCESS_TWICE_BIT] = "twice",
-    [AC_CPU_EFER_NX_BIT] = "efer.nx",
-    [AC_CPU_CR0_WP_BIT] = "cr0.wp",
-    [AC_CPU_CR4_SMEP_BIT] = "cr4.smep",
-    [AC_CPU_CR4_PKE_BIT] = "cr4.pke",
+	[AC_PTE_PRESENT_BIT] = "pte.p",
+	[AC_PTE_ACCESSED_BIT] = "pte.a",
+	[AC_PTE_WRITABLE_BIT] = "pte.rw",
+	[AC_PTE_USER_BIT] = "pte.user",
+	[AC_PTE_DIRTY_BIT] = "pte.d",
+	[AC_PTE_NX_BIT] = "pte.nx",
+	[AC_PTE_BIT51_BIT] = "pte.51",
+	[AC_PTE_BIT36_BIT] = "pte.36",
+	[AC_PDE_PRESENT_BIT] = "pde.p",
+	[AC_PDE_ACCESSED_BIT] = "pde.a",
+	[AC_PDE_WRITABLE_BIT] = "pde.rw",
+	[AC_PDE_USER_BIT] = "pde.user",
+	[AC_PDE_DIRTY_BIT] = "pde.d",
+	[AC_PDE_PSE_BIT] = "pde.pse",
+	[AC_PDE_NX_BIT] = "pde.nx",
+	[AC_PDE_BIT51_BIT] = "pde.51",
+	[AC_PDE_BIT36_BIT] = "pde.36",
+	[AC_PDE_BIT13_BIT] = "pde.13",
+	[AC_PDPTE_NO_WRITABLE_BIT] = "pdpte.ro",
+	[AC_PKU_AD_BIT] = "pkru.ad",
+	[AC_PKU_WD_BIT] = "pkru.wd",
+	[AC_PKU_PKEY_BIT] = "pkey=1",
+	[AC_ACCESS_WRITE_BIT] = "write",
+	[AC_ACCESS_USER_BIT] = "user",
+	[AC_ACCESS_FETCH_BIT] = "fetch",
+	[AC_ACCESS_TWICE_BIT] = "twice",
+	[AC_CPU_EFER_NX_BIT] = "efer.nx",
+	[AC_CPU_CR0_WP_BIT] = "cr0.wp",
+	[AC_CPU_CR4_SMEP_BIT] = "cr4.smep",
+	[AC_CPU_CR4_PKE_BIT] = "cr4.pke",
 };
 
 static inline void *va(pt_element_t phys)
 {
-    return (void *)phys;
+	return (void *)phys;
 }
 
 typedef struct {
-    pt_element_t pt_pool;
-    unsigned pt_pool_size;
-    unsigned pt_pool_current;
+	pt_element_t pt_pool;
+	unsigned pt_pool_size;
+	unsigned pt_pool_current;
 } ac_pool_t;
 
 typedef struct {
-    unsigned flags;
-    void *virt;
-    pt_element_t phys;
-    pt_element_t *ptep;
-    pt_element_t expected_pte;
-    pt_element_t *pdep;
-    pt_element_t expected_pde;
-    pt_element_t ignore_pde;
-    int expected_fault;
-    unsigned expected_error;
+	unsigned flags;
+	void *virt;
+	pt_element_t phys;
+	pt_element_t *ptep;
+	pt_element_t expected_pte;
+	pt_element_t *pdep;
+	pt_element_t expected_pde;
+	pt_element_t ignore_pde;
+	int expected_fault;
+	unsigned expected_error;
 } ac_test_t;
 
 typedef struct {
-    unsigned short limit;
-    unsigned long linear_addr;
+	unsigned short limit;
+	unsigned long linear_addr;
 } __attribute__((packed)) descriptor_table_t;
 
 
@@ -190,15 +190,15 @@ static unsigned long long shadow_efer;
 
 static void set_cr0_wp(int wp)
 {
-    unsigned long cr0 = shadow_cr0;
-
-    cr0 &= ~CR0_WP_MASK;
-    if (wp)
-	cr0 |= CR0_WP_MASK;
-    if (cr0 != shadow_cr0) {
-        write_cr0(cr0);
-        shadow_cr0 = cr0;
-    }
+	unsigned long cr0 = shadow_cr0;
+
+	cr0 &= ~CR0_WP_MASK;
+	if (wp)
+		cr0 |= CR0_WP_MASK;
+	if (cr0 != shadow_cr0) {
+		write_cr0(cr0);
+		shadow_cr0 = cr0;
+	}
 }
 
 static void clear_user_mask(struct pte_search search, void *va)
@@ -216,404 +216,405 @@ static void set_user_mask(struct pte_search search, void *va)
 
 static unsigned set_cr4_smep(int smep)
 {
-    extern char stext, etext;
-    size_t len = (size_t)&etext - (size_t)&stext;
-    unsigned long cr4 = shadow_cr4;
-    unsigned r;
-
-    cr4 &= ~CR4_SMEP_MASK;
-    if (smep)
-	cr4 |= CR4_SMEP_MASK;
-    if (cr4 == shadow_cr4)
-        return 0;
-
-    if (smep)
-        walk_pte(&stext, len, clear_user_mask);
-    r = write_cr4_checking(cr4);
-    if (r || !smep)
-        walk_pte(&stext, len, set_user_mask);
-    if (!r)
-        shadow_cr4 = cr4;
-    return r;
+	extern char stext, etext;
+	size_t len = (size_t)&etext - (size_t)&stext;
+	unsigned long cr4 = shadow_cr4;
+	unsigned r;
+
+	cr4 &= ~CR4_SMEP_MASK;
+	if (smep)
+		cr4 |= CR4_SMEP_MASK;
+	if (cr4 == shadow_cr4)
+		return 0;
+
+	if (smep)
+		walk_pte(&stext, len, clear_user_mask);
+	r = write_cr4_checking(cr4);
+	if (r || !smep)
+		walk_pte(&stext, len, set_user_mask);
+	if (!r)
+		shadow_cr4 = cr4;
+	return r;
 }
 
 static void set_cr4_pke(int pke)
 {
-    unsigned long cr4 = shadow_cr4;
-
-    cr4 &= ~X86_CR4_PKE;
-    if (pke)
-	cr4 |= X86_CR4_PKE;
-    if (cr4 == shadow_cr4)
-        return;
-
-    /* Check that protection keys do not affect accesses when CR4.PKE=0.  */
-    if ((shadow_cr4 & X86_CR4_PKE) && !pke)
-        write_pkru(0xfffffffc);
-    write_cr4(cr4);
-    shadow_cr4 = cr4;
+	unsigned long cr4 = shadow_cr4;
+
+	cr4 &= ~X86_CR4_PKE;
+	if (pke)
+		cr4 |= X86_CR4_PKE;
+	if (cr4 == shadow_cr4)
+		return;
+
+	/* Check that protection keys do not affect accesses when CR4.PKE=0.  */
+	if ((shadow_cr4 & X86_CR4_PKE) && !pke)
+		write_pkru(0xfffffffc);
+	write_cr4(cr4);
+	shadow_cr4 = cr4;
 }
 
 static void set_efer_nx(int nx)
 {
-    unsigned long long efer = shadow_efer;
-
-    efer &= ~EFER_NX_MASK;
-    if (nx)
-	efer |= EFER_NX_MASK;
-    if (efer != shadow_efer) {
-        wrmsr(MSR_EFER, efer);
-        shadow_efer = efer;
-    }
+	unsigned long long efer = shadow_efer;
+
+	efer &= ~EFER_NX_MASK;
+	if (nx)
+		efer |= EFER_NX_MASK;
+	if (efer != shadow_efer) {
+		wrmsr(MSR_EFER, efer);
+		shadow_efer = efer;
+	}
 }
 
 static void ac_env_int(ac_pool_t *pool)
 {
-    extern char page_fault, kernel_entry;
-    set_idt_entry(14, &page_fault, 0);
-    set_idt_entry(0x20, &kernel_entry, 3);
+	extern char page_fault, kernel_entry;
+	set_idt_entry(14, &page_fault, 0);
+	set_idt_entry(0x20, &kernel_entry, 3);
 
-    pool->pt_pool = 33 * 1024 * 1024;
-    pool->pt_pool_size = 120 * 1024 * 1024 - pool->pt_pool;
-    pool->pt_pool_current = 0;
+	pool->pt_pool = 33 * 1024 * 1024;
+	pool->pt_pool_size = 120 * 1024 * 1024 - pool->pt_pool;
+	pool->pt_pool_current = 0;
 }
 
 static void ac_test_init(ac_test_t *at, void *virt)
 {
-    set_efer_nx(1);
-    set_cr0_wp(1);
-    at->flags = 0;
-    at->virt = virt;
-    at->phys = 32 * 1024 * 1024;
+	set_efer_nx(1);
+	set_cr0_wp(1);
+	at->flags = 0;
+	at->virt = virt;
+	at->phys = 32 * 1024 * 1024;
 }
 
 static int ac_test_bump_one(ac_test_t *at)
 {
-    at->flags = ((at->flags | invalid_mask) + 1) & ~invalid_mask;
-    return at->flags < (1 << NR_AC_FLAGS);
+	at->flags = ((at->flags | invalid_mask) + 1) & ~invalid_mask;
+	return at->flags < (1 << NR_AC_FLAGS);
 }
 
 #define F(x)  ((flags & x##_MASK) != 0)
 
 static _Bool ac_test_legal(ac_test_t *at)
 {
-    int flags = at->flags;
-    unsigned reserved;
-
-    if (F(AC_ACCESS_FETCH) && F(AC_ACCESS_WRITE))
-	return false;
-
-    /*
-     * Since we convert current page to kernel page when cr4.smep=1,
-     * we can't switch to user mode.
-     */
-    if (F(AC_ACCESS_USER) && F(AC_CPU_CR4_SMEP))
-	return false;
-
-    /*
-     * Only test protection key faults if CR4.PKE=1.
-     */
-    if (!F(AC_CPU_CR4_PKE) &&
-        (F(AC_PKU_AD) || F(AC_PKU_WD))) {
-	return false;
-    }
-
-    /*
-     * pde.bit13 checks handling of reserved bits in largepage PDEs.  It is
-     * meaningless if there is a PTE.
-     */
-    if (!F(AC_PDE_PSE) && F(AC_PDE_BIT13))
-        return false;
-
-    /*
-     * Shorten the test by avoiding testing too many reserved bit combinations.
-     * Skip testing multiple reserved bits to shorten the test. Reserved bit
-     * page faults are terminal and multiple reserved bits do not affect the
-     * error code; the odds of a KVM bug are super low, and the odds of actually
-     * being able to detect a bug are even lower.
-     */
-    reserved = (AC_PDE_BIT51_MASK | AC_PDE_BIT36_MASK | AC_PDE_BIT13_MASK |
-	        AC_PTE_BIT51_MASK | AC_PTE_BIT36_MASK);
-    if (!F(AC_CPU_EFER_NX))
-        reserved |= AC_PDE_NX_MASK | AC_PTE_NX_MASK;
-
-    /* Only test one reserved bit at a time.  */
-    reserved &= flags;
-    if (reserved & (reserved - 1))
-        return false;
-
-    return true;
+	int flags = at->flags;
+	unsigned reserved;
+
+	if (F(AC_ACCESS_FETCH) && F(AC_ACCESS_WRITE))
+		return false;
+
+	/*
+	 * Since we convert current page to kernel page when cr4.smep=1,
+	 * we can't switch to user mode.
+	 */
+	if (F(AC_ACCESS_USER) && F(AC_CPU_CR4_SMEP))
+		return false;
+
+	/*
+	 * Only test protection key faults if CR4.PKE=1.
+	 */
+	if (!F(AC_CPU_CR4_PKE) &&
+		(F(AC_PKU_AD) || F(AC_PKU_WD))) {
+		return false;
+	}
+
+	/*
+	 * pde.bit13 checks handling of reserved bits in largepage PDEs.  It is
+	 * meaningless if there is a PTE.
+	 */
+	if (!F(AC_PDE_PSE) && F(AC_PDE_BIT13))
+		return false;
+
+	/*
+	 * Shorten the test by avoiding testing too many reserved bit combinations.
+	 * Skip testing multiple reserved bits to shorten the test. Reserved bit
+	 * page faults are terminal and multiple reserved bits do not affect the
+	 * error code; the odds of a KVM bug are super low, and the odds of actually
+	 * being able to detect a bug are even lower.
+	 */
+	reserved = (AC_PDE_BIT51_MASK | AC_PDE_BIT36_MASK | AC_PDE_BIT13_MASK |
+		   AC_PTE_BIT51_MASK | AC_PTE_BIT36_MASK);
+	if (!F(AC_CPU_EFER_NX))
+		reserved |= AC_PDE_NX_MASK | AC_PTE_NX_MASK;
+
+	/* Only test one reserved bit at a time.  */
+	reserved &= flags;
+	if (reserved & (reserved - 1))
+		return false;
+
+	return true;
 }
 
 static int ac_test_bump(ac_test_t *at)
 {
-    int ret;
+	int ret;
 
-    ret = ac_test_bump_one(at);
-    while (ret && !ac_test_legal(at))
 	ret = ac_test_bump_one(at);
-    return ret;
+	while (ret && !ac_test_legal(at))
+		ret = ac_test_bump_one(at);
+	return ret;
 }
 
 static pt_element_t ac_test_alloc_pt(ac_pool_t *pool)
 {
-    pt_element_t ret = pool->pt_pool + pool->pt_pool_current;
-    pool->pt_pool_current += PAGE_SIZE;
-    memset(va(ret), 0, PAGE_SIZE);
-    return ret;
+	pt_element_t ret = pool->pt_pool + pool->pt_pool_current;
+	pool->pt_pool_current += PAGE_SIZE;
+	memset(va(ret), 0, PAGE_SIZE);
+	return ret;
 }
 
 static _Bool ac_test_enough_room(ac_pool_t *pool)
 {
-    return pool->pt_pool_current + 5 * PAGE_SIZE <= pool->pt_pool_size;
+	return pool->pt_pool_current + 5 * PAGE_SIZE <= pool->pt_pool_size;
 }
 
 static void ac_test_reset_pt_pool(ac_pool_t *pool)
 {
-    pool->pt_pool_current = 0;
+	pool->pt_pool_current = 0;
 }
 
 static pt_element_t ac_test_permissions(ac_test_t *at, unsigned flags,
-                                        bool writable, bool user,
-                                        bool executable)
+					bool writable, bool user,
+					bool executable)
 {
-    bool kwritable = !F(AC_CPU_CR0_WP) && !F(AC_ACCESS_USER);
-    pt_element_t expected = 0;
-
-    if (F(AC_ACCESS_USER) && !user)
-	at->expected_fault = 1;
-
-    if (F(AC_ACCESS_WRITE) && !writable && !kwritable)
-	at->expected_fault = 1;
-
-    if (F(AC_ACCESS_FETCH) && !executable)
-	at->expected_fault = 1;
-
-    if (F(AC_ACCESS_FETCH) && user && F(AC_CPU_CR4_SMEP))
-        at->expected_fault = 1;
-
-    if (user && !F(AC_ACCESS_FETCH) && F(AC_PKU_PKEY) && F(AC_CPU_CR4_PKE)) {
-        if (F(AC_PKU_AD)) {
-            at->expected_fault = 1;
-            at->expected_error |= PFERR_PK_MASK;
-        } else if (F(AC_ACCESS_WRITE) && F(AC_PKU_WD) && !kwritable) {
-            at->expected_fault = 1;
-            at->expected_error |= PFERR_PK_MASK;
-        }
-    }
-
-    if (!at->expected_fault) {
-        expected |= PT_ACCESSED_MASK;
-        if (F(AC_ACCESS_WRITE))
-            expected |= PT_DIRTY_MASK;
-    }
-
-    return expected;
+	bool kwritable = !F(AC_CPU_CR0_WP) && !F(AC_ACCESS_USER);
+	pt_element_t expected = 0;
+
+	if (F(AC_ACCESS_USER) && !user)
+		at->expected_fault = 1;
+
+	if (F(AC_ACCESS_WRITE) && !writable && !kwritable)
+		at->expected_fault = 1;
+
+	if (F(AC_ACCESS_FETCH) && !executable)
+		at->expected_fault = 1;
+
+	if (F(AC_ACCESS_FETCH) && user && F(AC_CPU_CR4_SMEP))
+		at->expected_fault = 1;
+
+	if (user && !F(AC_ACCESS_FETCH) && F(AC_PKU_PKEY) && F(AC_CPU_CR4_PKE)) {
+		if (F(AC_PKU_AD)) {
+			at->expected_fault = 1;
+			at->expected_error |= PFERR_PK_MASK;
+		} else if (F(AC_ACCESS_WRITE) && F(AC_PKU_WD) && !kwritable) {
+			at->expected_fault = 1;
+			at->expected_error |= PFERR_PK_MASK;
+		}
+	}
+
+	if (!at->expected_fault) {
+		expected |= PT_ACCESSED_MASK;
+		if (F(AC_ACCESS_WRITE))
+			expected |= PT_DIRTY_MASK;
+	}
+
+	return expected;
 }
 
 static void ac_emulate_access(ac_test_t *at, unsigned flags)
 {
-    bool pde_valid, pte_valid;
-    bool user, writable, executable;
-
-    if (F(AC_ACCESS_USER))
-	at->expected_error |= PFERR_USER_MASK;
-
-    if (F(AC_ACCESS_WRITE))
-	at->expected_error |= PFERR_WRITE_MASK;
-
-    if (F(AC_ACCESS_FETCH))
-	at->expected_error |= PFERR_FETCH_MASK;
-
-    if (!F(AC_PDE_ACCESSED))
-        at->ignore_pde = PT_ACCESSED_MASK;
-
-    pde_valid = F(AC_PDE_PRESENT)
-        && !F(AC_PDE_BIT51) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
-        && !(F(AC_PDE_NX) && !F(AC_CPU_EFER_NX));
-
-    if (!pde_valid) {
-        at->expected_fault = 1;
-	if (F(AC_PDE_PRESENT)) {
-            at->expected_error |= PFERR_RESERVED_MASK;
-        } else {
-            at->expected_error &= ~PFERR_PRESENT_MASK;
-        }
-	goto fault;
-    }
-
-    writable = !F(AC_PDPTE_NO_WRITABLE) && F(AC_PDE_WRITABLE);
-    user = F(AC_PDE_USER);
-    executable = !F(AC_PDE_NX);
-
-    if (F(AC_PDE_PSE)) {
-        at->expected_pde |= ac_test_permissions(at, flags, writable, user,
-                                                executable);
-	goto no_pte;
-    }
-
-    at->expected_pde |= PT_ACCESSED_MASK;
-
-    pte_valid = F(AC_PTE_PRESENT)
-        && !F(AC_PTE_BIT51) && !F(AC_PTE_BIT36)
-        && !(F(AC_PTE_NX) && !F(AC_CPU_EFER_NX));
-
-    if (!pte_valid) {
-        at->expected_fault = 1;
-	if (F(AC_PTE_PRESENT)) {
-            at->expected_error |= PFERR_RESERVED_MASK;
-        } else {
-            at->expected_error &= ~PFERR_PRESENT_MASK;
-        }
-	goto fault;
-    }
-
-    writable &= F(AC_PTE_WRITABLE);
-    user &= F(AC_PTE_USER);
-    executable &= !F(AC_PTE_NX);
-
-    at->expected_pte |= ac_test_permissions(at, flags, writable, user,
-                                            executable);
+	bool pde_valid, pte_valid;
+	bool user, writable, executable;
+
+	if (F(AC_ACCESS_USER))
+		at->expected_error |= PFERR_USER_MASK;
+
+	if (F(AC_ACCESS_WRITE))
+		at->expected_error |= PFERR_WRITE_MASK;
+
+	if (F(AC_ACCESS_FETCH))
+		at->expected_error |= PFERR_FETCH_MASK;
+
+	if (!F(AC_PDE_ACCESSED))
+		at->ignore_pde = PT_ACCESSED_MASK;
+
+	pde_valid = F(AC_PDE_PRESENT)
+		&& !F(AC_PDE_BIT51) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
+		&& !(F(AC_PDE_NX) && !F(AC_CPU_EFER_NX));
+
+	if (!pde_valid) {
+		at->expected_fault = 1;
+		if (F(AC_PDE_PRESENT)) {
+			at->expected_error |= PFERR_RESERVED_MASK;
+		} else {
+			at->expected_error &= ~PFERR_PRESENT_MASK;
+		}
+		goto fault;
+	}
+
+	writable = !F(AC_PDPTE_NO_WRITABLE) && F(AC_PDE_WRITABLE);
+	user = F(AC_PDE_USER);
+	executable = !F(AC_PDE_NX);
+
+	if (F(AC_PDE_PSE)) {
+		at->expected_pde |= ac_test_permissions(at, flags, writable,
+							user, executable);
+		goto no_pte;
+	}
+
+	at->expected_pde |= PT_ACCESSED_MASK;
+
+	pte_valid = F(AC_PTE_PRESENT)
+		    && !F(AC_PTE_BIT51) && !F(AC_PTE_BIT36)
+		    && !(F(AC_PTE_NX) && !F(AC_CPU_EFER_NX));
+
+	if (!pte_valid) {
+		at->expected_fault = 1;
+		if (F(AC_PTE_PRESENT)) {
+			at->expected_error |= PFERR_RESERVED_MASK;
+		} else {
+			at->expected_error &= ~PFERR_PRESENT_MASK;
+		}
+		goto fault;
+	}
+
+	writable &= F(AC_PTE_WRITABLE);
+	user &= F(AC_PTE_USER);
+	executable &= !F(AC_PTE_NX);
+
+	at->expected_pte |= ac_test_permissions(at, flags, writable, user,
+						executable);
 
 no_pte:
 fault:
-    if (!at->expected_fault)
-        at->ignore_pde = 0;
-    if (!F(AC_CPU_EFER_NX) && !F(AC_CPU_CR4_SMEP))
-        at->expected_error &= ~PFERR_FETCH_MASK;
+	if (!at->expected_fault)
+		at->ignore_pde = 0;
+	if (!F(AC_CPU_EFER_NX) && !F(AC_CPU_CR4_SMEP))
+		at->expected_error &= ~PFERR_FETCH_MASK;
 }
 
 static void ac_set_expected_status(ac_test_t *at)
 {
-    invlpg(at->virt);
-
-    if (at->ptep)
-	at->expected_pte = *at->ptep;
-    at->expected_pde = *at->pdep;
-    at->ignore_pde = 0;
-    at->expected_fault = 0;
-    at->expected_error = PFERR_PRESENT_MASK;
-
-    if (at->flags & AC_ACCESS_TWICE_MASK) {
-        ac_emulate_access(at, at->flags & ~AC_ACCESS_WRITE_MASK
-                          & ~AC_ACCESS_FETCH_MASK & ~AC_ACCESS_USER_MASK);
-        at->expected_fault = 0;
+	invlpg(at->virt);
+
+	if (at->ptep)
+		at->expected_pte = *at->ptep;
+	at->expected_pde = *at->pdep;
+	at->ignore_pde = 0;
+	at->expected_fault = 0;
 	at->expected_error = PFERR_PRESENT_MASK;
-        at->ignore_pde = 0;
-    }
 
-    ac_emulate_access(at, at->flags);
+	if (at->flags & AC_ACCESS_TWICE_MASK) {
+		ac_emulate_access(at, at->flags &
+				  ~AC_ACCESS_WRITE_MASK &
+				  ~AC_ACCESS_FETCH_MASK &
+				  ~AC_ACCESS_USER_MASK);
+		at->expected_fault = 0;
+		at->expected_error = PFERR_PRESENT_MASK;
+		at->ignore_pde = 0;
+	}
+
+	ac_emulate_access(at, at->flags);
 }
 
 static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse,
 				      u64 pd_page, u64 pt_page)
-
 {
-    unsigned long root = read_cr3();
-    int flags = at->flags;
-    bool skip = true;
-
-    if (!ac_test_enough_room(pool))
-	ac_test_reset_pt_pool(pool);
-
-    at->ptep = 0;
-    for (int i = page_table_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
-	pt_element_t *vroot = va(root & PT_BASE_ADDR_MASK);
-	unsigned index = PT_INDEX((unsigned long)at->virt, i);
-	pt_element_t pte = 0;
+	unsigned long root = read_cr3();
+	int flags = at->flags;
+	bool skip = true;
 
-	/*
-	 * Reuse existing page tables along the path to the test code and data
-	 * (which is in the bottom 2MB).
-	 */
-	if (skip && i >= 2 && index == 0) {
-	    goto next;
-	}
-	skip = false;
-	if (reuse && vroot[index]) {
-	    switch (i) {
-	    case 2:
-		at->pdep = &vroot[index];
-		break;
-	    case 1:
-		at->ptep = &vroot[index];
-		break;
-	    }
-	    goto next;
-	}
+	if (!ac_test_enough_room(pool))
+		ac_test_reset_pt_pool(pool);
 
-	switch (i) {
-	case 5:
-	case 4:
-	    pte = ac_test_alloc_pt(pool);
-	    pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
-	    break;
-	case 3:
-	    pte = pd_page ? pd_page : ac_test_alloc_pt(pool);
-	    pte |= PT_PRESENT_MASK | PT_USER_MASK;
-	    if (!F(AC_PDPTE_NO_WRITABLE))
-		pte |= PT_WRITABLE_MASK;
-	    break;
-	case 2:
-	    if (!F(AC_PDE_PSE)) {
-		pte = pt_page ? pt_page : ac_test_alloc_pt(pool);
-		/* The protection key is ignored on non-leaf entries.  */
-                if (F(AC_PKU_PKEY))
-                    pte |= 2ull << 59;
-	    } else {
-		pte = at->phys & PT_PSE_BASE_ADDR_MASK;
-		pte |= PT_PAGE_SIZE_MASK;
-                if (F(AC_PKU_PKEY))
-                    pte |= 1ull << 59;
-	    }
-	    if (F(AC_PDE_PRESENT))
-		pte |= PT_PRESENT_MASK;
-	    if (F(AC_PDE_WRITABLE))
-		pte |= PT_WRITABLE_MASK;
-	    if (F(AC_PDE_USER))
-		pte |= PT_USER_MASK;
-	    if (F(AC_PDE_ACCESSED))
-		pte |= PT_ACCESSED_MASK;
-	    if (F(AC_PDE_DIRTY))
-		pte |= PT_DIRTY_MASK;
-	    if (F(AC_PDE_NX))
-		pte |= PT64_NX_MASK;
-	    if (F(AC_PDE_BIT51))
-		pte |= 1ull << 51;
-	    if (F(AC_PDE_BIT36))
-                pte |= 1ull << 36;
-	    if (F(AC_PDE_BIT13))
-		pte |= 1ull << 13;
-	    at->pdep = &vroot[index];
-	    break;
-	case 1:
-	    pte = at->phys & PT_BASE_ADDR_MASK;
-	    if (F(AC_PKU_PKEY))
-		pte |= 1ull << 59;
-	    if (F(AC_PTE_PRESENT))
-		pte |= PT_PRESENT_MASK;
-	    if (F(AC_PTE_WRITABLE))
-		pte |= PT_WRITABLE_MASK;
-	    if (F(AC_PTE_USER))
-		pte |= PT_USER_MASK;
-	    if (F(AC_PTE_ACCESSED))
-		pte |= PT_ACCESSED_MASK;
-	    if (F(AC_PTE_DIRTY))
-		pte |= PT_DIRTY_MASK;
-	    if (F(AC_PTE_NX))
-		pte |= PT64_NX_MASK;
-	    if (F(AC_PTE_BIT51))
-		pte |= 1ull << 51;
-	    if (F(AC_PTE_BIT36))
-                pte |= 1ull << 36;
-	    at->ptep = &vroot[index];
-	    break;
-	}
-	vroot[index] = pte;
+	at->ptep = 0;
+	for (int i = page_table_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
+		pt_element_t *vroot = va(root & PT_BASE_ADDR_MASK);
+		unsigned index = PT_INDEX((unsigned long)at->virt, i);
+		pt_element_t pte = 0;
+
+		/*
+		 * Reuse existing page tables along the path to the test code and data
+		 * (which is in the bottom 2MB).
+		 */
+		if (skip && i >= 2 && index == 0) {
+			goto next;
+		}
+		skip = false;
+		if (reuse && vroot[index]) {
+			switch (i) {
+			case 2:
+				at->pdep = &vroot[index];
+				break;
+			case 1:
+				at->ptep = &vroot[index];
+				break;
+			}
+			goto next;
+		}
+
+		switch (i) {
+		case 5:
+		case 4:
+			pte = ac_test_alloc_pt(pool);
+			pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+			break;
+		case 3:
+			pte = pd_page ? pd_page : ac_test_alloc_pt(pool);
+			pte |= PT_PRESENT_MASK | PT_USER_MASK;
+			if (!F(AC_PDPTE_NO_WRITABLE))
+				pte |= PT_WRITABLE_MASK;
+			break;
+		case 2:
+			if (!F(AC_PDE_PSE)) {
+				pte = pt_page ? pt_page : ac_test_alloc_pt(pool);
+				/* The protection key is ignored on non-leaf entries.  */
+				if (F(AC_PKU_PKEY))
+					pte |= 2ull << 59;
+			} else {
+				pte = at->phys & PT_PSE_BASE_ADDR_MASK;
+				pte |= PT_PAGE_SIZE_MASK;
+				if (F(AC_PKU_PKEY))
+					pte |= 1ull << 59;
+			}
+			if (F(AC_PDE_PRESENT))
+				pte |= PT_PRESENT_MASK;
+			if (F(AC_PDE_WRITABLE))
+				pte |= PT_WRITABLE_MASK;
+			if (F(AC_PDE_USER))
+				pte |= PT_USER_MASK;
+			if (F(AC_PDE_ACCESSED))
+				pte |= PT_ACCESSED_MASK;
+			if (F(AC_PDE_DIRTY))
+				pte |= PT_DIRTY_MASK;
+			if (F(AC_PDE_NX))
+				pte |= PT64_NX_MASK;
+			if (F(AC_PDE_BIT51))
+				pte |= 1ull << 51;
+			if (F(AC_PDE_BIT36))
+				pte |= 1ull << 36;
+			if (F(AC_PDE_BIT13))
+				pte |= 1ull << 13;
+			at->pdep = &vroot[index];
+			break;
+		case 1:
+			pte = at->phys & PT_BASE_ADDR_MASK;
+			if (F(AC_PKU_PKEY))
+				pte |= 1ull << 59;
+			if (F(AC_PTE_PRESENT))
+				pte |= PT_PRESENT_MASK;
+			if (F(AC_PTE_WRITABLE))
+				pte |= PT_WRITABLE_MASK;
+			if (F(AC_PTE_USER))
+				pte |= PT_USER_MASK;
+			if (F(AC_PTE_ACCESSED))
+				pte |= PT_ACCESSED_MASK;
+			if (F(AC_PTE_DIRTY))
+				pte |= PT_DIRTY_MASK;
+			if (F(AC_PTE_NX))
+				pte |= PT64_NX_MASK;
+			if (F(AC_PTE_BIT51))
+				pte |= 1ull << 51;
+			if (F(AC_PTE_BIT36))
+				pte |= 1ull << 36;
+			at->ptep = &vroot[index];
+			break;
+		}
+		vroot[index] = pte;
  next:
-	root = vroot[index];
-    }
-    ac_set_expected_status(at);
+		root = vroot[index];
+	}
+	ac_set_expected_status(at);
 }
 
 static void ac_test_setup_pte(ac_test_t *at, ac_pool_t *pool)
@@ -630,11 +631,11 @@ static void ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
 static void dump_mapping(ac_test_t *at)
 {
 	unsigned long root = read_cr3();
-        int flags = at->flags;
+	int flags = at->flags;
 	int i;
 
 	printf("Dump mapping: address: %p\n", at->virt);
-	for (i = page_table_levels ; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
+	for (i = page_table_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
 		pt_element_t *vroot = va(root & PT_BASE_ADDR_MASK);
 		unsigned index = PT_INDEX((unsigned long)at->virt, i);
 		pt_element_t pte = vroot[index];
@@ -645,168 +646,166 @@ static void dump_mapping(ac_test_t *at)
 }
 
 static void ac_test_check(ac_test_t *at, _Bool *success_ret, _Bool cond,
-                          const char *fmt, ...)
+			  const char *fmt, ...)
 {
-    va_list ap;
-    char buf[500];
+	va_list ap;
+	char buf[500];
 
-    if (!*success_ret) {
-        return;
-    }
+	if (!*success_ret) {
+		return;
+	}
 
-    if (!cond) {
-        return;
-    }
+	if (!cond) {
+		return;
+	}
 
-    *success_ret = false;
+	*success_ret = false;
 
-    if (!verbose) {
-        puts("\n");
-        ac_test_show(at);
-    }
+	if (!verbose) {
+		puts("\n");
+		ac_test_show(at);
+	}
 
-    va_start(ap, fmt);
-    vsnprintf(buf, sizeof(buf), fmt, ap);
-    va_end(ap);
-    printf("FAIL: %s\n", buf);
-    dump_mapping(at);
+	va_start(ap, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, ap);
+	va_end(ap);
+	printf("FAIL: %s\n", buf);
+	dump_mapping(at);
 }
 
 static int pt_match(pt_element_t pte1, pt_element_t pte2, pt_element_t ignore)
 {
-    pte1 &= ~ignore;
-    pte2 &= ~ignore;
-    return pte1 == pte2;
+	pte1 &= ~ignore;
+	pte2 &= ~ignore;
+	return pte1 == pte2;
 }
 
 static int ac_test_do_access(ac_test_t *at)
 {
-    static unsigned unique = 42;
-    int fault = 0;
-    unsigned e;
-    static unsigned char user_stack[4096];
-    unsigned long rsp;
-    _Bool success = true;
-    int flags = at->flags;
-
-    ++unique;
-    if (!(unique & 65535)) {
-        puts(".");
-    }
-
-    *((unsigned char *)at->phys) = 0xc3; /* ret */
-
-    unsigned r = unique;
-    set_cr0_wp(F(AC_CPU_CR0_WP));
-    set_efer_nx(F(AC_CPU_EFER_NX));
-    set_cr4_pke(F(AC_CPU_CR4_PKE));
-    if (F(AC_CPU_CR4_PKE)) {
-        /* WD2=AD2=1, WD1=F(AC_PKU_WD), AD1=F(AC_PKU_AD) */
-        write_pkru(0x30 | (F(AC_PKU_WD) ? 8 : 0) |
-                   (F(AC_PKU_AD) ? 4 : 0));
-    }
-
-    set_cr4_smep(F(AC_CPU_CR4_SMEP));
-
-    if (F(AC_ACCESS_TWICE)) {
-	asm volatile (
-	    "mov $fixed2, %%rsi \n\t"
-	    "mov (%[addr]), %[reg] \n\t"
-	    "fixed2:"
-	    : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
-	    : [addr]"r"(at->virt)
-	    : "rsi"
-	    );
-	fault = 0;
-    }
-
-    asm volatile ("mov $fixed1, %%rsi \n\t"
-		  "mov %%rsp, %[rsp0] \n\t"
-		  "cmp $0, %[user] \n\t"
-		  "jz do_access \n\t"
-		  "push %%rax; mov %[user_ds], %%ax; mov %%ax, %%ds; pop %%rax  \n\t"
-		  "pushq %[user_ds] \n\t"
-		  "pushq %[user_stack_top] \n\t"
-		  "pushfq \n\t"
-		  "pushq %[user_cs] \n\t"
-		  "pushq $do_access \n\t"
-		  "iretq \n"
-		  "do_access: \n\t"
-		  "cmp $0, %[fetch] \n\t"
-		  "jnz 2f \n\t"
-		  "cmp $0, %[write] \n\t"
-		  "jnz 1f \n\t"
-		  "mov (%[addr]), %[reg] \n\t"
-		  "jmp done \n\t"
-		  "1: mov %[reg], (%[addr]) \n\t"
-		  "jmp done \n\t"
-		  "2: call *%[addr] \n\t"
-		  "done: \n"
-		  "fixed1: \n"
-		  "int %[kernel_entry_vector] \n\t"
-		  ".section .text.entry \n\t"
-		  "kernel_entry: \n\t"
-		  "mov %[rsp0], %%rsp \n\t"
-		  "jmp back_to_kernel \n\t"
-		  ".section .text \n\t"
-		  "back_to_kernel:"
-		  : [reg]"+r"(r), "+a"(fault), "=b"(e), "=&d"(rsp),
-		    [rsp0]"=m"(tss[0].rsp0)
-		  : [addr]"r"(at->virt),
-		    [write]"r"(F(AC_ACCESS_WRITE)),
-		    [user]"r"(F(AC_ACCESS_USER)),
-		    [fetch]"r"(F(AC_ACCESS_FETCH)),
-		    [user_ds]"i"(USER_DS),
-		    [user_cs]"i"(USER_CS),
-		    [user_stack_top]"r"(user_stack + sizeof user_stack),
-		    [kernel_entry_vector]"i"(0x20)
-		  : "rsi");
-
-    asm volatile (".section .text.pf \n\t"
-		  "page_fault: \n\t"
-		  "pop %rbx \n\t"
-		  "mov %rsi, (%rsp) \n\t"
-		  "movl $1, %eax \n\t"
-		  "iretq \n\t"
-		  ".section .text");
-
-    ac_test_check(at, &success, fault && !at->expected_fault,
-                  "unexpected fault");
-    ac_test_check(at, &success, !fault && at->expected_fault,
-                  "unexpected access");
-    ac_test_check(at, &success, fault && e != at->expected_error,
-                  "error code %x expected %x", e, at->expected_error);
-    if (at->ptep)
-        ac_test_check(at, &success, *at->ptep != at->expected_pte,
-                      "pte %x expected %x", *at->ptep, at->expected_pte);
-    ac_test_check(at, &success,
-                  !pt_match(*at->pdep, at->expected_pde, at->ignore_pde),
-                  "pde %x expected %x", *at->pdep, at->expected_pde);
-
-    if (success && verbose) {
-	if (at->expected_fault) {
-            printf("PASS (%x)\n", at->expected_error);
-	} else {
-            printf("PASS\n");
+	static unsigned unique = 42;
+	int fault = 0;
+	unsigned e;
+	static unsigned char user_stack[4096];
+	unsigned long rsp;
+	_Bool success = true;
+	int flags = at->flags;
+
+	++unique;
+	if (!(unique & 65535)) {
+		puts(".");
 	}
-    }
-    return success;
+
+	*((unsigned char *)at->phys) = 0xc3; /* ret */
+
+	unsigned r = unique;
+	set_cr0_wp(F(AC_CPU_CR0_WP));
+	set_efer_nx(F(AC_CPU_EFER_NX));
+	set_cr4_pke(F(AC_CPU_CR4_PKE));
+	if (F(AC_CPU_CR4_PKE)) {
+		/* WD2=AD2=1, WD1=F(AC_PKU_WD), AD1=F(AC_PKU_AD) */
+		write_pkru(0x30 | (F(AC_PKU_WD) ? 8 : 0) |
+			   (F(AC_PKU_AD) ? 4 : 0));
+	}
+
+	set_cr4_smep(F(AC_CPU_CR4_SMEP));
+
+	if (F(AC_ACCESS_TWICE)) {
+		asm volatile ("mov $fixed2, %%rsi \n\t"
+			      "mov (%[addr]), %[reg] \n\t"
+			      "fixed2:"
+			      : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
+			      : [addr]"r"(at->virt)
+			      : "rsi");
+		fault = 0;
+	}
+
+	asm volatile ("mov $fixed1, %%rsi \n\t"
+		      "mov %%rsp, %[rsp0] \n\t"
+		      "cmp $0, %[user] \n\t"
+		      "jz do_access \n\t"
+		      "push %%rax; mov %[user_ds], %%ax; mov %%ax, %%ds; pop %%rax \n\t"
+		      "pushq %[user_ds] \n\t"
+		      "pushq %[user_stack_top] \n\t"
+		      "pushfq \n\t"
+		      "pushq %[user_cs] \n\t"
+		      "pushq $do_access \n\t"
+		      "iretq \n"
+		      "do_access: \n\t"
+		      "cmp $0, %[fetch] \n\t"
+		      "jnz 2f \n\t"
+		      "cmp $0, %[write] \n\t"
+		      "jnz 1f \n\t"
+		      "mov (%[addr]), %[reg] \n\t"
+		      "jmp done \n\t"
+		      "1: mov %[reg], (%[addr]) \n\t"
+		      "jmp done \n\t"
+		      "2: call *%[addr] \n\t"
+		      "done: \n"
+		      "fixed1: \n"
+		      "int %[kernel_entry_vector] \n\t"
+		      ".section .text.entry \n\t"
+		      "kernel_entry: \n\t"
+		      "mov %[rsp0], %%rsp \n\t"
+		      "jmp back_to_kernel \n\t"
+		      ".section .text \n\t"
+		      "back_to_kernel:"
+		      : [reg]"+r"(r), "+a"(fault), "=b"(e), "=&d"(rsp),
+			[rsp0]"=m"(tss[0].rsp0)
+		      : [addr]"r"(at->virt),
+			[write]"r"(F(AC_ACCESS_WRITE)),
+			[user]"r"(F(AC_ACCESS_USER)),
+			[fetch]"r"(F(AC_ACCESS_FETCH)),
+			[user_ds]"i"(USER_DS),
+			[user_cs]"i"(USER_CS),
+			[user_stack_top]"r"(user_stack + sizeof user_stack),
+			[kernel_entry_vector]"i"(0x20)
+		      : "rsi");
+
+	asm volatile (".section .text.pf \n\t"
+		      "page_fault: \n\t"
+		      "pop %rbx \n\t"
+		      "mov %rsi, (%rsp) \n\t"
+		      "movl $1, %eax \n\t"
+		      "iretq \n\t"
+		      ".section .text");
+
+	ac_test_check(at, &success, fault && !at->expected_fault,
+		      "unexpected fault");
+	ac_test_check(at, &success, !fault && at->expected_fault,
+		      "unexpected access");
+	ac_test_check(at, &success, fault && e != at->expected_error,
+		      "error code %x expected %x", e, at->expected_error);
+	if (at->ptep)
+		ac_test_check(at, &success, *at->ptep != at->expected_pte,
+			      "pte %x expected %x", *at->ptep, at->expected_pte);
+	ac_test_check(at, &success,
+		      !pt_match(*at->pdep, at->expected_pde, at->ignore_pde),
+		      "pde %x expected %x", *at->pdep, at->expected_pde);
+
+	if (success && verbose) {
+		if (at->expected_fault) {
+			printf("PASS (%x)\n", at->expected_error);
+		} else {
+			printf("PASS\n");
+		}
+	}
+	return success;
 }
 
 static void ac_test_show(ac_test_t *at)
 {
-    char line[5000];
-
-    *line = 0;
-    strcat(line, "test");
-    for (int i = 0; i < NR_AC_FLAGS; ++i)
-	if (at->flags & (1 << i)) {
-	    strcat(line, " ");
-	    strcat(line, ac_names[i]);
-	}
-
-    strcat(line, ": ");
-    printf("%s", line);
+	char line[5000];
+
+	*line = 0;
+	strcat(line, "test");
+	for (int i = 0; i < NR_AC_FLAGS; ++i)
+		if (at->flags & (1 << i)) {
+			strcat(line, " ");
+			strcat(line, ac_names[i]);
+		}
+
+	strcat(line, ": ");
+	printf("%s", line);
 }
 
 /*
@@ -815,36 +814,36 @@ static void ac_test_show(ac_test_t *at)
  */
 static int corrupt_hugepage_triger(ac_pool_t *pool)
 {
-    ac_test_t at1, at2;
+	ac_test_t at1, at2;
 
-    ac_test_init(&at1, (void *)(0x123400000000));
-    ac_test_init(&at2, (void *)(0x666600000000));
+	ac_test_init(&at1, (void *)(0x123400000000));
+	ac_test_init(&at2, (void *)(0x666600000000));
 
-    at2.flags = AC_CPU_CR0_WP_MASK | AC_PDE_PSE_MASK | AC_PDE_PRESENT_MASK;
-    ac_test_setup_pte(&at2, pool);
-    if (!ac_test_do_access(&at2))
-        goto err;
+	at2.flags = AC_CPU_CR0_WP_MASK | AC_PDE_PSE_MASK | AC_PDE_PRESENT_MASK;
+	ac_test_setup_pte(&at2, pool);
+	if (!ac_test_do_access(&at2))
+		goto err;
 
-    at1.flags = at2.flags | AC_PDE_WRITABLE_MASK;
-    ac_test_setup_pte(&at1, pool);
-    if (!ac_test_do_access(&at1))
-        goto err;
+	at1.flags = at2.flags | AC_PDE_WRITABLE_MASK;
+	ac_test_setup_pte(&at1, pool);
+	if (!ac_test_do_access(&at1))
+		goto err;
 
-    at1.flags |= AC_ACCESS_WRITE_MASK;
-    ac_set_expected_status(&at1);
-    if (!ac_test_do_access(&at1))
-        goto err;
+	at1.flags |= AC_ACCESS_WRITE_MASK;
+	ac_set_expected_status(&at1);
+	if (!ac_test_do_access(&at1))
+		goto err;
 
-    at2.flags |= AC_ACCESS_WRITE_MASK;
-    ac_set_expected_status(&at2);
-    if (!ac_test_do_access(&at2))
-        goto err;
+	at2.flags |= AC_ACCESS_WRITE_MASK;
+	ac_set_expected_status(&at2);
+	if (!ac_test_do_access(&at2))
+		goto err;
 
-    return 1;
+	return 1;
 
 err:
-    printf("corrupt_hugepage_triger test fail\n");
-    return 0;
+	printf("corrupt_hugepage_triger test fail\n");
+	return 0;
 }
 
 /*
@@ -861,24 +860,24 @@ static int check_pfec_on_prefetch_pte(ac_pool_t *pool)
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK;
 	ac_setup_specific_pages(&at1, pool, 30 * 1024 * 1024, 30 * 1024 * 1024);
 
-        at2.flags = at1.flags | AC_PTE_NX_MASK;
+	at2.flags = at1.flags | AC_PTE_NX_MASK;
 	ac_setup_specific_pages(&at2, pool, 30 * 1024 * 1024, 30 * 1024 * 1024);
 
 	if (!ac_test_do_access(&at1)) {
 		printf("%s: prepare fail\n", __FUNCTION__);
-		goto err;
+			goto err;
 	}
 
 	if (!ac_test_do_access(&at2)) {
 		printf("%s: check PFEC on prefetch pte path fail\n",
-			__FUNCTION__);
+		       __FUNCTION__);
 		goto err;
 	}
 
 	return 1;
 
 err:
-    return 0;
+	return 0;
 }
 
 /*
@@ -903,14 +902,14 @@ static int check_large_pte_dirty_for_nowp(ac_pool_t *pool)
 	ac_test_init(&at1, (void *)(0x123403000000));
 	ac_test_init(&at2, (void *)(0x666606000000));
 
-        at2.flags = AC_PDE_PRESENT_MASK | AC_PDE_PSE_MASK;
+	at2.flags = AC_PDE_PRESENT_MASK | AC_PDE_PSE_MASK;
 	ac_test_setup_pte(&at2, pool);
 	if (!ac_test_do_access(&at2)) {
 		printf("%s: read on the first mapping fail.\n", __FUNCTION__);
 		goto err;
 	}
 
-        at1.flags = at2.flags | AC_ACCESS_WRITE_MASK;
+	at1.flags = at2.flags | AC_ACCESS_WRITE_MASK;
 	ac_test_setup_pte(&at1, pool);
 	if (!ac_test_do_access(&at1)) {
 		printf("%s: write on the second mapping fail.\n", __FUNCTION__);
@@ -936,17 +935,17 @@ static int check_smep_andnot_wp(ac_pool_t *pool)
 	int err_prepare_andnot_wp, err_smep_andnot_wp;
 
 	if (!this_cpu_has(X86_FEATURE_SMEP)) {
-	    return 1;
+		return 1;
 	}
 
 	ac_test_init(&at1, (void *)(0x123406001000));
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
-            AC_PDE_USER_MASK | AC_PTE_USER_MASK |
-            AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
-            AC_CPU_CR4_SMEP_MASK |
-            AC_CPU_CR0_WP_MASK |
-            AC_ACCESS_WRITE_MASK;
+		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
+		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
+		    AC_CPU_CR4_SMEP_MASK |
+		    AC_CPU_CR0_WP_MASK |
+		    AC_ACCESS_WRITE_MASK;
 	ac_test_setup_pte(&at1, pool);
 
 	/*
@@ -960,10 +959,10 @@ static int check_smep_andnot_wp(ac_pool_t *pool)
 		goto clean_up;
 	}
 
-        at1.flags &= ~AC_ACCESS_WRITE_MASK;
-        at1.flags |= AC_ACCESS_FETCH_MASK;
-        ac_set_expected_status(&at1);
-        err_smep_andnot_wp = ac_test_do_access(&at1);
+	at1.flags &= ~AC_ACCESS_WRITE_MASK;
+	at1.flags |= AC_ACCESS_FETCH_MASK;
+	ac_set_expected_status(&at1);
+	err_smep_andnot_wp = ac_test_do_access(&at1);
 
 clean_up:
 	set_cr4_smep(0);
@@ -1049,14 +1048,14 @@ static int check_effective_sp_permissions(ac_pool_t *pool)
 
 static int ac_test_exec(ac_test_t *at, ac_pool_t *pool)
 {
-    int r;
-
-    if (verbose) {
-        ac_test_show(at);
-    }
-    ac_test_setup_pte(at, pool);
-    r = ac_test_do_access(at);
-    return r;
+	int r;
+
+	if (verbose) {
+		ac_test_show(at);
+	}
+	ac_test_setup_pte(at, pool);
+	r = ac_test_do_access(at);
+	return r;
 }
 
 typedef int (*ac_test_fn)(ac_pool_t *pool);
@@ -1071,82 +1070,82 @@ const ac_test_fn ac_test_cases[] =
 
 int ac_test_run()
 {
-    ac_test_t at;
-    ac_pool_t pool;
-    int i, tests, successes;
-
-    printf("run\n");
-    tests = successes = 0;
-
-    shadow_cr0 = read_cr0();
-    shadow_cr4 = read_cr4();
-    shadow_efer = rdmsr(MSR_EFER);
-
-    if (cpuid_maxphyaddr() >= 52) {
-        invalid_mask |= AC_PDE_BIT51_MASK;
-        invalid_mask |= AC_PTE_BIT51_MASK;
-    }
-    if (cpuid_maxphyaddr() >= 37) {
-        invalid_mask |= AC_PDE_BIT36_MASK;
-        invalid_mask |= AC_PTE_BIT36_MASK;
-    }
-
-    if (this_cpu_has(X86_FEATURE_PKU)) {
-        set_cr4_pke(1);
-        set_cr4_pke(0);
-        /* Now PKRU = 0xFFFFFFFF.  */
-    } else {
-	tests++;
-	if (write_cr4_checking(shadow_cr4 | X86_CR4_PKE) == GP_VECTOR) {
-            successes++;
-            invalid_mask |= AC_PKU_AD_MASK;
-            invalid_mask |= AC_PKU_WD_MASK;
-            invalid_mask |= AC_PKU_PKEY_MASK;
-            invalid_mask |= AC_CPU_CR4_PKE_MASK;
-            printf("CR4.PKE not available, disabling PKE tests\n");
-	} else {
-            printf("Set PKE in CR4 - expect #GP: FAIL!\n");
-            set_cr4_pke(0);
+	ac_test_t at;
+	ac_pool_t pool;
+	int i, tests, successes;
+
+	printf("run\n");
+	tests = successes = 0;
+
+	shadow_cr0 = read_cr0();
+	shadow_cr4 = read_cr4();
+	shadow_efer = rdmsr(MSR_EFER);
+
+	if (cpuid_maxphyaddr() >= 52) {
+		invalid_mask |= AC_PDE_BIT51_MASK;
+		invalid_mask |= AC_PTE_BIT51_MASK;
+	}
+	if (cpuid_maxphyaddr() >= 37) {
+		invalid_mask |= AC_PDE_BIT36_MASK;
+		invalid_mask |= AC_PTE_BIT36_MASK;
 	}
-    }
-
-    if (!this_cpu_has(X86_FEATURE_SMEP)) {
-	tests++;
-	if (set_cr4_smep(1) == GP_VECTOR) {
-            successes++;
-            invalid_mask |= AC_CPU_CR4_SMEP_MASK;
-            printf("CR4.SMEP not available, disabling SMEP tests\n");
+
+	if (this_cpu_has(X86_FEATURE_PKU)) {
+		set_cr4_pke(1);
+		set_cr4_pke(0);
+		/* Now PKRU = 0xFFFFFFFF.  */
 	} else {
-            printf("Set SMEP in CR4 - expect #GP: FAIL!\n");
-            set_cr4_smep(0);
+		tests++;
+		if (write_cr4_checking(shadow_cr4 | X86_CR4_PKE) == GP_VECTOR) {
+			successes++;
+			invalid_mask |= AC_PKU_AD_MASK;
+			invalid_mask |= AC_PKU_WD_MASK;
+			invalid_mask |= AC_PKU_PKEY_MASK;
+			invalid_mask |= AC_CPU_CR4_PKE_MASK;
+			printf("CR4.PKE not available, disabling PKE tests\n");
+		} else {
+			printf("Set PKE in CR4 - expect #GP: FAIL!\n");
+			set_cr4_pke(0);
+		}
+	}
+
+	if (!this_cpu_has(X86_FEATURE_SMEP)) {
+		tests++;
+		if (set_cr4_smep(1) == GP_VECTOR) {
+			successes++;
+			invalid_mask |= AC_CPU_CR4_SMEP_MASK;
+			printf("CR4.SMEP not available, disabling SMEP tests\n");
+		} else {
+			printf("Set SMEP in CR4 - expect #GP: FAIL!\n");
+			set_cr4_smep(0);
+		}
+	}
+
+	/* Toggling LA57 in 64-bit mode (guaranteed for this test) is illegal. */
+	if (this_cpu_has(X86_FEATURE_LA57)) {
+		tests++;
+		if (write_cr4_checking(shadow_cr4 ^ X86_CR4_LA57) == GP_VECTOR)
+			successes++;
+
+		/* Force a VM-Exit on KVM, which doesn't intercept LA57 itself. */
+		tests++;
+		if (write_cr4_checking(shadow_cr4 ^ (X86_CR4_LA57 | X86_CR4_PSE)) == GP_VECTOR)
+			successes++;
 	}
-    }
-
-    /* Toggling LA57 in 64-bit mode (guaranteed for this test) is illegal. */
-    if (this_cpu_has(X86_FEATURE_LA57)) {
-        tests++;
-        if (write_cr4_checking(shadow_cr4 ^ X86_CR4_LA57) == GP_VECTOR)
-            successes++;
-
-        /* Force a VM-Exit on KVM, which doesn't intercept LA57 itself. */
-        tests++;
-        if (write_cr4_checking(shadow_cr4 ^ (X86_CR4_LA57 | X86_CR4_PSE)) == GP_VECTOR)
-            successes++;
-    }
-
-    ac_env_int(&pool);
-    ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()));
-    do {
-	++tests;
-	successes += ac_test_exec(&at, &pool);
-    } while (ac_test_bump(&at));
-
-    for (i = 0; i < ARRAY_SIZE(ac_test_cases); i++) {
-	++tests;
-	successes += ac_test_cases[i](&pool);
-    }
-
-    printf("\n%d tests, %d failures\n", tests, tests - successes);
-
-    return successes == tests;
+
+	ac_env_int(&pool);
+	ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()));
+	do {
+		++tests;
+		successes += ac_test_exec(&at, &pool);
+	} while (ac_test_bump(&at));
+
+	for (i = 0; i < ARRAY_SIZE(ac_test_cases); i++) {
+		++tests;
+		successes += ac_test_cases[i](&pool);
+	}
+
+	printf("\n%d tests, %d failures\n", tests, tests - successes);
+
+	return successes == tests;
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog

