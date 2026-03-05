Return-Path: <kvm+bounces-72797-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFSeH+UxqWnM2wAAu9opvQ
	(envelope-from <kvm+bounces-72797-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:33:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BF620CB83
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:33:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 910AD301D0F0
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 07:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F30E3246F0;
	Thu,  5 Mar 2026 07:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehFfM/bo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842C130B53A
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 07:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772696029; cv=none; b=qSPPoM40OH9Or2IT6kf7JBRo6zHIhTikWOJIouuyq2RD2rl6sWemGjBMMFLzUoqFCFD70MS84BGP9+9PSU6zl5SMLbBhuqLQ5wPQSv3axec5BwOYJ/FWy6kmB0IX8XxMaNeJm4hQ9/AkqKwck1MIsiOjCVqR0BZtAINmcl1nCXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772696029; c=relaxed/simple;
	bh=4VQbdHSXddQBtT4jGJshiZPul2Aj6mriSxVAhWAE3RQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TPQRa6UxS2/3RjaveOxjRpDJ5auKdJ0q6F0gWr8aNO5+pCFT4qxBicxgWJbJRTFWPk0Sl09Myzg3dQlGXXs68HTcXB5Bi5XbAlaGtxCpkaqjea7D6oVQGr0hSAl1IX9gWfENOnBEs+yfw4ig5tIKRGRqiJYts7f0l3IKX646dm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehFfM/bo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AFFC4AF0B
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 07:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772696029;
	bh=4VQbdHSXddQBtT4jGJshiZPul2Aj6mriSxVAhWAE3RQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ehFfM/boPEsqX2z0TQgHynEnMN7nkcZ4akI+We6w7xsXNGJYK5YwBCQZ7TqN7H2kl
	 qMPwae2ycS5c5A4FPM1e7cuI3mHk7jtF94AdE2+SAWMd9nl3euKLt4Yd1k1pTds6px
	 Q5Fj3oqxtG54WynNRNeMdIDH4VHTv2jzFWWNX81G6TncOplI0puZ4xguTa7rbd1paO
	 cBBQ5N7sZfbTMc3NYmo4n+c3gBzWYQu5rXdhkRcXNouYG82DJUI8m1AJ8EEG7nv4f+
	 fVlp2NshXgeoimv5j/RVrXZAOQgK+JFOkwmpNOaMdGN5dVvVC9YOyXrS/lijdZfFnk
	 uTjQNuDA76Wdg==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65b9d8d6b7dso12543092a12.2
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 23:33:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV2OdMuOO5dlwWRY3Htwsa3T9pfrWM6Dqc+gg5vQw4e6X107B0GvtCLl/N/IfGycIoCRlE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZorg15WtBAd67Y8G27BGuiwUu2x5ptptPYXWNyO5U5/2TSe6R
	8liBg+jFzN2W0nMbH4Xqn0CJEPBZrp/LpRN9/HwhnRzjaLMHb+fHflh7QafJKwwE2M3eUWi70ae
	qgfLbbOd6WivvW7QvZcfT0mBroCGVV8g=
X-Received: by 2002:a05:6402:13c9:b0:660:39f:1cce with SMTP id
 4fb4d7f45d1cf-660f00d27f3mr2640022a12.20.1772696027702; Wed, 04 Mar 2026
 23:33:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206012028.3318291-1-gaosong@loongson.cn> <20260206012028.3318291-3-gaosong@loongson.cn>
In-Reply-To: <20260206012028.3318291-3-gaosong@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 5 Mar 2026 15:33:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6-dsyV+2FsYYo1ZovrKP+WxkWRqjFFkjRSxEw4m6jhYQ@mail.gmail.com>
X-Gm-Features: AaiRm50NeOQFjiC9QarfMHXB0y7H5gICg1wH3k2WVgm_37Pgk85I8N7Pf4rydVI
Message-ID: <CAAhV-H6-dsyV+2FsYYo1ZovrKP+WxkWRqjFFkjRSxEw4m6jhYQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] LongArch: KVM: Add dmsintc inject msi to the dest vcpu
To: Song Gao <gaosong@loongson.cn>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kernel@xen0n.name, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 20BF620CB83
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72797-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

Hi, Song,

