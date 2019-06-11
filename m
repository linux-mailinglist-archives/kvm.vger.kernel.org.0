Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676483C5D4
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 10:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404614AbfFKISD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 04:18:03 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41493 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404401AbfFKISC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 04:18:02 -0400
Received: by mail-ot1-f65.google.com with SMTP id 107so11023326otj.8;
        Tue, 11 Jun 2019 01:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k8iFXP2YapZ/y03rTP+uhVVYNu1jHF/FDPhY8TlmIFs=;
        b=MFEd/YzanQ7feW7RujaUFgXIbQo5AwemZLZzPFqkc6uq3m4qQJrkLQ0VvWQCKTlCFV
         1x5qoFGqBOxMO5+7W8KNz56ceoqTHIK53S2CqTahqDeLTXR0awz/bad+5eDYudoABLGw
         +J0Q0DbHqjJwIWvi2u8GtAQvFA37iFaVPiYwStLMQRJUy+iZbl43DdkFDL8KolXfUw8Q
         ey65t02HQ9igQ0fJddkK/hlKM3dOpbU9Oujpevv/3kaWaopHGPm+CwuUTvpy88QGrPlB
         YTZRSgtEz6vBNBKAr57FnQUg/k86Mh9/fCnAnsRz0V6agOsAiRdeEEznZZ2GBIU6sl1H
         vltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k8iFXP2YapZ/y03rTP+uhVVYNu1jHF/FDPhY8TlmIFs=;
        b=LT31gt/fgBvV+GJmhBuVd27/9Fls3g4kZfXW++VIa/6Ifm3sA2MM/eLhfU4ldZBN8m
         QGqE0EqYh/wjN4SvB+oLobQZ6PX5MDjCzleJS7+jcjVgUawpEAt84L/UH1iA+D3KADrD
         jFZJbLDr31imdPpf6R/FvrNK9FPt+Ki62JYJei/9yygK7LPGUJEzb4UWM3Y6Cen9BD7r
         exjQ42I0o4wuybdAlaUkIZYFs/zz/w12S5ZGqCqbv3NOFbP7M1zaeuJU4+EAuN4+h8KT
         HJros/uh6qGQlcZbWK3ItUkdONddwSvzGh3Xw6onkECD1xRbHevd2TF8xLX+K+fkGczF
         ZlZA==
X-Gm-Message-State: APjAAAUeRl7TYp2sjQv+6ddyLTVNUNTjIn1PabRurvM2yuvuOBgfrGYZ
        6INQSEhhGhdNfrwKrfYNwDm/rDRoM0p+/y5NitbHvTWe
X-Google-Smtp-Source: APXvYqzkjV6xW+S1V9TXzZvhH4WA2LcdgCsrocnV6Pj9lJZx7O9H9SOdD8aNwDehi+S21H1lAdyHTNZ/n0LVDgzZGO8=
X-Received: by 2002:a9d:7601:: with SMTP id k1mr5339977otl.254.1560241082148;
 Tue, 11 Jun 2019 01:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
 <1559799086-13912-3-git-send-email-wanpengli@tencent.com> <20190610165127.GA8389@flask>
In-Reply-To: <20190610165127.GA8389@flask>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Jun 2019 16:18:47 +0800
Message-ID: <CANRm+Cy4wBMZLVEHY3v+eAe859a8yR+cJ3ZFDor0nWZdufC0Zg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: LAPIC: lapic timer interrupt is injected by
 posted interrupt
To:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 at 00:51, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.c=
om> wrote:
>
> 2019-06-06 13:31+0800, Wanpeng Li:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Dedicated instances are currently disturbed by unnecessary jitter due
> > to the emulated lapic timers fire on the same pCPUs which vCPUs residen=
t.
> > There is no hardware virtual timer on Intel for guest like ARM. Both
> > programming timer in guest and the emulated timer fires incur vmexits.
> > This patch tries to avoid vmexit which is incurred by the emulated
> > timer fires in dedicated instance scenario.
> >
> > When nohz_full is enabled in dedicated instances scenario, the emulated
> > timers can be offload to the nearest busy housekeeping cpus since APICv
> > is really common in recent years. The guest timer interrupt is injected
> > by posted-interrupt which is delivered by housekeeping cpu once the emu=
lated
> > timer fires.
> >
> > 3%~5% redis performance benefit can be observed on Skylake server.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 32 +++++++++++++++++++++++++-------
> >  arch/x86/kvm/x86.h   |  5 +++++
> >  2 files changed, 30 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 09b7387..c08e5a8 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -133,6 +133,12 @@ static inline bool posted_interrupt_inject_timer_e=
nabled(struct kvm_vcpu *vcpu)
> >               kvm_mwait_in_guest(vcpu->kvm);
> >  }
> >
> > +static inline bool can_posted_interrupt_inject_timer(struct kvm_vcpu *=
vcpu)
> > +{
> > +     return posted_interrupt_inject_timer_enabled(vcpu) &&
> > +             !vcpu_halt_in_guest(vcpu);
>
> It would make more sense to have a condition for general blocking in
> KVM, but keep in mind that we're not running on the same cpu anymore, so
> any code like that has to be properly protected against VM entries under
> our hands.  (The VCPU could appear halted here, but before we get make
> the timer pending, the VCPU would enter and potentially never check the
> interrupt.)
>
> I think we should be able to simply do
>
>   if (posted_interrupt_inject_timer_enabled(vcpu))
>         kvm_inject_apic_timer_irqs();
>
> directly in the apic_timer_expired() as the injection will wake up the
> target if necessary.  It's going to be a bit slow for timer callback in
> those (too slow to warrant special handling?), but there hopefully
> aren't any context restrictions in place.

The vCPU halt status is used to handle non-PV apf notification aware
guest which is pointed out by Paolo.
https://lkml.org/lkml/2019/6/5/436 The vCPU will not re-vmentry w/
timer interrupt even if there is a kick since vcpu->arch.apf.halted is
true and it can't escape from kvm_vcpu_check_block().

Regards,
Wanpeng Li
