Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2006146FE5C
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbhLJKEl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 10 Dec 2021 05:04:41 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:32907 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239870AbhLJKEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:04:40 -0500
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J9RHP68dtzcdDG;
        Fri, 10 Dec 2021 18:00:49 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 18:01:03 +0800
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 18:01:03 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Fri, 10 Dec 2021 18:01:03 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Anup Patel <anup@brainfault.org>
CC:     QEMU Developers <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        KVM General <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        "wanbo (G)" <wanbo13@huawei.com>,
        "limingwang (A)" <limingwang@huawei.com>
Subject: RE: [PATCH v1 07/12] target/riscv: Support setting external interrupt
 by KVM
Thread-Topic: [PATCH v1 07/12] target/riscv: Support setting external
 interrupt by KVM
Thread-Index: AQHX3eLOQYyIjsANI0SxhcVCQ7WQtqwgCrqAgAuTD2A=
Date:   Fri, 10 Dec 2021 10:01:03 +0000
Message-ID: <aa0f6d5e285f4d3992d8ab018d7c5c40@huawei.com>
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-8-jiangyifei@huawei.com>
 <CAAhSdy3suxztJYmOtEdtY+bpvESACc4QbPbv0jNL00qpw0WeUw@mail.gmail.com>
In-Reply-To: <CAAhSdy3suxztJYmOtEdtY+bpvESACc4QbPbv0jNL00qpw0WeUw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.186.236]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> -----Original Message-----
> From: kvm-riscv [mailto:kvm-riscv-bounces@lists.infradead.org] On Behalf Of
> Anup Patel
> Sent: Friday, December 3, 2021 5:15 PM
> To: Jiangyifei <jiangyifei@huawei.com>
> Cc: QEMU Developers <qemu-devel@nongnu.org>; open list:RISC-V
> <qemu-riscv@nongnu.org>; kvm-riscv@lists.infradead.org; KVM General
> <kvm@vger.kernel.org>; libvir-list@redhat.com; Anup Patel
> <anup.patel@wdc.com>; Palmer Dabbelt <palmer@dabbelt.com>; Alistair
> Francis <Alistair.Francis@wdc.com>; Bin Meng <bin.meng@windriver.com>;
> Fanliang (EulerOS) <fanliang@huawei.com>; Wubin (H)
> <wu.wubin@huawei.com>; Wanghaibin (D) <wanghaibin.wang@huawei.com>;
> wanbo (G) <wanbo13@huawei.com>; limingwang (A)
> <limingwang@huawei.com>
> Subject: Re: [PATCH v1 07/12] target/riscv: Support setting external interrupt
> by KVM
> 
> On Sat, Nov 20, 2021 at 1:17 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
> >
> > Extend riscv_cpu_update_mip() to support setting external interrupt by
> > KVM. It will call kvm_riscv_set_irq() to change the IRQ state in the
> > KVM module When kvm is enabled and the MIP_SEIP bit is set in "mask"
> >
> > In addition, bacause target/riscv/cpu_helper.c is used to TCG, so move
> > riscv_cpu_update_mip() to target/riscv/cpu.c from
> > target/riscv/cpu_helper.c
> >
> > Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> > Signed-off-by: Mingwang Li <limingwang@huawei.com>
> > Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> > ---
> >  target/riscv/cpu.c        | 34 ++++++++++++++++++++++++++++++++++
> >  target/riscv/cpu_helper.c | 27 ---------------------------
> >  target/riscv/kvm-stub.c   |  5 +++++
> >  target/riscv/kvm.c        | 20 ++++++++++++++++++++
> >  target/riscv/kvm_riscv.h  |  1 +
> >  5 files changed, 60 insertions(+), 27 deletions(-)
> >
> > diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c index
> > 1c944872a3..a464845c99 100644
> > --- a/target/riscv/cpu.c
> > +++ b/target/riscv/cpu.c
> > @@ -21,6 +21,7 @@
> >  #include "qemu/qemu-print.h"
> >  #include "qemu/ctype.h"
> >  #include "qemu/log.h"
> > +#include "qemu/main-loop.h"
> >  #include "cpu.h"
> >  #include "internals.h"
> >  #include "exec/exec-all.h"
> > @@ -131,6 +132,39 @@ static void set_feature(CPURISCVState *env, int
> feature)
> >      env->features |= (1ULL << feature);  }
> >
> > +#ifndef CONFIG_USER_ONLY
> > +uint32_t riscv_cpu_update_mip(RISCVCPU *cpu, uint32_t mask, uint32_t
> > +value) {
> > +    CPURISCVState *env = &cpu->env;
> > +    CPUState *cs = CPU(cpu);
> > +    uint32_t old = env->mip;
> > +    bool locked = false;
> > +
> > +    if (!qemu_mutex_iothread_locked()) {
> > +        locked = true;
> > +        qemu_mutex_lock_iothread();
> > +    }
> > +
> > +    env->mip = (env->mip & ~mask) | (value & mask);
> > +
> > +    if (kvm_enabled() && (mask & MIP_SEIP)) {
> > +        kvm_riscv_set_irq(RISCV_CPU(cpu), IRQ_S_EXT, value &
> MIP_SEIP);
> > +    }
> > +
> > +    if (env->mip) {
> > +        cpu_interrupt(cs, CPU_INTERRUPT_HARD);
> > +    } else {
> > +        cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
> > +    }
> > +
> > +    if (locked) {
> > +        qemu_mutex_unlock_iothread();
> > +    }
> > +
> > +    return old;
> > +}
> > +#endif
> > +
> 
> We should not change riscv_cpu_update_mip() for injecting KVM interrupts
> because this function touches the user-space state of MIP csr but for KVM the
> SIP csr state is always in kernel-space.
> 
> Further, the KVM kernel-space ensures synchronization so we don't need to do
> qemu_mutex_lock/unlock_iothread() for KVM interrupts.
> 
> I would suggest to extend riscv_cpu_set_irq() for KVM interrupts. When KVM is
> enabled, the riscv_cpu_set_irq() should throw warning/abort for any interrupt
> other than S-mode external interrupts.
> 
> Regards,
> Anup
> 

