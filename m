Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDBB6646F2
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbjAJREY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238163AbjAJREK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:04:10 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0735448818
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:07 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id r126-20020a632b84000000b004393806c06eso5459610pgr.4
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zDFARFhQrpAenP30BalxIxt+DEVD8SrcDZuB3VTocFM=;
        b=RHVPby6d8YK0kNfyU4XbKbG9K0HrUPnMsx0zAVhYrwSEV1QvBOHDlns6vmL9HKJ0UX
         GTV1YXGFFi4qGGJzyDg70Bx23T/qk2m26IgQALGM9rhR0g1JyC0TbB4bIJ2Xw18fkNGl
         nOe59Ycux7gfu9Nmrbgz/R3/UuxVbrAk+IPG6nCPV99PZFoM0pXgOWGMXEgZm38uvpKf
         BBtJSb+cZOh9q9M9xGRmKPfF2dqWJWcjbhSQ7+/lvN18gTEm0VeYT2whIwJ0qMP5QdaY
         xG+z0S3/VWFyBnre6JlMVaycb/zTlF+EpxEJG1SUEa/ACow0BwLNJ1OBHer+Mgv9oE+1
         bY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zDFARFhQrpAenP30BalxIxt+DEVD8SrcDZuB3VTocFM=;
        b=OaOUb7e6QDjg2jLrN4E9uISwt8JzHGJ7MQCdk1lyw1jBtsRbMam2gtWI7iUqWEMoqo
         WCydSK+7Y3BcC4ZeAP/F5vqzw/mZyXVCtyPHiedN7i0NmkEdzTPvFpis1kSzKtHEw+46
         kOwDwCnOpGqeyZ5zeqT8kUL8mH1mcS+uhg6yYZeAroJGlYvNeaqPna8ske8BXKgWxIto
         s5kkRZoGQiOuV2UqnrF04j1opUv11EgzyOl/H6zdLJF70DvqSdlhobX4nOe8lzfzC4vJ
         kP8u3SjR8Q7xwEZyhGKseSNXfhyz6FfcT7vrt9r8wfIS/ARTmKyggITRWrYgmvWj3JKa
         vLgA==
X-Gm-Message-State: AFqh2kpdHAb6T7hG2wBeAmgiMvGHdJZb01HddrK4MdhzCsp/HOfQbjRY
        f4OJFqLV3aH0oanBft5NE5lk740wNk+zuFT9oycBhZMriQvxQy+omtQoWLXi+U/wE5WM0qy6l1e
        ehP3y2SHBhoknlXbBni39TJtcB8F1FAAqY3eE9VCHqb6U71E4QTqZbUx1mg==
X-Google-Smtp-Source: AMrXdXva5uhx3s+CWvKnDITDXLw6FXzMzy/SFM+KhQeIxW43fE2yM0tyQftMFsZ/tCmuuFkx7QZfCuLCIiY=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a17:902:c94d:b0:191:24d1:3b31 with SMTP id
 i13-20020a170902c94d00b0019124d13b31mr3005144pla.94.1673370246455; Tue, 10
 Jan 2023 09:04:06 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:03:54 -0800
In-Reply-To: <20230110170358.633793-1-pgonda@google.com>
Message-Id: <20230110170358.633793-4-pgonda@google.com>
Mime-Version: 1.0
References: <20230110170358.633793-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 3/7] KVM: selftests: handle protected bits in page tables
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

SEV guests rely on an encyption bit which resides within the range that
current code treats as address bits. Guest code will expect these bits
to be set appropriately in their page tables, whereas the rest of the
kvm_util functions will generally expect these bits to not be present.
Introduce pte_me_mask and struct kvm_vm_arch to allow for arch specific
address tagging. Currently just adding x86 c_bit and s_bit support for
SEV and TDX.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/arch/arm64/include/asm/kvm_host.h       |  7 +++++++
 tools/arch/riscv/include/asm/kvm_host.h       |  7 +++++++
 tools/arch/s390/include/asm/kvm_host.h        |  7 +++++++
 tools/arch/x86/include/asm/kvm_host.h         | 13 ++++++++++++
 .../selftests/kvm/include/kvm_util_base.h     | 19 +++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 ++++++++++++++++++-
 .../selftests/kvm/lib/x86_64/processor.c      | 17 ++++++++++++---
 7 files changed, 87 insertions(+), 4 deletions(-)
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
index 015b59a0b80e..f84d7777d5ca 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -17,6 +17,8 @@
 #include "linux/rbtree.h"
 
 #include <asm/atomic.h>
