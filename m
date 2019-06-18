Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A164149678
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 02:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFRA4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 20:56:40 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38277 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRA4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 20:56:40 -0400
Received: by mail-ot1-f65.google.com with SMTP id d17so11836051oth.5;
        Mon, 17 Jun 2019 17:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LAof2iPuEsmEYY4js8fXji44icMGLEIkpZjnqdzAtFI=;
        b=NAIs7vmQcsIIa8lS+vTvC5bC1yt5vtdlN596xVfEf8KBK7ly+kPIH49W5sZweA/Ar5
         PA4/gqSU3x5eUZ0EtsBshtI91HVoJKNqtK6Ou+yQB7Gjsm7MZm4cqPjgpzW7RlbVFSN6
         YhnqPmRSGWE8NntPKcZ7CCpEftrq4oNhfZgDPcSVKNyBk4zxI+veE9QHenHLTUzhnipp
         bbtUbg36mT3JQA7Wl9g2HSRNGKbn+tMG/JW+aNYQ79yVEzzhX2bpOcGEBtQz8/JiIjHC
         CDmw6qkhEzYvCzD5tjXQocYSqYRGCH72DeLaqI2NIS2py8OQegBrJOaMTbMUjTyAVbey
         K1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LAof2iPuEsmEYY4js8fXji44icMGLEIkpZjnqdzAtFI=;
        b=KNPyi8GGgDO7fT4XB7t0G9psPPDhBDiCMwmMSNSzMbdLq567rkhbaj0aoU/Zxb1PId
         ee4RY2CVUCNNCVM2QklmTbLdxXzgbkkUnArQl6ylQt1Hg+OJu4ZqbVjmdTX2TGLJ+njz
         +L7S+GkB0/7rMMZz7HLr2tCsWXZnhVAJXlI5TWDi8xfBcMqghLEYZujFUFtdfc0q/U5z
         53U+gmjllhFNVSCgjUKojeMcXBR3ZzXl+ODJWcP1Ww/XqM75iLzrbUFTBWgFPmsjC4Wd
         am9kYMq644kTmJzCNXIQ24jaE3/BhCJ3MmNQgX4nVf3A92EuuurMHNI2eIxpxEVjLDkv
         CZuA==
X-Gm-Message-State: APjAAAVuUbMkdq+LRIWD0kazYKj15BbtxUYwqGGNqkdfaGWl/lRCXkNn
        xYpUNdy6QGqWYDfQZui4Zp03jnxxrkPuLuUxBpy78HfS
X-Google-Smtp-Source: APXvYqxStP/pRcAOqf4HKAwAeLrfDpYbv22OnkQz8YMUT/lESO9FbeQpHSXEliXQuDp75dLIJfSM1BhMkWzVmdHmgDU=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr45374362otk.56.1560819399619;
 Mon, 17 Jun 2019 17:56:39 -0700 (PDT)
MIME-Version: 1.0
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-6-git-send-email-wanpengli@tencent.com> <20190617213201.GA26346@flask>
 <CANRm+Cxrn51mJUvjH7df+U-HpPPLJJzsRf+BMebxDogSabex3g@mail.gmail.com>
In-Reply-To: <CANRm+Cxrn51mJUvjH7df+U-HpPPLJJzsRf+BMebxDogSabex3g@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 18 Jun 2019 08:57:15 +0800
Message-ID: <CANRm+CwBY3xku7uE5fHRNBoHEctc1k-AS0DSny8jKKDsOUZs=g@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] KVM: LAPIC: add advance timer support to pi_inject_timer
To:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019 at 08:44, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Tue, 18 Jun 2019 at 05:32, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat=
.com> wrote:
> >
> > 2019-06-17 19:24+0800, Wanpeng Li:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Wait before calling posted-interrupt deliver function directly to add
> > > advance timer support to pi_inject_timer.
> > >
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> >
> > Please merge this patch with [2/5], so bisection doesn't break.
>
> Agreed.
>
> >
> > >  arch/x86/kvm/lapic.c   | 6 ++++--
> > >  arch/x86/kvm/lapic.h   | 2 +-
> > >  arch/x86/kvm/svm.c     | 2 +-
> > >  arch/x86/kvm/vmx/vmx.c | 2 +-
> > >  4 files changed, 7 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 1a31389..1a31ba5 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -1462,6 +1462,8 @@ static void apic_timer_expired(struct kvm_lapic=
 *apic, bool can_pi_inject)
> > >               return;
> > >
> > >       if (can_pi_inject && posted_interrupt_inject_timer(apic->vcpu))=
 {
> > > +             if (apic->lapic_timer.timer_advance_ns)
> > > +                     kvm_wait_lapic_expire(vcpu, true);
> >
> > From where does kvm_wait_lapic_expire() take
> > apic->lapic_timer.expired_tscdeadline?
>
> Sorry, I failed to understand this.
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/lapic.c=
?h=3Dqueue#n1541
> We can get apic->lapic_timer.expired_tscdeadline in
> kvm_wait_lapic_expire() directly.

Oh, miss the latest expired_tscdeadline, how about something like below?

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1a31ba5..7cd95ea 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1461,6 +1461,9 @@ static void apic_timer_expired(struct kvm_lapic
*apic, bool can_pi_inject)
     if (atomic_read(&apic->lapic_timer.pending))
         return;

+    if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
+        ktimer->expired_tscdeadline =3D ktimer->tscdeadline;
+
     if (can_pi_inject && posted_interrupt_inject_timer(apic->vcpu)) {
         if (apic->lapic_timer.timer_advance_ns)
             kvm_wait_lapic_expire(vcpu, true);
@@ -1477,9 +1480,6 @@ static void apic_timer_expired(struct kvm_lapic
*apic, bool can_pi_inject)
      */
     if (swait_active(q))
         swake_up_one(q);
-
-    if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
-        ktimer->expired_tscdeadline =3D ktimer->tscdeadline;
 }

 /*
