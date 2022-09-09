Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962675B380D
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiIIMnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 08:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiIIMnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 08:43:05 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F219EBD283
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 05:43:03 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id o2-20020a056e0214c200b002eb8acbd27cso1127466ilk.22
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 05:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=BMjKG2as0qOSM/SLj3SEmTF/TkVf+vK3g2yJY2fFR98=;
        b=bvlWVbDHbsxtZKjoySifdX++pIzQFA5pnfEdamliSst6RqC0cOcqMd3zhVPFqQFMVG
         kWVCVsyAkjpbBTxJcpj9uZwyxgfRfJFcKdhF2sAPxpdCWM2RSN+yLukULGQOTKQqv6a5
         VfhKswtFSg6efZrKu/AO5PXYbQkabR1dwxbr2Js2lU08nP41CCL4kbISz6j9775oRvm2
         foiaBX0wty6uj8vdEy0Kus8Aw8HbFCN3VRNN84X6XEHes1j9pKE9G0m43cYxa/Cci7Ir
         Dvcn+30mJsOzeiZsNUMbo+cUD0xLrG2iRTneOJ77TiKG57j0159/+cJ9nnAw+tkN8dAT
         ibnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=BMjKG2as0qOSM/SLj3SEmTF/TkVf+vK3g2yJY2fFR98=;
        b=l+MS0ZkU58D0IBo29vgKqMr1Zhd51+bKlXDnKTbRxlvqHzbjONwwYixE9svPz8wIPR
         ZpkMMIYg00lXtkdWyQ/PYqWyAJzVqecTzkRpk+u/zHTbSVazjAsA+GNWlnfjklg/5wKJ
         tFYcamCXKrnr8A2l2WI7Tmg2suZMKI8HtYoP47sEI3h586mGI+VaV/iQqK9U6r7dSGlh
         7jTmx/Vq0K3G9gK8JImVwvVvncPpvUZz+ahT/TjmY0FdYJ3QDPUe6tCVa08cHbFfry7N
         l/pml6o2GDBetYPY0wZOZ7Bf0qg16zn4vcld7fpegxa+LJBin2Ei25YviDC2EAMKWADm
         11zA==
X-Gm-Message-State: ACgBeo1P5WcdeGTCVUfVUPygj+yo0kCt5s3Bvyu8JIPtGA03KInRFkri
        ixclPxV9/3gbJS5IiJjMkoonSGMRCb0lL1xeC/A2syqLzdvXqP4MLCzJP75JvsL+FgAs7TUhoBJ
        gbbXUw34uuwjjG+uuPn4YiJeDtgyTNuYRKlkXyfz1nm0zcxDNR3wosIRBRaOb2KbvESF8Thg=
X-Google-Smtp-Source: AA6agR7eZl4INC5kiqnPUf6noZQ8hiTzzdfUcxUxtFd8aQb/kQhDeATzkl5v78WQpJlz9qa9/u1rjoX3htS3e859VA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:25d3:b0:34a:1590:6b8a with
 SMTP id u19-20020a05663825d300b0034a15906b8amr7439403jat.303.1662727383402;
 Fri, 09 Sep 2022 05:43:03 -0700 (PDT)
Date:   Fri,  9 Sep 2022 12:42:59 +0000
In-Reply-To: <20220909124300.3409187-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220909124300.3409187-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909124300.3409187-3-coltonlewis@google.com>
Subject: [PATCH v5 2/3] KVM: selftests: randomize which pages are written vs read
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

Randomize which pages are written vs read using the random number
generator.

Change the variable wr_fract and associated function calls to
write_percent that now operates as a percentage from 0 to 100 where X
means each page has an X% chance of being written. Change the -f
argument to -w to reflect the new variable semantics. Keep the same
default of 100% writes.

Population always uses 100% writes.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 30 +++++++++++--------
 .../selftests/kvm/include/perf_test_util.h    |  4 +--
 .../selftests/kvm/lib/perf_test_util.c        | 10 +++----
 4 files changed, 25 insertions(+), 21 deletions(-)

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
index 2f91acd94130..c2ad299b3760 100644
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
 
@@ -223,7 +223,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pr_info("Random seed: %u\n", p->random_seed);
 	perf_test_set_random_seed(vm, p->random_seed);
-	perf_test_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -248,6 +247,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
 		vcpu_last_completed_iteration[vcpu_id] = -1;
 
+	perf_test_set_write_percent(vm, 100);
 	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
@@ -269,6 +269,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+	perf_test_set_write_percent(vm, p->write_percent);
+
 	while (iteration < p->iterations) {
 		/*
 		 * Incrementing the iteration number will start the vCPUs
@@ -341,7 +343,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
-	       "[-x memslots]\n", name);
+	       "[-x memslots] [-w percentage]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -358,10 +360,6 @@ static void help(char *name)
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
@@ -369,6 +367,11 @@ static void help(char *name)
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
@@ -378,10 +381,10 @@ int main(int argc, char *argv[])
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
@@ -393,7 +396,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
 		switch (opt) {
 		case 'g':
 			dirty_log_manual_caps = 0;
@@ -413,10 +416,11 @@ int main(int argc, char *argv[])
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
index f18530984b42..f93f2ea7c6a3 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -35,7 +35,7 @@ struct perf_test_args {
 	uint64_t size;
 	uint64_t guest_page_size;
 	uint32_t random_seed;
-	int wr_fract;
+	uint32_t write_percent;
 
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
index 4d9c7d7693d9..12a3597be1f9 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -60,7 +60,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 			uint64_t addr = gva + (i * pta->guest_page_size);
 			guest_random(&rand);
 
-			if (i % pta->wr_fract == 0)
+			if (rand % 100 < pta->write_percent)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -118,7 +118,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	/* Set perf_test_args defaults. */
-	pta->wr_fract = 1;
+	pta->write_percent = 100;
 	pta->random_seed = time(NULL);
 
 	/*
@@ -221,10 +221,10 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
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
2.37.2.789.g6183377224-goog

