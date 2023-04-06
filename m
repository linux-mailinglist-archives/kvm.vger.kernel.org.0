Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D796DA4CD
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 23:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDFVjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 17:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237098AbjDFVjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 17:39:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A9A86A6
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 14:39:20 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r11so40812400wrr.12
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 14:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680817159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pj5O6q4/SLV++nc+no3Y4fbUsfJNZC+GMe261qLamEw=;
        b=n6h9c0j+sES0yh6qBjYK+xyko80XB8y/5ykeeb8R97B2LZPG62DfWbTddtyczMWNNt
         LGOjh/Qqu/RL3BkQkh9z9XKmf7JNg1Zq7cu7vKfTGi8YZ7Pr92/nGYRgQMcyXlADf081
         +n/51mtxYPJSRnwhZ6fiSX/fBrn6Yqiz+X4rmovqJLCsdo2gkxHrpVTaf/l+JPNgyxLj
         w36G+Zu9GjCCKHGMCk6oyAo8OXc7v5ABrXlclZNSBgBdWbLxzCaDTW+inb54gArnz07A
         3vVssEmLjoCOdoWdyoE9BkUDeKAroTXGArrI+dTVqjwxpaCvpyIadrhvgOTVkIEHQOf2
         D8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680817159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pj5O6q4/SLV++nc+no3Y4fbUsfJNZC+GMe261qLamEw=;
        b=NG5jHXpMEjSy6E0MrUiujGFocdygnZsMqBud/lYrLSxEEVFSaKs4s4gCHt1F/pzCfO
         rlLa/Z0S/sQMCbJAfgV/HtFqDFWXXwF5BwERoWq5p8Dq2P61FOhoKAaugLVE/cmijBr4
         lOqiZDdfdJoUnM53I/lD/lCeIWdHLkYoKCUMe4R5WFKmlAl7wIpcmyi3Kc0IDIXzqYXm
         3+KuUV0ByX2dDPqpmo9XDHYHEThK9l/3hH3pxeqQD0xmM1ZEeV9e/VntErKUqxknA71w
         qVSpPgIS71/S/KF31Av6ZnVTJTOOBXxDSz7brYXCtmmYwjhBazJgDz+C0SUh4bnuTgHl
         8hog==
X-Gm-Message-State: AAQBX9eNiBLsjYUeUunmy95fCFHTQ4qL/enXlcioVf5OOw6QF8VTUMK5
        rxbVAMvVSDkj/8iPc/aPr74NP6Y26srTr5J9+FRtUQ==
X-Google-Smtp-Source: AKy350bsgguQ6+ROAswXDMNqU++5TVFkFSC3cAihJii/tTwwKLweqkSx1v7IlTCmC0owbXWsm5Fo5s3Miuy0gzzDowI=
X-Received: by 2002:adf:eb4d:0:b0:2cf:f053:a32e with SMTP id
 u13-20020adfeb4d000000b002cff053a32emr2429273wrn.6.1680817158708; Thu, 06 Apr
 2023 14:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com> <ZCx97IKjsBibjdGc@linux.dev>
 <86sfdfv0e1.wl-maz@kernel.org> <ZC0n0HRsmNJeJZps@google.com>
 <CAGETcx_9SdyCQ5UHhjsnV5+X8arhXoZS2NN-mewtPM3oHuZrkw@mail.gmail.com> <ZC7Ao1qoNGYXQ9h4@google.com>
In-Reply-To: <ZC7Ao1qoNGYXQ9h4@google.com>
From:   David Dai <davidai@google.com>
Date:   Thu, 6 Apr 2023 14:39:07 -0700
Message-ID: <CABN1KCLQ3ArERDHxjDVxBmEx18us6dihHTrydjzKbPPw7rKhzA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
To:     Quentin Perret <qperret@google.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        kernel-team@android.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 6, 2023 at 5:52=E2=80=AFAM Quentin Perret <qperret@google.com> =
wrote:
>
> On Wednesday 05 Apr 2023 at 14:07:18 (-0700), Saravana Kannan wrote:
> > On Wed, Apr 5, 2023 at 12:48=E2=80=AFAM 'Quentin Perret' via kernel-tea=
m
> > > And I concur with all the above as well. Putting this in the kernel i=
s
> > > not an obvious fit at all as that requires a number of assumptions ab=
out
> > > the VMM.
> > >
> > > As Oliver pointed out, the guest topology, and how it maps to the hos=
t
> > > topology (vcpu pinning etc) is very much a VMM policy decision and wi=
ll
> > > be particularly important to handle guest frequency requests correctl=
y.
> > >
> > > In addition to that, the VMM's software architecture may have an impa=
ct.
> > > Crosvm for example does device emulation in separate processes for
> > > security reasons, so it is likely that adjusting the scheduling
> > > parameters ('util_guest', uclamp, or else) only for the vCPU thread t=
hat
> > > issues frequency requests will be sub-optimal for performance, we may
> > > want to adjust those parameters for all the tasks that are on the
> > > critical path.
> > >
> > > And at an even higher level, assuming in the kernel a certain mapping=
 of
