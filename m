Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48205B380B
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiIIMnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 08:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiIIMnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 08:43:06 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C69F109D3F
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 05:43:05 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id a12-20020a92c54c000000b002f146fd423dso1108041ilj.19
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 05:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=MGTz4V3aYmu5Ny1o3UC5sIQZoHtez2zS7W5OlREpVM8=;
        b=RFMJxwY+77Tb5oFy19vNK3wYlIEkTdfGVACeb1W/t2UfDzpyOpXwITCJxcjqSMJSvx
         1aTj9gAIUNVhqzq49Aqkpznd1WJsvEt66zx0WuICQsbajGYOPav0at6R2eZHRzchuFuq
         n3bX10/Q3rA4r4OTNbWLbfllXvDbUp/0/3DF1reu2jEAPS6T6IWGLpz75S6vTvAr7fq1
         BBLWICI+R+QV6tSHhDMYPwAwMxhpyO0ZYoo9YDnWI6MmvrORUPFDZlYSuXkt2Ft3DQfW
         h7pNsFwbhN0DWUHkr/4neGkDWz45IFCJOtJ9vEnoUlFKKtp+kTFkN+EUM4cBLVPDcsrX
         g6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=MGTz4V3aYmu5Ny1o3UC5sIQZoHtez2zS7W5OlREpVM8=;
        b=vS/VQwjHtYSktuT2hST7H6nHaFLQWdjupPR75OLHnDvnoxtUqlSUWjawlW3c3bzE9R
         Rkg9WqrnMuyytEsXcNxH1sUwL76JQw0uTqOxTynv6QdMzBQVpi6jpAQ6Kh+b/TK/0z50
         Ki4N5lHX72aBI7VEUKsHJWYgJatScWUSdIRrpcRHUNLCYP8jZxIEhdLa0Mu585yyeHoO
         rkFUjYVyGk2blgqZKYk80rVQmqTUrG0ZJ7SpMQXxpOT5VOxqYVbR6cuE3DRiuE2cjPMv
         IIumydTLVpndvkLNN+RUMW22jpsbIR28jtY4Cf4mzPJFvHna9j37f9xDt6lFK4CMqoUo
         mefg==
X-Gm-Message-State: ACgBeo1La/D7cuT5hMHXrIxM4GXaA3P5qorl1klknRdLnhi7kd7JIgCz
        qAeBT7/TLIRGrMdFyUsrzdiuISKZfm6Y1x/vxEVyqB6l6NIxnx651JGklJf3l91MuSEft6pmQhb
        CKEmZ/sUMFOSYxs0dDaf3UwkWAzVBR7+PQZvgZJ9uKRnxhjSgY0NvkvfwdNRLEaDBtOsigB8=
X-Google-Smtp-Source: AA6agR7kKIEDaBNgC++hs12/nX8lBcS0Tw+PO9/sfW+49RkJ0oMv2sWBMuRF1X3IIuIFFApEdH5FwFr5dNES+oR1tw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:2f09:b0:689:8993:6052 with
 SMTP id q9-20020a0566022f0900b0068989936052mr6825747iow.114.1662727384465;
 Fri, 09 Sep 2022 05:43:04 -0700 (PDT)
Date:   Fri,  9 Sep 2022 12:43:00 +0000
In-Reply-To: <20220909124300.3409187-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220909124300.3409187-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909124300.3409187-4-coltonlewis@google.com>
Subject: [PATCH v5 3/3] KVM: selftests: randomize page access order
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
argument, including the possibility that the same pages may be hit
multiple times during an iteration or not at all.

Population sets random access to false.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 11 +++++++++--
 .../selftests/kvm/include/perf_test_util.h        |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c  | 15 ++++++++++++++-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index c2ad299b3760..3639d5f95033 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -127,6 +127,7 @@ struct test_params {
 	int slots;
 	uint32_t write_percent;
 	uint32_t random_seed;
+	bool random_access;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -248,6 +249,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vcpu_last_completed_iteration[vcpu_id] = -1;
 
 	perf_test_set_write_percent(vm, 100);
+	perf_test_set_random_access(vm, false);
 	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
@@ -270,6 +272,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
 	perf_test_set_write_percent(vm, p->write_percent);
+	perf_test_set_random_access(vm, p->random_access);
 
 	while (iteration < p->iterations) {
 		/*
@@ -341,10 +344,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -396,8 +400,11 @@ int main(int argc, char *argv[])
 
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
index 12a3597be1f9..ce657fa92f05 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -46,6 +46,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
 	uint64_t gva;
 	uint64_t pages;
+	uint64_t addr;
 	int i;
 	uint32_t rand = pta->random_seed + vcpu_id;
 
@@ -57,7 +58,13 @@ void perf_test_guest_code(uint32_t vcpu_id)
 
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
 			guest_random(&rand);
 
 			if (rand % 100 < pta->write_percent)
@@ -233,6 +240,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
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

