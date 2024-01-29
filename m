Return-Path: <kvm+bounces-7336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EE2E84065E
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 14:12:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 773A0B24BA0
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 13:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FD9629EE;
	Mon, 29 Jan 2024 13:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKjxsM/J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1387B62804;
	Mon, 29 Jan 2024 13:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706533913; cv=none; b=EuJiyc38NpkKirk+xyJXookKgkCgiZFBYC19LF3Xu4dN0GnXuG9NhSc/xcQOjqDSAakXhXJ6cpNGMjCpPXubQ0ESlqrwM6PVGw4E5ZF68W4QOoJ36TSRIjA3gh9DHkQKSTm2c2u49LOc4oxHaxjG+a6Z9f6EW4SkQzBBiNbi1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706533913; c=relaxed/simple;
	bh=ZnTukG0ry6mY3S68K6+Bb7CU4b4XhqHBZ2rqk7MM7uk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S+Vagg3FUNofxWUB9mSjAk9H8z7AfDulr3kEvMbi3R6uVY1UNxfSDiMfDZvY2YmVrdVQDXnV/Fbmrp40BxtLnZJ0OHHP1FZxjYw7r1yLMGmoMWMXTX4ivd+77ci6n2MbYO8lBZS4oKpCo+bnIkJ2/6N6S67trcddt4jxAW3YTvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKjxsM/J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99BEC43399;
	Mon, 29 Jan 2024 13:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706533912;
	bh=ZnTukG0ry6mY3S68K6+Bb7CU4b4XhqHBZ2rqk7MM7uk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OKjxsM/JqzCOSUwLADpWgrNEZS88Om80y6gqueEU4TasftSyLcTVaIMr6iR8hlcKN
	 NY4rYvx2qwWcp5286XdMkG0srhX1ar4BFlNOKXKgCG8MjyWeSe8EsfXDEJWjRkQMkG
	 ABb30mF6c6eTuP9YwOetPm0B4FFoLznUzcm4Xt3hVsVZP75RtKzrRAloG0UcqdMhzq
	 KM0hryVSodNKQlByH8lWfw9Dym5zoWrf7+PYwDicP34ERJl9SrZ2i03s7sUFDRmdo/
	 qBuM92InOKhTei6K9Qwczcosc10h7sQTxh2S4eQrsagtCUBv5ztG9ullfILH+jAE4N
	 3+/aQkXsE+S+Q==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-55f0b2c79cdso976630a12.3;
        Mon, 29 Jan 2024 05:11:52 -0800 (PST)
X-Gm-Message-State: AOJu0YxmxMPqa1pPFyeayJxXc0uxRmq5GC7bmh2JvxmRRY8WWZHpJ5aY
	i6etH483XHYv9o1/DQiIqTzkHbYtpzPGwYFPjMTT0n0GNYcC3nBdWX67L0q4l+l24Ars52auTDd
	WD9PFCOHsRpnEkYqmMQhLg8Jz9l8=
X-Google-Smtp-Source: AGHT+IFQnhgfnpp+VE5IQCX1aYZC0mg2RyViiRDUgWm/V/YSKftwQ7xS3+Lvsojh4UebgJU9yOs6uZ0X/z3KAqgiqWU=
X-Received: by 2002:a05:6402:35c2:b0:55d:2447:844f with SMTP id
 z2-20020a05640235c200b0055d2447844fmr5704057edc.26.1706533910974; Mon, 29 Jan
 2024 05:11:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122100313.1589372-1-maobibo@loongson.cn> <20240122100313.1589372-6-maobibo@loongson.cn>
In-Reply-To: <20240122100313.1589372-6-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 29 Jan 2024 21:11:42 +0800
X-Gmail-Original-Message-ID: <CAAhV-H78HiRRsdsVHxYBYOEWew9FKDSF++bK_=g=UbBKc46d2Q@mail.gmail.com>
Message-ID: <CAAhV-H78HiRRsdsVHxYBYOEWew9FKDSF++bK_=g=UbBKc46d2Q@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] LoongArch: KVM: Add physical cpuid map support
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

Without this patch I can also create a SMP VM, so what problem does
this patch want to solve?

