Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D665AA06F
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 21:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiIATxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 15:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiIATxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 15:53:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130A348E90
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 12:53:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k13-20020a056902024d00b0066fa7f50b97so149495ybs.6
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 12:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=aiiR1f5HT2KwdSEXkCHOjWutBiHpk8ptJjVqoHC6U8U=;
        b=aM5ik92ut913qOU6oSuspzsrwCODfgTfhuaqNFxPLylNOYm9AE4xxNcnZOczE6G9YQ
         di1JvRXcZqYMZKm9UX1GXcpQmPvMH3yIFRAiKL0jJdcGUmrsRY7DzmWLWKqXi27CQkgu
         9Riqeio3R69bWLIqGjIni8ElKRtTjRLKNxLzVwh4phoaw6o0Z1waiPBCMFhAPRzNH/Sw
         V7M17F0K8651TmxGA9ItiKvzTxA7i34jiFboeC+1j1LiWHRUqI4s3wy/aEZly86QJy8l
         i7xSmIf4+4nx7DSLAscjGibyCq1O6ov6ICqTjHQc/W5GTW4d+KuhF5s21nP6fcbHmlve
         TMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=aiiR1f5HT2KwdSEXkCHOjWutBiHpk8ptJjVqoHC6U8U=;
        b=wEGtycSG8I4iOuCxNrM5rj8wpbeKQQBZEkIQsuxe2wntSYwAYvLKQZuSL5XeBFD/ie
         wYIXF+A6Ae+1n1W8mOEjzGusHWhNiCwjgLGhjlSyv07k1/+mR6APnwWPfd/5b6WmQG/z
         2C+4yI7daWUXwatgSp6RBaVykpcD7i4S39X5oWn9ZZRsOMoVOVZWAcNuuSxBfC39BqE0
         EAapekTnRK2qEa5ySlXl5MInB692JNXXoUkOUT6kueVzXzJ2Gk4yosBLuEvy8B3a7lhq
         bW4ftEXnFQs4N3LOClLwVu53eXadr1Qa8prdqZvudkhYBzdtbBYwOUxggdpRx0Scz65Q
         uSYg==
X-Gm-Message-State: ACgBeo34tTyCgoYLcIF/ELSBP+nWU3zo0bywJDoF2W1BNNXxKBr9NSuj
        QTrwnju8EShP9zUkp8wNDk/CTRprr0N9XvZ395svUw8KSSMikzeHTtbavpVonelAOx5SqtgtXW1
        imKXxT66dBBJo7Uc/SQ1uDEGYw2jV+QDB0yGRQxeBr9BaO4PHk5xdfPI7LQaiWP+5BfuDSTM=
X-Google-Smtp-Source: AA6agR7Mp2KEYFd1P3hMU3iGOC3mF/Vb6kHeg7hMMUydNjayESuuW8LtEhr+ggmwDZiv6boAM671t9Ee09le2bAblA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:120f:b0:6a1:f220:5ace with
 SMTP id s15-20020a056902120f00b006a1f2205acemr2565600ybu.141.1662061979310;
 Thu, 01 Sep 2022 12:52:59 -0700 (PDT)
Date:   Thu,  1 Sep 2022 19:52:35 +0000
In-Reply-To: <20220901195237.2152238-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220901195237.2152238-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220901195237.2152238-2-coltonlewis@google.com>
Subject: [PATCH v3 1/3] KVM: selftests: Implement random number generation for
 guest code.
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
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

Implement random number generation for guest code to randomize parts
of the test, making it less predictable and a more accurate reflection
of reality.

Create a -r argument to specify a random seed. If no argument is
provided, the seed defaults to the current Unix timestamp.

The random number generator chosen is the Park-Miller Linear
Congruential Generator, a fancy name for a basic and well-understood
random number generator entirely sufficient for this purpose. Each
vCPU calculates its own seed by adding its index to the seed provided.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c        | 12 ++++++++++--
 .../selftests/kvm/include/perf_test_util.h     |  2 ++
 .../testing/selftests/kvm/lib/perf_test_util.c | 18 +++++++++++++++++-
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index d60a34cdfaee..2f91acd94130 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -126,6 +126,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	uint32_t random_seed;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -220,6 +221,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
+	pr_info("Random seed: %u\n", p->random_seed);
+	perf_test_set_random_seed(vm, p->random_seed);
 	perf_test_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
@@ -337,7 +340,7 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
-	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
+	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
 	       "[-x memslots]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
@@ -362,6 +365,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -r: specify the starting random seed.\n");
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
@@ -378,6 +382,7 @@ int main(int argc, char *argv[])
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
+		.random_seed = time(NULL),
 	};
 	int opt;
 
@@ -388,7 +393,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
 		switch (opt) {
 		case 'g':
 			dirty_log_manual_caps = 0;
@@ -421,6 +426,9 @@ int main(int argc, char *argv[])
 		case 'o':
 			p.partition_vcpu_memory_access = false;
 			break;
+		case 'r':
+			p.random_seed = atoi(optarg);
+			break;
 		case 's':
 			p.backing_src = parse_backing_src_type(optarg);
 			break;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index d822cb670f1c..f18530984b42 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -34,6 +34,7 @@ struct perf_test_args {
 	uint64_t gpa;
 	uint64_t size;
 	uint64_t guest_page_size;
+	uint32_t random_seed;
 	int wr_fract;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
@@ -51,6 +52,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index f989ff91f022..1292ed7d1193 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -36,6 +36,13 @@ static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
 /* Set to true once all vCPU threads are up and running. */
 static bool all_vcpu_threads_running;
 
+
+/* Park-Miller LCG using standard constants */
+static uint32_t perf_test_random(uint32_t seed)
+{
+	return (uint64_t)seed * 48271 % ((uint32_t)(1 << 31) - 1);
+}
+
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
@@ -47,6 +54,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 	uint64_t gva;
 	uint64_t pages;
 	int i;
+	uint32_t rand = pta->random_seed + vcpu_id;
 
 	/* Make sure vCPU args data structure is not corrupt. */
 	GUEST_ASSERT(vcpu_args->vcpu_id == vcpu_id);
@@ -56,6 +64,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
+			rand = perf_test_random(rand);
 			uint64_t addr = gva + (i * pta->guest_page_size);
 
 			if (i % pta->wr_fract == 0)
@@ -115,8 +124,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	/* By default vCPUs will write to memory. */
+	/* Set perf_test_args defaults. */
 	pta->wr_fract = 1;
+	pta->random_seed = time(NULL);
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
@@ -224,6 +234,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
 	sync_global_to_guest(vm, perf_test_args);
 }
 
+void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
+{
+	perf_test_args.random_seed = random_seed;
+	sync_global_to_guest(vm, perf_test_args);
+}
+
 uint64_t __weak perf_test_nested_pages(int nr_vcpus)
 {
 	return 0;
-- 
2.37.2.789.g6183377224-goog

