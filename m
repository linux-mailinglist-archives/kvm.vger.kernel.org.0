Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D2A67D228
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 17:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjAZQx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 11:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjAZQx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 11:53:58 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1A57A86
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:53:57 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4cddba76f55so26215617b3.23
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2L3ER9SzABa+sDdvSwBbApK/Tx8lI+xii3tE+VgX11c=;
        b=Hr2CZb/TkOwfy5Pp+ggEBYNreT4Nj+fEELm5KwjWNo9wixRPcQ7OhuBOHEhnAdFvzT
         L6DLY5h6Z1wKIOGuHCjMV/wR7ke5kX+PX5dckvNqhTG3DnE/bnZmrJ6Dowrqts/dHf4s
         Sjec8bzvZW1Psa2vIEdAvo9k8xB+H2Xkd4B7epkTIm0MBoNbf+Z2+cZIqyF9mrw3x3J8
         rGgBNdepfhOqJcoDKsdr+Pqpj+UOpCNMWRoJdcZb0k26KvWuUi4P/b6EMWnnXB1h+f18
         5VfR5I7gc0jBCz38ztLcUZCpFjfz5J/w2z0OMWzpCGk/IeQM0mnOK4KeeaJPKz+IZ3LB
         eiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2L3ER9SzABa+sDdvSwBbApK/Tx8lI+xii3tE+VgX11c=;
        b=cFpzQ1uJSYpVgkHv3l9lQLhbdHptJ260YMM90LkheUIM1RLtjQ7I8jTMnyjdETg8f0
         +ugG8X8w5F04kUQY38n1cZTI8we2tudrxtyk9nyo3D/xiWDyhi6NviocQ8gUC3Oqn+q5
         7Ii0775TnMyKL7OWvZd1kxbrAaR+akFvgO6vNX8Fu97TC/vHrlTm5YHx70OumX1RnBPV
         MaeexX0P7PdM+q0KI00y9HHxlGy1mjoIb5CWet/ldOWiQv2kmtcIq2lQtGBfgnFrX5dc
         U9XXJ8j+OiTybFgabOWsYeCRBk08wB6WlcS3qVzFMO/adkxzCAPYiaWFiU13A4YNj72m
         mkzQ==
X-Gm-Message-State: AFqh2kr4V9VcZwvc6BB3obqMRVKYm630ZO3Ndl2LSbhZEZ1pTMnL4js8
        M1x4Jl4lfHjCqOCp5k53npP8ssuGvBNA543vaDd1Nd/N8FP/sg4quQJl/mnC5YwH9iUnnNbWRDj
        DIcfdYFTcOXQl3Zo/0q64m53DMpxuFECZkxL3KmouuJJGUtaf5bHcYAPDBarQ7HY=
X-Google-Smtp-Source: AMrXdXvgfGoyjWUZth5F4JKgaiPd8lntZP1O+F6uUABaLGE8kCNPIo0DECSCR3FhBqS0V/figGDuDKWzajFKug==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:8d06:0:b0:7be:813e:1f2b with SMTP id
 n6-20020a258d06000000b007be813e1f2bmr4298882ybl.508.1674752036924; Thu, 26
 Jan 2023 08:53:56 -0800 (PST)
Date:   Thu, 26 Jan 2023 16:53:47 +0000
In-Reply-To: <20230126165351.2561582-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230126165351.2561582-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-3-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 2/6] arm: pmu: Prepare for testing 64-bit overflows
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
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

PMUv3p5 adds a knob, PMCR_EL0.LP == 1, that allows overflowing at 64-bits
instead of 32. Prepare by doing these 3 things:

1. Add a "bool overflow_at_64bits" argument to all tests checking
   overflows.
2. Extend satisfy_prerequisites() to check if the machine supports
   "overflow_at_64bits".
3. Refactor the test invocations to use the new "run_test()" which adds a
   report prefix indicating whether the test uses 64 or 32-bit overflows.

A subsequent commit will actually add the 64-bit overflow tests.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arm/pmu.c | 99 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 39 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 7f0794d..06cbd73 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -164,13 +164,13 @@ static void pmu_reset(void)
 /* event counter tests only implemented for aarch64 */
 static void test_event_introspection(void) {}
 static void test_event_counter_config(void) {}
-static void test_basic_event_count(void) {}
-static void test_mem_access(void) {}
-static void test_sw_incr(void) {}
-static void test_chained_counters(void) {}
-static void test_chained_sw_incr(void) {}
-static void test_chain_promotion(void) {}
-static void test_overflow_interrupt(void) {}
+static void test_basic_event_count(bool overflow_at_64bits) {}
+static void test_mem_access(bool overflow_at_64bits) {}
+static void test_sw_incr(bool overflow_at_64bits) {}
+static void test_chained_counters(bool unused) {}
+static void test_chained_sw_incr(bool unused) {}
+static void test_chain_promotion(bool unused) {}
+static void test_overflow_interrupt(bool overflow_at_64bits) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -435,13 +435,24 @@ static uint64_t pmevcntr_mask(void)
 	return (uint32_t)~0;
 }
 
