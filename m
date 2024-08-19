Return-Path: <kvm+bounces-24517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 080B4956C36
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 633B8B27EE2
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 13:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5970F16C846;
	Mon, 19 Aug 2024 13:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8XArx5R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5A01DFE1;
	Mon, 19 Aug 2024 13:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724074455; cv=none; b=svrzXbZ+hiS0YFh1dqoxlZiGq6GXamoQZRUvZP8xDxK+sc5WREl5ab+FCv4xVLgrQwkvP+ibJQJs4YJTHIFhWrOkdNcWGs1bhc2fiRd7iQ5J5AVqAFxuUYZqZEgb9jGCL/GIQxD5RSyaSUu+dVK25DZw+5viyED7fNqQrV07oM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724074455; c=relaxed/simple;
	bh=PP8JSQ7AdLSLB8K/tbJoNx75U6KmfVwkvobUFPdglvI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DP8vEOQaJKcY6am4DtxQAIQG6nDnygQyrgYjRUbU0VH4r1YV2Jh029Y/2iRufn1lUa6gi0ufuOfT5Hixc+oQ6LV9QGl22Ax3hckcHy21K2FAG4nWFGRowf0DvSClM7VTfiNA+8Px89jJhduAryUrQi/dJOsSR/1XzgHJ3Kresy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8XArx5R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4395EC4AF12;
	Mon, 19 Aug 2024 13:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724074455;
	bh=PP8JSQ7AdLSLB8K/tbJoNx75U6KmfVwkvobUFPdglvI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=X8XArx5RIhMFBeRGDWSGcBgGGnCjcdxFzCCmX2LOiwbAHhzecgmMPO1O1AqaV3ekR
	 8yOf3DBEaiqUDY8SpobkMno6cB0uVid5zBARlsE5ORIni+4oeSIdJmjn9YDcGL/KBS
	 eG8ArP07B9s35PaEJXk30HRvKp6jQ8IhcMO03n0jkc9mDSN1Evi5KaK9D7LJwuZcIx
	 5oJFpgnrDytrJEZ2ka/M4k43EXjv9x6da4IIxrZVmmwEriwkikt93U4TeeVYD1jMBs
	 cCVZA8UQp4sAJsHCaA7/b2I6gnDnF4FNG4+6VSQ8e+tod8pBuzqoLbUhlEy2f08aZE
	 0j8tFTrxuqhAg==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5beb6ea9ed6so4202481a12.1;
        Mon, 19 Aug 2024 06:34:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU+/ztCjce1NRSlxRfOT0km3gu02L53/2eGY/T91tOYyPy4uqschC3rr5/AXqXSj0xDf8ohuPVuNgT78CtWDXG2lX/PIHNUz+GtGaX7sQ9uBC356r/XGCJ87tNt3d9YUMR3
X-Gm-Message-State: AOJu0Yy1qGmzNjpnwQi2Xg0a1N/ugudnk1GzEfnuFrh6jSDudng0cdZy
	noVy4catqVVthxyt/zPPluWwVQCioC4xNMMSbKPqLQNb2qdtkh8f9CJ8Mg5T4XgWaPWeY3idQrk
	aupz7097P6pkkG2J6p1OERHyoQXE=
X-Google-Smtp-Source: AGHT+IHsAfw01qb8feFNlq0C6FmFghaAsk6AXhN/B3NvYRjw2BrK/evtfJ/RaKMp+t7Kw6vm1hkbCMdsBHTnEoOS33s=
X-Received: by 2002:a05:6402:34cb:b0:5be:fadc:e13c with SMTP id
 4fb4d7f45d1cf-5befadce247mr2556543a12.4.1724074453673; Mon, 19 Aug 2024
 06:34:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240812030210.500240-1-maobibo@loongson.cn> <20240812030210.500240-4-maobibo@loongson.cn>
In-Reply-To: <20240812030210.500240-4-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 19 Aug 2024 21:34:11 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6DFNY=JnkAGj7vAR1UoXUtJZkbb-pwVSFodCwbyOmpGA@mail.gmail.com>
Message-ID: <CAAhV-H6DFNY=JnkAGj7vAR1UoXUtJZkbb-pwVSFodCwbyOmpGA@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] irqchip/loongson-eiointc: Add extioi virt
 extension support
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Thomas Gleixner <tglx@linutronix.de>, 
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, x86@kernel.org, 
	Song Gao <gaosong@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Mon, Aug 12, 2024 at 11:02=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> Interrupts can be routed to maximal four virtual CPUs with one HW
