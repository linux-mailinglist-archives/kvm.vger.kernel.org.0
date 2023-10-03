Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A0B7B73E2
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 00:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241190AbjJCWDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 18:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjJCWDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 18:03:33 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2F9AB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 15:03:30 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-65b0c9fb673so8064356d6.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 15:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696370609; x=1696975409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrSkqGEV7zYALyig+dy2qkh8ACgD/TSMuqcTHGTL0uA=;
        b=MPc4zMyhRZlUz1/PYKadBgW83YJ/C0nxGYu/8NJKqRWBGRYzuVi39FgoYKQKD/JtS7
         lRr+b38xJo8h+c2Ssuq8PWUS8thgCCD83sAJqfNaMmwAxI/Sr8+KZ4RuFxE5VHRgUXq+
         PE7tEavvqZN8UEuiqps4YCFaXvN36r8tF4gUeLvnqj4RAVdOBPiSHnAZTuo6OLaUYURW
         4m7B2TdqHi9h6oAx9Ddy/7XDi1xUYTUFGXBND+HrhgeSRc3keiDrxnPK1etmem2ocLcx
         v4NSboBcYeazkRO/mN464F1Mw0dl6pYIY4tBpx+90KRw72gXNrBWQ69AxJ4THr1BZHKp
         9lCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696370609; x=1696975409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nrSkqGEV7zYALyig+dy2qkh8ACgD/TSMuqcTHGTL0uA=;
        b=snaMfBrrkgG1jWnxyd45CS2iX9rDvx1tXGBPUJZO4ZMZcjamQ6JtF1jcgYs89sOmVp
         jn6B/rAtla2eL+bIwgMtlmYVFNMItiY9r5HsQnocfwOhEpqqmysfVLNX/UaBDP7cJKgf
         0t9ircVSHOC0uRKcaxEw3orfVd40Akq6qpcNAqMqoOuE0q22pQ/vbloZCOE6Eoxze40K
         9oB8TzSF4FHlyQR5fj828w7YI3xsb1aqGM25a0xZdU7Za/Oob5EYUqwXqqcCYPXOlY+o
         uo+ZfgdvT1z/B8Pziji95PM/LJ4vHTnXBkaaVHd8/tolqFsfrmcycTAbyWjHMlwPNMac
         Lusg==
X-Gm-Message-State: AOJu0YzATpbJm36NOdwq9kZfZza9PG6fhhwQGA+3q0xX3lZwiQRGp4PV
        6IDZZdAWTSYNLJopnC+043f/0+TPQuQzDqtEh7XsBA==
X-Google-Smtp-Source: AGHT+IHEOZCsS0mVwbHXXQUK8lL8I1Neq+QgI2XV25twUjgll1vTrMvhs5/MvZ8CYpB2qBR3TPu+PLW/AQx2wkxdlLE=
X-Received: by 2002:a05:6214:449d:b0:65b:771:f2d5 with SMTP id
 on29-20020a056214449d00b0065b0771f2d5mr575468qvb.61.1696370609164; Tue, 03
 Oct 2023 15:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com> <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com> <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net> <ZRtmvLJFGfjcusQW@google.com>
In-Reply-To: <ZRtmvLJFGfjcusQW@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 3 Oct 2023 15:02:52 -0700
Message-ID: <CAL715WLbAnnGUiTdHPO0L7v2FHGa5qmTnWJDi8k9qVkGry5GGQ@mail.gmail.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 2, 2023 at 5:56=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Oct 02, 2023, Peter Zijlstra wrote:
> > On Mon, Oct 02, 2023 at 08:56:50AM -0700, Sean Christopherson wrote:
> > > > > worse it's not a choice based in technical reality.
> > >
> > > The technical reality is that context switching the PMU between host =
and guest
> > > requires reading and writing far too many MSRs for KVM to be able to =
context
> > > switch at every VM-Enter and every VM-Exit.  And PMIs skidding past V=
M-Exit adds
> > > another layer of complexity to deal with.
> >
> > I'm not sure what you're suggesting here. It will have to save/restore
> > all those MSRs anyway. Suppose it switches between vCPUs.
>
> The "when" is what's important.   If KVM took a literal interpretation of
> "exclude guest" for pass-through MSRs, then KVM would context switch all =
those
> MSRs twice for every VM-Exit=3D>VM-Enter roundtrip, even when the VM-Exit=
 isn't a
> reschedule IRQ to schedule in a different task (or vCPU).  The overhead t=
o save
> all the host/guest MSRs and load all of the guest/host MSRs *twice* for e=
very
> VM-Exit would be a non-starter.  E.g. simple VM-Exits are completely hand=
led in
> <1500 cycles, and "fastpath" exits are something like half that.  Switchi=
ng all
> the MSRs is likely 1000+ cycles, if not double that.

Hi Sean,

Sorry, I have no intention to interrupt the conversation, but this is
slightly confusing to me.

I remember when doing AMX, we added gigantic 8KB memory in the FPU
context switch. That works well in Linux today. Why can't we do the
same for PMU? Assuming we context switch all counters, selectors and
global stuff there?

On the VM boundary, all we need is for global ctrl, right? We stop all
counters when we exit from the guest and restore the guest value of
global control when entering it. But the actual PMU context switch
should be deferred roughly to the same time we switch FPU (xsave
state). This means we do that when switching task_struct and/or
returning to userspace.

