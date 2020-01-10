Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BECD136C05
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 12:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgAJLfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 06:35:44 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42875 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbgAJLfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 06:35:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id q6so1466073wro.9
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 03:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/ktaB7I4rCYFrblp2jSw/SfgCdDKICa1HG8ihOdAKE=;
        b=ebrMAXn1+TXs9LnyCkB3PR/OuAwZiqV/OYuRpZtetve5p14eG2K+xbHRUKBbcFyf/G
         TOnxfF+q9GR9CUU9WJpgLPUqm6Ba0WV4XkEh/yiMERpNAOn/OfD+JjQRrcUxlDni9SDI
         Fv54XiPk5jWvnJLekH67bTnRxJ+0Ee1rvik4AoyLcZ5tuY5Fa1wA8MdljK1HpH/ZMsFR
         543nBq31OTu7OQouWAXYY+6jpbBr00K8N+ckPFlNWEhJsSCoA+8JuQyginKhUIklDZLQ
         tCmysW+OOTxWGJk/lQSesLoJUZ6oz6DQa7BiFZrPzvbk6j9DqSY/I/CDprGzm+KRWG71
         Xz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/ktaB7I4rCYFrblp2jSw/SfgCdDKICa1HG8ihOdAKE=;
        b=U7+x0K1tKNzsdNr/68igZVHEGHJw4CyDGB1N2CHfOLAL0IhL+C+BhU1Hs1EPRG7Ou6
         CIG23ohMwMZJwrVaLC1qINBRZeKVTXiSE0U9lZMG8nAuhMgR7X4m/fgCtZp/VpbT5mDg
         EhPCJ0SOYfwVGJHrsUEy/skbLMY4h9rTt1ALlKEb1thAno6Qw7CYiGSa7tHTlrF775oA
         irps0isBTMWpzuozHWC7a1xQ48ZX92e8/6grF8qADIWGpnBF1Fy5JAx+2/6JNymo/5cO
         oBaxBvm/RA6QShI/kTkobeyuXwgBistj++Pl5qHU1hA0KoVHF0fk40KgYp9WQYXlAH43
         FCNw==
X-Gm-Message-State: APjAAAVxmpZ+e9J3KJcpSVoMs8SSud8X3ihS7LT75bLw+/Wm+5IWmfyG
        Q5/mTNDSu/mSdyl1ovc5bHejDUuNSy2NEaRPTwgmCw==
X-Google-Smtp-Source: APXvYqwInXU5flZiyBwdhgpc5qOdt1m52bM5AvqsuW0e+jZf0LA8nOwVy8IP4NmDdFh2LxNKmQmt08D+v83qoK3Pngc=
X-Received: by 2002:a5d:690e:: with SMTP id t14mr3023379wru.65.1578656140235;
 Fri, 10 Jan 2020 03:35:40 -0800 (PST)
MIME-Version: 1.0
References: <20191225025945.108466-1-anup.patel@wdc.com> <20191225025945.108466-3-anup.patel@wdc.com>
 <c655ed3a-151e-0450-3439-d913ff22f5b1@arm.com> <CAAhSdy1XuwQGg=o0c957YfbOL9BMgzXFY08fYt4NOdoo=3NTzQ@mail.gmail.com>
 <70acbb6e-f076-8883-14bd-0b5df3c4fb2a@arm.com>
