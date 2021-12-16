Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27D6477B18
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240519AbhLPRxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 12:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhLPRxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 12:53:09 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87555C061574
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 09:53:09 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id d1-20020a4a3c01000000b002c2612c8e1eso7134446ooa.6
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 09:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUk3r6uRdZZstXr19oFrcGqqIEvfpgBXAzGpX6aO2aI=;
        b=F51jXFih9cfIt7+sP30Z7BlB0LJc5Q6WnrvzpukaVFCYsQQaRJKNkb2FqI5xX0etQO
         c5dUCOjSHEHO2FwGd5+7lCkOfYADW4klk1o27jdpVeNGwHIddOpPz0zzd3sbmfTxua8y
         Omd2erwjaOTpOdACowfCpM24hJiQ/I/IYr8Kodgkfy0Hvv9hUenQ7al6F+oXzqldWG1y
         l/w8yHbHILssTk1biox9O6xhX2SpEkdgfqDoQm9EF64sHqeqsWpTM57jt8aNfpPu3I3r
         9F4v9SGzUS6SsHbtfzgzk9JQq5eP46+beABJAGk2SCMgKekBzmlWIBe5biqsAeOjBU95
         eXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUk3r6uRdZZstXr19oFrcGqqIEvfpgBXAzGpX6aO2aI=;
        b=wzVG4NEPX0v0iy+rRguFZ/NoDAHiWOMf9bQlWbfI/zRCXIGkHsnTNI/5xkK0Ui8fIY
         uMVGv9gZ/JQhX1sw7+JXITKzXCX74Sk4487wzuELlSzQIIYnrwbub2Jqwd+ZwWIkbU6l
         GEpLTYysyHDkhxWxbG1FbKrn3YEIvD1CmoryuLtSIw4SGNa7ZaqjrA05+U6pQdLLcRLo
         P67fvZO4eLpxwO7wN4D6MoLavVeUnk3pJHb3Rat6Azjl1y/nXqqsTUty+pL00dL+86z7
         ifpoSpEGwyBB2pE+Gljo0evLTrZQ8NFl8ao4nh9OahzbNr6yi0xyfxZuSH4iOnW96DJH
         zElg==
X-Gm-Message-State: AOAM533u6AhuePl9B4mqpOf5tjdBVQr0+h4KSwxKKOSKOwn4SlA9MHmS
        F03bb1PnGFGDBdBCX4g8sS+pILqB72/IFOC7JFlJZA==
X-Google-Smtp-Source: ABdhPJxbDlSNDQMbjIrLPtjPfuNwdBLUVPUHhCuku3zg2aRLots2G7bTtpZfKhSTUlVMs5APKNCOXdnG68SyNoc0xno=
X-Received: by 2002:a4a:ac0a:: with SMTP id p10mr11758247oon.96.1639677188499;
 Thu, 16 Dec 2021 09:53:08 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-5-likexu@tencent.com>
 <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com>
 <0ca44f61-f7f1-0440-e1e1-8d5e8aa9b540@gmail.com> <CALMp9eTtsMuEsimONp7TOjJ-uskwJBD-52kZzOefSKXeCwn_5A@mail.gmail.com>
 <b6c1eb18-9237-f604-9a96-9e6ca397121c@redhat.com> <CALMp9eRy==yu1uQriqbeezeQ+mtFyfyP_iy9HdDiSZ27SnEfFg@mail.gmail.com>
 <c381aa2c-beb5-480f-1f24-a14de693e78f@redhat.com> <CALMp9eTKrQVCQPm=hcA50JSUCctPaGLEP19biVbGAtBN54dQfA@mail.gmail.com>
 <CALMp9eS8xDgdbfJTbzMmek3RcXKwkLdGMW-uMkJR3eJZ6sf0GA@mail.gmail.com>
 <CALMp9eThnOMnCkYp1LYM6Ph3NeB296QvXEWtn06A_1XtS+VCDA@mail.gmail.com> <ed29b3a7-53f0-94b3-4d20-f460e8160d47@gmail.com>
In-Reply-To: <ed29b3a7-53f0-94b3-4d20-f460e8160d47@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 16 Dec 2021 09:52:57 -0800
Message-ID: <CALMp9eQn80oum84N3u38rDaT6+RMVnza10_DYDrHpZcxfA46Kw@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16, 2021 at 1:57 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 13/12/2021 2:37 pm, Jim Mattson wrote:
> > On Sat, Dec 11, 2021 at 8:56 PM Jim Mattson <jmattson@google.com> wrote:
> >>
> >> On Fri, Dec 10, 2021 at 3:31 PM Jim Mattson <jmattson@google.com> wrote:
> >>>
> >>> On Fri, Dec 10, 2021 at 2:59 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>>>
> >>>> On 12/10/21 23:55, Jim Mattson wrote:
> >>>>>>
> >>>>>> Even for tracing the SDM says "Like the value returned by RDTSC, TSC
> >>>>>> packets will include these adjustments, but other timing packets (such
> >>>>>> as MTC, CYC, and CBR) are not impacted".  Considering that "stand-alone
> >>>>>> TSC packets are typically generated only when generation of other timing
> >>>>>> packets (MTCs and CYCs) has ceased for a period of time", I'm not even
> >>>>>> sure it's a good thing that the values in TSC packets are scaled and offset.
> >>>>>>
> >>>>>> Back to the PMU, for non-architectural counters it's not really possible
> >>>>>> to know if they count in cycles or not.  So it may not be a good idea to
> >>>>>> special case the architectural counters.
> >>>>>
> >>>>> In that case, what we're doing with the guest PMU is not
> >>>>> virtualization. I don't know what it is, but it's not virtualization.
>
> It's a use of profiling guest on the host side, like "perf kvm" and in that case,
> we need to convert the guest's TSC values with the host view, taking into
> account the guest TSC scaling.

