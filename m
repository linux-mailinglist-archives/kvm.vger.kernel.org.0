Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C50B5BDB43
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiITEPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiITEP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:15:26 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EEC2CDFF
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:23 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3452b545544so11253697b3.3
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=xFXNCs/Kv3LqJyXaP78XR5noApoFVHzXabQ5XyxTcYs=;
        b=g0OE0xyAwHrW3bu0pnLjJj9+YFtUoJaRROGWlVYNxzUXGS366tjvufvPYdPB2tbpS4
         kgFmaiA8xNt5oCi8dH7VPtRY0EK/bzymRsgz2+/FKOkK0oYCMS6F67e2RneeStveJoaC
         ifLs3bcCM44j4d0FVOmLbf7ROksy6yzCRafozEqHEhCWVRm+ylorpmw29PfkQBnCa+WK
         cnjYvDXW1B7YOTa3xWUMzqg4zi2kRORrLU3HP0TALaI0cQCi2XTKx/Qru33XVQRv58FD
         lShsWipnn4YxPsD3nrrMg8hEWIZm30HXJFQNGZVYjYr3dRgcH4EDkSX5U46O+TKUbLOo
         ZcVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=xFXNCs/Kv3LqJyXaP78XR5noApoFVHzXabQ5XyxTcYs=;
        b=1x/H+6EiywKdDpYk7C6Nsy7/rd/j73PTwCz6m+KuJXqFeMgbkekdxD1sz9vdqdPsRH
         FzQ502ct+NrsJGDfXPdOklZ5SjB4tK7Dia6XJ1eoFPbu8JJumsp9iBbg/rV9pCdWgNNX
         2suUNutAkHOPBTCsL2hjZOsnCVzucrBHtpszQ3RoqTm16UtmyfMb385oYg5z55l2rb91
         azXUUxAGMKBQ4U4PQD6UszgOln8ltqY7os8XNmvNC+CIok1L1rSKz/yf8ky4EDq5Z9Qf
         WOvbEe5YH3yRWYL2jT2igiJ94QzYN6IdgsXuJ/1BO0LJSZ7tHcCyWenmFUsYeQutkZJ5
         T+gQ==
X-Gm-Message-State: ACrzQf21rroDPYNj2EmGRv4mPhvWNlnhY8GiVGAwW/3MU1F07nDXZWyv
        /RBgQ4BatKp7JDaRw8E6+i5QPk5qGh3mjE4GGk73l4yDwj/L6ons04q/e/SI2KKf0e63jwklgkD
        8HKLVSmrI0QuF70ntYe4z4G5ovRep8+azUV6yJZ2XUAH8MYUyLBwS8MnpAW1vPz8=
X-Google-Smtp-Source: AMsMyM7wi8QcMPPhEUiWsefp8WweTOVtTk0urh9GuURVgfc1oCnctUuTuFGx5wZslu4U25mxb8JiqFHJA4go8A==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:778d:0:b0:6af:73a7:8e16 with SMTP id
 s135-20020a25778d000000b006af73a78e16mr17363116ybc.91.1663647323092; Mon, 19
 Sep 2022 21:15:23 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:15:03 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-8-ricarkol@google.com>
Subject: [PATCH v6 07/13] KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
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
anonymous 4K.  There are a couple of issues with that.  First, tests willing to
differ a bit, like placing page-tables in a different backing source type must
replicate much of what's already done by the vm_create() functions.  Second,
the hardcoded assumption of memslot #0 holding most things is spreaded
everywhere; this makes it very hard to change.

Fix the above issues by having selftests specify how they want memory to be
laid out. Start by changing ____vm_create() to not create memslot #0; a future
commit will add test that specifies all memslots used by the VM.  Then, add the
vm->memslots[] array to specify the right memslot for different memory
allocators, e.g.,: lib/elf should use the vm->[MEM_REGION_CODE] memslot.  This
will be used as a way to specify the page-tables memslots (to be backed by huge
pages for example).

There is no functional change intended. The current commit lays out memory
exactly as before. The next commit will change the allocators to get the region
they should be using, e.g.,: like the page table allocators using the pt
memslot.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 25 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 18 +++++++------
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index b2dbe253d4d0..26187b8a66c6 100644
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
@@ -643,13 +664,13 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
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
index 5a9f080ff888..2e36d6323518 100644
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
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
 
-	vm = ____vm_create(mode, nr_pages);
+	for (i = 0; i < NR_MEM_REGIONS; i++)
+		vm->memslots[i] = 0;
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
-- 
2.37.3.968.ga6b4b080e4-goog

