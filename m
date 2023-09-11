Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7D179A2AB
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 07:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbjIKFAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 01:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjIKFAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 01:00:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D0ECCA;
        Sun, 10 Sep 2023 21:59:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1B3C433CD;
        Mon, 11 Sep 2023 04:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694408398;
        bh=gCvtehknDUl3QH9SKtUiHlsPsjGZ5E9iz3pDBI9XNPQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ppadIEtmXfym/HDY8Sz8hYSKkqPLBUKsm7ZVOA/O2uf8x0DPUef8pbBABwkn3RYT1
         95+ilGgKsMRBep7O7A5WJOqPXtmxgonK7P34IRyYZXuHie/zIdHHnOssqMgW28gkJI
         FZLCGD+0EiGVTdwlBAQ3n9gL+z6n5n7pncglIhKHCOllezRRCexEt3AZq0aXeGUNcB
         CyJ9Im65c50u9lAioCD133vj9Pw25LaMDFGWGyFEjHlOKS4ToCHh8WvHfa9dZbO74q
         JJFHiG/Nm6b8Ww+r99kKNlITnlwjqi7uR1Atc1fXKHInNM+UY/iwNJFOYh8wVOK8J2
         NjYUb6oFGSg6w==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-52a23227567so5101493a12.0;
        Sun, 10 Sep 2023 21:59:57 -0700 (PDT)
X-Gm-Message-State: AOJu0YwZvULgKJcyNtk+buGCZDdZjx1StEVoHcFqgQIxjo6gRLmwBxJP
        CiKYG+dGnLMrwE6hrfpmZkW771xFp6UCY/tQz6s=
X-Google-Smtp-Source: AGHT+IEH6WwMxSKLtFFXUphU0ngn8X1dAuSlfOIteHCH5lBq1zmzW/RyeKvWID3SVfeLdbpU6FQL+3+D8g+Hd6PjyOU=
X-Received: by 2002:a17:906:3117:b0:99b:6e54:bd6e with SMTP id
 23-20020a170906311700b0099b6e54bd6emr6572749ejx.56.1694408396235; Sun, 10 Sep
 2023 21:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn> <20230831083020.2187109-2-zhaotianrui@loongson.cn>
In-Reply-To: <20230831083020.2187109-2-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 11 Sep 2023 12:59:43 +0800
X-Gmail-Original-Message-ID: <CAAhV-H64c=yDfTpWcvH3LXceJ+Eox0bboLSoq2w+=_ZuyU9jVw@mail.gmail.com>
Message-ID: <CAAhV-H64c=yDfTpWcvH3LXceJ+Eox0bboLSoq2w+=_ZuyU9jVw@mail.gmail.com>
Subject: Re: [PATCH v20 01/30] LoongArch: KVM: Add kvm related header files
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Tianrui,

