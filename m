Return-Path: <kvm+bounces-1390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F217E7539
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:42:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2111B210EC
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 23:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D0E38FBA;
	Thu,  9 Nov 2023 23:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ifO7c/43"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B7638FAD
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 23:42:37 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D47449E
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 15:42:37 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1ccdf149e60so15404675ad.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 15:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699573357; x=1700178157; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xvKbhUWYQDbe7zhIKsbg2b0+5K0fkOljaNJXIuAcrck=;
        b=ifO7c/43z1zQNPH6enXihuneoUempdmHICPPF3Objx9gjmMbwb3ZfRiq63hIGIrc8t
         sJWvoIB41EO8I2mDE0r2Lbp5EwiTPwn4cFYamsY9GX7E/zhLHP4MjRSN2enJKAbzk9Jn
         c+sz3j5/LEpD9fwiuhVx9JUWXEihOezt8q/neNWnHGxpcSSJwpGeE20MseG+bKHOgAcy
         GMY47T51L+7uxU6x2VReWz4boKOZ4huTJmQvJUbL3j913CRZtal760Fiyjo3VC9IAUHJ
         omvCOtYEh6BkAHRcEON5EqOqXheKjK2bdXoN3MwPyspuwYDasqXOTOUdntta8c6RyiZn
         /0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699573357; x=1700178157;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xvKbhUWYQDbe7zhIKsbg2b0+5K0fkOljaNJXIuAcrck=;
        b=FXaOdx2GUL4R8qdp6OddBWB1XsgtQnsAU9HEO+FXEC0loHjQ4EupqCyCUcIozs1Mq2
         xhI2KrxYqu8Dl2CiKZqhy9nXyTcetq46aumYhmzmgWKXKke6AiZQUDfjPQ9pvdlRUxJF
         BPE4lmOa64hEB24z4AleQrYgEanBjNI48YJtWRe17AKrdubUwFg47p9CvlHuqbnxPliF
         Mc3sBzmdU6bmGBLYOZbyglmeoLedctd5e09DYIOpea6+2UVxD3GIkF+8h078GqMZmyEc
         SFA3EoA7SeD7hsUwbazfcx+lsrAri+27gUJJ8J5Mk8ACk9PK9TZL/aEXdO0vAySWPGJk
         uYYw==
X-Gm-Message-State: AOJu0YxEPRGHPAT5huK7jRxoFDI/fJXYC+m9GWG2eRyHYEyqxpNbDsg5
	DnQ9UGFvKBZn54kaBMZy4ZwX25SBmQg=
X-Google-Smtp-Source: AGHT+IEqzoq9gwgzj9++u4SOKh28m/CUB1usWDPK/2AMZ/unlRUDNItOZEdEcDoSRWZBAj5QzF1zz9MQDBU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:268c:b0:1cc:335b:c923 with SMTP id
 jf12-20020a170903268c00b001cc335bc923mr854397plb.2.1699573356942; Thu, 09 Nov
 2023 15:42:36 -0800 (PST)
