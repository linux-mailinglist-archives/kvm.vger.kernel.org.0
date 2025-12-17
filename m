Return-Path: <kvm+bounces-66106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C954CC5FC1
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 05:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B2A6302B77A
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 04:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B50231A21;
	Wed, 17 Dec 2025 04:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBdti7St"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9CA25776
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 04:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765947308; cv=none; b=nyYfRLktdBzr2C+tm37HrgQHvU40Xwz3FEzhAiLnvUxF8OIm/7q2n4vSmsNdxOdrBl23G6/QaXYsGynBvBxWdM/skQpqeALJf8pwmqp69WWT9YW53npEd3LFuS1LKQ5wGNwz/L0NdsRhALlBsZzS2xngcp4yB+1gpFz5aFpYE74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765947308; c=relaxed/simple;
	bh=lAHGMMu6N3KIyR0A+0L13L+SSADR37OawFsR2bx8C3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I7geEbMOAK/QtEpp6JTMLYJSHtN5B4K3/bubLl5zV7ceJdgfZwDCjEQmvEUGidRAUAotKdErSsr7GGg0jVF3drBmERc0vVToFqrr7k3i1PLcetTYZgJJ4hFadHmK2vDDln/ynkCgYmccGXo2MTqYLu4nmimb6nZ+6X+QPzcSpFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBdti7St; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7229C113D0
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 04:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765947307;
	bh=lAHGMMu6N3KIyR0A+0L13L+SSADR37OawFsR2bx8C3w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aBdti7StnXTFGM7LF+vE6aLjHRdpibvUtPvxsJizZmh0pKscTEQa9oJf/7Jxjisxb
	 A4ApOM1kafo2mtTThyFK25PSUwKFVk80Rw+6U01Cx3XtfUhoZiz9TFeaoiy6BnHKwf
	 cCLe7ClSrzUHqzXu4wyJ15WdlzkBQzrF2nam6INF6znphAej89Ota+1wbKrTfd7whU
	 kf50xufv8wtA4a0s64Zl9ZWSHDuuZv0WVApSduIR9O3JM6wvEbXoIjXZzNU1/LOVU7
	 JL8HuanHOOHvfAzgauqTDjvHNsUmiT26KqwEXor795wGmu+S3wlDyo+Eud+eW43aoB
	 6g/N7xvh4kLnQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b7ffa5d1b80so163867066b.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 20:55:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX07/K0ryemdSZlJoyvXhfnTH/p4X6VT1d1je808dNXoQB1mfPzXmJ9TPU8ep67SzXhRug=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHacDoHoRQzzsUHRy0kmXe0tNDmR/aP0xZjTUeCgARputUpSKI
	4ntvE9i3aeOuv85EufIgE2a7bsZzIEEYX1eci5F0ndE5zNb6N2MYP1I6KKaFrwjANhdatwCvoZb
	iItInen8U5OZQPu+KBgxaW2AWGDSh7Ek=
X-Google-Smtp-Source: AGHT+IFAoom6hG9Dt8hOVD8egVwao+xt5F1b4wnA93K5h4TvpEA6sJ+Q8uA4HuejzTDAJjC/ULJyquXXRDbT5ydrExs=
X-Received: by 2002:a17:907:3ea8:b0:b7a:9cc5:4580 with SMTP id
 a640c23a62f3a-b7d236eeb00mr1714341866b.27.1765947306265; Tue, 16 Dec 2025
 20:55:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217032450.954344-1-lixianglai@loongson.cn> <20251217032450.954344-2-lixianglai@loongson.cn>
In-Reply-To: <20251217032450.954344-2-lixianglai@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 17 Dec 2025 12:55:19 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5g7KXK08vqKOR5HTsPKZ7X3CBa9fgfSTavnN7m9D_9AA@mail.gmail.com>
X-Gm-Features: AQt7F2pwNY2gTmTWS1K0BIjtqBZO1HmebMffODnjSz6bYm5Kbe45yC7GIOglavE
Message-ID: <CAAhV-H5g7KXK08vqKOR5HTsPKZ7X3CBa9fgfSTavnN7m9D_9AA@mail.gmail.com>
Subject: Re: [PATCH 1/2] LoongArch: KVM: Compile the switch.S file directly
 into the kernel
To: Xianglai Li <lixianglai@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, stable@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Xianglai,

