Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20785802CB
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 18:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiGYQfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 12:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbiGYQfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 12:35:50 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F263D107
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:35:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31e5cc477dcso90911607b3.0
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3zHETYKswgHnU9SUT0vO1IiL2eclnApb6cB3wXGTWnY=;
        b=siCGzUvp84v0Zlmmr+z2vLUKK6/vzu5ufFkYncvdwH8CUVEmD+36x+iCElQt5q587d
         LXX4KtIqRaihwMlLx1fyJst4IoX2672/O2MqGTCldR3A6lCCG/Z3gGt9lGX4xgMghVae
         T5U6FQPUGakaQzUQbjfhjSQ0Z9hGBE9wc77d7+vo6MDRSWQtE6QgBKUNdP3kKUwA2pQh
         s6/o9A+VghRuWnpgUO6h3CIdaiYgSuIA4lbA+xbyKBxXf+H2n86dvpc9a4DJGeNfdD7d
         oHfXz8HlwmQp3SITFKq23Jxgz0uz4CuHU4YVwFDYmuZmVMmGRybf5+3CTSRR4Czh/vCr
         b0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3zHETYKswgHnU9SUT0vO1IiL2eclnApb6cB3wXGTWnY=;
        b=k7O+Mi+N4uLPEIdKJJEYt4aW69EtwH9vkCuuTJ90Bhy/h0VeqR86Zrn+JafcYDDKZX
         uMxrNx4WhLLYzLzfHGFmq4NajqhWiZ+H7Swm7zj2q+J1R2NmVDaemOJgb38v3lXmkdz0
         4vPw2fDaXpUwXDxJNURiSpFsCdRC/fblT+7RgItfB1+Xms1bCq874/147T6FnbCj4TSa
         b/5NWfovxtYMPxjgB+pRvVNYVT0t4zrsI1lU2udEtS2vawjGlRr48G8y52xGxNYeBher
         Uwr0BRrA1lP2mE6jekFDYOBlfYEshntY/Mb2PYHwnrtVmbT6y9sR/NBwDOSN19I85h4M
         l51w==
X-Gm-Message-State: AJIora9BOKlCOuqBJKTaYl6lKtshAKxTllJPJh8ocKgNzz8hKjAE6lbJ
        Hd3OWM83W2wSw40Uhc3egPte0X+HBt80bQ==
X-Google-Smtp-Source: AGRyM1s1yVQ/C5k1yAOptp/5dEQXfzlsYyXYtgX1YgOum0FJD10YQm7H+iRVCOlZYs3oYrrMww3I2Pvhve4LAQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:5747:0:b0:31d:1bb8:65b7 with SMTP id
 l68-20020a815747000000b0031d1bb865b7mr10620401ywb.168.1658766946528; Mon, 25
 Jul 2022 09:35:46 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:35:39 +0000
In-Reply-To: <20220725163539.3145690-1-dmatlack@google.com>
Message-Id: <20220725163539.3145690-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220725163539.3145690-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [RFC PATCH 2/2] KVM: selftests: Rename perf_test_util symbols to memstress
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        David Matlack <dmatlack@google.com>
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

Replace the perf_test_ prefix on symbol names with memstress_ to match
the new file name. Since memtress contains the same number of characters
as perf_test, there is no impact on line lengths.

