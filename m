Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCAA1CF39E
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 13:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgELLsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 07:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgELLsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 07:48:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE462C061A0C;
        Tue, 12 May 2020 04:48:40 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id 50so14443416wrc.11;
        Tue, 12 May 2020 04:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CTJi1QXsJ02noBgV/+PPAwhVuw/esxdNNMHb24PYcas=;
        b=LEeRlVOTwPoTYgmmZ6QQdu0LvJfr/B5NnJJk6tQVDRHeUBJ+CJkb7cDeFSFMX+AuVK
         v8e9dDawnD5xFUlMjBaeozCy5uz69MfZNtzeSvnRz/7jkeCrpb25QTPuSuMoaAO4wogP
         K7T4IgXFUZup0mDkmPPzzY5kc0KTcVsZ4qPoCszhjYg+94yar6ibxkoCMaXL7SOtv6cd
         pNErdBUePJmh8vWoLcSGsqoocNMZOmB9dE9ISkwzcU7VpOWl3yNLYTJkjodGm5vDKbMc
         kHUYlVg9yUcQCQkOj4ygYEXcvOfsRDCgKf23BfntG2mFxqYNJhDhZHk5Ly8FvZOG/L/q
         2KXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CTJi1QXsJ02noBgV/+PPAwhVuw/esxdNNMHb24PYcas=;
        b=rLzWIV/vXOxYP2w7+J67806mGBDQUBKrFYHo0hEI22jwM5YXd/jeki7pZeRSCjoGvU
         7oDxecjAITN56K4OkKgom3LzvYeGkhtLktS4gf1GFrPDc/QanC1k2PO27ZDVmIT+IwAJ
         rAwVuTQ7HnS7KpVJNOBIhQ3kDxxADmXQsgN4y0G+DZ6fIKRBFe6GcP7RFE0ogerUYXEt
         JVaS5Dacgn8Y6VGGJHoeQvAtKwAe5YaK2+fND47kMkrXtvo5v5WUWc2i+6PoKya8rtmA
         Wz0U29znt5Ss6OR/K7FimMZrKi/AWmUnY+ucGeFu0+qf5q7wQ32JNy9UJk2ouNt+lDow
         FNIw==
X-Gm-Message-State: AGi0Pua6vFfKY2t+H8s9YxO84wq6yy6s1yjUriUlPjV19aeNWdik7rWu
        16m8uSYgQLrzRk4oFbyI3095p8g2BSzLerceBsU=
X-Google-Smtp-Source: APiQypKmd5EXNNu7gVWI0u5itf6CuUbqgM3M5keOof0Q7bW28Qzbu0MAvOxeMh35YC/VGU8iyg0PSNor7sa1MzuN9pY=
X-Received: by 2002:adf:e989:: with SMTP id h9mr8773052wrm.420.1589284119378;
 Tue, 12 May 2020 04:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com> <1589279480-27722-11-git-send-email-chenhc@lemote.com>
In-Reply-To: <1589279480-27722-11-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Tue, 12 May 2020 13:48:26 +0200
Message-ID: <CAHiYmc4NxYVD1hhfq88YRNiu6oCVMT05Y9RFsHh1un2WAkyU9g@mail.gmail.com>
Subject: Re: [PATCH V4 10/14] KVM: MIPS: Add Loongson-3 Virtual IPI interrupt support
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D1=83=D1=82=D0=BE, 12. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:35 Huacai Chen <=
chenhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> This patch add Loongson-3 Virtual IPI interrupt support in the kernel.
> The current implementation of IPI emulation in QEMU is based on GIC for
> MIPS, but Loongson-3 doesn't use GIC. Furthermore, IPI emulation in QEMU
> is too expensive for performance (because of too many context switches
> between Host and Guest). With current solution, the IPI delay may even
> cause RCU stall warnings in a multi-core Guest. So, we design a faster
> solution that emulate IPI interrupt in kernel (only used by Loongson-3
> now).
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>

