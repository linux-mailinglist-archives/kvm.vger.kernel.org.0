Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711C69AE5D
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393292AbfHWLqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:46:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41436 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393233AbfHWLqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:46:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so8344003wrr.8
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 04:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IzZhPx4n5QlVcVtSI+O2wNpdvbAxTecGWThw9DugxQA=;
        b=kxf114pOp4KOUp60b8uworoAcPWxW5NdbxiuZ8YBYdjhYSo50CJ6/S42LcwwZ8R941
         KiBnahI93DoIFtDiAbQAfFqcijbZOtQhM6FdFhffMP2ib62A4KY20TiiTmCIduI3MhyB
         G2WN33XK05sSuhR7bLxQTaoLcRAUNPCd9EGvZNnn6ImaReK/pTAgTi9/6JPgF7ElvIUF
         H5qWTjwOL6oM0Lq+RbOmVFrlhtnQwNuB2MVAd2UPYFxy8LBAcdKAnsHDno5SQQVx8RlR
         yr23ty6540delOmPZTxprA6ozFPCRmWsE7S1J0AgZmfcovZgh7Yep7hehtM3qe2NmCdp
         Gu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IzZhPx4n5QlVcVtSI+O2wNpdvbAxTecGWThw9DugxQA=;
        b=kMkGJBka6w5m9HfLuDscgJE5TAB1zoMfsu9NfTJFcQX7w9CvEHbqUt7TuBNs2AHPfi
         K/VG42E7PgfGKSAOrP2XgIDneNaWQWLTFLEnbwcRrI1lWSiBXXVXeD4ppV0lo9POuidn
         9r5vpQPsfug+sSEhKSWhem+zXOFKF8Pqu1e3MOuWNj8lrjM24SZooPiw3qXyXIBchBUv
         qAJU0ApydkAzy51fhpRvLQlAPrTXqP/wOux/hoEFtAnN2n/fk45rjkLt4ZSB7u5+g/nz
         e+/sMqpxpQoGXYMM5J5IhXa1VzhqzURxBUJyUGYYwehPHGGx20CQx3tHAGVGV7T9UZ0Z
         bBcQ==
X-Gm-Message-State: APjAAAUZAP7ux4MOVjDRhHlAg6sOZHHyFw2msHeMFgeAkMYee+2lMVww
        9urp879VFYxKbmPbeExlqHVyZtLh26s9XHVXooBqag==
X-Google-Smtp-Source: APXvYqxGkEriVP5kGyvYlJY/ziEdD3xZfSV97n/0w+efWGQFZx0FhdkyW3cqIo1fMK1QBqTzUBEdVGbPO0UC+ufojms=
X-Received: by 2002:adf:ce04:: with SMTP id p4mr4738517wrn.227.1566560802710;
 Fri, 23 Aug 2019 04:46:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190822084131.114764-1-anup.patel@wdc.com> <20190822084131.114764-16-anup.patel@wdc.com>
 <09d74212-4fa3-d64c-5a63-d556e955b88c@amazon.com> <CAAhSdy36q5-x8cXM=M5S3cnE2nvCMhcsfuQayVt7jahd58HWFw@mail.gmail.com>
 <CA3A6A8A-0227-4B92-B892-86A0C7CA369E@amazon.com>
In-Reply-To: <CA3A6A8A-0227-4B92-B892-86A0C7CA369E@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 23 Aug 2019 17:16:31 +0530
Message-ID: <CAAhSdy2FFmCZJhNnMojp8QbiD-t6=4XrNtE9KGnCG_-mPb19-A@mail.gmail.com>
Subject: Re: [PATCH v5 15/20] RISC-V: KVM: Add timer functionality
To:     "Graf (AWS), Alexander" <graf@amazon.com>
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

