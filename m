Return-Path: <kvm+bounces-4734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F20817717
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:13:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C31832854C0
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9112498BD;
	Mon, 18 Dec 2023 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cp5q6XgK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A590129EDF
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 16:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pgonda.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ce77ba2463so4465898b3a.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702915948; x=1703520748; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ajiqYHTTmxO72SG+HrHC8HXYH3UsjwoPzVuDZPnHMw=;
        b=cp5q6XgKrdQD3WKfj2W+U94YbQRsz8PeAi7fElt4hUbH22bHVEhOPPdWDB+H+XA5kT
         NYMttH7W1dB2SRY6axnqca2puVr2YtOnKVcaRTO8oIQjsNM4isW/dGNwnLIQ2eqp7IE8
         ACry/vPs57uLg5ROtoC6UzU8iRDG9ydiZWLJ5tB53DhApRr7Kwadr2+Y7JL0uRqFYQqW
         MMeCsHTDQe43I+so5gXl4S7cSsdKNxHStUNg5MxS9bb667B5N211P5FlYF9oXByIjbHx
         lkhnweQMNOqoeGtXmwW/Gu+fyOp3i1AOJIxqrga/gNFZEsJ2zUGnAOA+rWCFSvSbNNF8
         kfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702915948; x=1703520748;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ajiqYHTTmxO72SG+HrHC8HXYH3UsjwoPzVuDZPnHMw=;
        b=L4t4xK7tjiY8mjQLGhwBOL0QFebvTia924L7ICQaGUQda1FWyFo5jTz8xuS9zGuqNU
         vVAEkZ8qhFPfttk2RGKmIu130s6Z7beNmRgQoYEjGK3j8bsUWWB+qJto54sEtSJFWAtO
         Ft6T8QZ5t7kdDqAxR1PrsljMhPSSl4US+LU9jDP08LuKYMFbwq54j5qYsKAuottxFdYN
         vfdKDXtqXa4KarWdf6hccdFWREel0WMC02knPwrH+/C8nsfQg1lZcNqNYjSxpg8iifLL
         VRB7pRo+C0nTImlOwd/o64lPg9rJ2aCPir7hYUf+q8uy24WuNzGBbuQi8lpv3Es+03aH
         wkRA==
X-Gm-Message-State: AOJu0Ywuhtn1jc20gkDTOu1nw64CWXjg6Ah9F7M/BB59nJlApYZ7wdqa
	aqHxVI1bwCbmkOkAByD5PpxKySl9Z6fNFrUvlghPk2uDLphoEyTckzlU43tihKkpkQaRkrNKQQ0
	4OJpuIkAkQxyIv1fP3b7rqxuq/Fql0zqMAfkVJ4iSrCedIkJbc+N+qmcogg==
X-Google-Smtp-Source: AGHT+IFe5q18LGIpzA2mHRcP0IM4SNh0P6/P0pAyAlwOTuf58IYa4l/6GVTRpjvNpxBtzgXiCmqeNOl/XUo=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:8aeb:e3fa:237c:63a5])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:7d8:b0:6d6:9409:a41d with SMTP id
 n24-20020a056a0007d800b006d69409a41dmr37737pfu.5.1702915948393; Mon, 18 Dec
 2023 08:12:28 -0800 (PST)
Date: Mon, 18 Dec 2023 08:11:39 -0800
In-Reply-To: <20231218161146.3554657-1-pgonda@google.com>
Message-Id: <20231218161146.3554657-2-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH V7 1/8] KVM: selftests: Extend VM creation's @mode to allow
 control of VM subtype
From: Peter Gonda <pgonda@google.com>
To: kvm@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"

