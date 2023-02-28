Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9829E6A5003
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 01:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjB1AJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 19:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjB1AJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 19:09:13 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FA83C17
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:55 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id s8-20020a170902b18800b0019c92f56a8aso4435976plr.22
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sExX4ipGAFA5HR1B4tUeetDfYpcC755hrJJmqJQj/nI=;
        b=BL+SSvniZL6hJK6GecG807zeJqcw3hq2K+WkWSJAQshjtU2FPzuditvX40NmmrhTv6
         rul8V7l3rhM5i5KDuuKCqPG16Ul5Fl/fTDT7TQKqZm/ynbpqDcjasMUgY3Wa58CditSH
         NcZW2mDtoS1oXZHdK1bUKXBt5Hjfdpy55TYOB+0/9L1bWro0UVt2ijf2NmR/aU7KtUhV
         nmCTQQe42dCJ14vlfO8DxdruEhvOFBsguYGhYea7Q+9msdzxs5I0LWh1+TYjSjyKdM2c
         PCmAShs+CxaVXVnngkMCRfYVbHW/We3u6GIO8uchz/OMnpqUEGZgcu8+LdEry00PX0UD
         IwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sExX4ipGAFA5HR1B4tUeetDfYpcC755hrJJmqJQj/nI=;
        b=cwyyRtq5r0g6WkV7FBLFxxReBnnvnPqB6+y/56dXhsY4mwDS+Ep1w6AfM7xSvjYxqL
         8BSJDvtZul2BHQXifkF9Hh4+Oc/EwCmkUb/9GF3VJwKLNu+KwA1Ze5bOhS0ri48AOliG
         Qcuq8dpkAIRqnmWvzaGQFWl9LI4B0EnVAEdwFodI410MDHpDaEZ74rECJVuuu2ywRBGk
         dEHR1PT7xV2JNBPNJI1kKIDp+1K1/os+NZQ9O0lDgdOmslBlr21ura3m7weF9FxRUb/N
         i0fW1HpLoMavSv4xk92DEPdWEKIc3LqHGu9KVQL2bFw1+MPP4f1zceejE98W+A9wQJ/M
         l7cA==
X-Gm-Message-State: AO0yUKW41kDOTo0tHty2TbZipYNZMrwER+KM91kE0EhR7Ny/pdT2AQj1
        ohkh9LFaBL+PRNiO1G5Ow0LOOdObw3DK9xWmwdLUhA2JxN9E94e5AEdE+wkI8QWtJvLe0Vj98Wo
        6gH9A8iu6oRyVzLBWFNfrEzujoXmk98nJBSuMSweQ0Zsd9c0RWdGMLzx5/DItHX2F6Lol
X-Google-Smtp-Source: AK7set8+RalalUFulr1TP4UKoJ7I/A6yJv1ZPo3jY9UBB/CAItxtaXKIPvb1J4+x/eStiu9KV1te9IQJS5B24jDy
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:26eb:b0:5de:ece4:2674 with
 SMTP id p43-20020a056a0026eb00b005deece42674mr305826pfw.3.1677542932825; Mon,
 27 Feb 2023 16:08:52 -0800 (PST)
Date:   Tue, 28 Feb 2023 00:06:42 +0000
In-Reply-To: <20230228000644.3204402-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230228000644.3204402-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228000644.3204402-4-aaronlewis@google.com>
Subject: [PATCH v2 3/5] KVM: selftests: Add helpers for PMC asserts
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

Add the helpers, ASSERT_PMC_COUNTING and ASSERT_PMC_NOT_COUNTING, to
split out the asserts into one place.  This will make it easier to add
additional asserts related to counting later on.

No functional changes intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 70 ++++++++++---------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index f33079fc552b..8277b8f49dca 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -250,14 +250,27 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 	return f;
 }
 
+#define ASSERT_PMC_COUNTING(count)							\
+do {											\
+	if (count != NUM_BRANCHES)							\
+		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
+			__func__, count, NUM_BRANCHES);					\
+	TEST_ASSERT(count, "Allowed PMU event is not counting.");			\
+} while (0)
+
+#define ASSERT_PMC_NOT_COUNTING(count)							\
+do {											\
+	if (count)									\
+		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",		\
+			__func__, count);						\
+	TEST_ASSERT(!count, "Disallowed PMU Event is counting");			\
+} while (0)
+
 static void test_without_filter(struct kvm_vcpu *vcpu)
 {
-	uint64_t count = run_vcpu_to_sync(vcpu);
+	uint64_t c = run_vcpu_to_sync(vcpu);
 
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+	ASSERT_PMC_COUNTING(c);
 }
 
 static uint64_t test_with_filter(struct kvm_vcpu *vcpu,
@@ -271,70 +284,59 @@ static void test_amd_deny_list(struct kvm_vcpu *vcpu)
 {
 	uint64_t event = EVENT(0x1C2, 0);
 	struct kvm_pmu_event_filter *f;
-	uint64_t count;
+	uint64_t c;
 
 	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY, 0);
-	count = test_with_filter(vcpu, f);
-
+	c = test_with_filter(vcpu, f);
 	free(f);
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+
+	ASSERT_PMC_COUNTING(c);
 }
 
 static void test_member_deny_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
-	uint64_t count = test_with_filter(vcpu, f);
+	uint64_t c = test_with_filter(vcpu, f);
 
 	free(f);
-	if (count)
-		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
-			__func__, count);
-	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+
+	ASSERT_PMC_NOT_COUNTING(c);
 }
 
 static void test_member_allow_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
-	uint64_t count = test_with_filter(vcpu, f);
+	uint64_t c = test_with_filter(vcpu, f);
 
 	free(f);
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+
+	ASSERT_PMC_COUNTING(c);
 }
 
 static void test_not_member_deny_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
-	uint64_t count;
+	uint64_t c;
 
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
-	count = test_with_filter(vcpu, f);
+	c = test_with_filter(vcpu, f);
 	free(f);
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+
+	ASSERT_PMC_COUNTING(c);
 }
 
 static void test_not_member_allow_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
-	uint64_t count;
+	uint64_t c;
 
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
-	count = test_with_filter(vcpu, f);
+	c = test_with_filter(vcpu, f);
 	free(f);
-	if (count)
-		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
-			__func__, count);
-	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+
+	ASSERT_PMC_NOT_COUNTING(c);
 }
 
 /*
-- 
2.39.2.722.g9855ee24e9-goog

