Return-Path: <kvm+bounces-5652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDAA7824454
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 16:01:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E643F1C21F56
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 15:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E869241FD;
	Thu,  4 Jan 2024 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kd2fCAmh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4D420DDF
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704380408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aezVZ21RXwDSPznUaEfqO8ObQ6DAwMB4uYqaeR9muhs=;
	b=Kd2fCAmhoK0LpFlKeE2/ZmWLy+vejFuNGitUz2YD7+GTvUZprE2ihH0DH+FNLaqOTcDHa2
	m4NFZWqC06XcR5QDYdFpuxMEmO/6Bfc+runm9jpzh1sZsGyef/ozfSacHtTDe+nzYk0zh6
	XDBRllbDw85MyMTo0WLJ6QJiPx2U3jc=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-UbCQxDktMp-AyM0qHQek8Q-1; Thu, 04 Jan 2024 10:00:05 -0500
X-MC-Unique: UbCQxDktMp-AyM0qHQek8Q-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-46734fa034cso174723137.2
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 07:00:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704380405; x=1704985205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aezVZ21RXwDSPznUaEfqO8ObQ6DAwMB4uYqaeR9muhs=;
        b=jXUmyxN85QKEcHKrePHSU+OSw4RNAySOauHcRV5+Vuqm/PxAzwO7RftqoAn+pShl+/
         KkJNNGNWh1ch7QWaeQadmNPYy/YWwFx06a31tF70s87rmyn1JyUxKCsC0ym/2KrPQUH+
         gyuTy7GBmRCykNa34xGd2mbm2Ao7B5KZ2NArHhEgP/DDcu2ei2mHSQ1oA5czuzvNFMsS
         qnAjihMbNNOEG0/hg+IK47REV8nuXA8rltQoNhe41NXTed0qXgzhQEzAdTFDH8E9OWVK
         WoeKFAkBe7RJCpaorGVt/F3Y514+dLgCB/vUmUHRQ8sYHMbTIUTovviRqsWGG+L/NzdB
         mzNA==
X-Gm-Message-State: AOJu0Yw22ZjvyajSsUmn7dapZG8uUERtBWP/dp8Z9kDNp4EQF4VOM3Sm
	h4teFkmLWrfN3AeR1NemnqIsqFFV+/3Rswwwx03aX8hxaTZ/zPUP51HYLNcJgMe6Claukk+eiND
	OEBCccVWfO0pr0TpdLCoiRgbHvIiYrYu/3Fk8
X-Received: by 2002:a05:6102:3d0c:b0:467:ab82:8541 with SMTP id i12-20020a0561023d0c00b00467ab828541mr539155vsv.2.1704380405012;
        Thu, 04 Jan 2024 07:00:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF2HsVP41TbYsCNRo6/+4LVhY17gL8avGvalNBhnIivjxsS/wGVW5B9BBDLt8t9XK0c/FrtR1NieWMjipPujkQ=
X-Received: by 2002:a05:6102:3d0c:b0:467:ab82:8541 with SMTP id
 i12-20020a0561023d0c00b00467ab828541mr539149vsv.2.1704380404783; Thu, 04 Jan
 2024 07:00:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
 <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop> <ZZX6pkHnZP777DVi@google.com>
 <77d7a3e3-f35e-4507-82c2-488405b25fa4@paulmck-laptop> <c6d5dd6e-2dec-423c-af39-213f17b1a9db@paulmck-laptop>
In-Reply-To: <c6d5dd6e-2dec-423c-af39-213f17b1a9db@paulmck-laptop>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 4 Jan 2024 15:59:52 +0100
Message-ID: <CABgObfYG-ZwiRiFeGbAgctLfj7+PSmgauN9RwGMvZRfxvmD_XQ@mail.gmail.com>
Subject: Re: [BUG] Guest OSes die simultaneously (bisected)
To: paulmck@kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Like Xu <like.xu@linux.intel.com>, 
	Andi Kleen <ak@linux.intel.com>, Kan Liang <kan.liang@linux.intel.com>, 
	Luwei Kang <luwei.kang@intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 3:58=E2=80=AFPM Paul E. McKenney <paulmck@kernel.org=
