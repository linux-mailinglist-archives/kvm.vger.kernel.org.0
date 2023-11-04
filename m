Return-Path: <kvm+bounces-583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDDB7E0F93
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 14:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E01D9B210DD
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 13:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0349018C3C;
	Sat,  4 Nov 2023 13:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kxgaXtNc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94B3C13F
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 13:20:34 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E21194
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 06:20:32 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40837124e1cso41795e9.0
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 06:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699104031; x=1699708831; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lf4Kdqg1Ix4JtjJRKgIfRp+X+syD3doJEppQgu2HHg=;
        b=kxgaXtNc9U44tUHqWOfmr5fLkYLMQti0kVtTLCA+XcmE2wyQF2qLQAkg7QP8RsNHum
         DZ++oKOZY+zR6i0JsPWUrAlYxTTSHEqzWX84moFXqzeJUDs4k4ewEn6kM6bhmTnVj5Yr
         nBnNMrhDH1MimG/y/O1TE6NFm4NYDIVvCf2edpOdk+4H0b1U9UuO4/4JSIxrg8+6azvn
         U3euqWgvj5iIDAR5rxxxkUT/ipYYnLGxGtACRfagvP358WUB7qK5Zo3rX3kenHSe6Eyo
         gezTMfA21/n8bc7Fu011xuG6hs87CLZsxFbwV9MqxNcDzz+BoWZuhRgRSRZCRC/7c5P6
         v0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699104031; x=1699708831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7lf4Kdqg1Ix4JtjJRKgIfRp+X+syD3doJEppQgu2HHg=;
        b=WXL6WGVIl0FrIgC0GPCwdf6IoSGCsiXTdrEc9CQxi5YxSOub/ZZ1SScMzo89sR3+x5
         qRLrqn0FUbCuR4XXMEpOjE/FmHZvclM4QM7KgOfVkBDRF4B4tmd6v8uF7VVJddjLp+z0
         c/7NA4wFZ16aWbrS31IcnXBRtH5HhhYq4l5BHzCSmr/Gaqi/3tNBNEobe/5YWPR4bdPE
         HFaGSIsk00WLCE61GY8D+oGxbydi+pH2DyTe12I8pgb+m+5NT1UVE2rzXpjnCLtEOGuF
         SxjcusNOcLMD3X417M/vEONGIRtEkAodErRaiq/ojdXZc+KgTd1R8ywmC6kv3x2eajD7
         LXug==
X-Gm-Message-State: AOJu0YwBpQkBZwutaGjPwIZHVtZAHo0leZ9ehH6hIm8o0i7ivB873Kf6
	E5KSDNx2TcgSmZWkSsT+og6ZufEO9xFVqz7hSzqyIw==
X-Google-Smtp-Source: AGHT+IFHQeaiA0q5Oi0jH7atYpTBU7yDbM97qCWjibSomtP+3/oIJAE5t0nmu1K2Svfn7cZ2csJbk8jEBDbbCBVOSh4=
X-Received: by 2002:a05:600c:5406:b0:404:74f8:f47c with SMTP id
 he6-20020a05600c540600b0040474f8f47cmr40784wmb.5.1699104030677; Sat, 04 Nov
 2023 06:20:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-10-seanjc@google.com>
