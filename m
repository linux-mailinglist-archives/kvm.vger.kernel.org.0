Return-Path: <kvm+bounces-58002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B184B843C2
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D3F41882387
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 10:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584BF2F5306;
	Thu, 18 Sep 2025 10:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VxztcsO6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9802264CC
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192886; cv=none; b=ICEhYdYWj4lgmu0hvCWO7vQR1bEDrOA1hnhGj6U+iO6ZOkMYIstXFt/tRUzekE/AoTGKoJ/NfvAuSvKL9dqeZ9CStttforxbgohNe1LbOb0KLk6QWUAgbYW7blbOjMGkT9GXnOc5sSDmQONVeKnMVmTntPaamh28EU3mHgqEydU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192886; c=relaxed/simple;
	bh=k2ASZVr05LW1WBbf71NbgtR7vTPfPePngtU5VfeZDO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q36JNYJOgZiwxSqvxhEEk/UHjj1UqwCOWfbqrhDVdk1Hvdp/CvGr6pgAoN2EkCdm/WvnTxmKd2QlMfzGyHN5NZYhbqp8g8CGuQa/RS69QiMChLqWYaWavfBYaMarKtZdrHPkGTGfy052u37X0JASCUCSmDIyjApJQTqCSZmxGpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VxztcsO6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34388C4AF09
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758192886;
	bh=k2ASZVr05LW1WBbf71NbgtR7vTPfPePngtU5VfeZDO8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VxztcsO6jbSYStnxrqULNQ0wUptjkY7o1HkK4N7WvROL2CTnBdFFRX7JCT+XA+qz7
	 p+mx0j+fiK7PipFT1RTor2+zRTwfo5jwvNV+ib4IShiA9YX18xZSBgnZmW37LUAc4D
	 1kweIqmXxBqx56AYojyOLu1BgTEYXD93lyofP1JywaG7zyJr5D2ddq+45XVmpQYL0M
	 6htdUYe8zBB1e1wO+Gxz+HPKx8szSS94/zuMqnu3F3bM1N46GpUjMHKMN0rCKxnuyL
	 ehooQZL+ZSkOooQ2GpmtuQEiOPrGmAPErb8OgxbXOZ/BBvh30hA18NUTwuW5lbCUhd
	 QWur76L/p99vg==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b0787fa12e2so128301566b.2
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 03:54:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXugM11RwruxV0ex7kqC8WLBfbSdB0n2meimWj3Y0Zo7Fj+p9BsQNkKOmeKDiIOijCxL0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkGtRndLyRU1eBksVBkanc+mZMqAwMCMVfpaa6KtcyJe92qH1D
	JfJ9dpjAGuZwFEmxHMQmATb92E31Qa46GXNAWipoLy6yEnT6R1EUUbQdRJvMEBjoP4KbWTJP4fF
	3LFBD7C8mLd3R8FfzaGYpAwcG8gWEu6U=
X-Google-Smtp-Source: AGHT+IEwYM+SsguLP9WE94m8pZ+ESbFpNR6hzuBrMSj45TkgJFbhd2aYOB6dLmhp86ztV2jUtUH3o3wezWViL5/a5Q0=
X-Received: by 2002:a17:907:60cf:b0:b04:8358:7d96 with SMTP id
 a640c23a62f3a-b1bb935d92dmr659001066b.51.1758192884648; Thu, 18 Sep 2025
 03:54:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910071429.3925025-1-maobibo@loongson.cn> <CAAhV-H65H_iREuETGU_v9oZdaPFoQj1VZV46XSNTC8ppENXzuQ@mail.gmail.com>
 <3d3a72c2-7c91-7640-5f0b-7b95bd5f0d2e@loongson.cn> <CAAhV-H4bEyeV7WkfSNBJnicMhhnSwj3PEr9K4ZpXwto1=JyWUw@mail.gmail.com>
 <ff12ec30-b0df-aedd-a713-4fb77a4e092a@loongson.cn>
