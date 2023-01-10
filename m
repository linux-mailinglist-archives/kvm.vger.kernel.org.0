Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8656646F5
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbjAJRE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbjAJREM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:04:12 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F44643C
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:10 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id f8-20020a170902ce8800b00190c6518e21so8738059plg.1
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1jfzYB3eSzo0uQ/eLCbHbqOq8jz9MEk1g6fqiugzfaQ=;
        b=Yg4We21sqhESU2d+UO/H2SDeDwShjaf45qTgc3dap9vLYnyVTVXFvMZYvgIGzkIStX
         eK7V6Srh7D642eNTWPL8msuulIP7YSzvaXzlWvSjek7S67PLRpcboESVL6k19+S+iVMO
         EyuQpgsP5w2aoYWKtvtBewWQt3JswTSVk4SBdUBd8MQVnmMUjC9D8VPgfBbyvfx9DkgP
         rREKzwxTM21lBgm6EFqNQefE/TO9Ja3mwvmI/JBtYwK041UwOj/N9Gx3SqGVbao3jjbj
         hSEjJIiP9hHfIE9CLyspJcmZmV+FlIhb66SqnO5m6fG1v3xuGpl8OJ/4F9uQTk/oNdP/
         6msg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1jfzYB3eSzo0uQ/eLCbHbqOq8jz9MEk1g6fqiugzfaQ=;
        b=2bSnRQDotJJoJcdFUO818N/PXAL4iPhkO1ls779XOD9IKngv5hEmfxxdh7kEFWwfkP
         k5XkwApWRsyLTnWCSL7b4fu2NIkrMKbNDsXGffkz1mKMU40BGDIaNldf1SCFMNY+g82W
         NOU+lRWNcC2CMX5QWJNZWXcVm7on0X5rtBw2jjxp6cKgie+Bd/idCWE68Is569A8mYCj
         AUcOPpGU5d7I2ImBaWEOxgytYe0DepP3QR93HmSwhs68r9fGM5JhCVbkcEorZJqylVKh
         xaGKvLDjBfAuK2S5WLsNTWqBQD4xMH+OxiPyKSpaGHChmcSN4DrHVw9ZTxqfYyA4GdBF
         7WSA==
X-Gm-Message-State: AFqh2koHhLsmbIBcn2/mUGee83Bo0jzMi9ibpuzXTs6fAJ/AkiKVlIjM
        cdl3GNae0ZqARGNWYzZdV19j0PyjfR1mJIZcgk0rDHs0ZRgFkwPCZo+aKKXrtVc3m55kukxyIFJ
        ftXwYKh9lzqIA8EWyYwivaP7qPgJJZmKlDn/0tzlW3azNeJ9ygCoDWsO36w==
X-Google-Smtp-Source: AMrXdXuNzLX+lC3L0QA8KtIU/Hv4hDDifJhYuLmSdlJ8QAXOqHBogiJ0NYEZgVTb1CVSNTNLUdz5RsZYj6A=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a17:902:9883:b0:193:1c8f:182f with SMTP id
 s3-20020a170902988300b001931c8f182fmr691912plp.14.1673370249981; Tue, 10 Jan
 2023 09:04:09 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:03:56 -0800
In-Reply-To: <20230110170358.633793-1-pgonda@google.com>
Message-Id: <20230110170358.633793-6-pgonda@google.com>
Mime-Version: 1.0
References: <20230110170358.633793-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 5/7] KVM: selftests: add library for creating/interacting
 with SEV guests
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerly Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add interfaces to allow tests to create SEV guests. The additional
requirements for SEV guests PTs and other state is encapsulated by the
new vm_sev_create_with_one_vcpu() function. This can future be
generalized for more vCPUs but the first set of SEV selftests in this
series only uses a single vCPU.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Originally-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Ackerly Tng <ackerleytng@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>

---
 tools/arch/x86/include/asm/kvm_host.h         |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/include/kvm_util_base.h     |  15 +-
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/include/x86_64/sev.h        |  27 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   8 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  45 +++-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 254 ++++++++++++++++++
 8 files changed, 343 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c

