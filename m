Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA102F70E9
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 04:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbhAODVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 22:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbhAODVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 22:21:15 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467ABC061575;
        Thu, 14 Jan 2021 19:20:34 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id n42so7276548ota.12;
        Thu, 14 Jan 2021 19:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SU83BBg8Y1H95JuiTqGZ3fNuIYuLcUX0fHS1rihWLi4=;
        b=rZlNSGjA1YQ2qw7TwVXt/cUdOg7S+mj1HUunG9kth86IYDSxzMCLdQHm4jZ69N3/Ix
         bXB719+a8GKxyFS2WwuELprMbAy24BKZwMIers0Fx/DEOtMlOr8tR15B9M9ACPtNk86/
         WMH0HdS6dzs3KMi8IHqbjWMl56uOlWkbSezMNJC3pxLsEiMUyjjvn9/ZnqzRbaYJmhpx
         SUEVZsRGoeOihE1q/Ty5s031UKBObQhcGXnD3FNZDXM+zUMEeqYSax+Ifu0L1RRZc/i6
         Pby8y9gLVibRu0icBI7pRsW2aE1vWZIyUeJa8HoM6ZXXWRtm6TlFlmq1GskVkWJFdQyR
         iR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SU83BBg8Y1H95JuiTqGZ3fNuIYuLcUX0fHS1rihWLi4=;
        b=l7ZJiokjth6/68L1UJzSbCqZHmOTnri/0S68ZTCNZPyvmcJj9iIaCrDKy7CsklZXPg
         AqSh9jZkQkVS62lMVnvvljtRrm9orOI8yOA/Ga3CtMBBBcUDHbfgp3SNAFQae7/QzWhA
         B3m9b0NyLfeal08jS+Neokr1tdrr+FF4+5hvqwa3d+tC9zKM9UQgywvsCGpJeq81jHCb
         TPobxIXaa9eJDxiw8JOI/twAW64N9bdb1mMfApYjaUmz5JuYmASi9v24KFVqi0q20T+i
         W/Kg322PcyoRbV9pgA/bM117LXXxzoer7EJ1lbtBPIoRqJLvu9E8fQicZrOyg6rzsEYc
         g2Hw==
X-Gm-Message-State: AOAM530y+CNoS0HulBZ9rqLi0AJM1I7fm9c5SaJBxYg3FwJF5r2mvBxF
        uX2U/JG4dw2tSRGBULjZ6PwFoKGNVQlAsQ58lUgTZQhpacY=
X-Google-Smtp-Source: ABdhPJw/P6wMN/abg0NeerCMhwN6A3H1Y7cOcebaHPutrJx+eOpLdEedBBpf0mWTWjmZO9vMIobZ3yEj3097YtVTeII=
X-Received: by 2002:a05:6830:4f:: with SMTP id d15mr6810088otp.185.1610680833710;
 Thu, 14 Jan 2021 19:20:33 -0800 (PST)
MIME-Version: 1.0
References: <20210105192844.296277-1-nitesh@redhat.com> <X/UIh1PqmSLNg8vM@google.com>
In-Reply-To: <X/UIh1PqmSLNg8vM@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 15 Jan 2021 11:20:22 +0800
Message-ID: <CANRm+Cz1nHkLm=hg-JN3j-s-w1_c0zWm=EYLJ7hzPW-2k_a2Gw@mail.gmail.com>
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest context"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        w90p710@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 at 08:51, Sean Christopherson <seanjc@google.com> wrote:
>
> +tglx
>
> On Tue, Jan 05, 2021, Nitesh Narayan Lal wrote:
> > This reverts commit d7a08882a0a4b4e176691331ee3f492996579534.
> >
> > After the introduction of the patch:
> >
> >       87fa7f3e9: x86/kvm: Move context tracking where it belongs
> >
> > since we have moved guest_exit_irqoff closer to the VM-Exit, explicit
> > enabling of irqs to process pending interrupts should not be required
> > within vcpu_enter_guest anymore.
>
> Ugh, except that commit completely broke tick-based accounting, on both Intel
> and AMD.  With guest_exit_irqoff() being called immediately after VM-Exit, any
> tick that happens after IRQs are disabled will be accounted to the host.  E.g.
> on Intel, even an IRQ VM-Exit that has already been acked by the CPU isn't
> processed until kvm_x86_ops.handle_exit_irqoff(), well after PF_VCPU has been
> cleared.
>

This issue can be 100% reproduced.
https://bugzilla.kernel.org/show_bug.cgi?id=204177

> CONFIG_VIRT_CPU_ACCOUNTING_GEN=y should still work (I didn't bother to verify).
>
> Thomas, any clever ideas?  Handling IRQs in {vmx,svm}_vcpu_enter_exit() isn't an
> option as KVM hasn't restored enough state to handle an IRQ, e.g. PKRU and XCR0
> are still guest values.  Is it too heinous to fudge PF_VCPU across KVM's
> "pending" IRQ handling?  E.g. this god-awful hack fixes the accounting:
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 836912b42030..5a777fd35b4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9028,6 +9028,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         vcpu->mode = OUTSIDE_GUEST_MODE;
>         smp_wmb();
>
> +       current->flags |= PF_VCPU;
>         kvm_x86_ops.handle_exit_irqoff(vcpu);
>
>         /*
> @@ -9042,6 +9043,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         ++vcpu->stat.exits;
>         local_irq_disable();
>         kvm_after_interrupt(vcpu);
> +       current->flags &= ~PF_VCPU;
>
>         if (lapic_in_kernel(vcpu)) {
>                 s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
>
> > Conflicts:
> >       arch/x86/kvm/svm.c
> >
> > Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c |  9 +++++++++
> >  arch/x86/kvm/x86.c     | 11 -----------
> >  2 files changed, 9 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index cce0143a6f80..c9b2fbb32484 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4187,6 +4187,15 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
> >
> >  static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> >  {
> > +     kvm_before_interrupt(vcpu);
> > +     local_irq_enable();
> > +     /*
> > +      * We must have an instruction with interrupts enabled, so
> > +      * the timer interrupt isn't delayed by the interrupt shadow.
> > +      */
> > +     asm("nop");
> > +     local_irq_disable();
> > +     kvm_after_interrupt(vcpu);
> >  }
> >
> >  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 3f7c1fc7a3ce..3e17c9ffcad8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9023,18 +9023,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >
> >       kvm_x86_ops.handle_exit_irqoff(vcpu);
> >
> > -     /*
> > -      * Consume any pending interrupts, including the possible source of
> > -      * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
> > -      * An instruction is required after local_irq_enable() to fully unblock
> > -      * interrupts on processors that implement an interrupt shadow, the
> > -      * stat.exits increment will do nicely.
> > -      */
> > -     kvm_before_interrupt(vcpu);
> > -     local_irq_enable();
> >       ++vcpu->stat.exits;
> > -     local_irq_disable();
> > -     kvm_after_interrupt(vcpu);
> >
> >       if (lapic_in_kernel(vcpu)) {
> >               s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
> > --
> > 2.27.0
> >
