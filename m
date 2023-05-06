Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4869B6F90E1
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 11:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjEFJ21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 05:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjEFJ2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 05:28:24 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46D3D7D82;
        Sat,  6 May 2023 02:28:21 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8Bx6emzHVZkjrcFAA--.9557S3;
        Sat, 06 May 2023 17:28:19 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxqraxHVZk0VpNAA--.9963S3;
        Sat, 06 May 2023 17:28:18 +0800 (CST)
Subject: Re: [PATCH v8 01/30] LoongArch: KVM: Add kvm related header files
To:     Huacai Chen <chenhuacai@kernel.org>
References: <20230427071109.3367258-1-zhaotianrui@loongson.cn>
 <20230427071109.3367258-2-zhaotianrui@loongson.cn>
 <CAAhV-H4jifK457y9NSvTqmdx=23VCPKpOhD9ixaqGH0Fshe9GA@mail.gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <59ae8d72-97fc-6464-02ad-bb13cc23b19c@loongson.cn>
Date:   Sat, 6 May 2023 17:28:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4jifK457y9NSvTqmdx=23VCPKpOhD9ixaqGH0Fshe9GA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxqraxHVZk0VpNAA--.9963S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvAXoW3KF18CF1kWFyrZFy3uFykKrg_yoW8ArWxCo
        W3tF4Igw48Gr1UCws8C34jqa4Yv34rKr47Aa13A3s3J3W7ta4DGr48Kw4FqF43urn5KrW7
        uasxXa4DZayIvwn5n29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXasCq-sGcSsGvf
        J3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnRJU
        UUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s
        0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
        8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr0_GcWl
        n4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E
        87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUUUU=
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年05月06日 16:20, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Thu, Apr 27, 2023 at 3:11 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>> Add LoongArch KVM related header files, including kvm.h,
>> kvm_host.h, kvm_types.h. All of those are about LoongArch
>> virtualization features and kvm interfaces.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/cpu-features.h |  22 ++
>>   arch/loongarch/include/asm/cpu-info.h     |  10 +
>>   arch/loongarch/include/asm/kvm_host.h     | 254 ++++++++++++++++++++++
>>   arch/loongarch/include/asm/kvm_types.h    |  11 +
>>   arch/loongarch/include/uapi/asm/kvm.h     | 107 +++++++++
>>   include/uapi/linux/kvm.h                  |   9 +
>>   6 files changed, 413 insertions(+)
>>   create mode 100644 arch/loongarch/include/asm/kvm_host.h
>>   create mode 100644 arch/loongarch/include/asm/kvm_types.h
>>   create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
>>
>> diff --git a/arch/loongarch/include/asm/cpu-features.h b/arch/loongarch/include/asm/cpu-features.h
>> index f6177f133477..fbc5b4f202aa 100644
>> --- a/arch/loongarch/include/asm/cpu-features.h
>> +++ b/arch/loongarch/include/asm/cpu-features.h
>> @@ -65,5 +65,27 @@
>>   #define cpu_has_guestid                cpu_opt(LOONGARCH_CPU_GUESTID)
>>   #define cpu_has_hypervisor     cpu_opt(LOONGARCH_CPU_HYPERVISOR)
>>
>> +#define cpu_has_matc_guest     (cpu_data[0].guest_cfg & BIT(0))
>> +#define cpu_has_matc_root      (cpu_data[0].guest_cfg & BIT(1))
>> +#define cpu_has_matc_nest      (cpu_data[0].guest_cfg & BIT(2))
>> +#define cpu_has_sitp           (cpu_data[0].guest_cfg & BIT(6))
>> +#define cpu_has_titp           (cpu_data[0].guest_cfg & BIT(8))
>> +#define cpu_has_toep           (cpu_data[0].guest_cfg & BIT(10))
>> +#define cpu_has_topp           (cpu_data[0].guest_cfg & BIT(12))
>> +#define cpu_has_torup          (cpu_data[0].guest_cfg & BIT(14))
>> +#define cpu_has_gcip_all       (cpu_data[0].guest_cfg & BIT(16))
>> +#define cpu_has_gcip_hit       (cpu_data[0].guest_cfg & BIT(17))
>> +#define cpu_has_gcip_secure    (cpu_data[0].guest_cfg & BIT(18))
>> +
>> +/*
>> + * Guest capabilities
>> + */
>> +#define cpu_guest_has_conf1    (cpu_data[0].guest.conf & BIT(1))
>> +#define cpu_guest_has_conf2    (cpu_data[0].guest.conf & BIT(2))
>> +#define cpu_guest_has_conf3    (cpu_data[0].guest.conf & BIT(3))
>> +#define cpu_guest_has_fpu      (cpu_data[0].guest.options & LOONGARCH_CPU_FPU)
>> +#define cpu_guest_has_perf     (cpu_data[0].guest.options & LOONGARCH_CPU_PMP)
>> +#define cpu_guest_has_watch    (cpu_data[0].guest.options & LOONGARCH_CPU_WATCH)
>> +#define cpu_guest_has_lsx      (cpu_data[0].guest.options & LOONGARCH_CPU_LSX)
>>
>>   #endif /* __ASM_CPU_FEATURES_H */
>> diff --git a/arch/loongarch/include/asm/cpu-info.h b/arch/loongarch/include/asm/cpu-info.h
>> index cd73a6f57fe3..0b9119c2b29d 100644
>> --- a/arch/loongarch/include/asm/cpu-info.h
>> +++ b/arch/loongarch/include/asm/cpu-info.h
>> @@ -32,6 +32,13 @@ struct cache_desc {
>>   #define CACHE_LEVEL_MAX                3
>>   #define CACHE_LEAVES_MAX       6
>>
>> +struct guest_info {
>> +       unsigned long           options;
>> +       unsigned long           options_dyn;
>> +       unsigned char           conf;
>> +       unsigned int            kscratch_mask;
>> +};
>> +
>>   struct cpuinfo_loongarch {
>>          u64                     asid_cache;
>>          unsigned long           asid_mask;
>> @@ -60,6 +67,9 @@ struct cpuinfo_loongarch {
>>          unsigned int            watch_dreg_count;   /* Number data breakpoints */
>>          unsigned int            watch_ireg_count;   /* Number instruction breakpoints */
>>          unsigned int            watch_reg_use_cnt; /* min(NUM_WATCH_REGS, watch_dreg_count + watch_ireg_count), Usable by ptrace */
>> +       /* VZ & Guest features */
>> +       struct guest_info       guest;
>> +       unsigned long           guest_cfg;
>>   } __aligned(SMP_CACHE_BYTES);
>>
>>   extern struct cpuinfo_loongarch cpu_data[];
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> new file mode 100644
>> index 000000000000..6f72245f4e85
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -0,0 +1,254 @@
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
>> +       s64 time_offset;
>> +       struct kvm_context __percpu *vmcs;
>> +       unsigned long gpa_size;
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
>> +
>> +enum emulation_result {
>> +       EMULATE_DONE,           /* no further processing */
>> +       EMULATE_DO_MMIO,        /* kvm_run filled with MMIO request */
>> +       EMULATE_FAIL,           /* can't emulate this instruction */
>> +       EMULATE_WAIT,           /* WAIT instruction */
>> +       EMULATE_EXCEPT,         /* A guest exception has been generated */
>> +       EMULATE_DO_IOCSR,       /* handle IOCSR request */
>> +};
>> +
>> +#define KVM_LARCH_FPU          (0x1 << 0)
>> +#define KVM_LARCH_CSR          (0x1 << 1)
>> +
>> +struct kvm_vcpu_arch {
>> +       /*
>> +        * Switch pointer-to-function type to unsigned long
>> +        * for loading the value into register directly.
>> +        */
>> +       unsigned long guest_eentry;
>> +       unsigned long host_eentry;
>> +
>> +       /* Pointers stored here for easy accessing from assembly code */
>> +       int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +
>> +       /* Host registers preserved across guest mode execution */
>> +       unsigned long host_stack;
>> +       unsigned long host_gp;
>> +       unsigned long host_pgd;
>> +       unsigned long host_pgdhi;
>> +       unsigned long host_entryhi;
> I can't find that host_pgdhi and host_entryhi be used in this series,
> and I don't know whether they will be used in future.
The two variables are not used, and I will remove them.

Thanks
Tianrui Zhao
>
>> +
>> +       /* Host CSRs are used when handling exits from guest */
>> +       unsigned long badv;
>> +       unsigned long host_estat;
>> +       unsigned long badi;
>> +       unsigned long host_ecfg;
>> +       unsigned long host_percpu;
> If they are in badi, badv, host_ecfg, host_estat, host_percpu order, I
> think that is better.
>
>
> Huacai
Thanks, I will reorder these to make them better.

Thanks
Tianrui Zhao
>
>> +
>> +       /* GPRs */
>> +       unsigned long gprs[32];
>> +       unsigned long pc;
>> +
>> +       /* FPU state */
>> +       struct loongarch_fpu fpu FPU_ALIGN;
>> +       /* Which auxiliary state is loaded (KVM_LOONGARCH_AUX_*) */
>> +       unsigned int aux_inuse;
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
>> +void _kvm_check_vmid(struct kvm_vcpu *vcpu, int cpu);
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
>> +#define SW_GCSR        (1 << 0)
>> +#define HW_GCSR        (1 << 1)
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
>> index 000000000000..2fc3baac2ecd
>> --- /dev/null
>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>> @@ -0,0 +1,107 @@
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
>> +       __u32 none;
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
>> index d77aef872a0a..d14fde87ae35 100644
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
>> @@ -1354,6 +1362,7 @@ struct kvm_dirty_tlb {
>>   #define KVM_REG_ARM64          0x6000000000000000ULL
>>   #define KVM_REG_MIPS           0x7000000000000000ULL
>>   #define KVM_REG_RISCV          0x8000000000000000ULL
>> +#define KVM_REG_LOONGARCH      0x9000000000000000ULL
>>
>>   #define KVM_REG_SIZE_SHIFT     52
>>   #define KVM_REG_SIZE_MASK      0x00f0000000000000ULL
>> --
>> 2.31.1
>>

