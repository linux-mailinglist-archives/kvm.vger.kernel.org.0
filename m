Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EF859790E
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 23:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238436AbiHQVmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 17:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiHQVmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 17:42:19 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1025A7AA6
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:42:18 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id z30-20020a05660217de00b00688bd42dc1dso3319974iox.15
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=fyTRrNfvfx7kQKbQTujWp6z2VNyweYkMPBwA6/c3HSs=;
        b=YpsejDrEcD1JWYzwaN2iVX8qsBy7cfCtjfswlOLxBiTmnwL8xbomqLSOWtjzLA3VhW
         mq9xkXcs2UiS66Ort6VoF8fqk8UzvzVYaSfPDagTVmreW6hoFpFI+QKWQvzMrKS04Joi
         ewo9+qY47o0zRCcOtYbTe4uzkijMQJ/0FAe9HBOMCfFeB4aGFdvrm9aoPC186MGa05hP
         rVSR90T4x+GoGZ2//RJ8rTA2QQUKcJ9zm6E8Z9gC3w4rwgooU6Q0xfUNHb4/xMs8e19T
         K9tyEIoj3ZAlf46WTgz1/b2oU9Y5cSAlSvU7CL8Bi9TCczez+4tYBSUv5cvbp4eTaeI2
         9SOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=fyTRrNfvfx7kQKbQTujWp6z2VNyweYkMPBwA6/c3HSs=;
        b=StFK7Z5flRUT7d7lqG+LW2db0KVzzMILJRg4V4f66HY2M7G0Z+x2EyyGhZ+6AEkdCA
         rl+WPMyhCQgD07q13DpLPkqOwtmWE5781xzVLuecusXED9mEQ2Y6LE0oP8isprRSdW+L
         F8llzyUgJulwIiZ/dxjFrPPLItkdFW0aWwsqpVqGgs0JUh4vFdUVbeBWJbYyii9O0E2K
         1doFUdmV+4Du1DEsZsIAfhwue88z6zll8YN32bE3mVexYsoFV5q10iCJauHdbvV/6rAw
         GbUeomLQB4AeuGPGWzSjb/yCMfSUWMS3c5lmqliDyG/Y0Q55Oz8pipATwQH92bZC49TQ
         w05A==
X-Gm-Message-State: ACgBeo1P/pUQbWsuxf+7LqoHtbIcVopG6EBQfuaG1YVYGQqV2OfuZbn1
        ufczLJm0cVS4uTAyQI3ZWLwiHL5xbxPCJJzJoJezua8qGjMQzDfadgNrRS6M/Fb3vfnCjFmLq2W
        5DYomstID0qI8UmI2o2D/jtjfLXgPASbFt0gtTLpnJK/O65u9Zino+lC/mj+ev5YXQoirGKM=
X-Google-Smtp-Source: AA6agR5HuMFnmMZ/3l8xQBf9Q3UB8WVuQfZaqy1uzKF3ufszdvVaBnRaPzc+MlRfoOESJaSCQcBxs1qSOuWKX5eOZw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:cdcd:0:b0:67c:9b5b:2fa with SMTP
 id d196-20020a6bcdcd000000b0067c9b5b02famr86703iog.195.1660772537988; Wed, 17
 Aug 2022 14:42:17 -0700 (PDT)
Date:   Wed, 17 Aug 2022 21:41:44 +0000
In-Reply-To: <20220817214146.3285106-1-coltonlewis@google.com>
Message-Id: <20220817214146.3285106-2-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220817214146.3285106-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 1/3] KVM: selftests: Create source of randomness for guest code.
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

Create for each vcpu an array of random numbers to be used as a source
of randomness when executing guest code. Randomness should be useful
for approaching more realistic conditions in dirty_log_perf_test.

Create a -r argument to specify a random seed. If no argument
is provided, the seed defaults to the current Unix timestamp.