> EIOINTC interrupt controller model, since interrupt routing is encoded wi=
th
> CPU bitmap and EIOINTC node combined method. Here add the EIOINTC virt
> extension support so that interrupts can be routed to 256 vCPUs on
> hypervisor mode. CPU bitmap is replaced with normal encoding and EIOINTC
> node type is removed, so there are 8 bits for cpu selection, at most 256
> vCPUs are supported for interrupt routing.
>
> Co-developed-by: Song Gao <gaosong@loongson.cn>
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  .../arch/loongarch/irq-chip-model.rst         |  64 ++++++++++
>  .../zh_CN/arch/loongarch/irq-chip-model.rst   |  55 +++++++++
>  arch/loongarch/include/asm/irq.h              |   1 +
>  drivers/irqchip/irq-loongson-eiointc.c        | 109 ++++++++++++++----
>  4 files changed, 209 insertions(+), 20 deletions(-)
>
> diff --git a/Documentation/arch/loongarch/irq-chip-model.rst b/Documentat=
ion/arch/loongarch/irq-chip-model.rst
> index 7988f4192363..d2350780ad1d 100644
> --- a/Documentation/arch/loongarch/irq-chip-model.rst
> +++ b/Documentation/arch/loongarch/irq-chip-model.rst
> @@ -85,6 +85,70 @@ to CPUINTC directly::
>      | Devices |
>      +---------+
>
> +Virtual extended IRQ model
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +
> +In this model, IPI (Inter-Processor Interrupt) and CPU Local Timer inter=
rupt
> +go to CPUINTC directly, CPU UARTS interrupts go to PCH-PIC, while all ot=
her
> +devices interrupts go to PCH-PIC/PCH-MSI and gathered by V-EIOINTC (Virt=
ual
> +Extended I/O Interrupt Controller), and then go to CPUINTC directly::
> +
> +       +-----+    +-------------------+     +-------+
> +       | IPI |--> | CPUINTC(0-255vcpu)| <-- | Timer |
> +       +-----+    +-------------------+     +-------+
> +                            ^
> +                            |
> +                      +-----------+
> +                      | V-EIOINTC |
> +                      +-----------+
> +                       ^         ^
> +                       |         |
> +                +---------+ +---------+
> +                | PCH-PIC | | PCH-MSI |
> +                +---------+ +---------+
> +                  ^      ^          ^
> +                  |      |          |
> +           +--------+ +---------+ +---------+
> +           | UARTs  | | Devices | | Devices |
> +           +--------+ +---------+ +---------+
> +
> +
> +Description
> +-----------
> +V-EIOINTC (Virtual Extended I/O Interrupt Controller) is an extension of
> +EIOINTC, it only works in VM mode which runs in KVM hypervisor. Interrup=
ts can
> +be routed to up to four vCPUs via standard EIOINTC, however with V-EIOIN=
TC
> +interrupts can be routed to up to 256 virtual cpus.
> +
> +With standard EIOINTC, interrupt routing setting includes two parts: eig=
ht
> +bits for CPU selection and four bits for CPU IP (Interrupt Pin) selectio=
n.
> +For CPU selection there is four bits for EIOINTC node selection, four bi=
ts
> +for EIOINTC CPU selection. Bitmap method is used for CPU selection and
> +CPU IP selection, so interrupt can only route to CPU0 - CPU3 and IP0-IP3=
 in
> +one EIOINTC node.
> +
> +With V-EIOINTC it supports to route more CPUs and CPU IP (Interrupt Pin)=
,
> +there are two newly added registers with V-EIOINTC.
> +
> +EXTIOI_VIRT_FEATURES
> +--------------------
> +This register is read-only register, which indicates supported features =
with
> +V-EIOINTC. Feature EXTIOI_HAS_INT_ENCODE and EXTIOI_HAS_CPU_ENCODE is ad=
ded.
> +
> +Feature EXTIOI_HAS_INT_ENCODE is part of standard EIOINTC. If it is 1, i=
t
> +indicates that CPU Interrupt Pin selection can be normal method rather t=
han
> +bitmap method, so interrupt can be routed to IP0 - IP15.
> +
> +Feature EXTIOI_HAS_CPU_ENCODE is entension of V-EIOINTC. If it is 1, it
> +indicates that CPU selection can be normal method rather than bitmap met=
hod,
> +so interrupt can be routed to CPU0 - CPU255.
> +
> +EXTIOI_VIRT_CONFIG
> +------------------
> +This register is read-write register, for compatibility intterupt routed=
 uses
