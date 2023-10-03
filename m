Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD307B6CFD
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 17:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjJCPXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 11:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjJCPXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 11:23:32 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29DEA7
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 08:23:28 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a23fed55d7so15730367b3.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 08:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696346608; x=1696951408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ku2k6bqYSfGKotdN8kSOIqtcNeqWaahv/pJN4kCskfw=;
        b=IUKDQJmRYENZ/cCXAB8BiDftKArU2nPWsYzL0CZRMsY/+hlkITOygQ2FL6atvuhkEO
         fD+A3bHMrZhC2QAkNs0SBIKeD8bY4/WpsISZUSsd8hYhbCLXeV7Uwq6jj0VXDjmL2QeO
         bCg+LuPBynBZZdauIzRhWE342AnDY8Z6nZMF0jnjPzNqMV/Z1nm94Cm0bfMm0DFPHndB
         wpWLSoN3aTvRfxA2QGRseYdbz8ybazA+D1ucZMiLQ7Fs7bcV+RgPq8lUzxkMy0RStood
         BIQclJJLpmaYuApJ8sMfFaIoDIywhA1CSLQsiORrvGTTjifVO04h66/dpAdushkG7LNf
         pHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696346608; x=1696951408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ku2k6bqYSfGKotdN8kSOIqtcNeqWaahv/pJN4kCskfw=;
        b=YMwsa+62088Xdzx0efvQp2b79QJ6zCMdVtPAUdiNovLDgJddY5aoGNQL9VH3D1j580
         DylfwrKjJ8XCc36BcdSkzi8cDAG9DZSuLToJLJQ5cCtmtNyX4U7hkVWqPND4u/TkAbBY
         VWM1ESObPSzMBQqV43d92RSxEB/eGet+Fw5QDEOJn60ycI1//4jDdV0jxXPZFMPXFsP7
         PqW6nk8jo/vZDYinxJffYvpMFhmH8ASoiOfRy1Z2hbPP10cshHXcDAEkxx1JZgFjFsnL
         vjQ0ykLz6rF4ao8s23V0H1ENpBnQZrlYlxU7RxiImxQ/eaBixfx9YBdPbaCDmPKm0c1c
         6Llg==
X-Gm-Message-State: AOJu0YzDrtDwg0im+T8cn1qrzjWTLLer666VKBbP+AWyTdTuE/Gncdp8
        lHJrU6zw9CJP1LAYhAGmwTBOTcb8Ukk=
X-Google-Smtp-Source: AGHT+IEe60Ge08ChrKLbAE0AlUc3VERw2JR0sIjUUMnBW+5Ur0r4M/iclZyvuLfd5L/IwSVnwfIxDoiIqMQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6901:0:b0:d7e:dff4:b0fe with SMTP id
 e1-20020a256901000000b00d7edff4b0femr221605ybc.7.1696346607959; Tue, 03 Oct
 2023 08:23:27 -0700 (PDT)
Date:   Tue, 3 Oct 2023 08:23:26 -0700
In-Reply-To: <20231003081616.GE27267@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com> <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net> <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net>
Message-ID: <ZRwx7gcY7x1x3a5y@google.com>
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

On Tue, Oct 03, 2023, Peter Zijlstra wrote:
> On Mon, Oct 02, 2023 at 05:56:28PM -0700, Sean Christopherson wrote:
> > On Mon, Oct 02, 2023, Peter Zijlstra wrote:
> 
> > > I'm not sure what you're suggesting here. It will have to save/restore
> > > all those MSRs anyway. Suppose it switches between vCPUs.
> > 
> > The "when" is what's important.   If KVM took a literal interpretation of
> > "exclude guest" for pass-through MSRs, then KVM would context switch all those
> > MSRs twice for every VM-Exit=>VM-Enter roundtrip, even when the VM-Exit isn't a
> > reschedule IRQ to schedule in a different task (or vCPU).  The overhead to save
> > all the host/guest MSRs and load all of the guest/host MSRs *twice* for every
> > VM-Exit would be a non-starter.  E.g. simple VM-Exits are completely handled in
> > <1500 cycles, and "fastpath" exits are something like half that.  Switching all
> > the MSRs is likely 1000+ cycles, if not double that.
> 
> See, you're the virt-nerd and I'm sure you know what you're talking
> about, but I have no clue :-) I didn't know there were different levels
> of vm-exit.

An exit is essentially a fancy exception/event.  The hardware transition from
guest=>host is the exception itself (VM-Exit), and the transition back to guest
is analagous to the IRET (VM-Enter).

In between, software will do some amount of work, and the amount of work that is
done can vary quite significantly depending on what caused the exit.

