Return-Path: <kvm+bounces-66335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1550ECCFE88
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1F1B3147175
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B03328B78;
	Fri, 19 Dec 2025 12:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrjt0v1l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC19318124
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 12:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766148431; cv=none; b=ZtFDW0iROPSPRdUPOut2ic9wjvVG2cXr4/n5Zlj0/yAJ5jDmBrefFP6LvzcEMhyJsSW+lU9wv/4BIbSgnzvJ8zKuAtbForc0LZFMWmkDlwyxXly/Qn0T5WFCjUKD1TFzqEfQqW4uTYRxkzEeDrRdQMswe1LcXSCshkPA8bi7JKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766148431; c=relaxed/simple;
	bh=LJqwKP84mhl7BBVclz7iAAIU/1w603QPygS8o7SXfFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EmCkAxrDZjeFdw1nBF37Rrb/r7NjuOFh0tgC+3Ohpzudlx/0cB7TxIcgzfJgft2ZyPJbPnvWhddrwk6uVCWpwjTbvdsilNTnJ663mbZ2n9dY+Ng8D1sH4N6MZTeLlUlBMyeYpnhk1colvN3/tloABiLS+HzG68qRxRmxE+QQVSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrjt0v1l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850C8C19424
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 12:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766148430;
	bh=LJqwKP84mhl7BBVclz7iAAIU/1w603QPygS8o7SXfFU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jrjt0v1lv5WX+Kt9EjWxPNORmFVfHkag+aGHxMv+sVLlm7js9bjFw53cv1oNIUTPd
	 8g2Hc1OV+y4xzzSfT4Jt+/QIPdc0+CLmSd2kx9UZpqN4LWKItAV1lbUpEolPBAm/dc
	 psCg6v6ZDhncqZMHAPUkTH2oRMSF0SaLEVajGjFtE/MmudmcVMWIb8rcezQZqdItYA
	 fwlNPS/aDEBp/LWeJk/TbkjoN4naV/sK6ZopVduZ0e0XGcRrvbc1uhD3ccgcOoGNKe
	 nq30yWxRnapyLDG3IjNvyVGPBhuAGEKEjLk4hbLuVXVwX9J4NiTAn+l5r94OAzvqE/
	 VgNL2pSivC3EQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so395601066b.2
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 04:47:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVcZp5+ZyCsgPuPMLJI9aOpmk3SpkNGDTTcwhDcTqeTKm6JeVIJWWVf6xtkFgMfHObM/9U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww9WfeYVOzkux7Dti0PDHREvZ+6ZpSrqhDmLmXnp2XlwJQG7XQ
	B2ob0ZFYxuwYymOwCs47kbK8tyemLbD5ECZTEjz/t/kW9RpFhVJ1dXvkOYvLl2EnMR0+6xi48aM
	OTXseEkdJEuWbECdgl+AxtbB3BxF1p4E=
X-Google-Smtp-Source: AGHT+IEieUiJd2jEwMw53PpsA6/edgsPX9kZSPuBeejEyZ2xaVKkR3CuxR11VM0VoCy1E0kVuYze9ta+bcamK7vDllc=
X-Received: by 2002:a17:907:3e14:b0:b7c:f831:6ac2 with SMTP id
 a640c23a62f3a-b803715344emr272425366b.30.1766148428958; Fri, 19 Dec 2025
 04:47:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217032450.954344-1-lixianglai@loongson.cn>
 <20251217032450.954344-2-lixianglai@loongson.cn> <CAAhV-H5g7KXK08vqKOR5HTsPKZ7X3CBa9fgfSTavnN7m9D_9AA@mail.gmail.com>
 <831f8f7e-1628-42e2-ca2e-7772ad9d3057@loongson.cn>
In-Reply-To: <831f8f7e-1628-42e2-ca2e-7772ad9d3057@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 19 Dec 2025 20:47:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5MnYJ4+e3N7S8GyWV+f63gfdNE-Q-rc7D1oOZFCQ4EoQ@mail.gmail.com>
X-Gm-Features: AQt7F2rdEdVSGGPrtGeSXzjJz72py_f_yz1FAePQ7gCDFClAnUrU47PM54-6qB0
Message-ID: <CAAhV-H5MnYJ4+e3N7S8GyWV+f63gfdNE-Q-rc7D1oOZFCQ4EoQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] LoongArch: KVM: Compile the switch.S file directly
 into the kernel
