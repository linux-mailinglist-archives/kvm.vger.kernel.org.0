Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476826166C9
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiKBQA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiKBQAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:00:19 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5228E2C134
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:00:18 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id s15-20020a056e02216f00b00300d14ba82bso1537931ilv.5
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NUyMNnyD6Vd9kmq5WeePMbPGyZVCujZMExzub8EbTbU=;
        b=YqOPubMkKPWJJ/e3faDypXJGO3b4lCjBI/3C8q8uJ+RJbtshzDb7Bnrgg/y+eDV5vN
         NqKJJCm8NmnrHcOig/T9gf9tOFVQdmp2h02puzQpuaKeU4PeNczi24ysB5yXsXRMWnoQ
         9S0Tcf1WN4qcccxZhO7pzVuw+ozSNrucziBhlG0Z1a1ax4+2YL3yFE3uZs7/auYcy598
         UvDAfNsuK3rUHWfhsi7tqTaDuWS5sVGwKKk9mYaxDNRL+xAxmMuam5LHbSR9UJAGXrmF
         DT0Zg2WoRFYsA7l5u6niwa/ETl0BoiG82yC+r6sIpT5URozLof2XKIJjxGb8p8SJUFTY
         i6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NUyMNnyD6Vd9kmq5WeePMbPGyZVCujZMExzub8EbTbU=;
        b=6tjzAJCwb/r84UHIZwr6/0BWGh/V31QrxppkWrAJ8wUebfMtsQpvGkigWfXmR4dtJT
         BeBVKhihB8J6QwcrzyGD6398fpqnQ1w3OymdzY/lkzqZthaSrCE2U0Eb6RJAZEi1MVlc
         PLf/e6ENokGA+Khn7E6LzL9q9IIyVwl2JekoepZeJYolKTg1zDLpRWcDIxsoM7YrLGPa
         Xi8eavZ0X09OT5magIu7M6zurS/x8ppBNTwg6i8gZfnNjTEaqxDr4iksKO2MjRliRdP7
         lgBp2knQtZuPbMA1b6WMjdURLhPsZbhZHYSNkKzRS5Vo6jVGj1xxOpDiFGYg0lPy5/2V
         +Miw==
X-Gm-Message-State: ACrzQf26INsaSYBgheqSLS5FM+Ll2XY/1mEwCmyjGIhEueQ0QcsTn3ON
        f0eBVbW5eui/t8ruYeX2TpwVIFNLY2KQerH2HtRJhsmgZnBwbqfUO5qKpgik16jPgRuiyA1+m3R
        55Tn6cTeis2Fnyx4WFnbgVwYcP28duey8YB9CC57kQmGCf5WJSH2NbbkSRgJ8CVcExx+3F58=
X-Google-Smtp-Source: AMsMyM4n/1opFc5Ke/R+WJu3Mj6/h0tA49JogeuQjy+R16Aj5BAHfRiNDyEFEfLQhkTssnpb94A8cVWYsCEVRVX5zA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:9982:0:b0:364:6be:dbd6 with SMTP
 id a2-20020a029982000000b0036406bedbd6mr16631019jal.311.1667404818010; Wed,
 02 Nov 2022 09:00:18 -0700 (PDT)
Date:   Wed,  2 Nov 2022 16:00:07 +0000
In-Reply-To: <20221102160007.1279193-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221102160007.1279193-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102160007.1279193-5-coltonlewis@google.com>
Subject: [PATCH v9 4/4] KVM: selftests: randomize page access order
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
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 11 +++++++++--
 .../selftests/kvm/include/perf_test_util.h        |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c  | 15 ++++++++++++++-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 0d0240041acf..065961943b3d 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -133,6 +133,7 @@ struct test_params {
 	int slots;
 	uint32_t write_percent;
 	uint32_t random_seed;
+	bool random_access;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -260,6 +261,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 * would pollute the performance results.
 	 */
 	perf_test_set_write_percent(vm, 100);
+	perf_test_set_random_access(vm, false);
 	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
@@ -282,6 +284,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
 	perf_test_set_write_percent(vm, p->write_percent);
+	perf_test_set_random_access(vm, p->random_access);
 
 	while (iteration < p->iterations) {
 		/*
@@ -365,10 +368,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
2.38.1.273.g43a17bfeac-goog