> wrote:
>
> On Wed, Jan 03, 2024 at 05:00:35PM -0800, Paul E. McKenney wrote:
> > On Wed, Jan 03, 2024 at 04:24:06PM -0800, Sean Christopherson wrote:
> > > On Wed, Jan 03, 2024, Paul E. McKenney wrote:
> > > > On Wed, Jan 03, 2024 at 02:22:23PM -0800, Paul E. McKenney wrote:
> > > > > Hello!
> > > > >
> > > > > Since some time between v5.19 and v6.4, long-running rcutorture t=
ests
> > > > > would (rarely but intolerably often) have all guests on a given h=
ost die
> > > > > simultaneously with something like an instruction fault or a segm=
entation
> > > > > violation.
> > > > >
> > > > > Each bisection step required 20 hosts running 10 hours each, and
> > > > > this eventually fingered commit c59a1f106f5c ("KVM: x86/pmu: Add
> > > > > IA32_PEBS_ENABLE MSR emulation for extended PEBS").  Although thi=
s commit
> > > > > is certainly messing with things that could possibly cause all ma=
nner
> > > > > of mischief, I don't immediately see a smoking gun.  Except that =
the
> > > > > commit prior to this one is rock solid.
> > > > > Just to make things a bit more exciting, bisection in mainline pr=
oved
> > > > > to be problematic due to bugs of various kinds that hid this one.=
  I was
> > > > > therefore forced to bisect among the commits backported to the in=
ternal
> > > > > v5.19-based kernel, which fingered the backported version of the =
patch
> > > > > called out above.
> > > >
> > > > Ah, and so why do I believe that this is a problem in mainline rath=
er
> > > > than just (say) a backporting mistake?
> > > >
> > > > Because this issue was first located in v6.4, which already has thi=
s
> > > > commit included.
> > > >
> > > >                                                   Thanx, Paul
> > > >
> > > > > Please note that this is not (yet) an emergency.  I will just con=
tinue
> > > > > to run rcutorture on v5.19-based hypervisors in the meantime.
> > > > >
> > > > > Any suggestions for debugging or fixing?
> > >
> > > This looks suspect:
> > >
> > > +       u64 pebs_mask =3D cpuc->pebs_enabled & x86_pmu.pebs_capable;
> > > +       int global_ctrl, pebs_enable;
> > >
> > > -       arr[0].msr =3D MSR_CORE_PERF_GLOBAL_CTRL;
> > > -       arr[0].host =3D intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
> > > -       arr[0].guest =3D intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> > > -       arr[0].guest &=3D ~(cpuc->pebs_enabled & x86_pmu.pebs_capable=
);
> > > -       *nr =3D 1;
> > > +       *nr =3D 0;
> > > +       global_ctrl =3D (*nr)++;
> > > +       arr[global_ctrl] =3D (struct perf_guest_switch_msr){
> > > +               .msr =3D MSR_CORE_PERF_GLOBAL_CTRL,
> > > +               .host =3D intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> > > +               .guest =3D intel_ctrl & (~cpuc->intel_ctrl_host_mask =
| ~pebs_mask),
> > > +       };
> > >
> > >
> > > IIUC (always a big if with this code), the intent is that the guest's=
 version of
> > > PERF_GLOBAL_CTRL gets bits that are (a) not exclusive to the host and=
 (b) not
> > > being used for PEBS.  (b) is necessary because PEBS generates records=
 in memory
> > > using virtual addresses, i.e. the CPU will write to memory using a vi=
rtual address
> > > that is valid for the host but not the guest.  And so PMU counters th=
at are
> > > configured to generate PEBS records need to be disabled while running=
 the guest.
> > >
> > > Before that commit, the logic was:
> > >
> > >   guest[PERF_GLOBAL_CTRL] =3D ctrl & ~host;
> > >   guest[PERF_GLOBAL_CTRL] &=3D ~pebs;
> > >
> > > But after, it's now:
> > >
> > >   guest[PERF_GLOBAL_CTRL] =3D ctrl & (~host | ~pebs);
> > >
> > > I.e. the kernel is enabled counters in the guest that are not host-on=
ly OR not
> > > PEBS.  E.g. if only counter 0 is in use, it's using PEBS, but it's no=
t exclusive
> > > to the host, then the new code will yield (truncated to a single byte=
 for sanity)
> > >
> > >   1 =3D 1 & (0xf | 0xe)
> > >
> > > and thus keep counter 0 enabled, whereas the old code would yield
> > >
> > >   1 =3D 1 & 0xf
> > >   0 =3D 1 & 0xe
> > >
> > > A bit of a shot in the dark and completed untested, but I think this =
is the correct
> > > fix?
> >
> > I am firing off some tests, and either way, thank you very much!!!
>
> Woo-hoo!!!  ;-)
>
> Tested-by: Paul E. McKenney <paulmck@kernel.org>
>
> Will you be sending a proper patch, or would you prefer that I do so?
> In the latter case, I would need your Signed-off-by.

I will fast track this one to Linus.

Paolo

> And again, thank you very much!!!
>
>                                                         Thanx, Paul
>
> > > diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/cor=
e.c
> > > index a08f794a0e79..92d5a3464cb2 100644
> > > --- a/arch/x86/events/intel/core.c
> > > +++ b/arch/x86/events/intel/core.c
> > > @@ -4056,7 +4056,7 @@ static struct perf_guest_switch_msr *intel_gues=
t_get_msrs(int *nr, void *data)
> > >         arr[global_ctrl] =3D (struct perf_guest_switch_msr){
> > >                 .msr =3D MSR_CORE_PERF_GLOBAL_CTRL,
> > >                 .host =3D intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> > > -               .guest =3D intel_ctrl & (~cpuc->intel_ctrl_host_mask =
| ~pebs_mask),
> > > +               .guest =3D intel_ctrl & ~(cpuc->intel_ctrl_host_mask =
| pebs_mask),
> > >         };
> > >
> > >         if (!x86_pmu.pebs)
> > >
>


