Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4854CB13A
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 22:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245085AbiCBV0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 16:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbiCBV0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 16:26:19 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E93BECE7
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 13:25:33 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 9so2698250pll.6
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 13:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DSJKv4X7KgGu7FsUU22pIWhfKTSJUinwycebGO+swSE=;
        b=Z4bxuyoYzgxeSWKrJzJD6y7wbX5C5E4GHeIK8jVrI/c2ZKY/oMSQYZI/Zw24lrTRMV
         2Ao22Y/Vml0vHa938pDj53pm+0zcU/P8Rwm4MqacRApwFjS7++0L/L6SbDQ9HrP7asXr
         PhaXe3irMhgcY95iI9u04xdIaY65dkC/Xxpa58sK52VzbuixmQCxNHORCdbvUa/Xp75k
         GOmyJR41dm6BNB2yPwIqcqy13kDf516xAUxEWA7FYI+xLQKHI8reKV3E4CKMM+UyQLFe
         BUpKqnPMKYPQp1QvTTDlvQRcYhBO6PUGhfdPrxg00F093X7IUU46tSe34g0ZthWEOS/u
         /AAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DSJKv4X7KgGu7FsUU22pIWhfKTSJUinwycebGO+swSE=;
        b=QINPl3UlGtM1tQ54E36WTI1Zz3n0p8bTOOYYAxHs56723DmVbE818fVvtil23YjQTT
         m/mdNCUpFppRFLPg+EEu1sbIpis0qdNdAIyiw0JcnQgj28L7Gx4T9v7bQO3V8jVp/EKQ
         m4iLaQwWLu4E8Ei7TFa7VpWkk8UyG9t8/+5FOt4OmppnDPnOMHelL8OIlk9l7UzVnBTG
         FYvK98ujHJNjwL5GcecSQTKLxbEt+hDXMJH1M2CnH6pfP/YQAzBmcyV/U+sEYbmN6Pt7
         6ID1nGad4fSuxwD2pmpcUQlWLgC9PRpFJ1wckv/PLbZe1H0ad1TtnMufUZT9usDfaVst
         8EIw==
X-Gm-Message-State: AOAM531Idr0r1pw4h9YmUk/syFSFZ2l7tOKzQCd53FPahyRg+FzyQsna
        JksFS0LoKyeAXIwy/3AaDoOr9A==
X-Google-Smtp-Source: ABdhPJzooJsjmsWOCrjFPjKotLonTPkYm1cpFO1qaqpRcNgGLBSKs2YDLSRt8/7VYTEXGcrNnHgXZw==
X-Received: by 2002:a17:903:124a:b0:151:99fe:1a10 with SMTP id u10-20020a170903124a00b0015199fe1a10mr4031232plh.87.1646256332860;
        Wed, 02 Mar 2022 13:25:32 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id f13-20020a056a001acd00b004f0f9a967basm104045pfv.100.2022.03.02.13.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:25:32 -0800 (PST)
