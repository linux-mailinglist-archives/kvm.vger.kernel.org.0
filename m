Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26114CAB72
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243762AbiCBRWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243719AbiCBRWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:22:38 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD63C9928
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:21:53 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id s12-20020a17090a13cc00b001bee1e1677fso1286481pjf.0
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fgft+MtU6LGmqLMLdpX3BuX8zBdP/T6GMDeFFjL6SJk=;
        b=cvXDLK8T1Fis0LVsaenDWlU0PrJPTjzXmpT0pouf2vYZeBGfaL0ZMxmCFosKwcDKoz
         40o0PR7KlIdqq5lXMJQEM2dFJBlol94UwrGLt7gZXbWmfCcCTS1edXQuy+LnCgMVf3Pk
         qaixYp0DtWtSzqymPCk5yxGeiQAuaNDzaTirq6cKef9oDWJLMHQhwh5LiyyfCrsPJhOp
         S9y+av5JFQhexngV1TTKtQHUIgs90zBaNdwMPip4WKNyqu9c1zBxSK0GmGbDuIaBY28q
         OIbffJIp+GWv0PGiZHeSBnyZGaTag6RpG/hTT2Gmo4hlUNguGaR94/6l2iF/gXYBUjGn
         BKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fgft+MtU6LGmqLMLdpX3BuX8zBdP/T6GMDeFFjL6SJk=;
        b=6FwobVLQg6gNyfhWG5eUPbEvNsfZofAhaDr48I+I3oeaXQnyR4vNq35hNkrB3PfHXv
         6DrDZjyuMKcmwL55y9zOW34tLuTZjnJXEoy2HybTkMP4TC/ZIOa3d45g8JRZ6jdAA2rC
         w23f5lmvENYn7aJCMTMwE4CLYj3mWen874NOsoNV2DRitNWEkas6R8yptLbrZhv67aTw
         J9l/aPir5yCCrM53RMqpe0a2taxRYHmvd0sLzoSORWWRyj3iwfI+QHvcmFdqleyesWOY
         YTBIu+gh0GwyMfCEP52QGHTn3OL/mdJAfmhVvZvoyslw7F6DPosgDqiXquH3AVQs5BpC
         qtlg==
X-Gm-Message-State: AOAM531nutB9dDKI2jpcBPWVuFMKn7NR3xdh08eOinLDnMXG+TZKXNNr
        sA/gcn7URL4H3sdeXxlEeILYTfy5ggxFQgGFU/drQOpaB/Morrwuic7rC5IWcCmsHGTe+++rees
        cDd4p6vXFXRwkYUutZpB9OS4hi1a8J8H/WmhgtBojokp3tnQroxIZm4YyBCrmeis=
X-Google-Smtp-Source: ABdhPJwNA6qjSSyLVC2SGIUsnJLV2+UOdlO3I9FWMM/GdAtFSWUeY+DxuBd2ZlEmvOdbhe0ryjvdCQ6x3CSIDg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:24c5:b0:4d1:65bf:1fe0 with SMTP
 id d5-20020a056a0024c500b004d165bf1fe0mr33860310pfv.0.1646241713099; Wed, 02
 Mar 2022 09:21:53 -0800 (PST)
Date:   Wed,  2 Mar 2022 09:21:44 -0800
In-Reply-To: <20220302172144.2734258-1-ricarkol@google.com>
Message-Id: <20220302172144.2734258-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220302172144.2734258-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 3/3] KVM: arm64: selftests: add edge cases tests into arch_timer_edge_cases
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests that validates some edge cases related to the virtual
arch-timer:
- timers above the max TVAL value.
- timers in the past, including TVALs that rollover from 0.
- timers across counter roll-overs.
- moving counters ahead and behind pending timers.
- reprograming timers.
- the same timer condition firing multiple times.
- masking/unmasking using the timer control mask.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../kvm/aarch64/arch_timer_edge_cases.c       | 555 +++++++++++++++++-
 1 file changed, 550 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
