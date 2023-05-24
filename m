Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C4071013B
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 01:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjEXW7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 18:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238514AbjEXW7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 18:59:45 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643F7A9
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:59:43 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-3f6a6e9d90dso80641cf.0
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684969182; x=1687561182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VwZ7HOGa1OtTYpL3Q6Mk+wyS5qxehDKU6wYNUIwn0F8=;
        b=SLXezEOfP/bUhz9kgfaJH3kzPDiqZU9796oBLoh8sWQY6kI/YsBgeuy94VsgEsLsmD
         jeoyLHWbni2FcK1HhzIGd1fZVfPKN/Y8bfx8IY6KXpjXmQQLIPbHM0npS2gQXL3EMkh9
         lRaBNSO10WEVLG6lOra8NNIybfgJGk/nMLyvOc/3UTXe1Vr58JqXZph0tN0XP2Z+G8ly
         Foajk3PMF0Hp4HmSot6ybvPEMMHx6CKC6gILRqdUqsqlU1ugbsLqYplkHn8CmMTmkVtM
         P3AgVYvXnRU+Qhd82sqLTW/7WU98WiceqHaDTAu9NOSKyai7W8fiBHhWH4Vvgyy+8/On
         li2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684969182; x=1687561182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VwZ7HOGa1OtTYpL3Q6Mk+wyS5qxehDKU6wYNUIwn0F8=;
        b=OYuLoRGcfyeS0cb6ps+56IFz+Jf6DQGC34OLS6xi5P2NRtHgAVRq0YHzGsY2tztw9/
         4zd5FZMt8QHs+8nAO1iWCCXSz8NwjWFa2MvbPWgWO0yS1Qr4bSrP2CQ7eQ04/AoxkuPl
         NEJJV9sjI39ysdAKdV6GFCWc1ZfANXofSBbQmqFSkFpke6V+f2ZVG8/F/HwUf3bLNM/u
         q55CJE6mOHYi3H1iYvX71bjEgeYShVujJLy9n9mA5IgHMezRn2Zuj1Y7zrJD2S5uQ9Kd
         d0aTXFPBp36MqAzwW79/ph3aSjz6RYm6GcVq2Om3j8xazreeksOEG3DeaRF4EEAQLRQw
         /RTQ==
X-Gm-Message-State: AC+VfDy3T2xPUSVVk7tizR3XgDL/4xFd94YfmnC8RNWZJ/WkTzknljUe
        BOXF6eg8TdymhcN+eNHsc9OADrj0D2kPid0j/RYMaA==
X-Google-Smtp-Source: ACHHUZ4P5N4DncIC2PrG3o6mCScLGVEIOkNi3Mxc1gEILc1qL9wQm/cZtS99Xg9YiZUNidOcb2arhZ4NHU+Temvo2bg=
X-Received: by 2002:a05:622a:18a3:b0:3f6:97b4:1a4d with SMTP id
 v35-20020a05622a18a300b003f697b41a4dmr15523qtc.23.1684969182341; Wed, 24 May
 2023 15:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230323072714.82289-1-likexu@tencent.com> <20230323072714.82289-2-likexu@tencent.com>
