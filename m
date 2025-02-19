Return-Path: <kvm+bounces-38544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59609A3AFAC
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 03:36:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36B52188C502
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6E3819149F;
	Wed, 19 Feb 2025 02:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="qktJbkdw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF8F157A55
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 02:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739932600; cv=none; b=s38M3eMCZtmi23Lb2JqAQ8DvSrbSs4ZsQamlEZpau1bKb0rlO9OvyY4TE4kmq7fPKZPAlQR3bzogRLis85IuJ4TjIcLiufsF+kyvYFeyYXMv93IxC0GhI3UecdtPi0EJqTS22qEb5px92w5X0iSb+2vuuQDGlV8ARlW13maiVGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739932600; c=relaxed/simple;
	bh=rveXvfpNgj3V/3uXAGCU7hGmO4dBjIcMbwqqZkqK26s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UZN3/OOVORVmnm1IlhyBS6yuzSItlRflx5AXCoUiKlfMkB3mzJYEzMTycFboKxQWWyP5Kb/jkbtbhzOuVMnVg1QVzLh9xM1FDBOOqi+dX7BePD+IECtuDkczq0ziK2oP1G5yIIwORjQsbd3QN9PxZ6oN6Q9Gyqj6sQv3VibVWDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=qktJbkdw; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EA2714012C
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 02:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1739932595;
	bh=vf1qvK2by+jGV65Pqs0eS1MS94gVUz7y9vFh+Qb3c+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=qktJbkdwNbeRr6cAwvD0TgeJ8Ykk0sx1wwLgfc8mWoPMKVnnoG65HDUml6STTMloT
	 ZGTWmzzythbINA8stwbDdGFG5DGQYxZWAWVQRVSgPqE6FxeGvO6BT0pKvZq7qfuLWK
	 TFHDh2g3O4POoj2KkHkaDX9ZnZGp/3qWknyD9yjVkA89+vc0HplZQGP3EBPJ5hckNR
	 iBfHo++OxXGo4ytqzUMaVsS6YCeTznY+2tPvwer7sgBtG5PDz9VCDU6oNzCKQpDDb6
	 soaRBYIgN0utILRzxzyVnjLaYJXs3Fb652y/UeOWGX1ONrc90vzm0prMgO6tfNAFi7
	 xEhzFajBgiCmw==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5d9fb24f87bso6370971a12.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 18:36:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739932594; x=1740537394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vf1qvK2by+jGV65Pqs0eS1MS94gVUz7y9vFh+Qb3c+8=;
        b=VHn8sdmYZ91zKVfk0HhQBIUTE7bV3fSw9pWgI4YrJEJXX9q9QqYdRzqTCaNHtnc+cp
         S3MO8pBd1CHIkG4598EMqO7sG0zPNceCP8S2eOkQkAoklYd/hxWghqvk2ok+BnDmiRNo
         gojm1Gy8DmlSTpLMXBbvxoZS7jDRVsa3QaEEDfWLRAvxbselcTMzq9Y6zIF7CipQjM2/
         696jprh5vcPY3R14fWyhwm/rhv/r3LsnKohZxGHXVuAr0RrsbB8YiBpB9U2pxNg6vLBM
         OLiZrhZDEzsDaW9hGSiqULyAlyDmFFpHZRzGkiEndu87AIo+s1lEhDPmJER4NgvYjjsL
         tTWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFbRv1I6pZiokJgGzDGnBdH+GLRos2NGL+GIXzurJ8moyw1VzkRyNzz658BOxeBXvZxwE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy6k1wGoHG7iNfFIJtYu4Ds33FqzeUnNEyzHyE+qP62mln1oJ5
	uJ4lNiXDHVl2wu41Z/k6jwFGYcj59gDXVxVdkJbHRHo+B6p1W08TYyssOrLcMAGEB82cJG7xvO4
	/GP3pbLJZB5JKMhOHC9rFC6hMgrVAeL4NUg0Rs2x6DYxo0Z9Ya2RgNYFMpy0JDzNpDVymCuXTkp
	RanI5LWiB7SNDgDZrJllRqVC9wXZnM7KsuquEMsQaBgwmgN27E
X-Gm-Gg: ASbGncvq4AEOXa/NkXgO2tEQ1ruRHhRZ+7cnHIdjn8F31uzIOCdkJK3llsBN6hm8yaH
	noVWALvgDZU/UlCFNJga7q8aeeMiFwjDkdHenFHv69gAjYfSfArOzcdHVQT79
X-Received: by 2002:a05:6402:520e:b0:5dc:7fbe:72ff with SMTP id 4fb4d7f45d1cf-5e0894f7a93mr1494021a12.2.1739932594167;
        Tue, 18 Feb 2025 18:36:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGoq/ug3HpCJUOAUDpRyTkhBQF1qeEo0BUuVH4+X+SQxLUDIiWnGDZ38SmRisv8NVYqjTO25htXjWKz7FVPjZg=
