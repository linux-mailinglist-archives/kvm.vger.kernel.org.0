Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B5057E663
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 20:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiGVSUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 14:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiGVSUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 14:20:13 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9C8BC11
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 11:20:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q16so5054007pgq.6
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 11:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IRkLkhMhQKEobM4pu2VDwjqhdDazvgdQfdKijY0RKKc=;
        b=jWdCmXeyK6vkC6Hosc7yJpKdxFhP+RaTXRqLhj+IkZf9lAscjHGsAjlvgypofPUEEo
         z6TBaT/d4Z5stHuADy5I0YUkaxEKI8AbKdQiWt2Lb4OwEOh3QOE9SLlfQ52dCGDG4q3V
         1HJfAgpQ2UZBEsFaBl+c2B+wYLAPcPW36x9VzKbY2Ait7A6A+w4u1kHtphDGHqLG2W3t
         GctnETQJ19oykFg2KXUHliDb3yKWRvINjPQME06GhzNyVm71CCBm4eoDGHKC9pjIhyyi
         DgjKsll1Mw8VpuDeKMNjU+no0HHBx+vDdYG9ceODYsAiFJJMW7f+lRuVV0jbgGAqTTyw
         Zkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IRkLkhMhQKEobM4pu2VDwjqhdDazvgdQfdKijY0RKKc=;
        b=ZUnz7ZpdHRxaeiHYroDLf69A9MAnlvfI9OaExUh2lVNbMlAD0t0CMeEFI/H+p3kKk3
         Pp4MKMMLWNnYOBMtIl+mSyUI3Uy2J0gj4oxzRn+0Cr3ZJj2kp2fY69ZIvaoGwJHMuk1v
         SKboPKSQpSIfNcr+hqMo2QXmlj2NvrvA6yNFm1BIDwRb/QMULP35inYIOqPLrQBlTgjX
         NkPTHaTUU6sss4iDdo6fHo4+uannyy4b3UKWxPCZB83UlIYKC3ZFqa58nhYkU6yvnuAQ
         5jQikLNLYoK9aHEonDcJrlnnKkOz5b7n8+wrmgGsCHfs2t+WQxaBILXg6C0mZHcSxoWN
         zSfQ==
X-Gm-Message-State: AJIora8TgDF0DVap3MXvCK4T0U6nZQ/wP3H8OZ0mL+038yVjcIWdAU7h
        EhQaWossBxgkL14dav+wREShng==
X-Google-Smtp-Source: AGRyM1u6sqsryb8zNNqWWd1ReWEFrI3acQyg9JhcZMRtWlHFyIAQ3qES0WHgRmTRiISMOIGb84kTCA==
X-Received: by 2002:a63:ef51:0:b0:41a:554b:aef2 with SMTP id c17-20020a63ef51000000b0041a554baef2mr856313pgk.550.1658514011409;
        Fri, 22 Jul 2022 11:20:11 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902bb8500b0016c4331e61csm4064367pls.137.2022.07.22.11.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 11:20:10 -0700 (PDT)
Date:   Fri, 22 Jul 2022 18:20:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, maz@kernel.org, bgardon@google.com,
        dmatlack@google.com, pbonzini@redhat.com, axelrasmussen@google.com
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YtrqVwSK42KbKckf@google.com>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
 <Ytir/hbU9neBaYqb@google.com>
 <YtrcCeHqBcwy+Mf6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtrcCeHqBcwy+Mf6@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022, Ricardo Koller wrote:
> On Thu, Jul 21, 2022 at 01:29:34AM +0000, Sean Christopherson wrote:
> > If we don't care, and maybe even if we do, then my preference would be to
> > enhance the __vm_create family of helpers to allow for specifying what
> > backing type should be used for page tables, i.e. associate the info the VM
> > instead of passing it around the stack.
> > 
> > One idea would be to do something like David Matlack suggested a while back
> > and replace extra_mem_pages with a struct, e.g. struct kvm_vm_mem_params
> > That struct can then provide the necessary knobs to control how memory is
> > allocated.  And then the lib can provide a global
> > 
> > 	struct kvm_vm_mem_params kvm_default_vm_mem_params;
> > 
> 
> I like this idea, passing the info at vm creation.
> 
> What about dividing the changes in two.
> 
> 	1. Will add the struct to "__vm_create()" as part of this
> 	series, and then use it in this commit. There's only one user
> 
> 		dirty_log_test.c:   vm = __vm_create(mode, 1, extra_mem_pages);
> 
> 	so that would avoid having to touch every test as part of this patchset.
> 
> 	2. I can then send another series to add support for all the other
> 	vm_create() functions.
> 
> Alternatively, I can send a new series that does 1 and 2 afterwards.
> WDYT?

Don't do #2, ever. :-)  The intent of having vm_create() versus is __vm_create()
is so that tests that don't care about things like backing pages don't have to
pass in extra params.  I very much want to keep that behavior, i.e. I don't want
to extend vm_create() at all.  IMO, adding _anything_ is a slippery slope, e.g.
why are the backing types special enough to get a param, but thing XYZ isn't?

Thinking more, the struct idea probably isn't going to work all that well.  It
again puts the selftests into a state where it becomes difficult to control one
setting and ignore the rest, e.g. the dirty_log_test and anything else with extra
pages suddenly has to care about the backing type for page tables and code.

Rather than adding a struct, what about extending the @mode param?  We already
have vm_mem_backing_src_type, we just need a way to splice things together.  There
are a total of four things we can control: primary mode, and then code, data, and
page tables backing types.

