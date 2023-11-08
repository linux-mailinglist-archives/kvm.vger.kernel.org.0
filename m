Return-Path: <kvm+bounces-1206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 587FA7E5951
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 15:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9177F1C20B75
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 14:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA80A2F4B;
	Wed,  8 Nov 2023 14:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o2wC9Cqe"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DCB107AE
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 14:39:31 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728FF1FCA
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 06:39:30 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5bc3be6a91bso6353097b3.1
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 06:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699454369; x=1700059169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJbNnPajjokoZi+trDlI5nj+dX/8FMyM+8HOHunxhb4=;
        b=o2wC9CqeJsDHSdQ5E0CbB9gWiu1J3UYfKeoxt6uvTIUOxlz6PqMN+4ysTWK/SYHJSV
         FENAaVnZnydB66/A/KeQ5Y6YzwRBX1xop76a35dZrqhj4zAUOUUZLEStKq0hlzVqfyYx
         NvGwxHnCAv/jVdB11jid9jzyE6ydq9x2rj1MuQrfOOPVb5s7R61k7+tDF1Qrd1f6maoN
         Z7Pz3Pe+FFQzb/DIWO4Vx/MQwYQGFQ1JI9ltTi4s3vSBtTB+JMDXZO9Dmyl6FxlBxim7
         MuSaOMsYWbRcBUyOzoWXUFdklqAYl1DTN6S/DT5eI9Cwktq3h+yAjLf1he2q9RBhI2Kq
         5DMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699454369; x=1700059169;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tJbNnPajjokoZi+trDlI5nj+dX/8FMyM+8HOHunxhb4=;
        b=dLQn0HZz6M1CVUrS+062v24T4PMstkbYkjzCc48vXHyg0kbTk1A2kGhpZBL99gaSOk
         t2gvOqq3YHHpJa2sS7aPvXhWqwWnPYrSVzskksfwNv9Ev6m8JfHsWLlbM5nEjw8W4jUo
         7xkR20MpGhr73GQg+XItRZNBUix3rRe6/uTSVr3AY04aq6PHXOeUv92QCbto1MLqHGy/
         ABkhxyDL1AmfCNXr+qd+0C8PUDRTDM3N1kUF/0i+tzo6BXP5JekdrCDxxMyUEOMSpW92
         zH1hVQv1tDwwJJyvrKtiBil1VsAvWR3ZxTlocpvz3viH0duqoZkomtuYb8T56PUjaRTJ
         /cJQ==
X-Gm-Message-State: AOJu0Yw17WYoW0D3XyKuzX5LwHgU3U/VDNvRCTT0ozUOl9ZCXillypZ3
	a0Vug3Eiy0HXel49hvQu0HDopmPavXM=
X-Google-Smtp-Source: AGHT+IEGOUAM6lrblcS31XPUoikg+vPg8XVBrcbYRDe8dMIFcTXwqPSRn4QNRed/6pKUIjZ9T95v5jnE62o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:93:b0:5be:baac:54e4 with SMTP id
 be19-20020a05690c009300b005bebaac54e4mr37620ywb.5.1699454369670; Wed, 08 Nov
 2023 06:39:29 -0800 (PST)
Date: Wed, 8 Nov 2023 06:39:28 -0800
In-Reply-To: <CALMp9eRcBi19yGS3+t+Hm0fLSB5+ESDGAygjwE_CYs-jWtU9Cg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com> <20231108003135.546002-5-seanjc@google.com>
 <CALMp9eRcBi19yGS3+t+Hm0fLSB5+ESDGAygjwE_CYs-jWtU9Cg@mail.gmail.com>
Message-ID: <ZUudoEyqtf5ZPtPp@google.com>
Subject: Re: [PATCH v7 04/19] KVM: x86/pmu: Setup fixed counters' eventsel
 during PMU initialization
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 07, 2023, Jim Mattson wrote:
> On Tue, Nov 7, 2023 at 4:31=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Set the eventsel for all fixed counters during PMU initialization, the
> > eventsel is hardcoded and consumed if and only if the counter is suppor=
ted,
> > i.e. there is no reason to redo the setup every time the PMU is refresh=
ed.
> >
> > Configuring all KVM-supported fixed counter also eliminates a potential
> > pitfall if/when KVM supports discontiguous fixed counters, in which cas=
e
> > configuring only nr_arch_fixed_counters will be insufficient (ignoring =
the
> > fact that KVM will need many other changes to support discontiguous fix=
ed
> > counters).
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/pmu_intel.c | 14 ++++----------
> >  1 file changed, 4 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.=
c
> > index c4f2c6a268e7..5fc5a62af428 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -409,7 +409,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu,=
 struct msr_data *msr_info)
> >   * Note, reference cycles is counted using a perf-defined "psuedo-enco=
ding",
> >   * as there is no architectural general purpose encoding for reference=
 cycles.
> >   */
> > -static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
> > +static u64 intel_get_fixed_pmc_eventsel(int index)
> >  {
> >         const struct {
> >                 u8 eventsel;
> > @@ -419,17 +419,11 @@ static void setup_fixed_pmc_eventsel(struct kvm_p=
mu *pmu)
> >                 [1] =3D { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CP=
U_CYCLES. */
> >                 [2] =3D { 0x00, 0x03 }, /* Reference Cycles / PERF_COUN=
T_HW_REF_CPU_CYCLES*/
> >         };
> > -       int i;
> >
> >         BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) !=3D KVM_PMC_MAX_FIXE=
D);
> >
> > -       for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> > -               int index =3D array_index_nospec(i, KVM_PMC_MAX_FIXED);
> > -               struct kvm_pmc *pmc =3D &pmu->fixed_counters[index];
> > -
> > -               pmc->eventsel =3D (fixed_pmc_events[index].unit_mask <<=
 8) |
> > -                                fixed_pmc_events[index].eventsel;
> > -       }
> > +       return (fixed_pmc_events[index].unit_mask << 8) |
> > +               fixed_pmc_events[index].eventsel;
>=20
> Can I just say that it's really confusing that the value returned by
> intel_get_fixed_pmc_eventsel() is the concatenation of an 8-bit "unit
> mask" and an 8-bit "eventsel"?

Heh, blame the SDM for having an "event select" field in "event select" MSR=
s.

Is this better?

	const struct {
		u8 event;
		u8 unit_mask;
	} fixed_pmc_events[] =3D {
		[0] =3D { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIO=
NS. */
		[1] =3D { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
		[2] =3D { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLE=
S*/
	};

	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) !=3D KVM_PMC_MAX_FIXED);

	return (fixed_pmc_events[index].unit_mask << 8) |
		fixed_pmc_events[index].event;


Or are you complaining about the fact that they're split at all?  I'm open =
to any
format, though I personally found the seperate umask and event values helpf=
ul
when trying to understand what's going on.