On Fri, Feb 6, 2026 at 9:45=E2=80=AFAM Song Gao <gaosong@loongson.cn> wrote=
:
>
> Implement irqfd deliver msi to vcpu and vcpu dmsintc inject irq.
> Add irqfd choice dmsintc to set msi irq by the msg_addr and
> implement dmsintc set msi irq.
>
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_dmsintc.h |  1 +
>  arch/loongarch/include/asm/kvm_host.h    |  5 ++
>  arch/loongarch/kvm/intc/dmsintc.c        |  6 +++
>  arch/loongarch/kvm/interrupt.c           |  1 +
>  arch/loongarch/kvm/irqfd.c               | 42 +++++++++++++++--
>  arch/loongarch/kvm/vcpu.c                | 58 ++++++++++++++++++++++++
>  6 files changed, 109 insertions(+), 4 deletions(-)
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
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index 5e9e2af7312f..91e0190aeaec 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -258,6 +258,11 @@ struct kvm_vcpu_arch {
>         } st;
>  };
>
> +void loongarch_dmsintc_inject_irq(struct kvm_vcpu *vcpu);
> +int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
> +                               struct kvm_vcpu *vcpu,
> +                               u32 vector, int level);
> +
>  static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, in=
t reg)
>  {
>         return csr->csrs[reg];
> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/=
dmsintc.c
> index 00e401de0464..1bb61e55d061 100644
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
I'm not sure but maybe this part should go to the first patch?

> diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrup=
t.c
> index a6d42d399a59..893a81ca1079 100644
> --- a/arch/loongarch/kvm/interrupt.c
> +++ b/arch/loongarch/kvm/interrupt.c
> @@ -33,6 +33,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsig=
ned int priority)
>                 irq =3D priority_to_irq[priority];
>
>         if (cpu_has_msgint && (priority =3D=3D INT_AVEC)) {
> +               loongarch_dmsintc_inject_irq(vcpu);
>                 set_gcsr_estat(irq);
>                 return 1;
>         }
> diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
> index 9a39627aecf0..3bbb26f4e2b7 100644
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
> @@ -16,6 +17,38 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routi=
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
> +}
> +
> +static int loongarch_set_msi(struct kvm_kernel_irq_routing_entry *e,
> +                       struct kvm *kvm, int level)
> +{
> +       u64 msg_addr;
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
Rename loongarch_set_msi() to loongarch_msi_set_irq(), rename
kvm_dmsintc_set_msi_irq() to dmsintc_msi_set_irq(), this makes the
naming more consistent.

> +
>  /*
>   * kvm_set_msi: inject the MSI corresponding to the
>   * MSI routing entry
> @@ -29,9 +62,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>         if (!level)
>                 return -1;
>
> -       pch_msi_set_irq(kvm, e->msi.data, level);
> -
> -       return 0;
> +       return loongarch_set_msi(e, kvm, level);
>  }
>
>  /*
> @@ -71,12 +102,15 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>                 struct kvm *kvm, int irq_source_id, int level, bool line_=
status)
>  {
> +       if (!level)
> +               return -EWOULDBLOCK;
> +
>         switch (e->type) {
>         case KVM_IRQ_ROUTING_IRQCHIP:
>                 pch_pic_set_irq(kvm->arch.pch_pic, e->irqchip.pin, level)=
;
>                 return 0;
>         case KVM_IRQ_ROUTING_MSI:
> -               pch_msi_set_irq(kvm, e->msi.data, level);
> +               loongarch_set_msi(e, kvm, level);
>                 return 0;
>         default:
>                 return -EWOULDBLOCK;
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 656b954c1134..325bb084d704 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -14,6 +14,64 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>
> +void loongarch_dmsintc_inject_irq(struct kvm_vcpu *vcpu)
> +{
> +       struct dmsintc_state *ds =3D &vcpu->arch.dmsintc_state;
> +       unsigned int i;
> +       unsigned long temp[4], old;
> +
> +       if (!ds)
> +               return;
> +
> +       for (i =3D 0; i < 4; i++) {
> +               old =3D atomic64_read(&(ds->vector_map[i]));
> +               if (old)
> +                       temp[i] =3D atomic64_xchg(&(ds->vector_map[i]), 0=
);
> +       }
> +
> +       if (temp[0]) {
> +               old =3D kvm_read_hw_gcsr(LOONGARCH_CSR_ISR0);
> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR0, temp[0]|old);
> +       }
> +
> +       if (temp[1]) {
> +               old =3D kvm_read_hw_gcsr(LOONGARCH_CSR_ISR1);
> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR1, temp[1]|old);
> +       }
> +
> +       if (temp[2]) {
> +               old =3D kvm_read_hw_gcsr(LOONGARCH_CSR_ISR2);
> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR2, temp[2]|old);
> +       }
> +
> +       if (temp[3]) {
> +               old =3D kvm_read_hw_gcsr(LOONGARCH_CSR_ISR3);
> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR3, temp[3]|old);
> +       }
> +}
The only caller is in interrupt.c, so rename
loongarch_dmsintc_inject_irq() to msgint_inject_irq() (or
dmsintc_inject_irq() if you prefer), and move it to interrupt.c, then
we don't need to declare it as a extern function.

> +
> +int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
> +                               struct kvm_vcpu *vcpu,
> +                               u32 vector, int level)
> +{
> +       struct kvm_interrupt vcpu_irq;
> +       struct dmsintc_state *ds;
> +
> +       if (!level)
> +               return 0;
> +       if (!vcpu || vector >=3D 256)
> +               return -EINVAL;
> +       ds =3D &vcpu->arch.dmsintc_state;
> +       if (!ds)
> +               return -ENODEV;
> +       set_bit(vector, (unsigned long *)&ds->vector_map);
> +       vcpu_irq.irq =3D INT_AVEC;
> +       kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
> +       kvm_vcpu_kick(vcpu);
> +       return 0;
> +}
The only caller is in irqfd.c, so rename
kvm_loongarch_deliver_msi_to_vcpu() to dmsintc_deliver_msi_to_vcpu(),
and move it to irqfd.c, then we don't need to declare it as a extern
function.

And in addition, from Documentation/arch/loongarch/irq-chip-model.rst,
all msi irq are triggered from "pch_msi_irq", which means it is not
reasonable to dispatch the dmsintc/pch_msi paths in
loongarch_set_msi(). Instead, we should dispatch the dmsintc/eiointc
paths in pch_msi_set_irq(), this needs a rework...


Huacai

> +
> +
>  const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =3D {
>         KVM_GENERIC_VCPU_STATS(),
>         STATS_DESC_COUNTER(VCPU, int_exits),
> --
> 2.39.3
>
>