> +the default method which is the same with standard EIOINTC. If the bit i=
s set
> +with 1, it indicated HW to use normal method rather than bitmap method.
> +
>  ACPI-related definitions
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/Documentation/translations/zh_CN/arch/loongarch/irq-chip-mod=
el.rst b/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst
> index f1e9ab18206c..d696bd394c02 100644
> --- a/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst
> +++ b/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst
> @@ -87,6 +87,61 @@ PCH-LPC/PCH-MSI=EF=BC=8C=E7=84=B6=E5=90=8E=E8=A2=ABEIO=
INTC=E7=BB=9F=E4=B8=80=E6=94=B6=E9=9B=86=EF=BC=8C=E5=86=8D=E7=9B=B4=E6=8E=
=A5=E5=88=B0=E8=BE=BECPUINTC::
>      | Devices |
>      +---------+
>
> +=E8=99=9A=E6=8B=9F=E6=89=A9=E5=B1=95IRQ=E6=A8=A1=E5=9E=8B
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +=E5=9C=A8=E8=BF=99=E7=A7=8D=E6=A8=A1=E5=9E=8B=E9=87=8C=E9=9D=A2, IPI(Int=
er-Processor Interrupt) =E5=92=8CCPU=E6=9C=AC=E5=9C=B0=E6=97=B6=E9=92=9F=E4=
=B8=AD=E6=96=AD=E7=9B=B4=E6=8E=A5=E5=8F=91=E9=80=81=E5=88=B0CPUINTC,
> +CPU=E4=B8=B2=E5=8F=A3 (UARTs) =E4=B8=AD=E6=96=AD=E5=8F=91=E9=80=81=E5=88=
=B0PCH-PIC, =E8=80=8C=E5=85=B6=E4=BB=96=E6=89=80=E6=9C=89=E8=AE=BE=E5=A4=87=
=E7=9A=84=E4=B8=AD=E6=96=AD=E5=88=99=E5=88=86=E5=88=AB=E5=8F=91=E9=80=81=E5=
=88=B0=E6=89=80=E8=BF=9E=E6=8E=A5=E7=9A=84PCH_PIC/
> +PCH-MSI, =E7=84=B6=E5=90=8EV-EIOINTC=E7=BB=9F=E4=B8=80=E6=94=B6=E9=9B=86=
=EF=BC=8C=E5=86=8D=E7=9B=B4=E6=8E=A5=E5=88=B0=E8=BE=BECPUINTC::
> +
> +        +-----+    +-------------------+     +-------+
> +        | IPI |--> | CPUINTC(0-255vcpu)| <-- | Timer |
> +        +-----+    +-------------------+     +-------+
> +                             ^
> +                             |
> +                       +-----------+
> +                       | V-EIOINTC |
> +                       +-----------+
> +                        ^         ^
> +                        |         |
> +                 +---------+ +---------+
> +                 | PCH-PIC | | PCH-MSI |
> +                 +---------+ +---------+
> +                   ^      ^          ^
> +                   |      |          |
> +            +--------+ +---------+ +---------+
> +            | UARTs  | | Devices | | Devices |
> +            +--------+ +---------+ +---------+
> +
> +V-EIOINTC =E6=98=AFEIOINTC=E7=9A=84=E6=89=A9=E5=B1=95, =E4=BB=85=E5=B7=
=A5=E4=BD=9C=E5=9C=A8hyperisor=E6=A8=A1=E5=BC=8F=E4=B8=8B, =E4=B8=AD=E6=96=
=AD=E7=BB=8FEIOINTC=E6=9C=80=E5=A4=9A=E5=8F=AF=E4=B8=AA=E8=B7=AF=E7=94=B1=
=E5=88=B0=EF=BC=94=E4=B8=AA
> +=E8=99=9A=E6=8B=9Fcpu. =E4=BD=86=E4=B8=AD=E6=96=AD=E7=BB=8FV-EIOINTC=E6=
=9C=80=E5=A4=9A=E5=8F=AF=E4=B8=AA=E8=B7=AF=E7=94=B1=E5=88=B0256=E4=B8=AA=E8=
=99=9A=E6=8B=9Fcpu.
> +
> +=E4=BC=A0=E7=BB=9F=E7=9A=84EIOINTC=E4=B8=AD=E6=96=AD=E6=8E=A7=E5=88=B6=
=E5=99=A8=EF=BC=8C=E4=B8=AD=E6=96=AD=E8=B7=AF=E7=94=B1=E5=88=86=E4=B8=BA=E4=
=B8=A4=E4=B8=AA=E9=83=A8=E5=88=86=EF=BC=9A8=E6=AF=94=E7=89=B9=E7=94=A8=E4=
=BA=8E=E6=8E=A7=E5=88=B6=E8=B7=AF=E7=94=B1=E5=88=B0=E5=93=AA=E4=B8=AACPU=EF=
=BC=8C
> +4=E6=AF=94=E7=89=B9=E7=94=A8=E4=BA=8E=E6=8E=A7=E5=88=B6=E8=B7=AF=E7=94=
=B1=E5=88=B0=E7=89=B9=E5=AE=9ACPU=E7=9A=84=E5=93=AA=E4=B8=AA=E4=B8=AD=E6=96=
=AD=E7=AE=A1=E8=84=9A.=E6=8E=A7=E5=88=B6CPU=E8=B7=AF=E7=94=B1=E7=9A=848=E6=
=AF=94=E7=89=B9=E5=89=8D4=E6=AF=94=E7=89=B9=E7=94=A8=E4=BA=8E=E6=8E=A7=E5=
=88=B6
> +=E8=B7=AF=E7=94=B1=E5=88=B0=E5=93=AA=E4=B8=AAEIOINTC=E8=8A=82=E7=82=B9=
=EF=BC=8C=E5=90=8E4=E6=AF=94=E7=89=B9=E7=94=A8=E4=BA=8E=E6=8E=A7=E5=88=B6=
=E6=AD=A4=E8=8A=82=E7=82=B9=E5=93=AA=E4=B8=AACPU=E3=80=82=E4=B8=AD=E6=96=AD=
=E8=B7=AF=E7=94=B1=E5=9C=A8=E9=80=89=E6=8B=A9CPU=E8=B7=AF=E7=94=B1
> +=E5=92=8CCPU=E4=B8=AD=E6=96=AD=E7=AE=A1=E8=84=9A=E8=B7=AF=E7=94=B1=E6=97=
=B6=EF=BC=8C=E4=BD=BF=E7=94=A8bitmap=E7=BC=96=E7=A0=81=E6=96=B9=E5=BC=8F=E8=
=80=8C=E4=B8=8D=E6=98=AF=E6=AD=A3=E5=B8=B8=E7=BC=96=E7=A0=81=E6=96=B9=E5=BC=
=8F=EF=BC=8C=E6=89=80=E4=BB=A5=E5=AF=B9=E4=BA=8E=E4=B8=80=E4=B8=AA
> +EIOINTC=E4=B8=AD=E6=96=AD=E6=8E=A7=E5=88=B6=E5=99=A8=E8=8A=82=E7=82=B9=
=EF=BC=8C=E4=B8=AD=E6=96=AD=E5=8F=AA=E8=83=BD=E8=B7=AF=E7=94=B1=E5=88=B0CPU=
0 - CPU3=EF=BC=8C=E4=B8=AD=E6=96=AD=E7=AE=A1=E6=95=99IP0-IP3=E3=80=82
> +
> +V-EIOINTC=E6=96=B0=E5=A2=9E=E4=BA=86=E4=B8=A4=E4=B8=AA=E5=AF=84=E5=AD=98=
=E5=99=A8=EF=BC=8C=E6=94=AF=E6=8C=81=E4=B8=AD=E6=96=AD=E8=B7=AF=E7=94=B1=E5=
=88=B0=E6=9B=B4=E5=A4=9ACPU=E4=B8=AA=E5=92=8C=E4=B8=AD=E6=96=AD=E7=AE=A1=E8=
=84=9A=E3=80=82
> +
> +V-EIOINTC=E5=8A=9F=E8=83=BD=E5=AF=84=E5=AD=98=E5=99=A8
> +-------------------
> +=E5=8A=9F=E8=83=BD=E5=AF=84=E5=AD=98=E5=99=A8=E6=98=AF=E5=8F=AA=E8=AF=BB=
=E5=AF=84=E5=AD=98=E5=99=A8=EF=BC=8C=E7=94=A8=E4=BA=8E=E6=98=BE=E7=A4=BAV-E=
IOINTC=E6=94=AF=E6=8C=81=E7=9A=84=E7=89=B9=E6=80=A7=EF=BC=8C=E7=9B=AE=E5=89=
=8D=E4=B8=A4=E4=B8=AA=E6=94=AF=E6=8C=81=E4=B8=A4=E4=B8=AA=E7=89=B9=E6=80=A7
> +EXTIOI_HAS_INT_ENCODE =E5=92=8C EXTIOI_HAS_CPU_ENCODE=E3=80=82
> +
> +=E7=89=B9=E6=80=A7EXTIOI_HAS_INT_ENCODE=E6=98=AF=E4=BC=A0=E7=BB=9FEIOINT=
C=E4=B8=AD=E6=96=AD=E6=8E=A7=E5=88=B6=E5=99=A8=E7=9A=84=E4=B8=80=E4=B8=AA=
=E7=89=B9=E6=80=A7=EF=BC=8C=E5=A6=82=E6=9E=9C=E6=AD=A4=E6=AF=94=E7=89=B9=E4=
=B8=BA1=EF=BC=8C
> +=E6=98=BE=E7=A4=BACPU=E4=B8=AD=E6=96=AD=E7=AE=A1=E8=84=9A=E8=B7=AF=E7=94=
=B1=E6=96=B9=E5=BC=8F=E6=94=AF=E6=8C=81=E6=AD=A3=E5=B8=B8=E7=BC=96=E7=A0=81=
=EF=BC=8C=E8=80=8C=E4=B8=8D=E6=98=AFbitmap=E7=BC=96=E7=A0=81=EF=BC=8C=E6=89=
=80=E4=BB=A5=E4=B8=AD=E6=96=AD=E5=8F=AF=E4=BB=A5=E8=B7=AF=E7=94=B1=E5=88=B0
> +=E7=AE=A1=E8=84=9AIP0 - IP15=E3=80=82
> +
> +=E7=89=B9=E6=80=A7EXTIOI_HAS_CPU_ENCODE=E6=98=AFV-EIOINTC=E6=96=B0=E5=A2=
=9E=E7=89=B9=E6=80=A7=EF=BC=8C=E5=A6=82=E6=9E=9C=E6=AD=A4=E6=AF=94=E7=89=B9=
=E4=B8=BA1=EF=BC=8C=E8=A1=A8=E7=A4=BACPU=E8=B7=AF=E7=94=B1
> +=E6=96=B9=E5=BC=8F=E6=94=AF=E6=8C=81=E6=AD=A3=E5=B8=B8=E7=BC=96=E7=A0=81=
=EF=BC=8C=E8=80=8C=E4=B8=8D=E6=98=AFbitmap=E7=BC=96=E7=A0=81=EF=BC=8C=E6=89=
=80=E4=BB=A5=E4=B8=AD=E6=96=AD=E5=8F=AF=E4=BB=A5=E8=B7=AF=E7=94=B1=E5=88=B0=
CPU0 - CPU255=E3=80=82
> +
> +V-EIOINTC=E9=85=8D=E7=BD=AE=E5=AF=84=E5=AD=98=E5=99=A8
> +-------------------
> +=E9=85=8D=E7=BD=AE=E5=AF=84=E5=AD=98=E5=99=A8=E6=98=AF=E5=8F=AF=E8=AF=BB=
=E5=86=99=E5=AF=84=E5=AD=98=E5=99=A8=EF=BC=8C=E4=B8=BA=E4=BA=86=E5=85=BC=E5=
=AE=B9=E6=80=A7=E8=80=83=E8=99=91=EF=BC=8C=E5=A6=82=E6=9E=9C=E4=B8=8D=E5=86=
=99=E6=AD=A4=E5=AF=84=E5=AD=98=E5=99=A8=EF=BC=8C=E4=B8=AD=E6=96=AD=E8=B7=AF=
=E7=94=B1=E9=87=87=E7=94=A8
> +=E5=92=8C=E4=BC=A0=E7=BB=9FEIOINTC=E7=9B=B8=E5=90=8C=E7=9A=84=E8=B7=AF=
=E7=94=B1=E8=AE=BE=E7=BD=AE=E3=80=82=E5=A6=82=E6=9E=9C=E5=AF=B9=E5=BA=94=E6=
=AF=94=E7=89=B9=E8=AE=BE=E7=BD=AE=E4=B8=BA1=EF=BC=8C=E8=A1=A8=E7=A4=BA=E9=
=87=87=E7=94=A8=E6=AD=A3=E5=B8=B8=E8=B7=AF=E7=94=B1=E6=96=B9=E5=BC=8F=E8=80=
=8C
> +=E4=B8=8D=E6=98=AFbitmap=E7=BC=96=E7=A0=81=E7=9A=84=E8=B7=AF=E7=94=B1=E6=
=96=B9=E5=BC=8F=E3=80=82
> +
>  ACPI=E7=9B=B8=E5=85=B3=E7=9A=84=E5=AE=9A=E4=B9=89
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/as=
m/irq.h
> index 480418bc5071..ce85d4c7d225 100644
> --- a/arch/loongarch/include/asm/irq.h
> +++ b/arch/loongarch/include/asm/irq.h
> @@ -54,6 +54,7 @@ extern struct acpi_vector_group pch_group[MAX_IO_PICS];
>  extern struct acpi_vector_group msi_group[MAX_IO_PICS];
>
>  #define CORES_PER_EIO_NODE     4
> +#define CORES_PER_VEIO_NODE    256
>
>  #define LOONGSON_CPU_UART0_VEC         10 /* CPU UART0 */
>  #define LOONGSON_CPU_THSENS_VEC                14 /* CPU Thsens */
> diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq=
-loongson-eiointc.c
> index b1f2080be2be..cc5b1ec13531 100644
> --- a/drivers/irqchip/irq-loongson-eiointc.c
> +++ b/drivers/irqchip/irq-loongson-eiointc.c
> @@ -14,6 +14,7 @@
>  #include <linux/irqdomain.h>
>  #include <linux/irqchip/chained_irq.h>
>  #include <linux/kernel.h>
> +#include <linux/kvm_para.h>
>  #include <linux/syscore_ops.h>
>  #include <asm/numa.h>
>
> @@ -24,15 +25,36 @@
>  #define EIOINTC_REG_ISR                0x1800
>  #define EIOINTC_REG_ROUTE      0x1c00
>
> +#define EXTIOI_VIRT_FEATURES           0x40000000
> +#define  EXTIOI_HAS_VIRT_EXTENSION     BIT(0)
> +#define  EXTIOI_HAS_ENABLE_OPTION      BIT(1)
> +#define  EXTIOI_HAS_INT_ENCODE         BIT(2)
> +#define  EXTIOI_HAS_CPU_ENCODE         BIT(3)
> +#define EXTIOI_VIRT_CONFIG             0x40000004
> +#define  EXTIOI_ENABLE                 BIT(1)
> +#define  EXTIOI_ENABLE_INT_ENCODE      BIT(2)
> +#define  EXTIOI_ENABLE_CPU_ENCODE      BIT(3)
After careful reading, I found the only used bits are
EXTIOI_HAS_CPU_ENCODE/EXTIOI_ENABLE_CPU_ENCODE. So to minimize the
complexity, I suggest to define virtual register as below:
#define EXTIOI_VIRT_FEATURES           0x40000000
#define  EXTIOI_HAS_VIRT_EXTENSION                   BIT(0)
#define  EXTIOI_ENABLE_CPU_ENCODE                 BIT(15)
Then only one register, the low 16 bits are indicators while the high
16 bits are enable controls. Even if we will extend more (hardly
happen, I think), there is enough spaces.

