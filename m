Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29321648932
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 20:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiLITuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 14:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiLITuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 14:50:11 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC7654367
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 11:50:10 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso3770177pjb.6
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 11:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsFRMywDo5D+Oyj39yYT+UOuIsM7G19fY1mVfbubz78=;
        b=EEgcCJ4lVL0/IhcTKW/r1bZq5TODT7lopcFBjhSRPphoS7nDgm0VyZAvZsVyRZo+3r
         QSJlHLbmcwJjXCJfQjlBi8wx5zhUfvaRufCiHuHTVazcSReDu00Z0kzUeDU8g3O3wohN
         s2IFXFl35tg6BNP9kxmuTXyYQQ0u0HU7BzL0Ljj164Hl/L2jQhgGOEWTixMohZCSaHkN
         qE+VrNPIvvw1TizuOeu3/LbECbGWP3s+4PcDmvqKdVLGygC7WwSTstebuBP2yK5CTHMF
         0y62Y6XQUycFVMJHhvNUGN7Ho5Ln6r5fJpf5K7Hx4PiUbSVQBVUkjxfOPfXDDgvIFuM9
         xrUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PsFRMywDo5D+Oyj39yYT+UOuIsM7G19fY1mVfbubz78=;
        b=scTcOnUljivlDWYeoT8y8KXGTzuVyuGFnph8UnO+cf0v+0i70fReVk5zEtI6RTq1WN
         D8Zhvqgu3bE6Wqb0B1c5K3B1cx46fTe24DU0n5U6x60tgrG7twfm5gNOCR/o9Af0MLNJ
         vAglHKFQnRk9PioYeNhZj94/1PSbPEGnmVsYbGh2Yamae+TtKOO/AZDOWwGVfvWiPenU
         Lny0Zi4r5D99m36SrIZPQspQnjSa0kkk+m8bEIK5Qwe71GL5dZiz1HREfw5KC90lJKO8
         zUaV9cJkJu5XSkbZanGBkz9ahzLy+Z3yqRF2BKx8jpwP/vyFa2p7Yic06UwUVVnNbLd3
         t4Xg==
X-Gm-Message-State: ANoB5pl35BHiC0kCb/Ky3QNAiH49nomEcFzANhhu+evoTCEcZYoFXfDV
        PffWT5PbouO6Sfk0xC1CMteNl+FSknyYMWm/LX3SqJEMOPvrrrGIOuHClR0PbF+AcaT/Gjn2S0S
        +vpyK9Hg46oYxE1KYFNPeYuY9Xl5xX31ziLvfeg87xbWnGaiAufJEAAKKhp+6Sfzg1Y/W
X-Google-Smtp-Source: AA0mqf5aU2bm+O9MXAH9/sHx0aj6GBFW1X7MVZaW3RAaDRZHmfzypvRJm6AjA4tl9+3FV/jLIJsr2T+0X818nC/3
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:148f:0:b0:560:ee47:81e1 with SMTP
 id 137-20020a62148f000000b00560ee4781e1mr83068394pfu.63.1670615409576; Fri,
 09 Dec 2022 11:50:09 -0800 (PST)
Date:   Fri,  9 Dec 2022 19:49:57 +0000
In-Reply-To: <20221209194957.2774423-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221209194957.2774423-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221209194957.2774423-3-aaronlewis@google.com>
Subject: [PATCH 2/2] KVM: selftests: Test the PMU event "Instructions retired"
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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
 .../kvm/x86_64/pmu_event_filter_test.c        | 157 ++++++++++++------
 1 file changed, 110 insertions(+), 47 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 2de98fce7edd..81311af9522a 100644
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
+ *    			--- and ---
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
@@ -100,6 +125,24 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
 		GUEST_SYNC(0);
 }
 
+static uint64_t test_guest(uint32_t msr_base)
+{
+	struct perf_results r;
+	uint64_t br0, br1;
+	uint64_t ir0, ir1;
+
+	br0 = rdmsr(msr_base + 0);
+	ir0 = rdmsr(msr_base + 1);
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+	br1 = rdmsr(msr_base + 0);
+	ir1 = rdmsr(msr_base + 1);
+
+	r.br_count = br1 - br0;
+	r.ir_count = ir1 - ir0;
+
+	return r.raw;
+}
+
 static void intel_guest_code(void)
 {
 	check_msr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
@@ -108,16 +151,17 @@ static void intel_guest_code(void)
 	GUEST_SYNC(1);
 
 	for (;;) {
-		uint64_t br0, br1;
+		uint64_t counts;
 
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 		wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | INTEL_BR_RETIRED);
-		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
-		br0 = rdmsr(MSR_IA32_PMC0);
-		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
-		br1 = rdmsr(MSR_IA32_PMC0);
-		GUEST_SYNC(br1 - br0);
+		wrmsr(MSR_P6_EVNTSEL1, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | INST_RETIRED);
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
+
+		counts = test_guest(MSR_IA32_PMC0);
+		GUEST_SYNC(counts);
 	}
 }
 
