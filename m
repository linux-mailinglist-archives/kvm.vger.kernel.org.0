Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580411FDF2
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 05:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfEPDNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 23:13:50 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42049 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfEPDNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 23:13:50 -0400
Received: by mail-oi1-f194.google.com with SMTP id k9so1402995oig.9;
        Wed, 15 May 2019 20:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nQLrJG/rtyMfyjg8xodMHV8b5DIFETCrat3O+1ZGccE=;
        b=KMpZas/VkspcTYmIWz/679SkE+o9a7V2vV1HcW0lpalO1ANcgJy5YlOI8hB7ilNHhA
         7HNiylHGgBzvAG2Pv81L8RQVhpAbk2e4QeoaPAie5HkEwcvZYZrdN6rOAsDouqXZQndr
         p0TYbDOrshTuv2QfaQ+pC4ZcJb3aM147yvStgEHMns5rU4CHKWb95UgrUQjJjNGHZYWf
         +R/BIWKuW1eKb9rQZzPJfA9gRixkFpg0X3LtuLD9pS7jwXg6wFKSGkrO1NTFV8h1R4zV
         LTmw9l+fMQynFUmWEnlO144FxeBR+gGyc7RF6T4iyUyrXi5NJdGz3BZdpdYm8sid0IXZ
         Xbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nQLrJG/rtyMfyjg8xodMHV8b5DIFETCrat3O+1ZGccE=;
        b=ixFtUSmZef3NN2pjpoVv/hr1zLux2l68lC6zuuovjtcjnsQmZjg943Fpw/LZQZlfFh
         PKYigB9twlBhsfSJVy1LcaqmYXrrGvSxnh8IcwTHD8fXDYbDYrHhjfmQibeJPbBkgs5n
         dDD19Vuh0CwfchIe8uDzfsLV7BQfk1LxoEo5D4o/ugKGS7RG78bWQ1rchhwaOVhcjr97
         xRQlXIqM0hwZzfkXYyhkNOC6UgzEiHu+CaUj24t1w73T9EzJd67FSqAFZptIRs7fkyLa
         IUZuWJgWEf7QkefT95EbYtfQJWVuxecUfC4Bup9lTVUhYGcxOEw2xsn9j5KsAo/w1v21
         6GKg==
X-Gm-Message-State: APjAAAVlHiO8g+GcnvLWGJIsebGq2KtKOcyQ42C+qOLBMbNzC1Pt8rVa
        yNxkSsl4uGSj4p8S6zngEtYWHHMVFrWXbAWZDQCUug==
X-Google-Smtp-Source: APXvYqy5xIuYztcFAe+BnOihFLgqBgaPMYJBKZp9KPilfdPciLi5qm2f8CD8PqPnGLvQa1MUz8QsMp1XeJ/f1Xjaa90=
X-Received: by 2002:aca:3305:: with SMTP id z5mr4812192oiz.141.1557976429718;
 Wed, 15 May 2019 20:13:49 -0700 (PDT)
MIME-Version: 1.0
References: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
 <1557893514-5815-4-git-send-email-wanpengli@tencent.com> <20190515172132.GE5875@linux.intel.com>
In-Reply-To: <20190515172132.GE5875@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 16 May 2019 11:15:10 +0800
Message-ID: <CANRm+Cx5yQ_VQpSjKmO=Fi2_KCC4Rd_jMUr+mM7qvZ6EUD+=aA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: LAPIC: Expose per-vCPU timer adavance
 information to userspace
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 May 2019 at 01:21, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, May 15, 2019 at 12:11:53PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Expose the per-vCPU advancement information to the user via per-vCPU de=
bugfs
> > entry. wait_lapic_expire() call was moved above guest_enter_irqoff() be=
cause
> > of its tracepoint, which violated the RCU extended quiescent state invo=
ked
> > by guest_enter_irqoff()[1][2]. This patch simply removes the tracepoint=
,
> > which would allow moving wait_lapic_expire(). Sean pointed out:
> >
> > | Now that the advancement time is tracked per-vCPU, realizing a change
> > | in the advancement time requires creating a new VM. For all intents
> > | and purposes this makes it impractical to hand tune the advancement
> > | in real time using the tracepoint as the feedback mechanism.
> >
> > [1] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended q=
uiescent state")
> > [2] https://patchwork.kernel.org/patch/7821111/
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/debugfs.c | 16 ++++++++++++++++
> >  arch/x86/kvm/lapic.c   | 16 ++++++++--------
> >  arch/x86/kvm/lapic.h   |  1 +
> >  arch/x86/kvm/trace.h   | 20 --------------------
> >  4 files changed, 25 insertions(+), 28 deletions(-)
> >
> > diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> > index c19c7ed..8cf542e 100644
> > --- a/arch/x86/kvm/debugfs.c
> > +++ b/arch/x86/kvm/debugfs.c
> > @@ -9,12 +9,22 @@
> >   */
> >  #include <linux/kvm_host.h>
> >  #include <linux/debugfs.h>
> > +#include "lapic.h"
> >
> >  bool kvm_arch_has_vcpu_debugfs(void)
> >  {
> >       return true;
> >  }
> >
> > +static int vcpu_get_timer_expire_delta(void *data, u64 *val)
> > +{
> > +     struct kvm_vcpu *vcpu =3D (struct kvm_vcpu *) data;
> > +     *val =3D vcpu->arch.apic->lapic_timer.advance_expire_delta;
> > +     return 0;
> > +}
> > +
> > +DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_expire_delta_fops, vcpu_get_timer_e=
xpire_delta, NULL, "%lld\n");
> > +
> >  static int vcpu_get_tsc_offset(void *data, u64 *val)
> >  {
> >       struct kvm_vcpu *vcpu =3D (struct kvm_vcpu *) data;
> > @@ -51,6 +61,12 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vc=
pu)
> >       if (!ret)
> >               return -ENOMEM;
> >
> > +     ret =3D debugfs_create_file("advance_expire_delta", 0444,
> > +                                                     vcpu->debugfs_den=
try,
> > +                                                     vcpu, &vcpu_timer=
_expire_delta_fops);
>
> I was thinking we would expose 'kvm_timer.timer_advance_ns', not the
> delta, the idea being that being able to query the auto-adjusted value
> is now the desired behavior.  But rethinking things, that enhancement is
> orthogonal to removing the tracepoint.
>
> Back to the tracepoint, an alternative solution would be to add
> kvm_timer.advance_expire_delta as you did, but rather than add a new
> debugfs entry, simply move the tracepoint below guest_exit_irqoff()
> in vcpu_enter_guest().  I.e. snapshot the delta before VM-Enter, but
> trace it after VM-Exit.
>
> If we want to continue supporting hand tuning the advancement, then a
> tracepoint is much easier for userspace to consume, e.g. it allows the
> user to monitor the history of the delta while adjusting the advancement
> time.  Manually approximating that behavior by sampling the value from
> debugfs would be quite cumbersome.

