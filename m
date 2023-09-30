Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE997B3DD2
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 05:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjI3D3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 23:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbjI3D3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 23:29:49 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2BCDE
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 20:29:45 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-405459d9a96so36905e9.0
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 20:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696044584; x=1696649384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4M3VEzSVTHjyM3bYp0Tou9eIxp0wzmUOjm6ql/7oYQ=;
        b=By0EB+p3BGv87hJrhsjP4gLJjjzRtMASI5WNRn2z/NQbJ0HTLfiHxbMVPJN+U/Qkzq
         ofg4AerATQjfSSn82R67n7/VDqsK5aT+E3yDFPdCukCxkES5lWZbDKrUd1LDPlueNttn
         4zEEb9AJM1DiYARiYdg2X57DdBewjaV4Lgcn12Wy5hL4D8ki5kYukycy0XA4bGVZSbph
         w58LwYS2pzNin9quh3Esu0pK+VPC39W9aJE9Wp2l6IVRvRWUV9Odu5/Ow5pMwxzh/Vgw
         ljMbwOUUY3wcz1i9gbI2REU6ep3qEg3zhMWmvsdAwuxKSjFUVZXw25Ik6TRB78d1B0Yp
         jxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696044584; x=1696649384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j4M3VEzSVTHjyM3bYp0Tou9eIxp0wzmUOjm6ql/7oYQ=;
        b=YX/KRZ1UMl7R2U8Jo/DocoKZfI3Q5kL5UZRrUyD7NkNKJcIatiNz8JJAgSgbiwK2Hi
         zryY2PfTTNvkKwsC08Xnm8XJi8CYtX0BfUS+rUuCKp+7yOSEb0VzTu+FKyiRWLt0wKAr
         a08BFFwJ9mosyUIrE9vJbKlEiD7fQSVi76bQVHzjiMqyrxmp777NwmkGIfklvEfMRcSg
         NVyAFH69hzPFmVy2X9u4xuWYcptcaYp6OAc00T86fCCH213TVwDusDSeL0+fDaXlcFei
         5jPTSK7L05l5ATtmQ1LXND+J4ukGayl2OtoANp21dO5tWEIlr6sc96I72CJaj/jDSEKh
         uDog==
X-Gm-Message-State: AOJu0Yw0ksIuY48V72mFWFjRFK13OJPz5fCDTcKREZ5goVyTnVLeS8S1
        +ULDzxS906RwIhFgzmjpIeTnwclVj1R/PsMODHE7Vg==
X-Google-Smtp-Source: AGHT+IFw5iUrxH5guEM1BQla9TxWiZWlkJlQMD0ic7K3OQnFjcVC/Y3GoEG8BpeLQksdY8m4kRATgBmMD7jpqX69RuY=
X-Received: by 2002:a05:600c:35d3:b0:3f6:f4b:d4a6 with SMTP id
 r19-20020a05600c35d300b003f60f4bd4a6mr5790wmq.7.1696044583977; Fri, 29 Sep
 2023 20:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com> <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com>
In-Reply-To: <ZRbxb15Opa2_AusF@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 29 Sep 2023 20:29:31 -0700
Message-ID: <CALMp9eQvCLJCQYHfZ5K3nZ8jK14dUMmfEsSvkdteE2OUtg=8+g@mail.gmail.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
        David Dunn <daviddunn@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023 at 8:46=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Sep 29, 2023, Peter Zijlstra wrote:
> > On Wed, Sep 27, 2023 at 10:27:07AM -0700, Sean Christopherson wrote:
> > > Jumping the gun a bit (we're in the *super* early stages of scraping =
together a
> > > rough PoC), but I think we should effectively put KVM's current vPMU =
support into
> > > maintenance-only mode, i.e. stop adding new features unless they are =
*very* simple
> > > to enable, and instead pursue an implementation that (a) lets userspa=
ce (and/or
> > > the kernel builder) completely disable host perf (or possibly just ho=
st perf usage
> > > of the hardware PMU) and (b) let KVM passthrough the entire hardware =
PMU when it
> > > has been turned off in the host.
> >
> > I don't think you need to go that far, host can use PMU just fine as
> > long as it doesn't overlap with a vCPU. Basically, if you force
> > perf_attr::exclude_guest on everything your vCPU can haz the full thing=
.
>
> Complexity aside, my understanding is that the overhead of trapping and e=
mulating
> all of the guest counter and MSR accesses results in unacceptably degrade=
d functionality
> for the guest.  And we haven't even gotten to things like arch LBRs where=
 context
