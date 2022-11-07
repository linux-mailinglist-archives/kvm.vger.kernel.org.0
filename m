Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAFD61FD5B
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiKGSWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiKGSWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:22:37 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859771118
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:22:35 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36fc0644f51so115047477b3.17
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UCmXKpIYK2jDAtwwusb7rCkxaR7huRvuHuLP+E7RSxA=;
        b=NdFxpGjaQt/wCFKovrfNt9+7TFTktuX7BuItxvagYjkB8YTPjhvKJ8c/TlsdhFzKQv
         eUIuxTzOWb+ysAaxcOY+SsRZ+uvxztzWjmV5NI01zk4npRzLsqtWh8hGbQz0oJxAmJyp
         kQwM4Bg7KmWOwswSsfFVrQmvmcS7R5NZSGDtYsxSo76Lr0jbT6iL4d/dp923+Sz/dymo
         OOAHas013HE1GzARKTWS+sN6B0TvZCNbnpEFOusHt+Un0rtoGe75/2A+hHETiLt1oJpa
         1LjGtBejQRdlNP6yUhgcm3o1OFPxQqDmLKkvQoSW274bdsG0jBRZJiqdstKjNQE49OeN
         M+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCmXKpIYK2jDAtwwusb7rCkxaR7huRvuHuLP+E7RSxA=;
        b=m7t2XiZrw7OkHqPLK2NXfLgK58RlBINa5v8K3qxtT3x0alH9tVjJ/MhFNbvRLjMwu0
         VOdccNJT1BuemxjLz5sK4V8NI6Ao1r2AinPzMgwKxmrqq1xYwa5Mw4gb3shFoM93qSVe
         2A9O/NwZhVn0aSIiw4wfjR38HOmWzx29K7fA/VtR1UVHInyHbb6g3i+bE9RtnzkDfj8S
         eBIU18lxxXBgOt0/JNQ+tJYfOidcLooKEjYinVBszpnqa2t1OHfHyL/Nif40s04xsIG2
         8NSyMtdHZ8+KsPHtNwQCCsnuq3b1MpmQmDQgjrM025FFu6HS41C9P8PrAj+g6jEXGONs
         91gA==
X-Gm-Message-State: ACrzQf0jirM19wmQMGKM8y+VaI9OBPRcc3DrLX2EMcP5QJlry9EBnv8M
        Jes6lPXI83I5sTmW8Q8Dyg//sNLrUQbP7imxI2pMftLugRcoyayWBn55Zfd3fr9fDr9lPvgEfVa
        opRWD1h0neRZ7rjJ2Rqn+/zGw8VSwr4h89W3OX0BBMqFTTyOKSZ8Le3asvsuZgeYCqf6I4Cw=
X-Google-Smtp-Source: AMsMyM5Kx4mh2yYlOZ7S8Ane+15Y6L4tJ8NUTmvTMvThU0LUwNcu67+XmljAgTQ4UrZiXbb/RxAGfcHrZM5nvcB+Eg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:5344:0:b0:360:9535:bde3 with SMTP
 id h65-20020a815344000000b003609535bde3mr49924850ywb.344.1667845354765; Mon,
 07 Nov 2022 10:22:34 -0800 (PST)
Date:   Mon,  7 Nov 2022 18:22:07 +0000
In-Reply-To: <20221107182208.479157-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221107182208.479157-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221107182208.479157-4-coltonlewis@google.com>
Subject: [PATCH v10 3/4] KVM: selftests: randomize which pages are written vs read
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
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

Randomize which pages are written vs read using the random number
generator.

Change the variable wr_fract and associated function calls to
write_percent that now operates as a percentage from 0 to 100 where X
means each page has an X% chance of being written. Change the -f
argument to -w to reflect the new variable semantics. Keep the same
default of 100% writes.

Population always uses 100% writes to ensure all memory is actually
populated and not just mapped to the zero page. The prevents expensive
copy-on-write faults from occurring during the dirty memory iterations
below, which would pollute the performance results.

