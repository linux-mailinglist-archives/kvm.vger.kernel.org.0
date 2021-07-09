Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448D63C26B7
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 17:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhGIPVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 11:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbhGIPVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 11:21:19 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9207C0613E6
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 08:18:34 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id k8so8569977lja.4
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 08:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHB2yg+xWjLI3+5K3Ej64oZZcS/Ol5E7tQPgfsdpphU=;
        b=pO6eySDGQ5XpTC2So1IxOnNeAh5+1LSRTcpntr9Jhg1FGIIf8sRxk2EGrrJqEcBP89
         KKmaTgzBU8NOYYNMMC5sSpmU85HJDNgEnmE5kX/Dmeap8hB9Tusj/Fzd8XNSaiRKI3Ku
         y6fRMfHC9wBRahg7R+l+aOGjVg/cqDdCaIJNJ3IDk/DnVazpIuwQmu1RYaCCsQpbzwG9
         biNotNwpHz5I/eSO/Cw0Ic75EfaDV1Zw2lKol8HiSiMsn9rTFKPjy08r+IEq2XzdSY4o
         UYLo4D6nNKpmwT2K9yHjuMSiS8n1Gpjr3BLRPfIN9LpCui4p3Ms+DavP4lrp08gpFF8n
         epbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHB2yg+xWjLI3+5K3Ej64oZZcS/Ol5E7tQPgfsdpphU=;
        b=XfPUtpJmXo01MRLhPZVRzuTEc/8MXQFK0kF9/bolYt+ld2U7/1yGEUKSHoIZhhMt/m
         jHFFFGMlsB/sep6HlWxLjn+wS0Zsy3BzznBhodxl3aI1/SJLgB3kIrcEkkEeni1tysgL
         1kiBLPK3vsX2L+pLHKnR9Y8MpQvvungYRsMWsqwa2XElQ7SMXkg1rTo8fklfYZU9gkX9
         ksa6cZ3sJENjmtpm4N0wG2jd6oXs1+BSXXgPUAjHJUfoatDP+aCx6xv8uQpQeXaaHyWO
         dSCGqA8oNcvdF3GG7IzPUoaYGr/OeeDw/9ZDOBz9PPZVXRD0f4piWNbi2PXFaCBs5Ss4
         WEpQ==
X-Gm-Message-State: AOAM530YC+c/n3JTjlqR8fLaCfhWWn6vx+/MZVTk7TwY3aW+8a95Qzg2
        alpGuiKb5ZNJmWI/+X/1//6M4yj3GhrIJzUZM1uKOQ==
X-Google-Smtp-Source: ABdhPJyr2Cc5q1nJS7Duy/8Mt19V/m9CNZcr0+fvrWxoC5J2ReOfNJkxJEuGlJBfadLKWxku5m/gO/exFjDXLOoAseY=
X-Received: by 2002:a05:651c:d7:: with SMTP id 23mr20236071ljr.304.1625843911345;
 Fri, 09 Jul 2021 08:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-5-jingzhangos@google.com> <YOdxLwJx00nQIR87@google.com>
