Return-Path: <kvm+bounces-66671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8662BCDBAC5
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 09:30:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF6CC300FF8E
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 08:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797B632E749;
	Wed, 24 Dec 2025 08:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWpbYTtJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901EB32E728
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766565012; cv=none; b=J3nGQDhx48DTnsarwE9CEjLI8lYQszEkO69334LEi44IRtGmoP06Mg/o7Bj9Q4rF2mXjnp/0pelVsdBfZiHVrJyrVbekt6nlQFaRn0uyg0FEPXapY+Z5bZmL+RMNJ4KE/lGY6i3ONhbxV5mcXbB6Xr2tRTGZfwNS77Pj6LL9gtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766565012; c=relaxed/simple;
	bh=3cMlosX90tbr0LQx7VZgj7j/6noF326aNMjHBzxoe9U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ee5rHXSrkPR/NGyvg8i6PwCDDhwJiem+KnKesil4TTyUpty5fwoxPMGctWmdNvL8cd6LNf8gtFO1O/rFQyasHi0lKK4XI3fhKoz43MJaP8GlvvVhmhaNHXtj5gKr7Im0dcENjTtRt3ftx/r6lrcKB8b0N0BzbvJ0UR2grE6AIvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWpbYTtJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BABC16AAE
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 08:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766565012;
	bh=3cMlosX90tbr0LQx7VZgj7j/6noF326aNMjHBzxoe9U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QWpbYTtJmmXA6JEaSBs3NbgMQZvmWdv5xR9CUKwn/omc9c35RTqCyGhG1bagHzbOw
	 Ao2/xVB3jVF+9+LzZv/wBEreL5VTaMolqX9ukXJBUr9cJXzHg0n1wkPFDT1/9phIyO
	 Lme1CGvlPmyNTcLT9JdDZRuAGPQgog81CQ+CrUO3bUdm7f/l88K+XeU04wfQ7K54QX
	 HxnUDZRhc4e6nbJCnonjHYLY6J4HXOuusPxfN3YXqIlIjlLyqEVDzLqAxb1bRUlLPX
	 6dFrb7o3BnAmBqkwFZPQOzGJwKiK9lgwfVpUVFvQ0SRsMDWup46XwYRSgFYa/gMA5Q
	 AeSgGV6X5YdMA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b734fcbf1e3so1138513466b.3
        for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:30:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXD4NQeoTtP1JSfNOjHgBvZeXxa2qXAN3H3wKuaPdtMNTaMMU+OjGMQfdkTzWLLurWuwXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZpDrtuhunLLUqax2FeG2yVbWdYj17W41JMg8CReoECrR1Qgz1
	twOkEtOkaWBu7CAfFG4WpF+HqgN0t7fgN1mQMQNTMg/40AjeFCt51f0oExKfdv0hLXlwMouJws/
	7kdvj2gDhoscOLuA+fhZTH94jJPWXeNs=
X-Google-Smtp-Source: AGHT+IFE05z2xzUe0jeSzGoM1cwZ6c3XW5AreZuEZuoLUq/w20efSuucNxMi0mQsrbAl0xQX/eKVp4faLmJfX5vftP8=
X-Received: by 2002:a17:907:9447:b0:b71:df18:9fb6 with SMTP id
 a640c23a62f3a-b8036f5bb39mr1805581566b.26.1766565010739; Wed, 24 Dec 2025
 00:30:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218111822.975455-1-gaosong@loongson.cn> <20251218111822.975455-3-gaosong@loongson.cn>
 <CAAhV-H4oZJ-t2_sWQ+nkimv6htrBw5-rgG+Omuy2z2chWzK_MA@mail.gmail.com> <4c34fb99-d8d6-826c-3f41-831f2587039b@loongson.cn>
