Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC5A736144
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 03:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjFTBuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 21:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjFTBuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 21:50:44 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 320F410C4;
        Mon, 19 Jun 2023 18:50:41 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8BxY+jvBZFk7gMHAA--.388S3;
        Tue, 20 Jun 2023 09:50:39 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxauXtBZFkegghAA--.27417S3;
        Tue, 20 Jun 2023 09:50:38 +0800 (CST)
Subject: Re: [PATCH v14 01/30] LoongArch: KVM: Add kvm related header files
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
References: <20230619083255.3841777-1-zhaotianrui@loongson.cn>
 <20230619083255.3841777-2-zhaotianrui@loongson.cn>
 <CAAhV-H61FpoRA=F6iaHA9E=V4VUoQ5CGAF1YGBs-f9P2QNE+=g@mail.gmail.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <7409e2f3-7079-6ecd-7a7d-f6c0b8e36ee3@loongson.cn>
Date:   Tue, 20 Jun 2023 09:50:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H61FpoRA=F6iaHA9E=V4VUoQ5CGAF1YGBs-f9P2QNE+=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8AxauXtBZFkegghAA--.27417S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoW3Cw1rCr4xAr1DJFy8Xr15KFX_yoW8XrW8Wo
        W7tFs2gr48Gw15Cw45C342qa45Z34F9w47Aa13C3s3X3W7ta4UWr4UKw4FqF43ur15KrW7
        CasxX3WDZaySvwn5l-sFpf9Il3svdjkaLaAFLSUrUUUUeb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUOb7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4j6r4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
        Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
        Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
        CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcbAwUUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/6/19 下午5:59, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Mon, Jun 19, 2023 at 4:33 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>> Add LoongArch KVM related header files, including kvm.h,
