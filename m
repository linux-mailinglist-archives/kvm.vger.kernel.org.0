Return-Path: <kvm+bounces-818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C9457E2E54
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 21:41:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 110B2280D3E
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 20:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF122C867;
	Mon,  6 Nov 2023 20:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qdgyepgs"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5623F29CF6
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 20:40:51 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9E3D76
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 12:40:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da04776a869so4792943276.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 12:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699303248; x=1699908048; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QM6qohx+9oIaDINhDMHJi+mlZHqH6wIQjqhKc0eFioU=;
        b=qdgyepgsC1uQsu8K6jagR9wMhTO9+kSU4Npm9zYlQkXoCqsyhtNkBVqaHtum67VK8b
         TJqm/wPAAjv5ql6Rq8i0lHitMqDO6CV31/qrm/cQwbkbHt2yuKPdgYxkeOUCCzYAVOLU
         1wwzJKp+4z698MgL2GCcfWWfOu9kIPAdCg1+da8Dl6+dVFRU0NxmgPmM2Sb/NhV1FrE0
         wxkzsDlOJnWQa9m13huoxnaLhvQzLYc7houL1QX+jseWrqHwlmvIHEjY8VyXDHD+4Wy6
         aNuY3Dk12pJcMaGL2Y9ONRLkfJSF+vFEdi+M+fXZrjAH7sHcm3Jz0fsfLLsokzOMK2X+
         G7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699303248; x=1699908048;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QM6qohx+9oIaDINhDMHJi+mlZHqH6wIQjqhKc0eFioU=;
        b=Ec54HFewkmxZk262NpUUELyZTUP0gP8rGK1PPAHrKXxEHdI5cdXFOZeGv+NjOmLne4
         7t1y8lXL8lJ/Eq99+Tq3LzVu2OlJR453rjWV+2WeBn6qWb+IYIyTQWu2nbgdA1d3+mr9
         eF9Dt6su0mm6jgZ3d/tzo3sixYtFu4pqGfE4NM3CLIIRuRZm7yErC7BaOa/KddMdSiKX
         7+KfXvJ/kVqQGT/xUBtqujMn6IiSThvF2ApyzAGTo0rR1VrngrAeQn84axwxYG1cBGkF
         66jZFqSOwlH8BkLN14K1FXD1F5+S9fNsIE5W+bpFWrFwCmXlSKrvlgvoDdK1QATj3qNk
         641Q==
X-Gm-Message-State: AOJu0YzTwIbYb2nL0YBtFQo1kb0c/dNaPlBJCN97pCc16uuL0lnuI+l7
	PdusBR+i/6fdgQqwqcw2xrqELl/qTjo=
X-Google-Smtp-Source: AGHT+IHGJZTr+99CoJv+V3lEztsrN7CAj3K+6E8B3GoxKxb99wPAZ63dCisQjnrepys1EZ9IpsYWpym6TAQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1788:b0:da0:c9a5:b529 with SMTP id
 ca8-20020a056902178800b00da0c9a5b529mr556213ybb.12.1699303248740; Mon, 06 Nov
 2023 12:40:48 -0800 (PST)
Date: Mon, 6 Nov 2023 12:40:47 -0800
In-Reply-To: <e704b8ef-7488-96f4-27a8-35af722d4a3f@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-10-seanjc@google.com>
 <CALMp9eT22j2Ob9ihva41p2JRufR5P+xnzsm99LEd1quxnfCyWA@mail.gmail.com> <e704b8ef-7488-96f4-27a8-35af722d4a3f@gmail.com>
Message-ID: <ZUlPT6ed5d0FCLYL@google.com>
Subject: Re: [PATCH v6 09/20] KVM: selftests: Add pmu.h and lib/pmu.c for
 common PMU assets
