Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED2F6D892C
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 23:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjDEVBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 17:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjDEVBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 17:01:39 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833DC5FF2
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 14:01:36 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d13so35306771pjh.0
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 14:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680728496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHFlMisxaJ0plZrJeiWQsYMJJxbUcOQBZpoj9lXl62o=;
        b=o68UQJlSeR/2dP30d3/3CG29eQi7NJUexGjKnFCJlBRne7MBh/pnOLR6z5hr0IcBKF
         rGtNS+VfkApuHBT4LOZszkfDA5ur0hx2XsTYBVaUo9Mpo8zstckblRhZIrIFyUAyNKeC
         bImEOJVQiHH/0xwOgCdHD3FzLTUkJUOUg8YxvZjMvIvVZvTfDl/MO8+nVHCZ6Hjl/s9/
         nBOkPddImEOqiBfKtLNmE4rQkxJtcAAr2zemszvWQQ2l4d4CdHEk5hq0cYT/tIfQAHNQ
         PalbkNTzzkjmk+8KnlFVIxi2D0sXhuYRAxUUR3QGgi5uBzGsU5s1ufo++LrWQ+Aq5Ks9
         PXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680728496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHFlMisxaJ0plZrJeiWQsYMJJxbUcOQBZpoj9lXl62o=;
        b=MvC0pmmCbVqpMIhcZf4nxYXT+ZQLYJbuKS2vyH/AY2+lkyFJC8trW6Zyxe8+cgfLmq
         eYAuYTcRS4zqYChFoiuIYn4QidLWDG/zzsT/20PjPjhs5vUX43Wnt6ZbsQpiLNwb3vOi
         ZQi+VyS7D5zNwPh/3lqyiOIoHkJbRkYaYXGTo9AliMbOH+Nc2PIp/fZY9QTGfgghf9T8
         vnSxpqspQueW4SlckZBw4G+vawQAZDzURPJdkp8kuuVowo+774vjxjYQCQ16hV+eb3Aq
         wORgShTdR2TCNb3GLARHzj5IBc0ut6zamHNpD19VFecrcKdhL9ip+2SB6igFbt1tENoa
         RNAw==
X-Gm-Message-State: AAQBX9cjASwhg5wSIVVw/AmmO3dQMP9LCyI2FKiEzpcZidgVkRESl3sT
        heC9a2WHb9nl1piFQIpQutvALDXMwFtJOsKF5NZRvA==
X-Google-Smtp-Source: AKy350aHiztqd9S0M+CMjOQXju2vYq2NssFDb70LAGMoQGKeCoDHJhiRNivzaqFcE6TN33nMAdUuT1+/TPOGcn3A86M=
X-Received: by 2002:a17:902:a40a:b0:1a0:535b:22d9 with SMTP id
 p10-20020a170902a40a00b001a0535b22d9mr3252431plq.10.1680728495555; Wed, 05
 Apr 2023 14:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com> <ZCx97IKjsBibjdGc@linux.dev>
 <86sfdfv0e1.wl-maz@kernel.org>
In-Reply-To: <86sfdfv0e1.wl-maz@kernel.org>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 5 Apr 2023 14:00:59 -0700
Message-ID: <CAGETcx90SiaztPO21GsHSr18XUTHoLWt3Jv+y=EW5yfjJgzJHw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
To:     Marc Zyngier <maz@kernel.org>
Cc:     David Dai <davidai@google.com>,
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

On Tue, Apr 4, 2023 at 1:49=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 04 Apr 2023 20:43:40 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Folks,
> >
> > On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> >
> > <snip>
> >
> > > PCMark
> > > Higher is better
> > > +-------------------+----------+------------+--------+-------+-------=
-+
> > > | Test Case (score) | Baseline |  Hypercall | %delta |  MMIO | %delta=
 |
> > > +-------------------+----------+------------+--------+-------+-------=
-+
> > > | Weighted Total    |     6136 |       7274 |   +19% |  6867 |   +12%=
 |
> > > +-------------------+----------+------------+--------+-------+-------=
-+
> > > | Web Browsing      |     5558 |       6273 |   +13% |  6035 |    +9%=
 |
> > > +-------------------+----------+------------+--------+-------+-------=
-+
> > > | Video Editing     |     4921 |       5221 |    +6% |  5167 |    +5%=
 |
> > > +-------------------+----------+------------+--------+-------+-------=
-+
> > > | Writing           |     6864 |       8825 |   +29% |  8529 |   +24%=
 |
> > > +-------------------+----------+------------+--------+-------+-------=
-+
> > > | Photo Editing     |     7983 |      11593 |   +45% | 10812 |   +35%=
 |
> > > +-------------------+----------+------------+--------+-------+-------=
-+
> > > | Data Manipulation |     5814 |       6081 |    +5% |  5327 |    -8%=
 |
