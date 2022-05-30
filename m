Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE625374BE
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 09:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbiE3Gsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 02:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbiE3Gsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 02:48:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E3254ECD6
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 23:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653893316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6/2+mw5wOTszB5ngQLGSvBZ5dsDI9mRue3prVUj4clU=;
        b=DAI+g9qRzIPf5C1mQ95FzVI0UJk8KtGoHJUFhnL4OyrCP0+eCw3CMLecclmKZjEKSyN+jz
        jgAQwBT+UxUnRP1Pvu7xq57bJ3Ly33h5enxUiltV04Bukm+TrTrbwZs8XlWFSYnjxoP+J5
        FP5DLkt4X00eeoWtNBGHWCohif7oxSo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-zccNl2AIM0SOndchrcswvA-1; Mon, 30 May 2022 02:48:34 -0400
X-MC-Unique: zccNl2AIM0SOndchrcswvA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09301101AA46
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 06:48:34 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 626EC1410DDB;
        Mon, 30 May 2022 06:48:33 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Fix typos
Date:   Mon, 30 May 2022 08:48:31 +0200
Message-Id: <20220530064831.8828-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Correct typos which were discovered with the "codespell" utility.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 I thought I had sent this out a while ago already, but I can't find this in
 the archives ... so I likely missed to hit the "send" button, or it didn't
 go through the mail server... Anyway, sorry if you got this twice.

 x86/access.c      | 10 +++++-----
 x86/cet.c         |  2 +-
 x86/eventinj.c    |  6 +++---
 x86/kvmclock.c    |  4 ++--
 x86/svm.c         |  2 +-
 x86/svm_tests.c   |  4 ++--
 x86/taskswitch2.c | 12 ++++++------
 x86/vmx.c         |  2 +-
 x86/vmx_tests.c   |  8 ++++----
 9 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 21b4d74..3832e2e 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -894,10 +894,10 @@ static void ac_test_show(ac_test_t *at)
 }
 
 /*
- * This test case is used to triger the bug which is fixed by
+ * This test case is used to trigger the bug which is fixed by
  * commit e09e90a5 in the kvm tree
  */
-static int corrupt_hugepage_triger(ac_pt_env_t *pt_env)
+static int corrupt_hugepage_trigger(ac_pt_env_t *pt_env)
 {
 	ac_test_t at1, at2;
 
@@ -927,12 +927,12 @@ static int corrupt_hugepage_triger(ac_pt_env_t *pt_env)
 	return 1;
 
 err:
-	printf("corrupt_hugepage_triger test fail\n");
+	printf("corrupt_hugepage_trigger test fail\n");
 	return 0;
 }
 
 /*
- * This test case is used to triger the bug which is fixed by
+ * This test case is used to trigger the bug which is fixed by
  * commit 3ddf6c06e13e in the kvm tree
  */
 static int check_pfec_on_prefetch_pte(ac_pt_env_t *pt_env)
