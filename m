Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA5B6E88C7
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 05:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbjDTDcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 23:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDTDcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 23:32:15 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92CC440D4;
        Wed, 19 Apr 2023 20:32:11 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8Cxidk6skBkHUYfAA--.37329S3;
        Thu, 20 Apr 2023 11:32:10 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxtrU4skBkCHgwAA--.121S3;
        Thu, 20 Apr 2023 11:32:09 +0800 (CST)
Subject: Re: [PATCH v7 01/30] LoongArch: KVM: Add kvm related header files
To:     WANG Xuerui <kernel@xen0n.name>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230417094649.874671-1-zhaotianrui@loongson.cn>
 <20230417094649.874671-2-zhaotianrui@loongson.cn>
 <f80d89fb-3428-a0c3-b41e-9619ed5adc8c@xen0n.name>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <31de3597-91e3-90d6-2aee-88198d1fa395@loongson.cn>
Date:   Thu, 20 Apr 2023 11:32:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <f80d89fb-3428-a0c3-b41e-9619ed5adc8c@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxtrU4skBkCHgwAA--.121S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvAXoW3Cw18CF1xGr4kJr4fGFy5XFb_yoW8CFW3Ao
        W3tF4Igw48Gw1UCw4DG34jva45Z34Fkw47Aa13A3s5X3Wxtas8Gr48Kw48XF43uFn5KrW7
        CasxX3WDZayIvwn5n29KB7ZKAUJUUUjU529EdanIXcx71UUUUU7KY7ZEXasCq-sGcSsGvf
        J3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnRJU
        UUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s
        0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
        ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJVW0owAa
        w2AFwI0_Jw0_GFyle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
        I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2
        jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62
        AI1cAE67vIY487MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCa
        FVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1q6r43MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
        IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280
        aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUec6pPUUUUU==
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年04月19日 17:28, WANG Xuerui 写道:
> On 2023/4/17 17:46, Tianrui Zhao wrote:
>> Add LoongArch KVM related header files, including kvm.h,
>> kvm_host.h, kvm_types.h. All of those are about LoongArch
>> virtualization features and kvm interfaces.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/cpu-features.h |  22 ++
>>   arch/loongarch/include/asm/kvm_host.h     | 268 ++++++++++++++++++++++
>>   arch/loongarch/include/asm/kvm_types.h    |  11 +
>>   arch/loongarch/include/uapi/asm/kvm.h     | 107 +++++++++
>>   include/uapi/linux/kvm.h                  |   9 +
>>   5 files changed, 417 insertions(+)
>>   create mode 100644 arch/loongarch/include/asm/kvm_host.h
>>   create mode 100644 arch/loongarch/include/asm/kvm_types.h
>>   create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
>>
>> diff --git a/arch/loongarch/include/asm/cpu-features.h 
>> b/arch/loongarch/include/asm/cpu-features.h
>> index b07974218393..345b7674a15f 100644
>> --- a/arch/loongarch/include/asm/cpu-features.h
>> +++ b/arch/loongarch/include/asm/cpu-features.h
>> @@ -64,5 +64,27 @@
>>   #define cpu_has_guestid        cpu_opt(LOONGARCH_CPU_GUESTID)
>>   #define cpu_has_hypervisor cpu_opt(LOONGARCH_CPU_HYPERVISOR)
>>   +#define cpu_has_matc_guest    (cpu_data[0].guest_cfg & BIT(0))
>> +#define cpu_has_matc_root    (cpu_data[0].guest_cfg & BIT(1))
>> +#define cpu_has_matc_nest    (cpu_data[0].guest_cfg & BIT(2))
>> +#define cpu_has_sitp        (cpu_data[0].guest_cfg & BIT(6))
>> +#define cpu_has_titp        (cpu_data[0].guest_cfg & BIT(8))
>> +#define cpu_has_toep        (cpu_data[0].guest_cfg & BIT(10))
>> +#define cpu_has_topp        (cpu_data[0].guest_cfg & BIT(12))
>> +#define cpu_has_torup        (cpu_data[0].guest_cfg & BIT(14))
>> +#define cpu_has_gcip_all    (cpu_data[0].guest_cfg & BIT(16))
>> +#define cpu_has_gcip_hit    (cpu_data[0].guest_cfg & BIT(17))
>> +#define cpu_has_gcip_secure    (cpu_data[0].guest_cfg & BIT(18))
>
> We don't have guest_cfg yet in the cpu_data structure. You may have to 
> re-organize a little bit to avoid referencing things from future commits.
>
> Also you may want to make more use of the definitions already in 
> <asm/loongarch.h>, e.g. the BIT(6) here is just CSR_GCFG_SITP, and it 
> seems the matc_{guest,root,nest} definitions here conflict with the 
> definitions in <asm/loongarch.h> which implies the MATC is a plain 
> value instead of a bunch of bit flags.
>
>> +
>> +/*
>> + * Guest capabilities
>> + */
>> +#define cpu_guest_has_conf1    (cpu_data[0].guest.conf & BIT(1))
>> +#define cpu_guest_has_conf2    (cpu_data[0].guest.conf & BIT(2))
>> +#define cpu_guest_has_conf3    (cpu_data[0].guest.conf & BIT(3))
>> +#define cpu_guest_has_fpu    (cpu_data[0].guest.options & 
>> LOONGARCH_CPU_FPU)
>> +#define cpu_guest_has_perf    (cpu_data[0].guest.options & 
>> LOONGARCH_CPU_PMP)
>> +#define cpu_guest_has_watch    (cpu_data[0].guest.options & 
>> LOONGARCH_CPU_WATCH)
>> +#define cpu_guest_has_lsx    (cpu_data[0].guest.ases & 
>> LOONGARCH_ASE_LSX)
>
> There is no LOONGARCH_ASE_LSX either.
Thanks, I will fix the LOONGARCH_ASE_LSX macro

