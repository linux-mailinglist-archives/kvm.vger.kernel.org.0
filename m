Return-Path: <kvm+bounces-66461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A6ACD4A67
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 04:47:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC4E9300ACCF
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 03:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85DD326935;
	Mon, 22 Dec 2025 03:46:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5AE155757;
	Mon, 22 Dec 2025 03:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766375217; cv=none; b=IzCgjxzYc4hR9+kVu/ybL6A8hYGK0bkuRLa8jMtwjDDrqHHa3Lp3V6Js8oCznY7L65mXPK8xEDXxEtKSymLPvnipLTQh4Qf+2OQffTFWSJt3fFVSckq5Bz28v9hzoBLWkmAqlZoYiffvxhs0VTEjvHg30b/sC3jSaheMr/wRqV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766375217; c=relaxed/simple;
	bh=gWeBvtCoa5rc0TlgvyJru0JihucBhIdZ3JvPOtEYuQ8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ooGReKxvNaneRHoE9BBvuVuBJluvAL6xVzYDINnL1vkvs7tKKh1AfHg2K2DUmYBKiFEb2GcYdA0odhW3w+knMX9TV2DlQSeXGiGGO80KzE5WDHIoKT3C+Ym9v8WmA8KbjdHFKFGVaXCTsfmqCC+kTgcjif/15YNEIY+0AH+bTtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.126])
	by gateway (Coremail) with SMTP id _____8CxLMMiv0hp0MYBAA--.5500S3;
	Mon, 22 Dec 2025 11:46:42 +0800 (CST)
Received: from [10.20.42.126] (unknown [10.20.42.126])
	by front1 (Coremail) with SMTP id qMiowJCx+8Edv0hpMzEDAA--.7265S3;
	Mon, 22 Dec 2025 11:46:39 +0800 (CST)
Subject: Re: [PATCH 1/2] LoongArch: KVM: Compile the switch.S file directly
 into the kernel
To: Huacai Chen <chenhuacai@kernel.org>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, stable@vger.kernel.org, WANG Xuerui
 <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Charlie Jenkins <charlie@rivosinc.com>,
 Thomas Gleixner <tglx@linutronix.de>
References: <20251217032450.954344-1-lixianglai@loongson.cn>
 <20251217032450.954344-2-lixianglai@loongson.cn>
 <CAAhV-H5g7KXK08vqKOR5HTsPKZ7X3CBa9fgfSTavnN7m9D_9AA@mail.gmail.com>
 <831f8f7e-1628-42e2-ca2e-7772ad9d3057@loongson.cn>
 <CAAhV-H5MnYJ4+e3N7S8GyWV+f63gfdNE-Q-rc7D1oOZFCQ4EoQ@mail.gmail.com>
From: lixianglai <lixianglai@loongson.cn>
Message-ID: <6661a394-84e8-20f6-8285-5e047c42248c@loongson.cn>
Date: Mon, 22 Dec 2025 11:43:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5MnYJ4+e3N7S8GyWV+f63gfdNE-Q-rc7D1oOZFCQ4EoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJCx+8Edv0hpMzEDAA--.7265S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj9fXoW3ZF47urWrGrWDWw4DCFyfAFc_yoW8GrW8Jo
	WayF4Igrs7Gryjqr15J3srta4Yva4Fkw4UC347Awn3WF17t3yUtry7Kw1rtFW3Ga1kGr47
	Ga43Xr45ZFy3Jr1Dl-sFpf9Il3svdjkaLaAFLSUrUUUU8b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUYX7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5xhLUUUUU=

