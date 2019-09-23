Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B1ABB49A
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 14:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394771AbfIWM7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 08:59:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35521 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394720AbfIWM7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 08:59:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id y21so9222178wmi.0
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 05:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HTuM7/0UVWYw13uPzi+JxNLECRLsoMfgODIyjcc3VMA=;
        b=KHxg3sfhcAxqdoLBIjcXRxE8lVWuEiR3G6gv/GECDpR+XLvkcYfONyKgPhyWO12Pxx
         bsoM3Ln/JaM6ElP9GokIc9e7ZaT3JRpe00aXBJLKz3S4DQXQNxqU1l5bED1DlOzaKfAv
         bowzzJgpS8ooLWUkfNkTWPTGzDerYIiFNVxEUOuSQPrnOmYZkyF5nz8STB5vOw1hPANL
         RdGwHspHWsGCDayIoY4pNRNM5sBD17QO/DUasnMzcH5w71bpRyAYsL1/b/Gwe8Qff8yx
         3zGBlhk93p7X7uGHGWFiHM7aznecCqdV8N0avWMGCiIzzgAX63kBE6zAC3k7q6TJLyit
         E2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HTuM7/0UVWYw13uPzi+JxNLECRLsoMfgODIyjcc3VMA=;
        b=lPSSeH10m0MUQ5+x8t3x1rboXvVQBSk7JzCX2TvXmA80oI1TFtYa5ks8Oh2j+Q9ia6
         AzXDe0yk7Gib2VmIjb6CnDjUn3bkqwWWPOicVypL4+7F92mKE3d6Uyv4yQ8YjG7ANSks
         bKXnl069YaQHGNJIjwCFGEqWoH+kMp4hF++1sEj7O53PjESJ8xno09W7Ds/7Ca9ZHhTX
         i9gNbw+loneU44sIcClWYinkxbg3s4lSFHJQU5neFEWToHigzyOPXouW+JT0oGRpJI5B
         JFyqImzAcLAgn4CObFDALijA3UQ7twR37FdQ4qFcbepbh8uWDDAiafzJJSGK4W5woge0
         uMVA==
X-Gm-Message-State: APjAAAWW6bTHK2PUh1D2La3XFyoz1kFHaEZ5y0h73/UDN1R74sQ0f24/
        c6PVHfV6YnvLAt8A74dQi8MGKg+L9AGkklG3OwQNyw==
X-Google-Smtp-Source: APXvYqzh2IBz0cIlPb7hv46bd1P8/dI9ldz/B7wmwEcTK3TnZ6Hf8lVRsJVYT/tG4aQeI5ajqHIpCC6rKKf/Oh9nAIE=
X-Received: by 2002:a1c:5451:: with SMTP id p17mr13776037wmi.103.1569243552938;
 Mon, 23 Sep 2019 05:59:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-20-anup.patel@wdc.com>
 <d144652e-898b-bf6b-dc73-352fb1fffd40@amazon.com>
