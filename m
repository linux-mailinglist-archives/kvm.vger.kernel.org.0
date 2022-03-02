Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FAA4CAB71
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbiCBRWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241203AbiCBRWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:22:36 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E358C9916
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:21:52 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso1555551pjt.0
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2fYdchvlVv1J8E9Sk1RbyKjMgcdgbaaE8rhDEXc10fM=;
        b=Whh+nkr+WhYqM7wlQ4Q8CLy8k9vTOz0AN3Wd0XO7VhKmGjmdegAz6HyDtFctYpQ3/r
         Nd6hfoSKI3t3mBAjag8yyfg83m7i0dq+UlU5+zs/wHEGUaRyZA+aXp7r7Kj+XdGjM9Dl
         DrsNa4Pc1WpfLgQ2xiSSkRmI3q7ryPLktbcJZEvpG/UOSuDimuN0pmKOm0i6JOnuQExg
         h1NlvqdoyaIMfYKgR9SSV0S3UYnA7XmwxcNGGmSvfvAjCoQJAWxOOhDKFUdn0Ynw2eIE
         4/kKCdPgu/efyYsB39+BT4dZ0/NtxMjV3psoMQTjmvpqta3745pMVZc/Z0KqfQ8/xXT1
         xA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2fYdchvlVv1J8E9Sk1RbyKjMgcdgbaaE8rhDEXc10fM=;
        b=IvTeUqf/yIvDR2u0eYyEj9IcOkODKsXJHUqAp+L+smVIuB821bQAwi6x1nPoSEKY+9
         4dqCZSEfG8UD89rGtY9HARp0O4RTFTVwPLE2FLKheiqn0y4nsgbpmHeHa+v4kX6crPLi
         /n0yKAJywYNqbEdCQVDQzxPBOPvVFOlN/T3aV69aWzLPXAm2fClcduR8AE4aQgE/Khbl
         lNIsoKbpZXPoA2+RmOCtNTIiNsCTMj7U/2N54YF9ssCXNOBX3x6T3HQLcv/vMQ4nJBTf
         RHsk4Q0ydncvQzXJw9BXjsmrP0ELoOGP3Pxgp92fXzUEXv8TEap9OWpSETDm9t48vij5
         qbFw==
X-Gm-Message-State: AOAM5320spwjRGZiOSTq4zGNf6bzc6X8ks3ODf75fschSQq7zG5jMKQb
        Vnr6oIpUHRUtbZYppqCq5xsBTBqgjrYhQgn9KsMdaX5JwLagakfmjXjZyA0ky6dMpf8R/heLtq4
        MhEZKFIBlaz43MJdGYMTVo9WRGWUVsxulSQNcHpzkf3kTfT6f8Mw+wfzw5bSCYnM=
X-Google-Smtp-Source: ABdhPJx5J56xXUbfxbDN6iCvUjW8BTMrNf97HGmvngc0OeKQyzF0rG9qg2Hw2x9dkEU4rFjR5e2uqulob8IOjw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:cec1:b0:14f:d4d3:58c0 with SMTP
 id d1-20020a170902cec100b0014fd4d358c0mr31761733plg.62.1646241711386; Wed, 02
 Mar 2022 09:21:51 -0800 (PST)
Date:   Wed,  2 Mar 2022 09:21:43 -0800
In-Reply-To: <20220302172144.2734258-1-ricarkol@google.com>
Message-Id: <20220302172144.2734258-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220302172144.2734258-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
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

Add an arch_timer edge-cases selftest. For now, just add some basic
sanity checks, and some stress conditions (like waiting for the timers
while re-scheduling the vcpu). The next commit will add the actual edge
case tests.

This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
interrupts for suspended vCPU".

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 634 ++++++++++++++++++
 3 files changed, 636 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..8f7e0123dd28 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/arch_timer