On Thu, Aug 31, 2023 at 4:30=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
> Add LoongArch KVM related header files, including kvm.h,
> kvm_host.h, kvm_types.h. All of those are about LoongArch
> virtualization features and kvm interfaces.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h  | 238 +++++++++++++++++++++++++
>  arch/loongarch/include/asm/kvm_types.h |  11 ++
>  arch/loongarch/include/uapi/asm/kvm.h  | 101 +++++++++++
>  include/uapi/linux/kvm.h               |   9 +
>  4 files changed, 359 insertions(+)
>  create mode 100644 arch/loongarch/include/asm/kvm_host.h
>  create mode 100644 arch/loongarch/include/asm/kvm_types.h
>  create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> new file mode 100644
> index 0000000000..9f23ddaaae
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -0,0 +1,238 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_LOONGARCH_KVM_HOST_H__
> +#define __ASM_LOONGARCH_KVM_HOST_H__
> +
> +#include <linux/cpumask.h>
> +#include <linux/mutex.h>
> +#include <linux/hrtimer.h>
> +#include <linux/interrupt.h>
> +#include <linux/types.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_types.h>
> +#include <linux/threads.h>
> +#include <linux/spinlock.h>
> +
> +#include <asm/inst.h>
> +#include <asm/loongarch.h>
> +
> +/* Loongarch KVM register ids */
> +#define LOONGARCH_CSR_32(_R, _S)       \
> +       (KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U32 | (8 * (_R) + (_S)))
> +
> +#define LOONGARCH_CSR_64(_R, _S)       \
> +       (KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U64 | (8 * (_R) + (_S)))
> +
> +#define KVM_IOC_CSRID(id)              LOONGARCH_CSR_64(id, 0)
> +#define KVM_GET_IOC_CSRIDX(id)         ((id & KVM_CSR_IDX_MASK) >> 3)
> +
> +#define KVM_MAX_VCPUS                  256
> +/* memory slots that does not exposed to userspace */
> +#define KVM_PRIVATE_MEM_SLOTS          0
> +
> +#define KVM_HALT_POLL_NS_DEFAULT       500000
> +
> +struct kvm_vm_stat {
> +       struct kvm_vm_stat_generic generic;
> +};
> +
> +struct kvm_vcpu_stat {
> +       struct kvm_vcpu_stat_generic generic;
> +       u64 idle_exits;
> +       u64 signal_exits;
> +       u64 int_exits;
> +       u64 cpucfg_exits;
> +};
> +
> +struct kvm_arch_memory_slot {
> +};
> +
> +struct kvm_context {
> +       unsigned long vpid_cache;
> +       struct kvm_vcpu *last_vcpu;
> +};
> +
> +struct kvm_world_switch {
> +       int (*guest_eentry)(void);
> +       int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> +       unsigned long page_order;
> +};
> +
> +struct kvm_arch {
> +       /* Guest physical mm */
> +       pgd_t *pgd;
> +       unsigned long gpa_size;
> +
> +       s64 time_offset;
> +       struct kvm_context __percpu *vmcs;
> +};
> +
> +#define CSR_MAX_NUMS           0x800
> +
> +struct loongarch_csrs {
> +       unsigned long csrs[CSR_MAX_NUMS];
> +};
> +
> +/* Resume Flags */
> +#define RESUME_HOST            0
> +#define RESUME_GUEST           1
> +
> +enum emulation_result {
> +       EMULATE_DONE,           /* no further processing */
> +       EMULATE_DO_MMIO,        /* kvm_run filled with MMIO request */
> +       EMULATE_FAIL,           /* can't emulate this instruction */
> +       EMULATE_EXCEPT,         /* A guest exception has been generated *=
/
> +       EMULATE_DO_IOCSR,       /* handle IOCSR request */
> +};
> +
> +#define KVM_LARCH_CSR          (0x1 << 1)
> +#define KVM_LARCH_FPU          (0x1 << 0)
> +
> +struct kvm_vcpu_arch {
> +       /*
> +        * Switch pointer-to-function type to unsigned long
> +        * for loading the value into register directly.
> +        */
> +       unsigned long host_eentry;
> +       unsigned long guest_eentry;
> +
> +       /* Pointers stored here for easy accessing from assembly code */
> +       int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> +
> +       /* Host registers preserved across guest mode execution */
> +       unsigned long host_sp;
> +       unsigned long host_tp;
> +       unsigned long host_pgd;
> +
> +       /* Host CSRs are used when handling exits from guest */
> +       unsigned long badi;
> +       unsigned long badv;
> +       unsigned long host_ecfg;
> +       unsigned long host_estat;
> +       unsigned long host_percpu;
> +
> +       /* GPRs */
> +       unsigned long gprs[32];
> +       unsigned long pc;
> +
> +       /* Which auxiliary state is loaded (KVM_LOONGARCH_AUX_*) */
> +       unsigned int aux_inuse;
> +       /* FPU state */
> +       struct loongarch_fpu fpu FPU_ALIGN;
> +
> +       /* CSR state */
> +       struct loongarch_csrs *csr;
> +
> +       /* GPR used as IO source/target */
> +       u32 io_gpr;
> +
> +       struct hrtimer swtimer;
> +       /* KVM register to control count timer */
> +       u32 count_ctl;
> +
> +       /* Bitmask of exceptions that are pending */
> +       unsigned long irq_pending;
> +       /* Bitmask of pending exceptions to be cleared */
> +       unsigned long irq_clear;
> +
> +       /* Cache for pages needed inside spinlock regions */
> +       struct kvm_mmu_memory_cache mmu_page_cache;
> +
> +       /* vcpu's vpid */
> +       u64 vpid;
> +
> +       /* Frequency of stable timer in Hz */
> +       u64 timer_mhz;
> +       ktime_t expire;
> +
> +       u64 core_ext_ioisr[4];
> +
> +       /* Last CPU the vCPU state was loaded on */
> +       int last_sched_cpu;
> +       /* mp state */
> +       struct kvm_mp_state mp_state;
> +};
> +
> +static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, in=
t reg)
> +{
> +       return csr->csrs[reg];
> +}
> +
> +static inline void writel_sw_gcsr(struct loongarch_csrs *csr, int reg, u=
nsigned long val)
> +{
> +       csr->csrs[reg] =3D val;
> +}
> +
> +/* Helpers */
> +static inline bool _kvm_guest_has_fpu(struct kvm_vcpu_arch *arch)
> +{
> +       return cpu_has_fpu;
> +}
> +
> +void _kvm_init_fault(void);
Can we use kvm_guest_has_fpu and kvm_init_fault? Don't prefix with _
unless you have a special reason. For example, static internal
functions can be prefixed.

