Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634B165194C
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 04:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiLTDKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 22:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbiLTDKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 22:10:38 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694351018
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 19:10:37 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4528903f275so24611557b3.8
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 19:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xnm0j9raQy1Oj01SJW34nfgs6KGA8/nvtuOTe2h8nwo=;
        b=hrRIewrniOFjcx89HXBcytfmHUrxu2ThlfaUgGK1xUxWtRSBTV4k3zH6dE9vlZVRCJ
         kfwG2dhZU0VMBD8ZM4V+wpU2dQZnfTRtr/OlWb0JApBmtQTmYEWlj/TwhKB735dnu8La
         q26+H7/iqrup4bDTeEk8Rsl+cXyP5MKY/tAbwy+ju9rr2NNmqiuZmD6OgL2rHRIfBed7
         qth6yDtoXw4lSnz6oRcgfc+s0ky8xovTFuIZhDLLftg0yRS+M7C4aOabIx9gNe1j6wXq
         K7qT8EIOl3m1DFtxviz9s/gLLkkioHpuFvg1VHN7SK0wCnnkMp0/wOkc8sRIhfHMrCmN
         b1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xnm0j9raQy1Oj01SJW34nfgs6KGA8/nvtuOTe2h8nwo=;
        b=Fo0EBBte07SUxSK3C2N0g24liWnctSxzDJWsRL/yG1mgyKarxiFvGkNHjsGWvvS3AI
         SzcxI+4kJu1HlMc3wpXakNplRn0NLqfM45gSDXaRes5vzp621tPEYyCVGnIothIInFOE
         oXPkPckSw3tVWiCxRT/tQk24Y5i4ctObQ94gt/mWvZ4+cyNBPOkJ3api4qG5ku6rUAP7
         wOwRhTun0/ntGDXCiu9zdHG28Ivh/pNRfT1WMHTsIDf7ih92gl1lVQBc7eE10tcfQTuh
         ml0UiABBIZG/mvleSCaZpnHM3em+f0kyjNpOuUMUl5n9eyEHfYNwsoitHy3uIb5fMCV5
         iXCQ==
X-Gm-Message-State: AFqh2krYZmMiNHntt8BJaXyeJ39RugqPOhlZnfVVKojHgH1GeAoYPdTl
        tjWcYSTd2TCxKqKBDC7oLB+pipQ3GYWyj3RFtmor9bYuW+rHs7ymCjTwiyM9EWPZemTmZk4oO3N
        2yJNdOYz3GXymWQ4His2IwhBVk1slLjrGBjtheVS7kNJdveamdxJU9jcPMUQaBGc=
X-Google-Smtp-Source: AMrXdXuRbbc+T4ZX0QDLQDgzFQz9i28hQuZPYyJmzA0LAiRQAX+qKPltO6C140SftXppeKYoNEvuEaFYgbxMFQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:fe07:0:b0:3d7:b4:9879 with SMTP id
 j7-20020a81fe07000000b003d700b49879mr2877714ywn.370.1671505836639; Mon, 19
 Dec 2022 19:10:36 -0800 (PST)
Date:   Tue, 20 Dec 2022 03:10:29 +0000
In-Reply-To: <20221220031032.2648701-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221220031032.2648701-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220031032.2648701-2-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v2 1/4] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
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

PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
for overflowing at 32 or 64-bits. The consequence is that tests that check
the counter values after overflowing should not assume that values will be
wrapped around 32-bits: they overflow into the other half of the 64-bit
counters on PMUv3p5.

Fix tests by correctly checking overflowing-counters against the expected
64-bit value.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cd47b14..1b55e20 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -54,10 +54,13 @@
 #define EXT_COMMON_EVENTS_LOW	0x4000
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
-#define ALL_SET			0xFFFFFFFF
-#define ALL_CLEAR		0x0
-#define PRE_OVERFLOW		0xFFFFFFF0
-#define PRE_OVERFLOW2		0xFFFFFFDC
+#define ALL_SET			0x00000000FFFFFFFFULL
+#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
+#define ALL_CLEAR		0x0000000000000000ULL
+#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
+#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
+
+#define ALL_SET_AT(_64b)       (_64b ? ALL_SET_64 : ALL_SET)
 
 #define PMU_PPI			23
 
@@ -538,6 +541,7 @@ static void test_mem_access(void)
 static void test_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
+	uint64_t cntr0;
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -572,9 +576,11 @@ static void test_sw_incr(void)
 		write_sysreg(0x3, pmswinc_el0);
 
 	isb();
-	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
-	report(read_regn_el0(pmevcntr, 1)  == 100,
-		"counter #0 after + 100 SW_INCR");
+	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
+		(uint32_t)PRE_OVERFLOW + 100 :
+		(uint64_t)PRE_OVERFLOW + 100;
+	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
+	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
 	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
@@ -584,6 +590,7 @@ static void test_sw_incr(void)
 static void test_chained_counters(void)
 {
 	uint32_t events[] = {CPU_CYCLES, CHAIN};
+	uint64_t all_set = ALL_SET_AT(pmu.version >= ID_DFR0_PMU_V3_8_5);
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
 		return;
@@ -614,17 +621,19 @@ static void test_chained_counters(void)
 	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, ALL_SET);
+	write_regn_el0(pmevcntr, 1, all_set);
 
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
-	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
+	report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
+
 	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
 static void test_chained_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
+	uint64_t cntr0, cntr1;
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -665,10 +674,14 @@ static void test_chained_sw_incr(void)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
+	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
+		(uint32_t)PRE_OVERFLOW + 100 :
+		(uint64_t)PRE_OVERFLOW + 100;
+	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
 	report((read_sysreg(pmovsclr_el0) == 0x3) &&
-		(read_regn_el0(pmevcntr, 1) == 0) &&
-		(read_regn_el0(pmevcntr, 0) == 84),
-		"expected overflows and values after 100 SW_INCR/CHAIN");
+	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
+	       (read_regn_el0(pmevcntr, 1) == cntr1),
+	       "expected overflows and values after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
-- 
2.39.0.314.g84b9a713c41-goog

