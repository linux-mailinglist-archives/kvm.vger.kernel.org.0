Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C1949BD33
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 21:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiAYUcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 15:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiAYUcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 15:32:07 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC50C06173B
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:32:06 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f35-20020a631f23000000b0035ec54b3bbcso2996732pgf.0
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=88jfaDj1il9xwABQu6LXGpSGhv+xtpdaHiWeEG67LVY=;
        b=okYA5H0p43iNISptw3Xv8jbZqsHIUpZHAK/xi0RfQM/MhC3vk40ByR9rh2Bulorp6c
         Iy/ert8hHbqSt9MduoGdTfT6goN5sJk50rLUlCTA7q4lbUqhO/zvlk75fbWxVAvyV9iG
         4K1tCr6s/vueQkTJK2uxrQc8vLsg6svFFsVjp7fKmW0Ng+8RRiDkdoNDf/NUJYVxXqKq
         ajJD6b6ZLn+yqNslERr8Mp+M8n4KHmG1nhy7eKFM+HaP6R3/7D2awJ58exrqhUuvoDsN
         8rVfZqjJWfqxtqAzisJSLre0LsHeLIx3rEgZReHn4xqAO/DyErsWPM1DZlX7tGrv4kYf
         9QpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=88jfaDj1il9xwABQu6LXGpSGhv+xtpdaHiWeEG67LVY=;
        b=hn6cwLfjGopKnI768zPQD8LUHucILiB6ppHfqdKHBLEmHxlJNTjV4VGDlk14tNO/vY
         Tg0DvgS7j/Qu2oabFQjTJiQRlmPSpZiuos7WuuSnTIxpXyiB3AXhPEkGEn4M7GBFVtTd
         sPFVwYsywI/hDf3/WomCcMF/242segbF6vHU/ZlRfte5/eGMloY5TQY3Pxqx9ctEs665
         wO0GuBSJVw+CteZ6+jXs9pxLCuDogayuPsIP4P75r5dt8kxr+GIxD5ikCJPhVCCbkSaU
         idXGPpTm3cdO+mAi6kNz4Otg6wpYCAV80L0c2Ml1rb8vSHCCahJ2mMib1nQvMT50koQI
         rhWQ==
X-Gm-Message-State: AOAM531weQ+dFNEHeBHDCQKZh7kdQBOYTpcAKUkWc3smQeGPtOlwtCje
        rj/C3AUWcrSsxDeDJfmLPJsfw752m8khsGctQkm7SfJ7RH9B1PriCoQI1xNr4HybVPud66Moo9Y
        R8hxcN8IdXsaCHXLY+fNTTOOoNK3Sq6AYoyZCEDem5Y7IOjz7mGuPRxx3OT2Brevjs+JH
X-Google-Smtp-Source: ABdhPJzspOH99CpfaZa0gp/EpXNI1SoU7hmZyMJsKeSuswUZWS4cmJKKxcdA+Bm1hoDyxkjjU3NMWRgrZxzKKCNh
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:8d83:b0:14b:4063:dbcd with SMTP
 id v3-20020a1709028d8300b0014b4063dbcdmr13170862plo.72.1643142726410; Tue, 25
 Jan 2022 12:32:06 -0800 (PST)
Date:   Tue, 25 Jan 2022 20:31:27 +0000
In-Reply-To: <20220125203127.1161838-1-aaronlewis@google.com>
Message-Id: <20220125203127.1161838-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220125203127.1161838-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH v5 4/4] x86: Add test coverage for
 nested_vmx_reflect_vmexit() testing
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a framework and test cases to ensure exceptions that occur in L2 are
forwarded to the correct place by nested_vmx_reflect_vmexit().

Add testing for exceptions: #GP, #UD, #DE, #DB, #BP, and #AC.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/vmx_tests.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3d57ed6..796fd7b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -21,6 +21,7 @@
 #include "smp.h"
 #include "delay.h"
 #include "access.h"
+#include "x86/usermode.h"
 
 #define VPID_CAP_INVVPID_TYPES_SHIFT 40
 
@@ -10701,6 +10702,134 @@ static void vmx_pf_vpid_test(void)
 	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
 }
 