To: lixianglai <lixianglai@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, stable@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 7:08=E2=80=AFPM lixianglai <lixianglai@loongson.cn>=
 wrote:
>
> Hi  Huacai Chen:
> > Hi, Xianglai,
> >
> > On Wed, Dec 17, 2025 at 11:49=E2=80=AFAM Xianglai Li <lixianglai@loongs=
on.cn> wrote:
> >> If we directly compile the switch.S file into the kernel, the address =
of
> >> the kvm_exc_entry function will definitely be within the DMW memory ar=
ea.
> >> Therefore, we will no longer need to perform a copy relocation of
> >> kvm_exc_entry.
> >>
> >> Based on the above description, compile switch.S directly into the ker=
nel,
> >> and then remove the copy relocation execution logic for the kvm_exc_en=
try
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
> >>   arch/loongarch/include/asm/asm-prototypes.h | 16 ++++++++++
> >>   arch/loongarch/include/asm/kvm_host.h       |  5 +--
> >>   arch/loongarch/include/asm/kvm_vcpu.h       | 20 ++++++------
> >>   arch/loongarch/kvm/Makefile                 |  2 +-
> >>   arch/loongarch/kvm/main.c                   | 35 ++-----------------=
--
> >>   arch/loongarch/kvm/switch.S                 | 22 ++++++++++---
> >>   7 files changed, 49 insertions(+), 53 deletions(-)
> >>
> >> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
> >> index beb8499dd8ed..1c7a0dbe5e72 100644
> >> --- a/arch/loongarch/Kbuild
> >> +++ b/arch/loongarch/Kbuild
> >> @@ -3,7 +3,7 @@ obj-y +=3D mm/
> >>   obj-y +=3D net/
> >>   obj-y +=3D vdso/
> >>
> >> -obj-$(CONFIG_KVM) +=3D kvm/
> >> +obj-$(subst m,y,$(CONFIG_KVM)) +=3D kvm/
> >>
> >>   # for cleaning
> >>   subdir- +=3D boot
> >> diff --git a/arch/loongarch/include/asm/asm-prototypes.h b/arch/loonga=
rch/include/asm/asm-prototypes.h
> >> index 704066b4f736..eb591276d191 100644
> >> --- a/arch/loongarch/include/asm/asm-prototypes.h
> >> +++ b/arch/loongarch/include/asm/asm-prototypes.h
> >> @@ -20,3 +20,19 @@ asmlinkage void noinstr __no_stack_protector ret_fr=
om_kernel_thread(struct task_
> >>                                                                      s=
truct pt_regs *regs,
> >>                                                                      i=
nt (*fn)(void *),
> >>                                                                      v=
oid *fn_arg);
> >> +
> >> +void kvm_exc_entry(void);
> >> +int  kvm_enter_guest(void *run, void *vcpu);
> >> +
> >> +#ifdef CONFIG_CPU_HAS_LSX
> >> +void kvm_save_lsx(void *fpu);
> >> +void kvm_restore_lsx(void *fpu);
> >> +#endif
> >> +
> >> +#ifdef CONFIG_CPU_HAS_LASX
> >> +void kvm_save_lasx(void *fpu);
> >> +void kvm_restore_lasx(void *fpu);
> >> +#endif
> >> +
> >> +void kvm_save_fpu(void *fpu);
> >> +void kvm_restore_fpu(void *fpu);
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/in=
clude/asm/kvm_host.h
> >> index e4fe5b8e8149..0aa7679536cc 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -85,7 +85,6 @@ struct kvm_context {
> >>   struct kvm_world_switch {
> >>          int (*exc_entry)(void);
> >>          int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu=
);
> >> -       unsigned long page_order;
> >>   };
> >>
> >>   #define MAX_PGTABLE_LEVELS     4
> >> @@ -344,11 +343,9 @@ enum hrtimer_restart kvm_swtimer_wakeup(struct hr=
timer *timer);
> >>   void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm, const struc=
t kvm_memory_slot *memslot);
> >>   void kvm_init_vmcs(struct kvm *kvm);
> >>   void kvm_exc_entry(void);
> >> -int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
> >> +int  kvm_enter_guest(void *run, void *vcpu);
> >>
> >>   extern unsigned long vpid_mask;
> >> -extern const unsigned long kvm_exception_size;
> >> -extern const unsigned long kvm_enter_guest_size;
> >>   extern struct kvm_world_switch *kvm_loongarch_ops;
> >>
> >>   #define SW_GCSR                (1 << 0)
> >> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/in=
clude/asm/kvm_vcpu.h
> >> index 3784ab4ccdb5..8af98a3d7b0c 100644
> >> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> >> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> >> @@ -53,28 +53,28 @@ void kvm_deliver_exception(struct kvm_vcpu *vcpu);
> >>
> >>   void kvm_own_fpu(struct kvm_vcpu *vcpu);
> >>   void kvm_lose_fpu(struct kvm_vcpu *vcpu);
> >> -void kvm_save_fpu(struct loongarch_fpu *fpu);
> >> -void kvm_restore_fpu(struct loongarch_fpu *fpu);
> >> +void kvm_save_fpu(void *fpu);
> >> +void kvm_restore_fpu(void *fpu);
> > Why are these modifications needed?
> In the assembly file switch.S, we used the macro definition
> EXPORT_SYMBOL to export symbols without version information,
> which led to an alarm during the compilation stage. In order to solve
> this problem we need to put the symbol statement
> in the file "arch/loongarch/include/asm/asm-prototypes.h", And function
> declarations in the parameter types defined
> in the header file "arch/loongarch/include/asm/kvm_host h", it is very
> big, in order to reduce the
> "arch/loongarch/include/asm/asm-prototypes.h" the contents of the file,
> So we change the parameters in the function
> declaration, then the function declaration directly into the file
> "arch/loongarch/include/asm/asm-prototypes.h".
I know what you want, but you needn't do this. You can simply add a
line "struct loongarch_fpu;" in asm-prototypes.h before use.

