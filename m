Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED869BEAF7
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 05:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbfIZDtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 23:49:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733179AbfIZDtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 23:49:19 -0400
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0798E1108
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 03:49:19 +0000 (UTC)
Received: by mail-pf1-f200.google.com with SMTP id a1so813866pfn.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 20:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ShKNQbErac64XK8TSPHgRCKqoTFkkgB8tmVFA50VI9E=;
        b=cJW5Jt30RKfUY20PJwuGJhR8Pwe17LNUUmYeJzMqeZU7nsRjcWglQkVeNeRe5pge4F
         Dm+FGzPtlW60OL0QAJfwK2fOUOzBXquFIZwFlwfmz9W5ChxeBPuw+FWM3vZCaaAJxlsG
         DCb4kp5bWUSQK6Yos2W0oAeSt3trzNNjrA778oiLuX2VWsmZtLnWnO+NbQ3PN6Fpbfe0
         OaJ+HUr1nSVM8MgzYHEpLLm3DUin9WlVLYZYy/MXxVXIofLe+TcAFL3CP2RxCpiLpapg
         EnUlin9GddEfpqgKndMTVxt6ia2flQdmwanaepq8elOnWS3b59rnWcoAVsjwg085owVV
         IT2w==
X-Gm-Message-State: APjAAAXJdA6UaQhb2dhSqBEOvWVWoHEaLwdMy4S9++BpScniln2Sudyk
        uyb6JcPWLUowQhpTnTwXd4TXbKQM1nuV4A9ZJc5AMx7qA4wE2iLU/Y0Yq1l390rnsx2UL6B5SsJ
        mKIm9DWqoN1Tp
X-Received: by 2002:a63:df02:: with SMTP id u2mr1326647pgg.62.1569469758379;
        Wed, 25 Sep 2019 20:49:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxs4/hDxEwwNdVu+EpMWqbEMaG9qmJxTI8+9ub9yU1tkFZwOu/oob4U27J3j3Xho1yCL2C8Xw==
X-Received: by 2002:a63:df02:: with SMTP id u2mr1326630pgg.62.1569469758054;
        Wed, 25 Sep 2019 20:49:18 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f74sm576418pfa.34.2019.09.25.20.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 20:49:17 -0700 (PDT)
Date:   Thu, 26 Sep 2019 11:49:05 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kevin.tian@intel.com, Yi Sun <yi.y.sun@linux.intel.com>,
        ashok.raj@intel.com, kvm@vger.kernel.org, sanjay.k.kumar@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.sun@intel.com
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
Message-ID: <20190926034905.GW28074@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190925052157.GL28074@xz-x1>
 <c9792e0b-bf42-1dbb-f060-0b1a43125f47@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c9792e0b-bf42-1dbb-f060-0b1a43125f47@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 10:35:24AM +0800, Lu Baolu wrote:

[...]

