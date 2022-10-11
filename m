Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3BC5FA9B0
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 03:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJKBHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 21:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiJKBHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 21:07:03 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487F7537FC
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id v1-20020aa78081000000b005636d8a1947so1544127pff.0
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLUYIdTAWT8Y8VQYfW5BcWNeDtoU7cwO28DOSCLmdhs=;
        b=iENMaIEImKo0ZZsinAD0C283wnsdTbkav77KVBCxsE9mX/Mo4Hi7aHbqKAsKnitoI0
         DMqg41jfuylhyrhnScVdqOYsRfO49oIG8Blbb5kxHm1WDlHpBn/V8U/5apwC7grVQQ5s
         j0owaHC5/jpAAtXE663Wz87MoMnRU4O2J6fIg9OgBQamSf9K+NV/zWow4pcnUgQG+X+1
         JZMKP60ITXrn9Uo6sr2FBqIwyT78+MBI31Zl7Wubq54CU2fofsTSHffK0oA2se3qIiMh
         nLLXXuvUO9htR2Xd8p8ByjFQoSL9PSPx/BEzPAIPYiq0yIjbjlUqRTgSd/MnmWzdw7lA
         2iuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLUYIdTAWT8Y8VQYfW5BcWNeDtoU7cwO28DOSCLmdhs=;
        b=tbgupxnUB5/nISuwZi6YYC1pK/OVR0foWy7ZdAQSt7J6WMiTzATZn8R2i8hRZBHW3F
         FfhPkZcTs8F9uaY66C2DCsFywy+ed5uYE0elCmocryTw+u7XTCtELQePf7HQcJoSXu/e
         R31ZCUAXQ1GJTAcWhNqHpsY+bf2mIHL7IrBskTkWMuYtgFIysP0+jFiWxrNNiQ6Qj8au
         ZObDUg9ndCQ/0mWgWFHiF9HiKoRqBcp8fgltZLkloC+gjArzPWRdS9A80M3EvKJ3vE3n
         2A879H4Kr+Qt22BuM//0uVyar1Sx/ddN9nt/Lecj55esynm3SXIWZ79cqkbQ6hq/Li5Z
         KMxA==
X-Gm-Message-State: ACrzQf0koNy+nSqSyw25bKIqbgxQwvzbY1A6ZdKVmTMhyup6nARTY7SE
        ioNi3eoiWtQHGXxwIC9TQaH6iYA0v+Q5WIfg4/2aUP9pX9DlnN5FwanWDvsvLGA4lP3/HDIGRGR
        ikISrueDpJ9mTCgJFrDNk8zcgFNg9DoUqgzoqAdiQfx90oLAtTptKMSBsMPEdl5s=
X-Google-Smtp-Source: AMsMyM5srUlm+sTE4saC0UPFNNvdN38am6xst1Zr88kmdNsmGM741o/fdaLT5jLqJfm0CXc7RSkicYedCSCvOQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:a22:b0:54e:6a90:fbef with SMTP
 id p34-20020a056a000a2200b0054e6a90fbefmr22136854pfh.53.1665450411987; Mon,
 10 Oct 2022 18:06:51 -0700 (PDT)
Date:   Tue, 11 Oct 2022 01:06:23 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-10-ricarkol@google.com>
Subject: [PATCH v9 09/14] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Now that kvm_vm allows specifying different memslots for code, page tables,
and data, use the appropriate memslot when making allocations in
common/libraty code. Change them accordingly:

- code (allocated by lib/elf) use the CODE memslot
- stacks, exception tables, and other core data pages (like the TSS in x86)
  use the DATA memslot
- page tables and the PGD use the PT memslot
- test data (anything allocated with vm_vaddr_alloc()) uses the TEST_DATA
  memslot

No functional change intended. All allocators keep using memslot #0.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 .../selftests/kvm/lib/aarch64/processor.c     | 12 ++--
 tools/testing/selftests/kvm/lib/elf.c         |  3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 57 ++++++++++++-------
 .../selftests/kvm/lib/riscv/processor.c       |  8 ++-
 .../selftests/kvm/lib/s390x/processor.c       |  8 ++-
 .../selftests/kvm/lib/x86_64/processor.c      | 13 +++--
 7 files changed, 65 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6442aa9e9061..b0da75af1ff3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -407,7 +407,11 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			    enum kvm_mem_region_type type);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
+vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
+				 enum kvm_mem_region_type type);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6ff2b9d6cea6..2883dfd1ad49 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -82,7 +82,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 		return;
 
 	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
-				     KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				     vm->memslots[MEM_REGION_PT]);
 	vm->pgd_created = true;
 }
 
@@ -332,8 +333,9 @@ struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 
 	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
 					     vm->page_size;
-	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-				     DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+				       DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
+				       MEM_REGION_DATA);
 
 	aarch64_vcpu_setup(vcpu, init);
 