While here, also update the "pta" local variables, which was short for
"perf_test_args", to "ma" for "memtest_args".

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  18 ++--
 .../selftests/kvm/demand_paging_test.c        |  18 ++--
 .../selftests/kvm/dirty_log_perf_test.c       |  20 ++--
 .../testing/selftests/kvm/include/memstress.h |  26 ++---
 tools/testing/selftests/kvm/lib/memstress.c   | 100 +++++++++---------
 .../selftests/kvm/lib/x86_64/memstress.c      |  32 +++---
 .../kvm/memslot_modification_stress_test.c    |  14 +--
 7 files changed, 114 insertions(+), 114 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 9c9a78ec9134..9a0fcb15e3fc 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -125,7 +125,7 @@ static void mark_page_idle(int page_idle_fd, uint64_t pfn)
 }
 
 static void mark_vcpu_memory_idle(struct kvm_vm *vm,
-				  struct perf_test_vcpu_args *vcpu_args)
+				  struct memstress_vcpu_args *vcpu_args)
 {
 	int vcpu_idx = vcpu_args->vcpu_idx;
 	uint64_t base_gva = vcpu_args->gva;
@@ -147,7 +147,7 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
 	TEST_ASSERT(pagemap_fd > 0, "Failed to open pagemap.");
 
 	for (page = 0; page < pages; page++) {
-		uint64_t gva = base_gva + page * perf_test_args.guest_page_size;
+		uint64_t gva = base_gva + page * memstress_args.guest_page_size;
 		uint64_t pfn = lookup_pfn(pagemap_fd, vm, gva);
 
 		if (!pfn) {
@@ -213,10 +213,10 @@ static bool spin_wait_for_next_iteration(int *current_iteration)
 	return true;
 }
 
-static void vcpu_thread_main(struct perf_test_vcpu_args *vcpu_args)
+static void vcpu_thread_main(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
-	struct kvm_vm *vm = perf_test_args.vm;
+	struct kvm_vm *vm = memstress_args.vm;
 	int vcpu_idx = vcpu_args->vcpu_idx;
 	int current_iteration = 0;
 
@@ -272,7 +272,7 @@ static void run_iteration(struct kvm_vm *vm, int nr_vcpus, const char *descripti
 static void access_memory(struct kvm_vm *vm, int nr_vcpus,
 			  enum access_type access, const char *description)
 {
-	perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
+	memstress_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
 	iteration_work = ITERATION_ACCESS_MEMORY;
 	run_iteration(vm, nr_vcpus, description);
 }
@@ -296,10 +296,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	int nr_vcpus = params->nr_vcpus;
 
-	vm = perf_test_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
 				 params->backing_src, !overlap_memory_access);
 
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
+	memstress_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
 
 	pr_info("\n");
 	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Populating memory");
@@ -317,8 +317,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Set done to signal the vCPU threads to exit */
 	done = true;
 
-	perf_test_join_vcpu_threads(nr_vcpus);
-	perf_test_destroy_vm(vm);
+	memstress_join_vcpu_threads(nr_vcpus);
+	memstress_destroy_vm(vm);
 }
 
 static void help(char *name)
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 8b53ffeaaa73..35617aceb0aa 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -42,7 +42,7 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 static size_t demand_paging_size;
 static char *guest_data_prototype;
 
-static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
+static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	int vcpu_idx = vcpu_args->vcpu_idx;
@@ -285,7 +285,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	int r, i;
 
-	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
 
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
@@ -307,11 +307,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		TEST_ASSERT(pipefds, "Unable to allocate memory for pipefd");
 
 		for (i = 0; i < nr_vcpus; i++) {
-			struct perf_test_vcpu_args *vcpu_args;
+			struct memstress_vcpu_args *vcpu_args;
 			void *vcpu_hva;
 			void *vcpu_alias;
 
-			vcpu_args = &perf_test_args.vcpu_args[i];
+			vcpu_args = &memstress_args.vcpu_args[i];
 
 			/* Cache the host addresses of the region */
 			vcpu_hva = addr_gpa2hva(vm, vcpu_args->gpa);
@@ -329,17 +329,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 					    pipefds[i * 2], p->uffd_mode,
 					    p->uffd_delay, &uffd_args[i],
 					    vcpu_hva, vcpu_alias,
-					    vcpu_args->pages * perf_test_args.guest_page_size);
+					    vcpu_args->pages * memstress_args.guest_page_size);
 		}
 	}
 
 	pr_info("Finished creating vCPUs and starting uffd threads\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
+	memstress_start_vcpu_threads(nr_vcpus, vcpu_worker);
 	pr_info("Started all vCPUs\n");
 
-	perf_test_join_vcpu_threads(nr_vcpus);
+	memstress_join_vcpu_threads(nr_vcpus);
 	ts_diff = timespec_elapsed(start);
 	pr_info("All vCPU threads joined\n");
 
@@ -358,10 +358,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Total guest execution time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 	pr_info("Overall demand paging rate: %f pgs/sec\n",
-		perf_test_args.vcpu_args[0].pages * nr_vcpus /
+		memstress_args.vcpu_args[0].pages * nr_vcpus /
 		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
 
-	perf_test_destroy_vm(vm);
+	memstress_destroy_vm(vm);
 
 	free(guest_data_prototype);
 	if (p->uffd_mode) {
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 769ab87cadcc..1caf8ddbbc68 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -67,7 +67,7 @@ static bool host_quit;
 static int iteration;
 static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
 
-static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
+static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	int vcpu_idx = vcpu_args->vcpu_idx;
@@ -139,7 +139,7 @@ static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
 	int i;
 
 	for (i = 0; i < slots; i++) {
-		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
+		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
 		int flags = enable ? KVM_MEM_LOG_DIRTY_PAGES : 0;
 
 		vm_mem_region_set_flags(vm, slot, flags);
@@ -161,7 +161,7 @@ static void get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots
 	int i;
 
 	for (i = 0; i < slots; i++) {
-		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
+		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
 
 		kvm_vm_get_dirty_log(vm, slot, bitmaps[i]);
 	}
@@ -173,7 +173,7 @@ static void clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
 	int i;
 
 	for (i = 0; i < slots; i++) {
-		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
+		int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
 
 		kvm_vm_clear_dirty_log(vm, slot, bitmaps[i], 0, pages_per_slot);
 	}
@@ -221,11 +221,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec clear_dirty_log_total = (struct timespec){0};
 	int i;
 
-	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
-	perf_test_set_wr_fract(vm, p->wr_fract);
+	memstress_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -248,7 +248,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	for (i = 0; i < nr_vcpus; i++)
 		vcpu_last_completed_iteration[i] = -1;
 
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
+	memstress_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
 	pr_debug("Starting iteration %d - Populating\n", iteration);
@@ -329,7 +329,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 * wait for them to exit.
 	 */
 	host_quit = true;
-	perf_test_join_vcpu_threads(nr_vcpus);
+	memstress_join_vcpu_threads(nr_vcpus);
 
 	avg = timespec_div(get_dirty_log_total, p->iterations);
 	pr_info("Get dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
@@ -345,7 +345,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	free_bitmaps(bitmaps, p->slots);
 	arch_cleanup_vm(vm);
-	perf_test_destroy_vm(vm);
+	memstress_destroy_vm(vm);
 }
 
 static void help(char *name)
@@ -424,7 +424,7 @@ int main(int argc, char *argv[])
 			guest_modes_cmdline(optarg);
 			break;
 		case 'n':
-			perf_test_args.nested = true;
+			memstress_args.nested = true;
 			break;
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index e72dfb43e456..0f0ac6bc7f28 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -17,9 +17,9 @@
 
 #define DEFAULT_PER_VCPU_MEM_SIZE	(1 << 30) /* 1G */
 
-#define PERF_TEST_MEM_SLOT_INDEX	1
+#define MEMSTRESS_MEM_SLOT_INDEX	1
 
-struct perf_test_vcpu_args {
+struct memstress_vcpu_args {
 	uint64_t gpa;
 	uint64_t gva;
 	uint64_t pages;
@@ -29,7 +29,7 @@ struct perf_test_vcpu_args {
 	int vcpu_idx;
 };
 
-struct perf_test_args {
+struct memstress_args {
 	struct kvm_vm *vm;
 	/* The starting address and size of the guest test region. */
 	uint64_t gpa;
@@ -40,24 +40,24 @@ struct perf_test_args {
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
 
-	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
+	struct memstress_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
 
-extern struct perf_test_args perf_test_args;
+extern struct memstress_args memstress_args;
 
-struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
+struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access);
-void perf_test_destroy_vm(struct kvm_vm *vm);
+void memstress_destroy_vm(struct kvm_vm *vm);
 
-void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void memstress_set_wr_fract(struct kvm_vm *vm, int wr_fract);
 
-void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
-void perf_test_join_vcpu_threads(int vcpus);
-void perf_test_guest_code(uint32_t vcpu_id);
+void memstress_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct memstress_vcpu_args *));
+void memstress_join_vcpu_threads(int vcpus);
+void memstress_guest_code(uint32_t vcpu_id);
 
-uint64_t perf_test_nested_pages(int nr_vcpus);
-void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
+uint64_t memstress_nested_pages(int nr_vcpus);
+void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
 
 #endif /* SELFTEST_KVM_MEMSTRESS_H */
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index d3aea9e4f6a1..6611c72e9923 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -8,7 +8,7 @@
 #include "memstress.h"
 #include "processor.h"
 
-struct perf_test_args perf_test_args;
+struct memstress_args memstress_args;
 
 /*
  * Guest virtual memory offset of the testing memory slot.
@@ -31,7 +31,7 @@ struct vcpu_thread {
 static struct vcpu_thread vcpu_threads[KVM_MAX_VCPUS];
 
 /* The function run by each vCPU thread, as provided by the test. */
-static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
+static void (*vcpu_thread_fn)(struct memstress_vcpu_args *);
 
 /* Set to true once all vCPU threads are up and running. */
 static bool all_vcpu_threads_running;
@@ -42,10 +42,10 @@ static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
  */
-void perf_test_guest_code(uint32_t vcpu_idx)
+void memstress_guest_code(uint32_t vcpu_idx)
 {
-	struct perf_test_args *pta = &perf_test_args;
-	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
+	struct memstress_args *ma = &memstress_args;
+	struct memstress_vcpu_args *vcpu_args = &ma->vcpu_args[vcpu_idx];
 	uint64_t gva;
 	uint64_t pages;
 	int i;
@@ -58,9 +58,9 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * pta->guest_page_size);
+			uint64_t addr = gva + (i * ma->guest_page_size);
 
-			if (i % pta->wr_fract == 0)
+			if (i % ma->wr_fract == 0)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -70,17 +70,17 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	}
 }
 
-void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
+void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 			   struct kvm_vcpu *vcpus[],
 			   uint64_t vcpu_memory_bytes,
 			   bool partition_vcpu_memory_access)
 {
-	struct perf_test_args *pta = &perf_test_args;
-	struct perf_test_vcpu_args *vcpu_args;
+	struct memstress_args *ma = &memstress_args;
+	struct memstress_vcpu_args *vcpu_args;
 	int i;
 
 	for (i = 0; i < nr_vcpus; i++) {
-		vcpu_args = &pta->vcpu_args[i];
+		vcpu_args = &ma->vcpu_args[i];
 
 		vcpu_args->vcpu = vcpus[i];
 		vcpu_args->vcpu_idx = i;
@@ -89,29 +89,29 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 			vcpu_args->gva = guest_test_virt_mem +
 					 (i * vcpu_memory_bytes);
 			vcpu_args->pages = vcpu_memory_bytes /
-					   pta->guest_page_size;
-			vcpu_args->gpa = pta->gpa + (i * vcpu_memory_bytes);
+					   ma->guest_page_size;
+			vcpu_args->gpa = ma->gpa + (i * vcpu_memory_bytes);
 		} else {
 			vcpu_args->gva = guest_test_virt_mem;
 			vcpu_args->pages = (nr_vcpus * vcpu_memory_bytes) /
-					   pta->guest_page_size;
-			vcpu_args->gpa = pta->gpa;
+					   ma->guest_page_size;
+			vcpu_args->gpa = ma->gpa;
 		}
 
 		vcpu_args_set(vcpus[i], 1, i);
 
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
 			 i, vcpu_args->gpa, vcpu_args->gpa +
-			 (vcpu_args->pages * pta->guest_page_size));
+			 (vcpu_args->pages * ma->guest_page_size));
 	}
 }
 
-struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
+struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
 {
-	struct perf_test_args *pta = &perf_test_args;
+	struct memstress_args *ma = &memstress_args;
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages, slot0_pages = 0;
 	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
@@ -121,20 +121,20 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	/* By default vCPUs will write to memory. */
-	pta->wr_fract = 1;
+	ma->wr_fract = 1;
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
 	 * access/dirty pages at the logging granularity.
 	 */
-	pta->guest_page_size = vm_guest_mode_params[mode].page_size;
+	ma->guest_page_size = vm_guest_mode_params[mode].page_size;
 
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
-				(nr_vcpus * vcpu_memory_bytes) / pta->guest_page_size);
+				(nr_vcpus * vcpu_memory_bytes) / ma->guest_page_size);
 
 	TEST_ASSERT(vcpu_memory_bytes % getpagesize() == 0,
 		    "Guest memory size is not host page size aligned.");
-	TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
+	TEST_ASSERT(vcpu_memory_bytes % ma->guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
 	TEST_ASSERT(guest_num_pages % slots == 0,
 		    "Guest memory cannot be evenly divided into %d slots.",
@@ -144,8 +144,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * If using nested, allocate extra pages for the nested page tables and
 	 * in-memory data structures.
 	 */
-	if (pta->nested)
-		slot0_pages += perf_test_nested_pages(nr_vcpus);
+	if (ma->nested)
+		slot0_pages += memstress_nested_pages(nr_vcpus);
 
 	/*
 	 * Pass guest_num_pages to populate the page tables for test memory.
@@ -153,9 +153,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
 	vm = __vm_create_with_vcpus(mode, nr_vcpus, slot0_pages + guest_num_pages,
-				    perf_test_guest_code, vcpus);
+				    memstress_guest_code, vcpus);
 
-	pta->vm = vm;
+	ma->vm = vm;
 
 	/* Put the test region at the top guest physical memory. */
 	region_end_gfn = vm->max_gfn + 1;
@@ -165,8 +165,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * When running vCPUs in L2, restrict the test region to 48 bits to
 	 * avoid needing 5-level page tables to identity map L2.
 	 */
-	if (pta->nested)
-		region_end_gfn = min(region_end_gfn, (1UL << 48) / pta->guest_page_size);
+	if (ma->nested)
+		region_end_gfn = min(region_end_gfn, (1UL << 48) / ma->guest_page_size);
 #endif
 	/*
 	 * If there should be more memory in the guest test region than there
@@ -178,63 +178,63 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 		    " nr_vcpus: %d wss: %" PRIx64 "]\n",
 		    guest_num_pages, region_end_gfn - 1, nr_vcpus, vcpu_memory_bytes);
 
-	pta->gpa = (region_end_gfn - guest_num_pages - 1) * pta->guest_page_size;
-	pta->gpa = align_down(pta->gpa, backing_src_pagesz);
+	ma->gpa = (region_end_gfn - guest_num_pages - 1) * ma->guest_page_size;
+	ma->gpa = align_down(ma->gpa, backing_src_pagesz);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
-	pta->gpa = align_down(pta->gpa, 1 << 20);
+	ma->gpa = align_down(ma->gpa, 1 << 20);
 #endif
-	pta->size = guest_num_pages * pta->guest_page_size;
+	ma->size = guest_num_pages * ma->guest_page_size;
 	pr_info("guest physical test memory: [0x%lx, 0x%lx)\n",
-		pta->gpa, pta->gpa + pta->size);
+		ma->gpa, ma->gpa + ma->size);
 
 	/* Add extra memory slots for testing */
 	for (i = 0; i < slots; i++) {
 		uint64_t region_pages = guest_num_pages / slots;
-		vm_paddr_t region_start = pta->gpa + region_pages * pta->guest_page_size * i;
+		vm_paddr_t region_start = ma->gpa + region_pages * ma->guest_page_size * i;
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
-					    PERF_TEST_MEM_SLOT_INDEX + i,
+					    MEMSTRESS_MEM_SLOT_INDEX + i,
 					    region_pages, 0);
 	}
 
 	/* Do mapping for the demand paging memory slot */
-	virt_map(vm, guest_test_virt_mem, pta->gpa, guest_num_pages);
+	virt_map(vm, guest_test_virt_mem, ma->gpa, guest_num_pages);
 
-	perf_test_setup_vcpus(vm, nr_vcpus, vcpus, vcpu_memory_bytes,
+	memstress_setup_vcpus(vm, nr_vcpus, vcpus, vcpu_memory_bytes,
 			      partition_vcpu_memory_access);
 
-	if (pta->nested) {
+	if (ma->nested) {
 		pr_info("Configuring vCPUs to run in L2 (nested).\n");
-		perf_test_setup_nested(vm, nr_vcpus, vcpus);
+		memstress_setup_nested(vm, nr_vcpus, vcpus);
 	}
 
 	ucall_init(vm, NULL);
 
 	/* Export the shared variables to the guest. */
-	sync_global_to_guest(vm, perf_test_args);
+	sync_global_to_guest(vm, memstress_args);
 
 	return vm;
 }
 
-void perf_test_destroy_vm(struct kvm_vm *vm)
+void memstress_destroy_vm(struct kvm_vm *vm)
 {
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
 }
 
-void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
+void memstress_set_wr_fract(struct kvm_vm *vm, int wr_fract)
 {
-	perf_test_args.wr_fract = wr_fract;
-	sync_global_to_guest(vm, perf_test_args);
+	memstress_args.wr_fract = wr_fract;
+	sync_global_to_guest(vm, memstress_args);
 }
 
-uint64_t __weak perf_test_nested_pages(int nr_vcpus)
+uint64_t __weak memstress_nested_pages(int nr_vcpus)
 {
 	return 0;
 }
 
-void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu **vcpus)
+void __weak memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu **vcpus)
 {
 	pr_info("%s() not support on this architecture, skipping.\n", __func__);
 	exit(KSFT_SKIP);
@@ -255,13 +255,13 @@ static void *vcpu_thread_main(void *data)
 	while (!READ_ONCE(all_vcpu_threads_running))
 		;
 
-	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_idx]);
+	vcpu_thread_fn(&memstress_args.vcpu_args[vcpu->vcpu_idx]);
 
 	return NULL;
 }
 
