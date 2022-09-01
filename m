Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E0B5AA071
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 21:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbiIATxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 15:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiIATxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 15:53:03 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673494A120
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 12:53:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33dc390f26cso235842537b3.9
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 12:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=iNEYnc/ArzpTNoN95ptZ7A54YqbTfQJC2l461/+3kwI=;
        b=rClcVHJaHeAEnoKEMecWgYYJ6mkW6qyp0typJCX8rrFKXEBDE84SudvjN/c2sYgx0T
         ceOLwsYkvb2Awgz3ITTqUUoc7LuLL0jo4QSrGVxegUOIxsZ/P0REC5w5mdA7SjscZji/
         wJy6skqmRgqbgankdGhPeFF0eDpC8rpWd68vxAHzFtSop8wZ6KxfRcHmSv74DLHvaMO6
         D/6yw3zBi/T5z1QAdPkPUGQva588OYSxhj1Z5B5Rdf2cpjqXMjSW+Pmj4woksPVSPtG8
         h/9VlbhvAAODisDiFaiu0NIsRauM6PS8R4ceyKW0h3phj9RPvA8mDEThoabbyiz7JXc9
         bpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=iNEYnc/ArzpTNoN95ptZ7A54YqbTfQJC2l461/+3kwI=;
        b=fiOFeQmFrZVGt80bTAWMWV7WV4XBad+ndwl46VcAGq5A7fyc/tCykRDGyKPio1UY+d
         04tl54XpkUW1/UE+Ckd7UoSm3rqnHSy4V644GS1TMMeHCB2XwFrOy/Q0GTJ8KxmJkBIn
         1BhJRTUcRLHw0322LH5qGJky/j9hHgmlKYXEz1B42p2kFemtXmRmDyxcHiBf8X1W4eQX
         ef/nPdcCagnhp0QquaeRwJHg4Lytln5/YotIMna3pFP4D+TlTt8VF1ePGlXzxnQyMg+h
         JFUatXQD2kQxE+7edvCXYWr+BNmik39n5UhAWLpYZDR6A/0gzlpzI4yjdS9Mjy9d8tNk
         5MJw==
X-Gm-Message-State: ACgBeo2M+6G9feSRSQoLa/PDAQk53h2simLbr0uqSR47Fj8YtGp0Dncs
        4O6ZP0rV2ZBwxYeTAXV3euhxYTvnU4hGX6yMYUsDhGLzEWObFy56GKoT/VA7ND5pd0NcwwUVh1B
        t4NJlnHxTd8DPpqmtbvCutzKeN5N93A2ukL8+HBqWRCUXSfDio80Zf/i8+gLHEaL+z+rXpLc=
X-Google-Smtp-Source: AA6agR7XlrJBP4xc+2FMWxZIeX9uZDcKe/FOGryvm3N+vvZ6LnvhC+zjkPMNvmP5/HBgK1fzpw/sG4+BPml+eEEg3A==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a0d:e5c3:0:b0:329:bd79:63c with SMTP
 id o186-20020a0de5c3000000b00329bd79063cmr24794471ywe.56.1662061981601; Thu,
 01 Sep 2022 12:53:01 -0700 (PDT)
Date:   Thu,  1 Sep 2022 19:52:37 +0000
In-Reply-To: <20220901195237.2152238-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220901195237.2152238-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220901195237.2152238-4-coltonlewis@google.com>
Subject: [PATCH v3 3/3] KVM: selftests: Randomize page access order.
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
 .../testing/selftests/kvm/dirty_log_perf_test.c  | 12 ++++++++++--
 .../selftests/kvm/include/perf_test_util.h       |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c | 16 +++++++++++++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index c9441f8354be..631b3883ed12 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -127,6 +127,7 @@ struct test_params {
 	int slots;
 	uint32_t write_percent;
 	uint32_t random_seed;
+	bool random_access;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -269,6 +270,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+	/* Set random access here, after population phase. */
+	perf_test_set_random_access(vm, p->random_access);
+
 	while (iteration < p->iterations) {
 		/*
 		 * Incrementing the iteration number will start the vCPUs
@@ -339,10 +343,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -394,8 +399,11 @@ int main(int argc, char *argv[])
 
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
index 52c450eb6b9b..380c31375b60 100644
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
index be6176faaf8e..c6123b75d5e3 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -53,6 +53,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
 	uint64_t gva;
 	uint64_t pages;
+	uint64_t addr;
 	int i;
 	uint32_t rand = pta->random_seed + vcpu_id;
 
@@ -64,7 +65,14 @@ void perf_test_guest_code(uint32_t vcpu_id)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * pta->guest_page_size);
+			rand = perf_test_random(rand);
+
+			if (pta->random_access)
+				addr = gva +
+					((rand % pages) * pta->guest_page_size);
+			else
+				addr = gva + (i * pta->guest_page_size);
+
 			rand = perf_test_random(rand);
 
 			if (rand % 100 < pta->write_percent)
@@ -240,6 +248,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
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
2.37.2.789.g6183377224-goog

