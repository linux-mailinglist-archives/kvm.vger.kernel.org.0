Return-Path: <kvm+bounces-2436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 873007F764A
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 15:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E60BB2170F
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 14:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0632D60E;
	Fri, 24 Nov 2023 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aevSnydD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071E12D03C
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 14:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7D1C433B9;
	Fri, 24 Nov 2023 14:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700835789;
	bh=fxI4uXn2KfvV1R7R9iTkUg0DR5eIEK+BbuDI5r58j/w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aevSnydDZ4Uz+e2pC/C/kvwGX84Zj0aZfpEj+a9uSSjw36YDfHrl+gbR1scHc+VCv
	 kP93iyjC8FJa5LBIfIC1xGfWDCY3ZJZ5a+vdQLdbEkPPADLUI+eEhh6hzM7p95Cv/M
	 e9LkzYvdjfM3ZiawCRuta1Vff2dIXuNoV1woH+lhsBeJtGK8c9zmSRCJ4zyglBzR4v
	 ODcVXntzHes75XCUMhBJb6mLkJ4AK45B2HsAykXZrlvRZZnIQn5VxJIxQFh2o08wzl
	 gcttLHxCW3f2r8mVITkRGSrbxVsTugWompFGM+3a9HU6Iiy6Npwi9+3I56iTEwL0gu
	 J715C7xHk7A5w==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-54aecf9270fso1060633a12.0;
        Fri, 24 Nov 2023 06:23:09 -0800 (PST)
X-Gm-Message-State: AOJu0YwpvPjOCdkzYYwMGZBHVrpfO6jUnuJZYIwP0Gbtnt/gd8kqczsU
	LNYKKvLfDB0+cIrU7jFCgia8bKzX4U59zIv+OWY=
X-Google-Smtp-Source: AGHT+IGPovQWrXUW9VvdSCkq8lA5VR3r+K+n92IJb/FB7JmOHZ1l5GmXUGI8YDGzu2OFWBfLnjaFp1w9w/DhTWkNsgA=
X-Received: by 2002:a50:a693:0:b0:548:68a3:618e with SMTP id
 e19-20020a50a693000000b0054868a3618emr2333828edc.9.1700835788037; Fri, 24 Nov
 2023 06:23:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231115090735.2404866-1-chenhuacai@loongson.cn> <0f74ba84-a0fb-41cb-b22c-943f47c631da@infradead.org>
In-Reply-To: <0f74ba84-a0fb-41cb-b22c-943f47c631da@infradead.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 24 Nov 2023 22:22:58 +0800
X-Gmail-Original-Message-ID: <CAAhV-H63QkfSw+Esn8oW2PDEsCnTRPFqkj8X-x8i9cH3AS0k9w@mail.gmail.com>
Message-ID: <CAAhV-H63QkfSw+Esn8oW2PDEsCnTRPFqkj8X-x8i9cH3AS0k9w@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix build due to API changes
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Xuerui Wang <kernel@xen0n.name>, Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Paolo,

On Thu, Nov 16, 2023 at 3:48=E2=80=AFAM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
>
>
> On 11/15/23 01:07, Huacai Chen wrote:
> > Commit 8569992d64b8f750e34b7858eac ("KVM: Use gfn instead of hva for
> > mmu_notifier_retry") replaces mmu_invalidate_retry_hva() usage with
> > mmu_invalidate_retry_gfn() for X86, LoongArch also need similar changes
> > to fix build.
> >
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
I think this patch should go through your kvm tree rather than the
loongarch tree. Because the loongarch tree is based on 6.7 now, this
patch can fix a build error for kvm tree, but will cause a build error
on the loongarch tree.


Huacai

>
> Thanks.
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
> >       /* Check if an invalidation has taken place since we got pfn */
> >       spin_lock(&kvm->mmu_lock);
> > -     if (mmu_invalidate_retry_hva(kvm, mmu_seq, hva)) {
> > +     if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
> >               /*
> >                * This can happen when mappings are changed asynchronous=
ly, but
> >                * also synchronously if a COW is triggered by
>
> --
> ~Randy

