Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA6C601855
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 21:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiJQT64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 15:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiJQT6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 15:58:52 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F19778BF4
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 126-20020a630284000000b0043942ef3ac7so6955667pgc.11
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BNjTuI0rbj5ujoM1kr4Nyv5I/Kmc89C7mtOUsWzzEJg=;
        b=EHd3YR633sBZkMnhLM4/rA4QRzV+id//4pIzPBVlKxqg7uAumH4VvtyoRBsN7ICWjN
         o/SJ3TwgM8BKt5sd7DLWCOjCBUnHwvgoQaXljEz/8tX2rGdmVxkcmRdbMHVxSuOcovEd
         fzpLhWg0egbPzer0NcRvzpro+ni00xv1od7NfYe8xcrFzozgy8YxX1qASkZ2zuNLtJm/
         9LdhiHXsqS61l8KxYk85LAFF3WUepQJUrQyGqUbWcF06ZiOGZSuokdqXIpaOhPA8jAsM
         zZ7U7e4kim9rQpRBrfTNUjoEB37iSI8Gc2haBDO5r4I187lSpQeJrR5niAyoXIzMq5A2
         Jslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BNjTuI0rbj5ujoM1kr4Nyv5I/Kmc89C7mtOUsWzzEJg=;
        b=glxs73a1y/4XnTDqiFeSBxDHipr/GLASKdLQSuJyr9+9HQtX8riu1GzLbTrMm37R9F
         Lkow1OwqrREHUQAHpuP4LN/1npdt7KUgLsFF9mT9/wisczwbvn8mBOiJh/e38UzS3yqi
         uRTTEu2fzSNxO3g7Zir0Ox3LK1+pF0Znh/S4+bSHzizIM04ZPiwRw2zIJfHfFQfHHWrb
         gT5zI3OlX+j6GGdoeX5196tgQVFIAywZi2ct9MR0UHWuNkqGmQEpvUowFQOY8UjL1lnk
         Op4wW8m4jUiOyRkjaHRiiQG2ni9dvPNMIzUH6Lmr/V7Y99Z8iMBzg2fc9GWTUT/Mw57J
         B1lQ==
X-Gm-Message-State: ACrzQf38luda4yQlzQ9msDJa970a9+ZDzsvZDBwT9oljuPW3oOq7O5Ps
        z28/iKaXW2EK5eNCpaZy9xG7zJsBCBUpGcnX0slm+TFRqhYsQF7G9jeen/bo18NzXRGEjo9rKTL
        luW/ycrro4nRH3sStPGrykCXdD3iDPclCPd3C1wHO8q902fO4+vhDUGKz0GDMyDs=
X-Google-Smtp-Source: AMsMyM4+lVerbhrBNE/AY4j9ixM1lyPqkAbxgo5kVMWNw23jsa5g+O1C4hH5vOb41WausYHMinCyrF3MxD3ARQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:5408:b0:20a:d6b1:a2a7 with SMTP
 id z8-20020a17090a540800b0020ad6b1a2a7mr1474728pjh.2.1666036728944; Mon, 17
 Oct 2022 12:58:48 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:58:27 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-8-ricarkol@google.com>
Subject: [PATCH v10 07/14] KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
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

The vm_create() helpers are hardcoded to place most page types (code,
page-tables, stacks, etc) in the same memslot #0, and always backed with
anonymous 4K.  There are a couple of issues with that.  First, tests
willing to differ a bit, like placing page-tables in a different backing
source type must replicate much of what's already done by the vm_create()
functions.  Second, the hardcoded assumption of memslot #0 holding most
things is spread everywhere; this makes it very hard to change.

Fix the above issues by having selftests specify how they want memory to be
laid out. Start by changing ____vm_create() to not create memslot #0; a
test (to come) will specify all memslots used by the VM.  Then, add the
vm->memslots[] array to specify the right memslot for different memory
allocators, e.g.,: lib/elf should use the vm->[MEM_REGION_CODE] memslot.
This will be used as a way to specify the page-tables memslots (to be
backed by huge pages for example).

There is no functional change intended. The current commit lays out memory
exactly as before. A future commit will change the allocators to get the
region they should be using, e.g.,: like the page table allocators using
the pt memslot.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 26 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 18 +++++++------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a9264ed22cca..6442aa9e9061 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -65,6 +65,14 @@ struct userspace_mem_regions {
 	DECLARE_HASHTABLE(slot_hash, 9);
 };
 
+enum kvm_mem_region_type {
+	MEM_REGION_CODE,
+	MEM_REGION_DATA,
+	MEM_REGION_PT,
+	MEM_REGION_TEST_DATA,
+	NR_MEM_REGIONS,
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
@@ -93,6 +101,13 @@ struct kvm_vm {
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
 
 
@@ -105,6 +120,13 @@ struct kvm_vm {
 struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot);
 
+static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
+							     enum kvm_mem_region_type type)
+{
+	assert(type < NR_MEM_REGIONS);
+	return memslot2region(vm, vm->memslots[type]);
+}
+
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
@@ -647,13 +669,13 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
  * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
+struct kvm_vm *____vm_create(enum vm_guest_mode mode);
 struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
 {
-	return ____vm_create(VM_MODE_DEFAULT, 0);
+	return ____vm_create(VM_MODE_DEFAULT);
 }
 
 static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6affce47e899..f3dfa4e9ee0f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -185,13 +185,10 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
+struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 {
 	struct kvm_vm *vm;
 
-	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
-		 vm_guest_mode_string(mode), nr_pages);
-
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
 
@@ -287,9 +284,6 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
-	if (nr_pages != 0)
-		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    0, 0, nr_pages, 0);
 
 	return vm;
 }
@@ -335,8 +329,16 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
 						 nr_extra_pages);
 	struct kvm_vm *vm;
+	int i;
+
+	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
+		 vm_guest_mode_string(mode), nr_pages);
+
+	vm = ____vm_create(mode);
 
-	vm = ____vm_create(mode, nr_pages);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
+	for (i = 0; i < NR_MEM_REGIONS; i++)
+		vm->memslots[i] = 0;
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
-- 
2.38.0.413.g74048e4d9e-goog

