Return-Path: <kvm+bounces-7273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C3883EC01
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 09:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12E9F2836A1
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 08:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0428A1DFD6;
	Sat, 27 Jan 2024 08:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tcElxdZR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280191DA26;
	Sat, 27 Jan 2024 08:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706343488; cv=none; b=Gytf0kpcZE66Q7MJ5LPXUVSmjTeZEqN0R/Xr4Xz61lG09d3QB1DszUwIwK/DfodmiFcJde1GoMsgwTwnsNB8Dm3LNswbeh3RJwrw5PPKMa8eHWB83GAtawLZkj0Mwz3zFVVyx+j7UPQswf8aHqDxC507O3o4sxKYAJPLMWV32Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706343488; c=relaxed/simple;
	bh=8LLLdtl9//0302xBmCAb5fVKYkH14Azx9Y+eiOFpAO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g2Rgricsdj2Byib3H79sHlNCcbT34xs9UQcng9U0Qo9MTs8RS9+AkNrFI9iprhOwyYbU/r5UiugzbX+ZV3H58pRvbdynpY7f44PsAXrbjVF6vP9TxrDHEiRfFmsVATllMuMqSLSXstMcU5pTJ5yGMNNtVgVpj3EmZRcWIAezHpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tcElxdZR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0930C433A6;
	Sat, 27 Jan 2024 08:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706343487;
	bh=8LLLdtl9//0302xBmCAb5fVKYkH14Azx9Y+eiOFpAO8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tcElxdZRnTaWsZzPC7p3aBqDTC4aQE52psLaEiaM4MbTL1R+0e/ZkyFK1w4LXot/g
	 1Y70EW59o197oUXOdEcEr1OiBU7mt8TmuIPJzXlLwojfAdPuXHEC1RZMrQX0TKN8m2
	 wwo1RSbYFf0so93MyKlCKL4lxZY4HLkVNY7PnFZMOw1MGgApyPIrk8ASAF0xBtOmmT
	 /ChNYNQzoYx+75oXF4GJSEeQd1rJTbvzM9YM+7UL9kAuXzlUfo5mvmmWzlUlWCZMed
	 V7ioLrPNwbY3IFw2F4Q2JeaQY5SA8tbpJbKPs0PI2ADccsDwoLksi8fhh+l3pS9HyX
	 yusO6eyo6DK2g==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-55790581457so894132a12.3;
        Sat, 27 Jan 2024 00:18:07 -0800 (PST)
X-Gm-Message-State: AOJu0YyVrNGRIhFBxp0smw2LR5IU5xEgvSIwdb95hYhlmAYm3MUtFrOu
	FEP70rq4miYYwspbxXmTjLaOULxZFsc9OVVza0bdpGUHxK7wGUzB11ahC50L1aEsQM6l4Yy31lP
	1vfoF5uvFTGYzOzNp4ZZCACHM9Jk=
X-Google-Smtp-Source: AGHT+IGT2oaOQe+6LGqKk1utGK8v/4/ke1g5CH4yt8uO8c+K4HjhzynJLCp1L0QZDaO+dh5JgCFYR94L+8zzSAZbfAA=
X-Received: by 2002:aa7:da08:0:b0:55e:ba92:21a6 with SMTP id
 r8-20020aa7da08000000b0055eba9221a6mr256577eds.19.1706343485949; Sat, 27 Jan
 2024 00:18:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231115090735.2404866-1-chenhuacai@loongson.cn> <CABgObfYbv_rHto8eEWLB3srmCPj6Le7wDfG5XtYpUH17HBTcCw@mail.gmail.com>
In-Reply-To: <CABgObfYbv_rHto8eEWLB3srmCPj6Le7wDfG5XtYpUH17HBTcCw@mail.gmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 27 Jan 2024 16:17:55 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5OV4ije66YM=nTTL47nEmSb-N3KqnLWLYXx7UXeM=4PA@mail.gmail.com>
Message-ID: <CAAhV-H5OV4ije66YM=nTTL47nEmSb-N3KqnLWLYXx7UXeM=4PA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix build due to API changes
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Paolo,

On Sat, Jan 27, 2024 at 2:01=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Wed, Nov 15, 2023 at 10:14=E2=80=AFAM Huacai Chen <chenhuacai@loongson=
.cn> wrote:
> >
> > Commit 8569992d64b8f750e34b7858eac ("KVM: Use gfn instead of hva for
> > mmu_notifier_retry") replaces mmu_invalidate_retry_hva() usage with
> > mmu_invalidate_retry_gfn() for X86, LoongArch also need similar changes
> > to fix build.
> >
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
>
> Applied, thanks.
I'm sorry that I have already sent a PR to Linus which includes this
one and together with some other patches.

Huacai

>
> Paolo
>
> > ---
> >  arch/loongarch/kvm/mmu.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> > index 80480df5f550..9463ebecd39b 100644
> > --- a/arch/loongarch/kvm/mmu.c
> > +++ b/arch/loongarch/kvm/mmu.c
> > @@ -627,7 +627,7 @@ static bool fault_supports_huge_mapping(struct kvm_=
memory_slot *memslot,
> >   *
> >   * There are several ways to safely use this helper:
> >   *
> > - * - Check mmu_invalidate_retry_hva() after grabbing the mapping level=
, before
> > + * - Check mmu_invalidate_retry_gfn() after grabbing the mapping level=
, before
> >   *   consuming it.  In this case, mmu_lock doesn't need to be held dur=
ing the
> >   *   lookup, but it does need to be held while checking the MMU notifi=
er.
> >   *
> > @@ -807,7 +807,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsi=
gned long gpa, bool write)
> >
> >         /* Check if an invalidation has taken place since we got pfn */
> >         spin_lock(&kvm->mmu_lock);
> > -       if (mmu_invalidate_retry_hva(kvm, mmu_seq, hva)) {
> > +       if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
> >                 /*
> >                  * This can happen when mappings are changed asynchrono=
usly, but
> >                  * also synchronously if a COW is triggered by
> > --
> > 2.39.3
> >
>