Thanks
Tianrui Zhao
>
>>     #endif /* __ASM_CPU_FEATURES_H */
>> diff --git a/arch/loongarch/include/asm/kvm_host.h 
>> b/arch/loongarch/include/asm/kvm_host.h
>> new file mode 100644
>> index 000000000000..bd239079b36f
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -0,0 +1,268 @@
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
>> +#define LOONGARCH_CSR_32(_R, _S)    \
>> +    (KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U32 | (8 * (_R) + (_S)))
>> +
>> +#define LOONGARCH_CSR_64(_R, _S)    \
>> +    (KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U64 | (8 * (_R) + (_S)))
>> +
>> +#define KVM_IOC_CSRID(id)        LOONGARCH_CSR_64(id, 0)
>> +#define KVM_GET_IOC_CSRIDX(id)        ((id & KVM_CSR_IDX_MASK) >> 3)
>> +
>> +#define KVM_MAX_VCPUS            256
>> +/* memory slots that does not exposed to userspace */
>> +#define KVM_PRIVATE_MEM_SLOTS        0
>> +
>> +#define KVM_HALT_POLL_NS_DEFAULT    500000
>> +
>> +struct kvm_vm_stat {
>> +    struct kvm_vm_stat_generic generic;
>> +};
>> +
>> +struct kvm_vcpu_stat {
>> +    struct kvm_vcpu_stat_generic generic;
>> +    u64 idle_exits;
>> +    u64 signal_exits;
>> +    u64 int_exits;
>> +    u64 cpucfg_exits;
>> +};
>> +
>> +struct kvm_arch_memory_slot {
>> +};
>> +
>> +struct kvm_context {
>> +    unsigned long vpid_cache;
>> +    struct kvm_vcpu *last_vcpu;
>> +};
>> +
>> +struct kvm_world_switch {
>> +    int (*guest_eentry)(void);
>> +    int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +    unsigned long page_order;
>> +};
>> +
>> +struct kvm_arch {
>> +    /* Guest physical mm */
>> +    struct mm_struct gpa_mm;
>> +    /* Mask of CPUs needing GPA ASID flush */
>> +    cpumask_t asid_flush_mask;
>> +
>> +    unsigned char online_vcpus;
>> +    unsigned char is_migrate;
>> +    s64 time_offset;
>> +    struct kvm_context __percpu *vmcs;
>> +    unsigned long gpa_size;
>> +};
>> +
>> +
>> +#define LOONGARCH_CSRS        0x100
>> +#define CSR_UCWIN_BASE        0x100
>> +#define CSR_UCWIN_SIZE        0x10
>> +#define CSR_DMWIN_BASE        0x180
>> +#define CSR_DMWIN_SIZE        0x4 > +#define CSR_PERF_BASE        0x200
>> +#define CSR_PERF_SIZE        0x8
>> +#define CSR_DEBUG_BASE        0x500
>> +#define CSR_DEBUG_SIZE        0x3
>> +#define CSR_ALL_SIZE        0x800
>
> Is the "SIZE"'s actually "numbers"? 16-byte or even 3-byte CSRs make 
> absolutely no sense in LoongArch. However e.g. there are indeed 4 
> DMWINs in total, so I think you may want to say "number of xxx" 
> instead (in which case you should probably name them "CSR_XXX_NUM").
Thanks, the meaning of the macro should be CSR max numbers, and I will 
change the macro name.

