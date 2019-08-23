Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4579AE3F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392987AbfHWLjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:39:02 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:39745 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732231AbfHWLjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566560341; x=1598096341;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ji1WBt1MoZ3IvJNh35viZhZ/j+F2LYe0SDQaZnCu0Xo=;
  b=pUF+lycKW276hVIEkermgT2U42+ySm/vIgURyIYi2a7NZg0KXalSPFGo
   FOsyvXh9VolvBWD4ErBQXY79FGweEr943fj5u3LQtrDXgc2KHrlcGeuur
   rZPi7TItYDyVR3sZwcjBuDFzOmSvXWxtWwQiUOldAv0zpQ/gfH1JjgopO
   4=;
X-IronPort-AV: E=Sophos;i="5.64,421,1559520000"; 
   d="scan'208";a="411322945"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Aug 2019 11:38:58 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id E9DAFA1DAB;
        Fri, 23 Aug 2019 11:38:57 +0000 (UTC)
Received: from EX13D20UWC003.ant.amazon.com (10.43.162.18) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 11:38:57 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D20UWC003.ant.amazon.com (10.43.162.18) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 11:38:57 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Fri, 23 Aug 2019 11:38:56 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.com>
To:     Anup Patel <anup@brainfault.org>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Atish Patra" <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v5 18/20] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [PATCH v5 18/20] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVWYlrflI6481SQUmopAu7WHASy6cIlbyAgAAF42A=
Date:   Fri, 23 Aug 2019 11:38:56 +0000
Message-ID: <B29D1609-18FC-4327-8B34-33CB914042E7@amazon.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-19-anup.patel@wdc.com>
 <40911e08-e0ce-a2b8-24d4-9cf357432850@amazon.com>,<CAAhSdy3CvvYh59c=OomLZgweWREBhJj_eeH80OkU=7MMCwyiCQ@mail.gmail.com>