In-Reply-To: <ff12ec30-b0df-aedd-a713-4fb77a4e092a@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 18 Sep 2025 18:54:29 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7AhUijxaW5oS6s4hCtWyEOgx8iaku2KhbK_6mZbRHYHQ@mail.gmail.com>
X-Gm-Features: AS18NWAHCY3XIcsMOxrKzimbMXi0_bnNV7f7D5EuQM_0abl4FsluSSfxiqbpD6E
Message-ID: <CAAhV-H7AhUijxaW5oS6s4hCtWyEOgx8iaku2KhbK_6mZbRHYHQ@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix VM migration failure with PTW enabled
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 9:11=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/9/16 =E4=B8=8B=E5=8D=8810:21, Huacai Chen wrote:
> > On Mon, Sep 15, 2025 at 9:22=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >>
> >>
> >> On 2025/9/14 =E4=B8=8A=E5=8D=889:57, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Wed, Sep 10, 2025 at 3:14=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> With PTW disabled system, bit Dirty is HW bit for page writing, howe=
ver
> >>>> with PTW enabled system, bit Write is HW bit for page writing. Previ=
ously
> >>>> bit Write is treated as SW bit to record page writable attribute for=
 fast
> >>>> page fault handling in the secondary MMU, however with PTW enabled m=
achine,
> >>>> this bit is used by HW already.
> >>>>
> >>>> Here define KVM_PAGE_SOFT_WRITE with SW bit _PAGE_MODIFIED, so that =
it can
> >>>> work on both PTW disabled and enabled machines. And with HW write bi=
t, both
> >>>> bit Dirty and Write is set or clear.
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/include/asm/kvm_mmu.h | 20 ++++++++++++++++----
> >>>>    arch/loongarch/kvm/mmu.c             |  8 ++++----
> >>>>    2 files changed, 20 insertions(+), 8 deletions(-)
> >>>>
> >>>> diff --git a/arch/loongarch/include/asm/kvm_mmu.h b/arch/loongarch/i=
nclude/asm/kvm_mmu.h
> >>>> index 099bafc6f797..efcd593c42b1 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_mmu.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_mmu.h
> >>>> @@ -16,6 +16,13 @@
> >>>>     */
> >>>>    #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1=
)
> >>>>
> >>>> +/*
> >>>> + * _PAGE_MODIFIED is SW pte bit, it records page ever written on ho=
st
> >>>> + * kernel, on secondary MMU it records page writable in order to fa=
st
> >>>> + * path handling
> >>>> + */
> >>>> +#define KVM_PAGE_SOFT_WRITE    _PAGE_MODIFIED
> >>> KVM_PAGE_WRITEABLE is more suitable.
> >> both are ok for me.
> >>>
> >>>> +
> >>>>    #define _KVM_FLUSH_PGTABLE     0x1
> >>>>    #define _KVM_HAS_PGMASK                0x2
> >>>>    #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) | pgprot=
_val(prot))
> >>>> @@ -52,11 +59,16 @@ static inline void kvm_set_pte(kvm_pte_t *ptep, =
kvm_pte_t val)
> >>>>           WRITE_ONCE(*ptep, val);
> >>>>    }
> >>>>
> >>>> -static inline int kvm_pte_write(kvm_pte_t pte) { return pte & _PAGE=
_WRITE; }
> >>>> -static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & _PAGE=
_DIRTY; }
> >>>> +static inline int kvm_pte_soft_write(kvm_pte_t pte) { return pte & =
KVM_PAGE_SOFT_WRITE; }
> >>> The same, kvm_pte_mkwriteable() is more suitable.
> >> kvm_pte_writable()  here ?  and kvm_pte_mkwriteable() for the bellowin=
g
> >> sentense.
> >>
> >> If so, that is ok, both are ok for me.
> > Yes.
> >
> >>>
> >>>> +static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & __WRI=
TEABLE; }
> >>> _PAGE_DIRTY and _PAGE_WRITE are always set/cleared at the same time,
> >>> so the old version still works.
> >> Although it is workable, I still want to remove single bit _PAGE_DIRTY
> >> checking here.
> > I want to check a single bit because "kvm_pte_write() return
> > _PAGE_WRITE and kvm_pte_dirty() return _PAGE_DIRTY" looks more
> > natural.
> kvm_pte_write() is not needed any more and removed here. This is only
> kvm_pte_writable() to check software writable bit, kvm_pte_dirty() to
> check HW write bit.
>
> There is no reason to check single bit with _PAGE_WRITE or _PAGE_DIRTY,
> since there is different meaning on machines with/without HW PTW.
Applied together with other patches, you can test it.
https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.g=
it/log/?h=3Dloongarch-next