On Wed, Dec 17, 2025 at 11:49=E2=80=AFAM Xianglai Li <lixianglai@loongson.c=
n> wrote:
>
> If we directly compile the switch.S file into the kernel, the address of
> the kvm_exc_entry function will definitely be within the DMW memory area.
> Therefore, we will no longer need to perform a copy relocation of
> kvm_exc_entry.
>
> Based on the above description, compile switch.S directly into the kernel=
,
> and then remove the copy relocation execution logic for the kvm_exc_entry
> function.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Charlie Jenkins <charlie@rivosinc.com>
> Cc: Xianglai Li <lixianglai@loongson.cn>
> Cc: Thomas Gleixner <tglx@linutronix.de>
>
>  arch/loongarch/Kbuild                       |  2 +-
>  arch/loongarch/include/asm/asm-prototypes.h | 16 ++++++++++
>  arch/loongarch/include/asm/kvm_host.h       |  5 +--
>  arch/loongarch/include/asm/kvm_vcpu.h       | 20 ++++++------
>  arch/loongarch/kvm/Makefile                 |  2 +-
>  arch/loongarch/kvm/main.c                   | 35 ++-------------------
>  arch/loongarch/kvm/switch.S                 | 22 ++++++++++---
>  7 files changed, 49 insertions(+), 53 deletions(-)
>
> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
> index beb8499dd8ed..1c7a0dbe5e72 100644
> --- a/arch/loongarch/Kbuild
> +++ b/arch/loongarch/Kbuild
> @@ -3,7 +3,7 @@ obj-y +=3D mm/
>  obj-y +=3D net/
>  obj-y +=3D vdso/
>
> -obj-$(CONFIG_KVM) +=3D kvm/
> +obj-$(subst m,y,$(CONFIG_KVM)) +=3D kvm/
>
>  # for cleaning
>  subdir- +=3D boot
> diff --git a/arch/loongarch/include/asm/asm-prototypes.h b/arch/loongarch=
/include/asm/asm-prototypes.h
> index 704066b4f736..eb591276d191 100644
> --- a/arch/loongarch/include/asm/asm-prototypes.h
> +++ b/arch/loongarch/include/asm/asm-prototypes.h
> @@ -20,3 +20,19 @@ asmlinkage void noinstr __no_stack_protector ret_from_=
kernel_thread(struct task_
>                                                                     struc=
t pt_regs *regs,
>                                                                     int (=
*fn)(void *),
>                                                                     void =
*fn_arg);
> +
> +void kvm_exc_entry(void);
> +int  kvm_enter_guest(void *run, void *vcpu);
> +
> +#ifdef CONFIG_CPU_HAS_LSX
> +void kvm_save_lsx(void *fpu);
> +void kvm_restore_lsx(void *fpu);
> +#endif
> +
> +#ifdef CONFIG_CPU_HAS_LASX
> +void kvm_save_lasx(void *fpu);
> +void kvm_restore_lasx(void *fpu);
> +#endif
> +
> +void kvm_save_fpu(void *fpu);
> +void kvm_restore_fpu(void *fpu);
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index e4fe5b8e8149..0aa7679536cc 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -85,7 +85,6 @@ struct kvm_context {
>  struct kvm_world_switch {
>         int (*exc_entry)(void);
>         int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> -       unsigned long page_order;
>  };
>
>  #define MAX_PGTABLE_LEVELS     4
> @@ -344,11 +343,9 @@ enum hrtimer_restart kvm_swtimer_wakeup(struct hrtim=
er *timer);
>  void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm, const struct kv=
m_memory_slot *memslot);
>  void kvm_init_vmcs(struct kvm *kvm);
>  void kvm_exc_entry(void);
> -int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
> +int  kvm_enter_guest(void *run, void *vcpu);
>
>  extern unsigned long vpid_mask;
> -extern const unsigned long kvm_exception_size;
> -extern const unsigned long kvm_enter_guest_size;
>  extern struct kvm_world_switch *kvm_loongarch_ops;
>
>  #define SW_GCSR                (1 << 0)
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/inclu=
de/asm/kvm_vcpu.h
> index 3784ab4ccdb5..8af98a3d7b0c 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -53,28 +53,28 @@ void kvm_deliver_exception(struct kvm_vcpu *vcpu);
>
>  void kvm_own_fpu(struct kvm_vcpu *vcpu);
>  void kvm_lose_fpu(struct kvm_vcpu *vcpu);
> -void kvm_save_fpu(struct loongarch_fpu *fpu);
> -void kvm_restore_fpu(struct loongarch_fpu *fpu);
> +void kvm_save_fpu(void *fpu);
> +void kvm_restore_fpu(void *fpu);
Why are these modifications needed?

Huacai

