Return-Path: <kvm+bounces-4117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE0380DF9F
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 00:43:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 570EA28259F
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 23:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561AD56771;
	Mon, 11 Dec 2023 23:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LO/NJwRl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D3ACF
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 15:43:26 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d31be67c16so9010035ad.2
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 15:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702338206; x=1702943006; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L2CNIwBgf8qqJqiKqxAd6p8N8y1poBppmKnfZ/wvtKY=;
        b=LO/NJwRlwFspsaH6vN1v0xWssvr66YFxOJzgoYEKhMHcEnvKaB3FDLpIKr2xHgEiKc
         VGGh9WcYkfs6y5Fzbl6xty8kf5QIlsmzgP6g79A/4od176GTdXDSZX3woUHwSbfAAFks
         RtPgvdCY0Gh47kjNvRoPON5k+PKJv+baMk7+kskQS1qRO4uy0WkQnrbkkI8v6oGh6sUw
         kcMLrlB8UCPYtA02y3p+6DVXN7KsBBhChU4VyxkCRnebMOa9YP06PGbdt4PzCd50WD6C
         Dl383ilKUaAoh+gQJ8og0OaqZIA0Oup7ddo6SjwXt3OZzny8dd3QNJGCs4jzcP4AIXyd
         cKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702338206; x=1702943006;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L2CNIwBgf8qqJqiKqxAd6p8N8y1poBppmKnfZ/wvtKY=;
        b=YnbEJpXO2iZAn8GktflQwlNscWUSuInaH0OU2UOdtbIiBGg23WCmMVofpqT9iB+ZtG
         HppS5q2dqOyGQbQBgs+kPgsOqz3mCpzmBvShXeHtBQvMXxLfzvq25/HPaKd13dPSM2yO
         44UvTKEzKqCZAEUMbTMHUTFL3CY5PFIlbBYjzTCl2SEWgNMDAm/Pb0WACfOuVzLodqMf
         0vJR/1wT+fzGz8t1fublIv294XyGJfBclCLRq93I+3Hw13IDE2NaiTRShOzGgpSE0VEo
         fz7aKEH993Y6bh8Gr6GbzC59XGcjTz3F/O9hgBsze8XZl/+8JGbyHsiXhtFmB2QjHruS
         2TAQ==
X-Gm-Message-State: AOJu0YxS+nI+gyvP6aflzbDao32dwRtGwCgrinxY/sa8kzNZR3kn03l8
	uYZc12OzvT4dkUNDB8OVfepuYQbKb60=
X-Google-Smtp-Source: AGHT+IHN/X8vpCCGFmK83tyiDZb0nkShOkE/cOQzYYwhwDBDiWNivV7kXXOKQQJDyXYbj1jZ5AdUp5jMSGA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dacb:b0:1d0:9fdb:a958 with SMTP id
 q11-20020a170902dacb00b001d09fdba958mr42128plx.13.1702338205748; Mon, 11 Dec
 2023 15:43:25 -0800 (PST)
Date: Mon, 11 Dec 2023 15:43:24 -0800
In-Reply-To: <CALMp9eSp_9J9t3ByfHfnirXf=uxvWVWVtLWO5KPoO0nDFJ-gtw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com> <20231202000417.922113-11-seanjc@google.com>
 <b45efe2f-1b99-4596-b33f-d491726ed34d@linux.intel.com> <CALMp9eSp_9J9t3ByfHfnirXf=uxvWVWVtLWO5KPoO0nDFJ-gtw@mail.gmail.com>
Message-ID: <ZXeenJ6DAugGCaSN@google.com>
Subject: Re: [PATCH v9 10/28] KVM: x86/pmu: Explicitly check for RDPMC of
 unsupported Intel PMC types
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 11, 2023, Jim Mattson wrote:
> On Sun, Dec 10, 2023 at 10:26=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.int=
el.com> wrote:
> >
> >
> > On 12/2/2023 8:03 AM, Sean Christopherson wrote:
> > > Explicitly check for attempts to read unsupported PMC types instead o=
f
> > > letting the bounds check fail.  Functionally, letting the check fail =
is
> > > ok, but it's unnecessarily subtle and does a poor job of documenting =
the
> > > architectural behavior that KVM is emulating.
> > >
> > > Opportunistically add macros for the type vs. index to further docume=
nt
> > > what is going on.
> > >
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >   arch/x86/kvm/vmx/pmu_intel.c | 11 +++++++++--
> > >   1 file changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_inte=
l.c
> > > index 644de27bd48a..bd4f4bdf5419 100644
> > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > @@ -23,6 +23,9 @@
> > >   /* Perf's "BASE" is wildly misleading, this is a single-bit flag, n=
ot a base. */
> > >   #define INTEL_RDPMC_FIXED   INTEL_PMC_FIXED_RDPMC_BASE
> > >
> > > +#define INTEL_RDPMC_TYPE_MASK        GENMASK(31, 16)
> > > +#define INTEL_RDPMC_INDEX_MASK       GENMASK(15, 0)
> > > +
> > >   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFC=
TR0)
> > >
> > >   static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
> > > @@ -82,9 +85,13 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(stru=
ct kvm_vcpu *vcpu,
> > >       /*
> > >        * Fixed PMCs are supported on all architectural PMUs.  Note, K=
VM only
> > >        * emulates fixed PMCs for PMU v2+, but the flag itself is stil=
l valid,
> > > -      * i.e. let RDPMC fail due to accessing a non-existent counter.
> > > +      * i.e. let RDPMC fail due to accessing a non-existent counter.=
  Reject
> > > +      * attempts to read all other types, which are unknown/unsuppor=
ted.
> > >        */
> > > -     idx &=3D ~INTEL_RDPMC_FIXED;
> > > +     if (idx & INTEL_RDPMC_TYPE_MASK & ~INTEL_RDPMC_FIXED)
>=20
> You know how I hate to be pedantic (ROFL), but the SDM only says:
>=20
> If the processor does support architectural performance monitoring
> (CPUID.0AH:EAX[7:0] =E2=89=A0 0), ECX[31:16] specifies type of PMC while
> ECX[15:0] specifies the index of the PMC to be read within that type.
>=20
> It does not say that the types are bitwise-exclusive.
>=20
> Yes, the types defined thus far are bitwise-exclusive, but who knows
> what tomorrow may bring?

The goal isn't to make the types exclusive, the goal is to reject types tha=
t
aren't supported by KVM.  The above accomplishes that, no?  I don't see how=
 KVM
could get a false negative or false positive, the above allows exactly FIXE=
D and
"none" types.  Or are you objecting to the comment?