In-Reply-To: <20230323072714.82289-2-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 24 May 2023 15:59:31 -0700
Message-ID: <CALMp9eSzhXR8RiUo9vdz77ZjBpaLSQGtVn47p2EuwoyKbmz9EQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: selftests: Test Intel PMU architectural events
 on gp counters
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 12:27=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> =
wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> Add test cases to check if different Architectural events are available
> after it's marked as unavailable via CPUID. It covers vPMU event filterin=
g
> logic based on Intel CPUID, which is a complement to pmu_event_filter.
>
> According to Intel SDM, the number of architectural events is reported
> through CPUID.0AH:EAX[31:24] and the architectural event x is
> supported if EBX[x]=3D0 && EAX[31:24]>x.
>
> Co-developed-by: Jinrong Liang <cloudliang@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 202 ++++++++++++++++++
>  2 files changed, 203 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index 84a627c43795..8aa63081b3e6 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -78,6 +78,7 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/mmio_warning_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/monitor_mwait_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/nested_exceptions_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/platform_info_test
> +TEST_GEN_PROGS_x86_64 +=3D x86_64/pmu_cpuid_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/pmu_event_filter_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/set_boot_cpu_id
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/set_sregs_test
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/=
testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> new file mode 100644
> index 000000000000..faab0a91e191
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> @@ -0,0 +1,202 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Test the consistency of the PMU's CPUID and its features
> + *
> + * Copyright (C) 2023, Tencent, Inc.
> + *
> + * Check that the VM's PMU behaviour is consistent with the
> + * VM CPUID definition.
> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <x86intrin.h>
> +
> +#include "processor.h"
> +
> +/* Guest payload for any performance counter counting */
> +#define NUM_BRANCHES 10
> +
> +#define EVENTSEL_OS BIT_ULL(17)
> +#define EVENTSEL_EN BIT_ULL(22)
> +#define PMU_CAP_FW_WRITES BIT_ULL(13)
> +#define EVENTS_MASK GENMASK_ULL(7, 0)
> +#define PMU_VERSION_MASK GENMASK_ULL(7, 0)
> +#define GP_CTR_NUM_OFS_BIT 8
> +#define GP_CTR_NUM_MASK GENMASK_ULL(15, GP_CTR_NUM_OFS_BIT)
> +#define EVT_LEN_OFS_BIT 24
> +#define EVT_LEN_MASK GENMASK_ULL(31, EVT_LEN_OFS_BIT)
> +
> +#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) =
<< 8)
> +
> +/*
> + * Intel Pre-defined Architectural Performance Events. Note some events
> + * are skipped for testing due to difficulties in stable reproduction.
> + */
> +static const uint64_t arch_events[] =3D {
> +       [0] =3D ARCH_EVENT(0x3c, 0x0),
> +       [1] =3D ARCH_EVENT(0xc0, 0x0),
> +       [2] =3D ARCH_EVENT(0x3c, 0x1),
> +       [3] =3D ARCH_EVENT(0x2e, 0x4f), /* LLC Reference */
> +       [4] =3D ARCH_EVENT(0x2e, 0x41), /* LLC Misses */
> +       [5] =3D ARCH_EVENT(0xc4, 0x0),
> +       [6] =3D ARCH_EVENT(0xc5, 0x0),  /* Branch Misses Retired */
> +       [7] =3D ARCH_EVENT(0xa4, 0x1), /* Topdown Slots */
> +};
> +
> +static struct kvm_vcpu *new_vcpu(void *guest_code)
> +{
> +       struct kvm_vm *vm;
> +       struct kvm_vcpu *vcpu;
> +
> +       vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
> +       vm_init_descriptor_tables(vm);
> +       vcpu_init_descriptor_tables(vcpu);
> +
> +       return vcpu;
> +}
> +
> +static void free_vcpu(struct kvm_vcpu *vcpu)
> +{
> +       kvm_vm_free(vcpu->vm);
> +}
> +
> +static void run_vcpu(struct kvm_vcpu *vcpu, const char *msg,
> +                    bool (*check_ucall)(struct ucall *uc, void *data),
> +                    void *expect_args)
> +{
> +       struct ucall uc;
> +
> +       for (;;) {
> +               vcpu_run(vcpu);
> +               switch (get_ucall(vcpu, &uc)) {
> +               case UCALL_SYNC:
> +                       TEST_ASSERT(check_ucall(&uc, expect_args), "%s", =
msg);
> +                       continue;
> +               case UCALL_DONE:
> +                       break;
> +               default:
> +                       TEST_ASSERT(false, "Unexpected exit: %s",
> +                                   exit_reason_str(vcpu->run->exit_reaso=
n));
> +               }
> +               break;
> +       }
> +}
> +
> +static bool first_uc_arg_non_zero(struct ucall *uc, void *data)
> +{
> +       return uc->args[1];
> +}
> +
> +static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_n=
um,
> +                                      bool supported, uint32_t ctr_base_=
msr,
> +                                      uint64_t evt_code)
> +{
> +       uint32_t global_msr =3D MSR_CORE_PERF_GLOBAL_CTRL;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < max_gp_num; i++) {
> +               wrmsr(ctr_base_msr + i, 0);
> +               wrmsr(MSR_P6_EVNTSEL0 + i, EVENTSEL_OS | EVENTSEL_EN | ev=
t_code);
> +               if (version > 1)
> +                       wrmsr(global_msr, BIT_ULL(i));
> +
> +               __asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES})=
);
> +
> +               if (version > 1)
> +                       wrmsr(global_msr, 0);
> +
> +               GUEST_SYNC(supported =3D=3D !!_rdpmc(i));

