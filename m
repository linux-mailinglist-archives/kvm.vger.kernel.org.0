Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E4F5AF357
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 20:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiIFSJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 14:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiIFSJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 14:09:52 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A697C51438
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 11:09:49 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-345158b6641so63421107b3.8
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=Rs/wMLW/vGp5MGiiJEnVc1IKvM/DGXMWqUc3gISK3cY=;
        b=sX+tIBp/OmeiUsEltg/+BJcEmfbBwuHBwnEYd1tof8GW0e5p1eYI0oz+3QF55RyxDS
         Mr971dEXVFlcvXiyFcwF0QUxMRfmGo/inEHe2dO90GLgmeduTVvUrQc9kL55mWAFW5LL
         f/V8aEzOUsrinPIVdHFUuuqhI/a/2zBzG/I2lDlL/MATPYvQIISCFo1K7/tqlxLghBb+
         bqd1kr4FpEXECjHkpNOVUsmTLOM3+espY5/mrNJpIKe+zxeVJvuVBoHcdeBeVsqZDlnz
         NQxefggcbtybimGlO64ixJCD+vVx3WQoSMKqNK1yrPIwW9E6pHQacsXvk8pSnlMjP+4e
         O0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=Rs/wMLW/vGp5MGiiJEnVc1IKvM/DGXMWqUc3gISK3cY=;
        b=bomexyKADjI+TiSwqdTwN+3N6oJ/ttwJ4/z/NmlCDEUbQjXKhtD2Pb5+l/TQ/wtBAt
         OqlIZzAC+FQ/kd2QNarwsGz2uHYClg8TaZ0QdlsIIQvpSDyLkG+WQlj+kazwN1azP3eN
         pCY875+z8H9z9/rYr9a7DkFwvumfG+JH0CAz8OC2/C7/1EoA1Ma/dV8ehSFxiqco2aqB
         Ilpdvd4uMMr+mGKLPvuqfAjm893iUbmqQy6H98WL0QPDBoPyiRiWvFO2L2hMagVl357E
         YKZOBA7ghRR1L423eMQrBj/d/CbPUOgYajvLQ03GTEtKQX+YTXF5ICTkaKoUCq8xady1
         dWBA==
X-Gm-Message-State: ACgBeo0pavZF7rOGGnTXsi4PA7yVXuuMz6vpNuqT9ww7n/ZWPKAvbhdL
        N6KHhKBi7vHk04584FuuMd/AAP4wUkRSq7sjtGJQK8jtqLacDjuvH38sxAwwBXv+74EHeR7ujNL
        6mJlNDK6Lxlif7TJIUDbgK2PUOj8pmrC4NLWNleM1jaIT11wGvhQmmIJALNmYpZU=
X-Google-Smtp-Source: AA6agR5+ZwdBXg3yI2uyYQZ8M0QAMqg3cPEL4Di/OiWsx7lCNPhkI5z28yqm0qxi5xH/PDuFW7wZp3Jjs7JtUA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9b48:0:b0:67a:6ad0:f078 with SMTP id
 u8-20020a259b48000000b0067a6ad0f078mr38627093ybo.536.1662487788712; Tue, 06
 Sep 2022 11:09:48 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:09:24 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-8-ricarkol@google.com>
Subject: [PATCH v6 07/13] KVM: selftests: Change ____vm_create() to take
 struct kvm_vm_mem_params
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vm_create() helpers are hardcoded to place most page types (code,
page-tables, stacks, etc) in the same memslot #0, and always backed with
anonymous 4K.  There are a couple of issues with that.  First, tests willing to
differ a bit, like placing page-tables in a different backing source type must
replicate much of what's already done by the vm_create() functions.  Second,
the hardcoded assumption of memslot #0 holding most things is spreaded
everywhere; this makes it very hard to change.

Fix the above issues by having selftests specify how they want memory to be
laid out: define the memory regions to use for code, pt (page-tables), and
data. Introduce a new structure, struct kvm_vm_mem_params, that defines: guest
mode, a list of memory region descriptions, and some fields specifying what
regions to use for code, pt, and data.

There is no functional change intended. The current commit adds a default
struct kvm_vm_mem_params that lays out memory exactly as before. The next
commit will change the allocators to get the region they should be using,
e.g.,: like the page table allocators using the pt memslot.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 51 +++++++++++++++-
 .../selftests/kvm/lib/aarch64/processor.c     |  3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 58 ++++++++++++++++---
 3 files changed, 102 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index b2dbe253d4d0..5dbca38a512b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -65,6 +65,13 @@ struct userspace_mem_regions {
 	DECLARE_HASHTABLE(slot_hash, 9);
 };
 
