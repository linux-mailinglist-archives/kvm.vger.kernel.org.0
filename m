Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0416103F2
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 23:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiJ0VEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 17:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbiJ0VDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 17:03:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFF395E7C
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:57:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v81-20020a252f54000000b006cb87d7042cso2623682ybv.20
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mI1bL1qNldSt5bf6jYcLSpbsLUF8bpRTLV/Bcwyx20g=;
        b=XvKEwPq0OIlPNKjHDmCVgfLM1Cum7YeYDMJ5i3UDa0Pmb4Vq9ANaHtbK/OwOXrTXfR
         +85EEMDi5xbA6gdB28nLD4/M4jxLhoHJ/ba/hL3JoWEZVMnrm+9+7gf81HO+aQZzG8li
         YKnOoKSOCF6JettDVJrHxnCEnrPcr9F/KTfAphsOKVI9UKJsuRtgelXMrxXIBV+NiakG
         RgMjLOUnnrJ/vACMxiz/aCk+GEMFEQNhtrmoAUVRLFRyoGxCMzjFoE6l0/fiF3ZredK8
         IP8tdynuEuRiTENAI0jfYMmJmITTSS7xZ2EkHHME9Io2fc9Xm860tTF/UDAn2y9K5DRG
         hFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mI1bL1qNldSt5bf6jYcLSpbsLUF8bpRTLV/Bcwyx20g=;
        b=OBkg3mPUfE0NNcaThO2I8ZJRW3p/njyZWJ+BsLqE71v8YtYsRz9m0lQ3yDCVSaQGd/
         bntqSm3JMNScHQAqn6xqA73IL3rCOK6oByHszK3XHofLA5pH+kYhXq7Umv7mFCNoNNKD
         IW2O7Yl/nhDhLwfuyIQlJ17fFRCC90t/enAzDThUnZ+tSI814c9+0DBKpfMEFr6V6QBm
         Su6z2WAU9aL4aB7ckuLiw/oUlZ9eS8qFHbKH8GQsp1M0/uRtZinybDLszxpiLZ/WzZf8
         JY+juYI/M6k4AkpPKgEIfI1E5T1oUV5byiRgUFFtV7IzHLoLeyugW9lOwwXVbrK9azpX
         Gecg==
X-Gm-Message-State: ACrzQf02hZx5apAKh+u+V4f3hMRm8pZLipxPQ1ZMBdH0Y22xfZtRNDgc
        dcNULA9gv3rTnGNI6OS+5QAINhq4FZseiMNx2EfYXyt9MWSrS5OfxqXqZV8NIPSjmHeQqL6Eejg
        DbBT/KlYNkZ/gkBnN7vvzm2KfOC6Mrmb5TL/MpXljvfUOmpLhUgYIHV4iSiOqfmms9x+bDSw=
X-Google-Smtp-Source: AMsMyM5Uul9mjTcNdF2avz+gD00UUsV3Ee0nRwPkPh60EGXVrrSW3lMKv0tm0DoKexw6dnDP6modQELgvHBSfAlHUQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:17d1:0:b0:36a:6185:fb06 with SMTP
 id 200-20020a8117d1000000b0036a6185fb06mr30459759ywx.351.1666904224235; Thu,
 27 Oct 2022 13:57:04 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:56:31 +0000
In-Reply-To: <20221027205631.340339-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221027205631.340339-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027205631.340339-5-coltonlewis@google.com>
Subject: [PATCH v8 4/4] KVM: selftests: randomize page access order
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
index 97a402f5ed23..a27405a590ba 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -48,6 +48,8 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
 	uint64_t gva;
 	uint64_t pages;
+	uint64_t addr;
+	uint64_t page;
 	int i;
 	struct guest_random_state rand_state = new_guest_random_state(pta->random_seed + vcpu_idx);
 
@@ -59,7 +61,12 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 
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
@@ -236,6 +243,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
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

