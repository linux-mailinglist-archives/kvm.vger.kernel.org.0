Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD385576768
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 21:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiGOTaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 15:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiGOTaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 15:30:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5531E7A53A
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:19 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mi13-20020a17090b4b4d00b001ef9759d26aso2911543pjb.0
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l24GOrhB5xiwS9IYXc6IUpo/wNM5CtXC5pw4kqBO/F8=;
        b=NS8cvYntg+A8Lq5E/eFY/ZLlr/sy4y7KNe14ARQH/Sy81wod+1GFs9+ogPf1vBH7IK
         fN65cCoKsGv1I1APr8VCS0AX5ZDj4iWMD5z2QOZUbN/EgWP1KqEA5jZuzlWMhuKlU0P6
         g5J8U/ankGFcnIDMvWjyWS+R8d8vplO1rInihVmj2AV2WJNI5a/YL8S+VLym19LbjzYT
         sE8j8neuQGC3JaLhXevjdcg9yYNVHXR68MOmYTwk3jPTyB5hpHpWUpfUYX4Tg4sPzKuh
         aDWPLJy6cWQibtHRf2xmGFBPpwZdS0YG601gZAelDLg1pnCpYciHbZUBhmCNzUKwfLBY
         2tHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l24GOrhB5xiwS9IYXc6IUpo/wNM5CtXC5pw4kqBO/F8=;
        b=W9SYwkGh42zaF/XSaNWIaoeV3KtcvfaoEfdvKUiUik5YkNDFGk55CCPdud77pKwhbH
         5quYs3rfkBenrt+M4DtXY/KhuXMucqGsgXvG+4ohLCbe34cdrXhlVXCHjbL7l5D3Zu10
         sQsmg/lCb7VFcw7bYeoSwXuG8E29HPhPAkbZ467oWTma2Mq6q3C2QyzbPLXG4RhA5zx+
         Reu78SMDActe381AYqhq9X6/Q/Csyd2QZx1TLah/W441H/lKJPEX4EblhL4w/xX53Nnp
         wcLr33xe93EHxAoMhIGOEb3kML2JCkgWpDkq7v1P/GXJbRSNXE5bDTwJk02TwWAzU93z
         5Zcw==
X-Gm-Message-State: AJIora+fvAZr+cIvYsZ2Z0Hwy9JzM8KyHge1B5QoQmhdUJsacU+to8T1
        VdwoTtOVKwiXx7rGhJjwhdC4AA0TWIWRmd1j7j2ThPblfjmTUREbgbBQIqWEwWBDLkLhkHG3/vV
        uOeX2wh0oMqMq3RNoHNz7nvR7r267U6Zo2seueLgXNQGjlAyF7c8qqeGOOw==
X-Google-Smtp-Source: AGRyM1sfR7RDRlDwpq6mM94EZ6MFAeaZr1g/2HfOKbrYbvfFpYcW8rihI3+WY57o+JVN7EeXPZmM7HpeUC0=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:bd4e:b81d:4780:497d])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:1ad0:b0:52b:4175:953d with SMTP id
 f16-20020a056a001ad000b0052b4175953dmr3572157pfv.50.1657913418792; Fri, 15
 Jul 2022 12:30:18 -0700 (PDT)
Date:   Fri, 15 Jul 2022 12:29:52 -0700
In-Reply-To: <20220715192956.1873315-1-pgonda@google.com>
Message-Id: <20220715192956.1873315-8-pgonda@google.com>
Mime-Version: 1.0
References: <20220715192956.1873315-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [RFC V1 06/10] KVM: selftests: Consolidate boilerplate code in get_ucall()
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Consolidate the actual copying of a ucall struct from guest=>host into
the common get_ucall().  Return a host virtual address instead of a guest
virtual address even though the addr_gva2hva() part could be moved to
get_ucall() too.  Conceptually, get_ucall() is invoked from the host and
should return a host virtual address (and returning NULL for "nothing to
see here" is far superior to returning 0).

Use pointer shenanigans instead of an unnecessary bounce buffer when the
caller of get_ucall() provides a valid pointer.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>

---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/ucall_common.h      | 17 +++++++-
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 36 ++++-------------
 .../selftests/kvm/lib/perf_test_util.c        |  2 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c | 40 ++++---------------
 tools/testing/selftests/kvm/lib/s390x/ucall.c | 37 ++++-------------
 .../testing/selftests/kvm/lib/ucall_common.c  | 39 ++++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  | 37 ++++-------------
 8 files changed, 84 insertions(+), 125 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4d6753aadfa0..61e85892dd9b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -46,6 +46,7 @@ LIBKVM += lib/perf_test_util.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
+LIBKVM += lib/ucall_common.c
 
 LIBKVM_x86_64 += lib/x86_64/apic.c
 LIBKVM_x86_64 += lib/x86_64/handlers.S
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 98562f685151..cb9b37282701 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -23,11 +23,24 @@ struct ucall {
 	uint64_t args[UCALL_MAX_ARGS];
 };
 
-void ucall_init(struct kvm_vm *vm, void *arg);
-void ucall_uninit(struct kvm_vm *vm);
+void ucall_arch_init(struct kvm_vm *vm, void *arg);
+void ucall_arch_uninit(struct kvm_vm *vm);
+void ucall_arch_do_ucall(vm_vaddr_t uc);
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
+
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 
+static inline void ucall_init(struct kvm_vm *vm, void *arg)
+{
+	ucall_arch_init(vm, arg);
+}
+
+static inline void ucall_uninit(struct kvm_vm *vm)
+{
+	ucall_arch_uninit(vm);
+}
+
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index 0b949ee06b5e..9c124adbb560 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -21,7 +21,7 @@ static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
 	return true;
 }
 