From: Sean Christopherson <seanjc@google.com>
To: JinrongLiang <ljr.kernel@gmail.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Jinrong Liang <cloudliang@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 06, 2023, JinrongLiang wrote:
> =E5=9C=A8 2023/11/4 21:20, Jim Mattson =E5=86=99=E9=81=93:
> > > diff --git a/tools/testing/selftests/kvm/include/pmu.h b/tools/testin=
g/selftests/kvm/include/pmu.h
> > > new file mode 100644
> > > index 000000000000..987602c62b51
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/include/pmu.h
> > > @@ -0,0 +1,84 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +/*
> > > + * Copyright (C) 2023, Tencent, Inc.
> > > + */
> > > +#ifndef SELFTEST_KVM_PMU_H
> > > +#define SELFTEST_KVM_PMU_H
> > > +
> > > +#include <stdint.h>
> > > +
> > > +#define X86_PMC_IDX_MAX                                64
> > > +#define INTEL_PMC_MAX_GENERIC                          32
> >=20
> > I think this is actually 15. Note that IA32_PMC0 through IA32_PMC7
> > have MSR indices from 0xc1 through 0xc8, and MSR 0xcf is
> > IA32_CORE_CAPABILITIES. At the very least, we have to handle
> > non-contiguous MSR indices if we ever go beyond IA32_PMC14.

There's no reason to define this, it's not used in selftests.

> > > +#define KVM_PMU_EVENT_FILTER_MAX_EVENTS                300
> > > +
> > > +#define GP_COUNTER_NR_OFS_BIT                          8
> > > +#define EVENT_LENGTH_OFS_BIT                           24
> > > +
> > > +#define PMU_VERSION_MASK                               GENMASK_ULL(7=
, 0)
> > > +#define EVENT_LENGTH_MASK                              GENMASK_ULL(3=
1, EVENT_LENGTH_OFS_BIT)
> > > +#define GP_COUNTER_NR_MASK                             GENMASK_ULL(1=
5, GP_COUNTER_NR_OFS_BIT)
> > > +#define FIXED_COUNTER_NR_MASK                          GENMASK_ULL(4=
, 0)

These are also unneeded, they're superseded by CPUID properties.

> > > +#define ARCH_PERFMON_EVENTSEL_EVENT                    GENMASK_ULL(7=
, 0)
> > > +#define ARCH_PERFMON_EVENTSEL_UMASK                    GENMASK_ULL(1=
5, 8)
> > > +#define ARCH_PERFMON_EVENTSEL_USR                      BIT_ULL(16)
> > > +#define ARCH_PERFMON_EVENTSEL_OS                       BIT_ULL(17)
> > > +#define ARCH_PERFMON_EVENTSEL_EDGE                     BIT_ULL(18)
> > > +#define ARCH_PERFMON_EVENTSEL_PIN_CONTROL              BIT_ULL(19)
> > > +#define ARCH_PERFMON_EVENTSEL_INT                      BIT_ULL(20)
> > > +#define ARCH_PERFMON_EVENTSEL_ANY                      BIT_ULL(21)
> > > +#define ARCH_PERFMON_EVENTSEL_ENABLE                   BIT_ULL(22)
> > > +#define ARCH_PERFMON_EVENTSEL_INV                      BIT_ULL(23)
> > > +#define ARCH_PERFMON_EVENTSEL_CMASK                    GENMASK_ULL(3=
1, 24)
> > > +
> > > +#define PMC_MAX_FIXED                                  16

Also unneeded.

> > > +#define PMC_IDX_FIXED                                  32

This one is absolutely ridiculous.  It's the shift for the enable bit in gl=
obal
control, which is super obvious from the name. /s

> > > +
> > > +/* RDPMC offset for Fixed PMCs */
> > > +#define PMC_FIXED_RDPMC_BASE                           BIT_ULL(30)
> > > +#define PMC_FIXED_RDPMC_METRICS                        BIT_ULL(29)
> > > +
> > > +#define FIXED_BITS_MASK                                0xFULL
> > > +#define FIXED_BITS_STRIDE                              4
> > > +#define FIXED_0_KERNEL                                 BIT_ULL(0)
> > > +#define FIXED_0_USER                                   BIT_ULL(1)
> > > +#define FIXED_0_ANYTHREAD                              BIT_ULL(2)
> > > +#define FIXED_0_ENABLE_PMI                             BIT_ULL(3)
> > > +
> > > +#define fixed_bits_by_idx(_idx, _bits)                 \
> > > +       ((_bits) << ((_idx) * FIXED_BITS_STRIDE))

*sigh*  And now I see where the "i * 4" stuff in the new test comes from.  =
My
plan is to redo the above as:

/* RDPMC offset for Fixed PMCs */
#define FIXED_PMC_RDPMC_METRICS			BIT_ULL(29)
#define FIXED_PMC_RDPMC_BASE			BIT_ULL(30)

