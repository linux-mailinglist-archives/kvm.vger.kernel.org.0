Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC2544CB45
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhKJVXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbhKJVXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:36 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFFEC061226
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:37 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id p12-20020a17090b010c00b001a65bfe8054so1723219pjz.8
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JiXicHEorTD0W0ogbHs6tJnf0LcMa3Cy3C2YtlUwBjQ=;
        b=HRwG4ZjIx3xWJJo4dvUkSljuoPWs7AvFpKsfDZBdie/XltQdzUG/gnh20fCALTdE26
         OcMXByYAUp/H83RsPq0Mrpfy8HVWvoA0hYdecG9Uty5oSZRXnHSggT5A/RvTU8ofTgKf
         WXdIgwx/778sCMAFFEyl4Pb745s+QLUE+rlL+jzHhr01iJkuH/4xTdyQCYJHFiSG5All
         NOgUx6BAxEWh0v8LSIvPtv+KzdWj5tRqLdbZgnloWWpVmnP1Emw5w+GewpwMqQ6WUES7
         uI4bwytM8885lSUQcvaFQpsNjnwILZDw1WC2uBuEPabuz09Vbw0b5h6kNhi/YFolKzfM
         BXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JiXicHEorTD0W0ogbHs6tJnf0LcMa3Cy3C2YtlUwBjQ=;
        b=DXKdbFtL0ELfRctJEMteMUavPWpBFywGX7aUN292ghu4AYRMcp9Gs51U/+zumJLJW1
         8iQh14PtKZkKkgnUdgKFif+pnze1yhKRMLKjICInIRiKv6DwCUXbKYqL9p2Zzooh460w
         6K47oADMo5JT9u6PnyXqCjmY8km5ijONBm0/+hU8jPw9vEIZduUcHgVJu59UxqaDjA7M
         HGpvPJc3ORsJUgqnOAL0VM4AI4tsh77neikwj/xeqU7Rhlr9p3s5SqDFUls5AkYhgvXW
         qO22yG4+KDuYv7fpSPz5Wf536hPWSaSPdribg18Ae5OEijx0/xIHKH3k/O3frvZl5u0r
         S/wA==
X-Gm-Message-State: AOAM531k4b3257bIiaNQvWOtMEoAP7lU8iG6a8Jh6ZgTlrGlfbn0BmyI
        CEjG5sYDWLbRGnp6coRJ/ntAPJowXkuWzUtmI4VezmSYSJWWHDXgtZDM71hQQMMlHZl89NdpuQW
        JiqY70XTW5YYfqiVfkLlxFHHq5uYILXCIVhNwt0cTqkTDq0okSXCmFEb62dbIau566+gK
X-Google-Smtp-Source: ABdhPJzN7nSOLibM+XPsF5o01UO1BnBwcmw7LG7bd0pucMtVbhZ7cr6ZaxIMTp4xFIcX7dkly1VMA2BwmrntEmK8
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:a8b:b0:44d:ef7c:94b9 with SMTP
 id b11-20020a056a000a8b00b0044def7c94b9mr2112017pfl.36.1636579236669; Wed, 10
 Nov 2021 13:20:36 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:20:00 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-14-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 13/14] x86: Clean up the global,
 page_table_levels, in access.c
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the global, page table levels, from access.c and store it in the
test struct ac_test_t instead.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/access.c      | 50 ++++++++++++++++++++++++-----------------------
 x86/access.h      |  5 +++--
 x86/access_test.c |  6 ++----
 3 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index f832385..c5e71db 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -14,7 +14,6 @@ static _Bool verbose = false;
 
 typedef unsigned long pt_element_t;
 static int invalid_mask;
-int page_table_levels;
 
 #define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
 #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
@@ -174,6 +173,7 @@ typedef struct {
 	pt_element_t ignore_pde;
 	int expected_fault;
 	unsigned expected_error;
+	int page_table_levels;
 } ac_test_t;
 
 typedef struct {
@@ -278,13 +278,14 @@ static void ac_env_int(ac_pool_t *pool)
 	pool->pt_pool_current = 0;
 }
 
-static void ac_test_init(ac_test_t *at, void *virt)
+static void ac_test_init(ac_test_t *at, void *virt, int page_table_levels)
 {
 	set_efer_nx(1);
 	set_cr0_wp(1);
 	at->flags = 0;
 	at->virt = virt;
 	at->phys = 32 * 1024 * 1024;
+	at->page_table_levels = page_table_levels;
 }
 
 static int ac_test_bump_one(ac_test_t *at)
