Return-Path: <kvm+bounces-4737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DE5F81771A
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:13:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88691B23C0C
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884963D57F;
	Mon, 18 Dec 2023 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yWieuDJc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DE94FF69
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pgonda.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5ca2b4038f7so1055686a12.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702915954; x=1703520754; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WMKQ/MpYzLcktvJgAHrTIOV9eibXb9CzQKMta+SXpg8=;
        b=yWieuDJc0jn8BkjMKxNgKiMx9ElalTufBUjnVwae9X3KcAREB4c79wjomijwJYLBxZ
         PFeD3rSH9InO3UHXB1PK7rdwux7OucXxTnIrUDPb2IDbeLA11tZ1L6Uk1Cty0I5a9Mud
         IbrOlsqrwmxZa5hPR7uHa1B5jEZ20h2j5HXHeZNu5lgUK1O4TBiaFoX5l+X4Cz81kfGS
         eXKzg6KUFnL56nt8SKgKqs2btUiA8Z1svrKUGO4woAgPjtLX/C60jAuovOErl/pe5iRo
         qkkAjPckGBCD2NR4ZsHkSmNc3PaUtP1XCuXk4xRqPm3C063ddBH2Db7ln/v051cNLjMj
         yS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702915954; x=1703520754;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WMKQ/MpYzLcktvJgAHrTIOV9eibXb9CzQKMta+SXpg8=;
        b=tzXZizdgJMJCkHgs4HEf83cShvbaYy5kJyE6xBZXCqpkmbhGv+gzScZjpT+nTivTUJ
         HVtnBF2s1pr3XAPc25ODPBBcH2OJxSGGMcnZKF8LUNJs9uYXwN+knSJnLgt6ZxKbPIt0
         ChlngqfdYI4bffjGrwXhAiUlm9IHWnqkQefWYhdUtvTBEemFC8YFtS07GvMv+idbYlnF
         76ygKN1DoQfGBYN3uW+zyqm5DtKc4jakRa4ZZ0xfUzKf2COm370EQxL57Sku50ElW9c/
         e0WMVvylOBNpaUAc/i/ahgQ19Tp2O/6pjleJlLtlIdaB+u7JcsOE9w4/+/t/gVeTaKFJ
         qX2A==
X-Gm-Message-State: AOJu0YwqKdWxj8/4uwDdtuXd/7eFVTMyflE6KfM/i3ex5XxVbTCWKM/i
	1m8wn+7h9iiKFf6GWEnAYFurAv659VV5l34sQXnEzUIfnGM0UXpXamRGzzWCm0cM9Ff44UcgU/Y
	b8zKytkwk6pJ/qXwrWt+FScOAaVsJHqYvqiNFJlzGTMFkoiI6N+CAOaV5Ag==
X-Google-Smtp-Source: AGHT+IGVfChgq/lq5n3pDM7qXYK4lV2+2/tppXq3iWgROFoV3Y08xCxcJrGW2Xi5imujTJH/0zHUWlwQTdc=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:8aeb:e3fa:237c:63a5])
 (user=pgonda job=sendgmr) by 2002:a63:da41:0:b0:5ca:32cd:b524 with SMTP id
 l1-20020a63da41000000b005ca32cdb524mr902852pgj.3.1702915954072; Mon, 18 Dec
 2023 08:12:34 -0800 (PST)
Date: Mon, 18 Dec 2023 08:11:42 -0800
In-Reply-To: <20231218161146.3554657-1-pgonda@google.com>
Message-Id: <20231218161146.3554657-5-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH V7 4/8] KVM: selftests: Allow tagging protected memory in
 guest page tables
From: Peter Gonda <pgonda@google.com>
To: kvm@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerly Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"

SEV guests rely on an encyption bit (C-bit) which resides within the
physical address range, i.e. is stolen from the guest's GPA space.  Guest
code in selftests will expect the C-Bit to be set appropriately in the
guest's page tables, whereas the rest of the kvm_util functions will
generally expect these bits to not be present.  Introduce pte_me_mask and
struct kvm_vm_arch to allow for arch specific address tagging.

Currently just adding x86 c_bit and s_bit support for
SEV and TDX.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/arch/arm64/include/asm/kvm_host.h       |  7 +++++
 tools/arch/riscv/include/asm/kvm_host.h       |  7 +++++
 tools/arch/s390/include/asm/kvm_host.h        |  7 +++++
 tools/arch/x86/include/asm/kvm_host.h         | 13 +++++++++
 .../selftests/kvm/include/kvm_util_base.h     | 13 +++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 27 ++++++++++++++++---
 .../selftests/kvm/lib/x86_64/processor.c      | 15 ++++++++++-
 7 files changed, 85 insertions(+), 4 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/kvm_host.h
 create mode 100644 tools/arch/riscv/include/asm/kvm_host.h
 create mode 100644 tools/arch/s390/include/asm/kvm_host.h
 create mode 100644 tools/arch/x86/include/asm/kvm_host.h