+#include <asm/kvm.h>
+#include <asm/kvm_host.h>
 
 #include <sys/ioctl.h>
 
@@ -111,6 +113,9 @@ struct kvm_vm {
 	vm_vaddr_t idt;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
+	uint64_t gpa_protected_mask;
+
+	struct kvm_vm_arch arch;
 
 	/* VM protection enabled: SEV, etc*/
 	bool protected;
@@ -162,6 +167,7 @@ enum vm_guest_mode {
 	VM_MODE_P40V48_16K,
 	VM_MODE_P40V48_64K,
 	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
+	VM_MODE_PXXV48_4K_SEV,	/* For 48bits VA but ANY bits PA */
 	VM_MODE_P47V64_4K,
 	VM_MODE_P44V64_4K,
 	VM_MODE_P36V48_4K,
@@ -441,6 +447,17 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
+
+static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	return gpa & ~vm->gpa_protected_mask;
+}
+
+static inline vm_paddr_t vm_tag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	return gpa | vm->gpa_protected_mask;
+}
+
 void vcpu_run(struct kvm_vcpu *vcpu);
 int _vcpu_run(struct kvm_vcpu *vcpu);
 
@@ -917,4 +934,6 @@ void kvm_selftest_arch_init(void);
 
 void kvm_arch_vm_post_create(struct kvm_vm *vm);
 
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 63913b219b42..ba771c2d949d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1451,9 +1451,10 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
  * address providing the memory to the vm physical address is returned.
  * A TEST_ASSERT failure occurs if no region containing gpa exists.
  */
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
+void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa_tagged)
 {
 	struct userspace_mem_region *region;
+	vm_paddr_t gpa = vm_untag_gpa(vm, gpa_tagged);
 
 	region = userspace_mem_region_find(vm, gpa, gpa);
 	if (!region) {
@@ -2147,3 +2148,21 @@ void __attribute((constructor)) kvm_selftest_init(void)
 
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
index acfa1d01e7df..d03cefd9f6cd 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -127,6 +127,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	/* If needed, create page map l4 table. */
 	if (!vm->pgd_created) {
 		vm->pgd = vm_alloc_page_table(vm);
+
 		vm->pgd_created = true;
 	}
 }
@@ -153,13 +154,16 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 				       int target_level)
 {
 	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
+	uint64_t paddr_raw = vm_untag_gpa(vm, paddr);
 
 	if (!(*pte & PTE_PRESENT_MASK)) {
 		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
 		if (current_level == target_level)
-			*pte |= PTE_LARGE_MASK | (paddr & PHYSICAL_PAGE_MASK);
-		else
+			*pte |= PTE_LARGE_MASK | (paddr_raw & PHYSICAL_PAGE_MASK);
+		else {
 			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
+		}
+
 	} else {
 		/*
 		 * Entry already present.  Assert that the caller doesn't want
@@ -197,6 +201,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 		    "Physical address beyond maximum supported,\n"
 		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		    paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT(vm_untag_gpa(vm, paddr) == paddr,
+		    "Unexpected bits in paddr: %lx", paddr);
 
 	/*
 	 * Allocate upper level page tables, if not already present.  Return
@@ -219,6 +225,11 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+
+	if (vm_is_gpa_protected(vm, paddr))
+		*pte |= vm->arch.c_bit;
+	else
+		*pte |= vm->arch.s_bit;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -493,7 +504,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	 * No need for a hugepage mask on the PTE, x86-64 requires the "unused"
 	 * address bits to be zero.
 	 */
-	return PTE_GET_PA(*pte) | (gva & ~HUGEPAGE_MASK(level));
+	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
 }
 
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
-- 
2.39.0.314.g84b9a713c41-goog