+static void vmx_l2_gp_test(void)
+{
+	*(volatile u64 *)NONCANONICAL = 0;
+}
+
+static void vmx_l2_ud_test(void)
+{
+	asm volatile ("ud2");
+}
+
+static void vmx_l2_de_test(void)
+{
+	asm volatile (
+		"xor %%eax, %%eax\n\t"
+		"xor %%ebx, %%ebx\n\t"
+		"xor %%edx, %%edx\n\t"
+		"idiv %%ebx\n\t"
+		::: "eax", "ebx", "edx");
+}
+
+static void vmx_l2_bp_test(void)
+{
+	asm volatile ("int3");
+}
+
+static void vmx_l2_db_test(void)
+{
+	write_rflags(read_rflags() | X86_EFLAGS_TF);
+}
+
+static uint64_t usermode_callback(void)
+{
+	/*
+	 * Trigger an #AC by writing 8 bytes to a 4-byte aligned address.
+	 * Disclaimer: It is assumed that the stack pointer is aligned
+	 * on a 16-byte boundary as x86_64 stacks should be.
+	 */
+	asm volatile("movq $0, -0x4(%rsp)");
+
+	return 0;
+}
+
+static void vmx_l2_ac_test(void)
+{
+	bool hit_ac = false;
+
+	write_cr0(read_cr0() | X86_CR0_AM);
+	write_rflags(read_rflags() | X86_EFLAGS_AC);
+
+	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &hit_ac);
+	report(hit_ac, "Usermode #AC handled in L2");
+	vmcall();
+}
+
+struct vmx_exception_test {
+	u8 vector;
+	void (*guest_code)(void);
+};
+
+struct vmx_exception_test vmx_exception_tests[] = {
+	{ GP_VECTOR, vmx_l2_gp_test },
+	{ UD_VECTOR, vmx_l2_ud_test },
+	{ DE_VECTOR, vmx_l2_de_test },
+	{ DB_VECTOR, vmx_l2_db_test },
+	{ BP_VECTOR, vmx_l2_bp_test },
+	{ AC_VECTOR, vmx_l2_ac_test },
+};
+
+static u8 vmx_exception_test_vector;
+
+static void vmx_exception_handler(struct ex_regs *regs)
+{
+	report(regs->vector == vmx_exception_test_vector,
+	       "Handling %s in L2's exception handler",
+	       exception_mnemonic(vmx_exception_test_vector));
+	vmcall();
+}
+
+static void handle_exception_in_l2(u8 vector)
+{
+	handler old_handler = handle_exception(vector, vmx_exception_handler);
+
+	vmx_exception_test_vector = vector;
+
+	enter_guest();
+	report(vmcs_read(EXI_REASON) == VMX_VMCALL,
+	       "%s handled by L2", exception_mnemonic(vector));
+
+	handle_exception(vector, old_handler);
+}
+
+static void handle_exception_in_l1(u32 vector)
+{
+	u32 old_eb = vmcs_read(EXC_BITMAP);
+
+	vmcs_write(EXC_BITMAP, old_eb | (1u << vector));
+
+	enter_guest();
+
+	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
+	       ((vmcs_read(EXI_INTR_INFO) & 0xff) == vector),
+	       "%s handled by L1", exception_mnemonic(vector));
+
+	vmcs_write(EXC_BITMAP, old_eb);
+}
+
+static void vmx_exception_test(void)
+{
+	struct vmx_exception_test *t;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vmx_exception_tests); i++) {
+		t = &vmx_exception_tests[i];
+
+		/*
+		 * Override the guest code before each run even though it's the
+		 * same code, the VMCS guest state needs to be reinitialized.
+		 */
+		test_override_guest(t->guest_code);
+		handle_exception_in_l2(t->vector);
+
+		test_override_guest(t->guest_code);
+		handle_exception_in_l1(t->vector);
+	}
+
+	test_set_guest_finished();
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -10810,5 +10939,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_no_vpid_test),
 	TEST(vmx_pf_invvpid_test),
 	TEST(vmx_pf_vpid_test),
+	TEST(vmx_exception_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.35.0.rc0.227.g00780c9af4-goog