Please kindly correct me if this is flawed.

ah, I think I understand what you are saying... So, "If KVM took a
literal interpretation of "exclude guest" for pass-through MSRs..."

perf_event.attr.exclude_guest might need a different meaning, if we
have a pass-through PMU for KVM. exclude_guest=3D1 does not mean the
counters are restored at the VMEXIT boundary, which is a disaster if
we do that.

Thanks.
-Mingwei


-Mingwei


>
> FWIW, the primary use case we care about is for slice-of-hardware VMs, wh=
ere each
> vCPU is pinned 1:1 with a host pCPU.  I suspect it's a similar story for =
the other
> CSPs that are trying to provide accurate PMUs to guests.  If a vCPU is sc=
heduled
> out, then yes, a bunch of context switching will need to happen.  But for=
 the
> types of VMs that are the target audience, their vCPUs will rarely be sch=
eduled
> out.
>
> > > > > It's a choice out of lazyness, disabling host PMU is not a requir=
ement
> > > > > for pass-through.
> > >
> > > The requirement isn't passthrough access, the requirements are that t=
he guest's
> > > PMU has accuracy that is on par with bare metal, and that exposing a =
PMU to the
> > > guest doesn't have a meaningful impact on guest performance.
> >
> > Given you don't think that trapping MSR accesses is viable, what else
> > besides pass-through did you have in mind?
>
> Sorry, I didn't mean to imply that we don't want pass-through of MSRs.  W=
hat I was
> trying to say is that *just* passthrough MSRs doesn't solve the problem, =
because
> again I thought the whole "context switch PMU state less often" approach =
had been
> firmly nak'd.
>
> > > > Not just a choice of laziness, but it will clearly be forced upon u=
sers
> > > > by external entities:
> > > >
> > > >    "Pass ownership of the PMU to the guest and have no host PMU, or=
 you
> > > >     won't have sane guest PMU support at all. If you disagree, plea=
se open
> > > >     a support ticket, which we'll ignore."
> > >
> > > We don't have sane guest PMU support today.
> >
> > Because KVM is too damn hard to use, rebooting a machine is *sooo* much
> > easier -- and I'm really not kidding here.
> >
> > Anyway, you want pass-through, but that doesn't mean host cannot use
> > PMU when vCPU thread is not running.
> >
> > > If y'all are willing to let KVM redefined exclude_guest to be KVM's o=
uter run
> > > loop, then I'm all for exploring that option.  But that idea got shot=
 down over
> > > a year ago[*].
> >
> > I never saw that idea in that thread. You virt people keep talking like
> > I know how KVM works -- I'm not joking when I say I have no clue about
> > virt.
> >
> > Sometimes I get a little clue after y'all keep bashing me over the head=
,
> > but it quickly erases itself.
> >
> > > Or at least, that was my reading of things.  Maybe it was just a
> > > misunderstanding because we didn't do a good job of defining the beha=
vior.
> >
> > This might be the case. I don't particularly care where the guest
> > boundary lies -- somewhere in the vCPU thread. Once the thread is gone,
> > PMU is usable again etc..
>
> Well drat, that there would have saved a wee bit of frustration.  Better =
late
> than never though, that's for sure.
>
> Just to double confirm: keeping guest PMU state loaded until the vCPU is =
scheduled
> out or KVM exits to userspace, would mean that host perf events won't be =
active
> for potentially large swaths of non-KVM code.  Any function calls or even=
t/exception
> handlers that occur within the context of ioctl(KVM_RUN) would run with h=
ost
> perf events disabled.
>
> Are you ok with that approach?  Assuming we don't completely botch things=
, the
> interfaces are sane, we can come up with a clean solution for handling NM=
Is, etc.
>
> > Re-reading parts of that linked thread, I see mention of
> > PT_MODE_HOST_GUEST -- see I knew we had something there, but I can neve=
r
> > remember all that nonsense. Worst part is that I can't find the relevan=
t
> > perf code when I grep for that string :/
>
> The PT stuff is actually an example of what we don't want, at least not e=
xactly.
> The concept of a hard switch between guest and host is ok, but as-is, KVM=
's PT
> code does a big pile of MSR reads and writes on every VM-Enter and VM-Exi=
t.
>
> > Anyway, what I don't like is KVM silently changing all events to
> > ::exclude_guest=3D1. I would like all (pre-existing) ::exclude_guest=3D=
0
> > events to hard error when they run into a vCPU with pass-through on
> > (PERF_EVENT_STATE_ERROR). I would like event-creation to error out on
> > ::exclude_guest=3D0 events when a vCPU with pass-through exists -- with
> > minimal scope (this probably means all CPU events, but only relevant
> > vCPU events).
>
> Agreed, I am definitely against KVM silently doing anything.  And the mor=
e that
> is surfaced to the user, the better.
>
> > It also means ::exclude_guest should actually work -- it often does not
> > today -- the IBS thing for example totally ignores it.
>
> Is that already an in-tree, or are you talking about Manali's proposed se=
ries to
> support virtualizing IBS?
>
> > Anyway, none of this means host cannot use PMU because virt muck wants
> > it.
