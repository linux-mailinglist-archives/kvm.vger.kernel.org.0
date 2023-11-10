Return-Path: <kvm+bounces-1398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72FC37E75D0
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D56E1C20BCA
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E137E8;
	Fri, 10 Nov 2023 00:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d6U7dGrh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE10627
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:17:57 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDE4211D
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:17:56 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-545557de8e6so17736a12.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 16:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699575475; x=1700180275; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7AINGqD+uDcyCkNAuvVhFQmI+fmLnwrj5VTd+39JmM=;
        b=d6U7dGrhdVKm3vluVOlW4tjLENLDM9DxAksFjh1MLjLYARi5EnMQ1DA4RYMB0y9pSh
         /rJ5REA5IOYCnqpmIrkJS+s1h6mNYdS/5QYhiEZcf0pu1OZgGysR7oAHZEuRL4Bf071k
         sTtUek3xFuDt0FWgdjjJ4nTwGXa7u6ouAeKWwLj3NoGzHHMK+Bybg0ocgo9I75Eq3vGi
         8W/dx8pigk2V+skY77uI3RXN66HBdoq/6shwsSWsl22Gh/5CXCVwAnbrisEWwuv4mVhZ
         cOUEqYaFItFiW46OUfyrUutjC4BMN7krCBBMo/1mTy8QzH/5aX+Q/jy9fv8pzp4/wAQi
         PVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699575475; x=1700180275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7AINGqD+uDcyCkNAuvVhFQmI+fmLnwrj5VTd+39JmM=;
        b=MIL3aeu98coRLHJwroh+P48MNKJdH5SJJB+3tGGc08VUXIo7MCb4RfJKnqd+CehAzk
         gVN98RM7GUOHYNmLog6IlIZnax8CnKQYduvtFhPFV/JLPlhZnrGIOvQicS62JfJnMaYN
         +o8TLpvMqbCa1GHsWB85mQqQO/iey4bbojMMLI76xA+LmzvSACVppVBdCxFagmaPwAc/
         ttpciECL0OLOMCddN4QdG6BPC6j/LlyBTEUN2zHfwPrnHy3n2Q86Oy4S49S3jCsEjrra
         q9fiLx/iHmf15yyzSuj8kvTSbPOJoV0qlGjLc1leFDgfIZCISTqF9l2gSfyfr3Qj8ayw
         wbSA==
X-Gm-Message-State: AOJu0YzAdm5KkRm1Ehzf+RzZPRNS4pdGCILOXjHMoXwhBi9U1ULAbQFq
	L7L9e45+39n1HbnArIq49WQAK0aKW18OSrhPLFgcYg==
X-Google-Smtp-Source: AGHT+IESBd3cjsgylAurSqxlZheyZNpWVoWe6LpJQP2lCpStZcRcvuTY5HGrez1TCDbrh4u/T6jREH2S+kHpCTq7UXk=
X-Received: by 2002:a05:6402:3709:b0:544:4762:608 with SMTP id
 ek9-20020a056402370900b0054447620608mr262760edb.2.1699575475098; Thu, 09 Nov
 2023 16:17:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <CALMp9eQGqqo66fQGwFJMc3y+9XdUrL7ageE8kvoAOV6NJGfJpw@mail.gmail.com> <ZU1ua1mHDZFTmkHX@google.com>
In-Reply-To: <ZU1ua1mHDZFTmkHX@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 9 Nov 2023 16:17:40 -0800
Message-ID: <CALMp9eTqdg32KGh38wQYW-fvyrjrc7VQAsA1wnHhoCn-tLwyYg@mail.gmail.com>
Subject: Re: [PATCH 0/1] KVM: x86/vPMU: Speed up vmexit for AMD Zen 4 CPUs
To: Sean Christopherson <seanjc@google.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Denis V. Lunev" <den@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 3:42=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Nov 09, 2023, Jim Mattson wrote:
> > On Thu, Nov 9, 2023 at 10:24=E2=80=AFAM Konstantin Khorenko
> > <khorenko@virtuozzo.com> wrote:
> > >
> > > We have detected significant performance drop of our atomic test whic=
h
> > > checks the rate of CPUID instructions rate inside an L1 VM on an AMD
> > > node.
> > >
> > > Investigation led to 2 mainstream patches which have introduced extra
> > > events accounting:
> > >
> > >    018d70ffcfec ("KVM: x86: Update vPMCs when retiring branch instruc=
tions")
> > >    9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> > >
> > > And on an AMD Zen 3 CPU that resulted in immediate 43% drop in the CP=
UID
> > > rate.
> > >
> > > Checking latest mainsteam kernel the performance difference is much l=
ess
> > > but still quite noticeable: 13.4% and shows up on AMD CPUs only.
> > >
> > > Looks like iteration over all PMCs in kvm_pmu_trigger_event() is chea=
p
> > > on Intel and expensive on AMD CPUs.
> > >
> > > So the idea behind this patch is to skip iterations over PMCs at all =
in
> > > case PMU is disabled for a VM completely or PMU is enabled for a VM, =
but
> > > there are no active PMCs at all.
> >
> > A better solution may be to maintain two bitmaps of general purpose
> > counters that need to be incremented, one for instructions retired and
> > one for branch instructions retired. Set or clear these bits whenever
> > the PerfEvtSelN MSRs are written. I think I would keep the PGC bits
> > separate, on those microarchitectures that support PGC. Then,
> > kvm_pmu_trigger_event() need only consult the appropriate bitmap (or
> > the logical and of that bitmap with PGC). In most cases, the value
> > will be zero, and the function can simply return.
> >
> > This would work even for AMD microarchitectures that don't support PGC.
>
> Yeah.  There are multiple lower-hanging fruits to be picked though, most =
of which
> won't conflict with using dedicated per-event bitmaps, or at worst are tr=
ivial
> to resolve.
>
>  1. Don't call into perf to get the eventsel (which generates an indirect=
 call)
