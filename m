Return-Path: <kvm+bounces-66336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA63CCFEE5
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E29F30365B0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594C83009F7;
	Fri, 19 Dec 2025 12:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXso7U5F"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E40026ED33
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766148924; cv=none; b=s5mGHMb/0NTBqf5klEyJ3O+0wAHGbNsH5To4nD7cB5oIFIzmiAXapLva/NbkCKLkwIH8p48JihU/XNoAiZw5E2jpK7HWcPjHWK0PpwewnBSfL/pBgT6AkoC3R1L20zyRLxZcWyJDksLXjiKnuI8lXWYxBLGaVSk9Ix/ZTVOjauw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766148924; c=relaxed/simple;
	bh=ek/t0JS+qrNoh1M64LMlXVAk4CdB6zxzt1JBin/Xbr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FJpB8QBMSveXQfJAQ0nD/p9AY5IZeHFNQqh0wpWpZ+PfqJOjCg0rEVTID4qRjv2SHDZOdsjM95xAU5ety998PsnFGsomrUbZm6xml2Ux5R3GUliIgnVZpc/L/xkrvSCWgzNicYYBVIc5LNl1ltBmL5GJt8SznGjUg1XSdJnGA4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXso7U5F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35228C19421
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 12:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766148924;
	bh=ek/t0JS+qrNoh1M64LMlXVAk4CdB6zxzt1JBin/Xbr4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PXso7U5FLcxw6kOhjhCm3zAocpf2kKIRLx6dwS6GJgGpPLaUyCpmyYaDkD9Mn6oCf
	 Z5uYHgYFwtqj3cHRXw3TgAKxxEqaFetHh+b31Seou/7XFtZDB3Uij3aJYsZSGbVd8m
	 4GGypissyMqm0qcjAikAwaF/W+WcbyVU46d9R2S4XYZb2sWDWRh0X2hgviHuS1Ucnd
	 OE3+lRbVBJPaA/kqfP64WDM6BLBJBd583j8ZpjPQ4d6nZoEA6mbG26LLHY3DPn5TnA
	 bKgGQjGs7mzl44cvZTg0qr8r6ay/iWMJt15EQF7isptd30tovqRA/0M1jo+wEo8rph
	 pDR920JDUEOFw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7697e8b01aso311308666b.2
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 04:55:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWbumWqOUTz5STCi2Z6RDbdLhPrVBI5jC4mFtAFvPsu6lwEO9u/qVQP+QcuIb42WrrBOhE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQmkTuGcRXiujHlaex2dSjc90APv7/BMoFeTGRVQZ2kCdvPcqo
	X8IYK7bH8eRYjXs9TXcx5VJYRPlGahITws1Q3NiM1iNZ7tkh66Oj6T1K7wOubf3i0mQT1bFUtci
	exwGp1go9bxngg89cJg11ixOkDkZCAoU=
X-Google-Smtp-Source: AGHT+IGRYNKlM0FQSNpgTolizwO0ycirPPZBMnd73fF+8TwBT5nejT+3kcPll5ju8oL8Ktm8GrcAtWoJ0OglQEh1OCI=
X-Received: by 2002:a17:906:2081:b0:b80:411f:aa50 with SMTP id
 a640c23a62f3a-b80411faa6emr115146366b.48.1766148922782; Fri, 19 Dec 2025
 04:55:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218111822.975455-1-gaosong@loongson.cn> <20251218111822.975455-3-gaosong@loongson.cn>
In-Reply-To: <20251218111822.975455-3-gaosong@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 19 Dec 2025 20:55:18 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4oZJ-t2_sWQ+nkimv6htrBw5-rgG+Omuy2z2chWzK_MA@mail.gmail.com>
X-Gm-Features: AQt7F2pab9nMEvUYW8Ims0EqciIAEUFIO0uIVv0tMN8ZPFm5rjBUs4gOKOupZrg
Message-ID: <CAAhV-H4oZJ-t2_sWQ+nkimv6htrBw5-rgG+Omuy2z2chWzK_MA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] LongArch: KVM: Add irqfd set dmsintc msg irq
To: Song Gao <gaosong@loongson.cn>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kernel@xen0n.name, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Song,

