Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED77F4DBF9A
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 07:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiCQGqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 02:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiCQGqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 02:46:18 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC4BDF49C
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 23:45:00 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id x9so3114707ilc.3
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 23:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v7pGjN/Wy8oCjNwWtYxhmpBFrWvxobyE3IAs+6OAU0g=;
        b=N/WKdN1Vt8nnk7BQB593i1AH3F3hcqjxlmQTSIkQat987PtewY8lZZfp75zriGX2NU
         mCnCA+S99BCvuaFa7GtC9e1ZtAze1F148QbauI3OOvLJzkGjSxiH6Xip57FojksLHaXI
         bbvlJDqxhQL40Kc3MIFhoeX8gEnyF6d0gbG67LxJlmYxOffgbXbVX+Vuz5E/5+FdBWAd
         vLLFRXipJpmmP2D1acBOyJgOawVWr2LgSf8dV6RfQ85BBGWxxgcHx2ZkhIB/YBYZMvnC
         W7RVOprPSL17EJ2nQwsxFyovtCpAf2JOjRYcf21sJYgKy4+QjsLedI2QoiWnf0Cn6dl4
         f18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v7pGjN/Wy8oCjNwWtYxhmpBFrWvxobyE3IAs+6OAU0g=;
        b=BsWIKwydeKFj9RUZMcVOj2C8O1+40S99eUnJPd1RzAk2e6S0Us84fzYRotN12ZONCc
         gA9M+hntG80j53lOSFoUS0L6SQy4ZlqiuhwpnkAfUnnpoZJjyd51xUO/wo4WWmUowtag
         FcC51zjuMZU56Q9o/Vvtk/0fOOcwdJMilj0iuFjoc0n3PIK+tXoDvhZRuRPNievq2Xp/
         mK3yJ1iKhmWuy3odGx+7gLz4JlbqDuPHq9ijhgGLA3B8u4nbNXdoau8eenKzjRsjwzlp
         qqL1Bo8+sGMZVwUnTtcMwzRHALa3r7jqC/RTCs8H9gYR2cqo97Vje4wajQ/4/qnzoD4J
         UA8w==
X-Gm-Message-State: AOAM533acU7Q/x9oUX9vnSLj7CpTErbXL5vh/rb3MZ+w0Eh3pjIPjrqY
        dhoXy7UGxppoEORK1NGjkg53pg==
X-Google-Smtp-Source: ABdhPJzdV5eIVU7cgw9abDUJ1XCzV25pkEpUkTbUle8Fn570ZHjPi00vWOTRpdzjwWgH4bcU23tqlA==
X-Received: by 2002:a92:d2d0:0:b0:2c6:65a9:35cc with SMTP id w16-20020a92d2d0000000b002c665a935ccmr1234961ilg.262.1647499499722;
        Wed, 16 Mar 2022 23:44:59 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id m8-20020a92d708000000b002c6381d9144sm2307984iln.59.2022.03.16.23.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 23:44:59 -0700 (PDT)
