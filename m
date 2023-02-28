Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5984B6A5006
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 01:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjB1AJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 19:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjB1AJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 19:09:13 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDE17284
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:57 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536a4eba107so173417877b3.19
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D006eQccB/YfCTWYisON8RLDYL9oi52cmWtPqe0hG2Q=;
        b=gIjh3nfFBZCEmbLZxY9cp1FvHn6RY9fe8XhwD5eRTHENgNlVSZqBPNdH3YXYazv8fN
         5CnAiRZJwapuD3+6VAkcz9hrM9K7mX+4KYAnVGVnj7eWOc2xT2vwMI1vw42XRSXkJf0c
         Ss0+sAsslnDn0MFqH+k1e1LTDdwK0orODPOk5QA3qhO/1+tDpBqKtPwhZzTsDfnKSxQ6
         5TtWXV2yrqe6E5JiXzdg5djApMgbEQeqVlP6fqPO3Z7iahCFAUdHwiMrv3azVHqZUEc8
         XQfgbMx+WznNOM/tv/wmChpzbKQqvkxmMoYsSSWVeLgxx0RN6zIdJt+L7Pe5HM1bY0j/
         KGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D006eQccB/YfCTWYisON8RLDYL9oi52cmWtPqe0hG2Q=;
        b=1P3zID4eZ27oXIKNd185cggNC192h+uil2c32Rw+LXoVSMbUDRghowspeY8/1nKiLL
         Kvtp0jvBKJygTwr76gBXZHGEYI0JFpC7LmRhcvtYe1QCTPAxdXr+35qk2Amd8ggp+XQF
         wOTGU16SiYzwnBww4wMdxVAkBoenw0rlsJOxH0IJTr/TmOil80X4MtOdS9L/SSOBnKpq
         X3uchEtf4aSAu5923Sqx2U7/CtbgP/Zn2tV4vo+phAdbtqjZwv7muFdgeVBjN6jUv6Pz
         onPTrOzS/3ilBChlt/9aO9D/37D/uDicjdVEQdimMbNN8H1c1GyPtUc8/ZFWRhQaIGDr
         Fk+A==
X-Gm-Message-State: AO0yUKUeuQNdLiXju9T4FAuzpifx9IahvpSAReU5zL+XGTLq5HL7vHQi
        eV8VE7rFwtXaw1Scb+N5GIMMGFMhOIPGJiffRVVpdXxExw+sTHstyGldurfyKnrwC2vk67YyvNg
        /NUW8IvBwiG1FmL3eS4FvPSf1VhfMzYU92McXRDoRahp9RT6f+gMA8WENvyl1lbOtOZjY
X-Google-Smtp-Source: AK7set9MNbJkLgYlOqaghuoB+g0Ly4IF+DHAlQPysp1TABiQUhD2j9IAmfXheWt96/oV4RNHlHXooUwUbmg5GufK
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:118c:b0:a06:538f:265f with
 SMTP id m12-20020a056902118c00b00a06538f265fmr8975885ybu.4.1677542936347;
 Mon, 27 Feb 2023 16:08:56 -0800 (PST)
Date:   Tue, 28 Feb 2023 00:06:44 +0000
In-Reply-To: <20230228000644.3204402-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230228000644.3204402-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228000644.3204402-6-aaronlewis@google.com>
Subject: [PATCH v2 5/5] KVM: selftests: Test the PMU event "Instructions retired"
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

Add testing for the event "Instructions retired" (0xc0) in the PMU
event filter on both Intel and AMD to ensure that the event doesn't
count when it is disallowed.  Unlike most of the other events, the
event "Instructions retired", will be incremented by KVM when an
instruction is emulated.  Test that this case is being properly handled
and that KVM doesn't increment the counter when that event is
disallowed.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 80 ++++++++++++++-----
 1 file changed, 62 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 78bb48fcd33e..9e932b99d4fa 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -54,6 +54,21 @@
 
 #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
 
