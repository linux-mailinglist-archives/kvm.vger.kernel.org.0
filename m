Return-Path: <kvm+bounces-633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 162C07E1B00
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 08:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 765532813E5
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 07:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F39C8F7;
	Mon,  6 Nov 2023 07:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPPiMiXT"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4907CBE50
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 07:19:54 +0000 (UTC)
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0F0CC;
	Sun,  5 Nov 2023 23:19:52 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id 98e67ed59e1d1-2800bb246ceso3076820a91.1;
        Sun, 05 Nov 2023 23:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699255191; x=1699859991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=My7CqoZOB+eRXBk8/dw93V/H8Ii76LoKTE5qaEoy1n8=;
        b=JPPiMiXTBKuIMCC5oxlO3T0MyAqsoVmir9kpnH4qU6LmzOn8dPaLw7ptEqwd+NqoWM
         C3B5QbdHMGryaMmBzr0k0tdr3lk9XbeuEOqpUGtnBJ9SnArb9LaRWXM+2wkiwM20ipfa
         ZVvr2GxC6KoaXBwm7o4qmfHITFZk1JdbPa/3nGCT3mGYWLH+qu1C4s13uvTlt4i1Q6oE
         4mtomJ7/HphdHRl43ybqaWfOE2ycvhaM33RtLVQ5Kzaocwd6Y3vqqpmHlEUFd4Rjiual
         sZVUfQSoKWj4yFLQ6ipKXxR8jwCkM6MvkKaLlBii+e9FVsZiIXLLwx0GpKQa3ERu+5/S
         HAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699255191; x=1699859991;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=My7CqoZOB+eRXBk8/dw93V/H8Ii76LoKTE5qaEoy1n8=;
        b=HmNIi8l8ib0jN10bGZKIhBoqekCdjTJviCWgFe9lWnGk3SkMyfUWLbM3OySNSgWz2d
         7ArzJWCe1KL/agqKYC0Hc1HLfFnGUBzFx6A9Rn7myfmhj/hLa3MG5hHlu8VKhLKDaYc5
         V5GEZObkfgrR/noVmhy72g/79G6WX81D3uss2UWw0wGYtGOjqHh6Uw0AwahHOdd2EZp9
         UFexLVH4lJahiyovvktXwW8DqQdbAniOS8bVAOGpkhRGa9TnOP2o8c4EVr6IbpGL6D65
         eNeosy3dj+XPC7vwcDCLULmEUsSZS0mGCSEv8V56/1RisEjKK29eWfbjLUctTak7/Ay0
         mlFg==
X-Gm-Message-State: AOJu0YyitTI1BVFqsMHEOqEIvzSF0MlgRdc2eq5lxCuTAC5DWpqa6U9u
	s7hm/xE5rznWU4xggA87AO8=
X-Google-Smtp-Source: AGHT+IFEAnBPmdocHNbTlvhLW6mPldacfuJAxu8sqtvM+76CCJzVZYRgbJ94cwKypexPF2eOeGBGog==
X-Received: by 2002:a17:90b:4b11:b0:281:d55:6fe8 with SMTP id lx17-20020a17090b4b1100b002810d556fe8mr764396pjb.24.1699255191297;
        Sun, 05 Nov 2023 23:19:51 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090acb8700b0027d05817fcdsm4884991pju.0.2023.11.05.23.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Nov 2023 23:19:50 -0800 (PST)
Message-ID: <e704b8ef-7488-96f4-27a8-35af722d4a3f@gmail.com>
Date: Mon, 6 Nov 2023 15:19:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v6 09/20] KVM: selftests: Add pmu.h and lib/pmu.c for
 common PMU assets
To: Jim Mattson <jmattson@google.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Like Xu <likexu@tencent.com>,
 Aaron Lewis <aaronlewis@google.com>, Jinrong Liang <cloudliang@tencent.com>
References: <20231104000239.367005-1-seanjc@google.com>
 <20231104000239.367005-10-seanjc@google.com>
 <CALMp9eT22j2Ob9ihva41p2JRufR5P+xnzsm99LEd1quxnfCyWA@mail.gmail.com>