Huacai

>
> >
> > Huacai
> >
> >>   void kvm_restore_fcsr(struct loongarch_fpu *fpu);
> >>
> >>   #ifdef CONFIG_CPU_HAS_LSX
> >>   int kvm_own_lsx(struct kvm_vcpu *vcpu);
> >> -void kvm_save_lsx(struct loongarch_fpu *fpu);
> >> -void kvm_restore_lsx(struct loongarch_fpu *fpu);
> >> +void kvm_save_lsx(void *fpu);
> >> +void kvm_restore_lsx(void *fpu);
> >>   #else
> >>   static inline int kvm_own_lsx(struct kvm_vcpu *vcpu) { return -EINVA=
L; }
> >> -static inline void kvm_save_lsx(struct loongarch_fpu *fpu) { }
> >> -static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
> >> +static inline void kvm_save_lsx(void *fpu) { }
> >> +static inline void kvm_restore_lsx(void *fpu) { }
> >>   #endif
> >>
> >>   #ifdef CONFIG_CPU_HAS_LASX
> >>   int kvm_own_lasx(struct kvm_vcpu *vcpu);
> >> -void kvm_save_lasx(struct loongarch_fpu *fpu);
> >> -void kvm_restore_lasx(struct loongarch_fpu *fpu);
> >> +void kvm_save_lasx(void *fpu);
> >> +void kvm_restore_lasx(void *fpu);
> >>   #else
> >>   static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { return -EINV=
AL; }
> >> -static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
> >> -static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
> >> +static inline void kvm_save_lasx(void *fpu) { }
> >> +static inline void kvm_restore_lasx(void *fpu) { }
> >>   #endif
> >>
> >>   #ifdef CONFIG_CPU_HAS_LBT
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
> >>
> >>   static int kvm_loongarch_env_init(void)
> >>   {
> >> -       int cpu, order, ret;
> >> -       void *addr;
> >> +       int cpu, ret;
> >>          struct kvm_context *context;
> >>
> >>          vmcs =3D alloc_percpu(struct kvm_context);
> >> @@ -357,30 +356,8 @@ static int kvm_loongarch_env_init(void)
> >>                  return -ENOMEM;
> >>          }
> >>
> >> -       /*
> >> -        * PGD register is shared between root kernel and kvm hypervis=
or.
> >> -        * So world switch entry should be in DMW area rather than TLB=
 area
> >> -        * to avoid page fault reenter.
> >> -        *
> >> -        * In future if hardware pagetable walking is supported, we wo=
n't
> >> -        * need to copy world switch code to DMW area.
> >> -        */
> >> -       order =3D get_order(kvm_exception_size + kvm_enter_guest_size)=
;
> >> -       addr =3D (void *)__get_free_pages(GFP_KERNEL, order);
> >> -       if (!addr) {
> >> -               free_percpu(vmcs);
> >> -               vmcs =3D NULL;
> >> -               kfree(kvm_loongarch_ops);
> >> -               kvm_loongarch_ops =3D NULL;
> >> -               return -ENOMEM;
> >> -       }
> >> -
> >> -       memcpy(addr, kvm_exc_entry, kvm_exception_size);
> >> -       memcpy(addr + kvm_exception_size, kvm_enter_guest, kvm_enter_g=
uest_size);
> >> -       flush_icache_range((unsigned long)addr, (unsigned long)addr + =
kvm_exception_size + kvm_enter_guest_size);
> >> -       kvm_loongarch_ops->exc_entry =3D addr;
> >> -       kvm_loongarch_ops->enter_guest =3D addr + kvm_exception_size;
> >> -       kvm_loongarch_ops->page_order =3D order;
> >> +       kvm_loongarch_ops->exc_entry =3D (void *)kvm_exc_entry;
> >> +       kvm_loongarch_ops->enter_guest =3D (void *)kvm_enter_guest;
> >>
> >>          vpid_mask =3D read_csr_gstat();
> >>          vpid_mask =3D (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GID=
BIT_SHIFT;
> >> @@ -414,16 +391,10 @@ static int kvm_loongarch_env_init(void)
> >>
> >>   static void kvm_loongarch_env_exit(void)
> >>   {
> >> -       unsigned long addr;
> >> -
> >>          if (vmcs)
> >>                  free_percpu(vmcs);
> >>
> >>          if (kvm_loongarch_ops) {
> >> -               if (kvm_loongarch_ops->exc_entry) {
> >> -                       addr =3D (unsigned long)kvm_loongarch_ops->exc=
_entry;
> >> -                       free_pages(addr, kvm_loongarch_ops->page_order=
);
> >> -               }
> >>                  kfree(kvm_loongarch_ops);
> >>          }
> >>
> >> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> >> index f1768b7a6194..93845ce53651 100644
> >> --- a/arch/loongarch/kvm/switch.S
> >> +++ b/arch/loongarch/kvm/switch.S
> >> @@ -5,6 +5,7 @@
> >>
> >>   #include <linux/linkage.h>
> >>   #include <asm/asm.h>
> >> +#include <asm/page.h>
> >>   #include <asm/asmmacro.h>
> >>   #include <asm/loongarch.h>
> >>   #include <asm/regdef.h>
> >> @@ -100,10 +101,18 @@
> >>           *  -        is still in guest mode, such as pgd table/vmid r=
egisters etc,
> >>           *  -        will fix with hw page walk enabled in future
> >>           * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 t=
o KVM_TEMP_KS
> >> +        *
> >> +        * PGD register is shared between root kernel and kvm hypervis=
or.
> >> +        * So world switch entry should be in DMW area rather than TLB=
 area
> >> +        * to avoid page fault reenter.
> >> +        *
> >> +        * In future if hardware pagetable walking is supported, we wo=
n't
> >> +        * need to copy world switch code to DMW area.
> >>           */
> >>          .text
> >>          .cfi_sections   .debug_frame
> >>   SYM_CODE_START(kvm_exc_entry)
> >> +       .p2align PAGE_SHIFT
> >>          UNWIND_HINT_UNDEFINED
> >>          csrwr   a2,   KVM_TEMP_KS
> >>          csrrd   a2,   KVM_VCPU_KS
> >> @@ -190,8 +199,8 @@ ret_to_host:
> >>          kvm_restore_host_gpr    a2
> >>          jr      ra
> >>
> >> -SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
> >>   SYM_CODE_END(kvm_exc_entry)
> >> +EXPORT_SYMBOL(kvm_exc_entry)
> >>
> >>   /*
> >>    * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
> >> @@ -215,8 +224,8 @@ SYM_FUNC_START(kvm_enter_guest)
> >>          /* Save kvm_vcpu to kscratch */
> >>          csrwr   a1, KVM_VCPU_KS
> >>          kvm_switch_to_guest
> >> -SYM_INNER_LABEL(kvm_enter_guest_end, SYM_L_LOCAL)
> >>   SYM_FUNC_END(kvm_enter_guest)
> >> +EXPORT_SYMBOL(kvm_enter_guest)
> >>
> >>   SYM_FUNC_START(kvm_save_fpu)
> >>          fpu_save_csr    a0 t1
> >> @@ -224,6 +233,7 @@ SYM_FUNC_START(kvm_save_fpu)
> >>          fpu_save_cc     a0 t1 t2
> >>          jr              ra
> >>   SYM_FUNC_END(kvm_save_fpu)
> >> +EXPORT_SYMBOL(kvm_save_fpu)
> >>
> >>   SYM_FUNC_START(kvm_restore_fpu)
> >>          fpu_restore_double a0 t1
> >> @@ -231,6 +241,7 @@ SYM_FUNC_START(kvm_restore_fpu)
> >>          fpu_restore_cc     a0 t1 t2
> >>          jr                 ra
> >>   SYM_FUNC_END(kvm_restore_fpu)
> >> +EXPORT_SYMBOL(kvm_restore_fpu)
> >>
> >>   #ifdef CONFIG_CPU_HAS_LSX
> >>   SYM_FUNC_START(kvm_save_lsx)
> >> @@ -239,6 +250,7 @@ SYM_FUNC_START(kvm_save_lsx)
> >>          lsx_save_data   a0 t1
> >>          jr              ra
> >>   SYM_FUNC_END(kvm_save_lsx)
> >> +EXPORT_SYMBOL(kvm_save_lsx)
> >>
> >>   SYM_FUNC_START(kvm_restore_lsx)
> >>          lsx_restore_data a0 t1
> >> @@ -246,6 +258,7 @@ SYM_FUNC_START(kvm_restore_lsx)
> >>          fpu_restore_csr  a0 t1 t2
> >>          jr               ra
> >>   SYM_FUNC_END(kvm_restore_lsx)
> >> +EXPORT_SYMBOL(kvm_restore_lsx)
> >>   #endif
> >>
> >>   #ifdef CONFIG_CPU_HAS_LASX
> >> @@ -255,6 +268,7 @@ SYM_FUNC_START(kvm_save_lasx)
> >>          lasx_save_data  a0 t1
> >>          jr              ra
> >>   SYM_FUNC_END(kvm_save_lasx)
> >> +EXPORT_SYMBOL(kvm_save_lasx)
> >>
> >>   SYM_FUNC_START(kvm_restore_lasx)
> >>          lasx_restore_data a0 t1
> >> @@ -262,10 +276,8 @@ SYM_FUNC_START(kvm_restore_lasx)
> >>          fpu_restore_csr   a0 t1 t2
> >>          jr                ra
> >>   SYM_FUNC_END(kvm_restore_lasx)
> >> +EXPORT_SYMBOL(kvm_restore_lasx)
> >>   #endif
> >> -       .section ".rodata"
> >> -SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
> >> -SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_=
guest)
> >>
> >>   #ifdef CONFIG_CPU_HAS_LBT
> >>   STACK_FRAME_NON_STANDARD kvm_restore_fpu
> >> --
> >> 2.39.1
> >>
> >>
>

