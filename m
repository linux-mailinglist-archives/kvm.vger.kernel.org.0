Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DD66D7707
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbjDEIeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237534AbjDEIeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:34:18 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933C34C2B
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:34:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id d13so33240788pjh.0
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 01:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680683650; x=1683275650;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uswkZCNmvnRlVRQCSju2fZnjPjabnOYplQP8HVJ2wjE=;
        b=hDTg9cZ5dgqFve21IhvP0vjH/LT5Qn7NqlC7lp8kDbxvOzwqcjsmIaSgUiFkxF9/rA
         CX6RJ+FZxOinhHJXTmJWHeiM0PU12K7peccwTyhJ8SacTyOawUNsD711ZuiS/VYAiGjD
         JxibN6nFFF/mlX0xY9ioRXj8B1hj/IrRo1VRraKc0O5K/v3oPqUvBr2n5pgr62FnlVaU
         2hRpKMOuYdJLVWz7IDpKKO6Go35uPSTQZUdpvVPnGKhPc+aWLP8aA0Tz8VCWrmG+oJjo
         p54SNKfSHgQ/MCAetv/xg7nmJSwNXLhATwlFTNFdgDWIHq16UuKOooTHU7SDn+oVRjSK
         JQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680683650; x=1683275650;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uswkZCNmvnRlVRQCSju2fZnjPjabnOYplQP8HVJ2wjE=;
        b=18wsiDyzMzGTAWL32eM+uxEwGmX2dM1iIIwLpYwUG4PLVuppZHik5C09171I3o6Wc7
         JFuhAzlfZ+flI1kNhbA21JHoUADSfGGqE/Emc0U1zFe6tnGHNiuGP1ly79VDpuGs+o0Q
         RwZ1qHZA3CTBx2LbIDwOaPwC4gsOjEvVTA6BdPnp+OJYOBGpcwwifRqlAE83Rw3Ll36j
         J24uDAtMjmktG3AY20NuUYgrurmh4/h8nVgfEG40/djBNiIFcH4DvF73aZHoNnqFsE2o
         itkSd9o09NMDhBD3/Q98xUv8lROoasFe759fdYbb0Jrw39oKCl0RS3lVb6uhg0aVDvsu
         3T3g==
X-Gm-Message-State: AAQBX9c7NEUEllvuUpJXHdt80xCUxB98SAW40M9nNWv6WFp+cIR9cyyq
        EKSiTT6BUMnPx/QGVCxg4TEnsadKYxKUlua0y48ocw==
X-Google-Smtp-Source: AKy350ZAsaPHdY8c5KE9TLI0KeNHy+W9j9/lSgVgAc0xT/TIw+751YYthPnT3mfZja3e78XtuRBHMTFr1xtbfMMwycs=
X-Received: by 2002:a17:90a:d201:b0:240:d8d8:12c4 with SMTP id
 o1-20020a17090ad20100b00240d8d812c4mr1918429pju.3.1680683649941; Wed, 05 Apr
 2023 01:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com> <ZCx97IKjsBibjdGc@linux.dev>
 <86sfdfv0e1.wl-maz@kernel.org> <ZC0n0HRsmNJeJZps@google.com>