+enum kvm_mem_region_type {
+	MEM_REGION_CODE,
+	MEM_REGION_PT,
+	MEM_REGION_DATA,
+	NR_MEM_REGIONS,
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
@@ -93,6 +100,13 @@ struct kvm_vm {
 	int stats_fd;
 	struct kvm_stats_header stats_header;
 	struct kvm_stats_desc *stats_desc;
+
+	/*
+	 * KVM region slots. These are the default memslots used by page
+	 * allocators, e.g., lib/elf uses the memslots[MEM_REGION_CODE]
+	 * memslot.
+	 */
+	uint32_t memslots[NR_MEM_REGIONS];
 };
 
 
@@ -105,6 +119,13 @@ struct kvm_vm {
 struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot);
 
+inline struct userspace_mem_region *
+vm_get_mem_region(struct kvm_vm *vm, enum kvm_mem_region_type mrt)
+{
+	assert(mrt < NR_MEM_REGIONS);
+	return memslot2region(vm, vm->memslots[mrt]);
+}
+
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
@@ -637,19 +658,45 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+struct kvm_vm_mem_params {
+	enum vm_guest_mode mode;
+
+	struct {
+		enum vm_mem_backing_src_type src_type;
+		uint64_t guest_paddr;
+		/*
+		 * KVM region slot (same meaning as in struct
+		 * kvm_userspace_memory_region).
+		 */
+		uint32_t slot;
+		uint64_t npages;
+		uint32_t flags;
+		bool enabled;
+	} region[NR_MEM_REGIONS];
+
+	/* Each region type points to a region in the above array. */
+	uint16_t region_idx[NR_MEM_REGIONS];
+};
+
+extern struct kvm_vm_mem_params kvm_vm_mem_default;
+
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
  * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
+struct kvm_vm *____vm_create(struct kvm_vm_mem_params *mem_params);
 struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
 {
-	return ____vm_create(VM_MODE_DEFAULT, 0);
+	struct kvm_vm_mem_params params_wo_memslots = {
+		.mode = kvm_vm_mem_default.mode,
+	};
+
+	return ____vm_create(&params_wo_memslots);
 }
 
 static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 26f0eccff6fe..5a31dc85d054 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -508,7 +508,8 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
  */
 void __attribute__((constructor)) init_guest_modes(void)
 {
-       guest_modes_append_default();
+	guest_modes_append_default();
+	kvm_vm_mem_default.mode = VM_MODE_DEFAULT;
 }
 
 void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5a9f080ff888..02532bc528da 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -143,12 +143,37 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
+/*
+ * A single memslot #0 for code, data, and page tables.
+ *
+ * .region[0].npages should be set by the user.
+ */
+struct kvm_vm_mem_params kvm_vm_mem_default = {
+#ifndef __aarch64__
+	/* arm64 kvm_vm_mem_default.mode set in init_guest_modes() */
+	.mode = VM_MODE_DEFAULT,
+#endif
+	.region[0] = {
+		.src_type = VM_MEM_SRC_ANONYMOUS,
+		.guest_paddr = 0,
+		.slot = 0,
+		.npages = 0,
+		.flags = 0,
+		.enabled = true,
+	},
+	.region_idx[MEM_REGION_CODE] = 0,
+	.region_idx[MEM_REGION_PT] = 0,
+	.region_idx[MEM_REGION_DATA] = 0,
+};
+
+struct kvm_vm *____vm_create(struct kvm_vm_mem_params *mem_params)
 {
+	enum vm_guest_mode mode = mem_params->mode;
 	struct kvm_vm *vm;
+	enum kvm_mem_region_type mrt;
+	int idx;
 
-	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
-		 vm_guest_mode_string(mode), nr_pages);
+	pr_debug("%s: mode='%s'\n", __func__, vm_guest_mode_string(mode));
 
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
@@ -245,9 +270,25 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
-	if (nr_pages != 0)
-		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    0, 0, nr_pages, 0);
+
+	/* Create all mem regions according to mem_params specifications. */
+	for (idx = 0; idx < NR_MEM_REGIONS; idx++) {
+		if (!mem_params->region[idx].enabled)
+			continue;
+
+		vm_userspace_mem_region_add(vm,
+			mem_params->region[idx].src_type,
+			mem_params->region[idx].guest_paddr,
+			mem_params->region[idx].slot,
+			mem_params->region[idx].npages,
+			mem_params->region[idx].flags);
+	}
+
+	/* Set all memslot types for the VM, also according to the spec. */
+	for (mrt = 0; mrt < NR_MEM_REGIONS; mrt++) {
+		idx = mem_params->region_idx[mrt];
+		vm->memslots[mrt] = mem_params->region[idx].slot;
+	}
 
 	return vm;
 }
@@ -292,9 +333,12 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 {
 	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
 						 nr_extra_pages);
+	struct kvm_vm_mem_params mem_params = kvm_vm_mem_default;
 	struct kvm_vm *vm;
 
-	vm = ____vm_create(mode, nr_pages);
+	mem_params.region[0].npages = nr_pages;
+	mem_params.mode = mode;
+	vm = ____vm_create(&mem_params);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
-- 
2.37.2.789.g6183377224-goog

