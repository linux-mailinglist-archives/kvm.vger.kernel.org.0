Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2CC597907
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 23:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbiHQVmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 17:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238882AbiHQVmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 17:42:21 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EA2A8CF5
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:42:20 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id w6-20020a056e02190600b002e74e05fdc2so2931075ilu.21
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=eUN2ZDvPsolqQtzdBuIc7K4HgJ9E812yG7xKm8dwUDY=;
        b=IENcdKxq+beGG/Ls6s0DuC2g51R1wifMcmB2ZOBM4xmOeKP47+XVDjWUZ6r5eoepxd
         ZfkOZwtUyErnnVxJIQTKu3EHZjqp8AZ1jNicrrD3CKvakuei3iVFVlXy8ZiGl1FD6Ko1
         bY7AN/5OZg/jwcoINiR7ma88pQobKvOwrbkOViLlcw0C6q1Qbo5NlhYd/b48FAf2y8w4
         DZyoAruymoaHr4vVRUWI8OsMtFzK+tGWSzJNX30Do0nlAZtQ1KTqBI4QjwE/bcN9voAx
         JpfFGeL7Hk+mA43d1kP7adKosEnatm307bBvrHNuhglNy6UOltg6i74WpyVfyKQkHWJl
         IIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=eUN2ZDvPsolqQtzdBuIc7K4HgJ9E812yG7xKm8dwUDY=;
        b=l5FD7r5TlFucwR1E4ZTEJHo1IrRFBLwxXVpEWHTZ/MDGD9sow4LuKkH/4eUi6bjoGT
         PAhdYUix0bmVzJhgwR1ngEUqCDozBbYMwpHUPWioFsHkEMS/BOxiBGL0FuFotI2BMZ0j
         Z/v8IrlZ8AJzDFpTjPoSniXHYdYOndkJVa2l9ATQPGq6sI6irIZ5RuOYkOsp0er7IaHL
         hVqMwuqToLPfrD9RudqpDkDQsxB0xwhzLBH8NMb7NPM+6n7+79wDyz4+aJSgfyCMwINc
         FpIZ774EpiCJpKgO5ekepx1LocbnJMIM1tNLjHSxPMVoQnFAagsFKQ7ryAdjA9Xv3ARg
         og8Q==
X-Gm-Message-State: ACgBeo2TzK9PaTm7iUeRw3Ey0Mbwi6qCLZDd737XEBkKkklmMahHC1E9
        RlU1eQEUEP95Z6APllEcr5M7caC9Km4TAjwTPbByehkOZDH6bFM5AG74yvPkXeqHc9Tek+EXXsU
        zskKeaFYjA7PU/8ii6fWStIPRfAkKMeV0ib+vlRdDTpl10/fNtrp6S2XeX1QqblrdkY+lIqk=
X-Google-Smtp-Source: AA6agR4SZP5mmKPwiIJdWQbTKTAyFok9DEN4tuIUuQ22zel3ckRIV/05ackch0EsPL4eKAl1cvoOks/hiBRHBk44LQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:2e0e:b0:684:e4f9:734a with
 SMTP id o14-20020a0566022e0e00b00684e4f9734amr90184iow.200.1660772540287;
 Wed, 17 Aug 2022 14:42:20 -0700 (PDT)
Date:   Wed, 17 Aug 2022 21:41:46 +0000
In-Reply-To: <20220817214146.3285106-1-coltonlewis@google.com>
Message-Id: <20220817214146.3285106-4-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220817214146.3285106-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 3/3] KVM: selftests: Randomize page access order.
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

Create the ability to randomize page access order with the -a
argument, including the possibility that the same pages may be hit
multiple times during an iteration or not at all.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c   | 10 +++++++++-
 .../testing/selftests/kvm/include/perf_test_util.h  |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c    | 13 ++++++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 9226eeea79bc..af9754bda0a4 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -133,6 +133,7 @@ struct test_params {
 	int slots;
 	uint32_t write_percent;
 	uint32_t random_seed;
+	bool random_access;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -271,6 +272,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+	/* Set random access here, after population phase. */
+	perf_test_set_random_access(vm, p->random_access);
+
 	while (iteration < p->iterations) {
 		/*
 		 * Incrementing the iteration number will start the vCPUs
@@ -353,10 +357,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -413,6 +418,9 @@ int main(int argc, char *argv[])
 
 	while ((opt = getopt(argc, argv, "eghi:p:m:nb:v:or:s:x:w:")) != -1) {
 		switch (opt) {
+		case 'a':
+			p.random_access = true;
+			break;
 		case 'e':
 			/* 'e' is for evil. */
 			run_vcpus_while_disabling_dirty_logging = true;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 8da4a839c585..237899f3f4fe 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -41,6 +41,7 @@ struct perf_test_args {
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
+	bool random_access;
 
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
@@ -55,6 +56,7 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
 void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
+void perf_test_set_random_access(struct kvm_vm *vm, bool random_access);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 1a6b69713337..84e442a028c0 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -48,6 +48,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
 	uint64_t gva;
 	uint64_t pages;
+	uint64_t addr;
 	uint32_t *rnd_arr = (uint32_t *)vcpu_args->random_array;
 	int i;
 
@@ -59,7 +60,11 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * pta->guest_page_size);
+			if (pta->random_access)
+				addr = gva +
+					((rnd_arr[i] % pages) * pta->guest_page_size);
+			else
+				addr = gva + (i * pta->guest_page_size);
 
 			if (rnd_arr[i] % 100 < pta->write_percent)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
@@ -271,6 +276,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
 	sync_global_to_guest(vm, perf_test_args);
 }
 
+void perf_test_set_random_access(struct kvm_vm *vm, bool random_access)
+{
+	perf_test_args.random_access = random_access;
+	sync_global_to_guest(vm, perf_test_args);
+}
+
 uint64_t __weak perf_test_nested_pages(int nr_vcpus)
 {
 	return 0;
-- 
2.37.1.595.g718a3a8f04-goog