>> kvm_host.h, kvm_types.h. All of those are about LoongArch
>> virtualization features and kvm interfaces.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_host.h  | 253 +++++++++++++++++++++++++
>>   arch/loongarch/include/asm/kvm_types.h |  11 ++
>>   arch/loongarch/include/uapi/asm/kvm.h  | 106 +++++++++++
>>   include/uapi/linux/kvm.h               |   9 +
>>   4 files changed, 379 insertions(+)
>>   create mode 100644 arch/loongarch/include/asm/kvm_host.h
>>   create mode 100644 arch/loongarch/include/asm/kvm_types.h
>>   create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
>>
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> new file mode 100644
>> index 000000000000..a8ff3ef9cd55
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -0,0 +1,253 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#ifndef __ASM_LOONGARCH_KVM_HOST_H__
>> +#define __ASM_LOONGARCH_KVM_HOST_H__
>> +
>> +#include <linux/cpumask.h>
>> +#include <linux/mutex.h>
>> +#include <linux/hrtimer.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/types.h>
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_types.h>
>> +#include <linux/threads.h>
>> +#include <linux/spinlock.h>
>> +
>> +#include <asm/inst.h>
>> +#include <asm/loongarch.h>
>> +
>> +/* Loongarch KVM register ids */
>> +#define LOONGARCH_CSR_32(_R, _S)       \
>> +       (KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U32 | (8 * (_R) + (_S)))
>> +
>> +#define LOONGARCH_CSR_64(_R, _S)       \
>> +       (KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U64 | (8 * (_R) + (_S)))
>> +
>> +#define KVM_IOC_CSRID(id)              LOONGARCH_CSR_64(id, 0)
>> +#define KVM_GET_IOC_CSRIDX(id)         ((id & KVM_CSR_IDX_MASK) >> 3)
>> +
>> +#define KVM_MAX_VCPUS                  256
>> +/* memory slots that does not exposed to userspace */
>> +#define KVM_PRIVATE_MEM_SLOTS          0
>> +
>> +#define KVM_HALT_POLL_NS_DEFAULT       500000
>> +
>> +struct kvm_vm_stat {
>> +       struct kvm_vm_stat_generic generic;
>> +};
>> +
>> +struct kvm_vcpu_stat {
>> +       struct kvm_vcpu_stat_generic generic;
>> +       u64 idle_exits;
>> +       u64 signal_exits;
>> +       u64 int_exits;
>> +       u64 cpucfg_exits;
>> +};
>> +
>> +struct kvm_arch_memory_slot {
>> +};
>> +
>> +struct kvm_context {
>> +       unsigned long vpid_cache;
>> +       struct kvm_vcpu *last_vcpu;
>> +};
>> +
>> +struct kvm_world_switch {
>> +       int (*guest_eentry)(void);
>> +       int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +       unsigned long page_order;
>> +};
>> +
>> +struct kvm_arch {
>> +       /* Guest physical mm */
>> +       struct mm_struct gpa_mm;
>> +       /* Mask of CPUs needing GPA ASID flush */
>> +       cpumask_t asid_flush_mask;
>> +
>> +       unsigned char online_vcpus;
>> +       unsigned char is_migrate;
> is_migrating is better.
Thanks, I will rename it to is_migrating.
>
>> +       s64 time_offset;
>> +       struct kvm_context __percpu *vmcs;
>> +       unsigned long gpa_size;
> Move gpa_size under gpa_mm seems better.
Thanks, I will re-order it.
>> +};
>> +
>> +#define CSR_MAX_NUMS           0x800
>> +
>> +struct loongarch_csrs {
>> +       unsigned long csrs[CSR_MAX_NUMS];
>> +};
>> +
>> +/* Resume Flags */
>> +#define RESUME_GUEST           1
>> +#define RESUME_HOST            0
> Exchange their order seems better.
Thanks, I will exchange the two macros.
>
>> +
>> +enum emulation_result {
>> +       EMULATE_DONE,           /* no further processing */
>> +       EMULATE_DO_MMIO,        /* kvm_run filled with MMIO request */
>> +       EMULATE_FAIL,           /* can't emulate this instruction */
>> +       EMULATE_WAIT,           /* WAIT instruction */
> EMULATE_IDLE? also the comments should be modified.
This also could be removed, as it is not used and the idle instruction 
has been emulated in KVM.
>
>> +       EMULATE_EXCEPT,         /* A guest exception has been generated */
>> +       EMULATE_DO_IOCSR,       /* handle IOCSR request */
>> +};
>> +
>> +#define KVM_LARCH_FPU          (0x1 << 0)
>> +#define KVM_LARCH_CSR          (0x1 << 1)
> I want to change their order, just because we will add LSX/LASX, it is
> better to let LSX/LASX be together with FPU.
Thanks, I will re-order them.
>
>> +
>> +struct kvm_vcpu_arch {
>> +       /*
>> +        * Switch pointer-to-function type to unsigned long
>> +        * for loading the value into register directly.
>> +        */
>> +       unsigned long guest_eentry;
>> +       unsigned long host_eentry;
> Exchange their order seems better, as above.
Thanks, I will exchange them.
>
>> +
>> +       /* Pointers stored here for easy accessing from assembly code */
>> +       int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +
>> +       /* Host registers preserved across guest mode execution */
>> +       unsigned long host_sp;
>> +       unsigned long host_tp;
>> +       unsigned long host_pgd;
>> +
>> +       /* Host CSRs are used when handling exits from guest */
>> +       unsigned long badi;
>> +       unsigned long badv;
>> +       unsigned long host_ecfg;
>> +       unsigned long host_estat;
>> +       unsigned long host_percpu;
>> +
>> +       /* GPRs */
>> +       unsigned long gprs[32];
>> +       unsigned long pc;
>> +
>> +       /* FPU state */
>> +       struct loongarch_fpu fpu FPU_ALIGN;
>> +       /* Which auxiliary state is loaded (KVM_LOONGARCH_AUX_*) */
>> +       unsigned int aux_inuse;
> I also want to change the order of aux_inuse and fpu, just because we
> may add lbt after fpu in future.
I will also re-order them, thanks.
>
>> +
>> +       /* CSR state */
>> +       struct loongarch_csrs *csr;
>> +
>> +       /* GPR used as IO source/target */
>> +       u32 io_gpr;
>> +
>> +       struct hrtimer swtimer;
>> +       /* KVM register to control count timer */
>> +       u32 count_ctl;
>> +
>> +       /* Bitmask of exceptions that are pending */
>> +       unsigned long irq_pending;
>> +       /* Bitmask of pending exceptions to be cleared */
>> +       unsigned long irq_clear;
>> +
>> +       /* Cache for pages needed inside spinlock regions */
>> +       struct kvm_mmu_memory_cache mmu_page_cache;
>> +
>> +       /* vcpu's vpid */
>> +       u64 vpid;
>> +
>> +       /* Period of stable timer tick in ns */
>> +       u64 timer_period_ns;
>> +       /* Frequency of stable timer in Hz */
>> +       u64 timer_mhz;
>> +       /* Stable bias from the raw time */
>> +       u64 timer_bias;
>> +       /* Dynamic nanosecond bias (multiple of timer_period_ns) to avoid overflow */
>> +       s64 timer_dyn_bias;
>> +
>> +       ktime_t stable_ktime_saved;
>> +
>> +       u64 core_ext_ioisr[4];
>> +
>> +       /* Last CPU the vCPU state was loaded on */
>> +       int last_sched_cpu;
>> +       /* Last CPU the vCPU actually executed guest code on */
>> +       int last_exec_cpu;
>> +       /* mp state */
>> +       struct kvm_mp_state mp_state;
>> +};
>> +
>> +static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
>> +{
>> +       return csr->csrs[reg];
>> +}
>> +
>> +static inline void writel_sw_gcsr(struct loongarch_csrs *csr, int reg,
>> +               unsigned long val)
> Don't split here, long lines is acceptable now.
Thanks, I will make it in one line.
>
>> +{
>> +       csr->csrs[reg] = val;
>> +}
>> +
>> +/* Helpers */
>> +static inline bool _kvm_guest_has_fpu(struct kvm_vcpu_arch *arch)
>> +{
>> +       return cpu_has_fpu;
>> +}
>> +
>> +void _kvm_init_fault(void);
>> +
>> +/* Debug: dump vcpu state */
>> +int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
>> +
>> +/* MMU handling */
>> +int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long badv, bool write);
>> +void kvm_flush_tlb_all(void);
>> +void _kvm_destroy_mm(struct kvm *kvm);
>> +pgd_t *kvm_pgd_alloc(void);
>> +
>> +#define KVM_ARCH_WANT_MMU_NOTIFIER
>> +int kvm_unmap_hva_range(struct kvm *kvm,
>> +                       unsigned long start, unsigned long end, bool blockable);
>> +void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>> +int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
>> +int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>> +
>> +static inline void update_pc(struct kvm_vcpu_arch *arch)
>> +{
>> +       arch->pc += 4;
>> +}
>> +
>> +/**
>> + * kvm_is_ifetch_fault() - Find whether a TLBL exception is due to ifetch fault.
>> + * @vcpu:      Virtual CPU.
>> + *
>> + * Returns:    Whether the TLBL exception was likely due to an instruction
>> + *             fetch fault rather than a data load fault.
>> + */
>> +static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *arch)
>> +{
>> +       return arch->pc == arch->badv;
>> +}
>> +
>> +/* Misc */
>> +static inline void kvm_arch_hardware_unsetup(void) {}
>> +static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>> +static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>> +static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>> +static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_arch_free_memslot(struct kvm *kvm,
>> +                                  struct kvm_memory_slot *slot) {}
>> +void _kvm_check_vmid(struct kvm_vcpu *vcpu);
>> +enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer);
>> +int kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa);
>> +void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>> +                                       const struct kvm_memory_slot *memslot);
>> +void kvm_init_vmcs(struct kvm *kvm);
>> +void kvm_vector_entry(void);
>> +int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +extern const unsigned long kvm_vector_size;
>> +extern const unsigned long kvm_enter_guest_size;
>> +extern unsigned long vpid_mask;
>> +extern struct kvm_world_switch *kvm_loongarch_ops;
>> +
>> +#define SW_GCSR                (1 << 0)
>> +#define HW_GCSR                (1 << 1)
>> +#define INVALID_GCSR   (1 << 2)
>> +int get_gcsr_flag(int csr);
>> +extern void set_hw_gcsr(int csr_id, unsigned long val);
>> +#endif /* __ASM_LOONGARCH_KVM_HOST_H__ */
>> diff --git a/arch/loongarch/include/asm/kvm_types.h b/arch/loongarch/include/asm/kvm_types.h
>> new file mode 100644
>> index 000000000000..060647b5fe2e
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_types.h
>> @@ -0,0 +1,11 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#ifndef _ASM_LOONGARCH_KVM_TYPES_H
>> +#define _ASM_LOONGARCH_KVM_TYPES_H
>> +
>> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE      4
>> +
>> +#endif /* _ASM_LOONGARCH_KVM_TYPES_H */
>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>> new file mode 100644
>> index 000000000000..3ccadb73ad8d
>> --- /dev/null
>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>> @@ -0,0 +1,106 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#ifndef __UAPI_ASM_LOONGARCH_KVM_H
>> +#define __UAPI_ASM_LOONGARCH_KVM_H
>> +
>> +#include <linux/types.h>
>> +
>> +/*
>> + * KVM Loongarch specific structures and definitions.
>> + *
>> + * Some parts derived from the x86 version of this file.
>> + */
>> +
>> +#define __KVM_HAVE_READONLY_MEM
>> +
>> +#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>> +
>> +/*
>> + * for KVM_GET_REGS and KVM_SET_REGS
>> + */
>> +struct kvm_regs {
>> +       /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
>> +       __u64 gpr[32];
>> +       __u64 pc;
>> +};
>> +
>> +/*
>> + * for KVM_GET_FPU and KVM_SET_FPU
>> + */
>> +struct kvm_fpu {
>> +       __u32 fcsr;
>> +       __u64 fcc;    /* 8x8 */
>> +       struct kvm_fpureg {
>> +               __u64 val64[4];
>> +       } fpr[32];
>> +};
>> +
>> +/*
>> + * For LoongArch, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to access various
>> + * registers.  The id field is broken down as follows:
>> + *
>> + *  bits[63..52] - As per linux/kvm.h
>> + *  bits[51..32] - Must be zero.
>> + *  bits[31..16] - Register set.
>> + *
>> + * Register set = 0: GP registers from kvm_regs (see definitions below).
>> + *
>> + * Register set = 1: CSR registers.
>> + *
>> + * Register set = 2: KVM specific registers (see definitions below).
>> + *
>> + * Register set = 3: FPU / SIMD registers (see definitions below).
>> + *
>> + * Other sets registers may be added in the future.  Each set would
>> + * have its own identifier in bits[31..16].
>> + */
>> +
>> +#define KVM_REG_LOONGARCH_GP           (KVM_REG_LOONGARCH | 0x00000ULL)
> Maybe KVM_REG_LOONGARCH_GPR is better.
>
> Huacai
I will change it to KVM_REG_LOONGARCH_GPR.