> +
>  #define VEC_REG_COUNT          4
>  #define VEC_COUNT_PER_REG      64
>  #define VEC_COUNT              (VEC_REG_COUNT * VEC_COUNT_PER_REG)
>  #define VEC_REG_IDX(irq_id)    ((irq_id) / VEC_COUNT_PER_REG)
>  #define VEC_REG_BIT(irq_id)     ((irq_id) % VEC_COUNT_PER_REG)
>  #define EIOINTC_ALL_ENABLE     0xffffffff
> +#define EIOINTC_ALL_ENABLE_VEC_MASK(vector)    (EIOINTC_ALL_ENABLE & ~BI=
T(vector & 0x1F))
> +#define EIOINTC_REG_ENABLE_VEC(vector)         (EIOINTC_REG_ENABLE + ((v=
ector >> 5) << 2))
>
>  #define MAX_EIO_NODES          (NR_CPUS / CORES_PER_EIO_NODE)
>
> +/*
> + * Routing registers are 32bit, and there is 8-bit route setting for eve=
ry
> + * interrupt vector. So one Route register contains four vectors routing
> + * information.
> + */
> +#define EIOINTC_REG_ROUTE_VEC(vector)          (EIOINTC_REG_ROUTE + (vec=
tor & ~0x03))
> +#define EIOINTC_REG_ROUTE_VEC_SHIFT(vector)    ((vector & 0x03) << 3)
> +#define EIOINTC_REG_ROUTE_VEC_MASK(vector)     (0xff << EIOINTC_REG_ROUT=
E_VEC_SHIFT(vector))
> +
>  static int nr_pics;
>
>  struct eiointc_priv {
> @@ -42,6 +64,7 @@ struct eiointc_priv {
>         cpumask_t               cpuspan_map;
>         struct fwnode_handle    *domain_handle;
>         struct irq_domain       *eiointc_domain;
> +       bool                    cpu_encoded;
>  };
>
>  static struct eiointc_priv *eiointc_priv[MAX_IO_PICS];
> @@ -57,7 +80,13 @@ static void eiointc_enable(void)
>
>  static int cpu_to_eio_node(int cpu)
>  {
> -       return cpu_logical_map(cpu) / CORES_PER_EIO_NODE;
> +       int cores;
> +
> +       if (kvm_para_has_feature(KVM_FEATURE_VIRT_EXTIOI))
> +               cores =3D CORES_PER_VEIO_NODE;
> +       else
> +               cores =3D CORES_PER_EIO_NODE;
> +       return cpu_logical_map(cpu) / cores;
>  }
>
>  #ifdef CONFIG_SMP
> @@ -89,6 +118,16 @@ static void eiointc_set_irq_route(int pos, unsigned i=
nt cpu, unsigned int mnode,
>
>  static DEFINE_RAW_SPINLOCK(affinity_lock);
>
> +static void virt_extioi_set_irq_route(unsigned int vector, unsigned int =
cpu)
> +{
> +       unsigned long reg =3D EIOINTC_REG_ROUTE_VEC(vector);
> +       u32 data =3D iocsr_read32(reg);
> +
> +       data &=3D ~EIOINTC_REG_ROUTE_VEC_MASK(vector);
> +       data |=3D cpu_logical_map(cpu) << EIOINTC_REG_ROUTE_VEC_SHIFT(vec=
tor);
> +       iocsr_write32(data, reg);
> +}
This function can be embedded into eiointc_set_irq_affinity().

> +
>  static int eiointc_set_irq_affinity(struct irq_data *d, const struct cpu=
mask *affinity, bool force)
>  {
>         unsigned int cpu;
> @@ -105,18 +144,24 @@ static int eiointc_set_irq_affinity(struct irq_data=
 *d, const struct cpumask *af
>         }
>
>         vector =3D d->hwirq;
> -       regaddr =3D EIOINTC_REG_ENABLE + ((vector >> 5) << 2);
> -
> -       /* Mask target vector */
> -       csr_any_send(regaddr, EIOINTC_ALL_ENABLE & (~BIT(vector & 0x1F)),
> -                       0x0, priv->node * CORES_PER_EIO_NODE);
> -
> -       /* Set route for target vector */
> -       eiointc_set_irq_route(vector, cpu, priv->node, &priv->node_map);
> -
> -       /* Unmask target vector */
> -       csr_any_send(regaddr, EIOINTC_ALL_ENABLE,
> -                       0x0, priv->node * CORES_PER_EIO_NODE);
> +       regaddr =3D EIOINTC_REG_ENABLE_VEC(vector);
> +
> +       if (priv->cpu_encoded) {
> +               iocsr_write32(EIOINTC_ALL_ENABLE_VEC_MASK(vector), regadd=
r);
> +               virt_extioi_set_irq_route(vector, cpu);
> +               iocsr_write32(EIOINTC_ALL_ENABLE, regaddr);
> +       } else {
> +               /* Mask target vector */
> +               csr_any_send(regaddr, EIOINTC_ALL_ENABLE_VEC_MASK(vector)=
,
> +                            0x0, priv->node * CORES_PER_EIO_NODE);
> +
> +               /* Set route for target vector */
> +               eiointc_set_irq_route(vector, cpu, priv->node, &priv->nod=
e_map);
> +
> +               /* Unmask target vector */
> +               csr_any_send(regaddr, EIOINTC_ALL_ENABLE,
> +                            0x0, priv->node * CORES_PER_EIO_NODE);
> +       }
>
>         irq_data_update_effective_affinity(d, cpumask_of(cpu));
>
> @@ -140,17 +185,23 @@ static int eiointc_index(int node)
>
>  static int eiointc_router_init(unsigned int cpu)
>  {
> -       int i, bit;
> -       uint32_t data;
> -       uint32_t node =3D cpu_to_eio_node(cpu);
> -       int index =3D eiointc_index(node);
> +       int i, bit, cores, index, node;
> +       unsigned int data;
> +
> +       node =3D cpu_to_eio_node(cpu);
> +       index =3D eiointc_index(node);
>
>         if (index < 0) {
>                 pr_err("Error: invalid nodemap!\n");
> -               return -1;
> +               return -EINVAL;
>         }
>
> -       if ((cpu_logical_map(cpu) % CORES_PER_EIO_NODE) =3D=3D 0) {
> +       if (eiointc_priv[index]->cpu_encoded)
> +               cores =3D CORES_PER_VEIO_NODE;
> +       else
> +               cores =3D CORES_PER_EIO_NODE;
> +
> +       if ((cpu_logical_map(cpu) % cores) =3D=3D 0) {
>                 eiointc_enable();
>
>                 for (i =3D 0; i < eiointc_priv[0]->vec_count / 32; i++) {
> @@ -166,7 +217,9 @@ static int eiointc_router_init(unsigned int cpu)
>
>                 for (i =3D 0; i < eiointc_priv[0]->vec_count / 4; i++) {
>                         /* Route to Node-0 Core-0 */
> -                       if (index =3D=3D 0)
> +                       if (eiointc_priv[index]->cpu_encoded)
> +                               bit =3D cpu_logical_map(0);
> +                       else if (index =3D=3D 0)
>                                 bit =3D BIT(cpu_logical_map(0));
>                         else
>                                 bit =3D (eiointc_priv[index]->node << 4) =
| 1;
> @@ -367,6 +420,19 @@ static int __init acpi_cascade_irqdomain_init(void)
>         return 0;
>  }
>
> +static void __init kvm_eiointc_init(struct eiointc_priv *priv)
> +{
> +       int val;
> +
> +       val =3D iocsr_read32(EXTIOI_VIRT_FEATURES);
> +       if (val & EXTIOI_HAS_CPU_ENCODE) {
> +               val =3D iocsr_read32(EXTIOI_VIRT_CONFIG);
> +               val |=3D EXTIOI_ENABLE_CPU_ENCODE;
> +               iocsr_write32(val, EXTIOI_VIRT_CONFIG);
> +               priv->cpu_encoded =3D true;
> +       }
> +}
This function can be embedded into eiointc_init().

Huacai

> +
>  static int __init eiointc_init(struct eiointc_priv *priv, int parent_irq=
,
>                                u64 node_map)
>  {
> @@ -390,6 +456,9 @@ static int __init eiointc_init(struct eiointc_priv *p=
riv, int parent_irq,
>                 return -ENOMEM;
>         }
>
> +       if (kvm_para_has_feature(KVM_FEATURE_VIRT_EXTIOI))
> +               kvm_eiointc_init(priv);
> +
>         eiointc_priv[nr_pics++] =3D priv;
>         eiointc_router_init(0);
>         irq_set_chained_handler_and_data(parent_irq, eiointc_irq_dispatch=
, priv);
> --
> 2.39.3
>