>  arch/mips/include/asm/kvm_host.h |  32 ++++++
>  arch/mips/kvm/Makefile           |   3 +
>  arch/mips/kvm/emulate.c          |  23 ++++-
>  arch/mips/kvm/loongson_ipi.c     | 214 +++++++++++++++++++++++++++++++++=
++++++
>  arch/mips/kvm/mips.c             |   6 ++
>  5 files changed, 277 insertions(+), 1 deletion(-)
>  create mode 100644 arch/mips/kvm/loongson_ipi.c
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm=
_host.h
> index a7758c0..f165902 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -23,6 +23,8 @@
>  #include <asm/inst.h>
>  #include <asm/mipsregs.h>
>
> +#include <kvm/iodev.h>
> +
>  /* MIPS KVM register ids */
>  #define MIPS_CP0_32(_R, _S)                                    \
>         (KVM_REG_MIPS_CP0 | KVM_REG_SIZE_U32 | (8 * (_R) + (_S)))
> @@ -181,11 +183,39 @@ struct kvm_vcpu_stat {
>  struct kvm_arch_memory_slot {
>  };
>
> +#ifdef CONFIG_CPU_LOONGSON64
> +struct ipi_state {
> +       uint32_t status;
> +       uint32_t en;
> +       uint32_t set;
> +       uint32_t clear;
> +       uint64_t buf[4];
> +};
> +
> +struct loongson_kvm_ipi;
> +
> +struct ipi_io_device {
> +       int node_id;
> +       struct loongson_kvm_ipi *ipi;
> +       struct kvm_io_device device;
> +};
> +
> +struct loongson_kvm_ipi {
> +       spinlock_t lock;
> +       struct kvm *kvm;
> +       struct ipi_state ipistate[16];
> +       struct ipi_io_device dev_ipi[4];
> +};
> +#endif
> +
>  struct kvm_arch {
>         /* Guest physical mm */
>         struct mm_struct gpa_mm;
>         /* Mask of CPUs needing GPA ASID flush */
>         cpumask_t asid_flush_mask;
> +#ifdef CONFIG_CPU_LOONGSON64
> +       struct loongson_kvm_ipi ipi;
> +#endif
>  };
>
>  #define N_MIPS_COPROC_REGS     32
> @@ -1133,6 +1163,8 @@ extern int kvm_mips_trans_mtc0(union mips_instructi=
on inst, u32 *opc,
>  /* Misc */
>  extern void kvm_mips_dump_stats(struct kvm_vcpu *vcpu);
>  extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
> +extern int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> +                            struct kvm_mips_interrupt *irq);
>
>  static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
> index 0a3cef6..506c4ac 100644
> --- a/arch/mips/kvm/Makefile
> +++ b/arch/mips/kvm/Makefile
> @@ -13,6 +13,9 @@ kvm-objs :=3D $(common-objs-y) mips.o emulate.o entry.o=
 \
>             fpu.o
>  kvm-objs +=3D hypcall.o
>  kvm-objs +=3D mmu.o
> +ifdef CONFIG_CPU_LOONGSON64
> +kvm-objs +=3D loongson_ipi.o
> +endif
>
>  ifdef CONFIG_KVM_MIPS_VZ
>  kvm-objs               +=3D vz.o
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 754094b..3946499 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -1600,6 +1600,7 @@ enum emulation_result kvm_mips_emulate_store(union =
mips_instruction inst,
>                                              struct kvm_run *run,
>                                              struct kvm_vcpu *vcpu)
>  {
> +       int r;
>         enum emulation_result er;
>         u32 rt;
>         void *data =3D run->mmio.data;
> @@ -1666,9 +1667,18 @@ enum emulation_result kvm_mips_emulate_store(union=
 mips_instruction inst,
>                 goto out_fail;
>         }
>
> -       run->mmio.is_write =3D 1;
>         vcpu->mmio_needed =3D 1;
> +       run->mmio.is_write =3D 1;
>         vcpu->mmio_is_write =3D 1;
> +
> +       r =3D kvm_io_bus_write(vcpu, KVM_MMIO_BUS,
> +                       run->mmio.phys_addr, run->mmio.len, data);
> +
> +       if (!r) {
> +               vcpu->mmio_needed =3D 0;
> +               return EMULATE_DONE;
> +       }
> +
>         return EMULATE_DO_MMIO;
>
>  out_fail:
> @@ -1681,6 +1691,7 @@ enum emulation_result kvm_mips_emulate_load(union m=
ips_instruction inst,
>                                             u32 cause, struct kvm_run *ru=
n,
>                                             struct kvm_vcpu *vcpu)
>  {
> +       int r;
>         enum emulation_result er;
>         unsigned long curr_pc;
>         u32 op, rt;
> @@ -1745,6 +1756,16 @@ enum emulation_result kvm_mips_emulate_load(union =
mips_instruction inst,
>
>         run->mmio.is_write =3D 0;
>         vcpu->mmio_is_write =3D 0;
> +
> +       r =3D kvm_io_bus_read(vcpu, KVM_MMIO_BUS,
> +                       run->mmio.phys_addr, run->mmio.len, run->mmio.dat=
a);
> +
> +       if (!r) {
> +               kvm_mips_complete_mmio_load(vcpu, run);
> +               vcpu->mmio_needed =3D 0;
> +               return EMULATE_DONE;
> +       }
> +
>         return EMULATE_DO_MMIO;
>  }
>
> diff --git a/arch/mips/kvm/loongson_ipi.c b/arch/mips/kvm/loongson_ipi.c
> new file mode 100644
> index 00000000..3681fc8
> --- /dev/null
> +++ b/arch/mips/kvm/loongson_ipi.c
> @@ -0,0 +1,214 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Loongson-3 Virtual IPI interrupt support.
> + *
> + * Copyright (C) 2019  Loongson Technologies, Inc.  All rights reserved.
> + *
> + * Authors: Chen Zhu <zhuchen@loongson.cn>
> + * Authors: Huacai Chen <chenhc@lemote.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#define IPI_BASE            0x3ff01000ULL
> +
> +#define CORE0_STATUS_OFF       0x000
> +#define CORE0_EN_OFF           0x004
> +#define CORE0_SET_OFF          0x008
> +#define CORE0_CLEAR_OFF        0x00c
> +#define CORE0_BUF_20           0x020
> +#define CORE0_BUF_28           0x028
> +#define CORE0_BUF_30           0x030
> +#define CORE0_BUF_38           0x038
> +
> +#define CORE1_STATUS_OFF       0x100
> +#define CORE1_EN_OFF           0x104
> +#define CORE1_SET_OFF          0x108
> +#define CORE1_CLEAR_OFF        0x10c
> +#define CORE1_BUF_20           0x120
> +#define CORE1_BUF_28           0x128
> +#define CORE1_BUF_30           0x130
> +#define CORE1_BUF_38           0x138
> +
> +#define CORE2_STATUS_OFF       0x200
> +#define CORE2_EN_OFF           0x204
> +#define CORE2_SET_OFF          0x208
> +#define CORE2_CLEAR_OFF        0x20c
> +#define CORE2_BUF_20           0x220
> +#define CORE2_BUF_28           0x228
> +#define CORE2_BUF_30           0x230
> +#define CORE2_BUF_38           0x238
> +
> +#define CORE3_STATUS_OFF       0x300
> +#define CORE3_EN_OFF           0x304
> +#define CORE3_SET_OFF          0x308
> +#define CORE3_CLEAR_OFF        0x30c
> +#define CORE3_BUF_20           0x320
> +#define CORE3_BUF_28           0x328
> +#define CORE3_BUF_30           0x330
> +#define CORE3_BUF_38           0x338
> +
> +static int loongson_vipi_read(struct loongson_kvm_ipi *ipi,
> +                               gpa_t addr, int len, void *val)
> +{
> +       uint32_t core =3D (addr >> 8) & 3;
> +       uint32_t node =3D (addr >> 44) & 3;
> +       uint32_t id =3D core + node * 4;
> +       uint64_t offset =3D addr & 0xff;
> +       void *pbuf;
> +       struct ipi_state *s =3D &(ipi->ipistate[id]);
> +
> +       BUG_ON(offset & (len - 1));
> +
> +       switch (offset) {
> +       case CORE0_STATUS_OFF:
> +               *(uint64_t *)val =3D s->status;
> +               break;
> +
> +       case CORE0_EN_OFF:
> +               *(uint64_t *)val =3D s->en;
> +               break;
> +
> +       case CORE0_SET_OFF:
> +               *(uint64_t *)val =3D 0;
> +               break;
> +
> +       case CORE0_CLEAR_OFF:
> +               *(uint64_t *)val =3D 0;
> +               break;
> +
> +       case CORE0_BUF_20 ... CORE0_BUF_38:
> +               pbuf =3D (void *)s->buf + (offset - 0x20);
> +               if (len =3D=3D 8)
> +                       *(uint64_t *)val =3D *(uint64_t *)pbuf;
> +               else /* Assume len =3D=3D 4 */
> +                       *(uint32_t *)val =3D *(uint32_t *)pbuf;
> +               break;
> +
> +       default:
> +               pr_notice("%s with unknown addr %llx\n", __func__, addr);
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static int loongson_vipi_write(struct loongson_kvm_ipi *ipi,
> +                               gpa_t addr, int len, const void *val)
> +{
> +       uint32_t core =3D (addr >> 8) & 3;
> +       uint32_t node =3D (addr >> 44) & 3;
> +       uint32_t id =3D core + node * 4;
> +       uint64_t data, offset =3D addr & 0xff;
> +       void *pbuf;
> +       struct kvm *kvm =3D ipi->kvm;
> +       struct kvm_mips_interrupt irq;
> +       struct ipi_state *s =3D &(ipi->ipistate[id]);
> +
> +       data =3D *(uint64_t *)val;
> +       BUG_ON(offset & (len - 1));
> +
> +       switch (offset) {
> +       case CORE0_STATUS_OFF:
> +               break;
> +
> +       case CORE0_EN_OFF:
> +               s->en =3D data;
> +               break;
> +
> +       case CORE0_SET_OFF:
> +               s->status |=3D data;
> +               irq.cpu =3D id;
> +               irq.irq =3D 6;
> +               kvm_vcpu_ioctl_interrupt(kvm->vcpus[id], &irq);
> +               break;
> +
> +       case CORE0_CLEAR_OFF:
> +               s->status &=3D ~data;
> +               if (!s->status) {
> +                       irq.cpu =3D id;
> +                       irq.irq =3D -6;
> +                       kvm_vcpu_ioctl_interrupt(kvm->vcpus[id], &irq);
> +               }
> +               break;
> +
> +       case CORE0_BUF_20 ... CORE0_BUF_38:
> +               pbuf =3D (void *)s->buf + (offset - 0x20);
> +               if (len =3D=3D 8)
> +                       *(uint64_t *)pbuf =3D (uint64_t)data;
> +               else /* Assume len =3D=3D 4 */
> +                       *(uint32_t *)pbuf =3D (uint32_t)data;
> +               break;
> +
> +       default:
> +               pr_notice("%s with unknown addr %llx\n", __func__, addr);
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static int kvm_ipi_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev=
,
> +                       gpa_t addr, int len, void *val)
> +{
> +       unsigned long flags;
> +       struct loongson_kvm_ipi *ipi;
> +       struct ipi_io_device *ipi_device;
> +
> +       ipi_device =3D container_of(dev, struct ipi_io_device, device);
> +       ipi =3D ipi_device->ipi;
> +
> +       spin_lock_irqsave(&ipi->lock, flags);
> +       loongson_vipi_read(ipi, addr, len, val);
> +       spin_unlock_irqrestore(&ipi->lock, flags);
> +
> +       return 0;
> +}
> +
> +static int kvm_ipi_write(struct kvm_vcpu *vcpu, struct kvm_io_device *de=
v,
> +                       gpa_t addr, int len, const void *val)
> +{
> +       unsigned long flags;
> +       struct loongson_kvm_ipi *ipi;
> +       struct ipi_io_device *ipi_device;
> +
> +       ipi_device =3D container_of(dev, struct ipi_io_device, device);
> +       ipi =3D ipi_device->ipi;
> +
> +       spin_lock_irqsave(&ipi->lock, flags);
> +       loongson_vipi_write(ipi, addr, len, val);
> +       spin_unlock_irqrestore(&ipi->lock, flags);
> +
> +       return 0;
> +}
> +
> +static const struct kvm_io_device_ops kvm_ipi_ops =3D {
> +       .read     =3D kvm_ipi_read,
> +       .write    =3D kvm_ipi_write,
> +};
> +
> +void kvm_init_loongson_ipi(struct kvm *kvm)
> +{
> +       int i;
> +       unsigned long addr;
> +       struct loongson_kvm_ipi *s;
> +       struct kvm_io_device *device;
> +
> +       s =3D &kvm->arch.ipi;
> +       s->kvm =3D kvm;
> +       spin_lock_init(&s->lock);
> +
> +       /*
> +        * Initialize IPI device
> +        */
> +       for (i =3D 0; i < 4; i++) {
> +               device =3D &s->dev_ipi[i].device;
> +               kvm_iodevice_init(device, &kvm_ipi_ops);
> +               addr =3D (((unsigned long)i) << 44) + IPI_BASE;
> +               mutex_lock(&kvm->slots_lock);
> +               kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, addr, 0x400, d=
evice);
> +               mutex_unlock(&kvm->slots_lock);
> +               s->dev_ipi[i].ipi =3D s;
> +               s->dev_ipi[i].node_id =3D i;
> +       }
> +}
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 5ca122c..ed989ef 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -128,6 +128,8 @@ int kvm_arch_check_processor_compat(void *opaque)
>         return 0;
>  }
>
> +extern void kvm_init_loongson_ipi(struct kvm *kvm);
> +
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>         switch (type) {
> @@ -147,6 +149,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long =
type)
>         if (!kvm->arch.gpa_mm.pgd)
>                 return -ENOMEM;
>
> +#ifdef CONFIG_CPU_LOONGSON64
> +       kvm_init_loongson_ipi(kvm);
> +#endif
> +
>         return 0;
>  }
>
> --
> 2.7.0
>
