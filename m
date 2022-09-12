Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A6B5B61F8
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 21:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiILT66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 15:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiILT6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 15:58:55 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F72476D8
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:58:54 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id i14-20020a5d934e000000b006892db5bcd4so6194869ioo.22
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=gxBeRa2VjQQW/muLHdmZltqewhqJks5GzmP5Kl8OFNk=;
        b=AfM/BHiqIVltm1RG/McIYJ/69vf1yTwL+texDN/60IrqHt48kB5ucZXQ+f7qo6dlhV
         WyH/HxGN6FXqkdhqt/wn4Bk1imii/eSWbKaunDzTxGKt/09WaOhA94zuQNShj/3CrWRE
         2UjNOxtVT1tSyIOPwVYBSi4XnUaL7VUwO/sjQRpbqaQB+9QD4pgDFRlwy6ioEJeFG1f+
         CwHCAHtQ8lkwv1PuDDW4SdAO39D8waGYmkwaBocaxfwN7c/2EO7mWtUOoU1Xafj/zMPr
         NtFGP8IJNdFhLCgp3oEI8Tg09o48PNoUvd2tbR7DVipruPOWcmEYgl9etzqENHhP3u4E
         AL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=gxBeRa2VjQQW/muLHdmZltqewhqJks5GzmP5Kl8OFNk=;
        b=umCUpFywOHj6gYOmHsM8kaoDWQD1hQVfbfbP81+ATqdrmlC/psff4397pvx1zuod//
         rWe5f0AtRyQkHoqohDwdH1m28+1ExAjSgJW6xTMHn5VFoXajJj+qOX2p+wX2yU3e/qNX
         xq9v0AxGGBTDIRQobpvi/NEJdCppJ2XTMjMhPRRUW50mxpsgmBHQAfhl1dVovB3a2/fj
         7cMH5yYybJ8FOassvMpSWXkGQoQTY4rtPEvU24gYIJ3qcqx4iI2velbkMt8+IXcoGmHx
         Feccp22WXe0v83Zty5P1ttZYwN80WSADt3E/mlWsVoETrT8lrKAQKxbtyOQMvVmJB4tH
         ZCrw==
X-Gm-Message-State: ACgBeo2F+RC0rQyT3wBso6UfFZ+RuJoy5tEAMB08xckJbeaUM3LD1yzn
        LJQfevFvzBhU6cOrSAv80R/IKQTerH4AmqQRY8yd5P49RKVdgxrpykcPo/Ke9rt1Vubok/DbKQa
        NmPCoZkJkkFUHGeOs4P8uhPE4jdSvQ+hZvznvLLKVJtv5OGbWTWxD7gigGCAoiaEvCsMs1FM=
X-Google-Smtp-Source: AA6agR6iuH1XffI4lsNEcm+QiHZDtLOukN28JbwgZS/L5SiShfvBigS4bKdz0I04WbBh7eIvqzl9PFWIr6uNN52hLw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:2388:b0:34a:e033:396b with
 SMTP id q8-20020a056638238800b0034ae033396bmr14107350jat.93.1663012734297;
 Mon, 12 Sep 2022 12:58:54 -0700 (PDT)
Date:   Mon, 12 Sep 2022 19:58:49 +0000
In-Reply-To: <20220912195849.3989707-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220912195849.3989707-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220912195849.3989707-4-coltonlewis@google.com>
Subject: [PATCH v6 3/3] KVM: selftests: randomize page access order
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

Create the ability to randomize page access order with the -a
argument. This includes the possibility that the same pages may be hit
multiple times during an iteration or not at all.

Population has random access as false to ensure all pages will be
touched by population and avoid page faults in late dirty memory that
would pollute the test results.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 11 +++++++++--
 .../selftests/kvm/include/perf_test_util.h    |  2 ++
 .../selftests/kvm/lib/perf_test_util.c        | 19 ++++++++++++++++++-
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index dfa5957332b1..ccc1f571645a 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -127,6 +127,7 @@ struct test_params {
 	int slots;
 	uint32_t write_percent;
 	uint32_t random_seed;
+	bool random_access;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -256,6 +257,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 * would pollute the performance results.
 	 */
 	perf_test_set_write_percent(vm, 100);
+	perf_test_set_random_access(vm, false);
 	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
@@ -278,6 +280,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
 	perf_test_set_write_percent(vm, p->write_percent);
+	perf_test_set_random_access(vm, p->random_access);
 
 	while (iteration < p->iterations) {
 		/*
@@ -349,10 +352,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -403,8 +407,11 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
+	while ((opt = getopt(argc, argv, "aghi:p:m:nb:v:or:s:x:w:")) != -1) {
 		switch (opt) {
+		case 'a':
+			p.random_access = true;
+			break;
 		case 'g':
 			dirty_log_manual_caps = 0;
 			break;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index f93f2ea7c6a3..d9664a31e01c 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -39,6 +39,7 @@ struct perf_test_args {
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
+	bool random_access;
 
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
@@ -53,6 +54,7 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
 void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
+void perf_test_set_random_access(struct kvm_vm *vm, bool random_access);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9effd229b75d..6b196d003491 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -46,6 +46,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
 	uint64_t gva;
 	uint64_t pages;
+	uint64_t addr;
 	int i;
 	uint32_t rand = pta->random_seed + vcpu_id;
 
@@ -57,7 +58,17 @@ void perf_test_guest_code(uint32_t vcpu_id)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * pta->guest_page_size);
+			guest_random(&rand);
+
+			if (pta->random_access)
+				addr = gva + ((rand % pages) * pta->guest_page_size);
+			else
+				addr = gva + (i * pta->guest_page_size);
+
+			/*
+			 * Use a new random number here so read/write
+			 * is not tied to the address used.
+			 */
 			guest_random(&rand);
 
 			if (rand % 100 < pta->write_percent)
@@ -232,6 +243,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
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
2.37.2.789.g6183377224-goog