diff --git a/tools/arch/x86/include/asm/kvm_host.h b/tools/arch/x86/include/asm/kvm_host.h
index d8f48fe835fb..c95041e92fb5 100644
--- a/tools/arch/x86/include/asm/kvm_host.h
+++ b/tools/arch/x86/include/asm/kvm_host.h
@@ -8,6 +8,7 @@
 struct kvm_vm_arch {
 	uint64_t c_bit;
 	uint64_t s_bit;
+	bool is_pt_protected;
 };
 
 #endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd936..b7cfb15712d1 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -39,6 +39,7 @@ LIBKVM_x86_64 += lib/x86_64/processor.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
 LIBKVM_x86_64 += lib/x86_64/vmx.c
+LIBKVM_x86_64 += lib/x86_64/sev.c
 
 LIBKVM_aarch64 += lib/aarch64/gic.c
 LIBKVM_aarch64 += lib/aarch64/gic_v3.c
@@ -199,7 +200,7 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
 	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
-	$(KHDR_INCLUDES)
+	$(KHDR_INCLUDES) -static -gdwarf-4
 
 no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
         $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 5f3150ecfbbf..b5283bcc1d02 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -89,6 +89,13 @@ enum kvm_mem_region_type {
 	NR_MEM_REGIONS,
 };
 
+/* VM protection policy/configuration. */
+struct protected_vm {
+	bool enabled;
+	bool has_protected_bit;
+	int8_t protected_bit;
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
@@ -711,6 +718,10 @@ static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return _vm_phy_pages_alloc(vm, num, paddr_min, memslot, vm->protected);
 }
 
+uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
+			      uint32_t nr_runnable_vcpus,
+			      uint64_t extra_mem_pages);
+
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
@@ -767,8 +778,8 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
 unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages);
 unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_pages);
