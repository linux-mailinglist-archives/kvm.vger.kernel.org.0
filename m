Return-Path: <kvm+bounces-1037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5016D7E46EA
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:27:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E1B61C20A2A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 17:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD61347CB;
	Tue,  7 Nov 2023 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SApOfQWY"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3177E347AD
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:27:23 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E2F120
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:27:22 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afa86b8d66so80313597b3.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 09:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699378042; x=1699982842; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qa2wFXn+fN/9MOzm2p0htr7TnYIvjcbd3WdjaN07M/k=;
        b=SApOfQWYC9LmzzbP04Sz03KN1j6GWowzoqVDrR+eoszpBD1+TxUbsDYAGtwPxXkqyk
         NqCQ6sGrOYtCKxKtZAzeLOGpotn0YcpE8m92mC+H24JuUAsB2/MEdFzowPNLz90XlGqx
         keSEhAKp/PG9GixQhyllTirYiuYEQyVNJhFjzz94Y8ap4TejoMErlXnHvq1UlS/sexBv
         A026cfYfXu1SvfH/0fNJziIahS07Dwpup/3cdwzl5lzxU+EDImxf4H1zW8vWtteL0STB
         5q6wH0wof9W6FhaXdj3/IgHerOtS5l1Wu23VmqMSWGifaRf51QvCmiuVGhOL+EOYE+i5
         Y8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699378042; x=1699982842;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qa2wFXn+fN/9MOzm2p0htr7TnYIvjcbd3WdjaN07M/k=;
        b=o7MsgxYD8QpaW+oF55ERVsIYUXFEwV7VwJyvKzkOuWLoIhyJe0uZ+Wq2ZBG0Np6oG8
         46DDOO2ucowA3l8w4xCBvKjE+7HonMs2Qw4ZnAD/N715urdqGtEhXzAS8LDZCFhFKrgk
         KC39keLB6v41Qvmt26/3OyWX77FoT0V3D8emkbwEFYayoylrHtooN4AM5MyYxTv3H+x9
         qUTYgkBbu19htX4ihxFj549PSiwI8hgpy4rObi1Lgb2dyaPBEKlD+wHebktiuMR2Dl4S
         wROgI3Mu9Si2VtucyKpMDRRGRlsnegvnY/12WVQt8tZYSQeD3C96Q6WoKycAr+BlDfYW
         IbBA==
X-Gm-Message-State: AOJu0YxdZgQQt/a/9pc5KW61fmlFq6ucgpCftuCC3jDVXtb3pEDZaqvE
	iIgaQWKyeESs52v3RfeJnzVFLH+cAfU=
X-Google-Smtp-Source: AGHT+IEfx2xJRyHlzos0vemGZEAAO4aiy00M2pBqcV8b4prgzhoMSWSgigaGYOWEUbs4hq72Zazg1t3nACs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d88e:0:b0:5a8:33ab:d545 with SMTP id
 a136-20020a0dd88e000000b005a833abd545mr290916ywe.2.1699378041829; Tue, 07 Nov
 2023 09:27:21 -0800 (PST)
Date: Tue, 7 Nov 2023 09:27:20 -0800
In-Reply-To: <2c804098-af2b-4f1d-a39f-eb42f58635d7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-4-seanjc@google.com>
 <CALMp9eTvR1mNw7PEms7840t13dD_VGhEWpaz9w6prSiyDR9GtA@mail.gmail.com> <2c804098-af2b-4f1d-a39f-eb42f58635d7@linux.intel.com>
Message-ID: <ZUpzeGnWtExCxhcS@google.com>
Subject: Re: [PATCH v6 03/20] KVM: x86/pmu: Don't enumerate arch events KVM
 doesn't support
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 07, 2023, Dapeng Mi wrote:
>=20
> On 11/4/2023 8:41 PM, Jim Mattson wrote:
> > On Fri, Nov 3, 2023 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > Don't advertise support to userspace for architectural events that KV=
M
> > > doesn't support, i.e. for "real" events that aren't listed in
> > > intel_pmu_architectural_events.  On current hardware, this effectivel=
y
> > > means "don't advertise support for Top Down Slots".
> > NR_REAL_INTEL_ARCH_EVENTS is only used in intel_hw_event_available().
> > As discussed (https://lore.kernel.org/kvm/ZUU12-TUR_1cj47u@google.com/)=
,
> > intel_hw_event_available() should go away.
> >=20
> > Aside from mapping fixed counters to event selector and unit mask
> > (fixed_pmc_events[]), KVM has no reason to know when a new
> > architectural event is defined.
>=20
>=20
> Since intel_hw_event_available() would be removed, it looks the enum
> intel_pmu_architectural_events and intel_arch_events[] array become usele=
ss.
> We can directly simply modify current fixed_pmc_events[] array and use it=
 to
> store fixed counter events code and umask.

Yep, I came to the same conclusion.  This is what I ended up with yesterday=
:

/*
 * Map fixed counter events to architectural general purpose event encoding=
s.
 * Perf doesn't provide APIs to allow KVM to directly program a fixed count=
er,
 * and so KVM instead programs the architectural event to effectively reque=
st
 * the fixed counter.  Perf isn't guaranteed to use a fixed counter and may
 * instead program the encoding into a general purpose counter, e.g. if a
 * different perf_event is already utilizing the requested counter, but the=
 end
 * result is the same (ignoring the fact that using a general purpose count=
er
 * will likely exacerbate counter contention).
 *
 * Note, reference cycles is counted using a perf-defined "psuedo-encoding"=
,
 * there is no architectural general purpose encoding for reference TSC cyc=
les.
 */
static u64 intel_get_fixed_pmc_eventsel(int index)
{
        const struct {
                u8 eventsel;
                u8 unit_mask;
        } fixed_pmc_events[] =3D {
                [0] =3D { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT=
_HW_INSTRUCTIONS. */
                [1] =3D { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CY=
CLES. */
                [2] =3D { 0x00, 0x03 }, /* Reference TSC Cycles / PERF_COUN=
T_HW_REF_CPU_CYCLES*/
        };

        BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) !=3D KVM_PMC_MAX_FIXED);

        return (fixed_pmc_events[index].unit_mask << 8) |
               fixed_pmc_events[index].eventsel;
}

...

static void intel_pmu_init(struct kvm_vcpu *vcpu)
{
        int i;
        struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
        struct lbr_desc *lbr_desc =3D vcpu_to_lbr_desc(vcpu);

        for (i =3D 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
                pmu->gp_counters[i].type =3D KVM_PMC_GP;
                pmu->gp_counters[i].vcpu =3D vcpu;
                pmu->gp_counters[i].idx =3D i;
                pmu->gp_counters[i].current_config =3D 0;
        }

        for (i =3D 0; i < KVM_PMC_MAX_FIXED; i++) {
                pmu->fixed_counters[i].type =3D KVM_PMC_FIXED;
                pmu->fixed_counters[i].vcpu =3D vcpu;
                pmu->fixed_counters[i].idx =3D i + INTEL_PMC_IDX_FIXED;
                pmu->fixed_counters[i].current_config =3D 0;
                pmu->fixed_counters[i].eventsel =3D intel_get_fixed_pmc_eve=
ntsel(i);
        }

        lbr_desc->records.nr =3D 0;
        lbr_desc->event =3D NULL;
        lbr_desc->msr_passthrough =3D false;
}