> > > vCPU threads to host threads feels kinda wrong, this too is a host
> > > userspace policy decision I believe. Not that anybody in their right
> > > mind would want to do this, but I _think_ it would technically be
> > > feasible to serialize the execution of multiple vCPUs on the same hos=
t
> > > thread, at which point the util_guest thingy becomes entirely bogus. =
(I
> > > obviously don't want to conflate this use-case, it's just an example
> > > that shows the proposed abstraction in the series is not a perfect fi=
t
> > > for the KVM userspace delegation model.)
> >
> > See my reply to Oliver and Marc. To me it looks like we are converging
> > towards having shared memory between guest, host kernel and VMM and
> > that should address all our concerns.
>
> Hmm, that is not at all my understanding of what has been the most
> important part of the feedback so far: this whole thing belongs to
> userspace.
>
> > The guest will see a MMIO device, writing to it will trigger the host
> > kernel to do the basic "set util_guest/uclamp for the vCPU thread that
> > corresponds to the vCPU" and then the VMM can do more on top as/if
> > needed (because it has access to the shared memory too). Does that
> > make sense?
>
> Not really no. I've given examples of why this doesn't make sense for
> the kernel to do this, which still seems to be the case with what you're
> suggesting here.
>
> > Even in the extreme example, the stuff the kernel would do would still
> > be helpful, but not sufficient. You can aggregate the
> > util_guest/uclamp and do whatever from the VMM.
> > Technically in the extreme example, you don't need any of this. The
> > normal util tracking of the vCPU thread on the host side would be
> > sufficient.
> >
> > Actually any time we have only 1 vCPU host thread per VM, we shouldn't
> > be using anything in this patch series and not instantiate the guest
> > device at all.
>
> > > So +1 from me to move this as a virtual device of some kind. And if t=
he
> > > extra cost of exiting all the way back to userspace is prohibitive (i=
s
> > > it btw?),
> >
> > I think the "13% increase in battery consumption for games" makes it
> > pretty clear that going to userspace is prohibitive. And that's just
> > one example.
>

Hi Quentin,

Appreciate the feedback,

> I beg to differ. We need to understand where these 13% come from in more
> details. Is it really the actual cost of the userspace exit? Or is it
> just that from userspace the only knob you can play with is uclamp and
> that didn't reach the expected level of performance?

To clarify, the MMIO numbers shown in the cover letter were collected
with updating vCPU task's util_guest as opposed to uclamp_min. In that
configuration, userspace(VMM) handles the mmio_exit from the guest and
makes an ioctl on the host kernel to update util_guest for the vCPU
task.

>
> If that is the userspace exit, then we can work to optimize that -- it's
> a fairly common problem in the virt world, nothing special here.
>

Ok, we're open to suggestions on how to better optimize here.

> And if the issue is the lack of expressiveness in uclamp, then that too
> is something we should work on, but clearly giving vCPU threads more
> 'power' than normal host threads is a bit of a red flag IMO. vCPU
> threads must be constrained in the same way that userspace threads are,
> because they _are_ userspace threads.
>
> > > then we can try to work on that. Maybe something a la vhost
> > > can be done to optimize, I'll have a think.
> > >
> > > > The one thing I'd like to understand that the comment seems to impl=
y
> > > > that there is a significant difference in overhead between a hyperc=
all
> > > > and an MMIO. In my experience, both are pretty similar in cost for =
a
> > > > handling location (both in userspace or both in the kernel). MMIO
> > > > handling is a tiny bit more expensive due to a guaranteed TLB miss
> > > > followed by a walk of the in-kernel device ranges, but that's all. =
It
> > > > should hardly register.
> > > >
> > > > And if you really want some super-low latency, low overhead
> > > > signalling, maybe an exception is the wrong tool for the job. Share=
d
> > > > memory communication could be more appropriate.
> > >
> > > I presume some kind of signalling mechanism will be necessary to
> > > synchronously update host scheduling parameters in response to guest
> > > frequency requests, but if the volume of data requires it then a shar=
ed
> > > buffer + doorbell type of approach should do.
> >
> > Part of the communication doesn't need synchronous handling by the
> > host. So, what I said above.
>
> I've also replied to another message about the scale invariance issue,
> and I'm not convinced the frequency based interface proposed here really
> makes sense. An AMU-like interface is very likely to be superior.
>

Some sort of AMU-based interface was discussed offline with Saravana,
but I'm not sure how to best implement that. If you have any pointers
to get started, that would be helpful.

> > > Thinking about it, using SCMI over virtio would implement exactly tha=
t.
> > > Linux-as-a-guest already supports it IIRC, so possibly the problem
> > > being addressed in this series could be 'simply' solved using an SCMI
> > > backend in the VMM...
> >
> > This will be worse than all the options we've tried so far because it
> > has the userspace overhead AND uclamp overhead.
>
> But it doesn't violate the whole KVM userspace delegation model, so we
> should start from there and then optimize further if need be.

Do you have any references we can experiment with getting started for
SCMI? (ex. SCMI backend support in CrosVM).

For RFC V3, I'll post a CPUfreq driver implementation that only uses
MMIO and without any kernel host modifications(I.E. Only using uclamp
as a knob to tune the host) along with performance numbers and then
work on optimizing from there.

Thanks,
David

>
> Thanks,
> Quentin
