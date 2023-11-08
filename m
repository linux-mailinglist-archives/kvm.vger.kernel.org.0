Return-Path: <kvm+bounces-1122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 099257E4E87
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 02:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC82EB21023
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53139802;
	Wed,  8 Nov 2023 01:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1fSeqmCG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C980650
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 01:24:25 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C732810E4
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:24:24 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-54366bb1c02so3419a12.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 17:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699406663; x=1700011463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8gSlMrT7ac5Wcg60WKPeknEbhGLtSqkDGqcC2ydIQdM=;
        b=1fSeqmCGuGs//W/OcoVRaWEDwqokfwMSJlYji4bVQaxesgSGD1iahY75zsAjF36Jvp
         ujxJyGBS/ty73tNuTzwn9owHOYJhyHvc2XMbd2OUCzejPeShZRkbLYvNTgcdlqUn9l2+
         GuioyIhxSZopcCyntVTFeplAE5wT7+Tg2xb7pqn8nJy784xd3DD2xjAAc7KokMkB/Pmf
         XsX11ic75yhTHh3hGFDbbGtIQQp1n/f4fxFajBvxwaqVRcquiNprnh+Ej/5cfG7AtcPU
         R0Q2nCJfWAxzfBH0jaCevQAvOPZ+LMt2+0FYRIZNQeGVMfzg3YKPpDc1UBUfxDscxSm5
         62Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699406663; x=1700011463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8gSlMrT7ac5Wcg60WKPeknEbhGLtSqkDGqcC2ydIQdM=;
        b=dnpHGTw+9OQsyrWZXAsDTa4J242PXq0KRjc1MiwzLijBm6Kgva3h4TMKeo44vC3DDO
         ndU61I88DmwILZ8aw45L9zT5hv8AiO4RcUKbOblZmqv6r8j82dpFPGL8FswR06VKlplK
         3Yt0qhkhixEVS/hdQixciWUJnXsQSglrjvOPKAxE+3uwnOgOK3po6gfcPd86mM55wgO3
         9pPaZdDkqy41ggehp1BuokCq1uFvnvDvaXQxhBQuiuxoaqvijfBj00rHZzjeIVRewKTH
         SfrNP0bGdofk1qoKv01qEewBRj//iy2ggd4NoDrQWYTljQ8kxQqfAGrdKsRjI0r7Sker
         YUvw==
X-Gm-Message-State: AOJu0Yz8E0hkLpOTHrxtXmnK91OZm8lq8U7xOUFcKzFAkJu2TsUqFys3
	1/qX9P0wd5bw1w2/Bua0vwJeGo5e1E+4QE+haukweQ==
X-Google-Smtp-Source: AGHT+IHTEplORxG8PEzsJM1xxGSvCn+oHqxh3q51+AweQ5iroL23ChFxa6hfhoWWI7QRyFs/9j1q5G71VNezKVPIhcw=
X-Received: by 2002:a05:6402:2b8a:b0:544:e2b8:ba6a with SMTP id
 fj10-20020a0564022b8a00b00544e2b8ba6amr210327edb.3.1699406663113; Tue, 07 Nov
 2023 17:24:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com> <20231108003135.546002-3-seanjc@google.com>
In-Reply-To: <20231108003135.546002-3-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 7 Nov 2023 17:24:10 -0800
Message-ID: <CALMp9eTAU2hnCp+463xftURknfrtKa=b1KNXJO_kamCyzCpRkw@mail.gmail.com>
Subject: Re: [PATCH v7 02/19] KVM: x86/pmu: Allow programming events that
 match unsupported arch events
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 4:31=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Remove KVM's bogus restriction that the guest can't program an event whos=
e
> encoding matches an unsupported architectural event.  The enumeration of
> an architectural event only says that if a CPU supports an architectural
> event, then the event can be programmed using the architectural encoding.
> The enumeration does NOT say anything about the encoding when the CPU
> doesn't report support the architectural event.
>
> Preventing the guest from counting events whose encoding happens to match
> an architectural event breaks existing functionality whenever Intel adds
> an architectural encoding that was *ever* used for a CPU that doesn't
> enumerate support for the architectural event, even if the encoding is fo=
r
> the exact same event!
>
> E.g. the architectural encoding for Top-Down Slots is 0x01a4.  Broadwell
> CPUs, which do not support the Top-Down Slots architectural event, 0x10a4

Nit: 0x01a4

