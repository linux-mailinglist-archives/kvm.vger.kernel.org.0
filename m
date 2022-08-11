Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F9B5906C8
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 21:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbiHKSw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235971AbiHKSwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 14:52:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD699DF8A
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:21 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d3-20020a170902cec300b0016f04e2e730so11709698plg.1
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=p/ppzg47C+97FQWYd9dFXNdGPOMPqma4qKXwXuPgUEk=;
        b=RJJ9hUqaDoF3x4wOjJ6z7ndtxl2qLnCUzPGlaHF/3CmeduXZqBg0iE3BFQ6Qv6dMO/
         VRfyehBYbA3v6+h71gG32HcjhWcsm902d74UQtzlSDwyV9IBMwVFGwHUtIJPehvPvktb
         f7Aj88/tOSjsxK1DZTWoSTRMbh/yOQQeQrAR8XXj26NlYY1PHDq+ziqMlCfexDtvebn4
         lR5i0DH5dYvNjcKsS1oJaqaeOOyqTuMJ4Sn5ZhWbm/JU5T9/Iq50GoIdz4dL/kyo09zt
         n6/hVmqQOZV4QwxtUD5K13b3bzgAatKkOa3BjhYIMi1+VCDar6qi9bsS46jhc9MbNqv/
         pmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=p/ppzg47C+97FQWYd9dFXNdGPOMPqma4qKXwXuPgUEk=;
        b=vO5A4473QIxEUIQ8B3wQIE+G1vVOHDBsjaefpOCKjE9tNWIeip1aTADRybtkMaw5OE
         GQNGndUqH2nIQ2km1/utmVhv9zYXVmBU+A3eGcwcrdf/U/f2xjPUXfBIOe8RdCQPXpI4
         t5GlvT1VBGgVmG+4ZBYPxe/XYgDs7Uc2ctN0Mjj3SMpRm+eMsTYbgIUaBQ4NaOyASqnv
         kjmUxAhgRp/8ykNehuDALIvPJkkMI3TEyWEiE0NOuanYHv23bU/No9cYfIgqOa+LovGa
         s29OfnIGEB5v5+nM4JurxX6tvagqY8H8NyiBrXBMM6yA0i0ASluFEYT0S6Ql4JX4f1qa
         I6pw==
X-Gm-Message-State: ACgBeo0K9sug/nIGFgAN/yp3pJPpU0NERcsVkT9PwUHmI7W4Uqg9nXU8
        0n32zWQhafjyN0KiC1IdRACR5dWAiuFayLGDMYsvkEJd/odX1aUYOFU4Xb2URcP9bIeHgsVTC/I
        LZrb0Y3Nj8/+LvxDyz36sbw3GwJow2Ly/9P9nxSonjpRUP/SMaY8PT7bErHCxFlg=
X-Google-Smtp-Source: AA6agR6YJTzzjFaC/q8A+drTaKkj/pLNeMM2KQKA4NMyV74jrlBe6FcpX+iBRMu2+bl5ZMHk/CQLEBN52PR/rg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:174e:b0:52b:c705:a42c with SMTP
 id j14-20020a056a00174e00b0052bc705a42cmr554586pfc.68.1660243940729; Thu, 11
 Aug 2022 11:52:20 -0700 (PDT)
Date:   Thu, 11 Aug 2022 11:52:10 -0700
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
Message-Id: <20220811185210.234711-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220811185210.234711-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v4 4/4] arm: pmu: Check for overflow in the low
 counter in chained counters tests
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A chained event overflowing on the low counter can set the overflow flag
in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
(DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
overflow.

The pmu chain tests fail on bare metal when checking the overflow flag
of the low counter _not_ being set on overflow.  Fix by checking for
overflow. Note that this test fails in KVM without the respective fix.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 756e0d26..cd47b14b 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -599,7 +599,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 
 	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
+	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #1");
 
 	/* test 64b overflow */
 
@@ -611,7 +611,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
+	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	write_regn_el0(pmevcntr, 1, ALL_SET);
@@ -619,7 +619,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
-	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
+	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
 static void test_chained_sw_incr(void)
@@ -645,8 +645,9 @@ static void test_chained_sw_incr(void)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
-		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
+	report((read_sysreg(pmovsclr_el0) == 0x1) &&
+		(read_regn_el0(pmevcntr, 1) == 1),
+		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
@@ -664,10 +665,10 @@ static void test_chained_sw_incr(void)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report((read_sysreg(pmovsclr_el0) == 0x2) &&
+	report((read_sysreg(pmovsclr_el0) == 0x3) &&
 		(read_regn_el0(pmevcntr, 1) == 0) &&
 		(read_regn_el0(pmevcntr, 0) == 84),
-		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
+		"expected overflows and values after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
@@ -747,8 +748,9 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"CHAIN counter enabled: CHAIN counter was incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1) &&
+		(read_sysreg(pmovsclr_el0) == 0x1),
+		"CHAIN counter enabled: CHAIN counter was incremented and overflow");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
@@ -775,8 +777,9 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"32b->64b: CHAIN counter incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1) &&
+		(read_sysreg(pmovsclr_el0) == 0x1),
+		"32b->64b: CHAIN counter incremented and overflow");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
@@ -884,8 +887,8 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	isb();
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0),
-		"no overflow interrupt expected on 32b boundary");
+	report(expect_interrupts(0x1),
+		"expect overflow interrupt on 32b boundary");
 
 	/* overflow on odd counter */
 	pmu_reset_stats();
@@ -893,8 +896,8 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 1, ALL_SET);
 	isb();
 	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0x2),
-		"expect overflow interrupt on odd counter");
+	report(expect_interrupts(0x3),
+		"expect overflow interrupt on even and odd counter");
 }
 #endif
 
-- 
2.37.1.559.g78731f0fdb-goog