Date:   Thu, 17 Mar 2022 06:44:55 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com
Subject: Re: [PATCH v2 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
Message-ID: <YjLY5y+KObV0AR9g@google.com>
References: <20220317045127.124602-1-ricarkol@google.com>
 <20220317045127.124602-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317045127.124602-3-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 09:51:26PM -0700, Ricardo Koller wrote:
> Add an arch_timer edge-cases selftest. For now, just add some basic
> sanity checks, and some stress conditions (like waiting for the timers
> while re-scheduling the vcpu). The next commit will add the actual edge
> case tests.
> 
> This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
> interrupts for suspended vCPU".
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/aarch64/arch_timer_edge_cases.c       | 568 ++++++++++++++++++
>  3 files changed, 570 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index dce7de7755e6..8f7e0123dd28 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  /aarch64/arch_timer
> +/aarch64/arch_timer_edge_cases
>  /aarch64/debug-exceptions
>  /aarch64/get-reg-list
>  /aarch64/psci_cpu_on_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 17c3f0749f05..d4466ca76f21 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -100,6 +100,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
>  TEST_GEN_PROGS_x86_64 += system_counter_offset_test
>  
>  TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
> +TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
>  TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> new file mode 100644
> index 000000000000..dc399482e35d
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> @@ -0,0 +1,568 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * arch_timer_edge_cases.c - Tests the aarch64 timer IRQ functionality.
> + *
> + * Some of these tests program timers and then wait indefinitely for them to
> + * fire.  We rely on having a timeout mechanism in the "runner", like
> + * tools/testing/selftests/kselftest/runner.sh.
> + *
> + * Copyright (c) 2021, Google LLC.
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include <stdlib.h>
> +#include <pthread.h>
> +#include <linux/kvm.h>
> +#include <linux/sizes.h>
> +#include <linux/bitmap.h>
> +#include <sched.h>
> +#include <sys/sysinfo.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "delay.h"
> +#include "arch_timer.h"
> +#include "gic.h"
> +#include "vgic.h"
> +
> +#define VCPUID				0
> +
> +#define msecs_to_usecs(msec)		((msec) * 1000LL)

nit: drop the macro and simply open code the multiplication of
USEC_PER_MSEC

> +
> +#define CVAL_MAX			(~0ULL)
> +/* tval is a signed 32-bit int. */
> +#define TVAL_MAX			INT_MAX
> +#define TVAL_MIN			INT_MIN
> +
> +#define GICD_BASE_GPA			0x8000000ULL
> +#define GICR_BASE_GPA			0x80A0000ULL
> +
> +/* After how much time we say there is no IRQ. */
> +#define TIMEOUT_NO_IRQ_US		msecs_to_usecs(50)
> +
> +/* A nice counter value to use as the starting one for most tests. */
> +#define DEF_CNT				(CVAL_MAX / 2)
> +
> +/* Number of runs. */
> +#define NR_TEST_ITERS_DEF		5
> +
> +/* Shared with IRQ handler. */
> +volatile struct test_vcpu_shared_data {
> +	int handled;
> +} shared_data;
> +
> +struct test_args {
> +	/* Virtual or physical timer and counter tests. */
> +	enum arch_timer timer;
> +	/* Number of iterations. */
> +	int iterations;
> +};
> +
> +struct test_args test_args = {
> +	/* Only testing VIRTUAL timers for now. */
> +	.timer = VIRTUAL,
> +	.iterations = NR_TEST_ITERS_DEF,
> +};
> +
> +static int vtimer_irq, ptimer_irq;
> +
> +enum sync_cmd {
> +	SET_REG_KVM_REG_ARM_TIMER_CNT,
> +	USERSPACE_SCHED_YIELD,
> +	USERSPACE_MIGRATE_SELF,
> +};
> +
> +typedef void (*wait_method_t)(void);
> +
> +static void wait_for_non_spurious_irq(void);
> +static void wait_poll_for_irq(void);
> +static void wait_sched_poll_for_irq(void);
> +static void wait_migrate_poll_for_irq(void);
> +
> +wait_method_t wait_method[] = {
> +	wait_for_non_spurious_irq,
> +	wait_poll_for_irq,
> +	wait_sched_poll_for_irq,
> +	wait_migrate_poll_for_irq,
> +};
> +
> +enum timer_view {
> +	TIMER_CVAL,
> +	TIMER_TVAL,
> +};
> +
> +/* Pair of pcpus for the test to alternate between. */
> +static int pcpus[2] = {-1, -1};
> +static int pcpus_idx;
> +
> +static uint32_t next_pcpu(void)
> +{
> +	pcpus_idx = 1 - pcpus_idx;
> +	return pcpus[pcpus_idx];
> +}
> +
> +#define ASSERT_IRQS_HANDLED_2(__nr, arg1, arg2) do {				\
> +	int __h = shared_data.handled;						\
> +	GUEST_ASSERT_4(__h == (__nr), __h, __nr, arg1, arg2);			\
> +} while (0)
> +
> +#define ASSERT_IRQS_HANDLED_1(__nr, arg1)					\
> +	ASSERT_IRQS_HANDLED_2((__nr), arg1, 0)
> +
> +#define ASSERT_IRQS_HANDLED(__nr)						\
> +	ASSERT_IRQS_HANDLED_2((__nr), 0, 0)
> +
> +#define SET_COUNTER(__ctr, __t)							\
> +	GUEST_SYNC_ARGS(SET_REG_KVM_REG_ARM_TIMER_CNT, (__ctr), (__t), 0, 0)
> +
> +#define USERSPACE_CMD(__cmd)							\
> +	GUEST_SYNC_ARGS(__cmd, 0, 0, 0, 0)
> +
> +#define USERSPACE_SCHEDULE()							\
> +	USERSPACE_CMD(USERSPACE_SCHED_YIELD)
> +
> +#define USERSPACE_MIGRATE_VCPU()						\
> +	USERSPACE_CMD(USERSPACE_MIGRATE_SELF)
> +
> +static void guest_irq_handler(struct ex_regs *regs)
> +{
> +	unsigned int intid = gic_get_and_ack_irq();
> +	uint64_t cnt, cval;
> +	uint32_t ctl;
> +
> +	if (intid == IAR_SPURIOUS)
> +		return;
> +
> +	GUEST_ASSERT(gic_irq_get_pending(intid));
> +
> +	ctl = timer_get_ctl(test_args.timer);
> +	cnt = timer_get_cntct(test_args.timer);
> +	cval = timer_get_cval(test_args.timer);
> +
> +	GUEST_ASSERT_1(ctl & CTL_ISTATUS, ctl);
> +
> +	/* Disable and mask the timer. */
> +	timer_set_ctl(test_args.timer, CTL_IMASK);
> +	GUEST_ASSERT(!gic_irq_get_pending(intid));
> +
> +	shared_data.handled++;
> +
> +	/* The IRQ should not fire before time. */
> +	GUEST_ASSERT_2(cnt >= cval, cnt, cval);
> +
> +	gic_set_eoi(intid);
> +}
> +
> +static void program_timer_irq(uint64_t xval, uint32_t ctl, enum timer_view tv) > +{
> +	shared_data.handled = 0;
> +
> +	switch (tv) {
> +	case TIMER_CVAL:
> +		timer_set_cval(test_args.timer, xval);
> +		timer_set_ctl(test_args.timer, ctl);
> +		break;
> +	case TIMER_TVAL:
> +		timer_set_tval(test_args.timer, xval);
> +		timer_set_ctl(test_args.timer, ctl);
> +		break;
> +	default:
> +		GUEST_ASSERT(0);
> +	}
> +}
> +
> +/*
> + * Should be called with IRQs masked.
> + */
> +static void wait_for_non_spurious_irq(void)
> +{
> +	int h;
> +
> +	for (h = shared_data.handled; h == shared_data.handled;) {

how about:

  h = shared_data.handled;

  /* Wait for the IRQ handler to process an interrupt */
  while (h == shared_data.handled) {

  }

Brain is trained to think iteration when I see a for loop, and a while
loop does a better job hinting that we are waiting for a condition to be
met.

> +		asm volatile("wfi\n"
> +			     "msr daifclr, #2\n"
> +			     /* handle IRQ */

I believe an isb is owed here (DDI0487G.b D1.13.4). Annoyingly, I am
having a hard time finding the same language in the H.a revision of the
manual :-/

> +			     "msr daifset, #2\n"
> +			     : : : "memory");
> +	}
> +}
> +
> +/*
> + * Wait for an non-spurious IRQ by polling in the guest (userspace=0) or in
> + * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHED_YIELD).
> + *
> + * Should be called with IRQs masked. Not really needed like the wfi above, but
> + * it should match the others.
> + */
> +static void poll_for_non_spurious_irq(bool userspace,
> +		enum sync_cmd userspace_cmd)
> +{
> +	int h;
> +
> +	h = shared_data.handled;
> +
> +	local_irq_enable();
> +	while (h == shared_data.handled) {
> +		if (userspace)
> +			USERSPACE_CMD(userspace_cmd);
> +		else
> +			cpu_relax();
> +	}
> +	local_irq_disable();
> +}
> +
> +static void wait_poll_for_irq(void)
> +{
> +	poll_for_non_spurious_irq(false, -1);
> +}
> +
> +static void wait_sched_poll_for_irq(void)
> +{
> +	poll_for_non_spurious_irq(true, USERSPACE_SCHED_YIELD);
> +}
> +
> +static void wait_migrate_poll_for_irq(void)
> +{
> +	poll_for_non_spurious_irq(true, USERSPACE_MIGRATE_SELF);
> +}
> +
> +/*
> + * Reset the timer state to some nice values like the counter not being close
> + * to the edge, and the control register masked and disabled.
> + */
> +static void reset_timer_state(uint64_t cnt)
> +{
> +	SET_COUNTER(cnt, test_args.timer);
> +	timer_set_ctl(test_args.timer, CTL_IMASK);
> +}
> +
> +static void test_timer(uint64_t reset_cnt, uint64_t xval,
> +		wait_method_t wm, enum timer_view tv)
> +{
> +	local_irq_disable();
> +
> +	reset_timer_state(reset_cnt);
> +
> +	program_timer_irq(xval, CTL_ENABLE, tv);
> +	wm();
> +
> +	ASSERT_IRQS_HANDLED_1(1, tv);
> +	local_irq_enable();
> +}
> +
> +static void test_basic_functionality(void)
> +{
> +	int32_t tval = (int32_t)msec_to_cycles(10);
> +	uint64_t cval;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wait_method); i++) {
> +		wait_method_t wm = wait_method[i];
> +
> +		cval = DEF_CNT + msec_to_cycles(10);
> +
> +		test_timer(DEF_CNT, cval, wm, TIMER_CVAL);
> +		test_timer(DEF_CNT, tval, wm, TIMER_TVAL);
> +	}
> +}
> +
> +/*
> + * This test checks basic timer behavior without actually firing timers, things
> + * like: the relationship between cval and tval, tval down-counting.
> + */
> +static void timers_sanity_checks(bool use_sched)
> +{
> +	uint64_t cval;
> +
> +	reset_timer_state(DEF_CNT);
> +
> +	local_irq_disable();
> +
> +	/* cval in the past */
> +	timer_set_cval(test_args.timer, timer_get_cntct(test_args.timer) - 1);
> +	if (use_sched)
> +		USERSPACE_SCHEDULE();
> +	GUEST_ASSERT(timer_get_tval(test_args.timer) < 0);
> +
> +	/* tval in the past */
> +	timer_set_tval(test_args.timer, -1);
> +	if (use_sched)
> +		USERSPACE_SCHEDULE();
> +	GUEST_ASSERT(timer_get_cval(test_args.timer) <
> +			timer_get_cntct(test_args.timer));
> +
> +	/* tval larger than TVAL_MAX. */
> +	cval = timer_get_cntct(test_args.timer) + 2ULL * TVAL_MAX - 1;
> +	timer_set_cval(test_args.timer, cval);
> +	if (use_sched)
> +		USERSPACE_SCHEDULE();
> +	GUEST_ASSERT(timer_get_tval(test_args.timer) <= 0);
> +	GUEST_ASSERT_EQ(cval, timer_get_cval(test_args.timer));
> +
> +	/* tval should keep down-counting from 0 to -1. */
> +	SET_COUNTER(DEF_CNT, test_args.timer);
> +	timer_set_tval(test_args.timer, 0);
> +	if (use_sched)
> +		USERSPACE_SCHEDULE();
> +	/* We just need 1 cycle to pass. */
> +	isb();

Somewhat paranoid, but:

If the CPU retires the ISB much more quickly than the counter ticks, its
possible that you could observe an invalid TVAL even with a valid
implementation.

What if you spin waiting for CNT to increment before the assertion? Then
you for sureknow (and can tell by reading the test) that the
implementation is broken.

> +	GUEST_ASSERT(timer_get_tval(test_args.timer) < 0);
> +
> +	local_irq_enable();
> +
> +	/* Mask and disable any pending timer. */
> +	timer_set_ctl(test_args.timer, CTL_IMASK);
> +}
> +
> +static void test_timers_sanity_checks(void)
> +{
> +	timers_sanity_checks(false);
> +	/* Check how KVM saves/restores these edge-case values. */
> +	timers_sanity_checks(true);
> +}
> +
> +static void guest_run_iteration(void)
> +{
> +	test_timers_sanity_checks();
> +	test_basic_functionality();
> +}
> +
> +static void guest_code(void)
> +{
> +	int i;
> +
> +	local_irq_disable();
> +
> +	gic_init(GIC_V3, 1, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
> +
> +	timer_set_ctl(test_args.timer, CTL_IMASK);
> +	timer_set_ctl(PHYSICAL, CTL_IMASK);
> +
> +	gic_irq_enable(vtimer_irq);
> +	gic_irq_enable(ptimer_irq);
> +	local_irq_enable();
> +
> +	for (i = 0; i < test_args.iterations; i++) {
> +		GUEST_SYNC(i);
> +		guest_run_iteration();
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void migrate_self(uint32_t new_pcpu)
> +{
> +	int ret;
> +	cpu_set_t cpuset;
> +	pthread_t thread;
> +
> +	thread = pthread_self();
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(new_pcpu, &cpuset);
> +
> +	pr_debug("Migrating from %u to %u\n", sched_getcpu(), new_pcpu);
> +
> +	ret = pthread_setaffinity_np(thread, sizeof(cpuset), &cpuset);
> +
> +	TEST_ASSERT(ret == 0, "Failed to migrate to pCPU: %u; ret: %d\n",
> +			new_pcpu, ret);
> +}
> +
> +/*
> + * Set the two pcpus that the test will use to alternate between. Default to
> + * use the current cpu as pcpus[0] and the one right after in the affinity set
> + * as pcpus[1].
> + */
> +static void set_default_pcpus(void)
> +{
> +	int max	= get_nprocs();
> +	int curr = sched_getcpu();
> +	cpu_set_t cpuset;
> +	long i;
> +
> +	TEST_ASSERT(max > 1, "Need at least 2 online pcpus.");
> +

I don't think this could ever be reached, given that you exit(KSFT_SKIP)
for this condition. Maybe just take the string from this assertion and
add a pr_skip() to your early exit.

> +	pcpus[0] = curr;
> +
> +	sched_getaffinity(getpid(), sizeof(cpu_set_t), &cpuset);
> +	for (i = (curr + 1) % CPU_SETSIZE; i != curr; i = (i + 1) % CPU_SETSIZE) {
> +		if (CPU_ISSET(i, &cpuset)) {
> +			pcpus[1] = i;
> +			break;
> +		}
> +	}
> +
> +	TEST_ASSERT(pcpus[1] != -1, "Couldn't find a second pcpu.");
> +	pr_debug("pcpus: %d %d\n", pcpus[0], pcpus[1]);
> +}
> +
> +static void kvm_set_cntxct(struct kvm_vm *vm, uint64_t cnt, enum arch_timer timer)
> +{
> +	TEST_ASSERT(timer == VIRTUAL,
> +		"Only supports setting the virtual counter for now.");
> +
> +	struct kvm_one_reg reg = {
> +		.id = KVM_REG_ARM_TIMER_CNT,
> +		.addr = (uint64_t)&cnt,
> +	};
> +	vcpu_set_reg(vm, 0, &reg);
> +}
> +
> +static void handle_sync(struct kvm_vm *vm, struct ucall *uc)
> +{
> +	enum sync_cmd cmd = uc->args[1];
> +	uint64_t val = uc->args[2];
> +	enum arch_timer timer = uc->args[3];
> +
> +	switch (cmd) {
> +	case SET_REG_KVM_REG_ARM_TIMER_CNT:
> +		kvm_set_cntxct(vm, val, timer);
> +		break;
> +	case USERSPACE_SCHED_YIELD:
> +		sched_yield();
> +		break;
> +	case USERSPACE_MIGRATE_SELF:
> +		migrate_self(next_pcpu());
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static void test_run(struct kvm_vm *vm)
> +{
> +	struct ucall uc;
> +	int stage = 0;
> +
> +	/* Start on the first pcpu. */
> +	migrate_self(pcpus[0]);
> +
> +	sync_global_to_guest(vm, test_args);
> +
> +	for (stage = 0; ; stage++) {
> +		vcpu_run(vm, VCPUID);
> +		switch (get_ucall(vm, VCPUID, &uc)) {
> +		case UCALL_SYNC:
> +			handle_sync(vm, &uc);
> +			break;
> +		case UCALL_DONE:
> +			goto out;
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s at %s:%ld\n\tvalues: %lu, %lu; %lu",
> +				(const char *)uc.args[0], __FILE__, uc.args[1],
> +				uc.args[2], uc.args[3], uc.args[4]);
> +			goto out;
> +		default:
> +			TEST_FAIL("Unexpected guest exit\n");
> +		}
> +	}
> +
> +out:
> +	return;
> +}
> +
> +static void test_init_timer_irq(struct kvm_vm *vm)
> +{
> +	int vcpu_fd = vcpu_get_fd(vm, VCPUID);
> +
> +	kvm_device_access(vcpu_fd, KVM_ARM_VCPU_TIMER_CTRL,
> +			KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq, false);
> +	kvm_device_access(vcpu_fd, KVM_ARM_VCPU_TIMER_CTRL,
> +			KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq, false);
> +
> +	sync_global_to_guest(vm, ptimer_irq);
> +	sync_global_to_guest(vm, vtimer_irq);
> +
> +	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
> +}
> +
> +static struct kvm_vm *test_vm_create(void)
> +{
> +	struct kvm_vm *vm;
> +	int ret;
> +
> +	vm = vm_create_default(VCPUID, 0, guest_code);
> +
> +	vm_init_descriptor_tables(vm);
> +	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
> +
> +	vcpu_init_descriptor_tables(vm, 0);
> +
> +	ucall_init(vm, NULL);
> +	test_init_timer_irq(vm);
> +	ret = vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +	if (ret < 0) {
> +		print_skip("Failed to create vgic-v3, skipping");

I believe print_skip() already appends something about skipping the test.

> +		exit(KSFT_SKIP);
> +	}
> +
> +	return vm;
> +}
> +
> +static void test_print_help(char *name)
> +{
> +	pr_info("Usage: %s [-h] [-i iterations] [-w] [-p pcpu1,pcpu2]\n",
> +		name);
> +	pr_info("\t-i: Number of iterations (default: %u)\n",
> +		NR_TEST_ITERS_DEF);
> +	pr_info("\t-p: Pair of pcpus for the vcpus to alternate between.\n");
> +	pr_info("\t-h: Print this help message\n");
> +}
> +
> +static bool parse_args(int argc, char *argv[])
> +{
> +	int opt, ret;
> +
> +	while ((opt = getopt(argc, argv, "hi:p:")) != -1) {
> +		switch (opt) {
> +		case 'i':
> +			test_args.iterations = atoi(optarg);
> +			if (test_args.iterations <= 0) {
> +				pr_info("Positive value needed for -i\n");
> +				goto err;
> +			}
> +			break;
> +		case 'p':
> +			ret = sscanf(optarg, "%u,%u", &pcpus[0], &pcpus[1]);

It may also be useful to check if the desired CPUs are in the set of
online CPUs, exiting early if not.

> +			if (ret != 2) {
> +				pr_info("Invalid pcpus pair");
> +				goto err;
> +			}
> +			break;
> +		case 'h':
> +		default:
> +			goto err;
> +		}
> +	}
> +
> +	return true;
> +
> +err:
> +	test_print_help(argv[0]);
> +	return false;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vm *vm;
> +
> +	/* Tell stdout not to buffer its content */
> +	setbuf(stdout, NULL);
> +
> +	if (!parse_args(argc, argv))
> +		exit(KSFT_SKIP);
> +
> +	if (get_nprocs() < 2)
> +		exit(KSFT_SKIP);
> +
> +	if (pcpus[0] == -1 || pcpus[1] == -1)
> +		set_default_pcpus();
> +
> +	vm = test_vm_create();
> +	test_run(vm);
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
> -- 
> 2.35.1.723.g4982287a31-goog
> 
