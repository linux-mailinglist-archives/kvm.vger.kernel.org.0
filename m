Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3361641A0A
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 03:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbfFLBsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 21:48:16 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41466 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfFLBsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 21:48:16 -0400
Received: by mail-oi1-f195.google.com with SMTP id g7so7296370oia.8;
        Tue, 11 Jun 2019 18:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dm76JZldFkWEgkVO1SScer1LyP51y0/fkMGkyI4B5po=;
        b=jqOtu9b9g/g4PCAlxBumBB8oZSTNGeigc03WPBDH0+euBKHEh9LwKL+aKT7vI4blsi
         VECTaKvJ279kOlWcowd8LHyBRW6p2+yj/I6p+/4Dc2SQKFbwjv5Ihbbe4D0J2E/jAGla
         khBDvdpHU5bFJg8GrC3+SGLypXs3NTxL0Brb6FiqVajiNbf/4LvisZj7dfeCDy7dgIK3
         KA0hxTtA3bTuAva51ncqrDyPtdEA7u8E/QUNBYKEdFDqWSqmu9oLkigYG8FRQyngemem
         1jRaRIPm7zO7GUifkeWIlsMNVqTNlHm7Ek25SonVTtYaRzzvh0wzYxH6mzsNWJ71jC25
         iirQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dm76JZldFkWEgkVO1SScer1LyP51y0/fkMGkyI4B5po=;
        b=nVTbP6/Zn4zF4NR/4oU08DaqwyZcJ9UewAs1P2+YumOeBEUWAI5D/XoHQaa29D+/7C
         dUJzTQheTlaGlDRAKhEB7ApyKXZ6JTsLhZEJiaN9y2jRlPS0rqS5xnBkR2VuGuHe3YLk
         sjd1FpOeXUUj6snziyYJ+g4HBCPRJDE1sSVW1IX/xAfarS1EQD0JaXBPLu9arE5SDcon
         mxRS6Zq5ygnKNjrZq/CiiSVhXfpZL2XesY44DD8RWQpyr/RWcGWbYMTPmvzWHQZpOf5L
         OtybAdu2zRxAVbUrg64UdF7S4Q1hnDOpxyj5bSRFh4e2ASKBcMZONGcPBpoFIHW6V8wb
         kXTQ==
X-Gm-Message-State: APjAAAWIXfyNbd7aEn86ihSjoTTl2v5HznIbRhgmaktUvSGYP0qxef6E
        pnFr+k3b6XHcqBHb/ZsplVqL96fBH3ZMbtGCTe/DJD9S
X-Google-Smtp-Source: APXvYqy5z3LMZU/0QZyJ7yBAYlqwpNzIZB9WFfgK0/75pyUsnLxMTAhTbz7QgExMpnh95v9Fw7cZH3ZK1JgYLfVg6rg=
X-Received: by 2002:aca:51ce:: with SMTP id f197mr17752443oib.33.1560304095162;
 Tue, 11 Jun 2019 18:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
 <1560255429-7105-3-git-send-email-wanpengli@tencent.com> <20190611201849.GA7520@amt.cnet>
In-Reply-To: <20190611201849.GA7520@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 12 Jun 2019 09:48:58 +0800
Message-ID: <CANRm+CwrbMQpQ1d_KMp-EBMd-pXFVePQ8GV4Y4X0oy8-zGZCBQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] KVM: LAPIC: lapic timer interrupt is injected by
 posted interrupt
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019 at 04:39, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Tue, Jun 11, 2019 at 08:17:07PM +0800, Wanpeng Li wrote:
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
> > ~3% redis performance benefit can be observed on Skylake server.
> >
> > w/o patch:
> >
> >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Av=
g time
> >
> > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.=
71us ( +-   1.09% )
> >
> > w/ patch:
> >
> >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time     =
    Avg time
> >
> > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.=
72us ( +-   4.02% )
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 32 +++++++++++++++++++++++++-------
> >  1 file changed, 25 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index e57eeba..020599f 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -133,6 +133,12 @@ inline bool posted_interrupt_inject_timer_enabled(=
struct kvm_vcpu *vcpu)
> >  }
> >  EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer_enabled);
> >
> > +static inline bool can_posted_interrupt_inject_timer(struct kvm_vcpu *=
vcpu)
> > +{
> > +     return posted_interrupt_inject_timer_enabled(vcpu) &&
> > +             kvm_hlt_in_guest(vcpu->kvm);
> > +}
>
> Hi Li,

Hi Marcelo,

>
> Don't think its necessary to depend on kvm_hlt_in_guest: Can also use
> exitless injection if the guest is running (think DPDK style workloads
> that busy-spin on network card).
>

There are some discussions here.

https://lkml.org/lkml/2019/6/11/424
https://lkml.org/lkml/2019/6/5/436

Regards,
Wanpeng Li
