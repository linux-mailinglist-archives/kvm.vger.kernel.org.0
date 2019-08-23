Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831DC9AE9E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 14:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388866AbfHWMAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 08:00:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36507 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732688AbfHWMAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 08:00:37 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so8846320wme.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 05:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OSQOts4ipVHATDu6heXOLEB9yAN6oLXukpEFzyk4HhI=;
        b=DrZSBSnnerm1nTBP6O1oDPJ0z6pJRSpAdz0d2wiiUuwlIBmAm9CprQ8nyazH6uA2C3
         pXc5PzpTl/6kORYuCe0/7l9RX8jM7+/7VHUIOfX8/58cDr+eyG/ypphB3yAzWNCpb1UP
         uyDMF+L/T/9c7G7Uz6aswtuOiEMOGLcYV0wv8TbYwVNT4cF42Jj6P6hIs7VSp6X7eUJp
         aJp8J7wtTFEm45Vm3JzSatBtrFumurV0T860Jdoy3xD9HRhKH32o0/2fjYHKaOs4A7Ke
         D9KU8OOwuNZ1R3b/2W3U9KceDsUekaG4cU17DkcVn4dWQ5qZGvEMwESGpYYXjMa42871
         shhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OSQOts4ipVHATDu6heXOLEB9yAN6oLXukpEFzyk4HhI=;
        b=AXBQNZniRvldA1qC8dapDnVknGiKDApqaj4vYtSxhoj4ZHnvmwwB/pWYmQWlGCt2/m
         5aWJStQcITDXzq5A3YIAmBDR9F8B4LovHtItrvffTurfL3teDhrD4BFMeZJZuJ/gGP59
         PpUfI/tIbL9eV1ezEurlxt8c7laa+Jl3VnNmszS3BUvV5Z/LoSm1VDS3lfJy4YQrV+vj
         qWBqnQs5pFnIg0a9E5HuXK2Lcuy5jMGRcMb+lcLxN5oREowJ2ppRyugOIbNhTArRCrW4
         wVfwzJinJht9VkABCxqbiVeHtITVpBCukOnleY7pX8zGxdAgP+R7xb3Z3oi6cTx+Q9sm
         cJtQ==
X-Gm-Message-State: APjAAAUwG8yXlC58QxkfKXAxtlYvJIkKj9WE2tCXv6UbQ+iVmdfi8h45
        2n646OSDm4zHxwi2TaSo1UE0BYk9LEC3v/iOc52FUg==
X-Google-Smtp-Source: APXvYqzDJ2bL2ZEqUMC77UjPEaX3Atc+xH9gWgYd+nMeHAC2w8FjQWWV++aw3vHMHmBcyCwGNKb7JQ1+8tkZPfmoL1U=
X-Received: by 2002:a05:600c:2411:: with SMTP id 17mr4432346wmp.171.1566561632980;
 Fri, 23 Aug 2019 05:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190822084131.114764-1-anup.patel@wdc.com> <20190822084131.114764-19-anup.patel@wdc.com>
 <40911e08-e0ce-a2b8-24d4-9cf357432850@amazon.com> <CAAhSdy3CvvYh59c=OomLZgweWREBhJj_eeH80OkU=7MMCwyiCQ@mail.gmail.com>
 <B29D1609-18FC-4327-8B34-33CB914042E7@amazon.com>
In-Reply-To: <B29D1609-18FC-4327-8B34-33CB914042E7@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 23 Aug 2019 17:30:21 +0530
Message-ID: <CAAhSdy2eVDqCDnFT9WrboQn+ERhwDFU6UtBaCQp_C7HshLZ+Yw@mail.gmail.com>
Subject: Re: [PATCH v5 18/20] RISC-V: KVM: Add SBI v0.1 support
To:     "Graf (AWS), Alexander" <graf@amazon.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 5:09 PM Graf (AWS), Alexander <graf@amazon.com> wro=
te:
>
>
>
> > Am 23.08.2019 um 13:18 schrieb Anup Patel <anup@brainfault.org>:
> >
> >> On Fri, Aug 23, 2019 at 1:34 PM Alexander Graf <graf@amazon.com> wrote=
:
> >>
> >>> On 22.08.19 10:46, Anup Patel wrote:
> >>> From: Atish Patra <atish.patra@wdc.com>
> >>>
> >>> The KVM host kernel running in HS-mode needs to handle SBI calls comi=
ng
> >>> from guest kernel running in VS-mode.
> >>>
> >>> This patch adds SBI v0.1 support in KVM RISC-V. All the SBI calls are
> >>> implemented correctly except remote tlb flushes. For remote TLB flush=
es,
> >>> we are doing full TLB flush and this will be optimized in future.
> >>>
> >>> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> >>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> >>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> >>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> >>> ---
> >>>  arch/riscv/include/asm/kvm_host.h |   2 +
> >>>  arch/riscv/kvm/Makefile           |   2 +-
> >>>  arch/riscv/kvm/vcpu_exit.c        |   3 +
> >>>  arch/riscv/kvm/vcpu_sbi.c         | 119 ++++++++++++++++++++++++++++=
++
> >>>  4 files changed, 125 insertions(+), 1 deletion(-)
> >>>  create mode 100644 arch/riscv/kvm/vcpu_sbi.c
> >>>
> >>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/a=
sm/kvm_host.h
> >>> index 2af3a179c08e..0b1eceaef59f 100644
> >>> --- a/arch/riscv/include/asm/kvm_host.h
> >>> +++ b/arch/riscv/include/asm/kvm_host.h
> >>> @@ -241,4 +241,6 @@ bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu=
 *vcpu);
