Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E258DBC3E6
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 10:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409433AbfIXILH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 04:11:07 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:45014 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409428AbfIXILH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 04:11:07 -0400
Received: by mail-yb1-f196.google.com with SMTP id f1so368028ybq.11
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 01:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bf7s21SxYMbnBeKNwTjTIeOSbHSDn1quny+f4Km2hrQ=;
        b=VdDPs/1sIsEkegjUIVHkkeG5PDpTz9X7KNKBX0xYqC7EmyVYJpig/q7IDxU+UXayYk
         zdr+gbsCdBtydnWIwKXJetwELemHgI3OhABAfGaK8WjKEHFG3s86tLK7sViG9Fn2tthy
         8sBr7PuUQ2vUszuL/cuoBol2A/e59ssGzKZFuaZ2fLH4EFSIu3y2y+hYMEFijrO8YZuf
         k0JaDlYoouQHL1gSjmZZIsIw9j3H3utE21SdlhlSEjHW9sxMG3dxDSEdKoqu8BcCluml
         qfQWkGch453WluvEHTlyAa/3xElXDBqYOxL7w8Gt8BNUJyfTfeb8WqXXs+X+GdsBLkO3
         K36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bf7s21SxYMbnBeKNwTjTIeOSbHSDn1quny+f4Km2hrQ=;
        b=lLHjnaRbrhRy6eBYpLUpXcpOEBntpO4CPKy8Y0CpuMidDWCRpei8TIP6ePgGIxqB+U
         rgqnHvRHuni6f8d0epmmrmqpiLJuzMZAMLEAP0ycyblX1Ud1Gv9IrbR0g+Hyp/8LdFMZ
         9jCAy35TMujy8IDTxYV5uNOjrdEZn04eApryvvj+E0/wEduKDIDCMv9rpa6l19j+JPkH
         To9aQP1OpchoS1x3S6MAepCtOuADLb4t1flMLenHMC/l2yhwK2yB3j51cGuXW/MVhoz5
         VM6LzHo/4XIPE+MxkY8Gaj57O795Uq3bHrwrotZB/mT4rlGTaWjI38qHGgPL7sDz/zbl
         tmXQ==
X-Gm-Message-State: APjAAAWS6UZloAkCKn/oK7FnZ7ukjL/W/zgB7zZsL4WNiJSkYH7TYehO
        5QHc5Z0LfxKIjLWXPgdRcMaMZP/5TR2PgF6wjR/BYw==
X-Google-Smtp-Source: APXvYqxgRUt0S55DeFNvzPAntwNC3dCTwTs7jIj21VDRrVbKOOaka+5CyeYs10Hil6D801XvnmahIRTBmGodhmmOMHk=
X-Received: by 2002:a5b:38c:: with SMTP id k12mr1158117ybp.320.1569312666248;
 Tue, 24 Sep 2019 01:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190920062713.78503-1-suleiman@google.com> <20190920062713.78503-3-suleiman@google.com>
 <87woe38538.fsf@vitty.brq.redhat.com>
In-Reply-To: <87woe38538.fsf@vitty.brq.redhat.com>
From:   Suleiman Souhlal <suleiman@google.com>
Date:   Tue, 24 Sep 2019 17:10:55 +0900
Message-ID: <CABCjUKDPa1wrvp5zrjCa0tAQUO5UuFNgc00Z5kt_7rgakjApDw@mail.gmail.com>
Subject: Re: [RFC 2/2] x86/kvmclock: Use host timekeeping.
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     John Stultz <john.stultz@linaro.org>, sboyd@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        rkrcmar@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        Tomasz Figa <tfiga@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 20, 2019 at 10:33 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Suleiman Souhlal <suleiman@google.com> writes:
>
> > When CONFIG_KVMCLOCK_HOST_TIMEKEEPING is enabled, and the host
> > supports it, update our timekeeping parameters to be the same as
> > the host. This lets us have our time synchronized with the host's,
> > even in the presence of host NTP or suspend.
> >
> > When enabled, kvmclock uses raw tsc instead of pvclock.
> >
> > When enabled, syscalls that can change time, such as settimeofday(2)
> > or adj_timex(2) are disabled in the guest.
> >
> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> > ---
> >  arch/x86/Kconfig                |   9 +++
> >  arch/x86/include/asm/kvmclock.h |   2 +
> >  arch/x86/kernel/kvmclock.c      | 127 +++++++++++++++++++++++++++++++-
> >  kernel/time/timekeeping.c       |  21 ++++++
> >  4 files changed, 155 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 4195f44c6a09..37299377d9d7 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -837,6 +837,15 @@ config PARAVIRT_TIME_ACCOUNTING
> >  config PARAVIRT_CLOCK
> >       bool
> >
> > +config KVMCLOCK_HOST_TIMEKEEPING
> > +     bool "kvmclock uses host timekeeping"
> > +     depends on KVM_GUEST
> > +     ---help---
> > +       Select this option to make the guest use the same timekeeping
> > +       parameters as the host. This means that time will be almost
> > +       exactly the same between the two. Only works if the host uses "tsc"
> > +       clocksource.
> > +
>
> I'd also like to speak up against this config, it is confusing. In case
> the goal is to come up with a TSC-based clock for guests which will
> return the same as clock_gettime() on the host (or, is the goal to just
> have the same reading for all guests on the host?) I'd suggest we create
> a separate (from KVMCLOCK) clocksource (mirroring host timekeeper) and
> guests will be free to pick the one they like.

Fair enough. I'll do that in the next version of the patch.

The goal is to have a guest clock that gives the same
clock_gettime(CLOCK_MONOTONIC) as the host.

Thanks,
-- Suleiman
