Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F54D7143
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 10:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfJOIkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 04:40:08 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43903 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbfJOIkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 04:40:08 -0400
Received: by mail-yw1-f68.google.com with SMTP id q7so7042643ywe.10
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 01:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AqJilFgL4FnU7FTEYnrwYFbssjg64wIXPF6xmLsOmPw=;
        b=dMv5o/28lV5eqQ6bsstF+8kQTU23HpHM7uGA1mQx9OL8DufixiTQBhQczwb9OZFYYd
         7W3cA2GyJed1k6hXVr/2rwc3AX6DJgZ3fQkDiaw+7l1yVgu2ZIXaPzA9kX08sm87OeAM
         FHNxHoazD5b78yRw0zB7eEiE82F/JskUc7JsqDiXies4CyeBbO2EKG4DTSl32NqdhIfx
         6h7ICpf2yVbyT4NB4KWkpjk22CMGUG0adfxOhwVuaxE/drTDYt2FMC9CvUWdvcJPn64q
         H5oj5wSKb/hqXX3KhJalYdybL5MxH3ZboqDcmr0V8yvqmkIGQIMxj1j2P4/8zTvqfjOb
         zHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AqJilFgL4FnU7FTEYnrwYFbssjg64wIXPF6xmLsOmPw=;
        b=ZnCqyDzmBrT+4JIS64WR6Fi0B3NaAymgkMsBFNE9JBQGlytwKkSlhy+lreKmNmh+CV
         rABovQvzjLAh0xsLhdk1XEwHW4o4F2gbd2WpW+lp92KzrnJqOqVWV94vGmWCiybIAxNm
         zpRwqe2R5LZCd5LLFmuGx462zrobNp/IpRy11LKpnTgk/VnzPMJa8l0Gfi/6tWNGjAHo
         QyEbBtWR5GloPgvpZlchohOt+00HY7BqNZoj9KuAts9/+SASzD7DZ9mf+AKNBBobBGOV
         dKTWpqlpP7A0ybyf8l9D8VfKkCdnTlC+ANFE81LzEJk5g8Hpmnnn9iQGuY+AN69gmLEX
         j5Qw==
X-Gm-Message-State: APjAAAWbB3+nh0tVLy1PAoFIhZi20me0ex7su+8sD1dryYpyI15a4OW0
        tR8eMWnvvQ5Qm+bRz0mrJqYWK29peAECSrR4r4trxLH5lOvqng==
X-Google-Smtp-Source: APXvYqzu3fgAZn0e8gU0Hx3m9VF7LBh6xTjczQQEqITtlLvVTjf0aPPLvwy/C+DdGBt9KgMh8hPRtceTv89bTUbMWlA=
X-Received: by 2002:a81:996:: with SMTP id 144mr16495099ywj.57.1571128807207;
 Tue, 15 Oct 2019 01:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191010073055.183635-1-suleiman@google.com> <20191010073055.183635-3-suleiman@google.com>
 <2e6e5b14-fa68-67bd-1436-293659c8d92c@redhat.com>
In-Reply-To: <2e6e5b14-fa68-67bd-1436-293659c8d92c@redhat.com>
From:   Suleiman Souhlal <suleiman@google.com>
Date:   Tue, 15 Oct 2019 17:39:55 +0900
Message-ID: <CABCjUKAsO9bOW9-VW1gk0O_U=9V6Zhft8LjpcqXVbDVTvWJ5Hw@mail.gmail.com>
Subject: Re: [RFC v2 2/2] x86/kvmclock: Introduce kvm-hostclock clocksource.
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     rkrcmar@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, sboyd@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Suleiman Souhlal <ssouhlal@freebsd.org>,
        tfiga@chromium.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 10, 2019 at 7:55 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/10/19 09:30, Suleiman Souhlal wrote:
> > +kvm_hostclock_enable(struct clocksource *cs)
> > +{
> > +     pv_timekeeper_enabled = 1;
> > +
> > +     old_vclock_mode = kvm_clock.archdata.vclock_mode;
> > +     kvm_clock.archdata.vclock_mode = VCLOCK_TSC;
> > +     return 0;
> > +}
> > +
> > +static void
> > +kvm_hostclock_disable(struct clocksource *cs)
> > +{
> > +     pv_timekeeper_enabled = 0;
> > +     kvm_clock.archdata.vclock_mode = old_vclock_mode;
> > +}
> > +
>
> Why do you poke at kvm_clock?  Instead you should add
>
>         .archdata               = { .vclock_mode = VCLOCK_TSC },
>
> to the kvm_hostclock declaration.

Yeah, what I was doing does not make sense.

> Please also check that the invariant TSC CPUID bit
> CPUID[0x80000007].EDX[8] is set before enabling this feature.

Will do.

>
> Paolo
>
> > +     pvtk = &pv_timekeeper;
> > +     do {
> > +             gen = pvtk_read_begin(pvtk);
> > +             if (!(pv_timekeeper.flags & PVCLOCK_TIMEKEEPER_ENABLED))
> > +                     return;
> > +
> > +             pvclock_copy_into_read_base(pvtk, &tk->tkr_mono,
> > +                 &pvtk->tkr_mono);
> > +             pvclock_copy_into_read_base(pvtk, &tk->tkr_raw, &pvtk->tkr_raw);
> > +
> > +             tk->xtime_sec = pvtk->xtime_sec;
> > +             tk->ktime_sec = pvtk->ktime_sec;
> > +             tk->wall_to_monotonic.tv_sec = pvtk->wall_to_monotonic_sec;
> > +             tk->wall_to_monotonic.tv_nsec = pvtk->wall_to_monotonic_nsec;
> > +             tk->offs_real = pvtk->offs_real;
> > +             tk->offs_boot = pvtk->offs_boot;
> > +             tk->offs_tai = pvtk->offs_tai;
> > +             tk->raw_sec = pvtk->raw_sec;
> > +     } while (pvtk_read_retry(pvtk, gen));
> > +}
> > +
>
> Should you write an "enabled value" (basically the flags) into pvtk as well?

I think we have that already (pvtk->flags).
I'll change the if statement above to use pvtk instead of pv_timekeeper.

> > +kvm_hostclock_init(void)
> > +{
> > +     unsigned long pa;
> > +
> > +     pa = __pa(&pv_timekeeper);
> > +     wrmsrl(MSR_KVM_TIMEKEEPER_EN, pa);
>
>
> As Vitaly said, a new CPUID bit must be defined in
> Documentation/virt/kvm/cpuid.txt, and used here.  Also please make bit 0
> an enable bit.

I think I might not be able to move the enable bit to 0 because we
need the generation count (pvclock_timekeeper.gen) to be the first
word of the struct due to the way we copy the data to userspace,
similarly to how kvm_setup_pvclock_page() does it.

I also noticed the comment in kvm_copy_into_pvtk() references the
wrong function, which I will fix in the next revision.

Thanks for the feedback.

-- Suleiman
