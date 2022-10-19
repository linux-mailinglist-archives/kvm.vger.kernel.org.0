Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFB66052DC
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 00:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiJSWNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 18:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiJSWNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 18:13:51 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EAA48A30
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:13:50 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so14576648ioz.8
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zHCN1NpOBIjvJ3dOyBokgsfXrMU3XntQ/lV2trTRMnY=;
        b=AIsEXGNHQkLZcACXCjLRLHw7oAbFXTYbBeqOJgK86yQyNBsZdBjGgkwMxJpMwW9v6I
         k2xYRrNC6r2Z7rN/8fBisMgGQ0gD2ayzcGpfeLWztaTThcS3RNYS1bNNjuylSsmqN2S1
         IZuUv2SGEpxQQCotnFdpUu1K+R+Jev8Y9AC/K7IDJcspV2DHStWcA0ZQo0v0bj7kkwDX
         iCuGFEQV89hTIvWVhUd13viqOF1Q5kghfcJ0kDsXi5nAO4c/RXhLfzFMG4FQU3u+oaQD
         DooGaBtN5pJPshkxA1uNA/F5ETYze+qwJUJNhQAS/mR+G35XMTLU2dSGxEm4alMfucMv
         lPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zHCN1NpOBIjvJ3dOyBokgsfXrMU3XntQ/lV2trTRMnY=;
        b=UfMDLahPuW+KDu7+WmXcPUaF+ASf7PTSMnPlqYbPJkJeflGkjoNM87IupYH4m4sBO1
         kkH493Eqs90+EAOoCSHgbZAydG3kZQs0jazZAHsU29ovfcES9VGo7rmKSJfM1z+4CFWz
         2EWN0bKgNTT3IpIUzLgI7dM2rO+0ETo4lQxBfKDkv8yWBFxQLq8qFHDNwlskSwikGIvv
         wPPiAAAULBW5M3P1kZTqf4eBv8Hb1sSchmF9JvAPT7hjIJRNE6TRXADUYWUlibZyNE6U
         IIXs4C6CypdqgM8z4asNlHsOvO8kx4dRzT784DaqoJQqRtoIFEbjbpoDy1qrW6LCckrn
         ZdvA==
X-Gm-Message-State: ACrzQf0JH2HsX+S89Qrkf4yeaeKCdwZ7lEKPapcHlTtd0xRxTwx0AiC5
        FTbUKXXweFuIKwLbjjeYAo05/8VR3CTjry5/MixxtuUAEp3gT7pA5K4HboX355V2qQ5oqPtK+Cx
        Js1sRiKNP4lg7xGC85nbQ1nzI12mGSya2UuFmztX3FhrwYuhzlBvFSV3COGmUdramFF21zlk=
X-Google-Smtp-Source: AMsMyM5IkMUEqTmtYSOBcyBAbmzwb+lHabB7pE8dcVcKiHudSYY25OINRJBF/cNwmTxCfonAzvMwa9Emlr/grB4r+Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1054:b0:2fa:a73:cfa1 with
 SMTP id p20-20020a056e02105400b002fa0a73cfa1mr7717158ilj.203.1666217629728;
 Wed, 19 Oct 2022 15:13:49 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:13:19 +0000
In-Reply-To: <20221019221321.3033920-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221019221321.3033920-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019221321.3033920-2-coltonlewis@google.com>
Subject: [PATCH v7 1/3] KVM: selftests: implement random number generation for
 guest code
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

Implement random number generation for guest code to randomize parts
of the test, making it less predictable and a more accurate reflection
of reality.

Create a -r argument to specify a random seed. If no argument is
provided, the seed defaults to 0. The random seed is set with
perf_test_set_random_seed() and must be set before guest_code runs to
apply.

The random number generator chosen is the Park-Miller Linear
Congruential Generator, a fancy name for a basic and well-understood
random number generator entirely sufficient for this purpose. Each
vCPU calculates its own seed by adding its index to the seed provided.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/kvm/dirty_log_perf_test.c | 12 ++++++++++--
 .../selftests/kvm/include/perf_test_util.h      |  2 ++
 tools/testing/selftests/kvm/include/test_util.h |  7 +++++++
 .../testing/selftests/kvm/lib/perf_test_util.c  |  7 +++++++
 tools/testing/selftests/kvm/lib/test_util.c     | 17 +++++++++++++++++
 5 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..c97a5e455699 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -132,6 +132,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	uint32_t random_seed;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -225,6 +226,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
+	/* If no argument provided, random seed will be 1. */
+	pr_info("Random seed: %u\n", p->random_seed);
+	perf_test_set_random_seed(vm, p->random_seed ? p->random_seed : 1);
 	perf_test_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
@@ -352,7 +356,7 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
-	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
+	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
 	       "[-x memslots]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
@@ -380,6 +384,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -r: specify the starting random seed.\n");
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
@@ -406,7 +411,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
 		switch (opt) {
 		case 'e':
 			/* 'e' is for evil. */
@@ -442,6 +447,9 @@ int main(int argc, char *argv[])
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
index eaa88df0555a..f1050fd42d10 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -35,6 +35,7 @@ struct perf_test_args {
 	uint64_t gpa;
 	uint64_t size;
 	uint64_t guest_page_size;
+	uint32_t random_seed;
 	int wr_fract;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
@@ -52,6 +53,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index befc754ce9b3..9e4f36a1a8b0 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -152,4 +152,11 @@ static inline void *align_ptr_up(void *x, size_t size)
 	return (void *)align_up((unsigned long)x, size);
 }
 
+struct guest_random_state {
+	uint32_t seed;
+};
+
+struct guest_random_state new_guest_random_state(uint32_t seed);
+uint32_t guest_random_u32(struct guest_random_state *state);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..5f0eebb626b5 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -49,6 +49,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	uint64_t gva;
 	uint64_t pages;
 	int i;
+	struct guest_random_state rand_state = new_guest_random_state(pta->random_seed + vcpu_idx);
 
 	gva = vcpu_args->gva;
 	pages = vcpu_args->pages;
@@ -229,6 +230,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
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
index 6d23878bbfe1..c4d2749fb2c3 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -17,6 +17,23 @@
 
 #include "test_util.h"
 
+/*
+ * Random number generator that is usable from guest code. This is the
+ * Park-Miller LCG using standard constants.
+ */
+
+struct guest_random_state new_guest_random_state(uint32_t seed)
+{
+	struct guest_random_state s = {.seed = seed};
+	return s;
+}
+
+uint32_t guest_random_u32(struct guest_random_state *state)
+{
+	state->seed = (uint64_t)state->seed * 48271 % ((uint32_t)(1 << 31) - 1);
+	return state->seed;
+}
+
 /*
  * Parses "[0-9]+[kmgt]?".
  */
-- 
2.38.0.413.g74048e4d9e-goog

