Return-Path: <kvm+bounces-1406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B0A7E760E
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:52:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9994A28167B
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45F4EA9;
	Fri, 10 Nov 2023 00:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F7HaCclW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF0DA40
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:52:04 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109FC3850
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:52:04 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6b31cb3cc7eso1527618b3a.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 16:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699577523; x=1700182323; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CaXRIkgga9Mbd8IaWbzrZruI1+6G67OpEX1+PWQwT6Q=;
        b=F7HaCclW92vWchWE6CS0/hgKUcrN61PEYhf3VNl59nGQU8HO2VmxWMtkkvITj6w/us
         MZ/IYDF8qlQ+2FpzHJ0dXzcDgljvFIr71N7uf4/WbKbYyL1yEG3Z6qNCSqWl71SwVwln
         saYcDRbH/F5tW09j0rK0RlDdxHG417GjJOyPN9sI8OcEqwcSkjgAYr47Nj3ajTBAIf8w
         ILztUP+fkU8mn0SWujkyZ7EUalMltB2UsKMQvQ/qARnCx3jdqAqbljRT+KcO5jCsX9om
         XUOxVEhxZ3CsBEQsGvhEhLzMa0TmhLcmHMA+y0cKJEnQyczEIq83GNTTX7sg2gZJRwEi
         JD6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699577523; x=1700182323;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CaXRIkgga9Mbd8IaWbzrZruI1+6G67OpEX1+PWQwT6Q=;
        b=dUoU7hU5RrtSbh6dyMkpI/Z9OL5QzZI2/SyEZX+aCKPeOINMnyw0oOM1yFwcai4AoS
         hSxK6GNHAO75M1BYNHIkWIYAgPhx5r2nUB1hA01z2t7dqZHe+cwwOO3aOaFxfYSzphvf
         BODGjZJv2RWGFnen+clGJWvVvb/z0V7Ws05uW/y+wKzNYdZjMVzSYfhefP7tgD8kJTWf
         qxH+Kf5AWXajnYI7Qp/PplrdGHumJku57vlO7KsVgVf7Cjcqgn7dN+NACqYUZdz8QQJO
         ZIQ2hIbC0h7hCZjy1ykDS+weYxZI5GgAr7iy/tlrLC8w8lmhYUV6Uhm0uV/YJsi2FN3a
         RfCA==
X-Gm-Message-State: AOJu0YxEwf4H1cblwLly9biKkFsEytoEvUA0tZVldaMtQSdtzPMlWviL
	J5K77vXCD4mZfqs4fGXcE9aDjDPuk80=
X-Google-Smtp-Source: AGHT+IEleztEQXckmOw7ag1CDdfyMSONAMeNUT17fzoOAYUS0cSBFGncdHLVezawzVjGRkeJMyfugEhb/wU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:84c1:b0:692:c216:8830 with SMTP id
 gl1-20020a056a0084c100b00692c2168830mr318481pfb.0.1699577523585; Thu, 09 Nov
 2023 16:52:03 -0800 (PST)
Date: Fri, 10 Nov 2023 00:52:01 +0000
In-Reply-To: <CALMp9eTqdg32KGh38wQYW-fvyrjrc7VQAsA1wnHhoCn-tLwyYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <CALMp9eQGqqo66fQGwFJMc3y+9XdUrL7ageE8kvoAOV6NJGfJpw@mail.gmail.com>
 <ZU1ua1mHDZFTmkHX@google.com> <CALMp9eTqdg32KGh38wQYW-fvyrjrc7VQAsA1wnHhoCn-tLwyYg@mail.gmail.com>
Message-ID: <ZU1-sTcb2fvU2TYZ@google.com>
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
> On Thu, Nov 9, 2023 at 3:42=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Thu, Nov 09, 2023, Jim Mattson wrote:
> > > A better solution may be to maintain two bitmaps of general purpose
> > > counters that need to be incremented, one for instructions retired an=
d
> > > one for branch instructions retired. Set or clear these bits whenever
> > > the PerfEvtSelN MSRs are written. I think I would keep the PGC bits
> > > separate, on those microarchitectures that support PGC. Then,
> > > kvm_pmu_trigger_event() need only consult the appropriate bitmap (or
> > > the logical and of that bitmap with PGC). In most cases, the value
> > > will be zero, and the function can simply return.
> > >
> > > This would work even for AMD microarchitectures that don't support PG=
C.
> >
> > Yeah.  There are multiple lower-hanging fruits to be picked though, mos=
t of which
> > won't conflict with using dedicated per-event bitmaps, or at worst are =
trivial
> > to resolve.
> >
> >  1. Don't call into perf to get the eventsel (which generates an indire=
ct call)
> >     on every invocation, let alone every iteration.
> >
> >  2. Avoid getting the CPL when it's irrelevant.
> >
> >  3. Check the eventsel before querying the event filter.
> >
> >  4. Mask out PMCs that aren't globally enabled from the get-go (masking=
 out
> >     PMCs based on eventsel would essentially be the same as per-event b=
itmaps).
>=20
> The code below only looks at PGC. Even on CPUs that support PGC, some
> PMU clients still use the enable bits in the PerfEvtSelN. Linux perf,
> for instance, can't seem to make up its mind whether to use PGC or
> PerfEvtSelN.EN.

Ugh, as in perf leaves all GLOBAL_CTRL bits set and toggles only the events=
el
enable bit?  Lame.

> > I'm definitely not opposed to per-event bitmaps, but it'd be nice to av=
oid them,
> > e.g. if we can eke out 99% of the performance just by doing a few obvio=
us
> > optimizations.
> >
> > This is the end result of what I'm testing and will (hopefully) post sh=
ortly:
> >
> > static inline bool pmc_is_eventsel_match(struct kvm_pmc *pmc, u64 event=
sel)
> > {
> >         return !((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB);
> > }
>=20
> The top nybble of AMD's 3-nybble event select collides with Intel's
> IN_TX and IN_TXCP bits. I think we can assert that the vCPU can't be
> in a transaction if KVM is emulating an instruction, but this probably
> merits a comment.

Argh, more pre-existing crud.  This is silly, the vendor mask is already in
kvm_pmu_ops.EVENTSEL_EVENT.  What's one more patch...

> The function name should also be more descriptive, so that it doesn't get
> misused out of context. :)

Heh, I think I'll just delete the darn thing.  That also makes it easier to
understand the comment about ignoring certain fields.