Thanks
Tianrui Zhao
>
> Also there are duplications here too.  CSR_UCWIN_BASE is just 
> LOONGARCH_CSR_UCAWIN, CSR_DMWIN_BASE is LOONGARCH_CSR_DMWIN0, 
> CSR_PERF_BASE is LOONGARCH_CSR_PERFCTRL0, and CSR_DEBUG_BASE is 
> LOONGARCH_CSR_DEBUG. You should at least avoid repeating the magic 
> numbers.
Thanks, I will remove the duplicate definitions of CSRs.

Thanks
Tianrui Zhao
>
>> +
>> +struct loongarch_csrs {
>> +    unsigned long csrs[CSR_ALL_SIZE];
>> +};
>> +
>> +/* Resume Flags */
>> +#define RESUME_GUEST        1
>> +#define RESUME_HOST        0
>> +
>> +enum emulation_result {
>> +    EMULATE_DONE,        /* no further processing */
>> +    EMULATE_DO_MMIO,    /* kvm_run filled with MMIO request */
>> +    EMULATE_FAIL,        /* can't emulate this instruction */
>> +    EMULATE_WAIT,        /* WAIT instruction */
>> +    EMULATE_EXCEPT,        /* A guest exception has been generated */
>> +    EMULATE_DO_IOCSR,    /* handle IOCSR request */
>> +};
>> +
>> +#define KVM_NR_MEM_OBJS        4
>> +#define KVM_LARCH_FPU        (0x1 << 0)
>> +#define KVM_LARCH_CSR        (0x1 << 1)
>> +
>> +struct kvm_vcpu_arch {
>> +    /*
>> +     * Switch pointer-to-function type to unsigned long
>> +     * for loading the value into register directly.
>> +     */
>> +    unsigned long guest_eentry;
>> +    unsigned long host_eentry;
>> +
>> +    /* Pointers stored here for easy access from assembly code. */
>
> nit: remove trailing period
Thanks, I will remove the trailing period

Thanks
Tianrui Zhao
>
>> +    int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +
>> +    /* Host registers preserved across guest mode execution */
>> +    unsigned long host_stack;
>> +    unsigned long host_gp;
>> +    unsigned long host_pgd;
>> +    unsigned long host_pgdhi;
>> +    unsigned long host_entryhi;
>> +
>> +    /* Host CSR registers used when handling exits from guest */
>
> nit: "Host CSRs"
Thanks, I will fix it.

Thanks
Tianrui Zhao
>
>> +    unsigned long badv;
>> +    unsigned long host_estat;
>> +    unsigned long badi;
>> +    unsigned long host_ecfg;
>> +    unsigned long host_percpu;
>> +
>> +    /* GPRS */
>
> nit: "GPRs"
Thanks, I will fix it

Thanks
Tianrui Zhao
>
>> +    unsigned long gprs[32];
>> +    unsigned long pc;
>> +
>> +    /* FPU State */
>
> nit: "state"
Thanks, I will fix it.

Thanks
Tianrui Zhao
>
>> +    struct loongarch_fpu fpu FPU_ALIGN;
>> +    /* Which auxiliary state is loaded (KVM_LOONGARCH_AUX_*) */
>> +    unsigned int aux_inuse;
>> +
>> +    /* CSR State */
>> +    struct loongarch_csrs *csr;
>> +
>> +    /* GPR used as IO source/target */
>> +    u32 io_gpr;
>> +
>> +    struct hrtimer swtimer;
>> +    /* Count timer control KVM register */
>
> This doesn't make sense, how can the timer control KVM? Seems 
> something like "KVM register to control count timer" but I'm not sure.
Ok, I will fix this comment.

Thanks
Tianrui Zhao
>
>
>> +    u32 count_ctl;
>> +
>> +    /* Bitmask of exceptions that are pending */
>> +    unsigned long irq_pending;
>> +    /* Bitmask of pending exceptions to be cleared */
>> +    unsigned long irq_clear;
>> +
>> +    /* Cache some mmu pages needed inside spinlock regions */
>
> "Cache for pages needed inside ..."?
>
>> +    struct kvm_mmu_memory_cache mmu_page_cache;
>> +
>> +    /* vcpu's vpid */
>> +    u64 vpid;
>> +
>> +    /* Period of stable timer tick in ns */
>> +    u64 timer_period;
>
> Can you make it "timer_period_ns" or are you following other arches' 
> conventions?
Thanks, I will change the name to timer_period_ns.

Thanks
Tianrui Zhao
>
>> +    /* Frequency of stable timer in Hz */
>> +    u64 timer_mhz;
>
> Is it really MHz or Hz?
Yes, it is MHz.

Thanks
Tianrui Zhao
>
>> +    /* Stable bias from the raw time */
>> +    u64 timer_bias;
>> +    /* Dynamic nanosecond bias (multiple of timer_period) to avoid 
>> overflow */
>> +    s64 timer_dyn_bias;
>> +    /* Save ktime */
>
> The comment seems redundant (code is too trivial so the comment 
> doesn't add any information).
Thanks I will remove this comment

Thanks
Tianrui Zhao
>
>> +    ktime_t stable_ktime_saved;
>> +
>> +    u64 core_ext_ioisr[4];
>> +
>> +    /* Last CPU the VCPU state was loaded on */
>
> Use consistent spelling: "vCPU".
Ok, I will fix it.

Thanks
Tianrui Zhao
>
>> +    int last_sched_cpu;
>> +    /* Last CPU the VCPU actually executed guest code on */
>> +    int last_exec_cpu;
>> +    /* mp state */
>> +    struct kvm_mp_state mp_state;
>> +};
>> +
>> +static inline unsigned long readl_sw_gcsr(struct loongarch_csrs 
>> *csr, int reg)
>> +{
>> +    return csr->csrs[reg];
>> +}
>> +
>> +static inline void writel_sw_gcsr(struct loongarch_csrs *csr, int reg,
>> +        unsigned long val)
>> +{
>> +    csr->csrs[reg] = val;
>> +}
>> +
>> +/* Helpers */
>> +static inline bool _kvm_guest_has_fpu(struct kvm_vcpu_arch *arch)
>> +{
>> +    return cpu_has_fpu;
>> +}
>> +
>> +void _kvm_init_fault(void);
>> +
>> +/* Debug: dump vcpu state */
>> +int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
>> +
>> +/* MMU handling */
>> +int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long badv, 
>> bool write);
>> +void kvm_flush_tlb_all(void);
>> +void _kvm_destroy_mm(struct kvm *kvm);
>> +pgd_t *kvm_pgd_alloc(void);
>> +
>> +#define KVM_ARCH_WANT_MMU_NOTIFIER
>> +int kvm_unmap_hva_range(struct kvm *kvm,
>> +            unsigned long start, unsigned long end, bool blockable);
>> +void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>> +int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long 
>> end);
>> +int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>> +
>> +static inline void update_pc(struct kvm_vcpu_arch *arch)
>> +{
>> +    arch->pc += 4;
>> +}
>> +
>> +/**
>> + * kvm_is_ifetch_fault() - Find whether a TLBL exception is due to 
>> ifetch fault.
>> + * @vcpu:    Virtual CPU.
>> + *
>> + * Returns:    Whether the TLBL exception was likely due to an 
>> instruction
>> + *        fetch fault rather than a data load fault.
>> + */
>> +static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *arch)
>> +{
>> +    if (arch->pc == arch->badv)
>> +        return true;
>> +
>> +    return false;
>
> return arch->pc == arch->badv;
>
> All other such occurrences should preferably be simplified too.
Thanks, I will fix this.

Thanks
Tianrui Zhao
>
>> +}
>> +
>> +/* Misc */
>> +static inline void kvm_arch_hardware_unsetup(void) {}
>> +static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>> +static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 
>> gen) {}
>> +static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>> +static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_arch_free_memslot(struct kvm *kvm,
>> +                   struct kvm_memory_slot *slot) {}
>> +void _kvm_check_vmid(struct kvm_vcpu *vcpu, int cpu);
>> +enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer);
>> +int kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa);
>> +void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>> +                    const struct kvm_memory_slot *memslot);
>> +void kvm_init_vmcs(struct kvm *kvm);
>> +void kvm_vector_entry(void);
>> +int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
>> +extern const unsigned long kvm_vector_size;
>> +extern const unsigned long kvm_enter_guest_size;
>> +extern unsigned long vpid_mask;
>> +extern struct kvm_world_switch *kvm_loongarch_ops;
>> +
>> +#define SW_GCSR    (1 << 0)
>> +#define HW_GCSR    (1 << 1)
>> +int get_gcsr_flag(int csr);
>> +extern void set_hw_gcsr(int csr_id, unsigned long val);
>> +#endif /* __ASM_LOONGARCH_KVM_HOST_H__ */
>> diff --git a/arch/loongarch/include/asm/kvm_types.h 
>> b/arch/loongarch/include/asm/kvm_types.h
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
>> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE    4
>
> Is there any difference with KVM_NR_MEM_OBJS in <asm/kvm_host.h> in 
> the same commit? If they are actually the same thing you should avoid 
> duplicating the "4".
Yes, I will remove the KVM_NR_MEM_OBJS in <asm/kvm_host.h>.