-static inline unsigned int
-vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
+static inline unsigned int vm_adjust_num_guest_pages(enum vm_guest_mode mode,
+						     unsigned int num_guest_pages)
 {
 	unsigned int n;
 	n = vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2a5f47d51388..1c72fb5672a9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -916,6 +916,7 @@ static inline void vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index,
 
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
+void kvm_init_vm_address_properties(struct kvm_vm *vm);
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 struct ex_regs {
diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
new file mode 100644
index 000000000000..e212b032cd77
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Helpers used for SEV guests
+ *
+ */
+#ifndef SELFTEST_KVM_SEV_H
+#define SELFTEST_KVM_SEV_H
+
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "kvm_util.h"
+
+#define CPUID_MEM_ENC_LEAF 0x8000001f
+#define CPUID_EBX_CBIT_MASK 0x3f
+
+#define SEV_POLICY_NO_DBG	(1UL << 0)
+#define SEV_POLICY_ES		(1UL << 2)
+
+bool is_kvm_sev_supported(void);
+
+void sev_vm_init(struct kvm_vm *vm);
+
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+					   struct kvm_vcpu **cpu);
+
+#endif /* SELFTEST_KVM_SEV_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0d0a7ad7632d..99983a5c5558 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -151,6 +151,7 @@ const char *vm_guest_mode_string(uint32_t i)
 		[VM_MODE_P40V48_16K]	= "PA-bits:40,  VA-bits:48, 16K pages",
 		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
 		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
+		[VM_MODE_PXXV48_4K_SEV]	= "PA-bits:ANY, VA-bits:48,  4K pages",
 		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
 		[VM_MODE_P44V64_4K]	= "PA-bits:44,  VA-bits:64,  4K pages",
 		[VM_MODE_P36V48_4K]	= "PA-bits:36,  VA-bits:48,  4K pages",
@@ -176,6 +177,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	[VM_MODE_P40V48_16K]	= { 40, 48,  0x4000, 14 },
 	[VM_MODE_P40V48_64K]	= { 40, 48, 0x10000, 16 },
 	[VM_MODE_PXXV48_4K]	= {  0,  0,  0x1000, 12 },
+	[VM_MODE_PXXV48_4K_SEV]	= {  0,  0,  0x1000, 12 },
 	[VM_MODE_P47V64_4K]	= { 47, 64,  0x1000, 12 },
 	[VM_MODE_P44V64_4K]	= { 44, 64,  0x1000, 12 },
 	[VM_MODE_P36V48_4K]	= { 36, 48,  0x1000, 12 },
@@ -254,9 +256,11 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 	case VM_MODE_P36V47_16K:
 		vm->pgtable_levels = 3;
 		break;
+	case VM_MODE_PXXV48_4K_SEV:
 	case VM_MODE_PXXV48_4K:
 #ifdef __x86_64__
 		kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
+		kvm_init_vm_address_properties(vm);
 		/*
 		 * Ignore KVM support for 5-level paging (vm->va_bits == 57),
 		 * it doesn't take effect unless a CR4.LA57 is set, which it
@@ -270,7 +274,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 		vm->pgtable_levels = 4;
 		vm->va_bits = 48;
 #else
-		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
+		TEST_FAIL("VM_MODE_PXXV48_4K* not supported on non-x86 platforms");
 #endif
 		break;
 	case VM_MODE_P47V64_4K:
@@ -303,7 +307,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 	return vm;
 }
 
-static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
+uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 				     uint32_t nr_runnable_vcpus,
 				     uint64_t extra_mem_pages)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d03cefd9f6cd..557146ba85a8 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -8,6 +8,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "sev.h"
 
 #ifndef NUM_INTERRUPTS
 #define NUM_INTERRUPTS 256
@@ -119,10 +120,16 @@ bool kvm_is_tdp_enabled(void)
 		return get_kvm_amd_param_bool("npt");
 }
 
+static void assert_supported_guest_mode(struct kvm_vm *vm)
+{
+	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K || vm->mode == VM_MODE_PXXV48_4K_SEV,
+		    "Attempt to use unknown or unsupported guest mode, mode: 0x%x",
+		    vm->mode);
+}
+
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
-		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
+	assert_supported_guest_mode(vm);
 
 	/* If needed, create page map l4 table. */
 	if (!vm->pgd_created) {
@@ -186,8 +193,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	uint64_t *pml4e, *pdpe, *pde;
 	uint64_t *pte;
 
-	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
-		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
+	assert_supported_guest_mode(vm);
 
 	TEST_ASSERT((vaddr % pg_size) == 0,
 		    "Virtual address not aligned,\n"
@@ -273,11 +279,14 @@ uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 {
 	uint64_t *pml4e, *pdpe, *pde;
 
+	TEST_ASSERT(
+		!vm->arch.is_pt_protected,
+		"Protected guests have their page tables protected so gva2gpa conversions are not possible.");
+
 	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level < PG_LEVEL_NUM,
 		    "Invalid PG_LEVEL_* '%d'", *level);
 
-	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
-		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
+	assert_supported_guest_mode(vm);
 	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
 		(vaddr >> vm->page_shift)),
 		"Invalid virtual address, vaddr: 0x%lx",
@@ -543,6 +552,7 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	kvm_setup_gdt(vm, &sregs.gdt);
 
 	switch (vm->mode) {
+	case VM_MODE_PXXV48_4K_SEV:
 	case VM_MODE_PXXV48_4K:
 		sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
 		sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
@@ -566,6 +576,10 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 void kvm_arch_vm_post_create(struct kvm_vm *vm)
 {
 	vm_create_irqchip(vm);
+
+	if (vm->mode == VM_MODE_PXXV48_4K_SEV) {
+		sev_vm_init(vm);
+	}
 }
 
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
@@ -1050,6 +1064,25 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 	}
 }
 
+static void configure_sev_pte_masks(struct kvm_vm *vm)
+{
+	uint32_t eax, ebx, ecx, edx, enc_bit;
+
+	cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
+	enc_bit = ebx & CPUID_EBX_CBIT_MASK;
+
+	vm->arch.c_bit = 1ULL << enc_bit;
+	vm->protected = true;
+	vm->gpa_protected_mask = vm->arch.c_bit;
+}
+
+void kvm_init_vm_address_properties(struct kvm_vm *vm)
+{
+	if (vm->mode == VM_MODE_PXXV48_4K_SEV) {
+		configure_sev_pte_masks(vm);
+	}
+}
+
 static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 			  int dpl, unsigned short selector)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
