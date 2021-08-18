Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B033F08BB
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 18:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhHRQKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 12:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhHRQKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 12:10:20 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673C2C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 09:09:45 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id q21so6045745ljj.6
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 09:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tHnhNtLddRQOA3Axt0k000vlO0Owd0of5+pA/CBW0xs=;
        b=o1phBxQPnIMlCJ2jcvqW8gIZosfP3pj2y0s3lI4HpqRVRrOk3kukEsommA9bJPpmQJ
         DEB4GVDIqayhVTfboGPjynmDZarCjHdW1UdnEaXGgnDRHUq9SedOBY59SBPzEkPjEeS1
         v9iK4T3uxEz6pWfowbtFOBp7b5yNCeyM9pGkektgr4bjrFswfX0p78qi+VXk3sSOS5bD
         cU7MJHaMRJKMRXMNsZyzZurKcOfAH0ILzqTn16KRnjSeTXrWiIavOGifzUXz1nMHsjeC
         NCfwVd7PULoFWE/n0sNkeT9yVnVk1i4RGamtDOk15WK70BX5l4P2ZTtKbToqO3UeCX4c
         dZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tHnhNtLddRQOA3Axt0k000vlO0Owd0of5+pA/CBW0xs=;
        b=ijvvSOH4nQweBYXQHkXi1gTvQowmasSmLEVMul6uWwSSryLQlckp2vrx5Bl9GCWakf
         mUMNcRCYa89Zig882Q3DqtxZ50XoLZI9qXq3hVmyNdOMI9CmYsHvgzGJsmbIu2Wihmll
         BoZ0ha+KESuqseGpp9nY6vVl/fUYvoKL9PjByUTfxD9jRMNhDUQS93Bdtng1zk2ynYT7
         FAbaJ3bt86aHzCj4wpgclmOYIjj7b7b6yzy1M8Mo3lemXCM8Y9SOu6d6Yf8cc0qqQVne
         ikjZek3ppZopF+Go1hzR5UrAqeQHCcGCFjgODD71wBJg53heKli/MbdaK9oqnmtpvk2D
         6/xg==
X-Gm-Message-State: AOAM533PzY2RfYRMpAuPsHuOxZDxcGRZmhKR16VpydsuVyngySpjAd6P
        6+O04+flRjDyTf21o7DTH1JQfkvH9akvnQBsWQP4lg==
X-Google-Smtp-Source: ABdhPJzsDlNkQ1AEA+WEQnod1wuALKA3XaZkKbgYB208IkOx2w+pz5Y+F26mEuk3gMA4X4W5tJkkVg45pEKVnfSxDrA=
X-Received: by 2002:a2e:a7d4:: with SMTP id x20mr8780153ljp.394.1629302983447;
 Wed, 18 Aug 2021 09:09:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210817230508.142907-1-jingzhangos@google.com> <YRxKZXm68FZ0jr34@google.com>
In-Reply-To: <YRxKZXm68FZ0jr34@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 18 Aug 2021 09:09:32 -0700
Message-ID: <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: add stats to detect if vcpu is currently halted
To:     Sean Christopherson <seanjc@google.com>
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Cannon Matthews <cannonmatthews@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Tue, Aug 17, 2021 at 4:46 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Aug 17, 2021, Jing Zhang wrote:
> > Current guest/host/halt stats don't show when we are currently halting
>
> s/we are/KVM is
>
> And I would probably reword it to "when KVM is blocking a vCPU in response to
> the vCPU activity state, e.g. halt".  More on that below.
>
> > well. If a guest halts for a long period of time they could appear
> > pathologically blocked but really it's the opposite there's nothing to
> > do.
> > Simply count the number of times we enter and leave the kvm_vcpu_block
>
> s/we/KVM
>
> In general, it's good practice to avoid pronouns in comments and changelogs as
> doing so all but forces using precise, unambiguous language.  Things like 'it'
> and 'they' are ok when it's abundantly clear what they refer to, but 'we' and 'us'
> are best avoided entirely.
>
> > function per vcpu, if they are unequal, then a VCPU is currently
> > halting.
> > The existing stats like halt_exits and halt_wakeups don't quite capture
> > this. The time spend halted and halt polling is reported eventually, but
> > not until we wakeup and resume. If a guest were to indefinitely halt one
> > of it's CPUs we would never know, it may simply appear blocked.
>      ^^^^      ^^
>      its       userspace?
>
>
> The "blocked" terminology is a bit confusing since KVM is explicitly blocking
> the vCPU, it just happens to mostly do so in response to a guest HLT.  I think
> "block" is intended to mean "vCPU task not run", but it would be helpful to make
> that clear.
>
That's a good point. Will reword the comments as you suggested.
> > Original-by: Cannon Matthews <cannonmatthews@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  include/linux/kvm_host.h  | 4 +++-
> >  include/linux/kvm_types.h | 2 ++
> >  virt/kvm/kvm_main.c       | 2 ++
> >  3 files changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index d447b21cdd73..23d2e19af3ce 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1459,7 +1459,9 @@ struct _kvm_stats_desc {
> >       STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,        \
> >                       HALT_POLL_HIST_COUNT),                                 \
> >       STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,             \
> > -                     HALT_POLL_HIST_COUNT)
> > +                     HALT_POLL_HIST_COUNT),                                 \
> > +     STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_starts),                   \
> > +     STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_ends)
>
> Why two counters?  It's per-vCPU, can't this just be a "blocked" flag or so?  I
> get that all the other stats use "halt", but that's technically wrong as KVM will
> block vCPUs that are not runnable for other reason, e.g. because they're in WFS
> on x86.
The two counters are used to determine the reason why vCPU is not
running. If the halt_block_ends is one less than halt_block_starts,
then we know the vCPU is explicitly blocked by KVM. Otherwise, we know
there might be something wrong with the vCPU. Does this make sense?
Will rename from "halt_block_*" to "vcpu_block_*".

Thanks,
Jing