In-Reply-To: <ZC0n0HRsmNJeJZps@google.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Wed, 5 Apr 2023 10:33:58 +0200
Message-ID: <CAKfTPtBaXao2oFjFy7Zx8T6orBgC=+zw7L+mF3My7kOFAvg2Og@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
To:     Quentin Perret <qperret@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, David Dai <davidai@google.com>,
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
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Apr 2023 at 09:48, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 04 Apr 2023 at 21:49:10 (+0100), Marc Zyngier wrote:
> > On Tue, 04 Apr 2023 20:43:40 +0100,
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > Folks,
> > >
> > > On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> > >
> > > <snip>
> > >
> > > > PCMark
> > > > Higher is better
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Test Case (score) | Baseline |  Hypercall | %delta |  MMIO | %delta |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Weighted Total    |     6136 |       7274 |   +19% |  6867 |   +12% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Web Browsing      |     5558 |       6273 |   +13% |  6035 |    +9% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Video Editing     |     4921 |       5221 |    +6% |  5167 |    +5% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Writing           |     6864 |       8825 |   +29% |  8529 |   +24% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Photo Editing     |     7983 |      11593 |   +45% | 10812 |   +35% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > > | Data Manipulation |     5814 |       6081 |    +5% |  5327 |    -8% |
> > > > +-------------------+----------+------------+--------+-------+--------+
> > > >
> > > > PCMark Performance/mAh
> > > > Higher is better
> > > > +-----------+----------+-----------+--------+------+--------+
> > > > |           | Baseline | Hypercall | %delta | MMIO | %delta |
> > > > +-----------+----------+-----------+--------+------+--------+
> > > > | Score/mAh |       79 |        88 |   +11% |   83 |    +7% |
> > > > +-----------+----------+-----------+--------+------+--------+
> > > >
> > > > Roblox
> > > > Higher is better
> > > > +-----+----------+------------+--------+-------+--------+
> > > > |     | Baseline |  Hypercall | %delta |  MMIO | %delta |
> > > > +-----+----------+------------+--------+-------+--------+
> > > > | FPS |    18.25 |      28.66 |   +57% | 24.06 |   +32% |
> > > > +-----+----------+------------+--------+-------+--------+
> > > >
> > > > Roblox Frames/mAh
> > > > Higher is better
> > > > +------------+----------+------------+--------+--------+--------+
> > > > |            | Baseline |  Hypercall | %delta |   MMIO | %delta |
> > > > +------------+----------+------------+--------+--------+--------+
> > > > | Frames/mAh |    91.25 |     114.64 |   +26% | 103.11 |   +13% |
> > > > +------------+----------+------------+--------+--------+--------+
> > >
> > > </snip>
> > >
> > > > Next steps:
> > > > ===========
> > > > We are continuing to look into communication mechanisms other than
> > > > hypercalls that are just as/more efficient and avoid switching into the VMM
> > > > userspace. Any inputs in this regard are greatly appreciated.
> > >
> > > We're highly unlikely to entertain such an interface in KVM.
> > >
> > > The entire feature is dependent on pinning vCPUs to physical cores, for which
> > > userspace is in the driver's seat. That is a well established and documented
> > > policy which can be seen in the way we handle heterogeneous systems and
> > > vPMU.
> > >
> > > Additionally, this bloats the KVM PV ABI with highly VMM-dependent interfaces
> > > that I would not expect to benefit the typical user of KVM.
> > >
> > > Based on the data above, it would appear that the userspace implementation is
> > > in the same neighborhood as a KVM-based implementation, which only further
> > > weakens the case for moving this into the kernel.
> > >
> > > I certainly can appreciate the motivation for the series, but this feature
> > > should be in userspace as some form of a virtual device.
> >
> > +1 on all of the above.
>
> And I concur with all the above as well. Putting this in the kernel is
> not an obvious fit at all as that requires a number of assumptions about
> the VMM.
>
> As Oliver pointed out, the guest topology, and how it maps to the host
> topology (vcpu pinning etc) is very much a VMM policy decision and will
> be particularly important to handle guest frequency requests correctly.
>
> In addition to that, the VMM's software architecture may have an impact.
> Crosvm for example does device emulation in separate processes for
> security reasons, so it is likely that adjusting the scheduling
> parameters ('util_guest', uclamp, or else) only for the vCPU thread that
> issues frequency requests will be sub-optimal for performance, we may
> want to adjust those parameters for all the tasks that are on the
> critical path.
>
> And at an even higher level, assuming in the kernel a certain mapping of
> vCPU threads to host threads feels kinda wrong, this too is a host
> userspace policy decision I believe. Not that anybody in their right
> mind would want to do this, but I _think_ it would technically be
> feasible to serialize the execution of multiple vCPUs on the same host
> thread, at which point the util_guest thingy becomes entirely bogus. (I
> obviously don't want to conflate this use-case, it's just an example
> that shows the proposed abstraction in the series is not a perfect fit
> for the KVM userspace delegation model.)
>
> So +1 from me to move this as a virtual device of some kind. And if the
> extra cost of exiting all the way back to userspace is prohibitive (is
> it btw?), then we can try to work on that. Maybe something a la vhost
> can be done to optimize, I'll have a think.
>
> > The one thing I'd like to understand that the comment seems to imply
> > that there is a significant difference in overhead between a hypercall
> > and an MMIO. In my experience, both are pretty similar in cost for a
> > handling location (both in userspace or both in the kernel). MMIO
> > handling is a tiny bit more expensive due to a guaranteed TLB miss
> > followed by a walk of the in-kernel device ranges, but that's all. It
> > should hardly register.
> >
> > And if you really want some super-low latency, low overhead
> > signalling, maybe an exception is the wrong tool for the job. Shared
> > memory communication could be more appropriate.
>
> I presume some kind of signalling mechanism will be necessary to
> synchronously update host scheduling parameters in response to guest
> frequency requests, but if the volume of data requires it then a shared
> buffer + doorbell type of approach should do.
>
> Thinking about it, using SCMI over virtio would implement exactly that.
> Linux-as-a-guest already supports it IIRC, so possibly the problem
> being addressed in this series could be 'simply' solved using an SCMI
> backend in the VMM...

This is what was suggested at LPC:
using virtio-scmi and scmi performance domain in the guest for cpufreq driver
using a vhost user scmi backend in user space
from this vhost userspace backend updates the uclamp min of the vCPU
thread or use another method is this one is not good enough

>
> Thanks,
> Quentin