-void ucall_init(struct kvm_vm *vm, void *arg)
+void ucall_arch_init(struct kvm_vm *vm, void *arg)
 {
 	vm_paddr_t gpa, start, end, step, offset;
 	unsigned int bits;
@@ -64,37 +64,20 @@ void ucall_init(struct kvm_vm *vm, void *arg)
 	TEST_FAIL("Can't find a ucall mmio address");
 }
 
-void ucall_uninit(struct kvm_vm *vm)
+void ucall_arch_uninit(struct kvm_vm *vm)
 {
 	ucall_exit_mmio_addr = 0;
 	sync_global_to_guest(vm, ucall_exit_mmio_addr);
 }
 
-void ucall(uint64_t cmd, int nargs, ...)
+void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
-	va_list va;
-	int i;
-
-	nargs = min(nargs, UCALL_MAX_ARGS);
-
-	va_start(va, nargs);
-	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
-	va_end(va);
-
-	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
+	*ucall_exit_mmio_addr = uc;
 }
 
-uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	struct ucall ucall = {};
-
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
 
 	if (run->exit_reason == KVM_EXIT_MMIO &&
 	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
@@ -103,12 +86,7 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
 			    "Unexpected ucall exit mmio address access");
 		memcpy(&gva, run->mmio.data, sizeof(gva));
-		memcpy(&ucall, addr_gva2hva(vcpu->vm, gva), sizeof(ucall));
-
-		vcpu_run_complete_io(vcpu);
-		if (uc)
-			memcpy(uc, &ucall, sizeof(ucall));
+		return addr_gva2hva(vcpu->vm, gva);
 	}
-
-	return ucall.cmd;
+	return NULL;
 }
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..14f88f3ffa80 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -209,7 +209,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 		perf_test_setup_nested(vm, nr_vcpus, vcpus);
 	}
 
-	ucall_init(vm, NULL);
+	ucall_arch_init(vm, NULL);
 
 	/* Export the shared variables to the guest. */
 	sync_global_to_guest(vm, perf_test_args);
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index 087b9740bc8f..37e091d4366e 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -10,11 +10,11 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-void ucall_init(struct kvm_vm *vm, void *arg)
+void ucall_arch_init(struct kvm_vm *vm, void *arg)
 {
 }
 
-void ucall_uninit(struct kvm_vm *vm)
+void ucall_arch_uninit(struct kvm_vm *vm)
 {
 }
 
@@ -44,47 +44,22 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 	return ret;
 }
 
-void ucall(uint64_t cmd, int nargs, ...)
+void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
-	va_list va;
-	int i;
-
-	nargs = min(nargs, UCALL_MAX_ARGS);
-
-	va_start(va, nargs);
-	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
-	va_end(va);
-
 	sbi_ecall(KVM_RISCV_SELFTESTS_SBI_EXT,
 		  KVM_RISCV_SELFTESTS_SBI_UCALL,
-		  (vm_vaddr_t)&uc, 0, 0, 0, 0, 0);
+		  uc, 0, 0, 0, 0, 0);
 }
 
-uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	struct ucall ucall = {};
-
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
 
 	if (run->exit_reason == KVM_EXIT_RISCV_SBI &&
 	    run->riscv_sbi.extension_id == KVM_RISCV_SELFTESTS_SBI_EXT) {
 		switch (run->riscv_sbi.function_id) {
 		case KVM_RISCV_SELFTESTS_SBI_UCALL:
-			memcpy(&ucall,
-			       addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]),
-			       sizeof(ucall));
-
-			vcpu_run_complete_io(vcpu);
-			if (uc)
-				memcpy(uc, &ucall, sizeof(ucall));
-
-			break;
+			return addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]);
 		case KVM_RISCV_SELFTESTS_SBI_UNEXP:
 			vcpu_dump(stderr, vcpu, 2);
 			TEST_ASSERT(0, "Unexpected trap taken by guest");
@@ -93,6 +68,5 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 			break;
 		}
 	}
-
-	return ucall.cmd;
+	return NULL;
 }
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index 73dc4e21190f..0f695a031d35 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -6,40 +6,23 @@
  */
 #include "kvm_util.h"
 
-void ucall_init(struct kvm_vm *vm, void *arg)
+void ucall_arch_init(struct kvm_vm *vm, void *arg)
 {
 }
 
-void ucall_uninit(struct kvm_vm *vm)
+void ucall_arch_uninit(struct kvm_vm *vm)
 {
 }
 
-void ucall(uint64_t cmd, int nargs, ...)
+void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
-	va_list va;
-	int i;
-
-	nargs = min(nargs, UCALL_MAX_ARGS);
-
-	va_start(va, nargs);
-	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
-	va_end(va);
-
 	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
-	asm volatile ("diag 0,%0,0x501" : : "a"(&uc) : "memory");
+	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
 }
 
-uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	struct ucall ucall = {};
-
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
 
 	if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
 	    run->s390_sieic.icptcode == 4 &&
@@ -47,13 +30,7 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 	    (run->s390_sieic.ipb >> 16) == 0x501) {
 		int reg = run->s390_sieic.ipa & 0xf;
 
-		memcpy(&ucall, addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]),
-		       sizeof(ucall));
-
-		vcpu_run_complete_io(vcpu);
-		if (uc)
-			memcpy(uc, &ucall, sizeof(ucall));
+		return addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]);
 	}
-
-	return ucall.cmd;
+	return NULL;
 }
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
new file mode 100644
index 000000000000..c488ed23d0dd
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "kvm_util.h"
+
+void ucall(uint64_t cmd, int nargs, ...)
+{
+	struct ucall uc = {
+		.cmd = cmd,
+	};
+	va_list va;
+	int i;
+
+	nargs = min(nargs, UCALL_MAX_ARGS);
+
+	va_start(va, nargs);
+	for (i = 0; i < nargs; ++i)
+		uc.args[i] = va_arg(va, uint64_t);
+	va_end(va);
+
+	ucall_arch_do_ucall((vm_vaddr_t)&uc);
+}
+
+uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	struct ucall ucall;
+	void *addr;
+
+	if (!uc)
+		uc = &ucall;
+
+	addr = ucall_arch_get_ucall(vcpu);
+	if (addr) {
+		memcpy(uc, addr, sizeof(*uc));
+		vcpu_run_complete_io(vcpu);
+	} else {
+		memset(uc, 0, sizeof(*uc));
+	}
+
+	return uc->cmd;
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index e5f0f9e0d3ee..ec53a406f689 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -8,52 +8,29 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
-void ucall_init(struct kvm_vm *vm, void *arg)
+void ucall_arch_init(struct kvm_vm *vm, void *arg)
 {
 }
 
-void ucall_uninit(struct kvm_vm *vm)
+void ucall_arch_uninit(struct kvm_vm *vm)
 {
 }
 
-void ucall(uint64_t cmd, int nargs, ...)
+void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
-	va_list va;
-	int i;
-
-	nargs = min(nargs, UCALL_MAX_ARGS);
-
-	va_start(va, nargs);
-	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
-	va_end(va);
-
 	asm volatile("in %[port], %%al"
-		: : [port] "d" (UCALL_PIO_PORT), "D" (&uc) : "rax", "memory");
+		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory");
 }
 
-uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	struct ucall ucall = {};
-
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
 
 	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
 		struct kvm_regs regs;
 
 		vcpu_regs_get(vcpu, &regs);
-		memcpy(&ucall, addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi),
-		       sizeof(ucall));
-
-		vcpu_run_complete_io(vcpu);
-		if (uc)
-			memcpy(uc, &ucall, sizeof(ucall));
+		return addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi);
 	}
-
-	return ucall.cmd;
+	return NULL;
 }
-- 
2.37.0.170.g444d1eabd0-goog

