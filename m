Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116E1651953
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 04:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiLTDKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 22:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiLTDKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 22:10:43 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1658C10
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 19:10:42 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b16-20020a17090a10d000b00221653b4526so4426884pje.2
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 19:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q10rUBAMPp02OLhY9eCZCmG3XUyvR5sIHjaDQiVf8kk=;
        b=Tvafgg6lFog2gJPmCOGhUj8Gk0WzLIFS7rEmTaCtNS+wVfoRMaNckCyqEeYcfCMi44
         r3+3Q+WD5gPtX8afrAtXbryso5Gf+Hr3Pb/yeZHfRoUK1MDHquixZ8yqSiFDmHL515iL
         uZJbQUo27JjPfEFhq9NQkIV1yO1R1CQDLKq8x17erkYpAFFmET4hq85pFlO8F6MELIH9
         USR50ALgV96KN3DSQgvUVOn9BQ3Kl0lTe/BYaGi/DUCL+AuAjQFT/hKCdbRph76n5mcb
         6mN0BbPpaSHn8frr6wxGnG0HIoorI9/Glt/Afy8Fz7JeBZlfv+JT5EhzStQVnyI9fyC3
         C/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q10rUBAMPp02OLhY9eCZCmG3XUyvR5sIHjaDQiVf8kk=;
        b=L18OBMTlfAgiJyZV9SlcDba3FrlXDAmJlhvrmj4eLS77utbWkr3ZoXuIeQMS2sR6YH
         0DJcR88yWf6yauy505QvAs7O/ueWmTOTCHjXOFnIEiliIdjIvZVG+uRUSCVnbocG6rJG
         cE8Eouyta3y8eJ67Z2shTyH3bXcSIIKwKDQk0lpnKsJkobb5VFSTmmwGLoX5+0Nq/nwd
         BckBv5Ojgcxl2Cl6df5itKDsMaNU+VnFlf7/qnPXqN8wCV31yTCjuCMMYsV9o1GxR1U0
         Mvlts5pdFzpjYjUokJl2Hy77KwGt6rbV+3BJsDM+H7jaV+YfnDRsTuC+JRU3M0Qegznk
         In8Q==
X-Gm-Message-State: ANoB5pkeJSWlf72XFHgG9zMUJdH6ai2gVbEMw7p/y7kDSNY6j24RJt0C
        rklYViC9JblwDpuF6eZX6PqmY/e4H4uEBXiG4ggO0LO6TRiuadxUgzWlrzSmJOil+F1ZjSRzkwX
        8FozSmZAR4+k9Cqn6di8+FUbMIK1KQeGwsChFE7tPXweXN5V3PeQeJng5865Sm5Y=
X-Google-Smtp-Source: AA0mqf61vT9Jbaw7sgIBUPagUbDMGnQGx8IGqPTGr0B37Fpqbf+yIDfkZdKydSege8UhWLjgoKJXsr6BdGr+jg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:84c7:0:b0:574:9b8d:1873 with SMTP id
 x7-20020aa784c7000000b005749b8d1873mr68849788pfn.75.1671505842066; Mon, 19
 Dec 2022 19:10:42 -0800 (PST)
Date:   Tue, 20 Dec 2022 03:10:32 +0000
In-Reply-To: <20221220031032.2648701-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221220031032.2648701-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220031032.2648701-5-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v2 4/4] arm: pmu: Print counter values as hexadecimals
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

The arm/pmu test prints the value of counters as %ld.  Most tests start
with counters around 0 or UINT_MAX, so having something like -16 instead of
0xffff_fff0 is not very useful.

Report counter values as hexadecimals.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 680623d..b6b2871 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -537,8 +537,8 @@ static void test_mem_access(bool overflow_at_64bits)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
-	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
-	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
+	report_info("counter #0 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
+	report_info("counter #1 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
 	/* We may measure more than 20 mem access depending on the core */
 	report((read_regn_el0(pmevcntr, 0) == read_regn_el0(pmevcntr, 1)) &&
 	       (read_regn_el0(pmevcntr, 0) >= 20) && !read_sysreg(pmovsclr_el0),
@@ -553,7 +553,7 @@ static void test_mem_access(bool overflow_at_64bits)
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(read_sysreg(pmovsclr_el0) == 0x3,
 	       "Ran 20 mem accesses with expected overflows on both counters");
-	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
+	report_info("cnt#0=0x%lx cnt#1=0x%lx overflow=0x%lx",
 			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
 			read_sysreg(pmovsclr_el0));
 }
@@ -584,7 +584,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
+	report_info("SW_INCR counter #0 has value 0x%lx", read_regn_el0(pmevcntr, 0));
 	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
 		"PWSYNC does not increment if PMCR.E is unset");
 
@@ -604,7 +604,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 		(uint64_t)pre_overflow + 100;
 	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
 	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
-	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
+	report_info("counter values after 100 SW_INCR #0=0x%lx #1=0x%lx",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
 		"overflow on counter #0 after 100 SW_INCR");
@@ -680,7 +680,7 @@ static void test_chained_sw_incr(bool unused)
 	report((read_sysreg(pmovsclr_el0) == 0x1) &&
 		(read_regn_el0(pmevcntr, 1) == 1),
 		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
 	/* 64b SW_INCR and overflow on CHAIN counter*/
@@ -705,7 +705,7 @@ static void test_chained_sw_incr(bool unused)
 	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
 	       (read_regn_el0(pmevcntr, 1) == cntr1),
 	       "expected overflows and values after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
@@ -737,11 +737,11 @@ static void test_chain_promotion(bool unused)
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
 	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
 		"odd counter did not increment on overflow if disabled");
-	report_info("MEM_ACCESS counter #0 has value %ld",
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
-	report_info("CHAIN counter #1 has value %ld",
+	report_info("CHAIN counter #1 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 1));
-	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
+	report_info("overflow counter 0x%lx", read_sysreg(pmovsclr_el0));
 
 	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
 	pmu_reset();
-- 
2.39.0.314.g84b9a713c41-goog

