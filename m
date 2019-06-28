Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D7D5960C
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 10:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfF1I0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 04:26:33 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41617 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfF1I0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 04:26:33 -0400
Received: by mail-ot1-f67.google.com with SMTP id o101so4858887ota.8;
        Fri, 28 Jun 2019 01:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yv6CgnWPC6xWm8QD/szBDMm8993i38/ihT9u27h0IHg=;
        b=H/GoLEaonyeEZGb/WdSNNwT0RKBkwJ+epaDaWfsOguW1ydhvWbSbwKtl33NMN9i2m8
         4YgucQRpRpAj11NGAPXL1N6Upj0r4fa4YR6t0s5wOFoljLN+EmakXd1tfahz1hCskGtv
         d7xiJM8RVgBagmJlykCsk+u67mBH37AiwXILVK83OKJGYlFGuyQ+1DkSGU/2cGs9S5FK
         KxxmtUL5bRKoGEoaz8tSikz12ZSqU84znM7sD62zx2lL3V+VqRCP232O1crpiURARA9r
         l1BuLi3QAgDiuXPbyUpZcCqFVO/FhwNpXYyD1DSxHzknKJSGlebq6X4RuPzP0nzmNkDZ
         04Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yv6CgnWPC6xWm8QD/szBDMm8993i38/ihT9u27h0IHg=;
        b=TWj+2af4txb6fz1QktR4XaQE11ffW9bVY0n5kdV12hXjyaBwSZATPGeChqHeajAvea
         Pe/O9hpbe0di7WWLwqS1UHcEIeFt/kPrcW89xkekAWm7mSWgZ32Ze53cKnAxHedmzFqQ
         VjlEl+QsaSgyulErDqKmQLomCvVHF78wSVYNwkmgOXiwUDAkkTqFYF8ud5nXjNrXm5V3
         wP5BmNVKL3AW+EcTcj++rD+2roKghjEOFONvT9mDJnnIlm4S4cHP7fTRttyd9+r7exmM
         2fri1uDrpo4qJdWRJG7K9LzL3vnlusjLkoX3R0Q8eCHvKSBObrxQD+YLcSi6GmekouyD
         xPag==
X-Gm-Message-State: APjAAAUO9RXaXr+wjUkMFeGSGcihYBeqUbFsaKKiDYnXo4PRcUQ5dc0g
        M05deLYsskoTq2f3V0vovxFS9S81OMplydWeiHisKsU7q2I=
X-Google-Smtp-Source: APXvYqz/O75u9syzUZvnyk6BcL7Q+bOdMy3y6p5OqPd/UERUb8K0K03+LcpR7BORZfLKctoLiq90hrg13YbDW4N5BoM=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr6806096otk.56.1561710392254;
 Fri, 28 Jun 2019 01:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com> <20190618133541.GA3932@amt.cnet>
 <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com>
 <20190619210346.GA13033@amt.cnet> <CANRm+Cwxz7rR3o2m1HKg0-0z30B8-O-i4RrVC6EMG1jgBRxWPg@mail.gmail.com>
 <20190621214205.GA4751@amt.cnet> <CANRm+CxUgkF7zRmHC_MD2s00waj6qztWdPAm_u9Rhk34_bevfQ@mail.gmail.com>
 <20190625190010.GA3377@amt.cnet> <CANRm+CzmraRUNQfTWNZ3Bu5dJhjvL1eE9+=c2i_vwtYYT9ao2w@mail.gmail.com>
 <20190626164401.GA2211@amt.cnet>
In-Reply-To: <20190626164401.GA2211@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 28 Jun 2019 16:26:20 +0800
Message-ID: <CANRm+Cy0FFqoUuFsLGxGFN04wYaX_1y2t--EXacdwj7Q3wbOLQ@mail.gmail.com>
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