> >>>  void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
> >>>  void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
> >>>
> >>> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu);
> >>> +
> >>>  #endif /* __RISCV_KVM_HOST_H__ */
> >>> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> >>> index 3e0c7558320d..b56dc1650d2c 100644
> >>> --- a/arch/riscv/kvm/Makefile
> >>> +++ b/arch/riscv/kvm/Makefile
> >>> @@ -9,6 +9,6 @@ ccflags-y :=3D -Ivirt/kvm -Iarch/riscv/kvm
> >>>  kvm-objs :=3D $(common-objs-y)
> >>>
> >>>  kvm-objs +=3D main.o vm.o vmid.o tlb.o mmu.o
> >>> -kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
> >>> +kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi=
.o
> >>>
> >>>  obj-$(CONFIG_KVM)   +=3D kvm.o
> >>> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> >>> index fbc04fe335ad..87b83fcf9a14 100644
> >>> --- a/arch/riscv/kvm/vcpu_exit.c
> >>> +++ b/arch/riscv/kvm/vcpu_exit.c
> >>> @@ -534,6 +534,9 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run,
> >>>                  (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
> >>>                      ret =3D stage2_page_fault(vcpu, run, scause, stv=
al);
> >>>              break;
> >>> +     case EXC_SUPERVISOR_SYSCALL:
> >>> +             if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> >>> +                     ret =3D kvm_riscv_vcpu_sbi_ecall(vcpu);
> >>>      default:
> >>>              break;
> >>>      };
> >>> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> >>> new file mode 100644
> >>> index 000000000000..5793202eb514
> >>> --- /dev/null
> >>> +++ b/arch/riscv/kvm/vcpu_sbi.c
> >>> @@ -0,0 +1,119 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +/**
> >>> + * Copyright (c) 2019 Western Digital Corporation or its affiliates.
> >>> + *
> >>> + * Authors:
> >>> + *     Atish Patra <atish.patra@wdc.com>
> >>> + */
> >>> +
> >>> +#include <linux/errno.h>
> >>> +#include <linux/err.h>
> >>> +#include <linux/kvm_host.h>
> >>> +#include <asm/csr.h>
> >>> +#include <asm/kvm_vcpu_timer.h>
> >>> +
> >>> +#define SBI_VERSION_MAJOR                    0
> >>> +#define SBI_VERSION_MINOR                    1
> >>> +
> >>> +/* TODO: Handle traps due to unpriv load and redirect it back to VS-=
mode */
> >>
> >> Ugh, another one of those? Can't you just figure out a way to recover
> >> from the page fault? Also, you want to combine this with the instructi=
on
> >> load logic, so that we have a single place that guest address space
> >> reads go through.
> >
> > Walking Guest page table would be more expensive compared to implementi=
ng
> > a trap handling mechanism.
> >
> > We will be adding trap handling mechanism for reading instruction and r=
eading
> > load.
> >
> > Both these operations are different in following ways:
> > 1. RISC-V instructions are variable length. We get to know exact instru=
ction
> >    length only after reading first 16bits
> > 2. We need to set VSSTATUS.MXR bit when reading instruction for
> >    execute-only Guest pages.
>
> Yup, sounds like you could solve that with a trivial if() based on "read =
instruction" or not, no? If you want to, feel free to provide short version=
s that do only read ins/data, but I would really like to see the whole "dat=
a reads become guest reads" magic to be funneled through a single function =
(in C, can be inline unrolled in asm of course)
>
> >
> >>
> >>> +static unsigned long kvm_sbi_unpriv_load(const unsigned long *addr,
> >>> +                                      struct kvm_vcpu *vcpu)
> >>> +{
> >>> +     unsigned long flags, val;
> >>> +     unsigned long __hstatus, __sstatus;
> >>> +
> >>> +     local_irq_save(flags);
> >>> +     __hstatus =3D csr_read(CSR_HSTATUS);
> >>> +     __sstatus =3D csr_read(CSR_SSTATUS);
> >>> +     csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTAT=
US_SPRV);
> >>> +     csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus);
> >>> +     val =3D *addr;
> >>> +     csr_write(CSR_HSTATUS, __hstatus);
> >>> +     csr_write(CSR_SSTATUS, __sstatus);
> >>> +     local_irq_restore(flags);
> >>> +
> >>> +     return val;
> >>> +}
> >>> +
> >>> +static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu, u32 type)
> >>> +{
> >>> +     int i;
> >>> +     struct kvm_vcpu *tmp;
> >>> +
> >>> +     kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> >>> +             tmp->arch.power_off =3D true;
> >>> +     kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> >>> +
> >>> +     memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_ev=
ent));
> >>> +     vcpu->run->system_event.type =3D type;
> >>> +     vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
> >>> +}
> >>> +
> >>> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu)
> >>> +{
> >>> +     int ret =3D 1;
> >>> +     u64 next_cycle;
> >>> +     int vcpuid;
> >>> +     struct kvm_vcpu *remote_vcpu;
> >>> +     ulong dhart_mask;
> >>> +     struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
> >>> +
> >>> +     if (!cp)
> >>> +             return -EINVAL;
> >>> +     switch (cp->a7) {
> >>> +     case SBI_SET_TIMER:
> >>> +#if __riscv_xlen =3D=3D 32
> >>> +             next_cycle =3D ((u64)cp->a1 << 32) | (u64)cp->a0;
> >>> +#else
> >>> +             next_cycle =3D (u64)cp->a0;
> >>> +#endif
> >>> +             kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> >>
> >> Ah, this is where the timer set happens. I still don't understand how
> >> this takes the frequency bit into account?
> >
> > Explained it in PATCH17 comments.
> >
> >>
> >>> +             break;
> >>> +     case SBI_CONSOLE_PUTCHAR:
> >>> +             /* Not implemented */
> >>> +             cp->a0 =3D -ENOTSUPP;
> >>> +             break;
> >>> +     case SBI_CONSOLE_GETCHAR:
> >>> +             /* Not implemented */
> >>> +             cp->a0 =3D -ENOTSUPP;
> >>> +             break;
> >>
> >> These two should be covered by the default case.
> >
> > Sure, I will update.
> >
> >>
> >>> +     case SBI_CLEAR_IPI:
> >>> +             kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
> >>> +             break;
> >>> +     case SBI_SEND_IPI:
> >>> +             dhart_mask =3D kvm_sbi_unpriv_load((unsigned long *)cp-=
>a0, vcpu);
> >>> +             for_each_set_bit(vcpuid, &dhart_mask, BITS_PER_LONG) {
> >>> +                     remote_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, v=
cpuid);
> >>> +                     kvm_riscv_vcpu_set_interrupt(remote_vcpu, IRQ_S=
_SOFT);
> >>> +             }
> >>> +             break;
> >>> +     case SBI_SHUTDOWN:
> >>> +             kvm_sbi_system_shutdown(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN=
);
> >>> +             ret =3D 0;
> >>> +             break;
> >>> +     case SBI_REMOTE_FENCE_I:
> >>> +             sbi_remote_fence_i(NULL);
> >>> +             break;
> >>> +     /*
> >>> +      * TODO: There should be a way to call remote hfence.bvma.
> >>> +      * Preferred method is now a SBI call. Until then, just flush
> >>> +      * all tlbs.
> >>> +      */
> >>> +     case SBI_REMOTE_SFENCE_VMA:
> >>> +             /*TODO: Parse vma range.*/
> >>> +             sbi_remote_sfence_vma(NULL, 0, 0);
> >>> +             break;
> >>> +     case SBI_REMOTE_SFENCE_VMA_ASID:
> >>> +             /*TODO: Parse vma range for given ASID */
> >>> +             sbi_remote_sfence_vma(NULL, 0, 0);
> >>> +             break;
> >>> +     default:
> >>> +             cp->a0 =3D ENOTSUPP;
> >>> +             break;
> >>
> >> Please just send unsupported SBI events into user space.
> >
> > For unsupported SBI calls, we should be returning error to the
> > Guest Linux so that do something about it. This is in accordance
> > with the SBI spec.
>
> That's up to user space (QEMU / kvmtool) to decide. If user space wants t=
o implement the  console functions (like we do on s390), it should have the=
 chance to do so.

The SBI_CONSOLE_PUTCHAR and SBI_CONSOLE_GETCHAR are
for debugging only. These calls are deprecated in SBI v0.2 onwards
because we now have earlycon for early prints in Linux RISC-V.

The RISC-V Guest will generally have it's own MMIO based UART
which will be the default console.

Due to these reasons, we have not implemented these SBI calls.

If we still want user-space to implement this then we will require
separate exit reasons and we are trying to avoid adding RISC-V
specific exit reasons/ioctls in KVM user-space ABI.

The absence of SBI_CONSOLE_PUTCHAR/GETCHAR certainly
does not block anyone in debugging Guest Linux because we have
earlycon support in Linux RISC-V.

Regards,
Anup

>
> Alex
>