#define FIXED_PMC_GLOBAL_CTRL_ENABLE(_idx)	BIT_ULL((32 + (_idx)))

#define FIXED_PMC_KERNEL			BIT_ULL(0)
#define FIXED_PMC_USER				BIT_ULL(1)
#define FIXED_PMC_ANYTHREAD			BIT_ULL(2)
#define FIXED_PMC_ENABLE_PMI			BIT_ULL(3)
#define FIXED_PMC_NR_BITS			4
#define FIXED_PMC_CTRL(_idx, _val)		((_val) << ((_idx) * FIXED_PMC_NR_BITS)=
)

> > > +#define AMD64_NR_COUNTERS                              4
> > > +#define AMD64_NR_COUNTERS_CORE                         6

These too can be dropped for now.

> > > +#define PMU_CAP_FW_WRITES                              BIT_ULL(13)
> > > +#define PMU_CAP_LBR_FMT                                0x3f
> > > +
> > > +enum intel_pmu_architectural_events {
> > > +       /*
> > > +        * The order of the architectural events matters as support f=
or each
> > > +        * event is enumerated via CPUID using the index of the event=
.
> > > +        */
> > > +       INTEL_ARCH_CPU_CYCLES,
> > > +       INTEL_ARCH_INSTRUCTIONS_RETIRED,
> > > +       INTEL_ARCH_REFERENCE_CYCLES,
> > > +       INTEL_ARCH_LLC_REFERENCES,
> > > +       INTEL_ARCH_LLC_MISSES,
> > > +       INTEL_ARCH_BRANCHES_RETIRED,
> > > +       INTEL_ARCH_BRANCHES_MISPREDICTED,
> > > +       NR_INTEL_ARCH_EVENTS,
> > > +};
> > > +
> > > +enum amd_pmu_k7_events {
> > > +       AMD_ZEN_CORE_CYCLES,
> > > +       AMD_ZEN_INSTRUCTIONS,
> > > +       AMD_ZEN_BRANCHES,
> > > +       AMD_ZEN_BRANCH_MISSES,
> > > +       NR_AMD_ARCH_EVENTS,
> > > +};
> > > +
> > > +extern const uint64_t intel_pmu_arch_events[];
> > > +extern const uint64_t amd_pmu_arch_events[];
> >=20
> > AMD doesn't define *any* architectural events. Perhaps
> > amd_pmu_zen_events[], though who knows what Zen5 and  beyond will
> > bring?
> >=20
> > > +extern const int intel_pmu_fixed_pmc_events[];
> > > +
> > > +#endif /* SELFTEST_KVM_PMU_H */
> > > diff --git a/tools/testing/selftests/kvm/lib/pmu.c b/tools/testing/se=
lftests/kvm/lib/pmu.c
> > > new file mode 100644
> > > index 000000000000..27a6c35f98a1
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/lib/pmu.c
> > > @@ -0,0 +1,28 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Copyright (C) 2023, Tencent, Inc.
> > > + */
> > > +
> > > +#include <stdint.h>
> > > +
> > > +#include "pmu.h"
> > > +
> > > +/* Definitions for Architectural Performance Events */
> > > +#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0x=
ff) << 8)
> >=20
> > There's nothing architectural about this. Perhaps RAW_EVENT() for
> > consistency with perf?

Works for me.

