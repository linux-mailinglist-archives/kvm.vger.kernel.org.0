Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B060C6632A3
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbjAIVTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238202AbjAIVSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:18:03 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A37C33
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:17:59 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z17-20020a25e311000000b00719e04e59e1so10404640ybd.10
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8vYRLwUIk98bjKuNyIlvlUFommPfoiF0oXe1gHbwjak=;
        b=VvomFRCWxi3Cf9audhc8IhllDwknftt5v1xuSBd+oY9d3AEEOifMGXkAtQ1y+FuIWb
         u4XdeSZza8zSXC5W+g5s1/ZJfNX2sHykubx/mkrqg/oeakTwtE2nb9DOpAmXMFvLMLU1
         keLlnyqIXs/che9x+5WVb4heav9HjlZ+W7tly48xIaqrlC5yRwha947w1eUmBJL3lmhM
         7qYw1hlJD+RWGnmoQJLChDzs4MZjLDF0aiQYZrXq9g577VzsaC8KpcMYgsOuZHVagPXF
         QmL6WFGiMstE0vlkkCQyOHy17XYWZcxMOmykD7QP/fLW7A9wIRrtSjKWVfVZV5JxPZf6
         EF9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8vYRLwUIk98bjKuNyIlvlUFommPfoiF0oXe1gHbwjak=;
        b=o1R6M4RhNogOpvsdSjE54BSMoja8s4NYYMiGZ1snVazPAhmnth2w628+nk6iZUFMtY
         piQ/OgWsOOpq8hjsEddl4LQMBDPz0A4ogOhbtMgPUQDIns7mvHwdSAcNSr+r15amKsTS
         +9b3MlnHOLGrkH5dnvS99Zh3F/O5ptuFKNV02/cuo6bY9JPnbxRX5XgG/b6gZmgztHxH
         ug7RDUz+g8tcR0EIEeN/x3+XWvQKwRFttSvUj1gsSvjsQtaO1BPkK8nxf8YpwHmZKhgR
         q2d29fHKxscSEzBOl7CWJJyXkr8h+SXGMhe9h4nqP/WeIZ9BGNpEpr7g4E6ruOt20Y7o
         1E8w==
X-Gm-Message-State: AFqh2krOnIJcxILJ0Z56hZzXjOPfukDKFQFHBOEOA5ieC/MpiCLC+BdY
        SNf+eyX7dY2qPpumbh+737+J4Yp8aa6ADmjcRnDGR9tifs1qG2EypaA3jjZJcPIZGDXWbJmbwnH
        GvoJpyF74XygO1oJI6KOKwpcVaCz7wHSiYlgS2lkX6mtJeLz0un+YF+g0RggGc0c=
X-Google-Smtp-Source: AMrXdXv6G8Fd/Iz5y6AF6zj+XDreYn28g1+TON+MSNkB+1uemEgtB8oJGGT41EqFVyH6vt6dFGBz92mmUdxaMg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:ae06:0:b0:7bf:162d:a1b7 with SMTP id
 a6-20020a25ae06000000b007bf162da1b7mr415585ybj.410.1673299079087; Mon, 09 Jan
 2023 13:17:59 -0800 (PST)
Date:   Mon,  9 Jan 2023 21:17:51 +0000
In-Reply-To: <20230109211754.67144-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230109211754.67144-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109211754.67144-2-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v3 1/4] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
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

PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
for overflowing at 32 or 64-bits. The consequence is that tests that check
the counter values after overflowing should not assume that values will be
wrapped around 32-bits: they overflow into the other half of the 64-bit
counters on PMUv3p5.

Fix tests by correctly checking overflowing-counters against the expected
64-bit value.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cd47b14..7f0794d 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -54,10 +54,10 @@
 #define EXT_COMMON_EVENTS_LOW	0x4000
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
-#define ALL_SET			0xFFFFFFFF
-#define ALL_CLEAR		0x0
-#define PRE_OVERFLOW		0xFFFFFFF0
-#define PRE_OVERFLOW2		0xFFFFFFDC
+#define ALL_SET			0x00000000FFFFFFFFULL
+#define ALL_CLEAR		0x0000000000000000ULL
+#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
+#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
 
 #define PMU_PPI			23
 
@@ -419,6 +419,22 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
 	return true;
 }
 
+static uint64_t pmevcntr_mask(void)
+{
+	/*
+	 * Bits [63:0] are always incremented for 64-bit counters,
+	 * even if the PMU is configured to generate an overflow at
+	 * bits [31:0]
+	 *
+	 * For more details see the AArch64.IncrementEventCounter()
+	 * pseudo-code in the ARM ARM DDI 0487I.a, section J1.1.1.
+	 */
+	if (pmu.version >= ID_DFR0_PMU_V3_8_5)
+		return ~0;
+
+	return (uint32_t)~0;
+}
+
 static void test_basic_event_count(void)
 {
 	uint32_t implemented_counter_mask, non_implemented_counter_mask;
@@ -538,6 +554,7 @@ static void test_mem_access(void)
 static void test_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
+	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -572,9 +589,8 @@ static void test_sw_incr(void)
 		write_sysreg(0x3, pmswinc_el0);
 
 	isb();
-	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
-	report(read_regn_el0(pmevcntr, 1)  == 100,
-		"counter #0 after + 100 SW_INCR");
+	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
+	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
 	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
@@ -625,6 +641,8 @@ static void test_chained_counters(void)
 static void test_chained_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
+	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
+	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -666,9 +684,9 @@ static void test_chained_sw_incr(void)
 
 	isb();
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