Date: Thu, 9 Nov 2023 15:42:35 -0800
In-Reply-To: <CALMp9eQGqqo66fQGwFJMc3y+9XdUrL7ageE8kvoAOV6NJGfJpw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109180646.2963718-1-khorenko@virtuozzo.com> <CALMp9eQGqqo66fQGwFJMc3y+9XdUrL7ageE8kvoAOV6NJGfJpw@mail.gmail.com>
Message-ID: <ZU1ua1mHDZFTmkHX@google.com>
Subject: Re: [PATCH 0/1] KVM: x86/vPMU: Speed up vmexit for AMD Zen 4 CPUs
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Denis V. Lunev" <den@virtuozzo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 09, 2023, Jim Mattson wrote:
> On Thu, Nov 9, 2023 at 10:24=E2=80=AFAM Konstantin Khorenko
> <khorenko@virtuozzo.com> wrote:
> >
> > We have detected significant performance drop of our atomic test which
> > checks the rate of CPUID instructions rate inside an L1 VM on an AMD
> > node.
> >
> > Investigation led to 2 mainstream patches which have introduced extra
> > events accounting:
> >
> >    018d70ffcfec ("KVM: x86: Update vPMCs when retiring branch instructi=
ons")
> >    9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> >
> > And on an AMD Zen 3 CPU that resulted in immediate 43% drop in the CPUI=
D
> > rate.
> >
> > Checking latest mainsteam kernel the performance difference is much les=
s
> > but still quite noticeable: 13.4% and shows up on AMD CPUs only.
> >
> > Looks like iteration over all PMCs in kvm_pmu_trigger_event() is cheap
> > on Intel and expensive on AMD CPUs.
> >
> > So the idea behind this patch is to skip iterations over PMCs at all in
> > case PMU is disabled for a VM completely or PMU is enabled for a VM, bu=
t
> > there are no active PMCs at all.
>=20
> A better solution may be to maintain two bitmaps of general purpose
> counters that need to be incremented, one for instructions retired and
> one for branch instructions retired. Set or clear these bits whenever
> the PerfEvtSelN MSRs are written. I think I would keep the PGC bits
> separate, on those microarchitectures that support PGC. Then,
> kvm_pmu_trigger_event() need only consult the appropriate bitmap (or
> the logical and of that bitmap with PGC). In most cases, the value
> will be zero, and the function can simply return.
>=20
> This would work even for AMD microarchitectures that don't support PGC.

Yeah.  There are multiple lower-hanging fruits to be picked though, most of=
 which
won't conflict with using dedicated per-event bitmaps, or at worst are triv=
ial
to resolve.

 1. Don't call into perf to get the eventsel (which generates an indirect c=
all)
    on every invocation, let alone every iteration.

 2. Avoid getting the CPL when it's irrelevant.

 3. Check the eventsel before querying the event filter.

 4. Mask out PMCs that aren't globally enabled from the get-go (masking out
    PMCs based on eventsel would essentially be the same as per-event bitma=
ps).

I'm definitely not opposed to per-event bitmaps, but it'd be nice to avoid =
them,
e.g. if we can eke out 99% of the performance just by doing a few obvious
optimizations.

This is the end result of what I'm testing and will (hopefully) post shortl=
y:

static inline bool pmc_is_eventsel_match(struct kvm_pmc *pmc, u64 eventsel)
{
	return !((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB);
}

static inline bool cpl_is_matched(struct kvm_pmc *pmc)
{
	bool select_os, select_user;
	u64 config;

	if (pmc_is_gp(pmc)) {
		config =3D pmc->eventsel;
		select_os =3D config & ARCH_PERFMON_EVENTSEL_OS;
		select_user =3D config & ARCH_PERFMON_EVENTSEL_USR;
	} else {
		config =3D fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
					  pmc->idx - KVM_FIXED_PMC_BASE_IDX);
		select_os =3D config & 0x1;
		select_user =3D config & 0x2;
	}

	/*
	 * Skip the CPL lookup, which isn't free on Intel, if the result will
	 * be the same regardless of the CPL.
	 */
	if (select_os =3D=3D select_user)
		return select_os;

	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) =3D=3D 0) ? select_os : se=
lect_user;
}

void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
{
	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
	struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
	struct kvm_pmc *pmc;
	int i;

	BUILD_BUG_ON(sizeof(pmu->global_ctrl) * BITS_PER_BYTE !=3D X86_PMC_IDX_MAX=
);

	if (!kvm_pmu_has_perf_global_ctrl(pmu))
		bitmap_copy(bitmap, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
	else if (!bitmap_and(bitmap, pmu->all_valid_pmc_idx,
			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
		return;

	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
		if (!pmc_is_eventsel_match(pmc, eventsel) ||
		    !pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
			continue;

		kvm_pmu_incr_counter(pmc);
	}
}

