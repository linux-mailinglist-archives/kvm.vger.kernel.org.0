Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04144006D0
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350953AbhICUnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350944AbhICUnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:43:20 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835A4C061757
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:42:19 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id q70so734279ybg.11
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xuC1AbQeewFRo/xFFqcL88Ah+7CpgJ5CaVM6UZ6mtTI=;
        b=jM60ipIM3egn5pQ+GdkesL8xzx68ExyAKWHEiBTtmGEKVkhU5ELoPgYxRdVsTDKCEU
         6u1/Hhv3qdofh57ovdeLp0PBJq3/ccJC8RrajCa0wjhuwEUdWl/2YqgwPLQrODcGJGIj
         bbnZs9KUiFrGZ4FKcNl/vToO7Z8Kf4cbLMDsJlHWUSYPWSWy/2iwtVG0WrEMTkmcrHAK
         LtyQkK0XNOK/Hf4fal2UGoJzxeLpfX+e0FaUVEjtWrarqQle35I+bLgIeX3OglM5bDo4
         uSfu6rleePJB6h2EMQPXvGc0kyEjSHGFdvUNn5/9HpFMUk8TsL/x83yE/uCCt/3d7xgx
         NmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xuC1AbQeewFRo/xFFqcL88Ah+7CpgJ5CaVM6UZ6mtTI=;
        b=OTgi30EBp4QaysgfWIbYRW9Eqzec3PccKiKFrDVYcFHWJXv9TLGTQnPnamFFD1zmnE
         ViocSToFC02AsY5zWHsDoqBIQ0YervcyQe3cK+IeN6uLnek724HC54jR8saod6QWkomF
         PSCc/YBnANA4Z4n9/38GaDhBs4qUCwo133atcxlcHChweo0zgfb/UCPsLpp+yutr2u1Z
         zQ5gTZuRKUlradZapARex68xXVtS2s0fQ3s8PxFHB1/YgnMPOnjkVBrkF6SQ3dJMUeuB
         WW+E61Be/BwcX8JBaChB72cbcZSIg2nSi0wvWQCm53mNuzK55xL0jkWMRUvafjxY6AsD
         nedw==
X-Gm-Message-State: AOAM532cyMXG7eWF+zsxUeRzD/4irKEKlJmeI53hTrMBl2De3ioRdy0A
        8kCZxjc/Q07rh4+CK3iElszzYAGvST3qdGioDu/koQ==
X-Google-Smtp-Source: ABdhPJyHg7Q6U+LEI9cT8RqvbrXGuG61A+G+I9rNAlLOGZo9V713C/qUl4kUtsr4QUdE6efN1jSpFLbnaBJoUQjOKmQ=
X-Received: by 2002:a25:188b:: with SMTP id 133mr1222109yby.80.1630701738352;
 Fri, 03 Sep 2021 13:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com> <20210901211412.4171835-12-rananta@google.com>
 <20210903104823.ih4aj34vrbhlfhy3@gator.home>
