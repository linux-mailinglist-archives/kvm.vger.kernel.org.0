Return-Path: <kvm+bounces-5453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 546928220DA
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 19:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2BA62842D3
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5047156FF;
	Tue,  2 Jan 2024 18:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PMk/iwz7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8728F156E0
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 18:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704219501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qqNcOVDP8DdJ819qPbE88DE6/hMQSOntgNZh+qc4qEc=;
	b=PMk/iwz7OwAOoSCmxKCk329ea+CVx75q9bXUN8wEGcC0nUTqkowrv/6LAyleIVPAiIraoz
	23liv8ZVOvY914xbd33bHMR77KoW/DXbCOtL2FZGlbGAfm6aNK2c1HmDawlcDx3Eq5A381
	CoAmFWW51dzyBCtkdw3kVS6Aofzioy0=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-hgyTU_w8OrGrIvp4fjGM_g-1; Tue, 02 Jan 2024 13:18:19 -0500
X-MC-Unique: hgyTU_w8OrGrIvp4fjGM_g-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-466ff7ad1faso1721275137.2
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 10:18:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704219498; x=1704824298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqNcOVDP8DdJ819qPbE88DE6/hMQSOntgNZh+qc4qEc=;
        b=Gl2xvx/GNlskDNntLxkJS9Z4iTI7NWguEeqk9XvZLHUm9LDDDjHpF7YRW8C2zlTApP
         l4vkjkzGEjwICUkLbbuL6vu1QYD/VYU0O031JCkjcts1UZpAlTSE0UY2L1RwTAcODOW8
         1dHpHr9gIpLm8PD5xfzR2zhnuiBXFcQ+dUKB5+0mq+8PVUFdihAnxdXi+JxUlUhsR018
         3NZzGP9VJyDePhvCPw7RNIWnXxF1bLHSmxLinrBRLmsoWxfs7/sx6CzHkphCc27rodoE
         5q9Ftgwtv/lMJP6GIs1qjUqR/V37N5EATAoRmyJND6M4TIUuJJX2rSzM2jJM4m5CtXFv
         uTeg==
X-Gm-Message-State: AOJu0YwqErmo6e1PIIuk3NbPPBExDSNqGM+z02FXDGdkUHYUwgnIcYfW
	7SlF7SnOZ3QQpzNgMEoUpSw5XAxF5UZBzCzFazdI4kfNsfwx3z5TTaHbCsjk1i2BU+3BJ/kb1To
	+WrAwNfVoopOY0N5NkoJis5dqAcbLsBrqTkW2COlJTIQ7
X-Received: by 2002:a05:6102:32cb:b0:467:7df1:93d4 with SMTP id o11-20020a05610232cb00b004677df193d4mr1333690vss.56.1704219497983;
        Tue, 02 Jan 2024 10:18:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVztsrJFmMF0JJjeSQuEPrOTAsB2AewM3tqW1FHbMEMG3rKdHdoK3NErEji+Bu7ltEHjnjBgbxoSTivL4kKWw=
X-Received: by 2002:a05:6102:32cb:b0:467:7df1:93d4 with SMTP id
 o11-20020a05610232cb00b004677df193d4mr1333683vss.56.1704219497723; Tue, 02
 Jan 2024 10:18:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231223120642.1067728-1-chenhuacai@loongson.cn>
In-Reply-To: <20231223120642.1067728-1-chenhuacai@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 2 Jan 2024 19:18:05 +0100
Message-ID: <CABgObfZHRf7E_7Jk4uPRmSyxTy3EiuuYwHC35jQncNL9s-zTDA@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.8
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 23, 2023 at 1:12=E2=80=AFPM Huacai Chen <chenhuacai@loongson.cn=
> wrote:
>
> The following changes since commit ceb6a6f023fd3e8b07761ed900352ef574010b=
cb:
>
>   Linux 6.7-rc6 (2023-12-17 15:19:28 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson=
.git tags/loongarch-kvm-6.8
>
> for you to fetch changes up to 118e10cd893d57df55b3302dfd188a981b6e6d1c:
>
>   LoongArch: KVM: Add LASX (256bit SIMD) support (2023-12-19 10:48:28 +08=
00)

Pulled, thanks.

Paolo

>
> ----------------------------------------------------------------
> LoongArch KVM changes for v6.8
>
> 1. Optimization for memslot hugepage checking.
> 2. Cleanup and fix some HW/SW timer issues.
> 3. Add LSX/LASX (128bit/256bit SIMD) support.
>
> ----------------------------------------------------------------
> Bibo Mao (5):
>       LoongArch: KVM: Optimization for memslot hugepage checking
>       LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
>       LoongArch: KVM: Allow to access HW timer CSR registers always
>       LoongArch: KVM: Remove kvm_acquire_timer() before entering guest
>       LoongArch: KVM: Fix timer emulation with oneshot mode
>
> Tianrui Zhao (2):
>       LoongArch: KVM: Add LSX (128bit SIMD) support
>       LoongArch: KVM: Add LASX (256bit SIMD) support
>
>  arch/loongarch/include/asm/kvm_host.h |  24 ++-
>  arch/loongarch/include/asm/kvm_vcpu.h |  21 ++-
>  arch/loongarch/include/uapi/asm/kvm.h |   1 +
>  arch/loongarch/kernel/fpu.S           |   2 +
>  arch/loongarch/kvm/exit.c             |  50 ++++--
>  arch/loongarch/kvm/main.c             |   1 -
>  arch/loongarch/kvm/mmu.c              | 124 +++++++++-----
>  arch/loongarch/kvm/switch.S           |  31 ++++
>  arch/loongarch/kvm/timer.c            | 129 ++++++++------
>  arch/loongarch/kvm/trace.h            |   6 +-
>  arch/loongarch/kvm/vcpu.c             | 307 ++++++++++++++++++++++++++++=
++----
>  11 files changed, 551 insertions(+), 145 deletions(-)
>