-void perf_test_start_vcpu_threads(int nr_vcpus,
-				  void (*vcpu_fn)(struct perf_test_vcpu_args *))
+void memstress_start_vcpu_threads(int nr_vcpus,
+				  void (*vcpu_fn)(struct memstress_vcpu_args *))
 {
 	int i;
 
@@ -285,7 +285,7 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
 	WRITE_ONCE(all_vcpu_threads_running, true);
 }
 
-void perf_test_join_vcpu_threads(int nr_vcpus)
+void memstress_join_vcpu_threads(int nr_vcpus)
 {
 	int i;
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/memstress.c b/tools/testing/selftests/kvm/lib/x86_64/memstress.c
index 0bb717ac2cc5..2b3b47e4a973 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/memstress.c
@@ -15,21 +15,21 @@
 #include "processor.h"
 #include "vmx.h"
 
-void perf_test_l2_guest_code(uint64_t vcpu_id)
+void memstress_l2_guest_code(uint64_t vcpu_id)
 {
-	perf_test_guest_code(vcpu_id);
+	memstress_guest_code(vcpu_id);
 	vmcall();
 }
 
-extern char perf_test_l2_guest_entry[];
+extern char memstress_l2_guest_entry[];
 __asm__(
-"perf_test_l2_guest_entry:"
+"memstress_l2_guest_entry:"
 "	mov (%rsp), %rdi;"
-"	call perf_test_l2_guest_code;"
+"	call memstress_l2_guest_code;"
 "	ud2;"
 );
 
-static void perf_test_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
+static void memstress_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
@@ -42,14 +42,14 @@ static void perf_test_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
 
 	rsp = &l2_guest_stack[L2_GUEST_STACK_SIZE - 1];
 	*rsp = vcpu_id;
-	prepare_vmcs(vmx, perf_test_l2_guest_entry, rsp);
+	prepare_vmcs(vmx, memstress_l2_guest_entry, rsp);
 
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
 	GUEST_DONE();
 }
 