Thanks
Tianrui Zhao
>
>> +
>> +#endif /* _ASM_LOONGARCH_KVM_TYPES_H */
>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h 
>> b/arch/loongarch/include/uapi/asm/kvm.h
>> new file mode 100644
>> index 000000000000..074d86ba532c
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
>> +    /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
>> +    __u64 gpr[32];
>> +    __u64 pc;
>> +};
>> +
>> +/*
>> + * for KVM_GET_FPU and KVM_SET_FPU
>> + */
>> +struct kvm_fpu {
>> +    __u32 fcsr;
>> +    __u32 none;
>
> Is this field an explicit padding? Probably it's better to use a more 
> descriptive name like __pad0 if it's the case.
No, it is not a padding but a unused reg

Thanks
Tianrui Zhao
>
>> +    __u64 fcc;    /* 8x8 */
>> +    struct kvm_fpureg {
>> +        __u64 val64[4];
>> +    } fpr[32];
>> +};
>> +
>> +/*
>> + * For LoongArch, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to 
>> access various
>> + * registers.  The id field is broken down as follows:
>> + *
>> + *  bits[63..52] - As per linux/kvm.h
>> + *  bits[51..32] - Must be zero.
>> + *  bits[31..16] - Register set.
>> + *
>> + * Register set = 0: GP registers from kvm_regs (see definitions 
>> below).
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
>> +#define KVM_REG_LOONGARCH_GP        (KVM_REG_LOONGARCH | 0x00000ULL)
>> +#define KVM_REG_LOONGARCH_CSR        (KVM_REG_LOONGARCH | 0x10000ULL)
>> +#define KVM_REG_LOONGARCH_KVM        (KVM_REG_LOONGARCH | 0x20000ULL)
>> +#define KVM_REG_LOONGARCH_FPU        (KVM_REG_LOONGARCH | 0x30000ULL)
>> +#define KVM_REG_LOONGARCH_MASK        (KVM_REG_LOONGARCH | 0x30000ULL)
>> +#define KVM_CSR_IDX_MASK        (0x10000 - 1)
>> +
>> +/*
>> + * KVM_REG_LOONGARCH_KVM - KVM specific control registers.
>> + */
>> +
>> +#define KVM_REG_LOONGARCH_COUNTER    (KVM_REG_LOONGARCH_KVM | 
>> KVM_REG_SIZE_U64 | 3)
>> +#define KVM_REG_LOONGARCH_VCPU_RESET    (KVM_REG_LOONGARCH_KVM | 
>> KVM_REG_SIZE_U64 | 4)
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
>> +    __u32 addr;
>> +    __u32 pad;
>> +    __u64 data;
>> +};
>> +
>> +struct kvm_loongarch_interrupt {
>> +    /* in */
>> +    __u32 cpu;
>> +    __u32 irq;
>> +};
>> +
>> +#define KVM_NR_IRQCHIPS        1
>> +#define KVM_IRQCHIP_NUM_PINS    64
>> +#define KVM_MAX_CORES        256
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
>>     /* For KVM_EXIT_INTERNAL_ERROR */
>>   /* Emulate instruction failed. */
>> @@ -336,6 +337,13 @@ struct kvm_run {
>>               __u32 len;
>>               __u8  is_write;
>>           } mmio;
>> +        /* KVM_EXIT_LOONGARCH_IOCSR */
>> +        struct {
>> +            __u64 phys_addr;
>> +            __u8  data[8];
>> +            __u32 len;
>> +            __u8  is_write;
>> +        } iocsr_io;
>>           /* KVM_EXIT_HYPERCALL */
>>           struct {
>>               __u64 nr;
>> @@ -1354,6 +1362,7 @@ struct kvm_dirty_tlb {
>>   #define KVM_REG_ARM64        0x6000000000000000ULL
>>   #define KVM_REG_MIPS        0x7000000000000000ULL
>>   #define KVM_REG_RISCV        0x8000000000000000ULL
>> +#define KVM_REG_LOONGARCH    0x9000000000000000ULL
>>     #define KVM_REG_SIZE_SHIFT    52
>>   #define KVM_REG_SIZE_MASK    0x00f0000000000000ULL
>

