Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D0A5B8F98
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 22:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiINUMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 16:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiINUM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 16:12:28 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40C88688B
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 13:12:12 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1278624b7c4so44130826fac.5
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 13:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PS+i7WD6DvqgFUt9xjDtRNipRc6OC+kemNowSanyrIc=;
        b=eYLTijaOy9CLO8CFR7gciGXw9G/hD+VEZjib48ge05idVuHq+QBR05CGrmPm93XJH5
         58KSvPP+T7yI5N0SiEcHh2VwawzDtXmROLv5PS0ik8Nh4TBmnAOU4XRxxD9abkcXfuoU
         9WcmulBdObGUkEztw/jvhc70bM15M2azjzeCKgiI62QMuxxadobfrb1EjbEq6/+QaCB1
         TyunloNYwpPKgmEwEh+cwOeseSdWSdcK3xJ404hewfivXKnKVN216kn28b6WdiiyFCDt
         juvAVM24xUlpw+CjvPB/Z+fY8wRuKCAS3JcFX8B0UwKG2NzkyIAI7JG/740Jy9lRzJwA
         4+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PS+i7WD6DvqgFUt9xjDtRNipRc6OC+kemNowSanyrIc=;
        b=Et1uGiVdS/EEja4dhnp4Li0dE22llG5+fi98SD9HwMcD5o+lwlByJglwgCT1OWkhud
         bGfHE3+HiwJnn4/o/8K6CeJq/Z4DYu0FJltIRDVgdSv9ZTnUgIh/BrQN/jPvfFFT8i5t
         GEgwzOeP3hLiiIfYPCCuhPERtt+jUOkLWca+a5YllkNL/TUgZUQue/LWuUbJQIGojUzg
         MVwylwBfxE2PimZfZBkcmZcZEreEiOifv0U0WMZBNy4L/upY3R1fFVczrqblFTLK5XPo
         tIdd6SrQom/TH2raYTWnOG8GiC8zR1ae6HbaFVioF2jdWOD/v9pnrFYcjIGgG2/M2jBA
         IdHA==
X-Gm-Message-State: ACgBeo1p2rOqUB24iVVYjZD8sZ08s+eXRrd4c2k7XWVSaLSgRMm5BFAu
        2eJB1t/lW4fUIBSN5YxvvhAURig/sbCE7bdNOURmhg==
X-Google-Smtp-Source: AA6agR4I9/6gTGrk3KMdYwU/P4/2Xxyn819h+4b5+nqTLnCS86sz7BOjS5wxOUisZYCo1ltrV/0wl29wcXEHC4EVXIQ=
X-Received: by 2002:a05:6870:9593:b0:12b:fec4:f1c1 with SMTP id
 k19-20020a056870959300b0012bfec4f1c1mr3357935oao.181.1663186331672; Wed, 14
 Sep 2022 13:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com> <20220831162124.947028-8-aaronlewis@google.com>