new file mode 100644
index 000000000000..3e20f15dd098
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Helpers used for SEV guests
+ *
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "kvm_util.h"
+#include "svm_util.h"
+#include "linux/psp-sev.h"
+#include "processor.h"
+#include "sev.h"
+
+#define SEV_FW_REQ_VER_MAJOR 0
+#define SEV_FW_REQ_VER_MINOR 17
+
+enum sev_guest_state {
+	SEV_GSTATE_UNINIT = 0,
+	SEV_GSTATE_LUPDATE,
+	SEV_GSTATE_LSECRET,
+	SEV_GSTATE_RUNNING,
+};
+
+static void sev_ioctl(int cmd, void *data)
+{
+	int ret;
+	struct sev_issue_cmd arg;
+
+	arg.cmd = cmd;
+	arg.data = (unsigned long)data;
+	ret = ioctl(open_sev_dev_path_or_exit(), SEV_ISSUE_CMD, &arg);
+	TEST_ASSERT(ret == 0, "SEV ioctl %d failed, error: %d, fw_error: %d",
+		    cmd, ret, arg.error);
+}
+
+static void kvm_sev_ioctl(struct kvm_vm *vm, int cmd, void *data)
+{
+	struct kvm_sev_cmd arg = {0};
+	int ret;
+
+	arg.id = cmd;
+	arg.sev_fd = open_sev_dev_path_or_exit();
+	arg.data = (__u64)data;
+
+	ret = ioctl(vm->fd, KVM_MEMORY_ENCRYPT_OP, &arg);
+	TEST_ASSERT(
+		ret == 0,
+		"SEV KVM ioctl %d failed, rc: %i errno: %i (%s), fw_error: %d",
+		cmd, ret, errno, strerror(errno), arg.error);
+}
+
+static void sev_register_user_region(struct kvm_vm *vm, struct userspace_mem_region *region)
+{
+	struct kvm_enc_region range = {0};
+	int ret;
+
+	range.addr = (__u64)region->region.userspace_addr;
+	;
+	range.size = region->region.memory_size;
+
+	ret = ioctl(vm->fd, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
+	TEST_ASSERT(ret == 0, "failed to register user range, errno: %i\n",
+		    errno);
+}
+
+static void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa, uint64_t size)
+{
+	struct kvm_sev_launch_update_data ksev_update_data = {0};
+
+	pr_debug("%s: addr: 0x%lx, size: %lu\n", __func__, gpa, size);
+
+	ksev_update_data.uaddr = (__u64)addr_gpa2hva(vm, gpa);
+	ksev_update_data.len = size;
+
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &ksev_update_data);
+}
+
+
+/*
+ * Iterate over set ranges within sparsebit @s. In each iteration,
+ * @range_begin and @range_end will take the beginning and end of the set
+ * range, which are of type sparsebit_idx_t.
+ *
+ * For example, if the range [3, 7] (inclusive) is set, within the
+ * iteration,@range_begin will take the value 3 and @range_end will take
+ * the value 7.
+ *
+ * Ensure that there is at least one bit set before using this macro with
+ * sparsebit_any_set(), because sparsebit_first_set() will abort if none
+ * are set.
+ */
+#define sparsebit_for_each_set_range(s, range_begin, range_end)         \
+	for (range_begin = sparsebit_first_set(s),                      \
+	     range_end =                                        \
+	     sparsebit_next_clear(s, range_begin) - 1;          \
+	     range_begin && range_end;                                  \
+	     range_begin = sparsebit_next_set(s, range_end),            \
+	     range_end =                                        \
+	     sparsebit_next_clear(s, range_begin) - 1)
+
+/*
+ * sparsebit_next_clear() can return 0 if [x, 2**64-1] are all set, and the
+ * -1 would then cause an underflow back to 2**64 - 1. This is expected and
+ * correct.
+ *
+ * If the last range in the sparsebit is [x, y] and we try to iterate,
+ * sparsebit_next_set() will return 0, and sparsebit_next_clear() will try
+ * and find the first range, but that's correct because the condition
+ * expression would cause us to quit the loop.
+ */
+static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)
+{
+	const struct sparsebit *protected_phy_pages =
+		region->protected_phy_pages;
+	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
+	const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;
+
+	sparsebit_idx_t i;
+	sparsebit_idx_t j;
+
+	if (!sparsebit_any_set(protected_phy_pages))
+		return;
+
+	sev_register_user_region(vm, region);
+
+	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
+		const uint64_t size_to_load = (j - i + 1) * vm->page_size;
+		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
+		const uint64_t gpa = gpa_base + offset;
+
+		sev_launch_update_data(vm, gpa, size_to_load);
+	}
+}
+
+static void sev_encrypt(struct kvm_vm *vm)
+{
+	int ctr;
+	struct userspace_mem_region *region;
+
+	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node) {
+		encrypt_region(vm, region);
+	}
+
+	vm->arch.is_pt_protected = true;
+}
+
+bool is_kvm_sev_supported(void)
+{
+	struct sev_user_data_status sev_status;
+
+	sev_ioctl(SEV_PLATFORM_STATUS, &sev_status);
+
+	if (!(sev_status.api_major > SEV_FW_REQ_VER_MAJOR ||
+	      (sev_status.api_major == SEV_FW_REQ_VER_MAJOR &&
+	       sev_status.api_minor >= SEV_FW_REQ_VER_MINOR))) {
+		pr_info("SEV FW version too old. Have API %d.%d (build: %d), need %d.%d, skipping test.\n",
+			sev_status.api_major, sev_status.api_minor,
+			sev_status.build, SEV_FW_REQ_VER_MAJOR,
+			SEV_FW_REQ_VER_MINOR);
+		return false;
+	}
+
+	return true;
+}
+
+static void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
+{
+	struct kvm_sev_launch_start ksev_launch_start = {0};
+	struct kvm_sev_guest_status ksev_status;
+
+	ksev_launch_start.policy = policy;
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_START, &ksev_launch_start);
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.policy == policy, "Incorrect guest policy.");
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE,
+		    "Unexpected guest state: %d", ksev_status.state);
+
+	ucall_init(vm, 0);
+
+	sev_encrypt(vm);
+}
+
+static void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement)
+{
+	struct kvm_sev_launch_measure ksev_launch_measure;
+	struct kvm_sev_guest_status ksev_guest_status;
+
+	ksev_launch_measure.len = 256;
+	ksev_launch_measure.uaddr = (__u64)measurement;
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_MEASURE, &ksev_launch_measure);
+
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_guest_status);
+	TEST_ASSERT(ksev_guest_status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", ksev_guest_status.state);
+}
+
+static void sev_vm_launch_finish(struct kvm_vm *vm)
+{
+	struct kvm_sev_guest_status ksev_status;
+
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE ||
+		    ksev_status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", ksev_status.state);
+
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_FINISH, NULL);
+
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_RUNNING,
+		    "Unexpected guest state: %d", ksev_status.state);
+}
+
+static void sev_vm_measure(struct kvm_vm *vm)
+{
+	uint8_t measurement[512];
+	int i;
+
+	sev_vm_launch_measure(vm, measurement);
+
+	/* TODO: Validate the measurement is as expected. */
+	pr_debug("guest measurement: ");
+	for (i = 0; i < 32; ++i)
+		pr_debug("%02x", measurement[i]);
+	pr_debug("\n");
+}
+
+void sev_vm_init(struct kvm_vm *vm)
+{
+	kvm_sev_ioctl(vm, KVM_SEV_INIT, NULL);
+}
+
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+					   struct kvm_vcpu **cpu)
+{
+	enum vm_guest_mode mode = VM_MODE_PXXV48_4K_SEV;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *cpus[1];
+
+	vm = __vm_create_with_vcpus(mode, 1, 0, guest_code, cpus);
+	*cpu = cpus[0];
+
+	sev_vm_launch(vm, policy);
+
+	sev_vm_measure(vm);
+
+	sev_vm_launch_finish(vm);
+
+	pr_info("SEV guest created, policy: 0x%x\n", policy);
+
+	return vm;
+}
-- 
2.39.0.314.g84b9a713c41-goog

