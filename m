Return-Path: <kvm+bounces-4434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FA68127A1
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 07:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BF5A1F21ABE
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 06:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86070C8CC;
	Thu, 14 Dec 2023 06:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="wlkm2bV4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7DF172C
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 22:05:01 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6d266bfcd10so21649b3a.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 22:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702533901; x=1703138701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvVjokEhJRkgiYQ+o9OaV0HA0xI9C7Xt69a6c2d+FcQ=;
        b=wlkm2bV4t3Xww/AbxwzNROFizoefh2kCfL1aFhPEZCnBwErS+aI/37qTiU2eESjObN
         UnUvaGpOG1gaBiCzAAwJ8wsykjb7agAdbtPuRIy9mdjwWC8GpRNUXuDR2i4KfqxjOK0i
         Bzno6jIim8o6C0ADmoCtL74ySuIEUmQ2z5s5b7uMqV3UXEW0H+72GnFgOFEBmRuY0s39
         KZ1PLeznneFm+EwNpZrp042KGH/RyHSSHHabK8LtjLMPoa1MtYLeHqdHVvlqxAT2y3Nb
         tRKml/9gY9BKT2AMjCrFmsFHAzi8KWHpNiHUNtjKakrLpjcie22db2ZolJTU+KzihLCn
         O/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702533901; x=1703138701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dvVjokEhJRkgiYQ+o9OaV0HA0xI9C7Xt69a6c2d+FcQ=;
        b=tG+dN8vDgX0UIqm0w5iJFoKkSABpLqE5d3g6H6So0B+uMDYfTZGqW0WSU8lDyfRAvA
         BHGrwOewPQqYCbKaZfmtY+HYztZKbX6KnV8Lev9vzUFHEO6DS+M0E0ipRkPxwJXj4L81
         eSdy/uxBDvPMBJ2yHhcf9zKLJBLcce2+s/kPrTdE5NZWR90bpEhxUXbtgQjWgjnsvJra
         bOAm6kvTtQviL2bX6m6LTdgJINrjF1Z1BnR3QcvxamIx5c+uPu/JzlkJX7dsNLf7EYDi
         Bn5K0IAQH8C5WnYDXR3zaIEBx6QCwbapm2hj6BPilcBUKQBBkaZrQk0hxoh4GsZi6d/V
         qqNQ==
X-Gm-Message-State: AOJu0YwUfNe/wardGo/vtahHNb2i6fOtlO/3ZrGqcwp/+ExT7s6fANq6
	lW1wL5fpvw7AURvWVzqsgewY7KDUuVowWqXvoQQRSg==
X-Google-Smtp-Source: AGHT+IHIasKoIhsfkj7Yu+FMUSkaxjPll3cuawBTpXD75vrutVj6NpINC37M3K8JiCCZ1y7ffegWrPb57ZwkbEZ9v2I=
X-Received: by 2002:a17:90a:e395:b0:286:bfed:6f55 with SMTP id
 b21-20020a17090ae39500b00286bfed6f55mr4390822pjz.38.1702533901140; Wed, 13
 Dec 2023 22:05:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com> <20230916003118.2540661-20-seanjc@google.com>
In-Reply-To: <20230916003118.2540661-20-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 11:34:49 +0530
Message-ID: <CAAhSdy1bzQ2mxOew0iw-OuLWxzOhk3LtO+908TYw2gw+5yN3RA@mail.gmail.com>
Subject: Re: [PATCH 19/26] KVM: Standardize include paths across all architectures
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