> > > +const uint64_t intel_pmu_arch_events[] =3D {
> > > +       [INTEL_ARCH_CPU_CYCLES]                 =3D ARCH_EVENT(0x3c, =
0x0),
> > > +       [INTEL_ARCH_INSTRUCTIONS_RETIRED]       =3D ARCH_EVENT(0xc0, =
0x0),
> > > +       [INTEL_ARCH_REFERENCE_CYCLES]           =3D ARCH_EVENT(0x3c, =
0x1),
> > > +       [INTEL_ARCH_LLC_REFERENCES]             =3D ARCH_EVENT(0x2e, =
0x4f),
> > > +       [INTEL_ARCH_LLC_MISSES]                 =3D ARCH_EVENT(0x2e, =
0x41),
> > > +       [INTEL_ARCH_BRANCHES_RETIRED]           =3D ARCH_EVENT(0xc4, =
0x0),
> > > +       [INTEL_ARCH_BRANCHES_MISPREDICTED]      =3D ARCH_EVENT(0xc5, =
0x0),
> >=20
> > [INTEL_ARCH_TOPDOWN_SLOTS] =3D ARCH_EVENT(0xa4, 1),

...

> > > @@ -63,7 +50,6 @@
> > >=20
> > >   #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
> >=20
> > Now AMD_ZEN_BRANCHES, above?
>=20
> Yes, I forgot to replace INTEL_BR_RETIRED, AMD_ZEN_BR_RETIRED and
> INST_RETIRED in pmu_event_filter_test.c and remove their macro definition=
s.

Having to go through an array to get a hardcoded value is silly, e.g. it ma=
kes
it unnecessarily difficult to reference the encodings because they aren't s=
imple
literals.

My vote is this:

#define	INTEL_ARCH_CPU_CYCLES			RAW_EVENT(0x3c, 0x00)
#define	INTEL_ARCH_INSTRUCTIONS_RETIRED		RAW_EVENT(0xc0, 0x00)
#define	INTEL_ARCH_REFERENCE_CYCLES		RAW_EVENT(0x3c, 0x01)
#define	INTEL_ARCH_LLC_REFERENCES		RAW_EVENT(0x2e, 0x4f)
#define	INTEL_ARCH_LLC_MISSES			RAW_EVENT(0x2e, 0x41)
#define	INTEL_ARCH_BRANCHES_RETIRED		RAW_EVENT(0xc4, 0x00)
#define	INTEL_ARCH_BRANCHES_MISPREDICTED	RAW_EVENT(0xc5, 0x00)
#define	INTEL_ARCH_TOPDOWN_SLOTS		RAW_EVENT(0xa4, 0x01)

#define	AMD_ZEN_CORE_CYCLES			RAW_EVENT(0x76, 0x00)
#define	AMD_ZEN_INSTRUCTIONS_RETIRED		RAW_EVENT(0xc0, 0x00)
#define	AMD_ZEN_BRANCHES_RETIRED		RAW_EVENT(0xc2, 0x00)
#define	AMD_ZEN_BRANCHES_MISPREDICTED		RAW_EVENT(0xc3, 0x00)

/*
 * Note!  The order and thus the index of the architectural events matters =
as
 * support for each event is enumerated via CPUID using the index of the ev=
ent.
 */
enum intel_pmu_architectural_events {
	INTEL_ARCH_CPU_CYCLES_INDEX,
	INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX,
	INTEL_ARCH_REFERENCE_CYCLES_INDEX,
	INTEL_ARCH_LLC_REFERENCES_INDEX,
	INTEL_ARCH_LLC_MISSES_INDEX,
	INTEL_ARCH_BRANCHES_RETIRED_INDEX,
	INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX,
	INTEL_ARCH_TOPDOWN_SLOTS_INDEX,
	NR_INTEL_ARCH_EVENTS,
};

enum amd_pmu_zen_events {
	AMD_ZEN_CORE_CYCLES_INDEX,
	AMD_ZEN_INSTRUCTIONS_INDEX,
	AMD_ZEN_BRANCHES_INDEX,
	AMD_ZEN_BRANCH_MISSES_INDEX,
	NR_AMD_ZEN_EVENTS,
};

extern const uint64_t intel_pmu_arch_events[];
extern const uint64_t amd_pmu_zen_events[];

...


const uint64_t intel_pmu_arch_events[] =3D {
	INTEL_ARCH_CPU_CYCLES,
	INTEL_ARCH_INSTRUCTIONS_RETIRED,
	INTEL_ARCH_REFERENCE_CYCLES,
	INTEL_ARCH_LLC_REFERENCES,
	INTEL_ARCH_LLC_MISSES,
	INTEL_ARCH_BRANCHES_RETIRED,
	INTEL_ARCH_BRANCHES_MISPREDICTED,
	INTEL_ARCH_TOPDOWN_SLOTS,
};
kvm_static_assert(ARRAY_SIZE(intel_pmu_arch_events) =3D=3D NR_INTEL_ARCH_EV=
ENTS);

const uint64_t amd_pmu_zen_events[] =3D {
	AMD_ZEN_CORE_CYCLES,
	AMD_ZEN_INSTRUCTIONS_RETIRED,
	AMD_ZEN_BRANCHES_RETIRED,
	AMD_ZEN_BRANCHES_MISPREDICTED,
};
kvm_static_assert(ARRAY_SIZE(amd_pmu_zen_events) =3D=3D NR_AMD_ZEN_EVENTS);

