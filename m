Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0F7B5E65
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 02:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjJCA4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 20:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjJCA4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 20:56:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4D1B0
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 17:56:30 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c754c90b4bso3774255ad.2
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 17:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696294590; x=1696899390; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yj2LydfbYuVN73T9ynH1N69l8bJp0s1/U19rUmj6vQM=;
        b=iWDfm2bKG71c0O570jcKvoWTYt317X39rgjXONpDQGV2FMdyhDol8T2Q8+IzKNB6NC
         b0RQ0gIsiB5YIeJ9/ibF0x8AkQaatu7aafAa9KmOD5nC8VPUyxaDBWQA5rl/FPpYJ9U3
         lT+9gxgDr6NWb7hpglwXaPyOgeEoCa5dr3TUluYPiwG1c8JwdYh7SSoRlljM2YFavU8v
         BBZjRkgd+kXjW1PuBRpiZ6xA2D4aWHVGSZldjciHJBkUqS/LyVRy2gZdTLKBKAUpDRIs
         M5z/b5aUY11hROtjsmr8/EQpMEJDCXkIFmGrpfkPg9s0/8qTvQ6S+7u5ImLsQEs3hqrb
         p4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696294590; x=1696899390;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yj2LydfbYuVN73T9ynH1N69l8bJp0s1/U19rUmj6vQM=;
        b=U2QaLC/c26HCgpVkg6Bu14Mk+DmQYxyrtDYdMbG+XCz82SMsvWOstfNlH9ksYiNtc/
         DjADz75yTM6YKqxeMPGx9oz3LgUJMPcm6fjwB/l4s58d/im1fktuouagF5clYUcp548W
         wkqdzPi2qeE5PzVNL52VkTSIhbjj6EU3DjUk9eHU8W3TSq3a+meRlQKdgA2eUZ9PxUn6
         4QngONylvAUhWwCthx5M/HJ4D/FTQ4QgbJooTM0K0MXSYSoOjFM06WTKgQzVrbtlZp62
         NGQbEIxGM2XAeoqc7ceZLUp+yZBuhhoXLdm69Mq6j5Vi78iDXAVNCYalJZY9zUZeEuqe
         hmEA==
X-Gm-Message-State: AOJu0YzXGhjWHOBoXxcNJLz6LmcbbIbYkkEtyZz8qd0oPDV//jP3OZZL
        f0/6GQvSN6kTLu7/MnbRV0wvGolgKtk=
X-Google-Smtp-Source: AGHT+IFcguWqUhm6JFgKYW6t/nQZcIErhbpBsBan76uqxUkigrtIbXoKbtCxAfZWBlGGFPKw7JX2utPfTss=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:db04:b0:1bc:5182:1de2 with SMTP id
 m4-20020a170902db0400b001bc51821de2mr226409plx.1.1696294589834; Mon, 02 Oct
 2023 17:56:29 -0700 (PDT)
Date:   Mon, 2 Oct 2023 17:56:28 -0700
In-Reply-To: <20231002204017.GB27267@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com> <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com> <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com> <20231002204017.GB27267@noisy.programming.kicks-ass.net>
Message-ID: <ZRtmvLJFGfjcusQW@google.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
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
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, Peter Zijlstra wrote:
> On Mon, Oct 02, 2023 at 08:56:50AM -0700, Sean Christopherson wrote:
> > > > worse it's not a choice based in technical reality.
> > 
> > The technical reality is that context switching the PMU between host and guest
> > requires reading and writing far too many MSRs for KVM to be able to context
> > switch at every VM-Enter and every VM-Exit.  And PMIs skidding past VM-Exit adds
> > another layer of complexity to deal with.
> 
> I'm not sure what you're suggesting here. It will have to save/restore
> all those MSRs anyway. Suppose it switches between vCPUs.

The "when" is what's important.   If KVM took a literal interpretation of
"exclude guest" for pass-through MSRs, then KVM would context switch all those
MSRs twice for every VM-Exit=>VM-Enter roundtrip, even when the VM-Exit isn't a
reschedule IRQ to schedule in a different task (or vCPU).  The overhead to save
all the host/guest MSRs and load all of the guest/host MSRs *twice* for every
VM-Exit would be a non-starter.  E.g. simple VM-Exits are completely handled in
<1500 cycles, and "fastpath" exits are something like half that.  Switching all
the MSRs is likely 1000+ cycles, if not double that.