In-Reply-To: <20220831162124.947028-8-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 14 Sep 2022 13:12:00 -0700
Message-ID: <CALMp9eR0mC3VTFkUv1USHcG_9gANG3OzyzcXPo4EsXwtv4vN8Q@mail.gmail.com>
Subject: Re: [PATCH v4 7/7] selftests: kvm/x86: Test masked events
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Aug 31, 2022 at 9:21 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add testing to show that a pmu event can be filtered with a generalized
> match on it's unit mask.
>
> These tests set up test cases to demonstrate various ways of filtering
> a pmu event that has multiple unit mask values.  It does this by
> setting up the filter in KVM with the masked events provided, then
> enabling three pmu counters in the guest.  The test then verifies that
> the pmu counters agree with which counters should be counting and which
> counters should be filtered for both a sparse filter list and a dense
> filter list.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 330 +++++++++++++++++-
>  1 file changed, 329 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 73a81262ca72..dd75c2fb3048 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -442,6 +442,326 @@ static bool use_amd_pmu(void)
>                  is_zen3(entry->eax));
>  }
>
> +/*
> + * "MEM_INST_RETIRED.ALL_LOADS", "MEM_INST_RETIRED.ALL_STORES", and
> + * "MEM_INST_RETIRED.ANY" from https://perfmon-events.intel.com/
> + * supported on Intel Xeon processors:
> + *  - Sapphire Rapids, Ice Lake, Cascade Lake, Skylake.
> + */
> +#define MEM_INST_RETIRED               0xD0
> +#define MEM_INST_RETIRED_LOAD          EVENT(MEM_INST_RETIRED, 0x81)
> +#define MEM_INST_RETIRED_STORE         EVENT(MEM_INST_RETIRED, 0x82)
> +#define MEM_INST_RETIRED_LOAD_STORE    EVENT(MEM_INST_RETIRED, 0x83)
> +
> +static bool supports_event_mem_inst_retired(void)
> +{
> +       uint32_t eax, ebx, ecx, edx;
> +
> +       cpuid(1, &eax, &ebx, &ecx, &edx);
> +       assert(x86_family(eax) == 0x6);

This seems aggressive. Even if Linux no longer runs on Pentium 4, what
about Xeon Phi?

> +
> +       switch (x86_model(eax)) {
> +       /* Sapphire Rapids */
> +       case 0x8F:
> +       /* Ice Lake */
> +       case 0x6A:
> +       /* Skylake */
> +       /* Cascade Lake */
> +       case 0x55:
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +/*
> + * "LS Dispatch", from Processor Programming Reference
> + * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
> + * Preliminary Processor Programming Reference (PPR) for AMD Family
> + * 17h Model 31h, Revision B0 Processors, and Preliminary Processor
> + * Programming Reference (PPR) for AMD Family 19h Model 01h, Revision
> + * B1 Processors Volume 1 of 2.
> + */
> +#define LS_DISPATCH            0x29
> +#define LS_DISPATCH_LOAD       EVENT(LS_DISPATCH, BIT(0))
> +#define LS_DISPATCH_STORE      EVENT(LS_DISPATCH, BIT(1))
> +#define LS_DISPATCH_LOAD_STORE EVENT(LS_DISPATCH, BIT(2))
> +
> +#define INCLUDE_MASKED_ENTRY(event_select, mask, match) \
> +       KVM_PMU_EVENT_ENCODE_MASKED_ENTRY(event_select, mask, match, false)
> +#define EXCLUDE_MASKED_ENTRY(event_select, mask, match) \
> +       KVM_PMU_EVENT_ENCODE_MASKED_ENTRY(event_select, mask, match, true)
> +
> +struct perf_counter {
> +       union {
> +               uint64_t raw;
> +               struct {
> +                       uint64_t loads:22;
> +                       uint64_t stores:22;
> +                       uint64_t loads_stores:20;
> +               };
> +       };
> +};
> +
> +static uint64_t masked_events_guest_test(uint32_t msr_base)
> +{
> +       uint64_t ld0, ld1, st0, st1, ls0, ls1;
> +       struct perf_counter c;
> +       int val;
> +
> +       ld0 = rdmsr(msr_base + 0);
> +       st0 = rdmsr(msr_base + 1);
> +       ls0 = rdmsr(msr_base + 2);
> +
> +       __asm__ __volatile__("movl $0, %[v];"
> +                            "movl %[v], %%eax;"
> +                            "incl %[v];"
> +                            : [v]"+m"(val) :: "eax");
> +
> +       ld1 = rdmsr(msr_base + 0);
> +       st1 = rdmsr(msr_base + 1);
> +       ls1 = rdmsr(msr_base + 2);
> +
> +       c.loads = ld1 - ld0;
> +       c.stores = st1 - st0;
> +       c.loads_stores = ls1 - ls0;
> +
> +       return c.raw;
> +}
> +
> +static void intel_masked_events_guest_code(void)
> +{
> +       uint64_t r;
> +
> +       for (;;) {
> +               wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +
> +               wrmsr(MSR_P6_EVNTSEL0 + 0, ARCH_PERFMON_EVENTSEL_ENABLE |
> +                     ARCH_PERFMON_EVENTSEL_OS | MEM_INST_RETIRED_LOAD);
> +               wrmsr(MSR_P6_EVNTSEL0 + 1, ARCH_PERFMON_EVENTSEL_ENABLE |
> +                     ARCH_PERFMON_EVENTSEL_OS | MEM_INST_RETIRED_STORE);
> +               wrmsr(MSR_P6_EVNTSEL0 + 2, ARCH_PERFMON_EVENTSEL_ENABLE |
> +                     ARCH_PERFMON_EVENTSEL_OS | MEM_INST_RETIRED_LOAD_STORE);
> +
> +               wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
> +
> +               r = masked_events_guest_test(MSR_IA32_PMC0);
> +
> +               GUEST_SYNC(r);
> +       }
> +}
> +
> +static void amd_masked_events_guest_code(void)
> +{
> +       uint64_t r;
> +
> +       for (;;) {
> +               wrmsr(MSR_K7_EVNTSEL0, 0);
> +               wrmsr(MSR_K7_EVNTSEL1, 0);
> +               wrmsr(MSR_K7_EVNTSEL2, 0);
> +
> +               wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
> +                     ARCH_PERFMON_EVENTSEL_OS | LS_DISPATCH_LOAD);
> +               wrmsr(MSR_K7_EVNTSEL1, ARCH_PERFMON_EVENTSEL_ENABLE |
> +                     ARCH_PERFMON_EVENTSEL_OS | LS_DISPATCH_STORE);
> +               wrmsr(MSR_K7_EVNTSEL2, ARCH_PERFMON_EVENTSEL_ENABLE |
> +                     ARCH_PERFMON_EVENTSEL_OS | LS_DISPATCH_LOAD_STORE);
> +
> +               r = masked_events_guest_test(MSR_K7_PERFCTR0);
> +
> +               GUEST_SYNC(r);
> +       }
> +}
> +
> +static struct perf_counter run_masked_events_test(struct kvm_vcpu *vcpu,
> +                                                const uint64_t masked_events[],
> +                                                const int nmasked_events)
> +{
> +       struct kvm_pmu_event_filter *f;
> +       struct perf_counter r;
> +
> +       f = create_pmu_event_filter(masked_events, nmasked_events,
> +                                   KVM_PMU_EVENT_ALLOW,
> +                                   KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
> +       r.raw = test_with_filter(vcpu, f);
> +       free(f);
> +
> +       return r;
> +}
> +
> +/* Matches KVM_PMU_EVENT_FILTER_MAX_EVENTS in pmu.c */
> +#define MAX_FILTER_EVENTS      300
> +#define MAX_TEST_EVENTS                10
> +
> +#define ALLOW_LOADS            BIT(0)
> +#define ALLOW_STORES           BIT(1)
> +#define ALLOW_LOADS_STORES     BIT(2)
> +
> +struct masked_events_test {
> +       uint64_t intel_events[MAX_TEST_EVENTS];
> +       uint64_t intel_event_end;
> +       uint64_t amd_events[MAX_TEST_EVENTS];
> +       uint64_t amd_event_end;
> +       const char *msg;
> +       uint32_t flags;
> +};
> +
> +/*
> + * These are the test cases for the masked events tests.
> + *
> + * For each test, the guest enables 3 PMU counters (loads, stores,
> + * loads + stores).  The filter is then set in KVM with the masked events
> + * provided.  The test then verifies that the counters agree with which
> + * ones should be counting and which ones should be filtered.
> + */
> +const struct masked_events_test test_cases[] = {
> +       {
> +               .intel_events = {
> +                       INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x81),
> +               },
> +               .amd_events = {
> +                       INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(0)),
> +               },
> +               .msg = "Only allow loads.",
> +               .flags = ALLOW_LOADS,
> +       }, {
> +               .intel_events = {
> +                       INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x82),
> +               },
> +               .amd_events = {
> +                       INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(1)),
> +               },
> +               .msg = "Only allow stores.",
> +               .flags = ALLOW_STORES,
> +       }, {
> +               .intel_events = {
> +                       INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x83),
> +               },
> +               .amd_events = {
> +                       INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(2)),
> +               },
> +               .msg = "Only allow loads + stores.",
> +               .flags = ALLOW_LOADS_STORES,
> +       }, {
> +               .intel_events = {
> +                       INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0x7C, 0),
> +                       EXCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x83),
> +               },
> +               .amd_events = {
> +                       INCLUDE_MASKED_ENTRY(LS_DISPATCH, ~(BIT(0) | BIT(1)), 0),
> +               },
> +               .msg = "Only allow loads and stores.",
> +               .flags = ALLOW_LOADS | ALLOW_STORES,
> +       }, {
> +               .intel_events = {
> +                       INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0x7C, 0),
> +                       EXCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x82),
> +               },
> +               .amd_events = {
> +                       INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xF8, 0),
> +                       EXCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(1)),
> +               },
> +               .msg = "Only allow loads and loads + stores.",
> +               .flags = ALLOW_LOADS | ALLOW_LOADS_STORES
> +       }, {
> +               .intel_events = {
> +                       INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFE, 0x82),
> +               },
> +               .amd_events = {
> +                       INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xF8, 0),
> +                       EXCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(0)),
> +               },
> +               .msg = "Only allow stores and loads + stores.",
> +               .flags = ALLOW_STORES | ALLOW_LOADS_STORES
> +       }, {
> +               .intel_events = {
> +                       INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0x7C, 0),
> +               },
> +               .amd_events = {
> +                       INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xF8, 0),
> +               },
> +               .msg = "Only allow loads, stores, and loads + stores.",
> +               .flags = ALLOW_LOADS | ALLOW_STORES | ALLOW_LOADS_STORES
> +       },
> +};
> +
> +static int append_test_events(const struct masked_events_test *test,
> +                             uint64_t *events, int nevents)
> +{
> +       const uint64_t *evts;
> +       int i;
> +
> +       evts = use_intel_pmu() ? test->intel_events : test->amd_events;
> +       for (i = 0; i < MAX_TEST_EVENTS; i++) {
> +               if (evts[i] == 0)
> +                       break;
> +
> +               events[nevents + i] = evts[i];
> +       }
> +
> +       return nevents + i;
> +}
> +
> +static bool bool_eq(bool a, bool b)
> +{
> +       return a == b;
> +}
> +
> +static void run_masked_events_tests(struct kvm_vcpu *vcpu, uint64_t *events,
> +                                   int nevents)
> +{
> +       int ntests = ARRAY_SIZE(test_cases);
> +       struct perf_counter c;
> +       int i, n;
> +
> +       for (i = 0; i < ntests; i++) {
> +               const struct masked_events_test *test = &test_cases[i];
> +
> +               /* Do any test case events overflow MAX_TEST_EVENTS? */
> +               assert(test->intel_event_end == 0);
> +               assert(test->amd_event_end == 0);
> +
> +               n = append_test_events(test, events, nevents);
> +
> +               c = run_masked_events_test(vcpu, events, n);
> +               TEST_ASSERT(bool_eq(c.loads, test->flags & ALLOW_LOADS) &&
> +                           bool_eq(c.stores, test->flags & ALLOW_STORES) &&
> +                           bool_eq(c.loads_stores,
> +                                   test->flags & ALLOW_LOADS_STORES),
> +                           "%s  loads: %u, stores: %u, loads + stores: %u",
> +                           test->msg, c.loads, c.stores, c.loads_stores);
> +       }
> +}
> +
> +static void add_dummy_events(uint64_t *events, int nevents)
> +{
> +       int i;
> +
> +       for (i = 0; i < nevents; i++) {
> +               int event_select = i % 0xFF;
> +               bool exclude = ((i % 4) == 0);
> +
> +               if (event_select == MEM_INST_RETIRED ||
> +                   event_select == LS_DISPATCH)
> +                       event_select++;
> +
> +               events[i] = KVM_PMU_EVENT_ENCODE_MASKED_ENTRY(event_select, 0,
> +                                                             0, exclude);
> +       }
> +}
> +
> +static void test_masked_events(struct kvm_vcpu *vcpu)
> +{
> +       int nevents = MAX_FILTER_EVENTS - MAX_TEST_EVENTS;
> +       uint64_t events[MAX_FILTER_EVENTS];
> +
> +       /* Run the test cases against a sparse PMU event filter. */
> +       run_masked_events_tests(vcpu, events, 0);
> +
> +       /* Run the test cases against a dense PMU event filter. */
> +       add_dummy_events(events, MAX_FILTER_EVENTS);
> +       run_masked_events_tests(vcpu, events, nevents);
> +}
> +
>  static int run_filter_test(struct kvm_vcpu *vcpu, const uint64_t *events,
>                            int nevents, uint32_t flags)
>  {
> @@ -478,13 +798,14 @@ static void test_filter_ioctl(struct kvm_vcpu *vcpu)
>  int main(int argc, char *argv[])
>  {
>         void (*guest_code)(void);
> -       struct kvm_vcpu *vcpu;
> +       struct kvm_vcpu *vcpu, *vcpu2 = NULL;
>         struct kvm_vm *vm;
>
>         /* Tell stdout not to buffer its content */
>         setbuf(stdout, NULL);
>
>         TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
> +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
>
>         TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
>         guest_code = use_intel_pmu() ? intel_guest_code : amd_guest_code;
> @@ -505,6 +826,13 @@ int main(int argc, char *argv[])
>         test_not_member_deny_list(vcpu);
>         test_not_member_allow_list(vcpu);
>
> +       if (use_intel_pmu() && supports_event_mem_inst_retired())

Do we need to verify that 3 or more general purpose counters are available?

> +               vcpu2 = vm_vcpu_add(vm, 2, intel_masked_events_guest_code);
> +       else if (use_amd_pmu())

Do we need to verify that the CPU is Zen[123]?

> +               vcpu2 = vm_vcpu_add(vm, 2, amd_masked_events_guest_code);
> +
> +       if (vcpu2)
> +               test_masked_events(vcpu2);
>         test_filter_ioctl(vcpu);
>
>         kvm_vm_free(vm);
> --
> 2.37.2.672.g94769d06f0-goog
>