-static void test_basic_event_count(void)
+static bool check_overflow_prerequisites(bool overflow_at_64bits)
+{
+	if (overflow_at_64bits && pmu.version < ID_DFR0_PMU_V3_8_5) {
+		report_skip("Skip test as 64 overflows need FEAT_PMUv3p5");
+		return false;
+	}
+
+	return true;
+}
+
+static void test_basic_event_count(bool overflow_at_64bits)
 {
 	uint32_t implemented_counter_mask, non_implemented_counter_mask;
 	uint32_t counter_mask;
 	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
+	    !check_overflow_prerequisites(overflow_at_64bits))
 		return;
 
 	implemented_counter_mask = BIT(pmu.nb_implemented_counters) - 1;
@@ -515,12 +526,13 @@ static void test_basic_event_count(void)
 		"check overflow happened on #0 only");
 }
 
-static void test_mem_access(void)
+static void test_mem_access(bool overflow_at_64bits)
 {
 	void *addr = malloc(PAGE_SIZE);
 	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
+	    !check_overflow_prerequisites(overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -551,13 +563,14 @@ static void test_mem_access(void)
 			read_sysreg(pmovsclr_el0));
 }
 
-static void test_sw_incr(void)
+static void test_sw_incr(bool overflow_at_64bits)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
 	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
+	    !check_overflow_prerequisites(overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -597,7 +610,7 @@ static void test_sw_incr(void)
 		"overflow on counter #0 after 100 SW_INCR");
 }
 
-static void test_chained_counters(void)
+static void test_chained_counters(bool unused)
 {
 	uint32_t events[] = {CPU_CYCLES, CHAIN};
 
@@ -638,7 +651,7 @@ static void test_chained_counters(void)
 	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
-static void test_chained_sw_incr(void)
+static void test_chained_sw_incr(bool unused)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
 	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
@@ -691,7 +704,7 @@ static void test_chained_sw_incr(void)
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
-static void test_chain_promotion(void)
+static void test_chain_promotion(bool unused)
 {
 	uint32_t events[] = {MEM_ACCESS, CHAIN};
 	void *addr = malloc(PAGE_SIZE);
@@ -840,13 +853,14 @@ static bool expect_interrupts(uint32_t bitmap)
 	return true;
 }
 
-static void test_overflow_interrupt(void)
+static void test_overflow_interrupt(bool overflow_at_64bits)
 {
 	uint32_t events[] = {MEM_ACCESS, SW_INCR};
 	void *addr = malloc(PAGE_SIZE);
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
+	    !check_overflow_prerequisites(overflow_at_64bits))
 		return;
 
 	gic_enable_defaults();
@@ -1070,6 +1084,27 @@ static bool pmu_probe(void)
 	return true;
 }
 
+static void run_test(const char *name, const char *prefix,
+		     void (*test)(bool), void *arg)
+{
+	report_prefix_push(name);
+	report_prefix_push(prefix);
+
+	test(arg);
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
+static void run_event_test(char *name, void (*test)(bool),
+			   bool overflow_at_64bits)
+{
+	const char *prefix = overflow_at_64bits ? "64-bit overflows"
+						: "32-bit overflows";
+
+	run_test(name, prefix, test, (void *)overflow_at_64bits);
+}
+
 int main(int argc, char *argv[])
 {
 	int cpi = 0;
@@ -1102,33 +1137,19 @@ int main(int argc, char *argv[])
 		test_event_counter_config();
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
-		report_prefix_push(argv[1]);
-		test_basic_event_count();
-		report_prefix_pop();
+		run_event_test(argv[1], test_basic_event_count, false);
 	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
-		report_prefix_push(argv[1]);
-		test_mem_access();
-		report_prefix_pop();
+		run_event_test(argv[1], test_mem_access, false);
 	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
-		report_prefix_push(argv[1]);
-		test_sw_incr();
-		report_prefix_pop();
+		run_event_test(argv[1], test_sw_incr, false);
 	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
-		report_prefix_push(argv[1]);
-		test_chained_counters();
-		report_prefix_pop();
+		run_event_test(argv[1], test_chained_counters, false);
 	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
-		report_prefix_push(argv[1]);
-		test_chained_sw_incr();
-		report_prefix_pop();
+		run_event_test(argv[1], test_chained_sw_incr, false);
 	} else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
-		report_prefix_push(argv[1]);
-		test_chain_promotion();
-		report_prefix_pop();
+		run_event_test(argv[1], test_chain_promotion, false);
 	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
-		report_prefix_push(argv[1]);
-		test_overflow_interrupt();
-		report_prefix_pop();
+		run_event_test(argv[1], test_overflow_interrupt, false);
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
-- 
2.39.1.456.gfc5497dd1b-goog