In-Reply-To: <d144652e-898b-bf6b-dc73-352fb1fffd40@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 23 Sep 2019 18:29:01 +0530
Message-ID: <CAAhSdy3HE_s5mqGmC0w8WWxJ4C6HJPyo-9Pdc-7snQ4aN9vKOA@mail.gmail.com>
Subject: Re: [PATCH v7 18/21] RISC-V: KVM: Add SBI v0.1 support
To:     Alexander Graf <graf@amazon.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 12:31 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 04.09.19 18:16, Anup Patel wrote:
> > From: Atish Patra <atish.patra@wdc.com>
> >
> > The KVM host kernel running in HS-mode needs to handle SBI calls coming
> > from guest kernel running in VS-mode.
> >
> > This patch adds SBI v0.1 support in KVM RISC-V. All the SBI calls are
> > implemented correctly except remote tlb flushes. For remote TLB flushes,
> > we are doing full TLB flush and this will be optimized in future.
> >
> > Signed-off-by: Atish Patra <atish.patra@wdc.com>
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/riscv/include/asm/kvm_host.h |   2 +
> >   arch/riscv/kvm/Makefile           |   2 +-
> >   arch/riscv/kvm/vcpu_exit.c        |   3 +
> >   arch/riscv/kvm/vcpu_sbi.c         | 104 ++++++++++++++++++++++++++++++
> >   4 files changed, 110 insertions(+), 1 deletion(-)
> >   create mode 100644 arch/riscv/kvm/vcpu_sbi.c
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index 928c67828b1b..269bfa5641b1 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -250,4 +250,6 @@ bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu);
> >   void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
> >   void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
> >
> > +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu);
> > +
> >   #endif /* __RISCV_KVM_HOST_H__ */
> > diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> > index 3e0c7558320d..b56dc1650d2c 100644
> > --- a/arch/riscv/kvm/Makefile
> > +++ b/arch/riscv/kvm/Makefile
> > @@ -9,6 +9,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
> >   kvm-objs := $(common-objs-y)
> >
> >   kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
> > -kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
> > +kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o
> >
> >   obj-$(CONFIG_KVM)   += kvm.o
> > diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> > index 39469f67b241..0ee4e8943f4f 100644
> > --- a/arch/riscv/kvm/vcpu_exit.c
> > +++ b/arch/riscv/kvm/vcpu_exit.c
> > @@ -594,6 +594,9 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                   (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
> >                       ret = stage2_page_fault(vcpu, run, scause, stval);
> >               break;
> > +     case EXC_SUPERVISOR_SYSCALL:
> > +             if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> > +                     ret = kvm_riscv_vcpu_sbi_ecall(vcpu);
>
> implicit fall-through

Okay, I will add break here.

>
> >       default:
> >               break;
> >       };
> > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > new file mode 100644
> > index 000000000000..b415b8b54bb1
> > --- /dev/null
> > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > @@ -0,0 +1,104 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/**
> > + * Copyright (c) 2019 Western Digital Corporation or its affiliates.
> > + *
> > + * Authors:
> > + *     Atish Patra <atish.patra@wdc.com>
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/err.h>
> > +#include <linux/kvm_host.h>
> > +#include <asm/csr.h>
> > +#include <asm/kvm_vcpu_timer.h>
> > +
> > +#define SBI_VERSION_MAJOR                    0
> > +#define SBI_VERSION_MINOR                    1
> > +
> > +static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu, u32 type)
> > +{
> > +     int i;
> > +     struct kvm_vcpu *tmp;
> > +
> > +     kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> > +             tmp->arch.power_off = true;
> > +     kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> > +
> > +     memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> > +     vcpu->run->system_event.type = type;
> > +     vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>
> Is there a particular reason this has to be implemented in kernel space?

It's not implemented in kernel space. We are forwarding it to user space
using exit reason KVM_EXIT_SYSTEM_EVENT. These exit reason is
arch independent and both QEMU and KVMTOOL already implement
it in arch independent way.

> It's not performance critical and all stopping vcpus is something user
> space should be able to do as well, no?

Yes, it's not performance critical but it's done in user space.

>
> > +}
> > +
> > +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu)
> > +{
> > +     int i, ret = 1;
> > +     u64 next_cycle;
> > +     struct kvm_vcpu *rvcpu;
> > +     bool next_sepc = true;
> > +     ulong hmask, ut_scause = 0;
> > +     struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> > +
> > +     if (!cp)
> > +             return -EINVAL;
> > +
> > +     switch (cp->a7) {
> > +     case SBI_SET_TIMER:
> > +#if __riscv_xlen == 32
> > +             next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> > +#else
> > +             next_cycle = (u64)cp->a0;
> > +#endif
> > +             kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> > +             break;
> > +     case SBI_CLEAR_IPI:
> > +             kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
> > +             break;
> > +     case SBI_SEND_IPI:
> > +             hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> > +                                                &ut_scause);
> > +             if (ut_scause) {
> > +                     kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause,
> > +                                                  cp->a0);
> > +                     next_sepc = false;
> > +             } else {
> > +                     for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> > +                             rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> > +                             kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_S_SOFT);
> > +                     }
> > +             }
> > +             break;
> > +     case SBI_SHUTDOWN:
> > +             kvm_sbi_system_shutdown(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN);
> > +             ret = 0;
> > +             break;
> > +     case SBI_REMOTE_FENCE_I:
> > +             sbi_remote_fence_i(NULL);
> > +             break;
> > +     /*
> > +      * TODO: There should be a way to call remote hfence.bvma.
> > +      * Preferred method is now a SBI call. Until then, just flush
> > +      * all tlbs.
> > +      */
> > +     case SBI_REMOTE_SFENCE_VMA:
> > +             /* TODO: Parse vma range. */
> > +             sbi_remote_sfence_vma(NULL, 0, 0);
> > +             break;
> > +     case SBI_REMOTE_SFENCE_VMA_ASID:
> > +             /* TODO: Parse vma range for given ASID */
> > +             sbi_remote_sfence_vma(NULL, 0, 0);
> > +             break;
> > +     default:
> > +             /*
> > +              * For now, just return error to Guest.
> > +              * TODO: In-future, we will route unsupported SBI calls
> > +              * to user-space.
> > +              */
> > +             cp->a0 = -ENOTSUPP;
> > +             break;
> > +     };
> > +
> > +     if (ret >= 0)
> > +             cp->sepc += 4;
>
> I don't see you ever setting ret except for shutdown?
>
> Really, now is the time to plumb SBI calls down to user space. It allows
> you to have a clean shutdown story from day 1.

I agree with you.

I will implement unsupported SBI call forwarding to user-space in v8 series.

Regards,
Anup