In-Reply-To: <20231104000239.367005-10-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Sat, 4 Nov 2023 06:20:19 -0700
Message-ID: <CALMp9eT22j2Ob9ihva41p2JRufR5P+xnzsm99LEd1quxnfCyWA@mail.gmail.com>
Subject: Re: [PATCH v6 09/20] KVM: selftests: Add pmu.h and lib/pmu.c for
 common PMU assets
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> From: Jinrong Liang <cloudliang@tencent.com>
>
> By defining the PMU performance events and masks relevant for x86 in
> the new pmu.h and pmu.c, it becomes easier to reference them, minimizing
> potential errors in code that handles these values.
>
> Clean up pmu_event_filter_test.c by including pmu.h and removing
> unnecessary macros.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> [sean: drop PSEUDO_ARCH_REFERENCE_CYCLES]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  tools/testing/selftests/kvm/include/pmu.h     | 84 +++++++++++++++++++
>  tools/testing/selftests/kvm/lib/pmu.c         | 28 +++++++
>  .../kvm/x86_64/pmu_event_filter_test.c        | 32 ++-----
>  4 files changed, 122 insertions(+), 23 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/pmu.h
>  create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index a5963ab9215b..44d8d022b023 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -32,6 +32,7 @@ LIBKVM +=3D lib/guest_modes.c
>  LIBKVM +=3D lib/io.c
>  LIBKVM +=3D lib/kvm_util.c
>  LIBKVM +=3D lib/memstress.c
> +LIBKVM +=3D lib/pmu.c
>  LIBKVM +=3D lib/guest_sprintf.c
>  LIBKVM +=3D lib/rbtree.c
>  LIBKVM +=3D lib/sparsebit.c
> diff --git a/tools/testing/selftests/kvm/include/pmu.h b/tools/testing/se=
lftests/kvm/include/pmu.h
> new file mode 100644
> index 000000000000..987602c62b51
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/pmu.h
> @@ -0,0 +1,84 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2023, Tencent, Inc.
> + */
> +#ifndef SELFTEST_KVM_PMU_H
> +#define SELFTEST_KVM_PMU_H
> +
> +#include <stdint.h>
> +
> +#define X86_PMC_IDX_MAX                                64
> +#define INTEL_PMC_MAX_GENERIC                          32

I think this is actually 15. Note that IA32_PMC0 through IA32_PMC7
have MSR indices from 0xc1 through 0xc8, and MSR 0xcf is
IA32_CORE_CAPABILITIES. At the very least, we have to handle
non-contiguous MSR indices if we ever go beyond IA32_PMC14.

> +#define KVM_PMU_EVENT_FILTER_MAX_EVENTS                300
> +
> +#define GP_COUNTER_NR_OFS_BIT                          8
> +#define EVENT_LENGTH_OFS_BIT                           24
> +
> +#define PMU_VERSION_MASK                               GENMASK_ULL(7, 0)
> +#define EVENT_LENGTH_MASK                              GENMASK_ULL(31, E=
VENT_LENGTH_OFS_BIT)
> +#define GP_COUNTER_NR_MASK                             GENMASK_ULL(15, G=
P_COUNTER_NR_OFS_BIT)
> +#define FIXED_COUNTER_NR_MASK                          GENMASK_ULL(4, 0)
> +
> +#define ARCH_PERFMON_EVENTSEL_EVENT                    GENMASK_ULL(7, 0)
> +#define ARCH_PERFMON_EVENTSEL_UMASK                    GENMASK_ULL(15, 8=
)
> +#define ARCH_PERFMON_EVENTSEL_USR                      BIT_ULL(16)
> +#define ARCH_PERFMON_EVENTSEL_OS                       BIT_ULL(17)
> +#define ARCH_PERFMON_EVENTSEL_EDGE                     BIT_ULL(18)
> +#define ARCH_PERFMON_EVENTSEL_PIN_CONTROL              BIT_ULL(19)
> +#define ARCH_PERFMON_EVENTSEL_INT                      BIT_ULL(20)
> +#define ARCH_PERFMON_EVENTSEL_ANY                      BIT_ULL(21)
> +#define ARCH_PERFMON_EVENTSEL_ENABLE                   BIT_ULL(22)
> +#define ARCH_PERFMON_EVENTSEL_INV                      BIT_ULL(23)
> +#define ARCH_PERFMON_EVENTSEL_CMASK                    GENMASK_ULL(31, 2=
4)
> +
> +#define PMC_MAX_FIXED                                  16
> +#define PMC_IDX_FIXED                                  32
> +
> +/* RDPMC offset for Fixed PMCs */
> +#define PMC_FIXED_RDPMC_BASE                           BIT_ULL(30)
> +#define PMC_FIXED_RDPMC_METRICS                        BIT_ULL(29)
> +
> +#define FIXED_BITS_MASK                                0xFULL
> +#define FIXED_BITS_STRIDE                              4
> +#define FIXED_0_KERNEL                                 BIT_ULL(0)
> +#define FIXED_0_USER                                   BIT_ULL(1)
> +#define FIXED_0_ANYTHREAD                              BIT_ULL(2)
> +#define FIXED_0_ENABLE_PMI                             BIT_ULL(3)
> +
> +#define fixed_bits_by_idx(_idx, _bits)                 \
> +       ((_bits) << ((_idx) * FIXED_BITS_STRIDE))
> +
> +#define AMD64_NR_COUNTERS                              4
> +#define AMD64_NR_COUNTERS_CORE                         6
> +
> +#define PMU_CAP_FW_WRITES                              BIT_ULL(13)
> +#define PMU_CAP_LBR_FMT                                0x3f
> +
> +enum intel_pmu_architectural_events {
> +       /*
> +        * The order of the architectural events matters as support for e=
ach
> +        * event is enumerated via CPUID using the index of the event.
> +        */
> +       INTEL_ARCH_CPU_CYCLES,
> +       INTEL_ARCH_INSTRUCTIONS_RETIRED,
> +       INTEL_ARCH_REFERENCE_CYCLES,
> +       INTEL_ARCH_LLC_REFERENCES,
> +       INTEL_ARCH_LLC_MISSES,
> +       INTEL_ARCH_BRANCHES_RETIRED,
> +       INTEL_ARCH_BRANCHES_MISPREDICTED,
> +       NR_INTEL_ARCH_EVENTS,
> +};
> +
> +enum amd_pmu_k7_events {
> +       AMD_ZEN_CORE_CYCLES,
> +       AMD_ZEN_INSTRUCTIONS,
> +       AMD_ZEN_BRANCHES,
> +       AMD_ZEN_BRANCH_MISSES,
> +       NR_AMD_ARCH_EVENTS,
> +};
> +
> +extern const uint64_t intel_pmu_arch_events[];
> +extern const uint64_t amd_pmu_arch_events[];