>     on every invocation, let alone every iteration.
>
>  2. Avoid getting the CPL when it's irrelevant.
>
>  3. Check the eventsel before querying the event filter.
>
>  4. Mask out PMCs that aren't globally enabled from the get-go (masking o=
ut
>     PMCs based on eventsel would essentially be the same as per-event bit=
maps).

The code below only looks at PGC. Even on CPUs that support PGC, some
PMU clients still use the enable bits in the PerfEvtSelN. Linux perf,
for instance, can't seem to make up its mind whether to use PGC or
PerfEvtSelN.EN.

> I'm definitely not opposed to per-event bitmaps, but it'd be nice to avoi=
d them,
> e.g. if we can eke out 99% of the performance just by doing a few obvious
> optimizations.
>
> This is the end result of what I'm testing and will (hopefully) post shor=
tly:
>
> static inline bool pmc_is_eventsel_match(struct kvm_pmc *pmc, u64 eventse=
l)
> {
>         return !((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB);
> }

The top nybble of AMD's 3-nybble event select collides with Intel's
IN_TX and IN_TXCP bits. I think we can assert that the vCPU can't be
in a transaction if KVM is emulating an instruction, but this probably
merits a comment. The function name should also be more descriptive,
so that it doesn't get misused out of context. :)

> static inline bool cpl_is_matched(struct kvm_pmc *pmc)
> {
>         bool select_os, select_user;
>         u64 config;
>
>         if (pmc_is_gp(pmc)) {
>                 config =3D pmc->eventsel;
>                 select_os =3D config & ARCH_PERFMON_EVENTSEL_OS;
>                 select_user =3D config & ARCH_PERFMON_EVENTSEL_USR;
>         } else {
>                 config =3D fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ct=
rl,
>                                           pmc->idx - KVM_FIXED_PMC_BASE_I=
DX);
>                 select_os =3D config & 0x1;
>                 select_user =3D config & 0x2;
>         }
>
>         /*
>          * Skip the CPL lookup, which isn't free on Intel, if the result =
will
>          * be the same regardless of the CPL.
>          */
>         if (select_os =3D=3D select_user)
>                 return select_os;
>
>         return (static_call(kvm_x86_get_cpl)(pmc->vcpu) =3D=3D 0) ? selec=
t_os : select_user;
> }
>
> void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
> {
>         DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
>         struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
>         struct kvm_pmc *pmc;
>         int i;
>
>         BUILD_BUG_ON(sizeof(pmu->global_ctrl) * BITS_PER_BYTE !=3D X86_PM=
C_IDX_MAX);
>
>         if (!kvm_pmu_has_perf_global_ctrl(pmu))
>                 bitmap_copy(bitmap, pmu->all_valid_pmc_idx, X86_PMC_IDX_M=
AX);
>         else if (!bitmap_and(bitmap, pmu->all_valid_pmc_idx,
>                              (unsigned long *)&pmu->global_ctrl, X86_PMC_=
IDX_MAX))
>                 return;
>
>         kvm_for_each_pmc(pmu, pmc, i, bitmap) {
>                 /* Ignore checks for edge detect, pin control, invert and=
 CMASK bits */
>                 if (!pmc_is_eventsel_match(pmc, eventsel) ||
>                     !pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
>                         continue;
>
>                 kvm_pmu_incr_counter(pmc);
>         }
> }

