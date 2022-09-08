Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCB05B27F2
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 22:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiIHUy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 16:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiIHUyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 16:54:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1603C170
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 13:54:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3451078bb11so125621937b3.19
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 13:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=b0WdjrSKBh4BHzy44MCcrJw33QzuSMeA7jx0CKwspr0=;
        b=tKiQ4bUkZJHjfrYHk5BbODEyItQJ7S4MGkkfwNzVqvJBP4ltkjpGvTH+l/u3YRHjwX
         0CN1QAf2bIj7GgXBHzzA1pC+EhFOuA38d0R/l6J/4t+RvHFkDnwNobP0M2D1Nk065xoK
         EnOEzD97wKnQICHXLMaoZ2aADYMv7SQIkxcsQNe9A3CmOWZQAgPbrSpRxmLxpz5Xmn7z
         xhkwjdcFAHM1l4do0X5pbYxwpA4cJan7nEs38rV8uAIO0gI4UYyWxxkA62XZdFPH9gHf
         xqUqMRm+SSy+HcEfrO+srWPnlGdyg6adC+M85gCl2/OzJt9KnjB0+g61GXcYgg7BoZ49
         TvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=b0WdjrSKBh4BHzy44MCcrJw33QzuSMeA7jx0CKwspr0=;
        b=CubtehaMMsntkOVF/kQ+mf8UfuC7Nmj0utjR8viU6bXK55S4k1Kxrt0p3xt3AdCVcZ
         UjoQFB+tFaYcVr4p1ok4jzj/4RywfTEvjbWLfBwIvwPKLGQblEfNuhacFQ0j5DJV+4hO
         +IsjnOQwd0Jyfpq0mjhoFHWSUE9QemeCfqTm45orO47EUdMFXzWfkbtin/DZiCzmAk5R
         trlrS49WgNu6vExyomd/IpQxkuvl0S/8vdo+3yKqfOTi3HSujuCuLcDKfkI7lDJN9jCp
         YdPoqJe0f+az2AkZ/Sun18jY9XzbHPqgeJ+9FJ7/Eb/+ic1se5DIcRATMso0mIFNnjAz
         mjig==
X-Gm-Message-State: ACgBeo1cGexx4Lc6pzqBKTFqXJe+DQtadAjTKjYZzRVU5nRlbTwSmxqW
        GFh0H+lpZ5uv2PPBCLC+N+heZdjno5qPBMQbDD1FaQUdwqMCf8RathnO6sj0tOcx9ROpWbI7FQ2
        CzTa77iwlJkUGcz6Nuim5ULcagiVwWOr+dIEddtYB7cZbXiwlcnqZ/J+ta3G5yioydoXIJGo=
X-Google-Smtp-Source: AA6agR53DGMLxK/MMcRae4s+XtDOYZuuYcMdqKgfWSM+ef4ywcAYfUgqv1oIhH+ydrzWyX/p3coxnqeV6MasNSCiIw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:b683:0:b0:6a7:8b48:b9c1 with SMTP
 id s3-20020a25b683000000b006a78b48b9c1mr8753337ybj.506.1662670484735; Thu, 08
 Sep 2022 13:54:44 -0700 (PDT)
Date:   Thu,  8 Sep 2022 20:53:47 +0000
In-Reply-To: <20220908205347.3284344-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220908205347.3284344-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908205347.3284344-4-coltonlewis@google.com>
Subject: [PATCH v4 3/3] KVM: selftests: randomize page access order
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
 tools/testing/selftests/kvm/dirty_log_perf_test.c    | 11 +++++++++--
 tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c     |  9 ++++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 6f2c14dd8a65..4c45efe666b4 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -127,6 +127,7 @@ struct test_params {
 	int slots;
 	uint32_t write_percent;
 	uint32_t random_seed;
+	bool random_access;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -251,6 +252,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	/* Allow the vCPUs to populate memory */
 	perf_test_set_write_percent(vm, 100);
+	perf_test_set_random_access(vm, false);
 	pr_debug("Starting iteration %d - Populating\n", iteration);
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) !=
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
index 12a3597be1f9..5372f0b6c57a 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -46,6 +46,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
 	uint64_t gva;
 	uint64_t pages;
+	uint64_t addr;
 	int i;
 	uint32_t rand = pta->random_seed + vcpu_id;
 
@@ -57,7 +58,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * pta->guest_page_size);
+			addr = gva + (i * pta->guest_page_size);
 			guest_random(&rand);
 
 			if (rand % 100 < pta->write_percent)
@@ -233,6 +234,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
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

