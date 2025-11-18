Return-Path: <kvm+bounces-63542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B67BC69768
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 13:48:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 96F7A2ACCC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 12:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E17523CEF9;
	Tue, 18 Nov 2025 12:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="myoeeqSp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBEB236A70
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 12:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763470122; cv=none; b=Cgl5ct/LcgkXwsgW9gRFuB3vsC3kB3bIe6CN0TmaclU0k5V08Ry4leFvtk/U9CQQYd9+xsb2R9uZo+/dP8EmrTKj1gMNjO8IJ3XfePuAv5U0cEfd5frd6eTfG4FG5TR5MFKd+Saq6OVGfLg6vbZUfsZgATLELiQGVgrZqtU+msc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763470122; c=relaxed/simple;
	bh=pFdS3qA9WYaaq00VcckqdlanD8dVirrH/4YapO6gIKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mzYGPJv/cgrhsbd/Mblrk+9+p3hHO4r2eezqMXWj+CdTuyRoXClV1203MrCFAT/jO4SG8oYuEu1/cRa0KB4UX5uwYvGQsR6t0a6gTZL9cBL1+bkDJOeoHvfqXuQTdL4+FzXhmZfkm3hSipfXWOw/FDzewebOPWz5QulRh19kpxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=myoeeqSp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206C8C16AAE
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 12:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763470122;
	bh=pFdS3qA9WYaaq00VcckqdlanD8dVirrH/4YapO6gIKU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=myoeeqSpH6pW78m/Ndkzd3U8DjNF/t1HC43NAn5CmDRMeJ9/blyhxfMPm47q4vWU2
	 R688ttJjsZOP5Ara+YdG1pDi3FnmHDZaRwfjMhsG5ekaglB+icVddjkmBW5nVx5qrN
	 //ngDE/HupY/OMAxsLkojibdV9uhQLPQRYQZbNrQB9Nb1phIq6AqbFdDnsZBbEuXbj
	 Z5Qt6H4fs039V+wq/Awh3W0EocjT68aQAfZtLnFx9ByZXU6IUghdT0utlUNozfOUMv
	 yJv3BsWXVMqTm0ax2Po9wrCiq+U1JO/NfgsoW/ng4v03RvfC3GBzHVdMdkyWuBfhOL
	 3WWaKNyeg3h2Q==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b73875aa527so404085066b.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 04:48:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV5MEiBpCqP2SgOtn29Y1Xirl83itRPVVwHnVPN2MJjD/vVYBa5YkpjjCH/oZVsDi1ibK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQH0gvoMd0eOxJd1RujSKEBoC9a7ixM51OZy2xV+tz0Ags+cbg
	ucFaxuKalvlHBSSjtPImwi9m3BLeLPWhJw7ydJfGt4p9ZJOpTOFxgAsJkkrAJFZRurQ6Si51ns2
	zFX4FlYosuMSjPFttXs/hUoHPP222Pb4=
X-Google-Smtp-Source: AGHT+IEDrP2TdyUTahNPJRfPwcoYAoS5gMqEHUbAvm5d4Dycw7x0zFNGBRQFdUMDmaXX2ULGwzkJBFq6jE806ti0w0o=
X-Received: by 2002:a17:907:a44:b0:b73:544d:ba2e with SMTP id
 a640c23a62f3a-b736780d5bamr1948345866b.25.1763470120092; Tue, 18 Nov 2025
 04:48:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118080656.2012805-1-maobibo@loongson.cn> <20251118080656.2012805-3-maobibo@loongson.cn>
In-Reply-To: <20251118080656.2012805-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 18 Nov 2025 20:48:41 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4hoS0Wo3TS+FdikXMkb7qjWNFSPDoajQr0bzdeROJwGw@mail.gmail.com>
X-Gm-Features: AWmQ_bkSeXCgy-qK2rzvP-hL92k0XNXRWWttKpPo-xMdgC-eo-zjb1mltVmpNY4
Message-ID: <CAAhV-H4hoS0Wo3TS+FdikXMkb7qjWNFSPDoajQr0bzdeROJwGw@mail.gmail.com>
Subject: Re: [PATCH 2/3] LoongArch: Add paravirt support with vcpu_is_preempted()
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>, 
	Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Tue, Nov 18, 2025 at 4:07=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Function vcpu_is_preempted() is used to check whether vCPU is preempted
