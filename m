Return-Path: <kvm+bounces-585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D47287E0FA2
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 14:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A9B7B211C1
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 13:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0431A595;
	Sat,  4 Nov 2023 13:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QQynLCMV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E412919BCD
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 13:47:04 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46695123
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 06:47:01 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so6903a12.0
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 06:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699105620; x=1699710420; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4IHCSGPafA533OwSQMvLmdn1gOAi+VivQ/tQHnAD4YM=;
        b=QQynLCMVkSQV/bd6YxXpo6c31vN+LwGCif2gA1Oj4S9Bkiurc04h1JHpmHz2o/0hku
         OikfYe397/kFs2z01juum2+29U5dcqZ8J0LeErkm22fIMrCDkE16YBEgNN57l6XHggzx
         wQxvRwtCwNOnBatR+D19BGriFzN6szIOdIIqGNlALt/M0cHwEe88mhZUvAzEpl2u6ywH
         KuS5Jj3It5s6lgHtTdgyQzifEJZsT901oRAeXgI+F7h2R3NEmO8s98nnm+kCZAGAE9AI
         rtzg3WtuMFrQaFK1GhSnnu+rwWLGY05t5S6ouYBFrWA4+zAKfuyO8xThKbu0lYcxZz0+
         WeMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699105620; x=1699710420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4IHCSGPafA533OwSQMvLmdn1gOAi+VivQ/tQHnAD4YM=;
        b=WN05TNQ7FofWc1A+s2e7ywiG9PyHem7rug14H7WcHfBrebvqaZ+bMOtk6TRBMaXS3V
         jDsMEOSbnRcu0cgeOH6tnabkYEOfI3tN+Lct8pOQzzChDAwSU8MKXIn3/1F1H4yB23C6
         26JeOtF3YgNDqU7ufPZaOmNosHsn1sQKMCLFu3DjR96yicQ7yq7JH96vwq0be800OnGM
         Ck85q+P+ryawZAfDFtK7CLVJLssoJHvxRoHfSN5lU4BKNSaB8ZEskxAgzsHGgD7cRAYf
         iwg9baAdJvT6obn0PbzB7u4BJ8G4Bfd8GyR+NbPmhGdYaNMWLYZbQmU3w/NVOm29mPwJ
         dVTA==
X-Gm-Message-State: AOJu0YyDKqQUCSyvoUAgJNRFdAj/QtRD8yFyXZF3F0gZLE7vX5V6SQNy
	Je4PwktcdXxyeRIGv/OY95MfAwd4TVRc2O9wxKrmQg==
X-Google-Smtp-Source: AGHT+IFaVde2Gf94YPNr+N0q3kInBq+p4YM2sodMiHoaQSi/+7/LRhAwIntGJW/An950O0h3ikxJNbofivIKcnnZca8=
X-Received: by 2002:a50:8757:0:b0:544:24a8:ebd with SMTP id
 23-20020a508757000000b0054424a80ebdmr80217edv.4.1699105619567; Sat, 04 Nov
 2023 06:46:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-12-seanjc@google.com>
In-Reply-To: <20231104000239.367005-12-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Sat, 4 Nov 2023 06:46:42 -0700
Message-ID: <CALMp9eRzvj_Ach=QySHgpkKO6z=42OJmC4DPU=tCTxcioFvZEw@mail.gmail.com>
Subject: Re: [PATCH v6 11/20] KVM: selftests: Test Intel PMU architectural
 events on fixed counters
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 5:03=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> From: Jinrong Liang <cloudliang@tencent.com>
>
> Extend the PMU counters test to validate architectural events using fixed
> counters.  The core logic is largely the same, the biggest difference
> being that if a fixed counter exists, its associated event is available
> (the SDM doesn't explicitly state this to be true, but it's KVM's ABI and
> letting software program a fixed counter that doesn't actually count woul=
d
> be quite bizarre).
>
> Note, fixed counters rely on PERF_GLOBAL_CTRL.
>
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Jim Mattson <jmattson@google.com>