Each vCPU calculates its own random seed by adding its index to the
seed provided.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 38 ++++++++++++-------
 .../selftests/kvm/include/perf_test_util.h    |  4 +-
 .../selftests/kvm/lib/perf_test_util.c        | 12 +++---
 4 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 76c583a07ea2..3e16d5bd7856 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -279,7 +279,7 @@ static void run_iteration(struct kvm_vm *vm, int nr_vcpus, const char *descripti
 static void access_memory(struct kvm_vm *vm, int nr_vcpus,
 			  enum access_type access, const char *description)
 {
-	perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
+	perf_test_set_write_percent(vm, (access == ACCESS_READ) ? 0 : 100);
 	iteration_work = ITERATION_ACCESS_MEMORY;
 	run_iteration(vm, nr_vcpus, description);
 }
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f74a78138df3..a78c617ea2b4 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -128,10 +128,10 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 struct test_params {
 	unsigned long iterations;
 	uint64_t phys_offset;
-	int wr_fract;
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	uint32_t write_percent;
 	uint32_t random_seed;
 };
 
@@ -228,7 +228,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pr_info("Random seed: %u\n", p->random_seed);
 	perf_test_set_random_seed(vm, p->random_seed);
-	perf_test_set_wr_fract(vm, p->wr_fract);
+	perf_test_set_write_percent(vm, p->write_percent);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -251,6 +251,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	for (i = 0; i < nr_vcpus; i++)
 		vcpu_last_completed_iteration[i] = -1;
 
+	/*
+	 * Use 100% writes during the population phase to ensure all
+	 * memory is actually populated and not just mapped to the zero
+	 * page. The prevents expensive copy-on-write faults from
+	 * occurring during the dirty memory iterations below, which
+	 * would pollute the performance results.
+	 */
+	perf_test_set_write_percent(vm, 100);
 	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
@@ -272,6 +280,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+	perf_test_set_write_percent(vm, p->write_percent);
+
 	while (iteration < p->iterations) {
 		/*
 		 * Incrementing the iteration number will start the vCPUs
@@ -356,7 +366,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
-	       "[-x memslots]\n", name);
+	       "[-x memslots] [-w percentage]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -376,10 +386,6 @@ static void help(char *name)
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
 	       "     (default: 1G)\n");
-	printf(" -f: specify the fraction of pages which should be written to\n"
-	       "     as opposed to simply read, in the form\n"
-	       "     1/<fraction of pages to write>.\n"
-	       "     (default: 1 i.e. all pages are written to.)\n");
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
@@ -387,6 +393,11 @@ static void help(char *name)
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
+	printf(" -w: specify the percentage of pages which should be written to\n"
+	       "     as an integer from 0-100 inclusive. This is probabalistic,\n"
+	       "     so -w X means each page has an X%% chance of writing\n"
+	       "     and a (100-X)%% chance of reading.\n"
+	       "     (default: 100 i.e. all pages are written to.)\n");
 	puts("");
 	exit(0);
 }
@@ -396,11 +407,11 @@ int main(int argc, char *argv[])
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
 	struct test_params p = {
 		.iterations = TEST_HOST_LOOP_N,
-		.wr_fract = 1,
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
 		.random_seed = 1,
+		.write_percent = 100,
 	};
 	int opt;
 
@@ -411,7 +422,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "eghi:p:m:nb:v:or:s:x:w:")) != -1) {
 		switch (opt) {
 		case 'e':
 			/* 'e' is for evil. */
@@ -434,10 +445,11 @@ int main(int argc, char *argv[])
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
-		case 'f':
-			p.wr_fract = atoi(optarg);
-			TEST_ASSERT(p.wr_fract >= 1,
-				    "Write fraction cannot be less than one");
+		case 'w':
+			p.write_percent = atoi(optarg);
+			TEST_ASSERT(p.write_percent >= 0
+				    && p.write_percent <= 100,
+				    "Write percentage must be between 0 and 100");
 			break;
 		case 'v':
 			nr_vcpus = atoi(optarg);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index f1050fd42d10..845165001ec8 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -36,7 +36,7 @@ struct perf_test_args {
 	uint64_t size;
 	uint64_t guest_page_size;
 	uint32_t random_seed;
-	int wr_fract;
+	uint32_t write_percent;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
@@ -52,7 +52,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   bool partition_vcpu_memory_access);
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
-void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
 void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 0bb0659b9a0d..92b47f71a0a5 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -49,6 +49,8 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	uint64_t gva;
 	uint64_t pages;
 	int i;
+	struct guest_random_state rand_state =
+		new_guest_random_state(pta->random_seed + vcpu_idx);
 
 	gva = vcpu_args->gva;
 	pages = vcpu_args->pages;
@@ -60,7 +62,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 		for (i = 0; i < pages; i++) {
 			uint64_t addr = gva + (i * pta->guest_page_size);
 
-			if (i % pta->wr_fract == 0)
+			if (guest_random_u32(&rand_state) % 100 < pta->write_percent)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -121,7 +123,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	/* By default vCPUs will write to memory. */
-	pta->wr_fract = 1;
+	pta->write_percent = 100;
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
@@ -223,10 +225,10 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
 	kvm_vm_free(vm);
 }
 
-void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
+void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent)
 {
-	perf_test_args.wr_fract = wr_fract;
-	sync_global_to_guest(vm, perf_test_args);
+	perf_test_args.write_percent = write_percent;
+	sync_global_to_guest(vm, perf_test_args.write_percent);
 }
 
 void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
-- 
2.38.1.431.g37b22c650d-goog

