Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF10A6B31FE
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 00:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjCIXSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 18:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCIXSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 18:18:11 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296111CBD8
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 15:18:05 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id e9-20020a056830200900b00694651d19f6so1984620otp.12
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 15:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678403884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1sP6x7mkArg5aqqKsCgg++4CSOue5AINV7XPhKsofI=;
        b=CiD8vJ/YiGiUnsc8XTfoqvz2mMMSQQSrWkTWV8tOh/1LpxhykbLPuFN7SfIMfCZ6YV
         HmpxK1wFxIB7bYyfcRiPGe60fDhN/56XZnzsFSiA3IU1WkHX1GGt3aEmMkO7eMVqCvOb
         iyepL1GoQhg8QxGTc+sPJ/Y3pcWQSsiSSNiL3vKQ+h2dWLBQMFbLQ7t2W2jq6wZAADuD
         gi9YS3ESVG7C5z9yCIfwiud4uHPWWND/uHLKW+qHzMQVYYBq9BWuIgZIZ5VoQ02ZnYxd
         tG9z2fMzPFhfK29vecFRW/gbGAQ2toWXfUDIzXxOCY/S02ulyiJoRTMBDTfWo505uBMi
         qtkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678403884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1sP6x7mkArg5aqqKsCgg++4CSOue5AINV7XPhKsofI=;
        b=aZCn/l+Zt1Ya6HFMFqq4FM6JCzw4or0/aM4VU5oMhR2li2+DFj5BHZfWlkebsXQUbl
         qP3UBlFNBhVnIRbSquSrV6HAfKGP1IcYKNGrCeABMziDiNrOuMfiQ4K7n3VfJVLX9qo/
         tasR+DWatWTi//0MATzfQtzzMh8MLhO57y29ZqKpb2XR4qGBcm4Vx4LTP1v+cUdWC7vB
         BEeCbzi/oDvy7DMll1hhvZWHymDXv3pfzbzDWKvOZnQ+Min2oReIZHezHSTAka1UBOfx
         c7Ed5CRhItobbt7Mh+uBlUE+XKoHaUPQVjqZGj+ornOKw9R3f2tBkvONUfz9E+QSKr57
         15UQ==
X-Gm-Message-State: AO0yUKUsXPreZ48LXMHkRRWR8BX82eIsHatiBfwwEVMK+XtrOSQf6LTc
        cgXqelBG/fvqLENt+xaCWYPWT0yg+VZp2lPq5WGQBQ==
X-Google-Smtp-Source: AK7set9irtihOa1TtZj4KEzd5gXK4LOlmI8+Tr9jjEhWG0zWNkX6wBxBZYqv9xCcrDWMHBghZS53/3yAgsAgBNyEcKs=
X-Received: by 2002:a05:6830:26ca:b0:690:d39d:ee41 with SMTP id
 m10-20020a05683026ca00b00690d39dee41mr7541370otu.7.1678403884150; Thu, 09 Mar
 2023 15:18:04 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-10-rananta@google.com>
 <CAAeT=FwEPrJq7o4mRa-tMP2NgwkOR+5WjvjzwToG9-2PTBUZjg@mail.gmail.com>
