Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9224B1612
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 20:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343838AbiBJTRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 14:17:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343832AbiBJTRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 14:17:04 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61F825C3
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:17:04 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id ay7so7021439oib.8
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 11:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X3s20vgvk/guHKy7OMkfSdtJHxYHhLQSz8YFs1yoSNU=;
        b=E57GJzKhbzAlBrtpClBXPC+EYefkQ3zBFy6bahHm7Y61PEgtKH/yogBLaB4mPKBl4c
         a4Rcfxo7VmsJIxS6DT+TVlMIt5pRl+mOGHNyogYnIQdXdGtL+cEAjALV1/qp4AOwkbVr
         PvBRYXX/wXsyEJdB1pggwY6/3lg8k1rhGwZ0xnG89zUCPGjgpYLUvbj5JEPj1JEcghMw
         TE3Nr3hv9RikczXdBtitflOO8oW+2//WWwZolsJ2Zmx6DO/feR/OwpdoPVd8bsNvlkxx
         YMwOPsagr+LP8lNdrRqJG7O0rcG6hSNPdpqd9dIhTM/EGaI8WbV4NbodOOejfRdMYXW6
         WrAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X3s20vgvk/guHKy7OMkfSdtJHxYHhLQSz8YFs1yoSNU=;
        b=ULIVm57RjuA0ghkCIbGOfPKceF49fjRb5Glmx7aHsLzya8y1/BahGyIpa9RNL0qMRJ
         piLouFgl/exGIyzdYrDpY9VcOihcq5RxwG46/h4O+2oYjQG/I/rYSkn/RGJE7ODhpXrO
         k1zpTYT8cjJr5eRCydeBP5oXQLFx9Po9aIQPmfxWT8d3eSuweYK9QwubVTK8nxAA3rr/
         ZPCVpCku0ViKgc31KyPsJCNtVf2Vjd4MKNX1oTGMjRVEFMSD9yiovrBvV2qnQih3pQWb
         r9QYSg+5gKr9wHxBhPUEbnj7U4SpcO1oPfNRQvfmuia8nSyT8VPMuNRG5S2IvHcvaldG
         5gJQ==
X-Gm-Message-State: AOAM530ZKKyN260cAagKu6nm27ley1zzQzGpJhfEZ0O7E9aH7lY2OnxR
        ed02TuSGCY10HcZ2i17MbLYJwheLX6V68+KLJoUVag==
X-Google-Smtp-Source: ABdhPJy/E9Wn5fSooiazKYOicVt1TrF8XzqNeTB6psFmQZiOyn/7C/Bz63TcNhiSjkZblZiIJReF13/67Mc5aGKAUOM=
X-Received: by 2002:a05:6808:1292:: with SMTP id a18mr1708933oiw.314.1644520623949;
 Thu, 10 Feb 2022 11:17:03 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net> <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com> <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com> <CALMp9eTOaWxQPfdwMSAn-OYAHKPLcuCyse7BpsSOM35vg5d0Jg@mail.gmail.com>
 <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com>
