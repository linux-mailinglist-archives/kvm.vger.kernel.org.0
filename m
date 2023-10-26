Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100E67D785D
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 01:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjJYXHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 19:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJYXHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 19:07:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F03115
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 16:07:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da05c625cb9so200000276.2
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 16:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698275234; x=1698880034; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O15cc11Y2U+X3cd4yQ+sgNWTgH6WIo6obZaTsCYESCg=;
        b=mTQhe8G9/IMvTnXGnuAuDHPtfJkU58ZWy1e47h3lH32cHtafGMFEwvIycYsPqRq9m7
         YgD8UsVMtexPnzz8lLLK5OLtYi1S3XxyAmHXrgWgnx+9NP5lxytTUqjFUTTjrzgQXsX3
         Kak2Hau4FXGlv/B34VoA3SFRWhsN8gZmyE6X8mc1JCk2d1tEcewnWcdxunqD3RJmc00G
         TMI1DgZo4GfI6LxjfNptiTnMvM267a8gqP4ZUvbuvMkiHKr6g+UDtkv/ABrnISDui6eK
         1yxQYC/xm4r/hE15HHZ5m9O0T6x8X7ycNZFM38IamZqL+l2oN02NKz9wzEFQ+2SEYimZ
         5UsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698275234; x=1698880034;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O15cc11Y2U+X3cd4yQ+sgNWTgH6WIo6obZaTsCYESCg=;
        b=ZpnDAdMEz0M8zcndEV5dk3LRgnR596MmRsZU3qF+we0zjmajKyS5Dr9RxbHZQlj5lZ
         37V/sWbvhkILZZ2thBzKaZ9mSt3McKqCbC34JdaRC63eFJ79EDP0/8j3qvP/DGuyjien
         riqbLC5bT3sGcGV6GfUa83DIJQgJUYaoJ0SFqRCuDKJln9XCGyh0mxO3yfppfAi0PH67
         krIKIRMpp96/qV0guPJRrnoRreCX+mmV0AZR/r0PTCs61VB8976cntlgi6W3sgc2JKcO
         AzGjI9qHf1Kk2idHIeKCW1CQ4NUdPi3VqbZX7+DathyJwpwNV7a7ISKXjR9qb+3t7/Uv
         hDnQ==
X-Gm-Message-State: AOJu0YxtPWTJ3zxClcIUFq+3LbOVCELGQmX42Xxq5oLAY205MVDoicv1
        lc9wHZdcDCbuJGEUGYVkvhBSLyCrfqgLDbzhGQ==
X-Google-Smtp-Source: AGHT+IEOsv8AytmIY1ItchezUOVhfLQQRUHWfObjYh8N7g/KYP9s08yZwqx2bu9k2UF50/RA0SMHT3kZsNDjGKd9aw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:c103:0:b0:da0:3e20:658d with SMTP
 id r3-20020a25c103000000b00da03e20658dmr121575ybf.10.1698275234046; Wed, 25
 Oct 2023 16:07:14 -0700 (PDT)
Date:   Wed, 25 Oct 2023 23:07:12 +0000
In-Reply-To: <20230928210201.1310536-1-coltonlewis@google.com> (message from
 Colton Lewis on Thu, 28 Sep 2023 21:02:01 +0000)
Mime-Version: 1.0
Message-ID: <gsntzg06uwrj.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
From:   Colton Lewis <coltonlewis@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        ricarkol@google.com, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Is there something I can do to make this more worthwhile to review?

Zenghui? I know you started looking at the previous version before
finding a compile error. That's been fixed.

Colton Lewis <coltonlewis@google.com> writes:

> Add a new arch_timer_edge_cases selftests that validates:

> * timers above the max TVAL value
> * timers in the past
> * moving counters ahead and behind pending timers
> * reprograming timers
> * timers fired multiple times
> * masking/unmasking using the timer control mask

> These are intentionally unusual scenarios to stress compliance with
> the arm architecture.

> Co-developed-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---

> v2:
> * Rebase to v6.6-rc3
> * Use new GUEST_ASSERT macros
> * Remove spinlock in favor of atomic operations

> v1:  
> https://lore.kernel.org/kvm/20230516213731.387132-1-coltonlewis@google.com/

>   tools/testing/selftests/kvm/Makefile          |    1 +
>   .../kvm/aarch64/arch_timer_edge_cases.c       | 1105 +++++++++++++++++
>   .../kvm/include/aarch64/arch_timer.h          |   18 +-
>   3 files changed, 1123 insertions(+), 1 deletion(-)
>   create mode 100644  
> tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

> diff --git a/tools/testing/selftests/kvm/Makefile  
> b/tools/testing/selftests/kvm/Makefile
> index a3bb36fb3cfc..e940b7c6b818 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -141,6 +141,7 @@ TEST_GEN_PROGS_EXTENDED_x86_64 +=  
> x86_64/nx_huge_pages_test

