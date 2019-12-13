Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8882911E9EE
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 19:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfLMSNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:13:25 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45254 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbfLMSNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 13:13:25 -0500
Received: by mail-oi1-f196.google.com with SMTP id v10so1551761oiv.12
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 10:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w1cqQGOHLxt9WnlMRPGWtbihZqq/TPUJMIUsmupkqQc=;
        b=Z37IwFuamUtHj2UGycAzTlRIcOH/54EKCkDpaxP7Qp3MLa22kc/Usl9HnTrRe+y3QV
         jmlzBiBcgKWz0AkFOWkABdgtG4hYJTy1l4UIT6yWZWyPw9dRV6jw8VgbCyBLWLKiWGEX
         vM6Poow6sLwsq/ysxLVntPEkC62ExQjZKQkH6702/0HtxVqhTzpHmVb6lnPrLaCqpsEL
         zgjoMLNDG4MeH71UbAFhH4TqD4PJMpQDpjWWrZvQirUHWydeRNzmnynyQH4+Xkyz7ims
         L+1U3HsYxKKlN5qI/Ha+t6ww7rmUaJZ9hBlYoQDd0mpeknpPM1bHMMTuLHN+KJ75i+eW
         EFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w1cqQGOHLxt9WnlMRPGWtbihZqq/TPUJMIUsmupkqQc=;
        b=s3ywSBhUeBdxRJvJ70k2CKzjTvPB3/fL/pGRZ9MPL8rhfUQLZaYEIuBb2nPFEPDaip
         pAe1DPNUJDf4ovwvXGa4CKL4lVdROM2g8LGVAu+Ptp42fFF/qDHeAXqEusxMs6sHjZh0
         FItQ/viNjlocBGfmFT6jnPJIO/2AOUCWOcEGJqjqkkIhr6+YnLFiLqmNY2C9fEv3hetB
         wbVzClHLcIuScuIOCsqGxgiQ8OfP6fzc3JWxZeQ3E4OIj9DHBJShok5sH5/+vOZYbZxq
         M9zlx6hlPcArHLpUjFpe400LeHN+LEjElkaPSYndAMdQ09cDFKuauqEOdwXc/MLDYYPi
         SSUw==
X-Gm-Message-State: APjAAAVQk9PsfdadRpYiiENddW7UH5if6+Ttw6f0+B5PGeNXWGkzuDNU
        t994yz2u5apCuXtMUdk2Gb65RdbMByUoQW+zQEmlNA==
X-Google-Smtp-Source: APXvYqxZoubPWEAIaOvxFMZ9FPSoIReuNH6FLAi59sGYLvNzO+lWknFm2sHcIblMBoPXq/5GgUFCfD2MPq696t8Tmuc=
X-Received: by 2002:aca:4c9:: with SMTP id 192mr7971550oie.105.1576260803989;
 Fri, 13 Dec 2019 10:13:23 -0800 (PST)
MIME-Version: 1.0
References: <20191212182238.46535-1-brho@google.com> <20191212182238.46535-2-brho@google.com>
 <20191213174702.GB31552@linux.intel.com>
