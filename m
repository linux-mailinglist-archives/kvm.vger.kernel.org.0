Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103AA49627A
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381732AbiAUP7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381727AbiAUP7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 10:59:15 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42975C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:59:15 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id c23-20020aa78817000000b004be3f452a95so6278739pfo.19
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=e8l4oFvPoWvA9phQl8TvfOeE3zJv9n0shNsZrndBYsA=;
        b=LJCJlJKb56is3GDUbtigzRIfvQ+dVbLfoHTLS2MW6dlvp8olv5zAOzjhVTaIe+zQa0
         kPJZyyjj+Qa0GOW121sn4SuCBt2zOgsciPGNlrim3OYfM4ZcFrdEsbp9jUmbaMOcUBxD
         dSMs6Rav3f9YJFrPU5zfM4c2l09UW5WW0NZwqIe7iKZDhpx5wMqWeRRMNVbSRzxtqgut
         7/bgVisX5OKxwSsWaeKtCz3M2+5bhXuhaxYCc1LZGZVuH2QQVy6sEzSMteTkOJZ+Ee64
         nrWP07SxUbu68oJzJi9TKE6Qe1Xa8vBiqUE2h7HVYUIEgwUuYvS1gfzBODQub6IUQRMX
         CDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=e8l4oFvPoWvA9phQl8TvfOeE3zJv9n0shNsZrndBYsA=;
        b=HQuPZWtPSKtyGkF5riojTzxCQajFoiFrp1KjuP6aYsXzf5WH8x5ZmMaGfqhsB3ksrJ
         GtzAMZWmVBAPgTXmA3Me3ByQLa8uBe7veoxrX1gx7SVVwaXuNjGberAgMf2uOajFWutV
         3JeO0lFz4/8mH57v8bfA3fioiA3q/QpwSmAi/TRbWdhMUoEbNPEuW98ak4pJHDjxk0TF
         2Z/uVRUlC/Z9LvAw4DpJJzk7nyqWGJuE9n11RlT67sEvCJ32OKbcqql8WOKUR3oFdv9X
         9OOwCfXbxhVZUQ2pspBMP7gd30XBhUHq/oLGOMNr+A27rWBCG47Io8L8czen6LrXk605
         jiSw==
X-Gm-Message-State: AOAM531Jjxbq5qgDiCYjsGqjJqGnYuf7vlfYwJb9dzYYY3dAWOuvIHms
        pt5ixdxcbtu8yq+CJ35DJQ8W+XeUxQHojswfzG5qzP90h/zSTjekx3Ruw8jt9QHVI2/K0YtWkAb
        nj+soQEeiVpQ79wFjN3IzjrFCz2qXLSlh8gB2b67l+C0PZnihEcX6U+QIcwdoGhPU706N
X-Google-Smtp-Source: ABdhPJypzIl9hZzMWqwYX1AxlQ7tICUNI9g7H5ALQgrUPN5A1qqZWcN47nki7GRDVJoLb9XBupjKISnHq1Iqp+WJ
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:10d5:b0:4bc:a0eb:c6a0 with
 SMTP id d21-20020a056a0010d500b004bca0ebc6a0mr4426282pfu.70.1642780754613;
 Fri, 21 Jan 2022 07:59:14 -0800 (PST)
Date:   Fri, 21 Jan 2022 15:58:55 +0000
In-Reply-To: <20220121155855.213852-1-aaronlewis@google.com>
Message-Id: <20220121155855.213852-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220121155855.213852-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH v4 3/3] x86: Add test coverage for
 nested_vmx_reflect_vmexit() testing
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a framework and test cases to ensure exceptions that occur in L2 are
forwarded to the correct place by nested_vmx_reflect_vmexit().

Add testing for exceptions: #GP, #UD, #DE, #DB, #BP, and #AC.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: I0196071571671f06165983b5055ed7382fa3e1fb
---
 x86/unittests.cfg |   9 +++-
 x86/vmx_tests.c   | 129 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 9a70ba3..6ec7a98 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -288,7 +288,7 @@ arch =3D i386
