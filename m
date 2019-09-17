Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE22B56AA
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 22:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbfIQUHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 16:07:39 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34886 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfIQUHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 16:07:38 -0400
Received: by mail-io1-f68.google.com with SMTP id q10so10751100iop.2;
        Tue, 17 Sep 2019 13:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ce6TIk2yBsCUQjQPMJ8ki5Nu2SBqoNexDUHdpPLZySE=;
        b=IXoQ3vxuaz+/4yYyVZDcNRx1kyPbDpgLdKm9H8fFva0zYnZbhoFmyYyC8gngZ58zyF
         6NxP+qTT+//nALDqAjKoS3MOCtXEssE+jNU/o5MfABd/0QfY3+RqJjY3fM9a5qI/F/4T
         I6epQYin6F+jNcw6aZJIhbXjbp5bKLq+/DjI7wrNkEHGGgqFaC3H0YN1XY/adk4zydhW
         Xf95qYQNNXA2wAxAS+n54QcFh281JuuxKEOq/L8CTTqsOx4H9/SagURbie47k2iYcAhF
         B0/AzQQkBqYdmNMEweXoFU7lM61o6RZS8L7cktMGGlkEuw/V+Kp2pD+o1/oJYGlsiLZg
         WK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ce6TIk2yBsCUQjQPMJ8ki5Nu2SBqoNexDUHdpPLZySE=;
        b=O5jQ7tVXRc1wQIlHjwgfZR6m8vxkYK80IKrOocVPDDCXXFtuqoioR90u5xlatXvZS+
         oLtbjIQP9WFQQG/kFXdgnTV7mldnVV6cLXudXQi0/ifrz7TRIUq3BiATXWf1me0KditC
         l34M2nPn9yXWiRc7HEBvjdYUTzgwCww70yyhyEXoM4jL9mOqzsNq+fqyJVdH3F9825Dp
         oNaQ2+k8gVeV4yH7DLP5/z6n5l6zbFmJeAWVMpBz48STd1mdO5CBhS4k/iQbI5pWp/PK
         cOPOZmpeeN+U7bHhQ6WgdVKqeXT8NbutyY4W1wsD1ZCLy1uD7u5rngS8Knfk0oq7ywn0
         n5LQ==
X-Gm-Message-State: APjAAAVg32KQxoTIt/mPqoOSXQABST/Iq0jKLoE3zwFcm8U4xMNgxHAS
        V23PHPtBPjY3GeQuJ2iINcT7xmoXgDzaILHSvF0=
X-Google-Smtp-Source: APXvYqx/bywcsKyBZocnzcRUqWxcRIiNYzZKZ+MK31UwJG5x0ScDRR8hwq1bhsfxSgwub9YjCSWmX4ykNdQvx8Skj7k=
X-Received: by 2002:a5d:8b47:: with SMTP id c7mr733291iot.42.1568750857640;
 Tue, 17 Sep 2019 13:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172545.10910.88045.stgit@localhost.localdomain> <20190917174853.5csycb5pb5zalsxd@willie-the-truck>
In-Reply-To: <20190917174853.5csycb5pb5zalsxd@willie-the-truck>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 17 Sep 2019 13:07:26 -0700
Message-ID: <CAKgT0Ufoq5BsOwW11SYHDBcy8-U91FgFCxK9XFf5twPWXzpO7g@mail.gmail.com>
Subject: Re: [PATCH v9 5/8] arm64: Move hugetlb related definitions out of
 pgtable.h to page-defs.h
To:     Will Deacon <will@kernel.org>
Cc:     virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 10:49 AM Will Deacon <will@kernel.org> wrote:
>
> On Sat, Sep 07, 2019 at 10:25:45AM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > Move the static definition for things such as HUGETLB_PAGE_ORDER out of
> > asm/pgtable.h and place it in page-defs.h. By doing this the includes
> > become much easier to deal with as currently arm64 is the only architecture
> > that didn't include this definition in the asm/page.h file or a file
> > included by it.
> >
> > It also makes logical sense as PAGE_SHIFT was already defined in
> > page-defs.h so now we also have HPAGE_SHIFT defined there as well.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  arch/arm64/include/asm/page-def.h |    9 +++++++++
> >  arch/arm64/include/asm/pgtable.h  |    9 ---------
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/page-def.h b/arch/arm64/include/asm/page-def.h
> > index f99d48ecbeef..1c5b079e2482 100644
> > --- a/arch/arm64/include/asm/page-def.h
> > +++ b/arch/arm64/include/asm/page-def.h
> > @@ -20,4 +20,13 @@
> >  #define CONT_SIZE            (_AC(1, UL) << (CONT_SHIFT + PAGE_SHIFT))
> >  #define CONT_MASK            (~(CONT_SIZE-1))
> >
> > +/*
> > + * Hugetlb definitions.
> > + */
> > +#define HUGE_MAX_HSTATE              4
> > +#define HPAGE_SHIFT          PMD_SHIFT
> > +#define HPAGE_SIZE           (_AC(1, UL) << HPAGE_SHIFT)
> > +#define HPAGE_MASK           (~(HPAGE_SIZE - 1))
> > +#define HUGETLB_PAGE_ORDER   (HPAGE_SHIFT - PAGE_SHIFT)
> > +
> >  #endif /* __ASM_PAGE_DEF_H */
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index 7576df00eb50..06a376de9bd6 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -305,15 +305,6 @@ static inline int pte_same(pte_t pte_a, pte_t pte_b)
> >   */
> >  #define pte_mkhuge(pte)              (__pte(pte_val(pte) & ~PTE_TABLE_BIT))
> >
> > -/*
> > - * Hugetlb definitions.
> > - */
> > -#define HUGE_MAX_HSTATE              4
> > -#define HPAGE_SHIFT          PMD_SHIFT
> > -#define HPAGE_SIZE           (_AC(1, UL) << HPAGE_SHIFT)
> > -#define HPAGE_MASK           (~(HPAGE_SIZE - 1))
> > -#define HUGETLB_PAGE_ORDER   (HPAGE_SHIFT - PAGE_SHIFT)
> > -
>
> Acked-by: Will Deacon <will@kernel.org>
>
> I'm assuming you're taking this along with the other patches, but please
> shout if you'd rather it went via the arm64 tree.
>
> Will

As it turns out I am close to submitting a v10 that doesn't need this
patch. I basically just needed to move the list manipulators out of
mmzone.h and then moved my header file out of there so I no longer
needed the code.

Thanks.

- Alex
