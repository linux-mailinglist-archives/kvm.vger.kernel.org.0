Return-Path: <kvm+bounces-69441-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADeODS+femmF8gEAu9opvQ
	(envelope-from <kvm+bounces-69441-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:43:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5A6AA04C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 81EEB301DC08
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09CC3451A9;
	Wed, 28 Jan 2026 23:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fN6DU6gp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52B8338584
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 23:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769643813; cv=pass; b=V5nb8X7odDV+uXXG9avZ+156bWUpO16Mm8JAkBxFdw8VV0tb15NveqJRy80x4s2UW8kc09m8ojrRYzDxPqsNaLICibwKz6mB7bIPy1jRtQDwg0TVU+diVZZ3kTXofVGIRD4EpDRsjoJQiBTYRrZZQ7sAV8t22fD6S09oznRx8A0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769643813; c=relaxed/simple;
	bh=3eKMB8/N0MTev+99HlBTlmZD4BLsN9uhauxq9iekQUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XYZQt46QlLqKNTBNXv34HEaPQSv3MpLg6Bd3plkOkrCDQ0/O1QzEOwDNeJRcrz2jV/s4VHmq+g7K0J9ltCCpRyLK01hcUnSratYVgrPvutD+5QZcC1KIoHHvTIFCBOSgvQ4Q0a4qCK6lQi/NYNwZZhHnZgHKKjTYUdPbAg1hho8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fN6DU6gp; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5033b0b6eabso96671cf.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 15:43:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769643811; cv=none;
        d=google.com; s=arc-20240605;
        b=dMuTqY9zXpuEvbc6I4utSbM+Q4PIn3Kbh70qFJi2WSK7mrOOCmhFeKoTSLOngf+8FW
         AwKv9WYcSTinos+izNqE8RvXayHNlONrTGtYUY7hlP0Yh3BucAsGepAQZf/8FcIcJOIM
         SB/pV+VSAgkwlEmDHeORkDJqn5M7Y/9Ppu9PyzfUeO03ZFSGjpz3SjT2RmINlX2kW8w5
         AIR8o8J3EfIj1Ec11cqwc/yDE9ApT0Iofi0ByI452HA/NNph3o9dYOB7FPVyxGsVwBVZ
         m9sPelq/B3OctGN9n3/MGqR94IMpr2eSiGOb7DXO/D1JTtRXerv3Hj8ATNId2FeEC4AA
         5xmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Cbg9Q5eQVZakHpCjsYsySo/U1zRKnpzshKoOs5i9/fo=;
        fh=6uXbmtVboLnS9Cqrxcm1+NwetsYBzCfA0u4UI502PTY=;
        b=jK35vRg081EiJn7NUDv8MgVcimA4wxJPsVSj05vukK9kxRxQYawt9K/MKHHZpDTmnn
         7j27FnHmIiIWOxFPyrJ3Ylyuwt+56HID9qzrHI5/cjPYP20WHJDotWjmBV7HfhPfjZtL
         ia8M1YPlgMYXJaW+d0h8IoR3redMxcAovWQQ7Zk0S6haKlVk8085GOykCVz9qcUrJzc5
         mWPQfqqBk2vLTPVSnmfnuJWjoWfJz9EhvqWXEzQNHuR0rWnPzpZruAVuzZiaPGF/nH4g
         O4NmeBQDJMKbmLoSm46g7nGqx/o1NQNEchPaY4izftI8m4KbVJYrcfo+krmTp95papvn
         /yqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769643811; x=1770248611; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cbg9Q5eQVZakHpCjsYsySo/U1zRKnpzshKoOs5i9/fo=;
        b=fN6DU6gp2U3nktsx+h/gFgsRp0VKOYG0EKaGA3MvxbUh/RrPsHS51zNjT+52tbMv4m
         yxYwt/EPYPb2LnyVO4YDk/LRcly1tKbhCZC5qCLkaq7/cgwi64r5sM5U3gLip02DnukD
         RmVDQvIoaMHYc1u0frAdxEkAz3tNZGEnTb6nTSjTCX5QIqXcfoSFakLzPjbZ4MXdHYM2
         RRExj+lC9aQvts2u5Oyy4Ern+DWdmd//VeB2PlhPB9ZH10R3GFfbJROwmiIynAoYGo7V
         2Lt2Xr786ZXFcl8FfVExazmSDWE+h26vt7HthmtNpfLhrfy+rRERsvR4gxzJ1Y37vko1
         6oJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769643811; x=1770248611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cbg9Q5eQVZakHpCjsYsySo/U1zRKnpzshKoOs5i9/fo=;
        b=QN+TzWNcqa672NR9NPm48QgGayvJGMvLgWQ4XljgThZRdFVgI0fDmiEf+Ph4z7iFAD
         KQ2w+n0k3dJ1I3yGQ/6oKTTyGSQwEZi8Pu8YnN40aQHLJLvsewaSxFQB/jAcFkGUQ391
         FC5tNlVAzFoWfD1RVzUdkKlGqqjMXAL6VtLCfSlzqQG1hW0madcqAqs3thPJQGXyhbcH
         ndFdRhMusLKUxIHUUqO+pt9c7yL/rQN9/8vd4dtE7BD3OOSR5UVVyxTrUtK16tAhT/nS
         4xpQMeXLN3IhX2JLRlmbZF3aFVvSh72KiJts/8O4KEmvnla/yH6qzqeCQvU+YkYOB/TH
         rQBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVf/RIb7rios5JYi3DaMg3sUh9JwB0GsaYcLeqzjsxymb37YXn8rBzF7gIepTXlYugUvkA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa6Y5U6oIEki0JOLq1uyCeHs9INZFRSRuX1lBHIqSlmfOsUzUQ
	O+1NX3J9owHnuJis10JxZ3G3RRelBF8K/8Bm2WrsKM/XiUMosh483GtTM6PfEIhG+Hrdeu2/mku
	nxmW01XnHwbfgTMbn7hWLVQehkede3CcAZpr1Qu9Q
X-Gm-Gg: AZuq6aIKoC1fTYhNL19A+VPSy5qDZi9tZ+3ArekxeFnUpxNnHDzN5AsaD+fKPJd/Dmd
	h9neY0wHaAHOv7YAIIHhdn1P67au0kdsmNTedUoNxLVLJORaah39F9Xi8tZznfihV2/YfOZpzW7
	xcYv2wmtdVFzxOcJxiWlMUbPFxpFdFUTb1zQM4sBg+N6l+65MLo72q7iX7p36m0PcgqxZXKnQ+i
	AVBcyB0iyd5uKkMj+rwFbSdeIif2RNHcSOdiqwKowDmyAxQVeIY/zTB9NSv42VaPeGfqYI=
X-Received: by 2002:ac8:5845:0:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-503b670708bmr4368881cf.8.1769643810455; Wed, 28 Jan 2026
 15:43:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-5-jmattson@google.com>
 <aXJWkIw0oSzOmxLS@google.com>
In-Reply-To: <aXJWkIw0oSzOmxLS@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 28 Jan 2026 15:43:17 -0800
X-Gm-Features: AZwV_Qg3cPvdxu5JjE3L9etXDIim1laTDylrUrWKJZNk6kMLsMV9S1LQ51Qci3M
Message-ID: <CALMp9eSryGLaHfH0fWeQco1rTY57q=pskB5H50u2z4nxBuPqYA@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: x86/pmu: [De]activate HG_ONLY PMCs at SVME
 changes and nested transitions
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69441-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DE5A6AA04C
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 8:55=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jan 21, 2026, Jim Mattson wrote:
> > diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/=
asm/kvm-x86-pmu-ops.h
> > index f0aa6996811f..7b32796213a0 100644
> > --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> > @@ -26,6 +26,7 @@ KVM_X86_PMU_OP_OPTIONAL(cleanup)
> >  KVM_X86_PMU_OP_OPTIONAL(write_global_ctrl)
> >  KVM_X86_PMU_OP(mediated_load)
> >  KVM_X86_PMU_OP(mediated_put)
> > +KVM_X86_PMU_OP_OPTIONAL(set_pmc_eventsel_hw_enable)
> >
> >  #undef KVM_X86_PMU_OP
> >  #undef KVM_X86_PMU_OP_OPTIONAL
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 833ee2ecd43f..1541c201285b 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -1142,6 +1142,13 @@ void kvm_pmu_branch_retired(struct kvm_vcpu *vcp=
u)
> >  }
> >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_pmu_branch_retired);
> >
> > +void kvm_pmu_set_pmc_eventsel_hw_enable(struct kvm_vcpu *vcpu,
> > +                                    unsigned long *bitmap, bool enable=
)
> > +{
> > +     kvm_pmu_call(set_pmc_eventsel_hw_enable)(vcpu, bitmap, enable);
> > +}
> > +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_pmu_set_pmc_eventsel_hw_enable);
>
> Why bounce through a PMU op just to go from nested.c to pmu.c?  AFAICT, c=
ommon
> x86 code never calls kvm_pmu_set_pmc_eventsel_hw_enable(), just wire up c=
alls
> directly to amd_pmu_refresh_host_guest_eventsels().