In-Reply-To: <20210903104823.ih4aj34vrbhlfhy3@gator.home>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 3 Sep 2021 13:42:05 -0700
Message-ID: <CAJHc60xtp6Efdf2Ak4-zWQBcEwaM+TU2pb1qMigonxiG+gB4wQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] KVM: arm64: selftests: Add arch_timer test
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 3, 2021 at 3:48 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 01, 2021 at 09:14:11PM +0000, Raghavendra Rao Ananta wrote:
> > Add a KVM selftest to validate the arch_timer functionality.
> > Primarily, the test sets up periodic timer interrupts and
> > validates the basic architectural expectations upon its receipt.
> >
> > The test provides command-line options to configure the period
> > of the timer, number of iterations, and number of vCPUs.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/testing/selftests/kvm/.gitignore        |   1 +
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/aarch64/arch_timer.c        | 351 ++++++++++++++++++
> >  3 files changed, 353 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
> >
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 98053d3afbda..c6058df0cd18 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -1,4 +1,5 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > +/aarch64/arch_timer
> >  /aarch64/debug-exceptions
> >  /aarch64/get-reg-list
> >  /aarch64/psci_cpu_on_test
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 8342f65c1d96..46d43e706b20 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -84,6 +84,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
> >  TEST_GEN_PROGS_x86_64 += steal_time
> >  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> >
> > +TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
> >  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> >  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> >  TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
> > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > new file mode 100644
> > index 000000000000..1383f33850e9
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > @@ -0,0 +1,351 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * arch_timer.c - Tests the aarch64 timer IRQ functionality
> > + *
> > + * The test validates both the virtual and physical timer IRQs using
> > + * CVAL and TVAL registers. This consitutes the four stages in the test.
> > + * The guest's main thread configures the timer interrupt for a stage
> > + * and waits for it to fire, with a timeout equal to the timer period.
> > + * It asserts that the timeout doesn't exceed the timer period.
> > + *
> > + * On the other hand, upon receipt of an interrupt, the guest's interrupt
> > + * handler validates the interrupt by checking if the architectural state
> > + * is in compliance with the specifications.
> > + *
> > + * The test provides command-line options to configure the timer's
> > + * period (-p), number of vCPUs (-n), and iterations per stage (-i).
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
> > +
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "delay.h"
> > +#include "arch_timer.h"
> > +#include "gic.h"
> > +#include "vgic.h"
> > +
> > +#define NR_VCPUS_DEF                 4
> > +#define NR_TEST_ITERS_DEF            5
> > +#define TIMER_TEST_PERIOD_MS_DEF     10
> > +#define TIMER_TEST_ERR_MARGIN_US     100
> > +
> > +struct test_args {
> > +     int nr_vcpus;
> > +     int nr_iter;
> > +     int timer_period_ms;
> > +};
> > +
> > +static struct test_args test_args = {
> > +     .nr_vcpus = NR_VCPUS_DEF,
> > +     .nr_iter = NR_TEST_ITERS_DEF,
> > +     .timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> > +};
> > +
> > +#define msecs_to_usecs(msec)         ((msec) * 1000LL)
> > +
> > +#define VTIMER_IRQ                   27
> > +#define PTIMER_IRQ                   30
> > +
> > +#define GICD_BASE_GPA                        0x8000000ULL
> > +#define GICR_BASE_GPA                        0x80A0000ULL
> > +
> > +enum guest_stage {
> > +     GUEST_STAGE_VTIMER_CVAL = 1,
> > +     GUEST_STAGE_VTIMER_TVAL,
> > +     GUEST_STAGE_PTIMER_CVAL,
> > +     GUEST_STAGE_PTIMER_TVAL,
> > +     GUEST_STAGE_MAX,
> > +};
> > +
> > +/* Sahred variables between host and guest */
>
> Shared
>
> > +struct test_vcpu_shared_data {
> > +     int nr_iter;
> > +     enum guest_stage guest_stage;
> > +     uint64_t xcnt;
> > +};
> > +
> > +struct test_vcpu {
> > +     uint32_t vcpuid;
> > +     pthread_t pt_vcpu_run;
> > +     struct kvm_vm *vm;
> > +};
> > +
> > +static struct test_vcpu test_vcpu[KVM_MAX_VCPUS];
> > +static struct test_vcpu_shared_data vcpu_shared_data[KVM_MAX_VCPUS];
> > +
> > +static void
> > +guest_configure_timer_action(struct test_vcpu_shared_data *shared_data)
> > +{
> > +     switch (shared_data->guest_stage) {
> > +     case GUEST_STAGE_VTIMER_CVAL:
> > +             timer_set_next_cval_ms(VIRTUAL, test_args.timer_period_ms);
> > +             shared_data->xcnt = timer_get_cntct(VIRTUAL);
> > +             timer_set_ctl(VIRTUAL, CTL_ENABLE);
> > +             break;
> > +     case GUEST_STAGE_VTIMER_TVAL:
> > +             timer_set_next_tval_ms(VIRTUAL, test_args.timer_period_ms);
> > +             shared_data->xcnt = timer_get_cntct(VIRTUAL);
> > +             timer_set_ctl(VIRTUAL, CTL_ENABLE);
> > +             break;
> > +     case GUEST_STAGE_PTIMER_CVAL:
> > +             timer_set_next_cval_ms(PHYSICAL, test_args.timer_period_ms);
> > +             shared_data->xcnt = timer_get_cntct(PHYSICAL);
> > +             timer_set_ctl(PHYSICAL, CTL_ENABLE);
> > +             break;
> > +     case GUEST_STAGE_PTIMER_TVAL:
> > +             timer_set_next_tval_ms(PHYSICAL, test_args.timer_period_ms);
> > +             shared_data->xcnt = timer_get_cntct(PHYSICAL);
> > +             timer_set_ctl(PHYSICAL, CTL_ENABLE);
> > +             break;
>
> Since we divide the stages up for vtimer and ptimer, then I'm not sure we
> need the wrapper fuctions for timer register get/set with the vtimer and
> ptimer switches too.
>
I understand it's a little redundant. But like you saw in the
arch_timer framework patch,
the helper functions to program the cval, or tval, or any others to
follow, can be made very slim.

Thanks for catching the typos. Will fix them.

Regards,
Raghavendra
> > +     default:
> > +             GUEST_ASSERT(0);
> > +     }
> > +}
> > +
> > +static void guest_validate_irq(unsigned int intid,
> > +                             struct test_vcpu_shared_data *shared_data)
> > +{
> > +     enum guest_stage stage = shared_data->guest_stage;
> > +     uint64_t xcnt = 0, xcnt_diff_us, cval = 0;
> > +     unsigned long xctl = 0;
> > +     unsigned int timer_irq = 0;
> > +
> > +     if (stage == GUEST_STAGE_VTIMER_CVAL ||
> > +             stage == GUEST_STAGE_VTIMER_TVAL) {
> > +             xctl = timer_get_ctl(VIRTUAL);
> > +             timer_set_ctl(VIRTUAL, CTL_IMASK);
> > +             xcnt = timer_get_cntct(VIRTUAL);
> > +             cval = timer_get_cval(VIRTUAL);
> > +             timer_irq = VTIMER_IRQ;
> > +     } else if (stage == GUEST_STAGE_PTIMER_CVAL ||
> > +             stage == GUEST_STAGE_PTIMER_TVAL) {
> > +             xctl = timer_get_ctl(PHYSICAL);
> > +             timer_set_ctl(PHYSICAL, CTL_IMASK);
> > +             xcnt = timer_get_cntct(PHYSICAL);
> > +             cval = timer_get_cval(PHYSICAL);
> > +             timer_irq = PTIMER_IRQ;
> > +     } else {
> > +             GUEST_ASSERT(0);
> > +     }
> > +
> > +     xcnt_diff_us = cycles_to_usec(xcnt - shared_data->xcnt);
> > +
> > +     /* Make sure we are dealing with the correct timer IRQ */
> > +     GUEST_ASSERT_2(intid == timer_irq, intid, timer_irq);
> > +
> > +     /* Basic 'timer codition met' check */
>
> condition
>
> > +     GUEST_ASSERT_3(xcnt >= cval, xcnt, cval, xcnt_diff_us);
> > +     GUEST_ASSERT_1(xctl & CTL_ISTATUS, xctl);
> > +}
> > +
> > +static void guest_irq_handler(struct ex_regs *regs)
> > +{
> > +     unsigned int intid = gic_get_and_ack_irq();
> > +     uint32_t cpu = get_vcpuid();
> > +     struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
> > +
> > +     guest_validate_irq(intid, shared_data);
> > +
> > +     WRITE_ONCE(shared_data->nr_iter, shared_data->nr_iter + 1);
> > +
> > +     gic_set_eoi(intid);
> > +}
> > +
> > +static void guest_run_stage(struct test_vcpu_shared_data *shared_data,
> > +                             enum guest_stage stage)
> > +{
> > +     uint32_t irq_iter, config_iter;
> > +
> > +     shared_data->guest_stage = stage;
> > +     shared_data->nr_iter = 0;
> > +
> > +     for (config_iter = 0; config_iter < test_args.nr_iter; config_iter++) {
> > +             /* Setup the next interrupt */
> > +             guest_configure_timer_action(shared_data);
> > +
> > +             /* Setup a timeout for the interrupt to arrive */
> > +             udelay(msecs_to_usecs(test_args.timer_period_ms) +
> > +                     TIMER_TEST_ERR_MARGIN_US);
> > +
> > +             irq_iter = READ_ONCE(shared_data->nr_iter);
> > +             GUEST_ASSERT_2(config_iter + 1 == irq_iter,
> > +                             config_iter + 1, irq_iter);
> > +     };
>
> extra ;
>
> > +}
> > +
> > +static void guest_code(void)
> > +{
> > +     uint32_t cpu = get_vcpuid();
> > +     struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
> > +
> > +     local_irq_disable();
> > +
> > +     gic_init(GIC_V3, test_args.nr_vcpus,
> > +             (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
> > +
> > +     timer_set_ctl(VIRTUAL, CTL_IMASK);
> > +     timer_set_ctl(PHYSICAL, CTL_IMASK);
> > +
> > +     gic_irq_enable(VTIMER_IRQ);
> > +     gic_irq_enable(PTIMER_IRQ);
> > +     local_irq_enable();
> > +
> > +     guest_run_stage(shared_data, GUEST_STAGE_VTIMER_CVAL);
> > +     guest_run_stage(shared_data, GUEST_STAGE_VTIMER_TVAL);
> > +     guest_run_stage(shared_data, GUEST_STAGE_PTIMER_CVAL);
> > +     guest_run_stage(shared_data, GUEST_STAGE_PTIMER_TVAL);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static void *test_vcpu_run(void *arg)
> > +{
> > +     struct ucall uc;
> > +     struct test_vcpu *vcpu = arg;
> > +     struct kvm_vm *vm = vcpu->vm;
> > +     uint32_t vcpuid = vcpu->vcpuid;
> > +     struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[vcpuid];
> > +
> > +     vcpu_run(vm, vcpuid);
> > +
> > +     switch (get_ucall(vm, vcpuid, &uc)) {
> > +     case UCALL_SYNC:
> > +     case UCALL_DONE:
> > +             break;
> > +     case UCALL_ABORT:
> > +             sync_global_from_guest(vm, *shared_data);
> > +             TEST_ASSERT(false,
>
> TEST_FAIL(fmt, ...) can be used.
>
> > +                     "%s at %s:%ld\n\tvalues: %lu, %lu; %lu, vcpu: %u; stage: %u; iter: %u",
> > +                     (const char *)uc.args[0], __FILE__, uc.args[1],
> > +                     uc.args[2], uc.args[3], uc.args[4], vcpuid,
> > +                     shared_data->guest_stage, shared_data->nr_iter);
> > +             break;
> > +     default:
> > +             TEST_FAIL("Unexpected guest exit\n");
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +static void test_run(struct kvm_vm *vm)
> > +{
> > +     int i, ret;
> > +
> > +     for (i = 0; i < test_args.nr_vcpus; i++) {
> > +             ret = pthread_create(&test_vcpu[i].pt_vcpu_run, NULL,
> > +                             test_vcpu_run, &test_vcpu[i]);
> > +             TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
> > +     }
> > +
> > +     for (i = 0; i < test_args.nr_vcpus; i++)
> > +             pthread_join(test_vcpu[i].pt_vcpu_run, NULL);
> > +}
> > +
> > +static struct kvm_vm *test_vm_create(void)
> > +{
> > +     struct kvm_vm *vm;
> > +     unsigned int i;
> > +     int nr_vcpus = test_args.nr_vcpus;
> > +
> > +     vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
> > +
> > +     vm_init_descriptor_tables(vm);
> > +     vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
> > +
> > +     for (i = 0; i < nr_vcpus; i++) {
> > +             vcpu_init_descriptor_tables(vm, i);
> > +
> > +             test_vcpu[i].vcpuid = i;
> > +             test_vcpu[i].vm = vm;
> > +     }
> > +
> > +     ucall_init(vm, NULL);
> > +     vgic_v3_setup(vm, nr_vcpus, GICD_BASE_GPA, GICR_BASE_GPA, 1);
> > +
> > +     /* Make all the test's cmdline args visible to the guest */
> > +     sync_global_to_guest(vm, test_args);
> > +
> > +     return vm;
> > +}
> > +
> > +static void test_print_help(char *name)
> > +{
> > +     pr_info("Usage: %s [-h] [-n nr_vcpus] [-i iterations] [-p timer_period_ms]\n",
> > +             name);
> > +     pr_info("\t-n: Number of vCPUs to configure (default: %u; max: %u)\n",
> > +             NR_VCPUS_DEF, KVM_MAX_VCPUS);
> > +     pr_info("\t-i: Number of iterations per stage (default: %u)\n",
> > +             NR_TEST_ITERS_DEF);
> > +     pr_info("\t-p: Periodicity (in ms) of the guest timer (default: %u)\n",
> > +             TIMER_TEST_PERIOD_MS_DEF);
> > +     pr_info("\t-h: print this help screen\n");
> > +}
> > +
> > +static bool parse_args(int argc, char *argv[])
> > +{
> > +     int opt;
> > +
> > +     while ((opt = getopt(argc, argv, "hn:i:p:")) != -1) {
> > +             switch (opt) {
> > +             case 'n':
> > +                     test_args.nr_vcpus = atoi(optarg);
> > +                     if (test_args.nr_vcpus <= 0) {
> > +                             pr_info("Positive value needed for -n\n");
> > +                             goto err;
> > +                     } else if (test_args.nr_vcpus > KVM_MAX_VCPUS) {
> > +                             pr_info("Max allowed vCPUs: %u\n",
> > +                                     KVM_MAX_VCPUS);
> > +                             goto err;
> > +                     }
> > +                     break;
> > +             case 'i':
> > +                     test_args.nr_iter = atoi(optarg);
> > +                     if (test_args.nr_iter <= 0) {
> > +                             pr_info("Positive value needed for -i\n");
> > +                             goto err;
> > +                     }
> > +                     break;
> > +             case 'p':
> > +                     test_args.timer_period_ms = atoi(optarg);
> > +                     if (test_args.timer_period_ms <= 0) {
> > +                             pr_info("Positive value needed for -p\n");
> > +                             goto err;
> > +                     }
> > +                     break;
> > +             case 'h':
> > +             default:
> > +                     goto err;
> > +             }
> > +     }
> > +
> > +     return true;
> > +
> > +err:
> > +     test_print_help(argv[0]);
> > +     return false;
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     struct kvm_vm *vm;
> > +
> > +     /* Tell stdout not to buffer its content */
> > +     setbuf(stdout, NULL);
> > +
> > +     if (!parse_args(argc, argv))
> > +             exit(KSFT_SKIP);
> > +
> > +     vm = test_vm_create();
> > +     test_run(vm);
> > +     kvm_vm_free(vm);
> > +
> > +     return 0;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
>
> Besides the nits,
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> Thanks,
> drew
>