Carve out space in the @mode passed to the various VM creation helpers to
allow using the mode to control the subtype of VM, e.g. to identify x86's
SEV VMs (which are "regular" VMs as far as KVM is concerned).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 82 ++++++++++++-------
 tools/testing/selftests/kvm/lib/guest_modes.c |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++++----
 3 files changed, 73 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a18db6a7b3cf..ca99cc41685d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -43,6 +43,48 @@
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
+enum vm_guest_mode {
+	VM_MODE_P52V48_4K,
+	VM_MODE_P52V48_64K,
+	VM_MODE_P48V48_4K,
+	VM_MODE_P48V48_16K,
+	VM_MODE_P48V48_64K,
+	VM_MODE_P40V48_4K,
+	VM_MODE_P40V48_16K,
+	VM_MODE_P40V48_64K,
+	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
+	VM_MODE_P47V64_4K,
+	VM_MODE_P44V64_4K,
+	VM_MODE_P36V48_4K,
+	VM_MODE_P36V48_16K,
+	VM_MODE_P36V48_64K,
+	VM_MODE_P36V47_16K,
+	NUM_VM_MODES,
+};
+
+enum vm_subtype {
+	VM_SUBTYPE_DEFAULT,
+	VM_SUBTYPE_SEV,
+	NUM_VM_SUBTYPES,
+};
+
+/*
+ * There are currently two flavors of "modes" that tests can control.  The
+ * primary mode defines the physical and virtual address widths, and page sizes
+ * configured in hardware.  The VM type allows creating alternative types of
+ * VMs, e.g. architecture specific flavors of protected VMs.
+ *
+ * Valid values for the primary mask are "enum vm_guest_mode", and valid values
+ * for the type mask are "enum vm_subtype".
+ */
+#define VM_MODE_PRIMARY_MASK	GENMASK(7, 0)
+#define VM_MODE_SUBTYPE_SHIFT	8
+#define VM_MODE_SUBTYPE_MASK	GENMASK(15, 8)
+
+/* 8 bits in each mask above, i.e. 255 possible values */
+_Static_assert(NUM_VM_MODES < 256);
+_Static_assert(NUM_VM_SUBTYPES < 256);
+
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region region;
 	struct sparsebit *unused_phy_pages;
@@ -88,7 +130,8 @@ enum kvm_mem_region_type {
 };
 
 struct kvm_vm {
-	int mode;
+	enum vm_guest_mode mode;
+	enum vm_subtype subtype;
 	unsigned long type;
 	int kvm_fd;
 	int fd;
@@ -169,28 +212,9 @@ static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
 #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
 #define DEFAULT_STACK_PGS		5
 
-enum vm_guest_mode {
-	VM_MODE_P52V48_4K,
-	VM_MODE_P52V48_64K,
-	VM_MODE_P48V48_4K,
-	VM_MODE_P48V48_16K,
-	VM_MODE_P48V48_64K,
-	VM_MODE_P40V48_4K,
-	VM_MODE_P40V48_16K,
-	VM_MODE_P40V48_64K,
-	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
-	VM_MODE_P47V64_4K,
-	VM_MODE_P44V64_4K,
-	VM_MODE_P36V48_4K,
-	VM_MODE_P36V48_16K,
-	VM_MODE_P36V48_64K,
-	VM_MODE_P36V47_16K,
-	NUM_VM_MODES,
-};
-
 #if defined(__aarch64__)
 
-extern enum vm_guest_mode vm_mode_default;
+extern uint32_t vm_mode_default;
 
 #define VM_MODE_DEFAULT			vm_mode_default
 #define MIN_PAGE_SHIFT			12U
@@ -713,8 +737,8 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
  * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
-struct kvm_vm *____vm_create(enum vm_guest_mode mode);
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
+struct kvm_vm *____vm_create(uint32_t mode);
+struct kvm_vm *__vm_create(uint32_t mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
@@ -727,7 +751,7 @@ static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
 	return __vm_create(VM_MODE_DEFAULT, nr_runnable_vcpus, 0);
 }
 
-struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+struct kvm_vm *__vm_create_with_vcpus(uint32_t mode, uint32_t nr_vcpus,
 				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[]);
 
@@ -761,11 +785,11 @@ void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
 			    int nr_vcpus);
 
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
-unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
-unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages);
-unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_pages);
-static inline unsigned int
-vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
+unsigned int vm_calc_num_guest_pages(uint32_t mode, size_t size);
+unsigned int vm_num_host_pages(uint32_t mode, unsigned int num_guest_pages);
+unsigned int vm_num_guest_pages(uint32_t mode, unsigned int num_host_pages);
+static inline unsigned int vm_adjust_num_guest_pages(uint32_t mode,
+						     unsigned int num_guest_pages)
 {
 	unsigned int n;
 	n = vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 1df3ce4b16fd..0f6f2e2200b0 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -6,7 +6,7 @@
 
 #ifdef __aarch64__
 #include "processor.h"
-enum vm_guest_mode vm_mode_default;
+uint32_t vm_mode_default;
 #endif
 
 struct guest_mode guest_modes[NUM_VM_MODES];
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7a8af1821f5d..bb8bbebbd935 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -209,7 +209,7 @@ __weak void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
 		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);
 }
 
