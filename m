Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7916956755
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 13:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFZLCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 07:02:25 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45951 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfFZLCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 07:02:25 -0400
Received: by mail-ot1-f67.google.com with SMTP id x21so2027668otq.12;
        Wed, 26 Jun 2019 04:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BB3lIdtv3p+4asBNcb/GBEJsie+rkex27L+0WBCJpnc=;
        b=fe+9zxnJB/7Ni8/FnRJH2vJw2oxrcvr+SL4uvEWPq8AxxkZV+ZwL+1Z9qoGStnuE5S
         aDbmUqEexlRcuS1okFZIJByFdN4duohkATVPLVZxTi3wgfXfyBFQ8euWps77Nl6q5I9O
         DHXkRQNIW6wVoaXKtf89E/cTQuzWGjgKe+Fw0/XFg57SK9H6U78mKsYnea5qI77qOWYl
         +wsmABrEcOR0sWZ8wAKDRjaTU0G0uiFKtgGC3yfJHCInjYsVsWv840+o2rqXZZIjmO2V
         Luqa6qv34CvtNhmyjKFkhoK9Uz5n0yGTY+lGxm8JIc6RlFjPc7Jt/iPBlasmFvWg6SsH
         eqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BB3lIdtv3p+4asBNcb/GBEJsie+rkex27L+0WBCJpnc=;
        b=WYFXDQ2pvlCXavb1L5FSJjNKTKrALOvk8dKFBDdGizVzXuM9Rhhyi8jN3qmomw02yF
         iZEFeXY26gtU2CEMPDHw6t0emckyxNBvox87HBG4MCeQAlh/ihB6qGB5Vd7NBhRsI+o7
         st6rZciDGDfPBQDx+3RXhlCKCOgDhO2UFpf0Q7owzdinTrxUOUnb8Om4vFfnddIPqQXq
         IZyJVMaIwsS4eC0FWx5TjqfXYvc+rdvXh/4tyT1HocSyAHIPyztYvpzfaKO5TMbW4uHb
         Yf+PlR6MZZUsvqn9ACO5sEXqHybVM9uFXMkxjPEFE9P7tsxLr1cWbaQ/n+Krq5uDGO5z
         YDNg==
X-Gm-Message-State: APjAAAWRJJeyeCdgsm5+PwjMnxhrTITqTHLYDTemJHC7yhTwmJACw6jY
        X3Jcz8w7pOK57Euk6S6Fd8ovzYQKjZJ8uukKu3M=
X-Google-Smtp-Source: APXvYqx6TZJovv/TqMVaVuUfpmHFJFT111eFYwesBK2n88t+VWleIJgnz09Yp5kfS3MiK2CsLmZgQeOPWqPqgPaJQ5o=
X-Received: by 2002:a9d:6312:: with SMTP id q18mr2623861otk.45.1561546944381;
 Wed, 26 Jun 2019 04:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com> <20190618133541.GA3932@amt.cnet>
 <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com>
 <20190619210346.GA13033@amt.cnet> <CANRm+Cwxz7rR3o2m1HKg0-0z30B8-O-i4RrVC6EMG1jgBRxWPg@mail.gmail.com>
 <20190621214205.GA4751@amt.cnet> <CANRm+CxUgkF7zRmHC_MD2s00waj6qztWdPAm_u9Rhk34_bevfQ@mail.gmail.com>
 <20190625190010.GA3377@amt.cnet>
In-Reply-To: <20190625190010.GA3377@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 26 Jun 2019 19:02:13 +0800
Message-ID: <CANRm+CzmraRUNQfTWNZ3Bu5dJhjvL1eE9+=c2i_vwtYYT9ao2w@mail.gmail.com>
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

On Wed, 26 Jun 2019 at 03:03, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Mon, Jun 24, 2019 at 04:53:53PM +0800, Wanpeng Li wrote:
> > On Sat, 22 Jun 2019 at 06:11, Marcelo Tosatti <mtosatti@redhat.com> wro=
te:
> > >
> > > On Fri, Jun 21, 2019 at 09:42:39AM +0800, Wanpeng Li wrote:
> > > > On Thu, 20 Jun 2019 at 05:04, Marcelo Tosatti <mtosatti@redhat.com>=
 wrote:
> > > > >
> > > > > Hi Li,
> > > > >
> > > > > On Wed, Jun 19, 2019 at 08:36:06AM +0800, Wanpeng Li wrote:
> > > > > > On Tue, 18 Jun 2019 at 21:36, Marcelo Tosatti <mtosatti@redhat.=
com> wrote:
> > > > > > >
> > > > > > > On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrote:
> > > > > > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > >
> > > > > > > > Dedicated instances are currently disturbed by unnecessary =
jitter due
> > > > > > > > to the emulated lapic timers fire on the same pCPUs which v=
CPUs resident.
> > > > > > > > There is no hardware virtual timer on Intel for guest like =
ARM. Both
> > > > > > > > programming timer in guest and the emulated timer fires inc=
ur vmexits.
> > > > > > > > This patch tries to avoid vmexit which is incurred by the e=
mulated
> > > > > > > > timer fires in dedicated instance scenario.
> > > > > > > >
> > > > > > > > When nohz_full is enabled in dedicated instances scenario, =
the emulated
> > > > > > > > timers can be offload to the nearest busy housekeeping cpus=
 since APICv
