Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F61361FD5A
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiKGSWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiKGSWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:22:37 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C3613FB7
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:22:36 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id bf14-20020a056602368e00b006ce86e80414so7582191iob.7
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ro8EPKg0qJQpeO1j55KLBwg/vhsPlixbwUJbwaDMc/E=;
        b=a00iBNsi68OFyD51+5CStEs54BNyHYVb4y5LRj+gFy8zG4D5dibYqK3no4lgc2jC2f
         XNepo9xbvMFdNncaD8SPmjucN5ZMU/MuugVt67B3woj+kZP6GH3/G6pjYP5LioFG3+da
         pP/HKl+TCgK0Lz9QtKZ84J1O+cmwxMAerJvnADgrOaom41s3zvrByo7CsQtXirCSlnaV
         PsX12ZuQAebNP14JIoc+evMIlO0HWlK7gPMs2RxafGAv4Wn5T3IEGZGIfeWwZ28uNLS+
         V72dO0CD7ELsV7YabmOpA8wMH4VpahlmRl7r1B5MdpDKNwbMj8XeA/Iaz/vtev8Q+AXc
         nERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ro8EPKg0qJQpeO1j55KLBwg/vhsPlixbwUJbwaDMc/E=;
        b=h9Wre47lTWbGFDMWRQErQEWOn0a3etfICfo5msOQGWoO/EquA45jc0sQ20+gbTb9TB
         PyySbprlCBNRu1TO0XOxH8y57/dYSxJfks3tZgZnNJaicqFRDPh3sxY4yajplCRg21Dx
         jZxUBlJUOaq51qSZq4GeHfLoHoHTrDRnMvHbMgPpmqpUN9CJEsIl45bkNFgCQ//v8d6M
         FY4ZDz2NGZE6j8sO3jqODiOSBrJ0oKUDEACQ5oq9xlWrgZcFs8UEwQt0Z9Cpux4c7Kbb
         APFaZ6TvgGdvBpDi7yVfmTyw1nT4xx5kl+51nh5Cim5RG+lT870CyWnhyzZiXZlwvHFQ
         GJYQ==
X-Gm-Message-State: ANoB5pm9byNIoMzH1RP9cWPYhrcP1kB+XGiteS4fa08Zy6gthLylpOCp
        tGLzPgDDEabfnarquia2/CnIm5Ou59mKZe6QbrGXllgLI0IdqYYA9RYeV6SVv0wPGN6NDs4LXeW
        AX37jkGHN6m19UX1VC25U4KkXKI02PTJmuN5pHLRD46ah44SGBOhx5m3CzTl7hPO8SDym6x4=
X-Google-Smtp-Source: AA0mqf65lq3/iLj4w9oeddQ7cbH+aW2VsGLhLscOSBw+v6KehDWToch34KB3FcWyPD7oUyqLtyS3n0vTBW8Eu3Mkdw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:998d:0:b0:375:c016:a077 with SMTP
 id a13-20020a02998d000000b00375c016a077mr5118329jal.80.1667845355716; Mon, 07
 Nov 2022 10:22:35 -0800 (PST)
Date:   Mon,  7 Nov 2022 18:22:08 +0000
In-Reply-To: <20221107182208.479157-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221107182208.479157-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221107182208.479157-5-coltonlewis@google.com>
Subject: [PATCH v10 4/4] KVM: selftests: randomize page access order
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

Create the ability to randomize page access order with the -a
argument. This includes the possibility that the same pages may be hit
multiple times during an iteration or not at all.

Population has random access as false to ensure all pages will be
touched by population and avoid page faults in late dirty memory that
would pollute the test results.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 11 +++++++++--
 .../selftests/kvm/include/perf_test_util.h        |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c  | 15 ++++++++++++++-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index a78c617ea2b4..202f38a72851 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -133,6 +133,7 @@ struct test_params {
 	int slots;
 	uint32_t write_percent;
 	uint32_t random_seed;
+	bool random_access;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -259,6 +260,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 * would pollute the performance results.
 	 */
 	perf_test_set_write_percent(vm, 100);
+	perf_test_set_random_access(vm, false);
 	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
@@ -281,6 +283,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
 	perf_test_set_write_percent(vm, p->write_percent);
+	perf_test_set_random_access(vm, p->random_access);
 
 	while (iteration < p->iterations) {
 		/*
@@ -364,10 +367,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
+	printf("usage: %s [-h] [-a] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
 	       "[-x memslots] [-w percentage]\n", name);
 	puts("");
+	printf(" -a: access memory randomly rather than in order.\n");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -g: Do not enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2. This\n"
@@ -422,8 +426,11 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:v:or:s:x:w:")) != -1) {
+	while ((opt = getopt(argc, argv, "aeghi:p:m:nb:v:or:s:x:w:")) != -1) {
 		switch (opt) {
+		case 'a':
+			p.random_access = true;
+			break;
 		case 'e':
 			/* 'e' is for evil. */
 			run_vcpus_while_disabling_dirty_logging = true;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 845165001ec8..3d0b75ea866a 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -40,6 +40,7 @@ struct perf_test_args {
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
+	bool random_access;
 
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
@@ -54,6 +55,7 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
 void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
+void perf_test_set_random_access(struct kvm_vm *vm, bool random_access);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 92b47f71a0a5..137be359b09e 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -48,6 +48,8 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
 	uint64_t gva;
 	uint64_t pages;
+	uint64_t addr;
+	uint64_t page;
 	int i;
 	struct guest_random_state rand_state =
 		new_guest_random_state(pta->random_seed + vcpu_idx);
@@ -60,7 +62,12 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * pta->guest_page_size);
+			if (pta->random_access)
+				page = guest_random_u32(&rand_state) % pages;
+			else
+				page = i;
+
+			addr = gva + (page * pta->guest_page_size);
 
 			if (guest_random_u32(&rand_state) % 100 < pta->write_percent)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
@@ -237,6 +244,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
 	sync_global_to_guest(vm, perf_test_args.random_seed);
 }
 
+void perf_test_set_random_access(struct kvm_vm *vm, bool random_access)
+{
+	perf_test_args.random_access = random_access;
+	sync_global_to_guest(vm, perf_test_args.random_access);
+}
+
 uint64_t __weak perf_test_nested_pages(int nr_vcpus)
 {
 	return 0;
-- 
2.38.1.431.g37b22c650d-goog

