Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBCB58F205
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiHJR7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiHJR7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:59:13 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A9E6715D
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:59:13 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-32a144ac47fso27122767b3.8
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=lgJgdCZQ0TjMlmfx7G+B0ikIHptGNxeUSngBv5sFA9A=;
        b=KRO+rLT3JiNjFyPXdkIXNyw8h//BddzaHJPUU/5MmAKHooSUoSPod0N1BiaIENugBo
         ISorjqOg+6RlJlNC9S9H6r/Gmemg7KZ+L+xhoIDP5LkYbbqivI+ILkTzqtDYcco9WeuI
         LG/MBkmV4u+ywFiFJDwroKn+fI5Y5pQC1CYli6jq4yPNTottUt4ZrBmkF6WzPbcXJHhU
         tEgkcBkwuklTkCZaqdhoZrPZ5ZPaite8N5xYp0UrHD53HB8vQiN+w9re1y8jsn3GFjR3
         BgoGLkuh66RI7qBwR7MEsl14bEzPLfQEUaCGPYZpEe8KZaXMaDGUna4N3f9MW7acJq/D
         5UQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=lgJgdCZQ0TjMlmfx7G+B0ikIHptGNxeUSngBv5sFA9A=;
        b=vHuLrhNw49oL63hwpaXaqjf5oaEeF3dmwANHCheccny79cUttW3V3N3pkrpQVWDB9G
         aooPpbw3yjLkz/R5skTAskuj6Vrl3QLZmGdfTV9OKQ1wxUKPgyoZi0FzKpkWN0SkNuqc
         VNwEqrnz/AwMYX7tQATsGF+fsBXGSU/dqWOzhulskvrIK10ie3RO9SWbcscP2CWp1J6J
         PORhtAN4bn5OvZyoFL2ejgMm0ALX4L2r4byvxRDhyzN5rEO6HOd1vgiI0V3aI8QF2zx3
         Ca/dTx5onunA0CEAonPLlHwj66hwJYa7pZI3U6iOVt+VHbdhRnNk9NyPJEntwqWulwA4
         Cc4Q==
X-Gm-Message-State: ACgBeo2qJ94i+zy1BtYUI4sVdH4PbP4DZlS2GefEiQn1tOKD6QFSA9h5
        y5mRfDl5zjhN1mqREaQ/+gFqKurR0jhbiZs9hq11h+uhEamfeZctD5KT1Vug1rHd6l0At3DPHn8
        geSJMuiHc5pSuJZqTwdz0wg4YpUBLOE3XaygBNm7aCA4g0Ez3dFZ4XEnovQPyZMpxrxbIlsY=
X-Google-Smtp-Source: AA6agR6S6sOA+m7GxergCwP45znt2tRzu66mu27Bfvewsp7X0/1/CBKUaO1M2FWP1Fi7aPGCVQ2VpiBHVPItIUuZZQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:77ce:0:b0:67c:4bb5:5101 with SMTP
 id s197-20020a2577ce000000b0067c4bb55101mr3279437ybc.198.1660154352332; Wed,
 10 Aug 2022 10:59:12 -0700 (PDT)
Date:   Wed, 10 Aug 2022 17:58:28 +0000
In-Reply-To: <20220810175830.2175089-1-coltonlewis@google.com>
Message-Id: <20220810175830.2175089-2-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220810175830.2175089-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH 1/3] KVM: selftests: Add random table to randomize memory access
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

Linear access through all pages does not seem to replicate performance
problems with realistic dirty logging workloads. Make the test more
sophisticated through random access. Each vcpu has its own sequence of
random numbers that are refilled after every iteration. Having the
main thread fill the table for every vcpu is less efficient than
having each vcpu generate its own numbers, but this ensures threading
nondeterminism won't destroy reproducibility with a given random seed.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 13 ++++-
 .../selftests/kvm/include/perf_test_util.h    |  4 ++
 .../selftests/kvm/lib/perf_test_util.c        | 47 +++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..80a1cbe7fbb0 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -132,6 +132,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	uint32_t random_seed;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -243,6 +244,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Start the iterations */
 	iteration = 0;
 	host_quit = false;
