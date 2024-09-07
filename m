Return-Path: <kvm+bounces-26062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 510C49700AF
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 09:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4ED28562C
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 07:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3EA149C5B;
	Sat,  7 Sep 2024 07:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJJ+oFs+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BB614885B;
	Sat,  7 Sep 2024 07:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725695780; cv=none; b=oKdyoi5slnWSY9Qc4w5a46m8HggmftWdh1iOZ6MHR8Q2Q47BRTKzc7Y8PobjNlarMkpyE5HftvoSB0XQ+/+jugun3VUa90SYVIsHJJ5rfuT4GCtDvBiuv3PTV4CPI3ZmtIQ+c8biKSy/nprEndNHRcl+Z4vlhP9CcwHR6DCy9Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725695780; c=relaxed/simple;
	bh=rMVIG8fA6B1s7+r843qnmUPH6dIbkzZfUao/2Yt9+YY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IUX5QBNH4aLtz+LkyZugILt7feBuoYMurmqzWkY/evyjq2vZzRX0c6hgTleK8DhsytfupEtLubWXvyBx9R4AipVDa4zHXtnnHeamivUZxoUsjx/CWTMkKKvQouSCwtYW2ZcE93KZtSrJnVvZxVioNlh9MAeAaLQMVZFi5pzRXHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJJ+oFs+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFB4C4CEC8;
	Sat,  7 Sep 2024 07:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725695779;
	bh=rMVIG8fA6B1s7+r843qnmUPH6dIbkzZfUao/2Yt9+YY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TJJ+oFs+uFbWQey6H9FSdONVeJ4+Nk7PZGC9p+R2xuE2DkeG0lI/c8ZrquDzjvXND
	 TT1sTnWMNe876xx2L+mb1mq6hB0xlOrQAzYERAXRcndj9NWl49oYLNsLnnbw5s+LD7
	 WoJv+ptxNU2n+ygq27JpMw2x+RXZyO1NQ9sFJjzQ+XuneExjx5QXw60ieVd83vN2JO
	 zkWNggYANOwWUbCvH0xvrQSSSyIx0wdGRR3/Lt3fhk3u/HdP9Ninfy4wXH08MZFeJJ
	 cikHm59nL/Tbd7kBSD8DM+YwfBEOOkhBvzFDBgilbUqX0uT7/irgdE6pB41QyYO44Q
	 KXEdXNlwTHxpA==
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42ca573fd5aso10385045e9.3;
        Sat, 07 Sep 2024 00:56:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXL+27G7So9dUTb6ev/XgbWUHHqWS9ZfuHvMcuMrrhwptnJYqFEnU6bE6Qs/NRvUTDzo7o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDnPyNxZQ5PZpDy1v4i1jcMzRktrk2H1nHA3NzYWAUd3WTO9SO
	oJuD5t7//e6h2tAI5ptnhqiq9v7tFSxL2HxSTI0kJJn83TniGfhUMlhKom4G4WC1maUWqQpJ7pI
	NYON7hHYoI8QVCWiw9r7MBYF0p2s=
X-Google-Smtp-Source: AGHT+IFynoxTnXMTC8+Fo8fU+IIAu5+BJVgogUzWFqVgiJkrBh84P8uiKBPNKKNr7iDLnJaT3bdYOiP9AiNGJX1tMqU=
X-Received: by 2002:a5d:540b:0:b0:374:b6f3:728d with SMTP id
 ffacd0b85a97d-378896740ecmr3049996f8f.46.1725695778169; Sat, 07 Sep 2024
 00:56:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240823093404.204450-1-lixianglai@loongson.cn>
