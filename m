Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B663473A1D
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 02:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241728AbhLNBSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 20:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbhLNBSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 20:18:49 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1801C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:48 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b8-20020a17090a10c800b001a61dff6c9dso9574350pje.5
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GGx78l1C6UrDdfX2ISiFf3LXQn3wH8GXhVJbd0Xrhqs=;
        b=n1NesT7JZ6WaFJzqtnbXUxkjcyfqUtSYRR+l+x7ggc9oP6QGwxHdOguLAS6+fp7un6
         Nlv12OQVjSebEXC1ImkbpLHlP9qmU9UkwHonVkjw0MgYgC4MVNQEKdGChdcEsJKTImIw
         J1aGInFYShDRuJD72Sv0l/TX2P6JRcNjRgWaiBDxi5jiF2i8FnzllZoYU0Zg+RfA8Ym5
         1hl6oJYKsqCyRaYzAngGrV11G1S47v+pwZSoUgKNKjngnKI04mtlAB1FORffi/xEfejg
         9Gbmgayxx4FpFa60CR7xu0hkDNn7cOreWoatHbhm0lczhBsZGtJ7qOS0Vxu66aklxUAQ
         T8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GGx78l1C6UrDdfX2ISiFf3LXQn3wH8GXhVJbd0Xrhqs=;
        b=F4okmW18UlhYu/DhacPyNfuQCXsdMwcWzd2qILJrqHvvFCeQk+XScIAimz/uav1Jaa
         86cXxG8J0WKzAnq5uc0zjcbnI8DOol/1C3/mSUxEAITXPNSwGYE6qrwG07YttO5nWG6X
         VC+kqK9IVLi+NE7Ncd6fc2ndVo1Sgis5Sh/0elarwvYQjSVSFfaLBTKxP2fNxN/gEvNH
         1n7Xol0boceU3EDiXFq0CIC5pqZ9GPtgMJvgvTqOlXFFF4kgcZ9zDRtCFEOvIdFFiH1T
         kZZ53vUSEjL64O64GAnMLAwEWtnVjAgsQhVur7+Y0nbsAOVUmtJbmC6DRdmniDSa9HAg
         VtSg==
X-Gm-Message-State: AOAM53332ifNtBx45gOGSCeW+gMKjSeKXbaOzyAxQyoQkYXz/ov4Qd79
        Sl5/Gj0aNfawaxQZCVvTAMKt+lwqLgiFHHHpHSgIvj0YaBt4tpmZH5Y1SO+A1mGdTVHSVe9OF34
        se6ah2dImJfTX2SNtHYRJ/LE80LVjjDMFUqu0hppCGLW1cYvCjlup/JjXIddJiObqkYhv
X-Google-Smtp-Source: ABdhPJzQpoAqw+4FYkKVoidHLPyyX0TkAhypAFvK8G+8vLzCURfnVCxX+zO74HTPQuWQIFPPL/pC/SPcixGDg87s
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:1343:b0:4ad:99ae:d4b3 with
 SMTP id k3-20020a056a00134300b004ad99aed4b3mr1493568pfu.64.1639444728147;
 Mon, 13 Dec 2021 17:18:48 -0800 (PST)
Date:   Tue, 14 Dec 2021 01:18:22 +0000
In-Reply-To: <20211214011823.3277011-1-aaronlewis@google.com>
Message-Id: <20211214011823.3277011-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211214011823.3277011-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH v2 3/4] x86: Add a test framework for
 nested_vmx_reflect_vmexit() testing
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set up a test framework that verifies an exception occurring in L2 is
forwarded to the right place (L0?, L1?, L2?).  To add a test to this
framework just add the exception and callbacks to the
vmx_exception_tests array.

This framework tests two things:
 1) It tests that an exception is handled by L2.
 2) It tests that an exception is handled by L1.
To test that this happens, each exception is triggered twice; once with
just an L2 exception handler registered, and again with both an L2
exception handler registered and L1's exception bitmap set.  The
expectation is that the first exception will be handled by L2 and the
second by L1.

To implement this support was added to vmx.c to allow more than one
L2 test be run in a single test.  Previously there was a hard limit of
only being allowed to set the L2 guest code once in a given test.  That
is no longer a limitation with the addition of
test_set_guest_restartable().

