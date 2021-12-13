Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E98D472127
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 07:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhLMGiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 01:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhLMGiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 01:38:07 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1253AC061748
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 22:38:06 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id q25so22054740oiw.0
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 22:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8lP8OOorDp4RjZXoLRJhvTaaFlxLo7QMGtZf6Mua7X0=;
        b=VvqbD7i/phDRw4qlo/3D8JSYLBuK9N9Idj+2AhKszf22QRc3mns9rbQIAGYmQR9Cre
         JJpX/99WXVnfLUPMIEYw2BTEp9BUVjizx52QBoujIaooCUu8OPiqPGCw82L8McPAGRwT
         casmlHZ73tCkjgVEfcjpBt9xLgXUc90nWtz8/VKTj7VYJ2Vx6cTxdr6bSrsa3jKd0HNR
         3gdzjbK/ZXnJy/ZFb1NuP0MOixRinsKK6eqEnnAUNPJu02kCTdEWdJrxMnwSwJ+xOHak
         k7h4HU4Yiic7u4xbqqGgQzrRaf3PyGTYV4OAhvomtwbga8lCFria43ju8aUxFnAS32XI
         lhtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8lP8OOorDp4RjZXoLRJhvTaaFlxLo7QMGtZf6Mua7X0=;
        b=UUbY4/xgvqIICz8SdyOi37HKeopdE02qdZ/FPKlutgc8zvtIuOzsJ3hjoGSHOUu89M
         WxXI5jFtXmne/P2WMA66HNuCxPG8acR2DG3PqLU+dfr5ZyHMJ+k4RBsIhFb+LVwlsnqa
         TW5Pf9r8PbOd+oMwPv7JCRWx7TbHh8dEaHH5+V3emfbzyfne9DOmb4h1YUlFYuA5HGhb
         f83ohWBZplpQAJtSvWOf8VeDZOEEN0NnF0hG582/8mvvi5Dvngn79o8oaKDloGyqPjbl
         pFTI5z2oXEOpHtKaf1yMa+swBVEVWoMabs24/LRBikjBHQt4zt/M00PNIugQBUZEniWW
         TmXQ==
X-Gm-Message-State: AOAM531qFdZLNG+KQ1O2uucwkfhgQdvbJF+R5jfHVD8DJYTn8WZtVvSY
        MOPBpjQUF+evM/eYwHdzeZkYgNl5c0PQ9OACnQklAQ==
X-Google-Smtp-Source: ABdhPJxrvfANGAnK2tE5T2zE6CDhSVPk9jE0d3+LQ+mW7YRbOoSb0FlzP9qgVi00dKe8M4+tNVTTAP024Bdvq936/zY=
X-Received: by 2002:aca:674a:: with SMTP id b10mr26934304oiy.66.1639377485743;
 Sun, 12 Dec 2021 22:38:05 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-5-likexu@tencent.com>
 <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com>
 <0ca44f61-f7f1-0440-e1e1-8d5e8aa9b540@gmail.com> <CALMp9eTtsMuEsimONp7TOjJ-uskwJBD-52kZzOefSKXeCwn_5A@mail.gmail.com>
 <b6c1eb18-9237-f604-9a96-9e6ca397121c@redhat.com> <CALMp9eRy==yu1uQriqbeezeQ+mtFyfyP_iy9HdDiSZ27SnEfFg@mail.gmail.com>
 <c381aa2c-beb5-480f-1f24-a14de693e78f@redhat.com> <CALMp9eTKrQVCQPm=hcA50JSUCctPaGLEP19biVbGAtBN54dQfA@mail.gmail.com>
 <CALMp9eS8xDgdbfJTbzMmek3RcXKwkLdGMW-uMkJR3eJZ6sf0GA@mail.gmail.com>
In-Reply-To: <CALMp9eS8xDgdbfJTbzMmek3RcXKwkLdGMW-uMkJR3eJZ6sf0GA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sun, 12 Dec 2021 22:37:54 -0800
Message-ID: <CALMp9eThnOMnCkYp1LYM6Ph3NeB296QvXEWtn06A_1XtS+VCDA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, Andi Kleen <ak@linux.intel.com>,
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

On Sat, Dec 11, 2021 at 8:56 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Dec 10, 2021 at 3:31 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Dec 10, 2021 at 2:59 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 12/10/21 23:55, Jim Mattson wrote:
> > > >>
> > > >> Even for tracing the SDM says "Like the value returned by RDTSC, TSC
> > > >> packets will include these adjustments, but other timing packets (such
> > > >> as MTC, CYC, and CBR) are not impacted".  Considering that "stand-alone
> > > >> TSC packets are typically generated only when generation of other timing
> > > >> packets (MTCs and CYCs) has ceased for a period of time", I'm not even
> > > >> sure it's a good thing that the values in TSC packets are scaled and offset.
> > > >>
> > > >> Back to the PMU, for non-architectural counters it's not really possible
> > > >> to know if they count in cycles or not.  So it may not be a good idea to
> > > >> special case the architectural counters.
> > > >
> > > > In that case, what we're doing with the guest PMU is not
> > > > virtualization. I don't know what it is, but it's not virtualization.
> > >
> > > It is virtualization even if it is incompatible with live migration to a
> > > different SKU (where, as you point out below, multiple TSC frequencies
> > > might also count as multiple SKUs).  But yeah, it's virtualization with
> > > more caveats than usual.
> >
> > It's not virtualization if the counters don't count at the rate the
> > guest expects them to count.
>
> Per the SDM, unhalted reference cycles count at "a fixed frequency."
> If the frequency changes on migration, then the value of this event is
> questionable at best. For unhalted core cycles, on the other hand, the
> SDM says, "The performance counter for this event counts across
> performance state transitions using different core clock frequencies."
> That does seem to permit frequency changes on migration, but I suspect
> that software expects the event to count at a fixed frequency if
> INVARIANT_TSC is set.

Actually, I now realize that unhalted reference cycles is independent
of the host or guest TSC, so it is not affected by TSC scaling.
However, we still have to decide on a specific fixed frequency to
virtualize so that the frequency doesn't change on migration. As a
practical matter, it may be the case that the reference cycles
frequency is the same on all processors in a migration pool, and we
don't have to do anything.


> I'm not sure that I buy your argument regarding consistency. In
> general, I would expect the hypervisor to exclude non-architected
> events from the allow-list for any VM instances running in a
> heterogeneous migration pool. Certainly, those events could be allowed
> in a heterogeneous migration pool consisting of multiple SKUs of the
> same microarchitecture running at different clock frequencies, but
> that seems like a niche case.
>
>
> > > > Exposing non-architectural events is questionable with live migration,
> > > > and TSC scaling is unnecessary without live migration. I suppose you
> > > > could have a migration pool with different SKUs of the same generation
> > > > with 'seemingly compatible' PMU events but different TSC frequencies,
> > > > in which case it might be reasonable to expose non-architectural
> > > > events, but I would argue that any of those 'seemingly compatible'
> > > > events are actually not compatible if they count in cycles.
> > > I agree.  Support for marshaling/unmarshaling PMU state exists but it's
> > > more useful for intra-host updates than for actual live migration, since
> > > these days most live migration will use TSC scaling on the destination.
> > >
> > > Paolo
> > >
> > > >
> > > > Unless, of course, Like is right, and the PMU counters do count fractionally.
> > > >
> > >