> +
> +/* Debug: dump vcpu state */
> +int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
> +
> +/* MMU handling */
> +int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long badv, bool =
write);
> +void kvm_flush_tlb_all(void);
> +void _kvm_destroy_mm(struct kvm *kvm);
The same as before, and maybe you can check other patches for the same issu=
e.


Huacai

> +pgd_t *kvm_pgd_alloc(void);
> +
> +#define KVM_ARCH_WANT_MMU_NOTIFIER
> +int kvm_unmap_hva_range(struct kvm *kvm,
> +                       unsigned long start, unsigned long end, bool bloc=
kable);
> +void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
> +int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)=
;
> +int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
> +
> +static inline void update_pc(struct kvm_vcpu_arch *arch)
> +{
> +       arch->pc +=3D 4;
> +}
> +
> +/**
> + * kvm_is_ifetch_fault() - Find whether a TLBL exception is due to ifetc=
h fault.
> + * @vcpu:      Virtual CPU.
> + *
> + * Returns:    Whether the TLBL exception was likely due to an instructi=
on
> + *             fetch fault rather than a data load fault.
> + */
> +static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *arch)
> +{
> +       return arch->pc =3D=3D arch->badv;
> +}
> +
> +/* Misc */
> +static inline void kvm_arch_hardware_unsetup(void) {}
> +static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> +static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {=
}
> +static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> +static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_free_memslot(struct kvm *kvm,
> +                                  struct kvm_memory_slot *slot) {}
> +void _kvm_check_vmid(struct kvm_vcpu *vcpu);
> +enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer);
> +int kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa);
> +void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> +                                       const struct kvm_memory_slot *mem=
slot);
> +void kvm_init_vmcs(struct kvm *kvm);
> +void kvm_vector_entry(void);
> +int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
> +extern const unsigned long kvm_vector_size;
> +extern const unsigned long kvm_enter_guest_size;
> +extern unsigned long vpid_mask;
> +extern struct kvm_world_switch *kvm_loongarch_ops;
> +
> +#define SW_GCSR                (1 << 0)
> +#define HW_GCSR                (1 << 1)
> +#define INVALID_GCSR   (1 << 2)
> +int get_gcsr_flag(int csr);
> +extern void set_hw_gcsr(int csr_id, unsigned long val);
> +#endif /* __ASM_LOONGARCH_KVM_HOST_H__ */
> diff --git a/arch/loongarch/include/asm/kvm_types.h b/arch/loongarch/incl=
ude/asm/kvm_types.h
> new file mode 100644
> index 0000000000..2fe1d4bdff
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_types.h
> @@ -0,0 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef _ASM_LOONGARCH_KVM_TYPES_H
> +#define _ASM_LOONGARCH_KVM_TYPES_H
> +
> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE      40
> +
> +#endif /* _ASM_LOONGARCH_KVM_TYPES_H */
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inclu=
de/uapi/asm/kvm.h
> new file mode 100644
> index 0000000000..7ec2f34018
> --- /dev/null
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -0,0 +1,101 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __UAPI_ASM_LOONGARCH_KVM_H
> +#define __UAPI_ASM_LOONGARCH_KVM_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * KVM Loongarch specific structures and definitions.
> + *
> + * Some parts derived from the x86 version of this file.
> + */
> +
> +#define __KVM_HAVE_READONLY_MEM
> +
> +#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> +#define KVM_DIRTY_LOG_PAGE_OFFSET      64
> +
> +/*
> + * for KVM_GET_REGS and KVM_SET_REGS
> + */
> +struct kvm_regs {
> +       /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
> +       __u64 gpr[32];
> +       __u64 pc;
> +};
> +
> +/*
> + * for KVM_GET_FPU and KVM_SET_FPU
> + */
> +struct kvm_fpu {
> +       __u32 fcsr;
> +       __u64 fcc;    /* 8x8 */
> +       struct kvm_fpureg {
> +               __u64 val64[4];
> +       } fpr[32];
> +};
> +
> +/*
> + * For LoongArch, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to access v=
arious
> + * registers.  The id field is broken down as follows:
> + *
> + *  bits[63..52] - As per linux/kvm.h
> + *  bits[51..32] - Must be zero.
> + *  bits[31..16] - Register set.
> + *
> + * Register set =3D 0: GP registers from kvm_regs (see definitions below=
).
> + *
> + * Register set =3D 1: CSR registers.
> + *
> + * Register set =3D 2: KVM specific registers (see definitions below).
> + *
> + * Register set =3D 3: FPU / SIMD registers (see definitions below).
> + *
> + * Other sets registers may be added in the future.  Each set would
> + * have its own identifier in bits[31..16].
> + */
> +
> +#define KVM_REG_LOONGARCH_GPR          (KVM_REG_LOONGARCH | 0x00000ULL)
> +#define KVM_REG_LOONGARCH_CSR          (KVM_REG_LOONGARCH | 0x10000ULL)
> +#define KVM_REG_LOONGARCH_KVM          (KVM_REG_LOONGARCH | 0x20000ULL)
> +#define KVM_REG_LOONGARCH_FPU          (KVM_REG_LOONGARCH | 0x30000ULL)
> +#define KVM_REG_LOONGARCH_MASK         (KVM_REG_LOONGARCH | 0x30000ULL)
> +#define KVM_CSR_IDX_MASK               (0x10000 - 1)
> +
> +/*
> + * KVM_REG_LOONGARCH_KVM - KVM specific control registers.
> + */
> +
> +#define KVM_REG_LOONGARCH_COUNTER      (KVM_REG_LOONGARCH_KVM | KVM_REG_=
SIZE_U64 | 3)
> +#define KVM_REG_LOONGARCH_VCPU_RESET   (KVM_REG_LOONGARCH_KVM | KVM_REG_=
SIZE_U64 | 4)
> +
> +struct kvm_debug_exit_arch {
> +};
> +
> +/* for KVM_SET_GUEST_DEBUG */
> +struct kvm_guest_debug_arch {
> +};
> +
> +/* definition of registers in kvm_run */
> +struct kvm_sync_regs {
> +};
> +
> +/* dummy definition */
> +struct kvm_sregs {
> +};
> +
> +struct kvm_iocsr_entry {
> +       __u32 addr;
> +       __u32 pad;
> +       __u64 data;
> +};
> +
> +#define KVM_NR_IRQCHIPS                1
> +#define KVM_IRQCHIP_NUM_PINS   64
> +#define KVM_MAX_CORES          256
> +
> +#endif /* __UAPI_ASM_LOONGARCH_KVM_H */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f089ab2909..1184171224 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -264,6 +264,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_RISCV_SBI        35
>  #define KVM_EXIT_RISCV_CSR        36
>  #define KVM_EXIT_NOTIFY           37
> +#define KVM_EXIT_LOONGARCH_IOCSR  38
>
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -336,6 +337,13 @@ struct kvm_run {
>                         __u32 len;
>                         __u8  is_write;
>                 } mmio;
> +               /* KVM_EXIT_LOONGARCH_IOCSR */
> +               struct {
> +                       __u64 phys_addr;
> +                       __u8  data[8];
> +                       __u32 len;
> +                       __u8  is_write;
> +               } iocsr_io;
>                 /* KVM_EXIT_HYPERCALL */
>                 struct {
>                         __u64 nr;
> @@ -1362,6 +1370,7 @@ struct kvm_dirty_tlb {
>  #define KVM_REG_ARM64          0x6000000000000000ULL
>  #define KVM_REG_MIPS           0x7000000000000000ULL
>  #define KVM_REG_RISCV          0x8000000000000000ULL
> +#define KVM_REG_LOONGARCH      0x9000000000000000ULL
>
>  #define KVM_REG_SIZE_SHIFT     52
>  #define KVM_REG_SIZE_MASK      0x00f0000000000000ULL
> --
> 2.27.0
>
