Return-Path: <kvm+bounces-4759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D18381800F
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 04:07:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9601C1C22E25
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 03:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746384C78;
	Tue, 19 Dec 2023 03:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BBDzKc04"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBFB8460;
	Tue, 19 Dec 2023 03:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A90C433C9;
	Tue, 19 Dec 2023 03:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702955218;
	bh=RzxTf7RhaILeV9wCyhzQyl7++g8TNQNbq8hRWOyQd+M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BBDzKc04EME67QqQKtCaIS71J1L60KEaYd3UbCWUwUF6VeK1yfEc+khWnoYQA6k9g
	 O1Xu/e8erSPVa6IP4Sqg2jaJjjVaVFhmmCpTDOZOeOXJZPrzeF8sL8S6MAcs2eEtGy
	 Y3rCNuQd1/FsvoVq2iP6SwrVBrHKSsjiDEr5FpVz9YpLBqJAxS93Hll6WS1QURlNtD
	 O777tF/XUlAf+TLzwj4AoC8R9q3Z/EXNM6bF9DnODtHCP5KBMd9itDka5EklGUTbWR
	 n/LoPxax/nW0+PqoFyRy5Bugu6JNJ5lgY423z1/jxeoMMn/qaC39s/uJRs7vGiGRFy
	 tKtB6xGL5GdnA==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50e2ce4fb22so3594267e87.1;
        Mon, 18 Dec 2023 19:06:58 -0800 (PST)
X-Gm-Message-State: AOJu0YykKaqS5Q4dBOiKfFEPGlSXAiIJcDeus4sla8ZaGeagcUEd9PKv
	TfLzvfytyTDpAr52LSKI+Awa3boSjo/ZvkYe7PU=
X-Google-Smtp-Source: AGHT+IEk9tQlIMI9LFzQsHZ87oxZ2QTHtDV5rI1Dp8W1kZOWPN+LWRK4WWaazQRJIsOhShr35OG2IPzZlnxJ6etd6v4=
X-Received: by 2002:ac2:42c7:0:b0:50e:3659:8657 with SMTP id
 n7-20020ac242c7000000b0050e36598657mr1453178lfl.21.1702955216361; Mon, 18 Dec
 2023 19:06:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231115090735.2404866-1-chenhuacai@loongson.cn> <15ba5868-42de-4563-9903-ccd0297e2075@infradead.org>
In-Reply-To: <15ba5868-42de-4563-9903-ccd0297e2075@infradead.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 19 Dec 2023 11:06:43 +0800
X-Gmail-Original-Message-ID: <CAAhV-H57PxrGPQMSvxUS2eJFCETYYUAyc=oxxu5fX1akuUCAng@mail.gmail.com>
Message-ID: <CAAhV-H57PxrGPQMSvxUS2eJFCETYYUAyc=oxxu5fX1akuUCAng@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix build due to API changes
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Xuerui Wang <kernel@xen0n.name>, Jiaxun Yang <jiaxun.yang@flygoat.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Randy,

On Sat, Dec 16, 2023 at 1:08=E2=80=AFPM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
> Hi,
>
> Someone please merge this patch...
> Thanks.
I prepared loongarch-kvm changes for 6.8 and the base is 6.7-rc6 [1],
If I merge this patch then the loongarch-next branch will build fail.
So I think this patch should be merged to Paolo's next branch in his
kvm tree.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongs=
on.git/log/?h=3Dloongarch-next

Huacai

>
>
> On 11/15/23 01:07, Huacai Chen wrote:
> > Commit 8569992d64b8f750e34b7858eac ("KVM: Use gfn instead of hva for
> > mmu_notifier_retry") replaces mmu_invalidate_retry_hva() usage with
> > mmu_invalidate_retry_gfn() for X86, LoongArch also need similar changes
> > to fix build.
> >
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
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
> #Randy
> https://people.kernel.org/tglx/notes-about-netiquette
> https://subspace.kernel.org/etiquette.html