Date:   Wed, 2 Mar 2022 13:25:28 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com
Subject: Re: [PATCH 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
Message-ID: <Yh/gyN7Xu54SpWBx@google.com>
References: <20220302172144.2734258-1-ricarkol@google.com>
 <20220302172144.2734258-3-ricarkol@google.com>
 <Yh/XgYAbqCYguegJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yh/XgYAbqCYguegJ@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Wed, Mar 02, 2022 at 08:45:53PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Wed, Mar 02, 2022 at 09:21:43AM -0800, Ricardo Koller wrote:
> > Add an arch_timer edge-cases selftest. For now, just add some basic
> > sanity checks, and some stress conditions (like waiting for the timers
> > while re-scheduling the vcpu). The next commit will add the actual edge
> > case tests.
> > 
> > This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
> > interrupts for suspended vCPU".
> > 
> 
> Testing timer correctness is extremely challenging to do without
> inherent flakiness. I have some concerns about the expectations that a
> timer IRQ should fire in a given amount of time, as it is possible to
> flake for any number of benign reasons (such as high CPU load in the
> host).
> 
> While the architecture may suggest that the timer should fire as soon as
> CVAL is met:
> 
>   TimerConditionMet = (((Counter[63:0] – Offset[63:0])[63:0] - CompareValue[63:0]) >= 0)
> 
> However, the architecture is extremely imprecise as to when an interrupt
> should be taken:
> 
>   In the absence of a specific requirement to take an interrupt, the
>   architecture only requires that unmasked pending interrupts are taken
>   in finite time. [DDI0487G.b D1.13.4 "Prioritization and recognition of
>   interrupts"]
> 
> It seems to me that the only thing we can positively assert is that a
> timer interrupt should never be taken early. Now -- I agree that there
> is value in testing that the interrupt be taken in bounded time, but its
> hard to pick a good value for it.

Yes, a timer that never fires passes the test, but it's not very useful.

I saw delay issues immediately after testing with QEMU. I've been played
with values and found that 1ms is enough for all of my runs (QEMU
included) to pass (10000 iterations concurrently on all my 64 cpus). I
just checked in the fast model and 1ms seems to be enough as well
(although I didn't check for so long).

	/* 1ms sounds a bit excessive, but QEMU-TCG is slow. */
	#define TEST_MARGIN_US			1000ULL

> 
> Perhaps documenting the possibility of flakes in the test is warranted,
> along with some knobs to adjust these values for any particularly bad
> implementation.

What about having a cmdline arg to enable those tests?

> 
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/.gitignore        |   1 +
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../kvm/aarch64/arch_timer_edge_cases.c       | 634 ++++++++++++++++++
> >  3 files changed, 636 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> > 
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index dce7de7755e6..8f7e0123dd28 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -1,5 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  /aarch64/arch_timer
> > +/aarch64/arch_timer_edge_cases
> >  /aarch64/debug-exceptions
> >  /aarch64/get-reg-list
> >  /aarch64/psci_cpu_on_test
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 0e4926bc9a58..17a0f32cfc91 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -101,6 +101,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> >  TEST_GEN_PROGS_x86_64 += system_counter_offset_test
> >  
> >  TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
> > +TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
> >  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> >  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> >  TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
> > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> > new file mode 100644
> > index 000000000000..48c886bce849
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
> > @@ -0,0 +1,634 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * arch_timer_edge_cases.c - Tests the aarch64 timer IRQ functionality.
> > + *
> > + * Copyright (c) 2021, Google LLC.
> > + */
> > +
> > +#define _GNU_SOURCE
> > +
> > +#include <stdlib.h>
> > +#include <pthread.h>
> > +#include <linux/kvm.h>
> > +#include <linux/sizes.h>
> > +#include <linux/bitmap.h>
> > +#include <sched.h>
> > +#include <sys/sysinfo.h>
> > +
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "delay.h"
> > +#include "arch_timer.h"
> > +#include "gic.h"
> > +#include "vgic.h"
> > +
> > +#define VCPUID				0
> > +
> > +#define msecs_to_usecs(msec)		((msec) * 1000LL)
> > +
> > +#define CVAL_MAX			~0ULL
> > +/* tval is a signed 32-bit int. */
> > +#define TVAL_MAX			INT_MAX
> > +#define TVAL_MIN			INT_MIN
> > +
> > +#define GICD_BASE_GPA			0x8000000ULL
> > +#define GICR_BASE_GPA			0x80A0000ULL
> > +
> > +/* After how much time we say there is no IRQ. */
> > +#define TIMEOUT_NO_IRQ_US		msecs_to_usecs(50)
> > +
> > +/* 1ms sounds a bit excessive, but QEMU-TCG is slow. */
> > +#define TEST_MARGIN_US			1000ULL
> > +
> > +/* A nice counter value to use as the starting one for most tests. */
> > +#define DEF_CNT				(CVAL_MAX / 2)
> > +
> > +/* Number of runs. */
> > +#define NR_TEST_ITERS_DEF		5
> > +
> > +/* Shared with IRQ handler. */
> > +volatile struct test_vcpu_shared_data {
> > +	int handled;
> > +} shared_data;
> > +
> > +struct test_args {
> > +	/* Virtual or physical timer and counter tests. */
> > +	enum arch_timer timer;
> > +	/* Number of iterations. */
> > +	int iterations;
> > +};
> > +
> > +struct test_args test_args = {
> > +	/* Only testing VIRTUAL timers for now. */
> > +	.timer = VIRTUAL,
> > +	.iterations = NR_TEST_ITERS_DEF,
> > +};
> > +
> > +static int vtimer_irq, ptimer_irq;
> > +
> > +typedef enum sync_cmd {
> > +	SET_REG_KVM_REG_ARM_TIMER_CNT = 100001,
> > +	USERSPACE_SCHED_YIELD,
> > +	USERSPACE_MIGRATE_SELF,
> > +} sync_cmd_t;
> > +
> > +typedef void (*wfi_method_t)(void);
> > +
> 
> nit: the name suggests to me a WFI in the architectural sense, but it
> appears polling is employed in certain implementations. Perhaps call it
> wait_method_t?
> 
> > +static void wait_for_non_spurious_irq(void);
> > +static void wait_poll_for_irq(void);
> > +static void wait_sched_poll_for_irq(void);
> > +static void wait_migrate_poll_for_irq(void);
> > +
> > +wfi_method_t wfi_method[] = {
> > +	wait_for_non_spurious_irq,
> > +	wait_poll_for_irq,
> > +	wait_sched_poll_for_irq,
> > +	wait_migrate_poll_for_irq,
> > +};
> > +
> > +#define for_each_wfi_method(i)							\
> > +	for ((i) = 0; (i) < ARRAY_SIZE(wfi_method); (i)++)
> 
> nit: for simple iterators such as this, I would prefer it be open-coded
> instead of defined in a macro.
> 
> > +typedef enum timer_view {
> > +	TIMER_CVAL = 1,
> 
> nit: do we care about the enumeration value? Same goes for enum
> sync_cmd.
> 
> > +	TIMER_TVAL,
> > +} timer_view_t;
> 
> nit: drop the typedef and just refer to the enum type explicitly. I'd
> recommend this for other enums in this test as well.
> 
> > +
> > +/* Pair of pcpus for the test to alternate between. */
> > +static int pcpus[2] = {-1, -1};
> > +static int pcpus_idx;
> > +
> > +static uint32_t next_pcpu(void)
> > +{
> > +	pcpus_idx = 1 - pcpus_idx;
> > +	return pcpus[pcpus_idx];
> > +}
> > +
> > +#define ASSERT_IRQS_HANDLED_2(__nr, arg1, arg2) do {				\
> > +	int __h = shared_data.handled;						\
> > +	GUEST_ASSERT_4(__h == (__nr), __h, __nr, arg1, arg2);			\
> > +} while (0)
> > +
> > +#define ASSERT_IRQS_HANDLED_1(__nr, arg1)					\
> > +	ASSERT_IRQS_HANDLED_2((__nr), arg1, 0)
> > +
> > +#define ASSERT_IRQS_HANDLED(__nr)						\
> > +	ASSERT_IRQS_HANDLED_2((__nr), 0, 0)
> > +
> > +#define TIMER_GET_CTL()								\
> > +	timer_get_ctl(test_args.timer)
> > +
> > +#define TIMER_SET_CTL(__ctl)							\
> > +	timer_set_ctl(test_args.timer, (__ctl))
> > +
> > +#define TIMER_SET_CVAL(__cval)							\
> > +	timer_set_cval(test_args.timer, (__cval))
> > +
> > +#define TIMER_SET_TVAL(__tval)							\
> > +	timer_set_tval(test_args.timer, (__tval))
> > +
> > +#define TIMER_GET_CVAL()							\
> > +	timer_get_cval(test_args.timer)
> > +
> > +#define TIMER_GET_TVAL()							\
> > +	timer_get_tval(test_args.timer)
> > +
> > +#define TIMER_GET_CNTCT()							\
> > +	timer_get_cntct(test_args.timer)
> 
> It might be cleaner to avoid these macro indirections and just have the
> caller pass test_args.timer on its own. Could use a local variable in
> the caller body to avoid referencing the struct every time.
> 
> > +#define __SET_COUNTER(__ctr, __t)						\
> > +	GUEST_SYNC_ARGS(SET_REG_KVM_REG_ARM_TIMER_CNT, (__ctr), (__t), 0, 0)
> > +
> > +#define SET_COUNTER(__ctr)							\
> > +	__SET_COUNTER((__ctr), test_args.timer)
> > +
> > +#define USERSPACE_CMD(__cmd)							\
> > +	GUEST_SYNC_ARGS(__cmd, 0, 0, 0, 0)
> > +
> > +#define USERSPACE_SCHEDULE()							\
> > +	USERSPACE_CMD(USERSPACE_SCHED_YIELD)
> > +
> > +#define USERSPACE_MIGRATE_VCPU()						\
> > +	USERSPACE_CMD(USERSPACE_MIGRATE_SELF)
> > +
> > +#define IAR_SPURIOUS		1023
> > +
> 
> how about INTID_SPURIOUS? Also, this is an invariant in the GIC
> architecture, so maybe hoist it into the selftests GIC headers.
> 
> > +static void guest_irq_handler(struct ex_regs *regs)
> > +{
> > +	unsigned int intid = gic_get_and_ack_irq();
> > +	uint64_t cnt, cval;
> > +	uint32_t ctl;
> > +
> > +	GUEST_ASSERT(gic_irq_get_pending(intid));
> > +
> > +	if (intid == IAR_SPURIOUS)
> > +		return;
> > +
> > +	ctl = TIMER_GET_CTL();
> > +	cnt = TIMER_GET_CNTCT();
> > +	cval = TIMER_GET_CVAL();
> > +
> > +	GUEST_ASSERT_1(ctl & CTL_ISTATUS, ctl);
> > +
> > +	/* Disable and mask the timer. */
> > +	TIMER_SET_CTL(CTL_IMASK);
> > +	GUEST_ASSERT(!gic_irq_get_pending(intid));
> > +
> > +	shared_data.handled++;
> > +
> > +	GUEST_ASSERT_2(cnt >= cval, cnt, cval);
> > +
> > +	gic_set_eoi(intid);
> > +}
> > +
> > +static void set_cval_irq(uint64_t cval_cycles, uint32_t ctl)
> > +{
> > +	shared_data.handled = 0;
> > +	TIMER_SET_CVAL(cval_cycles);
> > +	TIMER_SET_CTL(ctl);
> > +}
> > +
> > +static void set_tval_irq(uint64_t tval_cycles, uint32_t ctl)
> > +{
> > +	shared_data.handled = 0;
> > +	TIMER_SET_TVAL(tval_cycles);
> > +	TIMER_SET_CTL(ctl);
> > +}
> > +
> > +static void set_xval_irq(uint64_t xval, uint32_t ctl, timer_view_t tv)
> 
> nit: how about program_timer_irq().
> 
> > +{
> > +	switch (tv) {
> > +	case TIMER_CVAL:
> > +		set_cval_irq(xval, ctl);
> 
> nit: just inline these helpers into the switch statement body.
> 
> > +		break;
> > +	case TIMER_TVAL:
> > +		set_tval_irq(xval, ctl);
> > +		break;
> > +	default:
> > +		GUEST_ASSERT(0);
> > +	}
> > +}
> > +
> > +/*
> > + * Should be called with IRQs masked.
> > + *
> > + * Note that this can hang forever, so we rely on having a timeout mechanism in
> > + * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
> > + */
> > +static void wait_for_non_spurious_irq(void)
> > +{
> > +	int h;
> > +
> > +	for (h = shared_data.handled; h == shared_data.handled;) {
> > +		asm volatile("wfi\n"
> > +			     "msr daifclr, #2\n"
> > +			     /* handle IRQ */
> > +			     "msr daifset, #2\n"
> > +			     : : : "memory");
> > +	}
> > +}
> > +
> > +/*
> > + * Wait for an non-spurious IRQ by polling in the guest (userspace=0) or in
> > + * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHED_YIELD).
> > + *
> > + * Should be called with IRQs masked. Not really needed like the wfi above, but
> > + * it should match the others.
> > + *
> > + * Note that this can hang forever, so we rely on having a timeout mechanism in
> > + * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
> > + */
> > +static void poll_for_non_spurious_irq(bool userspace, sync_cmd_t userspace_cmd)
> > +{
> > +	int h;
> > +
> > +	h = shared_data.handled;
> > +
> > +	local_irq_enable();
> > +	while (h == shared_data.handled) {
> > +		if (userspace)
> > +			USERSPACE_CMD(userspace_cmd);
> > +		else
> > +			cpu_relax();
> > +	}
> > +	local_irq_disable();
> > +}
> > +
> > +static void wait_poll_for_irq(void)
> > +{
> > +	poll_for_non_spurious_irq(false, -1);
> > +}
> > +
> > +static void wait_sched_poll_for_irq(void)
> > +{
> > +	poll_for_non_spurious_irq(true, USERSPACE_SCHED_YIELD);
> > +}
> > +
> > +static void wait_migrate_poll_for_irq(void)
> > +{
> > +	poll_for_non_spurious_irq(true, USERSPACE_MIGRATE_SELF);
> > +}
> > +
> > +/*
> > + * Reset the timer state to some nice values like the counter not being close
> > + * to the edge, and the control register masked and disabled.
> > + */
> > +static void reset_timer_state(uint64_t cnt)
> > +{
> > +	SET_COUNTER(cnt);
> > +	TIMER_SET_CTL(CTL_IMASK);
> > +}
> > +
> > +static void test_timer_xval(uint64_t xval, timer_view_t tv, wfi_method_t wm,
> > +		bool reset_state, uint64_t reset_cnt)
> > +{
> > +	local_irq_disable();
> > +
> > +	if (reset_state)
> > +		reset_timer_state(reset_cnt);
> > +
> > +	set_xval_irq(xval, CTL_ENABLE, tv);
> > +	wm();
> > +
> > +	ASSERT_IRQS_HANDLED_2(1, tv, wm);
> 
> Printing the function pointer probably isn't too helpful w/o inspecting
> the binary.
> 

This has been very useful on my side, for my own debugging. But I guess
it can be dropped.

> > +	local_irq_enable();
> > +}
> > +
> > +/*
> > + * The test_timer_* functions will program the timer, wait for it, and assert
> > + * the firing of the correct IRQ.
> > + *
> > + * These functions don't have a timeout and return as soon as they receive an
> > + * IRQ. They can hang (forever), so we rely on having a timeout mechanism in
> > + * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
> > + */
> 
> Lift the hang commentary into the top-level comment
> 
> > +static void test_timer_cval(uint64_t cval, wfi_method_t wm, bool reset_state,
> > +		uint64_t reset_cnt)
> > +{
> > +	test_timer_xval(cval, TIMER_CVAL, wm, reset_state, reset_cnt);
> > +}
> > +
> > +static void test_timer_tval(int32_t tval, wfi_method_t wm, bool reset_state,
> > +		uint64_t reset_cnt)
> > +{
> > +	test_timer_xval((uint64_t)tval, TIMER_TVAL, wm, reset_state, reset_cnt);
> > +}
> > +
> > +static void test_basic_functionality(void)
> > +{
> > +	int32_t tval = (int32_t)msec_to_cycles(10);
> > +	uint64_t cval;
> > +	int i;
> > +
> > +	for_each_wfi_method(i) {
> > +		wfi_method_t wm = wfi_method[i];
> > +
> > +		cval = DEF_CNT + msec_to_cycles(10);
> > +
> > +		test_timer_cval(cval, wm, true, DEF_CNT);
> > +		test_timer_tval(tval, wm, true, DEF_CNT);
> > +	}
> > +}
> > +
> > +/*
> > + * This test checks basic timer behavior without actually firing timers, things
> > + * like: the relationship between cval and tval, tval down-counting.
> > + */
> > +static void timers_sanity_checks(bool use_sched)
> > +{
> > +	reset_timer_state(DEF_CNT);
> > +
> > +	local_irq_disable();
> > +
> > +	/* cval in the past */
> > +	TIMER_SET_CVAL(TIMER_GET_CNTCT() - msec_to_cycles(10));
> > +	if (use_sched)
> > +		USERSPACE_SCHEDULE();
> > +	GUEST_ASSERT(TIMER_GET_TVAL() < 0);
> > +
> > +	/* tval in the past */
> > +	TIMER_SET_TVAL(-1);
> > +	if (use_sched)
> > +		USERSPACE_SCHEDULE();
> > +	GUEST_ASSERT(TIMER_GET_CVAL() < TIMER_GET_CNTCT());
> > +
> > +	/* tval larger than TVAL_MAX. */
> > +	TIMER_SET_CVAL(TIMER_GET_CNTCT() + TVAL_MAX + msec_to_cycles(10));
> > +	if (use_sched)
> > +		USERSPACE_SCHEDULE();
> > +	GUEST_ASSERT(TIMER_GET_TVAL() <= 0);
> > +
> > +	/*
> > +	 * tval larger than 2 * TVAL_MAX.
> > +	 * Twice the TVAL_MAX completely loops around the TVAL.
> > +	 */
> > +	TIMER_SET_CVAL(TIMER_GET_CNTCT() + 2ULL * TVAL_MAX + msec_to_cycles(10));
> > +	if (use_sched)
> > +		USERSPACE_SCHEDULE();
> > +	GUEST_ASSERT_1(TIMER_GET_TVAL() <= msec_to_cycles(10), TIMER_GET_TVAL());
> > +
> > +	/* negative tval that rollovers from 0. */
> > +	SET_COUNTER(msec_to_cycles(1));
> > +	TIMER_SET_TVAL(-1 * msec_to_cycles(10));
> > +	if (use_sched)
> > +		USERSPACE_SCHEDULE();
> > +	GUEST_ASSERT(TIMER_GET_CVAL() >= (CVAL_MAX - msec_to_cycles(9)));
> > +
> > +	/* tval should keep down-counting from 0 to -1. */
> > +	TIMER_SET_TVAL(0);
> > +	/* We just need 1 cycle to pass. */
> > +	isb();
> > +	GUEST_ASSERT(TIMER_GET_TVAL() < 0);
> > +
> > +	local_irq_enable();
> > +
> > +	/* Mask and disable any pending timer. */
> > +	TIMER_SET_CTL(CTL_IMASK);
> > +}
> 
> There are instances of not-so-sane Generic Timers, such as the XGene-1
> that probably won't be fun to test. Marc would know more about this, but
> there may need to be a denylist of bad implementations.
>

Actually, QEMU-TCG fails some tests (related to rollovers). I had a
commmit to add a cmdline arg to not run those. I decided in favor
of failing in those cases as well.

> > +static void test_timers_sanity_checks(void)
> > +{
> > +	timers_sanity_checks(false);
> > +	/* Check how KVM saves/restores these edge-case values. */
> > +	timers_sanity_checks(true);
> > +}
> > +
> > +static void guest_run_iteration(void)
> > +{
> > +	test_basic_functionality();
> > +	test_timers_sanity_checks();
> > +}
> > +
> > +static void guest_code(void)
> > +{
> > +	int i;
> > +
> > +	local_irq_disable();
> > +
> > +	gic_init(GIC_V3, 1, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
> > +
> > +	TIMER_SET_CTL(CTL_IMASK);
> > +	timer_set_ctl(PHYSICAL, CTL_IMASK);
> > +
> > +	gic_irq_enable(vtimer_irq);
> > +	gic_irq_enable(ptimer_irq);
> > +	local_irq_enable();
> > +
> > +	for (i = 0; i < test_args.iterations; i++) {
> > +		GUEST_SYNC(i);
> > +		guest_run_iteration();
> > +	}
> > +
> > +	GUEST_DONE();
> > +}
> > +
> > +static void migrate_self(uint32_t new_pcpu)
> > +{
> > +	int ret;
> > +	cpu_set_t cpuset;
> > +	pthread_t thread;
> > +
> > +	thread = pthread_self();
> > +
> > +	CPU_ZERO(&cpuset);
> > +	CPU_SET(new_pcpu, &cpuset);
> > +
> > +	pr_debug("Migrating from %u to %u\n", sched_getcpu(), new_pcpu);
> > +
> > +	ret = pthread_setaffinity_np(thread, sizeof(cpuset), &cpuset);
> > +
> > +	TEST_ASSERT(ret == 0, "Failed to migrate to pCPU: %u; ret: %d\n",
> > +			new_pcpu, ret);
> > +}
> > +
> > +/*
> > + * Set the two pcpus that the test will use to alternate between. Default to
> > + * use the current cpu as pcpus[0] and the one right after in the affinity set
> > + * as pcpus[1].
> > + */
> > +static void set_default_pcpus(void)
> > +{
> > +	int max	= get_nprocs();
> > +	int curr = sched_getcpu();
> > +	cpu_set_t cpuset;
> > +	long i;
> > +
> > +	TEST_ASSERT(max > 1, "Need at least 2 online pcpus.");
> 
> Should the test skip (instead of fail) on such a precondition?
>

Yes, that would be nicer, will add the check in v2.

> > +	pcpus[0] = curr;
> > +
> > +	sched_getaffinity(getpid(), sizeof(cpu_set_t), &cpuset);
> > +	for (i = (curr + 1) % CPU_SETSIZE; i != curr; i = (i + 1) % CPU_SETSIZE) {
> > +		if (CPU_ISSET(i, &cpuset)) {
> > +			pcpus[1] = i;
> > +			break;
> > +		}
> > +	}
> > +
> > +	TEST_ASSERT(pcpus[1] != -1, "Couldn't find a second pcpu.");
> > +	pr_debug("pcpus: %d %d\n", pcpus[0], pcpus[1]);
> > +}
> > +
> > +static void kvm_set_cntxct(struct kvm_vm *vm, uint64_t cnt, enum arch_timer timer)
> > +{
> > +	TEST_ASSERT(timer == VIRTUAL,
> > +		"Only supports setting the virtual counter for now.");
> > +
> > +	struct kvm_one_reg reg = {
> > +		.id = KVM_REG_ARM_TIMER_CNT,
> > +		.addr = (uint64_t)&cnt,
> > +	};
> > +	vcpu_set_reg(vm, 0, &reg);
> > +}
> > +
> > +static void handle_sync(struct kvm_vm *vm, struct ucall *uc)
> > +{
> > +	sync_cmd_t cmd = uc->args[1];
> > +	uint64_t val = uc->args[2];
> > +	enum arch_timer timer = uc->args[3];
> > +
> > +	switch (cmd) {
> > +	case SET_REG_KVM_REG_ARM_TIMER_CNT:
> > +		kvm_set_cntxct(vm, val, timer);
> > +		break;
> > +	case USERSPACE_SCHED_YIELD:
> > +		sched_yield();
> > +		break;
> > +	case USERSPACE_MIGRATE_SELF:
> > +		migrate_self(next_pcpu());
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +}
> > +
> > +static void test_run(struct kvm_vm *vm)
> > +{
> > +	struct ucall uc;
> > +	int stage = 0;
> > +
> > +	/* Start on the first pcpu. */
> > +	migrate_self(pcpus[0]);
> > +
> > +	sync_global_to_guest(vm, test_args);
> > +
> > +	for (stage = 0; ; stage++) {
> > +		vcpu_run(vm, VCPUID);
> > +		switch (get_ucall(vm, VCPUID, &uc)) {
> > +		case UCALL_SYNC:
> > +			handle_sync(vm, &uc);
> > +			break;
> > +		case UCALL_DONE:
> > +			goto out;
> > +		case UCALL_ABORT:
> > +			TEST_FAIL("%s at %s:%ld\n\tvalues: %lu, %lu; %lu",
> > +				(const char *)uc.args[0], __FILE__, uc.args[1],
> > +				uc.args[2], uc.args[3], uc.args[4]);
> > +			goto out;
> > +		default:
> > +			TEST_FAIL("Unexpected guest exit\n");
> > +		}
> > +	}
> > +
> > +out:
> > +	return;
> > +}
> > +
> > +static void test_init_timer_irq(struct kvm_vm *vm)
> > +{
> > +	int vcpu_fd = vcpu_get_fd(vm, VCPUID);
> > +
> > +	kvm_device_access(vcpu_fd, KVM_ARM_VCPU_TIMER_CTRL,
> > +			KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq, false);
> > +	kvm_device_access(vcpu_fd, KVM_ARM_VCPU_TIMER_CTRL,
> > +			KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq, false);
> > +
> > +	sync_global_to_guest(vm, ptimer_irq);
> > +	sync_global_to_guest(vm, vtimer_irq);
> > +
> > +	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
> > +}
> > +
> > +static struct kvm_vm *test_vm_create(void)
> > +{
> > +	struct kvm_vm *vm;
> > +
> > +	vm = vm_create_default(VCPUID, 0, guest_code);
> > +
> > +	vm_init_descriptor_tables(vm);
> > +	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
> > +
> > +	vcpu_init_descriptor_tables(vm, 0);
> > +
> > +	ucall_init(vm, NULL);
> > +	test_init_timer_irq(vm);
> > +	vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> 
> The test should probably skip if GICv3 isn't supported, like commit 456f89e0928a
> ("KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3")
>

Ack, will add the check in v2.

> > +	return vm;
> > +}
> > +
> > +static void test_print_help(char *name)
> > +{
> > +	pr_info("Usage: %s [-h] [-i iterations] [-w] [-p pcpu1,pcpu2]\n",
> > +		name);
> > +	pr_info("\t-i: Number of iterations (default: %u)\n",
> > +		NR_TEST_ITERS_DEF);
> > +	pr_info("\t-p: Pair of pcpus for the vcpus to alternate between. "
> > +		"Defaults to use the current cpu and the one right after "
> > +		"in the affinity set.\n");
> > +	pr_info("\t-h: Print this help message\n");
> > +}
> > +
> > +static bool parse_args(int argc, char *argv[])
> > +{
> > +	int opt, ret;
> > +
> > +	while ((opt = getopt(argc, argv, "hi:p:")) != -1) {
> > +		switch (opt) {
> > +		case 'i':
> > +			test_args.iterations = atoi(optarg);
> > +			if (test_args.iterations <= 0) {
> > +				pr_info("Positive value needed for -i\n");
> > +				goto err;
> > +			}
> > +			break;
> > +		case 'p':
> > +			ret = sscanf(optarg, "%u,%u", &pcpus[0], &pcpus[1]);
> > +			if (ret != 2) {
> > +				pr_info("Invalid pcpus pair");
> > +				goto err;
> > +			}
> > +			break;
> > +		case 'h':
> > +		default:
> > +			goto err;
> > +		}
> > +	}
> > +
> > +	return true;
> > +
> > +err:
> > +	test_print_help(argv[0]);
> > +	return false;
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	struct kvm_vm *vm;
> > +
> > +	/* Tell stdout not to buffer its content */
> > +	setbuf(stdout, NULL);
> > +
> > +	if (!parse_args(argc, argv))
> > +		exit(KSFT_SKIP);
> > +
> > +	if (pcpus[0] == -1 || pcpus[1] == -1)
> > +		set_default_pcpus();
> > +
> > +	vm = test_vm_create();
> > +	test_run(vm);
> > +	kvm_vm_free(vm);
> > +
> > +	return 0;
> > +}
> > -- 
> > 2.35.1.574.g5d30c73bfb-goog
>

Thanks for the review!

Will work on v2.