On Thu, 27 Jun 2019 at 00:44, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Wed, Jun 26, 2019 at 07:02:13PM +0800, Wanpeng Li wrote:
> > On Wed, 26 Jun 2019 at 03:03, Marcelo Tosatti <mtosatti@redhat.com> wro=
te:
> > >
> > > On Mon, Jun 24, 2019 at 04:53:53PM +0800, Wanpeng Li wrote:
> > > > On Sat, 22 Jun 2019 at 06:11, Marcelo Tosatti <mtosatti@redhat.com>=
 wrote:
> > > > >
> > > > > On Fri, Jun 21, 2019 at 09:42:39AM +0800, Wanpeng Li wrote:
> > > > > > On Thu, 20 Jun 2019 at 05:04, Marcelo Tosatti <mtosatti@redhat.=
com> wrote:
> > > > > > >
> > > > > > > Hi Li,
> > > > > > >
> > > > > > > On Wed, Jun 19, 2019 at 08:36:06AM +0800, Wanpeng Li wrote:
> > > > > > > > On Tue, 18 Jun 2019 at 21:36, Marcelo Tosatti <mtosatti@red=
hat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrot=
e:
> > > > > > > > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > > > >
> > > > > > > > > > Dedicated instances are currently disturbed by unnecess=
ary jitter due
> > > > > > > > > > to the emulated lapic timers fire on the same pCPUs whi=
ch vCPUs resident.
> > > > > > > > > > There is no hardware virtual timer on Intel for guest l=
ike ARM. Both
> > > > > > > > > > programming timer in guest and the emulated timer fires=
 incur vmexits.
> > > > > > > > > > This patch tries to avoid vmexit which is incurred by t=
he emulated
> > > > > > > > > > timer fires in dedicated instance scenario.
> > > > > > > > > >
> > > > > > > > > > When nohz_full is enabled in dedicated instances scenar=
io, the emulated
> > > > > > > > > > timers can be offload to the nearest busy housekeeping =
cpus since APICv
> > > > > > > > > > is really common in recent years. The guest timer inter=
rupt is injected
> > > > > > > > > > by posted-interrupt which is delivered by housekeeping =
cpu once the emulated
> > > > > > > > > > timer fires.
> > > > > > > > > >
> > > > > > > > > > The host admin should fine tuned, e.g. dedicated instan=
ces scenario w/
> > > > > > > > > > nohz_full cover the pCPUs which vCPUs resident, several=
 pCPUs surplus
> > > > > > > > > > for busy housekeeping, disable mwait/hlt/pause vmexits =
to keep in non-root
> > > > > > > > > > mode, ~3% redis performance benefit can be observed on =
Skylake server.
> > > > > > > > > >
> > > > > > > > > > w/o patch:
> > > > > > > > > >
> > > > > > > > > >             VM-EXIT  Samples  Samples%  Time%   Min Tim=
e  Max Time   Avg time
> > > > > > > > > >
> > > > > > > > > > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us=
   106.09us   0.71us ( +-   1.09% )
> > > > > > > > > >
> > > > > > > > > > w/ patch:
> > > > > > > > > >
> > > > > > > > > >             VM-EXIT  Samples  Samples%  Time%   Min Tim=
e  Max Time         Avg time
> > > > > > > > > >
> > > > > > > > > > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us=
    57.88us   0.72us ( +-   4.02% )