Hi Huacai Chen:
> On Thu, Dec 18, 2025 at 7:08 PM lixianglai <lixianglai@loongson.cn> wrote:
>> Hi  Huacai Chen:
>>> Hi, Xianglai,
>>>
>>> On Wed, Dec 17, 2025 at 11:49 AM Xianglai Li <lixianglai@loongson.cn> wrote:
>>>> If we directly compile the switch.S file into the kernel, the address of
>>>> the kvm_exc_entry function will definitely be within the DMW memory area.
>>>> Therefore, we will no longer need to perform a copy relocation of
>>>> kvm_exc_entry.
>>>>
>>>> Based on the above description, compile switch.S directly into the kernel,
>>>> and then remove the copy relocation execution logic for the kvm_exc_entry
>>>> function.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>>>> ---
>>>> Cc: Huacai Chen <chenhuacai@kernel.org>
>>>> Cc: WANG Xuerui <kernel@xen0n.name>
>>>> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
>>>> Cc: Bibo Mao <maobibo@loongson.cn>
>>>> Cc: Charlie Jenkins <charlie@rivosinc.com>
>>>> Cc: Xianglai Li <lixianglai@loongson.cn>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>
>>>>    arch/loongarch/Kbuild                       |  2 +-
>>>>    arch/loongarch/include/asm/asm-prototypes.h | 16 ++++++++++
>>>>    arch/loongarch/include/asm/kvm_host.h       |  5 +--
>>>>    arch/loongarch/include/asm/kvm_vcpu.h       | 20 ++++++------
>>>>    arch/loongarch/kvm/Makefile                 |  2 +-
>>>>    arch/loongarch/kvm/main.c                   | 35 ++-------------------
>>>>    arch/loongarch/kvm/switch.S                 | 22 ++++++++++---
>>>>    7 files changed, 49 insertions(+), 53 deletions(-)
>>>>
>>>> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
>>>> index beb8499dd8ed..1c7a0dbe5e72 100644
>>>> --- a/arch/loongarch/Kbuild
>>>> +++ b/arch/loongarch/Kbuild
>>>> @@ -3,7 +3,7 @@ obj-y += mm/
>>>>    obj-y += net/
>>>>    obj-y += vdso/
>>>>
>>>> -obj-$(CONFIG_KVM) += kvm/
>>>> +obj-$(subst m,y,$(CONFIG_KVM)) += kvm/
>>>>
>>>>    # for cleaning
>>>>    subdir- += boot
>>>> diff --git a/arch/loongarch/include/asm/asm-prototypes.h b/arch/loongarch/include/asm/asm-prototypes.h
>>>> index 704066b4f736..eb591276d191 100644
>>>> --- a/arch/loongarch/include/asm/asm-prototypes.h
>>>> +++ b/arch/loongarch/include/asm/asm-prototypes.h
>>>> @@ -20,3 +20,19 @@ asmlinkage void noinstr __no_stack_protector ret_from_kernel_thread(struct task_
>>>>                                                                       struct pt_regs *regs,
>>>>                                                                       int (*fn)(void *),
>>>>                                                                       void *fn_arg);
>>>> +
>>>> +void kvm_exc_entry(void);
>>>> +int  kvm_enter_guest(void *run, void *vcpu);
>>>> +
>>>> +#ifdef CONFIG_CPU_HAS_LSX
>>>> +void kvm_save_lsx(void *fpu);
>>>> +void kvm_restore_lsx(void *fpu);
>>>> +#endif
>>>> +
>>>> +#ifdef CONFIG_CPU_HAS_LASX
>>>> +void kvm_save_lasx(void *fpu);
>>>> +void kvm_restore_lasx(void *fpu);
>>>> +#endif
>>>> +
>>>> +void kvm_save_fpu(void *fpu);
>>>> +void kvm_restore_fpu(void *fpu);
>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>>>> index e4fe5b8e8149..0aa7679536cc 100644
>>>> --- a/arch/loongarch/include/asm/kvm_host.h
>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
>>>> @@ -85,7 +85,6 @@ struct kvm_context {
>>>>    struct kvm_world_switch {
>>>>           int (*exc_entry)(void);
>>>>           int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>>>> -       unsigned long page_order;
>>>>    };
>>>>
>>>>    #define MAX_PGTABLE_LEVELS     4
>>>> @@ -344,11 +343,9 @@ enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer);
>>>>    void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm, const struct kvm_memory_slot *memslot);
>>>>    void kvm_init_vmcs(struct kvm *kvm);
>>>>    void kvm_exc_entry(void);
>>>> -int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
>>>> +int  kvm_enter_guest(void *run, void *vcpu);
>>>>
>>>>    extern unsigned long vpid_mask;
>>>> -extern const unsigned long kvm_exception_size;
>>>> -extern const unsigned long kvm_enter_guest_size;
>>>>    extern struct kvm_world_switch *kvm_loongarch_ops;
>>>>
>>>>    #define SW_GCSR                (1 << 0)
>>>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
>>>> index 3784ab4ccdb5..8af98a3d7b0c 100644
>>>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
>>>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
>>>> @@ -53,28 +53,28 @@ void kvm_deliver_exception(struct kvm_vcpu *vcpu);
>>>>
>>>>    void kvm_own_fpu(struct kvm_vcpu *vcpu);
>>>>    void kvm_lose_fpu(struct kvm_vcpu *vcpu);
>>>> -void kvm_save_fpu(struct loongarch_fpu *fpu);
>>>> -void kvm_restore_fpu(struct loongarch_fpu *fpu);
>>>> +void kvm_save_fpu(void *fpu);
>>>> +void kvm_restore_fpu(void *fpu);
>>> Why are these modifications needed?
>> In the assembly file switch.S, we used the macro definition
>> EXPORT_SYMBOL to export symbols without version information,
>> which led to an alarm during the compilation stage. In order to solve
>> this problem we need to put the symbol statement
>> in the file "arch/loongarch/include/asm/asm-prototypes.h", And function
>> declarations in the parameter types defined
>> in the header file "arch/loongarch/include/asm/kvm_host h", it is very
>> big, in order to reduce the
>> "arch/loongarch/include/asm/asm-prototypes.h" the contents of the file,
>> So we change the parameters in the function
>> declaration, then the function declaration directly into the file
>> "arch/loongarch/include/asm/asm-prototypes.h".
> I know what you want, but you needn't do this. You can simply add a
> line "struct loongarch_fpu;" in asm-prototypes.h before use.
Ok, got it, I'll fix it in the next version.
Thanks,
Xianglai.