-struct kvm_vm *____vm_create(enum vm_guest_mode mode)
+struct kvm_vm *____vm_create(uint32_t mode)
 {
 	struct kvm_vm *vm;
 
@@ -221,13 +221,16 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 	vm->regions.hva_tree = RB_ROOT;
 	hash_init(vm->regions.slot_hash);
 
-	vm->mode = mode;
 	vm->type = 0;
+	vm->subtype = (mode & VM_MODE_SUBTYPE_MASK) >> VM_MODE_SUBTYPE_SHIFT;
+	vm->mode = mode & VM_MODE_PRIMARY_MASK;
+	pr_debug("%s: mode='%s'\n", __func__, vm_guest_mode_string(vm->mode));
 
-	vm->pa_bits = vm_guest_mode_params[mode].pa_bits;
-	vm->va_bits = vm_guest_mode_params[mode].va_bits;
-	vm->page_size = vm_guest_mode_params[mode].page_size;
-	vm->page_shift = vm_guest_mode_params[mode].page_shift;
+
+	vm->pa_bits = vm_guest_mode_params[vm->mode].pa_bits;
+	vm->va_bits = vm_guest_mode_params[vm->mode].va_bits;
+	vm->page_size = vm_guest_mode_params[vm->mode].page_size;
+	vm->page_shift = vm_guest_mode_params[vm->mode].page_shift;
 
 	/* Setup mode specific traits. */
 	switch (vm->mode) {
@@ -285,7 +288,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 		vm->pgtable_levels = 5;
 		break;
 	default:
-		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
+		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
 	}
 
 #ifdef __aarch64__
@@ -308,7 +311,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 	return vm;
 }
 
-static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
+static uint64_t vm_nr_pages_required(uint32_t mode,
 				     uint32_t nr_runnable_vcpus,
 				     uint64_t extra_mem_pages)
 {
@@ -347,17 +350,18 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
+struct kvm_vm *__vm_create(uint32_t mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages)
 {
-	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
+	uint32_t primary_mode = mode & VM_MODE_PRIMARY_MASK;
+	uint64_t nr_pages = vm_nr_pages_required(primary_mode, nr_runnable_vcpus,
 						 nr_extra_pages);
 	struct userspace_mem_region *slot0;
 	struct kvm_vm *vm;
 	int i;
 
 	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
-		 vm_guest_mode_string(mode), nr_pages);
+		 vm_guest_mode_string(primary_mode), nr_pages);
 
 	vm = ____vm_create(mode);
 
@@ -400,7 +404,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
  * extra_mem_pages is only used to calculate the maximum page table size,
  * no real memory allocation for non-slot0 memory in this function.
  */
-struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+struct kvm_vm *__vm_create_with_vcpus(uint32_t mode, uint32_t nr_vcpus,
 				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[])
 {
@@ -2030,7 +2034,7 @@ static inline int getpageshift(void)
 }
 
 unsigned int
-vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
+vm_num_host_pages(uint32_t mode, unsigned int num_guest_pages)
 {
 	return vm_calc_num_pages(num_guest_pages,
 				 vm_guest_mode_params[mode].page_shift,
@@ -2038,13 +2042,13 @@ vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
 }
 
 unsigned int
-vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_pages)
+vm_num_guest_pages(uint32_t mode, unsigned int num_host_pages)
 {
 	return vm_calc_num_pages(num_host_pages, getpageshift(),
 				 vm_guest_mode_params[mode].page_shift, false);
 }
 
-unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size)
+unsigned int vm_calc_num_guest_pages(uint32_t mode, size_t size)
 {
 	unsigned int n;
 	n = DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
-- 
2.43.0.472.g3155946c3a-goog


