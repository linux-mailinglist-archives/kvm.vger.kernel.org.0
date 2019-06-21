Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBB24DEBB
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 03:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfFUBl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 21:41:28 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46280 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfFUBl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 21:41:27 -0400
Received: by mail-ot1-f67.google.com with SMTP id z23so4688915ote.13;
        Thu, 20 Jun 2019 18:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5K99qU465Y/n1tzLPu9YxwdgC2mSpe51ZhWRmC2pnwU=;
        b=AYwGRLvpyHTyDwk5RUElurCTbQV5qtO9iO1tbPbw6cEWRiofvEQ7QuT/WxmI9SXcg8
         PfkrzmiqwtTtreLYNSg4hmjtXwVZJQgjAOHZVdr5lZ2hGTSZd4hx98eRQQErSBtO8CEo
         b+SDQaN4l6OvDVq7u1H9arQcgb8287eYIP5VmWXJqkpo52/x0zpNBGM4nWRkoxbJbzAv
         +JFX5Gv5y6kJrwzPTl4j/COxk4GtABFanM5XYU8KCDw9Iysls++BvyZkgNmgJPkcfx+q
         rDYhF+fexvoCJ7ssv+02EMWrSS3owS9SAFlUnIl3ux/zuZZ39prHaqUMw7ND9gpqdk+L
         MCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5K99qU465Y/n1tzLPu9YxwdgC2mSpe51ZhWRmC2pnwU=;
        b=HZGXF4c9sreM+DhkxgL8O4LyivEUlWEE0FFYDg/G3tnbZazmuCJT+laQe9d8j3SXXZ
         Q7vp+VgSVwz7QrMPLOEl7bgxl6xV7ZgfhvvYHmepNDQ2wVoIcMdkzeRvPHaleoC1pMju
         29PLM7qgnyaeHaYYLeEaaEYpXRYJbBUWVAYrVE8zQcwr2dR30fwgy5tLRLFaEh7Ry7ZF
         jwXre//6WWjQD2y5IajiGKPGt1crypYaaYfIf8BOiOhZ0O1r63S6GxpO5ii7G0LQu/Gm
         R2XrpyBJHe/NClhWmlM3SPbjeiNBFro6VSmmRwY7TdHl7LzUM/KO/7gctYYF2YNDDdaZ
         RvBw==
X-Gm-Message-State: APjAAAWur0s2WWCpSDsMs4NjSk0TVbcEmuvRdzar0BTA9KjpETCDwrZr
        ODqHi/8Ro0l7SBU/n041vUNqqabEaj/jn76H02Q=
X-Google-Smtp-Source: APXvYqwNyZyAKX6IT31Y1GxMTo6SUdAmyZewWriWRLYIAR4AtWJVG3Aup0uectw1fN8YKxZgIsshrr+N5jyD+xzFeHM=
X-Received: by 2002:a9d:2c47:: with SMTP id f65mr78355040otb.185.1561081286628;
 Thu, 20 Jun 2019 18:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com> <20190618133541.GA3932@amt.cnet>
 <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com> <20190619210346.GA13033@amt.cnet>
In-Reply-To: <20190619210346.GA13033@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 21 Jun 2019 09:42:39 +0800
Message-ID: <CANRm+Cwxz7rR3o2m1HKg0-0z30B8-O-i4RrVC6EMG1jgBRxWPg@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] KVM: LAPIC: inject lapic timer interrupt by posted interrupt
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Jun 2019 at 05:04, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> Hi Li,
>
> On Wed, Jun 19, 2019 at 08:36:06AM +0800, Wanpeng Li wrote:
> > On Tue, 18 Jun 2019 at 21:36, Marcelo Tosatti <mtosatti@redhat.com> wro=
te:
> > >
> > > On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrote:
> > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > >
> > > > Dedicated instances are currently disturbed by unnecessary jitter d=
ue
> > > > to the emulated lapic timers fire on the same pCPUs which vCPUs res=
ident.
> > > > There is no hardware virtual timer on Intel for guest like ARM. Bot=
h
> > > > programming timer in guest and the emulated timer fires incur vmexi=
ts.
> > > > This patch tries to avoid vmexit which is incurred by the emulated
> > > > timer fires in dedicated instance scenario.
> > > >
> > > > When nohz_full is enabled in dedicated instances scenario, the emul=
ated
> > > > timers can be offload to the nearest busy housekeeping cpus since A=
PICv
> > > > is really common in recent years. The guest timer interrupt is inje=
cted
> > > > by posted-interrupt which is delivered by housekeeping cpu once the=
 emulated
> > > > timer fires.
> > > >
> > > > The host admin should fine tuned, e.g. dedicated instances scenario=
 w/
> > > > nohz_full cover the pCPUs which vCPUs resident, several pCPUs surpl=
us
> > > > for busy housekeeping, disable mwait/hlt/pause vmexits to keep in n=
on-root
> > > > mode, ~3% redis performance benefit can be observed on Skylake serv=
er.
> > > >
> > > > w/o patch:
> > > >
> > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time =
  Avg time
> > > >
> > > > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us =
  0.71us ( +-   1.09% )
> > > >
> > > > w/ patch:
> > > >
> > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time =
        Avg time
> > > >
> > > > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us =
  0.72us ( +-   4.02% )
> > > >
> > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > ---
> > > >  arch/x86/kvm/lapic.c            | 33 ++++++++++++++++++++++++++---=
----
> > > >  arch/x86/kvm/lapic.h            |  1 +
> > > >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> > > >  arch/x86/kvm/x86.c              |  5 +++++
> > > >  arch/x86/kvm/x86.h              |  2 ++
> > > >  include/linux/sched/isolation.h |  2 ++
> > > >  kernel/sched/isolation.c        |  6 ++++++
> > > >  7 files changed, 44 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 87ecb56..9ceeee5 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lap=
ic *apic)
> > > >       return apic->vcpu->vcpu_id;
> > > >  }
> > > >
> > > > +bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > > +             kvm_hlt_in_guest(vcpu->kvm);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
> > >
> > > Paolo, can you explain the reasoning behind this?
> > >
> > > Should not be necessary...

https://lkml.org/lkml/2019/6/5/436  "Here you need to check
kvm_halt_in_guest, not kvm_mwait_in_guest, because you need to go
through kvm_apic_expired if the guest needs to be woken up from
kvm_vcpu_block."

I think we can still be woken up from kvm_vcpu_block() if pir is set.

Regards,
Wanpeng Li