In-Reply-To: <20191213174702.GB31552@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 13 Dec 2019 10:13:13 -0800
Message-ID: <CAPcyv4ia3mp9d24fBiSXh2m_T4sLHnJHeg6VLw2AZmk8DAD7qQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] mm: make dev_pagemap_mapping_shift() externally visible
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Barret Rhoden <brho@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zeng, Jason" <jason.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 13, 2019 at 9:47 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Dec 12, 2019 at 01:22:37PM -0500, Barret Rhoden wrote:
> > KVM has a use case for determining the size of a dax mapping.
> >
> > The KVM code has easy access to the address and the mm, and
> > dev_pagemap_mapping_shift() needs only those parameters.  It was
> > deriving them from page and vma.  This commit changes those parameters
> > from (page, vma) to (address, mm).
> >
> > Signed-off-by: Barret Rhoden <brho@google.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> > Acked-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  include/linux/mm.h  |  3 +++
> >  mm/memory-failure.c | 38 +++-----------------------------------
> >  mm/util.c           | 34 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 40 insertions(+), 35 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index a2adf95b3f9c..bfd1882dd5c6 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1013,6 +1013,9 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
> >  #define page_ref_zero_or_close_to_overflow(page) \
> >       ((unsigned int) page_ref_count(page) + 127u <= 127u)
> >
> > +unsigned long dev_pagemap_mapping_shift(unsigned long address,
> > +                                     struct mm_struct *mm);
> > +
> >  static inline void get_page(struct page *page)
> >  {
> >       page = compound_head(page);
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 3151c87dff73..bafa464c8290 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -261,40 +261,6 @@ void shake_page(struct page *p, int access)
> >  }
> >  EXPORT_SYMBOL_GPL(shake_page);
> >
> > -static unsigned long dev_pagemap_mapping_shift(struct page *page,
> > -             struct vm_area_struct *vma)
> > -{
> > -     unsigned long address = vma_address(page, vma);
> > -     pgd_t *pgd;
> > -     p4d_t *p4d;
> > -     pud_t *pud;
> > -     pmd_t *pmd;
> > -     pte_t *pte;
> > -
> > -     pgd = pgd_offset(vma->vm_mm, address);
> > -     if (!pgd_present(*pgd))
> > -             return 0;
> > -     p4d = p4d_offset(pgd, address);
> > -     if (!p4d_present(*p4d))
> > -             return 0;
> > -     pud = pud_offset(p4d, address);
> > -     if (!pud_present(*pud))
> > -             return 0;
> > -     if (pud_devmap(*pud))
> > -             return PUD_SHIFT;
> > -     pmd = pmd_offset(pud, address);
> > -     if (!pmd_present(*pmd))
> > -             return 0;
> > -     if (pmd_devmap(*pmd))
> > -             return PMD_SHIFT;
> > -     pte = pte_offset_map(pmd, address);
> > -     if (!pte_present(*pte))
> > -             return 0;
> > -     if (pte_devmap(*pte))
> > -             return PAGE_SHIFT;
> > -     return 0;
> > -}
> > -
> >  /*
> >   * Failure handling: if we can't find or can't kill a process there's
> >   * not much we can do.       We just print a message and ignore otherwise.
> > @@ -324,7 +290,9 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
> >       }
> >       tk->addr = page_address_in_vma(p, vma);
> >       if (is_zone_device_page(p))
> > -             tk->size_shift = dev_pagemap_mapping_shift(p, vma);
> > +             tk->size_shift =
> > +                     dev_pagemap_mapping_shift(vma_address(page, vma),
> > +                                               vma->vm_mm);
> >       else
> >               tk->size_shift = compound_order(compound_head(p)) + PAGE_SHIFT;
> >
> > diff --git a/mm/util.c b/mm/util.c
> > index 3ad6db9a722e..59984e6b40ab 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -901,3 +901,37 @@ int memcmp_pages(struct page *page1, struct page *page2)
> >       kunmap_atomic(addr1);
> >       return ret;
> >  }
> > +
> > +unsigned long dev_pagemap_mapping_shift(unsigned long address,
> > +                                     struct mm_struct *mm)
> > +{
> > +     pgd_t *pgd;
> > +     p4d_t *p4d;
> > +     pud_t *pud;
> > +     pmd_t *pmd;
> > +     pte_t *pte;
> > +
> > +     pgd = pgd_offset(mm, address);
> > +     if (!pgd_present(*pgd))
> > +             return 0;
> > +     p4d = p4d_offset(pgd, address);
> > +     if (!p4d_present(*p4d))
> > +             return 0;
> > +     pud = pud_offset(p4d, address);
> > +     if (!pud_present(*pud))
> > +             return 0;
> > +     if (pud_devmap(*pud))
> > +             return PUD_SHIFT;
> > +     pmd = pmd_offset(pud, address);
> > +     if (!pmd_present(*pmd))
> > +             return 0;
> > +     if (pmd_devmap(*pmd))
> > +             return PMD_SHIFT;
> > +     pte = pte_offset_map(pmd, address);
> > +     if (!pte_present(*pte))
> > +             return 0;
> > +     if (pte_devmap(*pte))
> > +             return PAGE_SHIFT;
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(dev_pagemap_mapping_shift);
>
> This is basically a rehash of lookup_address_in_pgd(), and doesn't provide
> exactly what KVM needs.  E.g. KVM works with levels instead of shifts, and
> it would be nice to provide the pte so that KVM can sanity check that the
> pfn from this walk matches the pfn it plans on mapping.
>
> Instead of exporting dev_pagemap_mapping_shift(), what about relacing it
> with a patch to introduce lookup_address_mm() and export that?
>
> dev_pagemap_mapping_shift() could then wrap the new helper (if you want),
> and KVM could do lookup_address_mm() for querying the size of ZONE_DEVICE
> pages.

All of the above sounds great to me. Should have looked that much
harder when implementing dev_pagemap_mapping_shift() originally.