=20
 [vmx]
 file =3D vmx.flat
-extra_params =3D -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_ac=
cess* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vm=
x_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_=
test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vm=
x_pf_invvpid_test -vmx_pf_vpid_test"
+extra_params =3D -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_ac=
cess* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vm=
x_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_=
test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vm=
x_pf_invvpid_test -vmx_pf_vpid_test -vmx_exception_test"
 arch =3D x86_64
 groups =3D vmx
=20
@@ -390,6 +390,13 @@ arch =3D x86_64
 groups =3D vmx nested_exception
 check =3D /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=3DY
=20
+[vmx_exception_test]
+file =3D vmx.flat
+extra_params =3D -cpu max,+vmx -append vmx_exception_test
+arch =3D x86_64
+groups =3D vmx nested_exception
+timeout =3D 10
+
 [debug]
 file =3D debug.flat
 arch =3D x86_64
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3d57ed6..af6f33b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -21,6 +21,7 @@
 #include "smp.h"
 #include "delay.h"
 #include "access.h"
+#include "x86/usermode.h"
=20
 #define VPID_CAP_INVVPID_TYPES_SHIFT 40
=20
@@ -10701,6 +10702,133 @@ static void vmx_pf_vpid_test(void)
 	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
 }
=20
+static void vmx_l2_gp_test(void)
+{
+	*(volatile u64 *)NONCANONICAL =3D 0;
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
+	/* Trigger an #AC by writing 8 bytes to a 4-byte aligned address. */
+	asm volatile(
+		"sub $0x10, %rsp\n\t"
+		"movq $0, 0x4(%rsp)\n\t"
+		"add $0x10, %rsp\n\t");
+
+	return 0;
+}
+
+static void vmx_l2_ac_test(void)
+{
+	bool raised_vector =3D false;
+
+	write_cr0(read_cr0() | X86_CR0_AM);
+	write_rflags(read_rflags() | X86_EFLAGS_AC);
+
+	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &raised_vector);
+	report(raised_vector, "#AC vector raised from usermode in L2");
+	vmcall();
+}
+
+struct vmx_exception_test {
+	u8 vector;
+	void (*guest_code)(void);
+};
+
+struct vmx_exception_test vmx_exception_tests[] =3D {
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
+	report(regs->vector =3D=3D vmx_exception_test_vector,
+	       "Handling %s in L2's exception handler",
+	       exception_mnemonic(vmx_exception_test_vector));
+	vmcall();
+}
+
+static void handle_exception_in_l2(u8 vector)
+{
+	handler old_handler =3D handle_exception(vector, vmx_exception_handler);
+
+	vmx_exception_test_vector =3D vector;
+
+	enter_guest();
+	report(vmcs_read(EXI_REASON) =3D=3D VMX_VMCALL,
+	       "%s handled by L2", exception_mnemonic(vector));
+
+	handle_exception(vector, old_handler);
+}
+
+static void handle_exception_in_l1(u32 vector)
+{
+	u32 old_eb =3D vmcs_read(EXC_BITMAP);
+
+	vmcs_write(EXC_BITMAP, old_eb | (1u << vector));
+
+	enter_guest();
+
+	report((vmcs_read(EXI_REASON) =3D=3D VMX_EXC_NMI) &&
+	       ((vmcs_read(EXI_INTR_INFO) & 0xff) =3D=3D vector),
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
+	for (i =3D 0; i < ARRAY_SIZE(vmx_exception_tests); i++) {
+		t =3D &vmx_exception_tests[i];
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
 #define TEST(name) { #name, .v2 =3D name }
=20
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -10810,5 +10938,6 @@ struct vmx_test vmx_tests[] =3D {
 	TEST(vmx_pf_no_vpid_test),
 	TEST(vmx_pf_invvpid_test),
 	TEST(vmx_pf_vpid_test),
+	TEST(vmx_exception_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
--=20
2.35.0.rc0.227.g00780c9af4-goog