From: JinrongLiang <ljr.kernel@gmail.com>
In-Reply-To: <CALMp9eT22j2Ob9ihva41p2JRufR5P+xnzsm99LEd1quxnfCyWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2023/11/4 21:20, Jim Mattson 写道:
> On Fri, Nov 3, 2023 at 5:02 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> From: Jinrong Liang <cloudliang@tencent.com>
>>
>> By defining the PMU performance events and masks relevant for x86 in
>> the new pmu.h and pmu.c, it becomes easier to reference them, minimizing
>> potential errors in code that handles these values.
>>
>> Clean up pmu_event_filter_test.c by including pmu.h and removing
>> unnecessary macros.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
>> [sean: drop PSEUDO_ARCH_REFERENCE_CYCLES]
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   tools/testing/selftests/kvm/Makefile          |  1 +
>>   tools/testing/selftests/kvm/include/pmu.h     | 84 +++++++++++++++++++
>>   tools/testing/selftests/kvm/lib/pmu.c         | 28 +++++++
>>   .../kvm/x86_64/pmu_event_filter_test.c        | 32 ++-----
>>   4 files changed, 122 insertions(+), 23 deletions(-)
>>   create mode 100644 tools/testing/selftests/kvm/include/pmu.h
>>   create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
>>
>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>> index a5963ab9215b..44d8d022b023 100644
>> --- a/tools/testing/selftests/kvm/Makefile
>> +++ b/tools/testing/selftests/kvm/Makefile
>> @@ -32,6 +32,7 @@ LIBKVM += lib/guest_modes.c
>>   LIBKVM += lib/io.c
>>   LIBKVM += lib/kvm_util.c
>>   LIBKVM += lib/memstress.c
>> +LIBKVM += lib/pmu.c
>>   LIBKVM += lib/guest_sprintf.c
>>   LIBKVM += lib/rbtree.c
>>   LIBKVM += lib/sparsebit.c
>> diff --git a/tools/testing/selftests/kvm/include/pmu.h b/tools/testing/selftests/kvm/include/pmu.h
>> new file mode 100644
>> index 000000000000..987602c62b51
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/include/pmu.h
>> @@ -0,0 +1,84 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2023, Tencent, Inc.
>> + */
>> +#ifndef SELFTEST_KVM_PMU_H
>> +#define SELFTEST_KVM_PMU_H
>> +
>> +#include <stdint.h>
>> +
>> +#define X86_PMC_IDX_MAX                                64
>> +#define INTEL_PMC_MAX_GENERIC                          32
> 
> I think this is actually 15. Note that IA32_PMC0 through IA32_PMC7
> have MSR indices from 0xc1 through 0xc8, and MSR 0xcf is
> IA32_CORE_CAPABILITIES. At the very least, we have to handle
> non-contiguous MSR indices if we ever go beyond IA32_PMC14.
> 
>> +#define KVM_PMU_EVENT_FILTER_MAX_EVENTS                300
>> +
>> +#define GP_COUNTER_NR_OFS_BIT                          8
>> +#define EVENT_LENGTH_OFS_BIT                           24
>> +
>> +#define PMU_VERSION_MASK                               GENMASK_ULL(7, 0)
>> +#define EVENT_LENGTH_MASK                              GENMASK_ULL(31, EVENT_LENGTH_OFS_BIT)
>> +#define GP_COUNTER_NR_MASK                             GENMASK_ULL(15, GP_COUNTER_NR_OFS_BIT)
>> +#define FIXED_COUNTER_NR_MASK                          GENMASK_ULL(4, 0)
>> +
>> +#define ARCH_PERFMON_EVENTSEL_EVENT                    GENMASK_ULL(7, 0)
>> +#define ARCH_PERFMON_EVENTSEL_UMASK                    GENMASK_ULL(15, 8)
>> +#define ARCH_PERFMON_EVENTSEL_USR                      BIT_ULL(16)
>> +#define ARCH_PERFMON_EVENTSEL_OS                       BIT_ULL(17)
>> +#define ARCH_PERFMON_EVENTSEL_EDGE                     BIT_ULL(18)
>> +#define ARCH_PERFMON_EVENTSEL_PIN_CONTROL              BIT_ULL(19)
>> +#define ARCH_PERFMON_EVENTSEL_INT                      BIT_ULL(20)
>> +#define ARCH_PERFMON_EVENTSEL_ANY                      BIT_ULL(21)
>> +#define ARCH_PERFMON_EVENTSEL_ENABLE                   BIT_ULL(22)
>> +#define ARCH_PERFMON_EVENTSEL_INV                      BIT_ULL(23)
>> +#define ARCH_PERFMON_EVENTSEL_CMASK                    GENMASK_ULL(31, 24)
>> +
>> +#define PMC_MAX_FIXED                                  16
>> +#define PMC_IDX_FIXED                                  32
>> +
>> +/* RDPMC offset for Fixed PMCs */
>> +#define PMC_FIXED_RDPMC_BASE                           BIT_ULL(30)
>> +#define PMC_FIXED_RDPMC_METRICS                        BIT_ULL(29)
>> +
>> +#define FIXED_BITS_MASK                                0xFULL
>> +#define FIXED_BITS_STRIDE                              4
>> +#define FIXED_0_KERNEL                                 BIT_ULL(0)
>> +#define FIXED_0_USER                                   BIT_ULL(1)
>> +#define FIXED_0_ANYTHREAD                              BIT_ULL(2)
>> +#define FIXED_0_ENABLE_PMI                             BIT_ULL(3)
>> +
>> +#define fixed_bits_by_idx(_idx, _bits)                 \
>> +       ((_bits) << ((_idx) * FIXED_BITS_STRIDE))
>> +
>> +#define AMD64_NR_COUNTERS                              4
>> +#define AMD64_NR_COUNTERS_CORE                         6
>> +
>> +#define PMU_CAP_FW_WRITES                              BIT_ULL(13)
>> +#define PMU_CAP_LBR_FMT                                0x3f
>> +
>> +enum intel_pmu_architectural_events {
>> +       /*
>> +        * The order of the architectural events matters as support for each
>> +        * event is enumerated via CPUID using the index of the event.
>> +        */
>> +       INTEL_ARCH_CPU_CYCLES,
>> +       INTEL_ARCH_INSTRUCTIONS_RETIRED,
>> +       INTEL_ARCH_REFERENCE_CYCLES,
>> +       INTEL_ARCH_LLC_REFERENCES,
>> +       INTEL_ARCH_LLC_MISSES,
>> +       INTEL_ARCH_BRANCHES_RETIRED,
>> +       INTEL_ARCH_BRANCHES_MISPREDICTED,
>> +       NR_INTEL_ARCH_EVENTS,
>> +};
>> +
>> +enum amd_pmu_k7_events {
>> +       AMD_ZEN_CORE_CYCLES,
>> +       AMD_ZEN_INSTRUCTIONS,
>> +       AMD_ZEN_BRANCHES,
>> +       AMD_ZEN_BRANCH_MISSES,
>> +       NR_AMD_ARCH_EVENTS,
>> +};
>> +
>> +extern const uint64_t intel_pmu_arch_events[];
>> +extern const uint64_t amd_pmu_arch_events[];
> 
> AMD doesn't define *any* architectural events. Perhaps
> amd_pmu_zen_events[], though who knows what Zen5 and  beyond will
> bring?
> 
>> +extern const int intel_pmu_fixed_pmc_events[];
>> +
>> +#endif /* SELFTEST_KVM_PMU_H */
>> diff --git a/tools/testing/selftests/kvm/lib/pmu.c b/tools/testing/selftests/kvm/lib/pmu.c
>> new file mode 100644
>> index 000000000000..27a6c35f98a1
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/lib/pmu.c
>> @@ -0,0 +1,28 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2023, Tencent, Inc.
>> + */
>> +
>> +#include <stdint.h>
>> +
>> +#include "pmu.h"
>> +
>> +/* Definitions for Architectural Performance Events */
>> +#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
> 
> There's nothing architectural about this. Perhaps RAW_EVENT() for
> consistency with perf?
> 
>> +
>> +const uint64_t intel_pmu_arch_events[] = {
>> +       [INTEL_ARCH_CPU_CYCLES]                 = ARCH_EVENT(0x3c, 0x0),
>> +       [INTEL_ARCH_INSTRUCTIONS_RETIRED]       = ARCH_EVENT(0xc0, 0x0),
>> +       [INTEL_ARCH_REFERENCE_CYCLES]           = ARCH_EVENT(0x3c, 0x1),
>> +       [INTEL_ARCH_LLC_REFERENCES]             = ARCH_EVENT(0x2e, 0x4f),
>> +       [INTEL_ARCH_LLC_MISSES]                 = ARCH_EVENT(0x2e, 0x41),
>> +       [INTEL_ARCH_BRANCHES_RETIRED]           = ARCH_EVENT(0xc4, 0x0),
>> +       [INTEL_ARCH_BRANCHES_MISPREDICTED]      = ARCH_EVENT(0xc5, 0x0),
> 
> [INTEL_ARCH_TOPDOWN_SLOTS] = ARCH_EVENT(0xa4, 1),
> 
>> +};
>> +
>> +const uint64_t amd_pmu_arch_events[] = {
>> +       [AMD_ZEN_CORE_CYCLES]                   = ARCH_EVENT(0x76, 0x00),
>> +       [AMD_ZEN_INSTRUCTIONS]                  = ARCH_EVENT(0xc0, 0x00),
>> +       [AMD_ZEN_BRANCHES]                      = ARCH_EVENT(0xc2, 0x00),
>> +       [AMD_ZEN_BRANCH_MISSES]                 = ARCH_EVENT(0xc3, 0x00),
>> +};
>> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
>> index 283cc55597a4..b6e4f57a8651 100644
>> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
>> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
>> @@ -11,31 +11,18 @@
>>    */
>>
>>   #define _GNU_SOURCE /* for program_invocation_short_name */
>> -#include "test_util.h"
>> +
>>   #include "kvm_util.h"
>> +#include "pmu.h"
>>   #include "processor.h"
>> -
>> -/*
>> - * In lieu of copying perf_event.h into tools...
>> - */
>> -#define ARCH_PERFMON_EVENTSEL_OS                       (1ULL << 17)
>> -#define ARCH_PERFMON_EVENTSEL_ENABLE                   (1ULL << 22)
>> -
>> -/* End of stuff taken from perf_event.h. */
>> -
>> -/* Oddly, this isn't in perf_event.h. */
>> -#define ARCH_PERFMON_BRANCHES_RETIRED          5
>> +#include "test_util.h"
>>
>>   #define NUM_BRANCHES 42
>> -#define INTEL_PMC_IDX_FIXED            32
>> -
>> -/* Matches KVM_PMU_EVENT_FILTER_MAX_EVENTS in pmu.c */
>> -#define MAX_FILTER_EVENTS              300
>>   #define MAX_TEST_EVENTS                10
>>
>>   #define PMU_EVENT_FILTER_INVALID_ACTION                (KVM_PMU_EVENT_DENY + 1)
>>   #define PMU_EVENT_FILTER_INVALID_FLAGS                 (KVM_PMU_EVENT_FLAGS_VALID_MASK << 1)
>> -#define PMU_EVENT_FILTER_INVALID_NEVENTS               (MAX_FILTER_EVENTS + 1)
>> +#define PMU_EVENT_FILTER_INVALID_NEVENTS               (KVM_PMU_EVENT_FILTER_MAX_EVENTS + 1)
>>
>>   /*
>>    * This is how the event selector and unit mask are stored in an AMD
>> @@ -63,7 +50,6 @@
>>
>>   #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
> 
> Now AMD_ZEN_BRANCHES, above?

Yes, I forgot to replace INTEL_BR_RETIRED, AMD_ZEN_BR_RETIRED and 
INST_RETIRED in pmu_event_filter_test.c and remove their macro definitions.

Thanks,

Jinrong

> 
>>
>> -
>>   /*
>>    * "Retired instructions", from Processor Programming Reference
>>    * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
>> @@ -84,7 +70,7 @@ struct __kvm_pmu_event_filter {
>>          __u32 fixed_counter_bitmap;
>>          __u32 flags;
>>          __u32 pad[4];
>> -       __u64 events[MAX_FILTER_EVENTS];
>> +       __u64 events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
>>   };
>>
>>   /*
>> @@ -729,14 +715,14 @@ static void add_dummy_events(uint64_t *events, int nevents)
>>
>>   static void test_masked_events(struct kvm_vcpu *vcpu)
>>   {
>> -       int nevents = MAX_FILTER_EVENTS - MAX_TEST_EVENTS;
>> -       uint64_t events[MAX_FILTER_EVENTS];
>> +       int nevents = KVM_PMU_EVENT_FILTER_MAX_EVENTS - MAX_TEST_EVENTS;
>> +       uint64_t events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
>>
>>          /* Run the test cases against a sparse PMU event filter. */
>>          run_masked_events_tests(vcpu, events, 0);
>>
>>          /* Run the test cases against a dense PMU event filter. */
>> -       add_dummy_events(events, MAX_FILTER_EVENTS);
>> +       add_dummy_events(events, KVM_PMU_EVENT_FILTER_MAX_EVENTS);
>>          run_masked_events_tests(vcpu, events, nevents);
>>   }
>>
>> @@ -818,7 +804,7 @@ static void intel_run_fixed_counter_guest_code(uint8_t fixed_ctr_idx)
>>                  /* Only OS_EN bit is enabled for fixed counter[idx]. */
>>                  wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * fixed_ctr_idx));
>>                  wrmsr(MSR_CORE_PERF_GLOBAL_CTRL,
>> -                     BIT_ULL(INTEL_PMC_IDX_FIXED + fixed_ctr_idx));
>> +                     BIT_ULL(PMC_IDX_FIXED + fixed_ctr_idx));
>>                  __asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
>>                  wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>>
>> --
>> 2.42.0.869.gea05f2083d-goog
>>


