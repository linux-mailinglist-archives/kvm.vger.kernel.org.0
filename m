Return-Path: <kvm+bounces-68669-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJ9TLd0icGlRVwAAu9opvQ
	(envelope-from <kvm+bounces-68669-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:50:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD294EB49
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3339662F7AC
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 00:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1AE2E093E;
	Wed, 21 Jan 2026 00:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yMeaxjNP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5512DCBEC
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 00:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956557; cv=none; b=D7Q/HeJWGizAghOjWOizFbWGAsAmfrXE8jfcNIXvyOSiXdDDpoNX0/SGnnwm5c8U2lOtSDGowdl/p0J5U8WNpHQbZNlIYnzWiEXGLU60mkgdnVA53uBz4FtVEOrn2EcrfwLpPMJSbOodoEeO9mWiWJOypN9RorDobxCCFwc0O+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956557; c=relaxed/simple;
	bh=BRZcgfr+vwJSytNzuLiWTzJvK7xnpQg5CcPjRZYb3hQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R3OWgk8pjI87+4kXJHskybcY12YMvDzFy1FDi535AUvM03hO75mULA8VRGI/oioqepL5HWMvx6eBQTYGjAsBJnSOXwDH5v5DmhDaq1EhKzcRHaRzpD4McT7+BGFfDzB0G36Qg5mJwb0yHD3pE/Ib9a7SztpjwTRnXPo+2onn8pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yMeaxjNP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c48a76e75so5335847a91.1
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 16:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768956555; x=1769561355; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iJ8F6Hu1eVVgcWN2Mt/1/ZMjoPZCdsge8X3jwhZPFZY=;
        b=yMeaxjNPsKrMvZBKBGCvdOTnNLb15BK/Y7/GU5tZJz9joEmX1Hhqu101+c33tndOGR
         xZ29DNnwTAY/wZjt/E1pvrU0fmK1A4L0OKAo6hTwIj12am//NzgtmF3erfHTCGfne9bg
         g0pW6rKZoP6f7bDeB3U2AuwhBznfO1k2FjXKK4C6g/bwgJtYw4z1N/NKL+wpL/PHHhqn
         6rCCgW69JYVanIQsNmnzpGwqkAle7MvsDQ5pviuPihoEodkZqLGFvoxBDUfRE6c3LGDs
         5axoev6PMBt1Wl3gtRW4JsD3WMHxFK89SvSawgvVY6lu45ouxK3OqLxnDH69riyLj2Rd
         QOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768956555; x=1769561355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJ8F6Hu1eVVgcWN2Mt/1/ZMjoPZCdsge8X3jwhZPFZY=;
        b=V5cl+4n4lsJemUm5a5OkWo1xWbqfxyN8sKLFglvJM2J2U0Wr3k2STrkW9v5g1XUnCD
         UMKe4ioE69LgAn8Or5zST7iWkpQPKEBBgrWukHZrXgCDYUDaB9oUOQxfAkJFWnFOYBcj
         3cMLteB8MCYBRZVZNGquUv7owocoleXuwOxwisS8mDnWixwb79paj2fPL/hs5veyA6mS
         m1jZ7yCuNn0D4ZgXbE0ljiDy8p8sIMidvYmt4ZD5PxDsdEi4Ugd/C+Z+gfGW1Am6v3py
         HrUgJUiyzwAX47W0kUg1krGB/8CoAXCrLyweKugGH1xj8CDfwKk1VIMdFiCh0n3bG6RF
         KE9Q==
X-Gm-Message-State: AOJu0YxTIxKnVWkLHTnA36hNgqDmJ2BvwsZO24i+qK5itBweKKZgjv/U
	rvE6w5MtKUWvFqxM8YKd+Ij0tVsqHjBqMH4m7qm2Atv48s1R2V16urRp5+7Ep+7btiZr6nQoSrD
	QyUFhBUOcP6sJ+Q==
X-Received: from pjbnd9.prod.google.com ([2002:a17:90b:4cc9:b0:352:e5f6:780a])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1c01:b0:340:c261:f9f3 with SMTP id 98e67ed59e1d1-35272f1a478mr13041032a91.14.1768956554712;
 Tue, 20 Jan 2026 16:49:14 -0800 (PST)
Date: Wed, 21 Jan 2026 00:49:06 +0000
In-Reply-To: <20260121004906.2373989-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121004906.2373989-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121004906.2373989-4-chengkev@google.com>
Subject: [PATCH 3/3] KVM: selftests: Add nested NPF injection test for SVM
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68669-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 9BD294EB49
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a test that exercises nested NPF injection when the original VM
exit was not an NPF. This tests the code path in
nested_svm_inject_npf_exit() where exit_code != SVM_EXIT_NPF.

L2 executes an OUTS instruction with the source address mapped in L2's
page tables but not in L1's NPT. KVM emulates the string I/O, and when
it tries to read the source operand, the GPA->HPA translation fails.
KVM then injects an NPF to L1 even though the original exit was IOIO.

The test verifies that:
  - The exit code is converted to SVM_EXIT_NPF
  - exit_info_1 has the appropriate PFERR_GUEST_* bit set
  - exit_info_2 contains the correct faulting GPA

Two test cases are implemented:
  - Test 1: Unmap the final data page from NPT (PFERR_GUEST_FINAL_MASK)
  - Test 2: Unmap a PT page from NPT (PFERR_GUEST_PAGE_MASK)

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/svm_nested_npf_test.c   | 154 ++++++++++++++++++
 2 files changed, 155 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_npf_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index e88699e227ddf..8babe6e228e11 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -112,6 +112,7 @@ TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
 TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
+TEST_GEN_PROGS_x86 += x86/svm_nested_npf_test
 TEST_GEN_PROGS_x86 += x86/tsc_scaling_sync
 TEST_GEN_PROGS_x86 += x86/sync_regs_test
 TEST_GEN_PROGS_x86 += x86/ucna_injection_test
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_npf_test.c b/tools/testing/selftests/kvm/x86/svm_nested_npf_test.c
new file mode 100644
index 0000000000000..c0a894acbc483
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/svm_nested_npf_test.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * svm_nested_npf_test
+ *
+ * Test nested NPF injection when the original VM exit was not an NPF.
+ * This exercises nested_svm_inject_npf_exit() with exit_code != SVM_EXIT_NPF.
+ *
+ * L2 executes OUTS with the source address mapped in L2's page tables but
+ * not in L1's NPT. KVM emulates the string I/O instruction, and when it
+ * tries to read the source operand, the GPA->HPA translation fails. KVM
+ * then injects an NPF to L1 even though the original exit was IOIO.
+ *
+ * Test 1: Final data page GPA not in NPT (PFERR_GUEST_FINAL_MASK)
+ * Test 2: Page table page GPA not in NPT (PFERR_GUEST_PAGE_MASK)
+ *
+ * Copyright (C) 2025, Google, Inc.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+
+#define L2_GUEST_STACK_SIZE 64
+
+enum test_type {
+	TEST_FINAL_PAGE_UNMAPPED, /* Final data page GPA not in NPT */
+	TEST_PT_PAGE_UNMAPPED, /* Page table page GPA not in NPT */
+};
+
+static void *l2_test_page;
+
+#define TEST_IO_PORT 0x80
+#define TEST1_VADDR 0x8000000ULL
+#define TEST2_VADDR 0x10000000ULL
+
+/*
+ * L2 executes OUTS with source at l2_test_page, triggering a nested NPF.
+ * The address is mapped in L2's page tables, but either the data page or
+ * a PT page is unmapped from L1's NPT, causing the fault.
+ */
+static void l2_guest_code(void *unused)
+{
+	asm volatile("outsb" ::"S"(l2_test_page), "d"(TEST_IO_PORT) : "memory");
+	GUEST_ASSERT(0);
+}
+
+static void l1_guest_code(struct svm_test_data *svm, void *expected_fault_gpa,
+						  uint64_t exit_info_1_mask)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	/* Verify we got an NPF exit (converted from IOIO by KVM) */
+	__GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_NPF,
+		       "Expected NPF exit (0x%x), got 0x%lx", SVM_EXIT_NPF,
+		       vmcb->control.exit_code);
+
+	/* Check for PFERR_GUEST_FINAL_MASK or PFERR_GUEST_PAGE_MASK */
+	__GUEST_ASSERT(vmcb->control.exit_info_1 & exit_info_1_mask,
+		       "Expected exit_info_1 to have 0x%lx set, got 0x%lx",
+		       (unsigned long)exit_info_1_mask,
+		       (unsigned long)vmcb->control.exit_info_1);
+
+	__GUEST_ASSERT(vmcb->control.exit_info_2 == (u64)expected_fault_gpa,
+		       "Expected exit_info_2 = 0x%lx, got 0x%lx",
+		       (unsigned long)expected_fault_gpa,
+		       (unsigned long)vmcb->control.exit_info_2);
+
+	GUEST_DONE();
+}
+
+/* Returns the GPA of the PT page that maps @vaddr. */
+static uint64_t get_pt_gpa_for_vaddr(struct kvm_vm *vm, uint64_t vaddr)
+{
+	uint64_t *pte;
+
+	pte = vm_get_pte(vm, vaddr);
+	TEST_ASSERT(pte && (*pte & 0x1), "PTE not present for vaddr 0x%lx",
+		    (unsigned long)vaddr);
+
+	return addr_hva2gpa(vm, (void *)((uint64_t)pte & ~0xFFFULL));
+}
+
+static void run_test(enum test_type type)
+{
+	vm_paddr_t expected_fault_gpa;
+	uint64_t exit_info_1_mask;
+	vm_vaddr_t svm_gva;
+
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	vm_enable_npt(vm);
+	vcpu_alloc_svm(vm, &svm_gva);
+
+	if (type == TEST_FINAL_PAGE_UNMAPPED) {
+		/*
+		 * Test 1: Unmap the final data page from NPT. The page table
+		 * walk succeeds, but the final GPA->HPA translation fails.
+		 */
+		l2_test_page =
+			(void *)vm_vaddr_alloc(vm, vm->page_size, TEST1_VADDR);
+		expected_fault_gpa = addr_gva2gpa(vm, (vm_vaddr_t)l2_test_page);
+		exit_info_1_mask = PFERR_GUEST_FINAL_MASK;
+	} else {
+		/*
+		 * Test 2: Unmap a PT page from NPT. The hardware page table
+		 * walk fails when translating the PT page's GPA through NPT.
+		 */
+		l2_test_page =
+			(void *)vm_vaddr_alloc(vm, vm->page_size, TEST2_VADDR);
+		expected_fault_gpa =
+			get_pt_gpa_for_vaddr(vm, (vm_vaddr_t)l2_test_page);
+		exit_info_1_mask = PFERR_GUEST_PAGE_MASK;
+	}
+
+	tdp_identity_map_default_memslots(vm);
+	tdp_unmap(vm, expected_fault_gpa, vm->page_size);
+
+	sync_global_to_guest(vm, l2_test_page);
+	vcpu_args_set(vcpu, 3, svm_gva, expected_fault_gpa, exit_info_1_mask);
+
+	vcpu_run(vcpu);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+	default:
+		TEST_FAIL("Unexpected exit reason: %d", vcpu->run->exit_reason);
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+	TEST_REQUIRE(kvm_cpu_has_npt());
+
+	run_test(TEST_FINAL_PAGE_UNMAPPED);
+	run_test(TEST_PT_PAGE_UNMAPPED);
+
+	return 0;
+}
-- 
2.52.0.457.g6b5491de43-goog


