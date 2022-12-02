Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9418C63FF9D
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 05:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiLBEzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 23:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiLBEzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 23:55:35 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF588CAF95
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 20:55:34 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y133-20020a25328b000000b006f997751950so3987704yby.7
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 20:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UWYoC1C7vLvgwnuJf/5t4YZu/UYVRlMlPl/Nd3cz8/k=;
        b=UKkIYduyOROeBe/8qzDkIHE+bh3g2clbyI9VybMrxEYMnL+5qIlK+c3SBaFAf3UVPo
         +68JmioMgLci+SyF0diG4OkWwH5J36rf8pcripXk7LF8mcYxxpVD0pTePemAffdjeOR6
         +Q+GiuFkRXwQUp3PWhtEefYYvIl7z0n0Qd+yAZd7on1apiAKNwCdsaOtA0ZitpRHqZBr
         hk+z13TtaCZ/98QH01jLzVd72LCnSSpAIaPZDFHOcv9Y1sBzf/PPjoM25egQKiGg0Ojk
         Z4Ni3Oc6wnmS+ZkI8kxLM5N1yzWA07FkHlKVyxIzETd+G3FAO7qdqUaB5dAsUD7N4wXa
         Y+zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UWYoC1C7vLvgwnuJf/5t4YZu/UYVRlMlPl/Nd3cz8/k=;
        b=2Y5nOu77xlOp8SHEe/uk5tznzdVpR9/ieTu2V0RxWQvrDCi/LyIZWxtaYulnDiEwmZ
         p/DoWBvfsFHgogPkj6P+I6xOjtvbY+OfS2YypMztJ3eQO2PTgio3/YxV+zZHL0UxdhZ1
         PalbhiY2HbygMW0DN3wXYoR8iO8wChNGDcOfBUe4Ue0QPxh5CB2TBVvLVF+N+ER0+Nl2
         PepGvEXGNQvcLIPm3685JKP0KA4YLJLwpHuWLlp0BHhg71T9M/9Sy7aLRveAGFXkanft
         C9tZThj401x2pEOjh0bTuQF/NNAd2oSQb0RKGd0Kjy4YNhiJIERv9KpoHWpVv10SC+2p
         Tu/A==
X-Gm-Message-State: ANoB5pmeFNFKPghrNCrAJ5k4e9Mfc64/nTyXl+lc2k9L9UuR05sScf7h
        lXe0F8Gskxl0RIazoHddq1Lb1mch2i+LCKOyFpPXyMvK65B63DhgBAUHPNcq557lIEhr537b2lm
        lfb4A4z7OcI+p9Ir8Rcao1U4ibRQCmMRPAlIR14eFKpj6FAePqFllJTrTNSC3ugE=
X-Google-Smtp-Source: AA0mqf5IaOCoNyWyBRi5C+jCmWXfzVKN66yMb+RMB1AWswia+RjOzlKyD4WeO4T93LoK0iPURRk0rV6XBGbVlg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:5583:0:b0:6e7:878:74 with SMTP id
 j125-20020a255583000000b006e708780074mr49333861ybb.645.1669956934065; Thu, 01
 Dec 2022 20:55:34 -0800 (PST)
Date:   Fri,  2 Dec 2022 04:55:26 +0000
In-Reply-To: <20221202045527.3646838-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221202045527.3646838-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202045527.3646838-3-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH 2/3] arm: pmu: Prepare for testing 64-bit overflows
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
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
---
 arm/pmu.c | 99 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 43 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index eeac984..59e5bfe 100644
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
+static void test_chained_counters(bool overflow_at_64bits) {}
+static void test_chained_sw_incr(bool overflow_at_64bits) {}
+static void test_chain_promotion(bool overflow_at_64bits) {}
+static void test_overflow_interrupt(bool overflow_at_64bits) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -399,7 +399,8 @@ static void test_event_counter_config(void)
 		"read of a counter programmed with unsupported event");
 }
 
-static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
+static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events,
+				  bool overflow_at_64bits)
 {
 	int i;
 
@@ -416,16 +417,23 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
 			return false;
 		}
 	}
