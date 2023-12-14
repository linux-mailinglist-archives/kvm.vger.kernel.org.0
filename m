Return-Path: <kvm+bounces-4436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC0F58127CA
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 07:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 359EEB21221
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 06:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1286D273;
	Thu, 14 Dec 2023 06:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="OyVCbnto"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C5D93
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 22:14:02 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-3b9e07690ccso5024945b6e.3
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 22:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702534442; x=1703139242; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3sMkRAMQECWLiukPZgPf+GGB55ddSK20MJ/gjXWD1s=;
        b=OyVCbntoESf3PuDmZz/t5WlC3rcPv1BiSso5hvDiLnGK7Dbjzx8dQPW3Wo73nxo+vS
         C5q28PKjbo8c4K1GE6Hjy7INqx6QAl1Ij4isbGgSsXYYJzSBf15H64MevWcYseE777ui
         HlZUlv/JsRTXIW7bCQXcJ7HWjKoMFajXiMyN+O609x6yqm6lRYJuOlBZ7ynKObBAAlJX
         mtazflA1hk/0P5Xuji/tZAbuRU7JR46A9d+HhmEaKrRkRMN4L8aZKCe2tCQcpMR5MO5M
         nv4aEDLXL7rsAyuxf3TG8EF0lhDSE9sPH+oVvZcj47YBzD+wa4XMq9ssrflavBuMDDWm
         aKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702534442; x=1703139242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3sMkRAMQECWLiukPZgPf+GGB55ddSK20MJ/gjXWD1s=;
        b=uR3k3xCSPZXc8MSoEsUBKfbeM9k2VNSVFsJJV87wmKbYN39fphKdV4IPejF3pTbH9W
         n6WR+VacOqGvmLFUgUpd+mzrY3ra5x3F7EV3x9404PnWsinU9rVwp8Q4S4FmQvRNpIVw
         HufqM6BVjurYLc8/OARKa/KSLpwPjvpV5RyehMAGelkvtGGen3f3m/8rl5Beh4LHz8rx
         J506vHzyb9gzhUFo1S0Vp4mOuXHbr5q5EaeYIjFzoVSYLZsMRPprebEE6fXooL1SabS0
         UYDtGLK+8b1CPR5EJjK40wdkMRolptDEQOJKKBkRdFO0N/DEz8eV8Mf5APscP15TNwpC
         a8nw==
X-Gm-Message-State: AOJu0Yx2CkXCtObvPkRAyJn9xr0MTd+XxgK37A+tGAu68IqLD77oqIJv
	kytR98AOgc73NUoRi6Vh2Sw7aytPUov5shb7gKfBHg==
X-Google-Smtp-Source: AGHT+IHQd+GqK3y5tlwO2tTpsax7aS81PVJh1PsMGIYAkqaLtpj/3C4S2vBn648Rccq1W4+OEQ+fJWJGTJEaydQwxew=
X-Received: by 2002:a05:6808:2e85:b0:3ba:8d5:4009 with SMTP id
 gt5-20020a0568082e8500b003ba08d54009mr11288098oib.110.1702534442120; Wed, 13
 Dec 2023 22:14:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com> <20230916003118.2540661-23-seanjc@google.com>
In-Reply-To: <20230916003118.2540661-23-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 11:43:50 +0530
Message-ID: <CAAhSdy2N8PmP2+-8sFVpgduED0HU9D3dqg7sk3+R9f2wRgZ7KA@mail.gmail.com>
Subject: Re: [PATCH 22/26] entry/kvm: KVM: Move KVM details related to
 signal/-EINTR into KVM proper
To: Sean Christopherson <seanjc@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>, 
	Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 16, 2023 at 6:02=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Move KVM's morphing of pending signals into exits to userspace into KVM