In-Reply-To: <70acbb6e-f076-8883-14bd-0b5df3c4fb2a@arm.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 10 Jan 2020 17:05:28 +0530
Message-ID: <CAAhSdy12is7QU5BHrDMGVnxHPm2soTHu62XQqkxPSnZCUdhVqA@mail.gmail.com>
Subject: Re: [kvmtool RFC PATCH 2/8] riscv: Initial skeletal support
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>, Will Deacon <will.deacon@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 3:17 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On 1/10/20 3:30 AM, Anup Patel wrote:
> > On Wed, Jan 8, 2020 at 6:52 PM Alexandru Elisei
> > <alexandru.elisei@arm.com> wrote:
> >> Hi,
> >>
> >> I don't know much about the RISC-V architecture, so I'm only going to comment on
> >> the more generic code.
> > Sure, no problem.
> >
> >> On 12/25/19 3:00 AM, Anup Patel wrote:
> >>> This patch adds initial skeletal KVMTOOL RISC-V support which
> >>> just compiles for RV32 and RV64 host.
> >>>
> >>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> >>> ---
> >>>  INSTALL                             |   7 +-
> >>>  Makefile                            |  15 +++-
> >>>  riscv/include/asm/kvm.h             | 127 ++++++++++++++++++++++++++++
> >>>  riscv/include/kvm/barrier.h         |  14 +++
> >>>  riscv/include/kvm/fdt-arch.h        |   4 +
> >>>  riscv/include/kvm/kvm-arch.h        |  58 +++++++++++++
> >>>  riscv/include/kvm/kvm-config-arch.h |   9 ++
> >>>  riscv/include/kvm/kvm-cpu-arch.h    |  49 +++++++++++
> >>>  riscv/ioport.c                      |  11 +++
> >>>  riscv/irq.c                         |  13 +++
> >>>  riscv/kvm-cpu.c                     |  64 ++++++++++++++
> >>>  riscv/kvm.c                         |  61 +++++++++++++
> >>>  util/update_headers.sh              |   2 +-
> >>>  13 files changed, 429 insertions(+), 5 deletions(-)
> >>>  create mode 100644 riscv/include/asm/kvm.h
> >>>  create mode 100644 riscv/include/kvm/barrier.h
> >>>  create mode 100644 riscv/include/kvm/fdt-arch.h
> >>>  create mode 100644 riscv/include/kvm/kvm-arch.h
> >>>  create mode 100644 riscv/include/kvm/kvm-config-arch.h
> >>>  create mode 100644 riscv/include/kvm/kvm-cpu-arch.h
> >>>  create mode 100644 riscv/ioport.c
> >>>  create mode 100644 riscv/irq.c
> >>>  create mode 100644 riscv/kvm-cpu.c
> >>>  create mode 100644 riscv/kvm.c
> >>>
> >>> diff --git a/INSTALL b/INSTALL
> >>> index ca8e022..951b123 100644
> >>> --- a/INSTALL
> >>> +++ b/INSTALL
> >>> @@ -26,8 +26,8 @@ For Fedora based systems:
> >>>  For OpenSUSE based systems:
> >>>       # zypper install glibc-devel-static
> >>>
> >>> -Architectures which require device tree (PowerPC, ARM, ARM64) also require
> >>> -libfdt.
> >>> +Architectures which require device tree (PowerPC, ARM, ARM64, RISC-V) also
> >>> +require libfdt.
> >>>       deb: $ sudo apt-get install libfdt-dev
> >>>       Fedora: # yum install libfdt-devel
> >>>       OpenSUSE: # zypper install libfdt1-devel
> >>> @@ -64,6 +64,7 @@ to the Linux name of the architecture. Architectures supported:
> >>>  - arm
> >>>  - arm64
> >>>  - mips
> >>> +- riscv
> >>>  If ARCH is not provided, the target architecture will be automatically
> >>>  determined by running "uname -m" on your host, resulting in a native build.
> >>>
> >>> @@ -81,7 +82,7 @@ On multiarch system you should be able to install those be appending
> >>>  the architecture name after the package (example for ARM64):
> >>>  $ sudo apt-get install libfdt-dev:arm64
> >>>
> >>> -PowerPC and ARM/ARM64 require libfdt to be installed. If you cannot use
> >>> +PowerPC, ARM/ARM64 and RISC-V require libfdt to be installed. If you cannot use
> >>>  precompiled mulitarch packages, you could either copy the required header and
> >>>  library files from an installed target system into the SYSROOT (you will need
> >>>  /usr/include/*fdt*.h and /usr/lib64/libfdt-v.v.v.so and its symlinks), or you
> >>> diff --git a/Makefile b/Makefile
> >>> index 3862112..972fa63 100644
> >>> --- a/Makefile
> >>> +++ b/Makefile
> >>> @@ -106,7 +106,8 @@ OBJS      += hw/i8042.o
> >>>
> >>>  # Translate uname -m into ARCH string
> >>>  ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
> >>> -       -e s/armv.*/arm/ -e s/aarch64.*/arm64/ -e s/mips64/mips/)
> >>> +       -e s/armv.*/arm/ -e s/aarch64.*/arm64/ -e s/mips64/mips/ \
> >>> +       -e s/riscv64/riscv/ -e s/riscv32/riscv/)
> >>>
> >>>  ifeq ($(ARCH),i386)
> >>>       ARCH         := x86
> >>> @@ -190,6 +191,18 @@ ifeq ($(ARCH),mips)
> >>>       OBJS            += mips/kvm.o
> >>>       OBJS            += mips/kvm-cpu.o
> >>>  endif
> >>> +
> >>> +# RISC-V (RV32 and RV64)
> >>> +ifeq ($(ARCH),riscv)
> >>> +     DEFINES         += -DCONFIG_RISCV
> >>> +     ARCH_INCLUDE    := riscv/include
> >>> +     OBJS            += riscv/ioport.o
> >>> +     OBJS            += riscv/irq.o
> >>> +     OBJS            += riscv/kvm.o
> >>> +     OBJS            += riscv/kvm-cpu.o
> >>> +
> >>> +     ARCH_WANT_LIBFDT := y
> >>> +endif
> >>>  ###
> >>>
> >>>  ifeq (,$(ARCH_INCLUDE))
> >>> diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
> >>> new file mode 100644
> >>> index 0000000..f4274c2
> >>> --- /dev/null
> >>> +++ b/riscv/include/asm/kvm.h
> >>> @@ -0,0 +1,127 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0 */
> >>> +/*
> >>> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> >>> + *
> >>> + * Authors:
> >>> + *     Anup Patel <anup.patel@wdc.com>
> >>> + */
> >>> +
> >>> +#ifndef __LINUX_KVM_RISCV_H
> >>> +#define __LINUX_KVM_RISCV_H
> >>> +
> >>> +#ifndef __ASSEMBLY__
> >>> +
> >>> +#include <linux/types.h>
> >>> +#include <asm/ptrace.h>
> >>> +
> >>> +#define __KVM_HAVE_READONLY_MEM
> >>> +
> >>> +#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> >>> +
> >>> +#define KVM_INTERRUPT_SET    -1U
> >>> +#define KVM_INTERRUPT_UNSET  -2U
> >>> +
> >>> +/* for KVM_GET_REGS and KVM_SET_REGS */
> >>> +struct kvm_regs {
> >>> +};
> >>> +
> >>> +/* for KVM_GET_FPU and KVM_SET_FPU */
> >>> +struct kvm_fpu {
> >>> +};
> >>> +
> >>> +/* KVM Debug exit structure */
> >>> +struct kvm_debug_exit_arch {
> >>> +};
> >>> +
> >>> +/* for KVM_SET_GUEST_DEBUG */
> >>> +struct kvm_guest_debug_arch {
> >>> +};
> >>> +
> >>> +/* definition of registers in kvm_run */
> >>> +struct kvm_sync_regs {
> >>> +};
> >>> +
> >>> +/* for KVM_GET_SREGS and KVM_SET_SREGS */
> >>> +struct kvm_sregs {
> >>> +};
> >>> +
> >>> +/* CONFIG registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >>> +struct kvm_riscv_config {
> >>> +     unsigned long isa;
> >>> +};
> >>> +
> >>> +/* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >>> +struct kvm_riscv_core {
> >>> +     struct user_regs_struct regs;
> >>> +     unsigned long mode;
> >>> +};
> >>> +
> >>> +/* Possible privilege modes for kvm_riscv_core */
> >>> +#define KVM_RISCV_MODE_S     1
> >>> +#define KVM_RISCV_MODE_U     0
> >>> +
> >>> +/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >>> +struct kvm_riscv_csr {
> >>> +     unsigned long sstatus;
> >>> +     unsigned long sie;
> >>> +     unsigned long stvec;
> >>> +     unsigned long sscratch;
> >>> +     unsigned long sepc;
> >>> +     unsigned long scause;
> >>> +     unsigned long stval;
> >>> +     unsigned long sip;
> >>> +     unsigned long satp;
> >>> +};
> >>> +
> >>> +/* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >>> +struct kvm_riscv_timer {
> >>> +     u64 frequency;
> >>> +     u64 time;
> >>> +     u64 compare;
> >>> +     u64 state;
> >>> +};
> >>> +
> >>> +/* Possible states for kvm_riscv_timer */
> >>> +#define KVM_RISCV_TIMER_STATE_OFF    0
> >>> +#define KVM_RISCV_TIMER_STATE_ON     1
> >>> +
> >>> +#define KVM_REG_SIZE(id)             \
> >>> +     (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> >>> +
> >>> +/* If you need to interpret the index values, here is the key: */
> >>> +#define KVM_REG_RISCV_TYPE_MASK              0x00000000FF000000
> >>> +#define KVM_REG_RISCV_TYPE_SHIFT     24
> >>> +
> >>> +/* Config registers are mapped as type 1 */
> >>> +#define KVM_REG_RISCV_CONFIG         (0x01 << KVM_REG_RISCV_TYPE_SHIFT)
> >>> +#define KVM_REG_RISCV_CONFIG_REG(name)       \
> >>> +     (offsetof(struct kvm_riscv_config, name) / sizeof(unsigned long))
> >>> +
> >>> +/* Core registers are mapped as type 2 */
> >>> +#define KVM_REG_RISCV_CORE           (0x02 << KVM_REG_RISCV_TYPE_SHIFT)
> >>> +#define KVM_REG_RISCV_CORE_REG(name) \
> >>> +             (offsetof(struct kvm_riscv_core, name) / sizeof(unsigned long))
> >>> +
> >>> +/* Control and status registers are mapped as type 3 */
> >>> +#define KVM_REG_RISCV_CSR            (0x03 << KVM_REG_RISCV_TYPE_SHIFT)
> >>> +#define KVM_REG_RISCV_CSR_REG(name)  \
> >>> +             (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
> >>> +
> >>> +/* Timer registers are mapped as type 4 */
> >>> +#define KVM_REG_RISCV_TIMER          (0x04 << KVM_REG_RISCV_TYPE_SHIFT)
> >>> +#define KVM_REG_RISCV_TIMER_REG(name)        \
> >>> +             (offsetof(struct kvm_riscv_timer, name) / sizeof(u64))
> >>> +
> >>> +/* F extension registers are mapped as type 5 */
> >>> +#define KVM_REG_RISCV_FP_F           (0x05 << KVM_REG_RISCV_TYPE_SHIFT)
> >>> +#define KVM_REG_RISCV_FP_F_REG(name) \
> >>> +             (offsetof(struct __riscv_f_ext_state, name) / sizeof(u32))
> >>> +
> >>> +/* D extension registers are mapped as type 6 */
> >>> +#define KVM_REG_RISCV_FP_D           (0x06 << KVM_REG_RISCV_TYPE_SHIFT)
> >>> +#define KVM_REG_RISCV_FP_D_REG(name) \
> >>> +             (offsetof(struct __riscv_d_ext_state, name) / sizeof(u64))
> >>> +
> >>> +#endif
> >>> +
> >>> +#endif /* __LINUX_KVM_RISCV_H */
> >>> diff --git a/riscv/include/kvm/barrier.h b/riscv/include/kvm/barrier.h
> >>> new file mode 100644
> >>> index 0000000..235f610
> >>> --- /dev/null
> >>> +++ b/riscv/include/kvm/barrier.h
> >>> @@ -0,0 +1,14 @@
> >>> +#ifndef KVM__KVM_BARRIER_H
> >>> +#define KVM__KVM_BARRIER_H
> >>> +
> >>> +#define nop()                __asm__ __volatile__ ("nop")
> >>> +
> >>> +#define RISCV_FENCE(p, s) \
> >>> +     __asm__ __volatile__ ("fence " #p "," #s : : : "memory")
> >>> +
> >>> +/* These barriers need to enforce ordering on both devices or memory. */
> >>> +#define mb()         RISCV_FENCE(iorw,iorw)
> >>> +#define rmb()                RISCV_FENCE(ir,ir)
> >>> +#define wmb()                RISCV_FENCE(ow,ow)
> >>> +
> >>> +#endif /* KVM__KVM_BARRIER_H */
> >>> diff --git a/riscv/include/kvm/fdt-arch.h b/riscv/include/kvm/fdt-arch.h
> >>> new file mode 100644
> >>> index 0000000..9450fc5
> >>> --- /dev/null
> >>> +++ b/riscv/include/kvm/fdt-arch.h
> >>> @@ -0,0 +1,4 @@
> >>> +#ifndef KVM__KVM_FDT_H
> >>> +#define KVM__KVM_FDT_H
> >>> +
> >>> +#endif /* KVM__KVM_FDT_H */
> >>> diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> >>> new file mode 100644
> >>> index 0000000..7e9c578
> >>> --- /dev/null
> >>> +++ b/riscv/include/kvm/kvm-arch.h
> >>> @@ -0,0 +1,58 @@
> >>> +#ifndef KVM__KVM_ARCH_H
> >>> +#define KVM__KVM_ARCH_H
> >>> +
> >>> +#include <stdbool.h>
> >>> +#include <linux/const.h>
> >>> +#include <linux/types.h>
> >>> +
> >>> +#define RISCV_IOPORT         0x00000000ULL
> >>> +#define RISCV_IOPORT_SIZE    0x00010000ULL
> >>> +#define RISCV_PLIC           0x0c000000ULL
> >>> +#define RISCV_PLIC_SIZE              0x04000000ULL
> >>> +#define RISCV_MMIO           0x10000000ULL
> >>> +#define RISCV_MMIO_SIZE              0x20000000ULL
> >>> +#define RISCV_PCI            0x30000000ULL
> >>> +#define RISCV_PCI_CFG_SIZE   0x10000000ULL
> >> In the DTB you're advertising the PCI node as CAM compatible, which is the right
> >> thing to do. Legacy PCI configuration space is 16MB, not 256MB (PCI Express is 256MB).
> > I was confused here so I did what was done for ARM. I will check with other
> > architectures and update like you suggested.
>
> For ARM, it's 16 MB (taken from arm/include/arm-common/kvm-arch.h)
>
> #define ARM_PCI_CFG_SIZE    (1ULL << 24)
>
> which was duplicated from include/kvm/pci.h:
>
> #define PCI_CFG_SIZE        (1ULL << 24)**
>
> It's not a question of what other architectures do, it's about kvmtool emulating
> the legacy PCI 3.0 protocol which uses 24 bits for device addressing. You can
> declare the PCI configuration space to be 256 MB (i.e 28 bit addresses), but
> kvmtool will only use the bottom 16MB.

Thanks for the PCI related explanation.

I will update PCI config size to 16M.

Regards,
Anup

>
> Thanks,
> Alex
> >
> >>> +#define RISCV_PCI_SIZE               0x50000000ULL
> >>> +#define RISCV_PCI_MMIO_SIZE  (RISCV_PCI_SIZE - RISCV_PCI_CFG_SIZE)
> >>> +
> >>> +#define RISCV_RAM            0x80000000ULL
> >> I'm not sure about the reasons for choosing RAM to start at 2GB. For arm we do the
> >> same, but qemu starts memory at 1GB and this mismatch has caused some issues in
> >> the past. For example, 32 bit kvm-unit-tests currently do not run under kvmtool
> >> because the text address is hardcoded to the qemu default value.
> > Actually in RISC-V world, it is kind of a un-documented standard that
> > RAM starts at
> > 2GB (0x80000000) for both RV32 and RV64. This is true for all existing HW,
> > QEMU RISC-V virt machine and here. This will be soon explicitly documented in
> > RISC-V Unix platform spec.
> >
> >> As a more general observation, I know that other architectures (like arm) declare
> >> the memory layout in hexadecimal numbers, but it might be a better idea to use the
> >> sizes from include/linux/sizes.h, since it makes the memory layout a lot more
> >> readable and mistakes are easier to spot.
> > Sure, I will try to use linux/sizes.h in next patch version.
> >
> >>> +
> >>> +#define RISCV_LOMAP_MAX_MEMORY       ((1ULL << 32) - RISCV_RAM)
> >>> +#define RISCV_HIMAP_MAX_MEMORY       ((1ULL << 40) - RISCV_RAM)
> >>> +
> >>> +#if __riscv_xlen == 64
> >>> +#define RISCV_MAX_MEMORY(kvm)        RISCV_HIMAP_MAX_MEMORY
> >>> +#elif __riscv_xlen == 32
> >>> +#define RISCV_MAX_MEMORY(kvm)        RISCV_LOMAP_MAX_MEMORY
> >>> +#endif
> >>> +
> >>> +#define KVM_IOPORT_AREA              RISCV_IOPORT
> >>> +#define KVM_PCI_CFG_AREA     RISCV_PCI
> >>> +#define KVM_PCI_MMIO_AREA    (KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
> >>> +#define KVM_VIRTIO_MMIO_AREA RISCV_MMIO
> >>> +
> >>> +#define KVM_IOEVENTFD_HAS_PIO        0
> >>> +
> >>> +#define KVM_IRQ_OFFSET               0
> >>> +
> >>> +#define KVM_VM_TYPE          0
> >>> +
> >>> +#define VIRTIO_DEFAULT_TRANS(kvm)    VIRTIO_MMIO
> >>> +
> >>> +#define VIRTIO_RING_ENDIAN   VIRTIO_ENDIAN_LE
> >>> +
> >>> +struct kvm;
> >>> +
> >>> +struct kvm_arch {
> >>> +};
> >>> +
> >>> +static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
> >>> +{
> >>> +     u64 limit = KVM_IOPORT_AREA + RISCV_IOPORT_SIZE;
> >>> +     return phys_addr >= KVM_IOPORT_AREA && phys_addr < limit;
> >>> +}
> >>> +
> >>> +enum irq_type;
> >>> +
> >>> +#endif /* KVM__KVM_ARCH_H */
> >>> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> >>> new file mode 100644
> >>> index 0000000..60c7333
> >>> --- /dev/null
> >>> +++ b/riscv/include/kvm/kvm-config-arch.h
> >>> @@ -0,0 +1,9 @@
> >>> +#ifndef KVM__KVM_CONFIG_ARCH_H
> >>> +#define KVM__KVM_CONFIG_ARCH_H
> >>> +
> >>> +#include "kvm/parse-options.h"
> >>> +
> >>> +struct kvm_config_arch {
> >>> +};
> >>> +
> >>> +#endif /* KVM__KVM_CONFIG_ARCH_H */
> >>> diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
> >>> new file mode 100644
> >>> index 0000000..09a50e8
> >>> --- /dev/null
> >>> +++ b/riscv/include/kvm/kvm-cpu-arch.h
> >>> @@ -0,0 +1,49 @@
> >>> +#ifndef KVM__KVM_CPU_ARCH_H
> >>> +#define KVM__KVM_CPU_ARCH_H
> >>> +
> >>> +#include <linux/kvm.h>
> >>> +#include <pthread.h>
> >>> +#include <stdbool.h>
> >>> +
> >>> +#include "kvm/kvm.h"
> >>> +
> >>> +struct kvm;
> >> Shouldn't kvm.h already have a definition for struct kvm? Also, the arm
> >> corresponding header doesn't have the include here, I don't think it's needed
> >> (unless I'm missing something).
> > Sure, I will drop this forward declaration here.
> >
> > Regards,
> > Anup
> >
> >> Thanks,
> >> Alex
> >>> +
> >>> +struct kvm_cpu {
> >>> +     pthread_t       thread;
> >>> +
> >>> +     unsigned long   cpu_id;
> >>> +
> >>> +     struct kvm      *kvm;
> >>> +     int             vcpu_fd;
> >>> +     struct kvm_run  *kvm_run;
> >>> +     struct kvm_cpu_task     *task;
> >>> +
> >>> +     u8              is_running;
> >>> +     u8              paused;
> >>> +     u8              needs_nmi;
> >>> +
> >>> +     struct kvm_coalesced_mmio_ring  *ring;
> >>> +};
> >>> +
> >>> +static inline bool kvm_cpu__emulate_io(struct kvm_cpu *vcpu, u16 port,
> >>> +                                    void *data, int direction,
> >>> +                                    int size, u32 count)
> >>> +{
> >>> +     return false;
> >>> +}
> >>> +
> >>> +static inline bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr,
> >>> +                                      u8 *data, u32 len, u8 is_write)
> >>> +{
> >>> +     if (riscv_addr_in_ioport_region(phys_addr)) {
> >>> +             int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
> >>> +             u16 port = (phys_addr - KVM_IOPORT_AREA) & USHRT_MAX;
> >>> +
> >>> +             return kvm__emulate_io(vcpu, port, data, direction, len, 1);
> >>> +     }
> >>> +
> >>> +     return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
> >>> +}
> >>> +
> >>> +#endif /* KVM__KVM_CPU_ARCH_H */
> >>> diff --git a/riscv/ioport.c b/riscv/ioport.c
> >>> new file mode 100644
> >>> index 0000000..bdd30b6
> >>> --- /dev/null
> >>> +++ b/riscv/ioport.c
> >>> @@ -0,0 +1,11 @@
> >>> +#include "kvm/ioport.h"
> >>> +#include "kvm/irq.h"
> >>> +
> >>> +void ioport__setup_arch(struct kvm *kvm)
> >>> +{
> >>> +}
> >>> +
> >>> +void ioport__map_irq(u8 *irq)
> >>> +{
> >>> +     *irq = irq__alloc_line();
> >>> +}
> >>> diff --git a/riscv/irq.c b/riscv/irq.c
> >>> new file mode 100644
> >>> index 0000000..8e605ef
> >>> --- /dev/null
> >>> +++ b/riscv/irq.c
> >>> @@ -0,0 +1,13 @@
> >>> +#include "kvm/kvm.h"
> >>> +#include "kvm/kvm-cpu.h"
> >>> +#include "kvm/irq.h"
> >>> +
> >>> +void kvm__irq_line(struct kvm *kvm, int irq, int level)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +void kvm__irq_trigger(struct kvm *kvm, int irq)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
> >>> new file mode 100644
> >>> index 0000000..e4b8fa5
> >>> --- /dev/null
> >>> +++ b/riscv/kvm-cpu.c
> >>> @@ -0,0 +1,64 @@
> >>> +#include "kvm/kvm-cpu.h"
> >>> +#include "kvm/kvm.h"
> >>> +#include "kvm/virtio.h"
> >>> +#include "kvm/term.h"
> >>> +
> >>> +#include <asm/ptrace.h>
> >>> +
> >>> +static int debug_fd;
> >>> +
> >>> +void kvm_cpu__set_debug_fd(int fd)
> >>> +{
> >>> +     debug_fd = fd;
> >>> +}
> >>> +
> >>> +int kvm_cpu__get_debug_fd(void)
> >>> +{
> >>> +     return debug_fd;
> >>> +}
> >>> +
> >>> +struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >>> +{
> >>> +     /* TODO: */
> >>> +     return NULL;
> >>> +}
> >>> +
> >>> +void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
> >>> +{
> >>> +}
> >>> +
> >>> +void kvm_cpu__delete(struct kvm_cpu *vcpu)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
> >>> +{
> >>> +     /* TODO: */
> >>> +     return false;
> >>> +}
> >>> +
> >>> +void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
> >>> +{
> >>> +     return VIRTIO_ENDIAN_LE;
> >>> +}
> >>> +
> >>> +void kvm_cpu__show_code(struct kvm_cpu *vcpu)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> diff --git a/riscv/kvm.c b/riscv/kvm.c
> >>> new file mode 100644
> >>> index 0000000..e816ef5
> >>> --- /dev/null
> >>> +++ b/riscv/kvm.c
> >>> @@ -0,0 +1,61 @@
> >>> +#include "kvm/kvm.h"
> >>> +#include "kvm/util.h"
> >>> +#include "kvm/fdt.h"
> >>> +
> >>> +#include <linux/kernel.h>
> >>> +#include <linux/kvm.h>
> >>> +#include <linux/sizes.h>
> >>> +
> >>> +struct kvm_ext kvm_req_ext[] = {
> >>> +     { DEFINE_KVM_EXT(KVM_CAP_ONE_REG) },
> >>> +     { 0, 0 },
> >>> +};
> >>> +
> >>> +bool kvm__arch_cpu_supports_vm(void)
> >>> +{
> >>> +     /* The KVM capability check is enough. */
> >>> +     return true;
> >>> +}
> >>> +
> >>> +void kvm__init_ram(struct kvm *kvm)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +void kvm__arch_delete_ram(struct kvm *kvm)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +void kvm__arch_read_term(struct kvm *kvm)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +void kvm__arch_set_cmdline(char *cmdline, bool video)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
> >>> +{
> >>> +     /* TODO: */
> >>> +}
> >>> +
> >>> +bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
> >>> +                              const char *kernel_cmdline)
> >>> +{
> >>> +     /* TODO: */
> >>> +     return true;
> >>> +}
> >>> +
> >>> +bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
> >>> +{
> >>> +     /* TODO: Firmware loading to be supported later. */
> >>> +     return false;
> >>> +}
> >>> +
> >>> +int kvm__arch_setup_firmware(struct kvm *kvm)
> >>> +{
> >>> +     return 0;
> >>> +}
> >>> diff --git a/util/update_headers.sh b/util/update_headers.sh
> >>> index bf87ef6..78eba1f 100755
> >>> --- a/util/update_headers.sh
> >>> +++ b/util/update_headers.sh
> >>> @@ -36,7 +36,7 @@ copy_optional_arch () {
> >>>       fi
> >>>  }
> >>>
> >>> -for arch in arm arm64 mips powerpc x86
> >>> +for arch in arm arm64 mips powerpc riscv x86
> >>>  do
> >>>       case "$arch" in
> >>>               arm) KVMTOOL_PATH=arm/aarch32 ;;