So, turn @mode into a uint32_t and carve out 8 bits for each of those four "modes".
The defaults Just Work because VM_MEM_SRC_ANONYMOUS==0.

Lightly tested, but the below should provide the necessary base infrastructure,
then you just need to have ____vm_create() consume the secondary "modes".

---
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 22 Jul 2022 10:56:08 -0700
Subject: [PATCH] KVM: selftests: Extend VM creation's @mode to allow control
 of backing types

Carve out space in the @mode passed to the various VM creation helpers to
allow using the mode to control the backing type for code, data, and page
table allocations made by the selftests framework.  E.g. to allow tests
to force guest page tables to be backed with huge pages.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 78 ++++++++++++-------
 tools/testing/selftests/kvm/lib/guest_modes.c |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++----
 3 files changed, 69 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..992dcc7b39e7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -29,6 +29,45 @@
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */

+
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
+/*
+ * There are four flavors of "modes" that tests can control.  The primary mode
+ * defines the physical and virtual address widths, and page sizes configured
+ * in hardware.  The code/data/page_table modifiers control the backing types
+ * for code, data, and page tables that are allocated by the infrastructure,
+ * e.g. to allow tests to force page tables to be back by huge pages.
+ *
+ * Valid values for the primary mask are "enum vm_guest_mode", and valid values
+ * for code, data, and page tables are "enum vm_mem_backing_src_type".
+ */
+#define VM_MODE_PRIMARY_MASK	GENMASK(7, 0)
+#define VM_MODE_CODE_MASK	GENMASK(15, 8)
+#define VM_MODE_DATA_MASK	GENMASK(23, 16)
+#define VM_MODE_PAGE_TABLE_MASK	GENMASK(31, 24)
+
+/* 8 bits in each mask above, i.e. 255 possible values */
+_Static_assert(NUM_VM_MODES < 256);
+_Static_assert(NUM_SRC_TYPES < 256);
+
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region region;
 	struct sparsebit *unused_phy_pages;
@@ -65,7 +104,7 @@ struct userspace_mem_regions {
 };

 struct kvm_vm {
-	int mode;
+	enum vm_guest_mode mode;
 	unsigned long type;
 	int kvm_fd;
 	int fd;
@@ -111,28 +150,9 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot);
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
@@ -642,8 +662,8 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
  * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
+struct kvm_vm *____vm_create(uint32_t mode, uint64_t nr_pages);
+struct kvm_vm *__vm_create(uint32_t mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages);

 static inline struct kvm_vm *vm_create_barebones(void)
@@ -656,7 +676,7 @@ static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
 	return __vm_create(VM_MODE_DEFAULT, nr_runnable_vcpus, 0);
 }

-struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+struct kvm_vm *__vm_create_with_vcpus(uint32_t mode, uint32_t nr_vcpus,
 				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[]);

@@ -685,11 +705,11 @@ static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);

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
index 99a575bbbc52..93c6ca9ebb49 100644
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
index 9889fe0d8919..c2f3c49643b1 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -143,13 +143,10 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");

-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
+struct kvm_vm *____vm_create(uint32_t mode, uint64_t nr_pages)
 {
 	struct kvm_vm *vm;

-	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
-		 vm_guest_mode_string(mode), nr_pages);
-
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");

@@ -158,13 +155,19 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 	vm->regions.hva_tree = RB_ROOT;
 	hash_init(vm->regions.slot_hash);

-	vm->mode = mode;
 	vm->type = 0;

-	vm->pa_bits = vm_guest_mode_params[mode].pa_bits;
-	vm->va_bits = vm_guest_mode_params[mode].va_bits;
-	vm->page_size = vm_guest_mode_params[mode].page_size;
-	vm->page_shift = vm_guest_mode_params[mode].page_shift;
+	vm->mode = mode & VM_MODE_PRIMARY_MASK;
+	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
+		 vm_guest_mode_string(mode), nr_pages);
+
+	TEST_ASSERT(vm->mode == mode,
+		    "Code, data, and page tables \"modes\" not yet implemented");
+
+	vm->pa_bits = vm_guest_mode_params[vm->mode].pa_bits;
+	vm->va_bits = vm_guest_mode_params[vm->mode].va_bits;
+	vm->page_size = vm_guest_mode_params[vm->mode].page_size;
+	vm->page_shift = vm_guest_mode_params[vm->mode].page_shift;

 	/* Setup mode specific traits. */
 	switch (vm->mode) {
@@ -222,7 +225,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 		vm->pgtable_levels = 5;
 		break;
 	default:
-		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
+		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
 	}

 #ifdef __aarch64__
@@ -252,7 +255,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 	return vm;
 }

-static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
+static uint64_t vm_nr_pages_required(uint32_t mode,
 				     uint32_t nr_runnable_vcpus,
 				     uint64_t extra_mem_pages)
 {
@@ -287,7 +290,7 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }

-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
+struct kvm_vm *__vm_create(uint32_t mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages)
 {
 	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
@@ -323,7 +326,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
  * extra_mem_pages is only used to calculate the maximum page table size,
  * no real memory allocation for non-slot0 memory in this function.
  */
-struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+struct kvm_vm *__vm_create_with_vcpus(uint32_t mode, uint32_t nr_vcpus,
 				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[])
 {
@@ -1849,7 +1852,7 @@ static inline int getpageshift(void)
 }

 unsigned int
-vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
+vm_num_host_pages(uint32_t mode, unsigned int num_guest_pages)
 {
 	return vm_calc_num_pages(num_guest_pages,
 				 vm_guest_mode_params[mode].page_shift,
@@ -1857,13 +1860,13 @@ vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
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

base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
--