> or not. Here add implementation with vcpu_is_preempted() when option
> CONFIG_PARAVIRT is enabled.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/smp.h      |  1 +
>  arch/loongarch/include/asm/spinlock.h |  5 +++++
>  arch/loongarch/kernel/paravirt.c      | 16 ++++++++++++++++
>  arch/loongarch/kernel/smp.c           |  6 ++++++
>  4 files changed, 28 insertions(+)
>
> diff --git a/arch/loongarch/include/asm/smp.h b/arch/loongarch/include/as=
m/smp.h
> index 3a47f52959a8..5b37f7bf2060 100644
> --- a/arch/loongarch/include/asm/smp.h
> +++ b/arch/loongarch/include/asm/smp.h
> @@ -18,6 +18,7 @@ struct smp_ops {
>         void (*init_ipi)(void);
>         void (*send_ipi_single)(int cpu, unsigned int action);
>         void (*send_ipi_mask)(const struct cpumask *mask, unsigned int ac=
tion);
> +       bool (*vcpu_is_preempted)(int cpu);
>  };
>  extern struct smp_ops mp_ops;
>
> diff --git a/arch/loongarch/include/asm/spinlock.h b/arch/loongarch/inclu=
de/asm/spinlock.h
> index 7cb3476999be..c001cef893aa 100644
> --- a/arch/loongarch/include/asm/spinlock.h
> +++ b/arch/loongarch/include/asm/spinlock.h
> @@ -5,6 +5,11 @@
>  #ifndef _ASM_SPINLOCK_H
>  #define _ASM_SPINLOCK_H
>
> +#ifdef CONFIG_PARAVIRT
> +#define vcpu_is_preempted      vcpu_is_preempted
> +bool vcpu_is_preempted(int cpu);
> +#endif
Maybe paravirt.h is a better place?

> +
>  #include <asm/processor.h>
>  #include <asm/qspinlock.h>
>  #include <asm/qrwlock.h>
> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/par=
avirt.c
> index b1b51f920b23..b99404b6b13f 100644
> --- a/arch/loongarch/kernel/paravirt.c
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -52,6 +52,13 @@ static u64 paravt_steal_clock(int cpu)
>  #ifdef CONFIG_SMP
>  static struct smp_ops native_ops;
>
> +static bool pv_vcpu_is_preempted(int cpu)
> +{
> +       struct kvm_steal_time *src =3D &per_cpu(steal_time, cpu);
> +
> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> +}
> +
>  static void pv_send_ipi_single(int cpu, unsigned int action)
>  {
>         int min, old;
> @@ -308,6 +315,9 @@ int __init pv_time_init(void)
>                 pr_err("Failed to install cpu hotplug callbacks\n");
>                 return r;
>         }
> +
> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_HINT))
> +               mp_ops.vcpu_is_preempted =3D pv_vcpu_is_preempted;
>  #endif
>
>         static_call_update(pv_steal_clock, paravt_steal_clock);
> @@ -332,3 +342,9 @@ int __init pv_spinlock_init(void)
>
>         return 0;
>  }
> +
> +bool notrace vcpu_is_preempted(int cpu)
> +{
> +       return mp_ops.vcpu_is_preempted(cpu);
> +}

We can simplify the whole patch like this, then we don't need to touch
smp.c, and we can merge Patch-2/3.

+bool notrace vcpu_is_preempted(int cpu)
+{
+  if (!kvm_para_has_feature(KVM_FEATURE_PREEMPT_HINT))
+     return false;
+ else {
+     struct kvm_steal_time *src =3D &per_cpu(steal_time, cpu);
+     return !!(src->preempted & KVM_VCPU_PREEMPTED);
+ }
+}
Huacai

> +EXPORT_SYMBOL(vcpu_is_preempted);
> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
> index 46036d98da75..f04192fedf8d 100644
> --- a/arch/loongarch/kernel/smp.c
> +++ b/arch/loongarch/kernel/smp.c
> @@ -307,10 +307,16 @@ static void loongson_init_ipi(void)
>                 panic("IPI IRQ request failed\n");
>  }
>
> +static bool loongson_vcpu_is_preempted(int cpu)
> +{
> +       return false;
> +}
> +
>  struct smp_ops mp_ops =3D {
>         .init_ipi               =3D loongson_init_ipi,
>         .send_ipi_single        =3D loongson_send_ipi_single,
>         .send_ipi_mask          =3D loongson_send_ipi_mask,
> +       .vcpu_is_preempted      =3D loongson_vcpu_is_preempted,
>  };
>
>  static void __init fdt_smp_setup(void)
> --
> 2.39.3
>
>