diff --git a/tools/arch/arm64/include/asm/kvm_host.h b/tools/arch/arm64/include/asm/kvm_host.h
new file mode 100644
index 000000000000..218f5cdf0d86
--- /dev/null
+++ b/tools/arch/arm64/include/asm/kvm_host.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
diff --git a/tools/arch/riscv/include/asm/kvm_host.h b/tools/arch/riscv/include/asm/kvm_host.h
new file mode 100644
index 000000000000..c8280d5659ce
--- /dev/null
+++ b/tools/arch/riscv/include/asm/kvm_host.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
diff --git a/tools/arch/s390/include/asm/kvm_host.h b/tools/arch/s390/include/asm/kvm_host.h
new file mode 100644
index 000000000000..4c4c1c1e4bf8
--- /dev/null
+++ b/tools/arch/s390/include/asm/kvm_host.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_S390_KVM_HOST_H
diff --git a/tools/arch/x86/include/asm/kvm_host.h b/tools/arch/x86/include/asm/kvm_host.h
new file mode 100644
index 000000000000..d8f48fe835fb
--- /dev/null
+++ b/tools/arch/x86/include/asm/kvm_host.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+
+#include <stdbool.h>
+#include <stdint.h>
+
+struct kvm_vm_arch {
+	uint64_t c_bit;
+	uint64_t s_bit;
+};
+
+#endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 71c0ed6a1197..8267476c76df 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -18,6 +18,8 @@
 #include <linux/types.h>
 
 #include <asm/atomic.h>
+#include <asm/kvm.h>
+#include <asm/kvm_host.h>
 
 #include <sys/ioctl.h>
 
@@ -155,6 +157,9 @@ struct kvm_vm {
 	vm_vaddr_t idt;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
+	uint64_t gpa_tag_mask;
+
+	struct kvm_vm_arch arch;
 
 	/* VM protection enabled: SEV, etc*/
 	bool protected;
@@ -489,6 +494,12 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
+
+static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	return gpa & ~vm->gpa_tag_mask;
+}
+
 void vcpu_run(struct kvm_vcpu *vcpu);
 int _vcpu_run(struct kvm_vcpu *vcpu);
 
@@ -967,4 +978,6 @@ void kvm_selftest_arch_init(void);
 
 void kvm_arch_vm_post_create(struct kvm_vm *vm);
 
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6b94b84ce2e0..3ab0fb0b6136 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -165,10 +165,11 @@ const char *vm_guest_mode_string(uint32_t i)
 	};
 	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
 		       "Missing new mode strings?");
+	const uint32_t mode = i & VM_MODE_PRIMARY_MASK;
 
-	TEST_ASSERT(i < NUM_VM_MODES, "Guest mode ID %d too big", i);
+	TEST_ASSERT(mode < NUM_VM_MODES, "Guest mode ID %d too big", mode);
 
-	return strings[i];
+	return strings[mode];
 }
 
 const struct vm_guest_mode_params vm_guest_mode_params[] = {
@@ -315,7 +316,7 @@ static uint64_t vm_nr_pages_required(uint32_t mode,
 				     uint32_t nr_runnable_vcpus,
 				     uint64_t extra_mem_pages)
 {
-	uint64_t page_size = vm_guest_mode_params[mode].page_size;
+	uint64_t page_size = vm_guest_mode_params[mode & VM_MODE_PRIMARY_MASK].page_size;
 	uint64_t nr_pages;
 
 	TEST_ASSERT(nr_runnable_vcpus,
@@ -1485,6 +1486,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
 {
 	struct userspace_mem_region *region;
 
+	gpa = vm_untag_gpa(vm, gpa);
+
 	region = userspace_mem_region_find(vm, gpa, gpa);
 	if (!region) {
 		TEST_FAIL("No vm physical memory at 0x%lx", gpa);
@@ -2190,3 +2193,21 @@ void __attribute((constructor)) kvm_selftest_init(void)
 
 	kvm_selftest_arch_init();
 }
+
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
+{
+	sparsebit_idx_t pg = 0;
+	struct userspace_mem_region *region;
+
+	if (!vm->protected)
+		return false;
+
+	region = userspace_mem_region_find(vm, paddr, paddr);
+	if (!region) {
+		TEST_FAIL("No vm physical memory at 0x%lx", paddr);
+		return false;
+	}
+
+	pg = paddr >> vm->page_shift;
+	return sparsebit_is_set(region->protected_phy_pages, pg);
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e..c18e2e9d3d75 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -157,6 +157,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 {
 	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
 
+	paddr = vm_untag_gpa(vm, paddr);
+
 	if (!(*pte & PTE_PRESENT_MASK)) {
 		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
 		if (current_level == target_level)
@@ -200,6 +202,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 		    "Physical address beyond maximum supported,\n"
 		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		    paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT(vm_untag_gpa(vm, paddr) == paddr,
+		    "Unexpected bits in paddr: %lx", paddr);
 
 	/*
 	 * Allocate upper level page tables, if not already present.  Return
@@ -222,6 +226,15 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+
+	/*
+	 * Neither SEV nor TDX supports shared page tables, so only the final
+	 * leaf PTE needs manually set the C/S-bit.
+	 */
+	if (vm_is_gpa_protected(vm, paddr))
+		*pte |= vm->arch.c_bit;
+	else
+		*pte |= vm->arch.s_bit;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -496,7 +509,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	 * No need for a hugepage mask on the PTE, x86-64 requires the "unused"
 	 * address bits to be zero.
 	 */
-	return PTE_GET_PA(*pte) | (gva & ~HUGEPAGE_MASK(level));
+	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
 }
 
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
-- 
2.43.0.472.g3155946c3a-goog


