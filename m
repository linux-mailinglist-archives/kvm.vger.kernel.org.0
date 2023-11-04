Return-Path: <kvm+bounces-576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 682647E0F54
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 13:26:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA6EA281D1E
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 12:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119ED1773A;
	Sat,  4 Nov 2023 12:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eJKbdFLE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF1716403
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 12:25:52 +0000 (UTC)
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7941B2
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 05:25:49 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-507a5edc2ebso1237e87.1
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 05:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699100747; x=1699705547; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5HDM/kMANYSHmWA+0ee6/FQ7sAYRigJq4+6ccpg/KU=;
        b=eJKbdFLEahFbKfxqDVST2NObzXiTE7uwEgQkxQqg7hVxzEe/eTXjhlORvykhfPa9AY
         qgUJZMhOEM+lC5KYiJGtcVOExh7xRmcNboi5dCjEqwGXViT6mDDHIZ8OmtUwrJlql74F
         zatcQe+0WHd486p3/Ffmbxkqa0UJEbaCFk5w3kU6W95zcNZea5iabIqCJzmxTJl4wvHs
         ifeQ6uKjgV6gCFh1SA/RBuCmCc6dqih9BFufrDTTya5oNsGCAYLB0XF6oM6+Cyopke8c
         t2sYjPc05blU8oeuVhZ7IMIteMNxz9RLsmSkVYpteID5M4nmsQ1YFsacvb09bRCFzAUq
         o/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699100747; x=1699705547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5HDM/kMANYSHmWA+0ee6/FQ7sAYRigJq4+6ccpg/KU=;
        b=GXUPpuZOOTwh1KX2QQXXz6q8P+Y0PNK1SgaAMR3YFS0HERax8StKQJ9QERIZEi343Q
         xHxXXlKmHbjFQHbpEwk2yrxhGPgiVY45W951mBjJkXhncIC8hM1jDeHneGk19rKUW2La
         TGTwo5NUiBux6X9BeJT5MsFBf/tUJ7clvM6tSktO3xNCbtYjHSJ/6xIGiBTXAoXw/2nf
         ndGUCgVktYKQ4Y92FKf5bsyhHDttFgAz7RvHAJyFJ7LJqLmIGJZPAf0675khU5/h6ZdS
         8mjK7C9b+moce833iRbHn+Yhu9HfB8FjDdo8rDqG6UKurGPfoKoDffXAlFAzulLQErL2
         u2yg==
X-Gm-Message-State: AOJu0YxfDFsV7iEvB8LfRVrG/C/BI6tqdrcYYuKGSz9CItcdBnikIwkL
	v1Kz+kRZ9p/Qz2Mb0s+M2Tmo690PFVb3xlvR5cYQSA==
X-Google-Smtp-Source: AGHT+IGo6RtvkSz4dTDqX99fEep2IQ+AJozEaQSBSdwjI1scwrWwPk5qZjMLajoFekJgVQOwAg2zFO9WL8dV9PoUl1Y=
X-Received: by 2002:a05:6512:b89:b0:501:b029:1a47 with SMTP id
 b9-20020a0565120b8900b00501b0291a47mr41070lfv.1.1699100747484; Sat, 04 Nov
 2023 05:25:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-3-seanjc@google.com>
In-Reply-To: <20231104000239.367005-3-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Sat, 4 Nov 2023 05:25:30 -0700
Message-ID: <CALMp9eS+kNYYK_1Ufy5vc5PK25q-ny20woxbHz1onStkcfWNVw@mail.gmail.com>
Subject: Re: [PATCH v6 02/20] KVM: x86/pmu: Don't enumerate support for fixed
 counters KVM can't virtualize
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
> Hide fixed counters for which perf is incapable of creating the associate=
d
> architectural event.  Except for the so called pseudo-architectural event
> for counting TSC reference cycle, KVM virtualizes fixed counters by
> creating a perf event for the associated general purpose architectural
> event.  If the associated event isn't supported in hardware, KVM can't
> actually virtualize the fixed counter because perf will likely not progra=
m
> up the correct event.

Won't it? My understanding was that perf preferred to use a fixed
counter when there was a choice of fixed or general purpose counter.
Unless the fixed counter is already assigned to a perf_event, KVM's
request should be satisfied by assigning the fixed counter.

> Note, this issue is almost certainly limited to running KVM on a funky
> virtual CPU model, no known real hardware has an asymmetric PMU where a
> fixed counter is supported but the associated architectural event is not.

This seems like a fix looking for a problem. Has the "problem"
actually been encountered?

> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a gues=
ts")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.h           |  4 ++++
>  arch/x86/kvm/vmx/pmu_intel.c | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 1d64113de488..5341e8f69a22 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -19,6 +19,7 @@
>  #define VMWARE_BACKDOOR_PMC_APPARENT_TIME      0x10002
>
>  struct kvm_pmu_ops {
> +       void (*init_pmu_capability)(void);
>         bool (*hw_event_available)(struct kvm_pmc *pmc);
>         struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_id=
x);
>         struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
> @@ -218,6 +219,9 @@ static inline void kvm_init_pmu_capability(const stru=
ct kvm_pmu_ops *pmu_ops)
>                                           pmu_ops->MAX_NR_GP_COUNTERS);
>         kvm_pmu_cap.num_counters_fixed =3D min(kvm_pmu_cap.num_counters_f=
ixed,
>                                              KVM_PMC_MAX_FIXED);
> +
> +       if (pmu_ops->init_pmu_capability)
> +               pmu_ops->init_pmu_capability();
>  }
>
>  static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc=
)
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 1b13a472e3f2..3316fdea212a 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -68,6 +68,36 @@ static int fixed_pmc_events[] =3D {
>         [2] =3D PSEUDO_ARCH_REFERENCE_CYCLES,
>  };
>
> +static void intel_init_pmu_capability(void)
> +{
> +       int i;
> +
> +       /*
> +        * Perf may (sadly) back a guest fixed counter with a general pur=
pose
> +        * counter, and so KVM must hide fixed counters whose associated
> +        * architectural event are unsupported.  On real hardware, this s=
hould
> +        * never happen, but if KVM is running on a funky virtual CPU mod=
el...
> +        *
> +        * TODO: Drop this horror if/when KVM stops using perf events for
> +        * guest fixed counters, or can explicitly request fixed counters=
.
> +        */
> +       for (i =3D 0; i < kvm_pmu_cap.num_counters_fixed; i++) {
> +               int event =3D fixed_pmc_events[i];
> +
> +               /*
> +                * Ignore pseudo-architectural events, they're a bizarre =
way of
> +                * requesting events from perf that _can't_ be backed wit=
h a
> +                * general purpose architectural event, i.e. they're guar=
anteed
> +                * to be backed by the real fixed counter.
> +                */
> +               if (event < NR_REAL_INTEL_ARCH_EVENTS &&
> +                   (kvm_pmu_cap.events_mask & BIT(event)))
> +                       break;
> +       }
> +
> +       kvm_pmu_cap.num_counters_fixed =3D i;
> +}
> +
>  static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>  {
>         struct kvm_pmc *pmc;
> @@ -789,6 +819,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu=
)
>  }
>
>  struct kvm_pmu_ops intel_pmu_ops __initdata =3D {
> +       .init_pmu_capability =3D intel_init_pmu_capability,
>         .hw_event_available =3D intel_hw_event_available,
>         .pmc_idx_to_pmc =3D intel_pmc_idx_to_pmc,
>         .rdpmc_ecx_to_pmc =3D intel_rdpmc_ecx_to_pmc,
> --
> 2.42.0.869.gea05f2083d-goog
>