In-Reply-To: <20240823093404.204450-1-lixianglai@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 7 Sep 2024 15:56:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7eGNof=qjq=U1KaQaC4p48DDroiRxhiTEWs9Eg=Y7D5w@mail.gmail.com>
Message-ID: <CAAhV-H7eGNof=qjq=U1KaQaC4p48DDroiRxhiTEWs9Eg=Y7D5w@mail.gmail.com>
Subject: Re: [[PATCH V2 00/10] Added Interrupt controller emulation for
 loongarch kvm
To: Xianglai Li <lixianglai@loongson.cn>
Cc: linux-kernel@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Xianglai,

This series is good as a whole, just some naming issues.
1, In the current kernel the short name of "Extended I/O Interrupt
Controller" is eiointc, so please change related prefix from extioi_
to eiointc.

And for

  KVM_DEV_TYPE_LA_IOAPIC,
  KVM_DEV_TYPE_LA_IPI,
  KVM_DEV_TYPE_LA_EXTIOI,

Please use

  KVM_DEV_TYPE_LOONGARCH_IPI,
  KVM_DEV_TYPE_LOONGARCH_EXTIOI,
  KVM_DEV_TYPE_LOONGARCH_PCHPIC,

instead.

Huacai

On Fri, Aug 23, 2024 at 5:51=E2=80=AFPM Xianglai Li <lixianglai@loongson.cn=
> wrote:
>
> Before this, the interrupt controller simulation has been completed
> in the user mode program. In order to reduce the loss caused by frequent
> switching of the virtual machine monitor from kernel mode to user mode
> when the guest accesses the interrupt controller, we add the interrupt
> controller simulation in kvm.
>
> The following is a virtual machine simulation diagram of interrupted
> connections:
>   +-----+    +---------+     +-------+
>   | IPI |--> | CPUINTC | <-- | Timer |
>   +-----+    +---------+     +-------+
>                  ^
>                  |
>            +---------+
>            | EIOINTC |
>            +---------+
>             ^       ^
>             |       |
>      +---------+ +---------+
>      | PCH-PIC | | PCH-MSI |
>      +---------+ +---------+
>        ^      ^          ^
>        |      |          |
> +--------+ +---------+ +---------+
> | UARTs  | | Devices | | Devices |
> +--------+ +---------+ +---------+
>
> In this series of patches, we mainly realized the simulation of
> IPI EXTIOI PCH-PIC interrupt controller.
>
> The simulation of IPI EXTIOI PCH-PIC interrupt controller mainly
> completes the creation simulation of the interrupt controller,
> the register address space read and write simulation,
> and the interface with user mode to obtain and set the interrupt
> controller state for the preservation,
> recovery and migration of virtual machines.
>
> IPI simulation implementation reference:
> https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongs=
on-3A5000-usermanual-EN/inter-processor-interrupts-and-communication
>
> EXTIOI simulation implementation reference:
> https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongs=
on-3A5000-usermanual-EN/io-interrupts/extended-io-interrupts
>
> PCH-PIC simulation implementation reference:
> https://github.com/loongson/LoongArch-Documentation/blob/main/docs/Loongs=
on-7A1000-usermanual-EN/interrupt-controller.adoc
>
> For PCH-MSI, we used irqfd mechanism to send the interrupt signal
> generated by user state to kernel state and then to EXTIOI without
> maintaining PCH-MSI state in kernel state.
>
> You can easily get the code from the link below:
> the kernel:
> https://github.com/lixianglai/linux
> the branch is: interrupt
>
> the qemu:
> https://github.com/lixianglai/qemu
> the branch is: interrupt
>
> Please note that the code above is regularly updated based on community
> reviews.
>
> change log:
> V1->V2:
> 1.Remove redundant blank lines according to community comments
> 2.Remove simplified redundant code
> 3.Adds 16 bits of read/write interface to the extioi iocsr address space
> 4.Optimize user - and kernel-mode data access interfaces: Access
> fixed length data each time to prevent memory overruns
> 5.Added virtual extioi, where interrupts can be routed to cpus other than=
 cpu 4
>
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: kvm@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Xianglai li <lixianglai@loongson.cn>
>
> Xianglai Li (10):
>   LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
>   LoongArch: KVM: Add IPI device support
>   LoongArch: KVM: Add IPI read and write function
>   LoongArch: KVM: Add IPI user mode read and write function
>   LoongArch: KVM: Add EXTIOI device support
>   LoongArch: KVM: Add EXTIOI read and write functions
>   LoongArch: KVM: Add PCHPIC device support
>   LoongArch: KVM: Add PCHPIC read and write functions
>   LoongArch: KVM: Add PCHPIC user mode read and write functions
>   LoongArch: KVM: Add irqfd support
>
>  arch/loongarch/include/asm/kvm_extioi.h  |  122 +++
>  arch/loongarch/include/asm/kvm_host.h    |   30 +
>  arch/loongarch/include/asm/kvm_ipi.h     |   52 ++
>  arch/loongarch/include/asm/kvm_pch_pic.h |   61 ++
>  arch/loongarch/include/uapi/asm/kvm.h    |   19 +
>  arch/loongarch/kvm/Kconfig               |    3 +
>  arch/loongarch/kvm/Makefile              |    4 +
>  arch/loongarch/kvm/exit.c                |   86 +-
>  arch/loongarch/kvm/intc/extioi.c         | 1056 ++++++++++++++++++++++
>  arch/loongarch/kvm/intc/ipi.c            |  510 +++++++++++
>  arch/loongarch/kvm/intc/pch_pic.c        |  521 +++++++++++
>  arch/loongarch/kvm/irqfd.c               |   87 ++
>  arch/loongarch/kvm/main.c                |   18 +-
>  arch/loongarch/kvm/vcpu.c                |    3 +
>  arch/loongarch/kvm/vm.c                  |   53 +-
>  include/linux/kvm_host.h                 |    1 +
>  include/trace/events/kvm.h               |   35 +
>  include/uapi/linux/kvm.h                 |    8 +
>  18 files changed, 2641 insertions(+), 28 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_extioi.h
>  create mode 100644 arch/loongarch/include/asm/kvm_ipi.h
>  create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
>  create mode 100644 arch/loongarch/kvm/intc/extioi.c
>  create mode 100644 arch/loongarch/kvm/intc/ipi.c
>  create mode 100644 arch/loongarch/kvm/intc/pch_pic.c
>  create mode 100644 arch/loongarch/kvm/irqfd.c
>
>
> base-commit: 872cf28b8df9c5c3a1e71a88ee750df7c2513971
> --
> 2.39.1
>