+	srandom(p->random_seed);
+	pr_info("Random seed: %d\n", p->random_seed);
+	alloc_random_table(nr_vcpus, guest_percpu_mem_size >> vm->page_shift);
+	fill_random_table(nr_vcpus, guest_percpu_mem_size >> vm->page_shift);
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	for (i = 0; i < nr_vcpus; i++)
@@ -270,6 +275,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
 	while (iteration < p->iterations) {
+		fill_random_table(nr_vcpus, guest_percpu_mem_size >> vm->page_shift);
 		/*
 		 * Incrementing the iteration number will start the vCPUs
 		 * dirtying memory again.
@@ -380,6 +386,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -r: specify the starting random seed.\n");
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
@@ -396,6 +403,7 @@ int main(int argc, char *argv[])
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
+		.random_seed = time(NULL),
 	};
 	int opt;
 
@@ -406,7 +414,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
 		switch (opt) {
 		case 'e':
 			/* 'e' is for evil. */
@@ -442,6 +450,9 @@ int main(int argc, char *argv[])
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
index eaa88df0555a..597875d0c3db 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -44,6 +44,10 @@ struct perf_test_args {
 };
 
 extern struct perf_test_args perf_test_args;
+extern uint32_t **random_table;
+
+void alloc_random_table(uint32_t nr_vcpus, uint32_t nr_randoms);
+void fill_random_table(uint32_t nr_vcpus, uint32_t nr_randoms);
 
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..b04e8d2c0f37 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -9,6 +9,10 @@
 #include "processor.h"
 
 struct perf_test_args perf_test_args;
+/* This pointer points to guest memory and must be converted with
+ * addr_gva2hva to be accessed from the host.
+ */
+uint32_t **random_table;
 
 /*
  * Guest virtual memory offset of the testing memory slot.
@@ -70,6 +74,49 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	}
 }
 
+void alloc_random_table(uint32_t nr_vcpus, uint32_t nr_randoms)
+{
+	struct perf_test_args *pta = &perf_test_args;
+	uint32_t **host_random_table;
+
+	random_table = (uint32_t **)vm_vaddr_alloc(
+		pta->vm,
+		nr_vcpus * sizeof(uint32_t *),
+		(vm_vaddr_t)0);
+	host_random_table = addr_gva2hva(pta->vm, (vm_vaddr_t)random_table);
+	pr_debug("Random start addr: %p %p.\n", random_table, host_random_table);
+
+	for (uint32_t i = 0; i < nr_vcpus; i++) {
+		host_random_table[i] = (uint32_t *)vm_vaddr_alloc(
+			pta->vm,
+			nr_randoms * sizeof(uint32_t),
+			(vm_vaddr_t)0);
+		pr_debug("Random row addr: %p %p.\n",
+			 host_random_table[i],
+			 addr_gva2hva(pta->vm, (vm_vaddr_t)host_random_table[i]));
+	}
+}
+
+void fill_random_table(uint32_t nr_vcpus, uint32_t nr_randoms)
+{
+	struct perf_test_args *pta = &perf_test_args;
+	uint32_t **host_random_table = addr_gva2hva(pta->vm, (vm_vaddr_t)random_table);
+	uint32_t *host_row;
+
+	pr_debug("Random start addr: %p %p.\n", random_table, host_random_table);
+
+	for (uint32_t i = 0; i < nr_vcpus; i++) {
+		host_row = addr_gva2hva(pta->vm, (vm_vaddr_t)host_random_table[i]);
+		pr_debug("Random row addr: %p %p.\n", host_random_table[i], host_row);
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
-- 
2.37.1.559.g78731f0fdb-goog

