Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FE1504F1
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 10:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfFXIyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 04:54:07 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36941 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfFXIyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 04:54:06 -0400
Received: by mail-oi1-f193.google.com with SMTP id t76so9202097oih.4;
        Mon, 24 Jun 2019 01:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V52MSPvHj58XWNWF/lx8FueRvOpPktrVCgVXMsv1ZfY=;
        b=Cy07rfej7m2r7xdhNhIjAcurx/BuLOjFrCIZjkl8NpafWjliGTyuoeWBC9FKVEBvna
         o3q4ib8z9Zt49wRm88ahBRsEqtbhozdKYHOPoXuwEjQmO3HjvWycGnDqKsdkpdrtrGYW
         TCdrp3ZYAGCuAsVsWHDU1iEy+NRIb6X61cWiQYeEuVXRyynZ7XJ/0OopJLGRnEpj9QcT
         1qrOSN+XhYuv4hy69oKocBT1VKoSR9NJcyUIclnf2c8XM+JrZrN56E7VKxhamWnK7MJN
         kuXMDsAcRktpBTDgW6KfX6iEJKBpBtEARQxEdWm3QyQa5f40vmctKwosmVdQAJtwyTgZ
         iJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V52MSPvHj58XWNWF/lx8FueRvOpPktrVCgVXMsv1ZfY=;
        b=p24tPTimV9mRL8S9s0U0Ykxh51mx87t6l4fSICxkrKZsIhrxDNfPXinabxLo8R1ET+
         nS/ih+VjkUkXKMRla4ZUVfc1x1/NvVceHTykT7slEBG+W9k1CCM7f62iTLHRUPFAD+fu
         3d/UXO6kpZ0bFyLzm89vT8KBTY/URzMOfshmxwuynM1a5k7a6DPHxYFr346TKQ8tAD6V
         nqJx5YDUb2G05VheGceEN+39FORVV0IJF5kZuhUStBkyw69znsBc5Z5HV87uCGCx7Oxo
         sY92nrNRBzzhj0YpkTIUzD6QLnTnJ0dulTAiq8QID6/VflB+yjAeUD3njPgSUJdYbGfD
         20tA==
X-Gm-Message-State: APjAAAUPV2vSOinpR8LoKQPKbbS39ya+NGJnn02bdhqNKoxzHiT5Ude+
        Ou1ZbVOkkwrtd/FYtzib08KG4eL3Gn8VatHVHLiLFA==
X-Google-Smtp-Source: APXvYqx0DAEftYzn3A4LrGe+jRiky1nawSDQr98J+TNY+CDV3EY0U9cZr6KFaWAKlPETVBgoGN0fwL6/e6DPaDn5/3c=
X-Received: by 2002:a05:6808:3:: with SMTP id u3mr9702787oic.141.1561366446032;
 Mon, 24 Jun 2019 01:54:06 -0700 (PDT)
MIME-Version: 1.0
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com> <20190618133541.GA3932@amt.cnet>
 <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com>
 <20190619210346.GA13033@amt.cnet> <CANRm+Cwxz7rR3o2m1HKg0-0z30B8-O-i4RrVC6EMG1jgBRxWPg@mail.gmail.com>
 <20190621214205.GA4751@amt.cnet>
In-Reply-To: <20190621214205.GA4751@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 24 Jun 2019 16:53:53 +0800
Message-ID: <CANRm+CxUgkF7zRmHC_MD2s00waj6qztWdPAm_u9Rhk34_bevfQ@mail.gmail.com>
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

On Sat, 22 Jun 2019 at 06:11, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Fri, Jun 21, 2019 at 09:42:39AM +0800, Wanpeng Li wrote:
> > On Thu, 20 Jun 2019 at 05:04, Marcelo Tosatti <mtosatti@redhat.com> wro=
te:
> > >
> > > Hi Li,
> > >
> > > On Wed, Jun 19, 2019 at 08:36:06AM +0800, Wanpeng Li wrote:
> > > > On Tue, 18 Jun 2019 at 21:36, Marcelo Tosatti <mtosatti@redhat.com>=
 wrote:
> > > > >
> > > > > On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrote:
> > > > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > > > >
> > > > > > Dedicated instances are currently disturbed by unnecessary jitt=
er due
> > > > > > to the emulated lapic timers fire on the same pCPUs which vCPUs=
 resident.
> > > > > > There is no hardware virtual timer on Intel for guest like ARM.=
 Both
> > > > > > programming timer in guest and the emulated timer fires incur v=
mexits.
> > > > > > This patch tries to avoid vmexit which is incurred by the emula=
ted
> > > > > > timer fires in dedicated instance scenario.
> > > > > >
> > > > > > When nohz_full is enabled in dedicated instances scenario, the =
emulated
> > > > > > timers can be offload to the nearest busy housekeeping cpus sin=
ce APICv
> > > > > > is really common in recent years. The guest timer interrupt is =
injected
> > > > > > by posted-interrupt which is delivered by housekeeping cpu once=
 the emulated