index 48c886bce849..ec791a7d2e8d 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
@@ -2,6 +2,16 @@
 /*
  * arch_timer_edge_cases.c - Tests the aarch64 timer IRQ functionality.
  *
+ * The test validates some edge cases related to the virtual arch-timer:
+ * - timers above the max TVAL value.
+ * - timers in the past, including TVALs that rollover from 0.
+ * - timers across counter roll-overs.
+ * - masking a pending timer across counter roll-overs.
+ * - moving counters ahead and behind pending timers.
+ * - reprograming timers.
+ * - the same timer condition firing multiple times.
+ * - masking/unmasking using the timer control mask.
+ *
  * Copyright (c) 2021, Google LLC.
  */
 
@@ -46,14 +56,20 @@
 /* Number of runs. */
 #define NR_TEST_ITERS_DEF		5
 
+/* Default "long" wait test time in ms. */
+#define LONG_WAIT_TEST_MS		100
+
 /* Shared with IRQ handler. */
 volatile struct test_vcpu_shared_data {
 	int handled;
+	int spurious;
 } shared_data;
 
 struct test_args {
 	/* Virtual or physical timer and counter tests. */
 	enum arch_timer timer;
+	/* Delay used in the test_long_timer_delays test. */
+	uint64_t long_wait_ms;
 	/* Number of iterations. */
 	int iterations;
 };
