Return-Path: <kvm+bounces-66565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2E1CD7E3A
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 03:41:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AF1A7301FA7C
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 02:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95D628BA95;
	Tue, 23 Dec 2025 02:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Plc/5dxg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53582405EC
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 02:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766457665; cv=none; b=Kc/bGGIpU1mdw41aGC2YDvKqDKC1eF/mcS4pZ+LbEtr82gXXNdKIs55zaiIC0pv7O7UsO+HPIRVR2+rYc559u7v4/V+zaQnjb66nkR2azHzQOXIBXL+rlYFiyYOuBHy2LYa8CU2JJUf+DcoCRtif6wsPIIv/83OOS6uWjkICkbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766457665; c=relaxed/simple;
	bh=9OtDXyTBxpWXWP29L5tgZAQoyx3TfeieKZxdhGpGKeE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YngrJKTRAH7PrcRaVh4ZC5w+yeXvBfVvbW+paB1I3Sj8AXKRV+7YPxgI/B9bbpFW69paarpxMAJI9GEd+UyGWTE+t6cE6rbGG9k808/4JVgMtUQe7/QPVZEVkLH7WR7J+pjr8viSjaflCjCvz8sWbyuf4ZWjvcu8njk+GLGJwlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Plc/5dxg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFB5C19424
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 02:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766457665;
	bh=9OtDXyTBxpWXWP29L5tgZAQoyx3TfeieKZxdhGpGKeE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Plc/5dxgr9lGfBtIJ1a2Isi703JQZCfzCJOabhFO6nKssqJXWL/P595PG8TINet5g
	 yitMflg/1Yc6hQ6IU9RjEVKpQwt1Jr6WZ7hjjfBUvKJ7p//YOv032+L6lRTPJclS6O
	 Fc1ZpC5pFXfuA8pzLXiBeB3vopoBWEzHLW1ClHGzT2JcUXCA4oKaDzyYiBqrs1Ddie
	 sUBOx1KMSXcgpRASx2Vz18TQwvE066V0LJPfJWzuNfbBSg+EpRzCWiplcpRsSOBkEF
	 2lkFn5VcxcacHr2uqwkoKwzHp+4r44n9VOouat1zZ8ySpdC8atWWMscLfwtAVEPWGH
	 4Jp8wytz5mo2Q==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b61f82b5fso5922101a12.0
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 18:41:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXbDs/Fo9wpF01KUiuuRnp+QEYtCVxLnQlHMYADCWe8Pnfxu1FO7e8RX7veNoDHQpMejlE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyT5IuOb8Mn/dmfnRhAZAlWBg5eFFmHkipjedlx87ZKE2r3SGL
	jZ8fjN9C5B8bOY27F9ntiRBLchqLdVlOJKyAhpsUoqg0K0fzJ6I80zsllmVxNu8ZCc4NgrTHSGf
	pj4z7CYU6pTeN0qPDm3E88wdUTFC6RT0=
X-Google-Smtp-Source: AGHT+IHYxB0wMb2kmbCYDGlcOPB5M/NrfL4ez7DrMu+0sJgd3OVq9G81iXu7ZIeSO7V1OEc+KMD0wbl1aUiaF27vN+A=
X-Received: by 2002:a17:907:608c:b0:b76:e346:f74 with SMTP id
 a640c23a62f3a-b8036f637f2mr1262528266b.16.1766457663778; Mon, 22 Dec 2025
 18:41:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251222113409.2343711-1-lixianglai@loongson.cn>
 <20251222113409.2343711-2-lixianglai@loongson.cn> <1dbb85b2-9b3b-a1b4-6fe2-b549099ab876@loongson.cn>
 <c83f82a9-8981-2fee-867e-17ae5dba3f0d@loongson.cn>
In-Reply-To: <c83f82a9-8981-2fee-867e-17ae5dba3f0d@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 23 Dec 2025 10:41:17 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6KtgTZJJc55ZB00p4oxrhOUvf9qn4Ls1mzDoO9QQ9gLw@mail.gmail.com>
X-Gm-Features: AQt7F2pz3-_pxZLqA5Gxp3h28z_ga-VQOSnovNAfY-YY6TFW18pD5t9PLGSUFj8
Message-ID: <CAAhV-H6KtgTZJJc55ZB00p4oxrhOUvf9qn4Ls1mzDoO9QQ9gLw@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] LoongArch: KVM: Compile the switch.S file directly
 into the kernel
To: lixianglai <lixianglai@loongson.cn>
Cc: Bibo Mao <maobibo@loongson.cn>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org, 
	WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Xianglai,