Thanks
Tianrui Zhao
>> +#define KVM_REG_LOONGARCH_CSR          (KVM_REG_LOONGARCH | 0x10000ULL)
>> +#define KVM_REG_LOONGARCH_KVM          (KVM_REG_LOONGARCH | 0x20000ULL)
>> +#define KVM_REG_LOONGARCH_FPU          (KVM_REG_LOONGARCH | 0x30000ULL)
>> +#define KVM_REG_LOONGARCH_MASK         (KVM_REG_LOONGARCH | 0x30000ULL)
>> +#define KVM_CSR_IDX_MASK               (0x10000 - 1)
>> +
>> +/*
>> + * KVM_REG_LOONGARCH_KVM - KVM specific control registers.
>> + */
>> +
>> +#define KVM_REG_LOONGARCH_COUNTER      (KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
>> +#define KVM_REG_LOONGARCH_VCPU_RESET   (KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 4)
>> +
>> +struct kvm_debug_exit_arch {
>> +};
>> +
>> +/* for KVM_SET_GUEST_DEBUG */
>> +struct kvm_guest_debug_arch {
>> +};
>> +
>> +/* definition of registers in kvm_run */
>> +struct kvm_sync_regs {
>> +};
>> +
>> +/* dummy definition */
>> +struct kvm_sregs {
>> +};
>> +
>> +struct kvm_iocsr_entry {
>> +       __u32 addr;
>> +       __u32 pad;
>> +       __u64 data;
>> +};
>> +
>> +struct kvm_loongarch_interrupt {
>> +       /* in */
>> +       __u32 cpu;
>> +       __u32 irq;
>> +};
>> +
>> +#define KVM_NR_IRQCHIPS                1
>> +#define KVM_IRQCHIP_NUM_PINS   64
>> +#define KVM_MAX_CORES          256
>> +
>> +#endif /* __UAPI_ASM_LOONGARCH_KVM_H */
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 737318b1c1d9..74d9766277e7 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -264,6 +264,7 @@ struct kvm_xen_exit {
>>   #define KVM_EXIT_RISCV_SBI        35
>>   #define KVM_EXIT_RISCV_CSR        36
>>   #define KVM_EXIT_NOTIFY           37
>> +#define KVM_EXIT_LOONGARCH_IOCSR  38
>>
>>   /* For KVM_EXIT_INTERNAL_ERROR */
>>   /* Emulate instruction failed. */
>> @@ -336,6 +337,13 @@ struct kvm_run {
>>                          __u32 len;
>>                          __u8  is_write;
>>                  } mmio;
>> +               /* KVM_EXIT_LOONGARCH_IOCSR */
>> +               struct {
>> +                       __u64 phys_addr;
>> +                       __u8  data[8];
>> +                       __u32 len;
>> +                       __u8  is_write;
>> +               } iocsr_io;
>>                  /* KVM_EXIT_HYPERCALL */
>>                  struct {
>>                          __u64 nr;
>> @@ -1360,6 +1368,7 @@ struct kvm_dirty_tlb {
>>   #define KVM_REG_ARM64          0x6000000000000000ULL
>>   #define KVM_REG_MIPS           0x7000000000000000ULL
>>   #define KVM_REG_RISCV          0x8000000000000000ULL
>> +#define KVM_REG_LOONGARCH      0x9000000000000000ULL
>>
>>   #define KVM_REG_SIZE_SHIFT     52
>>   #define KVM_REG_SIZE_MASK      0x00f0000000000000ULL
>> --
>> 2.39.1
>>