In-Reply-To: <CAAeT=FwEPrJq7o4mRa-tMP2NgwkOR+5WjvjzwToG9-2PTBUZjg@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Mar 2023 15:17:52 -0800
Message-ID: <CAJHc60w4aMS1AaUogyrijScv-R_Q8tx_Prma9ht56_GexzLrnw@mail.gmail.com>
Subject: Re: [REPOST PATCH 09/16] selftests: KVM: aarch64: Add KVM PMU event
 filter test
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Sat, Mar 4, 2023 at 12:28=E2=80=AFPM Reiji Watanabe <reijiw@google.com> =
wrote:
>
> Hi Raghu,
>
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Add tests to validate KVM's KVM_ARM_VCPU_PMU_V3_FILTER
> > attribute by applying a series of filters to allow or
> > deny events from the userspace. Validation is done by
> > the guest in a way that it should be able to count
> > only the events that are allowed.
> >
> > The workload to execute a precise number of instructions
> > (execute_precise_instrs() and precise_instrs_loop()) is taken
> > from the kvm-unit-tests' arm/pmu.c.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vpmu_test.c | 261 +++++++++++++++++-
> >  1 file changed, 258 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/te=
sting/selftests/kvm/aarch64/vpmu_test.c
> > index 2b3a4fa3afa9c..3dfb770b538e9 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > @@ -2,12 +2,21 @@
> >  /*
> >   * vpmu_test - Test the vPMU
> >   *
> > - * Copyright (c) 2022 Google LLC.
> > + * The test suit contains a series of checks to validate the vPMU
> > + * functionality. This test runs only when KVM_CAP_ARM_PMU_V3 is
> > + * supported on the host. The tests include:
> >   *
> > - * This test checks if the guest can see the same number of the PMU ev=
ent
> > + * 1. Check if the guest can see the same number of the PMU event
> >   * counters (PMCR_EL0.N) that userspace sets, if the guest can access
> >   * those counters, and if the guest cannot access any other counters.
> > - * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the hos=
t.
> > + *
> > + * 2. Test the functionality of KVM's KVM_ARM_VCPU_PMU_V3_FILTER
> > + * attribute by applying a series of filters in various combinations
> > + * of allowing or denying the events. The guest validates it by
> > + * checking if it's able to count only the events that are allowed.
> > + *
> > + * Copyright (c) 2022 Google LLC.
> > + *
> >   */
> >  #include <kvm_util.h>
> >  #include <processor.h>
> > @@ -230,6 +239,12 @@ struct pmc_accessor pmc_accessors[] =3D {
> >
> >  #define MAX_EVENT_FILTERS_PER_VM 10
> >
> > +#define EVENT_ALLOW(ev) \
> > +       {.base_event =3D ev, .nevents =3D 1, .action =3D KVM_PMU_EVENT_=
ALLOW}
> > +
> > +#define EVENT_DENY(ev) \
> > +       {.base_event =3D ev, .nevents =3D 1, .action =3D KVM_PMU_EVENT_=
DENY}
> > +
> >  #define INVALID_EC     (-1ul)
> >  uint64_t expected_ec =3D INVALID_EC;
> >  uint64_t op_end_addr;
> > @@ -243,11 +258,13 @@ struct vpmu_vm {
> >
> >  enum test_stage {
> >         TEST_STAGE_COUNTER_ACCESS =3D 1,
> > +       TEST_STAGE_KVM_EVENT_FILTER,
> >  };
> >
> >  struct guest_data {
> >         enum test_stage test_stage;
> >         uint64_t expected_pmcr_n;
> > +       unsigned long *pmu_filter;
> >  };
> >
> >  static struct guest_data guest_data;
> > @@ -329,6 +346,113 @@ static bool pmu_event_is_supported(uint64_t event=
)
> >                 GUEST_ASSERT_3(!(_tval & mask), _tval, mask, set_expect=
ed);\
> >  }
> >
> > +
> > +/*
> > + * Extra instructions inserted by the compiler would be difficult to c=
ompensate
> > + * for, so hand assemble everything between, and including, the PMCR a=
ccesses
> > + * to start and stop counting. isb instructions are inserted to make s=
ure
> > + * pmccntr read after this function returns the exact instructions exe=
cuted
> > + * in the controlled block. Total instrs =3D isb + nop + 2*loop =3D 2 =
+ 2*loop.
> > + */
> > +static inline void precise_instrs_loop(int loop, uint32_t pmcr)
> > +{
> > +       uint64_t pmcr64 =3D pmcr;
> > +
> > +       asm volatile(
> > +       "       msr     pmcr_el0, %[pmcr]\n"
> > +       "       isb\n"
> > +       "1:     subs    %w[loop], %w[loop], #1\n"
> > +       "       b.gt    1b\n"
> > +       "       nop\n"
> > +       "       msr     pmcr_el0, xzr\n"
> > +       "       isb\n"
> > +       : [loop] "+r" (loop)
> > +       : [pmcr] "r" (pmcr64)
> > +       : "cc");
> > +}
> > +
> > +/*
> > + * Execute a known number of guest instructions. Only even instruction=
 counts
> > + * greater than or equal to 4 are supported by the in-line assembly co=
de. The
> > + * control register (PMCR_EL0) is initialized with the provided value =
(allowing
> > + * for example for the cycle counter or event counters to be reset). A=
t the end
> > + * of the exact instruction loop, zero is written to PMCR_EL0 to disab=
le
> > + * counting, allowing the cycle counter or event counters to be read a=
t the
> > + * leisure of the calling code.
> > + */
> > +static void execute_precise_instrs(int num, uint32_t pmcr)
> > +{
> > +       int loop =3D (num - 2) / 2;
> > +
> > +       GUEST_ASSERT_2(num >=3D 4 && ((num - 2) % 2 =3D=3D 0), num, loo=
p);
> > +       precise_instrs_loop(loop, pmcr);
> > +}
> > +
> > +static void test_instructions_count(int pmc_idx, bool expect_count)
> > +{
> > +       int i;
> > +       struct pmc_accessor *acc;
> > +       uint64_t cnt;
> > +       int instrs_count =3D 100;
> > +
> > +       enable_counter(pmc_idx);
> > +
> > +       /* Test the event using all the possible way to configure the e=
vent */
> > +       for (i =3D 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> > +               acc =3D &pmc_accessors[i];
> > +
> > +               pmu_disable_reset();
> > +
> > +               acc->write_typer(pmc_idx, ARMV8_PMUV3_PERFCTR_INST_RETI=
RED);
> > +
> > +               /* Enable the PMU and execute precisely number of instr=
uctions as a workload */
> > +               execute_precise_instrs(instrs_count, read_sysreg(pmcr_e=
l0) | ARMV8_PMU_PMCR_E);
> > +
> > +               /* If a count is expected, the counter should be increa=
sed by 'instrs_count' */
> > +               cnt =3D acc->read_cntr(pmc_idx);
> > +               GUEST_ASSERT_4(expect_count =3D=3D (cnt =3D=3D instrs_c=
ount),
> > +                               i, expect_count, cnt, instrs_count);
> > +       }
> > +
> > +       disable_counter(pmc_idx);
> > +}
> > +
> > +static void test_cycles_count(bool expect_count)
> > +{
> > +       uint64_t cnt;
> > +
> > +       pmu_enable();
> > +       reset_cycle_counter();
> > +
> > +       /* Count cycles in EL0 and EL1 */
> > +       write_pmccfiltr(0);
> > +       enable_cycle_counter();
> > +
> > +       cnt =3D read_cycle_counter();
> > +
> > +       /*
> > +        * If a count is expected by the test, the cycle counter should=
 be increased by
> > +        * at least 1, as there is at least one instruction between ena=
bling the
> > +        * counter and reading the counter.
> > +        */
> > +       GUEST_ASSERT_2(expect_count =3D=3D (cnt > 0), cnt, expect_count=
);
> > +
> > +       disable_cycle_counter();
>
> It would be nicer to also test using a generic PMC with
> ARMV8_PMUV3_PERFCTR_CPU_CYCLES (not just with a cycle counter),
> as the filter should be applied to both.
>
Actually, my original intention was to check if the filters are being
applied to generic PMCs and the cycle counter, irrespective of the
event type. Hence, I did not focus too much on any other events.
But I understand that the cycles event is a special case. I'll check
the filter with cycles events on a generic counter.

> > +       pmu_disable_reset();
> > +}
> > +
> > +static void test_event_count(uint64_t event, int pmc_idx, bool expect_=
count)
> > +{
> > +       switch (event) {
> > +       case ARMV8_PMUV3_PERFCTR_INST_RETIRED:
> > +               test_instructions_count(pmc_idx, expect_count);
> > +               break;
> > +       case ARMV8_PMUV3_PERFCTR_CPU_CYCLES:
> > +               test_cycles_count(expect_count);
> > +               break;
> > +       }
> > +}
> > +
> >  /*
> >   * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
> >   * are set or cleared as specified in @set_expected.
> > @@ -532,12 +656,37 @@ static void guest_counter_access_test(uint64_t ex=
pected_pmcr_n)
> >         }
> >  }
> >
> > +static void guest_event_filter_test(unsigned long *pmu_filter)
> > +{
> > +       uint64_t event;
> > +
> > +       /*
> > +        * Check if PMCEIDx_EL0 is advertized as configured by the user=
space.
> > +        * It's possible that even though the userspace allowed it, it =
may not be supported
> > +        * by the hardware and could be advertized as 'disabled'. Hence=
, only validate against
> > +        * the events that are advertized.
>
> How about checking events that are supported by the hardware
> initially (without setting the event filter) ?
> Then, we can test if events that userspace tried to hide are
> not exposed to guests correctly.
>
Yes, that would be a way to go.

> Can we also add a case for events that we can test both upper
> 32bits and lower 32 bits of both of PMCEID{0,1}_EL0 registers ?
> (pmu_event_is_supported() needs to be fixed as well)
>
Of course, I'll cherry-pick some events.
>
>
> > +        *
> > +        * Furthermore, check if the event is in fact counting if enabl=
ed, or vice-versa.
> > +        */
> > +       for (event =3D 0; event < ARMV8_PMU_MAX_EVENTS - 1; event++) {
> > +               if (pmu_event_is_supported(event)) {
> > +                       GUEST_ASSERT_1(test_bit(event, pmu_filter), eve=
nt);
> > +                       test_event_count(event, 0, true);
> > +               } else {
> > +                       test_event_count(event, 0, false);
> > +               }
> > +       }
> > +}
> > +
> >  static void guest_code(void)
> >  {
> >         switch (guest_data.test_stage) {
> >         case TEST_STAGE_COUNTER_ACCESS:
> >                 guest_counter_access_test(guest_data.expected_pmcr_n);
> >                 break;
> > +       case TEST_STAGE_KVM_EVENT_FILTER:
> > +               guest_event_filter_test(guest_data.pmu_filter);
> > +               break;
> >         default:
> >                 GUEST_ASSERT_1(0, guest_data.test_stage);
> >         }
>
> IMHO running a guest from a different guest_code_xxx might be more
> straightforward rather than controlling through the test_stage,
> as it appears each test 'stage' is a different test case rather than
> a test stage, and the test creates a new guest for each test 'stage'.
> I don't find any reason to share the guest_code for those test
> cases (Unless we are going to run some common guest codes for test
> cases in the following patches)
>
Yes, I guess it should be okay to split the cases into independent
guest_code_xxx().
>
> > @@ -760,9 +909,115 @@ static void run_counter_access_tests(uint64_t pmc=
r_n)
> >                 run_counter_access_error_test(i);
> >  }
> >
> > +static struct kvm_pmu_event_filter pmu_event_filters[][MAX_EVENT_FILTE=
RS_PER_VM] =3D {
>
> It looks like KVM_ARM_VCPU_PMU_V3_FILTER is always used with
> one entry in the filter (.nevents =3D=3D 1).
> Could we also test with .nevents > 1 ?
>
The only reason why I went with 1 is I wanted to test the cycles and
instructions events with a workload, and these two aren't neighbours
when it comes to event numbers.
Anyway, I can also pick another supported event, plus its neighbours,
and test it only to the extent with pmu_event_is_supported(). This
way, I can also test .nevents > 2.

Thank you.
Raghavendra
> > +       /*
> > +        * Each set of events denotes a filter configuration for that V=
M.
> > +        * During VM creation, the filters will be applied in the seque=
nce mentioned here.
> > +        */
> > +       {
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +       },
> > +       {
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> > +       },
> > +       {
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> > +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +       },
> > +       {
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> > +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> > +       },
> > +       {
> > +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +       },
> > +       {
> > +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> > +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +       },
> > +       {
> > +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> > +       },
> > +       {
> > +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> > +       },
> > +};
> > +
> > +static void run_kvm_event_filter_error_tests(void)
> > +{
> > +       int ret;
> > +       struct kvm_vm *vm;
> > +       struct kvm_vcpu *vcpu;
> > +       struct vpmu_vm *vpmu_vm;
> > +       struct kvm_vcpu_init init;
> > +       struct kvm_pmu_event_filter pmu_event_filter =3D EVENT_ALLOW(AR=
MV8_PMUV3_PERFCTR_CPU_CYCLES);
> > +       struct kvm_device_attr filter_attr =3D {
> > +               .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> > +               .attr =3D KVM_ARM_VCPU_PMU_V3_FILTER,
> > +               .addr =3D (uint64_t) &pmu_event_filter,
> > +       };
> > +
> > +       /* KVM should not allow configuring filters after the PMU is in=
itialized */
> > +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
> > +       ret =3D __vcpu_ioctl(vpmu_vm->vcpu, KVM_SET_DEVICE_ATTR, &filte=
r_attr);
> > +       TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EBUSY,
> > +                       "Failed to disallow setting an event filter aft=
er PMU init");
> > +       destroy_vpmu_vm(vpmu_vm);
> > +
> > +       /* Check for invalid event filter setting */
> > +       vm =3D vm_create(1);
> > +       vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> > +       init.features[0] |=3D (1 << KVM_ARM_VCPU_PMU_V3);
> > +       vcpu =3D aarch64_vcpu_add(vm, 0, &init, guest_code);
> > +
> > +       pmu_event_filter.base_event =3D UINT16_MAX;
> > +       pmu_event_filter.nevents =3D 5;
> > +       ret =3D __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &filter_attr);
> > +       TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EINVAL, "Failed check=
 for invalid filter configuration");