It seemed that pmu.c deliberately didn't export anything. All accesses
were via virtual function table. But maybe that was just happenstance.
Should I create a separate pmu.h, or just throw the prototype into
svm.h?

> > @@ -1054,6 +1055,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> >       if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
> >               goto out_exit_err;
> >
> > +     kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
> > +             vcpu_to_pmu(vcpu)->pmc_hostonly, false);
> > +     kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
> > +             vcpu_to_pmu(vcpu)->pmc_guestonly, true);
> > +
> >       if (nested_svm_merge_msrpm(vcpu))
> >               goto out;
> >
> > @@ -1137,6 +1143,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >
> >       /* Exit Guest-Mode */
> >       leave_guest_mode(vcpu);
> > +     kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
> > +             vcpu_to_pmu(vcpu)->pmc_hostonly, true);
> > +     kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
> > +             vcpu_to_pmu(vcpu)->pmc_guestonly, false);
> >       svm->nested.vmcb12_gpa =3D 0;
> >       WARN_ON_ONCE(svm->nested.nested_run_pending);
>
> I don't think these are the right places to hook.  Shouldn't KVM update t=
he
> event selectors on _all_ transitions, whether they're architectural or no=
t?  E.g.
> by wrapping {enter,leave}_guest_mode()?

You are so right! I will fix this in the next version.

> static void svm_enter_guest_mode(struct kvm_vcpu *vcpu)
> {
>         enter_guest_mode(vcpu);
>         amd_pmu_refresh_host_guest_eventsels(vcpu);
> }
>
> static void svm_leave_guest_mode(struct kvm_vcpu *vcpu)
> {
>         leave_guest_mode(vcpu);
>         amd_pmu_refresh_host_guest_eventsels(vcpu);
> }

