Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4CA5AA070
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 21:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiIATxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 15:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiIATxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 15:53:02 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DF846217
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 12:53:01 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id a4-20020a056e0208a400b002e4621942dfso91475ilt.0
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 12:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=Rge06wV5FK7fxysd48Q9XgqgtxT13XVYQSdpPbtWqEM=;
        b=FuJg6K4a6I8uHuaABfr5TiSjJaPjt8alqI9JkI5PWHKVenay3vdP+l2iTwLKfubndh
         ZXlxj593RvsnAUY5C1LeNoien0sPLCdXiTlK9ESqOuh66h0s/hWGHvBHZPsYDKm56EZ0
         JyU40UiLj/oBUEOC1ywOAC97Bh+ANcDiwYsh/NWygdEj8MWjN+Fzvawdkc6jVJJwrRBy
         nwB0Sxh60omCtk+IccrySHM4dgqh7lS8RLyNCpl+8dQd99Q0qLpl3JoxMnM2e5wuVCV8
         smO0d9QZvSiZA63TGcRoETHJt4ttO1F7KIe9tzyyZqdqp+vuuL6udtgp3EqdNA9HPZ1i
         VVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=Rge06wV5FK7fxysd48Q9XgqgtxT13XVYQSdpPbtWqEM=;
        b=wrAspQr8GEjb4nf4iL9ozZ0mazjgAWRWoUL/TSZwirmV5boo/9I9DNov8siOh6GKtk
         p+LAQxhjfiBE6RMuA5qg5ZxP2n8o2LO1BJRGCgfSYLG/9dj1emlaANNfSjQchKbsLwU9
         pgziNs4a0lfVnhnPqLZd8T3qMAXN9//IqQ4lIbDZDqgPnJND4WJfF2PYFegRvfgxuLm+
         KjWaB+BDabZ4TGTCzRlKTnuKCtHiuk1cL1KQHFSLiO+fxwBzZewB9DJO3tar/HbdjLjD
         2QHuNrVDojsJeyJTnC8nwo7lV671Piv/MPEM5gsE/SYUH09Rh4+2XNMv2006RKJHEM2I
         ONIg==
X-Gm-Message-State: ACgBeo0qb5vRnJLJ6c7diNfEf210jTRQUNoH430U3vz8vBfwI3d23qVk
        nKLCArpPPfHkyWpxW2+hZ4N4lMbgijzqFDl3ZmUkVScZwQ6zOs5ZVbUVwhXis7QLSW1vCANqSWw
        U1xSDG3UqK94FyUPsxQlnnAFtlYQ3vcr2mxY67snV8y12JHTy3fTZyDk19iiAdhhlxUdstH8=
X-Google-Smtp-Source: AA6agR6kMrm0hKvKaJ+C4Jsf6TIZEV45sZTWwXc5QBZaqC8OcwYsOqgRSGPTllricCSP+3Y7E71mbimRmmzDjfT6xg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:491b:b0:34c:e5f:9ce1 with
 SMTP id cx27-20020a056638491b00b0034c0e5f9ce1mr4497636jab.222.1662061980462;
 Thu, 01 Sep 2022 12:53:00 -0700 (PDT)
Date:   Thu,  1 Sep 2022 19:52:36 +0000
In-Reply-To: <20220901195237.2152238-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220901195237.2152238-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220901195237.2152238-3-coltonlewis@google.com>
Subject: [PATCH v3 2/3] KVM: selftests: Randomize which pages are written vs read.
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

Randomize which pages are written vs read using the random number
generator.

Change the variable wr_fract and associated function calls to
write_percent that now operates as a percentage from 0 to 100 where X
means each page has an X% chance of being written. Change the -f
argument to -w to reflect the new variable semantics. Keep the same
default of 100 percent writes.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 28 ++++++++++---------
 .../selftests/kvm/include/perf_test_util.h    |  4 +--
 .../selftests/kvm/lib/perf_test_util.c        | 10 +++----
 4 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index d8909032317a..d86046ef3a0b 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -274,7 +274,7 @@ static void run_iteration(struct kvm_vm *vm, int vcpus, const char *description)
 static void access_memory(struct kvm_vm *vm, int vcpus, enum access_type access,
 			  const char *description)
 {
-	perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
+	perf_test_set_write_percent(vm, (access == ACCESS_READ) ? 0 : 100);
 	iteration_work = ITERATION_ACCESS_MEMORY;
 	run_iteration(vm, vcpus, description);
 }
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 2f91acd94130..c9441f8354be 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -122,10 +122,10 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
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
 
@@ -223,7 +223,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pr_info("Random seed: %u\n", p->random_seed);
 	perf_test_set_random_seed(vm, p->random_seed);
-	perf_test_set_wr_fract(vm, p->wr_fract);
+	perf_test_set_write_percent(vm, p->write_percent);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -341,7 +341,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
-	       "[-x memslots]\n", name);
+	       "[-x memslots] [-w percentage]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -358,10 +358,6 @@ static void help(char *name)
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
@@ -369,6 +365,11 @@ static void help(char *name)
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
@@ -378,10 +379,10 @@ int main(int argc, char *argv[])
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
 	struct test_params p = {
 		.iterations = TEST_HOST_LOOP_N,
-		.wr_fract = 1,
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
+		.write_percent = 100,
 		.random_seed = time(NULL),
 	};
 	int opt;
@@ -393,7 +394,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
 		switch (opt) {
 		case 'g':
 			dirty_log_manual_caps = 0;
@@ -413,10 +414,11 @@ int main(int argc, char *argv[])
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
-		case 'f':
-			p.wr_fract = atoi(optarg);
-			TEST_ASSERT(p.wr_fract >= 1,
-				    "Write fraction cannot be less than one");
+		case 'w':
+			perf_test_args.write_percent = atoi(optarg);
+			TEST_ASSERT(perf_test_args.write_percent >= 0
+				    && perf_test_args.write_percent <= 100,
+				    "Write percentage must be between 0 and 100");
 			break;
 		case 'v':
 			nr_vcpus = atoi(optarg);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index f18530984b42..52c450eb6b9b 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -35,7 +35,7 @@ struct perf_test_args {
 	uint64_t size;
 	uint64_t guest_page_size;
 	uint32_t random_seed;
-	int wr_fract;
+	int write_percent;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
@@ -51,7 +51,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   bool partition_vcpu_memory_access);
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
-void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
 void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 1292ed7d1193..be6176faaf8e 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -64,10 +64,10 @@ void perf_test_guest_code(uint32_t vcpu_id)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			rand = perf_test_random(rand);
 			uint64_t addr = gva + (i * pta->guest_page_size);
+			rand = perf_test_random(rand);
 
-			if (i % pta->wr_fract == 0)
+			if (rand % 100 < pta->write_percent)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -125,7 +125,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	/* Set perf_test_args defaults. */
-	pta->wr_fract = 1;
+	pta->write_percent = 100;
 	pta->random_seed = time(NULL);
 
 	/*
@@ -228,9 +228,9 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
 	kvm_vm_free(vm);
 }
 
-void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
+void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent)
 {
-	perf_test_args.wr_fract = wr_fract;
+	perf_test_args.write_percent = write_percent;
 	sync_global_to_guest(vm, perf_test_args);
 }
 
-- 
2.37.2.789.g6183377224-goog

