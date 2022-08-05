Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B142158A43E
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 02:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbiHEAlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 20:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiHEAlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 20:41:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331B56FA02
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 17:41:44 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o4-20020a17090ac08400b001f560755c39so384877pjs.2
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 17:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=02kVlxhYR2wVflGJuMXecQx6sdKKlCZWwBiydCGT0N0=;
        b=mNlSYnq6hfwiRO2PfUx1N9QufaqsC8RVb0nXYm9bGrV/jU1Gv68Qq3dcN7TiNykXwS
         P1RS/Kd0KNN2cL4R+wWsBAgh2ksiWg5u5UsDvA6S9F6ygt0n+uN8E1nGedmNYOiuzSSd
         CuatSUd7aFmeKIcwxfEOnCcJiXUIpfDyAs9yJyb8QCcoHXhNVDrfOZLEjo0PuQcJTuKj
         TE1COhE/xMo3599H6//88h6zTtgKMZ+TNO3LAsSv6AMxH7hxWpGmZ7VqTKrZryjAmrod
         i+MuPgkDwhXNCF+rlUoJQJsWGJnE2LI3ihv5oFAkh4sOyWVPGB9R8+t0WUcRF69wvLqR
         dB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=02kVlxhYR2wVflGJuMXecQx6sdKKlCZWwBiydCGT0N0=;
        b=JwIBcJX53zPkpBlJUeY4Rm5uKeGccCi4zmZ5/FdY7b3MAwKkjs3g9LHdFWeLaB4VI0
         RA95D1tYEpZyNCn+pzicnoDqMFGaUIBzPogG6l/rsGxEiKEI0kugU/pCdRdAZYS7vHQt
         NpB8NSmOB7Osz1xBtFcFF2A3bedeSopgg2fW4B9TO7eP3n/q4oZdIe8FRk7avFF7U1cM
         zrW/0/MeNIVDzmh2Dw36AM0tOl3zExdVKq3XqB1f3a+Jgp125sLRahAMR+jot9dsbCb3
         0cOOAr2O/U5QpPQuOEQLbflrLiYXMGK+iIN+lf4042jQ/vzAeY0CgIslWvIjbGEB5Wfj
         /4gg==
X-Gm-Message-State: ACgBeo02bSMyqir/YgeDGyO3oLZB84z7sTi53XLUyZoE5yMfyRSMeMMQ
        lARnoxq84akzf9y2xz0yQ+panXSnRPiB+uk8ceInrIcsbp13NFBfFSuBRufz8pLaH+itqP0h3Qv
        bIJPWrY0Orj4aEvGyP/SCeSa6OT9/sjj7yTQMohDYCh+8xpK1A5xIbG+dASp41Uo=
X-Google-Smtp-Source: AA6agR5i3eO0h3ui+dDSWAFqYIZiKGGMjyuqnTDX2nt72TATzBHKJ0uEQLFGv6WNY0C+7E/6UPHqCb/NsdA7eA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1996:b0:52e:b0f7:8c83 with SMTP
 id d22-20020a056a00199600b0052eb0f78c83mr1489248pfl.59.1659660103577; Thu, 04
 Aug 2022 17:41:43 -0700 (PDT)
Date:   Thu,  4 Aug 2022 17:41:37 -0700
In-Reply-To: <20220805004139.990531-1-ricarkol@google.com>
Message-Id: <20220805004139.990531-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220805004139.990531-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 1/3] arm: pmu: Add missing isb()'s after sys
 register writing
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

There are various pmu tests that require an isb() between enabling
counting and the actual counting. This can lead to count registers
reporting less events than expected; the actual enabling happens after
some events have happened.  For example, some missing isb()'s in the
pmu-sw-incr test lead to the following errors on bare-metal:

	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
	PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
	FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
	FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
	INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
	PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
	SUMMARY: 4 tests, 2 unexpected failures

Add the missing isb()'s on all failing tests, plus some others that seem
required:
- after clearing the overflow signal in the IRQ handler to make spurious
  interrupts less likely.
- after direct writes to PMSWINC_EL0 for software to read the correct
  value for PMEVNCTR0_EL0 (from ARM DDI 0487H.a, page D13-5237).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 15c542a2..4c601b05 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -307,6 +307,7 @@ static void irq_handler(struct pt_regs *regs)
 			}
 		}
 		write_sysreg(ALL_SET, pmovsclr_el0);
+		isb();
 	} else {
 		pmu_stats.unexpected = true;
 	}
@@ -534,10 +535,12 @@ static void test_sw_incr(void)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	isb();
 
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
+	isb();
 	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
 	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
 		"PWSYNC does not increment if PMCR.E is unset");
@@ -547,10 +550,12 @@ static void test_sw_incr(void)
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
 
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
 
+	isb();
 	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
 	report(read_regn_el0(pmevcntr, 1)  == 100,
 		"counter #0 after + 100 SW_INCR");
@@ -618,9 +623,12 @@ static void test_chained_sw_incr(void)
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
+	isb();
 	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
 		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
@@ -634,9 +642,12 @@ static void test_chained_sw_incr(void)
 	write_regn_el0(pmevcntr, 1, ALL_SET);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
+	isb();
 	report((read_sysreg(pmovsclr_el0) == 0x2) &&
 		(read_regn_el0(pmevcntr, 1) == 0) &&
 		(read_regn_el0(pmevcntr, 0) == 84),
@@ -821,10 +832,14 @@ static void test_overflow_interrupt(void)
 	report(expect_interrupts(0), "no overflow interrupt after preset");
 
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x2, pmswinc_el0);
 
+	isb();
 	set_pmcr(pmu.pmcr_ro);
+	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
 	/* enable interrupts */
@@ -879,6 +894,7 @@ static bool check_cycles_increase(void)
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
 	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
+	isb();
 
 	for (int i = 0; i < NR_SAMPLES; i++) {
 		uint64_t a, b;
@@ -894,6 +910,7 @@ static bool check_cycles_increase(void)
 	}
 
 	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
+	isb();
 
 	return success;
 }
-- 
2.37.1.559.g78731f0fdb-goog