On Sat, Sep 16, 2023 at 6:01=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Standardize KVM's include paths across all architectures by declaring
> the KVM-specific includes in the common Makefile.kvm.  Having common KVM
> "own" the included paths reduces the temptation to unnecessarily add
> virt/kvm to arch include paths, and conversely if allowing arch code to
> grab headers from virt/kvm becomes desirable, virt/kvm can be added to
> all architecture's include path with a single line update.
>
> Having the common KVM makefile append to ccflags also provides a
> convenient location to append other things, e.g. KVM-specific #defines.
>
> Note, this changes the behavior of s390 and PPC, as s390 and PPC
> previously overwrote ccflags-y instead of adding on.  There is no evidenc=
e
> that overwriting ccflags-y was necessary or even deliberate, as both s390
> and PPC switched to the overwrite behavior without so much as a passing
> mention when EXTRA_CFLAGS was replaced with ccflags-y (commit c73028a0288=
7
> ("s390: change to new flag variable") and commit 4108d9ba9091
> ("powerpc/Makefiles: Change to new flag variables")).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/arm64/kvm/Makefile   | 2 --
>  arch/mips/kvm/Makefile    | 2 --
>  arch/powerpc/kvm/Makefile | 2 --
>  arch/riscv/kvm/Makefile   | 2 --
>  arch/s390/kvm/Makefile    | 2 --
>  arch/x86/kvm/Makefile     | 1 -
>  virt/kvm/Makefile.kvm     | 2 ++
>  7 files changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index c0c050e53157..3996489baeef 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -3,8 +3,6 @@
>  # Makefile for Kernel-based Virtual Machine module
>  #
>
> -ccflags-y +=3D -I $(srctree)/$(src)
> -
>  include $(srctree)/virt/kvm/Makefile.kvm
>
>  obj-$(CONFIG_KVM) +=3D kvm.o
> diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
> index 96a7cd21b140..d198e1addea7 100644
> --- a/arch/mips/kvm/Makefile
> +++ b/arch/mips/kvm/Makefile
> @@ -4,8 +4,6 @@
>
>  include $(srctree)/virt/kvm/Makefile.kvm
>
> -ccflags-y +=3D -Iarch/mips/kvm
> -
>  kvm-$(CONFIG_CPU_HAS_MSA) +=3D msa.o
>
>  kvm-y +=3D    mips.o emulate.o entry.o \
> diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
> index 08a0e53d58c7..d6c6678ddf65 100644
> --- a/arch/powerpc/kvm/Makefile
> +++ b/arch/powerpc/kvm/Makefile
> @@ -3,8 +3,6 @@
>  # Makefile for Kernel-based Virtual Machine module
>  #
>
> -ccflags-y :=3D -Iarch/powerpc/kvm
> -
>  include $(srctree)/virt/kvm/Makefile.kvm
>
>  common-objs-y +=3D powerpc.o emulate_loadstore.o
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 4c2067fc59fc..ff7d5f67e229 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -3,8 +3,6 @@
>  # Makefile for RISC-V KVM support
>  #
>
> -ccflags-y +=3D -I $(srctree)/$(src)
> -
>  include $(srctree)/virt/kvm/Makefile.kvm
>
>  obj-$(CONFIG_KVM) +=3D kvm.o
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index f17249ab2a72..f8153189e003 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -5,8 +5,6 @@
>
>  include $(srctree)/virt/kvm/Makefile.kvm
>
> -ccflags-y :=3D -Iarch/s390/kvm
> -
>  kvm-y +=3D kvm-s390.o intercept.o interrupt.o priv.o sigp.o
>  kvm-y +=3D diag.o gaccess.o guestdbg.o vsie.o pv.o
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 80e3fe184d17..d13f1a7b7b3d 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -1,6 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>
> -ccflags-y +=3D -I $(srctree)/arch/x86/kvm
>  ccflags-$(CONFIG_KVM_WERROR) +=3D -Werror
>
>  ifeq ($(CONFIG_FRAME_POINTER),y)
> diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
> index 29373b59d89a..e85079ad245d 100644
> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -3,6 +3,8 @@
>  # Makefile for Kernel-based Virtual Machine module
>  #
>
> +ccflags-y +=3D -I$(srctree)/$(src)
> +
>  KVM ?=3D ../../../virt/kvm
>
>  kvm-y :=3D $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> --
> 2.42.0.459.ge4e396fd5e-goog
>