+
+	if (overflow_at_64bits && pmu.version < ID_DFR0_PMU_V3_8_5) {
+		report_skip("Skip test as 64 overflows need FEAT_PMUv3p5");
+		return false;
+	}
+
 	return true;
 }
 
-static void test_basic_event_count(void)
+static void test_basic_event_count(bool overflow_at_64bits)
 {
 	uint32_t implemented_counter_mask, non_implemented_counter_mask;
 	uint32_t counter_mask;
 	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	implemented_counter_mask = BIT(pmu.nb_implemented_counters) - 1;
@@ -499,12 +507,13 @@ static void test_basic_event_count(void)
 		"check overflow happened on #0 only");
 }
 
-static void test_mem_access(void)
+static void test_mem_access(bool overflow_at_64bits)
 {
 	void *addr = malloc(PAGE_SIZE);
 	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -535,13 +544,14 @@ static void test_mem_access(void)
 			read_sysreg(pmovsclr_el0));
 }
 
-static void test_sw_incr(void)
+static void test_sw_incr(bool overflow_at_64bits)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
 	uint64_t cntr0;
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -582,12 +592,13 @@ static void test_sw_incr(void)
 		"overflow on counter #0 after 100 SW_INCR");
 }
 
-static void test_chained_counters(void)
+static void test_chained_counters(bool overflow_at_64bits)
 {
 	uint32_t events[] = {CPU_CYCLES, CHAIN};
 	uint64_t cntr1;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -626,13 +637,14 @@ static void test_chained_counters(void)
 	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
-static void test_chained_sw_incr(void)
+static void test_chained_sw_incr(bool overflow_at_64bits)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
 	uint64_t cntr0, cntr1;
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -680,12 +692,13 @@ static void test_chained_sw_incr(void)
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
-static void test_chain_promotion(void)
+static void test_chain_promotion(bool overflow_at_64bits)
 {
 	uint32_t events[] = {MEM_ACCESS, CHAIN};
 	void *addr = malloc(PAGE_SIZE);
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	/* Only enable CHAIN counter */
@@ -829,13 +842,14 @@ static bool expect_interrupts(uint32_t bitmap)
 	return true;
 }
 
-static void test_overflow_interrupt(void)
+static void test_overflow_interrupt(bool overflow_at_64bits)
 {
 	uint32_t events[] = {MEM_ACCESS, SW_INCR};
 	void *addr = malloc(PAGE_SIZE);
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	gic_enable_defaults();
@@ -1059,6 +1073,19 @@ static bool pmu_probe(void)
 	return true;
 }
 
+static void run_test(char *name, void (*test)(bool), bool overflow_at_64bits)
+{
+	const char *prefix = overflow_at_64bits ? "64-bit" : "32-bit";
+
+	report_prefix_push(name);
+	report_prefix_push(prefix);
+
+	test(overflow_at_64bits);
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
 int main(int argc, char *argv[])
 {
 	int cpi = 0;
@@ -1091,33 +1118,19 @@ int main(int argc, char *argv[])
 		test_event_counter_config();
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
-		report_prefix_push(argv[1]);
-		test_basic_event_count();
-		report_prefix_pop();
+		run_test(argv[1], test_basic_event_count, false);
 	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
-		report_prefix_push(argv[1]);
-		test_mem_access();
-		report_prefix_pop();
+		run_test(argv[1], test_mem_access, false);
 	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
-		report_prefix_push(argv[1]);
-		test_sw_incr();
-		report_prefix_pop();
+		run_test(argv[1], test_sw_incr, false);
 	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
-		report_prefix_push(argv[1]);
-		test_chained_counters();
-		report_prefix_pop();
+		run_test(argv[1], test_chained_counters, false);
 	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
-		report_prefix_push(argv[1]);
-		test_chained_sw_incr();
-		report_prefix_pop();
+		run_test(argv[1], test_chained_sw_incr, false);
 	} else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
-		report_prefix_push(argv[1]);
-		test_chain_promotion();
-		report_prefix_pop();
+		run_test(argv[1], test_chain_promotion, false);
 	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
-		report_prefix_push(argv[1]);
-		test_overflow_interrupt();
-		report_prefix_pop();
+		run_test(argv[1], test_overflow_interrupt, false);
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