On Fri, Aug 23, 2019 at 5:03 PM Graf (AWS), Alexander <graf@amazon.com> wrote:
>
>
>
> > Am 23.08.2019 um 13:05 schrieb Anup Patel <anup@brainfault.org>:
> >
> >> On Fri, Aug 23, 2019 at 1:23 PM Alexander Graf <graf@amazon.com> wrote:
> >>
> >>> On 22.08.19 10:46, Anup Patel wrote:
> >>> From: Atish Patra <atish.patra@wdc.com>
> >>>
> >>> The RISC-V hypervisor specification doesn't have any virtual timer
> >>> feature.
> >>>
> >>> Due to this, the guest VCPU timer will be programmed via SBI calls.
> >>> The host will use a separate hrtimer event for each guest VCPU to
> >>> provide timer functionality. We inject a virtual timer interrupt to
> >>> the guest VCPU whenever the guest VCPU hrtimer event expires.
> >>>
> >>> The following features are not supported yet and will be added in
> >>> future:
> >>> 1. A time offset to adjust guest time from host time
> >>> 2. A saved next event in guest vcpu for vm migration
> >>
> >> Implementing these 2 bits right now should be trivial. Why wait?
> >
> > We were waiting for HTIMEDELTA CSR to be merged so we
> > deferred this items.
> >
> >>
> >>>
> >>> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> >>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> >>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> >>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> >>> ---
> >>>  arch/riscv/include/asm/kvm_host.h       |   4 +
> >>>  arch/riscv/include/asm/kvm_vcpu_timer.h |  32 +++++++
> >>>  arch/riscv/kvm/Makefile                 |   2 +-
> >>>  arch/riscv/kvm/vcpu.c                   |   6 ++
> >>>  arch/riscv/kvm/vcpu_timer.c             | 106 ++++++++++++++++++++++++
> >>>  drivers/clocksource/timer-riscv.c       |   8 ++
> >>>  include/clocksource/timer-riscv.h       |  16 ++++
> >>>  7 files changed, 173 insertions(+), 1 deletion(-)
> >>>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
> >>>  create mode 100644 arch/riscv/kvm/vcpu_timer.c
> >>>  create mode 100644 include/clocksource/timer-riscv.h
> >>>
> >>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> >>> index ab33e59a3d88..d2a2e45eefc0 100644
> >>> --- a/arch/riscv/include/asm/kvm_host.h
> >>> +++ b/arch/riscv/include/asm/kvm_host.h
> >>> @@ -12,6 +12,7 @@
> >>>  #include <linux/types.h>
> >>>  #include <linux/kvm.h>
> >>>  #include <linux/kvm_types.h>
> >>> +#include <asm/kvm_vcpu_timer.h>
> >>>
> >>>  #ifdef CONFIG_64BIT
> >>>  #define KVM_MAX_VCPUS                       (1U << 16)
> >>> @@ -167,6 +168,9 @@ struct kvm_vcpu_arch {
> >>>      unsigned long irqs_pending;
> >>>      unsigned long irqs_pending_mask;
> >>>
> >>> +     /* VCPU Timer */
> >>> +     struct kvm_vcpu_timer timer;
> >>> +
> >>>      /* MMIO instruction details */
> >>>      struct kvm_mmio_decode mmio_decode;
> >>>
> >>> diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
> >>> new file mode 100644
> >>> index 000000000000..df67ea86988e
> >>> --- /dev/null
> >>> +++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
> >>> @@ -0,0 +1,32 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0-only */
> >>> +/*
> >>> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> >>> + *
> >>> + * Authors:
> >>> + *   Atish Patra <atish.patra@wdc.com>
> >>> + */
> >>> +
> >>> +#ifndef __KVM_VCPU_RISCV_TIMER_H
> >>> +#define __KVM_VCPU_RISCV_TIMER_H
> >>> +
> >>> +#include <linux/hrtimer.h>
> >>> +
> >>> +#define VCPU_TIMER_PROGRAM_THRESHOLD_NS 1000
> >>> +
> >>> +struct kvm_vcpu_timer {
> >>> +     bool init_done;
> >>> +     /* Check if the timer is programmed */
> >>> +     bool is_set;
> >>> +     struct hrtimer hrt;
> >>> +     /* Mult & Shift values to get nanosec from cycles */
> >>> +     u32 mult;
> >>> +     u32 shift;
> >>> +};
> >>> +
> >>> +int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
> >>> +int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
> >>> +int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
> >>> +int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu,
> >>> +                                 unsigned long ncycles);
> >>
> >> This function never gets called?
> >
> > It's called from SBI emulation.
> >
> >>
> >>> +
> >>> +#endif
> >>> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> >>> index c0f57f26c13d..3e0c7558320d 100644
> >>> --- a/arch/riscv/kvm/Makefile
> >>> +++ b/arch/riscv/kvm/Makefile
> >>> @@ -9,6 +9,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
> >>>  kvm-objs := $(common-objs-y)
> >>>
> >>>  kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
> >>> -kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o
> >>> +kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
> >>>
> >>>  obj-$(CONFIG_KVM)   += kvm.o
> >>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> >>> index 6124077d154f..018fca436776 100644
> >>> --- a/arch/riscv/kvm/vcpu.c
> >>> +++ b/arch/riscv/kvm/vcpu.c
> >>> @@ -54,6 +54,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> >>>
> >>>      memcpy(cntx, reset_cntx, sizeof(*cntx));
> >>>
> >>> +     kvm_riscv_vcpu_timer_reset(vcpu);
> >>> +
> >>>      WRITE_ONCE(vcpu->arch.irqs_pending, 0);
> >>>      WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> >>>  }
> >>> @@ -108,6 +110,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> >>>      cntx->hstatus |= HSTATUS_SP2P;
> >>>      cntx->hstatus |= HSTATUS_SPV;
> >>>
> >>> +     /* Setup VCPU timer */
> >>> +     kvm_riscv_vcpu_timer_init(vcpu);
> >>> +
> >>>      /* Reset VCPU */
> >>>      kvm_riscv_reset_vcpu(vcpu);
> >>>
> >>> @@ -116,6 +121,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> >>>
> >>>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> >>>  {
> >>> +     kvm_riscv_vcpu_timer_deinit(vcpu);
> >>>      kvm_riscv_stage2_flush_cache(vcpu);
> >>>      kmem_cache_free(kvm_vcpu_cache, vcpu);
> >>>  }
> >>> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> >>> new file mode 100644
> >>> index 000000000000..a45ca06e1aa6
> >>> --- /dev/null
> >>> +++ b/arch/riscv/kvm/vcpu_timer.c
> >>> @@ -0,0 +1,106 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +/*
> >>> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> >>> + *
> >>> + * Authors:
> >>> + *     Atish Patra <atish.patra@wdc.com>
> >>> + */
> >>> +
> >>> +#include <linux/errno.h>
> >>> +#include <linux/err.h>
> >>> +#include <linux/kvm_host.h>
> >>> +#include <clocksource/timer-riscv.h>
> >>> +#include <asm/csr.h>
> >>> +#include <asm/kvm_vcpu_timer.h>
> >>> +
> >>> +static enum hrtimer_restart kvm_riscv_vcpu_hrtimer_expired(struct hrtimer *h)
> >>> +{
> >>> +     struct kvm_vcpu_timer *t = container_of(h, struct kvm_vcpu_timer, hrt);
> >>> +     struct kvm_vcpu *vcpu = container_of(t, struct kvm_vcpu, arch.timer);
> >>> +
> >>> +     t->is_set = false;
> >>> +     kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_TIMER);
> >>> +
> >>> +     return HRTIMER_NORESTART;
> >>> +}
> >>> +
> >>> +static u64 kvm_riscv_delta_cycles2ns(u64 cycles, struct kvm_vcpu_timer *t)
> >>> +{
> >>> +     unsigned long flags;
> >>> +     u64 cycles_now, cycles_delta, delta_ns;
> >>> +
> >>> +     local_irq_save(flags);
> >>> +     cycles_now = get_cycles64();
> >>> +     if (cycles_now < cycles)
> >>> +             cycles_delta = cycles - cycles_now;
> >>> +     else
> >>> +             cycles_delta = 0;
> >>> +     delta_ns = (cycles_delta * t->mult) >> t->shift;
> >>> +     local_irq_restore(flags);
> >>> +
> >>> +     return delta_ns;
> >>> +}
> >>> +
> >>> +static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
> >>> +{
> >>> +     if (!t->init_done || !t->is_set)
> >>> +             return -EINVAL;
> >>> +
> >>> +     hrtimer_cancel(&t->hrt);
> >>> +     t->is_set = false;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu,
> >>> +                                 unsigned long ncycles)
> >>> +{
> >>> +     struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> >>> +     u64 delta_ns = kvm_riscv_delta_cycles2ns(ncycles, t);
> >>
> >> ... in fact, I feel like I'm missing something obvious here. How does
> >> the guest trigger the timer event? What is the argument it uses for that
> >> and how does that play with the tbfreq in the earlier patch?
> >
> > We have SBI call inferface between Hypervisor and Guest. One of the
> > SBI call allows Guest to program time event. The next event is specified
> > as absolute cycles. The Guest can read time using TIME CSR which
> > returns system timer value (@ tbfreq freqency).
> >
> > Guest Linux will know the tbfreq from DTB passed by QEMU/KVMTOOL
> > and it has to be same as Host tbfreq.
> >
> > The TBFREQ config register visible to user-space is a read-only CONFIG
> > register which tells user-space tools (QEMU/KVMTOOL) about Host tbfreq.
>
> And it's read-only because you can not trap on TB reads?

There is no TB registers.

The tbfreq can only be know through DT/ACPI kind-of HW description
for both Host and Guest.

The KVM user-space tool needs to know TBFREQ so that it can set correct
value in generated DT for Guest Linux.

Regards,
Anup

>
> Alex
>
> >
> > Regards,
> > Anup
> >
> >>
> >>
> >> Alex
> >>
