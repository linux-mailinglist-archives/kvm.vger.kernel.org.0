Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA7E59790B
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 23:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241315AbiHQVmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 17:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbiHQVmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 17:42:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4920A896D
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:42:19 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-335ff2ef600so21368507b3.18
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=dLH+sVNnmkewn/U0/amXG1XYi6OV47iSKUjKy/dJDlg=;
        b=VTJq1dOJrRJGBtj2GFXSHkrjy1oACwRoBxB3JIkF5uSEB79uAyNl6jncVcPXcc4I9/
         0MIkFlTgZ9Likz3TrGSjiYwGgkuD0t1xdoi1gSxmre1yGfFydGkAlGFxNXz9AIL3DwX7
         5Zzbr+nPrBzI5glo003lw6AfxmIMRwqXqQISWdzS14al7efhzoBFCUX/zAFZeQktWU06
         K5nBAIrDAPNYy5RPoY+6eOPG9NxHf7C6HbE102SFXBOncp/I9azsT1VWRKF+iK4FX3gq
         4oPHBIAb7uAgLMx/3i3iNVVCt7xQ1CQWYTvRoONX5gFJSwkfYGT3Ns1xpJN7ApeNTWdj
         6XMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=dLH+sVNnmkewn/U0/amXG1XYi6OV47iSKUjKy/dJDlg=;
        b=WviT5cIkvZ78aiDxONXhrVruJM7b9DtZgBqjSa/uYrQi5hYVfSxu0PNxPgHHSZ6JdL
         s0xlTNZFFaa7Xh2JtYw8zpJ6HhyMzWkujjAMSzxcdL5mQnsuQMAQ+zVxioCyvKtna6SX
         Z6DfNTkMVevYGJ34MKljIrIeScWvOD3qvu4OBZhesjRfE0KUJavvIhAP5jDQBkn6WCUW
         12nsijRLraa+fUqoZHjpjhNSnOVPncaR613Zlzl/6txc/lOeO/FSxrUe3HBAV8BQVFUU
         ihMR4CGzgJ0Ri5UPg6hqjCqeVzly8K6KQs7AM0MC87N5ZRmQlWWWMeRA701iNcLGhOtl
         1X2w==
X-Gm-Message-State: ACgBeo24v5d9FuWmJmu35aL7aFYW/a4wrMPB2W5/8XFFclGHlrUR55uQ
        XW8h2KCbe3z5AbtuyzCOS/nEaS3Feu1xgeQCAS6J0l9hMCW7Pdac3Gu2S7KzmMVWlzup+3gcSrU
        oV1kbKJgcVRwKIc+Qso+tfn7saI4LssFFEKIRwD82mQE486F4DMw/wFpAFal0wonplHDeFGc=
X-Google-Smtp-Source: AA6agR796yf1Bqdh4G1LFNWXiAXo4qzIBqafW2xFO2keohri5TZOOzXmcLs837ohybTjxJnMy2k7IYkGUfllO3U39Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5b:b8e:0:b0:67c:237b:760b with SMTP
 id l14-20020a5b0b8e000000b0067c237b760bmr169537ybq.627.1660772539048; Wed, 17
 Aug 2022 14:42:19 -0700 (PDT)
Date:   Wed, 17 Aug 2022 21:41:45 +0000
In-Reply-To: <20220817214146.3285106-1-coltonlewis@google.com>
Message-Id: <20220817214146.3285106-3-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220817214146.3285106-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 2/3] KVM: selftests: Randomize which pages are written vs read.
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

Randomize which tables are written vs read using the random number
arrays. Change the variable wr_fract and associated function calls to
write_percent that now operates as a percentage from 0 to 100 where X
means each page has an X% chance of being written. Change the -f
argument to -w to reflect the new variable semantics. Keep the same
default of 100 percent writes.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 28 ++++++++++---------
 .../selftests/kvm/include/perf_test_util.h    |  4 +--
 .../selftests/kvm/lib/perf_test_util.c        |  9 +++---
 4 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 1c2749b1481a..e87696b60e0f 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -272,7 +272,7 @@ static void run_iteration(struct kvm_vm *vm, int nr_vcpus, const char *descripti
 static void access_memory(struct kvm_vm *vm, int nr_vcpus,
 			  enum access_type access, const char *description)
 {
-	perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
+	perf_test_set_write_percent(vm, (access == ACCESS_READ) ? 0 : 100);
 	iteration_work = ITERATION_ACCESS_MEMORY;
 	run_iteration(vm, nr_vcpus, description);
 }
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 362b946019e9..9226eeea79bc 100644
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
 
@@ -227,7 +227,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->partition_vcpu_memory_access);
 
 	perf_test_set_random_seed(vm, p->random_seed);
-	perf_test_set_wr_fract(vm, p->wr_fract);
+	perf_test_set_write_percent(vm, p->write_percent);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -355,7 +355,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
-	       "[-x memslots]\n", name);
+	       "[-x memslots] [-w percentage]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -375,10 +375,6 @@ static void help(char *name)
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
@@ -386,6 +382,11 @@ static void help(char *name)
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
@@ -395,10 +396,10 @@ int main(int argc, char *argv[])
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
@@ -410,7 +411,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "eghi:p:m:nb:v:or:s:x:w:")) != -1) {
 		switch (opt) {
 		case 'e':
 			/* 'e' is for evil. */
@@ -433,10 +434,11 @@ int main(int argc, char *argv[])
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
index 9517956424fc..8da4a839c585 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -37,7 +37,7 @@ struct perf_test_args {
 	uint64_t size;
 	uint64_t guest_page_size;
 	uint32_t random_seed;
-	int wr_fract;
+	int write_percent;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
@@ -53,7 +53,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   bool partition_vcpu_memory_access);
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
-void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
 void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 8d85923acb4e..1a6b69713337 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -48,6 +48,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
 	uint64_t gva;
 	uint64_t pages;
+	uint32_t *rnd_arr = (uint32_t *)vcpu_args->random_array;
 	int i;
 
 	gva = vcpu_args->gva;
@@ -60,7 +61,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 		for (i = 0; i < pages; i++) {
 			uint64_t addr = gva + (i * pta->guest_page_size);
 
-			if (i % pta->wr_fract == 0)
+			if (rnd_arr[i] % 100 < pta->write_percent)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -150,7 +151,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	/* Set perf_test_args defaults. */
-	pta->wr_fract = 100;
+	pta->write_percent = 100;
 	pta->random_seed = time(NULL);
 
 	/*
@@ -258,9 +259,9 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
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
2.37.1.595.g718a3a8f04-goog