@@ -518,7 +519,7 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse
 		ac_test_reset_pt_pool(pool);
 
 	at->ptep = 0;
-	for (int i = page_table_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
+	for (int i = at->page_table_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
 		pt_element_t *vroot = va(root & PT_BASE_ADDR_MASK);
 		unsigned index = PT_INDEX((unsigned long)at->virt, i);
 		pt_element_t pte = 0;
@@ -635,7 +636,7 @@ static void dump_mapping(ac_test_t *at)
 	int i;
 
 	printf("Dump mapping: address: %p\n", at->virt);
-	for (i = page_table_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
+	for (i = at->page_table_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
 		pt_element_t *vroot = va(root & PT_BASE_ADDR_MASK);
 		unsigned index = PT_INDEX((unsigned long)at->virt, i);
 		pt_element_t pte = vroot[index];
@@ -812,12 +813,12 @@ static void ac_test_show(ac_test_t *at)
  * This test case is used to triger the bug which is fixed by
  * commit e09e90a5 in the kvm tree
  */
-static int corrupt_hugepage_triger(ac_pool_t *pool)
+static int corrupt_hugepage_triger(ac_pool_t *pool, int page_table_levels)
 {
 	ac_test_t at1, at2;
 
-	ac_test_init(&at1, (void *)(0x123400000000));
-	ac_test_init(&at2, (void *)(0x666600000000));
+	ac_test_init(&at1, (void *)(0x123400000000), page_table_levels);
+	ac_test_init(&at2, (void *)(0x666600000000), page_table_levels);
 
 	at2.flags = AC_CPU_CR0_WP_MASK | AC_PDE_PSE_MASK | AC_PDE_PRESENT_MASK;
 	ac_test_setup_pte(&at2, pool);
@@ -850,12 +851,12 @@ err:
  * This test case is used to triger the bug which is fixed by
  * commit 3ddf6c06e13e in the kvm tree
  */
-static int check_pfec_on_prefetch_pte(ac_pool_t *pool)
+static int check_pfec_on_prefetch_pte(ac_pool_t *pool, int page_table_levels)
 {
 	ac_test_t at1, at2;
 
-	ac_test_init(&at1, (void *)(0x123406001000));
-	ac_test_init(&at2, (void *)(0x123406003000));
+	ac_test_init(&at1, (void *)(0x123406001000), page_table_levels);
+	ac_test_init(&at2, (void *)(0x123406003000), page_table_levels);
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK;
 	ac_setup_specific_pages(&at1, pool, 30 * 1024 * 1024, 30 * 1024 * 1024);
@@ -895,12 +896,12 @@ err:
  *
  * Note: to trigger this bug, hugepage should be disabled on host.
  */
-static int check_large_pte_dirty_for_nowp(ac_pool_t *pool)
+static int check_large_pte_dirty_for_nowp(ac_pool_t *pool, int page_table_levels)
 {
 	ac_test_t at1, at2;
 
-	ac_test_init(&at1, (void *)(0x123403000000));
-	ac_test_init(&at2, (void *)(0x666606000000));
+	ac_test_init(&at1, (void *)(0x123403000000), page_table_levels);
+	ac_test_init(&at2, (void *)(0x666606000000), page_table_levels);
 
 	at2.flags = AC_PDE_PRESENT_MASK | AC_PDE_PSE_MASK;
 	ac_test_setup_pte(&at2, pool);
@@ -929,7 +930,7 @@ err:
 	return 0;
 }
 
-static int check_smep_andnot_wp(ac_pool_t *pool)
+static int check_smep_andnot_wp(ac_pool_t *pool, int page_table_levels)
 {
 	ac_test_t at1;
 	int err_prepare_andnot_wp, err_smep_andnot_wp;
@@ -938,7 +939,7 @@ static int check_smep_andnot_wp(ac_pool_t *pool)
 		return 1;
 	}
 
-	ac_test_init(&at1, (void *)(0x123406001000));
+	ac_test_init(&at1, (void *)(0x123406001000), page_table_levels);
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
 		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
@@ -979,7 +980,7 @@ err:
 	return 0;
 }
 
-static int check_effective_sp_permissions(ac_pool_t *pool)
+static int check_effective_sp_permissions(ac_pool_t *pool, int page_table_levels)
 {
 	unsigned long ptr1 = 0x123480000000;
 	unsigned long ptr2 = ptr1 + SZ_2M;
@@ -1000,22 +1001,22 @@ static int check_effective_sp_permissions(ac_pool_t *pool)
 	 * pud1 and pud2 point to the same pmd page.
 	 */
 
-	ac_test_init(&at1, (void *)(ptr1));
+	ac_test_init(&at1, (void *)(ptr1), page_table_levels);
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
 		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
 		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
 		    AC_PTE_WRITABLE_MASK | AC_ACCESS_USER_MASK;
 	__ac_setup_specific_pages(&at1, pool, false, pmd, 0);
 
-	ac_test_init(&at2, (void *)(ptr2));
+	ac_test_init(&at2, (void *)(ptr2), page_table_levels);
 	at2.flags = at1.flags | AC_PDE_WRITABLE_MASK | AC_PTE_DIRTY_MASK | AC_ACCESS_WRITE_MASK;
 	__ac_setup_specific_pages(&at2, pool, true, pmd, 0);
 
-	ac_test_init(&at3, (void *)(ptr3));
+	ac_test_init(&at3, (void *)(ptr3), page_table_levels);
 	at3.flags = AC_PDPTE_NO_WRITABLE_MASK | at1.flags;
 	__ac_setup_specific_pages(&at3, pool, true, pmd, 0);
 
-	ac_test_init(&at4, (void *)(ptr4));
+	ac_test_init(&at4, (void *)(ptr4), page_table_levels);
 	at4.flags = AC_PDPTE_NO_WRITABLE_MASK | at2.flags;
 	__ac_setup_specific_pages(&at4, pool, true, pmd, 0);
 
@@ -1058,7 +1059,7 @@ static int ac_test_exec(ac_test_t *at, ac_pool_t *pool)
 	return r;
 }
 
-typedef int (*ac_test_fn)(ac_pool_t *pool);
+typedef int (*ac_test_fn)(ac_pool_t *pool, int page_table_levels);
 const ac_test_fn ac_test_cases[] =
 {
 	corrupt_hugepage_triger,
@@ -1068,7 +1069,7 @@ const ac_test_fn ac_test_cases[] =
 	check_effective_sp_permissions,
 };
 
-int ac_test_run()
+int ac_test_run(int page_table_levels)
 {
 	ac_test_t at;
 	ac_pool_t pool;
@@ -1134,7 +1135,8 @@ int ac_test_run()
 	}
 
 	ac_env_int(&pool);
-	ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()));
+	ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()),
+		page_table_levels);
 	do {
 		++tests;
 		successes += ac_test_exec(&at, &pool);
@@ -1142,7 +1144,7 @@ int ac_test_run()
 
 	for (i = 0; i < ARRAY_SIZE(ac_test_cases); i++) {
 		++tests;
-		successes += ac_test_cases[i](&pool);
+		successes += ac_test_cases[i](&pool, page_table_levels);
 	}
 
 	printf("\n%d tests, %d failures\n", tests, tests - successes);
diff --git a/x86/access.h b/x86/access.h
index 4f67b62..bcfa7b2 100644
--- a/x86/access.h
+++ b/x86/access.h
@@ -1,8 +1,9 @@
 #ifndef X86_ACCESS_H
 #define X86_ACCESS_H
 
-int ac_test_run(void);
+#define PT_LEVEL_PML4 4
+#define PT_LEVEL_PML5 5
 
-extern int page_table_levels;
+int ac_test_run(int page_table_levels);
 
 #endif // X86_ACCESS_H
\ No newline at end of file
diff --git a/x86/access_test.c b/x86/access_test.c
index 497f286..991f333 100644
--- a/x86/access_test.c
+++ b/x86/access_test.c
@@ -8,14 +8,12 @@ int main(void)
     int r;
 
     printf("starting test\n\n");
-    page_table_levels = 4;
-    r = ac_test_run();
+    r = ac_test_run(PT_LEVEL_PML4);
 
     if (this_cpu_has(X86_FEATURE_LA57)) {
-        page_table_levels = 5;
         printf("starting 5-level paging test.\n\n");
         setup_5level_page_table();
-        r = ac_test_run();
+        r = ac_test_run(PT_LEVEL_PML5);
     }
 
     return r ? 0 : 1;
-- 
2.34.0.rc1.387.gb447b232ab-goog