-uint64_t perf_test_nested_pages(int nr_vcpus)
+uint64_t memstress_nested_pages(int nr_vcpus)
 {
 	/*
 	 * 513 page tables is enough to identity-map 256 TiB of L2 with 1G
@@ -59,7 +59,7 @@ uint64_t perf_test_nested_pages(int nr_vcpus)
 	return 513 + 10 * nr_vcpus;
 }
 
-void perf_test_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
+void memstress_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 {
 	uint64_t start, end;
 
@@ -72,12 +72,12 @@ void perf_test_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 	 */
 	nested_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
 
-	start = align_down(perf_test_args.gpa, PG_SIZE_1G);
-	end = align_up(perf_test_args.gpa + perf_test_args.size, PG_SIZE_1G);
+	start = align_down(memstress_args.gpa, PG_SIZE_1G);
+	end = align_up(memstress_args.gpa + memstress_args.size, PG_SIZE_1G);
 	nested_identity_map_1g(vmx, vm, start, end - start);
 }
 
-void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
+void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
 {
 	struct vmx_pages *vmx, *vmx0 = NULL;
 	struct kvm_regs regs;
@@ -90,7 +90,7 @@ void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
 
 		if (vcpu_id == 0) {
-			perf_test_setup_ept(vmx, vm);
+			memstress_setup_ept(vmx, vm);
 			vmx0 = vmx;
 		} else {
 			/* Share the same EPT table across all vCPUs. */
@@ -100,11 +100,11 @@ void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 		}
 
 		/*
-		 * Override the vCPU to run perf_test_l1_guest_code() which will
-		 * bounce it into L2 before calling perf_test_guest_code().
+		 * Override the vCPU to run memstress_l1_guest_code() which will
+		 * bounce it into L2 before calling memstress_guest_code().
 		 */
 		vcpu_regs_get(vcpus[vcpu_id], &regs);
-		regs.rip = (unsigned long) perf_test_l1_guest_code;
+		regs.rip = (unsigned long) memstress_l1_guest_code;
 		vcpu_regs_set(vcpus[vcpu_id], &regs);
 		vcpu_args_set(vcpus[vcpu_id], 2, vmx_gva, vcpu_id);
 	}
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index edee00eff7c4..dd989867fb44 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -36,7 +36,7 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 static bool run_vcpus = true;
 
-static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
+static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	struct kvm_run *run;
@@ -72,10 +72,10 @@ static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 	int i;
 
 	/*
-	 * Add the dummy memslot just below the perf_test_util memslot, which is
+	 * Add the dummy memslot just below the memstress memslot, which is
 	 * at the top of the guest physical address space.
 	 */
-	gpa = perf_test_args.gpa - pages * vm->page_size;
+	gpa = memstress_args.gpa - pages * vm->page_size;
 
 	for (i = 0; i < nr_modifications; i++) {
 		usleep(delay);
@@ -97,13 +97,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = arg;
 	struct kvm_vm *vm;
 
-	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
 
 	pr_info("Finished creating vCPUs\n");
 
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
+	memstress_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	pr_info("Started all vCPUs\n");
 
@@ -112,10 +112,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	run_vcpus = false;
 
-	perf_test_join_vcpu_threads(nr_vcpus);
+	memstress_join_vcpu_threads(nr_vcpus);
 	pr_info("All vCPU threads joined\n");
 
-	perf_test_destroy_vm(vm);
+	memstress_destroy_vm(vm);
 }
 
 static void help(char *name)
-- 
2.37.1.359.gd136c6c3e2-goog