The random arrays are allocated and filled as part of VM creation. The
additional memory used is one 32-bit number per guest VM page to
ensure one number for each iteration of the inner loop of guest_code.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 11 ++++-
 .../selftests/kvm/include/perf_test_util.h    |  3 ++
 .../selftests/kvm/lib/perf_test_util.c        | 45 ++++++++++++++++++-
 3 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..362b946019e9 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -132,6 +132,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	uint32_t random_seed;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -225,6 +226,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
+	perf_test_set_random_seed(vm, p->random_seed);
 	perf_test_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
@@ -352,7 +354,7 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
-	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
+	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
 	       "[-x memslots]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
@@ -380,6 +382,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -r: specify the starting random seed.\n");
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
@@ -396,6 +399,7 @@ int main(int argc, char *argv[])
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
+		.random_seed = time(NULL),
 	};
 	int opt;
 
@@ -406,7 +410,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
 		switch (opt) {
 		case 'e':
 			/* 'e' is for evil. */
@@ -442,6 +446,9 @@ int main(int argc, char *argv[])
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
index eaa88df0555a..9517956424fc 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -23,6 +23,7 @@ struct perf_test_vcpu_args {
 	uint64_t gpa;
 	uint64_t gva;
 	uint64_t pages;
+	vm_vaddr_t random_array;
 
 	/* Only used by the host userspace part of the vCPU thread */
 	struct kvm_vcpu *vcpu;
@@ -35,6 +36,7 @@ struct perf_test_args {
 	uint64_t gpa;
 	uint64_t size;
 	uint64_t guest_page_size;
+	uint32_t random_seed;
 	int wr_fract;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
@@ -52,6 +54,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..8d85923acb4e 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -70,6 +70,35 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	}
 }
 
+void perf_test_alloc_random_arrays(uint32_t nr_vcpus, uint32_t nr_randoms)
+{
+	struct perf_test_args *pta = &perf_test_args;
+
+	for (uint32_t i = 0; i < nr_vcpus; i++) {
+		pta->vcpu_args[i].random_array = vm_vaddr_alloc(
+			pta->vm,
+			nr_randoms * sizeof(uint32_t),
+			KVM_UTIL_MIN_VADDR);
+		pr_debug("Random row %d vaddr: %p.\n", i, (void *)pta->vcpu_args[i].random_array);
+	}
+}
+
+void perf_test_fill_random_arrays(uint32_t nr_vcpus, uint32_t nr_randoms)
+{
+	struct perf_test_args *pta = &perf_test_args;
+	uint32_t *host_row;
+
+	for (uint32_t i = 0; i < nr_vcpus; i++) {
+		host_row = addr_gva2hva(pta->vm, pta->vcpu_args[i].random_array);
+
+		for (uint32_t j = 0; j < nr_randoms; j++)
+			host_row[j] = random();
+
+		pr_debug("New randoms row %d: %d, %d, %d...\n",
+			 i, host_row[0], host_row[1], host_row[2]);
+	}
+}
+
 void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 			   struct kvm_vcpu *vcpus[],
 			   uint64_t vcpu_memory_bytes,
@@ -120,8 +149,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	/* By default vCPUs will write to memory. */
-	pta->wr_fract = 1;
+	/* Set perf_test_args defaults. */
+	pta->wr_fract = 100;
+	pta->random_seed = time(NULL);
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
@@ -211,6 +241,11 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 	ucall_init(vm, NULL);
 
+	srandom(perf_test_args.random_seed);
+	pr_info("Random seed: %d\n", perf_test_args.random_seed);
+	perf_test_alloc_random_arrays(nr_vcpus, vcpu_memory_bytes >> vm->page_shift);
+	perf_test_fill_random_arrays(nr_vcpus, vcpu_memory_bytes >> vm->page_shift);
+
 	/* Export the shared variables to the guest. */
 	sync_global_to_guest(vm, perf_test_args);
 
@@ -229,6 +264,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
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
2.37.1.595.g718a3a8f04-goog

