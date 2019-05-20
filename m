Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD50F22C37
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 08:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbfETGiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 02:38:54 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38092 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730396AbfETGiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 02:38:54 -0400
Received: by mail-ot1-f66.google.com with SMTP id s19so11977688otq.5;
        Sun, 19 May 2019 23:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ft61RGLu+B9D+XA45SejYI1GMDQThqjRc6gz3XEAjd4=;
        b=DDgdFRuuoTma4VQ5D933PuiKMN0m2w9Rbiqtl4EdnGfkmgpH2CaufM/cZhofaVZ041
         4RNXZ1SqsY75HaVM6mOhs8Zp0GWOOsG2/+MIgzF6oj/yM99U8oHKuAnO569fmei8VEHy
         V+7Xg6N8aAtY93lCqI2IjLlBY+IOxu23SRg+XI0sbvXWtpLtiiKzi5gO5UoPddEOFiUq
         LUA/1gwuqM8uogM0JfCwfpiob3ooUkX+6+82vB9QefUO9HkEXd7Ykrb+onr3SHoESbTC
         yc7AjsyUqgaQU0OxM6LH7pAifzt+ISL6n6HTF694J86V3b13IepkCJrLW3GkkYPnY5Nh
         zV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ft61RGLu+B9D+XA45SejYI1GMDQThqjRc6gz3XEAjd4=;
        b=VFc+hTb70BkWheuSD5KvJ/LFMrlMx6OPRsZuKl7Tzo0jOk3Q73PJuh21nEBZ9QuAxL
         d/IiWzuPeAVCgbEEscwb1huwYeyyNfslmYcfq0N94NZnbA356z9gApK+Iyvjgk6GOQ7+
         ifAiZP9CGiGt1HxkwOqJlvrit4jVsdEHR5VXZ24rDl/RPRxfwlO53TW/FrgAJHBVaNd4
         R45rp7r4KKpC7mmX4VcBrtnRtTwm49d1TjE10dh0ytb/m0K0RUeQ8WC7/3mqCoX8xstC
         NDRbauWLv7soTmBOGuGL6yQkml1xluqR3t2iIz8ODPtC2ZR2sBzbIq088iCPYbd4ZNGu
         olQg==
X-Gm-Message-State: APjAAAUElvEhWuByPXdWAevrrVgX2kuF7+1JLNfJav6soVVhRhj6QGlZ
        M9a9Cvh75aDq62hekoE6f2R1ebMNER7fw6pbwf4=
X-Google-Smtp-Source: APXvYqzMqz1Nir3DOXJ3BvQUcNpd7qcrb+x7eMdO0m7sXVYYRFThvXTPOI/QoGTnvxM2hdl+pYQYsNHQLEt6LwD98JA=
X-Received: by 2002:a9d:6312:: with SMTP id q18mr2927734otk.45.1558334333277;
 Sun, 19 May 2019 23:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
 <1557975980-9875-5-git-send-email-wanpengli@tencent.com> <20190517194450.GH15006@linux.intel.com>
In-Reply-To: <20190517194450.GH15006@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 20 May 2019 14:38:44 +0800
Message-ID: <CANRm+Cz1kVkPQwDB3s_kD1ewdgUWaB4kQNZj_FqACPKk032Mgw@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] KVM: LAPIC: Delay trace advance expire delta
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

On Sat, 18 May 2019 at 03:44, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 16, 2019 at 11:06:19AM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > wait_lapic_expire() call was moved above guest_enter_irqoff() because o=
f
> > its tracepoint, which violated the RCU extended quiescent state invoked
> > by guest_enter_irqoff()[1][2]. This patch simply moves the tracepoint
> > below guest_exit_irqoff() in vcpu_enter_guest(). Snapshot the delta bef=
ore
> > VM-Enter, but trace it after VM-Exit. This can help us to move
> > wait_lapic_expire() just before vmentry in the later patch.
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
> >  arch/x86/kvm/lapic.c | 16 ++++++++--------
> >  arch/x86/kvm/lapic.h |  1 +
> >  arch/x86/kvm/x86.c   |  2 ++
> >  3 files changed, 11 insertions(+), 8 deletions(-)
> >
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
>
> I'd prefer to keep "guest_tsc < tsc_deadline" here, just so that it's
> obvious that the call to __wait_lapic_expire() is safe.  My eyes did a
> few double takes reading this code :-)

Ok.

>
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
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f2e3847..4a7b00c 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7961,6 +7961,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
> >       ++vcpu->stat.exits;
> >
> >       guest_exit_irqoff();
> > +     trace_kvm_wait_lapic_expire(vcpu->vcpu_id,
> > +             vcpu->arch.apic->lapic_timer.advance_expire_delta);
>
> This needs to be guarded with lapic_in_kernel(vcpu).  But, since this is
> all in the same flow, a better approach would be to return the delta from
> wait_lapic_expire().  That saves 8 bytes in struct kvm_timer and avoids
> additional checks for tracing the delta.

As you know, the function wait_lapic_expire() will be moved to vmx.c
and svm.c, so this is not suitable any more.

Regards,
Wanpeng Li

>
> E.g.:
>
>         s64 lapic_expire_delta;
>
>         ...
>
>         if (lapic_in_kernel(vcpu) &&
>             vcpu->arch.apic->lapic_timer.timer_advance_ns)
>                 lapic_expire_delta =3D wait_lapic_expire(vcpu);
>         else
>                 lapic_expire_delta =3D 0;
>
>         ...
>
>         trace_kvm_wait_lapic_expire(vcpu->vcpu_id, lapic_expire_delta);
> >
> >       local_irq_enable();
> >       preempt_enable();
> > --
> > 2.7.4
> >