FWIW, the primary use case we care about is for slice-of-hardware VMs, where each
vCPU is pinned 1:1 with a host pCPU.  I suspect it's a similar story for the other
CSPs that are trying to provide accurate PMUs to guests.  If a vCPU is scheduled
out, then yes, a bunch of context switching will need to happen.  But for the
types of VMs that are the target audience, their vCPUs will rarely be scheduled
out.

> > > > It's a choice out of lazyness, disabling host PMU is not a requirement
> > > > for pass-through.
> > 
> > The requirement isn't passthrough access, the requirements are that the guest's
> > PMU has accuracy that is on par with bare metal, and that exposing a PMU to the
> > guest doesn't have a meaningful impact on guest performance.
> 
> Given you don't think that trapping MSR accesses is viable, what else
> besides pass-through did you have in mind?

Sorry, I didn't mean to imply that we don't want pass-through of MSRs.  What I was
trying to say is that *just* passthrough MSRs doesn't solve the problem, because
again I thought the whole "context switch PMU state less often" approach had been
firmly nak'd.

> > > Not just a choice of laziness, but it will clearly be forced upon users
> > > by external entities:
> > > 
> > >    "Pass ownership of the PMU to the guest and have no host PMU, or you
> > >     won't have sane guest PMU support at all. If you disagree, please open
> > >     a support ticket, which we'll ignore."
> > 
> > We don't have sane guest PMU support today.
> 
> Because KVM is too damn hard to use, rebooting a machine is *sooo* much
> easier -- and I'm really not kidding here.
> 
> Anyway, you want pass-through, but that doesn't mean host cannot use
> PMU when vCPU thread is not running.
> 
> > If y'all are willing to let KVM redefined exclude_guest to be KVM's outer run
> > loop, then I'm all for exploring that option.  But that idea got shot down over
> > a year ago[*]. 
> 
> I never saw that idea in that thread. You virt people keep talking like
> I know how KVM works -- I'm not joking when I say I have no clue about
> virt.
> 
> Sometimes I get a little clue after y'all keep bashing me over the head,
> but it quickly erases itself.
>
> > Or at least, that was my reading of things.  Maybe it was just a
> > misunderstanding because we didn't do a good job of defining the behavior.
> 
> This might be the case. I don't particularly care where the guest
> boundary lies -- somewhere in the vCPU thread. Once the thread is gone,
> PMU is usable again etc..

Well drat, that there would have saved a wee bit of frustration.  Better late
than never though, that's for sure.

Just to double confirm: keeping guest PMU state loaded until the vCPU is scheduled
out or KVM exits to userspace, would mean that host perf events won't be active
for potentially large swaths of non-KVM code.  Any function calls or event/exception
handlers that occur within the context of ioctl(KVM_RUN) would run with host
perf events disabled.

Are you ok with that approach?  Assuming we don't completely botch things, the
interfaces are sane, we can come up with a clean solution for handling NMIs, etc.

> Re-reading parts of that linked thread, I see mention of
> PT_MODE_HOST_GUEST -- see I knew we had something there, but I can never
> remember all that nonsense. Worst part is that I can't find the relevant
> perf code when I grep for that string :/

The PT stuff is actually an example of what we don't want, at least not exactly.
The concept of a hard switch between guest and host is ok, but as-is, KVM's PT
code does a big pile of MSR reads and writes on every VM-Enter and VM-Exit.

> Anyway, what I don't like is KVM silently changing all events to
> ::exclude_guest=1. I would like all (pre-existing) ::exclude_guest=0
> events to hard error when they run into a vCPU with pass-through on
> (PERF_EVENT_STATE_ERROR). I would like event-creation to error out on
> ::exclude_guest=0 events when a vCPU with pass-through exists -- with
> minimal scope (this probably means all CPU events, but only relevant
> vCPU events).

Agreed, I am definitely against KVM silently doing anything.  And the more that
is surfaced to the user, the better.

> It also means ::exclude_guest should actually work -- it often does not
> today -- the IBS thing for example totally ignores it.

Is that already an in-tree, or are you talking about Manali's proposed series to
support virtualizing IBS?

> Anyway, none of this means host cannot use PMU because virt muck wants
> it.