I'm not sure if you are agreeing with me or disagreeing. Basically, my
argument is that the guest should observe a PMU counter programmed
with the "unhalted core cycles" event to be in sync with the guest's
time stamp counter. (If FREEZE_WHILE_SMM or Freeze_PerfMon_On_PMI is
set, the PMU counter may lag behind the time stamp counter, but it
should never get ahead of it.)

> >>>>
> >>>> It is virtualization even if it is incompatible with live migration to a
> >>>> different SKU (where, as you point out below, multiple TSC frequencies
> >>>> might also count as multiple SKUs).  But yeah, it's virtualization with
> >>>> more caveats than usual.
> >>>
> >>> It's not virtualization if the counters don't count at the rate the
> >>> guest expects them to count.
>
> We do have "Use TSC scaling" bit in the "Secondary Processor-Based VM-Execution
> Controls".

Yes, we do. That's what this discussion has been about. That
VM-execution control is documented as follows:

This control determines whether executions of RDTSC, executions of
RDTSCP, and executions of RDMSR that read from the
IA32_TIME_STAMP_COUNTER MSR return a value modified by the TSC
multiplier field (see Section 23.6.5 and Section 24.3).

The SDM is quite specific about what this VM-execution control bit
does, and it makes no mention of PMU events.

> >>
> >> Per the SDM, unhalted reference cycles count at "a fixed frequency."
> >> If the frequency changes on migration, then the value of this event is
> >> questionable at best. For unhalted core cycles, on the other hand, the
> >> SDM says, "The performance counter for this event counts across
> >> performance state transitions using different core clock frequencies."
> >> That does seem to permit frequency changes on migration, but I suspect
> >> that software expects the event to count at a fixed frequency if
> >> INVARIANT_TSC is set.
>
> Yes, I may propose that pmu be used in conjunction with INVARIANT_TSC.
>
> >
> > Actually, I now realize that unhalted reference cycles is independent
> > of the host or guest TSC, so it is not affected by TSC scaling.
>
> I doubt it.

Well, it should be easy to prove, one way or the other. :-)

> > However, we still have to decide on a specific fixed frequency to
> > virtualize so that the frequency doesn't change on migration. As a
> > practical matter, it may be the case that the reference cycles
> > frequency is the same on all processors in a migration pool, and we
> > don't have to do anything.
>
> Yes, someone is already doing this in a production environment.

I'm sure they are. That doesn't mean PMU virtualization is bug-free.

> >
> >
> >> I'm not sure that I buy your argument regarding consistency. In
> >> general, I would expect the hypervisor to exclude non-architected
> >> events from the allow-list for any VM instances running in a
> >> heterogeneous migration pool. Certainly, those events could be allowed
> >> in a heterogeneous migration pool consisting of multiple SKUs of the
> >> same microarchitecture running at different clock frequencies, but
> >> that seems like a niche case.
>
> IMO, if there are users who want to use the guest PMU, they definitely
> want non-architectural events, even without live migration support.
>
There are two scenarios to support: (1) VMs that run on the same
microarchitecture as reported in the guest CPUID. (2) VMs that don't.

Paolo has argued against scaling the architected "unhalted core
cycles" event, because it is infeasible for KVM to recognize and scale
non-architected events that are also TSC based, and the inconsistency
is ugly.
However, in case (2), it is infeasible for KVM to offer any
non-architected events.

To clarify my earlier position, I am arguing that in case (1), TSC
scaling is not likely to be in use, so consistency is not an issue. In
case (2), I don't want to see the inconsistency that would arise every
time the TSC scaling fgactor changes.

I believe that KVM should be made capable of correctly virtualizing
the "unhalted core cycles" event in the presence of TSC scaling. I'm
happy to put this under a KVM_CAP if there are those who would prefer
that it not.

> Another input is that we actually have no problem reporting erratic
> performance data during live migration transactions or host power
> transactions, and there are situations where users want to know
> that these kind of things are happening underwater.

I have no idea what you are saying.

> The software performance tuners would not trust the perf data from
> a single trial, relying more on statistical conclusions.

Software performance tuning is not the only use of the PMU.

> >>
> >>
> >>>>> Exposing non-architectural events is questionable with live migration,
> >>>>> and TSC scaling is unnecessary without live migration. I suppose you
> >>>>> could have a migration pool with different SKUs of the same generation
> >>>>> with 'seemingly compatible' PMU events but different TSC frequencies,
> >>>>> in which case it might be reasonable to expose non-architectural
> >>>>> events, but I would argue that any of those 'seemingly compatible'
> >>>>> events are actually not compatible if they count in cycles.
> >>>> I agree.  Support for marshaling/unmarshaling PMU state exists but it's
> >>>> more useful for intra-host updates than for actual live migration, since
> >>>> these days most live migration will use TSC scaling on the destination.
> >>>>
> >>>> Paolo
> >>>>
> >>>>>
> >>>>> Unless, of course, Like is right, and the PMU counters do count fractionally.
> >>>>>
> >>>>
> >
