Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B90C5B380A
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiIIMnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 08:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbiIIMnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 08:43:04 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88EDE22AA
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 05:43:02 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id c7-20020a056e020bc700b002e59be6ce85so1125170ilu.12
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 05:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=+cGIHyyO/TObOL7RYYQROdZlDl2AFQdBqWIubWPNzGw=;
        b=L/IAeuC6iOYy/ATBkN+2mrAZ0AeQVgwkX07qBYe6mgpQI1vzc9krJCvnnDElBR7484
         sYwqJ0IJxawovSovUOc3efEcEfUOP7MzAwxDSlJPxHTO5Vi0r21pGGsM32b98u7HNQ8K
         HD69NcySu7nkfDzfPBA4ZZK85Zqs6sf/5qx1PW77nAWsFaO+srTamdk85rwh1n95b1O3
         9qIXMkADLPUtDzjDXVrLWlKov1wsYzBIFiOQj52Ch6H79m5yS+KB+CCyv1MBVY88hsHv
         PGC4vRS2fKDXEeRnVcCgZJw1kBcmj6ttY/ezacMm7M8jhG7JqQBuCZo9rfPd8ltvk18X
         AGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=+cGIHyyO/TObOL7RYYQROdZlDl2AFQdBqWIubWPNzGw=;
        b=e6LuJF2Ur5pFAEB2gbeuVyM/eRMB+PkTOq8h4MBQRqQiOWCRFvcHifBWEGVGDCc6Nn
         E+Ef5WqmkKORjUqQyPktJti32JHcu1rW6bvomJ6A+Q2oFpw8nnc7Lu13kHa1R4MfMKhz
         +hRxzcNFKhP5rEOdLWC2rEZNdbVlG522a/cqMXEzKEHys+VRfKooBz6k3sWuiLEht8C5
         QR098MhDDj0HaYRGx6xtBqihSOGhAR2p47e5JfuDAfHlfX036G0hY3Woys66BBKQuTRo
         5PnHjyurP31ltWLVbmWTW4CdZ0lVzLXBcg9AzKYm8yrfqxXnClSZTVQvGQjGsr1k5278
         3Z7g==
X-Gm-Message-State: ACgBeo1iNvdnfBSTLineWJio6klhkcO4KR1+TeYMpMbR4WyW0Ji5eNEb
        WSF5KVE6jjBdOBh9Y8oKl+bTdiRhfTU660rCjOWLYNtaHPuE5SuHWeElEC3lj+AUBhgS2H/K0Q2
        YeEM1+zF0x/xkgAuX9QhMk/p1AbujmiHCC2Berui+g5Zn7UmqW/pKRd133lcdpRxGfZXbSlc=
X-Google-Smtp-Source: AA6agR40+uxXYn6e0ajQyeoeGxbQyG+VOqh5t35xj8Fm0v0JswBLy7rYc98ItA5pJqUpVUAxpfQIpoem3XstmrL13g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:6219:0:b0:689:7d47:4fe8 with SMTP
 id f25-20020a6b6219000000b006897d474fe8mr6325926iog.39.1662727382214; Fri, 09
 Sep 2022 05:43:02 -0700 (PDT)
Date:   Fri,  9 Sep 2022 12:42:58 +0000
In-Reply-To: <20220909124300.3409187-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220909124300.3409187-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909124300.3409187-2-coltonlewis@google.com>
Subject: [PATCH v5 1/3] KVM: selftests: implement random number generation for
 guest code
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev, Colton Lewis <coltonlewis@google.com>
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
provided, the seed defaults to the current Unix timestamp. The random
seed is set with perf_test_set_random_seed() and must be set before
guest_code runs to apply.

The random number generator chosen is the Park-Miller Linear
Congruential Generator, a fancy name for a basic and well-understood
random number generator entirely sufficient for this purpose. Each
vCPU calculates its own seed by adding its index to the seed provided.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c    | 12 ++++++++++--
 tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
 tools/testing/selftests/kvm/include/test_util.h      |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c     | 11 ++++++++++-
 tools/testing/selftests/kvm/lib/test_util.c          |  9 +++++++++
 5 files changed, 33 insertions(+), 3 deletions(-)

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
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 99e0dcdc923f..2dd286bcf46f 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
 	return (void *)align_up((unsigned long)x, size);
 }
 
+void guest_random(uint32_t *seed);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index f989ff91f022..4d9c7d7693d9 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -47,6 +47,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 	uint64_t gva;
 	uint64_t pages;
 	int i;
+	uint32_t rand = pta->random_seed + vcpu_id;
 
 	/* Make sure vCPU args data structure is not corrupt. */
 	GUEST_ASSERT(vcpu_args->vcpu_id == vcpu_id);
@@ -57,6 +58,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 	while (true) {
 		for (i = 0; i < pages; i++) {
 			uint64_t addr = gva + (i * pta->guest_page_size);
+			guest_random(&rand);
 
 			if (i % pta->wr_fract == 0)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
@@ -115,8 +117,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	/* By default vCPUs will write to memory. */
+	/* Set perf_test_args defaults. */
 	pta->wr_fract = 1;
+	pta->random_seed = time(NULL);
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
@@ -224,6 +227,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
 	sync_global_to_guest(vm, perf_test_args);
 }
 
+void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
+{
+	perf_test_args.random_seed = random_seed;
+	sync_global_to_guest(vm, perf_test_args.random_seed);
+}
+
 uint64_t __weak perf_test_nested_pages(int nr_vcpus)
 {
 	return 0;
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 6d23878bbfe1..28c895743abe 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -17,6 +17,15 @@
 
 #include "test_util.h"
 
+/*
+ * Random number generator that is usable from guest code. This is the
+ * Park-Miller LCG using standard constants.
+ */
+void guest_random(uint32_t *seed)
+{
+	*seed = (uint64_t)*seed * 48271 % ((uint32_t)(1 << 31) - 1);
+}
+
 /*
  * Parses "[0-9]+[kmgt]?".
  */
-- 
2.37.2.789.g6183377224-goog

