Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117AB6AE234
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 15:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjCGOYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 09:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjCGOY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 09:24:27 -0500
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463338C0FC
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 06:19:41 -0800 (PST)
Received: by mail-pl1-f202.google.com with SMTP id u4-20020a170902bf4400b0019e30a57694so7886345pls.20
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 06:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678198634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/MMz8rdBKrtWI7nlrUpQqxtFPLeRESqGCq83DZzXLMk=;
        b=tnAwhuWbVQoYJNDHY8n7woojAntfW20a3Ld8LgbzC4I4voZaeblfpwZLDFITtkJFWH
         +lpbrHohNvyqU7Js4yDw+KUxA7ZiU9ec5uqt046trl+gCYbYQIC6IOFgiftLulSJFKV3
         RXSphSqWNt+8BN5+1Gr7L3yubryDAaVhneT4yfa3kTklE7+ud1abFyDIMPfsVO1oo9H6
         F/X3GS+7vgsYv0XD+odjnaTarJ1TBoBij+ygt8+F0XVXrJm85AttcRJTQk2zW/nbAtpZ
         uvHpfapBRtKkyFh5MHXrwKAinrWFffTMvb/2KdnCKy9+X36XhRWmTv0RCJOOln+KO7Mx
         w0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678198634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/MMz8rdBKrtWI7nlrUpQqxtFPLeRESqGCq83DZzXLMk=;
        b=WCAvn+h8rWFlDLrRBR6u4jLWo9/3/LhzRFSZtf+yMsqBDlZif4X78XRhW7rwIm5PxR
         R1Trl7wjl9VzrKDme00/iJUlLTgqKHasTLKKzxWmFhQCKkLWXn5BFBP1at+283icHlFW
         BH0baSlu5z3XViweTcJjf6xfJXhf4GjhZ11CpY7iN7aUjDmHV7xFneF+9ifO+cEiwfPO
         90528YSkbieLfEgFkJ1N4g0kgbxEIUvtyuZT45SSwfZLZXHHRFMzEOhsgAdxQJH2jHrj
         co+vj4mnLc52G2hsgB2R5j32TuWar3O1Q7hN3weK0ISIP6Ma/AfCSniwRzn5r0s7gzTc
         EnIQ==
X-Gm-Message-State: AO0yUKWv/dQ/p+UZn9voNWkY/2myR1j5lYcAiDJ8Z9pMGkcr8RNMeo/O
        RSN0zvpAJIwcTV1owvoF69UbqVqOMO4WE76fUH0RNCBmFZ3nRuDDhkncr1zx1fzu2KP0dHS7ktg
        w702fFXaYztnthEKSlaNdcq8o5OrMEB3x29Y3OykDoFLuoJIiUZ4nB6fCxYdUBEqpkALK
X-Google-Smtp-Source: AK7set+0yz0wVLYPy2obVY4Z3jHYRxtmnxH5dw3Kvsp9B/YQi9iTRNPUu2KJbrQGG3e8iWYXQGiqBbtjY9nIn9B1
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a62:db83:0:b0:61c:67d2:a332 with SMTP
 id f125-20020a62db83000000b0061c67d2a332mr2735714pfg.3.1678198634473; Tue, 07
 Mar 2023 06:17:14 -0800 (PST)
Date:   Tue,  7 Mar 2023 14:13:58 +0000
In-Reply-To: <20230307141400.1486314-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307141400.1486314-4-aaronlewis@google.com>
Subject: [PATCH v3 3/5] KVM: selftests: Add helpers for PMC asserts
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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
2.40.0.rc0.216.gc4246ad0f0-goog

