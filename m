Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA1336B052
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhDZJOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:14:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232078AbhDZJOZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 05:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619428423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VFKLwwMzsvzItgmQ50JfwpzOy30SfCTtD6WkHv5wP/Y=;
        b=UGYe9r5fZZO5Ggy2PC8+A7BMSDoPEFMcSOpGVjRobiP9GVBRiBGUSHEBaRm55uNXs9yuIN
        iSiSNuPSRGbrbfbUpW6Bg2YBHtIvdDyc02VxFVeY9Hwp/WK+J3xjaEI108XLEY+3iqGh5p
        yBYhX4YqBOUeugOCwZ4+EtKkCBcV5Ak=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-wPu9R-20OiuZw9zQMdF5FA-1; Mon, 26 Apr 2021 05:13:41 -0400
X-MC-Unique: wPu9R-20OiuZw9zQMdF5FA-1
Received: by mail-ej1-f69.google.com with SMTP id w2-20020a1709062f82b0290378745f26d5so9894996eji.6
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:13:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VFKLwwMzsvzItgmQ50JfwpzOy30SfCTtD6WkHv5wP/Y=;
        b=cIrsJ81rxPUDXruumi3S01F3GmSFngeEvXm70rLuP0R1i9BTaf5NqYwNpMsUbHgrWe
         qj/jbGZgIzS1mz3GeUALg94XlObVD8RiNRC66v8wb4UNZwwLPic2cO5MMurhVH75p81L
         4XHRxRkTIYlEFwY1/rAsE2/pRq7v7/NgjIQn9CjMyNhzuKRCn24g6GxgfG5ILGwiUXaJ
         5PZus7VnvWmDSrS4xAEDNev0X0NFR/j68VGGVUnDGWMnFpEKKOPHATbuhj+WmR3N0srT
         dNWayV1gr9cgY7BUgB44+nzzwuYIG7OwSXeuvVJI4VwEBn3B3sIANNyN5a35gqB7xEDH
         s+kg==
X-Gm-Message-State: AOAM53360Kx8cN3fhvMgHgc0k+shEGVXEHUuqJYyxkEuhC36YFbsBZWU
        +ZYbQ5gYvmXRToqtzweBbyEXNks5atME4TbfozPZqyBJ/ja6VgSQg9d1hS15zWffgnU5cqJdpDw
        g9YQM7hqkZw5w
X-Received: by 2002:a50:9feb:: with SMTP id c98mr20300407edf.104.1619428420293;
        Mon, 26 Apr 2021 02:13:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVdEkajga/5+e46mH+HQWOhDYZhKQoGcl2MVCQxHt/h3c1ADc3J7cJk0MHbhAtXRNgVmRDfg==
X-Received: by 2002:a50:9feb:: with SMTP id c98mr20300388edf.104.1619428420150;
        Mon, 26 Apr 2021 02:13:40 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id hs26sm10901306ejc.23.2021.04.26.02.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 02:13:39 -0700 (PDT)
Date:   Mon, 26 Apr 2021 11:13:38 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2 4/8] arm/arm64: mmu: Stop mapping an
 assumed IO region
Message-ID: <20210426091338.nnobqhijsozvbha7@gator>
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-5-drjones@redhat.com>
 <3b26e00a-683f-f40c-638e-7f777b21047e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b26e00a-683f-f40c-638e-7f777b21047e@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 05:10:51PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/20/21 7:59 PM, Andrew Jones wrote:
> > By providing a proper ioremap function, we can just rely on devices
> > calling it for each region they need (as they already do) instead of
> > mapping a big assumed I/O range. We don't require the MMU to be
> > enabled at the time of the ioremap. In that case, we add the mapping
> > to the identity map anyway. This allows us to call setup_vm after
> > io_init. Why don't we just call setup_vm before io_init, I hear you
> > ask? Well, that's because tests like sieve want to start with the MMU
> > off, later call setup_vm, and all the while have working I/O. Some
> > unit tests are just really demanding...
> >
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  lib/arm/asm/io.h     |  6 ++++++
> >  lib/arm/asm/mmu.h    |  1 +
> >  lib/arm/asm/page.h   |  2 ++
> >  lib/arm/mmu.c        | 37 +++++++++++++++++++++++++++----------
> >  lib/arm64/asm/io.h   |  6 ++++++
> >  lib/arm64/asm/mmu.h  |  1 +
> >  lib/arm64/asm/page.h |  2 ++
> >  7 files changed, 45 insertions(+), 10 deletions(-)
> >
> > diff --git a/lib/arm/asm/io.h b/lib/arm/asm/io.h
> > index ba3b0b2412ad..e4caa6ff5d1e 100644
> > --- a/lib/arm/asm/io.h
> > +++ b/lib/arm/asm/io.h
> > @@ -77,6 +77,12 @@ static inline void __raw_writel(u32 val, volatile void __iomem *addr)
> >  		     : "r" (val));
> >  }
> >  
> > +#define ioremap ioremap
> > +static inline void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
> > +{
> > +	return __ioremap(phys_addr, size);
> > +}
> > +
> >  #define virt_to_phys virt_to_phys
> >  static inline phys_addr_t virt_to_phys(const volatile void *x)
> >  {
> > diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
> > index 122874b8aebe..d88a4f16df42 100644
> > --- a/lib/arm/asm/mmu.h
> > +++ b/lib/arm/asm/mmu.h
> > @@ -12,6 +12,7 @@
> >  #define PTE_SHARED		L_PTE_SHARED
> >  #define PTE_AF			PTE_EXT_AF
> >  #define PTE_WBWA		L_PTE_MT_WRITEALLOC
> > +#define PTE_UNCACHED		L_PTE_MT_UNCACHED
> >  
> >  /* See B3.18.7 TLB maintenance operations */
> >  
> > diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
> > index 1fb5cd26ac66..8eb4a883808e 100644
> > --- a/lib/arm/asm/page.h
> > +++ b/lib/arm/asm/page.h
> > @@ -47,5 +47,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
> >  extern phys_addr_t __virt_to_phys(unsigned long addr);
> >  extern unsigned long __phys_to_virt(phys_addr_t addr);
> >  
> > +extern void *__ioremap(phys_addr_t phys_addr, size_t size);
> > +
> >  #endif /* !__ASSEMBLY__ */
> >  #endif /* _ASMARM_PAGE_H_ */
> > diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> > index 15eef007f256..ee0c79142ba1 100644
> > --- a/lib/arm/mmu.c
> > +++ b/lib/arm/mmu.c
> > @@ -11,6 +11,7 @@
> >  #include <asm/mmu.h>
> >  #include <asm/setup.h>
> >  #include <asm/page.h>
> > +#include <asm/io.h>
> >  
> >  #include "alloc_page.h"
> >  #include "vmalloc.h"
> > @@ -157,9 +158,8 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
> >  void *setup_mmu(phys_addr_t phys_end)
> >  {
> >  	uintptr_t code_end = (uintptr_t)&etext;
> > -	struct mem_region *r;
> >  
> > -	/* 0G-1G = I/O, 1G-3G = identity, 3G-4G = vmalloc */
> > +	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
> >  	if (phys_end > (3ul << 30))
> >  		phys_end = 3ul << 30;
> >  
> > @@ -170,14 +170,8 @@ void *setup_mmu(phys_addr_t phys_end)
> >  			"Unsupported translation granule %ld\n", PAGE_SIZE);
> >  #endif
> >  
> > -	mmu_idmap = alloc_page();
> > -
> > -	for (r = mem_regions; r->end; ++r) {
> > -		if (!(r->flags & MR_F_IO))
> > -			continue;
> > -		mmu_set_range_sect(mmu_idmap, r->start, r->start, r->end,
> > -				   __pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
> > -	}
> > +	if (!mmu_idmap)
> > +		mmu_idmap = alloc_page();
> >  
> >  	/* armv8 requires code shared between EL1 and EL0 to be read-only */
> >  	mmu_set_range_ptes(mmu_idmap, PHYS_OFFSET,
> > @@ -192,6 +186,29 @@ void *setup_mmu(phys_addr_t phys_end)
> >  	return mmu_idmap;
> >  }
> >  
> > +void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
> > +{
> > +	phys_addr_t paddr_aligned = phys_addr & PAGE_MASK;
> > +	phys_addr_t paddr_end = PAGE_ALIGN(phys_addr + size);
> > +	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER);
> 
> From ARM DDI 0487G.a, page B-171:
> 
> "Hardware does not prevent speculative instruction fetches from a memory location
> with any of the Device memory attributes unless the memory location is also marked
> as execute-never for all Exception levels.
> *Note*
> This means that to prevent speculative instruction fetches from memory locations
> with Device memory attributes, any location that is assigned any Device memory
> type must also be marked as execute-never for all Exception levels. Failure to
> mark a memory location with any Device memory attribute as execute-never for all
> Exception levels is a programming error."
> 
> I think that should also be PTE_UXN | PTE_PXN (the kernel defines it the same
> way). Otherwise looks good.

Will fix for v3.

Thanks,
drew