> switching MSRs between the guest and host is going to be quite costly.

Trapping and emulating all of the PMU MSR accesses is ludicrously
slow, especially when the guest is multiplexing events.

Also, the current scheme of implicitly tying together usage mode and
priority means that KVM's "task pinned" perf_events always lose to
someone else's "CPU pinned" perf_events. Even if those "CPU pinned"
perf events are tagged "exclude_guest," the counters they occupy are
not available for KVM's "exclude_host" events, because host perf won't
multiplex a counter between an "exclude_host" event and an
"exclude_guest" event, even though the two events don't overlap.
Frankly, we wouldn't want it to, because that would introduce
egregious overheads at VM-entry and VM-exit. What we would need would
be a mechanism for allocating KVM's "task pinned" perf_events at the
highest priority, so they always win.

For things to work well in the "vPMU as a client of host perf" world,
we need to have the following at a minimum:
1) Guaranteed identity mapping of guest PMCs to host PMCs, so that we
don't have to intercept accesses to IA32_PERF_GLOBAL_CTRL.
2) Exclusive ownership of the PMU MSRs while in the KVM_RUN loop, so
that we don't have to switch any PMU MSRs on VM-entry/VM-exit (with
the exception of IA32_PERF_GLOBAL_CTRL, which has guest and host
fields in the VMCS).

There are other issues with the current implementation, like the
ridiculous overhead of bumping a counter in software to account for an
emulated instruction. That should just be a RDMSR, an increment, a
WRMSR, and the conditional synthesis of a guest PMI on overflow.
Instead, we have to pause a perf_event and reprogram it before
continuing. Putting a high-level abstraction between the guest PMU and
the host PMU does not yield the most efficient implementation.

> > > Note, a similar idea was floated and rejected in the past[*], but tha=
t failed
> > > proposal tried to retain host perf+PMU functionality by making the be=
havior dynamic,
> > > which I agree would create an awful ABI for the host.  If we make the=
 "knob" a
> > > Kconfig
> >
> > Must not be Kconfig, distros would have no sane choice.
>
> Or not only a Kconfig?  E.g. similar to how the kernel has
> CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS and nopku.
>
> > > or kernel param, i.e. require the platform owner to opt-out of using =
perf
> > > no later than at boot time, then I think we can provide a sane ABI, k=
eep the
> > > implementation simple, all without breaking existing users that utili=
ze perf in
> > > the host to profile guests.
> >
> > It's a shit choice to have to make. At the same time I'm not sure I hav=
e
> > a better proposal.
> >
> > It does mean a host cannot profile one guest and have pass-through on t=
he
> > other. Eg. have a development and production guest on the same box. Thi=
s
> > is pretty crap.
> >
> > Making it a guest-boot-option would allow that, but then the host gets
> > complicated again. I think I can make it trivially work for per-task
> > events, simply error the creation of events without exclude_guest for
> > affected vCPU tasks. But the CPU events are tricky.
> >
> >
> > I will firmly reject anything that takes the PMU away from the host
> > entirely through.
>
> Why?  What is so wrong with supporting use cases where the platform owner=
 *wants*
> to give up host PMU and NMI watchdog functionality?  If disabling host PM=
U usage
> were complex, highly invasive, and/or difficult to maintain, then I can u=
nderstand
> the pushback.
>
> But if we simply allow hiding hardware PMU support, then isn't the cost t=
o perf
> just a few lines in init_hw_perf_events()?  And if we put a stake in the =
ground
> and say that exposing "advanced" PMU features to KVM guests requires a pa=
ssthrough
> PMU, i.e. the PMU to be hidden from the host, that will significantly red=
uce our
> maintenance and complexity.
>
> The kernel allows disabling almost literally every other feature that is =
even
> remotely optional, I don't understand why the hardware PMU is special.
