Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4FA6D8948
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 23:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjDEVIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 17:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjDEVID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 17:08:03 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5427B61BA
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 14:07:56 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q191so5277097pgq.7
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 14:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680728875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sml6aLd7NKNtOPArQglRTFmPrwxLRHpfQGEdpLGQuKU=;
        b=hzTkqmv9kRVCuEZOHA2Eqet8sLVNbtm1v12CcRdciL89msd39FaXGObgLEAtilXQyw
         8/nTJHQyEKtHUXCZDNVNUwjpTKf3T8Bkx+UVT8ihgYKBi77tqtVuIBHbp6G5BxfUwt8G
         W5zxIeGHDJwNo9S7D5TYRs0cwadJf/BNQQs0a4O3I6poQik0dh2klYu6Z2u3dGzNnweb
         OgcKeZNhlCtp8r2xGYgU3R1uYe35oXfVzjM1MTAFlcQRsQqvtrJSbVphRz52PniweMYe
         mIyeb3OvhjOXZbUZJkXeD9VUUvZjh8RZ3FdimwT4HGsTjmkW282x/qfCTCsK7d/MGJDt
         9q7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680728875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sml6aLd7NKNtOPArQglRTFmPrwxLRHpfQGEdpLGQuKU=;
        b=0J/zYXPAuv935CgZLnpJtINYkYjGG2uNsuf65ZrRvR83btDNQ+zdqORsof2VSNjpgz
         am39W9MKEnUDN/UCgOgB0Nz2wz1zfUH2MXCCgTdwH2muYRBMzeO8Lw3BvPH700R6cNJd
         n4FAUTIYPZN59ur4HulvHMwToOWqO/aMmwBUkfSBL+JU3/2OjpmzsvVOwfjjat3GMLas
         5GIWpbXWQTbX3gfpCkB9hKre0VwV0fOhZZouyV5+j+3pjvIZlKm359YS6U0E3v0npYza
         luK6BP0UxKMunfTP+1ayeai3fo35V/f2f8joNxEJma4XafS0vyjop6k0W1vmu/uG0W3W
         slPw==
X-Gm-Message-State: AAQBX9dqMkGBL8lznadgL7xguvkEcv+JXq4+aHPRKc7KBtVTTl0qQT56
        B88BDpD7chPYJa8H3u9/95wqXxgQRu/6Hhs0kVc5pA==
X-Google-Smtp-Source: AKy350a1ele4zhxKI9UlE9RFiSzwa5NSjMvOCRjyurTKaNDCmlUY6tE70hOuWN6BZR42t9Xf7juFWt7K2QkuVmJZcy4=
X-Received: by 2002:a63:474b:0:b0:50f:ad00:3f92 with SMTP id
 w11-20020a63474b000000b0050fad003f92mr2366072pgk.3.1680728874841; Wed, 05 Apr
 2023 14:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com> <ZCx97IKjsBibjdGc@linux.dev>
 <86sfdfv0e1.wl-maz@kernel.org> <ZC0n0HRsmNJeJZps@google.com>
In-Reply-To: <ZC0n0HRsmNJeJZps@google.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 5 Apr 2023 14:07:18 -0700
Message-ID: <CAGETcx_9SdyCQ5UHhjsnV5+X8arhXoZS2NN-mewtPM3oHuZrkw@mail.gmail.com>
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

On Wed, Apr 5, 2023 at 12:48=E2=80=AFAM 'Quentin Perret' via kernel-team
<kernel-team@android.com> wrote:
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
> > > > +-------------------+----------+------------+--------+-------+-----=
---+
> > > > | Test Case (score) | Baseline |  Hypercall | %delta |  MMIO | %del=
ta |
> > > > +-------------------+----------+------------+--------+-------+-----=
---+
> > > > | Weighted Total    |     6136 |       7274 |   +19% |  6867 |   +1=
2% |
> > > > +-------------------+----------+------------+--------+-------+-----=
---+
> > > > | Web Browsing      |     5558 |       6273 |   +13% |  6035 |    +=
9% |
> > > > +-------------------+----------+------------+--------+-------+-----=
---+
> > > > | Video Editing     |     4921 |       5221 |    +6% |  5167 |    +=
5% |
> > > > +-------------------+----------+------------+--------+-------+-----=
---+
> > > > | Writing           |     6864 |       8825 |   +29% |  8529 |   +2=
4% |
> > > > +-------------------+----------+------------+--------+-------+-----=
---+
> > > > | Photo Editing     |     7983 |      11593 |   +45% | 10812 |   +3=
5% |
> > > > +-------------------+----------+------------+--------+-------+-----=
---+
> > > > | Data Manipulation |     5814 |       6081 |    +5% |  5327 |    -=
8% |
> > > > +-------------------+----------+------------+--------+-------+-----=
---+
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
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > We are continuing to look into communication mechanisms other than
> > > > hypercalls that are just as/more efficient and avoid switching into=
 the VMM
> > > > userspace. Any inputs in this regard are greatly appreciated.
> > >
> > > We're highly unlikely to entertain such an interface in KVM.
> > >
> > > The entire feature is dependent on pinning vCPUs to physical cores, f=
or which
> > > userspace is in the driver's seat. That is a well established and doc=
umented
> > > policy which can be seen in the way we handle heterogeneous systems a=
nd
> > > vPMU.
> > >
> > > Additionally, this bloats the KVM PV ABI with highly VMM-dependent in=
terfaces
> > > that I would not expect to benefit the typical user of KVM.
> > >
> > > Based on the data above, it would appear that the userspace implement=
ation is
> > > in the same neighborhood as a KVM-based implementation, which only fu=
rther
> > > weakens the case for moving this into the kernel.
> > >
> > > I certainly can appreciate the motivation for the series, but this fe=
ature
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

See my reply to Oliver and Marc. To me it looks like we are converging
towards having shared memory between guest, host kernel and VMM and
that should address all our concerns.

The guest will see a MMIO device, writing to it will trigger the host
kernel to do the basic "set util_guest/uclamp for the vCPU thread that
corresponds to the vCPU" and then the VMM can do more on top as/if
needed (because it has access to the shared memory too). Does that
make sense?

Even in the extreme example, the stuff the kernel would do would still
be helpful, but not sufficient. You can aggregate the
util_guest/uclamp and do whatever from the VMM.
Technically in the extreme example, you don't need any of this. The
normal util tracking of the vCPU thread on the host side would be
sufficient.

Actually any time we have only 1 vCPU host thread per VM, we shouldn't
be using anything in this patch series and not instantiate the guest
device at all.

> So +1 from me to move this as a virtual device of some kind. And if the
> extra cost of exiting all the way back to userspace is prohibitive (is
> it btw?),

I think the "13% increase in battery consumption for games" makes it
pretty clear that going to userspace is prohibitive. And that's just
one example.

> then we can try to work on that. Maybe something a la vhost
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

Part of the communication doesn't need synchronous handling by the
host. So, what I said above.

> Thinking about it, using SCMI over virtio would implement exactly that.
> Linux-as-a-guest already supports it IIRC, so possibly the problem
> being addressed in this series could be 'simply' solved using an SCMI
> backend in the VMM...

This will be worse than all the options we've tried so far because it
has the userspace overhead AND uclamp overhead.

-Saravana