> > > > > > > > is really common in recent years. The guest timer interrupt=
 is injected
> > > > > > > > by posted-interrupt which is delivered by housekeeping cpu =
once the emulated
> > > > > > > > timer fires.
> > > > > > > >
> > > > > > > > The host admin should fine tuned, e.g. dedicated instances =
scenario w/
> > > > > > > > nohz_full cover the pCPUs which vCPUs resident, several pCP=
Us surplus
> > > > > > > > for busy housekeeping, disable mwait/hlt/pause vmexits to k=
eep in non-root
> > > > > > > > mode, ~3% redis performance benefit can be observed on Skyl=
ake server.
> > > > > > > >
> > > > > > > > w/o patch:
> > > > > > > >
> > > > > > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  M=
ax Time   Avg time
> > > > > > > >
> > > > > > > > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   1=
06.09us   0.71us ( +-   1.09% )
> > > > > > > >
> > > > > > > > w/ patch:
> > > > > > > >
> > > > > > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  M=
ax Time         Avg time
> > > > > > > >
> > > > > > > > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    =
57.88us   0.72us ( +-   4.02% )
> > > > > > > >
> > > > > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > > > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > > > > > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > > > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > > ---
> > > > > > > >  arch/x86/kvm/lapic.c            | 33 +++++++++++++++++++++=
+++++-------
> > > > > > > >  arch/x86/kvm/lapic.h            |  1 +
> > > > > > > >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> > > > > > > >  arch/x86/kvm/x86.c              |  5 +++++
> > > > > > > >  arch/x86/kvm/x86.h              |  2 ++
> > > > > > > >  include/linux/sched/isolation.h |  2 ++
> > > > > > > >  kernel/sched/isolation.c        |  6 ++++++
> > > > > > > >  7 files changed, 44 insertions(+), 8 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > > > > > index 87ecb56..9ceeee5 100644
> > > > > > > > --- a/arch/x86/kvm/lapic.c
> > > > > > > > +++ b/arch/x86/kvm/lapic.c
> > > > > > > > @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct=
 kvm_lapic *apic)
> > > > > > > >       return apic->vcpu->vcpu_id;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > > > > > > > +{
> > > > > > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu)=
 &&
> > > > > > > > +             kvm_hlt_in_guest(vcpu->kvm);
> > > > > > > > +}
> > > > > > > > +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
> > > > > > >
> > > > > > > Paolo, can you explain the reasoning behind this?
> > > > > > >
> > > > > > > Should not be necessary...
> > > >
> > > > https://lkml.org/lkml/2019/6/5/436  "Here you need to check
> > > > kvm_halt_in_guest, not kvm_mwait_in_guest, because you need to go
> > > > through kvm_apic_expired if the guest needs to be woken up from
> > > > kvm_vcpu_block."
> > >
> > > Ah, i think he means that a sleeping vcpu (in kvm_vcpu_block) must
> > > be woken up, if it receives a timer interrupt.
> > >
> > > But your patch will go through:
> > >
> > > kvm_apic_inject_pending_timer_irqs
> > > __apic_accept_irq ->
> > > vmx_deliver_posted_interrupt ->
> > > kvm_vcpu_trigger_posted_interrupt returns false
> > > (because vcpu->mode !=3D IN_GUEST_MODE) ->
> > > kvm_vcpu_kick
> > >
> > > Which will wakeup the vcpu.
> >
> > Hi Marcelo,
> >
> > >
> > > Apart from this oops, which triggers when running:
> > > taskset -c 1 ./cyclictest -D 3600 -p 99 -t 1 -h 30 -m -n  -i 50000 -b=
 40
> >
> > I try both host and guest use latest kvm/queue  w/ CONFIG_PREEMPT
> > enabled, and expose mwait as your config, however, there is no oops.
> > Can you reproduce steadily or encounter casually? Can you reproduce
> > w/o the patchset?
>
> Hi Li,

Hi Marcelo,

>
> Steadily.
>
> Do you have this as well:

w/ or w/o below diff, testing on both SKX and HSW servers on hand, I
didn't see any oops. Could you observe the oops disappear when w/o
below diff? If the answer is yes, then the oops will not block to
merge the patchset since Paolo prefers to add the kvm_hlt_in_guest()
condition to guarantee be woken up from kvm_vcpu_block(). For the
exitless injection if the guest is running(DPDK style workloads that
busy-spin on network card) scenarios, we can find a solution later.

Regards,
Wanpeng Li

>
> Index: kvm/arch/x86/kvm/lapic.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- kvm.orig/arch/x86/kvm/lapic.c
> +++ kvm/arch/x86/kvm/lapic.c
> @@ -129,8 +129,7 @@ static inline u32 kvm_x2apic_id(struct k
>
>  bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
>  {
> -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> -               kvm_hlt_in_guest(vcpu->kvm);
> +       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