+/aarch64/arch_timer_edge_cases
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/psci_cpu_on_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0e4926bc9a58..17a0f32cfc91 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -101,6 +101,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
+TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
new file mode 100644
index 000000000000..48c886bce849
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
@@ -0,0 +1,634 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * arch_timer_edge_cases.c - Tests the aarch64 timer IRQ functionality.
+ *
+ * Copyright (c) 2021, Google LLC.
+ */
+
+#define _GNU_SOURCE
+
+#include <stdlib.h>
+#include <pthread.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+#include <linux/bitmap.h>
+#include <sched.h>
+#include <sys/sysinfo.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "delay.h"
+#include "arch_timer.h"
+#include "gic.h"
+#include "vgic.h"
+
+#define VCPUID				0
+
+#define msecs_to_usecs(msec)		((msec) * 1000LL)
+
+#define CVAL_MAX			~0ULL
+/* tval is a signed 32-bit int. */
+#define TVAL_MAX			INT_MAX
+#define TVAL_MIN			INT_MIN
+
+#define GICD_BASE_GPA			0x8000000ULL
+#define GICR_BASE_GPA			0x80A0000ULL
+
+/* After how much time we say there is no IRQ. */
+#define TIMEOUT_NO_IRQ_US		msecs_to_usecs(50)
+
+/* 1ms sounds a bit excessive, but QEMU-TCG is slow. */
+#define TEST_MARGIN_US			1000ULL
+
+/* A nice counter value to use as the starting one for most tests. */
+#define DEF_CNT				(CVAL_MAX / 2)
+
+/* Number of runs. */
+#define NR_TEST_ITERS_DEF		5
+
+/* Shared with IRQ handler. */
+volatile struct test_vcpu_shared_data {
+	int handled;
+} shared_data;
+
+struct test_args {
+	/* Virtual or physical timer and counter tests. */
+	enum arch_timer timer;
+	/* Number of iterations. */
+	int iterations;
+};
+
+struct test_args test_args = {
+	/* Only testing VIRTUAL timers for now. */
+	.timer = VIRTUAL,
+	.iterations = NR_TEST_ITERS_DEF,
+};
+
+static int vtimer_irq, ptimer_irq;
+
+typedef enum sync_cmd {
+	SET_REG_KVM_REG_ARM_TIMER_CNT = 100001,
+	USERSPACE_SCHED_YIELD,
+	USERSPACE_MIGRATE_SELF,
+} sync_cmd_t;
+
+typedef void (*wfi_method_t)(void);
+
+static void wait_for_non_spurious_irq(void);
+static void wait_poll_for_irq(void);
+static void wait_sched_poll_for_irq(void);
+static void wait_migrate_poll_for_irq(void);
+
+wfi_method_t wfi_method[] = {
+	wait_for_non_spurious_irq,
+	wait_poll_for_irq,
+	wait_sched_poll_for_irq,
+	wait_migrate_poll_for_irq,
+};
+
+#define for_each_wfi_method(i)							\
+	for ((i) = 0; (i) < ARRAY_SIZE(wfi_method); (i)++)
+
+typedef enum timer_view {
+	TIMER_CVAL = 1,
+	TIMER_TVAL,
+} timer_view_t;
+
+/* Pair of pcpus for the test to alternate between. */
+static int pcpus[2] = {-1, -1};
+static int pcpus_idx;
+
+static uint32_t next_pcpu(void)
+{
+	pcpus_idx = 1 - pcpus_idx;
+	return pcpus[pcpus_idx];
+}
+
+#define ASSERT_IRQS_HANDLED_2(__nr, arg1, arg2) do {				\
+	int __h = shared_data.handled;						\
+	GUEST_ASSERT_4(__h == (__nr), __h, __nr, arg1, arg2);			\
+} while (0)
+
+#define ASSERT_IRQS_HANDLED_1(__nr, arg1)					\
+	ASSERT_IRQS_HANDLED_2((__nr), arg1, 0)
+
+#define ASSERT_IRQS_HANDLED(__nr)						\
+	ASSERT_IRQS_HANDLED_2((__nr), 0, 0)
+
+#define TIMER_GET_CTL()								\
+	timer_get_ctl(test_args.timer)
+
+#define TIMER_SET_CTL(__ctl)							\
+	timer_set_ctl(test_args.timer, (__ctl))
+
+#define TIMER_SET_CVAL(__cval)							\
+	timer_set_cval(test_args.timer, (__cval))
+
+#define TIMER_SET_TVAL(__tval)							\
+	timer_set_tval(test_args.timer, (__tval))
+
+#define TIMER_GET_CVAL()							\
+	timer_get_cval(test_args.timer)
+
+#define TIMER_GET_TVAL()							\
+	timer_get_tval(test_args.timer)
+
+#define TIMER_GET_CNTCT()							\
+	timer_get_cntct(test_args.timer)
+
+#define __SET_COUNTER(__ctr, __t)						\
+	GUEST_SYNC_ARGS(SET_REG_KVM_REG_ARM_TIMER_CNT, (__ctr), (__t), 0, 0)
+
+#define SET_COUNTER(__ctr)							\
+	__SET_COUNTER((__ctr), test_args.timer)
+
+#define USERSPACE_CMD(__cmd)							\
+	GUEST_SYNC_ARGS(__cmd, 0, 0, 0, 0)
+
+#define USERSPACE_SCHEDULE()							\
+	USERSPACE_CMD(USERSPACE_SCHED_YIELD)
+
+#define USERSPACE_MIGRATE_VCPU()						\
+	USERSPACE_CMD(USERSPACE_MIGRATE_SELF)
+
+#define IAR_SPURIOUS		1023
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	unsigned int intid = gic_get_and_ack_irq();
+	uint64_t cnt, cval;
+	uint32_t ctl;
+
+	GUEST_ASSERT(gic_irq_get_pending(intid));
+
+	if (intid == IAR_SPURIOUS)
+		return;
+
+	ctl = TIMER_GET_CTL();
+	cnt = TIMER_GET_CNTCT();
+	cval = TIMER_GET_CVAL();
+
+	GUEST_ASSERT_1(ctl & CTL_ISTATUS, ctl);
+
+	/* Disable and mask the timer. */
+	TIMER_SET_CTL(CTL_IMASK);
+	GUEST_ASSERT(!gic_irq_get_pending(intid));
+
+	shared_data.handled++;
+
+	GUEST_ASSERT_2(cnt >= cval, cnt, cval);
+
+	gic_set_eoi(intid);
+}
+
+static void set_cval_irq(uint64_t cval_cycles, uint32_t ctl)
+{
+	shared_data.handled = 0;
+	TIMER_SET_CVAL(cval_cycles);
+	TIMER_SET_CTL(ctl);
+}
+
+static void set_tval_irq(uint64_t tval_cycles, uint32_t ctl)
+{
+	shared_data.handled = 0;
+	TIMER_SET_TVAL(tval_cycles);
+	TIMER_SET_CTL(ctl);
+}
+
+static void set_xval_irq(uint64_t xval, uint32_t ctl, timer_view_t tv)
+{
+	switch (tv) {
+	case TIMER_CVAL:
+		set_cval_irq(xval, ctl);
+		break;
+	case TIMER_TVAL:
+		set_tval_irq(xval, ctl);
+		break;
+	default:
+		GUEST_ASSERT(0);
+	}
+}
+
+/*
+ * Should be called with IRQs masked.
+ *
+ * Note that this can hang forever, so we rely on having a timeout mechanism in
+ * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
+ */
+static void wait_for_non_spurious_irq(void)
+{
+	int h;
+
+	for (h = shared_data.handled; h == shared_data.handled;) {
+		asm volatile("wfi\n"
+			     "msr daifclr, #2\n"
+			     /* handle IRQ */
+			     "msr daifset, #2\n"
+			     : : : "memory");
+	}
+}
+
+/*
+ * Wait for an non-spurious IRQ by polling in the guest (userspace=0) or in
+ * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHED_YIELD).
+ *
+ * Should be called with IRQs masked. Not really needed like the wfi above, but
+ * it should match the others.
+ *
+ * Note that this can hang forever, so we rely on having a timeout mechanism in
+ * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
+ */
+static void poll_for_non_spurious_irq(bool userspace, sync_cmd_t userspace_cmd)
+{
+	int h;
+
+	h = shared_data.handled;
+
+	local_irq_enable();
+	while (h == shared_data.handled) {
+		if (userspace)
+			USERSPACE_CMD(userspace_cmd);
+		else
+			cpu_relax();
+	}
+	local_irq_disable();
+}
+
+static void wait_poll_for_irq(void)
+{
+	poll_for_non_spurious_irq(false, -1);
+}
+
+static void wait_sched_poll_for_irq(void)
+{
+	poll_for_non_spurious_irq(true, USERSPACE_SCHED_YIELD);
+}
+
+static void wait_migrate_poll_for_irq(void)
+{
+	poll_for_non_spurious_irq(true, USERSPACE_MIGRATE_SELF);
+}
+
+/*
+ * Reset the timer state to some nice values like the counter not being close
+ * to the edge, and the control register masked and disabled.
+ */
+static void reset_timer_state(uint64_t cnt)
+{
+	SET_COUNTER(cnt);
+	TIMER_SET_CTL(CTL_IMASK);
+}
+
+static void test_timer_xval(uint64_t xval, timer_view_t tv, wfi_method_t wm,
+		bool reset_state, uint64_t reset_cnt)
+{
+	local_irq_disable();
+
+	if (reset_state)
+		reset_timer_state(reset_cnt);
+
+	set_xval_irq(xval, CTL_ENABLE, tv);
+	wm();
+
+	ASSERT_IRQS_HANDLED_2(1, tv, wm);
+	local_irq_enable();
+}
+
+/*
+ * The test_timer_* functions will program the timer, wait for it, and assert
+ * the firing of the correct IRQ.
+ *
+ * These functions don't have a timeout and return as soon as they receive an
+ * IRQ. They can hang (forever), so we rely on having a timeout mechanism in
+ * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
+ */
+
+static void test_timer_cval(uint64_t cval, wfi_method_t wm, bool reset_state,
+		uint64_t reset_cnt)
+{
+	test_timer_xval(cval, TIMER_CVAL, wm, reset_state, reset_cnt);
+}
+
+static void test_timer_tval(int32_t tval, wfi_method_t wm, bool reset_state,
+		uint64_t reset_cnt)
+{
+	test_timer_xval((uint64_t)tval, TIMER_TVAL, wm, reset_state, reset_cnt);
+}
+
+static void test_basic_functionality(void)
+{
+	int32_t tval = (int32_t)msec_to_cycles(10);
+	uint64_t cval;
+	int i;
+
+	for_each_wfi_method(i) {
+		wfi_method_t wm = wfi_method[i];
+
+		cval = DEF_CNT + msec_to_cycles(10);
+
+		test_timer_cval(cval, wm, true, DEF_CNT);
+		test_timer_tval(tval, wm, true, DEF_CNT);
+	}
+}
+
+/*
+ * This test checks basic timer behavior without actually firing timers, things
+ * like: the relationship between cval and tval, tval down-counting.
+ */
+static void timers_sanity_checks(bool use_sched)
+{
+	reset_timer_state(DEF_CNT);
+
+	local_irq_disable();
+
+	/* cval in the past */
+	TIMER_SET_CVAL(TIMER_GET_CNTCT() - msec_to_cycles(10));
+	if (use_sched)
+		USERSPACE_SCHEDULE();
+	GUEST_ASSERT(TIMER_GET_TVAL() < 0);
+
+	/* tval in the past */
+	TIMER_SET_TVAL(-1);
+	if (use_sched)
+		USERSPACE_SCHEDULE();
+	GUEST_ASSERT(TIMER_GET_CVAL() < TIMER_GET_CNTCT());
+
+	/* tval larger than TVAL_MAX. */
+	TIMER_SET_CVAL(TIMER_GET_CNTCT() + TVAL_MAX + msec_to_cycles(10));
+	if (use_sched)
+		USERSPACE_SCHEDULE();
+	GUEST_ASSERT(TIMER_GET_TVAL() <= 0);
+
+	/*
+	 * tval larger than 2 * TVAL_MAX.
+	 * Twice the TVAL_MAX completely loops around the TVAL.
+	 */
+	TIMER_SET_CVAL(TIMER_GET_CNTCT() + 2ULL * TVAL_MAX + msec_to_cycles(10));
+	if (use_sched)
+		USERSPACE_SCHEDULE();
+	GUEST_ASSERT_1(TIMER_GET_TVAL() <= msec_to_cycles(10), TIMER_GET_TVAL());
+
+	/* negative tval that rollovers from 0. */
+	SET_COUNTER(msec_to_cycles(1));
+	TIMER_SET_TVAL(-1 * msec_to_cycles(10));
+	if (use_sched)
+		USERSPACE_SCHEDULE();
+	GUEST_ASSERT(TIMER_GET_CVAL() >= (CVAL_MAX - msec_to_cycles(9)));
+
+	/* tval should keep down-counting from 0 to -1. */
+	TIMER_SET_TVAL(0);
+	/* We just need 1 cycle to pass. */
+	isb();
+	GUEST_ASSERT(TIMER_GET_TVAL() < 0);
+
+	local_irq_enable();
+
+	/* Mask and disable any pending timer. */
+	TIMER_SET_CTL(CTL_IMASK);
+}
+
+static void test_timers_sanity_checks(void)
+{
+	timers_sanity_checks(false);
+	/* Check how KVM saves/restores these edge-case values. */
+	timers_sanity_checks(true);
+}
+
+static void guest_run_iteration(void)
+{
+	test_basic_functionality();
+	test_timers_sanity_checks();
+}
+
+static void guest_code(void)
+{
+	int i;
+
+	local_irq_disable();
+
+	gic_init(GIC_V3, 1, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+
+	TIMER_SET_CTL(CTL_IMASK);
+	timer_set_ctl(PHYSICAL, CTL_IMASK);
+
+	gic_irq_enable(vtimer_irq);
+	gic_irq_enable(ptimer_irq);
+	local_irq_enable();
+
+	for (i = 0; i < test_args.iterations; i++) {
+		GUEST_SYNC(i);
+		guest_run_iteration();
+	}
+
+	GUEST_DONE();
+}
+
+static void migrate_self(uint32_t new_pcpu)
+{
+	int ret;
+	cpu_set_t cpuset;
+	pthread_t thread;
+
+	thread = pthread_self();
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(new_pcpu, &cpuset);
+
+	pr_debug("Migrating from %u to %u\n", sched_getcpu(), new_pcpu);
+
+	ret = pthread_setaffinity_np(thread, sizeof(cpuset), &cpuset);
+
+	TEST_ASSERT(ret == 0, "Failed to migrate to pCPU: %u; ret: %d\n",
+			new_pcpu, ret);
+}
+
+/*
+ * Set the two pcpus that the test will use to alternate between. Default to
+ * use the current cpu as pcpus[0] and the one right after in the affinity set
+ * as pcpus[1].
+ */
+static void set_default_pcpus(void)
+{
+	int max	= get_nprocs();
+	int curr = sched_getcpu();
+	cpu_set_t cpuset;
+	long i;
+
+	TEST_ASSERT(max > 1, "Need at least 2 online pcpus.");
+
+	pcpus[0] = curr;
+
+	sched_getaffinity(getpid(), sizeof(cpu_set_t), &cpuset);
+	for (i = (curr + 1) % CPU_SETSIZE; i != curr; i = (i + 1) % CPU_SETSIZE) {
+		if (CPU_ISSET(i, &cpuset)) {
+			pcpus[1] = i;
+			break;
+		}
+	}
+
+	TEST_ASSERT(pcpus[1] != -1, "Couldn't find a second pcpu.");
+	pr_debug("pcpus: %d %d\n", pcpus[0], pcpus[1]);
+}
+
+static void kvm_set_cntxct(struct kvm_vm *vm, uint64_t cnt, enum arch_timer timer)
+{
+	TEST_ASSERT(timer == VIRTUAL,
+		"Only supports setting the virtual counter for now.");
+
+	struct kvm_one_reg reg = {
+		.id = KVM_REG_ARM_TIMER_CNT,
+		.addr = (uint64_t)&cnt,
+	};
+	vcpu_set_reg(vm, 0, &reg);
+}
+
+static void handle_sync(struct kvm_vm *vm, struct ucall *uc)
+{
+	sync_cmd_t cmd = uc->args[1];
+	uint64_t val = uc->args[2];
+	enum arch_timer timer = uc->args[3];
+
+	switch (cmd) {
+	case SET_REG_KVM_REG_ARM_TIMER_CNT:
+		kvm_set_cntxct(vm, val, timer);
+		break;
+	case USERSPACE_SCHED_YIELD:
+		sched_yield();
+		break;
+	case USERSPACE_MIGRATE_SELF:
+		migrate_self(next_pcpu());
+		break;
+	default:
+		break;
+	}
+}
+
+static void test_run(struct kvm_vm *vm)
+{
+	struct ucall uc;
+	int stage = 0;
+
+	/* Start on the first pcpu. */
+	migrate_self(pcpus[0]);
+
+	sync_global_to_guest(vm, test_args);
+
+	for (stage = 0; ; stage++) {
+		vcpu_run(vm, VCPUID);
+		switch (get_ucall(vm, VCPUID, &uc)) {
+		case UCALL_SYNC:
+			handle_sync(vm, &uc);
+			break;
+		case UCALL_DONE:
+			goto out;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld\n\tvalues: %lu, %lu; %lu",
+				(const char *)uc.args[0], __FILE__, uc.args[1],
+				uc.args[2], uc.args[3], uc.args[4]);
+			goto out;
+		default:
+			TEST_FAIL("Unexpected guest exit\n");
+		}
+	}
+
+out:
+	return;
+}
+
+static void test_init_timer_irq(struct kvm_vm *vm)
+{
+	int vcpu_fd = vcpu_get_fd(vm, VCPUID);
+
+	kvm_device_access(vcpu_fd, KVM_ARM_VCPU_TIMER_CTRL,
+			KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq, false);
+	kvm_device_access(vcpu_fd, KVM_ARM_VCPU_TIMER_CTRL,
+			KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq, false);
+
+	sync_global_to_guest(vm, ptimer_irq);
+	sync_global_to_guest(vm, vtimer_irq);
+
+	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
+}
+
+static struct kvm_vm *test_vm_create(void)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create_default(VCPUID, 0, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
+
+	vcpu_init_descriptor_tables(vm, 0);
+
+	ucall_init(vm, NULL);
+	test_init_timer_irq(vm);
+	vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+
+	return vm;
+}
+
+static void test_print_help(char *name)
+{
+	pr_info("Usage: %s [-h] [-i iterations] [-w] [-p pcpu1,pcpu2]\n",
+		name);
+	pr_info("\t-i: Number of iterations (default: %u)\n",
+		NR_TEST_ITERS_DEF);
+	pr_info("\t-p: Pair of pcpus for the vcpus to alternate between. "
+		"Defaults to use the current cpu and the one right after "
+		"in the affinity set.\n");
+	pr_info("\t-h: Print this help message\n");
+}
+
+static bool parse_args(int argc, char *argv[])
+{
+	int opt, ret;
+
+	while ((opt = getopt(argc, argv, "hi:p:")) != -1) {
+		switch (opt) {
+		case 'i':
+			test_args.iterations = atoi(optarg);
+			if (test_args.iterations <= 0) {
+				pr_info("Positive value needed for -i\n");
+				goto err;
+			}
+			break;
+		case 'p':
+			ret = sscanf(optarg, "%u,%u", &pcpus[0], &pcpus[1]);
+			if (ret != 2) {
+				pr_info("Invalid pcpus pair");
+				goto err;
+			}
+			break;
+		case 'h':
+		default:
+			goto err;
+		}
+	}
+
+	return true;
+
+err:
+	test_print_help(argv[0]);
+	return false;
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	if (!parse_args(argc, argv))
+		exit(KSFT_SKIP);
+
+	if (pcpus[0] == -1 || pcpus[1] == -1)
+		set_default_pcpus();
+
+	vm = test_vm_create();
+	test_run(vm);
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.35.1.574.g5d30c73bfb-goog