In-Reply-To: <CAAhSdy3CvvYh59c=OomLZgweWREBhJj_eeH80OkU=7MMCwyiCQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 23.08.2019 um 13:18 schrieb Anup Patel <anup@brainfault.org>:
>=20
>> On Fri, Aug 23, 2019 at 1:34 PM Alexander Graf <graf@amazon.com> wrote:
>>=20
>>> On 22.08.19 10:46, Anup Patel wrote:
>>> From: Atish Patra <atish.patra@wdc.com>
>>>=20
>>> The KVM host kernel running in HS-mode needs to handle SBI calls coming
>>> from guest kernel running in VS-mode.
>>>=20
>>> This patch adds SBI v0.1 support in KVM RISC-V. All the SBI calls are
>>> implemented correctly except remote tlb flushes. For remote TLB flushes=
,
>>> we are doing full TLB flush and this will be optimized in future.
>>>=20
>>> Signed-off-by: Atish Patra <atish.patra@wdc.com>
>>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  arch/riscv/include/asm/kvm_host.h |   2 +
>>>  arch/riscv/kvm/Makefile           |   2 +-
>>>  arch/riscv/kvm/vcpu_exit.c        |   3 +
>>>  arch/riscv/kvm/vcpu_sbi.c         | 119 ++++++++++++++++++++++++++++++
>>>  4 files changed, 125 insertions(+), 1 deletion(-)
>>>  create mode 100644 arch/riscv/kvm/vcpu_sbi.c
>>>=20
>>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
>>> index 2af3a179c08e..0b1eceaef59f 100644
>>> --- a/arch/riscv/include/asm/kvm_host.h
>>> +++ b/arch/riscv/include/asm/kvm_host.h
>>> @@ -241,4 +241,6 @@ bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *=
vcpu);
>>>  void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
>>>  void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
>>>=20
>>> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu);
>>> +
>>>  #endif /* __RISCV_KVM_HOST_H__ */
>>> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
>>> index 3e0c7558320d..b56dc1650d2c 100644
>>> --- a/arch/riscv/kvm/Makefile
>>> +++ b/arch/riscv/kvm/Makefile
>>> @@ -9,6 +9,6 @@ ccflags-y :=3D -Ivirt/kvm -Iarch/riscv/kvm
>>>  kvm-objs :=3D $(common-objs-y)
>>>=20
>>>  kvm-objs +=3D main.o vm.o vmid.o tlb.o mmu.o
>>> -kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
>>> +kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o
>>>=20
>>>  obj-$(CONFIG_KVM)   +=3D kvm.o
>>> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
>>> index fbc04fe335ad..87b83fcf9a14 100644
>>> --- a/arch/riscv/kvm/vcpu_exit.c
>>> +++ b/arch/riscv/kvm/vcpu_exit.c
>>> @@ -534,6 +534,9 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run,
>>>                  (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
>>>                      ret =3D stage2_page_fault(vcpu, run, scause, stval=
);
>>>              break;
>>> +     case EXC_SUPERVISOR_SYSCALL:
>>> +             if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>>> +                     ret =3D kvm_riscv_vcpu_sbi_ecall(vcpu);
>>>      default:
>>>              break;
>>>      };
>>> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
>>> new file mode 100644
>>> index 000000000000..5793202eb514
>>> --- /dev/null
>>> +++ b/arch/riscv/kvm/vcpu_sbi.c
>>> @@ -0,0 +1,119 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/**
>>> + * Copyright (c) 2019 Western Digital Corporation or its affiliates.
>>> + *
>>> + * Authors:
>>> + *     Atish Patra <atish.patra@wdc.com>
>>> + */
>>> +
>>> +#include <linux/errno.h>
>>> +#include <linux/err.h>
>>> +#include <linux/kvm_host.h>
>>> +#include <asm/csr.h>
>>> +#include <asm/kvm_vcpu_timer.h>
>>> +
>>> +#define SBI_VERSION_MAJOR                    0
>>> +#define SBI_VERSION_MINOR                    1
>>> +
>>> +/* TODO: Handle traps due to unpriv load and redirect it back to VS-mo=
de */
>>=20
>> Ugh, another one of those? Can't you just figure out a way to recover
>> from the page fault? Also, you want to combine this with the instruction
>> load logic, so that we have a single place that guest address space
>> reads go through.
>=20
> Walking Guest page table would be more expensive compared to implementing
> a trap handling mechanism.
>=20
> We will be adding trap handling mechanism for reading instruction and rea=
ding
> load.
>=20
> Both these operations are different in following ways:
> 1. RISC-V instructions are variable length. We get to know exact instruct=
ion
>    length only after reading first 16bits
> 2. We need to set VSSTATUS.MXR bit when reading instruction for
>    execute-only Guest pages.

Yup, sounds like you could solve that with a trivial if() based on "read in=
struction" or not, no? If you want to, feel free to provide short versions =
that do only read ins/data, but I would really like to see the whole "data =
reads become guest reads" magic to be funneled through a single function (i=
n C, can be inline unrolled in asm of course)