+
+/*
+ * "Retired instructions", from Processor Programming Reference
+ * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
+ * Preliminary Processor Programming Reference (PPR) for AMD Family
+ * 17h Model 31h, Revision B0 Processors, and Preliminary Processor
+ * Programming Reference (PPR) for AMD Family 19h Model 01h, Revision
+ * B1 Processors Volume 1 of 2.
+ *                      --- and ---
+ * "Instructions retired", from the Intel SDM, volume 3,
+ * "Pre-defined Architectural Performance Events."
+ */
+
+#define INST_RETIRED EVENT(0xc0, 0)
+
 /*
  * This event list comprises Intel's eight architectural events plus
  * AMD's "retired branch instructions" for Zen[123] (and possibly
@@ -61,7 +76,7 @@
  */
 static const uint64_t event_list[] = {
 	EVENT(0x3c, 0),
-	EVENT(0xc0, 0),
+	INST_RETIRED,
 	EVENT(0x3c, 1),
 	EVENT(0x2e, 0x4f),
 	EVENT(0x2e, 0x41),
@@ -71,6 +86,16 @@ static const uint64_t event_list[] = {
 	AMD_ZEN_BR_RETIRED,
 };
 
+struct perf_results {
+	union {
+		uint64_t raw;
+		struct {
+			uint64_t br_count:32;
+			uint64_t ir_count:32;
+		};
+	};
+};
+
 /*
  * If we encounter a #GP during the guest PMU sanity check, then the guest
  * PMU is not functional. Inform the hypervisor via GUEST_SYNC(0).
@@ -102,13 +127,20 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
 
 static uint64_t test_guest(uint32_t msr_base)
 {
+	struct perf_results r;
 	uint64_t br0, br1;
+	uint64_t ir0, ir1;
 
 	br0 = rdmsr(msr_base + 0);
+	ir0 = rdmsr(msr_base + 1);
 	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
 	br1 = rdmsr(msr_base + 0);
+	ir1 = rdmsr(msr_base + 1);
 
-	return br1 - br0;
+	r.br_count = br1 - br0;
+	r.ir_count = ir1 - ir0;
+
+	return r.raw;
 }
 
 static void intel_guest_code(void)
@@ -119,15 +151,17 @@ static void intel_guest_code(void)
 	GUEST_SYNC(1);
 
 	for (;;) {
-		uint64_t count;
+		uint64_t counts;
 
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 		wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | INTEL_BR_RETIRED);
-		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x1);
+		wrmsr(MSR_P6_EVNTSEL1, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | INST_RETIRED);
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
 
-		count = test_guest(MSR_IA32_PMC0);
-		GUEST_SYNC(count);
+		counts = test_guest(MSR_IA32_PMC0);
+		GUEST_SYNC(counts);
 	}
 }
 
@@ -143,14 +177,16 @@ static void amd_guest_code(void)
 	GUEST_SYNC(1);
 
 	for (;;) {
-		uint64_t count;
+		uint64_t counts;
 
 		wrmsr(MSR_K7_EVNTSEL0, 0);
 		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | AMD_ZEN_BR_RETIRED);
+		wrmsr(MSR_K7_EVNTSEL1, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | INST_RETIRED);
 
-		count = test_guest(MSR_K7_PERFCTR0);
-		GUEST_SYNC(count);
+		counts = test_guest(MSR_K7_PERFCTR0);
+		GUEST_SYNC(counts);
 	}
 }
 
@@ -250,19 +286,25 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 	return f;
 }
 
-#define ASSERT_PMC_COUNTING(count)							\
+#define ASSERT_PMC_COUNTING(counts)							\
 do {											\
-	if (count && count != NUM_BRANCHES)						\
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
-			__func__, count, NUM_BRANCHES);					\
-	TEST_ASSERT(count, "%s: Branch instructions retired = %lu (expected > 0)",	\
-		    __func__, count);							\
+	struct perf_results r = {.raw = counts};					\
+	if (r.br_count && r.br_count != NUM_BRANCHES)					\
+		pr_info("%s: Branch instructions retired = %u (expected %u)\n",		\
+			__func__, r.br_count, NUM_BRANCHES);				\
+	TEST_ASSERT(r.br_count,	"%s: Branch instructions retired = %u (expected > 0)",	\
+		    __func__, r.br_count);						\
+	TEST_ASSERT(r.ir_count,	"%s: Instructions retired = %u (expected > 0)",		\
+		    __func__, r.ir_count);						\
 } while (0)
 
-#define ASSERT_PMC_NOT_COUNTING(count)							\
+#define ASSERT_PMC_NOT_COUNTING(counts)							\
 do {											\
-	TEST_ASSERT(!count, "%s: Branch instructions retired = %lu (expected 0)",	\
-		    __func__, count);							\
+	struct perf_results r = {.raw = counts};					\
+	TEST_ASSERT(!r.br_count, "%s: Branch instructions retired = %u (expected 0)",	\
+		    __func__, r.br_count);						\
+	TEST_ASSERT(!r.ir_count, "%s: Instructions retired = %u (expected 0)",		\
+		    __func__, r.ir_count);						\
 } while (0)
 
 static void test_without_filter(struct kvm_vcpu *vcpu)
@@ -317,6 +359,7 @@ static void test_not_member_deny_list(struct kvm_vcpu *vcpu)
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
 	uint64_t c;
 
+	remove_event(f, INST_RETIRED);
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
 	c = test_with_filter(vcpu, f);
@@ -330,6 +373,7 @@ static void test_not_member_allow_list(struct kvm_vcpu *vcpu)
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
 	uint64_t c;
 
+	remove_event(f, INST_RETIRED);
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
 	c = test_with_filter(vcpu, f);
-- 
2.39.2.722.g9855ee24e9-goog