> > > > > > timer fires.
> > > > > >
> > > > > > The host admin should fine tuned, e.g. dedicated instances scen=
ario w/
> > > > > > nohz_full cover the pCPUs which vCPUs resident, several pCPUs s=
urplus
> > > > > > for busy housekeeping, disable mwait/hlt/pause vmexits to keep =
in non-root
> > > > > > mode, ~3% redis performance benefit can be observed on Skylake =
server.
> > > > > >
> > > > > > w/o patch:
> > > > > >
> > > > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max T=
ime   Avg time
> > > > > >
> > > > > > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.0=
9us   0.71us ( +-   1.09% )
> > > > > >
> > > > > > w/ patch:
> > > > > >
> > > > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max T=
ime         Avg time
> > > > > >
> > > > > > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.8=
8us   0.72us ( +-   4.02% )
> > > > > >
> > > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > > > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > > ---
> > > > > >  arch/x86/kvm/lapic.c            | 33 +++++++++++++++++++++++++=
+-------
> > > > > >  arch/x86/kvm/lapic.h            |  1 +
> > > > > >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> > > > > >  arch/x86/kvm/x86.c              |  5 +++++
> > > > > >  arch/x86/kvm/x86.h              |  2 ++
> > > > > >  include/linux/sched/isolation.h |  2 ++
> > > > > >  kernel/sched/isolation.c        |  6 ++++++
> > > > > >  7 files changed, 44 insertions(+), 8 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > > > index 87ecb56..9ceeee5 100644
> > > > > > --- a/arch/x86/kvm/lapic.c
> > > > > > +++ b/arch/x86/kvm/lapic.c
> > > > > > @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct kvm=
_lapic *apic)
> > > > > >       return apic->vcpu->vcpu_id;
> > > > > >  }
> > > > > >
> > > > > > +bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > > > > > +{
> > > > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > > > > +             kvm_hlt_in_guest(vcpu->kvm);
> > > > > > +}
> > > > > > +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
> > > > >
> > > > > Paolo, can you explain the reasoning behind this?
> > > > >
> > > > > Should not be necessary...
> >
> > https://lkml.org/lkml/2019/6/5/436  "Here you need to check
> > kvm_halt_in_guest, not kvm_mwait_in_guest, because you need to go
> > through kvm_apic_expired if the guest needs to be woken up from
> > kvm_vcpu_block."
>
> Ah, i think he means that a sleeping vcpu (in kvm_vcpu_block) must
> be woken up, if it receives a timer interrupt.
>
> But your patch will go through:
>
> kvm_apic_inject_pending_timer_irqs
> __apic_accept_irq ->
> vmx_deliver_posted_interrupt ->
> kvm_vcpu_trigger_posted_interrupt returns false
> (because vcpu->mode !=3D IN_GUEST_MODE) ->
> kvm_vcpu_kick
>
> Which will wakeup the vcpu.

Hi Marcelo,

>
> Apart from this oops, which triggers when running:
> taskset -c 1 ./cyclictest -D 3600 -p 99 -t 1 -h 30 -m -n  -i 50000 -b 40

I try both host and guest use latest kvm/queue  w/ CONFIG_PREEMPT
enabled, and expose mwait as your config, however, there is no oops.
Can you reproduce steadily or encounter casually? Can you reproduce
w/o the patchset?

>
> Timer interruption from housekeeping vcpus is normal to me
> (without requiring kvm_hlt_in_guest).
>
> [ 1145.849646] BUG: kernel NULL pointer dereference, address:
> 0000000000000000
> [ 1145.850481] #PF: supervisor instruction fetch in kernel mode
> [ 1145.851161] #PF: error_code(0x0010) - not-present page
> [ 1145.851772] PGD 80000002a9fa5067 P4D 80000002a9fa5067 PUD 2abcbb067
> PMD 0
> [ 1145.852578] Oops: 0010 [#1] PREEMPT SMP PTI
> [ 1145.853066] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.2.0-rc1+ #11
> [ 1145.853809] Hardware name: Red Hat KVM, BIOS 1.11.0-2.el7 04/01/2014
> [ 1145.854554] RIP: 0010:0x0
> [ 1145.854879] Code: Bad RIP value.
> [ 1145.855270] RSP: 0018:ffffc90001903e68 EFLAGS: 00010013
> [ 1145.855902] RAX: 0000010ac9f60043 RBX: ffff8882b58a8320 RCX:
> 00000000c526b7c4
> [ 1145.856726] RDX: 0000000000000000 RSI: ffffffff820d9640 RDI:
> ffff8882b58a8320
> [ 1145.857560] RBP: ffffffff820d9640 R08: 00000000c526b7c4 R09:
> 0000000000000832
> [ 1145.858390] R10: 0000000000000000 R11: 0000000000000000 R12:
> 0000000000000000
> [ 1145.859222] R13: ffffffff820d9658 R14: ffff8881063b2880 R15:
> 0000000000000002
> [ 1145.860047] FS:  0000000000000000(0000) GS:ffff8882b5880000(0000)
> knlGS:0000000000000000
> [ 1145.860994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1145.861692] CR2: ffffffffffffffd6 CR3: 00000002ab1de001 CR4:
> 0000000000160ee0
> [ 1145.862570] Call Trace:
> [ 1145.862877]  cpuidle_enter_state+0x7c/0x3e0
> [ 1145.863392]  cpuidle_enter+0x29/0x40
>
>
> > I think we can still be woken up from kvm_vcpu_block() if pir is set.
>
> Exactly.
>