Huacai

On Mon, Jan 22, 2024 at 6:03=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Physical cpuid is used to irq routing for irqchips such as ipi/msi/
> extioi interrupt controller. And physical cpuid is stored at CSR
> register LOONGARCH_CSR_CPUID, it can not be changed once vcpu is
> created. Since different irqchips have different size definition
> about physical cpuid, KVM uses the smallest cpuid from extioi, and
> the max cpuid size is defines as 256.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h | 26 ++++++++
>  arch/loongarch/include/asm/kvm_vcpu.h |  1 +
>  arch/loongarch/kvm/vcpu.c             | 93 ++++++++++++++++++++++++++-
>  arch/loongarch/kvm/vm.c               | 11 ++++
>  4 files changed, 130 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index 2d62f7b0d377..57399d7cf8b7 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -64,6 +64,30 @@ struct kvm_world_switch {
>
>  #define MAX_PGTABLE_LEVELS     4
>
> +/*
> + * Physical cpu id is used for interrupt routing, there are different
> + * definitions about physical cpuid on different hardwares.
> + *  For LOONGARCH_CSR_CPUID register, max cpuid size if 512
> + *  For IPI HW, max dest CPUID size 1024
> + *  For extioi interrupt controller, max dest CPUID size is 256
> + *  For MSI interrupt controller, max supported CPUID size is 65536
> + *
> + * Currently max CPUID is defined as 256 for KVM hypervisor, in future
> + * it will be expanded to 4096, including 16 packages at most. And every
> + * package supports at most 256 vcpus
> + */
> +#define KVM_MAX_PHYID          256
> +
> +struct kvm_phyid_info {
> +       struct kvm_vcpu *vcpu;
> +       bool            enabled;
> +};
> +
> +struct kvm_phyid_map {
> +       int max_phyid;
> +       struct kvm_phyid_info phys_map[KVM_MAX_PHYID];
> +};
> +
>  struct kvm_arch {
>         /* Guest physical mm */
>         kvm_pte_t *pgd;
> @@ -71,6 +95,8 @@ struct kvm_arch {
>         unsigned long invalid_ptes[MAX_PGTABLE_LEVELS];
>         unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
>         unsigned int  root_level;
> +       struct mutex  phyid_map_lock;
> +       struct kvm_phyid_map  *phyid_map;
>
>         s64 time_offset;
>         struct kvm_context __percpu *vmcs;
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/inclu=
de/asm/kvm_vcpu.h
> index e71ceb88f29e..2402129ee955 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -81,6 +81,7 @@ void kvm_save_timer(struct kvm_vcpu *vcpu);
>  void kvm_restore_timer(struct kvm_vcpu *vcpu);
>
>  int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt=
 *irq);
> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid);
>
>  /*
>   * Loongarch KVM guest interrupt handling
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 27701991886d..97ca9c7160e6 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -274,6 +274,95 @@ static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsign=
ed int id, u64 *val)
>         return 0;
>  }
>
> +static inline int kvm_set_cpuid(struct kvm_vcpu *vcpu, u64 val)
> +{
> +       int cpuid;
> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> +       struct kvm_phyid_map  *map;
> +
> +       if (val >=3D KVM_MAX_PHYID)
> +               return -EINVAL;
> +
> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> +       map =3D vcpu->kvm->arch.phyid_map;
> +       mutex_lock(&vcpu->kvm->arch.phyid_map_lock);
> +       if (map->phys_map[cpuid].enabled) {
> +               /*
> +                * Cpuid is already set before
> +                * Forbid changing different cpuid at runtime
> +                */
> +               if (cpuid !=3D val) {
> +                       /*
> +                        * Cpuid 0 is initial value for vcpu, maybe inval=
id
> +                        * unset value for vcpu
> +                        */
> +                       if (cpuid) {
> +                               mutex_unlock(&vcpu->kvm->arch.phyid_map_l=
ock);
> +                               return -EINVAL;
> +                       }
> +               } else {
> +                        /* Discard duplicated cpuid set */
> +                       mutex_unlock(&vcpu->kvm->arch.phyid_map_lock);
> +                       return 0;
> +               }
> +       }
> +
> +       if (map->phys_map[val].enabled) {
> +               /*
> +                * New cpuid is already set with other vcpu
> +                * Forbid sharing the same cpuid between different vcpus
> +                */
> +               if (map->phys_map[val].vcpu !=3D vcpu) {
> +                       mutex_unlock(&vcpu->kvm->arch.phyid_map_lock);
> +                       return -EINVAL;
> +               }
> +
> +               /* Discard duplicated cpuid set operation*/
> +               mutex_unlock(&vcpu->kvm->arch.phyid_map_lock);
> +               return 0;
> +       }
> +
> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, val);
> +       map->phys_map[val].enabled      =3D true;
> +       map->phys_map[val].vcpu         =3D vcpu;
> +       if (map->max_phyid < val)
> +               map->max_phyid =3D val;
> +       mutex_unlock(&vcpu->kvm->arch.phyid_map_lock);
> +       return 0;
> +}
> +
> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid)
> +{
> +       struct kvm_phyid_map  *map;
> +
> +       if (cpuid >=3D KVM_MAX_PHYID)
> +               return NULL;
> +
> +       map =3D kvm->arch.phyid_map;
> +       if (map->phys_map[cpuid].enabled)
> +               return map->phys_map[cpuid].vcpu;
> +
> +       return NULL;
> +}
> +
> +static inline void kvm_drop_cpuid(struct kvm_vcpu *vcpu)
> +{
> +       int cpuid;
> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> +       struct kvm_phyid_map  *map;
> +
> +       map =3D vcpu->kvm->arch.phyid_map;
> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> +       if (cpuid >=3D KVM_MAX_PHYID)
> +               return;
> +
> +       if (map->phys_map[cpuid].enabled) {
> +               map->phys_map[cpuid].vcpu =3D NULL;
> +               map->phys_map[cpuid].enabled =3D false;
> +               kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, 0);
> +       }
> +}
> +
>  static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>  {
>         int ret =3D 0, gintc;
> @@ -291,7 +380,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigne=
d int id, u64 val)
>                 kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
>
>                 return ret;
> -       }
> +       } else if (id =3D=3D LOONGARCH_CSR_CPUID)
> +               return kvm_set_cpuid(vcpu, val);
>
>         kvm_write_sw_gcsr(csr, id, val);
>
> @@ -925,6 +1015,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>         hrtimer_cancel(&vcpu->arch.swtimer);
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>         kfree(vcpu->arch.csr);
> +       kvm_drop_cpuid(vcpu);
>
>         /*
>          * If the vCPU is freed and reused as another vCPU, we don't want=
 the
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index 0a37f6fa8f2d..6fd5916ebef3 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -30,6 +30,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long ty=
pe)
>         if (!kvm->arch.pgd)
>                 return -ENOMEM;
>
> +       kvm->arch.phyid_map =3D kvzalloc(sizeof(struct kvm_phyid_map),
> +                               GFP_KERNEL_ACCOUNT);
> +       if (!kvm->arch.phyid_map) {
> +               free_page((unsigned long)kvm->arch.pgd);
> +               kvm->arch.pgd =3D NULL;
> +               return -ENOMEM;
> +       }
> +
>         kvm_init_vmcs(kvm);
>         kvm->arch.gpa_size =3D BIT(cpu_vabits - 1);
>         kvm->arch.root_level =3D CONFIG_PGTABLE_LEVELS - 1;
> @@ -44,6 +52,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long typ=
e)
>         for (i =3D 0; i <=3D kvm->arch.root_level; i++)
>                 kvm->arch.pte_shifts[i] =3D PAGE_SHIFT + i * (PAGE_SHIFT =
- 3);
>
> +       mutex_init(&kvm->arch.phyid_map_lock);
>         return 0;
>  }
>
> @@ -51,7 +60,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
>         kvm_destroy_vcpus(kvm);
>         free_page((unsigned long)kvm->arch.pgd);
> +       kvfree(kvm->arch.phyid_map);
>         kvm->arch.pgd =3D NULL;
> +       kvm->arch.phyid_map =3D NULL;
>  }
>
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> --
> 2.39.3
>