> > > @@ -0,0 +1,342 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/**
> > > + * intel-pgtable.c - Intel IOMMU page table manipulation library
> > 
> > Could this be a bit misleading?  Normally I'll use "IOMMU page table"
> > to refer to the 2nd level page table only, and I'm always
> > understanding it as "the new IOMMU will understand MMU page table as
> > the 1st level".  At least mention "IOMMU 1st level page table"?
> > 
> 
> This file is a place holder for all code that manipulating iommu page
> tables (both first level and second level). Instead of putting
> everything in intel_iommu.c, let's make the code more structured so that
> it's easier for reading and maintaining. This is the motivation of this
> file.

I see.

> 
> > > + *
> > > + * Copyright (C) 2019 Intel Corporation
> > > + *
> > > + * Author: Lu Baolu <baolu.lu@linux.intel.com>
> > > + */
> > > +
> > > +#define pr_fmt(fmt)     "DMAR: " fmt
> > > +#include <linux/vmalloc.h>
> > > +#include <linux/mm.h>
> > > +#include <linux/sched.h>
> > > +#include <linux/io.h>
> > > +#include <linux/export.h>
> > > +#include <linux/intel-iommu.h>
> > > +#include <asm/cacheflush.h>
> > > +#include <asm/pgtable.h>
> > > +#include <asm/pgalloc.h>
> > > +#include <trace/events/intel_iommu.h>
> > > +
> > > +#ifdef CONFIG_X86
> > > +/*
> > > + * mmmap: Map a range of IO virtual address to physical addresses.
> > 
> > "... to physical addresses using MMU page table"?
> > 
> > Might be clearer?
> 
> Yes.
> 
> > 
> > > + */
> > > +#define pgtable_populate(domain, nm)					\
> > > +do {									\
> > > +	void *__new = alloc_pgtable_page(domain->nid);			\
> > > +	if (!__new)							\
> > > +		return -ENOMEM;						\
> > > +	smp_wmb();							\
> > 
> > Could I ask what's this wmb used for?
> 
> Sure. This is answered by a comment in __pte_alloc() in mm/memory.c. Let
> me post it here.
> 
>         /*
>          * Ensure all pte setup (eg. pte page lock and page clearing) are
>          * visible before the pte is made visible to other CPUs by being
>          * put into page tables.
>          *
>          * The other side of the story is the pointer chasing in the page
>          * table walking code (when walking the page table without locking;
>          * ie. most of the time). Fortunately, these data accesses consist
>          * of a chain of data-dependent loads, meaning most CPUs (alpha
>          * being the notable exception) will already guarantee loads are
>          * seen in-order. See the alpha page table accessors for the
>          * smp_read_barrier_depends() barriers in page table walking code.
>          */
>         smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */

Ok.  I don't understand the rationale much behind but the comment
seems to make sense...  Could you help to comment above, like "please
reference to comment in __pte_alloc" above the line?

> 
> > 
> > > +	spin_lock(&(domain)->page_table_lock);				\
> > 
> > Is this intended to lock here instead of taking the lock during the
> > whole page table walk?  Is it safe?
> > 
> > Taking the example where nm==PTE: when we reach here how do we
> > guarantee that the PMD page that has this PTE is still valid?
> 
> We will always keep the non-leaf pages in the table,

I see.  Though, could I ask why?  It seems to me that the existing 2nd
level page table does not keep these when unmap, and it's not even use
locking at all by leveraging cmpxchg()?

> hence we only need
> a spin lock to serialize multiple tries of populating a entry for pde.
> As for pte, we can assume there is only single thread which can access
> it at a time because different mappings will have different iova's.

Ah yes sorry nm will never be pte here... so do you mean the upper
layer, e.g., the iova allocator will make sure the ranges to be mapped
will never collapse with each other so setting PTEs do not need lock?

> 
> > 
> > > +	if (nm ## _present(*nm)) {					\
> > > +		free_pgtable_page(__new);				\
> > > +	} else {							\
> > > +		set_##nm(nm, __##nm(__pa(__new) | _PAGE_TABLE));	\
> > 
> > It seems to me that PV could trap calls to set_pte().  Then these
> > could also be trapped by e.g. Xen?  Are these traps needed?  Is there
> > side effect?  I'm totally not familiar with this, but just ask aloud...
> 
> Good catch. But I don't think a vIOMMU could get a chance to run in a PV
> environment. I might miss something?

I don't know... Is there reason to not allow a Xen guest to use 1st
level mapping?

While on the other side... If the PV interface will never be used,
then could native_set_##nm() be used directly?

[...]

> > > +static struct page *
> > > +mmunmap_pte_range(struct dmar_domain *domain, pmd_t *pmd,
> > > +		  unsigned long addr, unsigned long end,
> > > +		  struct page *freelist, bool reclaim)
> > > +{
> > > +	int i;
> > > +	unsigned long start;
> > > +	pte_t *pte, *first_pte;
> > > +
> > > +	start = addr;
> > > +	pte = pte_offset_kernel(pmd, addr);
> > > +	first_pte = pte;
> > > +	do {
> > > +		set_pte(pte, __pte(0));
> > > +	} while (pte++, addr += PAGE_SIZE, addr != end);
> > > +
> > > +	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
> > > +
> > > +	/* Add page to free list if all entries are empty. */
> > > +	if (reclaim) {
> > 
> > Shouldn't we know whether to reclaim if with (addr, end) specified as
> > long as they cover the whole range of this PMD?
> 
> Current policy is that we don't reclaim any pages until the whole page
> table will be torn down.

Ah OK.  But I saw that you're passing in relaim==!start_addr.
Shouldn't that errornously trigger if one wants to unmap the 1st page
as well even if not the whole address space?

> The gain is that we don't have to use a
> spinlock when map/unmap a pmd entry anymore.

So this question should also related to above on the locking - have
you thought about using the same way (IIUC) as the 2nd level page
table to use cmpxchg()?  AFAIU that does not need any lock?

For me it's perfectly fine to use a lock at least for initial version,
I just want to know the considerations behind in case I missed
anything important.

Thanks,

-- 
Peter Xu