AMD doesn't define *any* architectural events. Perhaps
amd_pmu_zen_events[], though who knows what Zen5 and  beyond will
bring?

> +extern const int intel_pmu_fixed_pmc_events[];
> +
> +#endif /* SELFTEST_KVM_PMU_H */
> diff --git a/tools/testing/selftests/kvm/lib/pmu.c b/tools/testing/selfte=
sts/kvm/lib/pmu.c
> new file mode 100644
> index 000000000000..27a6c35f98a1
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/pmu.c
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023, Tencent, Inc.
> + */
> +
> +#include <stdint.h>
> +
> +#include "pmu.h"
> +
> +/* Definitions for Architectural Performance Events */
> +#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) =
<< 8)

There's nothing architectural about this. Perhaps RAW_EVENT() for
consistency with perf?

> +
> +const uint64_t intel_pmu_arch_events[] =3D {
> +       [INTEL_ARCH_CPU_CYCLES]                 =3D ARCH_EVENT(0x3c, 0x0)=
,
> +       [INTEL_ARCH_INSTRUCTIONS_RETIRED]       =3D ARCH_EVENT(0xc0, 0x0)=
,
> +       [INTEL_ARCH_REFERENCE_CYCLES]           =3D ARCH_EVENT(0x3c, 0x1)=
,
> +       [INTEL_ARCH_LLC_REFERENCES]             =3D ARCH_EVENT(0x2e, 0x4f=
),
> +       [INTEL_ARCH_LLC_MISSES]                 =3D ARCH_EVENT(0x2e, 0x41=
),
> +       [INTEL_ARCH_BRANCHES_RETIRED]           =3D ARCH_EVENT(0xc4, 0x0)=
,
> +       [INTEL_ARCH_BRANCHES_MISPREDICTED]      =3D ARCH_EVENT(0xc5, 0x0)=
,

[INTEL_ARCH_TOPDOWN_SLOTS] =3D ARCH_EVENT(0xa4, 1),

> +};
> +
> +const uint64_t amd_pmu_arch_events[] =3D {
> +       [AMD_ZEN_CORE_CYCLES]                   =3D ARCH_EVENT(0x76, 0x00=
),
> +       [AMD_ZEN_INSTRUCTIONS]                  =3D ARCH_EVENT(0xc0, 0x00=
),
> +       [AMD_ZEN_BRANCHES]                      =3D ARCH_EVENT(0xc2, 0x00=
),
> +       [AMD_ZEN_BRANCH_MISSES]                 =3D ARCH_EVENT(0xc3, 0x00=
),
> +};
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b=
/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 283cc55597a4..b6e4f57a8651 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -11,31 +11,18 @@
>   */
>
>  #define _GNU_SOURCE /* for program_invocation_short_name */
> -#include "test_util.h"
> +
>  #include "kvm_util.h"
> +#include "pmu.h"
>  #include "processor.h"
> -
> -/*
> - * In lieu of copying perf_event.h into tools...
> - */
> -#define ARCH_PERFMON_EVENTSEL_OS                       (1ULL << 17)
> -#define ARCH_PERFMON_EVENTSEL_ENABLE                   (1ULL << 22)
> -
> -/* End of stuff taken from perf_event.h. */
> -
> -/* Oddly, this isn't in perf_event.h. */
> -#define ARCH_PERFMON_BRANCHES_RETIRED          5
> +#include "test_util.h"
>
>  #define NUM_BRANCHES 42
> -#define INTEL_PMC_IDX_FIXED            32
> -
> -/* Matches KVM_PMU_EVENT_FILTER_MAX_EVENTS in pmu.c */
> -#define MAX_FILTER_EVENTS              300
>  #define MAX_TEST_EVENTS                10
>
>  #define PMU_EVENT_FILTER_INVALID_ACTION                (KVM_PMU_EVENT_DE=
NY + 1)
>  #define PMU_EVENT_FILTER_INVALID_FLAGS                 (KVM_PMU_EVENT_FL=
AGS_VALID_MASK << 1)
> -#define PMU_EVENT_FILTER_INVALID_NEVENTS               (MAX_FILTER_EVENT=
S + 1)
> +#define PMU_EVENT_FILTER_INVALID_NEVENTS               (KVM_PMU_EVENT_FI=
LTER_MAX_EVENTS + 1)
>
>  /*
>   * This is how the event selector and unit mask are stored in an AMD
> @@ -63,7 +50,6 @@
>
>  #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)

Now AMD_ZEN_BRANCHES, above?

>
> -
>  /*
>   * "Retired instructions", from Processor Programming Reference
>   * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
> @@ -84,7 +70,7 @@ struct __kvm_pmu_event_filter {
>         __u32 fixed_counter_bitmap;
>         __u32 flags;
>         __u32 pad[4];
> -       __u64 events[MAX_FILTER_EVENTS];
> +       __u64 events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
>  };
>
>  /*
> @@ -729,14 +715,14 @@ static void add_dummy_events(uint64_t *events, int =
nevents)
>
>  static void test_masked_events(struct kvm_vcpu *vcpu)
>  {
> -       int nevents =3D MAX_FILTER_EVENTS - MAX_TEST_EVENTS;
> -       uint64_t events[MAX_FILTER_EVENTS];
> +       int nevents =3D KVM_PMU_EVENT_FILTER_MAX_EVENTS - MAX_TEST_EVENTS=
;
> +       uint64_t events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
>
>         /* Run the test cases against a sparse PMU event filter. */
>         run_masked_events_tests(vcpu, events, 0);
>
>         /* Run the test cases against a dense PMU event filter. */
> -       add_dummy_events(events, MAX_FILTER_EVENTS);
> +       add_dummy_events(events, KVM_PMU_EVENT_FILTER_MAX_EVENTS);
>         run_masked_events_tests(vcpu, events, nevents);
>  }
>
> @@ -818,7 +804,7 @@ static void intel_run_fixed_counter_guest_code(uint8_=
t fixed_ctr_idx)
>                 /* Only OS_EN bit is enabled for fixed counter[idx]. */
>                 wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * fixed_ctr=
_idx));
>                 wrmsr(MSR_CORE_PERF_GLOBAL_CTRL,
> -                     BIT_ULL(INTEL_PMC_IDX_FIXED + fixed_ctr_idx));
> +                     BIT_ULL(PMC_IDX_FIXED + fixed_ctr_idx));
>                 __asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES})=
);
>                 wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>
> --
> 2.42.0.869.gea05f2083d-goog
>