@@ -438,8 +440,8 @@ void route_exception(struct ex_regs *regs, int vector)
 
 void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
-	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
-			vm->page_size);
+	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
+					vm->page_size, MEM_REGION_DATA);
 
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 9f54c098d9d0..51f280c412ba 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -161,7 +161,8 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart);
+		vm_vaddr_t vaddr = __vm_vaddr_alloc(vm, seg_size, seg_vstart,
+						    MEM_REGION_CODE);
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
 			"  segment idx: %u\n"
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f3dfa4e9ee0f..5ad4acaec8e0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1226,32 +1226,15 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-/*
- * VM Virtual Address Allocate
- *
- * Input Args:
- *   vm - Virtual Machine
- *   sz - Size in bytes
- *   vaddr_min - Minimum starting virtual address
- *
- * Output Args: None
- *
- * Return:
- *   Starting guest virtual address
- *
- * Allocates at least sz bytes within the virtual address space of the vm
- * given by vm.  The allocated bytes are mapped to a virtual address >=
- * the address given by vaddr_min.  Note that each allocation uses a
- * a unique set of pages, with the minimum real allocation being at least
- * a page.
- */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			    enum kvm_mem_region_type type)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
 	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
+					      KVM_UTIL_MIN_PFN * vm->page_size,
+					      vm->memslots[type]);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1272,6 +1255,30 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 	return vaddr_start;
 }
 
+/*
+ * VM Virtual Address Allocate
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   sz - Size in bytes
+ *   vaddr_min - Minimum starting virtual address
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Starting guest virtual address
+ *
+ * Allocates at least sz bytes within the virtual address space of the vm
+ * given by vm.  The allocated bytes are mapped to a virtual address >=
+ * the address given by vaddr_min.  Note that each allocation uses a
+ * a unique set of pages, with the minimum real allocation being at least
+ * a page. The allocated physical space comes from the TEST_DATA memory region.
+ */
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return __vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA);
+}
+
 /*
  * VM Virtual Address Allocate Pages
  *
@@ -1291,6 +1298,11 @@ vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
 	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
 }
 
+vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type)
+{
+	return __vm_vaddr_alloc(vm, getpagesize(), KVM_UTIL_MIN_VADDR, type);
+}
+
 /*
  * VM Virtual Address Allocate Page
  *
@@ -1856,7 +1868,8 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
 {
-	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				 vm->memslots[MEM_REGION_PT]);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index ac7fc9d317db..d146ca71e0c0 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -61,7 +61,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 		return;
 
 	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
-				     KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				     vm->memslots[MEM_REGION_PT]);
 	vm->pgd_created = true;
 }
 
@@ -288,8 +289,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 
 	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
 					     vm->page_size;
-	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-				     DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
+	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+				       DEFAULT_RISCV_GUEST_STACK_VADDR_MIN,
+				       MEM_REGION_DATA);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	riscv_vcpu_mmu_setup(vcpu);
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 89d7340d9cbd..15945121daf1 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -21,7 +21,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 		return;
 
 	paddr = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
-				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				   vm->memslots[MEM_REGION_PT]);
 	memset(addr_gpa2hva(vm, paddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	vm->pgd = paddr;
@@ -167,8 +168,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	TEST_ASSERT(vm->page_size == 4096, "Unsupported page size: 0x%x",
 		    vm->page_size);
 
-	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-				     DEFAULT_GUEST_STACK_VADDR_MIN);
+	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+				       DEFAULT_GUEST_STACK_VADDR_MIN,
+				       MEM_REGION_DATA);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 39c4409ef56a..b199dde90e9f 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -552,7 +552,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
 {
 	if (!vm->gdt)
-		vm->gdt = vm_vaddr_alloc_page(vm);
+		vm->gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 
 	dt->base = vm->gdt;
 	dt->limit = getpagesize();
@@ -562,7 +562,7 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 				int selector)
 {
 	if (!vm->tss)
-		vm->tss = vm_vaddr_alloc_page(vm);
+		vm->tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 
 	memset(segp, 0, sizeof(*segp));
 	segp->base = vm->tss;
@@ -647,8 +647,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	vm_vaddr_t stack_vaddr;
 	struct kvm_vcpu *vcpu;
 
-	stack_vaddr = vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
-				     DEFAULT_GUEST_STACK_VADDR_MIN);
+	stack_vaddr = __vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
+				       DEFAULT_GUEST_STACK_VADDR_MIN,
+				       MEM_REGION_DATA);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
@@ -1145,8 +1146,8 @@ void vm_init_descriptor_tables(struct kvm_vm *vm)
 	extern void *idt_handlers;
 	int i;
 
-	vm->idt = vm_vaddr_alloc_page(vm);
-	vm->handlers = vm_vaddr_alloc_page(vm);
+	vm->idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
+	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 	/* Handlers have the same address in both address spaces.*/
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
-- 
2.38.0.rc1.362.ged0d419d3c-goog