> > +       kvm_vm_free(vm);
> > +}
> > +
> > +static void run_kvm_event_filter_test(void)
> > +{
> > +       int i;
> > +       struct vpmu_vm *vpmu_vm;
> > +       struct kvm_vm *vm;
> > +       vm_vaddr_t pmu_filter_gva;
> > +       size_t pmu_filter_bmap_sz =3D BITS_TO_LONGS(ARMV8_PMU_MAX_EVENT=
S) * sizeof(unsigned long);
> > +
> > +       guest_data.test_stage =3D TEST_STAGE_KVM_EVENT_FILTER;
> > +
> > +       /* Test for valid filter configurations */
> > +       for (i =3D 0; i < ARRAY_SIZE(pmu_event_filters); i++) {
> > +               vpmu_vm =3D create_vpmu_vm(guest_code, pmu_event_filter=
s[i]);
> > +               vm =3D vpmu_vm->vm;
> > +
> > +               pmu_filter_gva =3D vm_vaddr_alloc(vm, pmu_filter_bmap_s=
z, KVM_UTIL_MIN_VADDR);
> > +               memcpy(addr_gva2hva(vm, pmu_filter_gva), vpmu_vm->pmu_f=
ilter, pmu_filter_bmap_sz);
> > +               guest_data.pmu_filter =3D (unsigned long *) pmu_filter_=
gva;
> > +
> > +               run_vcpu(vpmu_vm->vcpu);
> > +
> > +               destroy_vpmu_vm(vpmu_vm);
> > +       }
> > +
> > +       /* Check if KVM is handling the errors correctly */
> > +       run_kvm_event_filter_error_tests();
> > +}
> > +
> >  static void run_tests(uint64_t pmcr_n)
> >  {
> >         run_counter_access_tests(pmcr_n);
> > +       run_kvm_event_filter_test();
> >  }
> >
> >  /*
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >
>
> Thank you,
> Reiji
