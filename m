Return-Path: <kvm+bounces-1600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 675317E9EDE
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 15:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08395B20A0D
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 14:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324FB21108;
	Mon, 13 Nov 2023 14:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHICE0Tu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112D121110
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 14:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A157EC433C9;
	Mon, 13 Nov 2023 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699886208;
	bh=T94jC6gYgqIEWFyZ1II2N6gAHu2jGjaIBOT2siGHB8A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CHICE0Tu+G63jYeMl+9KfCeKD3f+6g3YkLyIL6ERGvkZWpfxz0eOUFje7Gd4BOGad
	 qrnrT7S81BdPZZNv8kn6gWi/32gHa/YlM8ipH8IBeNtyAf4GzC/obyqe1YDIh0LIuz
	 4jd6hyhoZ2i9V9H3qBLQU2UL/isbo6JluQYR7YyEC5xsGJaLJT1Vhnh/9fc8K4B9Ht
	 h53B6ILBWqfXInSuOHvArWs9KBy5MAMVVoyUdTxF+RDP/3oYara6frtVkhO/oXe7+b
	 NOfVIevgl18YzcRwfCTtarBJW35Zb0J3TgRqXz8joARz9D7JjEdVwY/4fRnrOvhGiN
	 EunNr5ElkXw7g==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5440f25dcc7so6908685a12.0;
        Mon, 13 Nov 2023 06:36:48 -0800 (PST)
X-Gm-Message-State: AOJu0Yw8z25ZxMvXxwOXFzINvTNO0rfraH4D6byfJ/EkQeuPywvQk8f/
	NWjZ8IXOMGRkiDE+3ZIzljyl0zNCZtF7Fqp3FTw=
X-Google-Smtp-Source: AGHT+IE5N7gaovtQf+6aQpJwEoMCVsB9Y6Eaj7ba1gX65dnSqlKSXkvvTlQSoMjG3C4SFjnXtWxlh4xEYN/E1W7XgJo=
X-Received: by 2002:a05:6402:3494:b0:547:479b:c299 with SMTP id
 v20-20020a056402349400b00547479bc299mr3110444edc.19.1699886207128; Mon, 13
 Nov 2023 06:36:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231110090529.56950-1-maobibo@loongson.cn>
In-Reply-To: <20231110090529.56950-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 13 Nov 2023 22:36:35 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6zH7TwcAokHguy5Wk_z44nu6toZ9uW48TxrgxxRrvuJA@mail.gmail.com>
Message-ID: <CAAhV-H6zH7TwcAokHguy5Wk_z44nu6toZ9uW48TxrgxxRrvuJA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] LoongArch: KVM: Remove SW timer switch when vcpu
 is halt polling
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

Does this series have some relationship with the commit
"LoongArch:LSVZ: set timer offset at first time once" in our internal
repo?

Huacai

On Fri, Nov 10, 2023 at 5:07=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> This patches removes SW timer switch during vcpu block stage. VM uses HW
> timer rather than SW PV timer on LoongArch system, it can check pending
> HW timer interrupt status directly, rather than switch to SW timer and
> check injected SW timer interrupt.
>
> When SW timer is not used in vcpu halt-polling mode, the relative
> SW timer handling before entering guest can be removed also. Timer
> emulation is simpler than before, SW timer emuation is only used in vcpu
> thread context switch.
>
> ---
>
> Changes in v3:
>   Add kvm_arch_vcpu_runnable checking before kvm_vcpu_halt.
>
> Changes in v2:
>   Add halt polling support for idle instruction emulation, using api
> kvm_vcpu_halt rather than kvm_vcpu_block in function kvm_emu_idle.
>
> ---
>
> Bibo Mao (3):
>   LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
>   LoongArch: KVM: Allow to access HW timer CSR registers always
>   LoongArch: KVM: Remove kvm_acquire_timer before entering guest
>
>  arch/loongarch/include/asm/kvm_vcpu.h |  1 -
>  arch/loongarch/kvm/exit.c             | 13 ++------
>  arch/loongarch/kvm/main.c             |  1 -
>  arch/loongarch/kvm/timer.c            | 47 +++++++--------------------
>  arch/loongarch/kvm/vcpu.c             | 38 +++++-----------------
>  5 files changed, 22 insertions(+), 78 deletions(-)
>
>
> base-commit: 305230142ae0637213bf6e04f6d9f10bbcb74af8
> --
> 2.39.3
>

