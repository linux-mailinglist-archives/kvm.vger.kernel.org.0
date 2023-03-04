Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DE26AAC6B
	for <lists+kvm@lfdr.de>; Sat,  4 Mar 2023 21:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCDU2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Mar 2023 15:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCDU2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Mar 2023 15:28:49 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EE8E39D
        for <kvm@vger.kernel.org>; Sat,  4 Mar 2023 12:28:47 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id ce7so3514303pfb.9
        for <kvm@vger.kernel.org>; Sat, 04 Mar 2023 12:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677961727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6XnGfZ3Kb9963SPPqrDJB0yg+2sAvV1RW90nBYUsNQ=;
        b=XGPE7+iCfQw+GkoAkRLTGnfWoTqSO3hK16UKEw6JMRHBR/7P7f/N5Rz63ByGVE1EIY
         TEVO+h787UE2sQoUnwk+ceTawM09N+C+bKLNOZEuVZqaYni1ltd+1MgHPTe6UheGDEhT
         7wDARDUpX5Wd+ulVw23bhOgUpgsO0CsatCWphaDLCBKjCqCFgGneNT6YSHr2ZxJabv17
         aYUVSBAAesjfVQNsvYk1Gtu/MGTwWdY2iatK4Lu5eetZyyG8ga/zpYDWdevjiheoDwYM
         pdgh2rNf/kpDlHcb+yj3UxS+LpbVbHwXxCLr2kGbvAKOavmel3N2fvVEYAGxZRGOn+ui
         pUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677961727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n6XnGfZ3Kb9963SPPqrDJB0yg+2sAvV1RW90nBYUsNQ=;
        b=xLC163bB3j5lxfoCqLKG2e1KtLQMOa5TK281oZJ85vjjdMbxbiGVdPNwd2hLMXMH3Y
         N4yQkXK6TFlFP4h/QfNkwpk0jpCgz78O95PWp2qjzaWVFct2FfzOLZxk1g13oES1uddF
         PmBSAqgoTVnYy8p4ApP1JkB7a+I0iwRVwt/HtjyiWt5aiBiU+T9BdVaCP0MbXKX5eO7y
         ZOqslwDZXB4YGxP/I46P6LuNH5NSmrBPses+pRdeRpdey3Ap4CRHKPFfb5sHMvYxWZ6l
         djmBEFtqzixTiu81kL4kPp8ZC9egxA1fM/k5uyni5Dz7mclTLX8fXbQUSv2p6u5z3xpe
         k37w==
X-Gm-Message-State: AO0yUKVftxnT6xdJTF3eNRaooJydlraAugiVZpwaGfCv2u19ingcP5j+
        X4chpU4UcigGsV52iyyfftet7k/EXGAFEBFP9kuZtA==
X-Google-Smtp-Source: AK7set/01iy81PQUrASN7xzWQxpHDXBsU0RwzyMYtPI3/3MAoORVAKLFtqdY9QJDgfSYJGpdy5vbsRWDZVZ0ZsyJbSM=
X-Received: by 2002:a63:7d03:0:b0:503:a268:b81e with SMTP id
 y3-20020a637d03000000b00503a268b81emr1913781pgc.5.1677961726488; Sat, 04 Mar
 2023 12:28:46 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-10-rananta@google.com>
In-Reply-To: <20230215010717.3612794-10-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 4 Mar 2023 12:28:30 -0800
Message-ID: <CAAeT=FwEPrJq7o4mRa-tMP2NgwkOR+5WjvjzwToG9-2PTBUZjg@mail.gmail.com>
Subject: Re: [REPOST PATCH 09/16] selftests: KVM: aarch64: Add KVM PMU event
 filter test
To:     Raghavendra Rao Ananta <rananta@google.com>
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

Hi Raghu,