@@ -61,6 +77,7 @@ struct test_args {
 struct test_args test_args = {
 	/* Only testing VIRTUAL timers for now. */
 	.timer = VIRTUAL,
+	.long_wait_ms = LONG_WAIT_TEST_MS,
 	.iterations = NR_TEST_ITERS_DEF,
 };
 
@@ -68,10 +85,25 @@ static int vtimer_irq, ptimer_irq;
 
 typedef enum sync_cmd {
 	SET_REG_KVM_REG_ARM_TIMER_CNT = 100001,
+	USERSPACE_USLEEP,
 	USERSPACE_SCHED_YIELD,
 	USERSPACE_MIGRATE_SELF,
 } sync_cmd_t;
 
+typedef void (*sleep_method_t)(uint64_t usec);
+
+static void sleep_poll(uint64_t usec);
+static void sleep_sched_poll(uint64_t usec);
+static void sleep_in_userspace(uint64_t usec);
+static void sleep_migrate(uint64_t usec);
+
+sleep_method_t sleep_method[] = {
+	sleep_poll,
+	sleep_sched_poll,
+	sleep_migrate,
+	sleep_in_userspace,
+};
+
 typedef void (*wfi_method_t)(void);
 
 static void wait_for_non_spurious_irq(void);
@@ -89,6 +121,9 @@ wfi_method_t wfi_method[] = {
 #define for_each_wfi_method(i)							\
 	for ((i) = 0; (i) < ARRAY_SIZE(wfi_method); (i)++)
 
+#define for_each_sleep_method(i)						\
+	for ((i) = 0; (i) < ARRAY_SIZE(sleep_method); (i)++)
+
 typedef enum timer_view {
 	TIMER_CVAL = 1,
 	TIMER_TVAL,
@@ -136,6 +171,9 @@ static uint32_t next_pcpu(void)
 #define TIMER_GET_CNTCT()							\
 	timer_get_cntct(test_args.timer)
 
+#define GUEST_SYNC_CLOCK(__cmd, __val)						\
+	GUEST_SYNC_ARGS(__cmd, __val, 0, 0, 0)
+
 #define __SET_COUNTER(__ctr, __t)						\
 	GUEST_SYNC_ARGS(SET_REG_KVM_REG_ARM_TIMER_CNT, (__ctr), (__t), 0, 0)
 
@@ -151,6 +189,9 @@ static uint32_t next_pcpu(void)
 #define USERSPACE_MIGRATE_VCPU()						\
 	USERSPACE_CMD(USERSPACE_MIGRATE_SELF)
 
+#define SLEEP_IN_USERSPACE(__usecs)						\
+	GUEST_SYNC_ARGS(USERSPACE_USLEEP, (__usecs), 0, 0, 0)
+
 #define IAR_SPURIOUS		1023
 
 static void guest_irq_handler(struct ex_regs *regs)
@@ -161,8 +202,10 @@ static void guest_irq_handler(struct ex_regs *regs)
 
 	GUEST_ASSERT(gic_irq_get_pending(intid));
 
-	if (intid == IAR_SPURIOUS)
+	if (intid == IAR_SPURIOUS) {
+		shared_data.spurious++;
 		return;
+	}
 
 	ctl = TIMER_GET_CTL();
 	cnt = TIMER_GET_CNTCT();
@@ -184,6 +227,7 @@ static void guest_irq_handler(struct ex_regs *regs)
 static void set_cval_irq(uint64_t cval_cycles, uint32_t ctl)
 {
 	shared_data.handled = 0;
+	shared_data.spurious = 0;
 	TIMER_SET_CVAL(cval_cycles);
 	TIMER_SET_CTL(ctl);
 }
@@ -191,6 +235,7 @@ static void set_cval_irq(uint64_t cval_cycles, uint32_t ctl)
 static void set_tval_irq(uint64_t tval_cycles, uint32_t ctl)
 {
 	shared_data.handled = 0;
+	shared_data.spurious = 0;
 	TIMER_SET_TVAL(tval_cycles);
 	TIMER_SET_CTL(ctl);
 }
@@ -269,6 +314,60 @@ static void wait_migrate_poll_for_irq(void)
 	poll_for_non_spurious_irq(true, USERSPACE_MIGRATE_SELF);
 }
 
+/*
+ * Sleep for usec microseconds by polling in the guest (userspace=0) or in
+ * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHEDULE).
+ */
+static void guest_poll(enum arch_timer timer, uint64_t usec,
+		bool userspace, sync_cmd_t userspace_cmd)
+{
+	uint64_t cycles = usec_to_cycles(usec);
+	uint64_t start = timer_get_cntct(timer);
+
+	/*
+	 * TODO: Take care of roll-overs. Right now, we are fine as we use the
+	 * virtual timer/counter for all of our roll-over tests, and so we can use
+	 * the physical counter for this function. Assert this (temporarily):
+	 */
+	GUEST_ASSERT(test_args.timer == VIRTUAL && timer == PHYSICAL);
+
+	while ((timer_get_cntct(timer) - start) < cycles) {
+		if (userspace)
+			USERSPACE_CMD(userspace_cmd);
+		else
+			cpu_relax();
+	}
+}
+
+static void sleep_poll(uint64_t usec)
+{
+	if (test_args.timer == VIRTUAL)
+		guest_poll(PHYSICAL, usec, false, -1);
+	else
+		GUEST_ASSERT(0); /* Not implemented. */
+}
+
+static void sleep_sched_poll(uint64_t usec)
+{
+	if (test_args.timer == VIRTUAL)
+		guest_poll(PHYSICAL, usec, true, USERSPACE_SCHED_YIELD);
+	else
+		GUEST_ASSERT(0); /* Not implemented. */
+}
+
+static void sleep_migrate(uint64_t usec)
+{
+	if (test_args.timer == VIRTUAL)
+		guest_poll(PHYSICAL, usec, true, USERSPACE_MIGRATE_SELF);
+	else
+		GUEST_ASSERT(0); /* Not implemented. */
+}
+
+static void sleep_in_userspace(uint64_t usec)
+{
+	SLEEP_IN_USERSPACE(usec);
+}
+
 /*
  * Reset the timer state to some nice values like the counter not being close
  * to the edge, and the control register masked and disabled.
@@ -315,6 +414,221 @@ static void test_timer_tval(int32_t tval, wfi_method_t wm, bool reset_state,
 	test_timer_xval((uint64_t)tval, TIMER_TVAL, wm, reset_state, reset_cnt);
 }
 
+static void test_xval_check_no_irq(uint64_t xval, uint64_t usec,
+				timer_view_t timer_view,
+				sleep_method_t guest_sleep)
+{
+	local_irq_disable();
+
+	set_xval_irq(xval, CTL_ENABLE, timer_view);
+	guest_sleep(usec);
+
+	local_irq_enable();
+	isb();
+
+	/* Assume success (no IRQ) after waiting usec microseconds */
+	ASSERT_IRQS_HANDLED(0);
+	TIMER_SET_CTL(CTL_IMASK);
+}
+
+static void test_cval_no_irq(uint64_t cval, uint64_t usec, sleep_method_t wm)
+{
+	test_xval_check_no_irq(cval, usec, TIMER_CVAL, wm);
+}
+
+static void test_tval_no_irq(int32_t tval, uint64_t usec, sleep_method_t wm)
+{
+	/* tval will be cast to an int32_t in test_xval_check_no_irq */
+	test_xval_check_no_irq((uint64_t)tval, usec, TIMER_TVAL, wm);
+}
+
+/*
+ * Set the counter to just below the edge (CVAL_MAX) and set a timer that
+ * crosses it over.
+ */
+static void test_timers_across_rollovers(void)
+{
+	uint64_t edge_minus_5ms = CVAL_MAX - msec_to_cycles(5);
+	int i;
+
+	for_each_wfi_method(i) {
+		wfi_method_t wm = wfi_method[i];
+
+		reset_timer_state(edge_minus_5ms);
+		test_timer_tval(msec_to_cycles(10), wm, false, -1);
+
+		reset_timer_state(edge_minus_5ms);
+		test_timer_tval(TVAL_MAX, wm, false, -1);
+
+		reset_timer_state(edge_minus_5ms);
+		test_timer_tval(TVAL_MIN, wm, false, -1);
+	}
+}
+
+/* Test masking/unmasking a timer using the timer mask (not the IRQ mask). */
+static void test_timer_control_mask_then_unmask(void)
+{
+	reset_timer_state(DEF_CNT);
+	set_tval_irq(-1, CTL_ENABLE | CTL_IMASK);
+
+	/* No IRQs because the timer is still masked. */
+	ASSERT_IRQS_HANDLED(0);
+
+	/* Unmask the timer, and then get an IRQ. */
+	local_irq_disable();
+	TIMER_SET_CTL(CTL_ENABLE);
+	wait_for_non_spurious_irq();
+
+	ASSERT_IRQS_HANDLED(1);
+	local_irq_enable();
+}
+
+/* Check that timer control masks actually mask a timer being fired. */
+static void test_timer_control_masks(void)
+{
+	reset_timer_state(DEF_CNT);
+
+	/* Local IRQs are not masked at this point. */
+
+	set_tval_irq(-1, CTL_ENABLE | CTL_IMASK);
+
+	/* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
+	sleep_poll(TIMEOUT_NO_IRQ_US);
+
+	ASSERT_IRQS_HANDLED(0);
+	TIMER_SET_CTL(CTL_IMASK);
+}
+
+static void test_fire_a_timer_multiple_times(wfi_method_t wm, int num)
+{
+	int i;
+
+	local_irq_disable();
+	reset_timer_state(DEF_CNT);
+
+	set_tval_irq(0, CTL_ENABLE);
+
+	for (i = 1; i <= num; i++) {
+		wm();
+
+		/*
+		 * The IRQ handler masked and disabled the timer.
+		 * Enable and unmmask it again.
+		 */
+		TIMER_SET_CTL(CTL_ENABLE);
+
+		ASSERT_IRQS_HANDLED(i);
+	}
+
+	local_irq_enable();
+}
+
+static void test_timers_fired_multiple_times(void)
+{
+	int i;
+
+	for_each_wfi_method(i)
+		test_fire_a_timer_multiple_times(wfi_method[i], 10);
+}
+
+/*
+ * Set a timer for tval=d_1_ms then reprogram it to tval=d_2_ms. Check that we
+ * get the timer fired. There is no timeout for the wait: we use the wfi
+ * instruction.
+ */
+static void test_reprogramming_timer(wfi_method_t wm,
+		int32_t d_1_ms, int32_t d_2_ms)
+{
+	local_irq_disable();
+	reset_timer_state(DEF_CNT);
+
+	/* Program the timer to DEF_CNT + d_1_ms. */
+	set_tval_irq(msec_to_cycles(d_1_ms), CTL_ENABLE);
+
+	/* Reprogram the timer to DEF_CNT + d_2_ms. */
+	TIMER_SET_TVAL(msec_to_cycles(d_2_ms));
+
+	wm();
+
+	/* The IRQ should arrive at DEF_CNT + d_2_ms (or after). */
+	GUEST_ASSERT(TIMER_GET_CNTCT() >= DEF_CNT + msec_to_cycles(d_2_ms));
+
+	local_irq_enable();
+	ASSERT_IRQS_HANDLED_1(1, wm);
+};
+
+/*
+ * Set a timer for tval=d_1_ms then reprogram it to tval=d_2_ms. Check
+ * that we get the timer fired in d_2_ms.
+ */
+static void test_reprogramming_timer_with_timeout(sleep_method_t guest_sleep,
+		int32_t d_1_ms, int32_t d_2_ms)
+{
+	local_irq_disable();
+	reset_timer_state(DEF_CNT);
+
+	set_tval_irq(msec_to_cycles(d_1_ms), CTL_ENABLE);
+
+	/* Reprogram the timer. */
+	TIMER_SET_TVAL(msec_to_cycles(d_2_ms));
+
+	guest_sleep(msecs_to_usecs(d_2_ms) + TEST_MARGIN_US);
+
+	local_irq_enable();
+	isb();
+	ASSERT_IRQS_HANDLED(1);
+};
+
+static void test_reprogram_timers(void)
+{
+	int i;
+
+	for_each_wfi_method(i) {
+		test_reprogramming_timer(wfi_method[i], 20, 5);
+		test_reprogramming_timer(wfi_method[i], 5, 20);
+	}
+
+	for_each_sleep_method(i) {
+		test_reprogramming_timer_with_timeout(sleep_method[i], 20, 5);
+		test_reprogramming_timer_with_timeout(sleep_method[i], 5, 20);
+	}
+}
+
+/*
+ * Mask local IRQs, set the counter to MAX-5ms and a timer to fire
+ * immediately, wait for 10ms to roll-over, and then unmask. The timer should
+ * not fire as the timer condition is not valid anymore.
+ */
+static void test_irq_masked_timer_across_rollover(sleep_method_t guest_sleep)
+{
+	local_irq_disable();
+	reset_timer_state(CVAL_MAX - msec_to_cycles(5));
+
+	set_tval_irq(-1, CTL_ENABLE);
+
+	GUEST_ASSERT(TIMER_GET_CTL() & CTL_ISTATUS);
+	guest_sleep(msecs_to_usecs(10));
+	GUEST_ASSERT((TIMER_GET_CTL() & CTL_ISTATUS) == 0);
+
+	local_irq_enable();
+	isb();
+
+	ASSERT_IRQS_HANDLED(0);
+}
+
+/*
+ * Set a timer at the edge, and wait with irqs masked for so long that the
+ * counter rolls over and the "Timer Condition" doesn't apply anymore.
+ * We should still get an IRQ.
+ */
+static void test_irq_masked_timers_across_rollovers(void)
+{
+	int i;
+
+	for_each_sleep_method(i)
+		test_irq_masked_timer_across_rollover(sleep_method[i]);
+}
+
 static void test_basic_functionality(void)
 {
 	int32_t tval = (int32_t)msec_to_cycles(10);
@@ -377,8 +691,7 @@ static void timers_sanity_checks(bool use_sched)
 
 	/* tval should keep down-counting from 0 to -1. */
 	TIMER_SET_TVAL(0);
-	/* We just need 1 cycle to pass. */
-	isb();
+	sleep_poll(1);
 	GUEST_ASSERT(TIMER_GET_TVAL() < 0);
 
 	local_irq_enable();
@@ -394,10 +707,229 @@ static void test_timers_sanity_checks(void)
 	timers_sanity_checks(true);
 }
 