> ---
>  .../selftests/kvm/x86_64/pmu_counters_test.c  | 53 ++++++++++++++++---
>  1 file changed, 45 insertions(+), 8 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/too=
ls/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index dd9a7864410c..4d3a5c94b8ba 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -150,25 +150,46 @@ static void __guest_test_arch_event(uint8_t idx, st=
ruct kvm_x86_pmu_feature even
>         guest_assert_event_count(idx, event, pmc, pmc_msr);
>  }
>
> +#define X86_PMU_FEATURE_NULL                                           \
> +({                                                                     \
> +       struct kvm_x86_pmu_feature feature =3D {};                       =
 \
> +                                                                       \
> +       feature;                                                        \
> +})
> +
> +static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
> +{
> +       return !(*(u64 *)&event);
> +}
> +
>  static void guest_test_arch_event(uint8_t idx)
>  {
>         const struct {
>                 struct kvm_x86_pmu_feature gp_event;
> +               struct kvm_x86_pmu_feature fixed_event;
>         } intel_event_to_feature[] =3D {
> -               [INTEL_ARCH_CPU_CYCLES]            =3D { X86_PMU_FEATURE_=
CPU_CYCLES },
> -               [INTEL_ARCH_INSTRUCTIONS_RETIRED]  =3D { X86_PMU_FEATURE_=
INSNS_RETIRED },
> -               [INTEL_ARCH_REFERENCE_CYCLES]      =3D { X86_PMU_FEATURE_=
REFERENCE_CYCLES },
> -               [INTEL_ARCH_LLC_REFERENCES]        =3D { X86_PMU_FEATURE_=
LLC_REFERENCES },
> -               [INTEL_ARCH_LLC_MISSES]            =3D { X86_PMU_FEATURE_=
LLC_MISSES },
> -               [INTEL_ARCH_BRANCHES_RETIRED]      =3D { X86_PMU_FEATURE_=
BRANCH_INSNS_RETIRED },
> -               [INTEL_ARCH_BRANCHES_MISPREDICTED] =3D { X86_PMU_FEATURE_=
BRANCHES_MISPREDICTED },
> +               [INTEL_ARCH_CPU_CYCLES]            =3D { X86_PMU_FEATURE_=
CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
> +               [INTEL_ARCH_INSTRUCTIONS_RETIRED]  =3D { X86_PMU_FEATURE_=
INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
> +               /*
> +                * Note, the fixed counter for reference cycles is NOT th=
e same
> +                * as the general purpose architectural event (because th=
e GP
> +                * event is garbage).  The fixed counter explicitly count=
s at
> +                * the same frequency as the TSC, whereas the GP event co=
unts
> +                * at a fixed, but uarch specific, frequency.  Bundle the=
m here
> +                * for simplicity.
> +                */

Implementation-specific is not necessarily garbage, though it would be
nice if there was a way to query the frequency rather than calibrating
against another clock.
Note that tools/perf/pmu-events/arch/x86/*/pipeline.json does
typically indicate the {0x3c, 1} frequency for the CPU in question.

> +               [INTEL_ARCH_REFERENCE_CYCLES]      =3D { X86_PMU_FEATURE_=
REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_CYCLES_FIXED },
> +               [INTEL_ARCH_LLC_REFERENCES]        =3D { X86_PMU_FEATURE_=
LLC_REFERENCES, X86_PMU_FEATURE_NULL },
> +               [INTEL_ARCH_LLC_MISSES]            =3D { X86_PMU_FEATURE_=
LLC_MISSES, X86_PMU_FEATURE_NULL },
> +               [INTEL_ARCH_BRANCHES_RETIRED]      =3D { X86_PMU_FEATURE_=
BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
> +               [INTEL_ARCH_BRANCHES_MISPREDICTED] =3D { X86_PMU_FEATURE_=
BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
>         };
>
>         uint32_t nr_gp_counters =3D this_cpu_property(X86_PROPERTY_PMU_NR=
_GP_COUNTERS);
>         uint32_t pmu_version =3D guest_get_pmu_version();
>         /* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+.=
 */
>         bool guest_has_perf_global_ctrl =3D pmu_version >=3D 2;
> -       struct kvm_x86_pmu_feature gp_event;
> +       struct kvm_x86_pmu_feature gp_event, fixed_event;
>         uint32_t base_pmc_msr;
>         unsigned int i;
>
> @@ -198,6 +219,22 @@ static void guest_test_arch_event(uint8_t idx)
>                 __guest_test_arch_event(idx, gp_event, i, base_pmc_msr + =
i,
>                                         MSR_P6_EVNTSEL0 + i, eventsel);
>         }
> +
> +       if (!guest_has_perf_global_ctrl)
> +               return;
> +
> +       fixed_event =3D intel_event_to_feature[idx].fixed_event;
> +       if (pmu_is_null_feature(fixed_event) || !this_pmu_has(fixed_event=
))
> +               return;
> +
> +       i =3D fixed_event.f.bit;
> +
> +       wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
> +
> +       __guest_test_arch_event(idx, fixed_event, PMC_FIXED_RDPMC_BASE | =
i,
> +                               MSR_CORE_PERF_FIXED_CTR0 + i,
> +                               MSR_CORE_PERF_GLOBAL_CTRL,
> +                               BIT_ULL(PMC_IDX_FIXED + i));
>  }
>
>  static void guest_test_arch_events(void)
> --
> 2.42.0.869.gea05f2083d-goog
>