In-Reply-To: <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 10 Feb 2022 11:16:52 -0800
Message-ID: <CALMp9eSjDro169JjTXyCZn=Rf3PT0uHhdNXEifiXGYQK-Zn8LA@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     David Dunn <daviddunn@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022 at 10:30 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>
>
>
> On 2/10/2022 11:34 AM, Jim Mattson wrote:
> > On Thu, Feb 10, 2022 at 7:34 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
> >>
> >>
> >>
> >> On 2/9/2022 2:24 PM, David Dunn wrote:
> >>> Dave,
> >>>
> >>> In my opinion, the right policy depends on what the host owner and
> >>> guest owner are trying to achieve.
> >>>
> >>> If the PMU is being used to locate places where performance could be
> >>> improved in the system, there are two sub scenarios:
> >>>      - The host and guest are owned by same entity that is optimizing
> >>> overall system.  In this case, the guest doesn't need PMU access and
> >>> better information is provided by profiling the entire system from the
> >>> host.
> >>>      - The host and guest are owned by different entities.  In this
> >>> case, profiling from the host can identify perf issues in the guest.
> >>> But what action can be taken?  The host entity must communicate issues
> >>> back to the guest owner through some sort of out-of-band information
> >>> channel.  On the other hand, preempting the host PMU to give the guest
> >>> a fully functional PMU serves this use case well.
> >>>
> >>> TDX and SGX (outside of debug mode) strongly assume different
> >>> entities.  And Intel is doing this to reduce insight of the host into
> >>> guest operations.  So in my opinion, preemption makes sense.
> >>>
> >>> There are also scenarios where the host owner is trying to identify
> >>> systemwide impacts of guest actions.  For example, detecting memory
> >>> bandwidth consumption or split locks.  In this case, host control
> >>> without preemption is necessary.
> >>>
> >>> To address these various scenarios, it seems like the host needs to be
> >>> able to have policy control on whether it is willing to have the PMU
> >>> preempted by the guest.
> >>>
> >>> But I don't see what scenario is well served by the current situation
> >>> in KVM.  Currently the guest will either be told it has no PMU (which
> >>> is fine) or that it has full control of a PMU.  If the guest is told
> >>> it has full control of the PMU, it actually doesn't.  But instead of
> >>> losing counters on well defined events (from the guest perspective),
> >>> they simply stop counting depending on what the host is doing with the
> >>> PMU.
> >>
> >> For the current perf subsystem, a PMU should be shared among different
> >> users via the multiplexing mechanism if the resource is limited. No one
> >> has full control of a PMU for lifetime. A user can only have the PMU in
> >> its given period. I think the user can understand how long it runs via
> >> total_time_enabled and total_time_running.
> >
> > For most clients, yes. For kvm, no. KVM currently tosses
> > total_time_enabled and total_time_running in the bitbucket. It could
> > extrapolate, but that would result in loss of precision. Some guest
> > uses of the PMU would not be able to cope (e.g.
> > https://github.com/rr-debugger/rr).
> >
> >> For a guest, it should rely on the host to tell whether the PMU resource
> >> is available. But unfortunately, I don't think we have such a
> >> notification mechanism in KVM. The guest has the wrong impression that
> >> the guest can have full control of the PMU.
> >
> > That is the only impression that the architectural specification
> > allows the guest to have. On Intel, we can mask off individual fixed
> > counters, and we can reduce the number of GP counters, but AMD offers
> > us no such freedom. Whatever resources we advertise to the guest must
> > be available for its use whenever it wants. Otherwise, PMU
> > virtualization is simply broken.
> >
> >> In my opinion, we should add the notification mechanism in KVM. When the
> >> PMU resource is limited, the guest can know whether it's multiplexing or
> >> can choose to reschedule the event.
> >
> > That sounds like a paravirtual perf mechanism, rather than PMU
> > virtualization. Are you suggesting that we not try to virtualize the
> > PMU? Unfortunately, PMU virtualization is what we have customers
> > clamoring for. No one is interested in a paravirtual perf mechanism.
> > For example, when will VTune in the guest know how to use your
> > proposed paravirtual interface?
>
> OK. If KVM cannot notify the guest, maybe guest can query the usage of
> counters before using a counter. There is a IA32_PERF_GLOBAL_INUSE MSR
> introduced with Arch perfmon v4. The MSR provides an "InUse" bit for
> each counters. But it cannot guarantee that the counter can always be
> owned by the guest unless the host treats the guest as a super-user and
> agrees to not touch its counter. This should only works for the Intel
> platforms.

Simple question: Do all existing guests (Windows and Linux are my
primary interest) query that MSR today? If not, then this proposal is
DOA.

> >
> >> But seems the notification mechanism may not work for TDX case?
> >>>
> >>> On the other hand, if we flip it around the semantics are more clear.
> >>> A guest will be told it has no PMU (which is fine) or that it has full
> >>> control of the PMU.  If the guest is told that it has full control of
> >>> the PMU, it does.  And the host (which is the thing that granted the
> >>> full PMU to the guest) knows that events inside the guest are not
> >>> being measured.  This results in all entities seeing something that
> >>> can be reasoned about from their perspective.
> >>>
> >>
> >> I assume that this is for the TDX case (where the notification mechanism
> >>    doesn't work). The host still control all the PMU resources. The TDX
> >> guest is treated as a super-user who can 'own' a PMU. The admin in the
> >> host can configure/change the owned PMUs of the TDX. Personally, I think
> >> it makes sense. But please keep in mind that the counters are not
> >> identical. There are some special events that can only run on a specific
> >> counter. If the special counter is assigned to TDX, other entities can
> >> never run some events. We should let other entities know if it happens.
> >> Or we should never let non-host entities own the special counter.
> >
> > Right; the counters are not fungible. Ideally, when the guest requests
> > a particular counter, that is the counter it gets. If it is given a
> > different counter, the counter it is given must provide the same
> > behavior as the requested counter for the event in question.
>
> Ideally, Yes, but sometimes KVM/host may not know whether they can use
> another counter to replace the requested counter, because KVM/host
> cannot retrieve the event constraint information from guest.

In that case, don't do it. When the guest asks for a specific counter,
give the guest that counter. This isn't rocket science.

> For example, we have Precise Distribution (PDist) feature enabled only
> for the GP counter 0 on SPR. Perf uses the precise_level 3 (a SW
> variable) to indicate the feature. For the KVM/host, they never know
> whether the guest apply the PDist feature.
>
> I have a patch that forces the perf scheduler starts from the regular
> counters, which may mitigates the issue, but cannot fix it. (I will post
> the patch separately.)
>
> Or we should never let the guest own the special counters. Although the
> guest has to lose some special events, I guess the host may more likely
> be willing to let the guest own a regular counter.
>
>
> Thanks,
> Kan
>
> >
> >>
> >> Thanks,
> >> Kan
> >>
> >>> Thanks,
> >>>
> >>> Dave Dunn
> >>>
> >>> On Wed, Feb 9, 2022 at 10:57 AM Dave Hansen <dave.hansen@intel.com> wrote:
> >>>
> >>>>> I was referring to gaps in the collection of data that the host perf
> >>>>> subsystem doesn't know about if ATTRIBUTES.PERFMON is set for a TDX
> >>>>> guest. This can potentially be a problem if someone is trying to
> >>>>> measure events per unit of time.
> >>>>
> >>>> Ahh, that makes sense.
> >>>>
> >>>> Does SGX cause problem for these people?  It can create some of the same
> >>>> collection gaps:
> >>>>
> >>>>           performance monitoring activities are suppressed when entering
> >>>>           an opt-out (of performance monitoring) enclave.