Just because the counter is non-zero doesn't mean that the event is
supported.  "Supported" would imply that it actually works, doesn't
it?

> +       }
> +
> +       GUEST_DONE();
> +}
> +
> +static void test_arch_events_setup(struct kvm_vcpu *vcpu, uint8_t evt_ve=
ctor,
> +                                  uint8_t unavl_mask, uint8_t idx)
> +{
> +       struct kvm_cpuid_entry2 *entry;
> +       uint32_t ctr_msr =3D MSR_IA32_PERFCTR0;
> +       bool is_supported;
> +
> +       entry =3D vcpu_get_cpuid_entry(vcpu, 0xa);
> +       entry->eax =3D (entry->eax & ~EVT_LEN_MASK) |
> +               (evt_vector << EVT_LEN_OFS_BIT);
> +       entry->ebx =3D (entry->ebx & ~EVENTS_MASK) | unavl_mask;
> +       vcpu_set_cpuid(vcpu);
> +
> +       if (vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_W=
RITES)
> +               ctr_msr =3D MSR_IA32_PMC0;
> +
> +       /* Arch event x is supported if EBX[x]=3D0 && EAX[31:24]>x */
> +       is_supported =3D !(entry->ebx & BIT_ULL(idx)) &&
> +               (((entry->eax & EVT_LEN_MASK) >> EVT_LEN_OFS_BIT) > idx);
> +
> +       vcpu_args_set(vcpu, 5, entry->eax & PMU_VERSION_MASK,
> +                     (entry->eax & GP_CTR_NUM_MASK) >> GP_CTR_NUM_OFS_BI=
T,
> +                     is_supported, ctr_msr, arch_events[idx]);
> +}
> +
> +static void intel_check_arch_event_is_unavl(uint8_t idx)
> +{
> +       const char *msg =3D "Unavailable arch event is counting.";
> +       uint8_t eax_evt_vec, ebx_unavl_mask, i, j;
> +       struct kvm_vcpu *vcpu;
> +
> +       /*
> +        * A brute force iteration of all combinations of values is likel=
y to
> +        * exhaust the limit of the single-threaded thread fd nums, so it=
's
> +        * tested here by iterating through all valid values on a single =
bit.
> +        */
> +       for (i =3D 0; i < ARRAY_SIZE(arch_events); i++) {
> +               eax_evt_vec =3D BIT_ULL(i);
> +               for (j =3D 0; j < ARRAY_SIZE(arch_events); j++) {
> +                       ebx_unavl_mask =3D BIT_ULL(j);
> +
> +                       vcpu =3D new_vcpu(intel_guest_run_arch_event);
> +                       test_arch_events_setup(vcpu, eax_evt_vec,
> +                                              ebx_unavl_mask, idx);
> +                       run_vcpu(vcpu, msg, first_uc_arg_non_zero, NULL);
> +                       free_vcpu(vcpu);
> +               }
> +       }
> +}
> +
> +static void intel_test_arch_events(void)
> +{
> +       uint8_t idx;
> +
> +       for (idx =3D 0; idx < ARRAY_SIZE(arch_events); idx++) {
> +               /*
> +                * Given the stability of performance event recurrence,
> +                * only these arch events are currently being tested:
> +                * - Core cycle event (idx =3D 0)
> +                * - Instruction retired event (idx =3D 1)
> +                * - Reference cycles event (idx =3D 2)

Note that reference cycles is one event that actually cannot be
successfully virtualized.

> +                * - Branch instruction retired event (idx =3D 5)
> +                */
> +               if (idx > 2 && idx !=3D 5)
> +                       continue;
> +
> +               intel_check_arch_event_is_unavl(idx);
> +       }
> +}
> +
> +static void intel_test_pmu_cpuid(void)
> +{
> +       intel_test_arch_events();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> +
> +       if (host_cpu_is_intel) {
> +               TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
> +               TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) >=
 0);
> +               TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
> +
> +               intel_test_pmu_cpuid();
> +       }
> +
> +       return 0;
> +}
> --
> 2.40.0
>