> > > +-------------------+----------+------------+--------+-------+-------=
-+
> > >
> > > PCMark Performance/mAh
> > > Higher is better
> > > +-----------+----------+-----------+--------+------+--------+
> > > |           | Baseline | Hypercall | %delta | MMIO | %delta |
> > > +-----------+----------+-----------+--------+------+--------+
> > > | Score/mAh |       79 |        88 |   +11% |   83 |    +7% |
> > > +-----------+----------+-----------+--------+------+--------+
> > >
> > > Roblox
> > > Higher is better
> > > +-----+----------+------------+--------+-------+--------+
> > > |     | Baseline |  Hypercall | %delta |  MMIO | %delta |
> > > +-----+----------+------------+--------+-------+--------+
> > > | FPS |    18.25 |      28.66 |   +57% | 24.06 |   +32% |
> > > +-----+----------+------------+--------+-------+--------+
> > >
> > > Roblox Frames/mAh
> > > Higher is better
> > > +------------+----------+------------+--------+--------+--------+
> > > |            | Baseline |  Hypercall | %delta |   MMIO | %delta |
> > > +------------+----------+------------+--------+--------+--------+
> > > | Frames/mAh |    91.25 |     114.64 |   +26% | 103.11 |   +13% |
> > > +------------+----------+------------+--------+--------+--------+
> >
> > </snip>
> >
> > > Next steps:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > We are continuing to look into communication mechanisms other than
> > > hypercalls that are just as/more efficient and avoid switching into t=
he VMM
> > > userspace. Any inputs in this regard are greatly appreciated.

Hi Oliver and Marc,

Replying to both of you in this one email.

> >
> > We're highly unlikely to entertain such an interface in KVM.
> >
> > The entire feature is dependent on pinning vCPUs to physical cores, for=
 which
> > userspace is in the driver's seat. That is a well established and docum=
ented
> > policy which can be seen in the way we handle heterogeneous systems and
> > vPMU.
> >
> > Additionally, this bloats the KVM PV ABI with highly VMM-dependent inte=
rfaces
> > that I would not expect to benefit the typical user of KVM.
> >
> > Based on the data above, it would appear that the userspace implementat=
ion is
> > in the same neighborhood as a KVM-based implementation, which only furt=
her
> > weakens the case for moving this into the kernel.

Oliver,

Sorry if the tables/data aren't presented in an intuitive way, but
MMIO vs hypercall is definitely not in the same neighborhood. The
hypercall method often gives close to 2x the improvement that the MMIO
method gives. For example:

- Roblox FPS: MMIO improves it by 32% vs hypercall improves it by 57%.
- Frames/mAh: MMIO improves it by 13% vs hypercall improves it by 26%.
- PC Mark Data manipulation: MMIO makes it worse by 8% vs hypercall
improves it by 5%

Hypercall does better for other cases too, just not as good. For example,
- PC Mark Photo editing: Going from MMIO to hypercall gives a 10% improveme=
nt.

These are all pretty non-trivial, at least in the mobile world. Heck,
whole teams would spend months for 2% improvement in battery :)

> >
> > I certainly can appreciate the motivation for the series, but this feat=
ure
> > should be in userspace as some form of a virtual device.
>
> +1 on all of the above.

Marc and Oliver,

We are not tied to hypercalls. We want to do the right thing here, but
MMIO going all the way to userspace definitely doesn't cut it as is.
This is where we need some guidance. See more below.

> The one thing I'd like to understand that the comment seems to imply
> that there is a significant difference in overhead between a hypercall
> and an MMIO. In my experience, both are pretty similar in cost for a
> handling location (both in userspace or both in the kernel).

I think the main difference really is that in our hypercall vs MMIO
comparison the hypercall is handled in the kernel vs MMIO goes all the
way to userspace. I agree with you that the difference probably won't
be significant if both of them go to the same "depth" in the privilege
levels.

> MMIO
> handling is a tiny bit more expensive due to a guaranteed TLB miss
> followed by a walk of the in-kernel device ranges, but that's all. It
> should hardly register.
>
> And if you really want some super-low latency, low overhead
> signalling, maybe an exception is the wrong tool for the job. Shared
> memory communication could be more appropriate.

Yeah, that's one of our next steps. Ideally, we want to use shared
memory for the host to guest information flow. It's a 32-bit value
representing the current frequency that the host can update whenever
the host CPU frequency changes and the guest can read whenever it
needs it.

For guest to host information flow, we'll need a kick from guest to
host because we need to take action on the host side when threads
migrate between vCPUs and cause a significant change in vCPU util.
Again it can be just a shared memory and some kick. This is what we
are currently trying to figure out how to do.

If there are APIs to do this, can you point us to those please? We'd
also want the shared memory to be accessible by the VMM (so, shared
between guest kernel, host kernel and VMM).

Are the above next steps sane? Or is that a no-go? The main thing we
want to cut out is the need for having to switch to userspace for
every single interaction because, as is, it leaves a lot on the table.

Also, thanks for all the feedback. Glad to receive it.

-Saravana