In-Reply-To: <YOdxLwJx00nQIR87@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 9 Jul 2021 10:18:20 -0500
Message-ID: <CAAdAUti1C0s6b4acDeLHQqbFgswiwuUZNN+mVc4Zeh8_ZTRNzQ@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] KVM: stats: Add halt polling related histogram stats
To:     David Matlack <dmatlack@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 8, 2021 at 4:42 PM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, Jul 06, 2021 at 06:03:50PM +0000, Jing Zhang wrote:
> > Add simple stats halt_wait_ns to record the time a VCPU has spent on
> > waiting for all architectures (not just powerpc).
> > Add three log histogram stats to record the distribution of time spent
> > on successful polling, failed polling and VCPU wait.
> > halt_poll_success_hist: Distribution of time spent before a successful
> > polling.
> > halt_poll_fail_hist: Distribution of time spent before a failed polling.
> > halt_wait_hist: Distribution of time a VCPU has spent on waiting.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/powerpc/include/asm/kvm_host.h |  1 -
> >  arch/powerpc/kvm/book3s.c           |  1 -
> >  arch/powerpc/kvm/book3s_hv.c        | 20 +++++++++++++++++---
> >  arch/powerpc/kvm/booke.c            |  1 -
> >  include/linux/kvm_host.h            |  9 ++++++++-
> >  include/linux/kvm_types.h           |  4 ++++
> >  virt/kvm/kvm_main.c                 | 19 +++++++++++++++++++
> >  7 files changed, 48 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> > index 9f52f282b1aa..4931d03e5799 100644
> > --- a/arch/powerpc/include/asm/kvm_host.h
> > +++ b/arch/powerpc/include/asm/kvm_host.h
> > @@ -103,7 +103,6 @@ struct kvm_vcpu_stat {
> >       u64 emulated_inst_exits;
> >       u64 dec_exits;
> >       u64 ext_intr_exits;
> > -     u64 halt_wait_ns;
>
> The halt_wait_ns refactor should be a separate patch.
>
How about putting it into a separate commit? Just want to keep all
halt related change in the
same patch series.
> >       u64 halt_successful_wait;
> >       u64 dbell_exits;
> >       u64 gdbell_exits;
> > diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> > index 5cc6e90095b0..b785f6772391 100644
> > --- a/arch/powerpc/kvm/book3s.c
> > +++ b/arch/powerpc/kvm/book3s.c
> > @@ -69,7 +69,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
> >       STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
> >       STATS_DESC_COUNTER(VCPU, dec_exits),
> >       STATS_DESC_COUNTER(VCPU, ext_intr_exits),
> > -     STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
> >       STATS_DESC_COUNTER(VCPU, halt_successful_wait),
> >       STATS_DESC_COUNTER(VCPU, dbell_exits),
> >       STATS_DESC_COUNTER(VCPU, gdbell_exits),
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> > index cd544a46183e..103f998cee75 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -4144,19 +4144,33 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
> >
> >       /* Attribute wait time */
> >       if (do_sleep) {
> > -             vc->runner->stat.halt_wait_ns +=
> > +             vc->runner->stat.generic.halt_wait_ns +=
> >                       ktime_to_ns(cur) - ktime_to_ns(start_wait);
> > +             kvm_stats_log_hist_update(
> > +                             vc->runner->stat.generic.halt_wait_hist,
> > +                             LOGHIST_SIZE_LARGE,
> > +                             ktime_to_ns(cur) - ktime_to_ns(start_wait));
> >               /* Attribute failed poll time */
> > -             if (vc->halt_poll_ns)
> > +             if (vc->halt_poll_ns) {
> >                       vc->runner->stat.generic.halt_poll_fail_ns +=
> >                               ktime_to_ns(start_wait) -
> >                               ktime_to_ns(start_poll);
> > +                     kvm_stats_log_hist_update(
> > +                             vc->runner->stat.generic.halt_poll_fail_hist,
> > +                             LOGHIST_SIZE_LARGE, ktime_to_ns(start_wait) -
> > +                             ktime_to_ns(start_poll));
> > +             }
> >       } else {
> >               /* Attribute successful poll time */
> > -             if (vc->halt_poll_ns)
> > +             if (vc->halt_poll_ns) {
> >                       vc->runner->stat.generic.halt_poll_success_ns +=
> >                               ktime_to_ns(cur) -
> >                               ktime_to_ns(start_poll);
> > +                     kvm_stats_log_hist_update(
> > +                             vc->runner->stat.generic.halt_poll_success_hist,
> > +                             LOGHIST_SIZE_LARGE,
> > +                             ktime_to_ns(cur) - ktime_to_ns(start_poll));
> > +             }
> >       }
> >
> >       /* Adjust poll time */
> > diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> > index 5ed6c235e059..977801c83aff 100644
> > --- a/arch/powerpc/kvm/booke.c
> > +++ b/arch/powerpc/kvm/booke.c
> > @@ -67,7 +67,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
> >       STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
> >       STATS_DESC_COUNTER(VCPU, dec_exits),
> >       STATS_DESC_COUNTER(VCPU, ext_intr_exits),
> > -     STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
> >       STATS_DESC_COUNTER(VCPU, halt_successful_wait),
> >       STATS_DESC_COUNTER(VCPU, dbell_exits),
> >       STATS_DESC_COUNTER(VCPU, gdbell_exits),
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 356af173114d..268a0ccc9c5f 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1369,7 +1369,14 @@ struct _kvm_stats_desc {
> >       STATS_DESC_COUNTER(VCPU_GENERIC, halt_poll_invalid),                   \
> >       STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),                         \
> >       STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),              \
> > -     STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns)
> > +     STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns),                 \
> > +     STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_success_hist,     \
> > +                     LOGHIST_SIZE_LARGE),                                   \
>
> This should probably be a new macro rather than using LOGHIST_SIZE_LARGE
> everywhere.
>
> #define HALT_POLL_HIST_SIZE LOGHIST_SIZE_LARGE
>
Will double check the new halt polling stats with this idea.
> > +     STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,        \
> > +                     LOGHIST_SIZE_LARGE),                                   \
> > +     STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns),                      \
> > +     STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,             \
> > +                     LOGHIST_SIZE_LARGE)
> >
> >  extern struct dentry *kvm_debugfs_dir;
> >
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index cc88cd676775..7838a42932c8 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -103,6 +103,10 @@ struct kvm_vcpu_stat_generic {
> >       u64 halt_wakeup;
> >       u64 halt_poll_success_ns;
> >       u64 halt_poll_fail_ns;
> > +     u64 halt_poll_success_hist[LOGHIST_SIZE_LARGE];
> > +     u64 halt_poll_fail_hist[LOGHIST_SIZE_LARGE];
> > +     u64 halt_wait_ns;
> > +     u64 halt_wait_hist[LOGHIST_SIZE_LARGE];
> >  };
> >
> >  #define KVM_STATS_NAME_SIZE  48
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 3dcc2abbfc60..840b5bece080 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3093,12 +3093,24 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >                               ++vcpu->stat.generic.halt_successful_poll;
> >                               if (!vcpu_valid_wakeup(vcpu))
> >                                       ++vcpu->stat.generic.halt_poll_invalid;
> > +
> > +                             kvm_stats_log_hist_update(
> > +                                   vcpu->stat.generic.halt_poll_success_hist,
> > +                                   LOGHIST_SIZE_LARGE,
> > +                                   ktime_to_ns(ktime_get()) -
> > +                                   ktime_to_ns(start));
> >                               goto out;
> >                       }
> >                       poll_end = cur = ktime_get();
> >               } while (kvm_vcpu_can_poll(cur, stop));
> > +
> > +             kvm_stats_log_hist_update(
> > +                             vcpu->stat.generic.halt_poll_fail_hist,
> > +                             LOGHIST_SIZE_LARGE,
> > +                             ktime_to_ns(ktime_get()) - ktime_to_ns(start));
>
> nit: Consider creating a wrapper for kvm_stats_log_hist_update() since
> there are so many call sites. You can save a line at every call site by
> avoiding passing in the histogram size.
>
>         void halt_poll_hist_update(u64 *histogram, ktime_t time)
>         {
>                 kvm_stats_log_hist_update(histogram, LOGHIST_SIZE_LARGE, time);
>         }
>
>
Will double check the new halt polling stats with this idea.
> >       }
> >
> > +
> >       prepare_to_rcuwait(&vcpu->wait);
> >       for (;;) {
> >               set_current_state(TASK_INTERRUPTIBLE);
> > @@ -3111,6 +3123,13 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >       }
> >       finish_rcuwait(&vcpu->wait);
> >       cur = ktime_get();
> > +     if (waited) {
> > +             vcpu->stat.generic.halt_wait_ns +=
> > +                     ktime_to_ns(cur) - ktime_to_ns(poll_end);
> > +             kvm_stats_log_hist_update(vcpu->stat.generic.halt_wait_hist,
> > +                             LOGHIST_SIZE_LARGE,
> > +                             ktime_to_ns(cur) - ktime_to_ns(poll_end));
> > +     }
> >  out:
> >       kvm_arch_vcpu_unblocking(vcpu);
> >       block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
> > --
> > 2.32.0.93.g670b81a890-goog
> >
Thanks,
Jing
