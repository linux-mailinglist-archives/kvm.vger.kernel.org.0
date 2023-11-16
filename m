Return-Path: <kvm+bounces-1863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B937ED9CC
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:55:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CCFA281008
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 02:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CEE663BD;
	Thu, 16 Nov 2023 02:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvyfsMcf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588DF8F40
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 02:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5F9C433C8;
	Thu, 16 Nov 2023 02:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700103304;
	bh=ZqesSgGnkVZM04RFsgA7wOog4cC0NwW8GeTDpVZM7eo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CvyfsMcf7sdo3j1uzQfaol/ZITI27NtDWoHNx/qNQKZpvFsfY/6KxpizWMtjEjrzT
	 UqGhkv1DYO428o1V7FLwOg6Yac70GG4dK5i9fvipUAHNLJldii5N/TV4uvNed/WCHu
	 /lClVFSG7gQBt30snqdSOmd4KxBTPt/twxpCIMJiBnCzmDKxtxaiRbSO1ndINKHQf/
	 89g1gfHkiwHdycnErF/bRmjdcUuAuo0+nyqMFXtqoIAv+y9NFwr72NE3wgNr+r9TK/
	 qcImN6EKfXlTzqHYm6tLemYHtWue0Co/SOAF5J9LU4OfAd0rOFRC5hfLK+aPqgK1eQ
	 o/UIsQ09s3WcA==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5440f25dcc7so519139a12.0;
        Wed, 15 Nov 2023 18:55:03 -0800 (PST)
X-Gm-Message-State: AOJu0YyjKP8zYF02m2si6RyRwVY3aZblylmxzBy0Cma6cIzCgxwv7Nys
	IiXXzvxCY0XDWO2GtQ1EFNwrCmSpe0IkofNdgh8=
X-Google-Smtp-Source: AGHT+IGoyHYHxifCTEl8SsnAL1yE8tDDpUcvj5Qt/DgQNFhXKJlIPTjK+Dm+HM5u0H1F+5copmj1N5nmRNBShvMzuxs=
X-Received: by 2002:a05:6402:1042:b0:540:c989:fcdd with SMTP id
 e2-20020a056402104200b00540c989fcddmr11265637edu.11.1700103302368; Wed, 15
 Nov 2023 18:55:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231116023036.2324371-1-maobibo@loongson.cn>
In-Reply-To: <20231116023036.2324371-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 16 Nov 2023 10:54:52 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4Wyp-6_gFSfm8uWUMiEJnebk9n4JxQrx_nBdxkTF5wUA@mail.gmail.com>
Message-ID: <CAAhV-H4Wyp-6_gFSfm8uWUMiEJnebk9n4JxQrx_nBdxkTF5wUA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] LoongArch: KVM: Remove SW timer switch when vcpu
 is halt polling
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

I suggest submitting this series to the internal repo, too. Because we
don't have enough resources to test the stability for the upstream
version, while this is a fundamental change. On the other hand, the
patch "LoongArch:LSVZ: set timer offset at first time once" can be
submitted first because it is already in the internal repo.

Huacai

On Thu, Nov 16, 2023 at 10:33=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
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
> ---
> Changes in v4:
>   If vcpu is scheduled out since there is no pending event, and timer is
> fired during sched-out period. SW hrtimer is used to wake up vcpu thread
> in time, rather than inject pending timer irq.
>
> Changes in v3:
>   Add kvm_arch_vcpu_runnable checking before kvm_vcpu_halt.
>
> Changes in v2:
>   Add halt polling support for idle instruction emulation, using api
> kvm_vcpu_halt rather than kvm_vcpu_block in function kvm_emu_idle.
>
> ---
> Bibo Mao (3):
>   LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
>   LoongArch: KVM: Allow to access HW timer CSR registers always
>   LoongArch: KVM: Remove kvm_acquire_timer before entering guest
>
>  arch/loongarch/include/asm/kvm_vcpu.h |  1 -
>  arch/loongarch/kvm/exit.c             | 13 +-----
>  arch/loongarch/kvm/main.c             |  1 -
>  arch/loongarch/kvm/timer.c            | 62 ++++++++++-----------------
>  arch/loongarch/kvm/vcpu.c             | 38 ++++------------
>  5 files changed, 32 insertions(+), 83 deletions(-)
>
>
> base-commit: c42d9eeef8e5ba9292eda36fd8e3c11f35ee065c
> --
> 2.39.3
>