+static void test_set_cnt_after_tval_max(wfi_method_t wm)
+{
+	local_irq_disable();
+	reset_timer_state(DEF_CNT);
+
+	set_cval_irq((uint64_t)TVAL_MAX + msec_to_cycles(5), CTL_ENABLE);
+
+	SET_COUNTER(TVAL_MAX);
+	wm();
+
+	ASSERT_IRQS_HANDLED_1(1, wm);
+	local_irq_enable();
+}
+
+/* Test timers set for: cval = now + TVAL_MAX + 5ms */
+static void test_timers_above_tval_max(void)
+{
+	uint64_t cval;
+	int i;
+
+	/*
+	 * Test that the system is not implementing cval in terms of tval.  If
+	 * that was the case, setting a cval to "cval = now + TVAL_MAX + 5ms"
+	 * would wrap to "cval = now + 5ms", and the timer would fire
+	 * immediately. Test that it doesn't.
+	 */
+	for_each_sleep_method(i) {
+		reset_timer_state(DEF_CNT);
+		cval = TIMER_GET_CNTCT() + TVAL_MAX + msec_to_cycles(5);
+		test_cval_no_irq(cval, msecs_to_usecs(5) + TEST_MARGIN_US,
+				sleep_method[i]);
+	}
+
+	for_each_wfi_method(i) {
+		/* Get the IRQ by moving the counter forward. */
+		test_set_cnt_after_tval_max(wfi_method[i]);
+	}
+}
+
+/*
+ * Template function to be used by the test_move_counter_ahead_* tests.  It
+ * sets the counter to cnt_1, the [c|t]val, the counter to cnt_2, and
+ * then waits for an IRQ.
+ */
+static void test_set_cnt_after_xval(uint64_t cnt_1, uint64_t xval,
+		uint64_t cnt_2, wfi_method_t wm, timer_view_t tv)
+{
+	local_irq_disable();
+
+	SET_COUNTER(cnt_1);
+	TIMER_SET_CTL(CTL_IMASK);
+
+	set_xval_irq(xval, CTL_ENABLE, tv);
+	SET_COUNTER(cnt_2);
+	wm();
+
+	ASSERT_IRQS_HANDLED(1);
+	local_irq_enable();
+}
+
+/*
+ * Template function to be used by the test_move_counter_ahead_* tests.  It
+ * sets the counter to cnt_1, the [c|t]val, the counter to cnt_2, and
+ * then waits for an IRQ.
+ */
+static void test_set_cnt_after_xval_no_irq(uint64_t cnt_1, uint64_t xval,
+		uint64_t cnt_2, sleep_method_t guest_sleep, timer_view_t tv)
+{
+	local_irq_disable();
+
+	SET_COUNTER(cnt_1);
+	TIMER_SET_CTL(CTL_IMASK);
+
+	set_xval_irq(xval, CTL_ENABLE, tv);
+	SET_COUNTER(cnt_2);
+	guest_sleep(TIMEOUT_NO_IRQ_US);
+
+	local_irq_enable();
+	isb();
+
+	/* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
+	ASSERT_IRQS_HANDLED(0);
+	TIMER_SET_CTL(CTL_IMASK);
+}
+
+static void test_set_cnt_after_tval(uint64_t cnt_1, int32_t tval,
+		uint64_t cnt_2, wfi_method_t wm)
+{
+	test_set_cnt_after_xval(cnt_1, tval, cnt_2, wm, TIMER_TVAL);
+}
+
+static void test_set_cnt_after_cval(uint64_t cnt_1, uint64_t cval,
+		uint64_t cnt_2, wfi_method_t wm)
+{
+	test_set_cnt_after_xval(cnt_1, cval, cnt_2, wm, TIMER_CVAL);
+}
+
+static void test_set_cnt_after_tval_no_irq(uint64_t cnt_1, int32_t tval,
+		uint64_t cnt_2, sleep_method_t wm)
+{
+	test_set_cnt_after_xval_no_irq(cnt_1, tval, cnt_2, wm, TIMER_TVAL);
+}
+
+static void test_set_cnt_after_cval_no_irq(uint64_t cnt_1, uint64_t cval,
+		uint64_t cnt_2, sleep_method_t wm)
+{
+	test_set_cnt_after_xval_no_irq(cnt_1, cval, cnt_2, wm, TIMER_CVAL);
+}
+
+/* Set a timer and then move the counter ahead of it. */
+static void test_move_counters_ahead_of_timers(void)
+{
+	int i;
+	int32_t tval;
+
+	for_each_wfi_method(i) {
+		wfi_method_t wm = wfi_method[i];
+
+		test_set_cnt_after_cval(0, DEF_CNT, DEF_CNT + 1, wm);
+		test_set_cnt_after_cval(CVAL_MAX, 1, 2, wm);
+
+		/* Move counter ahead of negative tval. */
+		test_set_cnt_after_tval(0, -1, DEF_CNT + 1, wm);
+		test_set_cnt_after_tval(0, -1, TVAL_MAX, wm);
+		tval = TVAL_MAX;
+		test_set_cnt_after_tval(0, tval, (uint64_t)tval + 1, wm);
+	}
+
+	for_each_sleep_method(i) {
+		sleep_method_t sm = sleep_method[i];
+
+		test_set_cnt_after_cval_no_irq(0, DEF_CNT, CVAL_MAX, sm);
+		test_set_cnt_after_cval_no_irq(0, CVAL_MAX - 1, CVAL_MAX, sm);
+	}
+}
+
+/*
+ * Program a timer, mask it, and then change the tval or counter to cancel it.
+ * Unmask it and check that nothing fires.
+ */
+static void test_move_counters_behind_timers(void)
+{
+	int i;
+
+	for_each_sleep_method(i) {
+		sleep_method_t sm = sleep_method[i];
+
+		test_set_cnt_after_cval_no_irq(DEF_CNT, DEF_CNT - 1, 0, sm);
+		test_set_cnt_after_tval_no_irq(DEF_CNT, -1, 0, sm);
+	}
+}
+
+static void test_timers_in_the_past(void)
+{
+	int32_t tval = -1 * (int32_t)msec_to_cycles(10);
+	uint64_t cval;
+	int i;
+
+	for_each_wfi_method(i) {
+		wfi_method_t wm = wfi_method[i];
+
+		/* set a timer 10ms the past. */
+		cval = DEF_CNT - msec_to_cycles(10);
+		test_timer_cval(cval, wm, true, DEF_CNT);
+		test_timer_tval(tval, wm, true, DEF_CNT);
+
+		/* Set a timer to counter=0 (in the past) */
+		test_timer_cval(0, wm, true, DEF_CNT);
+
+		/* Set a time for tval=0 (now) */
+		test_timer_tval(0, wm, true, DEF_CNT);
+
+		/* Set a timer to as far in the past as possible */
+		test_timer_tval(TVAL_MIN, wm, true, DEF_CNT);
+	}
+
+	/*
+	 * Set the counter to 5ms, and a tval to -10ms. There should be no
+	 * timer as that tval means cval=CVAL_MAX-5ms.
+	 */
+	for_each_sleep_method(i) {
+		sleep_method_t sm = sleep_method[i];
+
+		SET_COUNTER(msec_to_cycles(5));
+		test_tval_no_irq(tval, TIMEOUT_NO_IRQ_US, sm);
+	}
+}
+
+static void test_long_timer_delays(void)
+{
+	uint64_t wait_ms = test_args.long_wait_ms;
+	int32_t tval = (int32_t)msec_to_cycles(wait_ms);
+	uint64_t cval;
+	int i;
+
+	for_each_wfi_method(i) {
+		wfi_method_t wm = wfi_method[i];
+
+		cval = DEF_CNT + msec_to_cycles(wait_ms);
+		test_timer_cval(cval, wm, true, DEF_CNT);
+		test_timer_tval(tval, wm, true, DEF_CNT);
+	}
+}
+
 static void guest_run_iteration(void)
 {
 	test_basic_functionality();
 	test_timers_sanity_checks();
+
+	test_timers_above_tval_max();
+	test_timers_in_the_past();
+
+	test_timers_across_rollovers();
+	test_irq_masked_timers_across_rollovers();
+
+	test_move_counters_ahead_of_timers();
+	test_move_counters_behind_timers();
+	test_reprogram_timers();
+
+	test_timers_fired_multiple_times();
+
+	test_timer_control_mask_then_unmask();
+	test_timer_control_masks();
 }
 
 static void guest_code(void)
@@ -420,6 +952,7 @@ static void guest_code(void)
 		guest_run_iteration();
 	}
 
