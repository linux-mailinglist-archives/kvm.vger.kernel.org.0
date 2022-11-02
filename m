Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C076166CA
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiKBQA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiKBQAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:00:18 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BA02C108
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:00:17 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so14436151ioz.8
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2NSz2J2sab68LtkPmC+v+ZsP/7tXhLhAVB/Asurj7c4=;
        b=SsClpNQViWdfyG14ZshlEfjZxZRGHinXGrfKcl1YBvX4gheCJ4rPeY4+ON9GTb7EY8
         AsB4F7RUq7hXeVZVaJ/Qw3tgBE7DE77ftxyksgjDFfI2mwd9LhlvxDT67159epJJlDPe
         vV3XvuoewASiX0TjCLwanOhSYn4yml3O420SfzlK1FMzc7+cbAUiSDu9C6tWpaM6nkwq
         raTK7XG4KLPa80nNwthz6Rw8VMBQiytCt0m72xttt5UYqEecP87CTFT3ybciZ/ynRTF+
         kCye+T8s6+3Sx3/vpfV8yWTRQYmqoGh1Ur5tHsQ5SJZr6jVlmfpoLfe2sPfCxZPW8ZC1
         YqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2NSz2J2sab68LtkPmC+v+ZsP/7tXhLhAVB/Asurj7c4=;
        b=VXd5s3bw4dwJUnAC3IH00/u4EOaFioxVaC2ku5CRoQyattKzDHmU4W769GgduuFHdY
         duNt0eBlggegXdQqxYS9O7AlSWhEMdnAey0O+1MBCooDR6nmAwON6rDQ1+03gSdK2/1/
         GLowRH9wHLnqnZEeIJWQBvjr1S5ST8KWJXEsNJx0gaQ5m/oWUnJUqpeCbNhDhVBMMDge
         1n5bRL49p/htkA9j/mvk0GsY/3RrSe1PEQ5PRszOB9lq/o7/kkmoThhxMa07FXyvUA9J
         GuZx7FX+hjVvALdIFomeR7qfWHnmSGWLMDCElVmt3krOxuowws9GgESF4HT++vJxalOa
         fx9A==
X-Gm-Message-State: ACrzQf0dpoChzBfIfVzfuM6sPQkGMHCD48br22GsGiAHIaFklbXfxbs2
        OoSaVDuuf/MTJFt31oxHmmp0vEc/ptqsKEmw2fgZSuwIV7H5inGZgW9MhQWdvVHsc6SjZWbDYik
        tUVNmqgHUNnvvszUhkrQ7ESuHkXlQQtPdVB4bJFxxXCI/KNMTzjw4eAb+WRtvH+ssw27+BsA=
X-Google-Smtp-Source: AMsMyM5TYxgbxTY6X0W2aChpKjvOpG/8TEbqrWP5ysPQ1MAeGjQmONVzFQfvCssndkCI+CgRVt4ul0kLw33E3NhpFQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:388c:b0:370:cb35:edfd with
 SMTP id b12-20020a056638388c00b00370cb35edfdmr16274609jav.181.1667404817024;
 Wed, 02 Nov 2022 09:00:17 -0700 (PDT)
Date:   Wed,  2 Nov 2022 16:00:06 +0000
In-Reply-To: <20221102160007.1279193-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221102160007.1279193-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102160007.1279193-4-coltonlewis@google.com>
Subject: [PATCH v9 3/4] KVM: selftests: randomize which pages are written vs read
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

Signed-off-by: Colton Lewis <coltonlewis@google.com>
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
index c97a5e455699..0d0240041acf 100644
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
 
@@ -229,7 +229,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* If no argument provided, random seed will be 1. */
 	pr_info("Random seed: %u\n", p->random_seed);
 	perf_test_set_random_seed(vm, p->random_seed ? p->random_seed : 1);
-	perf_test_set_wr_fract(vm, p->wr_fract);
+	perf_test_set_write_percent(vm, p->write_percent);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -252,6 +252,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -273,6 +281,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+	perf_test_set_write_percent(vm, p->write_percent);
+
 	while (iteration < p->iterations) {
 		/*
 		 * Incrementing the iteration number will start the vCPUs
@@ -357,7 +367,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
-	       "[-x memslots]\n", name);
+	       "[-x memslots] [-w percentage]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -377,10 +387,6 @@ static void help(char *name)
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
@@ -388,6 +394,11 @@ static void help(char *name)
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
@@ -397,10 +408,10 @@ int main(int argc, char *argv[])
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
 	struct test_params p = {
 		.iterations = TEST_HOST_LOOP_N,
-		.wr_fract = 1,
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
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
2.38.1.273.g43a17bfeac-goog