Huacai

>
> Regards
> Bibo Mao
> >
> > You may argue that kvm_pte_mkdirty() set both _PAGE_WRITE and
> > _PAGE_DIRTY so kvm_pte_dirty() should also return both. But I think
> > kvm_pte_mkdirty() in this patch is just a "reasonable optimization".
> > Because strictly speaking, we need both kvm_pte_mkdirty() and
> > kvm_pte_mkwrite() and call the pair when needed.
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>>>    static inline int kvm_pte_young(kvm_pte_t pte) { return pte & _PA=
GE_ACCESSED; }
> >>>>    static inline int kvm_pte_huge(kvm_pte_t pte) { return pte & _PAG=
E_HUGE; }
> >>>>
> >>>> +static inline kvm_pte_t kvm_pte_mksoft_write(kvm_pte_t pte)
> >>>> +{
> >>>> +       return pte | KVM_PAGE_SOFT_WRITE;
> >>>> +}
> >>>> +
> >>>>    static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
> >>>>    {
> >>>>           return pte | _PAGE_ACCESSED;
> >>>> @@ -69,12 +81,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t =
pte)
> >>>>
> >>>>    static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
> >>>>    {
> >>>> -       return pte | _PAGE_DIRTY;
> >>>> +       return pte | __WRITEABLE;
> >>>>    }
> >>>>
> >>>>    static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
> >>>>    {
> >>>> -       return pte & ~_PAGE_DIRTY;
> >>>> +       return pte & ~__WRITEABLE;
> >>>>    }
> >>>>
> >>>>    static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
> >>>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> >>>> index ed956c5cf2cc..68749069290f 100644
> >>>> --- a/arch/loongarch/kvm/mmu.c
> >>>> +++ b/arch/loongarch/kvm/mmu.c
> >>>> @@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu *vc=
pu, unsigned long gpa, bool writ
> >>>>           /* Track access to pages marked old */
> >>>>           new =3D kvm_pte_mkyoung(*ptep);
> >>>>           if (write && !kvm_pte_dirty(new)) {
> >>>> -               if (!kvm_pte_write(new)) {
> >>>> +               if (!kvm_pte_soft_write(new)) {
> >>>>                           ret =3D -EFAULT;
> >>>>                           goto out;
> >>>>                   }
> >>>> @@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, u=
nsigned long gpa, bool write)
> >>>>                   prot_bits |=3D _CACHE_SUC;
> >>>>
> >>>>           if (writeable) {
> >>>> -               prot_bits |=3D _PAGE_WRITE;
> >>>> +               prot_bits =3D kvm_pte_mksoft_write(prot_bits);
> >>>>                   if (write)
> >>>> -                       prot_bits |=3D __WRITEABLE;
> >>>> +                       prot_bits =3D kvm_pte_mkdirty(prot_bits);
> >>>>           }
> >>>>
> >>>>           /* Disable dirty logging on HugePages */
> >>>> @@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, u=
nsigned long gpa, bool write)
> >>>>           kvm_release_faultin_page(kvm, page, false, writeable);
> >>>>           spin_unlock(&kvm->mmu_lock);
> >>>>
> >>>> -       if (prot_bits & _PAGE_DIRTY)
> >>>> +       if (kvm_pte_dirty(prot_bits))
> >>>>                   mark_page_dirty_in_slot(kvm, memslot, gfn);
> >>>>
> >>>>    out:
> >>> To save time, I just change the whole patch like this, you can confir=
m
> >>> whether it woks:
> >>>
> >>> diff --git a/arch/loongarch/include/asm/kvm_mmu.h
> >>> b/arch/loongarch/include/asm/kvm_mmu.h
> >>> index 099bafc6f797..882f60c72b46 100644
> >>> --- a/arch/loongarch/include/asm/kvm_mmu.h
> >>> +++ b/arch/loongarch/include/asm/kvm_mmu.h
> >>> @@ -16,6 +16,13 @@
> >>>     */
> >>>    #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1)
> >>>
> >>> +/*
> >>> + * _PAGE_MODIFIED is SW pte bit, it records page ever written on hos=
t
> >>> + * kernel, on secondary MMU it records page writable in order to fas=
t
> >>> + * path handling
> >>> + */
> >>> +#define KVM_PAGE_WRITEABLE     _PAGE_MODIFIED
> >>> +
> >>>    #define _KVM_FLUSH_PGTABLE     0x1
> >>>    #define _KVM_HAS_PGMASK                0x2
> >>>    #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) |
> >>> pgprot_val(prot))
> >>> @@ -56,6 +63,7 @@ static inline int kvm_pte_write(kvm_pte_t pte) {
> >>> return pte & _PAGE_WRITE; }
> >>>    static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte &
> >>> _PAGE_DIRTY; }
> >>>    static inline int kvm_pte_young(kvm_pte_t pte) { return pte &
> >>> _PAGE_ACCESSED; }
> >>>    static inline int kvm_pte_huge(kvm_pte_t pte) { return pte &
> >>> _PAGE_HUGE; }
> >>> +static inline int kvm_pte_writeable(kvm_pte_t pte) { return pte &
> >>> KVM_PAGE_WRITEABLE; }
> >>>
> >>>    static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
> >>>    {
> >>> @@ -69,12 +77,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t
> >>> pte)
> >>>
> >>>    static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
> >>>    {
> >>> -       return pte | _PAGE_DIRTY;
> >>> +       return pte | __WRITEABLE;
> >>>    }
> >>>
> >>>    static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
> >>>    {
> >>> -       return pte & ~_PAGE_DIRTY;
> >>> +       return pte & ~__WRITEABLE;
> >>>    }
> >>>
> >>>    static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
> >>> @@ -87,6 +95,11 @@ static inline kvm_pte_t kvm_pte_mksmall(kvm_pte_t
> >>> pte)
> >>>           return pte & ~_PAGE_HUGE;
> >>>    }
> >>>
> >>> +static inline kvm_pte_t kvm_pte_mkwriteable(kvm_pte_t pte)
> >>> +{
> >>> +       return pte | KVM_PAGE_WRITEABLE;
> >>> +}
> >>> +
> >>>    static inline int kvm_need_flush(kvm_ptw_ctx *ctx)
> >>>    {
> >>>           return ctx->flag & _KVM_FLUSH_PGTABLE;
> >>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> >>> index ed956c5cf2cc..7c8143e79c12 100644
> >>> --- a/arch/loongarch/kvm/mmu.c
> >>> +++ b/arch/loongarch/kvm/mmu.c
> >>> @@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu
> >>> *vcpu, unsigned long gpa, bool writ
> >>>           /* Track access to pages marked old */
> >>>           new =3D kvm_pte_mkyoung(*ptep);
> >>>           if (write && !kvm_pte_dirty(new)) {
> >>> -               if (!kvm_pte_write(new)) {
> >>> +               if (!kvm_pte_writeable(new)) {
> >>>                           ret =3D -EFAULT;
> >>>                           goto out;
> >>>                   }
> >>> @@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
> >>> unsigned long gpa, bool write)
> >>>                   prot_bits |=3D _CACHE_SUC;
> >>>
> >>>           if (writeable) {
> >>> -               prot_bits |=3D _PAGE_WRITE;
> >>> +               prot_bits =3D kvm_pte_mkwriteable(prot_bits);
> >>>                   if (write)
> >>> -                       prot_bits |=3D __WRITEABLE;
> >>> +                       prot_bits =3D kvm_pte_mkdirty(prot_bits);
> >>>           }
> >>>
> >>>           /* Disable dirty logging on HugePages */
> >>> @@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
> >>> unsigned long gpa, bool write)
> >>>           kvm_release_faultin_page(kvm, page, false, writeable);
> >>>           spin_unlock(&kvm->mmu_lock);
> >>>
> >>> -       if (prot_bits & _PAGE_DIRTY)
> >>> +       if (kvm_pte_dirty(prot_bits))
> >>>                   mark_page_dirty_in_slot(kvm, memslot, gfn);
> >>>
> >>>    out:
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>> base-commit: 9dd1835ecda5b96ac88c166f4a87386f3e727bd9
> >>>> --
> >>>> 2.39.3
> >>>>
> >>>>
> >>
>
>