> proper, and drop the @vcpu param from xfer_to_guest_mode_handle_work().
> How KVM responds to -EINTR is a detail that really belongs in KVM itself,
> and removing the non-KVM call to kvm_handle_signal_exit() will allow
> hiding said API and the definition of "struct kvm_vcpu" from the kernel.
>
> Alternatively, entry/kvm.c could be treated as part of KVM, i.e. be given
> access to KVM internals, but that's not obviously better than having KVM
> react to -EINTR (though it's not obviously worse either).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/arm64/kvm/arm.c      |  3 +--
>  arch/riscv/kvm/vcpu.c     |  2 +-
>  arch/x86/kvm/vmx/vmx.c    |  1 -
>  arch/x86/kvm/x86.c        |  3 +--
>  include/linux/entry-kvm.h |  3 +--
>  include/linux/kvm_host.h  | 13 ++++++++++++-
>  kernel/entry/kvm.c        | 11 ++++-------
>  7 files changed, 20 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6480628197b4..641df091e46b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -6,7 +6,6 @@
>
>  #include <linux/bug.h>
>  #include <linux/cpu_pm.h>
> -#include <linux/entry-kvm.h>
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/kvm_host.h>
> @@ -929,7 +928,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 /*
>                  * Check conditions before entering the guest
>                  */
> -               ret =3D xfer_to_guest_mode_handle_work(vcpu);
> +               ret =3D kvm_xfer_to_guest_mode_handle_work(vcpu);
>                 if (!ret)
>                         ret =3D 1;
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 82229db1ce73..c313f4e90e70 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -667,7 +667,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>         run->exit_reason =3D KVM_EXIT_UNKNOWN;
>         while (ret > 0) {
>                 /* Check conditions before entering the guest */
> -               ret =3D xfer_to_guest_mode_handle_work(vcpu);
> +               ret =3D kvm_xfer_to_guest_mode_handle_work(vcpu);
>                 if (ret)
>                         continue;
>                 ret =3D 1;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index faf0071566ef..43b87ad5fde8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -28,7 +28,6 @@
>  #include <linux/slab.h>
>  #include <linux/tboot.h>
>  #include <linux/trace_events.h>
> -#include <linux/entry-kvm.h>
>
>  #include <asm/apic.h>
>  #include <asm/asm.h>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6c9c81e82e65..aab095f89d9e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -59,7 +59,6 @@
>  #include <linux/sched/stat.h>
>  #include <linux/sched/isolation.h>
>  #include <linux/mem_encrypt.h>
> -#include <linux/entry-kvm.h>
>  #include <linux/suspend.h>
>  #include <linux/smp.h>
>
> @@ -10987,7 +10986,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>
>                 if (__xfer_to_guest_mode_work_pending()) {
>                         kvm_vcpu_srcu_read_unlock(vcpu);
> -                       r =3D xfer_to_guest_mode_handle_work(vcpu);
> +                       r =3D kvm_xfer_to_guest_mode_handle_work(vcpu);
>                         kvm_vcpu_srcu_read_lock(vcpu);
>                         if (r)
>                                 return r;
> diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
> index e7d90d06e566..e235a91d28fc 100644
> --- a/include/linux/entry-kvm.h
> +++ b/include/linux/entry-kvm.h
> @@ -42,11 +42,10 @@ static inline int arch_xfer_to_guest_mode_handle_work=
(unsigned long ti_work)
>  /**
>   * xfer_to_guest_mode_handle_work - Check and handle pending work which =
needs
>   *                                 to be handled before going to guest m=
ode
> - * @vcpu:      Pointer to current's VCPU data
>   *
>   * Returns: 0 or an error code
>   */
> -int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu);
> +int xfer_to_guest_mode_handle_work(void);
>
>  /**
>   * xfer_to_guest_mode_prepare - Perform last minute preparation work tha=
t
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index fb6c6109fdca..d520d6801070 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2,7 +2,7 @@
>  #ifndef __KVM_HOST_H
>  #define __KVM_HOST_H
>
> -
> +#include <linux/entry-kvm.h>
>  #include <linux/types.h>
>  #include <linux/hardirq.h>
>  #include <linux/list.h>
> @@ -2293,6 +2293,17 @@ static inline void kvm_handle_signal_exit(struct k=
vm_vcpu *vcpu)
>         vcpu->run->exit_reason =3D KVM_EXIT_INTR;
>         vcpu->stat.signal_exits++;
>  }
> +
> +static inline int kvm_xfer_to_guest_mode_handle_work(struct kvm_vcpu *vc=
pu)
> +{
> +       int r =3D xfer_to_guest_mode_handle_work();
> +
> +       if (r) {
> +               WARN_ON_ONCE(r !=3D -EINTR);
> +               kvm_handle_signal_exit(vcpu);
> +       }
> +       return r;
> +}
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>
>  /*
> diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
> index c2fc39824157..872617468b4a 100644
> --- a/kernel/entry/kvm.c
> +++ b/kernel/entry/kvm.c
> @@ -1,17 +1,14 @@
>  // SPDX-License-Identifier: GPL-2.0
>
>  #include <linux/entry-kvm.h>
> -#include <linux/kvm_host.h>
>
> -static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long =
ti_work)
> +static int xfer_to_guest_mode_work(unsigned long ti_work)
>  {
>         do {
>                 int ret;
>
> -               if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
> -                       kvm_handle_signal_exit(vcpu);
> +               if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
>                         return -EINTR;
> -               }
>
>                 if (ti_work & _TIF_NEED_RESCHED)
>                         schedule();
> @@ -28,7 +25,7 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcp=
u, unsigned long ti_work)
>         return 0;
>  }
>
> -int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu)
> +int xfer_to_guest_mode_handle_work(void)
>  {
>         unsigned long ti_work;
>
> @@ -44,6 +41,6 @@ int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcp=
u)
>         if (!(ti_work & XFER_TO_GUEST_MODE_WORK))
>                 return 0;
>
> -       return xfer_to_guest_mode_work(vcpu, ti_work);
> +       return xfer_to_guest_mode_work(ti_work);
>  }
>  EXPORT_SYMBOL_GPL(xfer_to_guest_mode_handle_work);
> --
> 2.42.0.459.ge4e396fd5e-goog
>

