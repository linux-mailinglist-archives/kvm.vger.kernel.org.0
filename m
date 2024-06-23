Return-Path: <kvm+bounces-20334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A2D913981
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 12:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 854B81C214C4
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 10:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6DF612D205;
	Sun, 23 Jun 2024 10:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpp7I21V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2839470;
	Sun, 23 Jun 2024 10:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719137920; cv=none; b=NRiUOksUoNs3/MAm7xU3CYlhbETYb3+82+Cdu2jBCNL/KYZUUo0wshLpqpazCxHbJMD6Mo0qVcdgN4yioqjttYCcI7i3S9e03wB9TvXkS58wSxnnw5Ijhm/jpdMuAwz6iNtY4AuVn9kIruA5zzTNc98gNzPjAWo3si8rybP5k2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719137920; c=relaxed/simple;
	bh=YvSVXJdBQKWUuhk9Qus9TV4AhCWxwK8gs3Y89XMznTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iGcEZAuY7zWCTt/zUF9t2U/GEJoc+wTMhSNd8wyQTGLpVf+Y04d+B6RtBG8u43kIJW8QMa9Kff+u77HYNGF8hfCTiB6AiBWwOmZiSw4ml2+EnwMdW+0xcQeH7oGM1dUUUwd5dTdBlvS1KlV2oL2gF76ZUEeuT3ZT9XVzhKzwmZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpp7I21V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780F7C32782;
	Sun, 23 Jun 2024 10:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719137919;
	bh=YvSVXJdBQKWUuhk9Qus9TV4AhCWxwK8gs3Y89XMznTI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gpp7I21Vk/LF2bkbXohHJUXdbaUjuIKA26Vck4ESRK2TDVtOdLDWtqN8mxPcxfGxb
	 gzAbsiscGjZSSGHBtaf2Q0aiH3l2caAEOGXNoIkGOmm4XGxtsElE4uKgKRJpWjVTiT
	 lvej8KYHB+Y0YGYPYUnivy8OElXkxPfTYsRoYfyvYKt7llKfW85lQNZHFZdvH3wLEY
	 b0G9twTcDqWZBIvib9qv/iUV0oUMhEvUh8ALp38+9KpterAMFwxojOlhkZF6eCY+xk
	 VfpWxBuoG8JY8YhNaSQrKKignxrrWu2mIn3X3yceHbI3ziIma6QYh1kJJ0Y9Hua8hb
	 hQE9zy1xtU9AQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a689ad8d1f6so422383766b.2;
        Sun, 23 Jun 2024 03:18:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWGQ6EC+qF42BJrffSsrmsLtl2EsCPCbyb8dEKAuEtuP7NpifC3PwYC7gGfw2CdVYdSwvU/dksJ4CPgsx44wURMvUN6JhJb3Js4ASodPLMZm+ouqnDZ6Qf3Pxbm3nw/tuCJ
X-Gm-Message-State: AOJu0YwA59SN4ePC8zDfZu1Cm4qFMH3jgawO86AmT0uZ6Z4+SACrampw
	XTjuOhe14Y5m5dsyLlLrMZzQD/3GHRk4YDif6q/twJVY78Yvt262ldZ+/McvdLnSMOO6t7TzRzv
	DvSE5FYtqDF7/KNKyvx0FkJNPhJk=
X-Google-Smtp-Source: AGHT+IETl9tcGslgNmKwUQFdKXbdPsmbNWyuSxrrYzFXcGEQW2pW/t5Kw9wATH526H1HJQU6acmvH1WEciSIgB/l4d8=
X-Received: by 2002:a17:906:a8d:b0:a6e:fccc:e4a with SMTP id
 a640c23a62f3a-a7245b4a3c3mr96498966b.0.1719137917974; Sun, 23 Jun 2024
 03:18:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619080940.2690756-1-maobibo@loongson.cn> <20240619080940.2690756-5-maobibo@loongson.cn>
In-Reply-To: <20240619080940.2690756-5-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 23 Jun 2024 18:18:27 +0800
X-Gmail-Original-Message-ID: <CAAhV-H74raJ9eEWEHr=aN6LhVvNUyP6TLEDH006M6AnoE8tkPg@mail.gmail.com>
Message-ID: <CAAhV-H74raJ9eEWEHr=aN6LhVvNUyP6TLEDH006M6AnoE8tkPg@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] LoongArch: KVM: Add memory barrier before update
 pmd entry
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Wed, Jun 19, 2024 at 4:09=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> When updating pmd entry such as allocating new pmd page or splitting
> huge page into normal page, it is necessary to firstly update all pte
> entries, and then update pmd entry.
>
> It is weak order with LoongArch system, there will be problem if other
> vcpus sees pmd update firstly however pte is not updated. Here smp_wmb()
> is added to assure this.
Memory barriers should be in pairs in most cases. That means you may
lose smp_rmb() in another place.

Huacai

>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/mmu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 1690828bd44b..7f04edfbe428 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -163,6 +163,7 @@ static kvm_pte_t *kvm_populate_gpa(struct kvm *kvm,
>
>                         child =3D kvm_mmu_memory_cache_alloc(cache);
>                         _kvm_pte_init(child, ctx.invalid_ptes[ctx.level -=
 1]);
> +                       smp_wmb(); /* make pte visible before pmd */
>                         kvm_set_pte(entry, __pa(child));
>                 } else if (kvm_pte_huge(*entry)) {
>                         return entry;
> @@ -746,6 +747,7 @@ static kvm_pte_t *kvm_split_huge(struct kvm_vcpu *vcp=
u, kvm_pte_t *ptep, gfn_t g
>                 val +=3D PAGE_SIZE;
>         }
>
> +       smp_wmb();
>         /* The later kvm_flush_tlb_gpa() will flush hugepage tlb */
>         kvm_set_pte(ptep, __pa(child));
>
> --
> 2.39.3
>

