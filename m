Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8C94DC024
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 08:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiCQH3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 03:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiCQH3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 03:29:36 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5F6105057
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 00:28:04 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id b16so4980510ioz.3
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 00:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W2IkFd50h0tsFb7Hn8Oo7TOEqHvvQThfS9L+wttPU0c=;
        b=KgTxt4jiE0tKfHlqODSBDSXy53Fg4jEaZb1FmrlYav3VBMge1/pGx/t9c4o7gUxJRH
         WXXymP4iiTPWukDHgI4A6aNAf0uZRKQqcUyy6Jx9JYNcu0am8JjIRmy/ed0eqhEC0u56
         jmNFovoVbhxilkIy2AHRHEZ/QVJnwddLeEtr9S7Pnp6V6JD8OG12uooOuBUPhfsqUSiB
         gGc27rMFJnT0SFk7xEMUnulbIbNgzVX6Td7mAhEDifg2NdT1l8DzS6Aq7kyXKEvOULqt
         vUAR1gn7cwEG3DrQ7IDBLRUxVJR4nmxwUZblQtSNhJlPTiEIZGO21y4yZ9Gyy4SNoW0L
         Ik6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W2IkFd50h0tsFb7Hn8Oo7TOEqHvvQThfS9L+wttPU0c=;
        b=L4ptOlHW3VQ5sKxfkTm6PhO0Dr4rHH07HEoVb0Mdk9+RT0V1ioWdiyd5AkTKc2Q9/H
         WLNEjfV21ojm9K/YpprYYdnaiAchpo/8+wxymQflBYwP48S4j7uTBd+zbgPGJF6UAXWs
         z6DdyY3fiC7eNzQgMBmaTrQSLv0ioRNcbhkRogbEFYLLFPeoH6eZpt0xu9r7TgoEJ1Wi
         4frxsFdHHKm2PnyE6mK3rGkM3xTu8KdHqqT6DRGYz5bnXE5pOQui4Vlua2TcSkb1vh2q
         bkk2v80RlEVyVqUZRmhESKv0D80sdoMI4H4LW9IMzrDAMIxPf6UsX5buhRgZAbKaRl/V
         58hQ==
X-Gm-Message-State: AOAM532Ovf/ie49JuMoqrh8cfqN55UMLNKE3MejqkqYPVRK5HitEad47
        Lp8+e0jEDLiqCnnxdZUyEmC+N83dP5PYmA==
X-Google-Smtp-Source: ABdhPJxpp9p1Xp4vEwVWlQIMO2YIy+YwfrpjB/LdJ76qT2Rq7kgtq5JtrwdHZPWZ2Dr1Edy4xeXN6g==
X-Received: by 2002:a05:6638:2589:b0:31a:4a70:b070 with SMTP id s9-20020a056638258900b0031a4a70b070mr1340854jat.208.1647502082999;
        Thu, 17 Mar 2022 00:28:02 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id d1-20020a056e021c4100b002c7c7903febsm2403503ilg.86.2022.03.17.00.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 00:28:00 -0700 (PDT)
Date:   Thu, 17 Mar 2022 07:27:50 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com
Subject: Re: [PATCH v2 3/3] KVM: arm64: selftests: add edge cases tests into
 arch_timer_edge_cases
Message-ID: <YjLi9t5yRTNdyhFA@google.com>
References: <20220317045127.124602-1-ricarkol@google.com>
 <20220317045127.124602-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317045127.124602-4-ricarkol@google.com>