In-Reply-To: <4c34fb99-d8d6-826c-3f41-831f2587039b@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 24 Dec 2025 16:30:26 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4umT=NYa45EuywN_L6fR_vNUZKtPB5RR-GuD67Tpbf0A@mail.gmail.com>
X-Gm-Features: AQt7F2rRpRBC6JD7WH00FSOgOPLl6DauI25QWZvlOfXK8SrLSzmIwBeR0h71D1o
Message-ID: <CAAhV-H4umT=NYa45EuywN_L6fR_vNUZKtPB5RR-GuD67Tpbf0A@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] LongArch: KVM: Add irqfd set dmsintc msg irq
To: gaosong <gaosong@loongson.cn>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kernel@xen0n.name, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2025 at 3:25=E2=80=AFPM gaosong <gaosong@loongson.cn> wrote=
:
>
> Hi,
>
> =E5=9C=A8 2025/12/19 =E4=B8=8B=E5=8D=888:55, Huacai Chen =E5=86=99=E9=81=
=93:
> > Hi, Song,
> >
> > On Thu, Dec 18, 2025 at 7:43=E2=80=AFPM Song Gao <gaosong@loongson.cn> =
wrote:
> >> Add irqfd choice dmsintc to set msi irq by the msg_addr and
> >> implement dmsintc set msi irq.
> >>
> >> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> >> Signed-off-by: Song Gao <gaosong@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/kvm_dmsintc.h |  1 +
> >>   arch/loongarch/kvm/intc/dmsintc.c        |  6 ++++
> >>   arch/loongarch/kvm/irqfd.c               | 45 ++++++++++++++++++++--=
--
> >>   3 files changed, 45 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch=
/include/asm/kvm_dmsintc.h
> >> index 1d4f66996f3c..9b5436a2fcbe 100644
> >> --- a/arch/loongarch/include/asm/kvm_dmsintc.h
> >> +++ b/arch/loongarch/include/asm/kvm_dmsintc.h
> >> @@ -11,6 +11,7 @@ struct loongarch_dmsintc  {
> >>          struct kvm *kvm;
> >>          uint64_t msg_addr_base;
> >>          uint64_t msg_addr_size;
> >> +       uint32_t cpu_mask;
> >>   };
> >>
> >>   struct dmsintc_state {
> >> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/in=
tc/dmsintc.c
> >> index 3fdea81a08c8..9ecb2e3e352d 100644
> >> --- a/arch/loongarch/kvm/intc/dmsintc.c
> >> +++ b/arch/loongarch/kvm/intc/dmsintc.c
> >> @@ -15,6 +15,7 @@ static int kvm_dmsintc_ctrl_access(struct kvm_device=
 *dev,
> >>          void __user *data;
> >>          struct loongarch_dmsintc *s =3D dev->kvm->arch.dmsintc;
> >>          u64 tmp;
> >> +       u32 cpu_bit;
> >>
> >>          data =3D (void __user *)attr->addr;
> >>          switch (addr) {
> >> @@ -30,6 +31,11 @@ static int kvm_dmsintc_ctrl_access(struct kvm_devic=
e *dev,
> >>                                  s->msg_addr_base =3D tmp;
> >>                          else
> >>                                  return  -EFAULT;
> >> +                       s->msg_addr_base =3D tmp;
> >> +                       cpu_bit =3D find_first_bit((unsigned long *)&(=
s->msg_addr_base), 64)
> >> +                                               - AVEC_CPU_SHIFT;
> >> +                       cpu_bit =3D min(cpu_bit, AVEC_CPU_BIT);
> >> +                       s->cpu_mask =3D GENMASK(cpu_bit - 1, 0) & AVEC=
_CPU_MASK;
> >>                  }
> >>                  break;
> >>          case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
> >> diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
> >> index 9a39627aecf0..11f980474552 100644
> >> --- a/arch/loongarch/kvm/irqfd.c
> >> +++ b/arch/loongarch/kvm/irqfd.c
> >> @@ -6,6 +6,7 @@
> >>   #include <linux/kvm_host.h>
> >>   #include <trace/events/kvm.h>
> >>   #include <asm/kvm_pch_pic.h>
> >> +#include <asm/kvm_vcpu.h>
> >>
> >>   static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
> >>                  struct kvm *kvm, int irq_source_id, int level, bool l=
ine_status)
> >> @@ -16,6 +17,41 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_ro=
uting_entry *e,
> >>          return 0;
> >>   }
> >>
> >> +static int kvm_dmsintc_set_msi_irq(struct kvm *kvm, u32 addr, int dat=
a, int level)
> >> +{
> >> +       unsigned int virq, dest;
> >> +       struct kvm_vcpu *vcpu;
> >> +
> >> +       virq =3D (addr >> AVEC_IRQ_SHIFT) & AVEC_IRQ_MASK;
> >> +       dest =3D (addr >> AVEC_CPU_SHIFT) & kvm->arch.dmsintc->cpu_mas=
k;
> >> +       if (dest > KVM_MAX_VCPUS)
> >> +               return -EINVAL;
> >> +       vcpu =3D kvm_get_vcpu_by_cpuid(kvm, dest);
> >> +       if (!vcpu)
> >> +               return -EINVAL;
> >> +       return kvm_loongarch_deliver_msi_to_vcpu(kvm, vcpu, virq, leve=
l);
> > kvm_loongarch_deliver_msi_to_vcpu() is used in this patch but defined
> > in the last patch, this is not acceptable, you can consider to combine
> > these two, and I don't know whether vcpu.c is the best place for it.
> how about just change patch3 before patch 2?  and  deined them in
> kvm/interrupt.c ?
I think combining them is better, and the dmsintc.c part in this patch
seems should go to Patch-1.

Huacai

> >> +}
> >> +
> >> +static int loongarch_set_msi(struct kvm_kernel_irq_routing_entry *e,
> >> +                       struct kvm *kvm, int level)
> >> +{
> >> +       u64 msg_addr;
> >> +
> >> +       if (!level)
> >> +               return -1;
> > Before this patch, this check is in the caller, with this patch it is
> > in the callee, is this suitable? This will add a check in
> > kvm_arch_set_irq_inatomic().
> if check in the caller, like kvm_set_msi,  we also need a check in
> kvm_arch_set_irq_inatomic(), like arm64 or riscv.
I don't know whether it is better to check in the caller or the
callee, I just point out that the logic is changed by this patch.
You can choose the best way with your own knowledge.


Huacai

>
> I will correct it on v5.
>
> Thanks
> Song Gao
>
> > Huacai
> >
> >> +
> >> +       msg_addr =3D (((u64)e->msi.address_hi) << 32) | e->msi.address=
_lo;
> >> +       if (cpu_has_msgint && kvm->arch.dmsintc &&
> >> +               msg_addr >=3D kvm->arch.dmsintc->msg_addr_base &&
> >> +               msg_addr < (kvm->arch.dmsintc->msg_addr_base  + kvm->a=
rch.dmsintc->msg_addr_size)) {
> >> +               return kvm_dmsintc_set_msi_irq(kvm, msg_addr, e->msi.d=
ata, level);
> >> +       } else {
> >> +               pch_msi_set_irq(kvm, e->msi.data, level);
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >>   /*
> >>    * kvm_set_msi: inject the MSI corresponding to the
> >>    * MSI routing entry
> >> @@ -26,12 +62,7 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_ro=
uting_entry *e,
> >>   int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> >>                  struct kvm *kvm, int irq_source_id, int level, bool l=
ine_status)
> >>   {
> >> -       if (!level)
> >> -               return -1;
> >> -
> >> -       pch_msi_set_irq(kvm, e->msi.data, level);
> >> -
> >> -       return 0;
> >> +       return loongarch_set_msi(e, kvm, level);
> >>   }
> >>
> >>   /*
> >> @@ -76,7 +107,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq=
_routing_entry *e,
> >>                  pch_pic_set_irq(kvm->arch.pch_pic, e->irqchip.pin, le=
vel);
> >>                  return 0;
> >>          case KVM_IRQ_ROUTING_MSI:
> >> -               pch_msi_set_irq(kvm, e->msi.data, level);
> >> +               loongarch_set_msi(e, kvm, level);
> >>                  return 0;
> >>          default:
> >>                  return -EWOULDBLOCK;
> >> --
> >> 2.39.3
> >>
> >>
>