X-Received: by 2002:a05:6402:520e:b0:5dc:7fbe:72ff with SMTP id
 4fb4d7f45d1cf-5e0894f7a93mr1494002a12.2.1739932593834; Tue, 18 Feb 2025
 18:36:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-7-alex.williamson@redhat.com> <Z7UOEpgH5pdTBcJP@x1.local>
 <20250218161407.6ae2b082.alex.williamson@redhat.com>
In-Reply-To: <20250218161407.6ae2b082.alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Tue, 18 Feb 2025 20:36:22 -0600
X-Gm-Features: AWEUYZkz1cZnARvZskS0-aLz8NUwEBuzeFL49ZTvzIP2huZXOoCnDbKLjmz8aDk
Message-ID: <CAHTA-ua8mTgNkDs0g=_8gMyT1NkgZqCE0J7QjOU=+cmZ2xqd7Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] vfio/type1: Use mapping page mask for pfnmaps
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	clg@redhat.com, jgg@nvidia.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

/s/follow_pfnmap_args.pgmask/follow_pfnmap_args.addr_mask/ in v2
commit log. Aside from that, it works as expected.

Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>


On Tue, Feb 18, 2025 at 5:14=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Tue, 18 Feb 2025 17:47:46 -0500
> Peter Xu <peterx@redhat.com> wrote:
>
> > On Tue, Feb 18, 2025 at 03:22:06PM -0700, Alex Williamson wrote:
> > > vfio-pci supports huge_fault for PCI MMIO BARs and will insert pud an=
d
> > > pmd mappings for well aligned mappings.  follow_pfnmap_start() walks =
the
> > > page table and therefore knows the page mask of the level where the
> > > address is found and returns this through follow_pfnmap_args.pgmask.
> > > Subsequent pfns from this address until the end of the mapping page a=
re
> > > necessarily consecutive.  Use this information to retrieve a range of
> > > pfnmap pfns in a single pass.
> > >
> > > With optimal mappings and alignment on systems with 1GB pud and 4KB
> > > page size, this reduces iterations for DMA mapping PCI BARs by a
> > > factor of 256K.  In real world testing, the overhead of iterating
> > > pfns for a VM DMA mapping a 32GB PCI BAR is reduced from ~1s to
> > > sub-millisecond overhead.
> > >
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > >  drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++-------
> > >  1 file changed, 16 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iomm=
u_type1.c
> > > index ce661f03f139..0ac56072af9f 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -520,7 +520,7 @@ static void vfio_batch_fini(struct vfio_batch *ba=
tch)
> > >
> > >  static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_st=
ruct *mm,
> > >                         unsigned long vaddr, unsigned long *pfn,
> > > -                       bool write_fault)
> > > +                       unsigned long *addr_mask, bool write_fault)
> > >  {
> > >     struct follow_pfnmap_args args =3D { .vma =3D vma, .address =3D v=
addr };
> > >     int ret;
> > > @@ -544,10 +544,12 @@ static int follow_fault_pfn(struct vm_area_stru=
ct *vma, struct mm_struct *mm,
> > >                     return ret;
> > >     }
> > >
> > > -   if (write_fault && !args.writable)
> > > +   if (write_fault && !args.writable) {
> > >             ret =3D -EFAULT;
> > > -   else
> > > +   } else {
> > >             *pfn =3D args.pfn;
> > > +           *addr_mask =3D args.addr_mask;
> > > +   }
> > >
> > >     follow_pfnmap_end(&args);
> > >     return ret;
> > > @@ -590,15 +592,22 @@ static long vaddr_get_pfns(struct mm_struct *mm=
, unsigned long vaddr,
> > >     vma =3D vma_lookup(mm, vaddr);
> > >
> > >     if (vma && vma->vm_flags & VM_PFNMAP) {
> > > -           ret =3D follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMM=
U_WRITE);
> > > +           unsigned long addr_mask;
> > > +
> > > +           ret =3D follow_fault_pfn(vma, mm, vaddr, pfn, &addr_mask,
> > > +                                  prot & IOMMU_WRITE);
> > >             if (ret =3D=3D -EAGAIN)
> > >                     goto retry;
> > >
> > >             if (!ret) {
> > > -                   if (is_invalid_reserved_pfn(*pfn))
> > > -                           ret =3D 1;
> > > -                   else
> > > +                   if (is_invalid_reserved_pfn(*pfn)) {
> > > +                           unsigned long epfn;
> > > +
> > > +                           epfn =3D (*pfn | (~addr_mask >> PAGE_SHIF=
T)) + 1;
> > > +                           ret =3D min_t(long, npages, epfn - *pfn);
> >
> > s/long/unsigned long/?
>
> ret is signed long since it's the function return and needs to be able
> to return -errno, so long was the intention here.  Thanks,
>
> Alex
>
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> >
> > > +                   } else {
> > >                             ret =3D -EFAULT;
> > > +                   }
> > >             }
> > >     }
> > >  done:
> > > --
> > > 2.48.1
> > >
> >
>


--
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