X-Spam-Status: No, score=-15.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLACK,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Wed, Mar 16, 2022 at 09:51:27PM -0700, Ricardo Koller wrote:
> Add tests that validates some edge cases related to the virtual
> arch-timer:
> - timers in the past, including TVALs that rollover from 0.
> - timers across counter roll-overs.
> - moving counters ahead and behind pending timers.
> - reprograming timers.
> - the same timer condition firing multiple times.
> - masking/unmasking using the timer control mask.
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../kvm/aarch64/arch_timer_edge_cases.c       | 329 +++++++++++++++++-
>  1 file changed, 326 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> index dc399482e35d..0eeb72767bea 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> @@ -2,6 +2,12 @@
>  /*
>   * arch_timer_edge_cases.c - Tests the aarch64 timer IRQ functionality.
>   *
> + * The test validates some edge cases related to the virtual arch-timer:
> + * - timers across counter roll-overs.
> + * - moving counters ahead and behind pending timers.
> + * - reprograming timers.
> + * - the same timer condition firing multiple times.
> + *
>   * Some of these tests program timers and then wait indefinitely for them to
>   * fire.  We rely on having a timeout mechanism in the "runner", like
>   * tools/testing/selftests/kselftest/runner.sh.
> @@ -47,6 +53,9 @@
>  /* Number of runs. */
>  #define NR_TEST_ITERS_DEF		5
>  
> +/* Default "long" wait test time in ms. */
> +#define LONG_WAIT_TEST_MS		100
> +
>  /* Shared with IRQ handler. */
>  volatile struct test_vcpu_shared_data {
>  	int handled;
> @@ -55,6 +64,8 @@ volatile struct test_vcpu_shared_data {
>  struct test_args {
>  	/* Virtual or physical timer and counter tests. */
>  	enum arch_timer timer;
> +	/* Delay used in the test_long_timer_delays test. */
> +	uint64_t long_wait_ms;
>  	/* Number of iterations. */
>  	int iterations;
>  };
> @@ -62,6 +73,7 @@ struct test_args {
>  struct test_args test_args = {
>  	/* Only testing VIRTUAL timers for now. */
>  	.timer = VIRTUAL,
> +	.long_wait_ms = LONG_WAIT_TEST_MS,
>  	.iterations = NR_TEST_ITERS_DEF,
>  };
>  
> @@ -69,10 +81,25 @@ static int vtimer_irq, ptimer_irq;
>  
>  enum sync_cmd {
>  	SET_REG_KVM_REG_ARM_TIMER_CNT,
> +	USERSPACE_USLEEP,
>  	USERSPACE_SCHED_YIELD,
>  	USERSPACE_MIGRATE_SELF,
>  };
>  
> +typedef void (*sleep_method_t)(uint64_t usec);
> +
> +static void sleep_poll(uint64_t usec);
> +static void sleep_sched_poll(uint64_t usec);
> +static void sleep_in_userspace(uint64_t usec);
> +static void sleep_migrate(uint64_t usec);
> +
> +sleep_method_t sleep_method[] = {
> +	sleep_poll,
> +	sleep_sched_poll,
> +	sleep_migrate,
> +	sleep_in_userspace,
> +};
> +
>  typedef void (*wait_method_t)(void);
>  
>  static void wait_for_non_spurious_irq(void);
> @@ -125,6 +152,9 @@ static uint32_t next_pcpu(void)
>  #define USERSPACE_MIGRATE_VCPU()						\
>  	USERSPACE_CMD(USERSPACE_MIGRATE_SELF)
>  
> +#define SLEEP_IN_USERSPACE(__usecs)						\
> +	GUEST_SYNC_ARGS(USERSPACE_USLEEP, (__usecs), 0, 0, 0)
> +
>  static void guest_irq_handler(struct ex_regs *regs)
>  {
>  	unsigned int intid = gic_get_and_ack_irq();
> @@ -227,6 +257,60 @@ static void wait_migrate_poll_for_irq(void)
>  	poll_for_non_spurious_irq(true, USERSPACE_MIGRATE_SELF);
>  }
>  
> +/*
> + * Sleep for usec microseconds by polling in the guest (userspace=0) or in
> + * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHEDULE).
> + */
> +static void guest_poll(enum arch_timer timer, uint64_t usec,
> +		bool userspace, enum sync_cmd userspace_cmd)
> +{
> +	uint64_t cycles = usec_to_cycles(usec);
> +	uint64_t start = timer_get_cntct(timer);
> +
> +	/*
> +	 * TODO: Take care of roll-overs. Right now, we are fine as we use the
> +	 * virtual timer/counter for all of our roll-over tests, and so we can use
> +	 * the physical counter for this function. Assert this (temporarily):
> +	 */
> +	GUEST_ASSERT(test_args.timer == VIRTUAL && timer == PHYSICAL);
> +
> +	while ((timer_get_cntct(timer) - start) < cycles) {
> +		if (userspace)
> +			USERSPACE_CMD(userspace_cmd);
> +		else
> +			cpu_relax();
> +	}
> +}
> +
> +static void sleep_poll(uint64_t usec)
> +{
> +	if (test_args.timer == VIRTUAL)
> +		guest_poll(PHYSICAL, usec, false, -1);
> +	else
> +		GUEST_ASSERT(0); /* Not implemented. */
> +}
> +
> +static void sleep_sched_poll(uint64_t usec)
> +{
> +	if (test_args.timer == VIRTUAL)
> +		guest_poll(PHYSICAL, usec, true, USERSPACE_SCHED_YIELD);
> +	else
> +		GUEST_ASSERT(0); /* Not implemented. */
> +}
> +
> +static void sleep_migrate(uint64_t usec)
> +{
> +	if (test_args.timer == VIRTUAL)
> +		guest_poll(PHYSICAL, usec, true, USERSPACE_MIGRATE_SELF);
> +	else
> +		GUEST_ASSERT(0); /* Not implemented. */
> +}

It may be worth mentioning that you're polling the counter that is *not*
under test. I presume you do this so your sleep implementation is not
affected by the test manipulations to the virtual counter.

> +static void sleep_in_userspace(uint64_t usec)
> +{
> +	SLEEP_IN_USERSPACE(usec);
> +}
> +
>  /*
>   * Reset the timer state to some nice values like the counter not being close
>   * to the edge, and the control register masked and disabled.
> @@ -251,6 +335,156 @@ static void test_timer(uint64_t reset_cnt, uint64_t xval,
>  	local_irq_enable();
>  }
>  
> +/*
> + * Set the counter to just below the edge (CVAL_MAX) and set a timer that
> + * crosses it over.
> + */
> +static void test_timers_across_rollovers(void)
> +{
> +	uint64_t edge_minus_5ms = CVAL_MAX - msec_to_cycles(5);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wait_method); i++) {
> +		wait_method_t wm = wait_method[i];
> +
> +		test_timer(edge_minus_5ms, msec_to_cycles(10), wm, TIMER_TVAL);
> +		test_timer(edge_minus_5ms, TVAL_MAX, wm, TIMER_TVAL);
> +		test_timer(edge_minus_5ms, TVAL_MIN, wm, TIMER_TVAL);
> +	}
> +}
> +
> +/* Check that timer control masks actually mask a timer being fired. */
> +static void test_timer_control_masked(sleep_method_t guest_sleep)
> +{
> +	reset_timer_state(DEF_CNT);
> +
> +	/* Local IRQs are not masked at this point. */
> +
> +	program_timer_irq(-1, CTL_ENABLE | CTL_IMASK, TIMER_TVAL);
> +
> +	/* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
> +	guest_sleep(TIMEOUT_NO_IRQ_US);
> +
> +	ASSERT_IRQS_HANDLED(0);
> +	timer_set_ctl(test_args.timer, CTL_IMASK);
> +}
> +
> +/* Test masking/unmasking a timer using the timer mask (not the IRQ mask). */
> +static void test_timer_control_mask_then_unmask(wait_method_t wm)
> +{
> +	reset_timer_state(DEF_CNT);
> +	program_timer_irq(-1, CTL_ENABLE | CTL_IMASK, TIMER_TVAL);
> +
> +	/* No IRQs because the timer is still masked. */
> +	ASSERT_IRQS_HANDLED(0);
> +
> +	/* Unmask the timer, and then get an IRQ. */
> +	local_irq_disable();
> +	timer_set_ctl(test_args.timer, CTL_ENABLE);
> +	wm();
> +
> +	ASSERT_IRQS_HANDLED(1);
> +	local_irq_enable();
> +}
> +
> +/*
> + * Set a timer at the edge, and wait with irqs masked for so long that the
> + * counter rolls over and the "Timer Condition" doesn't apply anymore.  We
> + * should still get an IRQ.

It looks like the test asserts we do not get an interrupt if the timer
condtion is no longer valid.

> + */
> +static void test_irq_masked_timer_across_rollover(sleep_method_t guest_sleep)
> +{
> +	local_irq_disable();
> +	reset_timer_state(CVAL_MAX - msec_to_cycles(5));
> +
> +	program_timer_irq(-1, CTL_ENABLE, TIMER_TVAL);
> +
> +	GUEST_ASSERT(timer_get_ctl(test_args.timer) & CTL_ISTATUS);
> +	guest_sleep(msecs_to_usecs(10));
> +	GUEST_ASSERT((timer_get_ctl(test_args.timer) & CTL_ISTATUS) == 0);
> +
> +	local_irq_enable();
> +	isb();
> +
> +	ASSERT_IRQS_HANDLED(0);
> +}
> +
> +static void test_control_masks(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(sleep_method); i++)
> +		test_timer_control_masked(sleep_method[i]);
> +
> +	for (i = 0; i < ARRAY_SIZE(wait_method); i++)
> +		test_timer_control_mask_then_unmask(wait_method[i]);
> +
> +	for (i = 0; i < ARRAY_SIZE(sleep_method); i++)
> +		test_irq_masked_timer_across_rollover(sleep_method[i]);
> +}
> +
> +static void test_fire_a_timer_multiple_times(wait_method_t wm, int num)
> +{
> +	int i;
> +
> +	local_irq_disable();
> +	reset_timer_state(DEF_CNT);
> +
> +	program_timer_irq(0, CTL_ENABLE, TIMER_TVAL);
> +
> +	for (i = 1; i <= num; i++) {
> +		wm();
> +
> +		/*
> +		 * The IRQ handler masked and disabled the timer.
> +		 * Enable and unmmask it again.
> +		 */
> +		timer_set_ctl(test_args.timer, CTL_ENABLE);
> +
> +		ASSERT_IRQS_HANDLED(i);
> +	}
> +
> +	local_irq_enable();
> +}
> +
> +static void test_timers_fired_multiple_times(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wait_method); i++)
> +		test_fire_a_timer_multiple_times(wait_method[i], 1000);
> +}
> +
> +/* Set a timer for cval1 then reprogram it to cval1. */