>  void kvm_restore_fcsr(struct loongarch_fpu *fpu);
>
>  #ifdef CONFIG_CPU_HAS_LSX
>  int kvm_own_lsx(struct kvm_vcpu *vcpu);
> -void kvm_save_lsx(struct loongarch_fpu *fpu);
> -void kvm_restore_lsx(struct loongarch_fpu *fpu);
> +void kvm_save_lsx(void *fpu);
> +void kvm_restore_lsx(void *fpu);
>  #else
>  static inline int kvm_own_lsx(struct kvm_vcpu *vcpu) { return -EINVAL; }
> -static inline void kvm_save_lsx(struct loongarch_fpu *fpu) { }
> -static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
> +static inline void kvm_save_lsx(void *fpu) { }
> +static inline void kvm_restore_lsx(void *fpu) { }
>  #endif
>
>  #ifdef CONFIG_CPU_HAS_LASX
>  int kvm_own_lasx(struct kvm_vcpu *vcpu);
> -void kvm_save_lasx(struct loongarch_fpu *fpu);
> -void kvm_restore_lasx(struct loongarch_fpu *fpu);
> +void kvm_save_lasx(void *fpu);
> +void kvm_restore_lasx(void *fpu);
>  #else
>  static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { return -EINVAL; =
}
> -static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
> -static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
> +static inline void kvm_save_lasx(void *fpu) { }
> +static inline void kvm_restore_lasx(void *fpu) { }
>  #endif
>
>  #ifdef CONFIG_CPU_HAS_LBT
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index cb41d9265662..fe665054f824 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -11,7 +11,7 @@ kvm-y +=3D exit.o
>  kvm-y +=3D interrupt.o
>  kvm-y +=3D main.o
>  kvm-y +=3D mmu.o
> -kvm-y +=3D switch.o
> +obj-y +=3D switch.o
>  kvm-y +=3D timer.o
>  kvm-y +=3D tlb.o
>  kvm-y +=3D vcpu.o
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 80ea63d465b8..67d234540ed4 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -340,8 +340,7 @@ void kvm_arch_disable_virtualization_cpu(void)
>
>  static int kvm_loongarch_env_init(void)
>  {
> -       int cpu, order, ret;
> -       void *addr;
> +       int cpu, ret;
>         struct kvm_context *context;
>
>         vmcs =3D alloc_percpu(struct kvm_context);
> @@ -357,30 +356,8 @@ static int kvm_loongarch_env_init(void)
>                 return -ENOMEM;
>         }
>
> -       /*
> -        * PGD register is shared between root kernel and kvm hypervisor.
> -        * So world switch entry should be in DMW area rather than TLB ar=
ea
> -        * to avoid page fault reenter.
> -        *
> -        * In future if hardware pagetable walking is supported, we won't
> -        * need to copy world switch code to DMW area.
> -        */
> -       order =3D get_order(kvm_exception_size + kvm_enter_guest_size);
> -       addr =3D (void *)__get_free_pages(GFP_KERNEL, order);
> -       if (!addr) {
> -               free_percpu(vmcs);
> -               vmcs =3D NULL;
> -               kfree(kvm_loongarch_ops);
> -               kvm_loongarch_ops =3D NULL;
> -               return -ENOMEM;
> -       }
> -
> -       memcpy(addr, kvm_exc_entry, kvm_exception_size);
> -       memcpy(addr + kvm_exception_size, kvm_enter_guest, kvm_enter_gues=
t_size);
> -       flush_icache_range((unsigned long)addr, (unsigned long)addr + kvm=
_exception_size + kvm_enter_guest_size);
> -       kvm_loongarch_ops->exc_entry =3D addr;
> -       kvm_loongarch_ops->enter_guest =3D addr + kvm_exception_size;
> -       kvm_loongarch_ops->page_order =3D order;
> +       kvm_loongarch_ops->exc_entry =3D (void *)kvm_exc_entry;
> +       kvm_loongarch_ops->enter_guest =3D (void *)kvm_enter_guest;
>
>         vpid_mask =3D read_csr_gstat();
>         vpid_mask =3D (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_=
SHIFT;
> @@ -414,16 +391,10 @@ static int kvm_loongarch_env_init(void)
>
>  static void kvm_loongarch_env_exit(void)
>  {
> -       unsigned long addr;
> -
>         if (vmcs)
>                 free_percpu(vmcs);
>
>         if (kvm_loongarch_ops) {
> -               if (kvm_loongarch_ops->exc_entry) {
> -                       addr =3D (unsigned long)kvm_loongarch_ops->exc_en=
try;
> -                       free_pages(addr, kvm_loongarch_ops->page_order);
> -               }
>                 kfree(kvm_loongarch_ops);
>         }
>
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index f1768b7a6194..93845ce53651 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -5,6 +5,7 @@
>
>  #include <linux/linkage.h>
>  #include <asm/asm.h>
> +#include <asm/page.h>
>  #include <asm/asmmacro.h>
>  #include <asm/loongarch.h>
>  #include <asm/regdef.h>
> @@ -100,10 +101,18 @@
>          *  -        is still in guest mode, such as pgd table/vmid regis=
ters etc,
>          *  -        will fix with hw page walk enabled in future
>          * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to KV=
M_TEMP_KS
> +        *
> +        * PGD register is shared between root kernel and kvm hypervisor.
> +        * So world switch entry should be in DMW area rather than TLB ar=
ea
> +        * to avoid page fault reenter.
> +        *
> +        * In future if hardware pagetable walking is supported, we won't
> +        * need to copy world switch code to DMW area.
>          */
>         .text
>         .cfi_sections   .debug_frame
>  SYM_CODE_START(kvm_exc_entry)
> +       .p2align PAGE_SHIFT
>         UNWIND_HINT_UNDEFINED
>         csrwr   a2,   KVM_TEMP_KS
>         csrrd   a2,   KVM_VCPU_KS
> @@ -190,8 +199,8 @@ ret_to_host:
>         kvm_restore_host_gpr    a2
>         jr      ra
>
> -SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
>  SYM_CODE_END(kvm_exc_entry)
> +EXPORT_SYMBOL(kvm_exc_entry)
>
>  /*
>   * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
> @@ -215,8 +224,8 @@ SYM_FUNC_START(kvm_enter_guest)
>         /* Save kvm_vcpu to kscratch */
>         csrwr   a1, KVM_VCPU_KS
>         kvm_switch_to_guest
> -SYM_INNER_LABEL(kvm_enter_guest_end, SYM_L_LOCAL)
>  SYM_FUNC_END(kvm_enter_guest)
> +EXPORT_SYMBOL(kvm_enter_guest)
>
>  SYM_FUNC_START(kvm_save_fpu)
>         fpu_save_csr    a0 t1
> @@ -224,6 +233,7 @@ SYM_FUNC_START(kvm_save_fpu)
>         fpu_save_cc     a0 t1 t2
>         jr              ra
>  SYM_FUNC_END(kvm_save_fpu)
> +EXPORT_SYMBOL(kvm_save_fpu)
>
>  SYM_FUNC_START(kvm_restore_fpu)
>         fpu_restore_double a0 t1
> @@ -231,6 +241,7 @@ SYM_FUNC_START(kvm_restore_fpu)
>         fpu_restore_cc     a0 t1 t2
>         jr                 ra
>  SYM_FUNC_END(kvm_restore_fpu)
> +EXPORT_SYMBOL(kvm_restore_fpu)
>
>  #ifdef CONFIG_CPU_HAS_LSX
>  SYM_FUNC_START(kvm_save_lsx)
> @@ -239,6 +250,7 @@ SYM_FUNC_START(kvm_save_lsx)
>         lsx_save_data   a0 t1
>         jr              ra
>  SYM_FUNC_END(kvm_save_lsx)
> +EXPORT_SYMBOL(kvm_save_lsx)
>
>  SYM_FUNC_START(kvm_restore_lsx)
>         lsx_restore_data a0 t1
> @@ -246,6 +258,7 @@ SYM_FUNC_START(kvm_restore_lsx)
>         fpu_restore_csr  a0 t1 t2
>         jr               ra
>  SYM_FUNC_END(kvm_restore_lsx)
> +EXPORT_SYMBOL(kvm_restore_lsx)
>  #endif
>
>  #ifdef CONFIG_CPU_HAS_LASX
> @@ -255,6 +268,7 @@ SYM_FUNC_START(kvm_save_lasx)
>         lasx_save_data  a0 t1
>         jr              ra
>  SYM_FUNC_END(kvm_save_lasx)
> +EXPORT_SYMBOL(kvm_save_lasx)
>
>  SYM_FUNC_START(kvm_restore_lasx)
>         lasx_restore_data a0 t1
> @@ -262,10 +276,8 @@ SYM_FUNC_START(kvm_restore_lasx)
>         fpu_restore_csr   a0 t1 t2
>         jr                ra
>  SYM_FUNC_END(kvm_restore_lasx)
> +EXPORT_SYMBOL(kvm_restore_lasx)
>  #endif
> -       .section ".rodata"
> -SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
> -SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_gue=
st)
>
>  #ifdef CONFIG_CPU_HAS_LBT
>  STACK_FRAME_NON_STANDARD kvm_restore_fpu
> --
> 2.39.1
>
>