@@ -133,15 +177,16 @@ static void amd_guest_code(void)
 	GUEST_SYNC(1);
 
 	for (;;) {
-		uint64_t br0, br1;
+		uint64_t counts;
 
 		wrmsr(MSR_K7_EVNTSEL0, 0);
 		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | AMD_ZEN_BR_RETIRED);
-		br0 = rdmsr(MSR_K7_PERFCTR0);
-		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
-		br1 = rdmsr(MSR_K7_PERFCTR0);
-		GUEST_SYNC(br1 - br0);
+		wrmsr(MSR_K7_EVNTSEL1, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | INST_RETIRED);
+
+		counts = test_guest(MSR_K7_PERFCTR0);
+		GUEST_SYNC(counts);
 	}
 }
 
@@ -240,14 +285,39 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 	return f;
 }
 
+#define expect_success(r) __expect_success(r, __func__)
+
+static void __expect_success(struct perf_results r, const char *func) {
+	if (r.br_count != NUM_BRANCHES)
+		pr_info("%s: Branch instructions retired = %u (expected %u)\n",
+			func, r.br_count, NUM_BRANCHES);
+
+	TEST_ASSERT(r.br_count,
+		    "Allowed event, branch instructions retired, is not counting.");
+	TEST_ASSERT(r.ir_count,
+		    "Allowed event, instructions retired, is not counting.");	
+} 
+
+#define expect_failure(r) __expect_failure(r, __func__)
+
+static void __expect_failure(struct perf_results r, const char *func) {
+	if (r.br_count)
+		pr_info("%s: Branch instructions retired = %u (expected 0)\n",
+			func, r.br_count);
+
+	TEST_ASSERT(!r.br_count,
+		    "Disallowed PMU event, branch instructions retired, is counting");
+	TEST_ASSERT(!r.ir_count,
+		    "Disallowed PMU event, instructions retired, is counting");
+}
+
 static void test_without_filter(struct kvm_vcpu *vcpu)
 {
-	uint64_t count = run_vcpu_to_sync(vcpu);
+	struct perf_results r;
 
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+	r.raw = run_vcpu_to_sync(vcpu);
+
+	expect_success(r);
 }
 
 static uint64_t test_with_filter(struct kvm_vcpu *vcpu,
@@ -261,70 +331,63 @@ static void test_amd_deny_list(struct kvm_vcpu *vcpu)
 {
 	uint64_t event = EVENT(0x1C2, 0);
 	struct kvm_pmu_event_filter *f;
-	uint64_t count;
+	struct perf_results r;
 
 	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY);
-	count = test_with_filter(vcpu, f);
-
+	r.raw = test_with_filter(vcpu, f);
 	free(f);
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+
+	expect_success(r);
 }
 
 static void test_member_deny_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
-	uint64_t count = test_with_filter(vcpu, f);
+	struct perf_results r;
+
+	r.raw = test_with_filter(vcpu, f);
 
 	free(f);
-	if (count)
-		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
-			__func__, count);
-	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+
+	expect_failure(r);
 }
 
 static void test_member_allow_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
-	uint64_t count = test_with_filter(vcpu, f);
+	struct perf_results r;
 
+	r.raw = test_with_filter(vcpu, f);
 	free(f);
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+
+	expect_success(r);
 }
 
 static void test_not_member_deny_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
-	uint64_t count;
+	struct perf_results r;
 
+	remove_event(f, INST_RETIRED);
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
-	count = test_with_filter(vcpu, f);
+	r.raw = test_with_filter(vcpu, f);
 	free(f);
-	if (count != NUM_BRANCHES)
-		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
-			__func__, count, NUM_BRANCHES);
-	TEST_ASSERT(count, "Allowed PMU event is not counting");
+
+	expect_success(r);
 }
 
 static void test_not_member_allow_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
-	uint64_t count;
+	struct perf_results r;
 
+	remove_event(f, INST_RETIRED);
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
-	count = test_with_filter(vcpu, f);
-	free(f);
-	if (count)
-		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
-			__func__, count);
-	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+	r.raw = test_with_filter(vcpu, f);
+
+	expect_failure(r);
 }
 
 /*
-- 
2.39.0.rc1.256.g54fd8350bd-goog

