Return-Path: <kvm+bounces-20357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58749914262
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 08:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1221A281DB5
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 06:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A30931BDE6;
	Mon, 24 Jun 2024 06:00:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BB510E9
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 06:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719208844; cv=none; b=Qov4ed6ViEgUCBLM35mUUj37zdVnGrVFPCAhLSur3Q9OjQ5uTs/WCONlbhm/t8OfDdw2lj69DANchvECOYfikD22nYMqqdHJMwPs70PxHhapccWSzE21Xtn71DsfWciCoZQScLDhq6ET2BUlMA0C7OFlxFvyL8EeppVTx//4Q0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719208844; c=relaxed/simple;
	bh=lnUIAGpGezrkbBThtobhS90+6tFYz6MywL7+mhnalJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rLMI3MTlZnxoyYHXwTQxmlQYraLy6XsdONnJW05VsOONyVDdSfQU2mo5QVUYLO8OVYbXA0vLs6tZRFUzkSZLxjfgbeUI1geEWB/O7cQrVoTXX5trMnjS1ki1L+Dh3Dax0zS0KM/xQ7E/WR0EqYlFzdnmT8DuX9BlsIQWOc+vfo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [209.85.128.169])
	by gateway (Coremail) with SMTP id _____8Dxi+qGC3lmwG0JAA--.38421S3;
	Mon, 24 Jun 2024 14:00:39 +0800 (CST)
Received: from mail-yw1-f169.google.com (unknown [209.85.128.169])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxMMSCC3lmzMYuAA--.9677S3;
	Mon, 24 Jun 2024 14:00:35 +0800 (CST)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-64361817e78so11716457b3.1
        for <kvm@vger.kernel.org>; Sun, 23 Jun 2024 23:00:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVymqp0KIQjfzxjybqIv4vSqbrdsUAofRtU0NPtM12Me6+o3GExKRdiqaFeZAY/aq95G9BcTOqpEEmbo0v0e/BK5SyK
X-Gm-Message-State: AOJu0YySSpw2hvIqVmrRpBgctfJVZvegVBak2C6P6JU8ZZ/RPsQRvFZ8
	5sRf2ZS4XExgolSuScAgmLZsBMdAFJ3bwpDawkh18cTXlMsmuO1UVpj5AExxwCUoaEzji/3p66Z
	cnf37f0hYamMUcrn5qYsWfYrjbnChMx9mcKEWew==
X-Google-Smtp-Source: AGHT+IEWUjupNHuM3RdDGeChoM6aWZ8jhq3FZacRC/PBQZ7E8+aUc5gejhVZY1pssbnBdzZmMRhB+xmByyg51iJe2L4=
X-Received: by 2002:a05:690c:832:b0:628:c1f0:d8fd with SMTP id
 00721157ae682-643ac42dff3mr28386827b3.52.1719208833604; Sun, 23 Jun 2024
 23:00:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619080940.2690756-1-maobibo@loongson.cn> <20240619080940.2690756-5-maobibo@loongson.cn>
 <CAAhV-H74raJ9eEWEHr=aN6LhVvNUyP6TLEDH006M6AnoE8tkPg@mail.gmail.com>
 <58d34b7d-eaad-8aa8-46c3-9212664431be@loongson.cn> <CAAhV-H6CzPAxwymk16NfjPGO=oi+iBZJYsdSMiyp2N2cDsw54g@mail.gmail.com>
 <379d63cc-375f-3e97-006c-edf7edb4b202@loongson.cn> <CAAhV-H6vXMr5bviGoE1pojVswOkUWBkv9hOS4Jd-6Exb+G+1+g@mail.gmail.com>
In-Reply-To: <CAAhV-H6vXMr5bviGoE1pojVswOkUWBkv9hOS4Jd-6Exb+G+1+g@mail.gmail.com>
From: WANG Rui <wangrui@loongson.cn>
Date: Mon, 24 Jun 2024 14:00:22 +0800
X-Gmail-Original-Message-ID: <CAHirt9gKJdxoPCSB8dhNCTuyGOKFUZZkgQoOoQL4Wm64+CrdVA@mail.gmail.com>
Message-ID: <CAHirt9gKJdxoPCSB8dhNCTuyGOKFUZZkgQoOoQL4Wm64+CrdVA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] LoongArch: KVM: Add memory barrier before update
 pmd entry
To: Huacai Chen <chenhuacai@kernel.org>
Cc: maobibo <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:AQAAf8DxMMSCC3lmzMYuAA--.9677S3
X-CM-SenderInfo: pzdqw2txl6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw1xWry5Ar15AF4rJF13trc_yoWrCrWfpr
	ZrAF4qyF4kJryUGws2q3Wjvr10qryktF18X34Fq3WDZr90vw15tr1UJryakF17Ar95C3W8
	ZF4UKanxZ3WUA3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	JVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7BMNUUUUU

Hi,

On Mon, Jun 24, 2024 at 12:18=E2=80=AFPM Huacai Chen <chenhuacai@kernel.org=
> wrote:
>
> On Mon, Jun 24, 2024 at 10:21=E2=80=AFAM maobibo <maobibo@loongson.cn> wr=
ote:
> >
> >
> >
> > On 2024/6/24 =E4=B8=8A=E5=8D=889:56, Huacai Chen wrote:
> > > On Mon, Jun 24, 2024 at 9:37=E2=80=AFAM maobibo <maobibo@loongson.cn>=
 wrote:
> > >>
> > >>
> > >>
> > >> On 2024/6/23 =E4=B8=8B=E5=8D=886:18, Huacai Chen wrote:
> > >>> Hi, Bibo,
> > >>>
> > >>> On Wed, Jun 19, 2024 at 4:09=E2=80=AFPM Bibo Mao <maobibo@loongson.=
cn> wrote:
> > >>>>
> > >>>> When updating pmd entry such as allocating new pmd page or splitti=
ng
> > >>>> huge page into normal page, it is necessary to firstly update all =
pte
> > >>>> entries, and then update pmd entry.
> > >>>>
> > >>>> It is weak order with LoongArch system, there will be problem if o=
ther
> > >>>> vcpus sees pmd update firstly however pte is not updated. Here smp=
_wmb()
> > >>>> is added to assure this.
> > >>> Memory barriers should be in pairs in most cases. That means you ma=
y
> > >>> lose smp_rmb() in another place.
> > >> The idea adding smp_wmb() comes from function __split_huge_pmd_locke=
d()
> > >> in file mm/huge_memory.c, and the explanation is reasonable.
> > >>
> > >>                   ...
> > >>                   set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
> > >>           }
> > >>           ...
> > >>           smp_wmb(); /* make pte visible before pmd */
> > >>           pmd_populate(mm, pmd, pgtable);
> > >>
> > >> It is strange that why smp_rmb() should be in pairs with smp_wmb(),
> > >> I never hear this rule -:(
> > > https://docs.kernel.org/core-api/wrappers/memory-barriers.html
> > >
> > > SMP BARRIER PAIRING
> > > -------------------
> > >
> > > When dealing with CPU-CPU interactions, certain types of memory barri=
er should
> > > always be paired.  A lack of appropriate pairing is almost certainly =
an error.
> >     CPU 1                 CPU 2
> >          =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D       =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >          WRITE_ONCE(a, 1);
> >          <write barrier>
> >          WRITE_ONCE(b, 2);     x =3D READ_ONCE(b);
> >                                <read barrier>
> >                                y =3D READ_ONCE(a);
> >
> > With split_huge scenery to update pte/pmd entry, there is no strong
> > relationship between address ptex and pmd.
> > CPU1
> >       WRITE_ONCE(pte0, 1);
> >       WRITE_ONCE(pte511, 1);
> >       <write barrier>
> >       WRITE_ONCE(pmd, 2);
> >
> > However with page table walk scenery, address ptep depends on the
> > contents of pmd, so it is not necessary to add smp_rmb().
> >          ptep =3D pte_offset_map_lock(mm, pmd, address, &ptl);
> >          if (!ptep)
> >                  return no_page_table(vma, flags, address);
> >          pte =3D ptep_get(ptep);
> >          if (!pte_present(pte))
> >
> > It is just my option, or do you think where smp_rmb() barrier should be
> > added in page table reader path?
> There are some possibilities:
> 1. Read barrier is missing in some places;
> 2. Write barrier is also unnecessary here;
> 3. Read barrier is really unnecessary, but there is a better API to
> replace the write barrier;
> 4. Read barrier is really unnecessary, and write barrier is really the
> best API here.
>
> Maybe Rui Wang knows better here.

It appears that reading the pte address is data-dependent on the pmd,
rather than control-dependent. This creates an opportunity to omit the
read-side memory barrier.

Cheers,
-Rui


>
> Huacai
>
> >
> > Regards
> > Bibo Mao
> > >
> > >
> > > Huacai
> > >
> > >>
> > >> Regards
> > >> Bibo Mao
> > >>>
> > >>> Huacai
> > >>>
> > >>>>
> > >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> > >>>> ---
> > >>>>    arch/loongarch/kvm/mmu.c | 2 ++
> > >>>>    1 file changed, 2 insertions(+)
> > >>>>
> > >>>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> > >>>> index 1690828bd44b..7f04edfbe428 100644
> > >>>> --- a/arch/loongarch/kvm/mmu.c
> > >>>> +++ b/arch/loongarch/kvm/mmu.c
> > >>>> @@ -163,6 +163,7 @@ static kvm_pte_t *kvm_populate_gpa(struct kvm =
*kvm,
> > >>>>
> > >>>>                           child =3D kvm_mmu_memory_cache_alloc(cac=
he);
> > >>>>                           _kvm_pte_init(child, ctx.invalid_ptes[ct=
x.level - 1]);
> > >>>> +                       smp_wmb(); /* make pte visible before pmd =
*/
> > >>>>                           kvm_set_pte(entry, __pa(child));
> > >>>>                   } else if (kvm_pte_huge(*entry)) {
> > >>>>                           return entry;
> > >>>> @@ -746,6 +747,7 @@ static kvm_pte_t *kvm_split_huge(struct kvm_vc=
pu *vcpu, kvm_pte_t *ptep, gfn_t g
> > >>>>                   val +=3D PAGE_SIZE;
> > >>>>           }
> > >>>>
> > >>>> +       smp_wmb();
> > >>>>           /* The later kvm_flush_tlb_gpa() will flush hugepage tlb=
 */
> > >>>>           kvm_set_pte(ptep, __pa(child));
> > >>>>
> > >>>> --
> > >>>> 2.39.3
> > >>>>
> > >>
> > >>
> >
> >
>