On Thu, Dec 18, 2025 at 7:43=E2=80=AFPM Song Gao <gaosong@loongson.cn> wrot=
e:
>
> Add irqfd choice dmsintc to set msi irq by the msg_addr and
> implement dmsintc set msi irq.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_dmsintc.h |  1 +
>  arch/loongarch/kvm/intc/dmsintc.c        |  6 ++++
>  arch/loongarch/kvm/irqfd.c               | 45 ++++++++++++++++++++----
>  3 files changed, 45 insertions(+), 7 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/in=
clude/asm/kvm_dmsintc.h
> index 1d4f66996f3c..9b5436a2fcbe 100644
> --- a/arch/loongarch/include/asm/kvm_dmsintc.h
> +++ b/arch/loongarch/include/asm/kvm_dmsintc.h
> @@ -11,6 +11,7 @@ struct loongarch_dmsintc  {
>         struct kvm *kvm;
>         uint64_t msg_addr_base;
>         uint64_t msg_addr_size;
> +       uint32_t cpu_mask;
>  };
>
>  struct dmsintc_state {
> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/=
dmsintc.c
> index 3fdea81a08c8..9ecb2e3e352d 100644
> --- a/arch/loongarch/kvm/intc/dmsintc.c
> +++ b/arch/loongarch/kvm/intc/dmsintc.c
> @@ -15,6 +15,7 @@ static int kvm_dmsintc_ctrl_access(struct kvm_device *d=
ev,
>         void __user *data;
>         struct loongarch_dmsintc *s =3D dev->kvm->arch.dmsintc;
>         u64 tmp;
> +       u32 cpu_bit;
>
>         data =3D (void __user *)attr->addr;
>         switch (addr) {
> @@ -30,6 +31,11 @@ static int kvm_dmsintc_ctrl_access(struct kvm_device *=
dev,
>                                 s->msg_addr_base =3D tmp;
>                         else
>                                 return  -EFAULT;
> +                       s->msg_addr_base =3D tmp;
> +                       cpu_bit =3D find_first_bit((unsigned long *)&(s->=
msg_addr_base), 64)
> +                                               - AVEC_CPU_SHIFT;
> +                       cpu_bit =3D min(cpu_bit, AVEC_CPU_BIT);
> +                       s->cpu_mask =3D GENMASK(cpu_bit - 1, 0) & AVEC_CP=
U_MASK;
>                 }
>                 break;
>         case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
> diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
> index 9a39627aecf0..11f980474552 100644
> --- a/arch/loongarch/kvm/irqfd.c
> +++ b/arch/loongarch/kvm/irqfd.c
> @@ -6,6 +6,7 @@
>  #include <linux/kvm_host.h>
>  #include <trace/events/kvm.h>
>  #include <asm/kvm_pch_pic.h>
> +#include <asm/kvm_vcpu.h>
>
>  static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
>                 struct kvm *kvm, int irq_source_id, int level, bool line_=
status)
> @@ -16,6 +17,41 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routi=
ng_entry *e,
>         return 0;
>  }
>
> +static int kvm_dmsintc_set_msi_irq(struct kvm *kvm, u32 addr, int data, =
int level)
> +{
> +       unsigned int virq, dest;
> +       struct kvm_vcpu *vcpu;
> +
> +       virq =3D (addr >> AVEC_IRQ_SHIFT) & AVEC_IRQ_MASK;
> +       dest =3D (addr >> AVEC_CPU_SHIFT) & kvm->arch.dmsintc->cpu_mask;
> +       if (dest > KVM_MAX_VCPUS)
> +               return -EINVAL;
> +       vcpu =3D kvm_get_vcpu_by_cpuid(kvm, dest);
> +       if (!vcpu)
> +               return -EINVAL;
> +       return kvm_loongarch_deliver_msi_to_vcpu(kvm, vcpu, virq, level);
kvm_loongarch_deliver_msi_to_vcpu() is used in this patch but defined
in the last patch, this is not acceptable, you can consider to combine
these two, and I don't know whether vcpu.c is the best place for it.

> +}
> +
> +static int loongarch_set_msi(struct kvm_kernel_irq_routing_entry *e,
> +                       struct kvm *kvm, int level)
> +{
> +       u64 msg_addr;
> +
> +       if (!level)
> +               return -1;
Before this patch, this check is in the caller, with this patch it is
in the callee, is this suitable? This will add a check in
kvm_arch_set_irq_inatomic().

Huacai

> +
> +       msg_addr =3D (((u64)e->msi.address_hi) << 32) | e->msi.address_lo=
;
> +       if (cpu_has_msgint && kvm->arch.dmsintc &&
> +               msg_addr >=3D kvm->arch.dmsintc->msg_addr_base &&
> +               msg_addr < (kvm->arch.dmsintc->msg_addr_base  + kvm->arch=
.dmsintc->msg_addr_size)) {
> +               return kvm_dmsintc_set_msi_irq(kvm, msg_addr, e->msi.data=
, level);
> +       } else {
> +               pch_msi_set_irq(kvm, e->msi.data, level);
> +       }
> +
> +       return 0;
> +}
> +
>  /*
>   * kvm_set_msi: inject the MSI corresponding to the
>   * MSI routing entry
> @@ -26,12 +62,7 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routi=
ng_entry *e,
>  int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>                 struct kvm *kvm, int irq_source_id, int level, bool line_=
status)
>  {
> -       if (!level)
> -               return -1;
> -
> -       pch_msi_set_irq(kvm, e->msi.data, level);
> -
> -       return 0;
> +       return loongarch_set_msi(e, kvm, level);
>  }
>
>  /*
> @@ -76,7 +107,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_ro=
uting_entry *e,
>                 pch_pic_set_irq(kvm->arch.pch_pic, e->irqchip.pin, level)=
;
>                 return 0;
>         case KVM_IRQ_ROUTING_MSI:
> -               pch_msi_set_irq(kvm, e->msi.data, level);
> +               loongarch_set_msi(e, kvm, level);
>                 return 0;
>         default:
>                 return -EWOULDBLOCK;
> --
> 2.39.3
>
>

