Return-Path: <kvm+bounces-20332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 552C7913974
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 12:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCD4F1F2228D
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 10:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0276D12D205;
	Sun, 23 Jun 2024 10:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yeax3TV8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288862F2D;
	Sun, 23 Jun 2024 10:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719137672; cv=none; b=eMq8H8xv2xJrTdNponKq7tQCxrynPLblfQmLAsmI53sX4OCd4dhPvKAbcb+6LT2D/d/7UIkFHkcq41T1C64iHn9oqFKuCm2udilzmpdeosPv5p8BBEXpFu0Z/IbdtlAKSXOwFnFKVKSJ6+98Q0yeF6IkEqCsupAzjJQRFpgeMLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719137672; c=relaxed/simple;
	bh=BZlC/ZevG7rNZB+An/8lQl1qYs2YQHp78gl2A6TVgss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QGmKOWJ6D7ntGNjluNajYkxrFKmkIMuA6nJcPGWxH+QlxCf+l1jr6GRmzvkeqUZGyY4rgiH8itHv55P6wUF8SBnojxIOuYh5/lYUvJ5dOUcE4TaJU0T+vZDTLfsiQF8nC9YwxxXVU2jaVt4or0v4yD79esxKMDP0kX+dZqqd3dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yeax3TV8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067B3C4AF09;
	Sun, 23 Jun 2024 10:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719137672;
	bh=BZlC/ZevG7rNZB+An/8lQl1qYs2YQHp78gl2A6TVgss=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Yeax3TV85qsXBTAp84fR8Se2MlNyPLGpoGlpL2ValOuuPWxiu4d4pxZr4fCZBSFuo
	 57C/138HqoHv/3p9QngbY7bmnQoG7qtR+3IyUM+nsVY/MXpEwRivsY/rh/QK6SS5gz
	 NULmhedM03sTKnrxjQzIuH/VG+mKnKvozuoY1r8apQljpCJba8d1ROY/sImC3vKegR
	 ShO0FeoM92fD5ajp0ZRx5tzH3ZH+kC8A/yMuRzRJf8Llxxu5zdjkiLn5zSUH58VHTI
	 94jxd5NVFQoZ5ciZEsFeWNgRJOaXrrb1dkjvCgfzVrMbpwtGjbne3MBFOV0rs/UtRH
	 +Dvake5szy2GQ==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57d1d45ba34so3620209a12.3;
        Sun, 23 Jun 2024 03:14:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW8hMc16LE70ICp92UIn8O83wIycfn5eTk7JfP+VyqJ/gq4bx0aWacwH7UFHTqOypAUDoHsVJfkGfJO+hidheeYJutrwCvtC93CWVmiYjNtNuOqxrI1gW5nm/AEOsAtsx+6
X-Gm-Message-State: AOJu0Yzg9DxykQoNpccOIV6iS5jXHvN1970OjTL6684ySQDXsSZO93vY
	aQwiOSBcq+j76HsRCRTt+5R443jcPBREcxOF+z+ak8x1OyUxSezYfGnkEUvbaoWP++9AIvNS08W
	PJCD7gfO4hclhaKDd4LSZh5N2+zA=
X-Google-Smtp-Source: AGHT+IFwRyIcVSZvyXuz/Y5ENfaFoKjmeiBwqiYsSvIY+pVoBRHNwxCJKvllX7B4eNayMPzNqbM8OHgJEYlbks1+9Q4=
X-Received: by 2002:a17:907:d509:b0:a6f:27e6:8892 with SMTP id
 a640c23a62f3a-a7245dc9697mr132487866b.60.1719137670505; Sun, 23 Jun 2024
 03:14:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240527074644.836699-1-maobibo@loongson.cn> <20240527074644.836699-5-maobibo@loongson.cn>
In-Reply-To: <20240527074644.836699-5-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 23 Jun 2024 18:14:19 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7wdMH=fdGhtxcJ9zY+H-PKT2q0rgrsEPm+LhBgCqNsjQ@mail.gmail.com>
Message-ID: <CAAhV-H7wdMH=fdGhtxcJ9zY+H-PKT2q0rgrsEPm+LhBgCqNsjQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] LoongArch: KVM: Add VM LBT feature detection support
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Mon, May 27, 2024 at 3:46=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Before virt machine or vcpu is created, vmm need check supported
> features from KVM. Here ioctl command KVM_HAS_DEVICE_ATTR is added
> for VM, and macro KVM_LOONGARCH_VM_FEAT_CTRL is added to check
> supported feature.
>
> Three sub-features relative with LBT are added, in later any new
> feature can be added if it is used for vmm. The sub-features is
>  KVM_LOONGARCH_VM_FEAT_X86BT
>  KVM_LOONGARCH_VM_FEAT_ARMBT
>  KVM_LOONGARCH_VM_FEAT_MIPSBT
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
>  arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
>  2 files changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inclu=
de/uapi/asm/kvm.h
> index 656aa6a723a6..ed12e509815c 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -91,6 +91,12 @@ struct kvm_fpu {
>  #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARC=
H_CSR, REG)
>  #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARC=
H_CPUCFG, REG)
>
> +/* Device Control API on vm fd */
> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
I think LBT should be vcpu features rather than vm features, which is
the same like CPUCFG and FP/SIMD.

Moreover, this patch can be merged to the 2nd one.

Huacai

> +
>  /* Device Control API on vcpu fd */
>  #define KVM_LOONGARCH_VCPU_CPUCFG      0
>  #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index 6b2e4f66ad26..09e05108c68b 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long=
 ext)
>         return r;
>  }
>
> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_at=
tr *attr)
> +{
> +       switch (attr->attr) {
> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
> +               if (cpu_has_lbt_x86)
> +                       return 0;
> +               return -ENXIO;
> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
> +               if (cpu_has_lbt_arm)
> +                       return 0;
> +               return -ENXIO;
> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
> +               if (cpu_has_lbt_mips)
> +                       return 0;
> +               return -ENXIO;
> +       default:
> +               return -ENXIO;
> +       }
> +}
> +
> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr=
)
> +{
> +       switch (attr->group) {
> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
> +               return kvm_vm_feature_has_attr(kvm, attr);
> +       default:
> +               return -ENXIO;
> +       }
> +}
> +
>  int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned lo=
ng arg)
>  {
> -       return -ENOIOCTLCMD;
> +       struct kvm *kvm =3D filp->private_data;
> +       void __user *argp =3D (void __user *)arg;
> +       struct kvm_device_attr attr;
> +
> +       switch (ioctl) {
> +       case KVM_HAS_DEVICE_ATTR:
> +               if (copy_from_user(&attr, argp, sizeof(attr)))
> +                       return -EFAULT;
> +
> +               return kvm_vm_has_attr(kvm, &attr);
> +       default:
> +               return -EINVAL;
> +       }
>  }
> --
> 2.39.3
>