>   TEST_GEN_PROGS_aarch64 += aarch64/aarch32_id_regs
>   TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
> +TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
>   TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>   TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
>   TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c  
> b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> new file mode 100644
> index 000000000000..a3761a361de9
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> @@ -0,0 +1,1105 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * arch_timer_edge_cases.c - Tests the aarch64 timer IRQ functionality.
> + *
> + * The test validates some edge cases related to the arch-timer:
> + * - timers above the max TVAL value.
> + * - timers in the past
> + * - moving counters ahead and behind pending timers.
> + * - reprograming timers.
> + * - timers fired multiple times.
> + * - masking/unmasking using the timer control mask.
> + *
> + * Copyright (c) 2021, Google LLC.
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include <stdlib.h>
> +#include <pthread.h>
> +#include <linux/kvm.h>
> +#include <linux/atomic.h>
> +#include <linux/bitmap.h>
> +#include <linux/sizes.h>
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
> +#define msecs_to_usecs(msec)		((msec) * 1000LL)
> +
> +#define CVAL_MAX			~0ULL
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
> +#define TEST_MARGIN_US			1000ULL
> +
> +/* A nice counter value to use as the starting one for most tests. */
> +#define DEF_CNT				(CVAL_MAX / 2)
> +
> +/* Number of runs. */
> +#define NR_TEST_ITERS_DEF		5
> +
> +/* Default wait test time in ms. */
> +#define WAIT_TEST_MS			10
> +
> +/* Default "long" wait test time in ms. */
> +#define LONG_WAIT_TEST_MS		100
> +
> +/* Shared with IRQ handler. */
> +struct test_vcpu_shared_data {
> +	atomic_t handled;
> +	atomic_t spurious;
> +} shared_data;
> +
> +struct test_args {
> +	/* Virtual or physical timer and counter tests. */
> +	enum arch_timer timer;
> +	/* Delay used for most timer tests. */
> +	uint64_t wait_ms;
> +	/* Delay used in the test_long_timer_delays test. */
> +	uint64_t long_wait_ms;
> +	/* Number of iterations. */
> +	int iterations;
> +	/* Whether to test the physical timer. */
> +	bool test_physical;
> +	/* Whether to test the virtual timer. */
> +	bool test_virtual;
> +};
> +
> +struct test_args test_args = {
> +	.wait_ms = WAIT_TEST_MS,
> +	.long_wait_ms = LONG_WAIT_TEST_MS,
> +	.iterations = NR_TEST_ITERS_DEF,
> +	.test_physical = true,
> +	.test_virtual = true,
> +};
> +
> +static int vtimer_irq, ptimer_irq;
> +
> +enum sync_cmd {
> +	SET_REG_KVM_REG_ARM_TIMER_CNT = 100001,
> +	USERSPACE_USLEEP,
> +	USERSPACE_SCHED_YIELD,
> +	USERSPACE_MIGRATE_SELF,
> +};
> +
> +typedef void (*sleep_method_t)(enum arch_timer timer, uint64_t usec);
> +
> +static void sleep_poll(enum arch_timer timer, uint64_t usec);
> +static void sleep_sched_poll(enum arch_timer timer, uint64_t usec);
> +static void sleep_in_userspace(enum arch_timer timer, uint64_t usec);
> +static void sleep_migrate(enum arch_timer timer, uint64_t usec);
> +
> +sleep_method_t sleep_method[] = {
> +	sleep_poll,
> +	sleep_sched_poll,
> +	sleep_migrate,
> +	sleep_in_userspace,
> +};
> +
> +typedef void (*wfi_method_t)(void);
> +
> +static void wait_for_non_spurious_irq(void);
> +static void wait_poll_for_irq(void);
> +static void wait_sched_poll_for_irq(void);
> +static void wait_migrate_poll_for_irq(void);
> +
> +wfi_method_t wfi_method[] = {
> +	wait_for_non_spurious_irq,
> +	wait_poll_for_irq,
> +	wait_sched_poll_for_irq,
> +	wait_migrate_poll_for_irq,
> +};
> +
> +#define for_each_wfi_method(i)							\
> +	for ((i) = 0; (i) < ARRAY_SIZE(wfi_method); (i)++)
> +
> +#define for_each_sleep_method(i)						\
> +	for ((i) = 0; (i) < ARRAY_SIZE(sleep_method); (i)++)
> +
> +enum timer_view {
> +	TIMER_CVAL = 1,
> +	TIMER_TVAL,
> +};
> +
> +#define ASSERT_IRQS_HANDLED(_nr, _args...) do {				\
> +		int _h = atomic_read(&shared_data.handled);		\
> +		__GUEST_ASSERT(_h == (_nr), "Handled %d IRQS but expected %d", _h,  
> _nr, ##_args); \
> +	} while (0)
> +
> +#define GUEST_SYNC_CLOCK(__cmd, __val)						\
> +	GUEST_SYNC_ARGS(__cmd, __val, 0, 0, 0)
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
> +#define SLEEP_IN_USERSPACE(__usecs)						\
> +	GUEST_SYNC_ARGS(USERSPACE_USLEEP, (__usecs), 0, 0, 0)
> +
> +#define IAR_SPURIOUS		1023
> +
> +static void set_counter(enum arch_timer timer, uint64_t counter)
> +{
> +	GUEST_SYNC_ARGS(SET_REG_KVM_REG_ARM_TIMER_CNT, counter, timer, 0, 0);
> +}
> +
> +static uint32_t next_pcpu(void)
> +{
> +	uint32_t max = get_nprocs();
> +	uint32_t cur = sched_getcpu();
> +	uint32_t next = cur;
> +	cpu_set_t cpuset;
> +
> +	TEST_ASSERT(max > 1, "Need at least two physical cpus");
> +
> +	sched_getaffinity(getpid(), sizeof(cpuset), &cpuset);
> +
> +	do {
> +		next = (next + 1) % CPU_SETSIZE;
> +	} while (!CPU_ISSET(next, &cpuset));
> +
> +	return next;
> +}
> +
> +static void guest_irq_handler(struct ex_regs *regs)
> +{
> +	unsigned int intid = gic_get_and_ack_irq();
> +	enum arch_timer timer;
> +	uint64_t cnt, cval;
> +	uint32_t ctl;
> +	bool timer_condition, istatus;
> +
> +	if (intid == IAR_SPURIOUS) {
> +		atomic_inc(&shared_data.spurious);
> +		goto out;
> +	}
> +
> +	if (intid == ptimer_irq)
> +		timer = PHYSICAL;
> +	else if (intid == vtimer_irq)
> +		timer = VIRTUAL;
> +	else
> +		goto out;
> +
> +	ctl = timer_get_ctl(timer);
> +	cval = timer_get_cval(timer);
> +	cnt = timer_get_cntct(timer);
> +	timer_condition = cnt >= cval;
> +	istatus = (ctl & CTL_ISTATUS) && (ctl & CTL_ENABLE);
> +	GUEST_ASSERT_EQ(timer_condition, istatus);
> +
> +	/* Disable and mask the timer. */
> +	timer_set_ctl(timer, CTL_IMASK);
> +
> +	atomic_inc(&shared_data.handled);
> +
> +out:
> +	gic_set_eoi(intid);
> +}
> +
> +static void set_cval_irq(enum arch_timer timer, uint64_t cval_cycles,
> +			 uint32_t ctl)
> +{
> +	atomic_set(&shared_data.handled, 0);
> +	atomic_set(&shared_data.spurious, 0);
> +	timer_set_cval(timer, cval_cycles);
> +	timer_set_ctl(timer, ctl);
> +}
> +
> +static void set_tval_irq(enum arch_timer timer, uint64_t tval_cycles,
> +			 uint32_t ctl)
> +{
> +	atomic_set(&shared_data.handled, 0);
> +	atomic_set(&shared_data.spurious, 0);
> +	timer_set_tval(timer, tval_cycles);
> +	timer_set_ctl(timer, ctl);
> +}
> +
> +static void set_xval_irq(enum arch_timer timer, uint64_t xval, uint32_t  
> ctl,
> +			 enum timer_view tv)
> +{
> +	switch (tv) {
> +	case TIMER_CVAL:
> +		set_cval_irq(timer, xval, ctl);
> +		break;
> +	case TIMER_TVAL:
> +		set_tval_irq(timer, xval, ctl);
> +		break;
> +	default:
> +		GUEST_FAIL("Could not get timer %d", timer);
> +	}
> +}
> +
> +/*
> + * Should be called with IRQs masked.
> + *
> + * Note that this can theoretically hang forever, so we rely on having
> + * a timeout mechanism in the "runner", like:
> + * tools/testing/selftests/kselftest/runner.sh.
> + */
> +static void wait_for_non_spurious_irq(void)
> +{
> +	int h;
> +
> +	for (h = atomic_read(&shared_data.handled); h ==  
> atomic_read(&shared_data.handled);) {
> +		asm volatile ("wfi\n"
> +			      "msr daifclr, #2\n"
> +			      /* handle IRQ */
> +			      "msr daifset, #2\n":::"memory");
> +	}
> +}
> +
> +/*
> + * Wait for an non-spurious IRQ by polling in the guest (userspace=0) or  
> in
> + * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHED_YIELD).
> + *
> + * Should be called with IRQs masked. Not really needed like the wfi  
> above, but
> + * it should match the others.
> + *
> + * Note that this can theoretically hang forever, so we rely on having
> + * a timeout mechanism in the "runner", like:
> + * tools/testing/selftests/kselftest/runner.sh.
> + */
> +static void poll_for_non_spurious_irq(bool userspace, enum sync_cmd  
> userspace_cmd)
> +{
> +	int h;
> +
> +	h = atomic_read(&shared_data.handled);
> +
> +	local_irq_enable();
> +	while (h == atomic_read(&shared_data.handled)) {
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
> + * Sleep for usec microseconds by polling in the guest (userspace=0) or  
> in
> + * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHEDULE).
> + */
> +static void guest_poll(enum arch_timer test_timer, uint64_t usec,
> +		       bool userspace, enum sync_cmd userspace_cmd)
> +{
> +	uint64_t cycles = usec_to_cycles(usec);
> +	/* Whichever timer we are testing with, sleep with the other. */
> +	enum arch_timer sleep_timer = 1 - test_timer;
> +	uint64_t start = timer_get_cntct(sleep_timer);
> +
> +	while ((timer_get_cntct(sleep_timer) - start) < cycles) {
> +		if (userspace)
> +			USERSPACE_CMD(userspace_cmd);
> +		else
> +			cpu_relax();
> +	}
> +}
> +
> +static void sleep_poll(enum arch_timer timer, uint64_t usec)
> +{
> +	guest_poll(timer, usec, false, -1);
> +}
> +
> +static void sleep_sched_poll(enum arch_timer timer, uint64_t usec)
> +{
> +	guest_poll(timer, usec, true, USERSPACE_SCHED_YIELD);
> +}
> +
> +static void sleep_migrate(enum arch_timer timer, uint64_t usec)
> +{
> +	guest_poll(timer, usec, true, USERSPACE_MIGRATE_SELF);
> +}
> +
> +static void sleep_in_userspace(enum arch_timer timer, uint64_t usec)
> +{
> +	SLEEP_IN_USERSPACE(usec);
> +}
> +
> +/*
> + * Reset the timer state to some nice values like the counter not being  
> close
> + * to the edge, and the control register masked and disabled.
> + */
> +static void reset_timer_state(enum arch_timer timer, uint64_t cnt)
> +{
> +	set_counter(timer, cnt);
> +	timer_set_ctl(timer, CTL_IMASK);
> +}
> +
> +static void test_timer_xval(enum arch_timer timer, uint64_t xval,
> +			    enum timer_view tv, wfi_method_t wm, bool reset_state,
> +			    uint64_t reset_cnt)
> +{
> +	local_irq_disable();
> +
> +	if (reset_state)
> +		reset_timer_state(timer, reset_cnt);
> +
> +	set_xval_irq(timer, xval, CTL_ENABLE, tv);
> +	wm();
> +
> +	ASSERT_IRQS_HANDLED(1, tv, wm);
> +	local_irq_enable();
> +}
> +
> +/*
> + * The test_timer_* functions will program the timer, wait for it, and  
> assert
> + * the firing of the correct IRQ.
> + *
> + * These functions don't have a timeout and return as soon as they  
> receive an
> + * IRQ. They can hang (forever), so we rely on having a timeout  
> mechanism in
> + * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
> + */
> +
> +static void test_timer_cval(enum arch_timer timer, uint64_t cval,
> +			    wfi_method_t wm, bool reset_state,
> +			    uint64_t reset_cnt)
> +{
> +	test_timer_xval(timer, cval, TIMER_CVAL, wm, reset_state, reset_cnt);
> +}
> +
> +static void test_timer_tval(enum arch_timer timer, int32_t tval,
> +			    wfi_method_t wm, bool reset_state,
> +			    uint64_t reset_cnt)
> +{
> +	test_timer_xval(timer, (uint64_t) tval, TIMER_TVAL, wm, reset_state,
> +			reset_cnt);
> +}
> +
> +static void test_xval_check_no_irq(enum arch_timer timer, uint64_t xval,
> +				   uint64_t usec, enum timer_view timer_view,
> +				   sleep_method_t guest_sleep)
> +{
> +	local_irq_disable();
> +
> +	set_xval_irq(timer, xval, CTL_ENABLE | CTL_IMASK, timer_view);
> +	guest_sleep(timer, usec);
> +
> +	local_irq_enable();
> +	isb();
> +
> +	/* Assume success (no IRQ) after waiting usec microseconds */
> +	ASSERT_IRQS_HANDLED(0);
> +}
> +
> +static void test_cval_no_irq(enum arch_timer timer, uint64_t cval,
> +			     uint64_t usec, sleep_method_t wm)
> +{
> +	test_xval_check_no_irq(timer, cval, usec, TIMER_CVAL, wm);
> +}
> +
> +static void test_tval_no_irq(enum arch_timer timer, int32_t tval,  
> uint64_t usec,
> +			     sleep_method_t wm)
> +{
> +	/* tval will be cast to an int32_t in test_xval_check_no_irq */
> +	test_xval_check_no_irq(timer, (uint64_t) tval, usec, TIMER_TVAL, wm);
> +}
> +
> +/* Test masking/unmasking a timer using the timer mask (not the IRQ  
> mask). */
> +static void test_timer_control_mask_then_unmask(enum arch_timer timer)
> +{
> +	reset_timer_state(timer, DEF_CNT);
> +	set_tval_irq(timer, -1, CTL_ENABLE | CTL_IMASK);
> +
> +	/* No IRQs because the timer is still masked. */
> +	ASSERT_IRQS_HANDLED(0);
> +
> +	/* Unmask the timer, and then get an IRQ. */
> +	local_irq_disable();
> +	timer_set_ctl(timer, CTL_ENABLE);
> +	wait_for_non_spurious_irq();
> +
> +	ASSERT_IRQS_HANDLED(1);
> +	local_irq_enable();
> +}
> +
> +/* Check that timer control masks actually mask a timer being fired. */
> +static void test_timer_control_masks(enum arch_timer timer)
> +{
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	/* Local IRQs are not masked at this point. */
> +
> +	set_tval_irq(timer, -1, CTL_ENABLE | CTL_IMASK);
> +
> +	/* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
> +	sleep_poll(timer, TIMEOUT_NO_IRQ_US);
> +
> +	ASSERT_IRQS_HANDLED(0);
> +	timer_set_ctl(timer, CTL_IMASK);
> +}
> +
> +static void test_fire_a_timer_multiple_times(enum arch_timer timer,
> +					     wfi_method_t wm, int num)
> +{
> +	int i;
> +
> +	local_irq_disable();
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	set_tval_irq(timer, 0, CTL_ENABLE);
> +
> +	for (i = 1; i <= num; i++) {
> +		wm();
> +
> +		/* The IRQ handler masked and disabled the timer.
> +		 * Enable and unmmask it again.
> +		 */
> +		timer_set_ctl(timer, CTL_ENABLE);
> +
> +		ASSERT_IRQS_HANDLED(i);
> +	}
> +
> +	local_irq_enable();
> +}
> +
> +static void test_timers_fired_multiple_times(enum arch_timer timer)
> +{
> +	int i;
> +
> +	for_each_wfi_method(i)
> +		test_fire_a_timer_multiple_times(timer, wfi_method[i], 10);
> +}
> +
> +/*
> + * Set a timer for tval=d_1_ms then reprogram it to tval=d_2_ms. Check  
> that we
> + * get the timer fired. There is no timeout for the wait: we use the wfi
> + * instruction.
> + */
> +static void test_reprogramming_timer(enum arch_timer timer, wfi_method_t  
> wm,
> +				     int32_t d_1_ms, int32_t d_2_ms)
> +{
> +	local_irq_disable();
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	/* Program the timer to DEF_CNT + d_1_ms. */
> +	set_tval_irq(timer, msec_to_cycles(d_1_ms), CTL_ENABLE);
> +
> +	/* Reprogram the timer to DEF_CNT + d_2_ms. */
> +	timer_set_tval(timer, msec_to_cycles(d_2_ms));
> +
> +	wm();
> +
> +	/* The IRQ should arrive at DEF_CNT + d_2_ms (or after). */
> +	GUEST_ASSERT(timer_get_cntct(timer) >=
> +		     DEF_CNT + msec_to_cycles(d_2_ms));
> +
> +	local_irq_enable();
> +	ASSERT_IRQS_HANDLED(1, wm);
> +};
> +
> +/*
> + * Set a timer for tval=d_1_ms then reprogram it to tval=d_2_ms. Check
> + * that we get the timer fired in d_2_ms.
> + */
> +static void test_reprogramming_timer_with_timeout(enum arch_timer timer,
> +						  sleep_method_t guest_sleep,
> +						  int32_t d_1_ms,
> +						  int32_t d_2_ms)
> +{
> +	local_irq_disable();
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	set_tval_irq(timer, msec_to_cycles(d_1_ms), CTL_ENABLE);
> +
> +	/* Reprogram the timer. */
> +	timer_set_tval(timer, msec_to_cycles(d_2_ms));
> +
> +	guest_sleep(timer, msecs_to_usecs(d_2_ms) + TEST_MARGIN_US);
> +
> +	local_irq_enable();
> +	isb();
> +	ASSERT_IRQS_HANDLED(1);
> +};
> +
> +static void test_reprogram_timers(enum arch_timer timer)
> +{
> +	int i;
> +	uint64_t base_wait = test_args.wait_ms;
> +
> +	for_each_wfi_method(i) {
> +		test_reprogramming_timer(timer, wfi_method[i], 2 * base_wait,
> +					 base_wait);
> +		test_reprogramming_timer(timer, wfi_method[i], base_wait,
> +					 2 * base_wait);
> +	}
> +
> +	for_each_sleep_method(i) {
> +		test_reprogramming_timer_with_timeout(timer, sleep_method[i],
> +						      2 * base_wait, base_wait);
> +		test_reprogramming_timer_with_timeout(timer, sleep_method[i],
> +						      base_wait, 2 * base_wait);
> +	}
> +}
> +
> +static void test_basic_functionality(enum arch_timer timer)
> +{
> +	int32_t tval = (int32_t) msec_to_cycles(test_args.wait_ms);
> +	uint64_t cval;
> +	int i;
> +
> +	for_each_wfi_method(i) {
> +		wfi_method_t wm = wfi_method[i];
> +
> +		cval = DEF_CNT + msec_to_cycles(test_args.wait_ms);
> +
> +		test_timer_cval(timer, cval, wm, true, DEF_CNT);
> +		test_timer_tval(timer, tval, wm, true, DEF_CNT);
> +	}
> +}
> +
> +/*
> + * This test checks basic timer behavior without actually firing timers,  
> things
> + * like: the relationship between cval and tval, tval down-counting.
> + */
> +static void timers_sanity_checks(enum arch_timer timer, bool use_sched)
> +{
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	local_irq_disable();
> +
> +	/* cval in the past */
> +	timer_set_cval(timer,
> +		       timer_get_cntct(timer) -
> +		       msec_to_cycles(test_args.wait_ms));
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_tval(timer) < 0);
> +
> +	/* tval in the past */
> +	timer_set_tval(timer, -1);
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_cval(timer) < timer_get_cntct(timer));
> +
> +	/* tval larger than TVAL_MAX. */
> +	timer_set_cval(timer,
> +		       timer_get_cntct(timer) + TVAL_MAX +
> +		       msec_to_cycles(test_args.wait_ms));
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_tval(timer) <= 0);
> +
> +	/*
> +	 * tval larger than 2 * TVAL_MAX.
> +	 * Twice the TVAL_MAX completely loops around the TVAL.
> +	 */
> +	timer_set_cval(timer,
> +		       timer_get_cntct(timer) + 2ULL * TVAL_MAX +
> +		       msec_to_cycles(test_args.wait_ms));
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_tval(timer) <=
> +		       msec_to_cycles(test_args.wait_ms));
> +
> +	/* negative tval that rollovers from 0. */
> +	set_counter(timer, msec_to_cycles(1));
> +	timer_set_tval(timer, -1 * msec_to_cycles(test_args.wait_ms));
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_cval(timer) >= (CVAL_MAX - msec_to_cycles(9)));
> +
> +	/* tval should keep down-counting from 0 to -1. */
> +	timer_set_tval(timer, 0);
> +	sleep_poll(timer, 1);
> +	GUEST_ASSERT(timer_get_tval(timer) < 0);
> +
> +	local_irq_enable();
> +
> +	/* Mask and disable any pending timer. */
> +	timer_set_ctl(timer, CTL_IMASK);
> +}
> +
> +static void test_timers_sanity_checks(enum arch_timer timer)
> +{
> +	timers_sanity_checks(timer, false);
> +	/* Check how KVM saves/restores these edge-case values. */
> +	timers_sanity_checks(timer, true);
> +}
> +
> +static void test_set_cnt_after_tval_max(enum arch_timer timer,  
> wfi_method_t wm)
> +{
> +	local_irq_disable();
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	set_cval_irq(timer,
> +		     (uint64_t) TVAL_MAX +
> +		     msec_to_cycles(test_args.wait_ms) / 2, CTL_ENABLE);
> +
> +	set_counter(timer, TVAL_MAX);
> +	wm();
> +
> +	ASSERT_IRQS_HANDLED(1, wm);
> +	local_irq_enable();
> +}
> +
> +/* Test timers set for: cval = now + TVAL_MAX + wait_ms / 2*/
> +static void test_timers_above_tval_max(enum arch_timer timer)
> +{
> +	uint64_t cval;
> +	int i;
> +
> +	/*
> +	 * Test that the system is not implementing cval in terms of
> +	 * tval.  If that was the case, setting a cval to "cval = now
> +	 * + TVAL_MAX + wait_ms" would wrap to "cval = now +
> +	 * wait_ms / 2", and the timer would fire immediately. Test that it
> +	 * doesn't.
> +	 */
> +	for_each_sleep_method(i) {
> +		reset_timer_state(timer, DEF_CNT);
> +		cval =
> +		    timer_get_cntct(timer) + TVAL_MAX +
> +		    msec_to_cycles(test_args.wait_ms) / 2;
> +		test_cval_no_irq(timer, cval,
> +				 msecs_to_usecs(test_args.wait_ms) / 2 +
> +				 TEST_MARGIN_US, sleep_method[i]);
> +	}
> +
> +	for_each_wfi_method(i) {
> +		/* Get the IRQ by moving the counter forward. */
> +		test_set_cnt_after_tval_max(timer, wfi_method[i]);
> +	}
> +}
> +
> +/*
> + * Template function to be used by the test_move_counter_ahead_* tests.   
> It
> + * sets the counter to cnt_1, the [c|t]val, the counter to cnt_2, and
> + * then waits for an IRQ.
> + */
> +static void test_set_cnt_after_xval(enum arch_timer timer, uint64_t  
> cnt_1,
> +				    uint64_t xval, uint64_t cnt_2,
> +				    wfi_method_t wm, enum timer_view tv)
> +{
> +	local_irq_disable();
> +
> +	set_counter(timer, cnt_1);
> +	timer_set_ctl(timer, CTL_IMASK);
> +
> +	set_xval_irq(timer, xval, CTL_ENABLE, tv);
> +	set_counter(timer, cnt_2);
> +	wm();
> +
> +	ASSERT_IRQS_HANDLED(1);
> +	local_irq_enable();
> +}
> +
> +/*
> + * Template function to be used by the test_move_counter_ahead_* tests.   
> It
> + * sets the counter to cnt_1, the [c|t]val, the counter to cnt_2, and
> + * then waits for an IRQ.
> + */
> +static void test_set_cnt_after_xval_no_irq(enum arch_timer timer,
> +					   uint64_t cnt_1, uint64_t xval,
> +					   uint64_t cnt_2,
> +					   sleep_method_t guest_sleep,
> +					   enum timer_view tv)
> +{
> +	local_irq_disable();
> +
> +	set_counter(timer, cnt_1);
> +	timer_set_ctl(timer, CTL_IMASK);
> +
> +	set_xval_irq(timer, xval, CTL_ENABLE, tv);
> +	set_counter(timer, cnt_2);
> +	guest_sleep(timer, TIMEOUT_NO_IRQ_US);
> +
> +	local_irq_enable();
> +	isb();
> +
> +	/* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
> +	ASSERT_IRQS_HANDLED(0);
> +	timer_set_ctl(timer, CTL_IMASK);
> +}
> +
> +static void test_set_cnt_after_tval(enum arch_timer timer, uint64_t  
> cnt_1,
> +				    int32_t tval, uint64_t cnt_2,
> +				    wfi_method_t wm)
> +{
> +	test_set_cnt_after_xval(timer, cnt_1, tval, cnt_2, wm, TIMER_TVAL);
> +}
> +
> +static void test_set_cnt_after_cval(enum arch_timer timer, uint64_t  
> cnt_1,
> +				    uint64_t cval, uint64_t cnt_2,
> +				    wfi_method_t wm)
> +{
> +	test_set_cnt_after_xval(timer, cnt_1, cval, cnt_2, wm, TIMER_CVAL);
> +}
> +
> +static void test_set_cnt_after_tval_no_irq(enum arch_timer timer,
> +					   uint64_t cnt_1, int32_t tval,
> +					   uint64_t cnt_2, sleep_method_t wm)
> +{
> +	test_set_cnt_after_xval_no_irq(timer, cnt_1, tval, cnt_2, wm,
> +				       TIMER_TVAL);
> +}
> +
> +static void test_set_cnt_after_cval_no_irq(enum arch_timer timer,
> +					   uint64_t cnt_1, uint64_t cval,
> +					   uint64_t cnt_2, sleep_method_t wm)
> +{
> +	test_set_cnt_after_xval_no_irq(timer, cnt_1, cval, cnt_2, wm,
> +				       TIMER_CVAL);
> +}
> +
> +/* Set a timer and then move the counter ahead of it. */
> +static void test_move_counters_ahead_of_timers(enum arch_timer timer)
> +{
> +	int i;
> +	int32_t tval;
> +
> +	for_each_wfi_method(i) {
> +		wfi_method_t wm = wfi_method[i];
> +
> +		test_set_cnt_after_cval(timer, 0, DEF_CNT, DEF_CNT + 1, wm);
> +		test_set_cnt_after_cval(timer, CVAL_MAX, 1, 2, wm);
> +
> +		/* Move counter ahead of negative tval. */
> +		test_set_cnt_after_tval(timer, 0, -1, DEF_CNT + 1, wm);
> +		test_set_cnt_after_tval(timer, 0, -1, TVAL_MAX, wm);
> +		tval = TVAL_MAX;
> +		test_set_cnt_after_tval(timer, 0, tval, (uint64_t) tval + 1,
> +					wm);
> +	}
> +
> +	for_each_sleep_method(i) {
> +		sleep_method_t sm = sleep_method[i];
> +
> +		test_set_cnt_after_cval_no_irq(timer, 0, DEF_CNT, CVAL_MAX, sm);
> +	}
> +}
> +
> +/*
> + * Program a timer, mask it, and then change the tval or counter to  
> cancel it.
> + * Unmask it and check that nothing fires.
> + */
> +static void test_move_counters_behind_timers(enum arch_timer timer)
> +{
> +	int i;
> +
> +	for_each_sleep_method(i) {
> +		sleep_method_t sm = sleep_method[i];
> +
> +		test_set_cnt_after_cval_no_irq(timer, DEF_CNT, DEF_CNT - 1, 0,
> +					       sm);
> +		test_set_cnt_after_tval_no_irq(timer, DEF_CNT, -1, 0, sm);
> +	}
> +}
> +
> +static void test_timers_in_the_past(enum arch_timer timer)
> +{
> +	int32_t tval = -1 * (int32_t) msec_to_cycles(test_args.wait_ms);
> +	uint64_t cval;
> +	int i;
> +
> +	for_each_wfi_method(i) {
> +		wfi_method_t wm = wfi_method[i];
> +
> +		/* set a timer wait_ms the past. */
> +		cval = DEF_CNT - msec_to_cycles(test_args.wait_ms);
> +		test_timer_cval(timer, cval, wm, true, DEF_CNT);
> +		test_timer_tval(timer, tval, wm, true, DEF_CNT);
> +
> +		/* Set a timer to counter=0 (in the past) */
> +		test_timer_cval(timer, 0, wm, true, DEF_CNT);
> +
> +		/* Set a time for tval=0 (now) */
> +		test_timer_tval(timer, 0, wm, true, DEF_CNT);
> +
> +		/* Set a timer to as far in the past as possible */
> +		test_timer_tval(timer, TVAL_MIN, wm, true, DEF_CNT);
> +	}
> +
> +	/*
> +	 * Set the counter to wait_ms, and a tval to -wait_ms. There should be  
> no
> +	 * timer as that tval means cval=CVAL_MAX-wait_ms.
> +	 */
> +	for_each_sleep_method(i) {
> +		sleep_method_t sm = sleep_method[i];
> +
> +		set_counter(timer, msec_to_cycles(test_args.wait_ms));
> +		test_tval_no_irq(timer, tval, TIMEOUT_NO_IRQ_US, sm);
> +	}
> +}
> +
> +static void test_long_timer_delays(enum arch_timer timer)
> +{
> +	int32_t tval = (int32_t) msec_to_cycles(test_args.long_wait_ms);
> +	uint64_t cval;
> +	int i;
> +
> +	for_each_wfi_method(i) {
> +		wfi_method_t wm = wfi_method[i];
> +
> +		cval = DEF_CNT + msec_to_cycles(test_args.long_wait_ms);
> +		test_timer_cval(timer, cval, wm, true, DEF_CNT);
> +		test_timer_tval(timer, tval, wm, true, DEF_CNT);
> +	}
> +}
> +
> +static void guest_run_iteration(enum arch_timer timer)
> +{
> +	test_basic_functionality(timer);
> +	test_timers_sanity_checks(timer);
> +
> +	test_timers_above_tval_max(timer);
> +	test_timers_in_the_past(timer);
> +
> +	test_move_counters_ahead_of_timers(timer);
> +	test_move_counters_behind_timers(timer);
> +	test_reprogram_timers(timer);
> +
> +	test_timers_fired_multiple_times(timer);
> +
> +	test_timer_control_mask_then_unmask(timer);
> +	test_timer_control_masks(timer);
> +}
> +
> +static void guest_code(enum arch_timer timer)
> +{
> +	int i;
> +
> +	local_irq_disable();
> +
> +	gic_init(GIC_V3, 1, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
> +
> +	timer_set_ctl(VIRTUAL, CTL_IMASK);
> +	timer_set_ctl(PHYSICAL, CTL_IMASK);
> +
> +	gic_irq_enable(vtimer_irq);
> +	gic_irq_enable(ptimer_irq);
> +	local_irq_enable();
> +
> +	for (i = 0; i < test_args.iterations; i++) {
> +		GUEST_SYNC(i);
> +		guest_run_iteration(timer);
> +	}
> +
> +	test_long_timer_delays(timer);
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
> +		    new_pcpu, ret);
> +}
> +
> +static void kvm_set_cntxct(struct kvm_vcpu *vcpu, uint64_t cnt,
> +			   enum arch_timer timer)
> +{
> +	if (timer == PHYSICAL)
> +		vcpu_set_reg(vcpu, KVM_REG_ARM_PTIMER_CNT, cnt);
> +	else
> +		vcpu_set_reg(vcpu, KVM_REG_ARM_TIMER_CNT, cnt);
> +}
> +
> +static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
> +{
> +	enum sync_cmd cmd = uc->args[1];
> +	uint64_t val = uc->args[2];
> +	enum arch_timer timer = uc->args[3];
> +
> +	switch (cmd) {
> +	case SET_REG_KVM_REG_ARM_TIMER_CNT:
> +		kvm_set_cntxct(vcpu, val, timer);
> +		break;
> +	case USERSPACE_USLEEP:
> +		usleep(val);
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
> +static void test_run(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +
> +	while (true) {
> +		vcpu_run(vcpu);
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			handle_sync(vcpu, &uc);
> +			break;
> +		case UCALL_DONE:
> +			goto out;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			goto out;
> +		default:
> +			TEST_FAIL("Unexpected guest exit\n");
> +		}
> +	}
> +
> + out:
> +	return;
> +}
> +
> +static void test_init_timer_irq(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +{
> +	vcpu_device_attr_get(vcpu, KVM_ARM_VCPU_TIMER_CTRL,
> +			     KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq);
> +	vcpu_device_attr_get(vcpu, KVM_ARM_VCPU_TIMER_CTRL,
> +			     KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq);
> +
> +	sync_global_to_guest(vm, ptimer_irq);
> +	sync_global_to_guest(vm, vtimer_irq);
> +
> +	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
> +}
> +
> +static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
> +			   enum arch_timer timer)
> +{
> +	*vm = vm_create_with_one_vcpu(vcpu, guest_code);
> +	TEST_ASSERT(*vm, "Failed to create the test VM\n");
> +
> +	vm_init_descriptor_tables(*vm);
> +	vm_install_exception_handler(*vm, VECTOR_IRQ_CURRENT,
> +				     guest_irq_handler);
> +
> +	vcpu_init_descriptor_tables(*vcpu);
> +	vcpu_args_set(*vcpu, 1, timer);
> +
> +	test_init_timer_irq(*vm, *vcpu);
> +	vgic_v3_setup(*vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +	sync_global_to_guest(*vm, test_args);
> +}
> +
> +static void test_print_help(char *name)
> +{
> +	pr_info("Usage: %s [-h] [-b] [-i iterations] [-l long_wait_ms] [-p]  
> [-v]\n"
> +		, name);
> +	pr_info("\t-i: Number of iterations (default: %u)\n",
> +		NR_TEST_ITERS_DEF);
> +	pr_info("\t-b: Test both physical and virtual timers (default:  
> true)\n");
> +	pr_info("\t-l: Delta (in ms) used for long wait time test  
> (default: %u)\n",
> +	     LONG_WAIT_TEST_MS);
> +	pr_info("\t-l: Delta (in ms) used for wait times (default: %u)\n",
> +		WAIT_TEST_MS);
> +	pr_info("\t-p: Test physical timer (default: true)\n");
> +	pr_info("\t-v: Test virtual timer (default: true)\n");
> +	pr_info("\t-h: Print this help message\n");
> +}
> +
> +static bool parse_args(int argc, char *argv[])
> +{
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "bhi:l:pvw:")) != -1) {
> +		switch (opt) {
> +		case 'b':
> +			test_args.test_physical = true;
> +			test_args.test_virtual = true;
> +			break;
> +		case 'i':
> +			test_args.iterations =
> +			    atoi_positive("Number of iterations", optarg);
> +			break;
> +		case 'l':
> +			test_args.long_wait_ms =
> +			    atoi_positive("Long wait time", optarg);
> +			break;
> +		case 'p':
> +			test_args.test_physical = true;
> +			test_args.test_virtual = false;
> +			break;
> +		case 'v':
> +			test_args.test_virtual = true;
> +			test_args.test_physical = false;
> +			break;
> +		case 'w':
> +			test_args.wait_ms = atoi_positive("Wait time", optarg);
> +			break;
> +		case 'h':
> +		default:
> +			goto err;
> +		}
> +	}
> +
> +	return true;
> +
> + err:
> +	test_print_help(argv[0]);
> +	return false;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	/* Tell stdout not to buffer its content */
> +	setbuf(stdout, NULL);
> +
> +	if (!parse_args(argc, argv))
> +		exit(KSFT_SKIP);
> +
> +	if (test_args.test_virtual) {
> +		test_vm_create(&vm, &vcpu, VIRTUAL);
> +		test_run(vm, vcpu);
> +		kvm_vm_free(vm);
> +	}
> +
> +	if (test_args.test_physical) {
> +		test_vm_create(&vm, &vcpu, PHYSICAL);
> +		test_run(vm, vcpu);
> +		kvm_vm_free(vm);
> +	}
> +
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h  
> b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> index b3e97525cb55..bf461de34785 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> @@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer  
> timer)
>   	return 0;
>   }

> -static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
> +static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
>   {
>   	switch (timer) {
>   	case VIRTUAL:
> @@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer  
> timer, uint32_t tval)
>   	isb();
>   }

> +static inline int32_t timer_get_tval(enum arch_timer timer)
> +{
> +	isb();
> +	switch (timer) {
> +	case VIRTUAL:
> +		return read_sysreg(cntv_tval_el0);
> +	case PHYSICAL:
> +		return read_sysreg(cntp_tval_el0);
> +	default:
> +		GUEST_FAIL("Could not get timer %d\n", timer);
> +	}
> +
> +	/* We should not reach here */
> +	return 0;
> +}
> +
>   static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
>   {
>   	switch (timer) {
> --
> 2.42.0.582.g8ccd20d70d-goog