+	test_long_timer_delays();
 	GUEST_DONE();
 }
 
@@ -492,6 +1025,9 @@ static void handle_sync(struct kvm_vm *vm, struct ucall *uc)
 	case SET_REG_KVM_REG_ARM_TIMER_CNT:
 		kvm_set_cntxct(vm, val, timer);
 		break;
+	case USERSPACE_USLEEP:
+		usleep(val);
+		break;
 	case USERSPACE_SCHED_YIELD:
 		sched_yield();
 		break;
@@ -570,13 +1106,15 @@ static struct kvm_vm *test_vm_create(void)
 
 static void test_print_help(char *name)
 {
-	pr_info("Usage: %s [-h] [-i iterations] [-w] [-p pcpu1,pcpu2]\n",
+	pr_info("Usage: %s [-h] [-i iterations] [-p pcpu1,pcpu2] [-l long_wait_ms]\n",
 		name);
 	pr_info("\t-i: Number of iterations (default: %u)\n",
 		NR_TEST_ITERS_DEF);
 	pr_info("\t-p: Pair of pcpus for the vcpus to alternate between. "
 		"Defaults to use the current cpu and the one right after "
 		"in the affinity set.\n");
+	pr_info("\t-l: Delta (in ms) used for long wait time test (default: %u)\n",
+		LONG_WAIT_TEST_MS);
 	pr_info("\t-h: Print this help message\n");
 }
 
@@ -584,7 +1122,7 @@ static bool parse_args(int argc, char *argv[])
 {
 	int opt, ret;
 
-	while ((opt = getopt(argc, argv, "hi:p:")) != -1) {
+	while ((opt = getopt(argc, argv, "hi:p:l:")) != -1) {
 		switch (opt) {
 		case 'i':
 			test_args.iterations = atoi(optarg);
@@ -600,6 +1138,13 @@ static bool parse_args(int argc, char *argv[])
 				goto err;
 			}
 			break;
+		case 'l':
+			test_args.long_wait_ms = atoi(optarg);
+			if (test_args.long_wait_ms <= 0) {
+				pr_info("Positive value needed for -l\n");
+				goto err;
+			}
+			break;
 		case 'h':
 		default:
 			goto err;
-- 
2.35.1.574.g5d30c73bfb-goog

