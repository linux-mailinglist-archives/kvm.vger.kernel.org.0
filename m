Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890154D66E6
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 17:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349507AbiCKQ5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 11:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240931AbiCKQ5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 11:57:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D6851D3052
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 08:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647017776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GnNrjAxrT5ZrO3afz3SeyvIGZ5jINI+roKjTEpwxAD8=;
        b=TsndNmtauQx0N0b7GKif8Lqs37k1TB9gTJMxd5uBvIZZLOSKxO4tsWcpNQcI2TrWWp7y2e
        K0sQOCVLiuvYbmdRMsbDXoSxgF29UzgAD6uH8omrl6kb9n8f4qg5iHd/OoTqorL2FutjSf
        nqB9bSKLmXIwgEHrjk1RjbyLFUyJd4A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-GUr94pwmPyK05ihjJc4bbg-1; Fri, 11 Mar 2022 11:56:15 -0500
X-MC-Unique: GUr94pwmPyK05ihjJc4bbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E145835DE4
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 16:56:14 +0000 (UTC)
Received: from thuth.com (unknown [10.39.194.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70BAF7BCC9;
        Fri, 11 Mar 2022 16:56:13 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] x86: Fix typos
Date:   Fri, 11 Mar 2022 17:56:10 +0100
Message-Id: <20220311165610.2898136-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Correct typos which were discovered with the "codespell" utility.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
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
index 83c8221..086bc84 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -891,10 +891,10 @@ static void ac_test_show(ac_test_t *at)
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
 
@@ -924,12 +924,12 @@ static int corrupt_hugepage_triger(ac_pt_env_t *pt_env)
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
@@ -1146,7 +1146,7 @@ static int ac_test_exec(ac_test_t *at, ac_pt_env_t *pt_env)
 typedef int (*ac_test_fn)(ac_pt_env_t *pt_env);
 const ac_test_fn ac_test_cases[] =
 {
-	corrupt_hugepage_triger,
+	corrupt_hugepage_trigger,
 	check_pfec_on_prefetch_pte,
 	check_large_pte_dirty_for_nowp,
 	check_smep_andnot_wp,
diff --git a/x86/cet.c b/x86/cet.c
index a4b79cb..7a392a3 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -45,7 +45,7 @@ static u64 cet_shstk_func(void)
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
index 3f94b2a..f170924 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -418,7 +418,7 @@ int main(int ac, char **av)
 	__setup_vm(&opt_mask);
 
 	if (!this_cpu_has(X86_FEATURE_SVM)) {
-		printf("SVM not availble\n");
+		printf("SVM not available\n");
 		return report_summary();
 	}
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 0707786..da38400 100644
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
@@ -3071,7 +3071,7 @@ static void svm_nm_test(void)
 
     vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
     report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
-        "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
+        "fnop with CR0.TS and CR0.EM unset no #NM exception");
 }
 
 struct svm_test svm_tests[] = {
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
index 51eed8c..362e603 100644
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

