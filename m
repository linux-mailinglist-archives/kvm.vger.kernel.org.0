Return-Path: <kvm+bounces-65926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BB6CBA931
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 13:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C73363022FCC
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 12:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D778E2C0F6C;
	Sat, 13 Dec 2025 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4NJY0rb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AF7281356
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 12:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765629545; cv=none; b=X2efHzgDcNndSRSgtBWvTNY6K/+ckgo9FQ1Qhd7CFmOgazbssmzEneGs5uQQJXDMo4xQ2YKR+6dwVtofuZs8+aG5x+BXiyMVK9azDhjCz4sbeFVYJhwZAchdLdcQW9d3fLKlbVLJ6AUPzfpbZocSUUiAD5BER0a9YWjtKYLoKoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765629545; c=relaxed/simple;
	bh=eInlOs4Mc9g2A0jeabtfZtp33M6zckPZAXDrEPuMPx8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zv+gajDswEmLFIhYZY41zNOgP/Uo/kRtnEIilvqoOdBhLYvDACdONAKrCG6ty/879KER3dix1fKa141eFmJPm+bLXkk+ApX6Tfz73LJVYBXbWYpkwsGMfkvNKfwPSBoDljTmgWrpwIIeQfsTxsSaGKcV3ngwzigea+y0rIvPgio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4NJY0rb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9962BC4CEFB
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 12:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765629544;
	bh=eInlOs4Mc9g2A0jeabtfZtp33M6zckPZAXDrEPuMPx8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=j4NJY0rbhEFQxn7T756066+uHzz0peSc5DabxJkZa6TzPs9yHMifnPAtqWt5Cr7gg
	 J0KTF+xaH9+72ZVvd/181p+qmeuxtgm6boD3KQzFxWAaHgdTj0SLiwRntKFaKhsP3u
	 3OJEtYkfn32xImD+vagTDQC+YhQDUImoFZUzELsrOKkiwGW1Pvo3fGs43eZsThNVsI
	 ZXYPnzN+t7U/N7gH0u2A9jyMT/9MlmBaCAD/vc617RXt7/XTyJiMu4HTIAJmWQB4qE
	 98mlPmR4w1U5n+ovqVDPXw34h0Ncoji3ru+mleEh5rvlYqf6j/EbRwMQQ6HzCOra0B
	 bDgQD5NSg0W2g==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b725ead5800so306860266b.1
        for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 04:39:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU3WbeQNqF3C1yEzvIh/7Nf6xhd9UniEgk8sQPQ0PsnLGHp7PJcHp0MrqkCfgKjeAN3wxc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaE4u06H8AymPIGIHVadHuV337dz2+vzcepRq/be9isVpGVOCi
	SyGdz6fmYiawvEZgV8lpT+ltGfkOyU2sQRPDMlgmDqIYhZ7BdAYfegUF6Jg5K4JhfqEK0i8RupC
	Dxpce2FF43k5JpP+FpgNg1UtdcfqWYyQ=
X-Google-Smtp-Source: AGHT+IFLHD47GPfOFl7SONUY6Bn1a0xVaJUAYI6wlPg8HerejJH0KhouJ62knw3R+Ax3v24rtXyR6XxOjCL0UKOxJWI=
X-Received: by 2002:a17:907:1c1e:b0:b79:e887:e1b3 with SMTP id
 a640c23a62f3a-b7d23c2a164mr567772666b.57.1765629543203; Sat, 13 Dec 2025
 04:39:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251206064658.714100-1-gaosong@loongson.cn>
In-Reply-To: <20251206064658.714100-1-gaosong@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 13 Dec 2025 20:39:15 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5BZuZGu0jOBXr-Ed1uJYhS_d2NMhV22-7VGu_7J2D1fw@mail.gmail.com>
X-Gm-Features: AQt7F2q3O0tm0DpSPLgoXtszYEE-VE9U0I2bc3zJclmShIzFQf9ofhyqqA_ZP8I
Message-ID: <CAAhV-H5BZuZGu0jOBXr-Ed1uJYhS_d2NMhV22-7VGu_7J2D1fw@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] LongArch: KVM: Add AVEC support irqchip in kernel
To: Song Gao <gaosong@loongson.cn>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kernel@xen0n.name, linux-kernel@vger.kernel.org, lixianglai@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Song,

On Sat, Dec 6, 2025 at 3:11=E2=80=AFPM Song Gao <gaosong@loongson.cn> wrote=
:
>
> Hi,
>
> This series adds AVEC-related macros, implements the DINTC in-kernel irqc=
hip device,
> enables irqfd to deliver MSI to DINTC, and supports injecting MSI interru=
pts
> to the target vCPU.
>
>
> V3: Fix kvm_arch_set_irq_inatomic() missing dintc set msi.(patch3)
>
> V2:
> https://patchew.org/linux/20251128091125.2720148-1-gaosong@loongson.cn/
>
> Thanks.
> Song Gao
>
> Song Gao (4):
>   LongArch: KVM: Add some maccros for AVEC
The first patch has been merged.

For others, I prefer the AVEC/AVECINTC naming rather than DINTC, since
the driver name and your cover letter both call it AVEC.
But If you don't like AVEC or want to keep consistency with the user
manual, please use DMSINTC because the IOCSR feature bit is called
DMSI.

Huacai

>   LongArch: KVM: Add DINTC device support
>   LongArch: KVM: Add irqfd set dintc msi
>   LongArch: KVM: Add dintc inject msi to the dest vcpu
>
>  arch/loongarch/include/asm/irq.h       |   8 ++
>  arch/loongarch/include/asm/kvm_dintc.h |  22 +++++
>  arch/loongarch/include/asm/kvm_host.h  |   8 ++
>  arch/loongarch/include/uapi/asm/kvm.h  |   4 +
>  arch/loongarch/kvm/Makefile            |   1 +
>  arch/loongarch/kvm/intc/dintc.c        | 116 +++++++++++++++++++++++++
>  arch/loongarch/kvm/interrupt.c         |   1 +
>  arch/loongarch/kvm/irqfd.c             |  45 ++++++++--
>  arch/loongarch/kvm/main.c              |   5 ++
>  arch/loongarch/kvm/vcpu.c              |  55 ++++++++++++
>  drivers/irqchip/irq-loongarch-avec.c   |   5 +-
>  include/uapi/linux/kvm.h               |   2 +
>  12 files changed, 263 insertions(+), 9 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_dintc.h
>  create mode 100644 arch/loongarch/kvm/intc/dintc.c
>
> --
> 2.39.3
>
>