Support was also added to allow the test to complete without running
through the entirety of the L2 guest code. Calling the function
test_set_guest_finished() marks the guest code as completed, allowing
it to end without running to the end.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 lib/x86/desc.c    |  2 +-
 lib/x86/desc.h    |  1 +
 x86/unittests.cfg |  7 ++++
 x86/vmx.c         | 17 +++++++++
 x86/vmx.h         |  2 ++
 x86/vmx_tests.c   | 88 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 16b7256..c2eb16e 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -91,7 +91,7 @@ struct ex_record {
 
 extern struct ex_record exception_table_start, exception_table_end;
 
-static const char* exception_mnemonic(int vector)
+const char* exception_mnemonic(int vector)
 {
 	switch(vector) {
 	case 0: return "#DE";
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 9b81da0..ad6277b 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -224,6 +224,7 @@ void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
 void unhandled_exception(struct ex_regs *regs, bool cpu);
+const char* exception_mnemonic(int vector);
 
 bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
 			void *data);
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 9fcdcae..0353b69 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -368,6 +368,13 @@ arch = x86_64
 groups = vmx nested_exception
 check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
 
+[vmx_exception_test]
+file = vmx.flat
+extra_params = -cpu max,+vmx -append vmx_exception_test
+arch = x86_64
+groups = vmx nested_exception
+timeout = 10
+
 [debug]
 file = debug.flat
 arch = x86_64
diff --git a/x86/vmx.c b/x86/vmx.c
index f4fbb94..9908746 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1895,6 +1895,23 @@ void test_set_guest(test_guest_func func)
 	v2_guest_main = func;
 }
 
+/*
+ * Set the target of the first enter_guest call and reset the RIP so 'func'
+ * will start from the beginning.  This can be called multiple times per test.
+ */
+void test_set_guest_restartable(test_guest_func func)
+{
+	assert(current->v2);
+	v2_guest_main = func;
+	init_vmcs_guest();
+	guest_finished = 0;
+}
+
+void test_set_guest_finished(void)
+{
+	guest_finished = 1;
+}
+
 static void check_for_guest_termination(union exit_reason exit_reason)
 {
 	if (is_hypercall(exit_reason)) {
diff --git a/x86/vmx.h b/x86/vmx.h
index 4423986..5321a7e 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -1055,7 +1055,9 @@ void hypercall(u32 hypercall_no);
 typedef void (*test_guest_func)(void);
 typedef void (*test_teardown_func)(void *data);
 void test_set_guest(test_guest_func func);
+void test_set_guest_restartable(test_guest_func func);
 void test_add_teardown(test_teardown_func func, void *data);
 void test_skip(const char *msg);
+void test_set_guest_finished(void);
 
 #endif
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3d57ed6..018db2f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10701,6 +10701,93 @@ static void vmx_pf_vpid_test(void)
 	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
 }
 
+struct vmx_exception_test {
+	u8 vector;
+	void (*guest_code)(void);
+	void (*init_test)(void);
+	void (*uninit_test)(void);
+};
+
+struct vmx_exception_test vmx_exception_tests[] = {
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
+	test_set_guest_finished();
+
+	handle_exception(vector, old_handler);
+}
+
+static void handle_exception_in_l1(u32 vector)
+{
+	handler old_handler = handle_exception(vector, vmx_exception_handler);
+	u32 old_eb = vmcs_read(EXC_BITMAP);
+
+	vmx_exception_test_vector = 0xff;
+
+	vmcs_write(EXC_BITMAP, old_eb | (1u << vector));
+
+	enter_guest();
+
+	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
+	       ((vmcs_read(EXI_INTR_INFO) & 0xff) == vector),
+	       "%s handled by L1", exception_mnemonic(vector));
+
+	test_set_guest_finished();
+
+	vmcs_write(EXC_BITMAP, old_eb);
+	handle_exception(vector, old_handler);
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
+		TEST_ASSERT(t->guest_code);
+		test_set_guest_restartable(t->guest_code);
+
+		if (t->init_test)
+			t->init_test();
+
+		handle_exception_in_l2(t->vector);
+
+		if (t->uninit_test)
+			t->uninit_test();
+
+		test_set_guest_restartable(t->guest_code);
+
+		if (t->init_test)
+			t->init_test();
+
+		handle_exception_in_l1(t->vector);
+
+		if (t->uninit_test)
+			t->uninit_test();
+	}
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -10810,5 +10897,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_no_vpid_test),
 	TEST(vmx_pf_invvpid_test),
 	TEST(vmx_pf_vpid_test),
+	TEST(vmx_exception_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.34.1.173.g76aa8bc2d0-goog