Good point, handle it in v3.

Regards,
Wanpeng Li

>
> > +     if (!ret)
> > +             return -ENOMEM;
> > +
> >       if (kvm_has_tsc_control) {
> >               ret =3D debugfs_create_file("tsc-scaling-ratio", 0444,
> >                                                       vcpu->debugfs_den=
try,
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 2f364fe..af38ece 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1502,27 +1502,27 @@ static inline void __wait_lapic_expire(struct k=
vm_vcpu *vcpu, u64 guest_cycles)
> >  }
> >
> >  static inline void adaptive_tune_timer_advancement(struct kvm_vcpu *vc=
pu,
> > -                             u64 guest_tsc, u64 tsc_deadline)
> > +                             s64 advance_expire_delta)
> >  {
> >       struct kvm_lapic *apic =3D vcpu->arch.apic;
> >       u32 timer_advance_ns =3D apic->lapic_timer.timer_advance_ns;
> >       u64 ns;
> >
> >       /* too early */
> > -     if (guest_tsc < tsc_deadline) {
> > -             ns =3D (tsc_deadline - guest_tsc) * 1000000ULL;
> > +     if (advance_expire_delta < 0) {
> > +             ns =3D -advance_expire_delta * 1000000ULL;
> >               do_div(ns, vcpu->arch.virtual_tsc_khz);
> >               timer_advance_ns -=3D min((u32)ns,
> >                       timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STE=
P);
> >       } else {
> >       /* too late */
> > -             ns =3D (guest_tsc - tsc_deadline) * 1000000ULL;
> > +             ns =3D advance_expire_delta * 1000000ULL;
> >               do_div(ns, vcpu->arch.virtual_tsc_khz);
> >               timer_advance_ns +=3D min((u32)ns,
> >                       timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STE=
P);
> >       }
> >
> > -     if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DO=
NE)
> > +     if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> >               apic->lapic_timer.timer_advance_adjust_done =3D true;
> >       if (unlikely(timer_advance_ns > 5000)) {
> >               timer_advance_ns =3D 0;
> > @@ -1545,13 +1545,13 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
> >       tsc_deadline =3D apic->lapic_timer.expired_tscdeadline;
> >       apic->lapic_timer.expired_tscdeadline =3D 0;
> >       guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> > -     trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadli=
ne);
> > +     apic->lapic_timer.advance_expire_delta =3D guest_tsc - tsc_deadli=
ne;
> >
> > -     if (guest_tsc < tsc_deadline)
> > +     if (apic->lapic_timer.advance_expire_delta < 0)
> >               __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> >
> >       if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> > -             adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_dead=
line);
> > +             adaptive_tune_timer_advancement(vcpu, apic->lapic_timer.a=
dvance_expire_delta);
> >  }
> >
> >  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index d6d049b..3e72a25 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -32,6 +32,7 @@ struct kvm_timer {
> >       u64 tscdeadline;
> >       u64 expired_tscdeadline;
> >       u32 timer_advance_ns;
> > +     s64 advance_expire_delta;
> >       atomic_t pending;                       /* accumulated triggered =
timers */
> >       bool hv_timer_in_use;
> >       bool timer_advance_adjust_done;
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index 4d47a26..3f9bc62 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -953,26 +953,6 @@ TRACE_EVENT(kvm_pvclock_update,
> >                 __entry->flags)
> >  );
> >
> > -TRACE_EVENT(kvm_wait_lapic_expire,
> > -     TP_PROTO(unsigned int vcpu_id, s64 delta),
> > -     TP_ARGS(vcpu_id, delta),
> > -
> > -     TP_STRUCT__entry(
> > -             __field(        unsigned int,   vcpu_id         )
> > -             __field(        s64,            delta           )
> > -     ),
> > -
> > -     TP_fast_assign(
> > -             __entry->vcpu_id           =3D vcpu_id;
> > -             __entry->delta             =3D delta;
> > -     ),
> > -
> > -     TP_printk("vcpu %u: delta %lld (%s)",
> > -               __entry->vcpu_id,
> > -               __entry->delta,
> > -               __entry->delta < 0 ? "early" : "late")
> > -);
> > -
> >  TRACE_EVENT(kvm_enter_smm,
> >       TP_PROTO(unsigned int vcpu_id, u64 smbase, bool entering),
> >       TP_ARGS(vcpu_id, smbase, entering),
> > --
> > 2.7.4
> >