Thanks, it will be modified in the next series.

Yifei

> >  static void set_resetvec(CPURISCVState *env, target_ulong resetvec)
> > {  #ifndef CONFIG_USER_ONLY diff --git a/target/riscv/cpu_helper.c
> > b/target/riscv/cpu_helper.c index 9eeed38c7e..5e36c35b15 100644
> > --- a/target/riscv/cpu_helper.c
> > +++ b/target/riscv/cpu_helper.c
> > @@ -286,33 +286,6 @@ int riscv_cpu_claim_interrupts(RISCVCPU *cpu,
> uint32_t interrupts)
> >      }
> >  }
> >
> > -uint32_t riscv_cpu_update_mip(RISCVCPU *cpu, uint32_t mask, uint32_t
> > value) -{
> > -    CPURISCVState *env = &cpu->env;
> > -    CPUState *cs = CPU(cpu);
> > -    uint32_t old = env->mip;
> > -    bool locked = false;
> > -
> > -    if (!qemu_mutex_iothread_locked()) {
> > -        locked = true;
> > -        qemu_mutex_lock_iothread();
> > -    }
> > -
> > -    env->mip = (env->mip & ~mask) | (value & mask);
> > -
> > -    if (env->mip) {
> > -        cpu_interrupt(cs, CPU_INTERRUPT_HARD);
> > -    } else {
> > -        cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
> > -    }
> > -
> > -    if (locked) {
> > -        qemu_mutex_unlock_iothread();
> > -    }
> > -
> > -    return old;
> > -}
> > -
> >  void riscv_cpu_set_rdtime_fn(CPURISCVState *env, uint64_t
> (*fn)(uint32_t),
> >                               uint32_t arg)  { diff --git
> > a/target/riscv/kvm-stub.c b/target/riscv/kvm-stub.c index
> > 39b96fe3f4..4e8fc31a21 100644
> > --- a/target/riscv/kvm-stub.c
> > +++ b/target/riscv/kvm-stub.c
> > @@ -23,3 +23,8 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)  {
> >      abort();
> >  }
> > +
> > +void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level) {
> > +    abort();
> > +}
> > diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c index
> > 7f3ffcc2b4..8da2648d1a 100644
> > --- a/target/riscv/kvm.c
> > +++ b/target/riscv/kvm.c
> > @@ -458,6 +458,26 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
> >      env->satp = 0;
> >  }
> >
> > +void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level) {
> > +    int ret;
> > +    unsigned virq = level ? KVM_INTERRUPT_SET :
> KVM_INTERRUPT_UNSET;
> > +
> > +    if (irq != IRQ_S_EXT) {
> > +        return;
> > +    }
> > +
> > +    if (!kvm_enabled()) {
> > +        return;
> > +    }
> > +
> > +    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_INTERRUPT, &virq);
> > +    if (ret < 0) {
> > +        perror("Set irq failed");
> > +        abort();
> > +    }
> > +}
> > +
> >  bool kvm_arch_cpu_check_are_resettable(void)
> >  {
> >      return true;
> > diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h index
> > f38c82bf59..ed281bdce0 100644
> > --- a/target/riscv/kvm_riscv.h
> > +++ b/target/riscv/kvm_riscv.h
> > @@ -20,5 +20,6 @@
> >  #define QEMU_KVM_RISCV_H
> >
> >  void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
> > +void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
> >
> >  #endif
> > --
> > 2.19.1
> >
> >
> > --
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv
> 
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