>=20
>>=20
>>> +static unsigned long kvm_sbi_unpriv_load(const unsigned long *addr,
>>> +                                      struct kvm_vcpu *vcpu)
>>> +{
>>> +     unsigned long flags, val;
>>> +     unsigned long __hstatus, __sstatus;
>>> +
>>> +     local_irq_save(flags);
>>> +     __hstatus =3D csr_read(CSR_HSTATUS);
>>> +     __sstatus =3D csr_read(CSR_SSTATUS);
>>> +     csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS=
_SPRV);
>>> +     csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus);
>>> +     val =3D *addr;
>>> +     csr_write(CSR_HSTATUS, __hstatus);
>>> +     csr_write(CSR_SSTATUS, __sstatus);
>>> +     local_irq_restore(flags);
>>> +
>>> +     return val;
>>> +}
>>> +
>>> +static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu, u32 type)
>>> +{
>>> +     int i;
>>> +     struct kvm_vcpu *tmp;
>>> +
>>> +     kvm_for_each_vcpu(i, tmp, vcpu->kvm)
>>> +             tmp->arch.power_off =3D true;
>>> +     kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>>> +
>>> +     memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_even=
t));
>>> +     vcpu->run->system_event.type =3D type;
>>> +     vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
>>> +}
>>> +
>>> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu)
>>> +{
>>> +     int ret =3D 1;
>>> +     u64 next_cycle;
>>> +     int vcpuid;
>>> +     struct kvm_vcpu *remote_vcpu;
>>> +     ulong dhart_mask;
>>> +     struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
>>> +
>>> +     if (!cp)
>>> +             return -EINVAL;
>>> +     switch (cp->a7) {
>>> +     case SBI_SET_TIMER:
>>> +#if __riscv_xlen =3D=3D 32
>>> +             next_cycle =3D ((u64)cp->a1 << 32) | (u64)cp->a0;
>>> +#else
>>> +             next_cycle =3D (u64)cp->a0;
>>> +#endif
>>> +             kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
>>=20
>> Ah, this is where the timer set happens. I still don't understand how
>> this takes the frequency bit into account?
>=20
> Explained it in PATCH17 comments.
>=20
>>=20
>>> +             break;
>>> +     case SBI_CONSOLE_PUTCHAR:
>>> +             /* Not implemented */
>>> +             cp->a0 =3D -ENOTSUPP;
>>> +             break;
>>> +     case SBI_CONSOLE_GETCHAR:
>>> +             /* Not implemented */
>>> +             cp->a0 =3D -ENOTSUPP;
>>> +             break;
>>=20
>> These two should be covered by the default case.
>=20
> Sure, I will update.
>=20
>>=20
>>> +     case SBI_CLEAR_IPI:
>>> +             kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
>>> +             break;
>>> +     case SBI_SEND_IPI:
>>> +             dhart_mask =3D kvm_sbi_unpriv_load((unsigned long *)cp->a=
0, vcpu);
>>> +             for_each_set_bit(vcpuid, &dhart_mask, BITS_PER_LONG) {
>>> +                     remote_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, vcp=
uid);
>>> +                     kvm_riscv_vcpu_set_interrupt(remote_vcpu, IRQ_S_S=
OFT);
>>> +             }
>>> +             break;
>>> +     case SBI_SHUTDOWN:
>>> +             kvm_sbi_system_shutdown(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN);
>>> +             ret =3D 0;
>>> +             break;
>>> +     case SBI_REMOTE_FENCE_I:
>>> +             sbi_remote_fence_i(NULL);
>>> +             break;
>>> +     /*
>>> +      * TODO: There should be a way to call remote hfence.bvma.
>>> +      * Preferred method is now a SBI call. Until then, just flush
>>> +      * all tlbs.
>>> +      */
>>> +     case SBI_REMOTE_SFENCE_VMA:
>>> +             /*TODO: Parse vma range.*/
>>> +             sbi_remote_sfence_vma(NULL, 0, 0);
>>> +             break;
>>> +     case SBI_REMOTE_SFENCE_VMA_ASID:
>>> +             /*TODO: Parse vma range for given ASID */
>>> +             sbi_remote_sfence_vma(NULL, 0, 0);
>>> +             break;
>>> +     default:
>>> +             cp->a0 =3D ENOTSUPP;
>>> +             break;
>>=20
>> Please just send unsupported SBI events into user space.
>=20
> For unsupported SBI calls, we should be returning error to the
> Guest Linux so that do something about it. This is in accordance
> with the SBI spec.

That's up to user space (QEMU / kvmtool) to decide. If user space wants to =
implement the  console functions (like we do on s390), it should have the c=
hance to do so.

Alex