> Huacai
>
>>> Huacai
>>>
>>>>    void kvm_restore_fcsr(struct loongarch_fpu *fpu);
>>>>
>>>>    #ifdef CONFIG_CPU_HAS_LSX
>>>>    int kvm_own_lsx(struct kvm_vcpu *vcpu);
>>>> -void kvm_save_lsx(struct loongarch_fpu *fpu);
>>>> -void kvm_restore_lsx(struct loongarch_fpu *fpu);
>>>> +void kvm_save_lsx(void *fpu);
>>>> +void kvm_restore_lsx(void *fpu);
>>>>    #else
>>>>    static inline int kvm_own_lsx(struct kvm_vcpu *vcpu) { return -EINVAL; }
>>>> -static inline void kvm_save_lsx(struct loongarch_fpu *fpu) { }
>>>> -static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
>>>> +static inline void kvm_save_lsx(void *fpu) { }
>>>> +static inline void kvm_restore_lsx(void *fpu) { }
>>>>    #endif
>>>>
>>>>    #ifdef CONFIG_CPU_HAS_LASX
>>>>    int kvm_own_lasx(struct kvm_vcpu *vcpu);
>>>> -void kvm_save_lasx(struct loongarch_fpu *fpu);
>>>> -void kvm_restore_lasx(struct loongarch_fpu *fpu);
>>>> +void kvm_save_lasx(void *fpu);
>>>> +void kvm_restore_lasx(void *fpu);
>>>>    #else
>>>>    static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { return -EINVAL; }
>>>> -static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
>>>> -static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
>>>> +static inline void kvm_save_lasx(void *fpu) { }
>>>> +static inline void kvm_restore_lasx(void *fpu) { }
>>>>    #endif
>>>>
>>>>    #ifdef CONFIG_CPU_HAS_LBT
>>>> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
>>>> index cb41d9265662..fe665054f824 100644
>>>> --- a/arch/loongarch/kvm/Makefile
>>>> +++ b/arch/loongarch/kvm/Makefile
>>>> @@ -11,7 +11,7 @@ kvm-y += exit.o
>>>>    kvm-y += interrupt.o
>>>>    kvm-y += main.o
>>>>    kvm-y += mmu.o
>>>> -kvm-y += switch.o
>>>> +obj-y += switch.o
>>>>    kvm-y += timer.o
>>>>    kvm-y += tlb.o
>>>>    kvm-y += vcpu.o
>>>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>>>> index 80ea63d465b8..67d234540ed4 100644
>>>> --- a/arch/loongarch/kvm/main.c
>>>> +++ b/arch/loongarch/kvm/main.c
>>>> @@ -340,8 +340,7 @@ void kvm_arch_disable_virtualization_cpu(void)
>>>>
>>>>    static int kvm_loongarch_env_init(void)
>>>>    {
>>>> -       int cpu, order, ret;
>>>> -       void *addr;
>>>> +       int cpu, ret;
>>>>           struct kvm_context *context;
>>>>
>>>>           vmcs = alloc_percpu(struct kvm_context);
>>>> @@ -357,30 +356,8 @@ static int kvm_loongarch_env_init(void)
>>>>                   return -ENOMEM;
>>>>           }
>>>>
>>>> -       /*
>>>> -        * PGD register is shared between root kernel and kvm hypervisor.
>>>> -        * So world switch entry should be in DMW area rather than TLB area
>>>> -        * to avoid page fault reenter.
>>>> -        *
>>>> -        * In future if hardware pagetable walking is supported, we won't
>>>> -        * need to copy world switch code to DMW area.
>>>> -        */
>>>> -       order = get_order(kvm_exception_size + kvm_enter_guest_size);
>>>> -       addr = (void *)__get_free_pages(GFP_KERNEL, order);
>>>> -       if (!addr) {
>>>> -               free_percpu(vmcs);
>>>> -               vmcs = NULL;
>>>> -               kfree(kvm_loongarch_ops);
>>>> -               kvm_loongarch_ops = NULL;
>>>> -               return -ENOMEM;
>>>> -       }
>>>> -
>>>> -       memcpy(addr, kvm_exc_entry, kvm_exception_size);
>>>> -       memcpy(addr + kvm_exception_size, kvm_enter_guest, kvm_enter_guest_size);
>>>> -       flush_icache_range((unsigned long)addr, (unsigned long)addr + kvm_exception_size + kvm_enter_guest_size);
>>>> -       kvm_loongarch_ops->exc_entry = addr;
>>>> -       kvm_loongarch_ops->enter_guest = addr + kvm_exception_size;
>>>> -       kvm_loongarch_ops->page_order = order;
>>>> +       kvm_loongarch_ops->exc_entry = (void *)kvm_exc_entry;
>>>> +       kvm_loongarch_ops->enter_guest = (void *)kvm_enter_guest;
>>>>
>>>>           vpid_mask = read_csr_gstat();
>>>>           vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_SHIFT;
>>>> @@ -414,16 +391,10 @@ static int kvm_loongarch_env_init(void)
>>>>
>>>>    static void kvm_loongarch_env_exit(void)
>>>>    {
>>>> -       unsigned long addr;
>>>> -
>>>>           if (vmcs)
>>>>                   free_percpu(vmcs);
>>>>
>>>>           if (kvm_loongarch_ops) {
>>>> -               if (kvm_loongarch_ops->exc_entry) {
>>>> -                       addr = (unsigned long)kvm_loongarch_ops->exc_entry;
>>>> -                       free_pages(addr, kvm_loongarch_ops->page_order);
>>>> -               }
>>>>                   kfree(kvm_loongarch_ops);
>>>>           }
>>>>
>>>> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
>>>> index f1768b7a6194..93845ce53651 100644
>>>> --- a/arch/loongarch/kvm/switch.S
>>>> +++ b/arch/loongarch/kvm/switch.S
>>>> @@ -5,6 +5,7 @@
>>>>
>>>>    #include <linux/linkage.h>
>>>>    #include <asm/asm.h>
>>>> +#include <asm/page.h>
>>>>    #include <asm/asmmacro.h>
>>>>    #include <asm/loongarch.h>
>>>>    #include <asm/regdef.h>
>>>> @@ -100,10 +101,18 @@
>>>>            *  -        is still in guest mode, such as pgd table/vmid registers etc,
>>>>            *  -        will fix with hw page walk enabled in future
>>>>            * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to KVM_TEMP_KS
>>>> +        *
>>>> +        * PGD register is shared between root kernel and kvm hypervisor.
>>>> +        * So world switch entry should be in DMW area rather than TLB area
>>>> +        * to avoid page fault reenter.
>>>> +        *
>>>> +        * In future if hardware pagetable walking is supported, we won't
>>>> +        * need to copy world switch code to DMW area.
>>>>            */
>>>>           .text
>>>>           .cfi_sections   .debug_frame
>>>>    SYM_CODE_START(kvm_exc_entry)
>>>> +       .p2align PAGE_SHIFT
>>>>           UNWIND_HINT_UNDEFINED
>>>>           csrwr   a2,   KVM_TEMP_KS
>>>>           csrrd   a2,   KVM_VCPU_KS
>>>> @@ -190,8 +199,8 @@ ret_to_host:
>>>>           kvm_restore_host_gpr    a2
>>>>           jr      ra
>>>>
>>>> -SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
>>>>    SYM_CODE_END(kvm_exc_entry)
>>>> +EXPORT_SYMBOL(kvm_exc_entry)
>>>>
>>>>    /*
>>>>     * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
>>>> @@ -215,8 +224,8 @@ SYM_FUNC_START(kvm_enter_guest)
>>>>           /* Save kvm_vcpu to kscratch */
>>>>           csrwr   a1, KVM_VCPU_KS
>>>>           kvm_switch_to_guest
>>>> -SYM_INNER_LABEL(kvm_enter_guest_end, SYM_L_LOCAL)
>>>>    SYM_FUNC_END(kvm_enter_guest)
>>>> +EXPORT_SYMBOL(kvm_enter_guest)
>>>>
>>>>    SYM_FUNC_START(kvm_save_fpu)
>>>>           fpu_save_csr    a0 t1
>>>> @@ -224,6 +233,7 @@ SYM_FUNC_START(kvm_save_fpu)
>>>>           fpu_save_cc     a0 t1 t2
>>>>           jr              ra
>>>>    SYM_FUNC_END(kvm_save_fpu)
>>>> +EXPORT_SYMBOL(kvm_save_fpu)
>>>>
>>>>    SYM_FUNC_START(kvm_restore_fpu)
>>>>           fpu_restore_double a0 t1
>>>> @@ -231,6 +241,7 @@ SYM_FUNC_START(kvm_restore_fpu)
>>>>           fpu_restore_cc     a0 t1 t2
>>>>           jr                 ra
>>>>    SYM_FUNC_END(kvm_restore_fpu)
>>>> +EXPORT_SYMBOL(kvm_restore_fpu)
>>>>
>>>>    #ifdef CONFIG_CPU_HAS_LSX
>>>>    SYM_FUNC_START(kvm_save_lsx)
>>>> @@ -239,6 +250,7 @@ SYM_FUNC_START(kvm_save_lsx)
>>>>           lsx_save_data   a0 t1
>>>>           jr              ra
>>>>    SYM_FUNC_END(kvm_save_lsx)
>>>> +EXPORT_SYMBOL(kvm_save_lsx)
>>>>
>>>>    SYM_FUNC_START(kvm_restore_lsx)
>>>>           lsx_restore_data a0 t1
>>>> @@ -246,6 +258,7 @@ SYM_FUNC_START(kvm_restore_lsx)
>>>>           fpu_restore_csr  a0 t1 t2
>>>>           jr               ra
>>>>    SYM_FUNC_END(kvm_restore_lsx)
>>>> +EXPORT_SYMBOL(kvm_restore_lsx)
>>>>    #endif
>>>>
>>>>    #ifdef CONFIG_CPU_HAS_LASX
>>>> @@ -255,6 +268,7 @@ SYM_FUNC_START(kvm_save_lasx)
>>>>           lasx_save_data  a0 t1
>>>>           jr              ra
>>>>    SYM_FUNC_END(kvm_save_lasx)
>>>> +EXPORT_SYMBOL(kvm_save_lasx)
>>>>
>>>>    SYM_FUNC_START(kvm_restore_lasx)
>>>>           lasx_restore_data a0 t1
>>>> @@ -262,10 +276,8 @@ SYM_FUNC_START(kvm_restore_lasx)
>>>>           fpu_restore_csr   a0 t1 t2
>>>>           jr                ra
>>>>    SYM_FUNC_END(kvm_restore_lasx)
>>>> +EXPORT_SYMBOL(kvm_restore_lasx)
>>>>    #endif
>>>> -       .section ".rodata"
>>>> -SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
>>>> -SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
>>>>
>>>>    #ifdef CONFIG_CPU_HAS_LBT
>>>>    STACK_FRAME_NON_STANDARD kvm_restore_fpu
>>>> --
>>>> 2.39.1
>>>>
>>>>