On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Add tests to validate KVM's KVM_ARM_VCPU_PMU_V3_FILTER
> attribute by applying a series of filters to allow or
> deny events from the userspace. Validation is done by
> the guest in a way that it should be able to count
> only the events that are allowed.
>
> The workload to execute a precise number of instructions
> (execute_precise_instrs() and precise_instrs_loop()) is taken
> from the kvm-unit-tests' arm/pmu.c.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vpmu_test.c | 261 +++++++++++++++++-
>  1 file changed, 258 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/test=
ing/selftests/kvm/aarch64/vpmu_test.c
> index 2b3a4fa3afa9c..3dfb770b538e9 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> @@ -2,12 +2,21 @@
>  /*
>   * vpmu_test - Test the vPMU
>   *
> - * Copyright (c) 2022 Google LLC.
> + * The test suit contains a series of checks to validate the vPMU
> + * functionality. This test runs only when KVM_CAP_ARM_PMU_V3 is
> + * supported on the host. The tests include:
>   *
> - * This test checks if the guest can see the same number of the PMU even=
t
> + * 1. Check if the guest can see the same number of the PMU event
>   * counters (PMCR_EL0.N) that userspace sets, if the guest can access
>   * those counters, and if the guest cannot access any other counters.
> - * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
> + *
> + * 2. Test the functionality of KVM's KVM_ARM_VCPU_PMU_V3_FILTER
> + * attribute by applying a series of filters in various combinations
> + * of allowing or denying the events. The guest validates it by
> + * checking if it's able to count only the events that are allowed.
> + *
> + * Copyright (c) 2022 Google LLC.
> + *
>   */
>  #include <kvm_util.h>
>  #include <processor.h>
> @@ -230,6 +239,12 @@ struct pmc_accessor pmc_accessors[] =3D {
>
>  #define MAX_EVENT_FILTERS_PER_VM 10
>
> +#define EVENT_ALLOW(ev) \
> +       {.base_event =3D ev, .nevents =3D 1, .action =3D KVM_PMU_EVENT_AL=
LOW}
> +
> +#define EVENT_DENY(ev) \
> +       {.base_event =3D ev, .nevents =3D 1, .action =3D KVM_PMU_EVENT_DE=
NY}
> +
>  #define INVALID_EC     (-1ul)
>  uint64_t expected_ec =3D INVALID_EC;
>  uint64_t op_end_addr;
> @@ -243,11 +258,13 @@ struct vpmu_vm {
>
>  enum test_stage {
>         TEST_STAGE_COUNTER_ACCESS =3D 1,
> +       TEST_STAGE_KVM_EVENT_FILTER,
>  };
>
>  struct guest_data {
>         enum test_stage test_stage;
>         uint64_t expected_pmcr_n;
> +       unsigned long *pmu_filter;
>  };
>
>  static struct guest_data guest_data;
> @@ -329,6 +346,113 @@ static bool pmu_event_is_supported(uint64_t event)
>                 GUEST_ASSERT_3(!(_tval & mask), _tval, mask, set_expected=
);\
>  }
>
> +
> +/*
> + * Extra instructions inserted by the compiler would be difficult to com=
pensate
> + * for, so hand assemble everything between, and including, the PMCR acc=
esses
> + * to start and stop counting. isb instructions are inserted to make sur=
e
> + * pmccntr read after this function returns the exact instructions execu=
ted
> + * in the controlled block. Total instrs =3D isb + nop + 2*loop =3D 2 + =
2*loop.
> + */
> +static inline void precise_instrs_loop(int loop, uint32_t pmcr)
> +{
> +       uint64_t pmcr64 =3D pmcr;
> +
> +       asm volatile(
> +       "       msr     pmcr_el0, %[pmcr]\n"
> +       "       isb\n"
> +       "1:     subs    %w[loop], %w[loop], #1\n"
> +       "       b.gt    1b\n"
> +       "       nop\n"
> +       "       msr     pmcr_el0, xzr\n"
> +       "       isb\n"
> +       : [loop] "+r" (loop)
> +       : [pmcr] "r" (pmcr64)
> +       : "cc");
> +}
> +
> +/*
> + * Execute a known number of guest instructions. Only even instruction c=
ounts
> + * greater than or equal to 4 are supported by the in-line assembly code=
. The
> + * control register (PMCR_EL0) is initialized with the provided value (a=
llowing
> + * for example for the cycle counter or event counters to be reset). At =
the end
> + * of the exact instruction loop, zero is written to PMCR_EL0 to disable
> + * counting, allowing the cycle counter or event counters to be read at =
the
> + * leisure of the calling code.
> + */
> +static void execute_precise_instrs(int num, uint32_t pmcr)
> +{
> +       int loop =3D (num - 2) / 2;
> +
> +       GUEST_ASSERT_2(num >=3D 4 && ((num - 2) % 2 =3D=3D 0), num, loop)=
;
> +       precise_instrs_loop(loop, pmcr);
> +}
> +
> +static void test_instructions_count(int pmc_idx, bool expect_count)
> +{
> +       int i;
> +       struct pmc_accessor *acc;
> +       uint64_t cnt;
> +       int instrs_count =3D 100;
> +
> +       enable_counter(pmc_idx);
> +
> +       /* Test the event using all the possible way to configure the eve=
nt */
> +       for (i =3D 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> +               acc =3D &pmc_accessors[i];
> +
> +               pmu_disable_reset();
> +
> +               acc->write_typer(pmc_idx, ARMV8_PMUV3_PERFCTR_INST_RETIRE=
D);
> +
> +               /* Enable the PMU and execute precisely number of instruc=
tions as a workload */
> +               execute_precise_instrs(instrs_count, read_sysreg(pmcr_el0=
) | ARMV8_PMU_PMCR_E);
> +
> +               /* If a count is expected, the counter should be increase=
d by 'instrs_count' */
> +               cnt =3D acc->read_cntr(pmc_idx);
> +               GUEST_ASSERT_4(expect_count =3D=3D (cnt =3D=3D instrs_cou=
nt),
> +                               i, expect_count, cnt, instrs_count);
> +       }
> +
> +       disable_counter(pmc_idx);
> +}
> +
> +static void test_cycles_count(bool expect_count)
> +{
> +       uint64_t cnt;
> +
> +       pmu_enable();
> +       reset_cycle_counter();
> +
> +       /* Count cycles in EL0 and EL1 */
> +       write_pmccfiltr(0);
> +       enable_cycle_counter();
> +
> +       cnt =3D read_cycle_counter();
> +
> +       /*
> +        * If a count is expected by the test, the cycle counter should b=
e increased by
> +        * at least 1, as there is at least one instruction between enabl=
ing the
> +        * counter and reading the counter.
> +        */
> +       GUEST_ASSERT_2(expect_count =3D=3D (cnt > 0), cnt, expect_count);
> +
> +       disable_cycle_counter();

It would be nicer to also test using a generic PMC with
ARMV8_PMUV3_PERFCTR_CPU_CYCLES (not just with a cycle counter),
as the filter should be applied to both.

> +       pmu_disable_reset();
> +}
> +
> +static void test_event_count(uint64_t event, int pmc_idx, bool expect_co=
unt)
> +{
> +       switch (event) {
> +       case ARMV8_PMUV3_PERFCTR_INST_RETIRED:
> +               test_instructions_count(pmc_idx, expect_count);
> +               break;
> +       case ARMV8_PMUV3_PERFCTR_CPU_CYCLES:
> +               test_cycles_count(expect_count);
> +               break;
> +       }
> +}
> +
>  /*
>   * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
>   * are set or cleared as specified in @set_expected.
> @@ -532,12 +656,37 @@ static void guest_counter_access_test(uint64_t expe=
cted_pmcr_n)
>         }
>  }
>
> +static void guest_event_filter_test(unsigned long *pmu_filter)
> +{
> +       uint64_t event;
> +
> +       /*
> +        * Check if PMCEIDx_EL0 is advertized as configured by the usersp=
ace.
> +        * It's possible that even though the userspace allowed it, it ma=
y not be supported
> +        * by the hardware and could be advertized as 'disabled'. Hence, =
only validate against
> +        * the events that are advertized.

How about checking events that are supported by the hardware
initially (without setting the event filter) ?
Then, we can test if events that userspace tried to hide are
not exposed to guests correctly.

Can we also add a case for events that we can test both upper
32bits and lower 32 bits of both of PMCEID{0,1}_EL0 registers ?
(pmu_event_is_supported() needs to be fixed as well)



> +        *
> +        * Furthermore, check if the event is in fact counting if enabled=
, or vice-versa.
> +        */
> +       for (event =3D 0; event < ARMV8_PMU_MAX_EVENTS - 1; event++) {
> +               if (pmu_event_is_supported(event)) {
> +                       GUEST_ASSERT_1(test_bit(event, pmu_filter), event=
);
> +                       test_event_count(event, 0, true);
> +               } else {
> +                       test_event_count(event, 0, false);
> +               }
> +       }
> +}
> +
>  static void guest_code(void)
>  {
>         switch (guest_data.test_stage) {
>         case TEST_STAGE_COUNTER_ACCESS:
>                 guest_counter_access_test(guest_data.expected_pmcr_n);
>                 break;
> +       case TEST_STAGE_KVM_EVENT_FILTER:
> +               guest_event_filter_test(guest_data.pmu_filter);
> +               break;
>         default:
>                 GUEST_ASSERT_1(0, guest_data.test_stage);
>         }

IMHO running a guest from a different guest_code_xxx might be more
straightforward rather than controlling through the test_stage,
as it appears each test 'stage' is a different test case rather than
a test stage, and the test creates a new guest for each test 'stage'.
I don't find any reason to share the guest_code for those test
cases (Unless we are going to run some common guest codes for test
cases in the following patches)


> @@ -760,9 +909,115 @@ static void run_counter_access_tests(uint64_t pmcr_=
n)
>                 run_counter_access_error_test(i);
>  }
>
> +static struct kvm_pmu_event_filter pmu_event_filters[][MAX_EVENT_FILTERS=
_PER_VM] =3D {

It looks like KVM_ARM_VCPU_PMU_V3_FILTER is always used with
one entry in the filter (.nevents =3D=3D 1).
Could we also test with .nevents > 1 ?

> +       /*
> +        * Each set of events denotes a filter configuration for that VM.
> +        * During VM creation, the filters will be applied in the sequenc=
e mentioned here.
> +        */
> +       {
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +       },
> +       {
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +       },
> +       {
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +       },
> +       {
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +       },
> +       {
> +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +       },
> +       {
> +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +               EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +       },
> +       {
> +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +       },
> +       {
> +               EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +       },
> +};
> +
> +static void run_kvm_event_filter_error_tests(void)
> +{
> +       int ret;
> +       struct kvm_vm *vm;
> +       struct kvm_vcpu *vcpu;
> +       struct vpmu_vm *vpmu_vm;
> +       struct kvm_vcpu_init init;
> +       struct kvm_pmu_event_filter pmu_event_filter =3D EVENT_ALLOW(ARMV=
8_PMUV3_PERFCTR_CPU_CYCLES);
> +       struct kvm_device_attr filter_attr =3D {
> +               .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> +               .attr =3D KVM_ARM_VCPU_PMU_V3_FILTER,
> +               .addr =3D (uint64_t) &pmu_event_filter,
> +       };
> +
> +       /* KVM should not allow configuring filters after the PMU is init=
ialized */
> +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
> +       ret =3D __vcpu_ioctl(vpmu_vm->vcpu, KVM_SET_DEVICE_ATTR, &filter_=
attr);
> +       TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EBUSY,
> +                       "Failed to disallow setting an event filter after=
 PMU init");
> +       destroy_vpmu_vm(vpmu_vm);
> +
> +       /* Check for invalid event filter setting */
> +       vm =3D vm_create(1);
> +       vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> +       init.features[0] |=3D (1 << KVM_ARM_VCPU_PMU_V3);
> +       vcpu =3D aarch64_vcpu_add(vm, 0, &init, guest_code);
> +
> +       pmu_event_filter.base_event =3D UINT16_MAX;
> +       pmu_event_filter.nevents =3D 5;
> +       ret =3D __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &filter_attr);
> +       TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EINVAL, "Failed check f=
or invalid filter configuration");
> +       kvm_vm_free(vm);
> +}
> +
> +static void run_kvm_event_filter_test(void)
> +{
> +       int i;
> +       struct vpmu_vm *vpmu_vm;
> +       struct kvm_vm *vm;
> +       vm_vaddr_t pmu_filter_gva;
> +       size_t pmu_filter_bmap_sz =3D BITS_TO_LONGS(ARMV8_PMU_MAX_EVENTS)=
 * sizeof(unsigned long);
> +
> +       guest_data.test_stage =3D TEST_STAGE_KVM_EVENT_FILTER;
> +
> +       /* Test for valid filter configurations */
> +       for (i =3D 0; i < ARRAY_SIZE(pmu_event_filters); i++) {
> +               vpmu_vm =3D create_vpmu_vm(guest_code, pmu_event_filters[=
i]);
> +               vm =3D vpmu_vm->vm;
> +
> +               pmu_filter_gva =3D vm_vaddr_alloc(vm, pmu_filter_bmap_sz,=
 KVM_UTIL_MIN_VADDR);
> +               memcpy(addr_gva2hva(vm, pmu_filter_gva), vpmu_vm->pmu_fil=
ter, pmu_filter_bmap_sz);
> +               guest_data.pmu_filter =3D (unsigned long *) pmu_filter_gv=
a;
> +
> +               run_vcpu(vpmu_vm->vcpu);
> +
> +               destroy_vpmu_vm(vpmu_vm);
> +       }
> +
> +       /* Check if KVM is handling the errors correctly */
> +       run_kvm_event_filter_error_tests();
> +}
> +
>  static void run_tests(uint64_t pmcr_n)
>  {
>         run_counter_access_tests(pmcr_n);
> +       run_kvm_event_filter_test();
>  }
>
>  /*
> --
> 2.39.1.581.gbfd45094c4-goog
>

Thank you,
Reiji