On Tue, Dec 23, 2025 at 10:38=E2=80=AFAM lixianglai <lixianglai@loongson.cn=
> wrote:
>
> Hi Bibo Mao:
> >
> >
> > On 2025/12/22 =E4=B8=8B=E5=8D=887:34, Xianglai Li wrote:
> >> If we directly compile the switch.S file into the kernel, the address =
of
> >> the kvm_exc_entry function will definitely be within the DMW memory
> >> area.
> >> Therefore, we will no longer need to perform a copy relocation of
> >> kvm_exc_entry.
> >>
> >> Based on the above description, compile switch.S directly into the
> >> kernel,
> >> and then remove the copy relocation execution logic for the
> >> kvm_exc_entry
> >> function.
> >>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> >> ---
> >> Cc: Huacai Chen <chenhuacai@kernel.org>
> >> Cc: WANG Xuerui <kernel@xen0n.name>
> >> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> >> Cc: Bibo Mao <maobibo@loongson.cn>
> >> Cc: Charlie Jenkins <charlie@rivosinc.com>
> >> Cc: Xianglai Li <lixianglai@loongson.cn>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>
> >>   arch/loongarch/Kbuild                       |  2 +-
> >>   arch/loongarch/include/asm/asm-prototypes.h | 21 +++++++++++++
> >>   arch/loongarch/include/asm/kvm_host.h       |  3 --
> >>   arch/loongarch/kvm/Makefile                 |  2 +-
> >>   arch/loongarch/kvm/main.c                   | 35 ++-----------------=
--
> >>   arch/loongarch/kvm/switch.S                 | 22 ++++++++++---
> >>   6 files changed, 43 insertions(+), 42 deletions(-)
> >>
> >> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
> >> index beb8499dd8ed..1c7a0dbe5e72 100644
> >> --- a/arch/loongarch/Kbuild
> >> +++ b/arch/loongarch/Kbuild
> >> @@ -3,7 +3,7 @@ obj-y +=3D mm/
> >>   obj-y +=3D net/
> >>   obj-y +=3D vdso/
> >>   -obj-$(CONFIG_KVM) +=3D kvm/
> >> +obj-$(subst m,y,$(CONFIG_KVM)) +=3D kvm/
> >>     # for cleaning
> >>   subdir- +=3D boot
> >> diff --git a/arch/loongarch/include/asm/asm-prototypes.h
> >> b/arch/loongarch/include/asm/asm-prototypes.h
> >> index 704066b4f736..e8ce153691e5 100644
> >> --- a/arch/loongarch/include/asm/asm-prototypes.h
> >> +++ b/arch/loongarch/include/asm/asm-prototypes.h
> >> @@ -20,3 +20,24 @@ asmlinkage void noinstr __no_stack_protector
> >> ret_from_kernel_thread(struct task_
> >>                                       struct pt_regs *regs,
> >>                                       int (*fn)(void *),
> >>                                       void *fn_arg);
> >> +
> >> +struct kvm_run;
> >> +struct kvm_vcpu;
> >> +
> >> +void kvm_exc_entry(void);
> >> +int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
> >> +
> >> +struct loongarch_fpu;
> >> +
> >> +#ifdef CONFIG_CPU_HAS_LSX
> >> +void kvm_save_lsx(struct loongarch_fpu *fpu);
> >> +void kvm_restore_lsx(struct loongarch_fpu *fpu);
> >> +#endif
> >> +
> >> +#ifdef CONFIG_CPU_HAS_LASX
> >> +void kvm_save_lasx(struct loongarch_fpu *fpu);
> >> +void kvm_restore_lasx(struct loongarch_fpu *fpu);
> >> +#endif
> >> +
> >> +void kvm_save_fpu(struct loongarch_fpu *fpu);
> >> +void kvm_restore_fpu(struct loongarch_fpu *fpu);
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h
> >> b/arch/loongarch/include/asm/kvm_host.h
> >> index e4fe5b8e8149..1a1be10e3803 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -85,7 +85,6 @@ struct kvm_context {
> >>   struct kvm_world_switch {
> >>       int (*exc_entry)(void);
> >>       int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> >> -    unsigned long page_order;
> >>   };
> >>     #define MAX_PGTABLE_LEVELS    4
> >> @@ -347,8 +346,6 @@ void kvm_exc_entry(void);
> >>   int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
> >>     extern unsigned long vpid_mask;
> >> -extern const unsigned long kvm_exception_size;
> >> -extern const unsigned long kvm_enter_guest_size;
> >>   extern struct kvm_world_switch *kvm_loongarch_ops;
> >>     #define SW_GCSR        (1 << 0)
> >> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> >> index cb41d9265662..fe665054f824 100644
> >> --- a/arch/loongarch/kvm/Makefile
> >> +++ b/arch/loongarch/kvm/Makefile
> >> @@ -11,7 +11,7 @@ kvm-y +=3D exit.o
> >>   kvm-y +=3D interrupt.o
> >>   kvm-y +=3D main.o
> >>   kvm-y +=3D mmu.o
> >> -kvm-y +=3D switch.o
> >> +obj-y +=3D switch.o
> >>   kvm-y +=3D timer.o
> >>   kvm-y +=3D tlb.o
> >>   kvm-y +=3D vcpu.o
> >> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> >> index 80ea63d465b8..67d234540ed4 100644
> >> --- a/arch/loongarch/kvm/main.c
> >> +++ b/arch/loongarch/kvm/main.c
> >> @@ -340,8 +340,7 @@ void kvm_arch_disable_virtualization_cpu(void)
> >>     static int kvm_loongarch_env_init(void)
> >>   {
> >> -    int cpu, order, ret;
> >> -    void *addr;
> >> +    int cpu, ret;
> >>       struct kvm_context *context;
> >>         vmcs =3D alloc_percpu(struct kvm_context);
> >> @@ -357,30 +356,8 @@ static int kvm_loongarch_env_init(void)
> >>           return -ENOMEM;
> >>       }
> >>   -    /*
> >> -     * PGD register is shared between root kernel and kvm hypervisor.
> >> -     * So world switch entry should be in DMW area rather than TLB ar=
ea
> >> -     * to avoid page fault reenter.
> >> -     *
> >> -     * In future if hardware pagetable walking is supported, we won't
> >> -     * need to copy world switch code to DMW area.
> >> -     */
> >> -    order =3D get_order(kvm_exception_size + kvm_enter_guest_size);
> >> -    addr =3D (void *)__get_free_pages(GFP_KERNEL, order);
> >> -    if (!addr) {
> >> -        free_percpu(vmcs);
> >> -        vmcs =3D NULL;
> >> -        kfree(kvm_loongarch_ops);
> >> -        kvm_loongarch_ops =3D NULL;
> >> -        return -ENOMEM;
> >> -    }
> >> -
> >> -    memcpy(addr, kvm_exc_entry, kvm_exception_size);
> >> -    memcpy(addr + kvm_exception_size, kvm_enter_guest,
> >> kvm_enter_guest_size);
> >> -    flush_icache_range((unsigned long)addr, (unsigned long)addr +
> >> kvm_exception_size + kvm_enter_guest_size);
> >> -    kvm_loongarch_ops->exc_entry =3D addr;
> >> -    kvm_loongarch_ops->enter_guest =3D addr + kvm_exception_size;
> >> -    kvm_loongarch_ops->page_order =3D order;
> >> +    kvm_loongarch_ops->exc_entry =3D (void *)kvm_exc_entry;
> >> +    kvm_loongarch_ops->enter_guest =3D (void *)kvm_enter_guest;
> >>         vpid_mask =3D read_csr_gstat();
> >>       vpid_mask =3D (vpid_mask & CSR_GSTAT_GIDBIT) >>
> >> CSR_GSTAT_GIDBIT_SHIFT;
> >> @@ -414,16 +391,10 @@ static int kvm_loongarch_env_init(void)
> >>     static void kvm_loongarch_env_exit(void)
> >>   {
> >> -    unsigned long addr;
> >> -
> >>       if (vmcs)
> >>           free_percpu(vmcs);
> >>         if (kvm_loongarch_ops) {
> >> -        if (kvm_loongarch_ops->exc_entry) {
> >> -            addr =3D (unsigned long)kvm_loongarch_ops->exc_entry;
> >> -            free_pages(addr, kvm_loongarch_ops->page_order);
> >> -        }
> >>           kfree(kvm_loongarch_ops);
> >>       }
> >>   diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch=
.S
> >> index f1768b7a6194..93845ce53651 100644
> >> --- a/arch/loongarch/kvm/switch.S
> >> +++ b/arch/loongarch/kvm/switch.S
> >> @@ -5,6 +5,7 @@
> >>     #include <linux/linkage.h>
> >>   #include <asm/asm.h>
> >> +#include <asm/page.h>
> >>   #include <asm/asmmacro.h>
> >>   #include <asm/loongarch.h>
> >>   #include <asm/regdef.h>
> >> @@ -100,10 +101,18 @@
> >>        *  -        is still in guest mode, such as pgd table/vmid
> >> registers etc,
> >>        *  -        will fix with hw page walk enabled in future
> >>        * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to
> >> KVM_TEMP_KS
> >> +     *
> >> +     * PGD register is shared between root kernel and kvm hypervisor.
> >> +     * So world switch entry should be in DMW area rather than TLB ar=
ea
> >> +     * to avoid page fault reenter.
> >> +     *
> >> +     * In future if hardware pagetable walking is supported, we won't
> >> +     * need to copy world switch code to DMW area.
> >>        */
> >>       .text
> >>       .cfi_sections    .debug_frame
> >>   SYM_CODE_START(kvm_exc_entry)
> >> +    .p2align PAGE_SHIFT
I'm not sure, but if this line can be moved after .text, it seems better.

Huacai

> >>       UNWIND_HINT_UNDEFINED
> >>       csrwr    a2,   KVM_TEMP_KS
> >>       csrrd    a2,   KVM_VCPU_KS
> >> @@ -190,8 +199,8 @@ ret_to_host:
> >>       kvm_restore_host_gpr    a2
> >>       jr      ra
> >>   -SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
> >>   SYM_CODE_END(kvm_exc_entry)
> >> +EXPORT_SYMBOL(kvm_exc_entry)
> >>     /*
> >>    * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
> >> @@ -215,8 +224,8 @@ SYM_FUNC_START(kvm_enter_guest)
> >>       /* Save kvm_vcpu to kscratch */
> >>       csrwr    a1, KVM_VCPU_KS
> >>       kvm_switch_to_guest
> >> -SYM_INNER_LABEL(kvm_enter_guest_end, SYM_L_LOCAL)
> >>   SYM_FUNC_END(kvm_enter_guest)
> >> +EXPORT_SYMBOL(kvm_enter_guest)
> >>     SYM_FUNC_START(kvm_save_fpu)
> >>       fpu_save_csr    a0 t1
> >> @@ -224,6 +233,7 @@ SYM_FUNC_START(kvm_save_fpu)
> >>       fpu_save_cc    a0 t1 t2
> >>       jr              ra
> >>   SYM_FUNC_END(kvm_save_fpu)
> >> +EXPORT_SYMBOL(kvm_save_fpu)
> > one small nit, could EXPORT_SYMBOL_FOR_KVM() be used here compared
> > with EXPORT_SYMBOL()?
> >
>
> Ok! will fix it in next version
> Thanks!
> Xianglai.
>
> > Regards
> > Bibo Mao
> >>     SYM_FUNC_START(kvm_restore_fpu)
> >>       fpu_restore_double a0 t1
> >> @@ -231,6 +241,7 @@ SYM_FUNC_START(kvm_restore_fpu)
> >>       fpu_restore_cc       a0 t1 t2
> >>       jr                 ra
> >>   SYM_FUNC_END(kvm_restore_fpu)
> >> +EXPORT_SYMBOL(kvm_restore_fpu)
> >>     #ifdef CONFIG_CPU_HAS_LSX
> >>   SYM_FUNC_START(kvm_save_lsx)
> >> @@ -239,6 +250,7 @@ SYM_FUNC_START(kvm_save_lsx)
> >>       lsx_save_data   a0 t1
> >>       jr              ra
> >>   SYM_FUNC_END(kvm_save_lsx)
> >> +EXPORT_SYMBOL(kvm_save_lsx)
> >>     SYM_FUNC_START(kvm_restore_lsx)
> >>       lsx_restore_data a0 t1
> >> @@ -246,6 +258,7 @@ SYM_FUNC_START(kvm_restore_lsx)
> >>       fpu_restore_csr  a0 t1 t2
> >>       jr               ra
> >>   SYM_FUNC_END(kvm_restore_lsx)
> >> +EXPORT_SYMBOL(kvm_restore_lsx)
> >>   #endif
> >>     #ifdef CONFIG_CPU_HAS_LASX
> >> @@ -255,6 +268,7 @@ SYM_FUNC_START(kvm_save_lasx)
> >>       lasx_save_data  a0 t1
> >>       jr              ra
> >>   SYM_FUNC_END(kvm_save_lasx)
> >> +EXPORT_SYMBOL(kvm_save_lasx)
> >>     SYM_FUNC_START(kvm_restore_lasx)
> >>       lasx_restore_data a0 t1
> >> @@ -262,10 +276,8 @@ SYM_FUNC_START(kvm_restore_lasx)
> >>       fpu_restore_csr   a0 t1 t2
> >>       jr                ra
> >>   SYM_FUNC_END(kvm_restore_lasx)
> >> +EXPORT_SYMBOL(kvm_restore_lasx)
> >>   #endif
> >> -    .section ".rodata"
> >> -SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
> >> -SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end -
> >> kvm_enter_guest)
> >>     #ifdef CONFIG_CPU_HAS_LBT
> >>   STACK_FRAME_NON_STANDARD kvm_restore_fpu
> >>
>
>