@@ -1149,7 +1149,7 @@ static int ac_test_exec(ac_test_t *at, ac_pt_env_t *pt_env)
 typedef int (*ac_test_fn)(ac_pt_env_t *pt_env);
 const ac_test_fn ac_test_cases[] =
 {
-	corrupt_hugepage_triger,
+	corrupt_hugepage_trigger,
 	check_pfec_on_prefetch_pte,
 	check_large_pte_dirty_for_nowp,
 	check_smep_andnot_wp,
diff --git a/x86/cet.c b/x86/cet.c
index ed8616a..c01dd89 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -37,7 +37,7 @@ static u64 cet_shstk_func(void)
 static u64 cet_ibt_func(void)
 {
 	/*
-	 * In below assembly code, the first instruction at lable 2 is not
+	 * In below assembly code, the first instruction at label 2 is not
 	 * endbr64, it'll trigger #CP with error code 0x3, and the execution
 	 * is terminated when HW detects the violation.
 	 */
diff --git a/x86/eventinj.c b/x86/eventinj.c
index 3c0db56..3031c04 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -286,7 +286,7 @@ int main(void)
 	printf("After int $33\n");
 	report(test_count == 1, "int $33");
 
-	/* Inject two HW interrupt than open iterrupt windows. Both interrupt
+	/* Inject two HW interrupt than open interrupt windows. Both interrupt
 	   will fault on IDT access */
 	test_count = 0;
 	flush_idt_page();
@@ -302,8 +302,8 @@ int main(void)
 
 
 	/* Inject HW interrupt, do sti and than (while in irq shadow) inject
-	   soft interrupt. Fault during soft interrupt. Soft interrup shoud be
-	   handled before HW interrupt */
+	   soft interrupt. Fault during soft interrupt. Soft interrupt should
+	   be handled before HW interrupt */
 	test_count = 0;
 	flush_idt_page();
 	printf("Sending vec 32 and int $33\n");
diff --git a/x86/kvmclock.c b/x86/kvmclock.c
index de30a5e..f190048 100644
--- a/x86/kvmclock.c
+++ b/x86/kvmclock.c
@@ -201,8 +201,8 @@ static cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 	/*
 	 * Assumption here is that last_value, a global accumulator, always goes
 	 * forward. If we are less than that, we should not be much smaller.
-	 * We assume there is an error marging we're inside, and then the correction
-	 * does not sacrifice accuracy.
+	 * We assume there is an error margin we're inside, and then the
+	 * correction does not sacrifice accuracy.
 	 *
 	 * For reads: global may have changed between test and return,
 	 * but this means someone else updated poked the clock at a later time.
diff --git a/x86/svm.c b/x86/svm.c
index f6896f0..93794fd 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -409,7 +409,7 @@ int main(int ac, char **av)
 	__setup_vm(&opt_mask);
 
 	if (!this_cpu_has(X86_FEATURE_SVM)) {
-		printf("SVM not availble\n");
+		printf("SVM not available\n");
 		return report_summary();
 	}
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 6a9b03b..1bd4d3b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -397,7 +397,7 @@ static bool msr_intercept_finished(struct svm_test *test)
         }
 
         /*
-         * Warn that #GP exception occured instead.
+         * Warn that #GP exception occurred instead.
          * RCX holds the MSR index.
          */
         printf("%s 0x%lx #GP exception\n",
@@ -3208,7 +3208,7 @@ static void svm_nm_test(void)
 
     vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
     report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
-        "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
+        "fnop with CR0.TS and CR0.EM unset no #NM exception");
 }
 
 
diff --git a/x86/taskswitch2.c b/x86/taskswitch2.c
index 3c9af4c..db69f07 100644
--- a/x86/taskswitch2.c
+++ b/x86/taskswitch2.c
@@ -148,13 +148,13 @@ static void test_kernel_mode_int(void)
 
 	/* test that HW exception triggesr task gate */
 	set_intr_task_gate(0, de_tss);
-	printf("Try to devide by 0\n");
+	printf("Try to divide by 0\n");
 	asm volatile ("divl %3": "=a"(res)
 		      : "d"(0), "a"(1500), "m"(test_divider));
 	printf("Result is %d\n", res);
-	report(res == 150, "DE exeption");
+	report(res == 150, "DE exception");
 
-	/* test if call HW exeption DE by int $0 triggers task gate */
+	/* test if call HW exception DE by int $0 triggers task gate */
 	test_count = 0;
 	set_intr_task_gate(0, de_tss);
 	printf("Call int 0\n");
@@ -168,7 +168,7 @@ static void test_kernel_mode_int(void)
 	printf("Call into\n");
 	asm volatile ("addb $127, %b0\ninto"::"a"(127));
 	printf("Return from into\n");
-	report(test_count, "OF exeption");
+	report(test_count, "OF exception");
 
 	/* test if HW exception BP triggers task gate */
 	test_count = 0;
@@ -176,7 +176,7 @@ static void test_kernel_mode_int(void)
 	printf("Call int 3\n");
 	asm volatile ("int $3");
 	printf("Return from int 3\n");
-	report(test_count == 1, "BP exeption");
+	report(test_count == 1, "BP exception");
 
 	/*
 	 * test that PF triggers task gate and error code is placed on
@@ -189,7 +189,7 @@ static void test_kernel_mode_int(void)
 	printf("Access unmapped page\n");
 	*fault_addr = 0;
 	printf("Return from pf tss\n");
-	report(test_count == 1, "PF exeption");
+	report(test_count == 1, "PF exception");
 }
 
 static void test_gdt_task_gate(void)
diff --git a/x86/vmx.c b/x86/vmx.c
index 093da5e..c024298 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1477,7 +1477,7 @@ static int test_vmxon(void)
 		goto out;
 	}
 
-	/* invalid revision indentifier */
+	/* invalid revision identifier */
 	*bsp_vmxon_region = 0xba9da9;
 	ret1 = vmx_on();
 	report(ret1, "test vmxon with invalid revision identifier");
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index df93198..4d581e7 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -459,7 +459,7 @@ static void cr_shadowing_main(void)
 	vmx_set_test_stage(2);
 	write_cr0(guest_cr0);
 	if (vmx_get_test_stage() == 3)
-		report_fail("Write throuth CR0");
+		report_fail("Write through CR0");
 	else
 		vmcall();
 	vmx_set_test_stage(3);
@@ -2549,7 +2549,7 @@ static void ept_access_paddr(unsigned long ept_access, unsigned long pte_ad,
 	 * constructed our test such that those other 511 PTEs aren't used by
 	 * the guest: data->gva is at the beginning of a 1G huge page, thus the
 	 * PTE we're modifying is at the beginning of a 4K page and the
-	 * following 511 entires are also under our control (and not touched by
+	 * following 511 entries are also under our control (and not touched by
 	 * the guest).
 	 */
 	gpa = virt_to_phys(ptep);
@@ -4063,7 +4063,7 @@ static void test_posted_intr(void)
 	report_prefix_pop();
 
 	/*
-	 * Test posted-interrupt descriptor addresss
+	 * Test posted-interrupt descriptor address
 	 */
 	for (i = 0; i < 6; i++) {
 		test_pi_desc_addr(1ul << i, false);
@@ -10499,7 +10499,7 @@ static void atomic_switch_msrs_test(int count)
         struct vmx_msr_entry *vm_exit_store;
 	int max_allowed = max_msr_list_size();
 	int byte_capacity = 1ul << (msr_list_page_order + PAGE_SHIFT);
-	/* Exceeding the max MSR list size at exit trigers KVM to abort. */
+	/* Exceeding the max MSR list size at exit triggers KVM to abort. */
 	int exit_count = count > max_allowed ? max_allowed : count;
 	int cleanup_count = count > max_allowed ? 2 : 1;
 	int i;
-- 
2.27.0

