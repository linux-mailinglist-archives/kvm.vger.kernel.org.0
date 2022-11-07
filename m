Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB71261FD59
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiKGSWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiKGSWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:22:36 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1881145B
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:22:34 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so7619102ioz.8
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A8Fhf+GP7H/Uvmif/i8F8YNTUSAgb4QsWbaUg89LRpA=;
        b=q0qb93OWaflcmiJ+5i/YFAC8tg0aZPsr+Uor4bG6W6QyuEY9+cKdcVQ20TW51UZ6rh
         5R+HZU87eQGW3BEpweQD9Tf0lK/ROj1c593ZO2/mjytsougpER1eBF+h/EB9paASkzTC
         h4ai4lJSCIBxVFQ/HxQGbToNW7Az+b7hGFmIdZDqbTgW/NGtIfBgBArKyYTe378PRiKm
         BluOSL4hS2G/6zFS9hRnoWyfimFkJslnwX7diCKZLUPR2rtGw4i/nmoy+u5ujK+UaJSK
         SFaPoosM9BpYHfDlGheuaxhlgXNNnd38tfY2dMNTZRErPz0qEfMKIOthxC3GxTToNdGy
         3ObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A8Fhf+GP7H/Uvmif/i8F8YNTUSAgb4QsWbaUg89LRpA=;
        b=uwLNzyvmXUU9fu9zZCfhssw/YUCKmFwpnXQPdelmm3P7SDtr5dnAEA5ji/iMdR5g1T
         poy2TDPLk+tlpAYk1Xt8nxagHaRsI4mJauA0Tcy9zOBgrKcw8zxFnqxE1waloHHVxNWx
         TjCDe/bo1WpfwNPcOJaHFOlf1dh1+T652fh9eRxQTIDYZtWVJY3G08CIsaecsZVfoG61
         pelpoWGctpBEGOozAxlmnYeHhf9CbhnuPkNkXk0dS2FRxbS97ZOtervRpWwuOJOhD45Y
         egfX6fQKvL/+7chMg5Lfbs/UdYPsEnOqgsBMEweGNo0CU269hNaP+CyZ0C0avQvIDrXN
         mqWA==
X-Gm-Message-State: ACrzQf23BqIDf0CEqJqnKgF1IY1soktblCkl94u3XQT8QfnAqqb2GdhP
        6nw0f3jPPOplkLHEnx1tn6H/er9vgnXTtDF5qmWN3qhz4Meo2oMMXgndnTlyoLryg8uhCk+C9lj
        /QVj3qUF3TwWnRBxnwOMorhp3Mzck3QOCGay+5CY7uTYrSXnEJAITJ8zVcNccFXzfPA/lrJE=
X-Google-Smtp-Source: AMsMyM7F+/6XUxgpD6TL+vF1FKyfOJDlqdLctNy8kfeN6m9pH6qPLnv8w/Zuf+25C+6XLwokslTwVVmiAehaGQVT+w==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:3103:0:b0:6ce:e628:dba9 with SMTP
 id j3-20020a6b3103000000b006cee628dba9mr28087339ioa.151.1667845353839; Mon,
 07 Nov 2022 10:22:33 -0800 (PST)
Date:   Mon,  7 Nov 2022 18:22:06 +0000
In-Reply-To: <20221107182208.479157-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221107182208.479157-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221107182208.479157-3-coltonlewis@google.com>
Subject: [PATCH v10 2/4] KVM: selftests: create -r argument to specify random seed
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

Create a -r argument to specify a random seed. If no argument is
provided, the seed defaults to 1. The random seed is set with
perf_test_set_random_seed() and must be set before guest_code runs to
apply.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c  | 14 ++++++++++++--
 .../testing/selftests/kvm/include/perf_test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c   |  6 ++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..f74a78138df3 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -132,6 +132,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	uint32_t random_seed;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -225,6 +226,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
+	pr_info("Random seed: %u\n", p->random_seed);
+	perf_test_set_random_seed(vm, p->random_seed);
 	perf_test_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
@@ -352,7 +355,7 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
-	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
+	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
 	       "[-x memslots]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
@@ -380,6 +383,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -r: specify the starting random seed.\n");
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
@@ -396,6 +400,7 @@ int main(int argc, char *argv[])
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
+		.random_seed = 1,
 	};
 	int opt;
 
@@ -406,7 +411,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
 		switch (opt) {
 		case 'e':
 			/* 'e' is for evil. */
@@ -442,6 +447,11 @@ int main(int argc, char *argv[])
 		case 'o':
 			p.partition_vcpu_memory_access = false;
 			break;
+		case 'r':
+			p.random_seed = atoi(optarg);
+			TEST_ASSERT(p.random_seed > 0,
+				    "Invalid random seed, must be greater than 0");
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
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..0bb0659b9a0d 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -229,6 +229,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
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
-- 
2.38.1.431.g37b22c650d-goog