> > > > > > > > > >
> > > > > > > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > > > > > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > > > > > > > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > > > > > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > > > > ---
> > > > > > > > > >  arch/x86/kvm/lapic.c            | 33 +++++++++++++++++=
+++++++++-------
> > > > > > > > > >  arch/x86/kvm/lapic.h            |  1 +
> > > > > > > > > >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> > > > > > > > > >  arch/x86/kvm/x86.c              |  5 +++++
> > > > > > > > > >  arch/x86/kvm/x86.h              |  2 ++
> > > > > > > > > >  include/linux/sched/isolation.h |  2 ++
> > > > > > > > > >  kernel/sched/isolation.c        |  6 ++++++
> > > > > > > > > >  7 files changed, 44 insertions(+), 8 deletions(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.=
c
> > > > > > > > > > index 87ecb56..9ceeee5 100644
> > > > > > > > > > --- a/arch/x86/kvm/lapic.c
> > > > > > > > > > +++ b/arch/x86/kvm/lapic.c
> > > > > > > > > > @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(st=
ruct kvm_lapic *apic)
> > > > > > > > > >       return apic->vcpu->vcpu_id;
> > > > > > > > > >  }
> > > > > > > > > >
> > > > > > > > > > +bool posted_interrupt_inject_timer(struct kvm_vcpu *vc=
pu)
> > > > > > > > > > +{
> > > > > > > > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(v=
cpu) &&
> > > > > > > > > > +             kvm_hlt_in_guest(vcpu->kvm);
> > > > > > > > > > +}
> > > > > > > > > > +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
> > > > > > > > >
> > > > > > > > > Paolo, can you explain the reasoning behind this?
> > > > > > > > >
> > > > > > > > > Should not be necessary...
> > > > > >
> > > > > > https://lkml.org/lkml/2019/6/5/436  "Here you need to check
> > > > > > kvm_halt_in_guest, not kvm_mwait_in_guest, because you need to =
go
> > > > > > through kvm_apic_expired if the guest needs to be woken up from
> > > > > > kvm_vcpu_block."
> > > > >
> > > > > Ah, i think he means that a sleeping vcpu (in kvm_vcpu_block) mus=
t
> > > > > be woken up, if it receives a timer interrupt.
> > > > >
> > > > > But your patch will go through:
> > > > >
> > > > > kvm_apic_inject_pending_timer_irqs
> > > > > __apic_accept_irq ->
> > > > > vmx_deliver_posted_interrupt ->
> > > > > kvm_vcpu_trigger_posted_interrupt returns false
> > > > > (because vcpu->mode !=3D IN_GUEST_MODE) ->
> > > > > kvm_vcpu_kick
> > > > >
> > > > > Which will wakeup the vcpu.
> > > >
> > > > Hi Marcelo,
> > > >
> > > > >
> > > > > Apart from this oops, which triggers when running:
> > > > > taskset -c 1 ./cyclictest -D 3600 -p 99 -t 1 -h 30 -m -n  -i 5000=
0 -b 40
> > > >
> > > > I try both host and guest use latest kvm/queue  w/ CONFIG_PREEMPT
> > > > enabled, and expose mwait as your config, however, there is no oops=
.
> > > > Can you reproduce steadily or encounter casually? Can you reproduce
> > > > w/o the patchset?
> > >
> > > Hi Li,
> >
> > Hi Marcelo,
> >
> > >
> > > Steadily.
> > >
> > > Do you have this as well:
> >
> > w/ or w/o below diff, testing on both SKX and HSW servers on hand, I
> > didn't see any oops. Could you observe the oops disappear when w/o
> > below diff? If the answer is yes, then the oops will not block to
> > merge the patchset since Paolo prefers to add the kvm_hlt_in_guest()
> > condition to guarantee be woken up from kvm_vcpu_block().
>
> He agreed that its not necessary. Removing the HLT in guest widens
> the scope of the patch greatly.
>
> > For the
> > exitless injection if the guest is running(DPDK style workloads that
> > busy-spin on network card) scenarios, we can find a solution later.
>
> What is the use-case for HLT in guest again?

Together w/ mwait/hlt/pause no vmexits for dedicated instances. In
addition, hlt in guest will disable pv qspinlock which is not optimal
for dedicated instance. Refer to commit
b2798ba0b876 (KVM: X86: Choose qspinlock when dedicated physical CPUs
are available) and commit caa057a2cad64 (KVM: X86: Provide a
capability to disable HLT intercepts).

>
> I'll find the source for the oops (or confirm can't reproduce with
> kvm/queue RSN).

Looking forward to it, thanks Marcelo, hope we can catch the upcoming
merge window. :)

Regards,
Wanpeng Li