> > FWIW, the primary use case we care about is for slice-of-hardware VMs, where each
> > vCPU is pinned 1:1 with a host pCPU.
> 
> I've been given to understand that vm-exit is a bad word in this
> scenario, any exit is a fail. They get MWAIT and all the other crap and
> more or less pretend to be real hardware.
> 
> So why do you care about those MSRs so much? That should 'never' happen
> in this scenario.

It's not feasible to completely avoid exits, as current/upcoming hardware doesn't
(yet) virtualize a few important things.  Off the top of my head, the two most
relevant flows are:

  - APIC_LVTPC entry and PMU counters.  If a PMU counter overflows, the NMI that
    is generated will trigger a hardware level NMI and cause an exit.  And sadly,
    the guest's NMI handler (assuming the guest is also using NMIs for PMIs) will
    trigger another exit when it clears the mask bit in its LVTPC entry.

  - Timer related IRQs, both in the guest and host.  These are the biggest source
    of exits on modern hardware.  Neither AMD nor Intel provide a virtual APIC
    timer, and so KVM must trap and emulate writes to TSC_DEADLINE (or to APIC_TMICT),
    and the subsequent IRQ will also cause an exit.

The cumulative cost of all exits is important, but the latency of each individual
exit is even more critical, especially for PMU related stuff.  E.g. if the guest
is trying to use perf/PMU to profile a workload, adding a few thousand cycles to
each exit will introduce too much noise into the results.

> > > > Or at least, that was my reading of things.  Maybe it was just a
> > > > misunderstanding because we didn't do a good job of defining the behavior.
> > > 
> > > This might be the case. I don't particularly care where the guest
> > > boundary lies -- somewhere in the vCPU thread. Once the thread is gone,
> > > PMU is usable again etc..
> > 
> > Well drat, that there would have saved a wee bit of frustration.  Better late
> > than never though, that's for sure.
> > 
> > Just to double confirm: keeping guest PMU state loaded until the vCPU is scheduled
> > out or KVM exits to userspace, would mean that host perf events won't be active
> > for potentially large swaths of non-KVM code.  Any function calls or event/exception
> > handlers that occur within the context of ioctl(KVM_RUN) would run with host
> > perf events disabled.
> 
> Hurmph, that sounds sub-optimal, earlier you said <1500 cycles, this all
> sounds like a ton more.
> 
> /me frobs around the kvm code some...
> 
> Are we talking about exit_fastpath loop in vcpu_enter_guest() ? That
> seems to run with IRQs disabled, so at most you can trigger a #PF or
> something, which will then trip an exception fixup because you can't run
> #PF with IRQs disabled etc..
>
> That seems fine. That is, a theoretical kvm_x86_handle_enter_irqoff()
> coupled with the existing kvm_x86_handle_exit_irqoff() seems like
> reasonable solution from where I'm sitting. That also more or less
> matches the FPU state save/restore AFAICT.
> 
> Or are you talking about the whole of vcpu_run() ? That seems like a
> massive amount of code, and doesn't look like anything I'd call a
> fast-path. Also, much of that loop has preemption enabled...

The whole of vcpu_run().  And yes, much of it runs with preemption enabled.  KVM
uses preempt notifiers to context switch state if the vCPU task is scheduled
out/in, we'd use those hooks to swap PMU state.

Jumping back to the exception analogy, not all exits are equal.  For "simple" exits
that KVM can handle internally, the roundtrip is <1500.   The exit_fastpath loop is
roughly half that.

But for exits that are more complex, e.g. if the guest hits the equivalent of a
page fault, the cost of handling the page fault can vary significantly.  It might
be <1500, but it might also be 10x that if handling the page fault requires faulting
in a new page in the host.

We don't want to get too aggressive with moving stuff into the exit_fastpath loop,
because doing too much work with IRQs disabled can cause latency problems for the
host.  This isn't much of a concern for slice-of-hardware setups, but would be
quite problematic for other use cases.

And except for obviously slow paths (from the guest's perspective), extra latency
on any exit can be problematic.  E.g. even if we got to the point where KVM handles
99% of exits the fastpath (may or may not be feasible), a not-fastpath exit at an
inopportune time could throw off the guest's profiling results, introduce unacceptable
jitter, etc.

> > Are you ok with that approach?  Assuming we don't completely botch things, the
> > interfaces are sane, we can come up with a clean solution for handling NMIs, etc.
> 
> Since you steal the whole PMU, can't you re-route the PMI to something
> that's virt friendly too?

Hmm, actually, we probably could.  It would require modifying the host's APIC_LVTPC
entry when context switching the PMU, e.g. to replace the NMI with a dedicated IRQ
vector.  As gross as that sounds, it might actually be cleaner overall than
deciphering whether an NMI belongs to the host or guest, and it would almost
certainly yield lower latency for guest PMIs.
