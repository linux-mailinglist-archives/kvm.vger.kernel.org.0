Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4170D5E5998
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiIVDWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiIVDVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E12E91D3D
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m131-20020a252689000000b006b2bf1dd88cso7017388ybm.19
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=+LDIR5OdskiCOeqvXPXIE7HtnZy+9kr7t8dNqHGsjwY=;
        b=rcWk6OcvOrHOWAbj5rR/4bNi+HRrbr8j+oktBXKdT6DahbuQrxMNDJ4S+nEFXNsfL8
         gqznFIfF81NXYH6Kep0KZqnMrEmP3/OA0rGrLVbr4uXqpn2X74Vje97ANFNdev8k8gmb
         1HnNJvrjeiu5G3Cq++ddD0meIJwM+lpWdp0YE6CKXklOYpqhrgf+APA1/JiMC2mI0Xtd
         Is0eVkt7R/vCo23v6rSHoU52h5AiKTKYcT0WJOW+FRhdld6uCIeRRsnU+UBSlT5EcKQT
         uqglqL0hODEkKcyBYajOxjIZsHOPVnwO4r0QX0CdaN3AQbyIlyA6IuZqLipp8MXQPaq/
         29+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=+LDIR5OdskiCOeqvXPXIE7HtnZy+9kr7t8dNqHGsjwY=;
        b=AnhEdXA3pufGpCkkGvRNtWqtUYYU/hZjy2KwiM3sPP/eq7tRHjQ34X3CwgYLZP6BB+
         WH+yPAD+WKvstRVupfVDWvBNw5nFL4mUBpeL2pnV/Bp9xtCY4O2q6UuEyyOqzKZiY+gB
         PWIMZLWKqEc+mDEIjIiesFuSxA8GdV9aXHSAU2Du9tJPTq9p4tMOPwdJvyZhQfWi7O/o
         NbOsiz2968crpLvRsYrB3H4YI+5yj20ysfEBVAJiBeVJ299ZU/FL/N6jlFIV79gwPZMb
         Bq6E6GGVDf7N3S4T86jaADKuX60+B6TG3oSAupiXk69KVCw7DH5nACQ1O9YdDPxoD083
         mKFA==
X-Gm-Message-State: ACrzQf2lCJVCI+AYfbJBFCWjHfAW8vZw2+aV+wxVDJKb1nK7MgUH0RkN
        2WlSXU2+F79fwWOpasVSAals2IJ0Ao0Yk8m9Zrko9Ezhls84S5gEoqX/N4qB4BTrXHdnN3zKzDr
        4OWT3lpTx0CTgYW5z3nb2UyppksvsvoukF94xbtwlHmmxyUL+DTwucFGMSc/Lqys=
X-Google-Smtp-Source: AMsMyM61wAZO5S6xRlVQe9dt/kN929C/qdoAtEUmtZ2dr1VL0UOe005Tc1NkkFOnHH69KLpYbZMTwRZAuQz7Ng==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:d350:0:b0:329:515e:f83 with SMTP id
 d16-20020a81d350000000b00329515e0f83mr1223732ywl.327.1663816751463; Wed, 21
 Sep 2022 20:19:11 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:50 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-8-ricarkol@google.com>
Subject: [PATCH v8 07/14] KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
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
---
 .../selftests/kvm/include/kvm_util_base.h     | 26 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 18 +++++++------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index b2dbe253d4d0..5c0044ceae13 100644
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
@@ -643,13 +665,13 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
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
index 5a9f080ff888..a2d0c11457c0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -143,13 +143,10 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
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
 
@@ -245,9 +242,6 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
-	if (nr_pages != 0)
-		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    0, 0, nr_pages, 0);
 
 	return vm;
 }
@@ -293,8 +287,16 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
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
2.37.3.968.ga6b4b080e4-goog