reprogram it to cval2

> +static void test_reprogram_timer(wait_method_t wm, bool use_sched,
> +		uint64_t cnt, uint64_t cval1, uint64_t cval2)
> +{
> +	local_irq_disable();
> +	reset_timer_state(cnt);
> +
> +	program_timer_irq(cval1, CTL_ENABLE, TIMER_CVAL);
> +
> +	if (use_sched)
> +		USERSPACE_SCHEDULE();
> +
> +	timer_set_cval(test_args.timer, cval2);
> +
> +	wm();
> +
> +	local_irq_enable();
> +	ASSERT_IRQS_HANDLED(1);
> +};
> +
> +static void test_reprogram_timers(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wait_method); i++) {
> +		test_reprogram_timer(wait_method[i], true, 0, CVAL_MAX, 0);
> +		test_reprogram_timer(wait_method[i], true, 0, CVAL_MAX, 0);
> +	}
> +}
> +
>  static void test_basic_functionality(void)
>  {
>  	int32_t tval = (int32_t)msec_to_cycles(10);
> @@ -306,7 +540,7 @@ static void timers_sanity_checks(bool use_sched)
>  	if (use_sched)
>  		USERSPACE_SCHEDULE();
>  	/* We just need 1 cycle to pass. */
> -	isb();
> +	sleep_poll(1);

Ah, this is exactly what I was asking for in patch 2. Is it possible to
hoist the needed pieces into that patch so you always poll CNTPCT before
reaching the assertion?

--
Thanks,
Oliver

>  	GUEST_ASSERT(timer_get_tval(test_args.timer) < 0);
>  
>  	local_irq_enable();
> @@ -322,10 +556,86 @@ static void test_timers_sanity_checks(void)
>  	timers_sanity_checks(true);
>  }
>  
> +/*
> + * Set the counter to cnt_1, the [c|t]val to xval, the counter to cnt_2, and
> + * then wait for an IRQ.
> + */
> +static void test_set_counter_after_programming_timer(uint64_t cnt_1,
> +		uint64_t xval, uint64_t cnt_2, wait_method_t wm,
> +		enum timer_view tv)
> +{
> +	local_irq_disable();
> +
> +	SET_COUNTER(cnt_1, test_args.timer);
> +	timer_set_ctl(test_args.timer, CTL_IMASK);
> +
> +	program_timer_irq(xval, CTL_ENABLE, tv);
> +	SET_COUNTER(cnt_2, test_args.timer);
> +	wm();
> +
> +	ASSERT_IRQS_HANDLED(1);
> +	local_irq_enable();
> +}
> +
> +/* Set a timer and then move the counter ahead of it. */
> +static void test_move_counters_after_timers(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wait_method); i++) {
> +		wait_method_t wm = wait_method[i];
> +
> +		test_set_counter_after_programming_timer(0, DEF_CNT,
> +				DEF_CNT + 1, wm, TIMER_CVAL);
> +		test_set_counter_after_programming_timer(CVAL_MAX, 1,
> +				2, wm, TIMER_CVAL);
> +		test_set_counter_after_programming_timer(0, TVAL_MAX,
> +				(uint64_t)TVAL_MAX + 1, wm, TIMER_TVAL);
> +	}
> +}
> +
> +static void test_timers_in_the_past(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wait_method); i++) {
> +		wait_method_t wm = wait_method[i];
> +
> +		test_timer(DEF_CNT, DEF_CNT - 1, wm, TIMER_CVAL);
> +		test_timer(DEF_CNT, TVAL_MIN, wm, TIMER_TVAL);
> +		test_timer(CVAL_MAX, 0, wm, TIMER_CVAL);
> +		test_timer(DEF_CNT, 0, wm, TIMER_CVAL);
> +		test_timer(DEF_CNT, 0, wm, TIMER_TVAL);
> +	}
> +}
> +
> +static void test_long_timer_delays(void)
> +{
> +	uint64_t wait_ms = test_args.long_wait_ms;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wait_method); i++) {
> +		wait_method_t wm = wait_method[i];
> +
> +		test_timer(0, msec_to_cycles(wait_ms), wm, TIMER_CVAL);
> +		test_timer(0, msec_to_cycles(wait_ms), wm, TIMER_TVAL);
> +	}
> +}
> +
>  static void guest_run_iteration(void)
>  {
>  	test_timers_sanity_checks();
>  	test_basic_functionality();
> +
> +	test_timers_in_the_past();
> +	test_timers_across_rollovers();
> +
> +	test_move_counters_after_timers();
> +	test_reprogram_timers();
> +
> +	test_control_masks();
> +
> +	test_timers_fired_multiple_times();
>  }
>  
>  static void guest_code(void)
> @@ -348,6 +658,7 @@ static void guest_code(void)
>  		guest_run_iteration();
>  	}
>  
> +	test_long_timer_delays();
>  	GUEST_DONE();
>  }
>  
> @@ -420,6 +731,9 @@ static void handle_sync(struct kvm_vm *vm, struct ucall *uc)
>  	case SET_REG_KVM_REG_ARM_TIMER_CNT:
>  		kvm_set_cntxct(vm, val, timer);
>  		break;
> +	case USERSPACE_USLEEP:
> +		usleep(val);
> +		break;
>  	case USERSPACE_SCHED_YIELD:
>  		sched_yield();
>  		break;
> @@ -503,11 +817,13 @@ static struct kvm_vm *test_vm_create(void)
>  
>  static void test_print_help(char *name)
>  {
> -	pr_info("Usage: %s [-h] [-i iterations] [-w] [-p pcpu1,pcpu2]\n",
> +	pr_info("Usage: %s [-h] [-i iterations] [-p pcpu1,pcpu2] [-l long_wait_ms]\n",
>  		name);
>  	pr_info("\t-i: Number of iterations (default: %u)\n",
>  		NR_TEST_ITERS_DEF);
>  	pr_info("\t-p: Pair of pcpus for the vcpus to alternate between.\n");
> +	pr_info("\t-l: Delta (in ms) used for long wait time test (default: %u)\n",
> +		LONG_WAIT_TEST_MS);
>  	pr_info("\t-h: Print this help message\n");
>  }
>  
> @@ -515,7 +831,7 @@ static bool parse_args(int argc, char *argv[])
>  {
>  	int opt, ret;
>  
> -	while ((opt = getopt(argc, argv, "hi:p:")) != -1) {
> +	while ((opt = getopt(argc, argv, "hi:p:l:")) != -1) {
>  		switch (opt) {
>  		case 'i':
>  			test_args.iterations = atoi(optarg);
> @@ -531,6 +847,13 @@ static bool parse_args(int argc, char *argv[])
>  				goto err;
>  			}
>  			break;
> +		case 'l':
> +			test_args.long_wait_ms = atoi(optarg);
> +			if (test_args.long_wait_ms <= 0) {
> +				pr_info("Positive value needed for -l\n");
> +				goto err;
> +			}
> +			break;
>  		case 'h':
>  		default:
>  			goto err;
> -- 
> 2.35.1.723.g4982287a31-goog
> 