> is a valid, model-specific event.  Denying guest usage of 0x01a4 if/when
> KVM adds support for Top-Down slots would break any Broadwell-based guest=
.
>
> Reported-by: Kan Liang <kan.liang@linux.intel.com>
> Closes: https://lore.kernel.org/all/2004baa6-b494-462c-a11f-8104ea152c6a@=
linux.intel.com
> Fixes: a21864486f7e ("KVM: x86/pmu: Fix available_event_types check for R=
EF_CPU_CYCLES event")
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
>  arch/x86/kvm/pmu.c                     |  1 -
>  arch/x86/kvm/pmu.h                     |  1 -
>  arch/x86/kvm/svm/pmu.c                 |  6 ----
>  arch/x86/kvm/vmx/pmu_intel.c           | 38 --------------------------
>  5 files changed, 47 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/as=
m/kvm-x86-pmu-ops.h
> index 6c98f4bb4228..884af8ef7657 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -12,7 +12,6 @@ BUILD_BUG_ON(1)
>   * a NULL definition, for example if "static_call_cond()" will be used
>   * at the call sites.
>   */
> -KVM_X86_PMU_OP(hw_event_available)
>  KVM_X86_PMU_OP(pmc_idx_to_pmc)
>  KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
>  KVM_X86_PMU_OP(msr_idx_to_pmc)
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 9ae07db6f0f6..99ed72966528 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -374,7 +374,6 @@ static bool check_pmu_event_filter(struct kvm_pmc *pm=
c)
>  static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
>  {
>         return pmc_is_globally_enabled(pmc) && pmc_speculative_in_use(pmc=
) &&
> -              static_call(kvm_x86_pmu_hw_event_available)(pmc) &&
>                check_pmu_event_filter(pmc);
>  }
>
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 1d64113de488..10fe5bf02705 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -19,7 +19,6 @@
>  #define VMWARE_BACKDOOR_PMC_APPARENT_TIME      0x10002
>
>  struct kvm_pmu_ops {
> -       bool (*hw_event_available)(struct kvm_pmc *pmc);
>         struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_id=
x);
>         struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
>                 unsigned int idx, u64 *mask);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 373ff6a6687b..5596fe816ea8 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -73,11 +73,6 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kv=
m_pmu *pmu, u32 msr,
>         return amd_pmc_idx_to_pmc(pmu, idx);
>  }
>
> -static bool amd_hw_event_available(struct kvm_pmc *pmc)
> -{
> -       return true;
> -}
> -
>  static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int i=
dx)
>  {
>         struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> @@ -249,7 +244,6 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
>  }
>
>  struct kvm_pmu_ops amd_pmu_ops __initdata =3D {
> -       .hw_event_available =3D amd_hw_event_available,
>         .pmc_idx_to_pmc =3D amd_pmc_idx_to_pmc,
>         .rdpmc_ecx_to_pmc =3D amd_rdpmc_ecx_to_pmc,
>         .msr_idx_to_pmc =3D amd_msr_idx_to_pmc,
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index c6e227edcf8e..7737ee2fc62f 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -101,43 +101,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct k=
vm_pmu *pmu, int pmc_idx)
>         }
>  }
>
> -static bool intel_hw_event_available(struct kvm_pmc *pmc)
> -{
> -       struct kvm_pmu *pmu =3D pmc_to_pmu(pmc);
> -       u8 event_select =3D pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
> -       u8 unit_mask =3D (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >>=
 8;
> -       int i;
> -
> -       /*
> -        * Fixed counters are always available if KVM reaches this point.=
  If a
> -        * fixed counter is unsupported in hardware or guest CPUID, KVM d=
oesn't
> -        * allow the counter's corresponding MSR to be written.  KVM does=
 use
> -        * architectural events to program fixed counters, as the interfa=
ce to
> -        * perf doesn't allow requesting a specific fixed counter, e.g. p=
erf
> -        * may (sadly) back a guest fixed PMC with a general purposed cou=
nter.
> -        * But if _hardware_ doesn't support the associated event, KVM si=
mply
> -        * doesn't enumerate support for the fixed counter.
> -        */
> -       if (pmc_is_fixed(pmc))
> -               return true;
> -
> -       BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) !=3D NR_INTEL_ARCH_EVE=
NTS);
> -
> -       /*
> -        * Disallow events reported as unavailable in guest CPUID.  Note,=
 this
> -        * doesn't apply to pseudo-architectural events (see above).
> -        */
> -       for (i =3D 0; i < NR_REAL_INTEL_ARCH_EVENTS; i++) {
> -               if (intel_arch_events[i].eventsel !=3D event_select ||
> -                   intel_arch_events[i].unit_mask !=3D unit_mask)
> -                       continue;
> -
> -               return pmu->available_event_types & BIT(i);
> -       }
> -
> -       return true;
> -}
> -
>  static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int=
 idx)
>  {
>         struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> @@ -802,7 +765,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu=
)
>  }
>
>  struct kvm_pmu_ops intel_pmu_ops __initdata =3D {
> -       .hw_event_available =3D intel_hw_event_available,
>         .pmc_idx_to_pmc =3D intel_pmc_idx_to_pmc,
>         .rdpmc_ecx_to_pmc =3D intel_rdpmc_ecx_to_pmc,
>         .msr_idx_to_pmc =3D intel_msr_idx_to_pmc,
> --
> 2.42.0.869.gea05f2083d-goog
>

